# setup jupyter hub to connect to spark

```
apt-get update
apt install wget procps default-jdk unzip less

pip install pyspark==3.3.1

cd /usr/local/lib/python3.9/site-packages/pyspark/jars/
wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar
wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.901/aws-java-sdk-bundle-1.11.901.jar


aws s3 cp s3://udacity-dsnd/sparkify/mini_sparkify_event_data.json .
aws s3 cp s3://udacity-dsnd/sparkify/sparkify_event_data.json .

mkdir -p ~/temp
cd ~/temp
wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" 
unzip awscli-exe-linux-x86_64.zip 
./aws/install 
aws --version
aws configure
aws sts get-caller-identity
```

```
spark = SparkSession.builder.master("spark://bit-spark-master-svc.spark.svc.cluster.local:7077").config("spark.hadoop.fs.s3a.access.key", AWS_ACCESS_KEY_ID).config("spark.hadoop.fs.s3a.secret.key", AWS_SECRET_ACCESS_KEY).config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem").appName("FerisSparkSession").getOrCreate()
```

