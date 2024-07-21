section .text
	global input_str2int
	global int2str

; rsi - string
input_str2int: ; -> rax
	xor rax, rax    
	mov rcx, 10  

.loop:
    movzx rbx, byte [rsi]
    cmp rbx, 10         
    je .done           
    sub rbx, '0'      
    mul rcx          
    add rax, rbx     
    inc rsi          
    jmp .loop 
.done:
    ret             

; rax - num
; rsi - fd
; rdx - len
int2str: ; -> rsi
	mov rbx, 10
	mov rcx, rsi
	add rsi, rdx
	mov byte [rsi], 0
	dec rsi 
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
