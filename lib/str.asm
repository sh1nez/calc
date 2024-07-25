global num2str
global numlen

;rax rsi rdx 
num2str: ;-> rsi
	push rdx
	add rsi, rdx
	mov byte [rsi], 0x0A
	mov rbx, 10
.str_loop:
	xor rdx, rdx
	div rbx
	add dl, '0'
	dec rsi
	mov byte [rsi], dl
	test rax, rax
	jnz .str_loop
	pop rdx
	ret

;rax 
numlen:  ; -> rdx
	push rax
	mov rbx, 10
	xor rcx, rcx
.strlen_loop:
	xor rdx, rdx
	div rbx
	inc rcx
	test rax, rax
	jnz .strlen_loop
	pop rax
	mov rdx, rcx
	ret


