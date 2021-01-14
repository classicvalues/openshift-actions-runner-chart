#!/usr/bin/env bash

set -eE -o pipefail

REGISTRY=${RUNNERS_REGISTRY:-quay.io/redhat-github-actions}
TAG=${RUNNERS_TAG:-dev}     # 'latest' refers to latest CI build on main branch.

BASE_IMG=${REGISTRY}/redhat-actions-runner:${TAG}
BUILDAH_IMG=${REGISTRY}/redhat-buildah-runner:${TAG}

set -x

cd $(dirname $0)

docker build ./base -f ./base/Dockerfile -t $BASE_IMG
docker build ./buildah -f ./buildah/Dockerfile -t $BUILDAH_IMG

set +x

if [[ $1 == "push" ]]; then
    set -x
    docker push $BASE_IMG
    docker push $BUILDAH_IMG
else
    echo "Not pushing. Set \$1 to 'push' to push"
fi

echo "$BASE_IMG"
echo "$BUILDAH_IMG"

cd - > /dev/null