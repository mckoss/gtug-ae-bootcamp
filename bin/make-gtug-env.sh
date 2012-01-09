#!/bin/bash
BINDIR=$(cd `dirname $0` && pwd)
PROJDIR=`dirname $BINDIR`
DOWN_DIR="$HOME/Downloads"
AE_DIR=$PROJDIR/appengine
AE_BIN=$AE_DIR/google_appengine
ENV_DIR=$PROJDIR/gtugenv

AE_VERSION="1.6.1"

SUDO=sudo

if [ `uname` == "Darwin" ]; then
    platform="Mac"
elif [[ `uname` == *W32* ]]; then
    platform="Windows"
    SUDO=""
else
    platform="Linux"
fi

echo "I think your machine is running $platform ..."

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

function check_prog {
    type $1 > /dev/null 2>&1
}

cd $PROJDIR

if ! check_prog python2.5 ; then
    echo "You need Python 2.5 to use App Engine."
    if [ $platform == "Windows" ]; then
        download http://www.python.org/ftp/python/2.5.4/python-2.5.4.msi
        msiexec -i $DOWN_DIR/$FILE
    elif [ $platform == "Mac" ]; then
        echo "Please install Python 2.5.6 from http://www.python.org/getit/releases/2.5.6/"
        echo "Or install http://www.python.org/ftp/python/2.5/python-2.5-macosx.dmg"
        exit 1
    else
        $SUDO apt-get python2.5
    fi
fi

# Will this ever happen?
if ! type easy_install > /dev/null; then
    echo "Please install easy_install from http://pypi.python.org/pypi/setuptools."
    exit 1
fi

if ! type pip > /dev/null; then
    $SUDO easy-install pip
fi

if ! type virtualenv > /dev/null; then
    $SUDO pip install virtualenv
fi

read -p "Create local Python 2.5 environment? (y/n): "
if [ "$REPLY" = "y" ]; then
    rm -rf $ENV_DIR
    virtualenv --python=python2.5 $ENV_DIR
    ln -f -s $ENV_DIR/bin/activate
    source activate
    pip install PIL
fi

read -p "Install App Engine ($AE_VERSION)? (y/n): "
if [ "$REPLY" = "y" ]; then
    rm -rf appengine
    download_zip http://googleappengine.googlecode.com/files/google_appengine_$AE_VERSION.zip $AE_DIR
    ln -f -s $AE_BIN/*.py $ENV_DIR/bin
fi

echo "Type 'source activate' to use this environment"
