#!/bin/bash
mxmlc="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/mxmlc"
clear

main=RecursionModule.as
output=recursionModule.swf

"$mxmlc"	\
-static-link-runtime-shared-libraries	\
-default-script-limits 5 15	\
-source-path+=../../demos	\
-source-path+=../../src	\
-file-specs=$main	\
-output=$output	\
-debug

echo 

main=TimeoutModule.as
output=timeoutModule.swf

"$mxmlc"	\
-static-link-runtime-shared-libraries	\
-source-path+=../../demos	\
-source-path+=../../src	\
-file-specs=$main	\
-output=$output	\
-debug