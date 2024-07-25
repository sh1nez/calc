global is_num_or_sign
global is_op

is_num_or_sign: 
	xor rax, rax
	mov dil, byte [rsi]
    cmp dil, '0'
    jb .not_num_or_sign

    cmp dil, '9'
    ja .not_num_or_sign

    cmp dil, '-'
    je .is_num

    cmp dil, '+'
    je .is_num

.not_num_or_sign:
	mov rax, 1
	ret

.is_num:
	ret


is_op:
	xor rax, rax
    cmp dil, '+' 
    je short .true_op  
    cmp dil, '-' 
    je short .true_op  
    cmp dil, '*' 
    je short .true_op  
    cmp dil, '/' 
    je short .true_op  
    mov rax, 1   
    ret
.true_op:
	ret


