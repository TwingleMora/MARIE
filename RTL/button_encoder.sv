module button_encoder#(parameter DATA_WIDTH = 16)
(
    input   logic                       i_btn0,
    input   logic                       i_btn1,
    output  logic   [DATA_WIDTH-1:0]    o_btn_code,  
    output  logic                       o_btn_valid            
);


    always@(*)
    begin
        if(i_btn0)
        begin
            o_btn_code = 1;
            o_btn_valid = 1;
        end
        else if(i_btn1)
        begin
            o_btn_code = 2;
            o_btn_valid = 1;
        end
        else
        begin
            o_btn_code = 0;
            o_btn_valid = 0;
        end
    end


endmodule