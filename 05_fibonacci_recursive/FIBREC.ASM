.MODEL SMALL
.STACK 400H

DIGITS EQU 22

.DATA
PROMPT      DB 'Input n (1-100): $'
TITLE_TEXT  DB 0DH,0AH,'Fibonacci result: $'
ERROR_TEXT  DB 0DH,0AH,'Invalid input. Please enter 1-100.',0DH,0AH,'$'
INPUT_BUF   DB 4,0,4 DUP(0)
NUM_A       DB DIGITS DUP(0)       ; current F(k), decimal digits, low first
NUM_B       DB DIGITS DUP(0)       ; current F(k+1)
NUM_TEMP    DB DIGITS DUP(0)

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,PROMPT
    MOV AH,09H
    INT 21H

    LEA DX,INPUT_BUF
    MOV AH,0AH
    INT 21H
    CALL PARSE_INPUT               ; AX = n, CF = 1 when invalid
    JC BAD_INPUT
    MOV CX,AX                      ; preserve n before DOS output changes AX

    LEA DX,TITLE_TEXT
    MOV AH,09H
    INT 21H

    MOV BYTE PTR NUM_B,1           ; A=F(0)=0, B=F(1)=1
    CALL FIB_RECURSIVE
    CALL PRINT_BIG                 ; NUM_A now contains F(n)
    CALL NEW_LINE

    MOV AX,4C00H
    INT 21H

BAD_INPUT:
    LEA DX,ERROR_TEXT
    MOV AH,09H
    INT 21H
    MOV AX,4C01H
    INT 21H

; Parse the DOS 0AH keyboard buffer.
; Return AX=1..100 and CF=0, otherwise CF=1.
PARSE_INPUT PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    XOR AX,AX
    XOR CX,CX
    MOV CL,INPUT_BUF+1
    JCXZ PARSE_FAIL
    LEA SI,INPUT_BUF+2
    MOV BX,10
PARSE_LOOP:
    MOV DL,[SI]
    CMP DL,'0'
    JB PARSE_FAIL
    CMP DL,'9'
    JA PARSE_FAIL
    SUB DL,'0'
    XOR DH,DH
    MOV DI,DX
    MUL BX
    ADD AX,DI
    INC SI
    LOOP PARSE_LOOP
    CMP AX,1
    JB PARSE_FAIL
    CMP AX,100
    JA PARSE_FAIL
    CLC
    JMP SHORT PARSE_DONE
PARSE_FAIL:
    STC
PARSE_DONE:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    RET
PARSE_INPUT ENDP

; Recursively advance the state exactly CX times, leaving NUM_A=F(n).
; Every active level occupies 4 bytes: return address + saved CX.
; The recursive call reaches the base case first; calculation occurs while unwinding.
FIB_RECURSIVE PROC NEAR
    OR CX,CX
    JZ FIB_RETURN
    PUSH CX
    DEC CX
    CALL FIB_RECURSIVE
    POP CX

    CALL ADVANCE_FIB
FIB_RETURN:
    RET
FIB_RECURSIVE ENDP

; Print NUM_A without leading zeroes.
PRINT_BIG PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    LEA SI,NUM_A+DIGITS-1
    MOV CX,DIGITS
FIND_FIRST:
    CMP BYTE PTR [SI],0
    JNE PRINT_DIGITS
    DEC SI
    LOOP FIND_FIRST
    MOV DL,'0'
    MOV AH,02H
    INT 21H
    JMP SHORT PRINT_DONE
PRINT_DIGITS:
    MOV DL,[SI]
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    DEC SI
    LOOP PRINT_DIGITS
PRINT_DONE:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_BIG ENDP

; A,B = B,A+B.  Each big integer uses 22 decimal digits.
ADVANCE_FIB PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    XOR SI,SI
    XOR DX,DX                      ; DL is decimal carry (0 or 1)
    MOV CX,DIGITS
ADD_DIGITS:
    MOV AL,NUM_A[SI]
    ADD AL,NUM_B[SI]
    ADD AL,DL
    XOR DL,DL
    CMP AL,10
    JB STORE_DIGIT
    SUB AL,10
    MOV DL,1
STORE_DIGIT:
    MOV NUM_TEMP[SI],AL
    INC SI
    LOOP ADD_DIGITS

    XOR SI,SI
    MOV CX,DIGITS
COPY_DIGITS:
    MOV AL,NUM_B[SI]
    MOV NUM_A[SI],AL
    MOV AL,NUM_TEMP[SI]
    MOV NUM_B[SI],AL
    INC SI
    LOOP COPY_DIGITS
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ADVANCE_FIB ENDP

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
