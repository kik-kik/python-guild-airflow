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

docker_run: docker_build mk_dags_dir
	${SUDO} docker run -d --rm --name my_airflow -p 8080:8080 -v `pwd`/dags/:/usr/local/airflow/dags/ airflow:latest

docker_kill:
	${SUDO} docker kill my_airflow


mk_dags_dir:
	mkdir dags/

copy_example_1: mk_dags_dir
	cp .examples/example_bash_operator.py dags/.

copy_example_2: mk_dags_dir
	cp .examples/example_python_operator.py dags/.

copy_example_3: mk_dags_dir
	cp .examples/example_python_branch_operator.py dags/.

copy_example_4: mk_dags_dir
	cp .examples/example_complex.py dags/.

copy_all_examples: copy_example_1 copy_example_2 copy_example_3 copy_example_4


force_refresh_dags:
	${SUDO} docker exec -it my_airflow python -c "from airflow.models import DagBag; d = DagBag();"

cleanup: docker_kill
	rm -rf dags
