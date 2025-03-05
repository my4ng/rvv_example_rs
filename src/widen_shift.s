# widen_shift(len: usize, src: *const i16, dst: *mut i32);
# Example:
#     Load 16-bit values,
#     widen multiply to 32b,
#     shift 32b result # right by 3,
#     store 32b values.
# On entry:
# a0 holds the total number of elements to process
# a1 holds the address of the source array
# a2 holds the address of the destination array
widen_shift:
	# update a3 with vl (number of elements this iteration)
	# a0 number of elements total
	# SEW = 16b, selected element width is 16-bit
	# LMUL = 4, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     a3, a0, e16, m4, ta, ma  # vtype = 16-bit integer vectors;
	vle16.v     v4, (a1)                 # Get 16b vector
	slli        t1, a3, 1                # Multiply # elements this iteration by 2 bytes/source element
	add         a1, a1, t1               # Bump pointer
	vwmul.vx    v8, v4, a0               # Widening multiply into 32b in <v8--v15>
	# don't track number of elements per iteration
	# maximum number of elements
	# SEW = 32b, selected element width is 32-bit
	# LMUL = 8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     x0, x0, e32, m8, ta, ma  # Operate on 32b values
	vsrl.vi     v8, v8, 3                # shift right
	vse32.v     v8, (a2)                 # Store vector of 32b elements
	slli        t1, a3, 2                # Multiply # elements this iteration by 4 bytes/destination element
	add         a2, a2, t1               # Bump pointer
	sub         a0, a0, a3               # Decrement count by vl
	bnez        a0, widen_shift          # Any more?
	ret
