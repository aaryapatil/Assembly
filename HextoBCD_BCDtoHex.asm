section .data
msg: db "Enter your choice: 1. HEX to BCD 2.BCD to HEX 3.EXIT",10
len: equ $-msg
msg1: db "The equivalent BCD number is:",10
len1: equ $-msg1
msg2: db "Enter the 4 digit hexadecimal number:",10
len2: equ $-msg2
msg3: db "Enter the 5 digit BCD number:",10
len3: equ $-msg3
msg4: db "The equivalent hexadecimal number is:"

section .bss
option: resb 1
hex: resb 5
cnt2: resb 2
cnt3: resb 2
ans: resb 4
address:resq 4
bcd: resb 6
sum: resq 4
ten: resb 1
hexsum: resw 1

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
print msg2,len2
input hex,5
mov rsi,hex
call convertA4

mov rcx,00h
mov eax,00h
mov ax,bx
mov bx,0Ah

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
cmp dl,09h
jbe next
add al,07h
next:
add dl,30h
mov byte[rdi],dl
inc rdi
loop looping

print msg1,len1
print address,5
jmp main

convertBCD:
print msg3,len3

input bcd,6
mov rsi,bcd

mov cx,0x2710
mov eax,0x00
mov byte[ten],0x0A
mov word[hexsum],0x00

again1:
mov al,byte[rsi]
sub al,30h
mul cx
add word[hexsum],ax
inc rsi
mov ax,cx
mov bl,byte[ten]
div bl
mov cx,ax
cmp cx,0x01
je nextpart
jge again1

nextpart:
mov ax,word[hexsum]
call convertH
print ans,4

jmp main




Exit:
mov rax,60
mov rdi,0
syscall


convertA4:
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

convertA5:
mov rbx,0h
mov byte[cnt2],5
AGAIN1:
rol rbx,04
mov cl,byte[rsi]
cmp cl,39h
jbe loop1
sub cl,07h
loop1:
sub cl,30h
add bl,cl
inc rsi
dec byte[cnt2]
jnz AGAIN1
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
