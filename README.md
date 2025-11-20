# Solix-16 CPU Architecture Project# Solix-16 CPU Architecture Project# Solix-16 CPU Architecture Project# Project: CPU Docs Workspace

This repository contains the **Solix-16**, a complete 16-bit educational CPU architecture with assembler and hardware implementation.This repository contains the **Solix-16**, a complete 16-bit educational CPU architecture with assembler and hardware implementation.This repository contains the **Solix-16**, a 16-bit educational CPU architecture with a custom assembler implementation.This workspace contains study/reference material related to CPU architecture.

## Contents## Contents## ContentsIncluded file:

- **`solix16.pdf`** — Complete ISA specification and architecture documentation- **`solix16.pdf`** — Complete ISA specification and architecture documentation- **`solix16&ISA.pdf`** — Complete ISA specification and architecture documentation- `solix16&ISA.pdf` — a PDF document in the repository root. Open it with your preferred PDF viewer.

- **`assembler/`** — Two-pass assembler implementation in C++

  - `main.cpp` — Full assembler with label resolution- **`assembler/`** — Two-pass assembler implementation in C++

  - `solix16asm` — Compiled executable

  - Test programs (`test.asm`, `comprehensive_test.asm`, etc.) - `main.cpp` — Full assembler with label resolution- **`assembler/`** — Solix-16 assembler implementation in C++

- **`verilog/`** — Hardware implementation in Verilog

  - `alu.v` — 16-bit ALU with 8 operations - `solix16asm` — Compiled executable

  - `alu_tb.v` — ALU testbench

  - `register_file.v` — 11x16-bit register file - Test programs (`test.asm`, `comprehensive_test.asm`, etc.) - `main.cpp` — Full assembler with two-pass label resolutionQuick tips:

  - `register_file_dff.v` — Register file with explicit DFF modules

  - `register_file_tb.v` — Register file testbench- **`verilog/`** — Hardware implementation in Verilog

  - `dff.v` — D flip-flop building blocks

  - `alu.v` — 16-bit ALU with 8 operations - `solix16asm` — Compiled executable

## Solix-16 Architecture

- `alu_tb.v` — Comprehensive testbench

**Solix-16** is a 16-bit RISC-style architecture featuring:

- `alu_sim` — Compiled simulation executable - Test programs (`test.asm`, `bugfix_test.asm`)- To open the PDF from the command line on Linux:

- 16-bit data and address bus (64KB addressable memory)

- 11 registers: 8 general-purpose (r0-r7) + SP, PC, FLAGS## Solix-16 Architecture## Solix-16 Assembler```bash

- Three instruction formats: R-type, I-type, J-type

- Simple load/store architecture**Solix-16** is a 16-bit RISC-style architecture featuring:xdg-open "solix16&ISA.pdf" # or use your preferred PDF viewer (evince, okular, mupdf, etc.)

- Conditional branching (JZ, JNZ)

- 8 ALU operations with full flag support- 16-bit data and address bus (64KB addressable memory)A robust two-pass assembler for the Solix-16 ISA that generates machine code compatible with Logisim.```

### Instruction Set- 11 registers: 8 general-purpose (r0-r7) + SP, PC, FLAGS

- **Arithmetic & Logic:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`- Three instruction formats: R-type, I-type, J-type### Features- If you're using VS Code, you can open the file in the Explorer and preview it in the editor.

- **Data Transfer:** `MOV` (immediate), `LD`, `ST`

- **Control Flow:** `JMP`, `JZ`, `JNZ`- Simple load/store architecture

- **System:** `HLT`

- Conditional branching (JZ, JNZ)✅ **Complete instruction set support:**Notes:

See `solix16.pdf` for complete specifications.

- 8 ALU operations with full flag support

---

- Arithmetic & Logic: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

## Assembler

### Instruction Set

A robust two-pass assembler that generates machine code compatible with Logisim.

- Data Transfer: `MOV` (immediate), `LD`, `ST`- This repository currently contains only the PDF. If you want a more detailed README (project goals, build instructions, references, or contributor notes), tell me what to include and I'll expand it.

### Features

- **Arithmetic & Logic:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

✅ **Complete instruction set support**

✅ **Two-pass assembly** with full label resolution - **Data Transfer:** `MOV` (immediate), `LD`, `ST`- Control Flow: `JMP`, `JZ`, `JNZ`

✅ **Case-insensitive** labels and mnemonics

✅ **Flexible operand spacing** (`r1,r2,r3` or `r1 , r2 , r3`) - **Control Flow:** `JMP`, `JZ`, `JNZ`

✅ **Multiple number formats:** decimal (`42`), hex (`0xFF`), binary (`0b1010`)

✅ **Comprehensive error handling** with line numbers - **System:** `HLT`- System: `HLT`---

✅ **Production-ready** with all critical bugs fixed

See `solix16.pdf` for complete specifications.✅ **Robust parsing:**Generated on 2025-11-17.

### Build & Usage

---- Two-pass assembly with full label resolution

```bash

# Compile- Case-insensitive labels and mnemonics (normalized to uppercase)

cd assembler

g++ -std=c++11 -Wall -o solix16asm main.cpp## Assembler- Flexible operand spacing (handles `r1,r2,r3` and `r1 , r2 , r3`)



# Assemble a program- Multiple number formats: decimal (`42`), hex (`0xFF`), binary (`0b1010`)

./solix16asm input.asm output.hex

A robust two-pass assembler that generates machine code compatible with Logisim.

# Example

./solix16asm test.asm test.hex✅ **Error handling:**

```

### Features

### Example Program

- Detailed error messages with line numbers

`````asm

; Sum numbers 1-5✅ **Complete instruction set support** - Safe immediate value parsing

    MOV r1, 0           ; Sum accumulator

    MOV r2, 5           ; Counter✅ **Two-pass assembly** with full label resolution - Register and instruction validation



loop:✅ **Case-insensitive** labels and mnemonics

    ADD r1, r1, r2      ; sum += counter

    SUB r2, r2, 1       ; counter--✅ **Flexible operand spacing** (`r1,r2,r3` or `r1 , r2 , r3`) ### Build & Usage

    JNZ loop            ; Repeat if counter != 0

    ✅ **Multiple number formats:** decimal (`42`), hex (`0xFF`), binary (`0b1010`)

    HLT                 ; Stop

```✅ **Comprehensive error handling** with line numbers ```bash



### Output Format✅ **Production-ready** with all critical bugs fixed# Compile



Generates **Logisim v2.0 raw** format:cd assembler



```### Build & Usageg++ -std=c++11 -Wall -o solix16asm main.cpp

v2.0 raw

8100 8205 0112 1221 b001 f000````bash# Assemble a program

`````

# Compile./solix16asm input.asm output.hex

---

cd assembler

## Verilog Hardware Implementation

g++ -std=c++11 -Wall -o solix16asm main.cpp# Example

### ALU (Arithmetic Logic Unit)

./solix16asm test.asm test.hex

Complete 16-bit ALU implementation with testbench.

# Assemble a program```

#### Features

./solix16asm input.asm output.hex

- **8 operations:** ADD, SUB, AND, OR, XOR, NOT, SHL, SHR

- **4 status flags:** Zero, Negative, Carry, Overflow### Example Program

- **Combinational logic** for fast operation

- **Carry/overflow detection** for arithmetic operations# Example

- **Comprehensive testbench** with automated verification

./solix16asm test.asm test.hex```asm

#### ALU Operations

`````; Sum numbers 1-5

| `alu_op` | Operation | Description |

|----------|-----------|-------------|    MOV r1, 0           ; Sum accumulator

| `3'b000` | ADD       | result = a + b (with carry) |

| `3'b001` | SUB       | result = a - b (with borrow) |### Example Program    MOV r2, 5           ; Counter

| `3'b010` | AND       | result = a & b |

| `3'b011` | OR        | result = a \| b |

| `3'b100` | XOR       | result = a ^ b |

| `3'b101` | NOT       | result = ~a |```asmloop:

| `3'b110` | SHL       | result = a << 1 (carry = MSB) |

| `3'b111` | SHR       | result = a >> 1 (carry = LSB) |; Sum numbers 1-5    ADD r1, r1, r2      ; sum += counter



#### Status Flags    MOV r1, 0           ; Sum accumulator    SUB r2, r2, 1       ; counter--



- **Zero (Z):** Set when result is 0x0000    MOV r2, 5           ; Counter    JNZ loop            ; Repeat if counter != 0

- **Negative (N):** Set when result MSB is 1 (signed negative)

- **Carry (C):** Set on arithmetic carry/borrow or shift out

- **Overflow (O):** Set on signed arithmetic overflow

loop:    HLT                 ; Stop

---

    ADD r1, r1, r2      ; sum += counter```

### Register File

    SUB r2, r2, 1       ; counter--

16-bit register file with 11 registers built using D flip-flops.

    JNZ loop            ; Repeat if counter != 0### Output Format

#### Features



- **11 registers total:**

  - 8 general-purpose (r0-r7)    HLT                 ; StopGenerates **Logisim v2.0 raw** format:

  - 3 special registers (SP, PC, FLAGS)

- **Dual read ports** for simultaneous ALU operand access````

- **Single write port** with enable control

- **Asynchronous read** (combinational)```

- **Synchronous write** on positive clock edge

- **Asynchronous reset** (active high)### Output Formatv2.0 raw

- **Independent special register control** (PC, SP, FLAGS)

810a 8220 d021 0312 1431 5540 6650 b003

#### Register Map

Generates **Logisim v2.0 raw** format:f000

| Address | Register | Description |

|---------|----------|-------------|```

| `4'h0` - `4'h7` | r0-r7 | General-purpose registers |

| `4'h8` | SP | Stack Pointer |````

| `4'h9` | PC | Program Counter |

| `4'hA` | FLAGS | Status Flags (Z, N, C, O) |v2.0 raw## Recent Bug Fixes (Nov 2024)



#### Ports8100 8205 0112 1221 b001 f000



```verilog```### Critical Fixes (Round 1)

// Clock and reset

input clk, rst



// Dual read ports---1. **ST instruction encoding** ✅

input [3:0] rs_addr, rt_addr       // Read addresses

output [15:0] rs_data, rt_data     // Read data



// Write port## Verilog ALU   - **Bug:** `ST Rs, Rt` was encoding `Rd=Rs` instead of `Rd=0`

input wr_en                         // Write enable

input [3:0] rd_addr                 // Write address   - **Impact:** Memory writes would corrupt instruction format

input [15:0] rd_data                // Write data

Complete 16-bit ALU implementation with testbench.   - **Fixed:** Now correctly encodes `[opcode | 0000 | Rs | Rt]`

// Special register access

output [15:0] pc_out, sp_out, flags_out

input pc_wr, sp_wr, flags_wr

input [15:0] pc_in, sp_in, flags_in### Features2. **Operand parsing** ✅

`````

#### Implementation Variants

- **8 operations:** ADD, SUB, AND, OR, XOR, NOT, SHL, SHR - **Bug:** Concatenating operands without delimiters (`ADD r1,r2,r3` → `"r1r2r3"`)

**`register_file.v`** - Compact implementation using register array

**`register_file_dff.v`** - Explicit DFF instantiation showing internal structure - **4 status flags:** Zero, Negative, Carry, Overflow - **Impact:** All multi-operand instructions would fail to parse

**`dff.v`** - Basic D flip-flop building blocks (1-bit and 16-bit)

- **Combinational logic** for fast operation - **Fixed:** Preserve spaces when reassembling operand string

#### Example Usage

- **Carry/overflow detection** for arithmetic operations

```verilog

// Write r1 = 0x1234- **Comprehensive testbench** with automated verification3. **Label case sensitivity** ✅

@(posedge clk);

wr_en = 1;

rd_addr = 4'd1;

rd_data = 16'h1234;### ALU Operations   - **Bug:** Labels preserved original case but mnemonics uppercased



// Read r1 and r2 simultaneously   - **Impact:** `loop:` with `JNZ LOOP` would fail to resolve

rs_addr = 4'd1;

rt_addr = 4'd2;| `alu_op` | Operation | Description |   - **Fixed:** Normalize all labels to uppercase for consistent lookup

// rs_data and rt_data available combinationally

|----------|-----------|-------------|

// Update PC

pc_wr = 1;| `3'b000` | ADD       | result = a + b (with carry) |4. **Immediate parsing safety** ✅

pc_in = 16'h0100;

@(posedge clk);| `3'b001` | SUB       | result = a - b (with borrow) |

```

| `3'b010` | AND | result = a & b | - **Bug:** No validation before `substr(0,2)` for prefix detection

---

| `3'b011` | OR | result = a \| b | - **Impact:** Empty immediates or malformed values crashed

## Simulation

| `3'b100` | XOR | result = a ^ b | - **Fixed:** Check string length and validate before parsing

### Compile and Run ALU Tests

| `3'b101` | NOT | result = ~a |

```bash

cd verilog| `3'b110` | SHL       | result = a << 1 (carry = MSB) |5. **HLT encoding cleanup** ✅

iverilog -o alu_sim alu.v alu_tb.v

vvp alu_sim| `3'b111` | SHR       | result = a >> 1 (carry = LSB) |   - **Minor:** Used R-type encoding unnecessarily

```

- **Fixed:** Use clean `opcode << 12` encoding

### Compile and Run Register File Tests

### Status Flags

```bash

cd verilog### Critical Fixes (Round 2 - Nov 19, 2024)

iverilog -o regfile_sim register_file.v register_file_tb.v

vvp regfile_sim- **Zero (Z):** Set when result is 0x0000

```

- **Negative (N):** Set when result MSB is 1 (signed negative)6. **Ignored cleaned variable in second pass** ✅ **[MOST CRITICAL]**

### View Waveforms

- **Carry (C):** Set on arithmetic carry/borrow or shift out

````bash

gtkwave alu.vcd- **Overflow (O):** Set on signed arithmetic overflow   - **Bug:** Second pass called `assembleInstruction(lines[lineNum], ...)` instead of `assembleInstruction(cleaned, ...)`

gtkwave register_file.vcd

```   - **Impact:** Comments and labels were NOT stripped before parsing, breaking ANY line with comments or labels



### Expected Test Output### Simulation   - **Example:** `loop: ADD r1,r2,r3 ; comment` would try to parse the entire raw line including `;comment`



**ALU Test:**   - **Fixed:** Use the already-cleaned string that has comments/labels removed

````

=== Solix-16 ALU Testbench ===```bash

Testing ADD...# Compile with Icarus Verilog7. **Silent immediate truncation** ✅

5 + 3 = 8 ✓

FFFF + 1 = 0 (carry) ✓cd verilog

7FFF + 1 = 8000 (overflow) ✓

iverilog -o alu_sim alu.v alu_tb.v - **Bug:** `parseImmediate()` returns `uint16_t` but was cast to `uint8_t` BEFORE range checking

Testing SUB...

10 - 5 = B ✓ - **Impact:** `MOV r1, 300` would silently truncate to `44` instead of throwing an error

0 - 1 = FFFF (borrow) ✓

# Run simulation - **Fixed:** Check `if (imm16 > 255)` before truncating to `uint8_t`

All tests passed! ✓

```vvp alu_sim



**Register File Test:**8. **Redundant range check removed** ✅

```

=== Solix-16 Register File Testbench ===# View waveform (if generated) - **Bug:** `encodeIType()` checked `if (imm > 255)` but imm was already `uint8_t` (always false)

Test 1: Reset verificationgtkwave alu.vcd - **Impact:** Compiler warning, unreachable code

All registers should be 0

r0 = 0x0000 ✓``` - **Fixed:** Removed redundant check since validation now happens at call site

r7 = 0x0000 ✓

PC, SP, FLAGS = 0 ✓

Test 2: Writing to general-purpose registers### Expected Test Output### Verification

r1 = 0x1234 ✓

r3 = 0xABCD ✓

All tests completed!```All fixes verified with comprehensive test suite:

`````

=== Solix-16 ALU Testbench ===

---

**Test 1: Comment and label stripping**

## Recent Bug Fixes (Nov 2024)

Testing ADD...

### Critical Assembler Fixes

  5 + 3 = 8 ✓```asm

**Round 1 (Nov 18):**

1. ✅ ST instruction encoding (Rd=0)  FFFF + 1 = 0 (carry) ✓start:  MOV r1, 15  ; inline comment with label

2. ✅ Operand parsing with delimiters

3. ✅ Label case normalization  7FFF + 1 = 8000 (overflow) ✓        JNZ loop    ; uppercase reference

4. ✅ Immediate parsing safety

5. ✅ HLT encoding cleanup````



**Round 2 (Nov 19):**Testing SUB...

6. ✅ **[CRITICAL]** Fixed ignored `cleaned` variable in second pass

7. ✅ Silent immediate truncation detection10 - 5 = B ✓✅ Passes with cleaned variable fix

8. ✅ Removed redundant range checks

0 - 1 = FFFF (borrow) ✓

### Verification

**Test 2: Immediate overflow detection**

All fixes verified with comprehensive test suite:

Testing AND...

```bash

# Test comment/label strippingAAAA & 5555 = 0 ✓```asm

$ ./solix16asm comprehensive_test.asm

Assembly successful! ✓MOV r1, 300 ; Should fail



# Test immediate overflow detectionTesting OR...```

$ ./solix16asm overflow_test.asm

Error: Immediate value out of range (0-255): 300 ✓AA00 | 0055 = AA55 ✓

`````

✅ Now throws: `Immediate value out of range (0-255): 300`

**Key encoding verification:**

`````Testing XOR...

ST r2, r1  →  0xD021  =  1101 0000 0010 0001

                         ^^^^ ^^^^ ^^^^ ^^^^FFFF ^ AAAA = 5555 ✓**Test 3: ST encoding**

                         ST   Rd=0 Rs=2 Rt=1  ✓

```Testing NOT...```



---~AAAA = 5555 ✓ST r2, r1 → 0xD021 = 1101 0000 0010 0001



## Quick Start                         ^^^^ ^^^^ ^^^^ ^^^^



### 1. View DocumentationTesting SHL... ST Rd=0 Rs=2 Rt=1 ✓

```bash

# Open ISA specification4000 << 1 = 8000 (carry) ✓```

xdg-open solix16.pdf

```Testing SHR...**Test 4: Case-insensitive labels**



### 2. Build Assembler0001 >> 1 = 0 (carry) ✓

```bash

cd assembler````asm

g++ -std=c++11 -Wall -o solix16asm main.cpp

./solix16asm test.asm test.hexAll tests passed! ✓Loop:

`````

``````JNZ LOOP  ; Works correctly

### 3. Simulate Hardware

```bash````

cd verilog

---

# Test ALU

iverilog -o alu_sim alu.v alu_tb.v✅ Both stored and looked up as uppercase

vvp alu_sim

## Recent Bug Fixes (Nov 2024)

# Test Register File

iverilog -o regfile_sim register_file.v register_file_tb.v## Architecture Overview

vvp regfile_sim

```### Critical Assembler Fixes



---**Solix-16** is a 16-bit RISC-style architecture featuring:



## Project Structure**Round 1 (Nov 18):**



```1. ✅ ST instruction encoding (Rd=0)- 16-bit data and address bus (64KB addressable memory)

solix-16/

├── solix16.pdf              # ISA specification2. ✅ Operand parsing with delimiters- 11 registers including 8 general-purpose (r0-r7)

├── README.md                # This file

├── assembler/               # Software tools3. ✅ Label case normalization- Special registers: SP (stack pointer), PC (program counter), FLAGS

│   ├── main.cpp             # Assembler source

│   ├── solix16asm           # Compiled assembler4. ✅ Immediate parsing safety- Three instruction formats: R-type, I-type, J-type

│   └── *.asm                # Test programs

└── verilog/                 # Hardware implementation5. ✅ HLT encoding cleanup- Simple load/store architecture

    ├── alu.v                # ALU module

    ├── alu_tb.v             # ALU testbench- Zero and non-zero conditional branching

    ├── register_file.v      # Register file (array-based)

    ├── register_file_dff.v  # Register file (explicit DFF)**Round 2 (Nov 19):**

    ├── register_file_tb.v   # Register file testbench

    ├── dff.v                # D flip-flop modules6. ✅ **[CRITICAL]** Fixed ignored `cleaned` variable in second passSee `solix16&ISA.pdf` for complete specifications.

    └── *.vcd                # Waveform dumps

```7. ✅ Silent immediate truncation detection



---8. ✅ Removed redundant range checks## Quick Start



## Contributing### Verification```bash



When modifying the project:# View the PDF documentation



**Assembler:**All fixes verified with comprehensive test suite:xdg-open "solix16&ISA.pdf"

1. Maintain two-pass architecture for forward references

2. Keep error messages informative with line numbers````bash# Build and run a test

3. Test with edge cases (spacing, case mixing, number formats)

4. Verify encoding matches ISA specification exactly# Test comment/label strippingcd assembler



**Verilog:**$ ./solix16asm comprehensive_test.asmg++ -std=c++11 -Wall -o solix16asm main.cpp

1. Keep modules modular and well-commented

2. Write comprehensive testbenches for all modulesAssembly successful! ✓./solix16asm test.asm test.hex

3. Verify timing and combinational logic

4. Test edge cases (overflow, carry, zero flags, reset behavior)cat test.hex  # View generated machine code

5. Use asynchronous reset for all sequential elements

# Test immediate overflow detection```

---

$ ./solix16asm overflow_test.asm

## Resources

Error: Immediate value out of range (0-255): 300 ✓## Contributing

- **ISA Spec:** `solix16.pdf`

- **Assembler Source:** `assembler/main.cpp`````

- **Hardware Source:** `verilog/*.v`

- **Test Programs:** `assembler/*.asm`When modifying the assembler:

- **Testbenches:** `verilog/*_tb.v`

**Key encoding verification:**

---

````1. Maintain two-pass architecture for forward references

**Last Updated:** November 2024

**Status:**  ST r2, r1  →  0xD021  =  1101 0000 0010 00012. Keep error messages informative with line numbers

✅ Production-ready assembler

✅ Working ALU implementation                           ^^^^ ^^^^ ^^^^ ^^^^3. Test with edge cases (spacing variations, case mixing, number formats)

✅ Working Register File with DFF-based design

**Next Steps:** Control unit, memory interface, instruction decoder                         ST   Rd=0 Rs=2 Rt=1  ✓4. Verify encoding matches ISA specification exactly


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
``````

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
