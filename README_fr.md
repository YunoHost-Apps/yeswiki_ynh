# <img src="/images/yeswiki_logo.svg" height="80px" alt="logo de YesWiki"> YesWiki pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/yeswiki.svg)](https://dash.yunohost.org/appci/app/yeswiki)
[![Installer YesWiki avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=yeswiki)

*[Read this readme in english.](./README.md)*

> *Ce package vous permet d'installer YesWiki rapidement et simplement sur un serveur Yunohost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble
Description rapide de cette application.

**Version incluse:** 1.0

## Captures d'écran

![](/images/yeswiki_screenshots.png)

## Démo

* [Démo officielle](https://ferme.yeswiki.net/?CreerSonWiki)

## Configuration

Comment configurer cette application: via le panneau d'administration, un fichier brut en SSH ou tout autre moyen.

## Documentation

 * Documentation officielle: https://yeswiki.net/?DocumentatioN
 * Documentation YunoHost: Si une documentation spécifique est nécessaire, n'hésitez pas à contribuer.

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateurs

L'authentification LDAP et HTTP est-elle prise en charge?
L'application peut-elle être utilisée par plusieurs utilisateurs?

#### Architectures supportées

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/yeswiki/)
* Jessie x86-64b - [![Build Status](https://ci-stretch.nohost.me/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-stretch.nohost.me/ci/apps/yeswiki/)

## Limitations

* Limitations connues.

## Informations additionnelles

* Autres informations à ajouter sur cette application

**Plus d'informations sur la page de documentation:**
https://yunohost.org/packaging_apps

## Liens

 * Signaler un bug : https://github.com/YunoHost-Apps/yeswiki_ynh/issues
 * Site de l'application : https://yeswiki.net/?AccueiL
 * Dépôt de l'application principale : https://github.com/YesWiki/yeswiki
 * Site web YunoHost : https://yunohost.org/

## License

* GNU GPLv3

---

Informations pour les développeurs
----------------

**Seulement si vous voulez utiliser une branche de test pour le codage, au lieu de fusionner directement dans la banche principale.**
Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
ou
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```
