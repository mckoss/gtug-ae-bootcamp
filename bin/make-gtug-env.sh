#!/bin/bash
BINDIR=$(cd `dirname $0` && pwd)
PROJDIR=`dirname $BINDIR`
DOWN_DIR="$HOME/Downloads"
AE_DIR=$PROJDIR/appengine
AE_BIN=$AE_DIR/google_appengine
ENV_DIR=$PROJDIR/gtugenv

AE_FILES=http://googleappengine.googlecode.com/files
AE_VERSION="1.6.1"
PYTHON_CMD=python2.5

SUDO=sudo

if [ `uname` == "Darwin" ]; then
    platform="Mac"
elif [[ `uname` == *W32* ]]; then
    platform="Windows"
    SUDO=""
    PYTHON_VER="2.5.4"
    PYTHON_CMD=python2.5.exe
    SETUP_TOOLS=setuptools-0.6c11-py2.5.egg
else
    platform="Linux"
fi

echo "I think your machine is running $platform ..."

# download <url> - do nothing if already downloaded
function download {
    FILE_PATH=$1
    FILE="$( basename "$FILE_PATH" )"

    mkdir -p $DOWN_DIR
    if [ ! -f $DOWN_DIR/$FILE ]; then
        echo "Downloading $1"
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
        download http://www.python.org/ftp/python/$PYTHON_VER/python-$PYTHON_VER.msi
        cd $DOWN_DIR
        msiexec -i $FILE
        ln -s /c/Python25/python.exe /c/Python25/python2.5.exe
        PATH=$PATH:/c/Python25:/c/Python25/Scripts
        export PATH
        echo 'PATH=$PATH:/c/Python25:/c/Python25/Scripts' >> $HOME/.profile
        cd $PROJ_DIR
    elif [ $platform == "Mac" ]; then
        echo "Please install Python 2.5.6 from http://www.python.org/getit/releases/2.5.6/"
        echo "Or install http://www.python.org/ftp/python/2.5/python-2.5-macosx.dmg"
        exit 1
    else
        $SUDO apt-get python2.5
    fi
fi

if ! check_prog easy_install ; then
    if [ $platform == "Windows" ]; then
        download http://pypi.python.org/packages/2.5/s/setuptools/$SETUP_TOOLS
        sh $DOWN_DIR/$SETUP_TOOLS
    else
        echo "Please install easy_install from http://pypi.python.org/pypi/setuptools."
        exit 1
    fi
fi

if ! check_prog pip ; then
    $SUDO easy_install pip
fi

if ! check_prog virtualenv ; then
    $SUDO pip install virtualenv
fi

read -p "Create local Python 2.5 environment? (y/n): "
if [ "$REPLY" = "y" ]; then
    rm -rf $ENV_DIR
    virtualenv --python=$PYTHON_CMD $ENV_DIR
    if [ $platform = "Windows" ]; then
        ln -f -s $ENV_DIR/Scripts/activate.bat
    else
        ln -f -s $ENV_DIR/bin/activate
        source activate
    fi
    # pip install PIL
fi

read -p "Install App Engine ($AE_VERSION)? (y/n): "
if [ "$REPLY" = "y" ]; then
    if [ $platform == "Windows" ]; then
        download $AE_FILES/GoogleAppEngine-$AE_VERSION.msi
        cd $DOWN_DIR
        msiexec -i $FILE
        cd $PROJ_DIR
    elif [ $platform == "Mac" ]; then
        download $AE_FILES/GoogleAppEngineLauncher-$AE_VERSION.dmg
        open $DOWN_DIR/$FILE
    else
        rm -rf appengine
        download_zip $AE_FILES/google_appengine_$AE_VERSION.zip $AE_DIR
        ln -f -s $AE_BIN/*.py $ENV_DIR/bin
    fi
fi

if [ $platform == "Windows" ]; then
    echo "Open a Windows Command shell to use this environment."
    echo "And then type activate.bat"
else
    echo "Type 'source activate' to use this environment"
fi
