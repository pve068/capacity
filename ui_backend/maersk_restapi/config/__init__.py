import configparser

class ApiConfig:

   @staticmethod
   def alchemy_connection():
       app_config = configparser.ConfigParser()
       app_config.read('config\config.ini')
       sqlserver = 'mssql-ra'
       server = app_config.get(sqlserver, 'server')
       database = app_config.get(sqlserver, 'database')
       driver = app_config.get(sqlserver, 'driver')
       conn_string = "mssql+pyodbc://"+server+"/"+database+"?driver="+driver
       return conn_string

