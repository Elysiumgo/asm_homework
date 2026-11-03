.MODEL SMALL
.STACK 100H
.DATA
HEADER DB 'x y',0DH,0AH,'$'
ERROR_TEXT DB '  error$'
DONE_TEXT DB 'accomplish!',0DH,0AH,'$'

; Corrupted 9x9 multiplication table, stored row by row.
TABLE DB 7,2,3,4,5,6,7,8,9
      DB 2,4,7,8,10,12,14,16,18
      DB 3,6,9,12,15,18,21,24,27
      DB 4,8,12,16,7,24,28,32,36
      DB 5,10,15,20,25,30,35,40,45
      DB 6,12,18,24,30,7,42,48,54
      DB 7,14,21,28,35,42,49,56,63
      DB 8,16,24,32,40,48,56,7,72
      DB 9,18,27,36,45,54,63,72,81

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,HEADER
    MOV AH,09H
    INT 21H

    LEA SI,TABLE            ; DS:SI addresses the current table byte
    MOV BP,1                ; outer loop: row 1..9
ROW_LOOP:
    MOV DI,1                ; inner loop: column 1..9
COL_LOOP:
    MOV AX,BP               ; AX = row
    MOV BX,DI               ; BX = column
    CALL CHECK_ITEM         ; process preserves the caller's registers
    INC SI                  ; address the next byte in TABLE
    INC DI
    CMP DI,9
    JBE COL_LOOP
    INC BP
    CMP BP,9
    JBE ROW_LOOP

    LEA DX,DONE_TEXT
    MOV AH,09H
    INT 21H
    MOV AX,4C00H
    INT 21H

; Input: AX=row, BX=column, DS:SI=current stored value.
; Prints the position when stored value != row*column.
; All registers used by the caller are restored before RET.
CHECK_ITEM PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX,AX               ; keep row for printing
    MUL BX                  ; AX = row * column
    CMP AL,[SI]             ; compare expected value with table data
    JE ITEM_OK

    MOV AX,CX
    CALL PRINT_NUM
    MOV DL,' '
    MOV AH,02H
    INT 21H
    MOV AX,BX
    CALL PRINT_NUM
    LEA DX,ERROR_TEXT
    MOV AH,09H
    INT 21H
    CALL NEW_LINE

ITEM_OK:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CHECK_ITEM ENDP

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
