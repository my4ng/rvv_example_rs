std::arch::global_asm!(include_str!("ternary_assign.s"));

extern "C" {
    fn ternary_assign(len: usize, x: *const i8, a: *const i16, b: *const i16, z: *mut i16);
}

pub fn ternary_assign_safe(x: &[i8], a: &[i16], b: &[i16]) -> Vec<i16> {
    let len = x.len().min(a.len()).min(b.len());
    let mut z = Vec::with_capacity(len);
    unsafe {
        ternary_assign(len, x.as_ptr(), a.as_ptr(), b.as_ptr(), z.as_mut_ptr());
        z.set_len(len);
    }
    z
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let x: Vec<_> = [1, 5, 3, 8, 2].into_iter().cycle().take(1200).collect();
        let a: Vec<_> = [1, 2, 3, 4, 5].into_iter().cycle().take(1000).collect();
        let b: Vec<_> = [6, 7, 8, 9, 10].into_iter().cycle().take(1000).collect();
        let z: Vec<_> = [1, 7, 3, 9, 5].into_iter().cycle().take(1000).collect();
        assert_eq!(ternary_assign_safe(&x, &a, &b), z);
    }
}
