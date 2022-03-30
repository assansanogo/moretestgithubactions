#!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

output_text=cat $(ls *.csv)

echo $output_text

echo "::set-output name=summarized::$output_text"
