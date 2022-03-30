!/bin/sh -l

Rscript --vanilla reporter.r "$DATE" "$AGGREGATION" "$COUNTRY"

output_text=cat $(ls *.csv)

echo "::set-output name=summarized::$output_text"