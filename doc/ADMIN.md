#### LDAP/SSO integration

SSO authentication is supported by default. It is possible to choose the standalone YesWiki authentication during install.

If you upgraded from YesWiki version < 4.4.4 and want to use the SSO authentication, you must add `"enable_yunohost_sso" => true,` in the `wakka.config.php` file.