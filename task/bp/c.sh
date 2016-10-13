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
#bp1
Push_staticfile_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/staticfile

  APP_NAME="staticfile-app-$r"
  echo "staticfile Buildpack "
  cf buildpacks | egrep "staticfile_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "staticfile buildpack found in cf buildpacks"
  else
  echo "staticfile buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b staticfile_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp2
Push_Java_Buildpack_App() {
  
  cd ../oscf-manifest-stubs/ci/smoketests/java

  APP_NAME="java-app-$r"
  echo "Java Buildpack "
  cf buildpacks | egrep "java_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "Java buildpack found in cf buildpacks"
  else
  echo "Java buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b java_buildpack -p sample.war
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
  
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp3
Push_Ruby_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/ruby

  APP_NAME="ruby-app-$r"
  echo "Ruby Buildpack "
  cf buildpacks | egrep "ruby_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "Ruby buildpack found in cf buildpacks"
  else
  echo "Ruby buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b ruby_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
  
  cf apps
  cf services
  EXIT_STATUS=0  
  cf env $APP_NAME
  
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp4
Push_nodejs_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/nodejs

  APP_NAME="nodejs-app-$r"
  echo "nodejs Buildpack "
  cf buildpacks | egrep "nodejs_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "nodejs buildpack found in cf buildpacks"
  else
  echo "nodejs buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b nodejs_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp5
Push_go_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/go

  APP_NAME="go-app-$r"
  echo "go Buildpack "
  cf buildpacks | egrep "go_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "go buildpack found in cf buildpacks"
  else
  echo "go buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b go_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
  
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp6
Push_python_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/python

  APP_NAME="python-app-$r"
  echo "python Buildpack "
  cf buildpacks | egrep "python_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "python buildpack found in cf buildpacks"
  else
  echo "python buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b python_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp7
Push_Php_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/php

  APP_NAME="php-app-$r"
  echo "PHP Buildpack "
  cf buildpacks | egrep "php_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "PHP buildpack found in cf buildpacks"
  else
  echo "PHP buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b php_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp8
Push_binary_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/binary

  APP_NAME="binary-app-$r"
  echo "binary Buildpack "
  cf buildpacks | egrep "binary_buildpack"
  res=$?

  if [ $res -eq 0 ]; then
  echo "binary buildpack found in cf buildpacks"
  else
  echo "binary buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b binary_buildpack
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL

  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp9
Push_clojure_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/clojure

  APP_NAME="clojure-app-$r"
  echo "clojure Buildpack "
  cf buildpacks | egrep "clojure"
  res=$?

  if [ $res -eq 0 ]; then
  echo "clojure buildpack found in cf buildpacks"
  else
  echo "clojure buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b clojure
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp10
Push_scala_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/scala

  APP_NAME="scala-app-$r"
  echo "scala Buildpack "
  cf buildpacks | egrep "scala"
  res=$?

  if [ $res -eq 0 ]; then
  echo "scala buildpack found in cf buildpacks"
  else
  echo "scala buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b scala
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}

#bp11
Push_swift_Buildpack_App() {

  cd ../oscf-manifest-stubs/ci/smoketests/swift

  APP_NAME="swift-app-$r"
  echo "swift Buildpack "
  cf buildpacks | egrep "swift"
  res=$?

  if [ $res -eq 0 ]; then
  echo "swift buildpack found in cf buildpacks"
  else
  echo "swift buildpack not found in CF buildpacks."
  exit 1
  fi

  cf push $APP_NAME -b swift
  APP_URL="http://$APP_NAME.$CF_APP_DOMAIN"
  curl $APP_URL
 
  cf apps
  cf services
  EXIT_STATUS=0
  cf env $APP_NAME
  cf delete $APP_NAME -r -f
  cf delete-orphaned-routes -f

}


#Main Method

set +e

Cf_Login $CF_ADMIN_USER $CF_ADMIN_PASSWORD
cf target -o oscf-sys -s testing
echo "Pushing app"

Push_staticfile_Buildpack_App
cd ../../../../bp
Push_Java_Buildpack_App
cd ../../../../bp
Push_Ruby_Buildpack_App
cd ../../../../bp
#Push_nodejs_Buildpack_App
#cd ../../../../bp
#Push_go_Buildpack_App
#cd ../../../../bp
#Push_python_Buildpack_App
#cd ../../../../bp
#Push_Php_Buildpack_App
#cd ../../../../bp
#Push_binary_Buildpack_App
#cd ../../../../bp
#Push_clojure_Buildpack_App
#cd ../../../../bp
#Push_scala_Buildpack_App
#cd ../../../../bp
#Push_swift_Buildpack_App
#
exit $EXIT_STATUS



