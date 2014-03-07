#!/usr/bin/env bash
source ./helper.sh
ecow "Creating a request for a new server instance on DigitalOcean, and wait for completion (typically <1 min)"
tugboat create $dokku_domain_name
tugboat wait $dokku_domain_name
dokku_server_info=$(tugboat info $dokku_domain_name)
ecow $dokku_server_info
ecow "Now that the instance is created and running, we can see the info (including IP address):\n$dokku_server_info"
dokku_server_ip=$(echo $dokku_server_info | grep IP | cut -d':' -f2 | tr -d ' ')
if [ $(curl "https://api.digitalocean.com/domains/$dokku_domain_name?client_id=$do_client_key&api_key=$do_api_key" | python -mjson.tool | grep status | cut -d":" -f2 | tr -d '"' | tr -d " ") != "OK"]; then 
    ecow "Creating domain name $dokku_domain_name"
fi
ecow "Generate the DNS entries for $dokku_domain_name pointing to the new instance"
# curl "https://api.digitalocean.com/domains/new?client_id=$do_client_key&api_key=$do_api_key&name=$dokku_domain_name&ip_address=$dokku_server_ip"
echo $(curl "https://api.digitalocean.com/domains/$dokku_domain_name/records/new?client_id=$DIGITAL_OCEAN_CLIENT_ID&api_key=$DIGITAL_OCEAN_API_KEY&record_type=A&data=$dokku_server_ip")
echo $(curl "https://api.digitalocean.com/domains/$dokku_domain_name/records/new?client_id=$DIGITAL_OCEAN_CLIENT_ID&api_key=$DIGITAL_OCEAN_API_KEY&record_type=A&data=$dokku_server_ip&name=@")
ping_result=$(ping $dokku_domain_name)
ecow "Ping to $dokku_domain_name and confirm name resolution to the new instance:\n$ping_result"
echo
ecow "Finally after the demo, we will cleanup by destroying the instance -- hit any key to proceed"
read
tugboat destroy $dokku_domain_name
