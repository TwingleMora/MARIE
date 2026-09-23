module address_decoder#(parameter ADDR_WIDTH = 12)
(
    input   logic   [ADDR_WIDTH-1:0]    i_addr,
    input   logic                       i_wren,
    output  logic                       o_mem_wren,
    output  logic                       o_read_next_io,
    output  logic                       o_timer_start,
    output  logic                       o_frame_buffer_wren
);


always@(*)
begin
    o_mem_wren = 0;
    o_read_next_io = 0;
    o_timer_start = 0;
    o_frame_buffer_wren = 0;
    if(i_wren)
    begin
        if(i_addr < 12'h100)
        begin
            o_mem_wren = 1;
        end
        else if(i_addr == 12'h100)
        begin
            o_read_next_io = 1;
        end
        else if(i_addr == 12'h101)
        begin
            o_timer_start = 1;
        end
        else if(i_addr>12'h101 && i_addr<12'h105)
        begin
            o_frame_buffer_wren = 1;
        end
    end
end

endmodule