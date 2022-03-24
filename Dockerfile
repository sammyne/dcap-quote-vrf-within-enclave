FROM sammyne/gramine:1.0-go1.17.4-rs1.57.0-ubuntu20.04 AS builder

RUN apt update &&\
  UBUNTU_CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | awk -F"=" '{print $2}') &&\
  sdk_tag=${SDK_VERSION}-${UBUNTU_CODENAME}1 &&\
  apt install -y libsgx-headers=$sdk_tag

WORKDIR /output 

#ENV RA_CLIENT_LINKABLE=0                            \
#  LC_ALL=C.UTF-8                                    \
#  LANG=C.UTF-8

RUN rm -rf /lib/x86_64-linux-gnu/libpython3.8.a

WORKDIR /hello-world

ADD hello-world .

RUN . ~/.cargo/env && cargo build --release

WORKDIR /root/gramine/CI-Examples/hello-world

ADD gramine .

RUN cp /hello-world/target/release/hello-world . &&\
  make SGX=1    &&\
  cp * /output/

FROM sammyne/sgx-dcap:2.14.100.2-dcap1.11.100.2-ubuntu20.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
  sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt update && apt install -y libprotobuf-c-dev

WORKDIR /gramine

ENV RA_TLS_ALLOW_DEBUG_ENCLAVE_INSECURE=1 \
  RA_TLS_ALLOW_OUTDATED_TCB_INSECURE=1    \
  RA_TLS_ISV_PROD_ID=0                    \
  RA_TLS_ISV_SVN=0

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/bin/gramine-sgx /usr/local/bin/gramine-sgx

COPY --from=builder /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu

COPY --from=builder /output .

ADD aesmd.sh .
ADD check.sh .

CMD bash check.sh
