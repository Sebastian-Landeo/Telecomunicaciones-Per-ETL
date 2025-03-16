# pip install mysql-connector-python
import mysql.connector
from decouple import config
user = config('DB_USER')
password = config('DB_PASSWORD')
host = config('DB_HOST')
database = config('DB_NAME')
port = config('DB_PORT')
conexion = mysql.connector.connect(user=user, password=password, 
                                   host=host, database=database, port=port)
print(conexion)