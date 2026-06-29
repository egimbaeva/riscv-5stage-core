module control_unit (
    input [6:0] opcode,
    output reg [3:0] alu_op,
    output reg alu_src,
    output reg mem_write,
    output reg mem_read,
    output reg reg_write,
    output reg mem_to_reg,
    output reg branch
);
localparam R_TYPE = 7'b0110011;
localparam I_TYPE = 7'b0010011;
localparam LOAD = 7'b0000011;
localparam STORE = 7'b0100011;
localparam BRANCH = 7'b1100011;

always @(*) begin
    alu_op = 4'b0000;
    alu_src = 1'b0;
    mem_write = 1'b0;
    mem_read = 1'b0;
    reg_write = 1'b0;
    mem_to_reg = 1'b0;
    branch = 1'b0;

    case(opcode)
    //R-type
    R_TYPE: begin
        reg_write = 1'b1;
        alu_src = 1'b0;
        alu_op = 4'b0010; // ALU operation for R-type instructions     
    end
    I_TYPE: begin // I-type
        reg_write = 1'b1;
        alu_src = 1'b1;
        alu_op = 4'b1000; // ALU operation for I-type instructions
    end
    LOAD: begin // Load
        reg_write = 1'b1;
        alu_src = 1'b1;
        mem_read = 1'b1;
        mem_to_reg = 1'b1;
        alu_op = 4'b0000; // ALU operation for load instructions
    end
    STORE: begin // Store
        alu_src = 1'b1;
        mem_write = 1'b1;
        alu_op = 4'b0000; // ALU operation for store instructions
    end
    BRANCH: begin // Branch
        branch = 1'b1;
        alu_src = 1'b0;
        alu_op = 4'b0110; // ALU operation for branch instructions
    end
    default: begin
        alu_op = 4'b0000;
        alu_src = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;    
        reg_write = 1'b0;
        mem_to_reg = 1'b0;
        branch = 1'b0;
    end
    endcase
end
endmodule