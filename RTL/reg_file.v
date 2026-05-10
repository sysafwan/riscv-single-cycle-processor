//take out register addresses from the instruction
//initialize the registers with random value from tb or from actual memory

module reg_file (
    input clk, rst, reg_write,
    input [4:0]rs1, rs2, rd,
    input [31:0]write_data, 
    output [31:0]read_data_1, read_data_2
);

    reg [31:0] registers[31:0]; // 32 bit registers
    integer k;

    // initial begin
    //     $monitor("r1: %b, r2: %b, rd: %b", rs1, rs2, rd);
    //     registers[0] = 0;
    //     registers[1] = 2;
    //     registers[2] = 32;
    //     registers[3] = 22;
    //     registers[4] = 23;
    //     registers[5] = 14;
    //     registers[6] = 5;
    //     registers[7] = 8;
    //     registers[8] = 12;
    //     registers[9] = 68;
    //     registers[10] = 10;
    //     registers[11] = 16;
    //     registers[12] = 28;
    //     registers[13] = 51;
    //     registers[14] = 63;
    //     registers[15] = 78;
    //     registers[16] = 86;
    //     registers[17] = 90;
    //     registers[18] = 17;
    //     registers[19] = 19;
    //     registers[20] = 20;
    //     registers[21] = 4;
    //     registers[22] = 21;
    //     registers[23] = 6;
    //     registers[24] = 33;
    //     registers[25] = 44;
    //     registers[26] = 55;
    //     registers[27] = 66;
    //     registers[28] = 77;
    //     registers[29] = 88;
    //     registers[30] = 120;
    //     registers[31] = 134;
    // end

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            for(k=0;k<32;k=k+1) begin
                registers[k] <= k;
            end            
        end else if(reg_write) begin
            registers[rd] <= write_data;
        end
    end

    assign read_data_1 = registers[rs1];
    assign read_data_2 = registers[rs2];
    
endmodule