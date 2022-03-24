# DCAP quote Verification within Enclave

## Environment
- Gramine 1.0
- SGX 2.14
- DCAP 1.11

## Reproduction

### 1. build the docker image
```bash
docker build -t hello-quote-vrf:alpha .
```

### 2. run the demo

```bash
# please renew PCCS_ADDR based on address of your PCCS service
docker run -it --rm                               \
  -e PCCS_ADDR="1.2.3.4:8443"                     \
  --device /dev/kmsg:/dev/kmsg                    \
  --device /dev/sgx_enclave:/dev/sgx/enclave      \
  --device /dev/sgx_provision:/dev/sgx/provision  \
  hello-quote-vrf:alpha bash
```

And logs go as follow

```bash
renewing PCCS_ADDR in /etc/sgx_default_qcnl.conf

---
start up the AESM ...

---
waiting for AESM being ready ...
nohup: appending output to 'nohup.out'

---
AESM is now ready :) ...
aesm_service[14]: The server sock is 0x559048c7c9f0
-----------------------------------------------------------------------------------------------------------------------
Gramine detected the following insecure configurations:

  - loader.insecure__use_cmdline_argv = true   (forwarding command-line args from untrusted host to the app)

Gramine will continue application execution, but this configuration must not be used in production!
-----------------------------------------------------------------------------------------------------------------------

done quoting
thread 'main' panicked at 'bad quote: 0xe019', src/main.rs:18:9
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
aesm_service[14]: Malformed request received (May be forged for attack)
```

where `sgx_qv_verify_quote` of libsgx_dcap_quoteverify.so reports error code as 0xe019 indicating `SGX_QL_NETWORK_ERROR`.

## Problems
Why quote generation works, but quote verification fails.
