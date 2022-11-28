# syntax=docker/dockerfile:experimental


FROM python:3.10

# use docker arg overrides to start up container with corrected host mount permissions
ARG UID=1000
ARG GID=1000

# Tell pipenv to create venv in the current directory
ENV PIPENV_VENV_IN_PROJECT=1

EXPOSE 8888
EXPOSE 8080

RUN apt-get update --yes && apt-get upgrade --yes
RUN apt-get install wget git --yes
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN chown -R ${UID}:${GID} .

ADD ./jupyter/Pipfile /usr/src

RUN pip install wheel
RUN pip install --upgrade pip
RUN pip install pipenv
RUN pipenv install --skip-lock --system

RUN python -m ipykernel install --user --display-name ual-analysis --name ual-jupytizer

# entrypoint below will leave container running
ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0"]