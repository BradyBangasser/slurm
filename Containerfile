FROM almalinux:10.1

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

RUN useradd -r -c "Slurm Workload Manager" -d /var/lib/slurm -s /bin/bash slurm && \
    mkdir -p /etc/slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm && \
    chown -R slurm:slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm

RUN create-munge-key -f && \
    chown munge:munge /etc/munge/munge.key && \
    chmod 400 /etc/munge/munge.key

WORKDIR /slurm-src

CMD ["/bin/bash"]
