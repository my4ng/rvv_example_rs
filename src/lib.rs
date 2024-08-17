use std::arch::global_asm;

global_asm!(include_str!("vec.S"));

#[repr(C)]
pub struct Pt {
    x: f32,
    y: f32,
    z: f32,
}

impl From<(i32, i32, i32)> for Pt {
    fn from(value: (i32, i32, i32)) -> Self {
        Self {
            x: value.0 as f32,
            y: value.1 as f32,
            z: value.2 as f32,
        }
    }
}

extern "C" {
    fn vec_len_rvv(lens: *mut f32, pts: *const Pt, len: i32);
}

pub fn vec_len(pts: &[Pt]) -> Vec<f32> {
    let mut lens = vec![0f32; pts.len()];
    unsafe {
        vec_len_rvv(lens.as_mut_ptr(), pts.as_ptr(), pts.len() as i32);
    }
    lens
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_example() {
        let pts: [Pt; 6] = [
            (1, 2, 3),
            (4, 5, 6),
            (7, 8, 9),
            (10, 11, 12),
            (13, 14, 15),
            (16, 17, 18),
        ]
        .map(Into::into);

        for len in vec_len(&pts) {
            println!("{len}");
        }
    }
}
