# syntax=docker/dockerfile:experimental


FROM ubuntu:latest

# use docker arg overrides to start up container with corrected host mount permissions
ARG UID=1000
ARG GID=1000
ARG USER=docker

# a few variables that the image needs
ENV USER_DIR="/home/${USER}"
ENV PROJECT_DIR="/usr/src"
ENV DEBIAN_FRONTEND=noninteractive

# specific Python stuff...
# create pipenv venv in the current directory
# use .local dir for user pipenv settings
ENV PIPENV_VENV_IN_PROJECT=1
ENV PYTHONUSERBASE="${USER_DIR}/.local"
ENV PATH="${PATH}:${PYTHONUSERBASE}/bin"

# image ports, see dstart.sh script
EXPOSE 8888
EXPOSE 8080
EXPOSE 22

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN apt-get update -q \
	&& apt-get upgrade -qy 

RUN apt-get install -qy \
    apt-utils \
    build-essential \
    libssl-dev \
    libffi-dev \
    wget \
    git \
    python3-dev \
    python3-pip \
    python3-tk \
    libmagickwand-dev \
    openssh-server 

# this stuff gets trashed to keep the image weight down. super-necessary!
RUN apt-get autoremove -y \
	&& apt-get --fix-broken install \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# do SSH stuff
RUN mkdir /run/sshd
RUN sed -i -E 's/^#?PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config && \
    sed -i -E 's/^#?PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AllowUsers ${USER}" >> /etc/ssh/sshd_config
RUN service ssh start

# start non-root user install stuff
RUN addgroup --gid $GID --system ualhost
RUN useradd --uid $UID \
    -G "ualhost,root" \
    --no-log-init \
    --create-home --home-dir $USER_DIR \
    $USER

RUN mkdir "${USER_DIR}/.ssh"
RUN chmod u+rwx,go-rwx "${USER_DIR}/.ssh"

# finish non-root user tasks
RUN mkdir "${USER_DIR}/.local"
RUN chown -R $USER:$USER $USER_DIR

ADD ./jupyter/Pipfile $PROJECT_DIR
RUN chown -R $USER:$USER $PROJECT_DIR

RUN pip3 install wheel
RUN pip3 install --upgrade pip
RUN pip3 install pipenv

# finish up image build in the project dir as the non-root user
WORKDIR $PROJECT_DIR
USER $USER

RUN pipenv install --system --skip-lock --dev
# install individual packages here, but use discrimination as this will be committed
# RUN pipenv install py-pdf-parser[dev]

# entrypoint below will leave container running
# --ip needs to be set to scan all local for to lock up with docker host ip
ENTRYPOINT ["pipenv", "run", "jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0"]