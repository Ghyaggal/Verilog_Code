`timescale 1ns/100ps
module FFT_tb ;
reg      clk;
reg      rstn;
reg      en ;

reg signed [23:0]  x0_real;
reg signed [23:0]  x0_imag;
reg signed [23:0]  x1_real;
reg signed [23:0]  x1_imag;
reg signed [23:0]  x2_real;
reg signed [23:0]  x2_imag;
reg signed [23:0]  x3_real;
reg signed [23:0]  x3_imag;
reg signed [23:0]  x4_real;
reg signed [23:0]  x4_imag;
reg signed [23:0]  x5_real;
reg signed [23:0]  x5_imag;
reg signed [23:0]  x6_real;
reg signed [23:0]  x6_imag;
reg signed [23:0]  x7_real;
reg signed [23:0]  x7_imag;

wire valid;
wire signed [23:0]  y0_real;
wire signed [23:0]  y0_imag;
wire signed [23:0]  y1_real;
wire signed [23:0]  y1_imag;
wire signed [23:0]  y2_real;
wire signed [23:0]  y2_imag;
wire signed [23:0]  y3_real;
wire signed [23:0]  y3_imag;
wire signed [23:0]  y4_real;
wire signed [23:0]  y4_imag;
wire signed [23:0]  y5_real;
wire signed [23:0]  y5_imag;
wire signed [23:0]  y6_real;
wire signed [23:0]  y6_imag;
wire signed [23:0]  y7_real;
wire signed [23:0]  y7_imag;

initial begin
    clk = 0; //50MHz
    rstn = 0 ;
    #10 rstn = 1;
    forever begin
        #10 clk = ~clk; //50MHz
    end
end

FFT FFT_inst(
    .clk(clk),
    .rst_n(rstn),
    .en(en),
    .input_x_reg0(x0_real),
    .input_x_img0(x0_imag),
    .input_x_reg1(x1_real),
    .input_x_img1(x1_imag),
    .input_x_reg2(x2_real),
    .input_x_img2(x2_imag),
    .input_x_reg3(x3_real),
    .input_x_img3(x3_imag),
    .input_x_reg4(x4_real),
    .input_x_img4(x4_imag),
    .input_x_reg5(x5_real),
    .input_x_img5(x5_imag),
    .input_x_reg6(x6_real),
    .input_x_img6(x6_imag),
    .input_x_reg7(x7_real),
    .input_x_img7(x7_imag),  
    .valid(valid),
    .output_y_reg0(y0_real),
    .output_y_img0(y0_imag),
    .output_y_reg1(y1_real),
    .output_y_img1(y1_imag),
    .output_y_reg2(y2_real),
    .output_y_img2(y2_imag),
    .output_y_reg3(y3_real),
    .output_y_img3(y3_imag),
    .output_y_reg4(y4_real),
    .output_y_img4(y4_imag),
    .output_y_reg5(y5_real),
    .output_y_img5(y5_imag),
    .output_y_reg6(y6_real),
    .output_y_img6(y6_imag),
    .output_y_reg7(y7_real),
    .output_y_img7(y7_imag)
);

    //dinput
    initial     begin
        en = 0 ;
        x0_real = 24'd10;
        x1_real = 24'd20;
        x2_real = 24'd30;
        x3_real = 24'd40;
        x4_real = 24'd10;
        x5_real = 24'd20;
        x6_real = 24'd30;
        x7_real = 24'd40;

        x0_imag = 24'd0;
        x1_imag = 24'd0;
        x2_imag = 24'd0;
        x3_imag = 24'd0;
        x4_imag = 24'd0;
        x5_imag = 24'd0;
        x6_imag = 24'd0;
        x7_imag = 24'd0;
        @(negedge clk) ;
        en = 1 ;
        forever begin
            @(negedge clk) ;
            x0_real = (x0_real > 22'h3F_ffff) ? 'b0 : x0_real + 1 ;
            x1_real = (x1_real > 22'h3F_ffff) ? 'b0 : x1_real + 1 ;
            x2_real = (x2_real > 22'h3F_ffff) ? 'b0 : x2_real + 31 ;
            x3_real = (x3_real > 22'h3F_ffff) ? 'b0 : x3_real + 1 ;
            x4_real = (x4_real > 22'h3F_ffff) ? 'b0 : x4_real + 23 ;
            x5_real = (x5_real > 22'h3F_ffff) ? 'b0 : x5_real + 1 ;
            x6_real = (x6_real > 22'h3F_ffff) ? 'b0 : x6_real + 6 ;
            x7_real = (x7_real > 22'h3F_ffff) ? 'b0 : x7_real + 1 ; 
            x0_imag = (x0_imag > 22'h3F_ffff) ? 'b0 : x0_imag + 2 ;
            x1_imag = (x1_imag > 22'h3F_ffff) ? 'b0 : x1_imag + 5 ;
            x2_imag = (x2_imag > 22'h3F_ffff) ? 'b0 : x2_imag + 3 ;
            x3_imag = (x3_imag > 22'h3F_ffff) ? 'b0 : x3_imag + 6 ;
            x4_imag = (x4_imag > 22'h3F_ffff) ? 'b0 : x4_imag + 4 ;
            x5_imag = (x5_imag > 22'h3F_ffff) ? 'b0 : x5_imag + 8 ;
            x6_imag = (x6_imag > 22'h3F_ffff) ? 'b0 : x6_imag + 11 ;
            x7_imag = (x7_imag > 22'h3F_ffff) ? 'b0 : x7_imag + 7 ;
        end
    end

//finish simulation
    initial #1000   $finish ;
endmodule