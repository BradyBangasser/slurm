FROM almalinux:9

RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

RUN dnf -y update && \
    dnf -y install \
    gcc \
    make \
    munge \
    munge-devel \
    mariadb-server \
    mariadb-devel \
    pam-devel \
    perl \
    python3 \
    git \
    sudo \
    which \
    vim \
    && dnf clean all

RUN create-munge-key
RUN systemctl enable munge

RUN useradd -r -c "Slurm Workload Manager" -d /var/lib/slurm -s /bin/bash slurm && \
    mkdir -p /etc/slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm && \
    chown -R slurm:slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm

COPY . /slurm-src
WORKDIR /slurm-src

RUN mkdir -p /etc/slurm && cp slurm-conf/* /etc/slurm

RUN ./configure --sysconfdir=/etc/slurm --disable-cgroup --without-cgroup --disable-cgroupv2 && make && make install

RUN cp etc/*.service /etc/systemd/system/
RUN systemctl enable slurmctld
RUN systemctl enable slurmd

CMD ["/sbin/init"]
