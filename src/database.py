from configparser import ConfigParser

import mysql


def get_db_connection():
    config = ConfigParser()
    config.read('config.ini')

    try:
        return mysql.connector.connect(
            host=config['database']['host'],
            user=config['database']['user'],
            password=config['database']['password'],
            database=config['database']['database']
        )
    except mysql.connector.Error as err:
        print(f"Error connecting to the database: {err}")
        return None
