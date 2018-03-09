####################
#
### REPOSITORY DOCUMENTATION
### debian
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Debian packages located on the internet at:
http://deb.debian.org
http://security.debian.org

The default repositories are listed in /etc/apt/sources.list.
They include the following:

------
deb http://deb.debian.org/debian stretch main
deb http://deb.debian.org/debian stretch-updates main
deb http://security.debian.org stretch/updates main

deb http://deb.debian.org/debian jessie main
deb http://deb.debian.org/debian jessie-updates main
deb http://security.debian.org jessie/updates main
------

Note: the 'multiverse' and 'universe' repos are currently NOT being mirrored, so these should be disabled.


#####
# Retention Policy
####

We are currently excluding the 'multiverse' and 'universe' repositories in order to save space.
i386 packages are not needed due to limited utility and the rarity of likely use cases.
We are only mirroring amd64 and noarch packages.

We are mirroring all amd64 and no arch packages for the stable release (stretch) and oldstable (jessie). 
As newer releases are issued, we will continue this trend.

We believe that this retention policy is sufficient for Debian packages.
If you would like packages for other versions that are still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
