####################
#
### REPOSITORY DOCUMENTATION
### epel-repo
#
####################
#

#####
# Mirror Information
#####

This repository is a mirror of Extra Packages for Enterprise Linux (EPEL) located on the internet at:
rsync://linux.mirrors.es.net/fedora-epel

The canonical HTTP URL is http://download.fedoraproject.org/pub/epel/ for EPEL.

The default repositories listed in /etc/yum.repos.d/ do not include the EPEL repo.
However, if you "yum install epel-release" on a CentOS base image, you get this:

/etc/yum.repos.d/epel.repo:
---------
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch/debug
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
#baseurl=http://download.fedoraproject.org/pub/epel/7/SRPMS
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1
--------

Notes: by default, this points to a mirror list. You should comment this out and use the baseurl.
You should also disable the Debug and Source RPM repos since these are not mirrored at this time.

#####
# Retention Policy
####

We are currently mirroring EPEL packages for CentOS/RHEL 6 and 7 only.

We believe that this retention policy is sufficient for our internal infrastructure needs, 
and should cover most developer use cases as well.
If you would like packages for another version of RHEL/CentOS from their repos,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
