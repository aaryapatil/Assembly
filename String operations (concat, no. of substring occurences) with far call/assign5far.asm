global str1,str2,msg2,msg3,msg4,msg5,msg6,msg7,len2,len3,len4,len5,len6,len7
extern concat,substring

section .data
msg1: db "Enter the option 1.Concatenate string 2.Find number of occurences of substring",10
len1: equ $-msg1
msg2: db "Enter first string:"
len2: equ $-msg2
msg3: db "Enter second string:"
len3: equ $-msg3
msg4: db "Enter string:"
len4: equ $-msg4
msg5: db "Enter the substring:"
len5: equ $-msg5
msg6: db "The concatenated string is:"
len6: equ $-msg6
msg7: db "The number of occurences of substring is:"
len7: equ $-msg7

section .bss
option: resb 2
str1: resb 40
str2: resb 20

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

print msg1,len1
input option,2

cmp byte[option],31h
je p1

cmp byte[option],32h
je p2

cmp byte[option],33h
je exit

p1:
call concat       ;concat procedure far call
jmp _start

p2: 
call substring    ;substring procedure far all
jmp _start

exit:             ;exit system call
mov rax,60
mov rdi,0
syscall


