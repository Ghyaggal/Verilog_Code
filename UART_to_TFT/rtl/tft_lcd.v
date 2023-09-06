module tft_lcd (
    clk_33M,
    rst_n,
    Data_in,

    Hcount,
    Vcount,

    TFT_de,
    TFT_hs,
    TFT_vs,
    TFT_clk,
    TFT_rgb,
    TFT_pwm,

    TFT_begin
);

input clk_33M;
input rst_n;
input [15:0] Data_in;

output [11:0] Hcount;
output [11:0] Vcount;

output TFT_de;
output TFT_hs;
output TFT_vs;
output TFT_clk;
output [15:0] TFT_rgb;
output TFT_pwm;

output reg TFT_begin;

//TFT行、场扫描时序参数表
parameter tft_hs_end = 10'd1,
            hdat_begin = 10'd46,
                hdat_end   = 10'd846,
                hpixel_end = 12'd1056,
                tft_vs_end = 10'd1,
                vdat_begin = 10'd24,
                vdat_end   = 10'd504,
                vline_end  = 10'd524;

reg [11:0] Hcount_r;
reg [11:0] Vcount_r;

wire dat_ack;


assign TFT_clk = clk_33M;
assign TFT_pwm = rst_n;
assign TFT_hs = (Hcount_r > tft_hs_end);
assign TFT_vs = (Vcount_r > tft_vs_end);
assign Hcount = TFT_de?(Hcount_r-hdat_begin):12'd0;
assign Vcount = TFT_de?(Vcount_r-vdat_begin):12'd0;
assign TFT_de = dat_ack;
assign dat_ack = ((Hcount_r >= hdat_begin) && (Hcount_r < hdat_end)) &&
                    ((Vcount_r >= vdat_begin) && (Vcount_r < vdat_end));

assign TFT_rgb = dat_ack?Data_in:16'd0;

always @(posedge clk_33M or negedge rst_n) begin
    if (!rst_n)
        Hcount_r <= 12'd0;
    else if (Hcount_r == hpixel_end)
        Hcount_r <= 12'd0;
    else 
        Hcount_r <= Hcount_r + 1'b1;
end

always @(posedge clk_33M or negedge rst_n) begin
    if (!rst_n)
        Vcount_r <= 12'd0;
    else if (Hcount_r == hpixel_end) begin
        if (Vcount_r == vline_end)
            Vcount_r <= 12'd0;
        else 
            Vcount_r <= Vcount_r + 1'b1;
    end
    else
        Vcount_r <= Vcount_r;
end

always @(posedge clk_33M or negedge rst_n) begin
    if (!rst_n)
        TFT_begin <= 1'b0;
    else if ((Hcount_r == 0) && (Vcount_r == 0))
        TFT_begin <= 1'b1;
    else
        TFT_begin <= 1'b0;
end

endmodule