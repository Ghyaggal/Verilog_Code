`timescale 1ns/1ps

module butterfly (
    clk,
    rst_n,
    en,
    xp_real,
    xp_imag,
    xq_real,
    xq_imag,
    factor_real,
    factor_imag,
    valid,
    yp_real,
    yp_imag,
    yq_real,
    yq_imag
);

input clk;
input rst_n;
input en;
input signed [23:0] xp_real;
input signed [23:0] xp_imag;
input signed [23:0] xq_real;
input signed [23:0] xq_imag;
input signed [15:0] factor_real;
input signed [15:0] factor_imag;

output valid;
output signed [23:0] yp_real;
output signed [23:0] yp_imag;
output signed [23:0] yq_real;
output signed [23:0] yq_imag;

reg [2:0] en_r;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_r <= 3'd0;
    end else begin
        en_r <= {en_r[1:0], en};
    end
end

wire signed [39:0] xq_wnr_real0_r;
wire signed [39:0] xq_wnr_real1_r;
wire signed [39:0] xq_wnr_imag0_r;
wire signed [39:0] xq_wnr_imag1_r;
reg signed [39:0] xq_wnr_real0;
reg signed [39:0] xq_wnr_real1;
reg signed [39:0] xq_wnr_imag0;
reg signed [39:0] xq_wnr_imag1;
reg signed [39:0] xp_real_d;
reg signed [39:0] xp_imag_d;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xp_real_d <= 40'd0;
        xp_imag_d <= 40'd0;
        xq_wnr_real0 <= 40'd0;
        xq_wnr_real1 <= 40'd0;
        xq_wnr_imag0 <= 40'd0;
        xq_wnr_imag1 <= 40'd0;
    end else if (en) begin
        xq_wnr_real0 <= xq_real * factor_real;
        xq_wnr_real1 <= xq_imag * factor_imag;
        xq_wnr_imag0 <= xq_real * factor_imag;
        xq_wnr_imag1 <= xq_imag * factor_real;

        xp_real_d <= {{4{xp_real[23]}}, xp_real[22:0], 13'd0};
        xp_imag_d <= {{4{xp_imag[23]}}, xp_imag[22:0], 13'd0};
    end
end

reg signed [39:0] xp_real_d1;
reg signed [39:0] xp_imag_d1;
reg signed [39:0] xq_wnr_real;
reg signed [39:0] xq_wnr_imag;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xp_real_d1 <= 40'd0;
        xp_imag_d1 <= 40'd0;
        xq_wnr_real <= 40'd0;
        xq_wnr_imag <= 40'd0;
    end else if (en_r[0]) begin
        xp_real_d1 <= xp_real_d;
        xp_imag_d1 <= xp_imag_d;
        xq_wnr_real <= xq_wnr_real0 - xq_wnr_real1;
        xq_wnr_imag <= xq_wnr_imag0 + xq_wnr_imag1;
    end
end

reg signed [39:0] yp_real_r;
reg signed [39:0] yp_imag_r;
reg signed [39:0] yq_real_r;
reg signed [39:0] yq_imag_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yp_real_r <= 40'd0;
        yp_imag_r <= 40'd0;
        yq_real_r <= 40'd0;
        yq_imag_r <= 40'd0;
    end else if (en_r[1]) begin
        yp_real_r <= xp_real_d1 + xq_wnr_real;
        yp_imag_r <= xp_imag_d1 + xq_wnr_imag;
        yq_real_r <= xp_real_d1 - xq_wnr_real;
        yq_imag_r <= xp_imag_d1 - xq_wnr_imag;
    end
end

assign yp_real = {yp_real_r[39], yp_real_r[13+23:13]};
assign yp_imag = {yp_imag_r[39], yp_imag_r[13+23:13]};
assign yq_real = {yq_real_r[39], yq_real_r[13+23:13]};
assign yq_imag = {yq_imag_r[39], yq_imag_r[13+23:13]};
assign valid = en_r[2];

endmodule








