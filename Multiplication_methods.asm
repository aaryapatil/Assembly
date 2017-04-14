section .data
msg: db "Menu:",10,"1.Successive addition",10,"2.Add and shift method",10,"3.EXIT",10,"Enter choice:"
len: equ $-msg
msg1: db "Enter the Multiplicand:"
len1: equ $-msg1
msg2: db "Enter the Multiplier:"
len2: equ $-msg2
msg3: db "Reenter option (1-3)",10
len3: equ $-msg3
msg4: db "The multiplication result is(successive addition):",10
len4: equ $-msg4
msg5: db "The multiplication result is(add and shift method):",10
len5: equ $-msg5
msg6: db "",10
len6: equ $-msg6

section .bss
multiplicand:resb 2
multiplier: resb 2
cnt2: resb 2
cnt3: resb 2
ans: resb 10
num1: resb 2
count: resb 2
product: resw 1
option: resb 2
Q: resb 1
carry: resb 1

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
global _start
_start:

print msg,len
input option,2

cmp byte[option],31h
je successive

cmp byte[option],32h
je booths

cmp byte[option],33h
je Exit

print msg3,len3
jmp _start

successive:
print msg1,len1

input multiplicand,3
mov rsi,multiplicand
call convertA

mov byte[num1],bl

print msg2,len2
input multiplier,3
mov rsi,multiplier
call convertA

mov byte[count],bl
mov word[product],00h

looping:
mov bx,00h
mov bl,byte[num1]
add word[product],bx
dec byte[count]
jnz looping 

print msg4,len4
mov ax,word[product]
call convertH
print ans,4
print msg6,len6
jmp _start

booths:


print msg1,len1

input multiplicand,3
mov rsi,multiplicand
call convertA

mov byte[num1],bl

print msg2,len2
input multiplier,3
mov rsi,multiplier
call convertA

mov byte[Q],bl

print msg5,len5

mov byte[count],08h
mov byte[carry],00h
xor ax,ax
mov al,byte[Q]
mov bl,byte[num1]

shift:
BT ax,0
jnc noadd
add ah,bl
jc addition
noadd:
shr ax,01h
cmp byte[carry],01h
jne nextstep
BTS ax,15
nextstep:
dec byte[count]
jnz shift
jmp step

addition:
mov byte[carry],01h
jmp noadd

step:
call convertH
print ans,4
print msg6,len6
jmp _start

Exit:
mov rax,60
mov rdi,0
syscall

 
convertA:
mov bl,00h
mov byte[cnt2],2
AGAIN1:
rol bl,04
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
