.name		"Tester5"
.comment	"What if I press this?.."

	or r1, r2, r3
	and r3, r1, r7
loop:
	st r7, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
