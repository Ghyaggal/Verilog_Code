module mult_cell 
#(
    parameter N = 4,
    parameter M = 4
)
(
    clk,
    rst_n,
    en,
    mult1,
    mult2,
    mult_acci,
    rdy,
    mult1_o,
    mult2_o,
    mult_acci_o
    );


    input                   clk;
    input                   rst_n;
    input                   en;
    
    input [N+M-1:0]         mult1;
    input [M-1:0]           mult2;
    input [N+M-1:0]         mult_acci;

    output reg rdy;
    output reg [N+M-1:0]    mult1_o;
    output reg [M-1:0]      mult2_o;
    output reg [N+M-1:0]    mult_acci_o;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdy             <= 'b0;
            mult1_o         <= 'b0;
            mult2_o         <= 'b0;
            mult_acci_o     <= 'b0;
        end else if (en) begin
            rdy             <=  1'b1;
            mult1_o         <=  mult1 << 1;
            mult2_o         <=  mult2 >> 1;
            if (mult2[0]) begin
                mult_acci_o <=  mult_acci + mult1;
            end else begin
                mult_acci_o <=  mult_acci;
            end
        end else begin
            rdy             <= 'b0;
            mult1_o         <= 'b0;
            mult2_o         <= 'b0;
            mult_acci_o     <= 'b0;       
        end
    end


endmodule