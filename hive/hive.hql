CREATE DATABASE IF NOT EXISTS crash_warehouse;

USE crash_warehouse;

CREATE TABLE IF NOT EXISTS FACT_CRASH
(
    event_id          STRING PRIMARY KEY,
    platform          STRING,
    error_type        STRING,
    issue_title       STRING,
    issue_subtitle    STRING,
    process_state     STRING,
    installation_uuid STRING,
    project_name      STRING,
    date_key          INT,
    device_id         INT,
    os_id             INT,
    app_id            INT
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/fact_crash'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS DIM_APP
(
    app_id          INT PRIMARY KEY,
    build_version   STRING,
    display_version STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_app'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS DIM_DATE
(
    date_key        INT PRIMARY KEY,
    day             DATE,
    day_of_the_week STRING,
    week            INT,
    month           INT,
    year            INT
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_date'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS DIM_DEVICE
(
    device_id    INT PRIMARY KEY,
    manufacturer STRING,
    model        STRING,
    architecture STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_device'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS DIM_OS
(
    os_id              INT PRIMARY KEY,
    display_version    STRING,
    name               STRING,
    modification_state STRING,
    device_type        STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_os'
    TBLPROPERTIES ("skip.header.line.count" = "1");