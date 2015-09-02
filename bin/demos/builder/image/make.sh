#!/bin/bash
cd $(dirname $0)

mxmlc="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/mxmlc"
clear

main=classes/BitmapDataClass.as
output=classes/class.swf

"$mxmlc"	\
-static-link-runtime-shared-libraries	\
-source-path+=../../../../samples	\
-source-path+=../../../../src	\
-file-specs=$main	\
-optimize=false \
-output=$output	\
-debug=false