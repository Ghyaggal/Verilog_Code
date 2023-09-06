`timescale 1 ns/ 1 ns

module CORDIC_tb();

// Inputs
reg                         CLK_50M;
reg                         RST_N;
reg             [15:0]      cnt;
reg             [15:0]      cnt_n;
wire            [31:0]      Phase;
wire            [31:0]      Sin;
wire            [31:0]      Cos;
wire            [31:0]      Error;

// Instantiate the Unit Under Test (UUT)
CORDIC                 uut 
(
    .clk                (CLK_50M    ),
    .rst_n                  (RST_N      ),
    .Phase                  (Phase      ),
    .sin                    (Sin        ),
    .cos                    (Cos        ),
    .error                  (Error      )
);

initial
begin
    #0 CLK_50M = 1'b0;
    #10000 RST_N = 1'b0;
    #10000 RST_N = 1'b1;
    #10000000 $stop;
end 

always #10000 
begin
    CLK_50M = ~CLK_50M;
end

always @ (posedge CLK_50M or negedge RST_N)
begin
    if(!RST_N)
        cnt <= 1'b0;
    else
        cnt <= cnt_n;
end

always @ (*)
begin
    if(cnt == 16'd359)
        cnt_n = 1'b0;
    else
        cnt_n = cnt + 1'b1;
end

assign Phase = cnt;
endmodule

