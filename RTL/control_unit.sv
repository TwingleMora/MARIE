module control_unit#(parameter INSTR_WIDTH = 4)
(
    input   logic                       clk,
    input   logic                       rst,

    input   logic  [INSTR_WIDTH-1:0]    instr, 
    input   logic  [1:0]                skip_type,

    input   logic                       ac_lst,
    input   logic                       ac_zero,
    
    //read
    output  logic                       ir_reg_rden,
    output  logic                       out_reg_rden, 
    output  logic                       in_reg_rden, 
    output  logic                       ac_reg_rden, 
    output  logic                       alu_rden,
    output  logic                       mbr_reg_rden, 
    output  logic                       pc_count_rden, 
    output  logic                       mar_reg_rden,
    output  logic                       mem_rden,

    //write
    output  logic                       ir_reg_wren,
    output  logic                       out_reg_wren, 
    output  logic                       in_reg_wren, 
    output  logic                       ac_reg_wren, 
    output  logic                       mbr_reg_wren, 

    output  logic                       pc_count_wren, 
    output  logic                       pc_count_inc, 

    output  logic                       mar_reg_wren,
    output  logic                       mem_wren,

    output  logic       [1:0]           alu_op
);


typedef enum logic [2:0] {CPU_IDLE, FETCH, DECODE, EXECUTE, TERMINATE } cpu_fsm;
typedef enum logic [1:0] {FETCH_MAR, READ_UPDATE} fetch_fsm;
// typedef enum logic       {FETCH_MAR, READ_UPDATE} decode_fsm;
typedef enum logic [4:0] {IDLE, ADDR2MAR, ST_ADDR2MAR, STORE_MAR_MBR, MEM2MBR, MBR2AC, AC2MBR, MBR2MEM, IN2AC, AC2OUT, PCINC, ADDR2PC, EXIT} execute_fsm;


localparam LOAD     = 4'b0001;
localparam STORE    = 4'b0010;
localparam ADD      = 4'b0011;
localparam SUBT     = 4'b0100;

localparam INPUT = 4'b0101;
localparam OUTPUT = 4'b0110;
localparam HALT = 4'b0111;
localparam SKIPCOND = 4'b1000;
localparam JUMP = 4'b1001;
localparam CLEAR = 4'b1010;


cpu_fsm current;
cpu_fsm next;

fetch_fsm fetch_current;
fetch_fsm fetch_next;


execute_fsm execute_current;
execute_fsm execute_next;


always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        fetch_current <= FETCH_MAR;
    end
    else
    begin
        fetch_current <= fetch_next;
    end
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        execute_current <= IDLE;
    end
    else
    begin
        execute_current <= execute_next;
    end
end


always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        current <= CPU_IDLE;
    end
    else
    begin
        current <= next;
    end
end

logic fetch_done;
logic decode_done;
assign decode_done = 1;
logic execute_done;
logic terminate;
always@(*)
begin
    next = current;
    case(current)
    CPU_IDLE:
    begin
        next = FETCH;
    end
    FETCH:
    begin
        if(fetch_done)
            next = DECODE;
    end
    DECODE:
    begin
        if(decode_done)
            next = EXECUTE;
    end
    EXECUTE:
    begin
        if (terminate)
            next = TERMINATE;
        else if(execute_done)
            next = FETCH;
    end
    TERMINATE:
    begin

    end
    endcase

end


always@(*)
begin
    fetch_next = fetch_current;
    fetch_done = 0;
    if(current == FETCH)
    begin
        case(fetch_current)
        FETCH_MAR:
        begin
            fetch_next = READ_UPDATE;
        end
        READ_UPDATE:
        begin
            fetch_next = FETCH_MAR;
            fetch_done = 1;
        end
        endcase
    end
end


always@(*)
begin
    execute_done = 0;
    terminate = 0;
    execute_next = execute_current;
    if(current == EXECUTE)
    begin
        case(execute_current)
        ADDR2MAR:
        begin
            execute_next = MEM2MBR;
        end
        MEM2MBR:
        begin
            execute_next = MBR2AC;//end
        end

        AC2MBR:
        begin
            execute_next = ST_ADDR2MAR;
        end
        ST_ADDR2MAR:
        begin
            execute_next = MBR2MEM;
        end        
        // STORE_MAR_MBR:
        // begin
        //     execute_next = MBR2MEM;//end
        // end


        MBR2AC, MBR2MEM, PCINC, IDLE, ADDR2PC, AC2OUT, IN2AC:
        begin
            execute_done = 1;
        end
        EXIT:
        begin
            terminate = 1;
        end

        endcase
    end
    else if(next == EXECUTE)
    begin
        if(instr==LOAD)
        begin
            execute_next = ADDR2MAR;
        end
        else if(instr == STORE)
        begin
            execute_next = AC2MBR;
        end
        else if(instr == ADD)
        begin
            execute_next = ADDR2MAR;
        end
        else if(instr == SUBT)
        begin
            execute_next = ADDR2MAR;
        end
        else if(instr == INPUT)
        begin
            execute_next = IN2AC;
        end
        else if(instr == OUTPUT)
        begin
            execute_next = AC2OUT;
        end
        else if(instr == HALT)
        begin
            execute_next = EXIT;
        end
        else if(instr == SKIPCOND)
        begin
            execute_next = IDLE;
            if(skip_type==0)
            begin
                if(ac_lst)
                begin
                    execute_next = PCINC;
                end
            end
            else if(skip_type==1)
            begin
                if(ac_zero)
                begin
                    execute_next = PCINC;
                end
            end
            else if(skip_type==2)
            begin
                if(!(ac_lst&&ac_zero))
                begin
                    execute_next = PCINC;
                end
            end
            else if(skip_type==3)
            begin
                if(!(ac_zero))
                begin
                    execute_next = PCINC;
                end
            end
        end
        else if(JUMP)
        begin
            execute_next = ADDR2PC;
        end
        else
        begin
            execute_next = IDLE;
        end
    end
    
end

always@(*)
begin
    ir_reg_rden=0; 
    out_reg_rden=0;
    in_reg_rden=0;
    ac_reg_rden=0;
    mbr_reg_rden=0;
    pc_count_rden=0;
    mar_reg_rden=0;
    mem_rden=0;
    ir_reg_wren=0;
    out_reg_wren=0;
    in_reg_wren=0;
    ac_reg_wren=0;
    mbr_reg_wren=0;
    pc_count_wren=0;
    pc_count_inc=0;
    mar_reg_wren=0;
    mem_wren=0;

    alu_op = 0;

    case(instr)
        LOAD: alu_op = 0;
        ADD: alu_op = 1;
        SUBT: alu_op = 2;
        default: alu_op = 0;
    endcase

    case(current)
    CPU_IDLE:
    begin

    end
    FETCH:
    begin
        case(fetch_current)
        FETCH_MAR:
        begin
            pc_count_rden = 1;
            mar_reg_wren = 1;
        end
        READ_UPDATE:
        begin
            ir_reg_wren = 1;
            mem_rden = 1;
            pc_count_inc = 1;
        end
        endcase
    end
    DECODE:
    begin
        mar_reg_wren = 1;
        ir_reg_rden = 1;
    end
    EXECUTE:
    begin
        case(execute_current)
            ADDR2MAR,ST_ADDR2MAR:
            begin
                mar_reg_wren = 1;
                ir_reg_rden = 1;
            end
            MEM2MBR:
            begin
                mem_rden = 1;
                mbr_reg_wren = 1;
            end
            MBR2AC:
            begin
                ac_reg_wren = 1;
                mbr_reg_rden = 1;
            end
            AC2MBR:
            begin
                mbr_reg_wren = 1;
                ac_reg_rden = 1;
            end
            MBR2MEM:
            begin
                mem_wren = 1;
                mbr_reg_rden = 1;
            end
            IN2AC:
            begin
                in_reg_rden= 1;
                ac_reg_wren = 1;
            end
            AC2OUT:
            begin
                ac_reg_rden = 1;
                out_reg_wren = 1;
            end
            PCINC:
            begin
                pc_count_inc = 1;
            end
            ADDR2PC:
            begin
                pc_count_wren = 1;
                ir_reg_rden = 1;
            end
        endcase
    end
    endcase
end


endmodule