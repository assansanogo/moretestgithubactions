#!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"


Rscript --vanilla saver.r "$PROCESSED_REPORT_PATH" "$TOTAL_REPORT_PATH" "$OUTPUT_REPORT_PATH"
