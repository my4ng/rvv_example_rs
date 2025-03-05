# size_t strlen(const char *str)
# a0 holds *str
# return value:
# a0 - string length
#
# internal variables:
# a3 string pointer
strlen:
	mv          a3, a0                   # Save start
loop:
	# update a1 with vl (number of elements this iteration)
	# max length vectors of bytes, so not tracking array size
	# SEW=8b, selected element width is 8-bit (byte)
	# LMUL=8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     a1, x0, e8, m8, ta, ma   # Vector of bytes of maximum length
	vle8ff.v    v8, (a3)                 # Load bytes
	vmseq.vi    v0, v8, 0                # Set v0[i] where v8[i] = 0
	vfirst.m    a2, v0                   # Find first set bit
	add         a3, a3, a1               # Bump pointer
	bltz        a2, loop                 # Not found?
	add         a0, a0, a1               # Sum start + bump
	add         a3, a3, a2               # Add index
	sub         a0, a3, a0               # Subtract start address+bump
	ret                                  # return length in a0
