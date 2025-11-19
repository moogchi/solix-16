; Targeted test for bug fixes
; Tests: ST encoding, label case, operand parsing

start:
    MOV r1, 10          ; Load 10 into r1
    MOV r2, 0x20        ; Load address 32 into r2
    ST r2, r1           ; Store r1 to memory[r2] - tests Rd=0 fix
    
Loop:                   ; Mixed case label
    ADD r3, r1, r2      ; Test operand spacing
    SUB r4 , r3 , r1    ; Test extra spaces
    NOT r5, r4          ; Test unary op
    SHL r6,r5           ; Test no spaces after comma
    JNZ LOOP            ; Test label case (uppercase LOOP should match Loop)
    
    HLT                 ; Test HLT encoding
