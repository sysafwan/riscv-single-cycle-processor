`include "ALU_control.v"
`include "ALU_unit.v"
`include "branch_adder.v"
`include "control_unit.v"
`include "data_mem.v"
`include "gatelogic.v"
`include "ImmGen.v"
`include "instruction_mem.v"
`include "mux.v"
`include "PC_inc.v"
`include "program_counter.v"
`include "reg_file.v"

module top (
    input clk, rst
);

    wire [31:0] JAL_mux_out_top, PC_next_mux_out, PC_top, PC_plused_top, PC_addr_mux_out_top, instruction_top, RD1_top, RD2_top, ImmExt_top, ALU_mux_out_top, adder2_out_top, ALU_out_top, data_mem_read_out_top, data_mem_mux_out_top, mux_out_write_data, pc_sel_mux_out;
    wire JALr_en_top, JAL_en_top, AUIPC_en_top, RegWrite_top, ALUSrc_top, Branch_top, zero_top, and_out_top, MemtoReg_top, MemRead_top, MemWrite_top, LUI_en_top;
    wire [1:0] ALUOp_top;
    wire [3:0] ALU_ctrl_top;

    //pc
    program_counter PC(
        .clk(clk), .rst(rst),
        .PC_in(PC_next_mux_out),
        .PC_out(PC_top)
    );

    //pc_adder
    PC_inc PC_adder(
        .fromPC(PC_top),
        .toPC(PC_plused_top)
    );

    //mux to sel between pc+4 and JAL
    mux pc_sel_mux_J(
        .sel(JAL_en_top),
        .A(PC_addr_mux_out_top), .B(ALU_out_top),
        .mux_out(JAL_mux_out_top)
    );

    //mux to sel between JAL and JALr
    mux pc_sel_mux_Jr(
        .sel(JALr_en_top),
        .A(JAL_mux_out_top), .B(ALU_out_top),
        .mux_out(PC_next_mux_out)
    );

    //instruction memeory
    instruction_mem inst_mem(
        .clk(clk), .rst(rst),
        .read_address(PC_top),
        .instruction_out(instruction_top) 
    );

    //control unit
    control_unit ctrl_unit(
        .opcode(instruction_top[6:0]),
        .JALr_en(JALr_en_top), .AUIPC_en(AUIPC_en_top), .JAL_en(JAL_en_top), .LUI_en(LUI_en_top), .Branch(Branch_top), .MemRead(MemRead_top), .MemtoReg(MemtoReg_top), .ALUOp(ALUOp_top), .MemWrite(MemWrite_top), .ALUSrc(ALUsrc_top), .RegWrite(RegWrite_top)
    );

    //register file
    reg_file regFile(
        .clk(clk), .rst(rst), .reg_write(RegWrite_top),
        .rs1(instruction_top[19:15]), .rs2(instruction_top[24:20]), .rd(instruction_top[11:7]),
        .write_data(mux_out_write_data), 
        .read_data_1(RD1_top), .read_data_2(RD2_top)
    );

    //Immediate Generator
    ImmGen Imm(
        .opcode(instruction_top[6:0]),
        .instruction(instruction_top),
        .ImmExt(ImmExt_top)
    );

    //mux to select pc vs rd1 for AUIPC U-type
    mux pc_sel_mux_U(
        .sel(AUIPC_en_top),
        .A(RD1_top), .B(PC_top),
        .mux_out(pc_sel_mux_out)
    );

    //ALU control
    ALU_control ALUctrl(
        .ALUOp(ALUOp_top),
        .fun7(instruction_top[30]),
        .fun3(instruction_top[14:12]),
        .control_out(ALU_ctrl_top)
    );

    //ALU unit
    ALU_unit ALU(
        .A(pc_sel_mux_out), .B(ALU_mux_out_top),
        .control_in(ALU_ctrl_top),
        .zero(zero_top),
        .ALU_out(ALU_out_top)
    );
    
    //ALU_mux
    mux ALU_mux(
        .sel(ALUsrc_top),
        .A(RD2_top), .B(ImmExt_top),
        .mux_out(ALU_mux_out_top)
    );

    //Address adder logic - Branch Adder
    Branch_adder BranchAdd(
        .plus4_addr(PC_top), .ImmAddr(ImmExt_top),
        .mux_in_addr(adder2_out_top)
    );

    //AND logic
    gatelogic gate(
        .Branch(Branch_top), .zero(zero_top),
        .and_out(and_out_top)
    );

    //mux for AND and Adder
    mux gate_mux(
        .sel(and_out_top),
        .A(PC_plused_top), .B(adder2_out_top),
        .mux_out(PC_addr_mux_out_top)
    ); 

    //Data memory
    data_mem datamem_unit(
        .clk(clk), .rst(rst), .MemRead(MemRead_top), .MemWrite(MemWrite_top),
        .address(ALU_out_top),
        .write_data(RD2_top),
        .read_data(data_mem_read_out_top)
    );

    //data_mem mux - for sel between read data and ALU out
    mux date_mem_mux(
        .sel(MemtoReg_top),
        .A(ALU_out_top), .B(data_mem_read_out_top),
        .mux_out(data_mem_mux_out_top)
    );

    //mux to sel between LUI and write data 
    mux write_reg_mux(
        .sel(LUI_en_top),
        .A(data_mem_mux_out_top), .B(ImmExt_top),
        .mux_out(mux_out_write_data)
    );
    
endmodule