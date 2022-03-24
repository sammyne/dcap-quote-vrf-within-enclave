#!/bin/bash

tag=DCAP_1.11

remote=https://raw.githubusercontent.com/intel/SGXDataCenterAttestationPrimitives/$tag/QuoteVerification

curl -LO $remote/dcap_quoteverify/inc/sgx_dcap_quoteverify.h

curl -LO $remote/QvE/Include/sgx_qve_header.h
