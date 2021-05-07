#!/bin/bash

TOKEN=$(curl  -X POST 2>/dev/null  -H "Authorization: token ${GITHUB_ACCESS_TOKEN}"  -H "Accept: application/vnd.github.v3+json"  https://api.github.com/orgs/${ORG}/actions/runners/registration-token | jq '.token' | sed s/\"//g)
export TOKEN
/actions-runner/config.sh --unattended --labels ${LABELS} --name ${HOSTNAME} --url "https://github.com/${ORG}" --token "${TOKEN}"

exec $@