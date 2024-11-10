`include "defines.v"

module wb_stage (

    // �ӷô�׶λ�õ���Ϣ
    input wire                   wb_mreg_i,
    input wire [      `BSEL_BUS] wb_dre_i,
    input wire [  `REG_ADDR_BUS] wb_wa_i,
    input wire                   wb_wreg_i,
    input wire [       `REG_BUS] wb_dreg_i,
    input wire                   wb_whilo_i,
    input wire [`DOUBLE_REG_BUS] wb_hilo_i,
    input wire                   wb_whi_i,
    input wire                   wb_wlo_i,
    input wire [ `INST_ADDR_BUS] wb_debug_wb_pc, // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    input wire [`WORD_BUS] dm,

    // д��Ŀ�ļĴ���������
    output wire [  `REG_ADDR_BUS] wb_wa_o,
    output wire                   wb_wreg_o,
    output wire [      `WORD_BUS] wb_wd_o,
    output wire                   wb_whilo_o,
    output wire [`DOUBLE_REG_BUS] wb_hilo_o,
    output wire                   wb_whi_o,
    output wire                   wb_wlo_o,

    output wire [`INST_ADDR_BUS] debug_wb_pc,       // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire                  debug_wb_rf_wen,   // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire [ `REG_ADDR_BUS] debug_wb_rf_wnum,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire [     `WORD_BUS] debug_wb_rf_wdata  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
);

  // ����ͨ�üĴ����Ѻ�HILO�Ĵ������ź�
  assign wb_wa_o    = wb_wa_i;
  assign wb_wreg_o  = wb_wreg_i;
  assign wb_whilo_o = wb_whilo_i;
  assign wb_hilo_o  = wb_hilo_i;
  assign wb_whi_o   = wb_whi_i;
  assign wb_wlo_o   = wb_wlo_i;

  // ���ݶ��ֽ�ʹ���źţ������ݴ洢��������������ѡ���Ӧ���ֽ�   
  wire[`WORD_BUS] data = (wb_dre_i == 4'b1111) ? {dm[7:0], dm[15:8], dm[23:16], dm[31:24]} :
                            (wb_dre_i == 4'b1000) ? {{24{dm[31]}}, dm[31:24]} :
                            (wb_dre_i == 4'b0100) ? {{24{dm[23]}}, dm[23:16]} :
                            (wb_dre_i == 4'b0010) ? {{24{dm[15]}}, dm[15:8]} :
                            (wb_dre_i == 4'b0001) ? {{24{dm[7]}}, dm[7:0]} :
                            
                            (wb_dre_i == 4'b1100) ? {{16{dm[23]}}, dm[23:16], dm[31:24]} :
                            (wb_dre_i == 4'b0011) ? {{16{dm[7]}}, dm[7:0], dm[15:8]} : `ZERO_WORD;
  // ���ݴ洢�����Ĵ���ʹ���ź�mreg��ѡ�����մ�д��ͨ�üĴ���������
  assign wb_wd_o           = (wb_mreg_i == `MREG_ENABLE) ? data : wb_dreg_i;

  assign debug_wb_pc       = wb_debug_wb_pc;  // �ϰ����ʱ���ɾ�������
  assign debug_wb_rf_wen   = wb_wreg_i;  // �ϰ����ʱ���ɾ������� 
  assign debug_wb_rf_wnum  = wb_wa_i;  // �ϰ����ʱ���ɾ�������
  assign debug_wb_rf_wdata = wb_dreg_i;  // �ϰ����ʱ���ɾ������� 

endmodule
