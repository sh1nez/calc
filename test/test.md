EFLAGS:
zf - zero flag (if cmp == 0) -> jz | jnz
sf - sign falg (if cmp < 0) -> js | jns | jb | jnae
of - overflow flag (overflow with OUT sign) -> jo | jno
cf - carry flag (overflow with sign) -> jc | jnc
pf - parity flag -> jp | jnp ;; Флаг четности: устанавливается, если младшие 8 битов результата содержат четное число единиц. wrf??

other:
	https://metanit.com/assembler/tutorial/1.3.php
	http://mf.grsu.by/UchProc/livak/b_org/oal_7.htm

jumps:

je jz  == (ZF == 1)
jne jnz != (ZF == 0)

jg jnle > (ZF == 0 and SF == OF) ; для знаковых
jng <= (ZF == 0 or SF !+ OF)

jl jnge < SF != DF
jnl >= (SF == OF)

ja jnbe > (ZF == 0 and CF == 0) ; для беззнаковых точно гарантированно
jae >= (CF == 0)

jb jnae < (CF == 1)
jbe <= (CF == 0 and ZF ==0)

jmpq x86_64 jmp
jmp short (<128 byte)
jrcxz jecxz (rcx | ecx == 0) rcx == 0

rsp - last used byte
rbp - last last used byte (base of stack)
: no pusha
