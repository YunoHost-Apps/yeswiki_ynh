# YesWiki for YunoHost

[![Integration level](https://dash.yunohost.org/integration/yeswiki.svg)](https://dash.yunohost.org/appci/app/yeswiki) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/yeswiki.maintain.svg)  
[![Install YesWiki with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=yeswiki)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install YesWiki quickly and simply on a YunoHost server.
> If you don't have YunoHost, please see [here](https://yunohost.org/install) to know how to install and enjoy it.*

## Overview

YesWiki is a wiki designed to remain simple, very easy to install, in French translated into English, Spanish, Catalan, Flemish...

However, with a YesWiki we can build a website with multiple uses:
- Gather all the information of a project or a group (function of "central station")
- Mapping members or places in a participatory way
- Share resources, lists, calendars thanks to powerful cooperative databases
- Communicate information flows
- Cultivate a bit of freedom...

**Shipped version:** Doryphore 2021-05-24-7

## Screenshots

![](/images/yeswiki_screenshots.png)

## Demo

* [Official demo](https://ferme.yeswiki.net/?CreerSonWiki)

## Configuration

Configure the application via YesWiki.

## Documentation

* Official documentation: https://yeswiki.net/?DocumentatioN
* YunoHost documentation: If specific documentation is needed, feel free to contribute.

## YunoHost specific features

#### Multi-users support

LDAP integration is supported and required on new installs. It is possible to disable it on older installs by removing the loginldap plugin. **Warning: only do it if you know credentials for a wiki admin account**

At the moment SSO authentication is not supported. It is necessary to login on the wiki.

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/yeswiki.svg)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/yeswiki.svg)](https://ci-apps-arm.yunohost.org/ci/apps/yeswiki/)

## Limitations

* Any known limitations.

## Additional information

* Other information you would add about this application

## Links

* Report a bug: https://github.com/YunoHost-Apps/yeswiki_ynh/issues
* App website: https://yeswiki.net/?AccueiL
* Upstream app repository: https://github.com/YesWiki/yeswiki
* YunoHost website: https://yunohost.org/

---

## Developers info

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

To try the testing branch, please proceed like that.

```
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
or
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```
