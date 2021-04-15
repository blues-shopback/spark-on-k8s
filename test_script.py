import sys
from pyspark.sql import SparkSession
from pyspark.sql import functions as F


spark = SparkSession.builder.getOrCreate()

output_path = sys.argv[1]

df = spark.read.parquet("s3a://amazon-reviews-pds/parquet/")
df = df.sample(0.01)
print(df.count())
print("write result to: {}".format(output_path))

(df
 .select(
    F.explode(F.split(F.lower(df.review_body), " ")).alias("words")
  )
 .groupBy("words").count()
 .write.parquet(output_path, mode="overwrite")
 )

exit()
