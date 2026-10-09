#!/bin/bash

cache_yunohost_version() {
  (cd "$install_dir" && ynh_exec_as_app \
      dpkg-query --show --showformat='${Version}' yunohost > files/yunohost_version)
}

ynh_system_user_add_group() {
    local legacy_args=uhs
    local -A args_array=([u]=username= [g]=groups=)
    local username
    local groups

    ynh_handle_getopts_args "$@"
    groups="${groups:-}"

	local group
	for group in $groups; do
		usermod -a -G "$group" "$username"
	done
}

ynh_system_user_del_group() {
    local legacy_args=uhs
    local -A args_array=([u]=username= [g]=groups=)
    local username
    local groups

    ynh_handle_getopts_args "$@"
    groups="${groups:-}"

	local group
	for group in $groups; do
		gpasswd -d "$username" "$group"
	done
}

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

mail_config_run() {
  local script
  script="$(realpath ../conf/mail_config.php)"
  pushd "$install_dir"
    YNH_MAIL_PWD="$mail_pwd" "php$php_version" "$script" "$@"
    chown $app:www-data wakka.config.php
    find . -mindepth 2 -maxdepth 2 -name wakka.config.php -exec chown $app:www-data {} +
  popd
}

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

# Folder next to the install dir, on the same disk, where the farm wikis' content waits during an upgrade
farm_parking_dir() {
  echo "$(dirname "$install_dir")/.${app}-ferme-parking"
}

# Copies what is in $1 and missing from $2 into $2, then deletes $1, which is kept when the copy fails
merge_into() {
  if ! cp --archive --no-clobber "$1/." "$2/"; then
    ynh_print_warn "Could not merge $1 into $2, both are left as they are"
    return 1
  fi
  rm --recursive --force -- "$1"
}

# Moves the files/ and private/ folders of every farm wiki to the parking, out of the backups and of ynh_setup_source
farm_park() {
  local parking config wiki name entry
  parking=$(farm_parking_dir)
  for config in "$install_dir"/*/wakka.config.php; do
    [ -f "$config" ] || continue
    wiki=$(dirname -- "$config")
    name=$(basename -- "$wiki")
    for entry in files private; do
      if [ ! -d "$wiki/$entry" ] || [ -L "$wiki/$entry" ]; then
        continue
      fi
      mkdir --parents "$parking/$name"
      if [ -e "$parking/$name/$entry" ]; then
        merge_into "$wiki/$entry" "$parking/$name/$entry" || true
      else
        mv -- "$wiki/$entry" "$parking/$name/$entry"
      fi
    done
  done
}

# Puts the parked folders back into their farm wikis
farm_unpark() {
  local parking parked name entry target
  parking=$(farm_parking_dir)
  [ -d "$parking" ] || return 0
  for parked in "$parking"/*/; do
    [ -d "$parked" ] || continue
    name=$(basename -- "$parked")
    if [ ! -f "$install_dir/$name/wakka.config.php" ]; then
      ynh_print_warn "The farm wiki $name is gone, its files stay in $parking/$name"
      continue
    fi
    for entry in files private; do
      [ -d "$parked/$entry" ] || continue
      target="$install_dir/$name/$entry"
      if [ -d "$target" ] && [ ! -L "$target" ] && ! merge_into "$target" "$parked/$entry"; then
        continue
      fi
      mv --no-target-directory -- "$parked/$entry" "$target"
    done
    rmdir -- "$parked" 2>/dev/null || true
  done
  rmdir -- "$parking" 2>/dev/null || true
}

# Keeps files/ of the master wiki in the data dir behind a symlink, and private/ in the install dir where the ferme renames into it
data_dir_link() {
  if [ -L "$install_dir/private" ]; then
    rm "$install_dir/private"
    if [ -d "$data_dir/private" ]; then
      mv --no-target-directory "$data_dir/private" "$install_dir/private"
    else
      mkdir "$install_dir/private"
    fi
    chown $app:www-data "$install_dir/private"
  fi
  if [ -d "$install_dir/files" ] && [ ! -L "$install_dir/files" ]; then
    if [ -z "$(ls -A "$data_dir/files" 2>/dev/null)" ]; then
      rmdir "$data_dir/files" 2>/dev/null || true
      mv --no-target-directory "$install_dir/files" "$data_dir/files"
    else
      merge_into "$install_dir/files" "$data_dir/files" || ynh_die --message="$install_dir/files could not be moved to $data_dir/files"
    fi
    chown -R $app:www-data "$data_dir/files"
  fi
  mkdir --parents "$data_dir/files"
  chown $app:www-data "$data_dir/files"
  ln --symbolic --force --no-dereference "$data_dir/files" "$install_dir/files"
}

# Renames the app's cron jobs with a dot, which cron skips, so they leave the wikis alone during an upgrade
cron_pause() {
  local job
  for job in "/etc/cron.d/$app" "/etc/cron.d/$app"-*; do
    [ -f "$job" ] || continue
    [[ "$(basename "$job")" == *.* ]] && continue
    mv "$job" "$job.ynh-paused"
  done
  local waited=0
  while pgrep -u "$app" -f "includes/commands/console" >/dev/null && [ $waited -lt 300 ]; do
    sleep 5
    waited=$((waited + 5))
  done
  if pgrep -u "$app" -f "includes/commands/console" >/dev/null; then
    ynh_print_warn "A cron job of $app is still running after 5 minutes, carrying on anyway"
  fi
}

# Gives the app's cron jobs their names back
cron_resume() {
  local job
  for job in "/etc/cron.d/$app.ynh-paused" "/etc/cron.d/$app"-*.ynh-paused; do
    [ -f "$job" ] || continue
    mv "$job" "${job%.ynh-paused}"
  done
}

# Without the YunoHost SSO plugin nothing reads the SSO header, and a herse needs the visitor's own Basic auth to reach PHP.
sso_headers_config() {
  local sso_enabled
  sso_enabled=$("php$php_version" -r '$wakkaConfig = []; include $argv[1]; echo empty($wakkaConfig["enable_yunohost_sso"]) ? 0 : 1;' "$install_dir/wakka.config.php")
  if [ "$sso_enabled" = "1" ]; then
    ynh_app_setting_delete --key=protect_against_basic_auth_spoofing
    ynh_permission_url --permission=main --auth_header=true
  else
    ynh_app_setting_set --key=protect_against_basic_auth_spoofing --value=false
    ynh_permission_url --permission=main --auth_header=false
  fi
}

# The SSO cookie only covers the domain it was set on and its subdomains, so the portal must be the wiki's own domain or one of its parents.
sso_domain_config() {
  local wiki_domain="$1"
  local config="$install_dir/wakka.config.php"
  local current
  if ! grep -q "'yunohost_sso_domain'" "$config"; then
    ynh_replace --match="'wakka_version'" --replace="'yunohost_sso_domain' => '$wiki_domain',\n  'wakka_version'" --file="$config"
    return 0
  fi
  current=$(grep -oP "'yunohost_sso_domain' => '\K[^']*" "$config" || true)
  if [ "$wiki_domain" != "$current" ] && [[ "$wiki_domain" != *".$current" || -z "$current" ]]; then
    ynh_replace --match="'yunohost_sso_domain' => '[^']*'" --replace="'yunohost_sso_domain' => '$wiki_domain'" --file="$config"
  fi
}
