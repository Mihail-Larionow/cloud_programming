#!/bin/sh

# Call this script when you already have my_container.

# Start container
docker start my_container

# Call insert
/bin/sh insert.sh "$1" "$2"
