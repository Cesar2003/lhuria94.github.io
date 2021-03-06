#!/bin/sh
# ideas used from https://gist.github.com/motemen/8595451

# Based on https://github.com/eldarlabs/ghpages-deploy-script/blob/master/scripts/deploy-ghpages.sh
# Used with their MIT license https://github.com/eldarlabs/ghpages-deploy-script/blob/master/LICENSE

# abort the script if there is a non-zero error
set -e

# show where we are on the machine
pwd
remote=$(git config remote.origin.url)

current_branc=$(git rev-parse --abbrev-ref HEAD)
echo $current_branc

# make a directory to put the gp-pages branch
mkdir ../master-branch
cd ../master-branch
# now lets setup a new repo so we can update the gh-pages branch
git config --global user.email "$GH_EMAIL" > /dev/null 2>&1
git config --global user.name "$GH_NAME" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"


# switch into the the gh-pages branch
if git rev-parse --verify origin/master > /dev/null 2>&1
then
    git checkout master
    # delete any old site as we are going to replace it
    # Note: this explodes if there aren't any, so moving it here for now
    git rm -rf .
    git add -A
    git commit -m "Deploy to GitHub pages [ci skip]"
    git push --force --quiet origin master
else
    git checkout --orphan master
fi

# copy over or recompile the new site
pwd
git checkout dev-1.0
current_branc1=$(git rev-parse --abbrev-ref HEAD)
echo $current_branc1
#cp -R -u -p /home/ubuntu/lhuria94.github.io/. /home/ubuntu/master-branch/
# stage any changes and new files
#git add -A
# now commit, ignoring branch gh-pages doesn't seem to work, so trying skip
#git commit -m "Deploy to GitHub pages [ci skip]"
# and push, but send any output to /dev/null to hide anything sensitive
git commit --allow-empty -m "Deploy to GitHub pages [ci skip]"
git push --force origin HEAD:master 

#git fetch --all
#git pull "$remote" dev-1.0

#git push --force origin master
# go back to where we started and remove the gh-pages git repo we made and used
# for deployment
cd ..
rm -rf master-branch

echo "Finished Deployment!"
