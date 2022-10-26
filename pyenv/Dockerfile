FROM redhat/ubi9-init
# use bash as the default shell for this image
SHELL ["/bin/bash", "-l", "-c"]
# install dependencies

ARG CHOSEN_PY_VERSION
ENV CHOSEN_PY_VER ${CHOSEN_PY_VERSION}
ARG APP_USER

RUN echo ${CHOSEN_PY_VER} \
    echo ${APP_USER}

RUN yum -y --allowerasing install \
    make \
    zlib-devel \
    bzip2 \
    bzip2-devel \
    # readline-devel \
    sqlite \
    sqlite-devel \
    openssl-devel \
    # tk-devel \
    libffi-devel \
    gcc \
    gcc-c++ \
    procps \
    xz \ 
    xz-devel \
    libffi-devel \
    git \
    && yum -y clean all \
    && rm -rf /var/cache 

# Install pyenv using pyenv-installer
## set $PYENV_ROOT to choose the install directory
ENV PYENV_ROOT /opt/.pyenv
## the actual installation
RUN curl https://pyenv.run | bash

# download pyenv
# RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# setup pyenv ENV variables
RUN echo 'export PYENV_ROOT="$PYENV_ROOT"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# install python of chosen version
# could be used like so: `pyenv install -v 3.8:latest` or `pyenv install -v 3.x:latest`
RUN pyenv install -v ${CHOSEN_PY_VER}.14

# create virtualenv
# pyenv works with `-m venv` and `virtualenv` as well
# we will use `-m venv`, because `pyenv virtualenv` doesn't work well if user
# does not have write rights to the place .pyenv is installed in
# RUN pyenv virtualenv 3.8.14 venv
ENV VIRTUAL_ENV /opt/venv
# change workdir to /tmp
WORKDIR /tmp
RUN pyenv virtualenv 3.8.14 venv
RUN pyenv local venv
# create virtualenv using `-m venv`
RUN python -m venv ${VIRTUAL_ENV}

# Create a new user
RUN useradd -ms /bin/bash ${APP_USER}

WORKDIR ${VIRTUAL_ENV}

# copy requirements.txt
COPY --chown=${APP_USER}:root /requirements.txt /home/${APP_USER}/app/requirements.txt

# add VIRTUAL_ENV to ENVs for pip install step
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

# sanity check
RUN echo "which python: $(pyenv which python)" \
    && echo "which pip: $(pyenv which pip)"

# install python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir twine keyring artifacts-keyring \
    && pip install --no-cache-dir -r /home/${APP_USER}/app/requirements.txt

USER ${APP_USER}

# # setup VIRTUAL_ENV PATH for ${APP_USER}
RUN echo 'export PATH="$VIRTUAL_ENV/bin:$PATH"' >> /home/${APP_USER}/.bashrc

WORKDIR /home/${APP_USER}/app/

CMD [ "cd /home/${APP_USER}/app/ ; pytest ." ]