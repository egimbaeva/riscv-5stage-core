module id_ex_reg (
    input clk,
    input rst_n,

    input [31:0] pc_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] imm_in,

    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    input [3:0] alu_op_in,
    input alu_src_in,


    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [3:0] alu_op_out,
    output reg alu_src_out
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_out <= 32'b0;
        rs1_data_out <= 32'b0;
        rs2_data_out <= 32'b0;
        imm_out <= 32'b0;

        rs1_out <= 5'b0;
        rs2_out <= 5'b0;
        rd_out <= 5'b0;

        alu_op_out <= 4'b0;
        alu_src_out <= 1'b0;
    end
end
    else begin 
        pc_out <= pc_in;
        rs1_data_out <= rs1_data_in;
        rs2_data_out <= rs2_data_in;
        imm_out <= imm_in;

        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;

        alu_op_out <= alu_op_in;
        alu_src_out <= alu_src_in;
    end
endmodule