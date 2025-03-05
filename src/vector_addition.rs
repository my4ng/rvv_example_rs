std::arch::global_asm!(include_str!("vector_addition.s"));

extern "C" {
    fn vvaddint32(len: usize, xs: *const i32, ys: *const i32, zs: *mut i32);
}

pub fn vvaddint32_safe(fst: &[i32], snd: &[i32]) -> Vec<i32> {
    let len = fst.len().min(snd.len());
    let mut out = Vec::with_capacity(len);
    unsafe {
        vvaddint32(len, fst.as_ptr(), snd.as_ptr(), out.as_mut_ptr());
        out.set_len(len);
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let fst: Vec<_> = [1, 2, 3, 4, 5].into_iter().cycle().take(1200).collect();
        let snd: Vec<_> = [6, 7, 8, 9, 10].into_iter().cycle().take(1000).collect();
        let res: Vec<_> = [7, 9, 11, 13, 15].into_iter().cycle().take(1000).collect();
        assert_eq!(vvaddint32_safe(&fst, &snd), res);
    }
}
