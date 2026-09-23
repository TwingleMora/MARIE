module sram#(parameter WORD = 16, parameter ADDR_WIDTH = 12)
( 
    input   logic                   clk,
    input   logic                   rst,
    
    input   logic                   i_wren,
    input   logic [ADDR_WIDTH-1:0]  i_addr,
    input   logic [WORD-1:0]        i_data,
    output  logic [WORD-1:0]        o_data
);


initial begin
    @(posedge rst)
    #1;
    $readmemh("test.mem",mem);
end

localparam DEPTH = 2<<5;

logic [WORD-1:0] mem [DEPTH];




assign o_data = mem[i_addr];
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        for(int i = 0; i<DEPTH; i++)
        begin
            mem[i] <= 0;
        end
    end 
    else if(i_wren)
    begin
        mem[i_addr] <=  i_data;
    end
end

endmodule