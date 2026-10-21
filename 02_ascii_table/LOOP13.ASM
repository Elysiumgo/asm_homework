.MODEL SMALL
.STACK 100H
.DATA
LETTER DB 'a'
.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    MOV CX,2
ROW_LOOP:
    PUSH CX                 ; save outer loop count
    MOV CX,13
COL_LOOP:
    MOV DL,LETTER
    MOV AH,02H
    INT 21H
    INC LETTER

    CMP CX,1                ; omit the trailing space
    JE NO_SPACE
    MOV DL,' '
    MOV AH,02H
    INT 21H
NO_SPACE:
    LOOP COL_LOOP

    MOV DL,0DH
    MOV AH,02H
    INT 21H
    MOV DL,0AH
    MOV AH,02H
    INT 21H

    POP CX                  ; restore outer loop count
    LOOP ROW_LOOP

    MOV AX,4C00H
    INT 21H
END START
