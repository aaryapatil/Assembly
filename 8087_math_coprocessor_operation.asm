SECTION .data
msg0: db "",0x0A
len0: equ $-msg0
msg: db "The nos are 182.43,154.23,145.32,124.51,142.76",0x0a
len: equ $-msg
msg1: db "The mean is ",0x0a
len1: equ $-msg1
msg2: db "The variance is",0x0a
len2: equ $-msg2
msg3: db "The standard deviation is",0x0a
len3: equ $-msg3
arr: dd 182.43,154.23,145.32,124.51,142.76
acount: dw 5
mult: dd 100
dot: db "."

SECTION .bss
%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

count: resb 2
mean: resd 2
var: resd 2
std: resd 2
rest1: rest 1
h: resb 2
cnt: resb 2
v: resd 2


SECTION .text
global _start
_start:

print msg,len             ;mean
finit 
fldz
mov cx,word[acount]		;add all numbers in array to top of stack
mov rsi,arr 
sumofarr:
fadd dword[rsi]
add rsi,4
dec cx
jnz sumofarr

fidiv word[acount]
fst dword[mean]
fimul dword[mult]
fbstp tword[rest1]
print msg1,len1
call display

mov dword[v],0h
mov rsi,arr
mov cx,word[acount]
loop1:
fldz                     ;variance
fld dword[rsi]
fsub dword[mean]
add rsi,4
fst st1
fmul
fadd dword[v]
fst dword[v]
dec cx
jnz loop1

fld dword[v]
fidiv word[acount]
fst dword[var]
fimul dword[mult]
fbstp tword[rest1]
print msg2,len2
call display


fld dword[var]   ;standard deviation
fsqrt 
fimul dword[mult]
fbstp tword[rest1]
print msg3,len3
call display

exit:
mov rax,60
mov rdi,0
syscall

display:
mov r9,00h
mov r9,rest1                               ;converting no to desired form
add r9,9h                                     ;msb to lsb
mov cl,09h
mov byte[cnt],cl
disp:
mov bl,byte[r9]
call bcdtoa
print h,2                                   ;printing 18 digits
dec r9
dec byte[cnt]
jnz disp

print dot,1            ;printing dot

mov bl,byte[rest1]
call bcdtoa
print h,2
print msg0,len0
ret


bcdtoa:
mov rdi,h
mov ch,02
loop:
rol bl,04h
mov dl,bl
and dl,0fh
add dl,30h
mov byte[rdi],dl
inc rdi
dec ch
jnz loop
ret
