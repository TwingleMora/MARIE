module console_tob_tb;
    bit clk;
    bit rst;

    bit btn0;
    bit btn1;


always #5 clk <= ~clk;

console_top console_top_module
(
    /* input   wire      */           .clk(clk),
    /* input   wire      */           .btn0(btn0),
    /* input   wire      */           .btn1(btn1),
    /* output wire       */           .hdmi_tx_clk_p(),
    /* output wire       */           .hdmi_tx_clk_n(),
    /* output wire [2:0] */           .hdmi_tx_p(),
    /* output wire [2:0] */           .hdmi_tx_n()

);

initial
begin
    // rst <= 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk)
    // rst <= 1;

    btn0 <= 1;

    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    btn1 <= 1;

    @(posedge clk)
    @(posedge clk)

    repeat(1000)
        @(posedge clk);
        
        
    $stop;

end




endmodule