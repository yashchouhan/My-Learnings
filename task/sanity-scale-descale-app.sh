#!/bin/bash -ex

API_ENDPOINT=https://api.sys.test.cfdev.canopy-cloud.com
CF_ADMIN_USER=admin
CF_ADMIN_PASSWORD=mirorosyoydZorvucMop!FlevTyct1
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

Scaling_And_Descaling_Of_MySql_App() {

  cd oscf-manifest-stubs/ci/smoketests/mysql
  r=$RANDOM
  APP_NAME="mysql-app-$r"
  echo "Pushing MySql sample app on Diego"
  echo "Using RubyBuildpack "

  SERVICE_NAME="mysql-service"
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
  cf push $APP_NAME --no-start
  cf enable-diego $APP_NAME
  cf start $APP_NAME
  cf diego-apps
#  cf scale $APP_NAME -k 1G -i 3 -m 2G -f
#  cf scale $APP_NAME -k 512m -i 2 -m 1G -f
  cf app $APP_NAME
  
  APP_NAME_DEA="mysql-DEA-app-$r"
  echo "Pushing MySql sample app on DEA"
  
  cf push $APP_NAME_DEA --no-start
  echo "Pushing MySql sample app on DEA"
  echo "Using RubyBuildpack "
  SERVICE_NAME="mysql-service-dea"
  cf push $APP_NAME --no-start
  cf marketplace | egrep "*mysql"
  res=$?
  if [ $res -eq 0 ]; then
  echo "Creating Mysql Service Instance"
  cf create-service p-mysql default $SERVICE_NAME
  cf bind-service $APP_NAME_DEA $SERVICE_NAME
  else
  echo "MySQL service not found in marketplace."
  exit 1
  fi
 
  cf disable-diego $APP_NAME_DEA
  cf start $APP_NAME_DEA
  cf dea-apps

}

Cleanup() {

  cf delete $APP_NAME -r -f
  cf delete $APP_NAME_DEA -r -f

}

 
#Main file

  Cf_Login $CF_ADMIN_USER $CF_ADMIN_PASSWORD
  cf target -o oscf-sys -s testing
  Scaling_And_Descaling_Of_MySql_App
#  cf delete $APP_NAME -r -f
#  cf delete $APP_NAME_DEA -r -f
  Cleanup
 exit $EXIT_STATUS
