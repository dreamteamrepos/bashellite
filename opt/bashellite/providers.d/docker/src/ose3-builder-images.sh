#!/bin/bash

out_path=/mirror1/docker-images

# S2I Images
ose_s2i_tags=latest
docker pull registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat7-openshift:$ose_s2i_tags
docker pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/nodejs-4-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/nodejs-6-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhoar-nodejs/nodejs-8:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/perl-520-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/php-56-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/python-27-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/python-34-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/python-35-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/ruby-22-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/ruby-23-rhel7:$ose_s2i_tags
docker pull registry.access.redhat.com/rhscl/ruby-24-rhel7:$ose_s2i_tags

echo -e "\n\nAttempting to save s2i builder images now to ose3-builder-images.tar.\n"
docker save -o ${out_path}/ose3-builder-images.tar \
    registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat7-openshift \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift \
    registry.access.redhat.com/rhscl/nodejs-4-rhel7 \
    registry.access.redhat.com/rhscl/nodejs-6-rhel7 \
    registry.access.redhat.com/rhoar-nodejs/nodejs-8 \
    registry.access.redhat.com/rhscl/perl-520-rhel7 \
    registry.access.redhat.com/rhscl/php-56-rhel7 \
    registry.access.redhat.com/rhscl/python-27-rhel7 \
    registry.access.redhat.com/rhscl/python-34-rhel7 \
    registry.access.redhat.com/rhscl/python-35-rhel7 \
    registry.access.redhat.com/rhscl/ruby-22-rhel7 \
    registry.access.redhat.com/rhscl/ruby-23-rhel7 \
    registry.access.redhat.com/rhscl/ruby-24-rhel7

if [[ $? == 0 ]];
then
    md5=$(md5sum ${out_path}/ose3-builder-images.tar)
    echo -e "Saving was a success.\n"
    echo -e "The resulting md5sum is:"
    echo -e "$md5\n"
else
    echo -e "Saving failed. Review the output for errors.\n"
fi
