FROM redhat/ubi9-init
# use bash as the default shell for this image
SHELL ["/bin/bash", "-l", "-c"]
# install dependencies
RUN yum -y --allowerasing install \
    gcc \
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
# copy requirements.txt
COPY --chown=root:root /requirements.txt /home/app/requirements.txt
# install python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    pip install --no-cache-dir twine keyring artifacts-keyring \
    pip install --no-cache-dir -r /home/app/requirements.txt