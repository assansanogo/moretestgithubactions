#!/bin/sh -l


Rscript --vanilla /app/reporter.r $placeholder $input_date $aggregation $country 

output_path=$(find ./out/*.csv)

output_text=$(cat $output_path)

echo "::set-output name=summarized::$output_text"
