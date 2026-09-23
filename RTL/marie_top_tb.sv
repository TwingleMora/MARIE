module marie_top_tb;

bit clk;
bit rst;

bit btn0;
bit btn1;

always #5 clk <= ~clk;

localparam  ADDR_WIDTH = 12,
            DATA_WIDTH = 16,
            CONTROL_WIDTH = 3;


marie_top #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CONTROL_WIDTH(CONTROL_WIDTH)) marie_top_module
(
    .clk(clk),
    .rst(rst),
    .btn0(btn0),
    .btn1(btn1)
);

initial
begin
    rst <= 0;
    @(posedge clk);
    rst <= 1;

    @(posedge clk)
    btn0 <= 1;

    @(posedge clk)
    btn1 <= 1;

    @(posedge clk)

    repeat(1000)
        @(posedge clk);
        
        
    $stop;

end

endmodule