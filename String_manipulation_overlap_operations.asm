section .data
msg1: db "Enter the option for string manipulation: 1.NonOverlap without string 2.Overlap without string 3.NonOverlap with string 4.Overlap with string 5.Exit",10
len1: equ $-msg1
msg2: db " "
len2: equ $-msg2
array: dd 12345678h,23456789h,34567890h
msg3: db "",10
len3: equ $-msg3
msg4: db "Before copying",10
len4: equ $-msg4
msg5: db "After copying",10
len5: equ $-msg5
msg6: db "Enter the offset for overlap between 0 to 2:",10
len6: equ $-msg6
msg7: db " ",10
len7: equ $-msg7
msg8: db "Offset should be less than 3",10
len8: equ $-msg8

section .bss
option: resb 2
offset: resb 2
cnt: resb 2
ans: resq 1
address: resq 1
answer: resq 2
location: resq 1
start: resq 1
cnt3: resb 2

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

print msg1,len1

input option,2           ;read the option 

cmp byte[option],31h     ;compare option to those given
je Nonoverlap

cmp byte[option],32h
je Overlap

cmp byte[option],33h
je Nonoverlaps

cmp byte[option],34h
je Overlaps

cmp byte[option],35h
je Exit

Nonoverlap:              ;nonoverlap without string instructions

call initial             ;print condition before copying

print msg5,len5
mov rsi,array
mov rdi,address
mov qword[location],rdi
mov qword[start],rsi

mov byte[cnt],3
again3:                  ;move byte by byte

mov rdi,qword[location]
mov rsi,qword[start]

mov eax,dword[rsi]
mov dword[rdi],eax

call convertH
print ans,8
print msg2,len2
call convertaddress
print answer,16
add qword[location],4
add qword[start],4
dec byte[cnt]
print msg3,len3
jnz again3

jmp main

Overlap:                 ;overlap without string instructions

print msg6,len6
input offset,2           ;input offset
mov al,byte[offset]      ;convert offset from ascii to hex
cmp al,39h
jbe label
sub al,07h
label:
sub al,30h
mov byte[offset],al      

cmp byte[offset],0h      ;check if offset is within specified limits
je right

cmp byte[offset],1h
je right

cmp byte[offset],2h
je right

print msg8,len8
jmp main

right:
call initial
print msg5,len5
mov rsi,array
add rsi,8h               ;point to the last location of given array 
mov qword[start],rsi          
mov qword[location],rsi
mov ax,0x00
mov al,byte[offset]
mov bl,0x04              ;add offset*4 to last location of given array
mul bl
add word[location],ax

mov byte[cnt],3
again4:

mov rdi,qword[location]
mov rsi,qword[start]

mov eax,dword[rsi]
mov dword[rdi],eax

call convertH
print ans,8

print msg2,len2
call convertaddress
print answer,16
sub qword[location],4
sub qword[start],4
print msg7,len7
dec byte[cnt]
jnz again4

jmp main

Nonoverlaps:            ;nonoverlap with string instructions

print msg5,len5
mov rsi,array
mov rdi,address
mov byte[cnt],3
CLD                     ;clear direction flag to post increment
Backs:
MOVSD
dec byte[cnt]
jnz Backs


mov rsi,address
mov qword[location],rsi
mov byte[cnt],3
loops:

mov rsi,qword[location]

mov eax,dword[rsi]

call convertH
print ans,8
print msg2,len2
call convertaddress
print answer,16
add qword[location],04h
dec byte[cnt]
print msg7,len7
jnz loops

jmp main

Overlaps:                 ;overlap with string instructions

print msg6,len6
input offset,2
mov al,byte[offset]
cmp al,39h
jbe label1
sub al,07h
label1:
sub al,30h
mov byte[offset],al

cmp byte[offset],0h
je right1

cmp byte[offset],1h
je right1

cmp byte[offset],2h
je right1

print msg8,len8
jmp main

right1:

print msg5,len5

mov rsi,array
add rsi,8h

mov qword[location],rsi
mov ax,0x00
mov al,byte[offset]
mov bl,0x04
mul bl
add word[location],ax
mov rdi,qword[location]

mov byte[cnt],3
STD                         ;set direction flag to post decrement
againstring:
MOVSD
dec byte[cnt]
jnz againstring

mov rsi,qword[location]
mov byte[cnt],3
loopstring:

mov rsi,qword[location]

mov eax,dword[rsi]

call convertH
print ans,8
print msg2,len2
call convertaddress
print answer,16
sub qword[location],04h
dec byte[cnt]
print msg7,len7
jnz loopstring

jmp main
Exit:

mov rax,60               ;exit system call
mov rdi,0
syscall

convertH:                ;convert hex to ascii
mov rsi,ans
mov byte[cnt3],8
AGAIN2:
rol eax,04
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

convertaddress:           ;convert the address from hex to ascii
mov rax,qword[location]
mov rsi,answer
mov byte[cnt3],0x10
AGAIN:
rol rax,04
mov cl,al
AND cl,0Fh
cmp cl,09
jbe loop
add cl,07h
loop:
add cl,30h
mov byte[rsi],cl
inc rsi
dec byte[cnt3]
jnz AGAIN
RET

initial:                ;print initial condition of array
print msg4,len4
mov rsi,array
mov qword[location],rsi
mov byte[cnt],3
again:

mov rsi,qword[location]

mov eax,dword[rsi]

call convertH
print ans,8
print msg2,len2
call convertaddress
print answer,16
add qword[location],4
dec byte[cnt]
print msg3,len3
jnz again
RET
