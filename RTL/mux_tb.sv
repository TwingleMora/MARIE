module mux_tb;

localparam  SEL_WIDTH   =   3,
            WIDTH       =   4;

logic   [SEL_WIDTH-1:0]         sel;
logic   [(WIDTH*SEL_WIDTH)-1:0] in;
logic   [WIDTH-1:0]             out;

mux#(.SEL_WIDTH(SEL_WIDTH), .WIDTH(WIDTH)) mux_module
(
    /* input   logic   [SEL_WIDTH-1:0]         */ .sel(sel),
    /* input   logic   [(WIDTH*SEL_WIDTH)-1:0] */ .in(in),
    /* output  logic   [WIDTH-1:0]             */ .out(out)
);

initial
begin
in = {4'b0101, 4'b0111, 4'b1001};

#1;
sel = 1;

#5
sel = 2;


# 10
sel = 4;

#20;


end
endmodule