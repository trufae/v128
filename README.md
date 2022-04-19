v128
====

Imagine operating with 128bit integer values on 32bit systems.

Now stop imagining, it's now for real!

--pancake

Status
------

This code is inspired by:

* https://github.com/flang-compiler/flang/blob/master/include/int128.h
* https://github.com/flang-compiler/flang/blob/master/lib/scutil/int128.c

This module is still WIP, it requires tests and discussion to get more
operator overloading magic and how to better handle string-from/to,

Testing, feedback and contribs are welcome. But i hope to finish this soon and
get this module merged into the official vlang branch.

If you are still willing to read more on this check links below:

* https://www.linuxfixes.com/2021/10/solved-is-there-128-bit-integer-in-gcc.html
* https://www.avrfreaks.net/forum/tut-signed-and-unsigned-multiplication
