# Code using one width for predicate and different width for masked compute.
# Mixed-width code that keeps SEW/LMUL=8
# arguments:
# a0 = length
# a1 = xs
# a2 = ys
# a3 = zs
predicated_compute:
	vsetvli     a4, a0, e8, m1, ta, ma   # Byte vector for predicate calc
	vle8.v      v1, (a1)                 # Load a[i]
	add         a1, a1, a4               # Bump pointer.
	vmslt.vi    v0, v1, 5                # a[i] < 5?
	vsetvli     x0, a0, e32, m4, ta, mu  # Vector of 32-bit values.
	sub         a0, a0, a4               # Decrement count
	vmv.v.i     v4, 1                    # Splat immediate to destination
	vle32.v     v4, (a3), v0.t           # Load requested elements of C, others undisturbed
	sll         t1, a4, 2                # increment size is 4 bytes
	add         a3, a3, t1               # Bump pointer.
	vse32.v     v4, (a2)                 # Store b[i].
	add         a2, a2, t1               # Bump pointer.
	bnez        a0, predicated_compute   # Any more?
	ret
