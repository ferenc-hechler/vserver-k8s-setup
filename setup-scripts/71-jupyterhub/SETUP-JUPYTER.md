# Setup Jupyter lab 

## persist conda env

Set conda env to persisted workspace volume (/home/jupyter)

```
$ vi ~/.condarc
```

```
envs_dirs:
- /home/jovyan/.condaenvs
```

## create env for python 3.8

```
conda create --name py38 python==3.8
  conda init bash
  bash
conda activate py38
pip install pyspark==3.3.2 cryptography numpy ipykernel
python -m ipykernel install --user --name=py38
```

## install s3 jars

TODO: make persistent

```
cd /usr/local/spark-3.3.2-bin-hadoop3/jars/
sudo wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar
sudo wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar
```


# start py38 notebook

```
import pyspark
from pyspark.sql import SparkSession
from pyspark import SparkConf, SparkContext
from cryptography.fernet import Fernet
import base64
import socket
import os

OWN_IP=socket.gethostbyname(socket.gethostname())
#os.environ["HOSTNAME"]="10.244.0.86"
os.environ["SPARK_LOCAL_IP"]=OWN_IP
!echo $SPARK_LOCAL_IP
```

```
AWS_ACCESS_KEY_ID='AKIAYGAQNRJ6BF5ZXRBV'
AWS_SECRET_ACCESS_KEY_ENC='gAAAAABj9-WHrLBDqR8Pp3wFNx8TpKzDg25NsLTxHUh7XsgrvvwiQkVCW0ASyZdj6lj3IF7AUTkTZJGtYoWKNC1vXuA6FAmVyXVmZLqOeisXJBKD1eBxgOePtkh1zGk1_YnfmRjypnhI'
AWS_SECRET_ACCESS_KEY = Fernet(base64.b64encode((socket.gethostname()*32)[:32].encode('ascii')).decode('ascii')).decrypt(AWS_SECRET_ACCESS_KEY_ENC.encode('ascii')).decode('ascii')
AWS_DEFAULT_REGION='eu-central-1'

os.environ['AWS_ACCESS_KEY_ID']=AWS_ACCESS_KEY_ID
os.environ['AWS_SECRET_ACCESS_KEY']=AWS_SECRET_ACCESS_KEY
os.environ['AWS_DEFAULT_REGION']=AWS_DEFAULT_REGION
```

```
spark = SparkSession.builder.master("spark://bit-spark-master-svc.spark.svc.cluster.local:7077").config("spark.driver.host", OWN_IP).config("spark.hadoop.fs.s3a.access.key", AWS_ACCESS_KEY_ID).config("spark.hadoop.fs.s3a.secret.key", AWS_SECRET_ACCESS_KEY).config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem").appName("FerisSparkSession").getOrCreate()
```

```
sc = spark.sparkContext
#sc.setLogLevel("DEBUG")
sc.setLogLevel("WARN")

spark.version
```

```
from pyspark.sql import SparkSession

# TODOS: 
# 1) import any other libraries you might need
from pyspark.ml.feature import RegexTokenizer, VectorAssembler, Normalizer, StandardScaler, MinMaxScaler
from pyspark.ml.regression import LinearRegression
from pyspark.sql.functions import concat, col, lit, udf
from pyspark.sql.types import IntegerType

# 2) run the cells below to read the dataset and extract description length features
# 3) write code to answer the quiz questions
```

```
stack_overflow_data = "s3a://feris-udacity-spark-project/stackexchange/Train_onetag_small.json"
df = spark.read.json(stack_overflow_data)
df.persist()
```

```
df.schema
```

```
df.take(1)
```

```
df = df.withColumn("Desc", concat(col("Title"), lit(' '), col("Body")))
```

```
body_length = udf(lambda x: len(x), IntegerType())
df = df.drop(col("words"))

regexTokenizer = RegexTokenizer(inputCol="Desc", outputCol="words", pattern="\\W")
df = regexTokenizer.transform(df)
df = df.withColumn("DescLength", body_length(df.words))
```

```
assembler = VectorAssembler(inputCols=["DescLength"], outputCol="DescVec")
df = assembler.transform(df)
```

```
# TODO: write your code to answer this question
from pyspark.sql.functions import min, max
minmax = df.select(min("DescLength"), max("DescLength")).collect()[0]
print(minmax[1]/minmax[0])
```

```
# TODO: write your code to answer this question
from pyspark.sql.functions import avg, stddev
meanstd = df.select(avg("DescLength"), stddev("DescLength")).collect()[0]
print(f"meanstd: {meanstd[0]}, stddev: {meanstd[1]}")
```

```
# TODO: write your code to answer this question
import time

from pyspark.ml.clustering import KMeans
from pyspark.ml.evaluation import ClusteringEvaluator

silhouette_score=[]

df = df.drop(col("DescGroup"))

KMeans_algo = KMeans(featuresCol='DescVec', predictionCol="DescGroup", k=5, seed=42)
start = time.perf_counter()
KMeans_fit = KMeans_algo.fit(df)
df = KMeans_fit.transform(df)
stop = time.perf_counter()
print(f'{stop-start}s')

df.head()
```

```
word_counts = udf(lambda x: len(x.split(" ")), IntegerType())
df = df.withColumn("NumTags", word_counts(df.Tags))
```

```
from pyspark.sql.functions import count
df.groupby("DescGroup").agg(avg(col("DescLength")), avg(col("NumTags")), count(col("DescLength"))).orderBy("avg(DescLength)").show()
```

```
df.where(df.DescGroup == 3).sort("DescLength").count()
```

```
df3s=df.where(df.DescGroup == 3).sort("DescLength")
```

```
df3s.persist()
```

```
KMeans_fit.clusterCenters()
```

```
spark.stop()
```

