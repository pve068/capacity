FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
  curl=7.47.0-1ubuntu2.2 \
  wget=1.17.1-1ubuntu1.2 \
  apt-transport-https=1.2.10ubuntu1 \
  python3=3.5.1-3 \
  python3-pip=8.1.1-2ubuntu0.4 \
  && curl -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl -s https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql.list \
  && apt-get update && ACCEPT_EULA=Y apt-get install -y \
       msodbcsql=13.1.4.0-1 \
       unixodbc=2.3.1-4.1 \
       unixodbc-dev=2.3.1-4.1 \
       locales=2.23-0ubuntu9
COPY requirements.txt /
RUN pip3 install -r requirements.txt \
  && pip3 install uwsgi==2.0.15 \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 \
COPY maersk_restapi/ maersk_restapi/
EXPOSE 5000
WORKDIR maersk_restapi/
CMD ["uwsgi", "--socket=0.0.0.0:5000", "--protocol=http", "--plugin=python", "--wsgi-file", "__init__.py", "--callable", "app"]
