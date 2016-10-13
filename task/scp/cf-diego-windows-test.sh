#!/bin/bash -ex

CF_ADMIN_PASSWORD=VujghicujiginjawauddAcyikechna
Create_Org_And_View_Org()
{
  cf create-org $1
  cf target -o $1
}

Delete_Org()
{
  cf delete-org $1 -f
}

Create_Space()
{
  cf create-space $1
  cf target -s $1
}
:
View_Space()
{
  cf spaces
}

Delete_Space()
{
  cf delete-space $1 -f
}

Push_And_Test_Smoketest_App() {

 # cd manifest-stubs/ci/smoketests/mysql
  cd oscf-manifest-stubs/ci/aws/mysql
  r=$RANDOM
  APP_NAME="mysql-smoketest-app-$r"

  echo "Pushing MySql sample app on Diego"
  cf push $APP_NAME --no-start
  cf enable-diego $APP_NAME
  cf start $APP_NAME
  cf diego-apps
  cf scale $APP_NAME -k 1G -i 3 -m 2G -f
  cf scale $APP_NAME -k 512m -i 2 -m 1G -f
  cf app $APP_NAME
  
  APP_NAME_DEA="mysql-smoketest-app-1-$r"
  echo "Pushing MySql sample app on DEA"
  cf push $APP_NAME_DEA --no-start
  cf disable-diego $APP_NAME_DEA
  cf start $APP_NAME_DEA
  cf dea-apps

}

#Main file
   CF_VERSION=`bosh deployments | grep cf/ | sed -n 1p | awk -F"|" {'print $3'} | awk -F"/" {'print $2'}`
   echo "Current CF version is:" $CF_VERSION
   cf api --skip-ssl-validation $API_ENDPOINT
   cf auth admin $CF_ADMIN_PASSWORD
   Create_Org_And_View_Org Auto-Scale-Org
   Create_Space Auto-Scale-Space
   Push_And_Test_Smoketest_App
   cf delete $APP_NAME -f
   cf delete $APP_NAME_DEA -f
   cf delete-space Auto-Scale-Space -f
   cf delete-org Auto-Scale-Org -f
 exit $EXIT_STATUS
