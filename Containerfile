FROM almalinux:10

RUN dnf update -y && dnf install git make munge-devel clang -y

WORKDIR /opt
RUN git clone https://github.com/BradyBangasser/slurm.git
WORKDIR /opt/slurm

RUN ./configure && make
