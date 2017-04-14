section .data
msg1: db "Enter the number of 64 bit numbers to be accepted:",10
len1: equ $-msg1
msg2: db "Enter a 64 bit number(16 digit)",10
len2: equ $-msg2
msg3: db "The addition of accepted numbers is:",10
len3: equ $-msg3

section .bss
accept: resq 2
array: resq 9
sum: resq 1
cnt: resb 2
cnt2: resb 2
cnt3: resb 2
ans: resq 2
carry: resb 2
address: resq 1

%macro print 2        ;print system call macro
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro input 2        ;read system call macro
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text
global main
main:

print msg1,len1       ;print message

input cnt,2           ;read count of numbers to be input
mov al,byte[cnt]      ;convert count from acsii to hex
cmp al,39h
jbe label
sub al,07h
label:
sub al,30h
mov byte[cnt],al
dec byte[cnt]
 
 mov qword[sum],0x00      ;initialise sum
 mov qword[address],array ;to store numbers at the reserved memory location
 BACK:
 
 print msg2,len2 
 input accept,17          ;read 16 digit number

 call convertA            ;convert from ascii to hex
 mov rsi,qword[address]
 mov qword[rsi],rbx       ;store number in array
 add qword[address],8
 add qword[sum],rbx       ;add to sum
 
 dec byte[cnt]
 
 jnz BACK

print msg2,len2 
input accept,17

call convertA
mov rsi,qword[address]
mov qword[rsi],rbx
CLC
add qword[sum],rbx

print msg3,len3

jnc label2                  ;check carry bit
mov al,31h                  ;print the carry bit
mov byte[carry],al
print carry,2

label2:

mov rax,qword[sum]          ;print sum
call convertH               ;convert hex to ascii
print ans,16

mov rax,60                  ;exit system call
mov rdi,0
syscall

convertH:                   ;convert hex to ascii
mov rsi,ans
mov byte[cnt3],0x10
AGAIN2:
rol rax,04
mov cl,al
AND cl,0Fh
cmp cl,09h
jbe loop2
add cl,07h
loop2:
add cl,30h
mov byte[rsi],cl
inc rsi
dec byte[cnt3]
jnz AGAIN2
RET

convertA:                   ;convert ascii to hex
mov rbx,0x00
mov rsi,accept
mov byte[cnt2],0x10
AGAIN:
rol rbx,04
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


