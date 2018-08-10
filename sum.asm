%macro input 2
    
    mov eax, 3 ; input
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    
%endmacro

%macro output 2
    
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2

%endmacro

%macro soma 3
    
    mov ecx, %1
    sub ecx, '0'
    mov ebx, %2
    sub ebx, '0'
    add ecx, ebx
    mov %3, ecx
    mov ah, %3
    cmp ah, 0xA ; comparador auxiliar para saber se a soma deu >= 10
    jge soma1
    
    add ecx, '0' ; auxiliar para nao retornar errado na tabela ascii
    mov %3, ecx
    jmp end
    
    soma1:
        
        sub ecx, 0xA
        add ecx, '0'
        mov %3, ecx
        
        output decimal, 1
        int 80h
        
    end:
        
    
    
%endmacro

section .data

    msg1: db "Digite um numero de 0 a 9", 0xA 
    msg1Len: equ $ -msg1

    msg2: db "Voce digitou:"
    msg2Len: equ $ -msg2
    
    aux: db " ", 0xA ; serve como quebra de linha
    auxLen: equ $ -aux
    
    msgSoma: db "O resultado da soma eh: "
    msgSomaLen: equ $ -msgSoma
    
    decimal: db "1"


section .bss
    
    num1 resb 1 ; reserva 1 byte para usuario colocar input1
    num2 resb 1 ; reserva 1 byte para usuario colocar input2
    result resb 1 ; reserva 1 byte para resultado da soma
    
section .text

global _start

_start:
    
    output msg1, msg1Len
    int 80h
    
    
    input num1, 1
    int 80h
    
    output msg2, msg2Len
    int 80h
    
    output num1, 1
    int 80h
    
    output aux, auxLen
    int 80h
    
    output msg1, msg1Len
    int 80h
    
    input num2, 1
    int 80h
    
    output msg2, msg2Len
    int 80h
    
    output num2, 1
    int 80h
    
    output aux, auxLen
    int 80h
    
    output msgSoma, msgSomaLen
    int 80h
    
    soma [num1], [num2], [result]

    
    output result, 1
    int 80h
    
    mov  eax,1
    mov  ebx,0 
    int  80h
