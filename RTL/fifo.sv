module fifo #(parameter DEPTH = 5, WIDTH = 8, COUNTER_EN = 0, DATA_EN = 0, OUT_EN = 0, localparam COUNT_WIDTH = $clog2(DEPTH+1))
(
    input   logic                       clk,
    input   logic                       rst,

    input   logic                       sync_rst,

    input   logic   [WIDTH-1:0]         wr_data,
    input   logic                       wr_en,

    input   logic                       rd_en,
    output  logic   [WIDTH-1:0]         rd_data,

    output  logic   [WIDTH-1:0]         r_rd_data,
    output  logic                       r_empty,

    output  logic                       full,
    // output  logic                       r_full,
    output  logic                       empty,

    output  logic                       ready,
    output  logic                       valid,

    output  logic                       almost_empty,
    output  logic                       almost_full
    // output  logic                       last_read

    // output  logic   [COUNT_WIDTH-1:0]   o_counter

    // output  logic   [(DEPTH*WIDTH)-1:0]   o_data
);

//localparam COUNT_WIDTH = $clog2(DEPTH+1);//1 -> DEPTH, 0 -> DEPTH - 1
logic   write;
logic   read;

logic   [COUNT_WIDTH-1:0] counter;

logic   [COUNT_WIDTH-1:0] wr_ptr;
logic   [COUNT_WIDTH-1:0] rd_ptr;

(* ram_style = "block" *)
logic   [WIDTH-1:0]         mem [DEPTH];

/* generate
    if(DATA_EN)
    begin
        always@(*)
        begin
            o_data = 0;
            if(OUT_EN)
            begin
                for(int x = 0; x<DEPTH; x++)
                begin
                    o_data[(x*8)+:8] = mem[x];
                end
            end
        end
    end
    else
    begin
        assign o_data = 0;
    end
endgenerate */
// assign  o_counter    =  COUNTER_EN? counter : 'b0;

assign  full         =  counter ==  DEPTH;
assign  empty        =  counter ==  0;
assign  almost_empty =  counter ==  1;
assign  almost_full  =  counter ==  DEPTH-1;

assign  ready        = !full;
assign  valid        = !empty;

assign  rd_data      =   mem[rd_ptr];


// assign last_read     = almost_empty & read & !write; //transition from counter == 1 to counter == 0

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        r_empty <= 1;
    end
    else if(sync_rst)
    begin
        r_empty <= 1;
    end
    else
    begin
        r_empty <= empty;
    end
end


always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        r_rd_data <= 0;
    end
    else if(sync_rst)
    begin
        r_rd_data <= 0;
    end
    else
    begin
        r_rd_data <= rd_data;
    end

end




assign  write = wr_en && !full;
assign  read  = rd_en && !empty;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        for (int i = 0; i<DEPTH; i++)
        begin
            mem[i] <= 'd0;
        end
    end
    else
    begin
        if(wr_en && !full)
        begin
            mem[wr_ptr] <= wr_data;
        end
    end
end


always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        wr_ptr <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            wr_ptr <= 0;
        end
        else if(wr_en && !full)
        begin
            wr_ptr <= wr_ptr + 1;
            if(wr_ptr == DEPTH -1)
            begin
                wr_ptr <= 0;
            end
        end
    end
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        rd_ptr <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            rd_ptr <= 0;
        end
        else if(rd_en && !empty)
        begin
            rd_ptr <= rd_ptr + 1;
            if(rd_ptr == DEPTH-1)
            begin
                rd_ptr <= 0;
            end
        end
    end
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        counter <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            counter <= 0;
        end
        else if(write && read)
        begin
            counter <= counter;
        end
        else if(write)
        begin
            counter <= counter + 1;
        end
        else if(read)
        begin
            counter <= counter - 1;
        end

    end


end



endmodule