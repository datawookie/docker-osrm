#!/bin/bash

DATAPATH=/data

PROFILE=profiles/car.lua

# Extract road network.
#
osrm-extract $DATAPATH/$1 -p $PROFILE

# Create the hierachy.
#
osrm-contract $DATAPATH/$1.osrm

# TODO: Try running osrm-datastore here. See https://github.com/Project-OSRM/osrm-backend/wiki/Configuring-and-using-Shared-Memory.

# Start server.
#
osrm-routed --max-table-size=100000 $DATAPATH/$1.osrm &

server=$!

_sig() {
  kill -TERM $server 2>/dev/null
}

trap _sig SIGKILL SIGTERM SIGHUP SIGINT EXIT

wait "$server"

rm $DATAPATH/$1.osrm*
