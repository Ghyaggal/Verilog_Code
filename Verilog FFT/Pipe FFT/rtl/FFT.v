module FFT (
    clk,
    rst_n,
    en,
    input_x_reg0,
    input_x_img0,
    input_x_reg1,
    input_x_img1,
    input_x_reg2,
    input_x_img2,
    input_x_reg3,
    input_x_img3,
    input_x_reg4,
    input_x_img4,
    input_x_reg5,
    input_x_img5,
    input_x_reg6,
    input_x_img6,
    input_x_reg7,
    input_x_img7,  
    valid,
    output_y_reg0,
    output_y_img0,
    output_y_reg1,
    output_y_img1,
    output_y_reg2,
    output_y_img2,
    output_y_reg3,
    output_y_img3,
    output_y_reg4,
    output_y_img4,
    output_y_reg5,
    output_y_img5,
    output_y_reg6,
    output_y_img6,
    output_y_reg7,
    output_y_img7
);

input clk;
input rst_n;
input en;
input [23:0] input_x_reg0;
input [23:0] input_x_img0;
input [23:0] input_x_reg1;
input [23:0] input_x_img1;
input [23:0] input_x_reg2;
input [23:0] input_x_img2;
input [23:0] input_x_reg3;
input [23:0] input_x_img3;
input [23:0] input_x_reg4;
input [23:0] input_x_img4;
input [23:0] input_x_reg5;
input [23:0] input_x_img5;
input [23:0] input_x_reg6;
input [23:0] input_x_img6;
input [23:0] input_x_reg7;
input [23:0] input_x_img7;

output valid;
output [23:0] output_y_reg0;
output [23:0] output_y_img0;
output [23:0] output_y_reg1;
output [23:0] output_y_img1;
output [23:0] output_y_reg2;
output [23:0] output_y_img2;
output [23:0] output_y_reg3;
output [23:0] output_y_img3;
output [23:0] output_y_reg4;
output [23:0] output_y_img4;
output [23:0] output_y_reg5;
output [23:0] output_y_img5;
output [23:0] output_y_reg6;
output [23:0] output_y_img6;
output [23:0] output_y_reg7;
output [23:0] output_y_img7;

//factor, multiplied by 0x2000
wire signed [15:0]             factor_real [3:0] ;
wire signed [15:0]             factor_imag [3:0];
assign factor_real[0]        = 16'h2000; //1
assign factor_imag[0]        = 16'h0000; //0
assign factor_real[1]        = 16'h16a0; //sqrt(2)/2
assign factor_imag[1]        = 16'he95f; //-sqrt(2)/2
assign factor_real[2]        = 16'h0000; //0
assign factor_imag[2]        = 16'he000; //-1
assign factor_real[3]        = 16'he95f; //-sqrt(2)/2
assign factor_imag[3]        = 16'he95f; //-sqrt(2)/2


reg [7:0] en_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        en_r <= 'd0;
    else
        en_r <= {en_r[6:0], en};
end


reg signed [39:0] input_x_reg0_r;
reg signed [39:0] input_x_img0_r;
reg signed [39:0] input_x_reg1_r;
reg signed [39:0] input_x_img1_r;
reg signed [39:0] input_x_reg2_r;
reg signed [39:0] input_x_img2_r;
reg signed [39:0] input_x_reg3_r;
reg signed [39:0] input_x_img3_r;
reg signed [39:0] input_x_reg4_r;
reg signed [39:0] input_x_img4_r;
reg signed [39:0] input_x_reg5_r;
reg signed [39:0] input_x_img5_r;
reg signed [39:0] input_x_reg6_r;
reg signed [39:0] input_x_img6_r;
reg signed [39:0] input_x_reg7_r;
reg signed [39:0] input_x_img7_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin      
        input_x_reg0_r <= 40'd0;
        input_x_img0_r <= 40'd0;
        input_x_reg1_r <= 40'd0;
        input_x_img1_r <= 40'd0;
        input_x_reg2_r <= 40'd0;
        input_x_img2_r <= 40'd0;
        input_x_reg3_r <= 40'd0;
        input_x_img3_r <= 40'd0;
        input_x_reg4_r <= 40'd0;
        input_x_img4_r <= 40'd0;
        input_x_reg5_r <= 40'd0;
        input_x_img5_r <= 40'd0;
        input_x_reg6_r <= 40'd0;
        input_x_img6_r <= 40'd0;
        input_x_reg7_r <= 40'd0;
        input_x_img7_r <= 40'd0;
    end else if (en)begin
        input_x_reg0_r <= {{4{input_x_reg0[23]}}, input_x_reg0[22:0], 13'b0};
        input_x_img0_r <= {{4{input_x_img0[23]}}, input_x_img0[22:0], 13'b0};
        input_x_reg1_r <= {{4{input_x_reg1[23]}}, input_x_reg1[22:0], 13'b0};
        input_x_img1_r <= {{4{input_x_img1[23]}}, input_x_img1[22:0], 13'b0};
        input_x_reg2_r <= {{4{input_x_reg2[23]}}, input_x_reg2[22:0], 13'b0};
        input_x_img2_r <= {{4{input_x_img2[23]}}, input_x_img2[22:0], 13'b0};
        input_x_reg3_r <= {{4{input_x_reg3[23]}}, input_x_reg3[22:0], 13'b0};
        input_x_img3_r <= {{4{input_x_img3[23]}}, input_x_img3[22:0], 13'b0};
        input_x_reg4_r <= {{4{input_x_reg4[23]}}, input_x_reg4[22:0], 13'b0};
        input_x_img4_r <= {{4{input_x_img4[23]}}, input_x_img4[22:0], 13'b0};
        input_x_reg5_r <= {{4{input_x_reg5[23]}}, input_x_reg5[22:0], 13'b0};
        input_x_img5_r <= {{4{input_x_img5[23]}}, input_x_img5[22:0], 13'b0};
        input_x_reg6_r <= {{4{input_x_reg6[23]}}, input_x_reg6[22:0], 13'b0};
        input_x_img6_r <= {{4{input_x_img6[23]}}, input_x_img6[22:0], 13'b0};
        input_x_reg7_r <= {{4{input_x_reg7[23]}}, input_x_reg7[22:0], 13'b0};
        input_x_img7_r <= {{4{input_x_img7[23]}}, input_x_img7[22:0], 13'b0};
    end
end

reg signed [39:0] pipe1_reg0;  
reg signed [39:0] pipe1_img0;
reg signed [39:0] pipe1_reg1;  
reg signed [39:0] pipe1_img1;
reg signed [39:0] pipe1_reg2;  
reg signed [39:0] pipe1_img2;
reg signed [39:0] pipe1_reg3;  
reg signed [39:0] pipe1_img3;
reg signed [39:0] pipe1_reg4;  
reg signed [39:0] pipe1_img4;
reg signed [39:0] pipe1_reg5;  
reg signed [39:0] pipe1_img5;
reg signed [39:0] pipe1_reg6;  
reg signed [39:0] pipe1_img6;
reg signed [39:0] pipe1_reg7;  
reg signed [39:0] pipe1_img7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe1_reg0 <= 40'd0;
        pipe1_img0 <= 40'd0;
        pipe1_reg1 <= 40'd0;
        pipe1_img1 <= 40'd0;
        pipe1_reg2 <= 40'd0;
        pipe1_img2 <= 40'd0;
        pipe1_reg3 <= 40'd0;
        pipe1_img3 <= 40'd0;
        pipe1_reg4 <= 40'd0;
        pipe1_img4 <= 40'd0;
        pipe1_reg5 <= 40'd0;
        pipe1_img5 <= 40'd0;
        pipe1_reg6 <= 40'd0;
        pipe1_img6 <= 40'd0;
        pipe1_reg7 <= 40'd0;
        pipe1_img7 <= 40'd0;
    end else if (en_r[0]) begin
        pipe1_reg0 <= input_x_reg0_r + input_x_reg4_r;
        pipe1_img0 <= input_x_img0_r + input_x_img4_r;
        pipe1_reg1 <= input_x_reg0_r - input_x_reg4_r;
        pipe1_img1 <= input_x_img0_r - input_x_img4_r;
        pipe1_reg2 <= input_x_reg2_r + input_x_reg6_r;
        pipe1_img2 <= input_x_img2_r + input_x_img6_r;
        pipe1_reg3 <= input_x_reg2_r - input_x_reg6_r;
        pipe1_img3 <= input_x_img2_r - input_x_img6_r;
        pipe1_reg4 <= input_x_reg1_r + input_x_reg5_r;
        pipe1_img4 <= input_x_img1_r + input_x_img5_r;
        pipe1_reg5 <= input_x_reg1_r - input_x_reg5_r;
        pipe1_img5 <= input_x_img1_r - input_x_img5_r;
        pipe1_reg6 <= input_x_reg3_r + input_x_reg7_r;
        pipe1_img6 <= input_x_img3_r + input_x_img7_r;
        pipe1_reg7 <= input_x_reg3_r - input_x_reg7_r;
        pipe1_img7 <= input_x_img3_r - input_x_img7_r;
    end
end


wire signed [23:0] pipe1_reg3_w = {pipe1_reg3[39], pipe1_reg3[13+23:13]};
wire signed [23:0] pipe1_img3_w = {pipe1_img3[39], pipe1_img3[13+23:13]};
wire signed [23:0] pipe1_reg7_w = {pipe1_reg7[39], pipe1_reg7[13+23:13]};
wire signed [23:0] pipe1_img7_w = {pipe1_img7[39], pipe1_img7[13+23:13]};

reg signed [39:0] mul_reg3_real0;
reg signed [39:0] mul_img3_img0;
reg signed [39:0] mul_reg3_real1;
reg signed [39:0] mul_img3_img1;
reg signed [39:0] mul_reg7_real0;
reg signed [39:0] mul_img7_img0;
reg signed [39:0] mul_reg7_real1;
reg signed [39:0] mul_img7_img1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_reg3_real0 <= 40'd0;
        mul_img3_img0 <= 40'd0;
        mul_reg3_real1 <= 40'd0;
        mul_img3_img1 <= 40'd0;
        mul_reg7_real0 <= 40'd0;
        mul_img7_img0 <= 40'd0;
        mul_reg7_real1 <= 40'd0;
        mul_img7_img1 <= 40'd0;        
    end else if (en_r[1]) begin
        mul_reg3_real0 <= pipe1_reg3_w * factor_real[2];
        mul_reg3_real1 <= pipe1_img3_w * factor_imag[2];
        mul_img3_img0  <= pipe1_reg3_w * factor_imag[2];
        mul_img3_img1  <= pipe1_img3_w * factor_real[2];
        mul_reg7_real0 <= pipe1_reg7_w * factor_real[2];
        mul_reg7_real1 <= pipe1_img7_w * factor_imag[2];
        mul_img7_img0  <= pipe1_reg7_w * factor_imag[2];
        mul_img7_img1  <= pipe1_img7_w * factor_real[2];        
    end
end

reg signed [39:0] mul_reg3;
reg signed [39:0] mul_img3;
reg signed [39:0] mul_reg7;
reg signed [39:0] mul_img7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_reg3 <= 40'd0;
        mul_img3 <= 40'd0;
        mul_reg7 <= 40'd0;
        mul_img7 <= 40'd0;
    end else if (en_r[2]) begin
        mul_reg3 <= mul_reg3_real0 - mul_reg3_real1;
        mul_img3 <= mul_img3_img0 + mul_img3_img1;
        mul_reg7 <= mul_reg7_real0 - mul_reg7_real1;
        mul_img7 <= mul_img7_img0 + mul_img7_img1;
    end
end

reg signed [39:0] pipe1_reg0_reg1;  
reg signed [39:0] pipe1_img0_reg1;
reg signed [39:0] pipe1_reg1_reg1;  
reg signed [39:0] pipe1_img1_reg1;
reg signed [39:0] pipe1_reg2_reg1;  
reg signed [39:0] pipe1_img2_reg1;
reg signed [39:0] pipe1_reg4_reg1;  
reg signed [39:0] pipe1_img4_reg1;
reg signed [39:0] pipe1_reg5_reg1;  
reg signed [39:0] pipe1_img5_reg1;
reg signed [39:0] pipe1_reg6_reg1;  
reg signed [39:0] pipe1_img6_reg1;

reg signed [39:0] pipe1_reg0_reg2;  
reg signed [39:0] pipe1_img0_reg2;
reg signed [39:0] pipe1_reg1_reg2;  
reg signed [39:0] pipe1_img1_reg2;
reg signed [39:0] pipe1_reg2_reg2;  
reg signed [39:0] pipe1_img2_reg2;
reg signed [39:0] pipe1_reg4_reg2;  
reg signed [39:0] pipe1_img4_reg2;
reg signed [39:0] pipe1_reg5_reg2;  
reg signed [39:0] pipe1_img5_reg2;
reg signed [39:0] pipe1_reg6_reg2;  
reg signed [39:0] pipe1_img6_reg2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe1_reg0_reg1 <= 40'd0;  
        pipe1_img0_reg1 <= 40'd0;
        pipe1_reg1_reg1 <= 40'd0;  
        pipe1_img1_reg1 <= 40'd0;
        pipe1_reg2_reg1 <= 40'd0;  
        pipe1_img2_reg1 <= 40'd0;
        pipe1_reg4_reg1 <= 40'd0;  
        pipe1_img4_reg1 <= 40'd0;
        pipe1_reg5_reg1 <= 40'd0;  
        pipe1_img5_reg1 <= 40'd0;
        pipe1_reg6_reg1 <= 40'd0;  
        pipe1_img6_reg1 <= 40'd0;   
    end else if (en_r[1]) begin
        pipe1_reg0_reg1 <= pipe1_reg0;  
        pipe1_img0_reg1 <= pipe1_img0;
        pipe1_reg1_reg1 <= pipe1_reg1;  
        pipe1_img1_reg1 <= pipe1_img1;
        pipe1_reg2_reg1 <= pipe1_reg2;  
        pipe1_img2_reg1 <= pipe1_img2;
        pipe1_reg4_reg1 <= pipe1_reg4;  
        pipe1_img4_reg1 <= pipe1_img4;
        pipe1_reg5_reg1 <= pipe1_reg5;  
        pipe1_img5_reg1 <= pipe1_img5;
        pipe1_reg6_reg1 <= pipe1_reg6;  
        pipe1_img6_reg1 <= pipe1_img6;        
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe1_reg0_reg2 <= 40'd0;  
        pipe1_img0_reg2 <= 40'd0;
        pipe1_reg1_reg2 <= 40'd0;  
        pipe1_img1_reg2 <= 40'd0;
        pipe1_reg2_reg2 <= 40'd0;  
        pipe1_img2_reg2 <= 40'd0;
        pipe1_reg4_reg2 <= 40'd0;  
        pipe1_img4_reg2 <= 40'd0;
        pipe1_reg5_reg2 <= 40'd0;  
        pipe1_img5_reg2 <= 40'd0;
        pipe1_reg6_reg2 <= 40'd0;  
        pipe1_img6_reg2 <= 40'd0;            
    end else if (en_r[2]) begin
        pipe1_reg0_reg2 <= pipe1_reg0_reg1;  
        pipe1_img0_reg2 <= pipe1_img0_reg1;
        pipe1_reg1_reg2 <= pipe1_reg1_reg1;  
        pipe1_img1_reg2 <= pipe1_img1_reg1;
        pipe1_reg2_reg2 <= pipe1_reg2_reg1;  
        pipe1_img2_reg2 <= pipe1_img2_reg1;
        pipe1_reg4_reg2 <= pipe1_reg4_reg1;  
        pipe1_img4_reg2 <= pipe1_img4_reg1;
        pipe1_reg5_reg2 <= pipe1_reg5_reg1;  
        pipe1_img5_reg2 <= pipe1_img5_reg1;
        pipe1_reg6_reg2 <= pipe1_reg6_reg1;  
        pipe1_img6_reg2 <= pipe1_img6_reg1;         
    end
end


reg signed [39:0] pipe2_reg0;  
reg signed [39:0] pipe2_img0;
reg signed [39:0] pipe2_reg1;  
reg signed [39:0] pipe2_img1;
reg signed [39:0] pipe2_reg2;  
reg signed [39:0] pipe2_img2;
reg signed [39:0] pipe2_reg3;  
reg signed [39:0] pipe2_img3;
reg signed [39:0] pipe2_reg4;  
reg signed [39:0] pipe2_img4;
reg signed [39:0] pipe2_reg5;  
reg signed [39:0] pipe2_img5;
reg signed [39:0] pipe2_reg6;  
reg signed [39:0] pipe2_img6;
reg signed [39:0] pipe2_reg7;  
reg signed [39:0] pipe2_img7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe2_reg0 <= 40'd0;
        pipe2_img0 <= 40'd0;
        pipe2_reg1 <= 40'd0;
        pipe2_img1 <= 40'd0;
        pipe2_reg2 <= 40'd0;
        pipe2_img2 <= 40'd0;
        pipe2_reg3 <= 40'd0;
        pipe2_img3 <= 40'd0;
        pipe2_reg4 <= 40'd0;
        pipe2_img4 <= 40'd0;
        pipe2_reg5 <= 40'd0;
        pipe2_img5 <= 40'd0;
        pipe2_reg6 <= 40'd0;
        pipe2_img6 <= 40'd0;
        pipe2_reg7 <= 40'd0;
        pipe2_img7 <= 40'd0;
    end else if (en_r[3])begin
        pipe2_reg0 <= pipe1_reg0_reg2 + pipe1_reg2_reg2;
        pipe2_img0 <= pipe1_img0_reg2 + pipe1_img2_reg2;
        pipe2_reg2 <= pipe1_reg0_reg2 - pipe1_reg2_reg2;
        pipe2_img2 <= pipe1_img0_reg2 - pipe1_img2_reg2; 
        pipe2_reg1 <= pipe1_reg1_reg2 + mul_reg3;
        pipe2_img1 <= pipe1_img1_reg2 + mul_img3;
        pipe2_reg3 <= pipe1_reg1_reg2 - mul_reg3;
        pipe2_img3 <= pipe1_img1_reg2 - mul_img3;    
        pipe2_reg4 <= pipe1_reg4_reg2 + pipe1_reg6_reg2;
        pipe2_img4 <= pipe1_img4_reg2 + pipe1_img6_reg2;
        pipe2_reg6 <= pipe1_reg4_reg2 - pipe1_reg6_reg2;
        pipe2_img6 <= pipe1_img4_reg2 - pipe1_img6_reg2; 
        pipe2_reg5 <= pipe1_reg5_reg2 + mul_reg7;
        pipe2_img5 <= pipe1_img5_reg2 + mul_img7;
        pipe2_reg7 <= pipe1_reg5_reg2 - mul_reg7;
        pipe2_img7 <= pipe1_img5_reg2 - mul_img7; 
    end
end

wire signed [23:0] pipe2_reg5_w = {pipe2_reg5[39], pipe2_reg5[13+22:13]};
wire signed [23:0] pipe2_img5_w = {pipe2_img5[39], pipe2_img5[13+22:13]};
wire signed [23:0] pipe2_reg6_w = {pipe2_reg6[39], pipe2_reg6[13+22:13]};
wire signed [23:0] pipe2_img6_w = {pipe2_img6[39], pipe2_img6[13+22:13]};
wire signed [23:0] pipe2_reg7_w = {pipe2_reg7[39], pipe2_reg7[13+22:13]};
wire signed [23:0] pipe2_img7_w = {pipe2_img7[39], pipe2_img7[13+22:13]};

reg signed [39:0] mul2_reg5_real0;
reg signed [39:0] mul2_img5_img0;
reg signed [39:0] mul2_reg5_real1;
reg signed [39:0] mul2_img5_img1;
reg signed [39:0] mul2_reg6_real0;
reg signed [39:0] mul2_img6_img0;
reg signed [39:0] mul2_reg6_real1;
reg signed [39:0] mul2_img6_img1;
reg signed [39:0] mul2_reg7_real0;
reg signed [39:0] mul2_img7_img0;
reg signed [39:0] mul2_reg7_real1;
reg signed [39:0] mul2_img7_img1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul2_reg5_real0 <= 40'd0;
        mul2_img5_img0 <= 40'd0;
        mul2_reg5_real1 <= 40'd0;
        mul2_img5_img1 <= 40'd0;
        mul2_reg6_real0 <= 40'd0;
        mul2_img6_img0 <= 40'd0;
        mul2_reg6_real1 <= 40'd0;
        mul2_img6_img1 <= 40'd0;         
        mul2_reg7_real0 <= 40'd0;
        mul2_img7_img0 <= 40'd0;
        mul2_reg7_real1 <= 40'd0;
        mul2_img7_img1 <= 40'd0;        
    end else if (en_r[4]) begin
        mul2_reg5_real0 <= pipe2_reg5_w * factor_real[1];
        mul2_reg5_real1 <= pipe2_img5_w * factor_imag[1];
        mul2_img5_img0  <= pipe2_reg5_w * factor_imag[1];
        mul2_img5_img1  <= pipe2_img5_w * factor_real[1];
        mul2_reg6_real0 <= pipe2_reg6_w * factor_real[2];
        mul2_reg6_real1 <= pipe2_img6_w * factor_imag[2];
        mul2_img6_img0  <= pipe2_reg6_w * factor_imag[2];
        mul2_img6_img1  <= pipe2_img6_w * factor_real[2]; 
        mul2_reg7_real0 <= pipe2_reg7_w * factor_real[3];
        mul2_reg7_real1 <= pipe2_img7_w * factor_imag[3];
        mul2_img7_img0  <= pipe2_reg7_w * factor_imag[3];
        mul2_img7_img1  <= pipe2_img7_w * factor_real[3];        
    end
end


reg signed [39:0] mul2_reg5;
reg signed [39:0] mul2_img5;
reg signed [39:0] mul2_reg6;
reg signed [39:0] mul2_img6;
reg signed [39:0] mul2_reg7;
reg signed [39:0] mul2_img7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul2_reg5 <= 40'd0;
        mul2_img5 <= 40'd0;
        mul2_reg6 <= 40'd0;
        mul2_img6 <= 40'd0;
        mul2_reg7 <= 40'd0;
        mul2_img7 <= 40'd0;
    end else if (en_r[5]) begin
        mul2_reg5 <= mul2_reg5_real0 - mul2_reg5_real1;
        mul2_img5 <= mul2_img5_img0 + mul2_img5_img1;
        mul2_reg6 <= mul2_reg6_real0 - mul2_reg6_real1;
        mul2_img6 <= mul2_img6_img0 + mul2_img6_img1;        
        mul2_reg7 <= mul2_reg7_real0 - mul2_reg7_real1;
        mul2_img7 <= mul2_img7_img0 + mul2_img7_img1;
    end
end

reg signed [39:0] pipe2_reg0_reg1;  
reg signed [39:0] pipe2_img0_reg1;
reg signed [39:0] pipe2_reg1_reg1;  
reg signed [39:0] pipe2_img1_reg1;
reg signed [39:0] pipe2_reg2_reg1;  
reg signed [39:0] pipe2_img2_reg1;
reg signed [39:0] pipe2_reg3_reg1;  
reg signed [39:0] pipe2_img3_reg1;
reg signed [39:0] pipe2_reg4_reg1;  
reg signed [39:0] pipe2_img4_reg1;

reg signed [39:0] pipe2_reg0_reg2;  
reg signed [39:0] pipe2_img0_reg2;
reg signed [39:0] pipe2_reg1_reg2;  
reg signed [39:0] pipe2_img1_reg2;
reg signed [39:0] pipe2_reg2_reg2;  
reg signed [39:0] pipe2_img2_reg2;
reg signed [39:0] pipe2_reg3_reg2;  
reg signed [39:0] pipe2_img3_reg2;
reg signed [39:0] pipe2_reg4_reg2;  
reg signed [39:0] pipe2_img4_reg2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe2_reg0_reg1 <= 40'd0;  
        pipe2_img0_reg1 <= 40'd0;
        pipe2_reg1_reg1 <= 40'd0;  
        pipe2_img1_reg1 <= 40'd0;
        pipe2_reg2_reg1 <= 40'd0;  
        pipe2_img2_reg1 <= 40'd0;
        pipe2_reg3_reg1 <= 40'd0;  
        pipe2_img3_reg1 <= 40'd0; 
        pipe2_reg4_reg1 <= 40'd0;  
        pipe2_img4_reg1 <= 40'd0; 
    end else if (en_r[4]) begin
        pipe2_reg0_reg1 <= pipe2_reg0;  
        pipe2_img0_reg1 <= pipe2_img0;
        pipe2_reg1_reg1 <= pipe2_reg1;  
        pipe2_img1_reg1 <= pipe2_img1;
        pipe2_reg2_reg1 <= pipe2_reg2;  
        pipe2_img2_reg1 <= pipe2_img2;
        pipe2_reg3_reg1 <= pipe2_reg3;  
        pipe2_img3_reg1 <= pipe2_img3;      
        pipe2_reg4_reg1 <= pipe2_reg4;  
        pipe2_img4_reg1 <= pipe2_img4;            
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe2_reg0_reg2 <= 40'd0;  
        pipe2_img0_reg2 <= 40'd0;
        pipe2_reg1_reg2 <= 40'd0;  
        pipe2_img1_reg2 <= 40'd0;
        pipe2_reg2_reg2 <= 40'd0;  
        pipe2_img2_reg2 <= 40'd0;
        pipe2_reg3_reg2 <= 40'd0;  
        pipe2_img3_reg2 <= 40'd0;            
        pipe2_reg4_reg2 <= 40'd0;  
        pipe2_img4_reg2 <= 40'd0; 
    end else if (en_r[5]) begin
        pipe2_reg0_reg2 <= pipe2_reg0_reg1;  
        pipe2_img0_reg2 <= pipe2_img0_reg1;
        pipe2_reg1_reg2 <= pipe2_reg1_reg1;  
        pipe2_img1_reg2 <= pipe2_img1_reg1;
        pipe2_reg2_reg2 <= pipe2_reg2_reg1;  
        pipe2_img2_reg2 <= pipe2_img2_reg1;
        pipe2_reg3_reg2 <= pipe2_reg3_reg1;  
        pipe2_img3_reg2 <= pipe2_img3_reg1;      
        pipe2_reg4_reg2 <= pipe2_reg4_reg1;  
        pipe2_img4_reg2 <= pipe2_img4_reg1; 
    end
end


reg signed [39:0] pipe3_reg0;  
reg signed [39:0] pipe3_img0;
reg signed [39:0] pipe3_reg1;  
reg signed [39:0] pipe3_img1;
reg signed [39:0] pipe3_reg2;  
reg signed [39:0] pipe3_img2;
reg signed [39:0] pipe3_reg3;  
reg signed [39:0] pipe3_img3;
reg signed [39:0] pipe3_reg4;  
reg signed [39:0] pipe3_img4;
reg signed [39:0] pipe3_reg5;  
reg signed [39:0] pipe3_img5;
reg signed [39:0] pipe3_reg6;  
reg signed [39:0] pipe3_img6;
reg signed [39:0] pipe3_reg7;  
reg signed [39:0] pipe3_img7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe3_reg0 <= 40'd0;
        pipe3_img0 <= 40'd0;
        pipe3_reg1 <= 40'd0;
        pipe3_img1 <= 40'd0;
        pipe3_reg2 <= 40'd0;
        pipe3_img2 <= 40'd0;
        pipe3_reg3 <= 40'd0;
        pipe3_img3 <= 40'd0;
        pipe3_reg4 <= 40'd0;
        pipe3_img4 <= 40'd0;
        pipe3_reg5 <= 40'd0;
        pipe3_img5 <= 40'd0;
        pipe3_reg6 <= 40'd0;
        pipe3_img6 <= 40'd0;
        pipe3_reg7 <= 40'd0;
        pipe3_img7 <= 40'd0;
    end else if (en_r[6])begin
        pipe3_reg0 <= pipe2_reg0_reg2 + pipe2_reg4_reg2;
        pipe3_img0 <= pipe2_img0_reg2 + pipe2_img4_reg2;
        pipe3_reg4 <= pipe2_reg0_reg2 - pipe2_reg4_reg2;
        pipe3_img4 <= pipe2_img0_reg2 - pipe2_img4_reg2;
        pipe3_reg1 <= pipe2_reg1_reg2 + mul2_reg5;
        pipe3_img1 <= pipe2_img1_reg2 + mul2_img5;
        pipe3_reg5 <= pipe2_reg1_reg2 - mul2_reg5;
        pipe3_img5 <= pipe2_img1_reg2 - mul2_img5;  
        pipe3_reg2 <= pipe2_reg2_reg2 + mul2_reg6;
        pipe3_img2 <= pipe2_img2_reg2 + mul2_img6;
        pipe3_reg6 <= pipe2_reg2_reg2 - mul2_reg6;
        pipe3_img6 <= pipe2_img2_reg2 - mul2_img6; 
        pipe3_reg3 <= pipe2_reg3_reg2 + mul2_reg7;
        pipe3_img3 <= pipe2_img3_reg2 + mul2_img7;
        pipe3_reg7 <= pipe2_reg3_reg2 - mul2_reg7;
        pipe3_img7 <= pipe2_img3_reg2 - mul2_img7;                             
    end
end


assign valid = en_r[7];
assign output_y_reg0 =  {pipe3_reg0[39], pipe3_reg0[23+13:13]};
assign output_y_img0 =  {pipe3_img0[39], pipe3_img0[23+13:13]};
assign output_y_reg1 =  {pipe3_reg1[39], pipe3_reg1[23+13:13]};
assign output_y_img1 =  {pipe3_img1[39], pipe3_img1[23+13:13]};
assign output_y_reg2 =  {pipe3_reg2[39], pipe3_reg2[23+13:13]};
assign output_y_img2 =  {pipe3_img2[39], pipe3_img2[23+13:13]};
assign output_y_reg3 =  {pipe3_reg3[39], pipe3_reg3[23+13:13]};
assign output_y_img3 =  {pipe3_img3[39], pipe3_img3[23+13:13]};
assign output_y_reg4 =  {pipe3_reg4[39], pipe3_reg4[23+13:13]};
assign output_y_img4 =  {pipe3_img4[39], pipe3_img4[23+13:13]};
assign output_y_reg5 =  {pipe3_reg5[39], pipe3_reg5[23+13:13]};
assign output_y_img5 =  {pipe3_img5[39], pipe3_img5[23+13:13]};
assign output_y_reg6 =  {pipe3_reg6[39], pipe3_reg6[23+13:13]};
assign output_y_img6 =  {pipe3_img6[39], pipe3_img6[23+13:13]};
assign output_y_reg7 =  {pipe3_reg7[39], pipe3_reg7[23+13:13]};
assign output_y_img7 =  {pipe3_img7[39], pipe3_img7[23+13:13]};


endmodule