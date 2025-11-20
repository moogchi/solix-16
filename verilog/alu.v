module alu(
    input [15:0] a,        // First operand
    input [15:0] b,        // Second operand
    input [2:0] alu_op,    // ALU operation select
    output reg [15:0] result,  // ALU result
    output reg zero,       // Z flag
    output reg negative,   // N flag
    output reg carry,      // C flag
    output reg overflow    // O flag
);

// Internal wires for arithmetic operations
wire [16:0] add_result;  // 17-bit for carry detection
wire [16:0] sub_result;  // 17-bit for borrow detection
wire [15:0] b_invert;    // 16-bit inverted b for two's complement

// Arithmetic with carry/borrow detection
assign add_result = {1'b0, a} + {1'b0, b};

assign b_invert = ~b;
assign sub_result = {1'b0, a} + {1'b0, b_invert} + 17'b1;

always @(*) begin
    // Default values
    carry = 0;
    overflow = 0;
    
    case(alu_op)
        3'b000: begin // ADD
            result = add_result[15:0];
            carry = add_result[16];  // Carry out
            // Overflow: (pos + pos = neg) or (neg + neg = pos)
            overflow = (a[15] & b[15] & ~result[15]) | (~a[15] & ~b[15] & result[15]);

        end
        
        3'b001: begin // SUB
            result = sub_result[15:0];
            carry = sub_result[16];
            // Overflow: (pos - neg = neg) or (neg - pos = pos)
            overflow = (a[15] & ~b[15] & ~result[15]) | (~a[15] & b[15] & result[15]);
        end
        
        3'b010: begin // AND
            result = a & b;
        end
        
        3'b011: begin // OR
            result = a | b;
        end
        
        3'b100: begin // XOR
            result = a ^ b;
        end
        
        3'b101: begin // NOT
            result = ~a;  // Unary operation on 'a'
        end
        
        3'b110: begin // SHL (Shift Left Logical)
            result = a << 1;
            carry = a[15];  // MSB goes to carry
        end
        
        3'b111: begin // SHR (Shift Right Logical)
            result = a >> 1;
            carry = a[0];   // LSB goes to carry
        end
        
        default: begin
            result = 16'h0000;
        end
    endcase
    
    // Flag generation (common for all ops)
    zero = (result == 16'h0000);
    negative = result[15];
end

endmodule