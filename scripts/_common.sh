#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

YNH_PHP_VERSION="7.3"

# dependencies used by the app
extra_php_dependencies="php${YNH_PHP_VERSION}-zip"

loginldap_version="2021-03-01-2"

#=================================================
# PERSONAL HELPERS
#=================================================

# update directory right
# | arg: app - The application's name ; default : yeswiki
# | arg: final_path - The path of the application's folder
#	yeswiki_update_dir_rights yeswiki /var/www/yeswiki
yeswiki_update_dir_rights() {
	local app="${1:-yeswiki}"
	local final_path="${2}"
  
  chown -R $app:$app $final_path
  chmod -R u=rwX,g=rX,o=rW $final_path
  chmod -R g+rwX,o+rwX $final_path/{cache,files}
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
