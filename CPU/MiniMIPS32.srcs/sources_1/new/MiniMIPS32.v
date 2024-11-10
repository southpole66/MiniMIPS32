`include "defines.v"

module MiniMIPS32 (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // inst_rom
    output wire [`INST_ADDR_BUS] iaddr,
    output wire                  ice,
    input  wire [     `INST_BUS] inst,

    // data_ram
    output wire                  dce,
    output wire [`INST_ADDR_BUS] daddr,
    output wire [     `BSEL_BUS] we,
    output wire [     `INST_BUS] din,
    input  wire [     `INST_BUS] dm,

    output wire [`INST_ADDR_BUS] debug_wb_pc,       // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire                  debug_wb_rf_wen,   // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire [ `REG_ADDR_BUS] debug_wb_rf_wnum,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    output wire [     `WORD_BUS] debug_wb_rf_wdata  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
);

  wire [      `WORD_BUS] pc;

  /*---------------id�׶��ź�------------------*/
  // ����IF/IDģ��������׶�IDģ��ı��� 
  wire [      `WORD_BUS] id_pc_i;

  // ��������׶�IDģ����ͨ�üĴ���Regfileģ��ı��� 
  wire                   re1;
  wire [  `REG_ADDR_BUS] ra1;
  wire [       `REG_BUS] rd1;
  wire                   re2;
  wire [  `REG_ADDR_BUS] ra2;
  wire [       `REG_BUS] rd2;

  wire [     `ALUOP_BUS] id_aluop_o;
  wire [   `ALUTYPE_BUS] id_alutype_o;
  wire [       `REG_BUS] id_src1_o;
  wire [       `REG_BUS] id_src2_o;
  wire                   id_wreg_o;
  wire [  `REG_ADDR_BUS] id_wa_o;
  wire                   id_we_o;
  wire                   id_whilo_o;
  wire                   id_mreg_o;
  wire [       `REG_BUS] id_din_o;
  wire                   id_whi_o;
  wire                   id_wlo_o;
  /*------------------------------------------*/

  /*---------------exe�׶��ź�------------------*/
  wire [   `ALUTYPE_BUS] exe_alutype_i;
  wire [     `ALUOP_BUS] exe_aluop_i;
  wire [       `REG_BUS] exe_src1_i;
  wire [       `REG_BUS] exe_src2_i;
  wire [  `REG_ADDR_BUS] exe_wa_i;
  wire                   exe_wreg_i;
  wire                   exe_mreg_i;
  wire [       `REG_BUS] exe_din_i;
  wire                   exe_whilo_i;
  wire [       `REG_BUS] exe_whi_i;
  wire [       `REG_BUS] exe_wlo_i;

  wire [       `REG_BUS] hi_i;
  wire [       `REG_BUS] lo_i;

  wire [     `ALUOP_BUS] exe_aluop_o;
  wire [  `REG_ADDR_BUS] exe_wa_o;
  wire                   exe_wreg_o;
  wire [       `REG_BUS] exe_wd_o;
  wire                   exe_mreg_o;
  wire [       `REG_BUS] exe_din_o;
  wire                   exe_whilo_o;
  wire [`DOUBLE_REG_BUS] exe_hilo_o;
  wire                   exe_whi_o;
  wire                   exe_wlo_o;
  /*------------------------------------------*/

  /*----------------mem�׶��ź�-----------------*/
  wire [     `ALUOP_BUS] mem_aluop_i;
  wire                   mem_wreg_i;
  wire [  `REG_ADDR_BUS] mem_wa_i;
  wire [       `REG_BUS] mem_wd_i;
  wire                   mem_mreg_i;
  wire [       `REG_BUS] mem_din_i;
  wire                   mem_whilo_i;
  wire [`DOUBLE_REG_BUS] mem_hilo_i;
  wire                   mem_whi_i;
  wire                   mem_wlo_i;

  wire                   mem_wreg_o;
  wire [  `REG_ADDR_BUS] mem_wa_o;
  wire [       `REG_BUS] mem_dreg_o;
  wire                   mem_mreg_o;
  wire                   mem_whilo_o;
  wire [`DOUBLE_REG_BUS] mem_hilo_o;
  wire                   mem_whi_o;
  wire                   mem_wlo_o;
  wire [      `BSEL_BUS] dre;
  /*------------------------------------------*/

  /*----------------wb�׶��ź�-----------------*/
  wire                   wb_mreg_i;
  wire [      `BSEL_BUS] wb_dre_i;
  wire [  `REG_ADDR_BUS] wb_wa_i;
  wire                   wb_wreg_i;
  wire [       `REG_BUS] wb_dreg_i;
  wire                   wb_whilo_i;
  wire [`DOUBLE_REG_BUS] wb_hilo_i;
  wire                   wb_whi_i;
  wire                   wb_wlo_i;

  wire [  `REG_ADDR_BUS] wb_wa_o;
  wire                   wb_wreg_o;
  wire [      `WORD_BUS] wb_wd_o;
  wire                   wb_whilo_o;
  wire [`DOUBLE_REG_BUS] wb_hilo_o;
  wire                   wb_whi_o;
  wire                   wb_wlo_o;
  /*------------------------------------------*/


  wire [ `INST_ADDR_BUS] if_debug_wb_pc;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] id_debug_wb_pc_i;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] id_debug_wb_pc_o;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] exe_debug_wb_pc_i;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] exe_debug_wb_pc_o;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] mem_debug_wb_pc_i;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] mem_debug_wb_pc_o;  // �ϰ����ʱ���ɾ�����ź�
  wire [ `INST_ADDR_BUS] wb_debug_wb_pc_i;  // �ϰ����ʱ���ɾ�����ź�

  // �ӿ�����
  if_stage if_stage0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .pc         (pc),
      .ice        (ice),
      .iaddr      (iaddr),
      .debug_wb_pc(if_debug_wb_pc)
  );

  // �ӿ�����
  ifid_reg ifid_reg0 (
      .cpu_clk_50M   (cpu_clk_50M),
      .cpu_rst_n     (cpu_rst_n),
      .if_pc         (pc),
      .if_debug_wb_pc(if_debug_wb_pc),
      .id_pc         (id_pc_i),
      .id_debug_wb_pc(id_debug_wb_pc_i)
  );

  // �ӿ�����
  id_stage id_stage0 (
      .id_pc_i     (id_pc_i),
      .id_inst_i   (inst),
      .rd1         (rd1),
      .rd2         (rd2),
      .rreg1       (re1),
      .rreg2       (re2),
      .ra1         (ra1),
      .ra2         (ra2),
      .id_aluop_o  (id_aluop_o),
      .id_alutype_o(id_alutype_o),
      .id_src1_o   (id_src1_o),
      .id_src2_o   (id_src2_o),
      .id_wa_o     (id_wa_o),
      .id_wreg_o   (id_wreg_o),
      .id_whilo_o  (id_whilo_o),
      .id_whi_o    (id_whi_o),
      .id_wlo_o    (id_wlo_o),
      .id_mreg_o   (id_mreg_o),
      .id_din_o    (id_din_o)
  );

  // �ӿ�����
  regfile regfile0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .we         (wb_wreg_o),
      .wa         (wb_wa_o),
      .wd         (wb_wd_o),
      .re1        (re1),
      .ra1        (ra1),
      .rd1        (rd1),
      .re2        (re2),
      .ra2        (ra2),
      .rd2        (rd2)
  );

  // �ӿ�����
  idexe_reg idexe_reg0 (
      .cpu_clk_50M    (cpu_clk_50M),
      .cpu_rst_n      (cpu_rst_n),
      .id_alutype     (id_alutype_o),
      .id_aluop       (id_aluop_o),
      .id_src1        (id_src1_o),
      .id_src2        (id_src2_o),
      .id_din         (id_din_o),
      .id_wa          (id_wa_o),
      .id_wreg        (id_wreg_o),
      .id_debug_wb_pc (id_debug_wb_pc_o),
      .exe_alutype    (exe_alutype_i),
      .exe_aluop      (exe_aluop_i),
      .exe_src1       (exe_src1_i),
      .exe_src2       (exe_src2_i),
      .exe_din        (exe_din_i),
      .exe_wa         (exe_wa_i),
      .exe_wreg       (exe_wreg_i),
      .exe_debug_wb_pc(exe_debug_wb_pc_i)
  );

  // �ӿ�����
  exe_stage exe_stage0 (
      .exe_alutype_i  (exe_alutype_i),
      .exe_aluop_i    (exe_aluop_i),
      .exe_src1_i     (exe_src1_i),
      .exe_src2_i     (exe_src2_i),
      .exe_wa_i       (exe_wa_i),
      .exe_wreg_i     (exe_wreg_i),
      .exe_mreg_i     (exe_mreg_i),
      .exe_din_i      (exe_din_i),
      .exe_whilo_i    (exe_whilo_i),
      .exe_whi_i      (exe_whi_i),
      .exe_wlo_i      (exe_wlo_i),
      .hi_i           (hi_i),
      .lo_i           (lo_i),
      .exe_debug_wb_pc(exe_debug_wb_pc_i),

      .exe_aluop_o(exe_aluop_o),
      .exe_wa_o   (exe_wa_o),
      .exe_wreg_o (exe_wreg_o),
      .exe_wd_o   (exe_wd_o),
      .exe_mreg_o (exe_mreg_o),
      .exe_din_o  (exe_din_o),
      .exe_whilo_o(exe_whilo_o),
      .exe_hilo_o (exe_hilo_o),
      .exe_whi_o  (exe_whi_o),
      .exe_wlo_o  (exe_wlo_o),
      .debug_wb_pc(exe_debug_wb_pc_o)
  );


  // �ӿ�����
  exemem_reg exemem_reg0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),

      .exe_aluop      (exe_aluop_o),
      .exe_wa         (exe_wa_o),
      .exe_wreg       (exe_wreg_o),
      .exe_wd         (exe_wd_o),
      .exe_whilo      (exe_whilo_o),
      .exe_hilo       (exe_hilo_o),
      .exe_whi        (exe_whi_o),
      .exe_wlo        (exe_wlo_o),
      .exe_mreg       (exe_mreg_o),
      .exe_debug_wb_pc(exe_debug_wb_pc_o),

      .mem_aluop      (mem_aluop_i),
      .mem_wa         (mem_wa_i),
      .mem_wreg       (mem_wreg_i),
      .mem_wd         (mem_wd_i),
      .mem_whilo      (mem_whilo_i),
      .mem_hilo       (mem_hilo_i),
      .mem_whi        (mem_whi_i),
      .mem_wlo        (mem_wlo_i),
      .mem_mreg       (mem_mreg_i),
      .mem_din        (mem_din_i),
      .mem_debug_wb_pc(mem_debug_wb_pc_i)
  );

  // �ӿ�����
  mem_stage mem_stage0 (
      .mem_aluop_i    (mem_aluop_i),
      .mem_wa_i       (mem_wa_i),
      .mem_wreg_i     (mem_wreg_i),
      .mem_wd_i       (mem_wd_i),
      .mem_mreg_i     (mem_mreg_i),
      .mem_din_i      (mem_din_i),
      .mem_whilo_i    (mem_whilo_i),
      .mem_hilo_i     (mem_hilo_i),
      .mem_whi_i      (mem_whi_i),
      .mem_wlo_i      (mem_wlo_i),
      .mem_debug_wb_pc(mem_debug_wb_pc_i),


      .mem_wa_o   (mem_wa_o),
      .mem_wreg_o (mem_wreg_o),
      .mem_dreg_o (mem_dreg_o),
      .mem_mreg_o (mem_mreg_o),
      .mem_whilo_o(mem_whilo_o),
      .mem_hilo_o (mem_hilo_o),
      .mem_whi_o  (mem_whi_o),
      .mem_wlo_o  (mem_wlo_o),
      .dre        (dre),
      .dce        (dce),
      .daddr      (daddr),
      .we         (we),
      .din        (din),
      .debug_wb_pc(mem_debug_wb_pc_o)
  );

  // �ӿ�����
  memwb_reg memwb_reg0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),

      .mem_whilo      (mem_whilo_o),
      .mem_hilo       (mem_hilo_o),
      .mem_wa         (mem_wa_o),
      .mem_wreg       (mem_wreg_o),
      .mem_dreg       (mem_dreg_o),
      .mem_mreg       (mem_mreg_o),
      .mem_din        (mem_din_o),
      .mem_dre        (dre),
      .mem_whi        (mem_whi_o),
      .mem_wlo        (mem_wlo_o),
      .mem_debug_wb_pc(mem_debug_wb_pc_o),

      .wb_whilo      (wb_whilo),
      .wb_hilo       (wb_hilo),
      .wb_wa         (wb_wa),
      .wb_wreg       (wb_wreg),
      .wb_dreg       (wb_dreg),
      .wb_mreg       (wb_mreg),
      .wb_din        (wb_din),
      .wb_dre        (wb_dre),
      .wb_whi        (wb_whi),
      .wb_wlo        (wb_wlo),
      .wb_debug_wb_pc(wb_debug_wb_pc_i)
  );


  wb_stage wb_stage0 (
      .wb_mreg_i     (wb_mreg_i),
      .wb_dre_i      (wb_dre_i),
      .wb_wa_i       (wb_wa_i),
      .wb_wreg_i     (wb_wreg_i),
      .wb_dreg_i     (wb_dreg_i),
      .wb_whilo_i    (wb_whilo_i),
      .wb_hilo_i     (wb_hilo_i),
      .wb_whi_i      (wb_whi_i),
      .wb_wlo_i      (wb_wlo_i),
      .wb_debug_wb_pc(wb_debug_wb_pc_i),

      .wb_wa_o   (wb_wa_o),
      .wb_wreg_o (wb_wreg_o),
      .wb_wd_o   (wb_wd_o),
      .wb_whilo_o(wb_whilo_o),
      .wb_hilo_o (wb_hilo_o),
      .wb_whi_o  (wb_whi_o),
      .wb_wlo_o  (wb_wlo_o),

      .debug_wb_pc      (debug_wb_pc),
      .debug_wb_rf_wen  (debug_wb_rf_wen),
      .debug_wb_rf_wnum (debug_wb_rf_wnum),
      .debug_wb_rf_wdata(debug_wb_rf_wdata)
  );

  hilohilo hilo0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .we         (wb_whilo_o),
      .we_hi      (wb_whi_o),
      .we_lo      (wb_wlo_o),
      .hi_i       (wb_hilo_o[63:32]),
      .lo_i       (wb_hilo_o[31:0]),
      .hi_o       (hi_i),
      .lo_o       (lo_i)
  );

endmodule
