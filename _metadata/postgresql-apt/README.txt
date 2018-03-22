####################
#
### REPOSITORY DOCUMENTATION
### postgresql-apt
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the PostgreSQL apt packages located on the internet at:
http://download.postgresql.org/pub/repos/apt/

The default repositories listed in /etc/apt/sources.list.d/ do not include PostgreSQL's repos.  The README at the 
repo locations includes instructions for adding the repo.

Here are the contents:

---------
This repository hosts PostgreSQL server and extension module packages, as well
as some client applications.

To use the repository, do the following:

Create /etc/apt/sources.list.d/pgdg.list. The distributions are called
codename-pgdg. In the example, replace "jessie" with the actual distribution
you are using:

  deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main

(You may determine the codename of your distribution by running lsb_release -c.)

Import the repository key from https://www.postgresql.org/media/keys/ACCC4CF8.asc,
update the package lists, and start installing packages:

  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install postgresql-9.5 pgadmin3

More information:
* https://wiki.postgresql.org/wiki/Apt
* https://wiki.postgresql.org/wiki/Apt/FAQ
---------
---------
Note: 
* The repo location (http://apt.postgresql.org/pub/repos/apt or http://download.postgresql.org/pub/repos/apt) 
  has the key as well.
---------

#####
# Retention Policy
####

We are mirroring the following distribution packages for the x86_64 architecture: xenial-pgdg, zesty-pgdg, bionic-pgdg, 
jessie-pgdg, stretch-pgdg, and buster-pgdg.

We believe that this retention policy is sufficient for our internal infrastructure needs.
If you would like packages for another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
