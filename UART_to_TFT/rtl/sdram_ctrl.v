module sdram_ctrl (
    clk_100m,
    rst_n,
    
    Wr,
    Rd,
    caddr,
    raddr,
    baddr,
    Wr_data,
    Rd_data,
    Wr_data_vaild,
    Rd_data_vaild,
    WRITE_done,
    READ_done,

    address,
    address_b,
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

input Wr;
input Rd;

input [`ASIZE-1:0] caddr;
input [`ASIZE-1:0] raddr;
input [`BSIZE-1:0] baddr;
input [`DSIZE-1:0] Wr_data;
output [`DSIZE-1:0] Rd_data;

output reg [`ASIZE-1:0] address;
output reg [`BSIZE-1:0] address_b;
output CS_N;
output CKE;
output RAS_N;
output CAS_N;
output WE_N;

output reg Rd_data_vaild;
output reg Wr_data_vaild;
output WRITE_done;
output READ_done;

inout [`DSIZE-1:0] Dq;
output [`DSIZE/8-1:0] Dqm;

wire [3:0] init_command;
wire [`ASIZE-1:0] init_address;

reg [3:0] command;

reg [`ASIZE-1:0] caddr_r;
reg [`ASIZE-1:0] raddr_r;
reg [`BSIZE-1:0] baddr_r;


wire init_done;
wire AREF_done;

wire ref_break_wr;
wire ref_break_rd;
wire wr_break_ref;
wire rd_break_ref;

reg FF;

wire ref_time_flag;

reg ref_opt;
reg read_opt;
reg write_opt;

reg write_opt_done;
reg read_opt_done;
reg ref_opt_done;

reg AREF_req;
reg READ_req;
reg WRITE_req;

reg [15:0] ref_cnt;
reg [31:0] ref_time_cnt;
reg [15:0] write_cnt;
reg [15:0] read_cnt;

reg [3:0] state;
parameter IDLE = 4'b0001,
            AREF = 4'b0010,
            READ = 4'b0100,
            WRITE = 4'b1000;

sdram_init sdram_init(
    .clk_100m(clk_100m),
    .rst_n(rst_n),
    .command(init_command),
    .address(init_address),
    .init_done(init_done)
);

assign CKE = rst_n;
assign {CS_N,RAS_N,CAS_N,WE_N} = command;
assign Dq = Wr_data_vaild ? Wr_data : 16'bz;
assign Rd_data = Dq;
assign Dqm = 2'b00;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n)
        ref_time_cnt <= 32'd0;
    else if (ref_time_cnt == AUTO_REF)
        ref_time_cnt <= 32'd1;
    else if (init_done || ref_time_cnt>1'b0)
        ref_time_cnt <= ref_time_cnt + 1'b1;
    else
        ref_time_cnt <= ref_time_cnt;
end

assign ref_time_flag = (ref_time_cnt==AUTO_REF)?1'b1:1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        FF <= 1'b1;
    end else
        case (state)
            IDLE: begin
                state <= (init_done) ? AREF : IDLE;
                command <= init_command;
                address <= init_address;
            end
            AREF: begin
                if (FF == 1'b0)
                    auto_ref;
                else begin
                    if (READ_req) begin
                        state <= READ;
                        FF <= 1'b0;
                    end
                    else if (WRITE_req) begin
                        state <= WRITE;
                        FF <= 1'b0;
                    end
                    else if (AREF_req) begin
                        state <= AREF;
                        FF <= 1'b0;
                    end
                    else
                        state <= AREF;
                end
            end
            READ: begin
                if (FF == 1'b0)
                    read_data;
                else begin
                    if (read_opt_done & READ_req) begin
                        state <= READ;
                        FF <= 1'b0;
                    end
                    else if (read_opt_done & WRITE_req) begin
                        state <= WRITE;
                        FF <= 1'b0;
                    end
                    else if (AREF_req) begin
                        state <= AREF;
                        FF <= 1'b0;
                    end
                    else if (read_opt_done &!WRITE_req&!READ_req)
                        state <= AREF; 
                    else
                        state <= READ;                      
                end
            end
            WRITE: begin
                if (FF == 1'b0)
                    write_data;
                else begin
                    if (write_opt_done & READ_req) begin
                        state <= READ;
                        FF <= 1'b0;
                    end
                    else if (write_opt_done & WRITE_req) begin
                        state <= WRITE;
                        FF <= 1'b0;
                    end
                    else if (AREF_req) begin
                        state <= AREF;
                        FF <= 1'b0;
                    end
                    else if (write_opt_done &!WRITE_req&!READ_req)
                        state <= AREF;                    
                    else
                        state <= WRITE;
                end
            end
        endcase
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) begin
        caddr_r <= 0;
        raddr_r <= 0;
        baddr_r <= 0;
    end else if (WRITE_req || READ_req) begin
        caddr_r <= caddr;
        raddr_r <= raddr;
        baddr_r <= baddr;       
    end
end


parameter ref_PRE_TIME = 1'b1,
            ref_REF_TIME = REF_PRE+1'b1,
            ref_REF2_TIME = REF_PRE+REF_REF+1'b1,
            ref_END_TIME = REF_PRE+REF_REF*2;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        ref_cnt <= 16'd0;
    else if (ref_cnt == ref_END_TIME)
        ref_cnt <= 16'd0;
    else if (AREF_req || ref_cnt>16'd0)
        ref_cnt <= ref_cnt + 1'b1;
    else
        ref_cnt <= ref_cnt;
end

assign AREF_done = (ref_cnt == ref_END_TIME) ? 1'b1 : 1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        ref_opt_done <= 1'b0;
    else if (ref_cnt == ref_END_TIME)
        ref_opt_done <= 1'b1;
    else
        ref_opt_done <= 1'b0;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        ref_opt <= 1'b0;
    else if (AREF_req == 1'b1)
        ref_opt <= 1'b1;
    else if (ref_opt_done == 1'b1)
        ref_opt <= 1'b0;
    else
        ref_opt <= ref_opt;
end

task auto_ref;
begin
    case (ref_cnt)
        ref_PRE_TIME: begin
            command <= C_PRE;
            address[10] <= 1'b1;
        end
        ref_REF_TIME: begin
            command <= C_AREF;
        end
        ref_REF2_TIME: begin
            command <= C_AREF;
        end
        ref_END_TIME: begin
            command <= C_NOP;
            FF <= 1'b1;
        end
        default: begin
            command <= C_NOP;
        end
    endcase
end
endtask


parameter WRITE_ACT_TIME = 1'b1,
            WRITE_WR_TIME = SC_RCD + 1'b1,
            WRITE_PRE_TIME = SC_RCD + WR_PRE + SC_BL + 1'b1,
            WRITE_END_TIME = SC_RCD + WR_PRE + SC_BL + REF_PRE;


always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        write_cnt <= 0;
    else if (write_cnt == WRITE_END_TIME)
        write_cnt <= 0;
    else if (WRITE_req || write_cnt>1'b0)
        write_cnt <= write_cnt + 1'b1;
    else
        write_cnt <= 16'd0;
end

assign WRITE_done = (write_cnt==SC_RCD+SC_BL+1)?1'b1:1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        write_opt <= 1'b0;
    else if (WRITE_req == 1'b1)
        write_opt <= 1'b1;
    else if (write_opt_done == 1'b1)
        write_opt <= 1'b0;
    else
        write_opt <= write_opt;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        write_opt_done <= 1'b0;
    else if (write_cnt == WRITE_END_TIME)
        write_opt_done <= 1'b1;
    else
        write_opt_done <= 1'b0;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        Wr_data_vaild <= 1'b0;
    else if ((write_cnt>SC_RCD)&&(write_cnt<=SC_RCD+SC_BL))
        Wr_data_vaild <= 1'b1; 
    else
        Wr_data_vaild <= 1'b0; 
end

task write_data;
begin
    case (write_cnt)
        WRITE_ACT_TIME: begin
            command <= C_ACT;
            address <= raddr_r;
            address_b <= baddr_r;
        end
        WRITE_WR_TIME: begin
            command <= C_WR;
            address <= {1'b0, caddr_r[8:0]};
            address_b <= baddr_r;
        end
        WRITE_PRE_TIME: begin
            command <= C_PRE;
            address[10] <= 1'b1;
        end
        WRITE_END_TIME: begin
            command <= C_NOP;
            FF <= 1'b1;
        end
        default: command <= C_NOP;
    endcase
end
endtask


parameter READ_ACT_TIME = 1'b1,
            READ_REC_TIME = SC_RCD + 1'b1,
            READ_PRE_TIME = SC_RCD + SC_BL + 1'b1,
            READ_END_TIME = SC_RCD + SC_BL + SC_CL;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        read_cnt <= 16'd0;
    else if (read_cnt == READ_END_TIME)
        read_cnt <= 16'd0;
    else if (READ_req || read_cnt>16'd0)
        read_cnt <= read_cnt + 1'b1;
    else
        read_cnt <= 16'd0;
end

assign READ_done = (read_cnt == READ_END_TIME) ? 1'b1 : 1'b0;

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        read_opt <= 1'b0;
    else if (READ_req == 1'b1)
        read_opt <= 1'b1;
    else if (read_opt_done == 1'b1)
        read_opt <= 1'b0;
    else
        read_opt <= read_opt;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        read_opt_done <= 1'b0;
    else if (read_cnt == READ_END_TIME)
        read_opt_done <= 1'b1;
    else
        read_opt_done <= 1'b0;
end

always @(posedge clk_100m or negedge rst_n) begin
    if (!rst_n) 
        Rd_data_vaild <= 1'b0;
    else if ((read_cnt>SC_RCD+SC_CL)&&(read_cnt<=SC_RCD+SC_BL+SC_CL))
        Rd_data_vaild <= 1'b1;
    else
        Rd_data_vaild <= 1'b0;
end

task read_data;
begin
    case (read_cnt)
        READ_ACT_TIME: begin
            command <= C_ACT;
            address <= raddr_r;
            address_b <= baddr_r;
        end 
        READ_REC_TIME: begin
            command <= C_RD;
            address <= {1'b0, caddr_r[8:0]};
            address_b <= baddr_r;
        end
        READ_PRE_TIME: begin
            command <= C_PRE;
            address[10] <= 1'b1;
        end
        READ_END_TIME: begin
            command <= C_NOP;
            FF <= 1'b1;
        end
        default: command <= C_NOP;
    endcase
end
endtask

assign ref_break_wr = (ref_time_flag && write_opt)?1'b1:
                        ((!write_opt)?1'b0:ref_break_wr);

assign ref_break_rd = (ref_time_flag && read_opt)?1'b1:
                        ((!read_opt)?1'b0:ref_break_rd);

assign wr_break_ref = (Wr && ref_opt)?1'b1:
                        ((!ref_opt)?1'b0:wr_break_ref);

assign rd_break_ref = ((Rd && ref_opt)?1'b1:
                        ((!ref_opt)?1'b0:rd_break_ref));


always @(*) begin
    case (state)
        AREF: begin
            if (ref_time_flag)
                AREF_req <= 1'b1;
            else
                AREF_req <= 1'b0;
        end
        READ: begin
            if (ref_break_rd && read_opt_done)
                AREF_req <= 1'b1;
            else
                AREF_req <= 1'b0;
        end

        WRITE: begin
            if (ref_break_wr && write_opt_done)
                AREF_req <= 1'b1;
            else
                AREF_req <= 1'b0;            
        end
        default: AREF_req <= 1'b0;
    endcase
end

always @(*) begin
    case (state)
        AREF: begin
            if ((!rd_break_ref) && (!wr_break_ref)&&
                (!ref_time_flag) && !Wr && Rd)
                READ_req <= 1'b1;
            else if (ref_opt_done && !wr_break_ref && rd_break_ref)
                READ_req <= 1'b1;
            else
                READ_req <= 1'b0;
        end
        READ: begin
            if (read_opt_done && !ref_break_rd && !Wr && Rd)
                READ_req <= 1'b1;
            else
                READ_req <= 1'b0;
        end

        WRITE: begin
            if (write_opt_done && !ref_break_wr && !Wr && Rd)
                READ_req <= 1'b1;
            else
                READ_req <= 1'b0;            
        end
        default: READ_req <= 1'b0;
    endcase
end

always @(*) begin
    case (state)
        AREF: begin
            if ((!wr_break_ref) && Wr && !ref_time_flag)
                WRITE_req <= 1'b1;
            else if (wr_break_ref && ref_opt_done)
                WRITE_req <= 1'b1;
            else
                WRITE_req <= 1'b0;
        end 

        WRITE: begin
            if (write_opt_done && Wr && !ref_break_wr)
                WRITE_req <= 1'b1;
            else
                WRITE_req <= 1'b0;
        end

        READ: begin
            if (read_opt_done && Wr && !ref_break_rd)
                WRITE_req = 1'b1;
            else
                WRITE_req = 1'b0;
        end
        default: WRITE_req = 1'b0;
    endcase
end


endmodule