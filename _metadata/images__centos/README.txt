####################
#
### REPOSITORY DOCUMENTATION
### centos-images
#
####################
#

#####
# Mirror Information
#####
This repository is a mirror of the latest CentOS cloud-ready and virtualization-ready images located on the internet at:
http://cloud.centos.org

#####
# Retention Policy
####

We are also excluding any and all files and directories with the exception of select qcow2 and vagrant files.
In particular, we are mirroring the latest qcow2 and most of the latest vagrant files for CentOS 6 and 7.
For vagrant, the HyperV provider is being excluded, but we are mirroring the files for the following providers:
  - libvirt (.LibVirt.box)
  - VirtualBox (.box)
  - VMWare (.VMwareFustion.box)

We believe that this retention policy is sufficient for CentOS image files.
If you would like packages for an older/another version that is still hosted online,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
