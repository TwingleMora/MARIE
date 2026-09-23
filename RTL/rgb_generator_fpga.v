module rgb_generator_fpga#(parameter WIDTH = 16,parameter SCREEN_WIDTH = 640, parameter SCREEN_HEIGHT = 480)
(

    input   wire                pixel_clk,
    input   wire                rst,
    input   wire                clk_locked,
    input   wire [WIDTH-1:0]    ascii_char,
    output  wire [23:0]         rgb
);




// logic [23:0] rgb;
// logic [WIDTH-1:0] h_count;
// logic [WIDTH-1:0] v_count;

    
    wire    [WIDTH-1:0] h_count;
    wire    [WIDTH-1:0] v_count;
    wire                video_active;



hv_counter#(.WIDTH(WIDTH)) hv_counter_module
(
    /* input   logic                */    .pixel_clk(pixel_clk),
    /* input   logic                */    .rst(rst),
                                          .clk_locked(clk_locked),
    /* output  logic   [WIDTH-1:0]  */    .h_count(h_count),
    /* output  logic   [WIDTH-1:0]  */    .v_count(v_count),
    /* output  logic                */    .video_active(video_active)
);


rgb_generator#(.WIDTH(WIDTH)/*DATA_WIDTH*/, .SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT)) rgb_generator_module
(


    /* input   logic   [WIDTH-1:0] */   .ascii_char(ascii_char), 

    /* input   logic   [WIDTH-1:0]   */ .h_count(h_count),    
    /* input   logic   [WIDTH-1:0]   */ .v_count(v_count),  
    /* input   logic                 */ .video_active(video_active),  

    /* output  logic    [23:0] */       .rgb(rgb)
    


);



endmodule