#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

composer_version=2.8.1

cache_yunohost_version() {
  (cd "$install_dir" && ynh_exec_as_app \
      dpkg-query --show --showformat='${Version}' yunohost > files/yunohost_version)
}
