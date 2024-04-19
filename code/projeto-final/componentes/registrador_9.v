// REGISTRADOR SÍNCRONO DE 9 BITS -------------------------------------------------------
module registrador_9 (
    input        clock,
    input        clear,
    input        enable,
    input  [8:0] D,
    output [8:0] Q
);

    reg [8:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule