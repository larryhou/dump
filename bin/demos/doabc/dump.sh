#!/bin/bash

sdk="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin"
clear

cd "${sdk}"
echo $(PWD)
read -p "input swf file: "

output="$(dirname $0)/result.txt"
./swfdump -abc "${REPLY}" | mate