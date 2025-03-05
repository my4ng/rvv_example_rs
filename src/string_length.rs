std::arch::global_asm!(include_str!("string_length.s"));

extern "C" {
    fn strlen(str: *const std::ffi::c_char) -> usize;
}

/// Find the length of a C string.
pub fn strlen_safe(str: &std::ffi::CStr) -> usize {
    unsafe { strlen(str.as_ptr()) }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let mut bytes = vec![b'a'; 1000];
        bytes.push(b'\0');
        let cstr = std::ffi::CStr::from_bytes_with_nul(&bytes).unwrap();
        assert_eq!(strlen_safe(cstr), 1000);
    }
}
