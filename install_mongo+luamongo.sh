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

    # Install mongo (v2.4.3 or later)
    brew install mongodb

elif [[ `uname` == 'Linux' ]]; then
    # Ubuntu
    if [[ `which apt-get` == '' ]]; then
        echo "Platform not supported, aborting..."
        exit
    fi

    # Install Driver with apt-get
    sudo apt-get -y install scons
    sudo apt-get -y install libboost-filesystem-dev
    sudo apt-get -y install libboost-thread-dev

    # Download and install MongoDB, v2.4.3
    cd /tmp
    curl -s http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.3.tgz > mongodb.tgz
    tar xvf mongodb.tgz
    sudo cp -r mongodb-linux-x86_64-2.4.3/bin/* /usr/local/bin/

else
    # Unsupported
    echo 'Platform not supported, aborting...'
    exit
fi

# Fetch Lua driver's repo:
cd /tmp
git clone https://github.com/clementfarabet/luamongo.git
git pull

# Build C++ driver, as a shared lib:
cd luamongo/mongo-cxx-driver-v2.4
if [[ `uname` == 'Darwin' ]]; then
    scons install
elif [[ `uname` == 'Linux' ]]; then
    sudo scons install
fi

# Build Lua driver:
cd /tmp/luamongo
if [[ `uname` == 'Darwin' ]]; then
    make install
elif [[ `uname` == 'Linux' ]]; then
    sudo make install
fi
