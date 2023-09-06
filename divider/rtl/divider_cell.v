module divider_cell 
#(
    parameter N = 5,
    parameter M = 3
)
(
    clk,
    rst_n,
    data_rdy,
    dividend,
    divisor,
    merchant_ci,
    dividend_ci,
    rdy,
    dividend_kp,
    divisor_kp,
    merchant,
    remainder
    );

    input clk;
    input rst_n;
    input data_rdy;

    input [M:0] dividend;
    input [M-1:0] divisor;
    input [N-1:0] merchant_ci;
    input [N-1:0] dividend_ci;

    output reg rdy;
    output reg [N-1:0] dividend_kp;
    output reg [N-1:0] divisor_kp;
    output reg [N-1:0] merchant;    //商
    output reg [N-1:0] remainder;    //余数

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdy         <= 'b0;
            dividend_kp <= 'b0;
            divisor_kp  <= 'b0;
            merchant    <= 'b0;
            remainder    <= 'b0;
        end else if (data_rdy) begin
            rdy <= 1'b1;
            dividend_kp <= dividend_ci;
            divisor_kp  <= divisor;

            if (dividend >= divisor) begin
                remainder <= dividend - divisor;
                merchant <= (merchant_ci << 1) + 1'b1;
            end else begin
                remainder <= dividend;
                merchant <= (merchant_ci << 1);            
            end
        end else begin
            rdy         <= 'b0;
            dividend_kp <= 'b0;
            divisor_kp  <= 'b0;
            merchant    <= 'b0;
            remainder    <= 'b0;
        end
    end


endmodule