.MODEL SMALL
.STACK 100H
.DATA
PROMPT DB 'Input n (1-100): $'
ANSWER DB 0DH,0AH,'Sum = $'
ERROR  DB 0DH,0AH,'Invalid input. Enter 1-100.',0DH,0AH,'$'
.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

READ_AGAIN:
    LEA DX,PROMPT
    MOV AH,09H
    INT 21H

    XOR BX,BX               ; parsed value
    XOR DI,DI               ; digit count
READ_CHAR:
    MOV AH,01H              ; read one character with echo
    INT 21H
    CMP AL,0DH
    JE INPUT_DONE
    INC DI
    CMP DI,3
    JA DISCARD_LINE
    CMP AL,'0'
    JB DISCARD_LINE
    CMP AL,'9'
    JA DISCARD_LINE
    SUB AL,'0'
    XOR AH,AH
    PUSH AX                 ; save current digit
    MOV AX,BX
    MOV DX,10
    MUL DX                  ; old value * 10
    MOV BX,AX
    POP AX
    ADD BX,AX
    JMP READ_CHAR

INPUT_DONE:
    CMP DI,0
    JE BAD_INPUT
    CMP BX,1
    JB BAD_INPUT
    CMP BX,100
    JA BAD_INPUT

    XOR AX,AX
    MOV CX,BX
    MOV DX,1
SUM_LOOP:
    ADD AX,DX
    INC DX
    LOOP SUM_LOOP

    PUSH AX
    LEA DX,ANSWER
    MOV AH,09H
    INT 21H
    POP AX
    CALL PRINT_NUM
    CALL NEW_LINE
    MOV AX,4C00H
    INT 21H

DISCARD_LINE:
    MOV AH,01H
    INT 21H
    CMP AL,0DH
    JNE DISCARD_LINE
BAD_INPUT:
    LEA DX,ERROR
    MOV AH,09H
    INT 21H
    JMP READ_AGAIN

PRINT_NUM PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    XOR CX,CX
    MOV BX,10
DIVIDE:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    OR AX,AX
    JNZ DIVIDE
PRINT_DIGIT:
    POP DX
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    LOOP PRINT_DIGIT
    POP DX
    POP CX
    POP BX
    RET
PRINT_NUM ENDP

NEW_LINE PROC NEAR
    MOV DL,0DH
    MOV AH,02H
    INT 21H
    MOV DL,0AH
    MOV AH,02H
    INT 21H
    RET
NEW_LINE ENDP
END START
