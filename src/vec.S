    .globl vec_len_rvv
vec_len_rvv:
    # 32 bit elements, don't care (Agnostic) how tail and mask are handled
    vsetvli a3, a2, e32, m1, ta, ma
    vlseg3e32.v v0, (a1) # loads interleaved Xs, Ys, Zs into 3 registers
    vfmul.vv v3, v0, v0
    vfmacc.vv v3, v1, v1
    vfmacc.vv v3, v2, v2
    vfsqrt.v v3, v3
    vse32.v v3, (a0)
    sub a2, a2, a3
    sh2add a0, a3, a0 # bump r ptr 4 bytes per float
    sh1add a3, a3, a3 # multiply vl by 3 floats per point
    sh2add a1, a3, a1 # bump v ptr 4 bytes per float (12 per pt)
    bnez a2, vec_len_rvv
    ret
