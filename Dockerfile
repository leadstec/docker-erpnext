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
    npm install -g yarn && \
    lcs-cli schema add --section erpnext && \
    useradd -m erp -G wheel

# add install/startup scripts
COPY scripts /scripts

USER erp
RUN bash /scripts/setup/install

USER root
RUN rm -fr /scripts/setup

# EXPOSE 80 443 8000
