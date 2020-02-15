.name		"Tester3"
.comment	"What if I press this?.."

	st r1, r2
	st r2, r3
	st r3, r4
	st r4, r6
	st r6, r8
	st r8, r10
	st r10, r11
	st r11, r12
	st r12, r13
	st r13, r14
	st r14, r15
loop:
	st r15, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
