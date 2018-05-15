#!/bin/bash

MIRROR_TLD=/mirror1
CACHE_DIR=${MIRROR_TLD}/cache
REPO_DIR=${MIRROR_TLD}/repos
DEST_DIR=${REPO_DIR}/redhat

declare -a repos=(
# Base RHEL
  "rhel-7-server-rpms"
  "rhel-7-server-rh-common-rpms"
  "rhel-7-server-extras-rpms"
  "rhel-7-server-optional-rpms"
  "rhel-7-server-supplementary-rpms"
  "rhel-7-server-fastrack-rpms"
  "rhel-7-server-optional-fastrack-rpms"
  "rhel-server-rhscl-7-rpms"
# OpenStack Packages
  "rhel-ha-for-rhel-7-server-rpms"
  "rhel-7-server-openstack-10-rpms"
  "rhel-7-server-openstack-10-tools-rpms"
  "rhel-7-server-openstack-10-optools-rpms"
  "rhel-7-server-openstack-10-devtools-rpms"
# Ceph Packages
  "rhel-7-server-rhceph-2-tools-rpms"
  "rhel-7-server-rhceph-2-osd-rpms"
  "rhel-7-server-rhceph-2-mon-rpms"
  "rhel-7-server-rhscon-2-installer-rpms"
# OpenShift Packages
  "rhel-7-server-ose-3.9-rpms"
  "rhel-7-fast-datapath-rpms"
  "rhel-7-server-ansible-2.4-rpms"
)

for repo in "${repos[@]}"; do
  reposync -lnm -r $repo -e ${CACHE_DIR} -p ${REPO_DIR}
  createrepo -v --workers 4 -c ${CACHE_DIR} --update -g comps.xml ${REPO_DIR}/${repo}/
done
