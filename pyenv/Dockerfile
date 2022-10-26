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
RUN curl https://pyenv.run | bash

# download pyenv
# RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# setup pyenv ENV variables
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc

# # install new python version with pyenv
# RUN conda create --prefix /opt/venv python=${CHOSEN_PY_VER} --yes \
#     && echo "# activate miniconda3 env /opt/venv when using bash with --login flag (-l)" >> /root/.bashrc \
#     && echo "conda activate /opt/venv" >> /root/.bashrc

# # copy requirements.txt
# COPY --chown=root:root /requirements.txt /home/app/requirements.txt
# # install python dependencies
# RUN pip install --no-cache-dir --upgrade pip \
#     pip install --no-cache-dir twine keyring artifacts-keyring \
#     pip install --no-cache-dir -r /home/app/requirements.txt


CMD [ "cd /home/app ; pytest ." ]