# setup neccessary packages

```
apt-get update
apt install procps wget default-jdk

pip install -U numpy pyspark==3.3.2

cd /usr/local/lib/python3.9/site-packages/pyspark/jars
wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar
wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar

```

# patch coredns

add notebook jupyter-feri to CoreDNS:

```
JUPNB="jupyter-feri"
JFIP=$(kubectl get pod -n spark "$JUPNB" -oyaml -ojsonpath="{.status.podIP}")
DATA=".:53 {\n    errors\n    health {\n       lameduck 5s\n    }\n    rewrite name testdns1 hub.spark.svc.cluster.local\n    hosts {\n        ${JFIP} ${JUPNB}\n        fallthrough\n    }\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n       pods insecure\n       fallthrough in-addr.arpa ip6.arpa\n       ttl 30\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf {\n       max_concurrent 1000\n    }\n    cache 30\n    loop\n    reload\n    loadbalance\n}\n"
kubectl patch configmap -n kube-system coredns --patch "{\"data\": {\"Corefile\": \"${DATA}\"}}"
kubectl rollout restart deployment coredns -n kube-system
```

# install python 3.8

3.9 is not compatible with spark

https://www.linuxcapable.com/how-to-install-python-3-8-on-debian-11-bullseye/

```
wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tar.xz
tar -xf Python-3.8.12.tar.xz
mv Python-3.8.12 /opt/Python-3.8.12

apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev -y
#apt install -y gcc 

cd /opt/Python-3.8.12/
./configure --enable-optimizations --enable-shared --with-openssl

make

make altinstall
ldconfig /opt/Python-3.8.12

python3.8 --version

```

install jkernel

```
python3.8 -m venv ~/py38venv

source ~/py38venv/bin/activate

python3.8 -m pip install ipykernel
```

## recompile with ssl

```
apt-get install build-essential checkinstall libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
# libreadline-gplv2-dev 
./configure --enable-optimizations --enable-shared --with-openssl=/usr/bin/openssl
```

## error message from worker


```
Spark Executor Command: "/opt/bitnami/java/bin/java" "-cp" "/opt/bitnami/spark/conf/:/opt/bitnami/spark/jars/*" "-Xmx1024M" "-Dspark.driver.port=42427" "-XX:+IgnoreUnrecognizedVMOptions" "--add-opens=java.base/java.lang=ALL-UNNAMED" "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED" "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED" "--add-opens=java.base/java.io=ALL-UNNAMED" "--add-opens=java.base/java.net=ALL-UNNAMED" "--add-opens=java.base/java.nio=ALL-UNNAMED" "--add-opens=java.base/java.util=ALL-UNNAMED" "--add-opens=java.base/java.util.concurrent=ALL-UNNAMED" "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED" "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED" "--add-opens=java.base/sun.nio.cs=ALL-UNNAMED" "--add-opens=java.base/sun.security.action=ALL-UNNAMED" "--add-opens=java.base/sun.util.calendar=ALL-UNNAMED" "--add-opens=java.security.jgss/sun.security.krb5=ALL-UNNAMED" "org.apache.spark.executor.CoarseGrainedExecutorBackend" "--driver-url" "spark://CoarseGrainedScheduler@jupyter-feri:42427" "--executor-id" "247" "--hostname" "10.244.0.35" "--cores" "6" "--app-id" "app-20230223145252-0023" "--worker-url" "spark://Worker@10.244.0.35:34647"
========================================

Using Spark's default log4j profile: org/apache/spark/log4j2-defaults.properties
Exception in thread "main" java.lang.reflect.UndeclaredThrowableException
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1894)
  ...
Caused by: java.net.UnknownHostException: jupyter-feri
	...
```	