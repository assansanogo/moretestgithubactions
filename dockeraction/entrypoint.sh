#!/bin/sh -l

echo $0
echo $1
echo $2

Rscript --vanilla /app/reporter.r $0 $1 $2

output_path=$(find ./out/*.csv)

output_text=$(cat $output_path)

echo "::set-output name=summarized::$output_text"
