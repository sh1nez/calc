%macro IS_NUM_OR_SIGN 0
	mov dil, [rsi]
    cmp dil, '0'
    jb %%not_num_or_sign

    cmp dil, '9'
    ja %%not_num_or_sign

    cmp dil, '-'
    je %%is_num

    cmp dil, '+'
    je %%is_num

%%not_num_or_sign:
	mov rax, 1
	ret

%%is_num:

%endmacro


%macro IS_OP 0
    cmp dil, '+' 
    je short %%true_op  
    cmp dil, '-' 
    je short %%true_op  
    cmp dil, '*' 
    je short %%true_op  
    cmp dil, '/' 
    je short %%true_op  
    cmp dil, '%' 
    je short %%true_op  
    mov rax, 1   
    ret
%%true_op:
%endmacro


