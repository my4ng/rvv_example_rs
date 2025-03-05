std::arch::global_asm!(include_str!("saxpy.s"));

extern "C" {
    // y[i] = a * x[i] + y[i]
    fn saxpy(n: usize, a: f32, x: *const f32, y: *mut f32);
}

pub fn saxpy_safe(a: f32, x: &[f32], y: &mut [f32]) {
    assert!(x.len() >= y.len());
    unsafe {
        saxpy(y.len(), a, x.as_ptr(), y.as_mut_ptr());
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let a = 42.;
        let x: Vec<_> = [1., 2., 3., 4., 5.]
            .into_iter()
            .cycle()
            .take(1200)
            .collect();
        let mut y: Vec<_> = [6., 7., 8., 9., 10.]
            .into_iter()
            .cycle()
            .take(1000)
            .collect();
        let res: Vec<_> = x
            .iter()
            .copied()
            .zip(y.iter().copied())
            .map(|(x, y)| a * x + y)
            .collect();

        saxpy_safe(a, &x, &mut y);
        assert_eq!(y, res);
    }
}
