#### Intégration LDAP/SSO

L'authentification SSO est prise en charge, mais peut être remplacée par une authentification propre à YesWiki.

Si vous mettez à jour depuis une version de YesWiki < 4.4.4 et que vous voulez utiliser l'authentification SSO de YunoHost, vous devez ajouter `'enable_yunohost_sso' => true,` dans le fichier `wakka.config.php`.

#### Emplacement des fichiers

Les dossiers `files` et `private` du wiki sont dans `/home/yunohost.app/__APP__`, et `__INSTALL_DIR__` contient des liens symboliques vers eux. YunoHost ne met pas ce dossier dans la sauvegarde de sécurité qu'il fait avant une mise à jour, mais le garde dans les sauvegardes classiques. Les utilisateurs SFTP sont enfermés dans `__INSTALL_DIR__` et ne peuvent pas suivre ces liens.

Les wikis d'une ferme gardent leurs propres dossiers `files` et `private`. Avant une mise à jour, YunoHost les déplace dans `/var/www/.__APP__-ferme-parking`, puis les remet en place à la fin de la mise à jour, ou en restaurant la sauvegarde de sécurité si elle a échoué. Si ce dossier existe encore après une mise à jour, son contenu appartient aux wikis de la ferme du même nom.
