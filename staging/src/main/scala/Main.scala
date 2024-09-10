//package dodat.spark

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._

object Main {
  def main(/*args: Array[String]*/): Unit = {
//    val spark = SparkSession.builder()
//      .appName("crash-staging")
//      .master("local")
//      .getOrCreate()

    val df = spark.read.format("parquet")
      .load("hdfs://namenode:9000/input/data")
      .withColumn("day", to_date(col("event_timestamp")))
      .na.drop()

//    df.show(truncate = false)

    val app_df = df.select(
        col("application").getField("build_version").alias("build_version"),
        col("application").getField("display_version").alias("display_version")
      ).distinct()
      .withColumn("app_id", monotonically_increasing_id()) // surrogate key
      .select("app_id", "build_version", "display_version")

    val date_df = df.select(col("day"))
      .withColumn("date_key", date_format(col("day"), "MMddyyyy").cast("integer")) // foreign key
      .withColumn("day_of_the_week", date_format(col("day"), "EEEE"))
      .withColumn("week", weekofyear(col("day")))
      .withColumn("month", month(col("day")))
      .withColumn("year", year(col("day")))
      .distinct()
      .select("date_key", "day", "day_of_the_week", "week", "month", "year")

    val devide_df = df.select(
        col("device").getField("manufacturer").alias("manufacturer"),
        col("device").getField("model").alias("model"),
        col("device").getField("architecture").alias("architecture")
      ).distinct()
      .withColumn("device_id", monotonically_increasing_id()) // surrogate key
      .select("device_id", "manufacturer", "model", "architecture")

    val os_df = df.select(
        col("operating_system").getField("display_version").alias("display_version"),
        col("operating_system").getField("name").alias("name"),
        col("operating_system").getField("modification_state").alias("modification_state"),
        col("operating_system").getField("device_type").alias("device_type")
      ).distinct()
      .withColumn("os_id", monotonically_increasing_id()) // surrogate key
      .select("os_id", "display_version", "name", "modification_state", "device_type")

    val fact_df = df
      .join(app_df, (df.col("application").getField("display_version") === app_df.col("display_version")) && (df.col("application").getField("build_version") === app_df.col("build_version")), "inner")
      .join(date_df, df.col("day") === date_df.col("day"), "inner")
      .join(devide_df, (df.col("device").getField("model") === devide_df.col("model")) && (df.col("device").getField("manufacturer") === devide_df.col("manufacturer")) && (df.col("device").getField("architecture") === devide_df.col("architecture")), "inner")
      .join(os_df, (df.col("operating_system").getField("display_version") === os_df.col("display_version")) && (df.col("operating_system").getField("modification_state") === os_df.col("modification_state")) && (df.col("operating_system").getField("name") === os_df.col("name")) && (df.col("operating_system").getField("device_type") === os_df.col("device_type")), "inner")
      .select(col("event_id"), col("platform"), col("error_type"), col("issue_title"), col("issue_subtitle"), col("process_state"), col("installation_uuid"), col("project_name"), col("date_key"), col("device_id"), col("os_id"), col("app_id"))

    // load to hdfs
    fact_df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://namenode:9000/output/fact_crash")
    app_df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://namenode:9000/output/dim_app")
    date_df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://namenode:9000/output/dim_date")
    devide_df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://namenode:9000/output/dim_device")
    os_df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://namenode:9000/output/dim_os")
  }
}