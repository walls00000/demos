export MYNAME=./build.sh

source common.sh
help() {
  cat << FIN

  ${REPO}/${CUSTOM_NAME}:latest
  
  source $MYNAME 
  build: build $IMAGE
  login: docker login
  push: push $IMAGE to $REPO in docker hub
  pull: pull $IMAGE from $REPO in docker hub
  logout: logout from docker

  example:
    # normal workflow:
    source $MYNAME; build; login; push; pull;
FIN
}

usage() {
  if [ "X$@" != "X"];then
    echo "$@"
  fi
  help
}

build() {
  set -x
  docker build -f ${DOCKERFILE} -t ${IMAGE}:latest .
  set +x
}

login() {
  set -x
  docker login
  set +x
}

logout() {
  docker logout
}



push() {
  docker tag ${IMAGE}:latest ${REPO}/${IMAGE}:latest
  docker push ${REPO}/${IMAGE}:latest
}

pull() {
  set -x
  docker pull ${REPO}/${IMAGE}:latest
  set +x
}




help



#docker push ${imageName}
# docker-compose up -build
