;-----------------------------------------------------------------------------------------------------------------------------------;
;                                                         KERNAL                                                                    ;
;-----------------------------------------------------------------------------------------------------------------------------------;






;---------------------------------------------------------------------------------------------------------------------------------;
;            Author:     SYEED MOHD AMEEN                                                   DATE:   16-09-2020                    ;
;            Email:      ameensyeed2@gmail.com                                                                                    ;
;---------------------------------------------------------------------------------------------------------------------------------;


;----------------------------------------------------------;
;                    MEMORY MAP                            ;
;----------------------------------------------------------;

;                -------------------    0X00000
;               |    BOOTLOADER     |
;               |                   |
;               |                   |
;               |                   |
;               |                   |   0X00200
;                -------------------
;               |      KERNAL       |   0X00201
;               |                   |
;               |                   |
;               |                   |
;               |                   |   0X02000
;                -------------------
;               |    SYSTEM CALLS   |   0X02001
;               |                   |
;               |                   |
;               |                   |
;               |                   |   0X03000
;                -------------------
;               |        I/0        |   0X03001
;               |                   |
;               |                   |
;               |                   |   0X030FF
;                -------------------




KERNAL:
    ORG 0XFFFF0         ;8086 RESET VECTOR 
    JMP BOOTLOADER      ;JMP BOOTLOADER 

    ORG 0X00000
BOOTLOADER:
    ; --------------------
    ;   INCOMPLETE 






;-------------------------------------------------------;
;                  PROCESS SCHEDULAR                    ; 
;-------------------------------------------------------;

SCHEDULAR:

    PROCESS_QUEUE:          EQU 0X1000  ;PROCESS QUEUE ADDRESS 
    DPTR_SJF:               EQU 0X1050  ;PROCESS ARRAY BASE ADDRESS 


    POP AX                              ;POP RETURN ADDRESS OF SUBROUTINE 
    POP SI                              ;BASE ADDRESS OF PROCESS TIME QUANTUM 
    POP CX                              ;NUMBER OF PROCESS 
    PUSH AX                             ;PUSH RETURN ADDRESS OF SUBROUTINE 

    PUSH CX 
    PUSH SI 
    CALL SELSORT                        ;SORT PROCESS (SHORTEST JOB FIRST [algo])
    MOV DI,PROCESS_QUEUE

REPEAT_SCHEDULAR:
    MOV [DI],[SI]
    INC DI                              ;COPY PROCESS ID INTO PROCESS QUEUE 
    INC SI 
    LOOP REPEAT_SCHEDULAR




;-------------------------------------------------------;
;                  SELECTION SORT                       ;     
;-------------------------------------------------------;
SELSORT:
    POP AX                               ;POP RET ADDRESS OF SUBROUTINE 
    POP SI                               ;BASE ADDRESS OF ARRAY 
    POP CX                               ;COUNTER REGISTER
    PUSH AX                              ;PUSH RET ADDRESS OF SUBROUTINE 

COUNTER_SELSORT:        EQU 0X4500
DPTR_SELSORT:           EQU 0X4510 


    MOV ES:[COUNTER_SELSORT],CX 
    MOV ES:[COUNTER_SELSORT+2],CX
    MOV ES:[DPTR_SELSORT],SI 
    XOR BX,BX                           ;CLEAR INDEX REGISTER 
    
REPEAT2_SELSORT:
    MOV AH,[SI+BX]                      ;MOVE INITIAL ELEMENT AND COMPARE IN ENTIRE ARRAY 

REPEAT1_SELSORT:
    CMP AH,[SI+BX+1]                    
    JC NOSWAP_SELSORT   
        XCHG AH,[SI+BX+1]       
    NOSWAP_SELSORT:
    INC SI                              ;INCREMENT INDEX REGISTER 
    LOOP REPEAT1_SELSORT                ;REPEAT UNTIL COUNTER != 0 
    MOV SI,ES:[DPTR_SELSORT]            ;MOVE BASE ADDRESS OF ARRAY 
    DEC ES:[COUNTER_SELSORT+2]
    MOV CX,ES:[COUNTER_SELSORT+2]       ;MOVE COUNTER INTO CX REG.
    INC BX                              ;INCREMENT INDEX REGISTER 
    CMP BX,ES:[COUNTER_SELSORT]     
    JNE SKIP_SELSORT                    ;IF BX == ES:[COUNTER_SELSORT] RET SUBROUTINE 
        RET                             ;RETURN SUBROUTINE 
    SKIP_SELSORT:   
    JMP REPEAT2_SELSORT         


;---------------------------------------------------------;
;                       COMMANDS                          ;
;---------------------------------------------------------;
COMMANDS:
    DW DIR         ;0    ;DIRECTORY SHOW        
    DW OPEN        ;1    ;OPEN FILE
    DW CLOSE       ;2    ;CLOSE FILE 
    DW MKDIR       ;3    ;CREATE DIRECTORY 
    DW RMDIR       ;4    ;REMOVE DIRECTORY 
    DW GETDATE     ;5    ;GET DATE 
    DW GETTIME     ;6    ;GET TIME 
    DW SETDATE     ;7    ;SET DATE 
    DW SETTIME     ;8    ;SET TIME 
    DW DELETE      ;9    ;DELETE FILE 
    DW RENAME      ;10   ;RENAME FILE 
    DW GETHEX      ;11   ;GET HEX DUMP 
;----------------------------------------------------------;

; ;-----------------------------------------------------------------------------------;
; ;                              COMMAND HEX DUMP FILE                                ;
; ;-----------------------------------------------------------------------------------;
; ;   FORMAT:                                                                         ;
; ;    ADDRESS:   HEX BYTES                                            ANSI ENCODING  ;
; ;    0X0000      BC CA 10 23 45 24 12 12 04 45 50 30 23 04 32 34      $3!fd& 4#?}[  ;
; ;-----------------------------------------------------------------------------------;
; GETHEX:
;     T_HEX_COUNTER   EQU 100
;     T_DATAPOINTER   EQU 200 




;     PUSH DX             ;SAVE REGISTERS 
;     PUSH CX 
;     PUSH BX 
;     PUSH AX

copy_data:
    pop ax 
    pop cx 
    pop si 
    pop di 
    push ax
    
 repeat_copy_data:
    mov [di],[si]
    inc di 
    inc si 
    loop repeat_copy_data
