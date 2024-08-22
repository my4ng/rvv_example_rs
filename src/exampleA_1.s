# vector-vector add routine of 32-bit integers
vvaddint32:
    vsetvli t0, a0, e32, m1, ta, ma # Set vector length based on 32-bit vectors
    vle32.v v0, (a1) # Get first vector
    sub a0, a0, t0 # Decrement number done
    slli t0, t0, 2 # Multiply number done by 4 bytes
    add a1, a1, t0 # Bump pointer
    vle32.v v1, (a2) # Get second vector
    add a2, a2, t0 # Bump pointer
    vadd.vv v2, v0, v1 # Sum vectors
    vse32.v v2, (a3) # Store result
    add a3, a3, t0 # Bump pointer
    bnez a0, vvaddint32 # Loop back
    ret # Finished
