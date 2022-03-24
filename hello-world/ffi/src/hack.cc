extern "C" {
// hack to avoid sgx_urts.so
// ref:
// https://github.com/gramineproject/gramine/blob/v1.1/Pal/src/host/Linux-SGX/tools/ra-tls/ra_tls_verify_dcap_urts.c
#define DUMMY_FUNCTION(f)                             \
  __attribute__((visibility("default"))) int f(void); \
  int f(void) { return /*SGX_ERROR_UNEXPECTED*/ 1; }

DUMMY_FUNCTION(pthread_wait_timeout_ocall)
DUMMY_FUNCTION(pthread_create_ocall)
DUMMY_FUNCTION(pthread_wakeup_ocall)
}
