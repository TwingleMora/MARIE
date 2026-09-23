module hv_counter#(parameter WIDTH = 16, parameter SCREEN_WIDTH = 640, parameter SCREEN_HEIGHT = 480)
(

    input   logic                   pixel_clk,
    input   logic                   rst,
    input   logic                   clk_locked,

    output  logic   [WIDTH-1:0]     h_count,
    output  logic   [WIDTH-1:0]     v_count,

    output  logic   [WIDTH-1:0]     div_h_count,
    output  logic   [WIDTH-1:0]     div_v_count,
    
    output  logic                   hsync,
    output  logic                   vsync,
    output  logic                   video_active,
    output  logic                   video_rst,
    output  logic                   video_rst_n
);




 // 640x480 timing
    localparam H_ACTIVE = SCREEN_WIDTH;
    localparam H_FRONT  = 16;
    localparam H_SYNC   = 96;
    localparam H_BACK   = 48;
    localparam H_TOTAL  = 800;

    localparam V_ACTIVE = SCREEN_HEIGHT;
    localparam V_FRONT  = 10;
    localparam V_SYNC   = 2;
    localparam V_BACK   = 33;
    localparam V_TOTAL  = 525;

logic             h_count_enable, v_count_enable;
logic             h_count_sync_rst, v_count_sync_rst;

assign h_count_enable = 1;
assign v_count_enable = (h_count == H_TOTAL-1);
assign h_count_sync_rst = v_count_enable;
assign v_count_sync_rst = (v_count == V_TOTAL -1);

assign div_h_count = {3'b000,h_count[WIDTH-1:3]};
assign div_v_count = {3'b000,v_count[WIDTH-1:3]};

// wire video_rst_n;

// wire video_rst;
assign video_rst_n = rst & clk_locked;
assign video_rst = ~video_rst_n;

counter  #(.WIDTH(WIDTH)) h_count_module
(
    .clk(pixel_clk),
    .rst(/* rst */video_rst_n),
    .sync_rst(h_count_sync_rst),
    .enable(h_count_enable),
    .count(h_count)
);

counter #(.WIDTH(WIDTH)) v_count_module
(
    .clk(pixel_clk),
    .rst(/* rst */video_rst_n),
    .sync_rst(v_count_sync_rst),
    .enable(v_count_enable),
    .count(v_count)
);


    // Horizontal sync
    assign hsync =
        ~((h_count >= H_ACTIVE + H_FRONT) &&
          (h_count <  H_ACTIVE + H_FRONT + H_SYNC));


    // Vertical sync
    assign vsync =
        ~((v_count >= V_ACTIVE + V_FRONT) &&
          (v_count <  V_ACTIVE + V_FRONT + V_SYNC));

    // Video Active
    assign video_active =   (h_count < SCREEN_WIDTH) &&
        (v_count < SCREEN_HEIGHT);

endmodule