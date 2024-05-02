# Apache Spark

https://bitnami.com/stack/spark/helm

```
ferenc@vmd38168:~$ helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" already exists with the same configuration, skipping
ferenc@vmd38168:~$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "openebs" chart repository
...Successfully got an update from the "codecentric" chart repository
...Successfully got an update from the "jetstack" chart repository
...Successfully got an update from the "incubator" chart repository
...Successfully got an update from the "bitnami" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈

ferenc@vmd38168:~$ kubectl create namespace spark
namespace/spark created

ferenc@vmd38168:~$ helm install -n spark bit-spark bitnami/spark
NAME: bit-spark
LAST DEPLOYED: Tue Feb 14 19:19:01 2023
NAMESPACE: spark
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: spark
CHART VERSION: 6.3.16
APP VERSION: 3.3.1

** Please be patient while the chart is being deployed **

1. Get the Spark master WebUI URL by running these commands:

  kubectl port-forward --namespace spark svc/bit-spark-master-svc 80:80
  echo "Visit http://127.0.0.1:80 to use your application"

2. Submit an application to the cluster:

  To submit an application to the cluster the spark-submit script must be used. That script can be
  obtained at https://github.com/apache/spark/tree/master/bin. Also you can use kubectl run.

  export EXAMPLE_JAR=$(kubectl exec -ti --namespace spark bit-spark-worker-0 -- find examples/jars/ -name 'spark-example*\.jar' | tr -d '\r')

  kubectl exec -ti --namespace spark bit-spark-worker-0 -- spark-submit --master spark://bit-spark-master-svc:7077 \
    --class org.apache.spark.examples.SparkPi \
    $EXAMPLE_JAR 5

** IMPORTANT: When submit an application from outside the cluster service type should be set to the NodePort or LoadBalancer. **

** IMPORTANT: When submit an application the --master parameter should be set to the service IP, if not, the application will not resolve the master. **
```
