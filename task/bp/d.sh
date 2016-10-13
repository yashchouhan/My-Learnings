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

#t1
Push_tomee-embedded_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-embedded-app-$r"
  echo "tomee-embedded Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p embedded-app.war
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#t2
Push_tomee-grails_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-grails-app-$r"
  echo "tomee-grails Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p grails-app.war
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#t3
Push_tomee-groovy_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-groovy-app-$r"
  echo "tomee-groovy Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p groovy-app.zip
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#t4
Push_tomee-play_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-play-app-$r"
  echo "tomee-play Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p play-app.zip
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#t5
Push_tomee-servlet_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-servlet-app-$r"
  echo "tomee-servlet Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p servlet-app.war
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}


#t6
Push_tomee-spring_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="tomee-spring-app-$r"
  echo "tomee-spring Buildpack "
  cf buildpacks | egrep "tomee"
  res=$?

  if [ $res -eq 0 ]; then
  echo "tomee buildpack found in cf buildpacks"
  else
  echo "tomee buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b tomee -p spring-app.jar
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#t7
Push_jboss-java_Buildpack_App() {

  cd ../smoketest/
  APP_NAME="jboss-java-app-$r"
  echo "jboss-java Buildpack "
  cf buildpacks | egrep "jboss"
  res=$?

  if [ $res -eq 0 ]; then
  echo "jboss buildpack found in cf buildpacks"
  else
  echo "jboss buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b jboss -p java-app.jar
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}


set +e

Cf_Login $CF_ADMIN_USER $CF_ADMIN_PASSWORD
cf target -o oscf-sys -s testing
echo "Pushing app"
Push_tomee-embedded_Buildpack_App
cd ../bp
Push_tomee-grails_Buildpack_App
cd ../bp
Push_tomee-groovy_Buildpack_App
cd ../bp
Push_tomee-play_Buildpack_App
cd ../bp
Push_tomee-servlet_Buildpack_App
cd ../bp
Push_tomee-spring_Buildpack_App
cd ../bp
Push_jboss-java_Buildpack_App

exit $EXIT_STATUS


