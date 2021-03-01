# YesWiki pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/yeswiki.svg)](https://dash.yunohost.org/appci/app/yeswiki) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.maintain.svg)  
[![Installer YesWiki avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=yeswiki)

*[Read this readme in english.](./README.md)*

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

**Version incluse :** Doryphore 2021-02-26-2

## Captures d'écran

![](/images/yeswiki_screenshots.png)

## Démo

* [Démo officielle](https://ferme.yeswiki.net/?CreerSonWiki)

## Configuration

Configurer l'application via YesWiki.

## Documentation

 * Documentation officielle : https://yeswiki.net/?DocumentatioN
 * Documentation YunoHost : Si une documentation spécifique est nécessaire, n'hésitez pas à contribuer.

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateurs

Pour le moment l'authentification LDAP et SSO ne sont pas prisent en charge. Il est nécessaire de se connecter sur le wiki.

#### Architectures supportées

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/yeswiki/)

## Limitations

* Limitations connues.

## Informations additionnelles

* Autres informations à ajouter sur cette application

## Liens

 * Signaler un bug : https://github.com/YunoHost-Apps/yeswiki_ynh/issues
 * Site de l'application : https://yeswiki.net/?AccueiL
 * Dépôt de l'application principale : https://github.com/YesWiki/yeswiki
 * Site web YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
ou
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```
