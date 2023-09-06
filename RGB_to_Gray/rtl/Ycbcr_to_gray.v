module Ycbcr_to_gray (
    o_Y_8b,
    o_cb_8b,
    o_cr_8b,

    TFT_gray
);

input [7:0] o_Y_8b;
input [7:0] o_cb_8b;
input [7:0] o_cr_8b;

output [15:0] TFT_gray;

assign TFT_gray = {o_Y_8b[5:1], o_Y_8b[5:0], o_Y_8b[5:1]};

endmodule