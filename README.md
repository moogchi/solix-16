# Solix-16 CPU Architecture

A complete 16-bit educational CPU with a custom assembler and Verilog hardware implementation.

## Overview

**Solix-16** is a 16-bit RISC-style architecture featuring:

- 16-bit data and address bus (64KB addressable memory)
- 11 registers: 8 general-purpose (r0–r7) + SP, PC, FLAGS
- Three instruction formats: R-type, I-type, J-type
- Simple load/store architecture
- Conditional branching (JZ, JNZ)
- 8 ALU operations with full flag support

### Instruction Set

| Category | Instructions |
|---|---|
| Arithmetic & Logic | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR` |
| Data Transfer | `MOV` (immediate), `LD`, `ST` |
| Control Flow | `JMP`, `JZ`, `JNZ` |
| System | `HLT` |

See `solix16.pdf` for the complete ISA specification.

---

## Assembler

A two-pass assembler written in C++ that generates Logisim-compatible machine code.

### Features

- Complete instruction set support
- Two-pass assembly with full label resolution
- Case-insensitive labels and mnemonics
- Flexible operand spacing (`r1,r2,r3` or `r1 , r2 , r3`)
- Multiple number formats: decimal (`42`), hex (`0xFF`), binary (`0b1010`)
- Detailed error messages with line numbers

### Build & Usage

```bash
cd assembler
g++ -std=c++11 -Wall -o solix16asm main.cpp
./solix16asm input.asm output.hex
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
8100 8205 0112 1221 b001 f000
```

---

## Verilog Hardware Implementation

### ALU (Arithmetic Logic Unit)

Complete 16-bit ALU with testbench.

| `alu_op` | Operation | Description |
|----------|-----------|-------------|
| `3'b000` | ADD | `a + b` (with carry) |
| `3'b001` | SUB | `a - b` (with borrow) |
| `3'b010` | AND | `a & b` |
| `3'b011` | OR  | `a \| b` |
| `3'b100` | XOR | `a ^ b` |
| `3'b101` | NOT | `~a` |
| `3'b110` | SHL | `a << 1` (carry = MSB) |
| `3'b111` | SHR | `a >> 1` (carry = LSB) |

**Status flags:** Zero (Z), Negative (N), Carry (C), Overflow (O)

### Register File

16-bit register file with 11 registers built from D flip-flops.

- 8 general-purpose registers (r0–r7) at addresses `4'h0`–`4'h7`
- SP at `4'h8`, PC at `4'h9`, FLAGS at `4'hA`
- Dual read ports (asynchronous), single write port (synchronous)
- Asynchronous active-high reset

Two implementation variants are provided: `register_file.v` (compact array-based) and `register_file_dff.v` (explicit DFF instantiation).

### Simulation

```bash
cd verilog

# ALU
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim

# Register File
iverilog -o regfile_sim register_file.v register_file_tb.v
vvp regfile_sim

# View waveforms
gtkwave alu.vcd
gtkwave register_file.vcd
```

---

## Bug Fix Log (November 2024)

### Round 1 — Nov 18

1. **ST instruction encoding** — Was encoding `Rd=Rs` instead of `Rd=0`; now correctly outputs `[opcode | 0000 | Rs | Rt]`.
2. **Operand parsing** — Multi-operand instructions failed because operands were concatenated without delimiters; fixed by preserving spaces during reassembly.
3. **Label case sensitivity** — Labels kept original case while mnemonics were uppercased, causing lookup mismatches; all labels now normalized to uppercase.
4. **Immediate parsing safety** — No length validation before prefix detection (`0x`, `0b`); added bounds checking.
5. **HLT encoding** — Simplified from unnecessary R-type encoding to clean `opcode << 12`.

### Round 2 — Nov 19

6. **Ignored `cleaned` variable in second pass** *(most critical)* — Second pass used the raw line instead of the comment/label-stripped version, breaking any line with comments or labels.
7. **Silent immediate truncation** — `parseImmediate()` returned `uint16_t` but was cast to `uint8_t` before range checking; `MOV r1, 300` now correctly errors instead of silently truncating.
8. **Redundant range check** — Removed unreachable `if (imm > 255)` check on a `uint8_t` value; validation now happens at the call site.

**Verification:**

```
ST r2, r1 → 0xD021 = 1101 0000 0010 0001 → ST Rd=0 Rs=2 Rt=1 ✓
MOV r1, 300 → Error: Immediate value out of range (0-255): 300 ✓
```

---

## Project Structure

```
solix-16/
├── solix16.pdf              # ISA specification
├── README.md
├── assembler/
│   ├── main.cpp             # Assembler source
│   ├── solix16asm           # Compiled assembler
│   └── *.asm                # Test programs
└── verilog/
    ├── alu.v                # ALU module
    ├── alu_tb.v             # ALU testbench
    ├── register_file.v      # Register file (array-based)
    ├── register_file_dff.v  # Register file (explicit DFF)
    ├── register_file_tb.v   # Register file testbench
    └── dff.v                # D flip-flop building blocks
```

---

## Contributing

**Assembler:** Maintain the two-pass architecture, keep error messages informative with line numbers, test edge cases (spacing, case mixing, number formats), and verify encoding against the ISA spec.

**Verilog:** Keep modules modular and well-commented, write comprehensive testbenches, verify timing/combinational logic, and test edge cases (overflow, carry, zero flags, reset behavior).

---

**Last Updated:** November 2024
**Status:** ✅ Production-ready assembler · ✅ Working ALU · ✅ Working register file
**Next Steps:** Control unit, memory interface, instruction decoder
