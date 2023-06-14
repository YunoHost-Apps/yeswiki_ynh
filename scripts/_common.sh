#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

#REMOVEME? YNH_PHP_VERSION="7.4"

# dependencies used by the app
#REMOVEME? pkg_dependencies="php${YNH_PHP_VERSION}-zip"

loginldap_version="2021-03-01-2"

#=================================================
# PERSONAL HELPERS
#=================================================

# update directory right
# | arg: app - The application's name ; default : yeswiki
# | arg: install_dir - The path of the application's folder
#	yeswiki_update_dir_rights yeswiki /var/www/yeswiki
yeswiki_update_dir_rights() {
	local app="${1:-yeswiki}"
	local install_dir="${2}"
  
  chown -R $app:www-data $install_dir
  chmod -R u=rwx,g=rx,o-rwx $install_dir
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
