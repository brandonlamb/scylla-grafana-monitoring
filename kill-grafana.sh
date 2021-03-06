#!/usr/bin/env bash

usage="$(basename "$0") [-h] [-g grafana port ] -- kills existing Grafana Docker instances at given ports"

while getopts ':hg:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    g) GRAFANA_PORT=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done

if [ -z $GRAFANA_PORT ]; then
    GRAFANA_NAME=agraf
else
    GRAFANA_NAME=agraf-$GRAFANA_PORT
fi

if [ "$(docker ps -q -f name=$GRAFANA_NAME)" ]; then
    docker kill $GRAFANA_NAME
fi

if [[ "$(docker  ps -aq --filter name=$GRAFANA_NAME 2> /dev/null)" != "" ]]; then
    docker rm -v $GRAFANA_NAME
fi
