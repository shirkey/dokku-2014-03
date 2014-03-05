#!/usr/bin/env zsh

ecow "Create new server instance on DigitalOcean via tugboat tool"
tugboat create mainga.me
ecow "Now we wait until that is finished \(typically < 1 min\)"
tugboat wait mainga.me
ecow "Once completed, we grab the IP address of the running instance"
tugboat info mainga.me
local dokku_server_ip=$(tugboat info mainga.me | grep IP | cut -d':' -f2 | tr -d ' ')
ecow "Next, we'll the target DNS zone to ${dokku_server_ip} in their hosted DNS"
curl https://api.digitalocean.com/domains/new?client_id=$DIGITAL_OCEAN_CLIENT_ID&api_key=$DIGITAL_OCEAN_API_KEY&name=mainga.me&ip_address=${dokku_server_ip}
ecow "Finally let\'s cleanup by destroying the instance -- hit any key to proceed"
tugboat destroy mainga.me
