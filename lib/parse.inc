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
%%parse_loop:
	mov dil, byte [rsi]
	sub dil, '0'
	jb %%done_parse_num
	cmp dil, 9
	ja %%done_parse_num
	imul rax, rax, 10
	add rax, dil
	inc rsi
	jmp %%parse_loop
%%done_parse_num:
%endmacro
