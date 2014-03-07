#!/usr/bin/env bash
source ./helper.sh
./copy-ssh-public-key.sh
./test-with-nodejs.sh
#./test-with-python.sh
