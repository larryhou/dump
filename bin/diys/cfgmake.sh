#!/bin/bash

find . -maxdepth 1 -mindepth 1 -iname '*.swf' | awk -F'/' '{print $NF}' | sort -n | while read file
do
	id=$(echo ${file} | awk -F'.' '{print $1}')
	echo -e "${id}\tdiys/${file}\t${id}"
done
