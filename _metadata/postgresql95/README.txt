####################
#
### REPOSITORY DOCUMENTATION
### postgresql95
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the PostgreSQL v9.5 packages located on the internet at:
rsync://yum.postgresql.org/pgrpms-95/
http://download.postgresql.org

The default repositories listed in /etc/yum.repos.d/ do not include PostgreSQL's repos.
PostgreSQL does provide an rpm that installs the proper repo files. It can be found here:
https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm

Here are the contents:

---------
[pgdg95]
name=PostgreSQL 9.5 $releasever - $basearch
baseurl=https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-$releasever-$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-95

[pgdg95-source]
name=PostgreSQL 9.5 $releasever - $basearch - Source
failovermethod=priority
baseurl=https://download.postgresql.org/pub/repos/yum/srpms/9.5/redhat/rhel-$releasever-$basearch
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-95
---------

#####
# Retention Policy
####

We are mirroring EL7 packages for the x86_64 architecture; however, 

We believe that this retention policy is sufficient for our internal infrastructure needs.
If you would like packages for another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
