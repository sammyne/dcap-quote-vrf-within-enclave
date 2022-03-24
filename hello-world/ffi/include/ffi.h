#pragma once

#include <stdint.h>

#include "sgx_dcap_quoteverify.h"

#ifdef __cplusplus
extern "C" {
#endif

uint32_t verify_quote(const uint8_t *quote, uint32_t quote_len, int64_t expired_date);

#ifdef __cplusplus
}
#endif
