std::arch::global_asm!(include_str!("predicated_compute.s"));

extern "C" {
    fn predicated_compute(len: usize, xs: *const i8, ys: *mut i32, zs: *const i32);
}

pub fn predicated_compute_safe(fst: &[i8], snd: &[i32]) -> Vec<i32> {
    let len = fst.len().min(snd.len());
    let mut out = Vec::with_capacity(len);
    unsafe {
        predicated_compute(len, fst.as_ptr(), out.as_mut_ptr(), snd.as_ptr());
        out.set_len(len);
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let fst: Vec<_> = [1, 5, 3, 8, 2].into_iter().cycle().take(1200).collect();
        let snd: Vec<_> = [6, 7, 8, 9, 10].into_iter().cycle().take(1000).collect();
        let res: Vec<_> = [6, 1, 8, 1, 10].into_iter().cycle().take(1000).collect();
        assert_eq!(predicated_compute_safe(&fst, &snd), res);
    }
}
