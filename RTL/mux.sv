
module mux#(parameter SEL_WIDTH = 8, WIDTH = 16)
(
    input   logic   [SEL_WIDTH-1:0]         sel,
    input   logic   [(WIDTH*SEL_WIDTH)-1:0] in,
    output  logic   [WIDTH-1:0]             out
);

    logic   [(WIDTH*SEL_WIDTH)-1:0] in_sel;
    logic   [(WIDTH*SEL_WIDTH)-1:0] orx;

    // logic   []

    logic [SEL_WIDTH-1:0] grant;
    logic [SEL_WIDTH-2:0] ors;
    always@(*)
    begin
        grant = 0;
        ors = 0;
        
        if(sel[SEL_WIDTH-1])
        begin
            grant[SEL_WIDTH-1] = 1;
        end
        else
        begin
        for(int i = (SEL_WIDTH-2); i>=0; i--)//1 0
        begin
                // grant[i] = sel[i]&; 
                if(i == (SEL_WIDTH-2))
                begin
                    ors[i] = sel[i+1];
                end 
                else
                begin
                    ors[i] = ors[i+1]|sel[i+1];
                end
                grant[i] = !ors[i] & sel[i];
        end
        end
    end


    always@(*)
    begin
        for(int i = 0;i<SEL_WIDTH;i++)
        begin
            in_sel[(WIDTH*i)+:WIDTH] = in[(WIDTH*i)+:WIDTH] & {WIDTH{grant[i]}};
        end
        // out[0] = orx[SEL_WIDTH-1];
        for(int i = 0;i<WIDTH;i++)
        begin
            // out[i] = 
            orx[SEL_WIDTH*i] = in_sel[i];
            for(int x = 1;x<SEL_WIDTH;x++)
            begin
                orx[SEL_WIDTH*i+x] = orx[SEL_WIDTH*i+(x-1)] | in_sel[i+(WIDTH*x)];
            end
            out[i] = orx[(i+1)*SEL_WIDTH-1];
        end

    end
endmodule