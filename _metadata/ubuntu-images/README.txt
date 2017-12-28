####################
#
### REPOSITORY DOCUMENTATION
### ubuntu-images
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the latest Ubuntu cloud-ready and virtualization-ready images located on the internet at:
http://cloud-images.ubuntu.com

#####
# Retention Policy
####

We are excluding any and all files and directories with the exception of select image files.
In particular, we are mirroring the latest files only for the two latest LTS releases,
as well as the most current non-LTS release.

We are mirroring the files for the following file types:
  - Linux Container (.lxd.tar.gz)
  - KVM/QEMU/libvirt (.img)
  - Vagrant (.box)

We believe that this retention policy is sufficient for Ubuntu image files.
If you would like packages for an older/another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
