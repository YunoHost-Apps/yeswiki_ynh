# <img src="/images/yeswiki_logo.svg" height="80px" alt="YesWiki's logo"> YesWiki app for YunoHost

[![Integration level](https://dash.yunohost.org/integration/yeswiki.svg)](https://dash.yunohost.org/appci/app/yeswiki)
[![Install YesWiki with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=yeswiki)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install YesWiki quickly and simply on a YunoHost server.
> If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview

Quick description of this app.

**Shipped version:** [Doryphore version 2020-10-2-1 from github repository](https://github.com/YesWiki/yeswiki/archive/2020-10-2-1.zip)

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

At the moment LDAP and SSO authentication are not supported. It is necessary to login on the wiki.

#### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/yeswiki/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/yeswiki%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/yeswiki/)

## Limitations

* Any known limitations.

## Additional information

* Other information you would add about this application

**More information on the documentation page:**
https://yunohost.org/packaging_apps

## Links

* Report a bug: https://github.com/YunoHost-Apps/yeswiki_ynh/issues
* App website: https://yeswiki.net/?AccueiL
* Upstream app repository: https://github.com/YesWiki/yeswiki
* YunoHost website: https://yunohost.org/

## License

* [GNU GPLv3](LICENSE)

---

Developers info
----------------

**Only if you want to use a testing branch for coding, instead of merging directly into master.**
Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing).

To try the testing branch, please proceed like that.

```
sudo yunohost app install https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
or
sudo yunohost app upgrade yeswiki -u https://github.com/YunoHost-Apps/yeswiki_ynh/tree/testing --debug
```