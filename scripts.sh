#!/bin/bash

function build() {

    # TODO : find a way to sync stable extensions list to avoid hardcoded extensions folders to keep
    local noncore_extensions="$(echo tools/{accountactivationbyemail,advancedsearch,benevolat,ferme,fontautoinstall,importer,ipblock,lms,login-sso,logincas,loginldap,maintenance,multideletepages,nextcloudconnector,publication,qrcode,stats,tabdyn,twolevels,webhooks,yunohost})"
    local ferme_instances="$(for p in $install_dir/*/wakka.config.php; do basename "$(dirname "$p")"; done)"

    ynh_setup_source \
        --dest_dir="$install_dir" \
        --full_replace \
        --keep=".env wakka.config.php files custom private themes $noncore_extensions $ferme_instances"

    ynh_print_info "Installing composer dependencies..."
    ynh_composer_exec install --no-dev
}

function init() {
 
  if [ "${wikimodel}" = "CLIC" ]; then
    # Replace default YesWiki model with CLIC model
    mv setup/sql/default-content.sql setup/sql/default-content.sql.original
    cp /conf/CLIC/default-content.sql setup/sql/default-content.sql
  fi

  admin_temp_pass=$(ynh_string_random --length=20)
  wiki_name_escaped=$(echo "$wiki_name" | sed 's/ /%20/g')
  ynh_local_curl "/?PagePrincipale&installAction=install" \
    "config[default_language]=$language" \
    "config[wakka_name]=$wiki_name_escaped" \
    "config[root_page]=PagePrincipale" \
    "config[mysql_host]=localhost" \
    "config[mysql_database]=$app" \
    "config[mysql_user]=$db_user" \
    "config[mysql_password]=$db_pwd" \
    "config[table_prefix]=yeswiki_" \
    "admin_name=$admin" \
    "admin_password=$admin_temp_pass" \
    "admin_password_conf=$admin_temp_pass" \
    "admin_email=$admin%40$domain" \
    "config[allow_robots]=$allow_robots" \
    "config[allow_raw_html]=1" \
    "submit=Continue"

  if [ "${wikimodel}" = "CLIC" ]; then
    # restore original YesWiki model
    mv -f setup/sql/default-content.sql.original setup/sql/default-content.sql
  fi

  cd $install_dir
  
  # use the correct php version in yeswicli
  ynh_replace --match="php " --replace="php${php_version} " --file="yeswicli"

  # TODO / FIXME : here, install plugins etc
  
  ./yeswicli migrate
}

function migrate() {

  ./yeswicli migrate

}

function finalize() {
    # Not handled declaratively because it's created by the yeswiki code itself
    ynh_replace --match="yeswiki_release' \?=> \?'.*',$" \
                --replace="yeswiki_release' => '$(ynh_app_upstream_version)'," \
                --file="$install_dir/wakka.config.php"

    _ynh_apply_default_permissions $install_dir/wakka.config.php
}



# #=================================================
# # DOWNLOAD AND CONFIGURE IMPORTER PLUGIN
# #=================================================
# ynh_script_progression "Configure importer plugin"

# # Download importer plugin from YesWiki repository
# mkdir -p "$install_dir/tools/importer"

# ynh_setup_source --dest_dir="$install_dir/tools/importer" --source_id="importerplugin"
# chown -R ${app}:www-data $install_dir/tools/importer
# chmod -R u=rwX,g=rX,o-rwx $install_dir/tools/importer

# #=================================================
# # DOWNLOAD AND CONFIGURE YUNOHOST PLUGIN
# #=================================================
# ynh_script_progression "Configure YunoHost plugin"

# # Download YesWiki plugin from YesWiki repository
# mkdir -p "$install_dir/tools/yunohost"
# ynh_setup_source --dest_dir="$install_dir/tools/yunohost" --source_id="yunohostplugin"
# chown -R ${app}:www-data $install_dir/tools/yunohost
# chmod -R u=rwX,g=rX,o-rwx $install_dir/tools/yunohost

# # In order to use this extension, we need to provide a cached file with the yunohost version
# cache_yunohost_version

# # Add config at the end of wakka.config.php
# ynh_replace --match=");" --replace="  'dataSources' => [\n'yunohost-apps' => [\n'formId' => '5', // form id used in local bazar\n'lang' => 'fr',\n'importer' => 'YunohostCLIApp', // importer class name (without Importer suffix)\n],\n],\n);" --file="$install_dir/wakka.config.php"
# SSO_DOMAIN=$(yunohost domain main-domain | sed -e 's/.*: //')
# ynh_replace --match=");" --replace="  'yunohost_sso_domain' => '${SSO_DOMAIN}',\n);" --file="$install_dir/wakka.config.php"

# # Ensure that scripts are executable
# chmod +x $install_dir/tools/yunohost/private/scripts/*.sh

# # FIXME : core should automatically use this from the app folder

# # ynh_config_add --template="sync_app_importer.sh" --destination="/etc/yunohost/hooks.d/post_app_install/${app}_sync_app_importer.sh"
# # ynh_config_add --template="sync_app_importer.sh" --destination="/etc/yunohost/hooks.d/post_app_remove/${app}_sync_app_importer.sh"
# # ynh_config_add --template="sync_user_importer.sh" --destination="/etc/yunohost/hooks.d/post_user_create/${app}_sync_user_importer.sh"
# # ynh_config_add --template="sync_user_importer.sh" --destination="/etc/yunohost/hooks.d/post_user_delete/${app}_sync_user_importer.sh"



# # At last, run the YunoHost app importer
# ynh_script_progression "Import YunoHost apps in bazar"
# pushd $install_dir
# ynh_exec_as_app ./yeswicli importer:sync -s yunohost-apps
# popd

# if [ "${authprovider}" = "YunoHost SSO" ]; then
#   #=================================================
#   # CONFIGURE YUNOHOST PLUGIN
#   #=================================================
#   ynh_script_progression "Enable YunoHost SSO"

#   # Add config at the end of wakka.config.php
#   ynh_replace --match=");" --replace="  'enable_yunohost_sso' => true,\n);" --file="$install_dir/wakka.config.php"
# fi

# #=================================================
# #  FERME PLUGIN
# #=================================================
# if [ "${wikimodel}" = "CLIC" ]; then

#   ynh_script_progression "Configure ferme plugin"

#   # Download ferme plugin from YesWiki repository
#   mkdir -p "$install_dir/tools/ferme"
#   ynh_setup_source --dest_dir="$install_dir/tools/ferme" --source_id="ferme"
#   chown -R ${app}:www-data $install_dir/tools/ferme
#   chmod -R u=rwX,g=rX,o-rwx $install_dir/tools/ferme

#   # copy CSS presets and files from CLIC
#   cp -R ../source/CLIC/custom/* $install_dir/custom/
#   cp -R ../source/CLIC/files/* $install_dir/files/

#   # Update configuration
#   ynh_replace --match=");" --replace="  'favorite_preset' => 'custom/clic.css',\n);" --file="$install_dir/wakka.config.php"
#   ynh_replace --match=");" --replace="  'favicon' => 'files/faviconclic.png',\n);" --file="$install_dir/wakka.config.php"
# fi
