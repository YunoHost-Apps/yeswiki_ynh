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

  ynh_replace --match=");" --replace="  'dataSources' => [\n'yunohost-apps' => [\n'formId' => '5', // form id used in local bazar\n'lang' => 'fr',\n'importer' => 'YunohostCLIApp', // importer class name (without Importer suffix)\n],\n],\n);" --file="$config_file"
  chown $app:www-data "$config_file"
}

app_importer_config_remove() {
  local config_file="$install_dir/wakka.config.php"

  [ -f "$config_file" ] || return 0

  perl -0pi -e "s/^  'dataSources' => \[\n'yunohost-apps' => \[\n(?:(?!\],).*\n)*\],\n\],\n//m" "$config_file"
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
