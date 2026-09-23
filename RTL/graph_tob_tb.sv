module graph_top_tb;
localparam WIDTH = 16;
bit clk;
bit rst;

always #5 clk = ~clk;


logic [23:0] rgb;
logic video_active;
logic [WIDTH-1:0] h_count;
logic [WIDTH-1:0] v_count;
rgb_generator#(.WIDTH(WIDTH)/*DATA_WIDTH*/, .SCREEN_WIDTH(640), .SCREEN_HEIGHT(480)) rgb_generator_module
(

    /* input   logic           */       .clk(clk),
    /* input   logic           */       .rst(rst),
    /* input   logic           */       .video_active(video_active),
    /* output  logic    [23:0] */       .rgb(rgb),
                                        .h_count(h_count),
                                        .v_count(v_count)
);


initial
begin
    rst <= 1;
    @(posedge clk);
    repeat(1000)
    begin
        @(posedge clk);
    end
    $stop;
end

endmodule