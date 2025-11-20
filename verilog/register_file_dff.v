// Solix-16 Register File - DFF-based implementation
// Explicitly uses dff_16bit modules to show structure

module register_file_dff(
    input clk,
    input rst,
    
    // Read ports
    input [3:0] rs_addr,
    input [3:0] rt_addr,
    output reg [15:0] rs_data,
    output reg [15:0] rt_data,
    
    // Write port
    input wr_en,
    input [3:0] rd_addr,
    input [15:0] rd_data,
    
    // Special registers
    output [15:0] pc_out,
    output [15:0] sp_out,
    output [15:0] flags_out,
    input pc_wr,
    input sp_wr,
    input flags_wr,
    input [15:0] pc_in,
    input [15:0] sp_in,
    input [15:0] flags_in
);

// Internal wires for register outputs
wire [15:0] reg_out [0:10];

// Write enable signals for each register
wire [10:0] reg_wr_en;

// Generate write enables
assign reg_wr_en[0] = wr_en && (rd_addr == 4'd0);
assign reg_wr_en[1] = wr_en && (rd_addr == 4'd1);
assign reg_wr_en[2] = wr_en && (rd_addr == 4'd2);
assign reg_wr_en[3] = wr_en && (rd_addr == 4'd3);
assign reg_wr_en[4] = wr_en && (rd_addr == 4'd4);
assign reg_wr_en[5] = wr_en && (rd_addr == 4'd5);
assign reg_wr_en[6] = wr_en && (rd_addr == 4'd6);
assign reg_wr_en[7] = wr_en && (rd_addr == 4'd7);
assign reg_wr_en[8] = sp_wr;     // SP
assign reg_wr_en[9] = pc_wr;     // PC
assign reg_wr_en[10] = flags_wr; // FLAGS

// Input data selection
wire [15:0] reg_in [0:10];
assign reg_in[0] = rd_data;
assign reg_in[1] = rd_data;
assign reg_in[2] = rd_data;
assign reg_in[3] = rd_data;
assign reg_in[4] = rd_data;
assign reg_in[5] = rd_data;
assign reg_in[6] = rd_data;
assign reg_in[7] = rd_data;
assign reg_in[8] = sp_in;
assign reg_in[9] = pc_in;
assign reg_in[10] = flags_in;

// Instantiate 11 D Flip-Flop registers (8 GPR + 3 special)
genvar i;
generate
    for (i = 0; i < 11; i = i + 1) begin : reg_array
        dff_16bit_en reg_dff (
            .clk(clk),
            .rst(rst),
            .en(reg_wr_en[i]),
            .d(reg_in[i]),
            .q(reg_out[i])
        );
    end
endgenerate

// Read port multiplexers (combinational)
always @(*) begin
    case (rs_addr)
        4'd0:  rs_data = reg_out[0];
        4'd1:  rs_data = reg_out[1];
        4'd2:  rs_data = reg_out[2];
        4'd3:  rs_data = reg_out[3];
        4'd4:  rs_data = reg_out[4];
        4'd5:  rs_data = reg_out[5];
        4'd6:  rs_data = reg_out[6];
        4'd7:  rs_data = reg_out[7];
        4'd8:  rs_data = reg_out[8];  // SP
        4'd9:  rs_data = reg_out[9];  // PC
        4'd10: rs_data = reg_out[10]; // FLAGS
        default: rs_data = 16'h0000;
    endcase
end

always @(*) begin
    case (rt_addr)
        4'd0:  rt_data = reg_out[0];
        4'd1:  rt_data = reg_out[1];
        4'd2:  rt_data = reg_out[2];
        4'd3:  rt_data = reg_out[3];
        4'd4:  rt_data = reg_out[4];
        4'd5:  rt_data = reg_out[5];
        4'd6:  rt_data = reg_out[6];
        4'd7:  rt_data = reg_out[7];
        4'd8:  rt_data = reg_out[8];  // SP
        4'd9:  rt_data = reg_out[9];  // PC
        4'd10: rt_data = reg_out[10]; // FLAGS
        default: rt_data = 16'h0000;
    endcase
end

// Special register outputs
assign pc_out = reg_out[9];
assign sp_out = reg_out[8];
assign flags_out = reg_out[10];

endmodule

// 16-bit D Flip-Flop with enable
module dff_16bit_en(
    input clk,
    input rst,
    input en,           // Write enable
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 16'h0000;
    else if (en)
        q <= d;
end

endmodule
