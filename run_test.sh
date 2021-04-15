#!/bin/zsh

spark-3.0.0-bin-hadoop3.2/bin/spark-submit \
--master k8s://36BDA031119670885142D03102F6195D.yl4.ap-southeast-1.eks.amazonaws.com \
--deploy-mode cluster \
--name 'sparkonk8-test-0412-v1' \
--conf spark.eventLog.dir=s3a://blues-bucket/spark-k8s/logs \
--conf spark.eventLog.enabled=true \
--conf spark.history.fs.inProgressOptimization.enabled=true \
--conf spark.history.fs.update.interval=5s \
--conf spark.kubernetes.container.image=247461624575.dkr.ecr.ap-southeast-1.amazonaws.com/spark-k8-test-v2:numpy2 \
--conf spark.kubernetes.container.image.pullPolicy=IfNotPresent \
--conf spark.kubernetes.driver.podTemplateFile='eks_config/driver_pod_template.yml' \
--conf spark.kubernetes.executor.podTemplateFile='eks_config/executor_pod_template.yml' \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
--conf spark.dynamicAllocation.enabled=true \
--conf spark.dynamicAllocation.shuffleTracking.enabled=true \
--conf spark.dynamicAllocation.maxExecutors=100 \
--conf spark.dynamicAllocation.executorAllocationRatio=0.5 \
--conf spark.dynamicAllocation.sustainedSchedulerBacklogTimeout=30 \
--conf spark.dynamicAllocation.executorIdleTimeout=60s \
--conf spark.driver.memory=8g \
--conf spark.driver.extraJavaOptions='-Divy.cache.dir=/tmp -Divy.home=/tmp' \
--conf spark.kubernetes.driver.request.cores=2 \
--conf spark.kubernetes.driver.limit.cores=4 \
--conf spark.executor.memory=16g \
--conf spark.kubernetes.executor.request.cores=4 \
--conf spark.kubernetes.executor.limit.cores=32 \
--conf spark.jars.packages=org.apache.hadoop:hadoop-aws:3.2.0 \
--conf spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version=2 \
--conf spark.hadoop.mapreduce.fileoutputcommitter.cleanup-failures.ignored=true \
--conf spark.hadoop.fs.s3a.committer.name=directory \
--conf spark.hadoop.parquet.enable.summary-metadata=false \
--conf spark.sql.parquet.mergeSchema=false \
--conf spark.sql.parquet.filterPushdown=true \
--conf spark.sql.hive.metastorePartitionPruning=true \
--conf spark.executor.instances=2 \
s3a://blues-bucket/spark-k8s/test_script.py \
s3a://blues-bucket/spark-k8s/output_0414
