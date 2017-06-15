FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
  curl=7.47.0-1ubuntu2.2 \
  apt-transport-https=1.2.10ubuntu1 \
  python=2.7.11-1 \
  python-pip=8.1.1-2ubuntu0.4 \
  nginx \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql.list \
  && apt-get update && ACCEPT_EULA=Y apt-get install -y \
       msodbcsql=13.1.4.0-1 \
       unixodbc=2.3.1-4.1 \
       unixodbc-dev=2.3.1-4.1 \
       locales=2.23-0ubuntu7
COPY ui_frontend ui_frontend/
COPY ui_backend ui_backend/
WORKDIR ui_backend/
RUN pip install -r requirements.txt \
  && pip install pyodbc==4.0.15 uwsgi==2.0.15 \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 \

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/

COPY uwsgi.ini /etc/uwsgi/
RUN apt-get update && apt-get install -y supervisor \
  && rm -rf /var/lib/apt/lists/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80 443
CMD ["/usr/bin/supervisord"]

