#!/bin/sh -l


Rscript --vanilla /app/reporter.r "03-04-2021" TRUE US

output_path=$(find ./out/*.csv)

output_text=$(cat $output_path)

echo "::set-output name=summarized::$output_text"
