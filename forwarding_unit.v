module forwarding_unit (
    input [4:0] rs1_ex,
    input [4:0] rs2_ex,
    input [4:0] rd_mem,
    input [4:0] rd_wb,
    input reg_write_mem,
    input reg_write_wb,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);
always @(*) begin
    //default values
    forward_a = 2'b00;
    forward_b = 2'b00;
    if (reg_write_mem && (rd_mem != 0) && (rd_mem == rs1_ex)) begin
        forward_a = 2'b10; 
    end
    else if (reg_write_wb && (rd_wb != 0) && (rd_wb == rs1_ex)) begin
        forward_a = 2'b01;
    end
    if (reg_write_mem && (rd_mem != 0) && (rd_mem == rs2_ex)) begin
        forward_b = 2'b10;
    end
    else if (reg_write_wb && (rd_wb != 0) && (rd_wb == rs2_ex)) begin
        forward_b = 2'b01;
    end
end
endmodule