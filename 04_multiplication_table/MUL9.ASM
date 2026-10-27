.MODEL SMALL
.STACK 100H
.DATA
TITLE_TEXT DB 'The 9mul9 table:',0DH,0AH,'$'
.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,TITLE_TEXT
    MOV AH,09H
    INT 21H

    MOV SI,9                ; outer loop: row 9 down to 1
ROW_LOOP:
    MOV DI,1                ; inner loop: column 1 up to row
COL_LOOP:
    MOV AX,SI               ; AX = row
    MOV BX,DI               ; BX = column
    CALL PRINT_ITEM         ; procedure call, returns with registers restored
    INC DI
    CMP DI,SI
    JBE COL_LOOP

    CALL NEW_LINE
    DEC SI
    JNZ ROW_LOOP

    MOV AX,4C00H
    INT 21H

; Input: AX = row, BX = column
; Output: row*column=result followed by two spaces
; AX, BX, CX and DX are preserved for the caller.
PRINT_ITEM PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,AX               ; keep row for multiplication
    CALL PRINT_NUM

    MOV DL,'*'
    MOV AH,02H
    INT 21H

    MOV AX,BX
    CALL PRINT_NUM

    MOV DL,'='
    MOV AH,02H
    INT 21H

    MOV AX,CX
    MUL BX                  ; AX = row * column
    CALL PRINT_NUM

    MOV DL,' '
    MOV AH,02H
    INT 21H
    MOV DL,' '
    INT 21H

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_ITEM ENDP

; Print the unsigned decimal value in AX.
PRINT_NUM PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    XOR CX,CX
    MOV BX,10
DIVIDE_LOOP:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    OR AX,AX
    JNZ DIVIDE_LOOP
PRINT_LOOP:
    POP DX
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    LOOP PRINT_LOOP
    POP DX
    POP CX
    POP BX
    RET
PRINT_NUM ENDP

NEW_LINE PROC NEAR
    PUSH AX
    PUSH DX
    MOV DL,0DH
    MOV AH,02H
    INT 21H
    MOV DL,0AH
    INT 21H
    POP DX
    POP AX
    RET
NEW_LINE ENDP

END START
