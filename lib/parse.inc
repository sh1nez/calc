%macro PRE_SKIP_SPACE 0
    %%skip_space:
        mov dil, byte [rsi]
        cmp dil, ' '
        jne %%done_skip_space
        inc rsi
        jmp %%skip_space
    %%done_skip_space:
%endmacro


%macro PARSE_NUM 0
    xor rax, rax
	mov rbx, 10
%%parse_loop:
	movzx rdi, byte [rsi]
	sub rdi, '0'
	jb %%done_parse_num
	cmp rdi, 9
	ja %%done_parse_num
	mul rbx
	add rax, rdi
	inc rsi
	jmp %%parse_loop
%%done_parse_num:
%endmacro
