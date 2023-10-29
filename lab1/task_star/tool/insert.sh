#!/bin/sh

# Call it only if you have my_container and it is running now!
FALLBACK_NAME="TEST"
FALLBACK_SIZE=10

STAR_NAME=$1
if [ -z "$STAR_NAME" ]; then
  echo "STAR_NAME is not set, setting $FALLBACK_NAME"
  STAR_NAME=$FALLBACK_NAME
else
  echo "STAR_NAME is set to $STAR_NAME"
fi

STAR_SIZE=$2
if [ -z "$STAR_SIZE" ]; then
  echo "STAR_SIZE is not set, setting $FALLBACK_SIZE"
  STAR_SIZE=$FALLBACK_SIZE
else
  echo "STAR_SIZE is set to $STAR_SIZE"
fi

docker-compose exec lab1 psql -U postgres \
  -c "\c cloud_lab1_db; \dt;" \
  -c "INSERT INTO stars (name, size) VALUES ('$STAR_NAME', $STAR_SIZE);"
