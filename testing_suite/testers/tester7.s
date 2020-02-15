.name		"Tester7"
.comment	"What if I press this?.."

sti:
	sti r1, %200, %0
	ldi %:sti, %200, r10
loop:
	st r10, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
