module sdram_init (
    clk_100m,
    rst_n,

    command,
    address,
    init_done
);

`include    "Sdram_Params.h"

input   clk_100m;
input   rst_n;

output reg [3:0] command;
output reg [`ASIZE-1:0] address;
output init_done;

parameter WAIT_TIME = INIT_PRE,
            PRE_TIME = INIT_PRE + REF_PRE,
            REF_TIME = INIT_PRE + REF_PRE + REF_REF,
            REF2_TIME = INIT_PRE + REF_PRE + REF_REF*2,
            END_TIME = INIT_PRE + REF_PRE + REF_REF*2 + LMR_ACT;

reg [14:0] cnt;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        cnt <= 15'd0;
    else if (cnt < END_TIME)
        cnt <= cnt + 1'b1;
    else
        cnt <= 15'd0;
end

assign init_done = (cnt == END_TIME) ? 1'b1 : 1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) begin
        command <= C_NOP;
        address <= 0;
    end else 
        case (cnt)
            WAIT_TIME: begin
                command <= C_PRE;
                address[10] <= 1'b1;
            end
            PRE_TIME: command <= C_AREF;
            REF_TIME: command <= C_AREF;
            REF2_TIME: begin
                command <= C_MSET;
                address <= {OP_CODE,2'b00,SDR_CL,SDR_BT,SDR_BL};
            end
            default: begin
                command <= C_NOP;
                address <= 0;
            end
        endcase
    
end


endmodule