//increament the counter with 4

module PC_inc(
    input [31:0] fromPC,
    output [31:0] toPC
);

    assign toPC = 4 + fromPC;

endmodule