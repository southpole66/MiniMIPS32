`include "defines.v"

module idexe_reg (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // ��������׶ε���Ϣ
    input wire [  `ALUTYPE_BUS] id_alutype,
    input wire [    `ALUOP_BUS] id_aluop,
    input wire                  id_whilo,
    input wire [      `REG_BUS] id_src1,
    input wire [      `REG_BUS] id_src2,
    input wire [ `REG_ADDR_BUS] id_wa,
    input wire                  id_we,
    input wire                  id_wreg,
    input wire [      `REG_BUS] id_din,
    input wire                  id_mreg,
    input wire [`INST_ADDR_BUS] id_debug_wb_pc, // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    // ����ִ�н׶ε���Ϣ
    output reg [  `ALUTYPE_BUS] exe_alutype,
    output reg [    `ALUOP_BUS] exe_aluop,
    output reg [      `REG_BUS] exe_src1,
    output reg [      `REG_BUS] exe_src2,
    output reg [ `REG_ADDR_BUS] exe_wa,
    output reg                  exe_we,
    output reg                  exe_wreg,
    output reg [      `REG_BUS] exe_din,
    output reg                  exe_whilo,
    output reg                  exe_mreg,
    output reg [`INST_ADDR_BUS] exe_debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
);

  always @(posedge cpu_clk_50M) begin
    // ��λ��ʱ������ִ�н׶ε���Ϣ��0
    if (cpu_rst_n == `RST_ENABLE) begin
      exe_alutype     <= `NOP;
      exe_aluop       <= `MINIMIPS32_SLL;
      exe_src1        <= `ZERO_WORD;
      exe_src2        <= `ZERO_WORD;
      exe_wa          <= `REG_NOP;
      exe_wreg        <= `WRITE_DISABLE;
      exe_we          <= `FALSE_V;
      exe_debug_wb_pc <= `PC_INIT;  // �ϰ����ʱ���ɾ�������
    end  // ����������׶ε���Ϣ�Ĵ沢����ִ�н׶�
    else begin
      exe_alutype     <= id_alutype;
      exe_aluop       <= id_aluop;
      exe_src1        <= id_src1;
      exe_src2        <= id_src2;
      exe_wa          <= id_wa;
      exe_wreg        <= id_wreg;
      exe_din         <= id_din;
      exe_whilo       <= id_whilo;
      exe_mreg        <= id_mreg;
      exe_we          <= id_we;
      exe_debug_wb_pc <= id_debug_wb_pc;  // �ϰ����ʱ���ɾ�������
    end
  end

endmodule
