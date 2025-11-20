`timescale 1ns / 1ps

module alu_tb;

// Testbench signals
reg [15:0] a;
reg [15:0] b;
reg [2:0] alu_op;
wire [15:0] result;
wire zero, negative, carry, overflow;

// Instantiate the ALU
alu uut (
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .result(result),
    .zero(zero),
    .negative(negative),
    .carry(carry),
    .overflow(overflow)
);

// Test counter
integer test_num = 0;
integer errors = 0;

// Task to display test results
task display_result;
    input [15:0] expected_result;
    input expected_z, expected_n, expected_c, expected_o;
    input [80*8:1] test_name;
    begin
        test_num = test_num + 1;
        $display("Test %0d: %s", test_num, test_name);
        $display("  A=%h, B=%h, ALUOp=%b", a, b, alu_op);
        $display("  Result=%h (expected %h) %s", 
                 result, expected_result, 
                 (result == expected_result) ? "✓" : "✗ FAIL");
        $display("  Flags: Z=%b N=%b C=%b O=%b", zero, negative, carry, overflow);
        $display("  Expected: Z=%b N=%b C=%b O=%b", 
                 expected_z, expected_n, expected_c, expected_o);
        
        if (result != expected_result || zero != expected_z || 
            negative != expected_n || carry != expected_c || overflow != expected_o) begin
            $display("  ❌ TEST FAILED!");
            errors = errors + 1;
        end else begin
            $display("  ✅ PASS");
        end
        $display("");
    end
endtask

initial begin
    $display("========================================");
    $display("  Solix-16 ALU Testbench");
    $display("========================================\n");
    
    // ==========================================
    // Test 1: ADD - Basic Addition
    // ==========================================
    a = 16'd15; b = 16'd10; alu_op = 3'b000;
    #10;
    display_result(16'd25, 0, 0, 0, 0, "ADD: 15 + 10 = 25");
    
    // ==========================================
    // Test 2: ADD - Result is Zero
    // ==========================================
    a = 16'd0; b = 16'd0; alu_op = 3'b000;
    #10;
    display_result(16'd0, 1, 0, 0, 0, "ADD: 0 + 0 = 0 (Zero flag)");
    
    // ==========================================
    // Test 3: ADD - Carry Flag
    // ==========================================
    a = 16'hFFFF; b = 16'h0001; alu_op = 3'b000;
    #10;
    display_result(16'h0000, 1, 0, 1, 0, "ADD: 0xFFFF + 1 = 0 (Carry)");
    
    // ==========================================
    // Test 4: ADD - Overflow (Pos + Pos = Neg)
    // ==========================================
    a = 16'h7FFF; b = 16'h0001; alu_op = 3'b000;  // 32767 + 1
    #10;
    display_result(16'h8000, 0, 1, 0, 1, "ADD: 32767 + 1 = -32768 (Overflow)");
    
    // ==========================================
    // Test 5: ADD - Overflow (Neg + Neg = Pos)
    // ==========================================
    a = 16'h8000; b = 16'hFFFF; alu_op = 3'b000;  // -32768 + (-1)
    #10;
    display_result(16'h7FFF, 0, 0, 1, 1, "ADD: -32768 + (-1) (Overflow)");
    
    // ==========================================
    // Test 6: SUB - Basic Subtraction
    // ==========================================
    a = 16'd25; b = 16'd10; alu_op = 3'b001;
    #10;
    display_result(16'd15, 0, 0, 1, 0, "SUB: 25 - 10 = 15");
    
    // ==========================================
    // Test 7: SUB - Result is Zero
    // ==========================================
    a = 16'd42; b = 16'd42; alu_op = 3'b001;
    #10;
    display_result(16'd0, 1, 0, 1, 0, "SUB: 42 - 42 = 0 (Zero flag)");
    
    // ==========================================
    // Test 8: SUB - Negative Result
    // ==========================================
    a = 16'd10; b = 16'd20; alu_op = 3'b001;
    #10;
    display_result(16'hFFF6, 0, 1, 0, 0, "SUB: 10 - 20 = -10 (Negative)");
    
    // ==========================================
    // Test 9: SUB - Overflow (Pos - Neg = Neg)
    // ==========================================
    a = 16'h7FFF; b = 16'hFFFF; alu_op = 3'b001;  // 32767 - (-1)
    #10;
    display_result(16'h8000, 0, 1, 0, 1, "SUB: 32767 - (-1) (Overflow)");
    
    // ==========================================
    // Test 10: AND - Bitwise AND
    // ==========================================
    a = 16'hAAAA; b = 16'h5555; alu_op = 3'b010;
    #10;
    display_result(16'h0000, 1, 0, 0, 0, "AND: 0xAAAA & 0x5555 = 0");
    
    // ==========================================
    // Test 11: AND - Masking
    // ==========================================
    a = 16'hABCD; b = 16'h00FF; alu_op = 3'b010;
    #10;
    display_result(16'h00CD, 0, 0, 0, 0, "AND: 0xABCD & 0x00FF = 0x00CD");
    
    // ==========================================
    // Test 12: OR - Bitwise OR
    // ==========================================
    a = 16'hAAAA; b = 16'h5555; alu_op = 3'b011;
    #10;
    display_result(16'hFFFF, 0, 1, 0, 0, "OR: 0xAAAA | 0x5555 = 0xFFFF");
    
    // ==========================================
    // Test 13: OR - Simple OR
    // ==========================================
    a = 16'h0F00; b = 16'h00F0; alu_op = 3'b011;
    #10;
    display_result(16'h0FF0, 0, 0, 0, 0, "OR: 0x0F00 | 0x00F0 = 0x0FF0");
    
    // ==========================================
    // Test 14: XOR - Toggle bits
    // ==========================================
    a = 16'hAAAA; b = 16'hFFFF; alu_op = 3'b100;
    #10;
    display_result(16'h5555, 0, 0, 0, 0, "XOR: 0xAAAA ^ 0xFFFF = 0x5555");
    
    // ==========================================
    // Test 15: XOR - Same values = 0
    // ==========================================
    a = 16'h1234; b = 16'h1234; alu_op = 3'b100;
    #10;
    display_result(16'h0000, 1, 0, 0, 0, "XOR: 0x1234 ^ 0x1234 = 0");
    
    // ==========================================
    // Test 16: NOT - Bitwise inversion
    // ==========================================
    a = 16'hAAAA; b = 16'h0000; alu_op = 3'b101;
    #10;
    display_result(16'h5555, 0, 0, 0, 0, "NOT: ~0xAAAA = 0x5555");
    
    // ==========================================
    // Test 17: NOT - All zeros
    // ==========================================
    a = 16'hFFFF; b = 16'h0000; alu_op = 3'b101;
    #10;
    display_result(16'h0000, 1, 0, 0, 0, "NOT: ~0xFFFF = 0x0000");
    
    // ==========================================
    // Test 18: SHL - Shift Left
    // ==========================================
    a = 16'h0001; b = 16'h0000; alu_op = 3'b110;
    #10;
    display_result(16'h0002, 0, 0, 0, 0, "SHL: 0x0001 << 1 = 0x0002");
    
    // ==========================================
    // Test 19: SHL - Carry out MSB
    // ==========================================
    a = 16'h8000; b = 16'h0000; alu_op = 3'b110;
    #10;
    display_result(16'h0000, 1, 0, 1, 0, "SHL: 0x8000 << 1 (Carry from MSB)");
    
    // ==========================================
    // Test 20: SHL - Middle bits
    // ==========================================
    a = 16'h00FF; b = 16'h0000; alu_op = 3'b110;
    #10;
    display_result(16'h01FE, 0, 0, 0, 0, "SHL: 0x00FF << 1 = 0x01FE");
    
    // ==========================================
    // Test 21: SHR - Shift Right
    // ==========================================
    a = 16'h0002; b = 16'h0000; alu_op = 3'b111;
    #10;
    display_result(16'h0001, 0, 0, 0, 0, "SHR: 0x0002 >> 1 = 0x0001");
    
    // ==========================================
    // Test 22: SHR - Carry out LSB
    // ==========================================
    a = 16'h0001; b = 16'h0000; alu_op = 3'b111;
    #10;
    display_result(16'h0000, 1, 0, 1, 0, "SHR: 0x0001 >> 1 (Carry from LSB)");
    
    // ==========================================
    // Test 23: SHR - Large value
    // ==========================================
    a = 16'hFF00; b = 16'h0000; alu_op = 3'b111;
    #10;
    display_result(16'h7F80, 0, 0, 0, 0, "SHR: 0xFF00 >> 1 = 0x7F80");
    
    // ==========================================
    // Summary
    // ==========================================
    $display("\n========================================");
    $display("  Test Summary");
    $display("========================================");
    $display("  Total Tests: %0d", test_num);
    $display("  Passed: %0d", test_num - errors);
    $display("  Failed: %0d", errors);
    
    if (errors == 0) begin
        $display("\n  🎉 ALL TESTS PASSED! 🎉");
    end else begin
        $display("\n  ❌ SOME TESTS FAILED");
    end
    $display("========================================\n");
    
    $finish;
end

endmodule