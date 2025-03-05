# char* strcpy(char *dst, const char* src)
# a0 = destination pointer
# a1 = source pointer
strcpy:
	mv          a2, a0                   # Copy destination pointer for local use.
loop:
	# update t1 with vl (number of elements this iteration)
	# max length vectors of bytes, set vl to VLMAX
	# SEW=8b - selected element width is 8-bit (byte)
	# LMUL=8 vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     t1, x0, e8, m8, ta, ma   # Max length vectors of bytes
	vle8ff.v    v8, (a1)                 # Get src bytes
	csrr        t1, vl                   # Get number of bytes fetched
	vmseq.vi    v1, v8, 0                # Flag zero bytes
	vfirst.m    a3, v1                   # Zero found?
	add         a1, a1, t1               # Bump pointer
	vmsif.m     v0, v1                   # Set mask up to and including zero byte.
	vse8.v      v8, (a2), v0.t           # Write out bytes
	add         a2, a2, t1               # Bump pointer
	bltz        a3, loop                 # Zero byte not found, so loop
	ret                                  # Return in a0 the destination pointer

# char * strncpy(char *dest, const char *src, size_t n)
# 	size_t i;
# 	for (i = 0; i < n && src[i] != '\0'; i++)
# 		dest[i] = src[i];
# 	for ( ; i < n; i++)
# 		dest[i] = '\0';
# 	return dest;
# a0 = destination pointer
# a1 = source pointer
# a2 = total number of bytes to copy
#
# internal vars:
# a3 = iteration destination pointer
# a4 = bytes remaining
# t1 = bytes this iteration
strncpy:
	mv          a3, a0                   # return original dest pointer as a0
loop1:
	# don't track number of elements per iteration
	# a2 number of elements total
	# SEW  = 8b, selected element width is 8-bit (byte)
	# LMUL = 8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     x0, a2, e8, m8, ta, ma   # Vectors of bytes.
	vle8ff.v    v8, (a1)                 # Get src bytes
	vmseq.vi    v1, v8, 0                # Flag zero bytes
	csrr        t1, vl                   # Get number of bytes fetched
	vfirst.m    a4, v1                   # Zero found?
	vmsbf.m     v0, v1                   # Set mask up to before zero byte.
	vse8.v      v8, (a3), v0.t           # Write out non-zero bytes
	bgez        a4, zero_tail            # Zero remaining bytes.
	sub         a2, a2, t1               # Decrement count.
	add         a3, a3, t1               # Bump dest pointer
	add         a1, a1, t1               # Bump src pointer
	bnez        a2, loop1                # Anymore?
	ret                                  # return dest pointer in a0
zero_tail:
	sub         a2, a2, a4               # Subtract count on non-zero bytes.
	add         a3, a3, a4               # Advance past non-zero bytes.
	# update t1 with vl (number of elements this iteration)
	# a2 number of elements total
	# SEW  = 8b, selected element width is 8-bit (byte)
	# LMUL = 8, vector register group multiplier
	# tail policy: agnostic
	# mask policy: agnostic
	vsetvli     t1, a2, e8, m8, ta, ma   # Vectors of bytes.
	vmv.v.i     v0, 0                    # Splat zero.
zero_loop:
	vse8.v      v0, (a3)                 # Store zero.
	sub         a2, a2, t1               # Decrement count.
	add         a3, a3, t1               # Bump pointer
	bnez        a2, zero_loop            # Anymore?
	ret
