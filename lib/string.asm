section .text
	global str2int
	global int2str
	global strlen

; rsi - string
str2int: ; -> rax
	xor rax, rax
	mov rcx, 10
.str_loop:
	movzx rbx, byte [rsi]
	test rbx, rbx
	jz .done
	sub rbx, '0'
	mul rcx
	add rax, rbx
	inc rsi
	jmp .str_loop
.done:
	ret

; rax - num
; rsi - fd
; rdx - len
int2str: 
	mov rbx, 10 ; for div
	mov rcx, rsi
	add rsi, rdx
	dec rsi
.loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	mov [rcx + rdx], dl
	dec rsi
	test rax, rax ; 1 if rax == 0
	jnz .loop
	inc rsi
	ret

; esi
strlen: ; -> ecx
	mov ecx, 0
.loopy:
	mov al, [esi]
	cmp al, 0
	je .done

	inc esi
	inc ecx
	jmp .loopy
.done:
	ret
