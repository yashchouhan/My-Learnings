#!/bin/bash -ex

API_ENDPOINT=https://api.sys.test.cfdev.canopy-cloud.com
CF_ADMIN_USER=admin
CF_ADMIN_PASSWORD=DipfopOddEpsUlsEerfOavwoHenIqu
CF_APP_DOMAIN=apps.test.cfdev.canopy-cloud.com
CF_SYS_DOMAIN=sys.test.cfdev.canopy-cloud.com

# Below Api Endpoint are need for CF Login Method
PREPROD_API_ENDPOINT=https://api.sys.preprod.cfdev.canopy-cloud.com
PROD_API_ENDPOINT=https://api.sys.eu01.cf.canopy-cloud.com



r=$RANDOM

#To Print Current Date and Time
now="$(date)"
printf "Current date and time %s\n" "$now"


Cf_Login()
{
 if [ "${API_ENDPOINT}" == "${PROD_API_ENDPOINT}" ]; then
   cf api $API_ENDPOINT
   cf auth $1 $2
 elif [ "${API_ENDPOINT}" == "${PREPROD_API_ENDPOINT}" ]; then
   cf api $API_ENDPOINT
   cf auth $1 $2
 else
   cf api --skip-ssl-validation $API_ENDPOINT
   cf auth $1 $2
 fi
}


Push_And_Test_Smoketest_App() {

  cd oscf-manifest-stubs/ci/smoketests/mysql


  APP_NAME="mysql-smoketest-app-$r"
  SERVICE_NAME="mysql-smoketest-service"
  echo "Using RubyBuildpack "
  cf push $APP_NAME --no-start
  cf marketplace | egrep "*mysql"
  res=$?

  if [ $res -eq 0 ]; then
  echo "Creating Mysql Service Instance"
  cf create-service p-mysql default $SERVICE_NAME
  cf bind-service $APP_NAME $SERVICE_NAME
  else
  echo "MySQL service not found in marketplace."
  exit 1
  fi

  cf push $APP_NAME
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  echo "App Url=$APP_URL"
  EXIT_STATUS=0


  login_test=`curl $APP_URL`
  create_table_test=`curl $APP_URL/create-table-test/Test`
  insert_test=`curl $APP_URL/insert-test/Test`

  echo "Curl Output- $login_test"

  if [ "$login_test" != "ok" ]; then
    echo "Failed to login to MySQL service"
    EXIT_STATUS=1
  elif [ "$create_table_test" != "ok" ]; then
    echo "Failed to create table in the DB."
    EXIT_STATUS=1
  elif [ "$insert_test" != "ok" ]; then
    echo "Failed to insert entry into table in the DB."
    EXIT_STATUS=1
  else
    echo "All test suites passed."
  fi

  cf orgs
  cf spaces
  cf quotas
  cf space-quotas
  cf services
  cf apps
  cf routes
  cf domains
  cf env $APP_NAME
  cf unbind-service $APP_NAME $SERVICE_NAME
  cf delete $APP_NAME -f
  cf delete-service $SERVICE_NAME -f
  cf delete-orphaned-routes -f

}



set +e

Cf_Login $CF_ADMIN_USER $CF_ADMIN_PASSWORD
cf target -o oscf-sys -s testing
echo "Pushing app"
Push_And_Test_Smoketest_App
exit $EXIT_STATUS
