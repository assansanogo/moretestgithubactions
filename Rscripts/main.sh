#!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

output_text=$(ls -l ./out)

echo $output_text

echo "::set-output name=summarized::$output_text"
