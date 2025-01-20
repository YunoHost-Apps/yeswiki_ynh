<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# YesWiki pour YunoHost

[![Niveau d’intégration](https://apps.yunohost.org/badge/integration/yeswiki)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
![Statut du fonctionnement](https://apps.yunohost.org/badge/state/yeswiki)
![Statut de maintenance](https://apps.yunohost.org/badge/maintained/yeswiki)

[![Installer YesWiki avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=yeswiki)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer YesWiki rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

YesWiki est un wiki conçu pour rester simple, très facile à installer, en français traduit en anglais, espagnol, catalan, flamand...

Néanmoins, avec un YesWiki on peut fabriquer un site internet aux usages multiples :
- Rassembler toutes les infos d'un projet ou d'un groupe (fonction de "gare centrale")
- Cartographier des membres ou des lieux de façon participative
- Partager des ressources, des listes, des agendas grâce à des bases de données coopératives puissantes
- Faire communiquer des flux d'informations
- Cultiver un bout de liberté...


**Version incluse :** 4.5.0~ynh1

**Démo :** <https://ferme.yeswiki.net/?CreerSonWiki>

## Captures d’écran

![Capture d’écran de YesWiki](./doc/screenshots/yeswiki_screenshots.png)

## Documentations et ressources

- Site officiel de l’app : <https://yeswiki.net/>
- Documentation officielle de l’admin : <https://yeswiki.net/?doc>
- Dépôt de code officiel de l’app : <https://github.com/YesWiki/yeswiki>
- YunoHost Store : <https://apps.yunohost.org/app/yeswiki>
- Signaler un bug : <https://github.com/YunoHost-Apps/yeswiki_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
ou
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
