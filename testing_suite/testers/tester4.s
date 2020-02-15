.name		"Tester4"
.comment	"What if I press this?.."

	add r1, r1, r2
	add r2, r2, r3
	add r3, r3, r4
	sub r4, r3, r5
	sub r5, r2, r6
	sub r6, r1, r7
loop:
	st r7, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
