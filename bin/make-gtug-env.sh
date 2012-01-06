#!/bin/bash
BINDIR=$(cd `dirname $0` && pwd)
PROJDIR=`dirname $BINDIR`
DOWN_DIR="$HOME/Downloads"
AE_DIR=$PROJDIR/appengine
AE_BIN=$AE_DIR/google_appengine
ENV_DIR=$PROJDIR/gtugenv

AE_VERSION="1.6.1"

if [ `uname` == "Darwin" ]; then
    platform="Mac"
else
    platform="Linux"
fi

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

if ! type python2.5 > /dev/null; then
    echo "You need Python 2.5 to use App Engine."
    if [ $platform == "Mac" ]; then
        echo "Please install Python 2.5.6 from http://www.python.org/getit/releases/2.5.6/"
        echo "Or install http://www.python.org/ftp/python/2.5/python-2.5-macosx.dmg"
        exit 1
    else
        sudo apt-get python2.5
    fi
fi

# Will this ever happen?
if ! type easy_install > /dev/null; then
    echo "Please install easy_install from http://pypi.python.org/pypi/setuptools."
    exit 1
fi

if ! type pip > /dev/null; then
    sudo easy-install pip
fi

if ! type virtualenv > /dev/null; then
    sudo pip install virtualenv
fi

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
