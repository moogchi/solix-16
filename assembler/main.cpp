#include <algorithm>
#include <bitset>
#include <cctype>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

class Solix16Assembler {
private:
  struct Instruction {
    uint8_t opcode;
    char format; // 'R', 'I', 'J', 'N' (no operands)
    uint8_t aluop;
  };

  map<string, Instruction> instructions;
  map<string, uint8_t> registers;
  map<string, uint16_t> labels;
  vector<uint16_t> machineCode;

  void initInstructions() {
    // Arithmetic & Logical (R-Type)
    instructions["ADD"] = {0b0000, 'R', 0b000};
    instructions["SUB"] = {0b0001, 'R', 0b001};
    instructions["AND"] = {0b0010, 'R', 0b010};
    instructions["OR"] = {0b0011, 'R', 0b011};
    instructions["XOR"] = {0b0100, 'R', 0b100};
    instructions["NOT"] = {0b0101, 'R', 0b101};
    instructions["SHL"] = {0b0110, 'R', 0b110};
    instructions["SHR"] = {0b0111, 'R', 0b111};

    // Data Transfer
    instructions["MOV"] = {0b1000, 'I', 0b000};
    instructions["LD"] = {0b1100, 'R', 0b000};
    instructions["ST"] = {0b1101, 'R', 0b000};

    // Control Flow (J-Type)
    instructions["JMP"] = {0b1001, 'J', 0};
    instructions["JZ"] = {0b1010, 'J', 0};
    instructions["JNZ"] = {0b1011, 'J', 0};

    // System
    instructions["HLT"] = {0b1111, 'N', 0};
  }

  void initRegisters() {
    registers["r0"] = 0;
    registers["r1"] = 1;
    registers["r2"] = 2;
    registers["r3"] = 3;
    registers["r4"] = 4;
    registers["r5"] = 5;
    registers["r6"] = 6;
    registers["r7"] = 7;
    registers["sp"] = 8;
    registers["pc"] = 9;
    registers["flags"] = 10;
  }

  string trim(const string &str) {
    size_t start = str.find_first_not_of(" \t\r\n");
    if (start == string::npos)
      return "";
    size_t end = str.find_last_not_of(" \t\r\n");
    return str.substr(start, end - start + 1);
  }

  string toUpper(string str) {
    transform(str.begin(), str.end(), str.begin(), ::toupper);
    return str;
  }

  string toLower(string str) {
    transform(str.begin(), str.end(), str.begin(), ::tolower);
    return str;
  }

  uint8_t parseRegister(const string &reg) {
    string regLower = toLower(trim(reg));
    if (registers.find(regLower) == registers.end()) {
      throw runtime_error("Invalid register: " + reg);
    }
    return registers[regLower];
  }

  uint16_t parseImmediate(const string &imm) {
    string val = trim(imm);

    if (val.empty()) {
      throw runtime_error("Empty immediate value");
    }

    int value;

    // Hex: 0x... or 0X...
    if (val.size() >= 2 &&
        (val.substr(0, 2) == "0x" || val.substr(0, 2) == "0X")) {
      if (val.size() == 2) {
        throw runtime_error("Invalid hex immediate (no digits after 0x)");
      }
      value = stoi(val.substr(2), nullptr, 16);
    }
    // Binary: 0b... or 0B...
    else if (val.size() >= 2 &&
             (val.substr(0, 2) == "0b" || val.substr(0, 2) == "0B")) {
      if (val.size() == 2) {
        throw runtime_error("Invalid binary immediate (no digits after 0b)");
      }
      value = stoi(val.substr(2), nullptr, 2);
    }
    // Decimal
    else {
      value = stoi(val);
    }

    return static_cast<uint16_t>(value);
  }

  uint16_t encodeRType(uint8_t opcode, uint8_t rd, uint8_t rs, uint8_t rt) {
    return ((opcode & 0xF) << 12) | ((rd & 0xF) << 8) | ((rs & 0xF) << 4) |
           (rt & 0xF);
  }

  uint16_t encodeIType(uint8_t opcode, uint8_t rd, uint8_t imm) {
    // imm is already validated to be <= 255 by caller
    return ((opcode & 0xF) << 12) | ((rd & 0xF) << 8) | (imm & 0xFF);
  }

  uint16_t encodeJType(uint8_t opcode, uint16_t address) {
    if (address > 4095) {
      throw runtime_error("Jump address out of range (0-4095): " +
                          to_string(address));
    }
    return ((opcode & 0xF) << 12) | (address & 0xFFF);
  }

  vector<string> split(const string &str, char delimiter) {
    vector<string> tokens;
    stringstream ss(str);
    string token;
    while (getline(ss, token, delimiter)) {
      token = trim(token);
      if (!token.empty()) {
        tokens.push_back(token);
      }
    }
    return tokens;
  }

  void firstPass(const vector<string> &lines) {
    uint16_t address = 0;

    for (const auto &line : lines) {
      string cleaned = line;

      // Remove comments
      size_t commentPos = cleaned.find(';');
      if (commentPos != string::npos) {
        cleaned = cleaned.substr(0, commentPos);
      }

      cleaned = trim(cleaned);
      if (cleaned.empty())
        continue;

      // Check for label
      size_t colonPos = cleaned.find(':');
      if (colonPos != string::npos) {
        string label = toUpper(trim(cleaned.substr(0, colonPos)));
        labels[label] = address;

        // Check if there's an instruction after the label
        cleaned = trim(cleaned.substr(colonPos + 1));
        if (cleaned.empty())
          continue;
      }

      // This line has an instruction
      address++;
    }
  }

  uint16_t assembleInstruction(const string &line, uint16_t currentAddress) {
    string cleaned = line;

    // Remove comments
    size_t commentPos = cleaned.find(';');
    if (commentPos != string::npos) {
      cleaned = cleaned.substr(0, commentPos);
    }

    // Remove label if present
    size_t colonPos = cleaned.find(':');
    if (colonPos != string::npos) {
      cleaned = trim(cleaned.substr(colonPos + 1));
    }

    cleaned = trim(cleaned);
    if (cleaned.empty()) {
      throw runtime_error("Empty instruction");
    }

    // Split instruction and operands
    vector<string> parts = split(cleaned, ' ');
    if (parts.empty()) {
      throw runtime_error("Invalid instruction format");
    }

    string mnemonic = toUpper(parts[0]);

    if (instructions.find(mnemonic) == instructions.end()) {
      throw runtime_error("Unknown instruction: " + mnemonic);
    }

    Instruction instr = instructions[mnemonic];

    // Parse operands
    vector<string> operands;
    if (parts.size() > 1) {
      string operandStr = "";
      for (size_t i = 1; i < parts.size(); i++) {
        if (i > 1)
          operandStr += " ";
        operandStr += parts[i];
      }
      operands = split(operandStr, ',');
    }

    // Encode based on format
    switch (instr.format) {
    case 'R': {
      if (mnemonic == "LD") {
        // LD Rd, Rs
        if (operands.size() != 2) {
          throw runtime_error("LD requires 2 operands");
        }
        uint8_t rd = parseRegister(operands[0]);
        uint8_t rs = parseRegister(operands[1]);
        return encodeRType(instr.opcode, rd, rs, 0);
      } else if (mnemonic == "ST") {
        // ST Rs, Rt (address in Rs, data in Rt)
        // Encoding: [opcode | 0000 | Rs | Rt] - Rd must be 0
        if (operands.size() != 2) {
          throw runtime_error("ST requires 2 operands");
        }
        uint8_t rs = parseRegister(operands[0]);
        uint8_t rt = parseRegister(operands[1]);
        return encodeRType(instr.opcode, 0, rs, rt);
      } else if (mnemonic == "NOT" || mnemonic == "SHL" || mnemonic == "SHR") {
        // Unary: OP Rd, Rs
        if (operands.size() != 2) {
          throw runtime_error(mnemonic + " requires 2 operands");
        }
        uint8_t rd = parseRegister(operands[0]);
        uint8_t rs = parseRegister(operands[1]);
        return encodeRType(instr.opcode, rd, rs, 0);
      } else {
        // Binary: OP Rd, Rs, Rt
        if (operands.size() != 3) {
          throw runtime_error(mnemonic + " requires 3 operands");
        }
        uint8_t rd = parseRegister(operands[0]);
        uint8_t rs = parseRegister(operands[1]);
        uint8_t rt = parseRegister(operands[2]);
        return encodeRType(instr.opcode, rd, rs, rt);
      }
    }

    case 'I': {
      // MOV Rd, Immediate
      if (operands.size() != 2) {
        throw runtime_error("MOV requires 2 operands");
      }
      uint8_t rd = parseRegister(operands[0]);
      uint16_t imm16 = parseImmediate(operands[1]);
      if (imm16 > 255) {
        throw runtime_error("Immediate value out of range (0-255): " +
                            to_string(imm16));
      }
      uint8_t imm = static_cast<uint8_t>(imm16);
      return encodeIType(instr.opcode, rd, imm);
    }

    case 'J': {
      // JMP/JZ/JNZ Address (label or immediate)
      if (operands.size() != 1) {
        throw runtime_error(mnemonic + " requires 1 operand");
      }

      uint16_t address;
      // Check if it's a label (normalize to uppercase)
      string target = toUpper(trim(operands[0]));
      if (labels.find(target) != labels.end()) {
        address = labels[target];
      } else {
        address = parseImmediate(operands[0]);
      }

      return encodeJType(instr.opcode, address);
    }

    case 'N': {
      // HLT - no operands
      return (instr.opcode & 0xF) << 12;
    }

    default:
      throw runtime_error("Unknown instruction format");
    }
  }

public:
  Solix16Assembler() {
    initInstructions();
    initRegisters();
  }

  void assemble(const string &inputFile, const string &outputFile) {
    // Read input file
    ifstream inFile(inputFile);
    if (!inFile) {
      throw runtime_error("Cannot open input file: " + inputFile);
    }

    vector<string> lines;
    string line;
    while (getline(inFile, line)) {
      lines.push_back(line);
    }
    inFile.close();

    // First pass: extract labels
    firstPass(lines);

    // Second pass: assemble instructions
    uint16_t address = 0;
    for (size_t lineNum = 0; lineNum < lines.size(); lineNum++) {
      string cleaned = lines[lineNum];

      // Remove comments
      size_t commentPos = cleaned.find(';');
      if (commentPos != string::npos) {
        cleaned = cleaned.substr(0, commentPos);
      }

      // Remove label if present
      size_t colonPos = cleaned.find(':');
      if (colonPos != string::npos) {
        cleaned = trim(cleaned.substr(colonPos + 1));
      }

      cleaned = trim(cleaned);
      if (cleaned.empty())
        continue;

      try {
        uint16_t machineInstr = assembleInstruction(cleaned, address);
        machineCode.push_back(machineInstr);
        address++;
      } catch (const exception &e) {
        cerr << "Error on line " << (lineNum + 1) << ": " << e.what() << endl;
        cerr << "Line: " << lines[lineNum] << endl;
        throw;
      }
    }

    // Write output
    writeOutput(outputFile);
  }

  void writeOutput(const string &outputFile) {
    ofstream outFile(outputFile);
    if (!outFile) {
      throw runtime_error("Cannot open output file: " + outputFile);
    }

    outFile << "v2.0 raw" << endl; // Logisim format

    for (size_t i = 0; i < machineCode.size(); i++) {
      outFile << hex << setw(4) << setfill('0') << machineCode[i];
      if ((i + 1) % 8 == 0) {
        outFile << endl;
      } else {
        outFile << " ";
      }
    }
    outFile << endl;

    outFile.close();

    cout << "Assembly successful!" << endl;
    cout << "Generated " << dec << machineCode.size() << " instructions"
         << endl;
  }

  void printMachineCode() {
    cout << "\n=== Machine Code ===" << endl;
    for (size_t i = 0; i < machineCode.size(); i++) {
      cout << "0x" << hex << setw(3) << setfill('0') << i << ": ";
      cout << "0x" << setw(4) << setfill('0') << machineCode[i];
      cout << " (" << bitset<16>(machineCode[i]) << ")" << endl;
    }
  }
};

int main(int argc, char *argv[]) {
  if (argc < 2) {
    cout << "Usage: " << argv[0] << " <input.asm> [output.hex]" << endl;
    cout << "Example: " << argv[0] << " program.asm program.hex" << endl;
    return 1;
  }

  string inputFile = argv[1];
  string outputFile = argc >= 3 ? argv[2] : "output.hex";

  try {
    Solix16Assembler assembler;
    assembler.assemble(inputFile, outputFile);
    assembler.printMachineCode();
  } catch (const exception &e) {
    cerr << "Assembly failed: " << e.what() << endl;
    return 1;
  }

  return 0;
}