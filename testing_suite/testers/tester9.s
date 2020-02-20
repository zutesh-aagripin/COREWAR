.name		"Tester9"
.comment	"What if I press this?.."

sti:
	sti r1, %200, %0
	ldi %:sti, %200, r1
	ldi %:sti, %200, r2
	ldi %:sti, %200, r3
	ldi %:sti, %200, r4
	ldi %:sti, %200, r5
	ldi %:sti, %200, r6
	ldi %:sti, %200, r7
	ldi %:sti, %200, r8
	ldi %:sti, %200, r9
	ldi %:sti, %200, r10
	ldi %:sti, %200, r11
	ldi %:sti, %200, r12
	ldi %:sti, %200, r13
	ldi %:sti, %200, r14
	ldi %:sti, %200, r15
	ldi %:sti, %200, r16
loop:
	st r1, 200 
	st r2, 200 
	st r3, 200 
	st r4, 200 
	st r5, 200 
	st r6, 200 
	st r7, 200 
	st r8, 200 
	st r9, 200 
	st r11, 200 
	st r12, 200 
	st r13, 200 
	st r14, 200 
	st r15, 200 
	st r16, 200 
	st r10, 6 
live:
	live %0
	ld %0, r2
	zjmp %:loop
