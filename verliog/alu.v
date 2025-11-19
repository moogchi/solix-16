module alu(
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  ALUOp,
    output reg [15:0] Result,
    output Zero,
    output Negative,
    output Carry,
    output Overflow
);

    wire [15:0] add_sub = (ALUOp == 3'b001) ? (A - B) : (A + B);
    wire [15:0] logic_and = A & B;
    wire [15:0] logic_or  = A | B;
    wire [15:0] logic_xor = A ^ B;
    wire [15:0] logic_not = ~A;
    wire [15:0] shl = A << 1;
    wire [15:0] shr = A >> 1;

    always @(*) begin
        case (ALUOp)
            3'b000: Result = add_sub;   // ADD or PASS
            3'b001: Result = add_sub;   // SUB
            3'b010: Result = logic_and;
            3'b011: Result = logic_or;
            3'b100: Result = logic_xor;
            3'b101: Result = logic_not;
            3'b110: Result = shl;
            3'b111: Result = shr;
        endcase
    end

    assign Zero = (Result == 16'h0000);
    assign Negative = Result[15];

    assign Carry = (ALUOp == 3'b000) ? // ADD
                    (A + B > 16'hFFFF) :
                   (ALUOp == 3'b001) ? // SUB borrow
                    (A < B) :
                   (ALUOp == 3'b110) ? A[15] : 
                   (ALUOp == 3'b111) ? A[0] : 1'b0;

    assign Overflow = 
        (ALUOp == 3'b000) ? ((A[15] == B[15]) && (Result[15] != A[15])) :
        (ALUOp == 3'b001) ? ((A[15] != B[15]) && (Result[15] != A[15])) :
        1'b0;

endmodule
