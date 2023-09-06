module uart_rx (
    clk,
    rst_n,
    baud_set,
    uart_rxd,

    data,
    Rx_Done,
    uart_state
);

input clk;
input rst_n;
input baud_set;
input uart_rxd;

output reg [7:0] data;
output reg Rx_Done;
output reg uart_state;

wire nege_sign;
reg bps_clk;
reg [7:0] bps_cnt;

parameter baud_9600 = 324,
    baud_19200 = 162,
    baud_38400 = 80,
    baud_57600 = 53,
    baud_115200 = 26,
    baud_1562500 = 1;

 reg data_reg1, data_reg2;
reg data_temp1, data_temp2;

wire [12:0] CNT_MAX;
reg [12:0] div_cnt;

reg [3:0] START_BIT;
reg [3:0] STOP_BIT;
reg [3:0] data_get [7:0];


assign CNT_MAX = baud_set ? baud_115200 : baud_1562500;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg1 <= 1'b0;
        data_reg2 <= 1'b0;
    end else begin
        data_reg1 <= uart_rxd;
        data_reg2 <= data_reg1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_temp1 <= 1'b0;
        data_temp2 <= 1'b0;
    end else begin
        data_temp1 <= data_reg2;
        data_temp2 <= data_temp1;
    end
end

assign nege_sign = data_temp2 & ~data_temp1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        uart_state <= 1'b0;
    else if (nege_sign)
        uart_state <= 1'b1;
    else if ((Rx_Done) || ((bps_cnt==8'd12) && (START_BIT>2)))
        uart_state <= 1'b0;
    else
        uart_state <= uart_state;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        div_cnt <= 13'd0;
    else if (uart_state && (div_cnt == CNT_MAX))
        div_cnt <= 13'd0;
    else if (uart_state)
        div_cnt <= div_cnt + 1'b1;
    else
        div_cnt <= 13'd0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        bps_clk <= 1'b0;
    else if (div_cnt == 13'd1)
        bps_clk <= 1'b1;
    else
        bps_clk <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        bps_cnt <= 8'd0;
    else if ((bps_cnt == 8'd159) || ((bps_cnt==8'd12) && (START_BIT>2)))
        bps_cnt <= 8'd0;
    else if (bps_clk)
        bps_cnt <= bps_cnt + 1'b1;
    else
        bps_cnt <= bps_cnt;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Rx_Done <= 1'b0;
    else if (bps_cnt == 8'd159)
        Rx_Done <= 1'b1;
    else
        Rx_Done <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_get[0] <= 3'd0;
        data_get[1] <= 3'd0;
        data_get[2] <= 3'd0;
        data_get[3] <= 3'd0;
        data_get[4] <= 3'd0;
        data_get[5] <= 3'd0;
        data_get[6] <= 3'd0;
        data_get[7] <= 3'd0;
        START_BIT <= 3'd0;
        STOP_BIT <= 3'd0;
    end else if (bps_clk) begin
        case (bps_cnt)
            0:
            begin
                data_get[0] <= 3'd0;
                data_get[1] <= 3'd0;
                data_get[2] <= 3'd0;
                data_get[3] <= 3'd0;
                data_get[4] <= 3'd0;
                data_get[5] <= 3'd0;
                data_get[6] <= 3'd0;
                data_get[7] <= 3'd0;
                START_BIT <= 3'd0;
                STOP_BIT <= 3'd0;               
            end
            6,7,8,9,10,11: START_BIT <= START_BIT + data_reg2;
            22,23,24,25,26,27: data_get[0] <= data_get[0] + data_reg2;
            38,39,40,41,42,43: data_get[1] <= data_get[1] + data_reg2;
            54,55,56,57,58,59: data_get[2] <= data_get[2] + data_reg2;
            70,71,72,73,74,75: data_get[3] <= data_get[3] + data_reg2;
            86,87,88,89,90,91: data_get[4] <= data_get[4] + data_reg2;
            102,103,104,105,106,107: data_get[5] <= data_get[5] + data_reg2;
            118,119,120,121,122,123: data_get[6] <= data_get[6] + data_reg2;
            134,135,136,137,138,139: data_get[7] <= data_get[7] + data_reg2;
            150,151,152,153,154,155: STOP_BIT <= STOP_BIT + data_reg2;
            default:  
            begin
                START_BIT = START_BIT;
                data_get[0] <= data_get[0];
                data_get[1] <= data_get[1];
                data_get[2] <= data_get[2];
                data_get[3] <= data_get[3];
                data_get[4] <= data_get[4];
                data_get[5] <= data_get[5];
                data_get[6] <= data_get[6];
                data_get[7] <= data_get[7];
                STOP_BIT = STOP_BIT;              
            end            
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        data <= 8'd0;
    else if (bps_cnt == 8'd159) begin
        data[0] <= data_get[0][2];
        data[1] <= data_get[1][2];
        data[2] <= data_get[2][2];
        data[3] <= data_get[3][2];
        data[4] <= data_get[4][2];
        data[5] <= data_get[5][2];
        data[6] <= data_get[6][2];
        data[7] <= data_get[7][2];
    end
end

endmodule