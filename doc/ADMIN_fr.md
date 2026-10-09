#### Intégration LDAP/SSO

L'authentification SSO est prise en charge, mais peut être remplacée par une authentification propre à YesWiki.

Si vous mettez à jour depuis une version de YesWiki < 4.4.4 et que vous voulez utiliser l'authentification SSO de YunoHost, vous devez ajouter `'enable_yunohost_sso' => true,` dans le fichier `wakka.config.php`.

#### Emplacement des fichiers

Le dossier `files` du wiki est dans `__DATA_DIR__`, et `__INSTALL_DIR__/files` est un lien symbolique vers lui. `private` reste dans `__INSTALL_DIR__`, parce que l'extension ferme y déplace des dossiers. YunoHost ne met pas le dossier de données dans la sauvegarde de sécurité qu'il fait avant une mise à jour, mais le garde dans les sauvegardes classiques. Les utilisateurs SFTP sont enfermés dans `__INSTALL_DIR__` et ne peuvent pas suivre ce lien.

Les wikis d'une ferme gardent leurs propres dossiers `files` et `private`. Avant une mise à jour, YunoHost les déplace dans `/var/www/.__APP__-ferme-parking`, puis les remet en place à la fin de la mise à jour, ou en restaurant la sauvegarde de sécurité si elle a échoué. Si ce dossier existe encore après une mise à jour, son contenu appartient aux wikis de la ferme du même nom.
