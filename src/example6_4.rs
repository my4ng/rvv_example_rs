std::arch::global_asm!(include_str!("example6_4.s"));

extern "C" {
    fn r#loop(len: usize, src: *const i16, dst: *mut i32);
}

/// Widen multiply and right shift by 3.
///
/// The result of this function might be a little surprising; The elements are widen multiplied by
/// the value of `vl`, which is dependent on the `VLEN` and `AVL`. For example, with a `VLEN` of
/// 256, the vl for all but the last iteration of the loop is `VLMAX = VLEN * LMUL / SEW =
/// 256 * 4 / 16 = 64`. For the last iteration, it will be the remaining number of elements.
/// (This is an over-simplication, see section 6 for more details).
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
        dbg!(dst);
    }
}
