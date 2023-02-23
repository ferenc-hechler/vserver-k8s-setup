# setup neccessary packages

```
apt-get update
apt install procps wget default-jdk

pip install -U numpy pyspark==3.3.2

cd /usr/local/lib/python3.9/site-packages/pyspark/jars
wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar
wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar

```

# problem

```
Spark Executor Command: "/opt/bitnami/java/bin/java" "-cp" "/opt/bitnami/spark/conf/:/opt/bitnami/spark/jars/*" "-Xmx1024M" "-Dspark.driver.port=42427" "-XX:+IgnoreUnrecognizedVMOptions" "--add-opens=java.base/java.lang=ALL-UNNAMED" "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED" "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED" "--add-opens=java.base/java.io=ALL-UNNAMED" "--add-opens=java.base/java.net=ALL-UNNAMED" "--add-opens=java.base/java.nio=ALL-UNNAMED" "--add-opens=java.base/java.util=ALL-UNNAMED" "--add-opens=java.base/java.util.concurrent=ALL-UNNAMED" "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED" "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED" "--add-opens=java.base/sun.nio.cs=ALL-UNNAMED" "--add-opens=java.base/sun.security.action=ALL-UNNAMED" "--add-opens=java.base/sun.util.calendar=ALL-UNNAMED" "--add-opens=java.security.jgss/sun.security.krb5=ALL-UNNAMED" "org.apache.spark.executor.CoarseGrainedExecutorBackend" "--driver-url" "spark://CoarseGrainedScheduler@jupyter-feri:42427" "--executor-id" "247" "--hostname" "10.244.0.35" "--cores" "6" "--app-id" "app-20230223145252-0023" "--worker-url" "spark://Worker@10.244.0.35:34647"
========================================

Using Spark's default log4j profile: org/apache/spark/log4j2-defaults.properties
Exception in thread "main" java.lang.reflect.UndeclaredThrowableException
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1894)
	at org.apache.spark.deploy.SparkHadoopUtil.runAsSparkUser(SparkHadoopUtil.scala:61)
	at org.apache.spark.executor.CoarseGrainedExecutorBackend$.run(CoarseGrainedExecutorBackend.scala:424)
	at org.apache.spark.executor.CoarseGrainedExecutorBackend$.main(CoarseGrainedExecutorBackend.scala:413)
	at org.apache.spark.executor.CoarseGrainedExecutorBackend.main(CoarseGrainedExecutorBackend.scala)
Caused by: org.apache.spark.SparkException: Exception thrown in awaitResult: 
	at org.apache.spark.util.ThreadUtils$.awaitResult(ThreadUtils.scala:301)
	at org.apache.spark.rpc.RpcTimeout.awaitResult(RpcTimeout.scala:75)
	at org.apache.spark.rpc.RpcEnv.setupEndpointRefByURI(RpcEnv.scala:102)
	at org.apache.spark.executor.CoarseGrainedExecutorBackend$.$anonfun$run$9(CoarseGrainedExecutorBackend.scala:444)
	at scala.runtime.java8.JFunction1$mcVI$sp.apply(JFunction1$mcVI$sp.java:23)
	at scala.collection.TraversableLike$WithFilter.$anonfun$foreach$1(TraversableLike.scala:985)
	at scala.collection.immutable.Range.foreach(Range.scala:158)
	at scala.collection.TraversableLike$WithFilter.foreach(TraversableLike.scala:984)
	at org.apache.spark.executor.CoarseGrainedExecutorBackend$.$anonfun$run$7(CoarseGrainedExecutorBackend.scala:442)
	at org.apache.spark.deploy.SparkHadoopUtil$$anon$1.run(SparkHadoopUtil.scala:62)
	at org.apache.spark.deploy.SparkHadoopUtil$$anon$1.run(SparkHadoopUtil.scala:61)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:422)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1878)
	... 4 more
Caused by: java.io.IOException: Failed to connect to jupyter-feri:42427
	at org.apache.spark.network.client.TransportClientFactory.createClient(TransportClientFactory.java:288)
	at org.apache.spark.network.client.TransportClientFactory.createClient(TransportClientFactory.java:218)
	at org.apache.spark.network.client.TransportClientFactory.createClient(TransportClientFactory.java:230)
	at org.apache.spark.rpc.netty.NettyRpcEnv.createClient(NettyRpcEnv.scala:204)
	at org.apache.spark.rpc.netty.Outbox$$anon$1.call(Outbox.scala:202)
	at org.apache.spark.rpc.netty.Outbox$$anon$1.call(Outbox.scala:198)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:750)
Caused by: java.net.UnknownHostException: jupyter-feri
	at java.net.InetAddress$CachedAddresses.get(InetAddress.java:764)
	at java.net.InetAddress.getAllByName0(InetAddress.java:1282)
	at java.net.InetAddress.getAllByName(InetAddress.java:1140)
	at java.net.InetAddress.getAllByName(InetAddress.java:1064)
	at java.net.InetAddress.getByName(InetAddress.java:1014)
	at io.netty.util.internal.SocketUtils$8.run(SocketUtils.java:156)
	at io.netty.util.internal.SocketUtils$8.run(SocketUtils.java:153)
	at java.security.AccessController.doPrivileged(Native Method)
	at io.netty.util.internal.SocketUtils.addressByName(SocketUtils.java:153)
	at io.netty.resolver.DefaultNameResolver.doResolve(DefaultNameResolver.java:41)
	at io.netty.resolver.SimpleNameResolver.resolve(SimpleNameResolver.java:61)
	at io.netty.resolver.SimpleNameResolver.resolve(SimpleNameResolver.java:53)
	at io.netty.resolver.InetSocketAddressResolver.doResolve(InetSocketAddressResolver.java:55)
	at io.netty.resolver.InetSocketAddressResolver.doResolve(InetSocketAddressResolver.java:31)
	at io.netty.resolver.AbstractAddressResolver.resolve(AbstractAddressResolver.java:106)
	at io.netty.bootstrap.Bootstrap.doResolveAndConnect0(Bootstrap.java:206)
	at io.netty.bootstrap.Bootstrap.access$000(Bootstrap.java:46)
	at io.netty.bootstrap.Bootstrap$1.operationComplete(Bootstrap.java:180)
	at io.netty.bootstrap.Bootstrap$1.operationComplete(Bootstrap.java:166)
	at io.netty.util.concurrent.DefaultPromise.notifyListener0(DefaultPromise.java:578)
	at io.netty.util.concurrent.DefaultPromise.notifyListenersNow(DefaultPromise.java:552)
	at io.netty.util.concurrent.DefaultPromise.notifyListeners(DefaultPromise.java:491)
	at io.netty.util.concurrent.DefaultPromise.setValue0(DefaultPromise.java:616)
	at io.netty.util.concurrent.DefaultPromise.setSuccess0(DefaultPromise.java:605)
	at io.netty.util.concurrent.DefaultPromise.trySuccess(DefaultPromise.java:104)
	at io.netty.channel.DefaultChannelPromise.trySuccess(DefaultChannelPromise.java:84)
	at io.netty.channel.AbstractChannel$AbstractUnsafe.safeSetSuccess(AbstractChannel.java:990)
	at io.netty.channel.AbstractChannel$AbstractUnsafe.register0(AbstractChannel.java:516)
	at io.netty.channel.AbstractChannel$AbstractUnsafe.access$200(AbstractChannel.java:429)
	at io.netty.channel.AbstractChannel$AbstractUnsafe$1.run(AbstractChannel.java:486)
	at io.netty.util.concurrent.AbstractEventExecutor.safeExecute(AbstractEventExecutor.java:164)
	at io.netty.util.concurrent.SingleThreadEventExecutor.runAllTasks(SingleThreadEventExecutor.java:469)
	at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:503)
	at io.netty.util.concurrent.SingleThreadEventExecutor$4.run(SingleThreadEventExecutor.java:986)
	at io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
	at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
	... 1 more
```	