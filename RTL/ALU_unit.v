module ALU_unit (
    input [31:0]A, B,
    input [3:0] control_in,
    output reg zero,  //for beq instruction, when and b are equal, zero is set to 1
    output reg [31:0]ALU_out
);

    always @(control_in or A or B) begin
        case(control_in)
            4'b0000: begin ALU_out <= A & B; zero <= 0; end
            4'b0001: begin ALU_out <= A | B; zero <= 0; end
            4'b0010: begin ALU_out <= A + B; zero <= 0; end
            4'b0110: 
                begin 
                    ALU_out <= A - B; 
                    if(A==B)
                        zero <= 1; 
                    else
                        zero <= 0; 
                end
            default: zero <= 0;
        endcase
    end
    
endmodule