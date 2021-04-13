#
# Author            Frank,H.L.Lai <frank@leadstec.com>
# Docker Version    20.10
# Website           https://www.leadstec.com
# Copyright         (C) 2021 LEADSTEC Systems. All rights reserved.
#
FROM leadstec/centos:8

LABEL description="ERPNext image for VCubi" \
    maintainer="Frank,H.L.Lai <frank@leadstec.com>"

# set environment variables
ENV ERPNEXT_LOG_DIR="${LOG_DIR}/erpnext"

# install packages
RUN yum install -y gcc make git bzip2 mariadb nginx supervisor python3 python3-devel redis nodejs && \
    npm install -g yarn

# install frappe
RUN useradd -m erp -G wheel && \
    chown -R erp:erp ${APP_DIR}
USER erp
RUN export PATH=~/.local/bin/:${PATH} && \
    pip3 install --user frappe-bench && \
    bench init ${APP_DIR} --ignore-exist && \
    cd ${APP_DIR} && \
    bench get-app erpnext --branch version-13

# add install/startup scripts
USER root
COPY scripts /scripts
RUN bash /scripts/setup/install
RUN rm -fr /scripts/setup

# EXPOSE 80 443 8000
