####################
#
### REPOSITORY DOCUMENTATION
### postgresql-yum
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the PostgreSQL yum packages located on the internet at:
http://download.postgresql.org/pub/repos/yum/

The default repositories listed in /etc/yum.repos.d/ do not include PostgreSQL's repos.  The script 
'InstallPGDGRepoRPM.sh' at the repo locations can be used for adding the repo.

#####
# Retention Policy
####

We are mirroring the following versions for the x86_64 architecture: 9.3, 9.4, 9.5, 9.6, and 10.

We believe that this retention policy is sufficient for our internal infrastructure needs.
If you would like packages for another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
