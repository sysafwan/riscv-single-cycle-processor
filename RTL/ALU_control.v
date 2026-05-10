//takes the control unit output ALUOp and instruction func7 and func3
//to generate the function opcode for ALU
//we only use 30th bit in func7 as other wont change in ISA spec

module ALU_control (
    input [1:0]ALUOp,   //from control unit
    input fun7,     //from instruction mem
    input [2:0]fun3,    //from instruction mem
    output reg[3:0]control_out     //sent to ALU
);

    always @(*) begin
        case({ALUOp, fun7, fun3})
            6'b00_0_000: control_out <= 4'b0010;    //LOAD or STORE
            6'b01_0_000: control_out <= 4'b0110;    //BEQ - (Subtract)branch if equal
            6'b10_0_000: control_out <= 4'b0010;    //ADD
            6'b10_1_000: control_out <= 4'b0110;    //SUB
            6'b10_0_111: control_out <= 4'b0000;    //AND
            6'b10_0_110: control_out <= 4'b0001;    //OR
        endcase
    end
    
endmodule