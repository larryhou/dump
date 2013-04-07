#!/bin/bash
mxmlc="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/mxmlc"

clear
echo "Wanna build debug version?"
read debug

main=CodeModule.as
output=module.swf

if [ "$debug" = "true" ] || [ "$debug" = "yes" ] || [ "$debug" = "y" ] || [ "$debug" = "t" ];
then
	"$mxmlc"	\
	-static-link-runtime-shared-libraries	\
	-source-path+=../../../larrio/greensock	\
	-source-path+=../../demos	\
	-source-path+=../../src	\
	-file-specs=$main	\
	-output=$output	\
	-debug
else
	"$mxmlc"	\
	-static-link-runtime-shared-libraries	\
	-source-path+=../../../larrio/greensock	\
	-source-path+=../../demos	\
	-source-path+=../../src	\
	-file-specs=$main	\
	-output=$output
fi