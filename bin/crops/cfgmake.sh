#!/bin/bash

json=$(cat crops.json)

find . -maxdepth 1 -mindepth 1 -iname '*.swf' | awk -F'/' '{print $NF}' | sort -n | while read file
do
	id=$(echo ${file} | awk -F'.' '{print $1}')
	name=$(echo ${json} | jq ".crops[] | select(.id == ${id}) | .name" - | awk -F'"' '{print $2}')
	echo -e "${id}\tcrops/${file}\t${name}"
done
