module UART_to_TFT (
    clk,
    rst_n,
    Rs232_rx,
    
    sd_clk,
    sd_SA,
    sd_BA,
    sd_CKE,
    sd_CS_N,
    sd_RAS_N,
    sd_CAS_N,
    sd_WE_N,
    sd_Dq,
    sd_Dqm,

    TFT_de,
    TFT_hs,
    TFT_vs,
    TFT_clk,
    TFT_gray,
    TFT_pwm
);

parameter img_h = 800;
parameter img_v = 480;
parameter img_data_byte = img_h*img_v;

input clk;
input rst_n;
input Rs232_rx;

output sd_clk;
output [12:0] sd_SA;
output [1:0] sd_BA;
output sd_CKE;
output sd_CS_N;
output sd_RAS_N;
output sd_CAS_N;
output sd_WE_N;
inout [15:0] sd_Dq;
output [1:0] sd_Dqm;

output TFT_de;
output TFT_hs;
output TFT_vs;
output TFT_clk;
output [15:0] TFT_gray;
output TFT_pwm;

wire clk_50M;
wire clk_33M;
wire clk_100M;

pll	pll_inst (
	.areset ( !rst_n ),
	.inclk0 ( clk ),
	.c0 ( clk_50M ),
	.c1 ( clk_33M ),
	.c2 ( clk_100M ),
	.c3 ( sd_clk )
	);


wire [7:0] Data_Byte;
wire Rx_Done;
uart_rx uart_rx_inst(
    .clk(clk_50M),
    .rst_n(rst_n),
    .uart_rxd(Rs232_rx),
    .baud_set(0),

    .data(Data_Byte),
    .Rx_Done(Rx_Done),
    .uart_state()
);

wire TFT_de_r;
wire TFT_hs_r;
wire TFT_vs_r;

wire [15:0] rd_data;
wire TFT_begin;
reg [1:0]tft_begin_r;	
always@(posedge clk_100M)
        tft_begin_r <= {tft_begin_r[0],TFT_begin};

wire [15:0] TFT_rgb;
tft_lcd tft_lcd_inst(
    .clk_33M(clk_33M),
    .rst_n(rst_n),
    .Data_in({rd_data[7:0], rd_data[15:8]}),

    .Hcount(),
    .Vcount(),

    .TFT_de(TFT_de),
    .TFT_hs(TFT_hs),
    .TFT_vs(TFT_vs),
    .TFT_clk(TFT_clk),
    .TFT_rgb(TFT_rgb),
    .TFT_pwm(TFT_pwm),

    .TFT_begin(TFT_begin)
);

wire [7:0] o_Y_8b;
wire [7:0] o_cb_8b;
wire [7:0] o_cr_8b;

// wire TFT_hs_reg, TFT_vs_reg, TFT_de_reg;

// rgb_to_Ycbcr rgb_to_Ycbcr_inst(
//     .clk(clk_50M),
    
//     .i_r_8b({3'd0, TFT_rgb[15:11]}),
//     .i_g_8b({2'd0, TFT_rgb[10:5]}),
//     .i_b_8b({3'd0, TFT_rgb[4:0]}),

//     .i_h_sync(TFT_hs_r),
//     .i_v_sync(TFT_vs_r),
//     .i_data_en(TFT_de_r),

//     .o_Y_8b(o_Y_8b),
//     .o_cb_8b(o_cb_8b),
//     .o_cr_8b(o_cr_8b),

//     .o_h_sync(TFT_hs_reg),
//     .o_v_sync(TFT_vs_reg),
//     .o_data_en(TFT_de_reg)
// );

 wire [15:0] TFT_gray_r;

// Ycbcr_to_gray Ycbcr_to_gray_inst(
//     .o_Y_8b(o_Y_8b),
//     .o_cb_8b(o_cb_8b),
//     .o_cr_8b(o_cr_8b),

//     .TFT_gray(TFT_gray_r)
// );

rgb_to_gray rgb_to_gray_inst(
    .TFT_rgb(TFT_rgb),
    .sel(1),
    .TFT_gray(TFT_gray)
);

sdram_ctrl_top sdram_ctrl_top_inst(
    .clk_100m(clk_100M),
    .rst_n(rst_n),
    .sd_clk(sd_clk),

    .wr_data(Data_Byte),
    .wr_en(Rx_Done),
    .wr_addr(0),
    .wr_max_addr(img_data_byte),
    .wr_load(!rst_n),
    .wr_clk(clk_50M),
    .wr_full(),
    .wr_use(),

    .rd_data(rd_data),
    .rd_en(TFT_de),
    .rd_addr(0),
    .rd_max_addr(img_data_byte),
    .rd_load(tft_begin_r[1]),
    .rd_clk(clk_33M),
    .rd_empty(),
    .rd_use(),

    .SA(sd_SA),
    .BA(sd_BA),
    .CS_N(sd_CS_N),
    .CKE(sd_CKE),
    .RAS_N(sd_RAS_N),
    .CAS_N(sd_CAS_N),
    .WE_N(sd_WE_N),
    .Dq(sd_Dq),
    .Dqm(sd_Dqm)
);

endmodule