#!/bin/bash

(trap '' HUP; /actions-runner/finish.sh 0>/dev/null >logfile 2>&1 &)

exit 0