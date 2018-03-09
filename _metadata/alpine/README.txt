####################
#
### REPOSITORY DOCUMENTATION
### alpine
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the Alpine Linux packages located on the internet at:
http://dl-cdn.alpinelinux.org/alpine/

The default repositories listed in /etc/apk/repositories are currently:
http://dl-cdn.alpinelinux.org/alpine/v3.7/main
http://dl-cdn.alpinelinux.org/alpine/v3.7/community

#####
# Retention Policy
####

We are mirroring all x86_64 packages for v3.7 and v3.6.
As newer minor releases are issued, we will mirror just the latest two.
Since docker containers typically pull from latest, only otherwise specified,
we believe that this retention policy is sufficient for alpine (apk) packages.
If you would like packages for an older version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
