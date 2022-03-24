#include "ffi.h"

uint32_t verify_quote(const uint8_t *quote, uint32_t quote_len, int64_t expired_date) {
  uint32_t expired = 1;
  // uint32_t result = 1;
  sgx_ql_qv_result_t result = SGX_QL_QV_RESULT_OK;

  if (auto err = sgx_qv_verify_quote(quote, quote_len, nullptr, (time_t)expired_date, &expired,
                                     &result, nullptr, 0, nullptr);
      0 != err) {
    return err;
  }

  if (0 != expired) {
    return 1;
  }

  sgx_ql_qv_result_t acceptables[4] = {
      SGX_QL_QV_RESULT_OK,
      SGX_QL_QV_RESULT_CONFIG_NEEDED,
      SGX_QL_QV_RESULT_OUT_OF_DATE,
      SGX_QL_QV_RESULT_OUT_OF_DATE_CONFIG_NEEDED,
  };
  bool accepted = false;
  for (size_t i = 0; (i < sizeof(acceptables) / sizeof(uint32_t)) && !accepted; ++i) {
    accepted = (acceptables[i] == result);
  }
  if (!accepted) {
    return 3;
  }

  return 0;
}