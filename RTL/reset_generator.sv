module reset_generator
(
    input  logic    clk,
    output logic    rst
);


reg rst_ff0;
reg rst_ff1;
reg rst_ff2;
reg rst_ff3;
reg rst_ff4;


initial rst_ff0 = 0;
initial rst_ff1 = 0;
initial rst_ff2 = 0;
initial rst_ff3 = 0;
initial rst_ff4 = 0;

always @(posedge clk) begin
    rst_ff0 <= 1;
    rst_ff1 <= rst_ff0;
    rst_ff2 <= rst_ff1;
    rst_ff3 <= rst_ff2;
    rst_ff4 <= rst_ff3;
    rst     <= rst_ff4;
end


endmodule