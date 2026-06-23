module mem_wb_reg (
    input [31:0] pc_in,
    input [31:0] read_data_mem_in,
    input [31:0] alu_result_in,
    input [4:0] rd_in,
    input mem_to_reg_in,
    input reg_write_in,
    input clk,
    input rst_n,

    output reg [31:0] pc_out,
    output reg [31:0] read_data_mem_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out,
    output reg mem_to_reg_out,
    output reg reg_write_out
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_out <= 32'b0;
        read_data_mem_out <= 32'b0;
        alu_result_out <= 32'b0;
        rd_out <= 5'b0;
        mem_to_reg_out <= 1'b0;
        reg_write_out <= 1'b0;
    end
    else begin 
        pc_out <= pc_in;
        read_data_mem_out <= read_data_mem_in;
        alu_result_out <= alu_result_in;
        rd_out <= rd_in;
        mem_to_reg_out <= mem_to_reg_in;
        reg_write_out <= reg_write_in;
    end
end
endmodule