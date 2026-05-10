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
