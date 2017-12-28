####################
#
### REPOSITORY DOCUMENTATION
### centos-packages
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the CentOS packages located on the internet at:
http://mirror.centos.org/centos/

The actual mirror being synced from is located here:
http://centos.mirror.lstn.net
It emulates the same structure as http://mirror.centos.org/centos/

The default repositories listed in /etc/yum.repos.d/CentOS-* are currently mirror lists.
Upon initial installation of a CentOS ISO, you'll need to enable the "baseurl" value instead.
The baseurls in the default repository files are currently:
CentOS-Base.repo: 
http://mirror.centos.org/centos/$releasever/os/$basearch/
http://mirror.centos.org/centos/$releasever/updates/$basearch/
http://mirror.centos.org/centos/$releasever/extras/$basearch/
http://mirror.centos.org/centos/$releasever/centosplus/$basearch/
http://mirror.centos.org/centos/$releasever/contrib/$basearch/

CentOS-fasttrack.repo:
http://mirror.centos.org/centos/$releasever/fasttrack/$basearch/

The repositories listed in the following default repo files are NOT being mirrored:
CentOS-Debuginfo.repo
CentOS-Vault.repo
CentOS-Media.repo


#####
# Retention Policy
####

We are also excluding any *isos/, *i386,  and *atomic/ subdirectories.
Vault is not needed due to the age of the packages located there (CentOS 6.7 and earlier).
i386 packages are not needed due to limited utility and the rarity of likely use cases.
ISOs are handled via another repository on this mirror.
Project Atomic packages will not be mirrored unless requested on an al la carte basis due to size.

We are mirroring all x86_64 packages for CentOS 6:latest and 7:last-two-latest..
As newer minor releases are issued, we will mirror just the latest two for CentOS 7..

We believe that this retention policy is sufficient for CentOS packages.
If you would like packages for an older version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
