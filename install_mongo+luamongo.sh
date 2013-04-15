#!/usr/bin/env bash

# Platform specific
if [[ `uname` == 'Darwin' ]]; then
    # Needs Homebrew
    if [[ `which brew` == '' ]]; then
        echo "Please install Homebrew to proceed (http://mxcl.github.com/homebrew/)"
        echo "$ ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
        exit
    fi

    # On MacOS, we need to flip Boost to an older version... crap.
    cd /usr/local
    git checkout c65892f Library/Formula/boost.rb
    brew remove boost
    brew install boost

    # Get SCons
    brew install scons

    # Install driver by hand
    cd /tmp/
    mkdir -p mongostuff; cd mongostuff
    git clone https://github.com/mongodb/mongo.git
    cd mongo
    git pull
    scons all
    scons all install

elif [[ `uname` == 'Linux' ]]; then
    # Ubuntu
    if [[ `which apt-get` == '' ]]; then
        echo "Platform not supported, aborting..."
        exit
    fi

    # Install Driver with apt-get
    sudo apt-get -y install python-software-properties
    sudo add-apt-repository ppa:28msec/utils
    sudo apt-get update
    sudo apt-get -y install libboost-filesystem-dev
    sudo apt-get -y install libboost-thread-dev
    sudo apt-get -y install libmongo-cxx-driver-dev
    sudo apt-get -y install mongodb

else
    # Unsupported
    echo 'Platform not supported, aborting...'
    exit
fi

# Clone repos
cd /tmp/
mkdir -p mongostuff; cd mongostuff
git clone https://github.com/clementfarabet/luamongo.git

# Build Lua Driver
cd /tmp/mongostuff/luamongo
git pull
make

# Install
if [[ `uname` == 'Darwin' ]]; then
    make install
elif [[ `uname` == 'Linux' ]]; then
    sudo make install
fi
