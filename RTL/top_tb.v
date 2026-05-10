`timescale 1ns/1ns
`include "top.v"


module top_tb ();
    
    reg clk, rst;
    integer i;

    top DUT(.clk(clk), .rst(rst));

    // initial begin
    //     $monitor("inst=%h - PC=%h | x1=%d x2=%d x3=%d x4=%d x5=%d x6=%d x10=%d x12=%d| MEM[0]=%d",
    //             DUT.instruction_top,
    //             DUT.PC.PC_out, 
    //             DUT.regFile.registers[1], 
    //             DUT.regFile.registers[2],
    //             DUT.regFile.registers[3], 
    //             DUT.regFile.registers[4], 
    //             DUT.regFile.registers[5],
    //             DUT.regFile.registers[6],
    //             DUT.regFile.registers[10],
    //             DUT.regFile.registers[12],
    //             DUT.datamem_unit.D_mem[0]);
    // end


        // initialize memory from hex file at simulation start
    initial begin
        // clear memory just in case
        for (i = 0; i < 64; i = i + 1)
            DUT.inst_mem.mem[i] = 32'b0;

        // load your program hex
        $readmemh("../sw/final.hex", DUT.inst_mem.mem);
    end

    initial begin
        clk = 0;
        rst = 1;
        #5
        rst = 0;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("top_tb.vcd"); // GTK
        $dumpvars(0, top_tb);

        #1000
        $finish;
    end

    always @(posedge clk) begin
    // Only print when a register is actually being updated
    if (DUT.regFile.reg_write && !rst) begin
        $display("Time: %0t | Writing Result: %d to Register x%0d", 
                 $time, 
                 DUT.regFile.write_data, 
                 DUT.regFile.rd);
    end
    end
endmodule