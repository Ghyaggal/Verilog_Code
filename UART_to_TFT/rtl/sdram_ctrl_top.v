module sdram_ctrl_top (
    clk_100m,
    rst_n,
    sd_clk,

    wr_data,
    wr_en,
    wr_addr,
    wr_max_addr,
    wr_load,
    wr_clk,
    wr_full,
    wr_use,

    rd_data,
    rd_en,
    rd_addr,
    rd_max_addr,
    rd_load,
    rd_clk,
    rd_empty,
    rd_use,

    SA,
    BA,
    CS_N,
    CKE,
    RAS_N,
    CAS_N,
    WE_N,
    Dq,
    Dqm
);

`include "Sdram_Params.h"

input clk_100m;
input rst_n;
input sd_clk;

input [7:0] wr_data;
input wr_en;
input [23:0] wr_addr;
input [23:0] wr_max_addr;
input wr_load;
input wr_clk;
output wr_full;
output [7:0] wr_use;

output [`DSIZE-1:0] rd_data;
input rd_en;
input [23:0] rd_addr;
input [23:0] rd_max_addr;
input rd_load;
input rd_clk;
output rd_empty;
output [7:0] rd_use;

output [`ASIZE-1:0] SA;
output [`BSIZE-1:0] BA;
output CS_N;
output CKE;
output RAS_N;
output CAS_N;
output WE_N;
inout [`DSIZE-1:0] Dq;
output [`DSIZE/8-1:0] Dqm;

reg sd_wr;
reg sd_rd;
reg [`ASIZE-1:0] sd_caddr;
reg [`ASIZE-1:0] sd_raddr;
reg [`BSIZE-1:0] sd_baddr;
wire [`DSIZE-1:0] sd_wr_data;
wire [`DSIZE-1:0] sd_rd_data;
wire sd_rdata_vaild;
wire sd_wdata_vaild;
wire sd_wdata_done;
wire sd_rdata_done;
wire [7:0] fifo_rduse;
wire [7:0] fifo_wruse;
reg [23:0] wr_sdram_addr;
reg [23:0] rd_sdram_addr;
wire sd_wr_req;
wire sd_rd_req;

fifo_wr	fifo_wr_inst (
	.aclr (wr_load),
	.data (wr_data),
	.rdclk (clk_100m),
	.rdreq (sd_wdata_vaild),
	.wrclk (wr_clk),
	.wrreq (wr_en),
	.q (sd_wr_data),
	.rdempty (),
	.rdusedw (fifo_rduse),
	.wrfull (wr_full),
	.wrusedw (wr_use)
	);

fifo_rd	fifo_rd_inst (
	.aclr (rd_load),
	.data (sd_rd_data),
	.rdclk (rd_clk),
	.rdreq (rd_en),
	.wrclk (sd_clk),
	.wrreq (sd_rdata_vaild),
	.q (rd_data),
	.rdempty (rd_empty),
	.rdusedw (rd_use),
	.wrfull (),
	.wrusedw (fifo_wruse)
	);

sdram_ctrl sdram_ctrl_inst(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .Wr(sd_wr),
    .Rd(sd_rd),
    .caddr(sd_caddr),
    .raddr(sd_raddr),
    .baddr(sd_baddr),
    .Wr_data(sd_wr_data),
    .Rd_data(sd_rd_data),
    .Wr_data_vaild(sd_wdata_vaild),
    .Rd_data_vaild(sd_rdata_vaild),
    .WRITE_done(sd_wdata_done),
    .READ_done(sd_rdata_done),
    .address(SA),
    .address_b(BA),
    .CS_N(CS_N),
    .CKE(CKE),
    .RAS_N(RAS_N),
    .CAS_N(CAS_N),
    .WE_N(WE_N),
    .Dq(Dq),
    .Dqm(Dqm)
);


always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        wr_sdram_addr <= wr_addr;
    else if (wr_load)
        wr_sdram_addr <= wr_addr;
    else if (sd_wdata_done) begin
        if (wr_sdram_addr == wr_max_addr-SC_BL)
            wr_sdram_addr <= wr_addr;
        else 
            wr_sdram_addr <= wr_sdram_addr + SC_BL;
    end else
        wr_sdram_addr <= wr_sdram_addr;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        rd_sdram_addr <= rd_addr;
    else if (rd_load)
        rd_sdram_addr <= rd_addr;
    else if (sd_rdata_done) begin
        if (rd_sdram_addr == rd_max_addr-SC_BL)
            rd_sdram_addr <= rd_addr;
        else
            rd_sdram_addr <= rd_sdram_addr + SC_BL;
    end else
        rd_sdram_addr <= rd_sdram_addr;
end

assign sd_wr_req = (fifo_rduse >= SC_BL) ? 1'b1 : 1'b0;
assign sd_rd_req = (!rd_load) && (fifo_wruse[7] == 1'b0)?1'b1:1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        sd_wr <= 1'b0;
    else if (sd_wr_req)
        sd_wr <= 1'b1;
    else
        sd_wr <= 1'b0;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        sd_rd <= 1'b0;
    else if (sd_rd_req)
        sd_rd <= 1'b1;
    else
        sd_rd <= 1'b0;
end

always @(*) begin
    if (!rst_n)
        sd_caddr <= 9'd0;
    else if (sd_wr_req)
        sd_caddr <= wr_sdram_addr[8:0];
    else if (sd_rd_req)
        sd_caddr <= rd_sdram_addr[8:0];
    else
        sd_caddr <= sd_caddr;
end

always @(*) begin
    if (!rst_n)
        sd_raddr <= 13'd0;
    else if (sd_wr_req)
        sd_raddr <= wr_sdram_addr[21:9];
    else if (sd_rd_req)
        sd_raddr <= rd_sdram_addr[21:9];
    else
        sd_raddr <= sd_raddr;
end


always @(*) begin
    if (!rst_n)
        sd_baddr <= 2'd0;
    else if (sd_wr_req)
        sd_baddr <= wr_sdram_addr[23:22];
    else if (sd_rd_req)
        sd_baddr <= rd_sdram_addr[23:22];
    else
        sd_baddr <= sd_baddr;
end

endmodule