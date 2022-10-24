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
    gcc \
    gcc-c++ \
    procps \
    && yum -y clean all \
    && rm -rf /var/cache 
# download miniconda3
# https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
# https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh --output /tmp/minicond3_latest_x86_64.sh \
    && chmod +x /tmp/minicond3_latest_x86_64.sh
# install miniconda3
RUN /tmp/minicond3_latest_x86_64.sh -b -u -p root/miniconda3 \
    && source /root/miniconda3/bin/activate \
    && conda init
# create miniconda3 env
# activate new miniconda3 env when running bash with --login flag (-l)
RUN conda create --prefix /opt/venv python=${CHOSEN_PY_VER} --yes \
    && echo "# activate miniconda3 env /opt/venv when using bash with --login flag (-l)" >> /root/.bashrc \
    && echo "conda activate /opt/venv" >> /root/.bashrc

# copy requirements.txt
COPY --chown=root:root /requirements.txt /home/app/requirements.txt
# install python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    pip install --no-cache-dir twine keyring artifacts-keyring \
    pip install --no-cache-dir -r /home/app/requirements.txt

USER APP_USER

CMD [ "cd /home/app ; pytest ." ]