#!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

echo $(ls .)


Rscript --vanilla saver.r "$PROCESSED_REPORT_PATH" "$TOTAL_REPORT_PATH" "$OUTPUT_REPORT_PATH"

chmod -R 777 $(pwd)
