module marie_top#(parameter ADDR_WIDTH = 12, DATA_WIDTH = 16, CONTROL_WIDTH = 3)
(
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       btn0,
    input   logic                       btn1,
    input   logic                       clk_locked,
    // input   logic   [DATA_WIDTH-1:0]    h_count,
    // input   logic   [DATA_WIDTH-1:0]    v_count,
    output  logic   [DATA_WIDTH-1:0]    code
    // output  logic   [DATA_WIDTH-1:0]    player_x,
    // output  logic   [DATA_WIDTH-1:0]    player_y
);

wire    logic marie_sync_rst = 0;
logic       [ADDR_WIDTH-1:0]    mosi_addr;
logic       [DATA_WIDTH-1:0]    mosi_data;
logic       [DATA_WIDTH-1:0]    miso_data;
logic                           control_wren;
logic                           mem_wren;


logic btn0_ff1,btn0_ff2,btn0_ff3;
logic btn1_ff1,btn1_ff2,btn1_ff3;
logic btn0_down, btn1_down;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        btn0_ff1<=0;btn0_ff2<=0;btn0_ff3<=0;
        btn1_ff1<=0;btn1_ff2<=0;btn1_ff3<=0;
    end
    else
    begin
        btn0_ff1<=btn0;btn0_ff2<=btn0_ff1;btn0_ff3<=btn0_ff2;
        btn1_ff1<=btn1;btn1_ff2<=btn1_ff1;btn1_ff3<=btn1_ff2;
    end
end
assign btn0_down = !btn0_ff3 & btn0_ff2;
assign btn1_down = !btn1_ff3 & btn1_ff2;

MARIE #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CONTROL_WIDTH(CONTROL_WIDTH)) marie_module
(
    /* input   logic                    */    .clk(clk),
    /* input   logic                    */    .rst(rst),
    /* input   logic                    */    .sync_rst(marie_sync_rst),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_data(miso_data),
    /* output  logic   [DATA_WIDTH-1:0] */    .o_data(mosi_data),
    /* output  logic   [ADDR_WIDTH-1:0] */    .o_addr(mosi_addr),
    /* output  logic                    */    .o_wren(control_wren)
);


logic [DATA_WIDTH-1:0]      input_fifo_write_data;
logic                       input_fifo_write_enable;


button_encoder#(.DATA_WIDTH(DATA_WIDTH)) button_encoder_module
(
    /* input   logic                    */    .i_btn0(btn0_down),
    /* input   logic                    */    .i_btn1(btn1_down),
    /* output  logic   [DATA_WIDTH-1:0] */    .o_btn_code(input_fifo_write_data),  
    /* output  logic                    */    .o_btn_valid(input_fifo_write_enable)            
);

wire   [DATA_WIDTH-1:0]     h_count;
wire   [DATA_WIDTH-1:0]     v_count;


wire   [(DATA_WIDTH-1):0]     div_h_count;// = {3'b000,h_count[DATA_WIDTH-1:3]};
wire   [(DATA_WIDTH-1):0]     div_v_count;// = {3'b000,v_count[DATA_WIDTH-1:3]};
hv_counter#(.WIDTH(DATA_WIDTH)) hv_counter_module
(
    /* input   logic                */    .pixel_clk(clk),
    /* input   logic                */    .rst(rst),
                                          .clk_locked(clk_locked),
    /* output  logic   [WIDTH-1:0]  */    .h_count(h_count),
    /* output  logic   [WIDTH-1:0]  */    .v_count(v_count),

    /* output  logic   [WIDTH-1:0]  */    .div_h_count(div_h_count),
    /* output  logic   [WIDTH-1:0]  */    .div_v_count(div_v_count)

);

logic [DATA_WIDTH-1:0]      mem_read;
sram#(.WORD(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) sram_module
(
    /* input   logic                  */  .clk(clk),
    /* input   logic                  */  .rst(rst),
    /* input   logic                  */  .i_wren(mem_wren),
    /* input   logic [ADDR_WIDTH-1:0] */  .i_addr(mosi_addr),
    /* input   logic [WORD-1:0]       */  .i_data(mosi_data),
    /* output  logic [WORD-1:0]       */  .o_data(mem_read)
);

logic o_frame_buffer_wren;
logic   [7:0]   ascii_code_tmp;

assign code   =   {8'h00,ascii_code_tmp};

frame_buffer #(.WORD(8), .DATA_WIDTH(DATA_WIDTH)) frame_buffer_module
(
    /* input   logic                    */    .clk(clk),
    /* input   logic                    */    .rst(rst),
    /* input   logic                    */    .i_wren(o_frame_buffer_wren),
    /* input   logic                    */    .i_addr(mosi_addr),
    /* input   logic   [WORD-1:0]       */    .i_data(mosi_data),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_graph_addr_x(div_h_count),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_graph_addr_y(div_v_count),
    /* output  logic   [WORD-1:0]       */    .o_data(ascii_code_tmp)
);



//0x0000
//0x1000//read data []
//0x1001//read      [next (mem_wren)]
 

logic [DATA_WIDTH-1:0]      input_fifo_read_data;
logic                       input_fifo_rden;
logic                       input_fifo_valid;
logic [DATA_WIDTH-1:0]      input_fifo_read_data_tmp;
assign input_fifo_read_data = {16{input_fifo_valid}} & input_fifo_read_data_tmp;
fifo #(.DEPTH(5) , .WIDTH(DATA_WIDTH), .COUNTER_EN(0), .DATA_EN(0), .OUT_EN(0)) input_buffer
(
    /* input   logic                */         .clk(clk),
    /* input   logic                */         .rst(rst),
    /* input   logic                */         .sync_rst(sync_rst),
    /* input   logic    [WIDTH-1:0] */         .wr_data(input_fifo_write_data),
    /* input   logic                */         .wr_en(input_fifo_write_enable),
    /* input   logic                */         .rd_en(input_fifo_rden),
    /* output  logic    [WIDTH-1:0] */         .rd_data(input_fifo_read_data_tmp),
    /* output  logic                */         .ready(ready),
    /* output  logic                */         .valid(input_fifo_valid)
);




read_mux #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) read_mux_module
(
    /* input   logic   [ADDR_WIDTH-1:0] */    .i_addr(mosi_addr),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_mem_data(mem_read),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_timer(),
    /* input   logic   [DATA_WIDTH-1:0] */    .i_io_buff_data(input_fifo_read_data),
    /* output  logic   [DATA_WIDTH-1:0] */    .o_data(miso_data)
);

address_decoder#(.ADDR_WIDTH(ADDR_WIDTH)) address_decoder_module
(
    /* input   logic   [ADDR_WIDTH-1:0] */    .i_addr(mosi_addr),
    /* input   logic                    */    .i_wren(control_wren),
    /* output  logic                    */    .o_mem_wren(mem_wren),
    /* output  logic                    */    .o_read_next_io(input_fifo_rden),
                                              .o_frame_buffer_wren(o_frame_buffer_wren)
);



endmodule