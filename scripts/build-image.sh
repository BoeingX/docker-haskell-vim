#!/bin/bash
#
# Build docker image only if TARGET_DIR changes from the last commit
if [[ $(git --no-pager diff HEAD~1..HEAD "$TARGET_DIR") ]]; then
    echo "Changes detected in $TARGET_DIR"
    cd docker && docker build -t "${IMAGE_NAME}" .
else
    echo "No file changed in ${TARGET_DIR}, skip build"
fi
