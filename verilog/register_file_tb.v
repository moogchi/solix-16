// Testbench for Solix-16 Register File
`timescale 1ns/1ps

module register_file_tb;

// Clock and reset
reg clk;
reg rst;

// Read ports
reg [3:0] rs_addr;
reg [3:0] rt_addr;
wire [15:0] rs_data;
wire [15:0] rt_data;

// Write port
reg wr_en;
reg [3:0] rd_addr;
reg [15:0] rd_data;

// Special registers
wire [15:0] pc_out;
wire [15:0] sp_out;
wire [15:0] flags_out;
reg pc_wr;
reg sp_wr;
reg flags_wr;
reg [15:0] pc_in;
reg [15:0] sp_in;
reg [15:0] flags_in;

// Instantiate register file
register_file uut (
    .clk(clk),
    .rst(rst),
    .rs_addr(rs_addr),
    .rt_addr(rt_addr),
    .rs_data(rs_data),
    .rt_data(rt_data),
    .wr_en(wr_en),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .pc_out(pc_out),
    .sp_out(sp_out),
    .flags_out(flags_out),
    .pc_wr(pc_wr),
    .sp_wr(sp_wr),
    .flags_wr(flags_wr),
    .pc_in(pc_in),
    .sp_in(sp_in),
    .flags_in(flags_in)
);

// Clock generation (10ns period = 100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test sequence
initial begin
    $display("=== Solix-16 Register File Testbench ===\n");
    
    // Initialize signals
    rst = 1;
    wr_en = 0;
    rd_addr = 0;
    rd_data = 0;
    rs_addr = 0;
    rt_addr = 0;
    pc_wr = 0;
    sp_wr = 0;
    flags_wr = 0;
    pc_in = 0;
    sp_in = 0;
    flags_in = 0;
    
    // Wait for reset
    #10;
    rst = 0;
    #10;
    
    $display("Test 1: Reset verification");
    $display("  All registers should be 0");
    rs_addr = 4'd0; #1;
    if (rs_data == 16'h0000) $display("  r0 = 0x%04h ✓", rs_data);
    else $display("  r0 = 0x%04h ✗ (expected 0x0000)", rs_data);
    
    rs_addr = 4'd7; #1;
    if (rs_data == 16'h0000) $display("  r7 = 0x%04h ✓", rs_data);
    else $display("  r7 = 0x%04h ✗ (expected 0x0000)", rs_data);
    
    if (pc_out == 16'h0000 && sp_out == 16'h0000 && flags_out == 16'h0000)
        $display("  PC, SP, FLAGS = 0 ✓\n");
    else
        $display("  Special registers not zero ✗\n");
    
    // Test 2: Write to general-purpose registers
    $display("Test 2: Writing to general-purpose registers");
    @(posedge clk);
    wr_en = 1;
    rd_addr = 4'd1;
    rd_data = 16'h1234;
    @(posedge clk);
    wr_en = 0;
    #1;
    rs_addr = 4'd1;
    #1;
    if (rs_data == 16'h1234) $display("  r1 = 0x%04h ✓", rs_data);
    else $display("  r1 = 0x%04h ✗ (expected 0x1234)", rs_data);
    
    @(posedge clk);
    wr_en = 1;
    rd_addr = 4'd3;
    rd_data = 16'hABCD;
    @(posedge clk);
    wr_en = 0;
    #1;
    rs_addr = 4'd3;
    #1;
    if (rs_data == 16'hABCD) $display("  r3 = 0x%04h ✓\n", rs_data);
    else $display("  r3 = 0x%04h ✗ (expected 0xABCD)\n", rs_data);
    
    // Test 3: Dual read ports
    $display("Test 3: Simultaneous dual read");
    rs_addr = 4'd1;
    rt_addr = 4'd3;
    #1;
    if (rs_data == 16'h1234 && rt_data == 16'hABCD)
        $display("  rs=0x%04h, rt=0x%04h ✓\n", rs_data, rt_data);
    else
        $display("  rs=0x%04h, rt=0x%04h ✗\n", rs_data, rt_data);
    
    // Test 4: Write all registers
    $display("Test 4: Writing to all general-purpose registers");
    wr_en = 1;
    for (integer i = 0; i < 8; i = i + 1) begin
        @(posedge clk);
        rd_addr = i;
        rd_data = 16'h0100 + i;
    end
    @(posedge clk);
    wr_en = 0;
    
    // Verify all writes
    for (integer i = 0; i < 8; i = i + 1) begin
        rs_addr = i;
        #1;
        if (rs_data == (16'h0100 + i))
            $display("  r%0d = 0x%04h ✓", i, rs_data);
        else
            $display("  r%0d = 0x%04h ✗ (expected 0x%04h)", i, rs_data, 16'h0100 + i);
    end
    $display("");
    
    // Test 5: PC write
    $display("Test 5: Program Counter (PC) operations");
    @(posedge clk);
    pc_wr = 1;
    pc_in = 16'h0100;
    @(posedge clk);
    pc_wr = 0;
    #1;
    if (pc_out == 16'h0100) $display("  PC = 0x%04h ✓", pc_out);
    else $display("  PC = 0x%04h ✗ (expected 0x0100)", pc_out);
    
    // Increment PC
    @(posedge clk);
    pc_wr = 1;
    pc_in = pc_out + 1;
    @(posedge clk);
    pc_wr = 0;
    #1;
    if (pc_out == 16'h0101) $display("  PC++ = 0x%04h ✓\n", pc_out);
    else $display("  PC++ = 0x%04h ✗ (expected 0x0101)\n", pc_out);
    
    // Test 6: SP write
    $display("Test 6: Stack Pointer (SP) operations");
    @(posedge clk);
    sp_wr = 1;
    sp_in = 16'hFFFF;
    @(posedge clk);
    sp_wr = 0;
    #1;
    if (sp_out == 16'hFFFF) $display("  SP = 0x%04h ✓", sp_out);
    else $display("  SP = 0x%04h ✗ (expected 0xFFFF)", sp_out);
    
    // Decrement SP (stack grows down)
    @(posedge clk);
    sp_wr = 1;
    sp_in = sp_out - 1;
    @(posedge clk);
    sp_wr = 0;
    #1;
    if (sp_out == 16'hFFFE) $display("  SP-- = 0x%04h ✓\n", sp_out);
    else $display("  SP-- = 0x%04h ✗ (expected 0xFFFE)\n", sp_out);
    
    // Test 7: FLAGS write
    $display("Test 7: Flags register operations");
    @(posedge clk);
    flags_wr = 1;
    flags_in = 16'h000F;  // Z=1, N=1, C=1, O=1
    @(posedge clk);
    flags_wr = 0;
    #1;
    if (flags_out == 16'h000F) $display("  FLAGS = 0x%04h ✓\n", flags_out);
    else $display("  FLAGS = 0x%04h ✗ (expected 0x000F)\n", flags_out);
    
    // Test 8: Simultaneous operations
    $display("Test 8: Simultaneous write and read");
    @(posedge clk);
    wr_en = 1;
    rd_addr = 4'd5;
    rd_data = 16'h5555;
    rs_addr = 4'd3;
    rt_addr = 4'd5;  // Read old value
    #1;
    if (rt_data != 16'h5555)
        $display("  Read before write: rt=0x%04h ✓", rt_data);
    else
        $display("  Read before write: rt=0x%04h (unexpected)", rt_data);
    
    @(posedge clk);
    wr_en = 0;
    #1;
    rt_addr = 4'd5;
    #1;
    if (rt_data == 16'h5555)
        $display("  Read after write: rt=0x%04h ✓\n", rt_data);
    else
        $display("  Read after write: rt=0x%04h ✗\n", rt_data);
    
    // Test 9: Reset during operation
    $display("Test 9: Reset during operation");
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    rst = 0;
    #1;
    rs_addr = 4'd1;
    rt_addr = 4'd3;
    #1;
    if (rs_data == 16'h0000 && rt_data == 16'h0000 && 
        pc_out == 16'h0000 && sp_out == 16'h0000)
        $display("  All registers cleared ✓\n");
    else
        $display("  Reset failed ✗\n");
    
    $display("===========================================");
    $display("All tests completed!");
    $display("===========================================\n");
    
    #50;
    $finish;
end

// Optional: Dump waveform
initial begin
    $dumpfile("register_file.vcd");
    $dumpvars(0, register_file_tb);
end

endmodule
