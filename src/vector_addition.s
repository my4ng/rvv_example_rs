# vvaddint32(len: usize, xs: *const i32, ys: *const i32, zs: *mut i32);
# vector-vector add routine of 32-bit integers
#
# input arguments:
# a0 = len, length of arrays
# a1 = xs, array
# a2 = ys, array
# a3 = zs, array
vvaddint32:
	# update t0 with vl (number of elements this iteration)
	# a0 number of elements total
	# SEW = 32b, selected element width is 32-bit
	# LMUL = 8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     t0, a0, e32, m8, ta, ma  # Set vector length based on 32-bit vectors
	vle32.v     v0, (a1)                 # Get first vector
	sub         a0, a0, t0               # Decrement number done
	slli        t0, t0, 2                # Multiply number done by 4 bytes
	add         a1, a1, t0               # Bump pointer
	vle32.v     v8, (a2)                 # Get second vector
	add         a2, a2, t0               # Bump pointer
	vadd.vv     v16, v0, v8              # Sum vectors
	vse32.v     v16, (a3)                # Store result
	add         a3, a3, t0               # Bump pointer
	bnez        a0, vvaddint32           # Loop back
	ret                                  # Finished
