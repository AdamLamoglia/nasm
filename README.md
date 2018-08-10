# nasm

All the codes was implemented in a 64 Bit computer. If you are using a 32 Bit computer, you need to change these instructions:

push/pop rax/rbx/rcx/rdx -> push/pop eax/ebx/ecx/edx


### -> sum.asm ###

Enter 2 numbers between 0 and 9. The program will return the sum of these numbers

### -> factorial.asm ###

Enter 1 number between 0 and 9. The program will return the factorial of the number

### -> calculator.asm ###

Enter a infix expression (with parentheses). The program will tell if the expression is well formatted or not. If yes, the result of expression will appear on screen.

Examples:
 Input: 2*5+4-(4+8)
 Output: Bem formatada (Well formatted)
         2
 Input: 1 + ((4)
 Output: Erro na formatação (Bad formatting)
