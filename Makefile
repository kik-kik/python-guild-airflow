SHELL=/bin/bash

OS = $(shell uname -s)

SUDO :=
ifeq ($(OS),Linux)
	SUDO = sudo
else
	SUDO =
endif


docker_build:
	${SUDO} docker build . -t airflow:latest

docker_run: docker_build
	${SUDO} docker run -d --rm --name my_airflow -p 8080:8080 -v `pwd`/dags/:/usr/local/airflow/dags/ airflow:latest

docker_kill:
	${SUDO} docker kill my_airflow

dags_copy_part_1:
	cp part_1/example_bash_operator.py dags/.

dags_copy_part_2:
	cp part_2/example_python_operator.py dags/.

force_refresh_dags:
	${SUDO} docker exec -it my_airflow python -c "from airflow.models import DagBag; d = DagBag();"