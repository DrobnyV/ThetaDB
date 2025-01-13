# /src/database.py

import mysql.connector
from mysql.connector import Error
import configparser


class DatabaseConnection:
    def __init__(self, config_file='../config.ini'):
        self.config = configparser.ConfigParser()
        self.config.read(config_file)
        self.host = self.config['database']['host']
        self.user = self.config['database']['user']
        self.password = self.config['database']['password']
        self.database = self.config['database']['database']
        self.connection = None

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database
            )
            if self.connection.is_connected():
                print("Úspěšně připojeno k MySQL databázi")
        except Error as e:
            print(f"Chyba při připojování k MySQL databázi: {e}")

    def disconnect(self):
        if self.connection.is_connected():
            self.connection.close()
            print("Spojení s databází bylo ukončeno")

    def get_connection(self):
        return self.connection

# Příklady použítí:
connection = DatabaseConnection()
connection.connect()
connection.disconnect()