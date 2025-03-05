std::arch::global_asm!(include_str!("string_copy.s"));

extern "C" {
    fn strcpy(dst: *mut std::ffi::c_char, src: *const std::ffi::c_char);
    fn strncpy(dst: *mut std::ffi::c_char, src: *const std::ffi::c_char, n: usize);
}

/// Copy a C string into a new one.
pub fn strcpy_safe(src: &std::ffi::CStr) -> std::ffi::CString {
    let len = src.count_bytes() + 1;
    let mut dst: Vec<u8> = Vec::with_capacity(len);
    unsafe {
        strcpy(dst.as_mut_ptr().cast(), src.as_ptr());
        dst.set_len(len);
        std::ffi::CString::from_vec_with_nul_unchecked(dst)
    }
}

/// Copy a C string into a new one up to length `len`, with padded `\0` if it is not long enough.
pub fn strncpy_safe(src: &std::ffi::CStr, len: usize) -> std::ffi::CString {
    let mut dst: Vec<u8> = Vec::with_capacity(len + 1);
    unsafe {
        strncpy(dst.as_mut_ptr().cast(), src.as_ptr(), len);
        dst.set_len(len);
        if dst.last().copied() != Some(b'\0') {
            dst.push(b'\0');
        }
        std::ffi::CString::from_vec_with_nul_unchecked(dst)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test0() {
        let mut bytes = vec![b'a'; 1000];
        bytes.push(b'\0');
        let cstr = std::ffi::CStr::from_bytes_with_nul(&bytes).unwrap();
        assert_eq!(strcpy_safe(cstr).as_c_str(), cstr);
    }

    #[test]
    fn test1() {
        let mut bytes = vec![b'a'; 1000];
        bytes.push(b'\0');
        let cstr = std::ffi::CStr::from_bytes_with_nul(&bytes).unwrap();
        assert_eq!(strncpy_safe(cstr, 500).to_bytes(), &cstr.to_bytes()[..500]);
    }
}
