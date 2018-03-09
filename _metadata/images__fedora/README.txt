####################
#
### REPOSITORY DOCUMENTATION
### fedora-images
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the latest Fedora cloud-ready and Atomic images located on the internet at:
rsync://mirrors.mit.edu/fedora/

#####
# Retention Policy
####

We are excluding any and all files and directories with the exception of select qcow2 and vagrant files.
In particular, we are mirroring the latest qcow2 and most of the latest vagrant files for the last two releases..
We are mirroring the files for the following types::
  - Vagrant/VirtualBox (.vagrant-virtualbox.box)
  - KVM/QEMU (.qcow2)

We believe that this retention policy is sufficient for Fedora image files.
If you would like packages for an older/another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
