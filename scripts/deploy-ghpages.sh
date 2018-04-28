#!/bin/bash

# Automated deploy script with Circle CI.

# Exit if any subcommand fails.
set -e

# Variables
ORIGIN_URL=`git config --get remote.origin.url`

echo "Started deploying"

# Checkout gh-pages branch.
if [ `git branch | grep master` ]
then
  git branch -D master
fi
git checkout -b master

# Build site.
jekyll build

# Delete and move files.
find . -maxdepth 1 ! -name '_site' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;
mv _site/* .
rm -R _site/

# Push to gh-pages.
git config user.name "$GH_NAME"
git config user.email "$GH_EMAIL"

git add -fA
git commit --allow-empty -m "$(git log -1 --pretty=%B) [ci skip]"
git push -f $ORIGIN_URL master

# Move back to previous branch.
git checkout -
bower install

echo "Deployed Successfully!"

exit 0
