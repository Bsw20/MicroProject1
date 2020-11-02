; Карипунькин Ярослав
; БПИ191
; Вариант №17
; Условие: написать программу, находящую количество единиц и нулей в битовом представлении заданнго машинного слова.

format PE Console

entry start

include 'win32ax.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        digit       db "%d", 0
        string0     db 256 DUP(?)
        string1     db 256 DUP(?)
        newStr      db '', 10, 13, 0

        number          dd ?
        tmpStack        dd ?
        num0            dd 0
        num1            dd 0
        indic           dd 0


;-----------------0---------------------------------------------------------
section '.code' code readable executable
start:
        call Begin
        call MainPart
        call Output

Begin:
        mov [tmpStack], esp
        invoke printf, "Input number from 0 to 2^32 - 1 to find out, how many 0/1 in its bit represention: "
        cinvoke scanf, digit, number
        mov esp,[tmpStack]
        ret

MainPart:
        mov [tmpStack], esp
        mov edx, 10000000000000000000000000000000b
        jmp body

                body:
                        cmp edx, 0
                        je over

                        mov eax, [number]
                        and eax, edx
                        cmp eax, 0
                        je do0
                        jne do1

                        do0:
                               cmp [indic], 0
                               je fin
                               inc [num0]
                               jmp fin

                        do1:
                               inc [num1]
                               cmp [indic], 0
                               je ChangeIndicator
                               jmp fin

                        ChangeIndicator:
                                mov [indic], 1
                                jmp fin
                        fin:
                                shr edx, 1
                                jmp body

                over:
                        mov esp, [tmpStack]
                        ret

Output:
        invoke sprintf, string0, "Number of '0' subsequences in bit representation of your number: %d.",[num0]
        invoke sprintf, string1, "Number of '1' subsequences in bit representation of your number: %d.",[num1]
        cinvoke printf, string0
        cinvoke printf, newStr
        cinvoke printf, string1

finish:
        call [getch]
        invoke ExitProcess, 0

;--------------------------------------------------------------------------
section '.idata' import data readable

        library user32,'USER32.DLL',\
                msvcrt, 'MSVCRT.DLL',\
                kernel32, 'KERNEL32.DLL',\
                shell32, 'SHELL32.DLL'

        import msvcrt,\
               sprintf, 'sprintf',\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
 
        import kernel32,\
               ExitProcess, 'ExitProcess'
