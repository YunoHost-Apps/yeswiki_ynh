#!/bin/bash

function build() {

    # TODO : find a way to sync stable extensions list to avoid hardcoded extensions folders to keep
    local noncore_extensions="$(echo tools/{accountactivationbyemail,advancedsearch,benevolat,ferme,fontautoinstall,importer,ipblock,lms,login-sso,logincas,loginldap,maintenance,multideletepages,nextcloudconnector,publication,qrcode,stats,tabdyn,twolevels,webhooks,yunohost})"
    local ferme_instances="$(for p in $install_dir/*/wakka.config.php; do basename "$(dirname "$p")"; done)"

    ynh_setup_source \
        --dest_dir="$install_dir" \
        --full_replace \
        --keep=".env wakka.config.php files custom private themes $noncore_extensions $ferme_instances"

    # use the correct php version in yeswicli
    ynh_replace --match="php " --replace="php${php_version} " --file="$install_dir/yeswicli"

    ynh_print_info "Installing composer dependencies..."
    ynh_composer_exec install --no-dev

    ynh_print_info "Installing importer plugin"

    mkdir -p "$install_dir/tools/importer"
    ynh_setup_source \
        --dest_dir="$install_dir/tools/importer" \
        --source_id="importerplugin"
    chmod -R u=rwX,g=X,o-rwx $install_dir/tools/importer

    ynh_print_info "Installing yunohost plugin"

    mkdir -p "$install_dir/tools/yunohost"
    ynh_setup_source \
        --dest_dir="$install_dir/tools/yunohost" \
        --source_id="yunohostplugin"
    chmod -R u=rwX,g=X,o-rwx $install_dir/tools/yunohost
    chmod +x $install_dir/tools/yunohost/private/scripts/*.sh

    # Needed for the yunohost plugin
    dpkg-query --show --showformat='${Version}' yunohost > $install_dir/files/yunohost_version

    if [[ "$YNH_APP_ACTION" == "install" ]] && [[ "${wikimodel}" == "CLIC" ]]; then
        #=================================================
        # DOWNLOAD AND CONFIGURE FERME PLUGIN
        #=================================================
        ynh_script_progression "Installing ferme plugin"

        # Download ferme plugin from YesWiki repository
        mkdir -p "$install_dir/tools/ferme"
        ynh_setup_source --dest_dir="$install_dir/tools/ferme" --source_id="ferme"
        chmod -R u=rwX,g=X,o-rwx $install_dir/tools/ferme

        # copy CSS presets and files from CLIC
        cp -R $YNH_APP_BASEDIR/source/CLIC/custom/* $install_dir/custom/
        cp -R $YNH_APP_BASEDIR/source/CLIC/files/* $install_dir/files/
    fi
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
    # Update configuration
    ynh_replace --match=");" --replace="  'favorite_preset' => 'custom/clic.css',\n);" --file="$install_dir/wakka.config.php"
    ynh_replace --match=");" --replace="  'favicon' => 'files/faviconclic.png',\n);" --file="$install_dir/wakka.config.php"
  fi

  cd $install_dir
  ./yeswicli migrate
}

function migrate() {
  ./yeswicli migrate
}

function finalize() {

    cd $install_dir

    ynh_replace --match="yeswiki_release' \?=> \?'.*',$" \
                --replace="yeswiki_release' => '$YNH_APP_UPSTREAM_VERSION'," \
                --file="wakka.config.php"

    if [[ "${authprovider}" == "YunoHost SSO" ]] && ! grep "'enable_yunohost_sso'" "wakka.config.php"; then
      # Enable YunoHost SSO in wakka.config.php
      ynh_replace --match=");" --replace="  'enable_yunohost_sso' => true,\n);" --file="wakka.config.php"
    fi

    # Enable app YunoHost importer
    if ! grep 'yunohost-apps' "wakka.config.php"
    then
        ynh_replace --file="wakka.config.php" --match=");" --replace="'dataSources' => [\n'yunohost-apps' => [\n'formId' => '5', // form id used in local bazar\n'lang' => 'fr',\n'importer' => 'YunohostCLIApp', // importer class name (without Importer suffix)\n],\n],\n);"
    fi

    # FIXME : uuuh is this still needed in the context of yunohost 12.x ?
    # Or should it be the top-most parent domain ?
    sso_domain=$(cat /etc/yunohost/current_host | sed -e 's/.*: //')
    if grep "'yunohost_sso_domain'" "wakka.config.php"; then
        ynh_replace --match="^\s*'yunohost_sso_domain'.*," --replace="  'yunohost_sso_domain' => '${sso_domain}'," --file="wakka.config.php"
    else
        ynh_replace --match=");" --replace="  'yunohost_sso_domain' => '${sso_domain}',\n);" --file="wakka.config.php"
    fi

    # Make sure the conf isnt world-readable (and not readable by www-data either)
    _ynh_apply_default_permissions $install_dir/wakka.config.php

    # At last, run the YunoHost app importer
    ynh_print_info "Import YunoHost apps in bazar"
    ./yeswicli importer:sync -s yunohost-apps
}

# # FIXME : core should automatically use this from the app folder

# # ynh_config_add --template="sync_app_importer.sh" --destination="/etc/yunohost/hooks.d/post_app_install/${app}_sync_app_importer.sh"
# # ynh_config_add --template="sync_app_importer.sh" --destination="/etc/yunohost/hooks.d/post_app_remove/${app}_sync_app_importer.sh"
# # ynh_config_add --template="sync_user_importer.sh" --destination="/etc/yunohost/hooks.d/post_user_create/${app}_sync_user_importer.sh"
# # ynh_config_add --template="sync_user_importer.sh" --destination="/etc/yunohost/hooks.d/post_user_delete/${app}_sync_user_importer.sh"

