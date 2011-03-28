#!/bin/sh

SOURCE_DIR="source"
BUILD_DIR="build"
BUILDER_NAME=$1
REPO_URL=$2
BRANCH_NAME=$3
NODE_PATH=$4

cd ${BUILDER_NAME}

NEED_COMPILING=0
if [ ! -d "${SOURCE_DIR}" ] ; then
  mkdir source
  cd source/
  git clone ${REPO_URL} . --branch ${BRANCH_NAME}
  NEED_COMPILING=1
else
  cd source/
  UP_TO_DATE=`git pull origin ${BRANCH_NAME} | grep "up-to-date"`

  if [ -z "${UP_TO_DATE}" ]; then
    NEED_COMPILING=1
  fi
fi

cd ..
cp -rf source/* build/

if [ $NEED_COMPILING = "1" ]; then
  cd build
  ./configure --prefix=${NODE_PATH}/${BRANCH_NAME}
  make
  make install
fi
