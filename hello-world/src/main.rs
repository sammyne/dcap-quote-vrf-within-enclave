use std::fs;
use std::time::SystemTime;

extern "C" {
    fn verify_quote(quote: *const u8, quote_len: u32, expired_date: i64) -> u32;
}

fn main() {
    let quote = generate_quote().expect("generate quote");
    println!("done quoting");

    let now = SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .unwrap()
        .as_secs() as i64;
    let err = unsafe { verify_quote(quote.as_ptr(), quote.len() as u32, now) };
    if err != 0 {
        panic!("bad quote: 0x{:04x}", err);
    }
    println!("fine :)");
}

fn generate_quote() -> Result<Vec<u8>, String> {
    const REPORT_DATA_PATH: &'static str = "/dev/attestation/user_report_data";
    const QUOTE_PATH: &'static str = "/dev/attestation/quote";

    let report_data = [0x01u8; 64];

    fs::write(REPORT_DATA_PATH, &report_data)
        .map_err(|err| format!("write report data: {}", err))?;

    fs::read(QUOTE_PATH).map_err(|err| format!("read quote: {}", err))
}
