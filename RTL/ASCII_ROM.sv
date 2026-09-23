module ASCII_ROM#(parameter ADDR_WIDTH = 10, DATA_WIDTH = 8)
(
    input   logic   [ADDR_WIDTH-1:0] i_addr,
    output  logic   [DATA_WIDTH-1:0] o_data
);  
localparam DEPTH = 128 * 8;
logic [7:0] mem [DEPTH];
initial begin
    $readmemh("font128x8rows_lsb_left.mem",mem);
end

assign o_data = mem[i_addr];



endmodule