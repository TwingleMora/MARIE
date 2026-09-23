module console_top
(
    input   wire               clk,
    input   wire               btn0,
    input   wire               btn1,


    output wire                 hdmi_tx_clk_p,
    output wire                 hdmi_tx_clk_n,
    output wire [2:0]           hdmi_tx_p,
    output wire [2:0]           hdmi_tx_n

);

localparam DATA_WIDTH = 16;
localparam ADDR_WIDTH = 12;

reset_generator reset_generator_module (.clk(clk), .rst(rst));

wire   [DATA_WIDTH-1:0]     h_count;
wire   [DATA_WIDTH-1:0]     v_count;
wire   [DATA_WIDTH-1:0]     ascii_char;
wire   [23:0]               rgb;
wire                        pixel_clk;
wire                        serial_clk;
wire                        hsync;
wire                        vsync;
wire                        clk_locked;
wire                        video_rst;


assign                       pixel_clk   = clk;
assign                       serial_clk  = clk;
assign                       clk_locked  = 1;
wire clk_rst = ~rst;
// clk_wiz_0 clock_wizard (
//     .clk_in1  (clk),
//     .reset    (clk_rst),      // Clock Wizard reset is active high
//     .clk_out1 (pixel_clk),
//     .clk_out2 (serial_clk),
//     .locked   (clk_locked)
// );




wire   [(DATA_WIDTH-1):0]     div_h_count;// = {3'b000,h_count[DATA_WIDTH-1:3]};
wire   [(DATA_WIDTH-1):0]     div_v_count;// = {3'b000,v_count[DATA_WIDTH-1:3]};




hv_counter#(.WIDTH(DATA_WIDTH)) hv_counter_module
(
    /* input   logic                */    .pixel_clk(pixel_clk),
    /* input   logic                */    .rst(rst),
                                          .clk_locked(clk_locked),
    // /* output  logic   [WIDTH-1:0]  */    .h_count(h_count),
    // /* output  logic   [WIDTH-1:0]  */    .v_count(v_count),
    /* output  logic                */    .hsync(hsync),
    /* output  logic                */    .vsync(vsync),
    /* output  logic                */    .video_active(video_active),
                                          .video_rst(video_rst)
);

marie_top#(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CONTROL_WIDTH(3)) marie_top_module
(
    /* input   logic                    */    .clk(pixel_clk),
    /* input   logic                    */    .rst(rst),
    /* input   logic                    */    .btn0(btn0),
    /* input   logic                    */    .btn1(btn1),
    /* input   logic                    */    .clk_locked(clk_locked),
    // /* input   logic   [DATA_WIDTH-1:0] */    .h_count(div_h_count),
    // /* input   logic   [DATA_WIDTH-1:0] */    .v_count(div_v_count),
    /* output  logic   [DATA_WIDTH-1:0] */    .code(ascii_char)
);


rgb_generator_fpga#(.WIDTH(DATA_WIDTH), .SCREEN_WIDTH(640), .SCREEN_HEIGHT(480)) rgb_generator_fpga_module
(
    /* input   wire                 */  .pixel_clk(pixel_clk),
    /* input   wire                 */  .rst(rst),
    /* input   wire                 */  .clk_locked(clk_locked),
    /* input   wire [WIDTH-1:0]     */  .ascii_char(ascii_char),
    /* output  wire [23:0]          */  .rgb(rgb)
);


// rgb2dvi_0 rgb2dvi_module (
//     .PixelClk     (pixel_clk),
//     .SerialClk    (serial_clk),

//     .vid_pData    (rgb),
//     .vid_pVDE     (video_active),
//     .vid_pHSync   (hsync),
//     .vid_pVSync   (vsync),

//     // You configured rgb2dvi reset as active-high
//     .aRst         (video_rst),

//     .TMDS_Clk_p   (hdmi_tx_clk_p),
//     .TMDS_Clk_n   (hdmi_tx_clk_n),

//     .TMDS_Data_p  (hdmi_tx_p),
//     .TMDS_Data_n  (hdmi_tx_n)
// );


endmodule
