%macro input 2
    
    mov eax, 3
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

%macro fatorial 2
    
    mov eax, %1
    sub eax, '0'
    mov ebx, eax
    
    cmp ebx, 1
    jg multiplica
    jmp end
    
    multiplica:
        
        dec ebx
        mul ebx
        cmp ebx, 1
        jg multiplica
    
    end:
        
        mov %2, eax
        
%endmacro

%macro conta 2
        
    mov eax, %1
    mov ebx,0
    mov ecx,10

    while:
        mov	edx,0
        div ecx
        add bx, 1
	    cmp eax,1
        jge while
    
    mov %2,ebx
    

%endmacro

%macro converte 2

    mov edi,%2
    sub edi, 1
    mov ebx, final
    add ebx,edi
    mov ecx, 10
    mov eax, %1
    mov edi,10
        
    for:
        mov edx,0
    	div edi
        add	edx,'0'
        mov	[ebx],dl
	    dec	ebx
	    loop for



%endmacro

    

section .data

    msg1: db "Digite um numero inteiro entre 0 e 9", 0xA 
    msg1Len: equ $ -msg1
    
    aux: db " ", 0xA
    auxLen: equ $ -aux
    
    msgFatorial: db "fatorial de "
    msgFatorialLen: equ $ -msgFatorial
    
    msgAux: db ": "
    msgAuxLen: equ $ -msgAux
    
    final:   db	'0'
    
    excecao: db '1'
    excecaoLen: equ $ -excecao

section .bss
    
    num resb 4
    result resb 4
    contador resb 1
    
section .text

global _start

_start:
    
    output msg1, msg1Len
    int 80h
    
    
    input num, 1
    int 80h
    
    
    output aux, auxLen
    int 80h
    
    
    output msgFatorial, msgFatorialLen
    int 80h
    
    output num, 1
    int 80h
    
    output msgAux, msgAuxLen
    int 80h
    
    mov eax, [num]
    sub eax,'0'
    cmp eax,0
    jle excecaoZero
    jmp continue
    
    excecaoZero:
        mov byte [num], '1'
        output num, 1
        int 80h
        jmp fim
        
    
    continue:

        fatorial [num], [result]
        conta [result], [contador]
        converte [result], [contador]
    
        output final, [contador]
        int 80h
        
  
    fim:
        mov  eax,1
        mov  ebx,0 
        int  80h
