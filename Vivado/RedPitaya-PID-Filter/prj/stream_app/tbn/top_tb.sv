////////////////////////////////////////////////////////////////////////////////
// Module: Red Pitaya top FPGA module
// Author: Iztok Jeras
// (c) Red Pitaya  (redpitaya.com)
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module top_tb #(
  // time period
  realtime  TP = 8.0ns,  // 250MHz
  realtime  AXIP = 5.0ns,  // 200MHz
  realtime  RP = 100.1ns,  // ~10MHz
  // DUT configuration
  int unsigned DAC_DW = 14, // ADC data width
  int unsigned RSZ = 14  // RAM size is 2**RSZ
);

////////////////////////////////////////////////////////////////////////////////
// IO port signals
////////////////////////////////////////////////////////////////////////////////

// PS connections
wire  [54-1:0] FIXED_IO_mio     ;
wire           FIXED_IO_ps_clk  ;
wire           FIXED_IO_ps_porb ;
wire           FIXED_IO_ps_srstb;
wire           FIXED_IO_ddr_vrn ;
wire           FIXED_IO_ddr_vrp ;
// DDR
wire  [15-1:0] DDR_addr   ;
wire  [ 3-1:0] DDR_ba     ;
wire           DDR_cas_n  ;
wire           DDR_ck_n   ;
wire           DDR_ck_p   ;
wire           DDR_cke    ;
wire           DDR_cs_n   ;
wire  [ 4-1:0] DDR_dm     ;
wire  [32-1:0] DDR_dq     ;
wire  [ 4-1:0] DDR_dqs_n  ;
wire  [ 4-1:0] DDR_dqs_p  ;
wire           DDR_odt    ;
wire           DDR_ras_n  ;
wire           DDR_reset_n;
wire           DDR_we_n   ;

// ADC
logic [2-1:0] [ 7-1:0] adc_dat;
logic         [ 2-1:0] adc_dco;
// DAC
logic [2-1:0] [14-1:0] dac_dat;     // DAC combined data
logic                  dac_clk;     // DAC clock
logic                  dac_rst;     // DAC reset
// PDM DAC
logic         [ 4-1:0] dac_pwm;     // 1-bit PDM DAC
// XADC
logic         [ 5-1:0] vinp;        // voltages p
logic         [ 5-1:0] vinn;        // voltages n
// Expansion connector
wire          [ 9-1:0] exp_p_io;
wire          [ 9-1:0] exp_n_io;
wire                   exp_9_io;
// Expansion output data/enable
logic         [ 9-1:0] exp_p_od, exp_p_oe;
logic         [ 9-1:0] exp_n_od, exp_n_oe;
logic                  exp_9_od, exp_9_oe;
// SATA
logic         [ 4-1:0] daisy_p;
logic         [ 4-1:0] daisy_n;

// LED
wire          [ 8-1:0] led;

logic         [ 2-1:0] temp_prot;
logic                  pll_lo;
logic                  pll_hi;
logic                  pll_ref;
logic                  trig;

logic                  intr;

logic               clk ;
logic               axi_clk ;

logic               clkn;
wire               rstn_out;
logic               rstn;

wire clkout_200;
wire rstn_200;
//glbl glbl();

localparam OSC_DW = 64;
localparam REG_DW = 32;
localparam OSC_AW = 32;
localparam REG_AW = 32;
localparam IW = 4;
localparam LW = 8;

localparam GEN1_EVENT = 0;
localparam GEN2_EVENT = 1;
localparam OSC1_EVENT = 2;
localparam OSC2_EVENT = 3;
localparam LA_EVENT = 4;

localparam GPIO_IN_CTRL_ADDR  = 'h8C;
localparam GPIO_OUT_CTRL_ADDR = 'h90;


wire interf_clk, interf_rst;
wire clkout_125, clkout_625;

//--------------------------------------------------------------------------------------------
localparam MASTER = 0;
localparam SLAVE  = 1;
wire mode = SLAVE;

assign interf_clk=clkout_125;
assign interf_rst=rstn_out;

//--------------------------------------------------------------------------------------------

wire [4-1:0] fclk, frstn;

wire          [ 8-1:0] gpio_p_i;
wire          [ 8-1:0] gpio_n_i;

wire          [ 8-1:0] dirp;
wire          [ 8-1:0] dirn;

reg          [ 8-1:0] gpio_p_o;
reg          [ 8-1:0] gpio_n_o;

reg          [10-1:0] gpio_cnt;

logic [14-1:0] dac_dat_o;
logic          dac_wrt_o;
logic          dac_sel_o;
logic          dac_clk_o;
logic          dac_rst_o;

//assign gpio_p_o = 8'h01;
//assign gpio_n_o = 8'hFE;

always @(posedge clk) begin
  if (~rstn) begin
    gpio_cnt <= 'h0;
    gpio_p_o <= 'h0;
    gpio_n_o <= 'h0;
  end else begin
    if (gpio_cnt >= 10'd100) begin
      gpio_cnt <= 'h0;
      gpio_p_o <= gpio_p_o + 1;
      gpio_n_o <= gpio_n_o - 1;      
    end else
      gpio_cnt <= gpio_cnt + 1;
  end
end
wire [31:0] read_dat1={8'd100, gpio_p_o,   8'd100, gpio_n_o  };
wire [31:0] read_dat2={8'd100, gpio_p_o+1, 8'd100, gpio_n_o-1};
wire [63:0] read_dat ={read_dat1, read_dat2};


axi4_if #(.DW (REG_DW), .AW (REG_AW), .IW (IW), .LW (LW)) axi_reg (
  .ACLK    (fclk[2]   ),  .ARESETn (rstn_axi)
);


axi4_if #(.DW (REG_DW), .AW (REG_AW), .IW (IW), .LW (LW)) axi_syncd (
  .ACLK    (fclk[2]   ),  .ARESETn (rstn_axi)
);

axi4_if #(.DW (OSC_DW), .AW (OSC_AW), .IW (IW), .LW (LW)) axi_osc1 (
  .ACLK    (interf_clk   ),  .ARESETn (interf_rst)
);

/*axi4_if #(.DW (OSC_DW), .AW (OSC_AW), .IW (IW), .LW (LW)) axi_osc2 (
  .ACLK    (clk   ),  .ARESETn (rstn)
);*/



axi_bus_model #(.AW (REG_AW), .DW (REG_DW), .IW (IW), .LW (LW)) axi_bm_reg  (axi_reg );
axi_slave_model #(.AXI_AW (OSC_AW), .AXI_DW (OSC_DW), .AXI_IW (IW), .AXI_ID(0)) 
axi_bm_osc1 (
   // global signals
  .axi_clk_i      (interf_clk), // global clock
  .axi_rstn_i     (interf_rst), // global reset
   // axi write address channel
  .axi_awid_i     (axi_osc1.AWID), // write address ID
  .axi_awaddr_i   (axi_osc1.AWADDR), // write address
  .axi_awlen_i    (axi_osc1.AWLEN), // write burst length
  .axi_awsize_i   (axi_osc1.AWSIZE), // write burst size
  .axi_awburst_i  (axi_osc1.AWBURST), // write burst type
  .axi_awlock_i   (axi_osc1.AWLOCK), // write lock type
  .axi_awcache_i  (axi_osc1.AWCACHE), // write cache type
  .axi_awprot_i   (axi_osc1.AWPROT), // write protection type
  .axi_awvalid_i  (axi_osc1.AWVALID), // write address valid
  .axi_awready_o  (axi_osc1.AWREADY), // write ready
   // axi write data channel
  .axi_wid_i      (axi_osc1.WID), // write data ID
  .axi_wdata_i    (axi_osc1.WDATA), // write data
  .axi_wstrb_i    (axi_osc1.WSTRB), // write strobes
  .axi_wlast_i    (axi_osc1.WLAST), // write last
  .axi_wvalid_i   (axi_osc1.WVALID), // write valid
  .axi_wready_o   (axi_osc1.WREADY), // write ready
   // axi write response channel
  .axi_bid_o      (axi_osc1.BID), // write response ID
  .axi_bresp_o    (axi_osc1.BRESP), // write response
  .axi_bvalid_o   (axi_osc1.BVALID), // write response valid
  .axi_bready_i   (axi_osc1.BREADY), // write response ready
   // axi read address channel
  .axi_arid_i     (axi_osc1.ARID), // read address ID
  .axi_araddr_i   (axi_osc1.ARADDR), // read address
  .axi_arlen_i    (axi_osc1.ARLEN), // read burst length
  .axi_arsize_i   (axi_osc1.ARSIZE), // read burst size
  .axi_arburst_i  (axi_osc1.ARBURST), // read burst type
  .axi_arlock_i   (axi_osc1.ARLOCK), // read lock type
  .axi_arcache_i  (axi_osc1.ARCACHE), // read cache type
  .axi_arprot_i   (axi_osc1.ARPROT), // read protection type
  .axi_arvalid_i  (axi_osc1.ARVALID), // read address valid
  .axi_arready_o  (axi_osc1.ARREADY), // read address ready
   // axi read data channel
  .axi_rid_o      (axi_osc1.RID), // read response ID
  .axi_rdata_o    (axi_osc1.RDATA), // read data
  .axi_rresp_o    (axi_osc1.RRESP), // read response
  .axi_rlast_o    (axi_osc1.RLAST), // read last
  .axi_rvalid_o   (axi_osc1.RVALID), // read response valid
  .axi_rready_i   (axi_osc1.RREADY) // read response ready
);

////////////////////////////////////////////////////////////////////////////////
// Clock and reset generation
////////////////////////////////////////////////////////////////////////////////


assign clkn = ~clk;
// clock
initial        clk = 1'b0;
always #(TP/2) clk = ~clk;

initial        pll_ref = 1'b0;
always #(RP/2) pll_ref = ~pll_ref;

initial          axi_clk = 1'b0;
always #(AXIP/2) axi_clk = ~axi_clk;

// default clocking 
default clocking cb @ (posedge clk);
  input  rstn;
  input  exp_p_od, exp_p_oe;
  input  exp_n_od, exp_n_oe;
endclocking: cb

// reset
initial begin
        rstn = 1'b0;
  ##4;  rstn = 1'b1;
end

// clock cycle counter
int unsigned cyc=0;
always_ff @ (posedge clk)
cyc <= cyc+1;






////////////////////////////////////////////////////////////////////////////////
// initializtion
////////////////////////////////////////////////////////////////////////////////

initial begin
  exp_p_od = '0;
  exp_n_od = '0;
  exp_p_oe = '0;
  exp_n_oe = '0;
end

////////////////////////////////////////////////////////////////////////////////
// test sequence
////////////////////////////////////////////////////////////////////////////////

//initial begin
//  ##6000;
//  $display("ERROR: timeout!");
//  $finish();
//end

initial begin
  ##500;

   //top_tc.test_hk                 (0<<20, 32'h55);
   //top_tc.test_sata               (5<<20, 32'h55);
   top_tc.test_osc                (32'h40000000, OSC1_EVENT);

  //top_tc_gpio.test_gpio (32'h40100000, GPIO_OUT_CTRL_ADDR, LA_EVENT);
   //top_tc_dac.test_dac2            (32'h40100000, GEN1_EVENT);

//   top_tc.test_asg                (2<<20, 32'h40090000, 2);


  ##1600000000;
  $finish();
end

reg  [16-1:0] out_dat, out_dat2, out_dat3;
reg  [8-1:0] out_l, out_l2, out_r;

reg seldat;
integer fd;

/*initial begin
   fd = $fopen("RPstreamtest2.bin", "r");
  seldat   = 'h0;

end

always @ (clk) begin
  out_l <= out_l2;
  out_r <= out_l;
  seldat <= ~seldat;

  if (seldat)
    //out_dat <= {out_r[15:8], out_l[15:8]};
    out_dat <= {out_l, out_r};

  if (rstn_out) begin
    if (!$feof(fd)) begin
      $fgets(out_l2 , fd);
    end else
      $fclose(fd);
  end
end
*/
////////////////////////////////////////////////////////////////////////////////
// signal generation
////////////////////////////////////////////////////////////////////////////////

localparam int unsigned DWM = 14;
localparam int unsigned CWM = 14;
localparam int unsigned CWF = 16;

//int buf_len = 2**CWM;
int buf_len = 'hff+1;
real freq  = 10_000; // 10kHz
real phase = 0; // DEG

always begin
  trig <= 1'b0;
  ##100000;
  trig <= 1'b1;
  ##1200;
  trig <= 1'b0;
end


always begin
  temp_prot <= 2'b00;
  ##50000;
  temp_prot <= 2'b10;
  ##1000;
  temp_prot <= 2'b00;
end


//localparam int unsigned SIZ_REF = 64;
//
//bit [16-1:0] dat_ref [SIZ_REF];
//
//initial begin
//  logic signed [16-1:0] dat;
//  for (int unsigned i=0; i<SIZ_REF; i++) begin
//      dat = -SIZ_REF/2+i;
//      dat_ref[i] = {dat[16-1], ~dat[16-2:0]};
//  end
//end

bit [14-1:0] dat_ref [2*15];

initial begin
  for (int unsigned i=0; i<31; i++) begin
    dat_ref [i] = {i, 2'b0};
    dat_ref [16-1-i] = {1'b1, 15'(1<<i)};
    dat_ref [16  +i] = {1'b0, 15'(1<<i)};
  end
end

// ADC
logic [2-1:0] [14-1:0] adc_dr ;
assign adc_dr[0] =  dat_ref[cyc % $size(dat_ref)];
assign adc_dr[1] = ~dat_ref[cyc % $size(dat_ref)];

always @(clk) begin
  if (clk==1) begin
    #(0.1);
    adc_dat[0] <= {adc_dr[0][12], adc_dr[0][10], adc_dr[0][8], adc_dr[0][6], adc_dr[0][4], adc_dr[0][2]};
    adc_dat[1] <= {adc_dr[1][12], adc_dr[1][10], adc_dr[1][8], adc_dr[1][6], adc_dr[1][4], adc_dr[1][2]};
  end else begin
    #(0.1);
    adc_dat[0] <= {adc_dr[0][13], adc_dr[0][11], adc_dr[0][9], adc_dr[0][7], adc_dr[0][5], adc_dr[0][3]};
    adc_dat[1] <= {adc_dr[1][13], adc_dr[1][11], adc_dr[1][9], adc_dr[1][7], adc_dr[1][5], adc_dr[1][3]};
  end
end

always @(clk) begin
  if (clk==1) begin
    #(0.7);
    adc_dco[1] <= 1;
    adc_dco[0] <= 0;
  end else begin
    #(0.7);
    adc_dco[1] <= 0;
    adc_dco[0] <= 1;
  end
end

// XADC
assign vinp = '0;
assign vinn = '0;

// Expansion connector
//assign exp_p_io = 8'h0;
//assign exp_n_io = 8'h0;

// LED


assign #0.2 daisy_p[3] = daisy_p[1] ;
assign #0.2 daisy_n[3] = daisy_n[1] ;
assign #0.2 daisy_p[2] = daisy_p[0] ;
assign #0.2 daisy_n[2] = daisy_n[0] ;



wire [ 1:0] clko;
wire [13:0] dac_dat_o;
wire [15:0] wdat1; 
wire [15:0] wdat2;
wire [15:0] wdat3;
wire [15:0] wdat4;

wire [15:0] wdat5; 
wire [15:0] wdat6;
wire [15:0] wdat7;
wire [15:0] wdat8;
assign wdat1 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc1_wdata[15: 0];
assign wdat2 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc1_wdata[31:16];
assign wdat3 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc1_wdata[47:32];
assign wdat4 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc1_wdata[63:48];

assign wdat5 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc2_wdata[15: 0];
assign wdat6 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc2_wdata[31:16];
assign wdat7 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc2_wdata[47:32];
assign wdat8 = red_pitaya_top_sim.system_wrapper_i.system_i.rp_oscilloscope.m_axi_osc2_wdata[63:48];

reg [15:0] wdat1_r; 
reg [15:0] wdat2_r;
reg [15:0] wdat3_r;
reg [15:0] wdat4_r;

reg [15:0] wdat5_r; 
reg [15:0] wdat6_r;
reg [15:0] wdat7_r;
reg [15:0] wdat8_r;

always @(posedge interf_clk) begin
  if (interf_rst==0) begin
    wdat1_r <= 'h0;
    wdat2_r <= 'h0;
    wdat3_r <= 'h0;
    wdat4_r <= 'h0;
    wdat5_r <= 'h0;
    wdat6_r <= 'h0;
    wdat7_r <= 'h0;
    wdat8_r <= 'h0;
  end else begin
    if (axi_osc1.WVALID & axi_osc1.WREADY) begin
      wdat1_r <= wdat1;
      wdat2_r <= wdat2;
      wdat3_r <= wdat3;
      wdat4_r <= wdat4;
      wdat5_r <= wdat5;
      wdat6_r <= wdat6;
      wdat7_r <= wdat7;
      wdat8_r <= wdat8;
    end
  end
end

reg [15:0] cnter;
always @(adc_clk) begin

    if (rstn==0)
        cnter <= 16'b0;
    //else if (cnter==13'hFFF && clk==1)
    //    cnter <= 13'b0;
    else if (clk == 1)
        cnter <= cnter + 16'd1; 

end

reg [32-1:0] trig_cnt;
reg          daisy_trig;
always @(posedge clk) begin
  if (rstn==0)
    trig_cnt <= 'h0;
  else
    trig_cnt <= trig_cnt + 'h1; 

  daisy_trig <= &trig_cnt[12-1:0];
end

wire adc_clk;
wire pll_in_clk = mode == MASTER ? clk  : clko[0] & ~clko[1];
wire daisy_clk  = mode == MASTER ? 1'b0 : clk;

clk_gen #(
  .CLKA_PERIOD  (  8000   ),
  .CLKA_JIT     (  0      ),
  .DEL          (  70     ) // in percent
)
i_clgen_model
(
  .clk_i  ( pll_in_clk ) ,
  .clk_o  ( adc_clk    )
);
////////////////////////////////////////////////////////////////////////////////
// module instances
////////////////////////////////////////////////////////////////////////////////

// module under test

 red_pitaya_top_sim red_pitaya_top_sim
       (.DDR_addr(),
        .DDR_ba(),
        .DDR_cas_n(),
        .DDR_ck_n(),
        .DDR_ck_p(),
        .DDR_cke(),
        .DDR_cs_n(),
        .DDR_dm(),
        .DDR_dq(),
        .DDR_dqs_n(),
        .DDR_dqs_p(),
        .DDR_odt(),
        .DDR_ras_n(),
        .DDR_reset_n(),
        .DDR_we_n(),
        .FIXED_IO_ddr_vrn(),
        .FIXED_IO_ddr_vrp(),
        .FIXED_IO_mio(),
        .FIXED_IO_ps_clk(),
        .FIXED_IO_ps_porb(),
        .FIXED_IO_ps_srstb(),
/*
        .M_AXI_OSC_araddr(axi_osc1.ARADDR),
        .M_AXI_OSC_arburst(axi_osc1.ARBURST),
        .M_AXI_OSC_arcache(axi_osc1.ARCACHE),
        .M_AXI_OSC_arid(axi_osc1.ARID),
        .M_AXI_OSC_arlen(axi_osc1.ARLEN),
        .M_AXI_OSC_arlock(axi_osc1.ARLOCK),
        .M_AXI_OSC_arprot(axi_osc1.ARPROT),
        .M_AXI_OSC_arqos(axi_osc1.ARQOS),
        .M_AXI_OSC_arready(axi_osc1.ARREADY),
        .M_AXI_OSC_arsize(axi_osc1.ARSIZE),
        .M_AXI_OSC_arvalid(axi_osc1.ARVALID),
        */
        .M_AXI_OSC_awaddr(axi_osc1.AWADDR),
        .M_AXI_OSC_awburst(axi_osc1.AWBURST),
        .M_AXI_OSC_awcache(axi_osc1.AWCACHE),
        .M_AXI_OSC_awid(axi_osc1.AWID),
        .M_AXI_OSC_awlen(axi_osc1.AWLEN),
        .M_AXI_OSC_awlock(axi_osc1.AWLOCK),
        .M_AXI_OSC_awprot(axi_osc1.AWPROT),
        .M_AXI_OSC_awqos(axi_osc1.AWQOS),
        .M_AXI_OSC_awready(axi_osc1.AWREADY),
        .M_AXI_OSC_awsize(axi_osc1.AWSIZE),
        .M_AXI_OSC_awvalid(axi_osc1.AWVALID),
        .M_AXI_OSC_bid(axi_osc1.BID),
        .M_AXI_OSC_bready(axi_osc1.BREADY),
        .M_AXI_OSC_bresp(axi_osc1.BRESP),
        .M_AXI_OSC_bvalid(axi_osc1.BVALID),
        /*
        .M_AXI_OSC_rdata(axi_osc1.RDATA),
        .M_AXI_OSC_rid(axi_osc1.RID),
        .M_AXI_OSC_rlast(axi_osc1.RLAST),
        .M_AXI_OSC_rready(axi_osc1.RREADY),
        .M_AXI_OSC_rresp(axi_osc1.RRESP),
        .M_AXI_OSC_rvalid(axi_osc1.RVALID),
        
        */
        .M_AXI_OSC_wdata(axi_osc1.WDATA),
        .M_AXI_OSC_wid(axi_osc1.WID),
        .M_AXI_OSC_wlast(axi_osc1.WLAST),
        .M_AXI_OSC_wready(axi_osc1.WREADY),
        .M_AXI_OSC_wstrb(axi_osc1.WSTRB),
        .M_AXI_OSC_wvalid(axi_osc1.WVALID),

        .S_AXI_REG_araddr(axi_reg.ARADDR),
        .S_AXI_REG_arburst(axi_reg.ARBURST),
        .S_AXI_REG_arcache(axi_reg.ARCACHE),
        .S_AXI_REG_arid(axi_reg.ARID),
        .S_AXI_REG_arlen(axi_reg.ARLEN),
        .S_AXI_REG_arlock(axi_reg.ARLOCK),
        .S_AXI_REG_arprot(axi_reg.ARPROT),
        .S_AXI_REG_arqos(axi_reg.ARQOS),
        .S_AXI_REG_arready(axi_reg.ARREADY),
        .S_AXI_REG_arsize(axi_reg.ARSIZE),
        .S_AXI_REG_arvalid(axi_reg.ARVALID),
        .S_AXI_REG_awaddr(axi_reg.AWADDR),
        .S_AXI_REG_awburst(axi_reg.AWBURST),
        .S_AXI_REG_awcache(axi_reg.AWCACHE),
        .S_AXI_REG_awid(axi_reg.AWID),
        .S_AXI_REG_awlen(axi_reg.AWLEN),
        .S_AXI_REG_awlock(axi_reg.AWLOCK),
        .S_AXI_REG_awprot(axi_reg.AWPROT),
        .S_AXI_REG_awqos(axi_reg.AWQOS),
        .S_AXI_REG_awready(axi_reg.AWREADY),
        .S_AXI_REG_awsize(axi_reg.AWSIZE),
        .S_AXI_REG_awvalid(axi_reg.AWVALID),
        .S_AXI_REG_bid(axi_reg.BID),
        .S_AXI_REG_bready(axi_reg.BREADY),
        .S_AXI_REG_bresp(axi_reg.BRESP),
        .S_AXI_REG_bvalid(axi_reg.BVALID),
        .S_AXI_REG_rdata(axi_reg.RDATA),
        .S_AXI_REG_rid(axi_reg.RID),
        .S_AXI_REG_rlast(axi_reg.RLAST),
        .S_AXI_REG_rready(axi_reg.RREADY),
        .S_AXI_REG_rresp(axi_reg.RRESP),
        .S_AXI_REG_rvalid(axi_reg.RVALID),
        .S_AXI_REG_wdata(axi_reg.WDATA),
        .S_AXI_REG_wid(axi_reg.WID),
        .S_AXI_REG_wlast(axi_reg.WLAST),
        .S_AXI_REG_wready(axi_reg.WREADY),
        .S_AXI_REG_wstrb(axi_reg.WSTRB),
        .S_AXI_REG_wvalid(axi_reg.WVALID),
        .fclk         (fclk      ),
        .frstn        (frstn     ),
        .clkout_625(clkout_625),
        .clkout_125(clkout_125),
        .clkout_200(clkout_200),

        .daisy_p_o(),
        .daisy_n_o(),
        .daisy_p_i({ daisy_clk, daisy_trig}),
        .daisy_n_i({~daisy_clk,~daisy_trig}),

        .rstn_out(rstn_out),
        .rstn_axi(rstn_axi),
        .rstn_200(rstn_200),

        .rst_in(~rstn),
        .dac_dat_o(dac_dat_o),
        .dac_wrt_o(dac_wrt_o),
        .dac_sel_o(dac_sel_o),
        .dac_clk_o(dac_clk_o),
        .dac_rst_o(dac_rst_o),
/*
        .gpio_p_o(gpio_p_i),
        .gpio_n_o(gpio_n_i),
        .gpio_p_i(gpio_p_o),
        .gpio_n_i(gpio_n_o),
        .dirp(dirp),
        .dirn(dirn),
*/
        .adc_clk_i({~adc_clk,adc_clk}),
        .adc_clk_o(clko),
        //.adc_clk_p(clk),
        //.adc_data_ch1({1'b0,cnter,2'b0}),
        .adc_data_ch1({cnter[15],~cnter[14:0]/*,1'b0*/}),
        //.adc_data_ch1({out_dat[15],~out_dat[14:0]}),
        .adc_data_ch2({cnter[15:1],1'b0}));


reg [14-1:0] dac_cha, dac_cha_prev;
reg [14-1:0] dac_chb, dac_chb_prev;

always @(posedge dac_clk_o) begin
    if (~dac_wrt_o) begin
        if (~dac_sel_o)
            dac_cha <= dac_dat_o;
        else 
            dac_chb <= dac_dat_o;  
    end
    dac_cha_prev <= dac_cha;
    dac_chb_prev <= dac_chb;

end

wire port1_en  = dac_wrt_o &  dac_sel_o;
wire port2_en  = dac_wrt_o & ~dac_sel_o;
wire port_sync = dac_clk_o & ~dac_rst_o;
reg [14-1:0] port1, port2;
reg [14-1:0] port1_o, port2_o;

always @(posedge port1_en)
  port1 <= dac_dat_o;

always @(posedge port2_en)
  port2 <= dac_dat_o;

always @(posedge dac_clk_o) begin
  port1_o <= ~port1;
  port2_o <= ~port2;
end

wire cha_test = (dac_cha_prev - dac_cha) > 1 ? 1'b0 : 1'b1;
wire chb_test = (dac_chb_prev - dac_chb) > 1 ? 1'b0 : 1'b1;


bufif1 bufif_exp_p_io [9-1:0] (exp_p_io, exp_p_od, exp_p_oe);
bufif1 bufif_exp_n_io [9-1:0] (exp_n_io, exp_n_od, exp_n_oe);
bufif1 bufif_exp_9_io         (exp_9_io, exp_9_od, exp_9_oe);
// testcases
top_tc top_tc();
top_tc_dac top_tc_dac();


////////////////////////////////////////////////////////////////////////////////
// waveforms
////////////////////////////////////////////////////////////////////////////////

initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars(0, top_tb);
end



endmodule: top_tb
