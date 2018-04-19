#!/bin/bash

out_path=/mirror1/docker-images
tag=v3.9.14

##### Logging and Metrics
# OpenShift Container Platform Logging containerized components

ose_logging_tag=$tag
docker pull registry.access.redhat.com/openshift3/logging-auth-proxy:$ose_logging_tag
docker pull registry.access.redhat.com/openshift3/logging-curator:$ose_logging_tag
docker pull registry.access.redhat.com/openshift3/logging-deployer:latest
docker pull registry.access.redhat.com/openshift3/logging-elasticsearch:$ose_logging_tag
docker pull registry.access.redhat.com/openshift3/logging-fluentd:$ose_logging_tag
docker pull registry.access.redhat.com/openshift3/logging-kibana:$ose_logging_tag

# OpenShift Container Platform Metrics containerized components
ose_metrics_tag=$tag
docker pull registry.access.redhat.com/openshift3/metrics-cassandra:$ose_metrics_tag
docker pull registry.access.redhat.com/openshift3/metrics-deployer
docker pull registry.access.redhat.com/openshift3/metrics-hawkular-metrics:$ose_metrics_tag
docker pull registry.access.redhat.com/openshift3/metrics-hawkular-openshift-agent:$ose_metrics_tag
docker pull registry.access.redhat.com/openshift3/metrics-heapster:$ose_metrics_tag

echo -e "\n\nAttempting to save logging and metrics images now to ose3-logging-metrics-images.tar.\n"
docker save -o ${out_path}/ose3-logging-metrics-images.tar \
    registry.access.redhat.com/openshift3/logging-auth-proxy \
    registry.access.redhat.com/openshift3/logging-curator \
    registry.access.redhat.com/openshift3/logging-deployer \
    registry.access.redhat.com/openshift3/logging-elasticsearch \
    registry.access.redhat.com/openshift3/logging-fluentd \
    registry.access.redhat.com/openshift3/logging-kibana \
    registry.access.redhat.com/openshift3/metrics-cassandra \
    registry.access.redhat.com/openshift3/metrics-deployer \
    registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
    registry.access.redhat.com/openshift3/metrics-hawkular-openshift-agent \
    registry.access.redhat.com/openshift3/metrics-heapster

if [[ $? == 0 ]];
then
    md5=$(md5sum ${out_path}/ose3-logging-metrics-images.tar)
    echo -e "Saving was a success.\n"
    echo -e "The resulting md5sum is:"
    echo -e "$md5\n"
else
    echo -e "Saving failed. Review the output for errors.\n"
fi
