module MARIE #(parameter ADDR_WIDTH = 12, DATA_WIDTH = 16, CONTROL_WIDTH = 3)
(
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       sync_rst,

    input   logic   [DATA_WIDTH-1:0]    i_data,
    output  logic   [DATA_WIDTH-1:0]    o_data,
    output  logic   [ADDR_WIDTH-1:0]    o_addr,
    output  logic                       o_wren
);
localparam SEL_WIDTH = 8;

logic [1:0] alu_op;

logic                   ir_reg_rden,
                        out_reg_rden, 
                        in_reg_rden, 
                        ac_reg_rden, 
                        mbr_reg_rden, 
                        pc_count_rden, 
                        mar_reg_rden;
logic                   mem_rden;


// logic [DATA_WIDTH-1:0] ir_reg;

logic [3:0]            instr_reg;
logic [ADDR_WIDTH-1:0] instr_addr_reg; 
logic                  ir_reg_wren;

logic [DATA_WIDTH-1:0] out_reg;
logic                  out_reg_wren;

logic [DATA_WIDTH-1:0] in_reg;
logic                  in_reg_wren;

logic [DATA_WIDTH-1:0] ac_reg;
logic                  ac_reg_wren;

logic [DATA_WIDTH-1:0] mbr_reg;
logic                  mbr_reg_wren;

logic [DATA_WIDTH-1:0] alu_out;

logic [ADDR_WIDTH-1:0] pc_count;
logic                  pc_count_inc;
logic                  pc_count_wren;

logic [ADDR_WIDTH-1:0] mar_reg;
logic                  mar_reg_wren;

logic                  mem_wren;

logic                  ac_lst;
logic                  ac_zero;

wire logic [7:0] mux_sel = {ir_reg_rden, out_reg_rden, in_reg_rden, ac_reg_rden, mbr_reg_rden, pc_count_rden, mar_reg_rden, mem_rden};
wire logic [(DATA_WIDTH*SEL_WIDTH)-1:0] mux_in = {4'b0, instr_addr_reg, out_reg, in_reg, ac_reg, alu_out/* mbr_reg */, 4'b0, pc_count, 4'b0, mar_reg, i_data};

logic [DATA_WIDTH-1:0] data_bus;
// logic [ADDR_BUS-1:0] addr_bus;

assign o_addr = mar_reg;
assign o_wren = mem_wren; 
assign o_data = mbr_reg;


mux#(.SEL_WIDTH(SEL_WIDTH), .WIDTH(DATA_WIDTH)) mux_module
(
    .sel(mux_sel),
    .in(mux_in),
    .out(data_bus)
);


register#(.WIDTH(DATA_WIDTH)) ir_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(ir_reg_wren),
    .Q({instr_reg,instr_addr_reg})
);

register#(.WIDTH(DATA_WIDTH)) out_reg_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(out_reg_wren),
    .Q(out_reg)
);


register#(.WIDTH(DATA_WIDTH)) in_reg_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(in_reg_wren),
    .Q(in_reg)
);

register#(.WIDTH(DATA_WIDTH)) ac_reg_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(ac_reg_wren),
    .Q(ac_reg)
);

register#(.WIDTH(DATA_WIDTH)) mbr_reg_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(mbr_reg_wren),
    .Q(mbr_reg)
);


counter#(.WIDTH(ADDR_WIDTH), .LOAD_EN(1)) pc_count_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .enable(pc_count_inc),
    .load_data(data_bus),
    .load_en(pc_count_wren),
    .count(pc_count)
);

register#(.WIDTH(DATA_WIDTH)) mar_reg_module
(
    .clk(clk),
    .rst(rst),
    .sync_rst(1'b0),
    .D(data_bus),
    .EN(mar_reg_wren),
    .Q(mar_reg)
);



control_unit#(.INSTR_WIDTH(4)) control_module
(
    //read
    //write
    /* input   logic                    */    .clk(clk),
    /* input   logic                    */    .rst(rst),
    /* input   logic  [INSTR_WIDTH-1:0] */    .instr(instr_reg), 
                                              .skip_type(instr_addr_reg[11:10]),
                                              .ac_lst(ac_lst),
                                              .ac_zero(ac_zero),
    /* output  logic                    */    .ir_reg_rden(ir_reg_rden),
    /* output  logic                    */    .out_reg_rden(out_reg_rden), 
    /* output  logic                    */    .in_reg_rden(in_reg_rden), 
    /* output  logic                    */    .ac_reg_rden(ac_reg_rden), 
    /* output  logic                    */    .mbr_reg_rden(mbr_reg_rden), 
    /* output  logic                    */    .pc_count_rden(pc_count_rden), 
    /* output  logic                    */    .mar_reg_rden(mar_reg_rden),
    /* output  logic                    */    .mem_rden(mem_rden),
    /* output  logic                    */    .ir_reg_wren(ir_reg_wren),
    /* output  logic                    */    .out_reg_wren(out_reg_wren), 
    /* output  logic                    */    .in_reg_wren(in_reg_wren), 
    /* output  logic                    */    .ac_reg_wren(ac_reg_wren), 
    /* output  logic                    */    .mbr_reg_wren(mbr_reg_wren), 
    /* output  logic                    */    .pc_count_wren(pc_count_wren), 
    /* output  logic                    */    .pc_count_inc(pc_count_inc), 
    /* output  logic                    */    .mar_reg_wren(mar_reg_wren),
    /* output  logic                    */    .mem_wren(mem_wren),
                                              .alu_op(alu_op)
);



alu#(.DATA_WIDTH(DATA_WIDTH)) alu_module
(
    /* input   logic [1:0]            */  .op(alu_op),
    /* input   logic [DATA_WIDTH-1:0] */  .ac_reg(ac_reg),
    /* input   logic [DATA_WIDTH-1:0] */  .mbr_reg(mbr_reg),
    /* output  logic [DATA_WIDTH-1:0] */  .alu_out(alu_out)

);




endmodule