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


%macro verificar_parenteses 5

	mov edx, 0 ; zera contador de "("
	mov ecx, 0
    
pega_parenteses:
	mov al, [%1 + ecx] ; pega um caractere da string
	inc ecx  ; vai para o proximo caractere
    
	cmp al, 0  ; compara o caractere com 0
	jz fimCorreto ; se for 0, a string foi conferida por inteira
    
	cmp al, 40 ; compara o caractere com "("
    
	je incrementa_abre ; se nao for igual a "(", continua o loop
	cmp al, 41 ; compara o caractere com ")"
	je incrementa_fecha ;se for igual a ")", pula para incrementa_fecha
	jmp pega_parenteses ;se nao, volta para o inicio do loop
    
	incrementa_abre:
    
    	inc edx ; incrementa o contador (futuramente colocar na pilha)
    	jmp pega_parenteses ; continua o loop
    
	incrementa_fecha:
   	 
    	cmp edx, 0 ;compara o contador com 0
    	je fimErro ;se for igual, pula pro final de erro
    	dec edx ;se nao, decrementa o contador
   	 
    	jmp pega_parenteses ;volta para o inicio do loop
   	 
fimCorreto:
    
	cmp edx, 0 ;compara o contador com 0
	jne fimErro ;se nao for igual pula pro final de erro
	output %2,%3 ;imprime "bem formatado"
 	int 80h
	mov eax, 1
	jmp fim ;pula para o fim evitando a branch de fimErro
    
fimErro:
	output %4,%5 ;imprime "erro na formatacao"
 	int 80h
	mov eax, 0
fim:

%endmacro

%macro conta_caracteres 2
    
	mov ecx, 0
	mov edx, 0
    
for_contagem:
	mov  al, [%1 + ecx] ; pega um caractere da string
	inc ecx  ; vai para o proximo caractere
    
	cmp al, 0
	jz termino

	    inc edx ; tamanho_expressao++
	    jmp for_contagem
    
termino:
	dec edx ; eh feito isso, pois em toda expressao o valor esta dando expressao.size+1
	mov %2, edx
    
%endmacro

%macro infixa_para_posfixa 5
    
	mov eax, 0 ; eax = ponteiro da expressao infixa
	mov ebx, 0 ; ebx = ponteiro da expressao posfixa
	mov ecx, %2 ; ecx = tamanho da expressao (i)
	mov byte [%5], 0 ; tamanho_posfixa = 0
	
	push rax ; auxiliar para pilha

    
para_cada_caractere:
    
	cmp ecx, 0
	je fim_para
    
	dec ecx ; decrementa i
    
	mov dl, [%1 + eax] ; pega um caractere c da expressao infixa
	inc eax ; vai para o proximo caractere
    
	mov [%4+200], dl ; bufferAux = c
	
	
	cmp dl, '(' ; se c = '('
	je empilha_abre
    
	cmp dl, ')' ; se c = ')'
	je caso_fecha

	cmp dl, '+' ; se c = '+'
	je caso_mais_menos
    
	cmp dl, '-' ; se c = '-'
	je caso_mais_menos

	cmp dl, '*'
	je caso_vezes_divide ; se c = '*'
	
	cmp dl, '/'
	je caso_vezes_divide ; se c = '/'
    
    
	jmp coloca_numero ; se eh numero, coloca direto em posfixa
    
    empilha_abre:
    	push rdx ; empilha c
    	jmp para_cada_caractere
    
	caso_fecha:
   	 
    	verifica_topo_pilha_abre:
               	 
                	pop rdx ; desempilha x
                	cmp dl, '('
                	je fim_enquanto_abre
                	
                	cmp dl, 0
                    je fim_enquanto_abre
               	 
                	mov [%3 + ebx], dl ; coloca x em posfixa
                	inc ebx ; vai para proximo caractere da expressao posfixa
                	jmp verifica_topo_pilha_abre
   	 
    	fim_enquanto_abre:
           	 
            	jmp para_cada_caractere

   	 
	caso_mais_menos:
		add byte [%5], 1
   	 
	    	verifica_topo_pilha_mais_menos:
		   	 
		    	pop rdx ; desempilha x
		    	cmp dl, '('
		    	je fim_enquanto_mais_menos
		    	
		    	cmp dl, 0
		        je fim_enquanto_mais_menos
		   	 
		     	mov [%3 + ebx], dl ; coloca x em posfixa
		        inc ebx ; vai para proximo caractere da expressao posfixa
		  	jmp verifica_topo_pilha_mais_menos
	   	 
	    	fim_enquanto_mais_menos:
	       	 
			push rdx
			mov dl, [%4+200] ; dl = c  
			push rdx ; empilha c
	       	 
			jmp para_cada_caractere
	
	caso_vezes_divide:
		add byte [%5], 1
		
		verifica_topo_pilha_vezes_divide:
			
			pop rdx ; desempilha x
		    	
			cmp dl, '('
		    	je fim_enquanto_vezes_divide

			cmp dl, '+'
			je fim_enquanto_vezes_divide		

			cmp dl, '-'
			je fim_enquanto_vezes_divide	
		    	
		    	cmp dl, 0
		        je fim_enquanto_vezes_divide
		   	 
		     	mov [%3 + ebx], dl ; coloca x em posfixa
		        inc ebx ; vai para proximo caractere da expressao posfixa
		  	jmp verifica_topo_pilha_vezes_divide

		fim_enquanto_vezes_divide:
			
			
			push rdx
			mov dl, [%4+200] ; dl = c  
			push rdx ; empilha c
	       	 
			jmp para_cada_caractere
		

	coloca_numero:
    
    		mov byte  [%3 + ebx], dl ; coloca x em posfixa
    		inc ebx ; vai para proximo caractere da expressao posfixa
		add byte [%5], 1
    		jmp para_cada_caractere

fim_para:
	 pop rdx ; pega caracteres remanescentes da pilha
	
	 cmp dl, 0
	 je fim_total

	 mov [%3 + ebx], dl ; move para posfixa
	 inc ebx
	 jmp fim_para

fim_total: 
	
	
    
%endmacro

%macro realiza_operacao_aritmetica 4
	
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	
	push rax ; puxa auxiliar para pilha

	transforma_char_em_numero:
	
		cmp cl, [%4] ; se cl = tamanho_posfixa
		je fim_transforma
		
		mov dl, [%1 + ecx] ; pega um caractere c da expressao posfixa
		inc ecx

		cmp dl, '+'
		je transforma_char_em_numero
		
		cmp dl, '-'
		je transforma_char_em_numero
		
		cmp dl, '*'
		je transforma_char_em_numero

		cmp dl, '/'
		je transforma_char_em_numero

		dec ecx
		mov dl, [%1 + ecx] ; pega um numero, que esta em ascii da expressao posfixa
		sub dl, 48	      ; transforma numero ascii em numero binario
		mov [%1 + ecx], dl	; move numero binario para expressao posfixa
		inc ecx
		
		jmp transforma_char_em_numero

	fim_transforma:
		
		mov ebx, 0
		mov ecx, 0


	para_cada_char:

		cmp bl, [%4] ; se bl = tamanho_posfixa
		je fim_para_cada_char
		
		mov dl, [%1 + ebx] ; pega um caractere c da expressao posfixa
		inc ebx ; vai para o proximo caractere

		cmp dl, '+'
		je op_soma
		
		cmp dl, '-'
		je op_subtrai
		
		cmp dl, '*'
		je op_multiplica

		cmp dl, '/'
		je op_divide

		
		push rdx ; puxa numero para pilha
		jmp para_cada_char

		op_soma:
			
			pop rax
			pop rcx
			
			add eax, ecx ; soma 2 numeros
			
			push rax ; puxa resultado para pilha
			jmp para_cada_char

		op_subtrai:

			pop rcx
			pop rax
			
			
			sub eax, ecx ; subtrai 2 numeros
			
			push rax ; puxa resultado para pilha
			jmp para_cada_char

		op_multiplica:
			
			pop rax
			pop rcx
			
			imul eax, ecx ; multiplica 2 numeros
			
			push rax ; puxa resultado para pilha
			jmp para_cada_char

		op_divide:
			pop rcx
			pop rax

			mov edx, 0
			cdq
			idiv ecx ; divide 2 numeros
			
			push rax ; puxa resultado para pilha
			jmp para_cada_char

	fim_para_cada_char:

		pop rdx ; desempilha resultado final
		mov [%2], edx ; move para resultado
			

	
%endmacro

%macro converte_resultado 3

	mov eax, [%1] ; eax = resultado
	mov ebx, 0 ; ebx = contador_de_casas
	mov ecx, 10 ; ecx = divisor_de_casas
	
	cmp eax, 0
	jl imprime_negativo ; se eax < 0, imprime '-' e converte eax
	jmp pula_imprime
	
	imprime_negativo:
		
		mov byte [%3], '-'
		neg eax ; converte eax
		mov [%1], eax ; move para resultado

	pula_imprime:

		mov eax, [%1] ; eax = resultado
	
	enquanto_maior_que_zero:

			cmp eax, 0
			je fim_enquanto			
						
			mov edx, 0
			div ecx  ; eax = eax/10
			add edx, 48 ; soma resto da divisao para te-lo como caractere da tabela ascii 

			push rdx ; puxa edx para pilha, para conseguir imprimir o resultado na ordem correta
			inc ebx ; incrementa contador
			jmp enquanto_maior_que_zero

	fim_enquanto:

		cmp ebx, 0 ; se contador = 0, imprime somente o 0
		je poe_zero
		mov ecx, 0
		
		puxa_pilha:
			cmp ebx, 0
			je fim_enquanto2
			
			pop rax
			mov [%1 + ecx], eax ; move para resultado final o caractere atual
			inc ecx ; vai para proximo espaco de memoria
			dec ebx ; decrementa contador
			jmp puxa_pilha

	poe_zero:
		mov byte [%1], 48 ; resultado = '0'
		
	fim_enquanto2:
		
		
%endmacro


section .data

	msgSucesso: db "Bem Formatada", 0xA
	msgSucessoLen: equ $ -msgSucesso
    
	msgFalha: db "Erro de formatação", 0xA
	msgFalhaLen: equ $ -msgFalha

	quebraLinha: db " ", 0xA
	quebraLinhaLen: equ $ -quebraLinha

	entrada: db "Entrada "
	entradaLen: equ $ -entrada


section .bss
    
	expressao resb 200 ;expressao infixa (entrada)
	tamanho_expressao resb 1 ; tamanho da expressao infixa
	posfixa resb 200 ;expressao posfixa (entrada convertida)
	bufferAux resb 4
	aux resb 2
	resultado resb 10
	tamanho_resultado resb 1
	tamanho_posfixa resb 1
	negativo: resb 1
    
section .text

global _start

_start:
    
    loop_entrada:
    
	input expressao, 200
	int 80h

	cmp byte [expressao],'f' ; se expressao = EOF, finaliza o programa
       je terminou
       
	verificar_parenteses expressao,msgSucesso,msgSucessoLen,msgFalha,msgFalhaLen
    	
	cmp eax, 0 ; se eax = 0, entao a expressao esta mal formatada
	je finaliza

	conta_caracteres expressao, [tamanho_expressao]
    
	infixa_para_posfixa expressao,[tamanho_expressao],posfixa, bufferAux, 	tamanho_posfixa
    

       realiza_operacao_aritmetica posfixa, resultado, bufferAux, tamanho_posfixa


	converte_resultado resultado, tamanho_resultado, negativo

	output negativo, 1 ; imprime '-' ou ''
	int 80h
	
	output resultado, 10
	int 80h
	
	finaliza:
		
		output quebraLinha,quebraLinhaLen
		int 80h

		output quebraLinha,quebraLinhaLen
		int 80h
        
	jmp loop_entrada ; equivalente a while(cin >> expressao)

    terminou:
		mov  eax,1
		mov  ebx,0
		int  80h