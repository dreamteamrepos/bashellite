####################
#
### REPOSITORY DOCUMENTATION
### ubuntu-packages
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Ubuntu packages located on the internet at:
rsync://archive.ubuntu.org/ubuntu/
http://archive.ubuntu.org/ubuntu/

The default repositories are listed in /etc/apt/sources.list.
They include the following:

------
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial universe
deb-src http://archive.ubuntu.com/ubuntu/ xenial universe
deb http://archive.ubuntu.com/ubuntu/ xenial-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu/ xenial multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu xenial partner
# deb-src http://archive.canonical.com/ubuntu xenial partner

deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security main restricted
deb http://security.ubuntu.com/ubuntu/ xenial-security universe
deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe
deb http://security.ubuntu.com/ubuntu/ xenial-security multiverse
# deb-src http://security.ubuntu.com/ubuntu/ xenial-security multiverse
------

Note: the 'multiverse' and 'universe' repos are currently NOT being mirrored, so these should be disabled.


#####
# Retention Policy
####

We are currently excluding the 'multiverse' and 'universe' repositories in order to save space.
i386 packages are not needed due to limited utility and the rarity of likely use cases.
ISOs are handled via another repository on this mirror.

We are mirroring all x86_64 packages for the latest release (17.10) and the two latest LTS releases (16.04 & 18.04). 
As newer minor releases are issued, we will continue this trend. For the most stability,
avoid creating persistent VMs with the latest release. Stick to the LTS releases.

We believe that this retention policy is sufficient for Ubuntu packages.
If you would like packages for other versions that are still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
