std::arch::global_asm!(include_str!("copy_non_zero.s"));

extern "C" {
    fn compact_non_zero(len: usize, r#in: *const i32, out: *mut i32) -> usize;
}

/// Compact non-zero elements.
pub fn compact_non_zero_safe(src: &[i32]) -> Vec<i32> {
    let len = src.len();
    let mut dst = Vec::with_capacity(len);
    unsafe {
        let len = compact_non_zero(len, src.as_ptr(), dst.as_mut_ptr());
        dst.set_len(len);
        dst.shrink_to_fit();
    }
    dst
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let src: Vec<_> = [0, 1, 2, 3, 0, 4, 0, 5, 6, 0]
            .into_iter()
            .cycle()
            .take(1000)
            .collect();
        let dst = compact_non_zero_safe(&src);
        assert_eq!(
            &dst,
            &[1, 2, 3, 4, 5, 6]
                .into_iter()
                .cycle()
                .take(600)
                .collect::<Vec<_>>()
        );
    }
}
