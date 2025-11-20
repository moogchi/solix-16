// Solix-16 Register File
// 8 general-purpose registers (r0-r7) + 3 special registers (SP, PC, FLAGS)
// Total: 11 registers, each 16-bit

module register_file(
    input clk,                  // Clock signal
    input rst,                  // Reset signal (active high)
    
    // Read ports (dual read for ALU operations)
    input [3:0] rs_addr,        // Source register 1 address
    input [3:0] rt_addr,        // Source register 2 address
    output [15:0] rs_data,      // Source register 1 data
    output [15:0] rt_data,      // Source register 2 data
    
    // Write port
    input wr_en,                // Write enable
    input [3:0] rd_addr,        // Destination register address
    input [15:0] rd_data,       // Data to write
    
    // Special register access
    output [15:0] pc_out,       // Program counter output
    output [15:0] sp_out,       // Stack pointer output
    output [15:0] flags_out,    // Flags register output
    input pc_wr,                // PC write enable
    input sp_wr,                // SP write enable
    input flags_wr,             // FLAGS write enable
    input [15:0] pc_in,         // PC input
    input [15:0] sp_in,         // SP input
    input [15:0] flags_in       // FLAGS input
);

// Register array: 11 x 16-bit registers
reg [15:0] registers [0:10];

// Register addresses
parameter R0 = 4'd0;
parameter R1 = 4'd1;
parameter R2 = 4'd2;
parameter R3 = 4'd3;
parameter R4 = 4'd4;
parameter R5 = 4'd5;
parameter R6 = 4'd6;
parameter R7 = 4'd7;
parameter SP = 4'd8;
parameter PC = 4'd9;
parameter FLAGS = 4'd10;

// Asynchronous read (combinational)
assign rs_data = registers[rs_addr];
assign rt_data = registers[rt_addr];

// Special register outputs
assign pc_out = registers[PC];
assign sp_out = registers[SP];
assign flags_out = registers[FLAGS];

// Synchronous write with D flip-flops
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers to 0
        registers[0] <= 16'h0000;
        registers[1] <= 16'h0000;
        registers[2] <= 16'h0000;
        registers[3] <= 16'h0000;
        registers[4] <= 16'h0000;
        registers[5] <= 16'h0000;
        registers[6] <= 16'h0000;
        registers[7] <= 16'h0000;
        registers[8] <= 16'h0000;  // SP
        registers[9] <= 16'h0000;  // PC
        registers[10] <= 16'h0000; // FLAGS
    end
    else begin
        // Write to general-purpose registers
        if (wr_en && rd_addr <= 4'd7) begin
            registers[rd_addr] <= rd_data;
        end
        
        // Write to special registers (independent control)
        if (pc_wr) begin
            registers[PC] <= pc_in;
        end
        
        if (sp_wr) begin
            registers[SP] <= sp_in;
        end
        
        if (flags_wr) begin
            registers[FLAGS] <= flags_in;
        end
    end
end

endmodule
