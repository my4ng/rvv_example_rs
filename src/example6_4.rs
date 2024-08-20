std::arch::global_asm!(include_str!("example6_4.s"));

extern "C" {
    fn r#loop(len: usize, src: *const i16, dst: *mut i32);
}

/// Widen multiply and right shift by 3.
pub fn loop_safe(src: &[i16]) -> Vec<i32> {
    let len = src.len();
    let mut dst = Vec::with_capacity(len);
    unsafe {
        r#loop(len, src.as_ptr(), dst.as_mut_ptr());
        dst.set_len(len);
    }
    dst
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let src = (0..1000).collect::<Vec<_>>();
        let dst = loop_safe(&src);
        let res = src.into_iter().enumerate().map(|(i, n)| {
            let m = (i & !0b111_111) as i32;
            (n as i32 * (1000 - m)) >> 3 
        }).collect::<Vec<_>>();
        assert_eq!(dst, res);
    }
}
