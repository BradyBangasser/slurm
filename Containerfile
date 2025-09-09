FROM almalinux:10

RUN dnf update -y && dnf install git make munge-devel clang python3-pytest expect -y

RUN /sbin/init

WORKDIR /opt
RUN git clone https://github.com/BradyBangasser/slurm.git
WORKDIR /opt/slurm

RUN ./configure && make && make install
WORKDIR /opt/slurm/testsuite

RUN cp testsuite.conf.sample testsuite.conf

RUN ./run-tests
