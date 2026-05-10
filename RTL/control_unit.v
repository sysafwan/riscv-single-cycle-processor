//this specifies the operation based on the opcode
//mainly determins the ALUOp

module control_unit (
    input [6:0]opcode,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, LUI_en, AUIPC_en, JAL_en, JALr_en,
    output reg[1:0]ALUOp
);

    always @(*) begin
        case(opcode)
            7'b0110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b0010000000_10;  //R-type
            7'b0010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b1010000000_10;  //I-type
            7'b0000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b1111000000_00;  //load
            7'b0100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b1000100000_00;  //store
            7'b1100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b0000010000_01;  //beq

            7'b0110111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b0010001000_00;  //U-type lui
            7'b0010111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b0010000100_10;  //U-type AUIPC
            
            7'b1101111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b1000000110_10;  //J-type JAL
            7'b1100111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b1000000001_10;  //J-type JALr
            
            
            default: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, LUI_en, AUIPC_en, JAL_en, JALr_en, ALUOp} <= 12'b0000000000_00; //default with r-type
        endcase
    end
    
endmodule