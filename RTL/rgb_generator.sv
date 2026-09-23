module rgb_generator#(parameter WIDTH = 16/*DATA_WIDTH*/, SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480)
(



    input   logic   [WIDTH-1:0]         h_count,    
    input   logic   [WIDTH-1:0]         v_count,  
    input   logic                       video_active,  

    input   logic   [WIDTH-1:0]         ascii_char,
    output  logic   [23:0]              rgb

);


   


    logic   pixel_on;


pixel_out_generator#(.WIDTH(WIDTH)/*DATA_WIDTH*/, .SCREEN_WIDTH(SCREEN_WIDTH), .SCREEN_HEIGHT(SCREEN_HEIGHT)) pixel_out_generator_module
(

    /* input   logic [WIDTH-1:0] */   .h_count(h_count),
    /* input   logic [WIDTH-1:0] */   .v_count(v_count),
    /* input   logic [WIDTH-1:0] */   .ascii_char(ascii_char),
    /* output  logic             */   .pixel_on(pixel_on)
);


assign rgb = video_active? {24{pixel_on}}:24'h0;




endmodule