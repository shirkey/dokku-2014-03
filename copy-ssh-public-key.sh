#!/usr/bin/env bash
source ./helper.sh
ecow "Copy local public key to Dokku user on the Dokku server, 
replacing mainga.me with the name of the Dokku target domain used 
earlier when setting up the server"
echo "cat ~/.ssh/id_rsa.pub | ssh root@mainga.me \"sudo sshcommand acl-add dokku developer\""
cat ~/.ssh/id_rsa.pub | ssh root@mainga.me "sudo sshcommand acl-add dokku dokku-client"
ecow "Test for a successful key installation as Dokku by running a Dokku command like 'help' via ssh"
echo "ssh -t dokku@mainga.me help"
ssh -t dokku@mainga.me help
