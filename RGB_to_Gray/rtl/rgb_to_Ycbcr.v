module rgb_to_Ycbcr (
    clk,
    
    i_r_8b,
    i_g_8b,
    i_b_8b,

    i_h_sync,
    i_v_sync,
    i_data_en,

    o_Y_8b,
    o_cb_8b,
    o_cr_8b,

    o_h_sync,
    o_v_sync,
    o_data_en
);


parameter para_0183_10b = 10'd47;
parameter para_0614_10b = 10'd157;
parameter para_0062_10b = 10'd16;
parameter para_0101_10b = 10'd26;
parameter para_0338_10b = 10'd86;
parameter para_0439_10b = 10'd112;
parameter para_0399_10b = 10'd102;
parameter para_0040_10b = 10'd10;
parameter para_16_18b = 18'd4096;
parameter para_128_18b = 18'd32768;

input clk;

input [7:0] i_r_8b;
input [7:0] i_g_8b;
input [7:0] i_b_8b;

input i_h_sync;
input i_v_sync;
input i_data_en;

output [7:0] o_Y_8b;
output [7:0] o_cb_8b;
output [7:0] o_cr_8b;

output o_h_sync;
output o_v_sync;
output o_data_en;

reg [17:0] mult_r_for_Y_18b, mult_r_for_cb_18b, mult_r_for_cr_18b;
reg [17:0] mult_g_for_Y_18b, mult_g_for_cb_18b, mult_g_for_cr_18b;
reg [17:0] mult_b_for_Y_18b, mult_b_for_cb_18b, mult_b_for_cr_18b;

reg [17:0] add_Y_0_18b, add_cb_0_18b, add_cr_0_18b;
reg [17:0] add_Y_1_18b, add_cb_1_18b, add_cr_1_18b;

reg [17:0] result_Y_18b, result_cb_18b, result_cr_18b;

reg [9:0] Y_tmp, cb_tmp, cr_tmp;

wire sign_cb, sign_cr;

reg i_h_sync_reg1, i_h_sync_reg2, i_h_sync_reg3;
reg i_v_sync_reg1, i_v_sync_reg2, i_v_sync_reg3;
reg i_data_en_reg1, i_data_en_reg2, i_data_en_reg3;

initial begin
    mult_r_for_Y_18b <= 18'd0;
    mult_r_for_cb_18b <= 18'd0;
    mult_r_for_cr_18b <= 18'd0;

    mult_g_for_Y_18b <= 18'd0;
    mult_g_for_cb_18b <= 18'd0;
    mult_g_for_cr_18b <= 18'd0;

    mult_b_for_Y_18b <= 18'd0;
    mult_b_for_cb_18b <= 18'd0;
    mult_b_for_cr_18b <= 18'd0;

    add_Y_0_18b <= 18'd0;
    add_cb_0_18b <= 18'd0;
    add_cr_0_18b <= 18'd0;

    add_Y_1_18b <= 18'd0;
    add_cb_1_18b <= 18'd0;
    add_cr_1_18b <= 18'd0;

    result_Y_18b <= 18'd0;
    result_cb_18b <= 18'd0;
    result_cr_18b <= 18'd0;    

    i_h_sync_reg1 <= 18'd0;
    i_h_sync_reg2 <= 18'd0;
    i_h_sync_reg3 <= 18'd0;    

    i_v_sync_reg1 <= 18'd0;
    i_v_sync_reg2 <= 18'd0;
    i_v_sync_reg3 <= 18'd0;   

    i_data_en_reg1 <= 18'd0;
    i_data_en_reg2 <= 18'd0;
    i_data_en_reg3 <= 18'd0;   
end

always @(posedge clk) begin
    i_h_sync_reg1 <= i_h_sync;
    i_h_sync_reg2 <= i_h_sync_reg1;
    i_h_sync_reg3 <= i_h_sync_reg2;

    i_v_sync_reg1 <= i_v_sync;
    i_v_sync_reg2 <= i_v_sync_reg1;
    i_v_sync_reg3 <= i_v_sync_reg2;

    i_data_en_reg1 <= i_data_en;
    i_data_en_reg2 <= i_data_en_reg1;
    i_data_en_reg3 <= i_data_en_reg2;
end


always @(posedge clk) begin
    mult_r_for_Y_18b <= i_r_8b * para_0183_10b;
    mult_r_for_cb_18b <= i_r_8b * para_0101_10b;
    mult_r_for_cr_18b <= i_r_8b * para_0439_10b;
end

always @(posedge clk) begin
    mult_g_for_Y_18b <= i_g_8b * para_0614_10b;
    mult_g_for_cb_18b <= i_g_8b * para_0338_10b;
    mult_g_for_cr_18b <= i_g_8b * para_0399_10b;
end

always @(posedge clk) begin
    mult_b_for_Y_18b <= i_b_8b * para_0062_10b;
    mult_b_for_cb_18b <= i_b_8b * para_0439_10b;
    mult_b_for_cr_18b <= i_b_8b * para_0040_10b;
end

always @(posedge clk) begin
    add_Y_0_18b <= mult_r_for_Y_18b + mult_g_for_Y_18b;
    add_Y_1_18b <= mult_b_for_Y_18b + para_16_18b;

    add_cb_0_18b <= mult_b_for_cb_18b + para_128_18b;
    add_cb_1_18b <= mult_r_for_cb_18b + mult_g_for_cb_18b;

    add_cr_0_18b <= mult_r_for_cr_18b + para_128_18b;
    add_cr_1_18b <= mult_g_for_cr_18b + mult_b_for_cr_18b;
end

assign sign_cb = (add_cb_0_18b >= add_cb_1_18b);
assign sign_cr = (add_cr_0_18b >= add_cr_1_18b);

always @(posedge clk) begin
    result_Y_18b <= add_Y_0_18b + add_Y_1_18b;
    result_cb_18b <= sign_cb ? (add_cb_0_18b - add_cb_1_18b) : 18'd0;
    result_cr_18b <= sign_cr ? (add_cr_0_18b - add_cr_1_18b) : 18'd0;
end

always @(posedge clk) begin
    Y_tmp <= result_Y_18b[17:8] + {9'd0, result_Y_18b[7]};
    cb_tmp <= result_cb_18b[17:8] + {9'd0, result_cb_18b[7]};
    cr_tmp <= result_cr_18b[17:8] + {9'd0, result_cr_18b[7]};
end

assign o_Y_8b = (Y_tmp[9:8] == 2'b00) ? Y_tmp[7:0] : 8'hFF;
assign o_cb_8b = (cb_tmp[9:8] == 2'b00) ? cb_tmp[7:0] : 8'hFF;
assign o_cr_8b = (cr_tmp[9:8] == 2'b00) ? cr_tmp[7:0] : 8'hFF;

assign o_h_sync = i_h_sync_reg3;
assign o_v_sync = i_v_sync_reg3;
assign o_data_en = i_data_en_reg3;

endmodule