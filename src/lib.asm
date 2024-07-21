section .text
	global str2int
	global int2str
; rsi - string
str2int: ; -> rax
	xor rax, rax
	mov rcx, 10
.str_loop:
	movzx rbx, byte [rsi]
	test rbx, rbx
	jz .done
	sub rbx, '0'
	imul rax, rax, rcx
	add rax, rbx
	inc rsi
	jmp .str_loop
.done:
	ret

; rax - num
int2str: ; rsi - string
	mov rbx, 10
	mov rcx, rdi
	mov rdx, 0
.loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	mov [rcx + rdx], dl
	inc rdx
	test rax, rax ; 1 if rax == 0
	jnz .loop
	mov byte [rcx + rdx], 0
	ret
asdfas
