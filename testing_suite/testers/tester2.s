.name		"Tester"
.comment	"Does this help?.."

loop:
	sti r1, %:live, %1
	sti r1, %:live2, %1
	sti r1, %:live3, %1
	sti r1, %:live4, %1
	sti r1, %:live5, %1
	sti r1, %:live6, %1
live:
	live %0
live2:
	live %0
live3:
	live %0
live4:
	live %0
live5:
	live %0
live6:
	live %0
	ld %0, r2
	zjmp %:loop
