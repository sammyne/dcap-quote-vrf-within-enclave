fn main() {
    cc::Build::new()
        .file("ffi/src/ffi.cc")
        .file("ffi/src/hack.cc")
        .flag("-std=c++17")
        .include("third_party/sgx-dcap")
        .include("ffi/include")
        .compile("ffi");

    println!("cargo:rustc-link-lib=sgx_dcap_quoteverify");
}
