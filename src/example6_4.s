# Example: Load 16-bit values, widen multiply to 32b, shift 32b result
# right by 3, store 32b values.
# On entry:
# a0 holds the total number of elements to process
# a1 holds the address of the source array
# a2 holds the address of the destination array
loop:
    vsetvli a3, a0, e16, m4, ta, ma # vtype = 16-bit integer vectors;
    # also update a3 with vl (# of elements this iteration)
    vle16.v v4, (a1) # Get 16b vector
    slli t1, a3, 1 # Multiply # elements this iteration by 2 bytes/source element
    add a1, a1, t1 # Bump pointer
    vwmul.vx v8, v4, a0 # Widening multiply into 32b in <v8--v15>
    vsetvli x0, x0, e32, m8, ta, ma # Operate on 32b values
    vsrl.vi v8, v8, 3
    vse32.v v8, (a2) # Store vector of 32b elements
    slli t1, a3, 2 # Multiply # elements this iteration by 4 bytes/destination element
    add a2, a2, t1 # Bump pointer
    sub a0, a0, a3 # Decrement count by vl
    bnez a0, loop # Any more?
    ret
