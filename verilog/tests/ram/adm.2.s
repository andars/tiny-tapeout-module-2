!rand
!ram
/ select ram 0
LDM 0
DCL
CLC
/ load value into accumulator
LDM 7
/ load address in {0, 1}
FIM 0P 0
/ set address
SRC 0
/ write value to ram
WRM

LDM 10
ADM

!expect accumulator: 0x1
!expect ram 0 reg 0: 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
!expect carry: 1

