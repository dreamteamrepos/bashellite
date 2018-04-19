#!/bin/bash

out_path=/mirror1/docker-images

# OpenShift Container Platform containerized components
ose_tag="v3.9.14"
docker pull registry.access.redhat.com/openshift3/ose-ansible:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-ansible-service-broker:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-cluster-capacity:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-deployer:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-docker-builder:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-docker-registry:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-egress-http-proxy:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-egress-router:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-f5-router:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-haproxy-router:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-pod:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-sti-builder:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-template-service-broker:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose-web-console:$ose_tag
docker pull registry.access.redhat.com/openshift3/ose:$ose_tag
docker pull registry.access.redhat.com/openshift3/container-engine:$ose_tag
docker pull registry.access.redhat.com/openshift3/efs-provisioner
docker pull registry.access.redhat.com/openshift3/node:$ose_tag
docker pull registry.access.redhat.com/openshift3/openvswitch:$ose_tag
docker pull registry.access.redhat.com/rhel7/etcd
docker pull registry.access.redhat.com/openshift3/ose-service-catalog:$ose_tag
docker pull registry.access.redhat.com/openshift3/mediawiki-apb:$ose_tag
docker pull registry.access.redhat.com/openshift3/postgresql-apb:$ose_tag
docker pull registry.access.redhat.com/openshift3/registry-console:$ose_tag

echo -e "\n\nAttempting to save component images now to ose3-component-images.tar.\n"
docker save -o ${out_path}/ose3-component-images.tar \
    registry.access.redhat.com/openshift3/ose-ansible \
    registry.access.redhat.com/openshift3/ose-ansible-service-broker \
    registry.access.redhat.com/openshift3/ose-cluster-capacity \
    registry.access.redhat.com/openshift3/ose-deployer \
    registry.access.redhat.com/openshift3/ose-docker-builder \
    registry.access.redhat.com/openshift3/ose-docker-registry \
    registry.access.redhat.com/openshift3/ose-egress-http-proxy \
    registry.access.redhat.com/openshift3/ose-egress-router \
    registry.access.redhat.com/openshift3/ose-f5-router \
    registry.access.redhat.com/openshift3/ose-haproxy-router \
    registry.access.redhat.com/openshift3/ose-keepalived-ipfailover \
    registry.access.redhat.com/openshift3/ose-pod \
    registry.access.redhat.com/openshift3/ose-sti-builder \
    registry.access.redhat.com/openshift3/ose-template-service-broker \
    registry.access.redhat.com/openshift3/ose-web-console \
    registry.access.redhat.com/openshift3/ose \
    registry.access.redhat.com/openshift3/container-engine \
    registry.access.redhat.com/openshift3/efs-provisioner \
    registry.access.redhat.com/openshift3/node \
    registry.access.redhat.com/openshift3/openvswitch \
    registry.access.redhat.com/rhel7/etcd \
    registry.access.redhat.com/openshift3/ose-service-catalog \
    registry.access.redhat.com/openshift3/mediawiki-apb \
    registry.access.redhat.com/openshift3/postgresql-apb \
    registry.access.redhat.com/openshift3/registry-console

if [[ $? == 0 ]];
then
    md5=$(md5sum ${out_path}/ose3-component-images.tar)
    echo -e "Saving was a success.\n"
    echo -e "The resulting md5sum is:"
    echo -e "$md5\n"
else
    echo -e "Saving failed. Review the output for errors.\n"
fi
