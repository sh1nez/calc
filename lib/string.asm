section .text
	global str2int
	global int2str
	global strlen

; rsi - string
str2int: ; -> rax
	xor rax, rax
	mov rcx, 10
.str_loop:
	movzx rbx, byte [rsi] ; с расширение берём первый байт из rsi
	test rdx, rdx; если строка кончилась
	jz .done
	sub rbx, '0'
	mul rcx
	add rax, rbx
	inc rsi
	dec rdx
	jmp .str_loop
.done:
	ret

; rax - num
; rsi - fd
; rdx - len
int2str: ; -> rsi
	mov rbx, 10
	mov rcx, rsi
	add rsi, rdx
	; mov [rsi], 0
	dec rsi ; указывает на последний действительный элемент буфера
.loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	mov [rsi], dl
	dec rsi
	test rax, rax
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
