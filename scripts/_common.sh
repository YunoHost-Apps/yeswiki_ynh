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
