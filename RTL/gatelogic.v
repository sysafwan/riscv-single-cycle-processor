module gatelogic (
    input Branch, zero,
    output and_out
);

    assign and_out = Branch & zero; 
    
endmodule