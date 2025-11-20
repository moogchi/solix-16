// Basic D Flip-Flop for Solix-16
// Positive edge-triggered with asynchronous reset

module dff(
    input clk,          // Clock
    input rst,          // Asynchronous reset (active high)
    input d,            // Data input
    output reg q        // Data output
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end

endmodule

// 16-bit D Flip-Flop register
module dff_16bit(
    input clk,
    input rst,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 16'h0000;
    else
        q <= d;
end

endmodule
