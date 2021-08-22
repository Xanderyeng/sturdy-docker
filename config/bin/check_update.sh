#!/bin/bash
# Example usage:
# ./docker-image-update-check.sh gitlab/gitlab-ce update-gitlab.sh

echo "/bin/bash config/bin/update"
IMAGE="benlumia007/sturdy-docker"
COMMAND="$2"

which jq
if [ "$?" != "0" ] ; then
	echo "'jq' command not found. Please install and ensure that it is available in PATH."
  exit 1
fi

echo "Fetching Docker Hub token..."
token=$(curl --silent "https://auth.docker.io/token?scope=repository:$IMAGE:pull&service=registry.docker.io" | jq -r '.token')

echo -n "Fetching remote digest... "
digest=$(curl --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -H "Authorization: Bearer $token" "https://registry.hub.docker.com/v2/$IMAGE/manifests/apache2" | jq -r '.config.digest')
echo "$digest"

echo -n "Fetching local digest...  "
local_digest=$(docker images -q --no-trunc $IMAGE:apache2)
echo "$local_digest"

if [ "$digest" != "$local_digest" ] ; then
	echo "Update available. Executing update command..."
	($COMMAND)
else
	echo "Already up to date. Nothing to do."
fi

