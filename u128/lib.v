module u128

const msb32 = 1 << 31

pub struct U128 {
mut:
	part [4]u32
}

pub fn from_string(a string) U128 {
	mut r := U128{}
	r.part[0] = u32(a.int())
	return r
}

pub fn from_int(a int) U128 {
	mut r := U128{}
	r.part[0] = u32(a)
	r.part[1] = u32(0)
	r.part[2] = u32(0)
	r.part[3] = u32(0)
	return r
}

fn (u &U128) str() string {
	mut s := '0x'
	hex := '0123456789abcdef'.bytes()
	mut trailing := true
	for i := 3; i >= 0; i-- {
		for j := 3; j >= 0; j-- {
			word := (u.part[i] >> (j * 8)) & 0xff
			if word == 0 {
				if trailing {
					continue
				}
			} else {
				trailing = false
			}
			a := hex[(word >> 4) & 0xf]
			b := hex[word & 0xf]
			mut words := []u8{}
			words << a
			words << b
			s += words.bytestr()
		}
	}
	return s
}

fn (x U128) %(y U128) U128 {
	mut r := U128{}
	return r
}
fn (x U128) /(y U128) U128 {
	mut r := U128{}
/*
bool
int128_unsigned_divide(int128_t *quotient, int128_t *remainder,
                       const int128_t *dividend, const int128_t *divisor)
{
  bool allzero = int128_unsigned_compare(divisor, &zero) == 0;
  int128_t top;
  int bits = int128_count_leading_zeros(dividend);

  *quotient = zero;
  *remainder = zero;
  int128_shift_left(&top, dividend, bits);
  for (; bits < 128; ++bits) {
    int128_t tmp = *remainder;
    int128_unsigned_add(remainder, &tmp, &tmp);
    tmp = top;
    if (int128_unsigned_add(&top, &tmp, &tmp)) {
      tmp = *remainder;
      int128_unsigned_add(remainder, &tmp, &one);
    }
    tmp = *quotient;
    int128_unsigned_add(quotient, &tmp, &tmp);
    if (int128_unsigned_compare(remainder, divisor) >= 0) {
      tmp = *quotient;
      int128_unsigned_add(quotient, &tmp, &one);
      tmp = *remainder;
      int128_signed_subtract(remainder, &tmp, divisor);
    }
  }
  return allzero;
*/
	return r
}

fn (x U128) * (y U128) U128 {
	mut r := U128{}
	mut res := [8]u32{}
	for j := 0; j < 8; j++ {
		res[j] = 0
	}
	for j := 0; j < 4; j++ {
		for k := 0; k < 4; k++ {
			/*
			Next few expressions can't overflow, since they compute at most
       *    0xffffffff * 0xffffffff + 0xffffffff
       *  = (0xffffffff + 1) * 0xffffffff
       *  = 0x100000000 * 0xffffffff
       *  = 0xffffffff00000000
       * or, if you prefer,
       *    (2**32 - 1)**2 + 2**32 - 1
       *  = 2**64 - 2*(2**32) + 1 + 2**32 - 1
       *  = 2**64 - 2**32
			*/
			mut xy := u64(x.part[j]) * y.part[k]
			mut to := 0
			for to = j + k; to < 8; to++ {
				if xy == 0 {
					break
				}
				xy += res[to]
				res[to] = u32(xy)
				xy >>= 32
			}
		}
	}
	mut low := U128{}
	mut high := U128{}
	for j := 0; j < 4; j++ {
		r.part[j] = res[j]
		low.part[j] = res[j]
		high.part[j] = res[j + 4]
	}
	return r
}

fn (u U128) + (n U128) U128 {
	mut r := U128{}
	r.part[0] = u.part[0] + n.part[0]
	return r
}

fn (u U128) right_logical(count int) U128 {
	mut r := U128{}
	assert count >= 0
	off := count >> 5
	sh := count & 31
	mut j := 0
	if sh == 0 {
		// Be portable: don't assume that a shift by (32-0) below yields 0.
		for j = 0; j + off < 4; j++ {
			r.part[j] = u.part[j + off]
		}
	} else {
		for j = 0; j + off + 1 < 4; j++ {
			r.part[j] = (u.part[j + off] >> sh) | (u.part[j + off + 1] << (32 - sh))
		}
		if j + off < 4 {
			r.part[j] = u.part[j + off] >> sh
			j++
		}
	}
	for ; j < 4; j++ {
		r.part[j] = 0
	}
	return r
}

fn (u U128) shift_left(count int) U128 {
	assert count >= 0
	off := count >> 5
	sh := count & 31
	mut j := 0
	mut r := U128{}
	if sh == 0 {
		// Be portable: don't assume that a shift by (32-0) below yields 0.
		for j = 3; j - off >= 0; j-- {
			r.part[j] = u.part[j - off]
		}
	} else {
		for j = 3; j - off - 1 >= 0; j-- {
			r.part[j] = (u.part[j - off] << sh) | (u.part[j - off - 1] >> (32 - sh))
		}
		if j - off >= 0 {
			r.part[j] = u.part[j - off] << sh
			j--
		}
	}
	for ; j >= 0; j-- {
		r.part[j] = 0
	}
	return r
}

fn (u U128) @or(n U128) U128 {
	mut r := U128{}
	for i in 0 .. 3 {
		r.part[i] = u.part[i] | n.part[i]
	}
	return r
}

fn (u U128) xor(n U128) U128 {
	mut r := U128{}
	for i in 0 .. 3 {
		r.part[i] = u.part[i] ^ n.part[i]
	}
	return r
}

fn (u U128) and(n U128) U128 {
	mut r := U128{}
	for i in 0 .. 3 {
		r.part[i] = u.part[i] & n.part[i]
	}
	return r
}

fn (u U128) unsigned_add(n U128) U128 {
	mut r := U128{}
	mut carry := u64(0)
	for j := 0; j < 4; j++ {
		carry += u.part[j]
		r.part[j] = u32(carry) + n.part[j]
		carry >>= 32
	}
	// TODO: expose carry somehow?
	// return carry != 0;
	return r
}
