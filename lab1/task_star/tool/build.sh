#!/bin/sh

# If you don't have a my_container, call it!
docker compose -f ../docker-compose.yml up --build -d &&
  echo "Waiting for Docker to TOTALLY come built ..." &&
  sleep 5

# Insert variables from command line
/bin/sh insert.sh "$1" "$2"
