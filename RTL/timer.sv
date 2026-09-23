module timer#(parameter WIDTH = 10)
(
    input   logic               clk,
    input   logic               rst,

    input   logic  [WIDTH-1:0]  init_value,
    input   logic               start,//reset and continue

    output  logic  [WIDTH-1:0]  timer
);

logic state;
logic finish;

assign finish = timer == 0;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        state <= 0;
    end
    else if(start)
    begin
        state <= 1;
    end
    else if(finish)
    begin
        state <= 0;
    end

end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        timer <= init_value;
    end
    else if(start)
    begin
        timer <= init_value;
    end
    else if(state)
    begin
        if(!finish)
        begin
            timer <= timer - 1;
        end
    end
end


endmodule

