extern str1,str2,msg2,msg3,msg4,msg5,msg6,msg7,len2,len3,len4,len5,len6,len7
global concat,substring

section .data
msg: db "",10
len: equ $-msg

section .bss
address: resb 40
length1: resq 1
length2: resb 1
sub: resb 6
occurences: resb 2
temp: resq 1
templen: resb 1

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

concat:
mov qword[length1],00h
print msg2,len2
input str1,20
dec al
mov byte[length1],al    ;calculate length of string1

print msg3,len3
input str2,20
mov byte[length2],al    ;calculte length of string2

mov rdi,str1            ;concatenate string2 after string1
add rdi,[length1]
mov rsi,str2
again:                  ;move byte by byte

mov bl,byte[rsi]
mov byte[rdi],bl

add rsi,1               ;increment pointers
add rdi,1
dec byte[length2]
jnz again

print msg6,len6
print str1,40           ;print concatenated string

RET

substring:

print msg4,len4
input str1,20
dec al
mov byte[length1],al       ;calcualte length of string

print msg5,len5
input sub,6
mov byte[occurences],00h   ;initialise 

mov rsi,str1
mov rdi,sub

back:
mov al,byte[rsi]
cmp byte[rdi],al
jne next
mov qword[temp],rsi
mov al,byte[length1]
mov byte[templen],al
looping:
inc rdi
cmp byte[rdi],0Ah          ;compare with new line character to check end of substring
je occur
inc rsi
dec byte[length1]
mov al,byte[rsi]
cmp byte[rdi],al
je looping

mov rsi,qword[temp]
mov al,byte[templen]
mov byte[length1],al
jmp next

occur:
inc byte[occurences]       ;increment the occurences  
mov rsi,qword[temp]
mov al,byte[templen]
mov byte[length1],al

next:
inc rsi
mov rdi,sub
dec byte[length1]          ;to check end of string
jnz back

print msg7,len7
mov al,byte[occurences]    ;convert to ascii
cmp al,09h
jbe ascii
add al,07h
ascii:
add al,30h
mov byte[occurences],al
print occurences,2
print msg,len
RET


