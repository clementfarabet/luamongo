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
    brew checkout c65892f /usr/local/Library/Formula/boost.rb
    brew remove boost
    brew install boost

    # Get SCons
    brew install scons
else
    # Unsupported
    echo '==> platform not supported, aborting (only supporting MacOS for now)'
    exit
fi

# Clone repos
cd /tmp/
mkdir mongostuff; cd mongostuff
git clone https://github.com/mongodb/mongo.git
git clone https://github.com/clementfarabet/luamongo.git

# Build Mongo
cd mongo
scons all
scons all install

# Build Lua Driver
cd ../luamongo
make
make install
