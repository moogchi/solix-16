; Solix-16 Test Program
; Tests arithmetic, logic, memory, and control flow

; ===== Initialization =====
    MOV r1, 15          ; r1 = 15
    MOV r2, 10          ; r2 = 10
    MOV r3, 0           ; r3 = 0 (accumulator)

; ===== Arithmetic Test =====
    ADD r3, r1, r2      ; r3 = 15 + 10 = 25
    SUB r4, r3, r2      ; r4 = 25 - 10 = 15

; ===== Logic Test =====
    MOV r5, 0xAA        ; r5 = 0b10101010
    MOV r6, 0x55        ; r6 = 0b01010101
    AND r7, r5, r6      ; r7 = 0 (no bits overlap)
    OR  r7, r5, r6      ; r7 = 0xFF (all bits set)
    XOR r7, r5, r6      ; r7 = 0xFF (all bits flip)
    NOT r7, r5          ; r7 = ~0xAA = 0x55

; ===== Shift Test =====
    MOV r1, 8           ; r1 = 8 = 0b00001000
    SHL r1, r1          ; r1 = 16 = 0b00010000
    SHR r1, r1          ; r1 = 8 = 0b00001000

; ===== Memory Test =====
    MOV r1, 100         ; Memory address
    MOV r2, 42          ; Data to store
    ST  r1, r2          ; MEM[100] = 42
    MOV r3, 0           ; Clear r3
    LD  r3, r1          ; r3 = MEM[100] = 42

; ===== Loop Test: Sum 1+2+3+4+5 =====
    MOV r1, 0           ; Sum accumulator
    MOV r2, 5           ; Counter (count down from 5)
    MOV r3, 1           ; Decrement value

loop_start:
    ADD r1, r1, r2      ; sum += counter
    SUB r2, r2, r3      ; counter--
    JNZ loop_start      ; if counter != 0, loop
    ; r1 should now equal 15 (1+2+3+4+5)

; ===== Conditional Jump Test =====
    MOV r4, 10          ; r4 = 10
    MOV r5, 10          ; r5 = 10
    SUB r6, r4, r5      ; r6 = 0, sets Z flag
    JZ  zero_flag_set   ; Should jump
    MOV r7, 99          ; Should NOT execute
    
zero_flag_set:
    MOV r7, 77          ; Should execute, r7 = 77

; ===== Test Jump =====
    JMP end_program     ; Jump over next instruction
    MOV r1, 255         ; Should NOT execute

end_program:
    HLT                 ; Stop execution