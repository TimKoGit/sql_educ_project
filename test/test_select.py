import pandas as pd
import pytest
import psycopg2
import os
from pathlib import Path


@pytest.fixture(scope="session")
def postgresql_db():
    conn = psycopg2.connect(
        dbname="test_db",
        user="postgres",
        password="postgres",
        host="localhost"
    )
    yield conn
    conn.close()


def read_queries_from_file(filename):
    with open(filename, "r") as file:
        queries = file.read()
    return queries.split(";")[:-1]


def test_queries(postgresql_db):
    cursor = postgresql_db.cursor()
    script_directory = os.path.dirname(os.path.realpath(__file__))
    parent_directory = os.path.abspath(os.path.join(script_directory, ".."))
    sql_file_path = os.path.join(parent_directory, "scripts")
    ddl_path = os.path.join(sql_file_path, "ddl.sql")
    ddl_queries = read_queries_from_file(ddl_path)
    
    for query in ddl_queries:
        cursor.execute(query)
        
    inserts_path = os.path.join(sql_file_path, "inserts.sql")
    inserts_queries = read_queries_from_file(inserts_path)
    
    for query in inserts_queries:
        cursor.execute(query)    
        
    selects_path = os.path.join(sql_file_path, "select_queries.sql")
    select_queries = read_queries_from_file(selects_path)
    answer_path = os.path.join(script_directory, "answers")
    for i in range(10):
        cursor.execute(select_queries[i])
        colnames = [desc[0] for desc in cursor.description]
        df = pd.DataFrame(cursor.fetchall(), columns=colnames)
        select_path = os.path.join(answer_path, f"select{i + 1}.xlsx")
        right_df = pd.read_excel(select_path)
        assert df.equals(right_df)
    
