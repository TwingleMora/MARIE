module frame_buffer #(parameter WIDTH = 32, parameter HEIGHT = 32, parameter WORD = 8, parameter DATA_WIDTH = 16)
(
    input   logic                       clk,
    input   logic                       rst,
    

    input   logic                       i_wren,
    input   logic                       i_addr,
    input   logic   [WORD-1:0]          i_data,



    input   logic   [DATA_WIDTH-1:0]    i_graph_addr_x,
    input   logic   [DATA_WIDTH-1:0]    i_graph_addr_y,

    output  logic   [WORD-1:0]          o_data
);

    logic   [DATA_WIDTH-1:0]    r_coord_x;
    logic   [DATA_WIDTH-1:0]    r_coord_y;
    
    logic   [WORD-1:0]          r_code;

    localparam DEPTH = WIDTH *HEIGHT;
    logic   [7:0] frame [DEPTH];

    initial 
    begin
        $readmemh("map.mem", frame);
    end


    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            r_coord_x <= 0;
            r_coord_y <= 0;
        end
        else
        begin
            if(i_wren)
            begin
                if(i_addr == 12'h102)
                begin
                    r_coord_x <= i_data;
                end
                else if(i_addr == 12'h103)
                begin
                    r_coord_y <= i_data;
                end
            end

        end
    end
    wire logic [DATA_WIDTH-1:0] frame_addr = (r_coord_y<<5) + r_coord_x;
    always@(posedge clk)
    begin
        if(i_wren)
        begin
            if(i_addr == 12'h104)
            begin
                frame[frame_addr] <= i_data;
            end
        end
    end

    wire logic [DATA_WIDTH-1:0] i_graph_addr = (i_graph_addr_y<<5) + i_graph_addr_x;
    always@(*)
    begin
        if((i_graph_addr_x<WIDTH)&&(i_graph_addr_y<HEIGHT))
        begin
            o_data = frame[i_graph_addr];
        end
        else
        begin
            o_data = 8'h20;
        end
    end
    


endmodule