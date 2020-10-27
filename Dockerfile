FROM apache/airflow:1.10.12-python3.8

ARG AIRFLOW_USER_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
COPY script/entrypoint.sh /entrypoint.sh

EXPOSE 8080 5555 8793

USER root
RUN chown -R airflow: ${AIRFLOW_USER_HOME}

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]