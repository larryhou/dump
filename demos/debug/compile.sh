#!/bin/bash
MXMLC="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/mxmlc"
"${MXMLC}"	\
-static-link-runtime-shared-libraries	\
-source-path+=../../../larrio/greensock	\
-source-path+=../../demos	\
-source-path+=../../src	\
-file-specs=FileMain.as	\
-output=FileMain.swf	\
-debug