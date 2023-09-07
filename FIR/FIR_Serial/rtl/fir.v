module fir (
    clk,
    rst_n,
    en,
    xin,
    rdy,
    yout
    );


    input           clk;
    input           rst_n;
    input           en;
    input [11:0]    xin;

    output          rdy;
    output [28:0]   yout;


    reg [11:0]  rdy_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdy_reg <= 'b0;
        end else begin
            rdy_reg <= {rdy_reg[10:0], en};
        end
    end

    reg [2:0]   cnt;
    integer i, j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end else if (en || cnt != 0) begin
            cnt <= cnt + 1'b1;
        end
    end

    reg [11:0]  xin_reg [15:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<16; i=i+1) begin
                xin_reg[i] <= 'b0;
            end
        end else if (cnt == 3'd0 && en) begin
            xin_reg[0] <= xin;
            for (j=0; j<15; j=j+1) begin
                xin_reg[j+1] <= xin_reg[j];
            end
        end
    end

    wire [11:0]     coe [7:0];
    assign coe[0] = 12'd11;
    assign coe[1] = 12'd31;
    assign coe[2] = 12'd63;
    assign coe[3] = 12'd104;
    assign coe[4] = 12'd152;
    assign coe[5] = 12'd198;
    assign coe[6] = 12'd235;
    assign coe[7] = 12'd255;

    reg [11:0]      add_a, add_b;
    reg [11:0]      coe_r;
    wire [12:0]     add_r;
    wire [2:0]      xin_index = cnt>=1 ? cnt-1 : 3'd7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a <= 'b0;
            add_b <= 'b0;
            coe_r <= 'b0;
        end else if (rdy_reg[xin_index]) begin
            add_a <= xin_reg[xin_index];
            add_b <= xin_reg[15-xin_index];
            coe_r <= coe[xin_index];
        end
    end
    assign add_r = add_a + add_b;

    wire [24:0]      mout;
    wire            en_mult;
    wire [3:0]      index_mult = cnt>=2 ? cnt-1 : 4'd7 + cnt[0];           

    mult #(.N(13), .M(12))
    mult_inst
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (rdy_reg[index_mult]),
        .mult1      (add_r),
        .mult2      (coe_r),
        .result     (mout),
        .rdy        (en_mult)
        );


    reg  [28:0]     sum;
    reg             valid_r;
    reg  [4:0]      cnt_acc_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_acc_r <= 'b0;
        end else if (cnt_acc_r == 5'd7) begin
            cnt_acc_r <= 'b0;
        end else if (en_mult || cnt_acc_r != 0) begin
            cnt_acc_r <= cnt_acc_r + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum     <= 'b0;
            valid_r <= 'b0;
        end else if (cnt_acc_r == 5'd7) begin
            sum     <= sum + mout;
            valid_r <= 1'b1;
        end else if (en_mult && cnt_acc_r == 0) begin
            sum     <= mout;
            valid_r <= 1'b0;
        end else if (cnt_acc_r != 0) begin
            sum     <= sum + mout; 
            valid_r <= 1'b0;
        end
    end

    reg [28:0]      yout_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout_r <= 'b0;
        end else if (valid_r) begin
            yout_r <= sum;
        end
    end
    assign yout = yout_r;

    reg [4:0]       cnt_valid;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_valid <= 'b0;
        end else if (valid_r && cnt_valid != 5'd16) begin
            cnt_valid <= cnt_valid + 1'b1;
        end
    end
    assign rdy = (cnt_valid == 5'd16) & valid_r;

endmodule