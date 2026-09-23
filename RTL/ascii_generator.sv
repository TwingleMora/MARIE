module ascii_generator #(parameter WIDTH=16)
(

    input   logic   [WIDTH-1:0] h_count,
    input   logic   [WIDTH-1:0] v_count,

    input   logic   [WIDTH-1:0] r_x,
    input   logic   [WIDTH-1:0] r_y,

    input   logic   [WIDTH-1:0] a_x,
    input   logic   [WIDTH-1:0] a_y,

    output  logic   [WIDTH-1:0] ascii_char

);

always@(*)
begin
    if((h_count[WIDTH-1:3] == a_x[WIDTH-1:3])
    &&(v_count[WIDTH-1:3] == a_y[WIDTH-1:3]))
    begin
        ascii_char = 'd62;//>
    end
    else if((h_count[WIDTH-1:3] == r_x[WIDTH-1:3])
    &&(v_count[WIDTH-1:3] == r_y[WIDTH-1:3]))
    begin
        ascii_char = 'd64;//@
    end
    else
    begin
        ascii_char = 'd46;//.
    end
end



endmodule