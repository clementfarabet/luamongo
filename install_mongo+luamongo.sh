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

else
    # Unsupported
    echo 'Platform not supported, aborting...'
    exit
fi

# Fetch LuaMongo driver
cd /tmp/
git clone https://github.com/clementfarabet/luamongo.git
cd luamongo
git checkout master
git pull

# Build and install latest MongoDB - with shared client
git clone https://github.com/mongodb/mongo.git
cd mongo
git checkout v2.4
git pull
git apply ../mongo_v2.4_sharedclient.patch
if [[ `uname` == 'Darwin' ]]; then
    scons --full --sharedclient install
elif [[ `uname` == 'Linux' ]]; then
    sudo scons --full --sharedclient install
fi

# Build Lua Driver (uses the client above)
cd /tmp/luamongo
make
if [[ `uname` == 'Darwin' ]]; then
    make install
elif [[ `uname` == 'Linux' ]]; then
    sudo make install
fi
