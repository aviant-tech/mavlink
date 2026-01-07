#!/usr/bin/env bash
set -euxo pipefail

# Update pymavlink submodule to point to current mavlink commit
# This script updates the mavlink submodule in pymavlink repository

MAVLINK_PATH=$PWD
MAVLINK_GITHASH=$(git rev-parse HEAD)
BRANCH_NAME="auto-update-${MAVLINK_GITHASH:0:8}"

# Clone pymavlink
PYMAVLINK_PATH="$MAVLINK_PATH/pymavlink_temp"
git clone git@github.com:aviant-tech/pymavlink.git "$PYMAVLINK_PATH"
cd "$PYMAVLINK_PATH"

# Create new branch
git checkout -b "$BRANCH_NAME"

# Initialize submodule
git submodule update --init mavlink

# Update mavlink submodule to point to current commit
cd mavlink

# Fetch the specific commit
git fetch origin "$MAVLINK_GITHASH"
git checkout "$MAVLINK_GITHASH"
cd ..

# Commit the submodule update
git add mavlink
COMMIT_MESSAGE="Update mavlink submodule to ${MAVLINK_GITHASH}"
GIT_COMMITTER_NAME="Aviant Bot" \
GIT_COMMITTER_EMAIL="bot@aviant.no" \
git commit -m "$COMMIT_MESSAGE" --author "Aviant Bot <bot@aviant.no>" || exit 0

# Push branch
git push -u origin "$BRANCH_NAME" || exit 1

echo -e "\033[34mBranch $BRANCH_NAME pushed successfully to pymavlink\033[0m"
echo -e "\033[34mCreate PR at: https://github.com/aviant-tech/pymavlink/compare/$BRANCH_NAME\033[0m"
