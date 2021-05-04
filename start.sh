#!/bin/bash

/actions-runner/config.sh --unattended --labels ${LABELS} --name ${HOSTNAME} --url "${URL}" --token "${TOKEN}"

exec $@