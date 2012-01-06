#!/bin/bash
BINDIR=$(cd `dirname $0` && pwd)
PROJDIR=`dirname $BINDIR`
DOWN_DIR="$HOME/Downloads"
AE_DIR=$PROJDIR/appengine
AE_BIN=$AE_DIR/google_appengine
ENV_DIR=$PROJDIR/gtugenv

AE_VERSION="1.6.1"

# download <url> - do nothing if already downloaded
function download {
    FILE_PATH=$1
    FILE="$( basename "$FILE_PATH" )"

    if [ ! -f $DOWN_DIR/$FILE ]; then
        if ! curl $FILE_PATH --output $DOWN_DIR/$FILE; then
            echo "Failed to download $FILE_PATH"
            exit 1
        fi
    fi
}

# download_zip <url> <destination directory>
# download and unzip directory to destination
function download_zip {
    DEST_PATH=$2

    download $1

    rm -rf $DEST_PATH
    mkdir $DEST_PATH
    unzip -q $DOWN_DIR/$FILE -d $DEST_PATH
}

cd $PROJDIR

read -p "Create local Python environment? (y/n): "
if [ "$REPLY" = "y" ]; then
    rm -rf $ENV_DIR
    virtualenv --python=python2.5 $ENV_DIR
    ln -f -s $ENV_DIR/bin/activate
fi

read -p "Install App Engine? (y/n): "
if [ "$REPLY" = "y" ]; then
    rm -rf appengine
    download_zip http://googleappengine.googlecode.com/files/google_appengine_$AE_VERSION.zip $AE_DIR
    ln -f -s $AE_BIN/dev_appserver.py $AE_BIN/appcfg.py $ENV_DIR/bin
fi

echo "Type 'source activate' to use this environment"
