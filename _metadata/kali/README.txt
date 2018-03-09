####################
#
### REPOSITORY DOCUMENTATION
### kali
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Kali packages located on the internet at:
http://http.kali.org

The default repositories are listed in /etc/apt/sources.list.
They include the following:

------
deb http://http.kali.org/kali kali-rolling main contrib non-free
------

Note: the 'multiverse' and 'universe' 'source' repos are currently NOT being mirrored, so these should be disabled.


#####
# Retention Policy
####

We are currently excluding the 'multiverse' and 'universe' repositories in order to save space.

We are only mirror "kali-rolling". As newer releases are issued, we will continue this trend.

We believe that this retention policy is sufficient for Kali packages.
If you would like packages for other versions that are still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
