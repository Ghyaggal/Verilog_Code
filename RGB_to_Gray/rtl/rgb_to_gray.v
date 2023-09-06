module rgb_to_gray (
    TFT_rgb,
    sel,
    TFT_gray
);

input [15:0] TFT_rgb;
input [2:0] sel;
output reg [15:0] TFT_gray;

always @(*) begin
    case (sel)
        0: TFT_gray = TFT_rgb;
        1: TFT_gray = {TFT_rgb[15:11], TFT_rgb[15:11], 1'b0, TFT_rgb[15:11]}; //red
        2: TFT_gray = {TFT_rgb[10:6], TFT_rgb[10:5], TFT_rgb[10:6]}; //green
        3: TFT_gray = {TFT_rgb[4:0], TFT_rgb[4:0], 1'b0, TFT_rgb[4:0]}; //blue
        default: TFT_gray = TFT_rgb;
    endcase
end

endmodule