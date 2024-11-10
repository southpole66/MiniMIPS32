`include "defines.v"

module memwb_reg (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // ���Էô�׶ε���Ϣ
    input wire                   mem_whilo,
    input wire [`DOUBLE_REG_BUS] mem_hilo,
    input wire [  `REG_ADDR_BUS] mem_wa,
    input wire                   mem_wreg,
    input wire [       `REG_BUS] mem_dreg,
    input wire                   mem_mreg,
    input wire [       `REG_BUS] mem_din,
    input wire [      `BSEL_BUS] mem_dre,

    input wire mem_whi,
    input wire mem_wlo,

    input wire [`INST_ADDR_BUS] mem_debug_wb_pc,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    // ����д�ؽ׶ε���Ϣ 
    output reg                   wb_whilo,
    output reg [`DOUBLE_REG_BUS] wb_hilo,
    output reg [  `REG_ADDR_BUS] wb_wa,
    output reg                   wb_wreg,
    output reg [       `REG_BUS] wb_dreg,
    output reg                   wb_mreg,
    output reg [       `REG_BUS] wb_din,
    output reg [      `BSEL_BUS] wb_dre,

    output reg wb_whi,
    output reg wb_wlo,

    output wire [`INST_ADDR_BUS] wb_debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
);


  always @(posedge cpu_clk_50M) begin
    // ��λ��ʱ������д�ؽ׶ε���Ϣ��0
    if (cpu_rst_n == `RST_ENABLE) begin
      wb_wa    <= `REG_NOP;
      wb_wreg  <= `WRITE_DISABLE;
      wb_dreg  <= `ZERO_WORD;
      wb_whilo <= `WRITE_DISABLE;
      wb_hilo  <= `ZERO_DWORD;
      wb_dre   <= 4'b0;
      wb_mreg  <= `WRITE_DISABLE;
      wb_whi   <= `WRITE_DISABLE;
      wb_wlo   <= `WRITE_DISABLE;
    end  // �����Էô�׶ε���Ϣ�Ĵ沢����д�ؽ׶�
    else begin
      wb_wa    <= mem_wa;
      wb_wreg  <= mem_wreg;
      wb_dreg  <= mem_dreg;
      wb_whilo <= mem_whilo;
      wb_hilo  <= mem_hilo;
      wb_mreg  <= mem_mreg;
      wb_dre   <= mem_dre;
      wb_whi   <= mem_whi;
      wb_wlo   <= mem_wlo;
    end
  end

endmodule
