# saxpy(size_t n, const float a, const float *x, float *y)
#    for (int i = 0; i < n; ++i)
#      y[i] = a * x[i] + y[i];
# input arguments:
# a0  = n, number of elements
# fa0 = a, the multiplier (floating point)
# a1  = array x
# a2  = array y
saxpy:
	# update a4 with vl (number of elements this iteration)
	# a0 number of elements total
	# SEW = 32b, selected element width is 32-bit (single-precision floating point)
	# LMUL = 8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     a4, a0, e32, m8, ta, ma  #
	vle32.v     v0, (a1)                 # load elements of x into v0
	sub         a0, a0, a4               # Number of elements remaining after this iteration
	slli        a4, a4, 2                # 4 bytes per element
	add         a1, a1, a4               # increment pointer to beginning of next section
	vle32.v     v8, (a2)                 # load y[i] into v8
	vfmacc.vf   v8, fa0, v0              # y[i] = a * x[i] + y[i]
	vse32.v     v8, (a2)                 # store y[i]
	add         a2, a2, a4               # increment destination pointer
	bnez        a0, saxpy                # Repeat if any elements remain
	ret
