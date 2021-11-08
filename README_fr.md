# YesWiki pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/yeswiki.svg)](https://dash.yunohost.org/appci/app/yeswiki) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.maintain.svg)  
[![Installer YesWiki avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=yeswiki)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer YesWiki rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

YesWiki est un wiki conçu pour rester simple, très facile à installer, en français traduit en anglais, espagnol, catalan, flamand...

Néanmoins, avec un YesWiki on peut fabriquer un site internet aux usages multiples :
- Rassembler toutes les infos d'un projet ou d'un groupe (fonction de "gare centrale")
- Cartographier des membres ou des lieux de façon participative
- Partager des ressources, des listes, des agendas grâce à des bases de données coopératives puissantes
- Faire communiquer des flux d'informations
- Cultiver un bout de liberté...


**Version incluse :** 2021.11.04~ynh1

**Démo :** https://ferme.yeswiki.net/?CreerSonWiki

## Captures d'écran

![](./doc/screenshots/yeswiki_screenshots.png)

## Avertissements / informations importantes

#### Support multi-utilisateurs

L'intégration au LDAP est la seule méthode supportée pour les nouvelles installations. Il est possible de la désactiver sur les anciennes installations en retirant l'extension loginldap. **Attention : Ne pas retirer l'extension sans connaitre d'identifiants administrateurs du wiki**

Pour le moment l'authentification SSO n'est pas prise en charge. Il est nécessaire de se connecter sur le wiki.

## Documentations et ressources

* Site officiel de l'app : https://yeswiki.net/
* Documentation officielle de l'admin : https://yeswiki.net/?DocumentatioN
* Dépôt de code officiel de l'app : https://github.com/YesWiki/yeswiki
* Documentation YunoHost pour cette app : https://yunohost.org/app_yeswiki
* Signaler un bug : https://github.com/YunoHost-Apps/yeswiki_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
ou
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps