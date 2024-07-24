%macro PRE_SKIP_SPACE 0
.pre_space_loop:
	movzx di, byte [rsi]
	cmp di, ' '
	je short .pre_space_loop
%endmacro

; rcx - sum
%macro PARSE_NUM 0
	xor rax, rax
	mov rbx, 10
.num_loop:
	movzx rdi, byte [rsi]
	cmp rdi, '0'
	jb short .num_end
	cmp rdi, '9'
	ja short .num_end
	sub rdi, '0'
	mul rbx
	add rax, rdi
	inc rsi
	jmp short .num_loop
.num_end:
%endmacro
