module read_mux #(parameter ADDR_WIDTH = 12, parameter DATA_WIDTH = 16)
(
    input   logic   [ADDR_WIDTH-1:0]    i_addr,
    input   logic   [DATA_WIDTH-1:0]    i_mem_data,
    input   logic   [DATA_WIDTH-1:0]    i_io_buff_data,
    input   logic   [DATA_WIDTH-1:0]    i_timer,
    output  logic   [DATA_WIDTH-1:0]    o_data
);

always@(*)
begin
    o_data = 0;
    if(i_addr < 12'h100)
    begin
        o_data = i_mem_data;
    end
    else if(i_addr == 12'h100)
    begin
        o_data = i_io_buff_data;
    end
    else if(i_addr == 12'h101)
    begin
        o_data = i_timer;
    end
end


endmodule