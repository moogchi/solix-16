# Solix-16 CPU Architecture Project# Project: CPU Docs Workspace

This repository contains the **Solix-16**, a 16-bit educational CPU architecture with a custom assembler implementation.This workspace contains study/reference material related to CPU architecture.

## ContentsIncluded file:

- **`solix16&ISA.pdf`** — Complete ISA specification and architecture documentation- `solix16&ISA.pdf` — a PDF document in the repository root. Open it with your preferred PDF viewer.

- **`assembler/`** — Solix-16 assembler implementation in C++

  - `main.cpp` — Full assembler with two-pass label resolutionQuick tips:

  - `solix16asm` — Compiled executable

  - Test programs (`test.asm`, `bugfix_test.asm`)- To open the PDF from the command line on Linux:

## Solix-16 Assembler```bash

xdg-open "solix16&ISA.pdf" # or use your preferred PDF viewer (evince, okular, mupdf, etc.)

A robust two-pass assembler for the Solix-16 ISA that generates machine code compatible with Logisim.```

### Features- If you're using VS Code, you can open the file in the Explorer and preview it in the editor.

✅ **Complete instruction set support:**Notes:

- Arithmetic & Logic: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`

- Data Transfer: `MOV` (immediate), `LD`, `ST`- This repository currently contains only the PDF. If you want a more detailed README (project goals, build instructions, references, or contributor notes), tell me what to include and I'll expand it.

- Control Flow: `JMP`, `JZ`, `JNZ`

- System: `HLT`---

✅ **Robust parsing:**Generated on 2025-11-17.

- Two-pass assembly with full label resolution
- Case-insensitive labels and mnemonics (normalized to uppercase)
- Flexible operand spacing (handles `r1,r2,r3` and `r1 , r2 , r3`)
- Multiple number formats: decimal (`42`), hex (`0xFF`), binary (`0b1010`)

✅ **Error handling:**

- Detailed error messages with line numbers
- Safe immediate value parsing
- Register and instruction validation

### Build & Usage

```bash
# Compile
cd assembler
g++ -std=c++11 -Wall -o solix16asm main.cpp

# Assemble a program
./solix16asm input.asm output.hex

# Example
./solix16asm test.asm test.hex
```

### Example Program

```asm
; Sum numbers 1-5
    MOV r1, 0           ; Sum accumulator
    MOV r2, 5           ; Counter

loop:
    ADD r1, r1, r2      ; sum += counter
    SUB r2, r2, 1       ; counter--
    JNZ loop            ; Repeat if counter != 0

    HLT                 ; Stop
```

### Output Format

Generates **Logisim v2.0 raw** format:

```
v2.0 raw
810a 8220 d021 0312 1431 5540 6650 b003
f000
```

## Recent Bug Fixes (Nov 2024)

### Critical Fixes

1. **ST instruction encoding** ✅

   - **Bug:** `ST Rs, Rt` was encoding `Rd=Rs` instead of `Rd=0`
   - **Impact:** Memory writes would corrupt instruction format
   - **Fixed:** Now correctly encodes `[opcode | 0000 | Rs | Rt]`

2. **Operand parsing** ✅

   - **Bug:** Concatenating operands without delimiters (`ADD r1,r2,r3` → `"r1r2r3"`)
   - **Impact:** All multi-operand instructions would fail to parse
   - **Fixed:** Preserve spaces when reassembling operand string

3. **Label case sensitivity** ✅

   - **Bug:** Labels preserved original case but mnemonics uppercased
   - **Impact:** `loop:` with `JNZ LOOP` would fail to resolve
   - **Fixed:** Normalize all labels to uppercase for consistent lookup

4. **Immediate parsing safety** ✅

   - **Bug:** No validation before `substr(0,2)` for prefix detection
   - **Impact:** Empty immediates or malformed values crashed
   - **Fixed:** Check string length and validate before parsing

5. **HLT encoding cleanup** ✅
   - **Minor:** Used R-type encoding unnecessarily
   - **Fixed:** Use clean `opcode << 12` encoding

### Verification

All fixes verified with test suite. Example ST encoding:

```
ST r2, r1  →  0xD021  =  1101 0000 0010 0001
                         ^^^^ ^^^^ ^^^^ ^^^^
                         ST   Rd=0 Rs=2 Rt=1  ✓
```

## Architecture Overview

**Solix-16** is a 16-bit RISC-style architecture featuring:

- 16-bit data and address bus (64KB addressable memory)
- 11 registers including 8 general-purpose (r0-r7)
- Special registers: SP (stack pointer), PC (program counter), FLAGS
- Three instruction formats: R-type, I-type, J-type
- Simple load/store architecture
- Zero and non-zero conditional branching

See `solix16&ISA.pdf` for complete specifications.

## Quick Start

```bash
# View the PDF documentation
xdg-open "solix16&ISA.pdf"

# Build and run a test
cd assembler
g++ -std=c++11 -Wall -o solix16asm main.cpp
./solix16asm test.asm test.hex
cat test.hex  # View generated machine code
```

## Contributing

When modifying the assembler:

1. Maintain two-pass architecture for forward references
2. Keep error messages informative with line numbers
3. Test with edge cases (spacing variations, case mixing, number formats)
4. Verify encoding matches ISA specification exactly
5. Run test suite before committing

## Resources

- **ISA Spec:** `solix16&ISA.pdf`
- **Assembler Source:** `assembler/main.cpp`
- **Test Programs:** `assembler/*.asm`

---

**Last Updated:** November 2024  
**Status:** Production-ready assembler with comprehensive bug fixes
