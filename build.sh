#!/bin/sh

GITHUB_REPOSITORY=libc7zip
MATRIX_ARCH=32

clear

echo '### Initializing build settings...'
GITHUB_WORKSPACE=$HOME/work/$GITHUB_REPOSITORY/$GITHUB_REPOSITORY
RUNNER_OS=$(uname -s)
RUNNER_TEMP=$HOME/work/_temp
OUTPUT_DIR=$RUNNER_TEMP/build
UPLOAD_DIR=$RUNNER_TEMP/upload
echo

echo '### Cleaning output dir...'
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
echo

echo '### Checking out project source...'
mkdir -p $HOME/work/$GITHUB_REPOSITORY
cp -r -v /vagrant $HOME/work/$GITHUB_REPOSITORY
mv $HOME/work/$GITHUB_REPOSITORY/vagrant $HOME/work/$GITHUB_REPOSITORY/$GITHUB_REPOSITORY
echo

echo '### Listing workspace files...'
cd $GITHUB_WORKSPACE
ls -l
echo

echo '### Generating build files...'
cmake \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_BUILD_TYPE=Release \
  -G "Unix Makefiles" \
  -DCMAKE_C_FLAGS=-m$MATRIX_ARCH \
  -DCMAKE_CXX_FLAGS=-m$MATRIX_ARCH \
  -DCMAKE_C_FLAGS_RELEASE=-s \
  -DCMAKE_CXX_FLAGS_RELEASE=-s \
  -S $GITHUB_WORKSPACE \
  -B $OUTPUT_DIR
echo

echo '### Building...'
cmake --build $OUTPUT_DIR
echo

echo '### Checking executable binary'
file $OUTPUT_DIR/libc7zip.so
file $OUTPUT_DIR/c7zip-sample
file $OUTPUT_DIR/vendor/lib7zip/Lib7Zip/lib7zip.a
echo

echo '### Prepare upload artifact'
rm -rf $UPLOAD_DIR
mkdir -p $UPLOAD_DIR

cp -v $GITHUB_WORKSPACE/LICENSE $UPLOAD_DIR
cp -v $GITHUB_WORKSPACE/README.md $UPLOAD_DIR

mkdir $UPLOAD_DIR/bin
cp -v $OUTPUT_DIR/c7zip-sample $UPLOAD_DIR/bin

mkdir $UPLOAD_DIR/lib
cp -v $OUTPUT_DIR/libc7zip.so $UPLOAD_DIR/lib
cp -v $OUTPUT_DIR/vendor/lib7zip/Lib7Zip/lib7zip.a $UPLOAD_DIR/lib

cp -r -v $GITHUB_WORKSPACE/include $UPLOAD_DIR

echo '### Upload artifact'
cd $UPLOAD_DIR
zip -r -v /vagrant/$GITHUB_REPOSITORY-$RUNNER_OS-$MATRIX_ARCH.zip .
cd ..
echo

echo '### Check artifact'
unzip -l /vagrant/$GITHUB_REPOSITORY-$RUNNER_OS-$MATRIX_ARCH.zip
echo
