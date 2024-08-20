# Compact non-zero elements from input memory array to output memory array
compact_non_zero:
    li a6, 0 # Clear count of non-zero elements
loop:
    vsetvli a5, a0, e32, m8, ta, ma # 32-bit integers
    vle32.v v8, (a1) # Load input vector
    sub a0, a0, a5 # Decrement number done
    slli a5, a5, 2 # Multiply by four bytes
    vmsne.vi v0, v8, 0 # Locate non-zero values
    add a1, a1, a5 # Bump input pointer
    vcpop.m a5, v0 # Count number of elements set in v0
    viota.m v16, v0 # Get destination offsets of active elements
    add a6, a6, a5 # Accumulate number of elements
    vsll.vi v16, v16, 2, v0.t # Multiply offsets by four bytes
    slli a5, a5, 2 # Multiply number of non-zero elements by four bytes
    vsuxei32.v v8, (a2), v16, v0.t # Scatter using scaled viota results under mask
    add a2, a2, a5 # Bump output pointer
    bnez a0, loop # Any more?
    mv a0, a6 # Return count
    ret
