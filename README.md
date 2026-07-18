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
![alt text](https://github.com/rionurfadilah229/ELT-Pipeline/blob/202999afb953b1d8e9cc1811978b003ed8d8823f/Screenshot%20(2251).png)
![alt text](https://github.com/rionurfadilah229/ELT-Pipeline/blob/202999afb953b1d8e9cc1811978b003ed8d8823f/Screenshot%20(2253).png)

If either DAG fails, this query would return no rows or an error — so a populated result like the one below is direct evidence that the full pipeline ran end-to-end successfully.

![alt text](https://github.com/rionurfadilah229/ELT-Pipeline/blob/202999afb953b1d8e9cc1811978b003ed8d8823f/Screenshot%20(2488).png)
![alt text](https://github.com/rionurfadilah229/ELT-Pipeline/blob/202999afb953b1d8e9cc1811978b003ed8d8823f/Screenshot%20(2520).png)
![alt text](https://github.com/rionurfadilah229/ELT-Pipeline/blob/202999afb953b1d8e9cc1811978b003ed8d8823f/Screenshot%202026-07-18%20232344.png)


This repository is designed to demonstrate a practical ELT workflow for modern data engineering, with orchestration, warehouse loading, and SQL-driven transformation in a clean and maintainable structure.
