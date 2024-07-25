global skip_space
global parse_num

skip_space: ;rsi -> not space
.skip:
	mov dil, byte [rsi]
	cmp dil, ' '
	jne .done
	inc rsi
	jmp .skip
.done:
	ret


parse_num:
    xor rax, rax
	mov rbx, 10
.parse_loop:
	movzx rdi, byte [rsi]
	sub rdi, '0'
	jb .done
	cmp rdi, 9
	ja .done
	mul rbx
	add rax, rdi
	inc rsi
	jmp .parse_loop
.done:
	ret


