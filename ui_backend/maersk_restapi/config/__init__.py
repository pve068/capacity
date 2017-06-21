import os

class ApiConfig:

   @staticmethod
   def alchemy_connection():
       server = os.environ.get('CAPACITY_DBMS_SERVER')
       database = os.environ.get('CAPACITY_DBMS_DATABASE')
       driver = os.environ.get('CAPACITY_DBMS_DRIVER')
       user = os.environ.get('CAPACITY_DBMS_USER')
       pwd = os.environ.get('CAPACITY_DBMS_PASSWORD')
       conn_string = "mssql+pyodbc://"+user+':'+pwd+'@'+server+"/"+database+"?driver="+driver
       return conn_string

