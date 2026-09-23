module pixel_out_generator#(parameter WIDTH = 16/*DATA_WIDTH*/, SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480)
(
    // input   logic                   clk,
    // input   logic                   rst,

    input   logic [WIDTH-1:0]       h_count,
    input   logic [WIDTH-1:0]       v_count,
    input   logic [WIDTH-1:0]       ascii_char,

    output  logic               pixel_on
   


);

// localparam WIDTH = PIXEL_WIDTH;




// logic   [WIDTH-1:0] rocket_x, rocket_y, asteroid_x, asteroid_y;

// assign rocket_x = 0;
// assign rocket_y = 0;
// assign asteroid_x = 0;
// assign asteroid_y = 0;


// logic [WIDTH-1:0] ascii_char;
// ascii_generator #(.WIDTH(WIDTH)) ascii_generator_module
// (

//     /* input   logic   [WIDTH-1:0] */ .h_count(h_count),
//     /* input   logic   [WIDTH-1:0] */ .v_count(v_count),
//     /* input   logic   [WIDTH-1:0] */ .r_x(rocket_x),
//     /* input   logic   [WIDTH-1:0] */ .r_y(rocket_y),
//     /* input   logic   [WIDTH-1:0] */ .a_x(asteroid_x),
//     /* input   logic   [WIDTH-1:0] */ .a_y(asteroid_y),
//     /* output  logic   [WIDTH-1:0] */ .ascii_char(ascii_char)

// );
wire logic [7:0] ascii_char_addr = ascii_char[7:0]; 
logic [10:0] rom_addr;
logic [7:0]  h_pixels;
assign rom_addr = {ascii_char_addr,v_count[2:0]};
ASCII_ROM#(.ADDR_WIDTH(11), .DATA_WIDTH(8)) ascii_rom_module
(
    /* input   logic   [ADDR_WIDTH-1:0] */ .i_addr(rom_addr),
    /* output  logic   [ADDR_WIDTH-1:0] */ .o_data(h_pixels)
);

assign pixel_on = h_pixels[h_count[2:0]];


endmodule