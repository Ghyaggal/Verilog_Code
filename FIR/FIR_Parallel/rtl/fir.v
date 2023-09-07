module fir (
    clk,
    rst_n,
    en,
    xin,
    valid,
    yout
    );
    
    input           clk;
    input           rst_n;
    input           en;
    input [11:0]    xin;
    output          valid;
    output [28:0]   yout;


    reg [2:0]       en_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_r <= 'b0;
        end else begin
            en_r <= {en_r[1:0], en};
        end
    end

    reg [11:0]      xin_reg     [15:0];
    reg [4:0]       i, j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<=15; i=i+1) begin
                xin_reg[i] <= 'b0;
            end
        end else if (en) begin
            xin_reg[0] <= xin;
            for (j=0; j<15; j=j+1) begin
                xin_reg[j+1] <= xin_reg[j];
            end
        end
    end

    reg [12:0]      add_reg     [7:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1) begin
                add_reg[i] <= 'b0;
            end
        end else if (en_r[0]) begin
            for (i=0; i<8; i=i+1) begin
                add_reg[i] <= xin_reg[i] + xin_reg[15-i];
            end
        end
    end

    wire [11:0]     coe  [7:0];
    assign coe[0] = 12'd11;
    assign coe[1] = 12'd31;
    assign coe[2] = 12'd63;
    assign coe[3] = 12'd104;
    assign coe[4] = 12'd152;
    assign coe[5] = 12'd198;
    assign coe[6] = 12'd235;
    assign coe[7] = 12'd255;
    wire  [24:0]     mout [7:0];

    wire [7:0]  valid_mult;
    genvar k;
    generate
        for (k=0; k<8; k=k+1) begin : for_multx
            mult #(.N(13), .M(12))
            mult_instx
            (
                .clk    (clk),
                .rst_n  (rst_n),
                .en     (en_r[1]),
                .mult1  (add_reg[k]),
                .mult2  (coe[k]),
                .result (mout[k]),
                .rdy    (valid_mult[k])  
                );
        end
    endgenerate

    wire valid_mult_7 = valid_mult[7];

    reg valid_mult_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_mult_r <= 1'b0;
        end else begin
            valid_mult_r <= valid_mult_7;
        end
    end

    reg [28:0]  sum1;
    reg [28:0]  sum2;
    reg [28:0]  yout_t;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 'b0;
            sum2 <= 'b0;
            yout_t <= 'b0;
        end else if (valid_mult_7) begin
            sum1 <= mout[0] + mout[1] + mout[2] + mout[3];
            sum2 <= mout[4] + mout[5] + mout[6] + mout[7];
            yout_t <= sum1 + sum2;
        end
    end

assign yout = yout_t;
assign valid = valid_mult_r;

endmodule