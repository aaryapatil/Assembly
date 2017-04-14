section .data
msg: db "Enter your choice: 1. HEX to BCD 2.BCD to HEX 3.EXIT",10
len: equ $-msg
msg1: db "Enter 4 digit Hexadecimal number:",10
len1: equ $-msg1
msg2: db "The equivalent BCD number is:"
len2: equ $-msg2
msg3: db "Enter 5 digit BCD number(0-65535):",10
len3: equ $-msg3
msg4: db "The equivalent Hexadecimal number is:"
len4: equ $-msg4
msg5: db "",10
len5: equ $-msg5

section .bss
option: resb 1
hex: resb 4
cnt2: resb 2
cnt3: resb 2
ans: resb 4
address:resq 1
a: resq 1
count: resb 1

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

print msg,len

input option,2

cmp byte[option],31h
je convertHEX

cmp byte[option],32h
je convertBCD

cmp byte[option],33h
je Exit

convertHEX:

print msg1,len1
input hex,5
mov rsi,hex
call convertA

xor rcx,rcx
xor eax,eax
mov ax,bx
mov bx,0Ah

mov dword[address],00h

loops:
mov dx,00h
div bx
push dx
inc rcx
cmp ax,0h
jne loops

mov rdi,address
   looping:
        pop dx
        add dl,30h
        mov byte[rdi],dl
        inc rdi
        loop looping

print msg2,len2

print address,5

print msg5,len5
jmp main

convertBCD:

print msg3,len3
input a,6
print msg4,len4   

mov rsi,a
mov rcx,05h
xor ax,ax
mov bx,0Ah
    
    multiply:
        mov dx,0
        mul bx       
        mov dl,byte[rsi]   
        sub dl,30h  
        add ax,dx 
        inc rsi
        loop multiply
        
call convertH
print ans,4

print msg5,len5
jmp main

Exit:
mov rax,60
mov rdi,0
syscall


convertA:
mov bx,0h
mov byte[cnt2],4
AGAIN:
rol bx,04
mov cl,byte[rsi]
cmp cl,39h
jbe loop
sub cl,07h
loop:
sub cl,30h
add bl,cl
inc rsi
dec byte[cnt2]
jnz AGAIN
RET


convertH:
mov rsi,ans
mov byte[cnt3],4
AGAIN2:
rol ax,04
mov cl,al
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
