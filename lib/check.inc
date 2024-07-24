%macro IS_NUM_OR_SIGN 0
	cmp rbx, '0'
	jb short .not_num
	cmp rbx, '9'
	ja short .not_num
	jmp short .true_num_sign
.not_num_sign:
	cmp rbx, '-'
	je short .true_num
	cmp rbx, '+'
	je short .true_num_sign
	mov rax, 1
	ret
.true_num_sign:
%endmacro

%macro IS_OP 0
    cmp rbx, '+' 
    je short .true_op  
    cmp rbx, '-' 
    je short .true_op  
    cmp rbx, '*' 
    je short .true_op  
    cmp rbx, '/' 
    je short .true_op  
    cmp rbx, '%' 
    je short .true_op  
    mov rax, 1   
    ret
.true_op:
%endmacro


