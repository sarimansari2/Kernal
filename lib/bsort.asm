;----------------------------------------------------------------;              DATE:   27-09-2020
;                   Bubble Sorting Subroutine                    ;
;----------------------------------------------------------------;

BSORT:
    POP AX          ;RETURN ADDRESS OF SUBROUTINE 
    POP SI          ;BASE ADDRESS OF SUBROUTINE 
    POP CX          ;COUNTER REGISTER 
    PUSH AX         ;PUSH RETURN ADDRESS OF SUBROUTINE 

COUNTER1        EQU 0X4000  
COUNTER2        EQU 0X4002 
BASE_ADDRESS    EQU 0X4004 

    MOV ES:[COUNTER1],CX 
    MOV ES:[COUNTER2],CX 
    MOV ES:[BASE_ADDRESS],CX 

REPEAT_BSORT:  
    MOV AH,[SI]
    CMP AH,[SI+1]
    JB NOSWAP_BSORT             ;CMP A[I] WITH A[I+1]
        XCHG AH,[SI+1]
    NOSWAP_BSORT:
    INC SI 
    LOOP REPEAT_BSORT
    MOV SI,ES:[BASE_ADDRESS]
    MOV CX,ES:[COUNTER1]
    DEC ES:[COUNTER2]
    JNZ REPEAT_BSORT
    RET 