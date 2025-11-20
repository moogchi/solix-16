; ============================================================
;                 SOLIX16 FULL ISA TORTURE TEST
;    Covers:
;      - All R-type (ADD, SUB, AND, OR, XOR, NOT, SHL, SHR)
;      - All I-type (MOV)
;      - All J-type (JMP, JZ, JNZ)
;      - System (HLT)
;      - Registers r0–r7, sp, pc, flags
;      - Immediates: decimal, hex, binary, min/max
;      - LD/ST with different register combos
;      - Nested labels, forward/backward jumps
; ============================================================

; =============================
; Register Init + Immediate Tests
; =============================

START:
    MOV r1, 0          ; zero
    MOV r2, 1          ; one
    MOV r3, 255        ; max 8-bit immediate
    MOV r4, 0xAA       ; hex immediate
    MOV r5, 0b101010   ; binary immediate (42)
    MOV r6, 127        ; mid value
    MOV r7, 0b11111111 ; another max (255)

; =============================
; Arithmetic Tests
; =============================

    ADD r1, r2, r3     ; r1 = 1 + 255 = 256 (truncates to 16-bit ALU)
    SUB r4, r3, r2     ; r4 = 255 - 1
    AND r5, r3, r4     ; AND test
    OR  r6, r4, r2     ; OR test
    XOR r7, r3, r4     ; XOR test

; =============================
; Unary Tests (NOT / SHL / SHR)
; =============================

    NOT r1, r1         ; invert
    SHL r2, r2         ; << 1
    SHR r3, r3         ; >> 1

; =============================
; Load/Store Tests
; NOTE: The CPU must treat rX as addresses; this is legal for your ISA.
; =============================

    MOV r0, 100        ; Base memory address to test LD/ST
    MOV r1, 77         ; Data to store

    ST r0, r1          ; MEM[100] = 77
    LD r2, r0          ; Load it back → r2 = 77

; Test with different registers
    MOV r3, 200
    MOV r4, 0x55
    ST r3, r4
    LD r5, r3          ; Expect 0x55

; =============================
; Branch Tests (Forward + Backward)
; =============================

    MOV r6, 3

LOOP_TOP:
    SUB r6, r6, r2     ; r6 -= r2 (r2 = 77 so it will underflow)
    JZ EXIT            ; if zero → exit loop
    JNZ LOOP_TOP       ; always true, ensures backward jump

EXIT:
    MOV r7, 0x10       ; mark exit

; =============================
; Specific Jump Address Test
; (Jump to raw numeric address instead of label)
; =============================

    JMP 12             ; Jump directly to instruction address 12

; =============================
; Label at target numeric address 12
; (Depending on how assembler offsets work, this is reachable)
; =============================

ADDR12:
    MOV r1, 0x5A       ; check if JMP numeric landed here

; =============================
; Zero Flag Branch Tests
; =============================

    MOV r2, 0
    JZ ZERO_HIT
    MOV r3, 123        ; this should get skipped

ZERO_HIT:
    MOV r4, 0xF0

; =============================
; Non-zero Branch Test
; =============================

    MOV r5, 1
    JNZ NONZERO_HIT
    MOV r6, 99         ; skipped (this line should not execute)

NONZERO_HIT:
    MOV r7, 0x33

; =============================
; Final Instruction
; =============================

    HLT
