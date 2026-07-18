### ELT Pipeline: PostgreSQL → Airflow → dbt
A containerized ELT (Extract-Load-Transform) pipeline that moves transactional data from a source database into a destination database, then transforms it into analytics-ready tables using dbt — fully orchestrated with Apache Airflow.


### architecture
-source_postgres : simulates an OLTP database with customers, products, and transaction_items tables.
-destination_postgres : target warehouse where raw data is loaded and later transformed.
-Airflow that orchestrates two DAGs: one for extract+load (pg_dump/psql), one for transformation.
-dbt (run via DockerOperator) : transforms raw loaded data into clean, analytics-ready models.


### Tech Stack
Orchestration : Apache Airflow 2.9.2
Database : PostgreSQL 13
Transformation : dbt (dbt-postgres)
Containerization : Docker & Docker Compose
Language : Python (extraction script), SQL (dbt models)


### How to Run this project
-Open a terminal in the project root.
-Start the services with Docker Compose with #docker compose up -d 
-Wait until the containers are healthy and the Airflow services are ready.
-Open the Airflow UI in your browser: - http://localhost:8080
-Trigger the DAG from the Airflow web interface.
-Run the dbt transformation workflow after the load step completes.


### Sql output for desired needs
This output is only possible after both DAGs succeed: dag_load_and_transfer moves raw data from source_postgres into destination_postgres, and dag_dbt transforms it into analytics-ready tables.
-dag_id         : dag_load_and_transfer
-run_id         : manual__2026-07-18T15:22:01.284340+00:00
-state          : success
-execution_date : 2026-07-18T15:22:01.284340+00:00
-start_date     : 2026-07-18T15:22:02.178046+00:00 
-end_date       : 2026-07-18T15:22:10.581618+00:00 

-dag_id         : dag_dbt
-run_id         : manual__2026-07-18T15:32:41.032641+00:00
-state          : success
-execution_date : 2026-07-18T15:22:01.284340+00:00    
-start_date     : 2026-07-18T15:22:02.178046+00:00
-end_date       : 2026-07-18T15:22:10.581618+00:00

If either DAG fails, this query would return no rows or an error — so a populated result like the one below is direct evidence that the full pipeline ran end-to-end successfully.

destination_db=# SELECT
    customer_id,
    customer_name,
    SUM(total_price) AS total_belanja
FROM denormalized_table
GROUP BY customer_id, customer_name
ORDER BY total_belanja DESC
LIMIT 10;
 customer_id | customer_name | total_belanja 
-------------+---------------+---------------
           5 | Lina          |     128000.00
           8 | Yudi          |     109000.00
           4 | Budi          |     108000.00
           3 | Sari          |     103000.00
           2 | Andi          |      76000.00
           6 | Dika          |      57000.00
           1 | Rina          |      40000.00
           7 | Eka           |      31000.00
          10 | Tono          |      27000.00
           9 | Nina          |      25000.00
(10 rows)

destination_db=# SELECT
    product_id,
    product_name,
    COUNT(*) AS jumlah_transaksi
FROM denormalized_table
GROUP BY product_id, product_name
ORDER BY jumlah_transaksi DESC
LIMIT 10;
 product_id |   product_name   | jumlah_transaksi 
------------+------------------+------------------
          3 | Pasta Gigi       |                6
          2 | Shampoo          |                5
          1 | Sabun Mandi      |                5
          4 | Sikat Gigi       |                4
          5 | Minyak Goreng 1L |                4
          6 | Beras 5kg        |                4
         10 | Mie Instan       |                4
          7 | Gula Pasir 1kg   |                3
          9 | Teh Celup        |                3
          8 | Kopi Instan      |                2
(10 rows)

destination_db=# SELECT
    transaction_date,
    COUNT(*) AS jumlah_transaksi
FROM denormalized_table
GROUP BY transaction_date
ORDER BY jumlah_transaksi DESC
LIMIT 10;
 transaction_date | jumlah_transaksi 
------------------+------------------
 2025-05-04       |               10
 2025-05-06       |                9
 2025-05-03       |                8
 2025-05-02       |                5
 2025-05-05       |                4
 2025-05-01       |                4
(6 rows)

destination_db=# SELECT
    COUNT(*) AS total_record,
    COUNT(DISTINCT customer_id) AS total_customer,
    COUNT(DISTINCT product_id) AS total_product,
    MIN(transaction_date) AS earliest_date,
    MAX(transaction_date) AS latest_date
FROM denormalized_table;
 total_record | total_customer | total_product | earliest_date | latest_date 
--------------+----------------+---------------+---------------+-------------
           40 |             10 |            10 | 2025-05-01    | 2025-05-06
(1 row)


This repository is designed to demonstrate a practical ELT workflow for modern data engineering, with orchestration, warehouse loading, and SQL-driven transformation in a clean and maintainable structure.