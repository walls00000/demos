#!/bin/bash

source ./docker/common.sh
export X11_SOCKET=/tmp/.X11-unix

red() {
  echo "[031m$@[0m"
}

yellow() {
  echo "[033m$@[0m"
}

warn() {
  yellow "WARNING: $@"
}

usage() {
  cat << FIN
############################################################
## docker-run.sh run a docker container interactively 
##
## provide a command argument to run, such as "/bin/bash -l" to drop
## into an interactive bash shell.  For example:
##
## ./docker-run.sh /bin/bash -l
##
## This file can also be sourced to export ENV variables 
## into the current shell as environment variables once:
##
## source ./docker-run.sh
## run yarn e2e
## run /bin/bash -l
##
## ctrl+d to exit interactive container
############################################################
FIN
}
SCRIPTNAME="docker-run.sh"
MYNAME=$(basename "$0")
if [ "$MYNAME" == "$SCRIPTNAME" ]; then
  DIRNAME=$(dirname "$0")
else
  DIRNAME=.
fi

fatal () {
  red "FATAL: $@"
  usage
  if [ "$MYNAME" == "$SCRIPTNAME" ];then
    exit 1
  fi
}

if [ "X${AWS_PROFILE}" == "X" ];then
  fatal "Please set AWS_PROFILE"
fi

# determine which env file to use based on the $ENV variable
getDotenv() {
  envDir="${DIRNAME}"
  local dotenvFile
  env=$(echo ${ENV} | tr '[:upper:]' '[:lower:]')
  case $env in
    dev)
      dotenvFile="${envDir}/.env.dev"
    ;;

    qa)
      dotenvFile="${envDir}/.env.qa"
    ;;

    stg)
      dotenvFile="${envDir}/.env.stg"
    ;;

    *)
      dotenvFile="${envDir}/.env"
    ;;
  esac

  echo $dotenvFile

  if [ ! -f ${dotenvFile} ];then
    fatal "The file ${dotenvFile} does not exist"
  fi
}

parseSecrets() {
  local dotenv=$1
  if [ -f $dotenv ];then
    cat $dotenv | grep =/
    ## Add ZEPHYR_TOKEN
    echo "ZEPHYR_TOKEN=/test-automation/dct/ZEPHYR_TOKEN"
  fi

}

getParams() {
  echo "Using dotenv file: $(getDotenv)"
  secrets=$(parseSecrets $(getDotenv))
  ## 
  DOCKER_ENV_ARGS=""
  for line in $secrets 
  do
    key=$(echo $line | awk -F= '{print $1}')
    value=$(echo $line | awk -F= '{print $2}')
    local test=$(eval echo \$$(echo $key))
    if [ "X${test}" == "X" ];then
      echo "fetching parameter for $key"
      eval export $key=$(aws ssm get-parameter --name "$value" --with-decryption | jq -r ".Parameter.Value")
    fi
    DOCKER_ENV_ARGS="$DOCKER_ENV_ARGS -e $key=$(eval echo \$$key)"
  done
  echo
}

run() {
  if [ "X$1" == "X" ];then
    fatal "No command to run!  Please provide a command to run in the container, eg: './docker-run.sh /bin/bash -l'"
  fi
  if [ "${PROMPT}" == "" ];then
    export PROMPT="${CONTAINERNAME}"
  fi
  DOCKER_RUN_ARGS="-it --rm"
  docker run $DOCKER_RUN_ARGS \
  $DOCKER_ENV_ARGS \
  -e IMAGE=$IMAGE \
  -e PROMPT=$PROMPT \
  -e ENV=$ENV \
  -e DISPLAY=$DISPLAY \
  --name $PROMPT \
  -v $BILLING_DIR:$CONTAINER_WORK_DIR \
  -v /private/tmp:/private/tmp \
  -v ${X11_SOCKET}:${X11_SOCKET} \
  ${REPO}/$IMAGE $@
}

export CONTAINER_WORK_DIR="/var/build"
export BILLING_DIR=$DIRNAME


if [ ! -d "${X11_SOCKET}" ];then
  warn "X11 Socket not found! No such directory ${X11_SOCKET}.  Run sokat.sh??"
fi

#run as shell script
if [ "$MYNAME" == "$SCRIPTNAME" ]; then
  if [ "$#" -lt 1 ];then
    fatal "Expected a command! Please provide a command to run in the container, eg: './docker-run.sh /bin/bash -l'"
  fi
  echo "running '$@'"
  #getParams
  run $@
else 
  echo "MYNAME: $MYNAME"
  #getParams
fi
