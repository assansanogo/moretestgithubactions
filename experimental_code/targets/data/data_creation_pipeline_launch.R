# dataset creation
airqual <- airquality

# dataset save to disk
write.csv(airqual, '/data/raw_data.csv')

# create the pipeline
tar_make()

#interact with elements of the pipeline
tar_read(histogram)
