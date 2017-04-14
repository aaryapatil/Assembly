section .data
msg: db "Enter the string:",10
len: equ $-msg
menu: db "Enter choice: 1.Display Length of string 2.Reverse string and Check if string is a Palindrome 4.EXIT",10
menulen: equ $-menu
msg1: db "The length of the string is: ", 10
len1: equ $- msg1
msg2: db " ", 10
len2: equ $- msg2
msg3: db "The string is a Palindrome.", 10
len3: equ $- msg3
msg4: db "The string is not a Palindrome!!", 10
len4: equ $- msg4
msg5: db "The reverse of the string is:", 10
len5: equ $- msg5
msg6: db "Thank You!", 10
len6: equ $- msg6
msg7: db "",10
len7: equ $-msg7

section .bss
option: resb 1
string: resb 100
length: resq 1
temp: resq 1
cnt2: resb 2
cnt3: resb 2
ans: resb 4
revaddress: resb 20

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro input 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text
global main
main:

print menu,menulen

input option,2

cmp byte[option],31h
je callen

cmp byte[option],32h
je reverse

;cmp byte[option],33h
;je palindrome

cmp byte[option],34h
je Exit

callen:
print msg,len
input string,20
print msg1,len1
mov qword[length],00h
mov rsi,string

looping:
cmp byte[rsi],0Ah
je outloop
inc word[length]
inc rsi
jmp looping


outloop:
mov bx,word[length]
call convertH
print ans,4
print msg7,len7
jmp main

reverse:
mov qword[revaddress],00h
print msg,len
input string,20
print msg5, len5
mov qword[length],00h
mov rsi,string
end:
cmp byte[rsi],0Ah
je done
inc word[length]
inc rsi
jmp end

done:
dec rsi
mov rdi,revaddress

copyloop:
mov dl, [rsi]
mov [rdi], dl
check:
add rdi, 1h
sub rsi, 1h
dec word[length]
jnz copyloop

print revaddress,30
print msg7, len7

palindrome:
mov rsi, string
mov rdi, revaddress

checkloop:
	mov cl, byte[rsi]
	mov dl, byte[rdi]
	cmp cl, dl
	jne notpalin
	inc rsi
	inc rdi
	mov cl, byte[rsi]
	cmp cl, 0Ah
	jne checkloop
	print msg3, len3
	print msg7,len7
		jmp main
	notpalin:
		print msg4, len4
        print msg7,len7
        jmp main

Exit:
mov rax,60
mov rdi,0
syscall


convertH:
mov rsi,ans
mov byte[cnt3],4
AGAIN2:
rol bx,04
mov cl,bl
AND cl,0Fh
cmp cl,09
jbe loop2
add cl,07h
loop2:
add cl,30h
mov byte[rsi],cl
inc rsi
dec byte[cnt3]
jnz AGAIN2
RET

