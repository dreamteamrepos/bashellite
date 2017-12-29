####################
#
### REPOSITORY DOCUMENTATION
### ceph-repo
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Ceph packages located on the internet at:
rsync://download.ceph.com/ceph
http://download.ceph.com

The default repositories listed in /etc/yum.repos.d/ do not include Ceph's repos.
According to the ceph docs (http://docs.ceph.com/docs/master/install/get-packages),
the yum repo files for Ceph should look like this:

---------
[ceph]
name=Ceph packages for $basearch
baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/$basearch
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/noarch
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=https://download.ceph.com/rpm-{ceph-release}/{distro}/SRPMS
enabled=0
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc
--------


#####
# Retention Policy
####

We are mirroring EL7 packages for the x86_64, Source RPM, and noarch architectures; however, 
we are limiting the sync to packages related to the Ceph Jewel release and the ceph-medic util.
This is the current version (jewel) used by our Openstack installation.

We believe that this retention policy is sufficient for our internal infrastructure needs.
If you would like packages for another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
