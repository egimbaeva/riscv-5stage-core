module top(
    input clk,
    input rst_n,
);
// IF 
wire [31:0] pc_if_in;
wire [31:0] instr_if_in;

// ID
wire [31:0] pc_id;
wire [31:0] instr_id;

wire [3:0] alu_op_id;
wire alu_src_id;
wire mem_write_id;
wire mem_read_id;
wire reg_write_id;
wire mem_to_reg_id;
wire branch_id;

// EX 
wire [31:0] pc_ex;

wire [31:0] rs1_data_ex;
wire [31:0] rs2_data_ex;
wire [31:0] imm_ex;
wire [4:0] rs1_ex;
wire [4:0] rs2_ex;  
wire [4:0] rd_ex;

wire [3:0] alu_op_ex;
wire alu_src_ex;
wire mem_write_ex;
wire mem_read_ex;
wire reg_write_ex;
wire mem_to_reg_ex;
wire branch_ex;

wire [31:0] alu_result_ex;

// MEM
wire [31:0] pc_mem;

wire [31:0] alu_result_mem;
wire [31:0] write_data_mem;
wire [4:0] rd_mem;
wire mem_write_mem;
wire mem_read_mem;
wire reg_write_mem;
wire mem_to_reg_mem;
wire branch_mem;

// WB
wire [31:0] pc_wb;

wire [31:0] read_data_mem_wb;
wire [31:0] alu_result_wb;
wire [4:0] rd_wb;
wire mem_to_reg_wb;
wire reg_write_wb;

wire [1:0] forward_a;
wire [1:0] forward_b;
reg [31:0] alu_src_a;
reg [31:0] alu_src_b;

// IF/ID 
if_id_reg if_id_reg_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pc_in(pc_if_in),
    .instr_in(instr_if_in),
    .pc_out(pc_id),
    .instr_out(instr_id)
);

control_unit control_unit_inst(
    .instr(instr_id),
    .alu_op(alu_op_id),
    .alu_src(alu_src_id),
    .mem_write(mem_write_id),
    .mem_read(mem_read_id),
    .reg_write(reg_write_id),
    .mem_to_reg(mem_to_reg_id),
    .branch(branch_id)
);

id_ex_reg id_ex_reg_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pc_in(pc_id),
    .rs1_data_in(rs1_data_id),
    .rs2_data_in(rs2_data_id),
    .imm_in(imm_id),
    .rs1_in(rs1_id),
    .rs2_in(rs2_id),
    .rd_in(rd_id),
    .alu_op_in(alu_op_id),
    .alu_src_in(alu_src_id),
    .mem_write_in(mem_write_id),
    .mem_read_in(mem_read_id),
    .reg_write_in(reg_write_id),
    .mem_to_reg_in(mem_to_reg_id),
    .branch_in(branch_id),
    .pc_out(pc_ex),
    .rs1_data_out(rs1_data_ex),
    .rs2_data_out(rs2_data_ex),
    .imm_out(imm_ex),
    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex),
    .rd_out(rd_ex),
    .alu_op_out(alu_op_ex),
    .alu_src_out(alu_src_ex),
    .mem_write_out(mem_write_ex),
    .mem_read_out(mem_read_ex),
    .reg_write_out(reg_write_ex),
    .mem_to_reg_out(mem_to_reg_ex),
    .branch_out(branch_ex)
);
ex_mem_reg ex_mem_reg_inst(
    .clk(clk),
    .rst_n(rst_n),
    .alu_result_in(alu_result_ex),
    .write_data_in(alu_src_b),
    .rd_in(rd_ex),
    .mem_write_in(mem_write_ex),
    .mem_read_in(mem_read_ex),
    .reg_write_in(reg_write_ex),
    .mem_to_reg_in(mem_to_reg_ex),
    .branch_in(branch_ex),
    .pc_in(pc_ex),
    .alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),
    .rd_out(rd_mem),
    .mem_write_out(mem_write_mem),
    .mem_read_out(mem_read_mem),
    .reg_write_out(reg_write_mem),
    .mem_to_reg_out(mem_to_reg_mem),
    .branch_out(branch_mem),
    .pc_out(pc_mem),
);
mem_wb_reg mem_wb_reg_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pc_in(pc_mem),
    .read_data_mem_in(read_data_mem_mem),
    .alu_result_in(alu_result_mem),
    .rd_in(rd_mem),
    .mem_to_reg_in(mem_to_reg_mem),
    .reg_write_in(reg_write_mem),
    .pc_out(pc_wb),
    .read_data_mem_out(read_data_mem_wb),
    .alu_result_out(alu_result_wb),
    .rd_out(rd_wb),
    .mem_to_reg_out(mem_to_reg_wb),
    .reg_write_out(reg_write_wb)
);
forwarding_unit forwarding_unit_inst(
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_mem(rd_mem),
    .rd_wb(rd_wb),
    .reg_write_mem(reg_write_mem),
    .reg_write_wb(reg_write_wb),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

always @(*) begin
    // Default values
    alu_src_a = rs1_data_ex;
    alu_src_b = rs2_data_ex;

    // Forwarding for ALU source A
    case (forward_a)
        2'b00: alu_src_a = rs1_data_ex; // No forwarding
        2'b01: alu_src_a = alu_result_wb; // Forward from WB stage
        2'b10: alu_src_a = alu_result_mem; // Forward from MEM stage
        default: alu_src_a = rs1_data_ex; // Default case
    endcase

    // Forwarding for ALU source B
    case (forward_b)
        2'b00: alu_src_b = rs2_data_ex; // No forwarding
        2'b01: alu_src_b = alu_result_wb; // Forward from WB stage
        2'b10: alu_src_b = alu_result_mem; // Forward from MEM stage
        default: alu_src_b = rs2_data_ex; // Default case
    endcase
end
wire [31:0] alu_operand_b = alu_src_ex ? imm_ex : alu_src_b;
reg [31:0] alu_out_comb;
always @(*) begin
    case (alu_op_ex)
        4'b0000: alu_out_comb = alu_src_a + alu_operand_b;
        4'b0001: alu_out_comb = alu_src_a - alu_operand_b;
        4'b0010: alu_out_comb = alu_src_a & alu_operand_b;
        4'b0011: alu_out_comb = alu_src_a | alu_operand_b;
        4'b0100: alu_out_comb = alu_src_a ^ alu_operand_b;
        4'b0101: alu_out_comb = alu_src_a << alu_operand_b[4:0];
        4'b0110: alu_out_comb = alu_src_a >> alu_operand_b[4:0];
        4'b0111: alu_out_comb = $signed(alu_src_a) >>> alu_operand_b[4:0];
        4'b1000: alu_out_comb = (alu_src_a < alu_operand_b) ? 32'b1 : 32'b0;
        default: alu_out_comb = 32'b0; // Default case
    endcase
end
assign alu_result_ex = alu_out_comb;
wire [31:0] write_data_wb = mem_to_reg_wb ? read_data_mem_wb : alu_result_wb;
endmodule