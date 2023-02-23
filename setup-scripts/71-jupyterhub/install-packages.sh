#!/bin/sh

set -xe

apt-get update
apt install -y vim procps wget default-jdk

pip install --no-input -U numpy pyspark==3.3.2

cd /usr/local/lib/python3.9/site-packages/pyspark/jars
wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar
wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar

