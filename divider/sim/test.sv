`timescale 1ns/1ns

module test ;

   parameter    N = 5 ;
   parameter    M = 3 ;

   reg          clk;
   reg          rstn ;

   reg          data_rdy ;
   reg [N-1:0]  dividend ;
   reg [M-1:0]  divisor ;

   wire         res_rdy ;
   wire [N-1:0] merchant ;
   wire [M-1:0] remainder ;

   //clock
   always begin
      clk = 0 ; #5 ;
      clk = 1 ; #5 ;
   end

   //driver
   initial begin
      rstn      = 1'b0 ;
      #8 ;
      rstn      = 1'b1 ;

      #55 ;
      @(negedge clk ) ;
      data_rdy  = 1'b1 ;
      dividend  = 25;      divisor      = 5;
      #10 ;
      dividend  = 16;      divisor      = 3;
      #10 ;
      dividend  = 10;      divisor      = 4;
      #10 ;
      dividend  = 15;      divisor      = 1;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 7;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 5;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 3;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 2;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 4;
      repeat(32)    #10   dividend   = dividend + 1 ;
      divisor      = 6;
      repeat(32)    #10   dividend   = dividend + 1 ;
   end // initial begin

   //for better observation to align data_in and results
   reg  [N-1:0]   dividend_ref [N-1:0];
   reg  [M-1:0]   divisor_ref [N-1:0];
   always @(posedge clk) begin
      dividend_ref[0] <= dividend ;
      divisor_ref[0]  <= divisor ;
   end

   genvar         i ;
   generate
      for(i=1; i<=N-1; i=i+1) begin : forx
         always @(posedge clk) begin
            dividend_ref[i] <= dividend_ref[i-1];
            divisor_ref[i]  <= divisor_ref[i-1];
         end
      end
   endgenerate

   //auto check
   reg  error_flag ;
   always @(posedge clk) begin
      # 1 ;
      if (merchant * divisor_ref[N-1] + remainder != dividend_ref[N-1] && res_rdy) begin
         error_flag <= 1'b1 ;
      end
      else begin
         error_flag <= 1'b0 ;
      end
   end

   //module instantiation
   divider  #(.N(N), .M(M))
   u_divider
     (
      .clk              (clk),
      .rst_n             (rstn),
      .data_rdy         (data_rdy),
      .dividend         (dividend),
      .divisor          (divisor),

      .rdy          (res_rdy),
      .merchant         (merchant),
      .remainder        (remainder));

   //simulation finish
   initial begin
      forever begin
         #100;
         if ($time >= 10000)  $finish ;
      end
   end

endmodule // test
