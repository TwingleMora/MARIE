module register#(parameter WIDTH = 16)
(
    input   logic               clk,
    input   logic               rst,
    input   logic               sync_rst,
    input   logic   [WIDTH-1:0] D,
    input   logic               EN,
    output  logic   [WIDTH-1:0] Q
    
);

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Q <= 0;
    end
    else if(sync_rst)
    begin
        Q <= 0;
    end
    else if(EN)
    begin
        Q <= D;
    end
end


endmodule