.name "tester"
.comment "test sti"

ld %3, r3
st r1, 6
live %0
sti r3, %345, %53
live %0
sti r3, %345, %53
live %0
sti r3, %345, %53
st r1, 6
live %0
sti r3, %34, %53
live %1
sti r3, %34, %53
live %1
sti r3, %345345, %53

#will do nothing if r is <= 0 or > REG_NUM

