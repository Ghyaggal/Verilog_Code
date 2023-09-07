module mult 
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
    result,
    rdy
    );

    input               clk;
    input               rst_n;
    input               en;

    input [N-1:0]       mult1;
    input [M-1:0]       mult2;

    output [N+M-1:0]    result;
    output              rdy;

    wire   [M-1:0]      rdy_data;
    wire   [N+M-1:0]    mult1_data      [M-1:0];
    wire   [M-1:0]      mult2_data      [M-1:0];
    wire   [N+M-1:0]    mult_acci_data  [M-1:0];

    mult_cell #(.N(N), .M(M))
    mult_cell_inst0
    (
        .clk            (clk),
        .rst_n          (rst_n),
        .en             (en),
        .mult1          ({{{(M){1'b0}}},mult1}),
        .mult2          (mult2),
        .mult_acci      ({(N+M){1'b0}}),
        .rdy            (rdy_data[0]),
        .mult1_o        (mult1_data[0]),
        .mult2_o        (mult2_data[0]),
        .mult_acci_o    (mult_acci_data[0])
    );


    genvar i;
    generate
        for (i=0; i<M-1; i=i+1) begin : mult_stepx
            mult_cell #(.N(N), .M(M))
            mult_cell_instx
            (
                .clk            (clk),
                .rst_n          (rst_n),
                .en             (rdy_data[i]),
                .mult1          (mult1_data[i]),
                .mult2          (mult2_data[i]),
                .mult_acci      (mult_acci_data[i]),
                .rdy            (rdy_data[i+1]),
                .mult1_o        (mult1_data[i+1]),
                .mult2_o        (mult2_data[i+1]),
                .mult_acci_o    (mult_acci_data[i+1])
            );
        end
    endgenerate

assign result = mult_acci_data[M-1];
assign rdy    = rdy_data[M-1];

endmodule