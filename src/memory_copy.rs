std::arch::global_asm!(include_str!("memory_copy.s"));

extern "C" {
    fn memcpy(dst: *mut std::ffi::c_void, src: *const std::ffi::c_void, len: usize);
}

pub fn memcpy_safe<T>(src: &T) -> T {
    let mut dst = std::mem::MaybeUninit::<T>::uninit();
    unsafe {
        memcpy(dst.as_mut_ptr().cast(), (src as *const T).cast(), size_of::<T>());
        dst.assume_init()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let value = [b'a'; 0x1000];
        assert_eq!(memcpy_safe(&value), value);
    }
}
