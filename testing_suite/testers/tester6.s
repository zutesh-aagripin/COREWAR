.name		"Tester6"
.comment	"What if I press this?.."

	xor r1, r2, r3
	xor r3, r4, r5
loop:
	st r5, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
