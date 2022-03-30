#!/bin/sh -l

Rscript --vanilla reporter.r $1 $2 $3

output_path=$(find ./out/*.csv)

output_text=$(cat $output_path)

echo "::set-output name=summarized::$output_text"
