# A Lua driver for mongodb

Forked from [http://github.com/moai/luamongo](moai)'s repo.

## Easy Install

C.Farabet: changed Makefile to build against Torch7. Added script to automate build
on MacOS and Ubuntu (MongoDB + Lua Driver). This script can be executed like this:

    curl -s https://raw.github.com/clementfarabet/luamongo/master/install_mongo+luamongo.sh | bash

(On MacOS, the sript assumes Homebrew is installed).

Note: Mongo 2.4 is built from the sources, with a patch that allows building the client
as a shared library.

## Wiki Documentation

 * <a href="https://github.com/moai/luamongo/wiki/Bsontypes">BsonTypes</a>

 * <a href="https://github.com/moai/luamongo/wiki/Helperfunctions">HelperFunctions</a>

 * <a href="https://github.com/moai/luamongo/wiki/GridFS">GridFS</a>

 * <a href="https://github.com/moai/luamongo/wiki/MongoConnection">MongoConnection</a> - START HERE

 * <a href="https://github.com/moai/luamongo/wiki/MongoReplicaSet">MongoReplicaSet</a>

 * <a href="https://github.com/moai/luamongo/wiki/MongoCursor">MongoCursor</a>

## Support

Submit issues to the <a href="https://github.com/moai/luamongo/issues">moai github site</a>.

There is a <a href="http://groups.google.com/group/luamongo">Google Groups mailing list</a>.

## Example

    require('mongo')

    -- Create a connection object
    local db = assert(mongo.Connection.New())

    -- connect to the server on localhost
    assert(db:connect('localhost'))

    -- insert a value into the namespace 'test.values'
    assert(db:insert('test.values', {a = 10, b = 'str1'}))

    -- the same using a JSON string
    assert(db:insert('test.values', "{'a': 20, 'b': 'str2'}"))

    -- insert a multiple values into the namespace 'test.values'
    assert(db:insert_batch('test.values', {{a = 10, b = 'str1'}, {c = 11, d = 'str2'}}))

    -- print the number of rows in the namespace 'test.values'
    print(db:count('test.values'))

    -- query all the values in the namespace 'test.values'
    local q = assert(db:query('test.values', {}))

    -- loop through the result set
    for result in q:results() do
            print(result.a)
            print(result.b)
    end


## How It Works

luamongo is a Lua library that wraps the <a href="https://github.com/mongodb/mongo/blob/master/src/mongo/client/dbclient.h">mongodb C++ API</a>.

The current implementation does not give you raw access to the BSON objects.  BSON objects are passed to the API using a Lua table or a JSON string representation.  Every returned BSON document is fully marshalled to a Lua table.

## History

This project was forked from the <a href="http://code.google.com/p/luamongo/">luamongo project</a> on googlecode.

