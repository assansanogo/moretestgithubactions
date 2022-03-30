#!/bin/sh -l


Rscript --vanilla /app/reporter.r

output_path=$(find ./out/*.csv)

output_text=$(cat $output_path)

echo "::set-output name=summarized::$output_text"
