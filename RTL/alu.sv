module alu#(parameter DATA_WIDTH = 16)
(
    input   logic [1:0] op,
    input   logic [DATA_WIDTH-1:0] ac_reg,
    input   logic [DATA_WIDTH-1:0] mbr_reg,

    output  logic [DATA_WIDTH-1:0] alu_out

);


always@(*)
begin
    case(op)
    0:
    begin
        alu_out = mbr_reg;
    end
    1:
    begin
        alu_out = mbr_reg + ac_reg;
    end
    2:
    begin
        alu_out = ac_reg - mbr_reg;
    end
    endcase
end

endmodule