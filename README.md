# Data Pipeline for Analyzing Application Crash and Performance

## Setting up environment

Deploy the nifi-hdsf-spark-hive-superset cluster

    docker-compose up

## Putting data from local to HDFS using Apache NiFi

    http://localhost:8091/nifi/

## Run Spark job

Go to the command line of the Spark master and start spark-shell

    docker exec -it spark-master bash

    spark/bin/spark-shell --master spark://spark-master:7077

Load and run Spark job

    :load /spark/job/src/main/scala/Main.scala

    Main.main()

## Building Data Warehouse with Hive

![hive_schema.png](info%2Fhive_schema.png)

Go to the command line of the Hive server and run hive scripts

    docker exec -it hive-server bash

    hive -f /hive/scripts/hive.hql;

## Create report using Superset

Run `docker network inspect` on the network (e.g. `docker-hadoop-spark-hive_default`) to get hostname of Apache Hive (
used for connecting Superset)

Result: https://drive.google.com/file/d/1MrmS3WJZs1UoUKuLZeEbBPnV73nbZn11/view