#!/bin/bash

usage()
{
    echo "usage: startup [[-f docker-compose-file] [-t timer in seconds]]"
}

t=10
f=docker-compose.yml

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                f=$1
                                ;;
        -t | --timer)           shift
                                t=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

docker-compose pull

docker-compose -f $f up -d postgres
echo "Database is initializing."

docker-compose -f $f up -d elasticsearch
echo "Elasticsearch is initializing."

docker-compose -f $f up -d virtuoso
docker-compose -f $f up -d piveau_virtuoso
echo "Virtuoso is initializing."

echo "Enable initialization. Sleeping for "${t}" seconds..."
sleep "${t}"

docker-compose -f $f up -d piveau-hub
echo "piveau hub is starting."

docker-compose -f $f up -d piveau-search
echo "piveau search is starting."

docker-compose -f $f up -d odb-manager
echo "odb-manager is starting..."

docker-compose -f $f up -d piveau-ui
echo "Frontend is starting..."

docker-compose -f $f up -d nginx
echo "Nginx is starting..."