module counter #(parameter WIDTH = 16, LOAD_EN = 0)
(
    input   logic                   clk,
    input   logic                   rst,
    input   logic                   sync_rst,
    input   logic                   load_en,
    input   logic   [WIDTH-1:0]     load_data,
    input   logic                   enable,
    output  logic   [WIDTH-1:0]     count
);

generate
    if(!LOAD_EN)
    begin
        always@(posedge clk or negedge rst)
        begin
            if(!rst)
            begin
                count <= 0;
            end
            else if(sync_rst)
            begin
                count <= 0;
            end
            else if(enable)
            begin
                count <= count + 1;
            end
        end
    end
    else
    begin
        always@(posedge clk or negedge rst)
        begin
            if(!rst)
            begin
                count <= 0;
            end
            else if(sync_rst)
            begin
                count <= 0;
            end
            else if(load_en)
            begin
                count <= load_data;
            end
            else if(enable)
            begin
                count <= count + 1;
            end
        end
    end
endgenerate

endmodule