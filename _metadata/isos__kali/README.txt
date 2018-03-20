####################
#
### REPOSITORY DOCUMENTATION
### kali-isos
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Kali Linux ISOs located on the internet at:
http://cdimage.kali.org/current/

Important Note: This repository is not and rsync or apt repository. As a result, it
is synced with wget, and is not using any sort of regex to perform the sync.
This means that anytime there is an update to the file list at the URL,
the contents of the repo_filter.conf file have to be updated manually.

#####
# Retention Policy
####

We are mirroring the *.iso files and checksums for Kali's current/rolling release only;
however, we are mirror all versions, all desktops (i.e. Mate, lxde, kde, etc.).

We believe that this retention policy is sufficient for Kali ISOs.
If you would like packages for an older/another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
