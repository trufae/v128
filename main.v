module main

import u128

fn main() {
	mut n := u128.from_int(123)
	mut n2 := u128.from_string('123')
	b := n + n2
	println('$b')
	c := u128.from_int(3) * u128.from_int(3)
	println('$c')
	
}

