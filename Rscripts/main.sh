#!/bin/sh -l

#retrieving. data
Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

#consolidating data
Rscript --vanilla saver.r "$PROCESSED_REPORT_PATH" "$TOTAL_REPORT_PATH" "$OUTPUT_REPORT_PATH"

#simplify access errors when accessing the share repository
#from the host
chmod -R 777 $(pwd)
