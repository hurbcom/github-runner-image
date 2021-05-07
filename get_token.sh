#!/bin/bash

sleep 2700
TOKEN=$(curl  -X POST 2>/dev/null  -H "Authorization: token ${GITHUB_ACCESS_TOKEN}"  -H "Accept: application/vnd.github.v3+json"  https://api.github.com/orgs/${ORG}/actions/runners/registration-token | jq '.token' | sed s/\"//g)


export TOKEN
