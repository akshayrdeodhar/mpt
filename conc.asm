.8086
.MODEL SMALL
.STACK
.DATA
	MSG1 DB "ENTER THE STRING:- $"
	INPUT1 DB 100 DUP(0)
	INPUT2 DB 100 DUP(0)
	OUTPUT DB 100 DUP(0)
	LINE DB 10, 13, "$"

.CODE
	MOV AX, @DATA
	MOV DS, AX
	MOV ES, AX
	LEA SI, INPUT1
	LEA DI, OUTPUT
	PUSH SI
	CALL STR_IN
	POP SI
	LEA SI, INPUT2
        PUSH SI
	CALL STR_IN
        POP SI
	CALL CONC
	MOV AH, 4CH
	INT 21H

STR_IN:
	PUSH BP
	MOV BP, SP
	MOV SI, [BP + 04]
	MOV CL, 13
	LEA DX, MSG1
	MOV AH, 09H
	INT 21H
CONTI:	MOV AH, 01H
	INT 21H
	CMP AL, CL
	JZ IN_COM
	MOV [SI], AL
	INC SI
	JMP CONTI
IN_COM: MOV BYTE PTR [SI], '$'
	POP BP
	RET

CONC:
	PUSH BP
	MOV BP, SP
	LEA SI, INPUT1
	LEA DI, OUTPUT
	MOV CL, '$'
STR_1:	MOV AL, [SI]
	CMP AL, CL
	JZ NEXT
	MOV [DI], AL
	INC SI
	INC DI
	JMP STR_1
NEXT:   LEA SI, INPUT2
STR_2:	MOV AL, [SI]
	CMP AL, CL
	JZ DONE
	MOV [DI], AL
	INC SI
	INC DI
	JMP STR_2
DONE:	MOV [DI], CL
	LEA DX, OUTPUT
	MOV AH, 09H
	INT 21H
	POP BP
	RET
END