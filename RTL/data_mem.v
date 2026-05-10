//this is the actual memory to store data

module data_mem (
    input clk, rst, MemRead, MemWrite,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0]D_mem[63:0];
    integer k;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for (k = 0; k<64; k=k+1) begin
                D_mem[k] <= 32'b00;
            end
        end
        else if(MemWrite)
            D_mem[address] <= write_data;
    end

    assign read_data = (MemRead) ? D_mem[address] : 32'b00;
    
endmodule