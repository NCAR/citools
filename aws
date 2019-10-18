#!/bin/sh
PROG=aws.sh
DESC="Wrapper script for ncar/aws-cli docker container"
AWS_CLI_VERSION=${AWS_CLI_VERSION:-latest}
AWS_CLI_IMAGE=ncar/aws-cli:${AWS_CLI_VERSION}
AWS_ENV_VARS="
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_SESSION_TOKEN
  AWS_DEFAULT_REGION
  AWS_DEFAULT_OUTPUT
  AWS_DEFAULT_PROFILE
  AWS_CA_BUNDLE
  AWS_SHARED_CREDENTIALS_FILE
  AWS_CONFIG_FILE"

uid=`id -u`
gid=`id -g`
s=`docker info 2>&1  >/dev/null`
case $s in
    *permission*denied*)
        DOCKER="sudo docker" ;;
    *)
        DOCKER="docker" ;;
esac

set ${AWS_CLI_IMAGE} "$@"
if [ -d $HOME/.aws ] ; then
    set : --volume=$HOME/.aws:/home/.aws "$@"
    shift
fi
for var in ${AWS_ENV_VARS} ; do
    eval val="\"\$${var}\""
    if [ ":${val}" != ":" ] ; then
        set :  -e "${var}=${val}" "$@"
        shift
    fi
done
${DOCKER} run -u $uid:$gid --rm -it --volume=`pwd`:/home/workdir "$@" |
  tr -d '\r'

