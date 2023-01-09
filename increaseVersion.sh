#!/bin/bash

#this script updates app version inside build.groovy app
#use instructions: $./increaseVersion [major/minor/patch]

update=$1 #which version to upgrade

#extract the major, minor and patch version from build.gradle
major=$(sed -n 8p build.gradle | awk '{print $2}' | xargs | cut -d . -f 1)
minor=$(sed -n 8p build.gradle | awk '{print $2}' | xargs | cut -d . -f 2)
patch=$(sed -n 8p build.gradle | awk '{print $2}' | xargs | cut -d . -f 3)


if [ $update == "major" ]
then
major=$(($major+1))
minor=0
patch=0
fi

if [ $update == "minor" ]
then
minor=$(($minor+1))
patch=0
fi

if [ $update == "patch" ]
then
patch=$(($patch+1))
fi


version="version '$major.$minor.$patch'"
export BUILD_VERSION="$version"

#replace line 8 with the updated app version
sed -i "8s/.*/$version/" build.gradle
