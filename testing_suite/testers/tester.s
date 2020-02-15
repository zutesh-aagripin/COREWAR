.name		"Tester"
.comment	"What if I press this?.."

loop:
	sti r1, %:live, %1
live:
	live %0
	ld %0, r2
	fork %:loop
	zjmp %:loop
