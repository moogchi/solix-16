# Solix-16 CPU Architecture Project# Solix-16 CPU Architecture Project# Project: CPU Docs Workspace

This repository contains the **Solix-16**, a complete 16-bit educational CPU architecture with assembler and hardware implementation.This repository contains the **Solix-16**, a 16-bit educational CPU architecture with a custom assembler implementation.This workspace contains study/reference material related to CPU architecture.

## Contents## ContentsIncluded file:

- **`solix16.pdf`** — Complete ISA specification and architecture documentation- **`solix16&ISA.pdf`** — Complete ISA specification and architecture documentation- `solix16&ISA.pdf` — a PDF document in the repository root. Open it with your preferred PDF viewer.

- **`assembler/`** — Two-pass assembler implementation in C++

  - `main.cpp` — Full assembler with label resolution- **`assembler/`** — Solix-16 assembler implementation in C++

  - `solix16asm` — Compiled executable

  - Test programs (`test.asm`, `comprehensive_test.asm`, etc.) - `main.cpp` — Full assembler with two-pass label resolutionQuick tips:

- **`verilog/`** — Hardware implementation in Verilog

  - `alu.v` — 16-bit ALU with 8 operations - `solix16asm` — Compiled executable

  - `alu_tb.v` — Comprehensive testbench

  - `alu_sim` — Compiled simulation executable - Test programs (`test.asm`, `bugfix_test.asm`)- To open the PDF from the command line on Linux:

## Solix-16 Architecture## Solix-16 Assembler```bash

**Solix-16** is a 16-bit RISC-style architecture featuring:xdg-open "solix16&ISA.pdf" # or use your preferred PDF viewer (evince, okular, mupdf, etc.)

- 16-bit data and address bus (64KB addressable memory)A robust two-pass assembler for the Solix-16 ISA that generates machine code compatible with Logisim.```

- 11 registers: 8 general-purpose (r0-r7) + SP, PC, FLAGS

- Three instruction formats: R-type, I-type, J-type### Features- If you're using VS Code, you can open the file in the Explorer and preview it in the editor.

- Simple load/store architecture

- Conditional branching (JZ, JNZ)✅ **Complete instruction set support:**Notes:

- 8 ALU operations with full flag support

- Arithmetic & Logic: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

### Instruction Set

- Data Transfer: `MOV` (immediate), `LD`, `ST`- This repository currently contains only the PDF. If you want a more detailed README (project goals, build instructions, references, or contributor notes), tell me what to include and I'll expand it.

- **Arithmetic & Logic:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

- **Data Transfer:** `MOV` (immediate), `LD`, `ST`- Control Flow: `JMP`, `JZ`, `JNZ`

- **Control Flow:** `JMP`, `JZ`, `JNZ`

- **System:** `HLT`- System: `HLT`---

See `solix16.pdf` for complete specifications.✅ **Robust parsing:**Generated on 2025-11-17.

---- Two-pass assembly with full label resolution

- Case-insensitive labels and mnemonics (normalized to uppercase)

## Assembler- Flexible operand spacing (handles `r1,r2,r3` and `r1 , r2 , r3`)

- Multiple number formats: decimal (`42`), hex (`0xFF`), binary (`0b1010`)

A robust two-pass assembler that generates machine code compatible with Logisim.

✅ **Error handling:**

### Features

- Detailed error messages with line numbers

✅ **Complete instruction set support** - Safe immediate value parsing

✅ **Two-pass assembly** with full label resolution - Register and instruction validation

✅ **Case-insensitive** labels and mnemonics

✅ **Flexible operand spacing** (`r1,r2,r3` or `r1 , r2 , r3`) ### Build & Usage

✅ **Multiple number formats:** decimal (`42`), hex (`0xFF`), binary (`0b1010`)

✅ **Comprehensive error handling** with line numbers ```bash

✅ **Production-ready** with all critical bugs fixed# Compile

cd assembler

### Build & Usageg++ -std=c++11 -Wall -o solix16asm main.cpp

````bash# Assemble a program

# Compile./solix16asm input.asm output.hex

cd assembler

g++ -std=c++11 -Wall -o solix16asm main.cpp# Example

./solix16asm test.asm test.hex

# Assemble a program```

./solix16asm input.asm output.hex

### Example Program

# Example

./solix16asm test.asm test.hex```asm

```; Sum numbers 1-5

    MOV r1, 0           ; Sum accumulator

### Example Program    MOV r2, 5           ; Counter



```asmloop:

; Sum numbers 1-5    ADD r1, r1, r2      ; sum += counter

    MOV r1, 0           ; Sum accumulator    SUB r2, r2, 1       ; counter--

    MOV r2, 5           ; Counter    JNZ loop            ; Repeat if counter != 0



loop:    HLT                 ; Stop

    ADD r1, r1, r2      ; sum += counter```

    SUB r2, r2, 1       ; counter--

    JNZ loop            ; Repeat if counter != 0### Output Format



    HLT                 ; StopGenerates **Logisim v2.0 raw** format:

````

```

### Output Formatv2.0 raw

810a 8220 d021 0312 1431 5540 6650 b003

Generates **Logisim v2.0 raw** format:f000

```

````

v2.0 raw## Recent Bug Fixes (Nov 2024)

8100 8205 0112 1221 b001 f000

```### Critical Fixes (Round 1)



---1. **ST instruction encoding** ✅



## Verilog ALU   - **Bug:** `ST Rs, Rt` was encoding `Rd=Rs` instead of `Rd=0`

   - **Impact:** Memory writes would corrupt instruction format

Complete 16-bit ALU implementation with testbench.   - **Fixed:** Now correctly encodes `[opcode | 0000 | Rs | Rt]`



### Features2. **Operand parsing** ✅



- **8 operations:** ADD, SUB, AND, OR, XOR, NOT, SHL, SHR   - **Bug:** Concatenating operands without delimiters (`ADD r1,r2,r3` → `"r1r2r3"`)

- **4 status flags:** Zero, Negative, Carry, Overflow   - **Impact:** All multi-operand instructions would fail to parse

- **Combinational logic** for fast operation   - **Fixed:** Preserve spaces when reassembling operand string

- **Carry/overflow detection** for arithmetic operations

- **Comprehensive testbench** with automated verification3. **Label case sensitivity** ✅



### ALU Operations   - **Bug:** Labels preserved original case but mnemonics uppercased

   - **Impact:** `loop:` with `JNZ LOOP` would fail to resolve

| `alu_op` | Operation | Description |   - **Fixed:** Normalize all labels to uppercase for consistent lookup

|----------|-----------|-------------|

| `3'b000` | ADD       | result = a + b (with carry) |4. **Immediate parsing safety** ✅

| `3'b001` | SUB       | result = a - b (with borrow) |

| `3'b010` | AND       | result = a & b |   - **Bug:** No validation before `substr(0,2)` for prefix detection

| `3'b011` | OR        | result = a \| b |   - **Impact:** Empty immediates or malformed values crashed

| `3'b100` | XOR       | result = a ^ b |   - **Fixed:** Check string length and validate before parsing

| `3'b101` | NOT       | result = ~a |

| `3'b110` | SHL       | result = a << 1 (carry = MSB) |5. **HLT encoding cleanup** ✅

| `3'b111` | SHR       | result = a >> 1 (carry = LSB) |   - **Minor:** Used R-type encoding unnecessarily

   - **Fixed:** Use clean `opcode << 12` encoding

### Status Flags

### Critical Fixes (Round 2 - Nov 19, 2024)

- **Zero (Z):** Set when result is 0x0000

- **Negative (N):** Set when result MSB is 1 (signed negative)6. **Ignored cleaned variable in second pass** ✅ **[MOST CRITICAL]**

- **Carry (C):** Set on arithmetic carry/borrow or shift out

- **Overflow (O):** Set on signed arithmetic overflow   - **Bug:** Second pass called `assembleInstruction(lines[lineNum], ...)` instead of `assembleInstruction(cleaned, ...)`

   - **Impact:** Comments and labels were NOT stripped before parsing, breaking ANY line with comments or labels

### Simulation   - **Example:** `loop: ADD r1,r2,r3 ; comment` would try to parse the entire raw line including `;comment`

   - **Fixed:** Use the already-cleaned string that has comments/labels removed

```bash

# Compile with Icarus Verilog7. **Silent immediate truncation** ✅

cd verilog

iverilog -o alu_sim alu.v alu_tb.v   - **Bug:** `parseImmediate()` returns `uint16_t` but was cast to `uint8_t` BEFORE range checking

   - **Impact:** `MOV r1, 300` would silently truncate to `44` instead of throwing an error

# Run simulation   - **Fixed:** Check `if (imm16 > 255)` before truncating to `uint8_t`

vvp alu_sim

8. **Redundant range check removed** ✅

# View waveform (if generated)   - **Bug:** `encodeIType()` checked `if (imm > 255)` but imm was already `uint8_t` (always false)

gtkwave alu.vcd   - **Impact:** Compiler warning, unreachable code

```   - **Fixed:** Removed redundant check since validation now happens at call site



### Expected Test Output### Verification



```All fixes verified with comprehensive test suite:

=== Solix-16 ALU Testbench ===

**Test 1: Comment and label stripping**

Testing ADD...

  5 + 3 = 8 ✓```asm

  FFFF + 1 = 0 (carry) ✓start:  MOV r1, 15  ; inline comment with label

  7FFF + 1 = 8000 (overflow) ✓        JNZ loop    ; uppercase reference

````

Testing SUB...

10 - 5 = B ✓✅ Passes with cleaned variable fix

0 - 1 = FFFF (borrow) ✓

**Test 2: Immediate overflow detection**

Testing AND...

AAAA & 5555 = 0 ✓```asm

MOV r1, 300 ; Should fail

Testing OR...```

AA00 | 0055 = AA55 ✓

✅ Now throws: `Immediate value out of range (0-255): 300`

Testing XOR...

FFFF ^ AAAA = 5555 ✓**Test 3: ST encoding**

Testing NOT...```

~AAAA = 5555 ✓ST r2, r1 → 0xD021 = 1101 0000 0010 0001

                         ^^^^ ^^^^ ^^^^ ^^^^

Testing SHL... ST Rd=0 Rs=2 Rt=1 ✓

4000 << 1 = 8000 (carry) ✓```

Testing SHR...**Test 4: Case-insensitive labels**

0001 >> 1 = 0 (carry) ✓

````asm

All tests passed! ✓Loop:

```    JNZ LOOP  ; Works correctly

````

---

✅ Both stored and looked up as uppercase

## Recent Bug Fixes (Nov 2024)

## Architecture Overview

### Critical Assembler Fixes

**Solix-16** is a 16-bit RISC-style architecture featuring:

**Round 1 (Nov 18):**

1. ✅ ST instruction encoding (Rd=0)- 16-bit data and address bus (64KB addressable memory)

2. ✅ Operand parsing with delimiters- 11 registers including 8 general-purpose (r0-r7)

3. ✅ Label case normalization- Special registers: SP (stack pointer), PC (program counter), FLAGS

4. ✅ Immediate parsing safety- Three instruction formats: R-type, I-type, J-type

5. ✅ HLT encoding cleanup- Simple load/store architecture

- Zero and non-zero conditional branching

**Round 2 (Nov 19):**

6. ✅ **[CRITICAL]** Fixed ignored `cleaned` variable in second passSee `solix16&ISA.pdf` for complete specifications.

7. ✅ Silent immediate truncation detection

8. ✅ Removed redundant range checks## Quick Start

### Verification```bash

# View the PDF documentation

All fixes verified with comprehensive test suite:xdg-open "solix16&ISA.pdf"

````bash# Build and run a test

# Test comment/label strippingcd assembler

$ ./solix16asm comprehensive_test.asmg++ -std=c++11 -Wall -o solix16asm main.cpp

Assembly successful! ✓./solix16asm test.asm test.hex

cat test.hex  # View generated machine code

# Test immediate overflow detection```

$ ./solix16asm overflow_test.asm

Error: Immediate value out of range (0-255): 300 ✓## Contributing

````

When modifying the assembler:

**Key encoding verification:**

````1. Maintain two-pass architecture for forward references

ST r2, r1  →  0xD021  =  1101 0000 0010 00012. Keep error messages informative with line numbers

                         ^^^^ ^^^^ ^^^^ ^^^^3. Test with edge cases (spacing variations, case mixing, number formats)

                         ST   Rd=0 Rs=2 Rt=1  ✓4. Verify encoding matches ISA specification exactly

```5. Run test suite before committing



---## Resources



## Quick Start- **ISA Spec:** `solix16&ISA.pdf`

- **Assembler Source:** `assembler/main.cpp`

### 1. View Documentation- **Test Programs:** `assembler/*.asm`

```bash

# Open ISA specification---

xdg-open solix16.pdf

```**Last Updated:** November 2024

**Status:** Production-ready assembler with comprehensive bug fixes

### 2. Build Assembler
```bash
cd assembler
g++ -std=c++11 -Wall -o solix16asm main.cpp
./solix16asm test.asm test.hex
````

### 3. Simulate ALU

```bash
cd verilog
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

---

## Project Structure

```
solix-16/
├── solix16.pdf          # ISA specification
├── README.md            # This file
├── assembler/           # Software tools
│   ├── main.cpp         # Assembler source
│   ├── solix16asm       # Compiled assembler
│   └── *.asm            # Test programs
└── verilog/             # Hardware implementation
    ├── alu.v            # ALU module
    ├── alu_tb.v         # ALU testbench
    └── alu_sim          # Compiled simulation
```

---

## Contributing

When modifying the project:

**Assembler:**

1. Maintain two-pass architecture for forward references
2. Keep error messages informative with line numbers
3. Test with edge cases (spacing, case mixing, number formats)
4. Verify encoding matches ISA specification exactly

**Verilog:**

1. Keep modules modular and well-commented
2. Write comprehensive testbenches for all modules
3. Verify timing and combinational logic
4. Test edge cases (overflow, carry, zero flags)

---

## Resources

- **ISA Spec:** `solix16.pdf`
- **Assembler Source:** `assembler/main.cpp`
- **Hardware Source:** `verilog/alu.v`
- **Test Programs:** `assembler/*.asm`
- **Testbenches:** `verilog/*_tb.v`

---

**Last Updated:** November 2024  
**Status:** ✅ Production-ready assembler | ✅ Working ALU implementation  
**Next Steps:** Control unit, register file, memory interface
