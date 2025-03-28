<!--
Ohart ongi: README hau automatikoki sortu da <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>ri esker
EZ editatu eskuz.
-->

# YesWiki YunoHost-erako

[![Integrazio maila](https://apps.yunohost.org/badge/integration/yeswiki)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
![Funtzionamendu egoera](https://apps.yunohost.org/badge/state/yeswiki)
![Mantentze egoera](https://apps.yunohost.org/badge/maintained/yeswiki)

[![Instalatu YesWiki YunoHost-ekin](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=yeswiki)

*[Irakurri README hau beste hizkuntzatan.](./ALL_README.md)*

> *Pakete honek YesWiki YunoHost zerbitzari batean azkar eta zailtasunik gabe instalatzea ahalbidetzen dizu.*  
> *YunoHost ez baduzu, kontsultatu [gida](https://yunohost.org/install) nola instalatu ikasteko.*

## Aurreikuspena

YesWiki is a wiki designed to remain simple, very easy to install, in French translated into English, Spanish, Catalan, Flemish...

However, with a YesWiki we can build a website with multiple uses:
- Gather all the information of a project or a group (function of "central station")
- Mapping members or places in a participatory way
- Share resources, lists, calendars thanks to powerful cooperative databases
- Communicate information flows
- Cultivate a bit of freedom...


**Paketatutako bertsioa:** 4.5.2~ynh1

**Demoa:** <https://ferme.yeswiki.net/?CreerSonWiki>

## Pantaila-argazkiak

![YesWiki(r)en pantaila-argazkia](./doc/screenshots/yeswiki_screenshots.png)

## Dokumentazioa eta baliabideak

- Aplikazioaren webgune ofiziala: <https://yeswiki.net/>
- Administratzaileen dokumentazio ofiziala: <https://yeswiki.net/?doc>
- Jatorrizko aplikazioaren kode-gordailua: <https://github.com/YesWiki/yeswiki>
- YunoHost Denda: <https://apps.yunohost.org/app/yeswiki>
- Eman errore baten berri: <https://github.com/YunoHost-Apps/yeswiki_ynh/issues>

## Garatzaileentzako informazioa

Bidali `pull request`a [`testing` abarrera](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

`testing` abarra probatzeko, honakoa egin:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
edo
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```

**Informazio gehiago aplikazioaren paketatzeari buruz:** <https://yunohost.org/packaging_apps>
