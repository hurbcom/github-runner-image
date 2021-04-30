#!/bin/bash

/actions-runner/config.sh --unattended --labels ${LABELS} --name github-runner-${HOSTNAME} --url "${URL}" --token "${TOKEN}"

exec $@