#!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

echo "$PROCCESSED_REPORT_PATH"
echo "$TOTAL_REPORT_PATH"
echo "$OUTPUT_REPORT_PATH"

Rscript --vanilla saver.r "$PROCCESSED_REPORT_PATH" "$TOTAL_REPORT_PATH" "$OUTPUT_REPORT_PATH"
