DROP DATABASE IF EXISTS crash_warehouse;

CREATE DATABASE crash_warehouse;

USE crash_warehouse;

CREATE TABLE FACT_CRASH
(
    event_id          STRING,
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

CREATE TABLE DIM_APP
(
    app_id          INT,
    build_version   STRING,
    display_version STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_app'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE DIM_DATE
(
    date_key        INT,
    day             DATE,
    day_of_the_week STRING,
    week            INT,
    month           INT,
    year            INT
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_date'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE DIM_DEVICE
(
    device_id    INT,
    manufacturer STRING,
    model        STRING,
    architecture STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_device'
    TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE DIM_OS
(
    os_id              INT,
    display_version    STRING,
    name               STRING,
    modification_state STRING,
    device_type        STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION '/output/dim_os'
    TBLPROPERTIES ("skip.header.line.count" = "1");

SHOW TABLES;