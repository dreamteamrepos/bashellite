#!/usr/bin/env bash

echo -e "\n[INFO] Checking system compatibility with installer...";

# Ensures yum is installed
which yum &>/dev/null || echo "\n[FAIL] yum not installed and/or accessible; exiting."

# Ensures system is CentOS
grep "CentOS" /etc/redhat-release &>/dev/null || echo "[FAIL] Not a CentOS system; exiting."

# Ensures system is EL7
uname -r | grep "el7" &>/dev/null || echo "[FAIL] Not a EL7 system; exiting."

# Defines list of deps to be installed
deps_array=( \
              bash \
              ncurses \
              coreutils \
              sed \
              python-virtualenv \
              wget \
              rsync \
              docker-common \
              grep \
              yum-utils \
              createrepo \
              python35u \
              python2-pip \
              perl \
              less \
              git \
              ruby \
              rubygems \
           );
# Check to see if python2-pip is available via package manager
{ yum info python2-pip &>/dev/null && pkg_available=true; } || pkg_available=false;

# Based on the install method/status, select the appropriate action to ensure pip is installed
if ! ${pkg_available}; then
  echo -e "\n[INFO] Installing EPEL repo..." \
  && yum install -y epel-release \
  && yum clean expire-cache \
  && yum makecache;
fi

# Check to see if python3.5 is available via package manager
{ yum info python35u &>/dev/null && pkg_available=true; } || pkg_available=false;

# Based on the install method/status, select the appropriate action to ensure python3.5 is installed
if ! ${pkg_available}; then
  echo -e "\n[INFO] Installing IUS repo..." \
  && yum install -y "https://centos7.iuscommunity.org/ius-release.rpm" \
  && yum clean expire-cache \
  && yum makecache;
fi

# Installs other misc dependencies
  echo -e "\n[INFO] Ensuring dependencies are installed and latest version..." \
  && yum install -y ${deps_array[@]} \
  && yum upgrade -y ${deps_array[@]};

