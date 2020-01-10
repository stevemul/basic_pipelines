#!/bin/bash

NAME='test-jenkins-pipeline'
SOURCE_REPOSITORY_URL='https://github.com/stevemul/basic_pipelines.git'
SOURCE_REPOSITORY_REF='testing'
CONTEXT_DIR='jenkins-pipelines'

oc project test-pipeline
oc new-app -f test-pipeline.yaml 
oc start-build test-pipeline
