.name "tester"
.comment "test ldi ind"


ldi 5, r3, r3
st r3, 10

#will do nothing if r is <= 0 or > REG_NUM
