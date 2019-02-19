#!/bin/bash

echo "Please enter the Openshift domain suffix"
read domainsuffix

echo 'Please enter the password for the openstack CI user (openshift@ukcloud.com)'
read password

openshiftadminuser="admin"
openshiftdemouser="demo"

echo "Please enter the 'admin' user's password"
read openshiftadminpass

echo "Please enter the 'demo' user's password"
read openshiftdemopass

NAME='test-openshift-commands-from-slave'
SOURCE_REPOSITORY_URL='https://github.com/stevemul/basic_pipelines.git'
SOURCE_REPOSITORY_REF='master'
CONTEXT_DIR='jenkins-pipelines/openshift'

function setup_openshift_deployment_jenkins_pipeline() {
    oc project build-openshift
    oc new-app -f openshift-yaml/template-openshift-build.yaml \
        -p NAME=$NAME \
        -p SOURCE_REPOSITORY_URL=$SOURCE_REPOSITORY_URL \
        -p SOURCE_REPOSITORY_REF=$SOURCE_REPOSITORY_REF \
        -p CONTEXT_DIR=$CONTEXT_DIR
    oc start-build test-openshift-commands-from-slave
}

function setup_openstack_variables() {
    oc create -f openshift-yaml/openstack_params.yaml

    oc create secret generic openstack \
        --from-literal=username=openshift@ukcloud.com \
        --from-literal=password=$password

    # Admin is adminuser/adminpass. 'demo' is username/userpass
    oc create secret generic openshift \
        --from-literal=adminuser=$openshiftadminuser \
        --from-literal=username=$openshiftdemouser \
        --from-literal=adminpass=$openshiftadminpass \
        --from-literal=userpass=$openshiftdemopass \
        --from-literal=domainsuffix=$domainsuffix 
}

setup_openstack_variables
setup_openshift_deployment_jenkins_pipeline

