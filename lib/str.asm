; rax, rdx, rsi
num2str:
	push rdx
	add rsi, rdx
	mov byte [rsi], '\n'
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
	xor rcx, rcx 
	mov rbx, 10
.strlen_loop:
	div rbx
	inc rcx
	test rax, rax
	jnz .strlen_loop
	mov rdx, rcx
	ret
