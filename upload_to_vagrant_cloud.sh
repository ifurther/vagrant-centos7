#!/bin/bash

USERNAME="CHANGE ME"
PROVIDER_NAME="virtualbox"
ACCESS_TOKEN="CHANGE ME"

set -eu

if [ $# -ne 3 ]; then
  cat <<_EOT_
Usage:
  $0 <box_name> <version> <box_filepath>
_EOT_
  exit 1
fi

BOX_NAME=$1
VERSION=$2
BOX_FILEPATH=$3

UPLOAD_PATH=`curl -s "https://vagrantcloud.com/api/v1/box/${USERNAME}/${BOX_NAME}/version/${VERSION}/provider/${PROVIDER_NAME}/upload?access_token=${ACCESS_TOKEN}" | jq -r '.upload_path'`

echo "Uploading to $UPLOAD_PATH ..."

curl -X PUT --upload-file $BOX_FILEPATH $UPLOAD_PATH

echo "done!"