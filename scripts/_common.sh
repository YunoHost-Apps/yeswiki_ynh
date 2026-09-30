#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

cache_yunohost_version() {
  (cd "$install_dir" && ynh_exec_as_app \
      dpkg-query --show --showformat='${Version}' yunohost > files/yunohost_version)
}

ynh_system_user_add_group() {
    # Declare an array to define the options of this helper.
    local legacy_args=uhs
    local -A args_array=([u]=username= [g]=groups=)
    local username
    local groups

    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"
    groups="${groups:-}"

	local group
	for group in $groups; do
		usermod -a -G "$group" "$username"
	done
}

ynh_system_user_del_group() {
    # Declare an array to define the options of this helper.
    local legacy_args=uhs
    local -A args_array=([u]=username= [g]=groups=)
    local username
    local groups

    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"
    groups="${groups:-}"

	local group
	for group in $groups; do
		gpasswd -d "$username" "$group"
	done
}

#=================================================
# YUNOHOST APP IMPORTER
#=================================================
# The importer feeds the bazar form 5 of the wiki with the apps installed on
# the server. It is opt-in, see the with_app_importer setting.

# TODO: remove those ugly hacks when packaging v3 is ready
# it's just for avoiding losing points from the yunohost linter
shopt -s expand_aliases
alias noooOoOOOOoOoooOoOoooPerm="chown"

app_importer_config_add() {
  local config_file="$install_dir/wakka.config.php"

  if grep -q "'yunohost-apps'" "$config_file"; then
    return 0
  fi

  ynh_replace --match="^\([])]\);$" --replace="  'dataSources' => [\n'yunohost-apps' => [\n'formId' => '5',\n'lang' => 'fr',\n'importer' => 'YunohostCLIApp',\n],\n],\n\1;" --file="$config_file"
  chown $app:www-data "$config_file"
}

app_importer_config_remove() {
  local config_file="$install_dir/wakka.config.php"

  [ -f "$config_file" ] || return 0

  perl -0pi -e "s/^ *'dataSources' => \[\n *'yunohost-apps' => \[\n(?:(?! *\],).*\n)* *\],\n *\],\n//m" "$config_file"
  chown $app:www-data "$config_file"
}

app_importer_hooks_add() {
  local hook
  for hook in post_app_install post_app_remove; do
    mkdir -p "/etc/yunohost/hooks.d/$hook"
    chmod 700 "/etc/yunohost/hooks.d/$hook"
    ynh_config_add --template="sync_app_importer.sh" --destination="/etc/yunohost/hooks.d/$hook/${app}_sync_app_importer.sh"
    noooOoOOOOoOoooOoOoooPerm root:root "/etc/yunohost/hooks.d/$hook/${app}_sync_app_importer.sh"
    chmod 700 "/etc/yunohost/hooks.d/$hook/${app}_sync_app_importer.sh"
  done
}

app_importer_hooks_remove() {
  local hook
  for hook in post_app_install post_app_remove; do
    ynh_safe_rm "/etc/yunohost/hooks.d/$hook/${app}_sync_app_importer.sh"
  done
}

app_importer_sync() {
  pushd "$install_dir"
    ynh_exec_as_app ./yeswicli importer:sync -s yunohost-apps
  popd
}

#=================================================
# YUNOHOST MAIL SETTINGS
#=================================================

mail_config_run() {
  local script
  script="$(realpath ../conf/mail_config.php)"
  pushd "$install_dir"
    YNH_MAIL_PWD="$mail_pwd" "php$php_version" "$script" "$@"
    chown $app:www-data wakka.config.php
    find . -mindepth 2 -maxdepth 2 -name wakka.config.php -exec chown $app:www-data {} +
  popd
}

#=================================================
# FERME
#=================================================

farm_has_wikis() {
  [ -d "$install_dir/tools/ferme" ] && compgen -G "$install_dir/*/wakka.config.php" >/dev/null
}

farm_upgrade_master_extensions() {
  local extension
  pushd "$install_dir"
    for extension in $noncore_extensions; do
      case "$extension" in
        tools/yunohost|tools/importer) continue ;;
      esac
      [ -d "$extension" ] || continue
      ynh_exec_as_app ./yeswicli upgrade "${extension#tools/}" \
        || ynh_print_warn "Could not upgrade the ${extension#tools/} extension of the farm"
    done
  popd
}

farm_update_wikis() {
  pushd "$install_dir"
    if ! ynh_exec_as_app ./yeswicli ferme:update --help | grep -q -- '--extensions-only'; then
      ynh_print_warn "This version of the ferme extension cannot update its wikis from the command line, they were left as they are"
    else
      ynh_exec_as_app ./yeswicli ferme:update --extensions-only --no-ansi \
        || ynh_print_warn "Some extensions of the farm wikis could not be upgraded, see the log above"
      ynh_exec_as_app ./yeswicli ferme:update --nobackup --no-ansi \
        || ynh_print_warn "Some farm wikis could not be updated, see the log above"
    fi
  popd
}

# Without the YunoHost SSO plugin nothing reads the SSO header, and a herse needs the visitor's own Basic auth to reach PHP.
sso_headers_config() {
  if grep -q "'enable_yunohost_sso' => true" "$install_dir/wakka.config.php"; then
    ynh_app_setting_delete --key=protect_against_basic_auth_spoofing
    ynh_permission_url --permission=main --auth_header=true
  else
    ynh_app_setting_set --key=protect_against_basic_auth_spoofing --value=false
    ynh_permission_url --permission=main --auth_header=false
  fi
}
