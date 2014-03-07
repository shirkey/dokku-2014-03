#!/usr/bin/env bash
source ./helper.sh
ecow "Grab a test repo for a nodejs project that works on Heroku"
echo "cd /tmp;git clone https://github.com/heroku/node-js-sample.git;cd node-js-sample"
cd /tmp;git clone https://github.com/heroku/node-js-sample.git;cd node-js-sample
ecow "Install the app and run it from the console to see the result"
echo "npm install"
npm install
echo "node web.js & echo $! > this.pid"
node web.js & echo $! > this.pid
echo "curl locahost:5000"
sleep 3s
curl localhost:5000
ecow "Kill the local process and delete the pid as we get ready to deploy to Dokku"
echo "kill $(cat ./this.pid); rm ./this.pid"
kill $(cat ./this.pid); rm ./this.pid
ecow "Create a new remote git repository named dokku that points to dokku@mainga.me:nodehello"
echo "git remote dokku dokku@mainga.me:nodehello"
git remote add dokku dokku@mainga.me:nodehello
ecow "Push the local master branch to dokku"
echo "git push dokku master"
git push dokku master
ecow "Test the remote deployment at nodehello.mainga.me"
echo "curl nodehello.mainga.me"
curl nodehello.mainga.me
ecow "Update the content of the node app, commit and redeploy"
echo "sed -i \"s/World/Dokku/\" /tmp/node-js-sample/web.js"
sed -i "s/World/Dokku/" /tmp/node-js-sample/web.js
echo "git commit -am 'Change greeting'; git push dokku master"
git commit -am "Change greeting"; git push dokku master
curl nodehello.mainga.me
