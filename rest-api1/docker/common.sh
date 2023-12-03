#export REGION=${REGION:-us-east-1}
#export AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-$(aws sts get-caller-identity | jq -r .Account)}
export REPO=braveheart55
export DOCKERFILE=Dockerfile
export IMAGE="ubuntu"
export CUSTOM_NAME="ubuntu"
export CONTAINER_NAME=$(basename $IMAGE | awk -F: '{print $1}')
