module divider 
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
    rdy,
    merchant,
    remainder
    );

    input clk;
    input rst_n;
    input data_rdy;

    input [N-1:0] dividend;
    input [M-1:0] divisor;

    output         rdy;
    output [N-1:0] merchant;
    output [N-1:0] remainder;

    wire [N-1:0] dividend_r [N-1:0];
    wire [N-1:0] divisor_r [N-1:0];
    wire [N-1:0] merchant_r [N-1:0];
    wire [N-1:0] remainder_r [N-1:0];
    wire [N-1:0] rdy_r;

    divider_cell   #(.M(M), .N(N))
    divider_cell_inst0
    (
        .clk                (clk),
        .rst_n              (rst_n),
        .data_rdy           (data_rdy),
        .dividend           ({{(M){1'b0}}, dividend[N-1]}),
        .divisor            (divisor),
        .merchant_ci        ({(N){1'b0}}),
        .dividend_ci        (dividend),
        .rdy                (rdy_r[0]),
        .dividend_kp        (dividend_r[0]),
        .divisor_kp         (divisor_r[0]),
        .merchant           (merchant_r[0]),
        .remainder          (remainder_r[0])
    );


genvar i;
generate
    for (i=0; i<N-1; i=i+1) begin : for_x
        divider_cell   #(.M(M), .N(N))
        divider_cell_instx
        (
            .clk                (clk),
            .rst_n              (rst_n),
            .data_rdy           (rdy_r[i]),
            .dividend           ({remainder_r[i], dividend_r[i][N-2-i]}),
            .divisor            (divisor_r[i]),
            .merchant_ci        (merchant_r[i]),
            .dividend_ci        (dividend_r[i]),
            .rdy                (rdy_r[i+1]),
            .dividend_kp        (dividend_r[i+1]),
            .divisor_kp         (divisor_r[i+1]),
            .merchant           (merchant_r[i+1]),
            .remainder          (remainder_r[i+1])
        );    
    end
endgenerate

assign rdy = rdy_r[N-1];
assign merchant = merchant_r[N-1];
assign remainder = remainder_r[N-1];

endmodule