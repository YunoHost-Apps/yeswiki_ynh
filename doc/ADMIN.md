#### LDAP/SSO integration

SSO authentication is supported by default. It is possible to choose the standalone YesWiki authentication during install.

If you upgraded from YesWiki version < 4.4.4 and want to use the SSO authentication, you must add `'enable_yunohost_sso' => true,` in the `wakka.config.php` file.

#### Where the files are

The `files` folder of the wiki is in `__DATA_DIR__`, and `__INSTALL_DIR__/files` is a symlink to it. `private` stays in `__INSTALL_DIR__`, because the ferme extension moves folders into it. YunoHost leaves the data dir out of the safety backup it makes before an upgrade, and keeps it in regular backups. SFTP users are locked in `__INSTALL_DIR__`, so they cannot follow this link.

The wikis of a farm keep their own `files` and `private` folders. Before an upgrade, YunoHost moves them to `/var/www/.__APP__-ferme-parking`, then puts them back at the end of the upgrade, or when it restores the safety backup after a failed one. If that folder is still there after an upgrade, its content belongs to the farm wikis of the same name.
