#!/bin/bash
API_ENDPOINT=https://api.sys.test.cfdev.canopy-cloud.com
CF_USER=admin
CF_ADMIN_PASSWORD=VujghicujiginjawauddAcyikechna

Create_Org_And_View_Org_And_Org_Quotas()
{
  cf orgs
  cf create-org $1
  cf target -o $1
  cf quotas
}

Create_Space()
{
  cf create-space $1
  cf target -s $1
}
  r=$RANDOM
  SERVICE_NAME="mysql-smoketest-service"
  APP_NAME="mysql-smoketest-app-$r"

Push_And_Test_Smoketest_App() {

  cd oscf-manifest-stubs/ci/smoketests/mysql
  cf push $APP_NAME --no-start
  cf marketplace | egrep "*mysql"
  res=$?

  if [ $res -eq 0 ]; then
  cf create-service p-mysql default mysql-smoketest-service
  cf bind-service $APP_NAME mysql-smoketest-service
  else
  echo "MySQL service not found in marketplace."
  exit 1
  fi

  cf push $APP_NAME
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  EXIT_STATUS=0

  login_test=`curl $APP_URL`
  create_table_test=`curl $APP_URL/create-table-test/Test`
  insert_test=`curl $APP_URL/insert-test/Test`

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

#  exit $EXIT_STATUS
}

Delete_App()
{
  cf unbind-service $APP_NAME mysql-smoketest-service
  cf delete $APP_NAME -f
  cf delete-service mysql-smoketest-service -f
  cf delete-orphaned-routes -f
}

Delete_Space()
{
  cf delete-space $1 -f
}

Delete_Org()
{
  cf delete-org $1 -f
}

Delete_User()
{
 cf delete-user $1 -f
}

EXIT_STATUS=0

 yes|bosh download manifest oscf oscf.yml 
 bosh deployment oscf.yml

 cf api --skip-ssl-validation $API_ENDPOINT 
 cf auth $CF_USER $CF_ADMIN_PASSWORD 
 create_org_and_view_org_and_Org_quotas backup-restore-Org 
 create_space backup-restore-Space 
 cf create-user backup-user Canopy1!
 cf set-space-role backup-user backup-restore-Org backup-restore-Space SpaceDeveloper 
 cf api --skip-ssl-validation $API_ENDPOINT 
 cf auth backup-user Canopy1! 
 echo "Checkpoint1" 
 cf target -o backup-restore-Org -s backup-restore-Space      
 push_and_test_smoketest_app
 bosh run errand db_backup 

 cf api --skip-ssl-validation $API_ENDPOINT
 cf auth $CF_USER $CF_ADMIN_PASSWORD
 cf target -o backup-restore-Org
 delete_app
 delete_space backup-restore-Space
 delete_org backup-restore-Org
 delete_user backup-user

 bosh run errand db_restore

 cf orgs | grep "backup-restore-Org"
 orgname=$?
 if [ $orgname -eq 0 ]; then
  echo "Org restored"
  cf target -o backup-restore-Org
 else
  echo "Org Restored failed"
  EXIT_STATUS=1
 fi

 cf spaces | grep "backup-restore-Space"
 spacename=$?
 if [ $spacename -eq 0 ]; then
  echo "Space restored"
  cf target -o backup-restore-Org -s backup-restore-Space
 else
  echo "Space Restored failed "
  EXIT_STATUS=1
 fi

 cf space-users backup-restore-Org backup-restore-Space | grep "backup-user"
 username=$?
 if [ $username -eq 0 ]; then
  echo "User restored"
 else
  echo "User Restore failed"
  EXIT_STATUS=1
 fi

 cf apps | grep $APP_NAME
 appname=$?
 if [ $appname -eq 0 ]; then
  echo "App restored"
 else
  echo "App Restore failed "
  EXIT_STATUS=1
 fi

 cf services | grep $SERVICE_NAME
 servicename=$?
 if [ $servicename -eq 0 ]; then
  echo "Service restored"
 else
  echo "Service Restored failed "
  EXIT_STATUS=1
 fi

exit $EXIT_STATUS
