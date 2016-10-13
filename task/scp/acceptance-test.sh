#!/bin/bash -ex

#if [ $ENV == 'prod' ]; then
 # cf login  -a $CF_API -u $CF_USER -p $CF_PASSWORD -o oscf-sys -s testing
#else
 #:w cf login  -a $CF_API -u $CF_USER -p $CF_PASSWORD -o oscf-sys -s testing --skip-ssl-validation
#fi

cf delete -f windows-test-app

cd windows-acceptance-tests/assets/nora/NoraPublished

cf push windows-test-app -s windows2012R2 -b https://github.com/ryandotsmith/null-buildpack.git -m 1G --no-start
app_guid=$(cf app windows-test-app --guid)

cf curl /v2/apps/$app_guid -X PUT -d '{"diego":true, "enable_ssh":false}'

cf start windows-test-app
app_route=$(cf a | grep windows-test-app | awk '{ print $6 }')
curl -f $app_route

cf delete -f windows-test-app
