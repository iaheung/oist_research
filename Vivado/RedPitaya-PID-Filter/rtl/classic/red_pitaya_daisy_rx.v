/**
 * $Id: red_pitaya_daisy_rx.v 961 2014-01-21 11:40:39Z matej.oblak $
 *
 * @brief Red Pitaya daisy chain communication module. RX de-serializator.
 *
 * @Author Matej Oblak
 *
 * (c) Red Pitaya  http://www.redpitaya.com
 *
 * This part of code is written in Verilog hardware description language (HDL).
 * Please visit http://en.wikipedia.org/wiki/Verilog
 * for more details on the language used herein.
 */



/**
 * GENERAL DESCRIPTION:
 *
 * This module takes care of receiving serial data.
 *
 *
 *               /------\
 *   RX DAT ---> | SER  |
 *               |  ->  | -------> RX PARALLEL
 *   RX CLK ---> | PAR  |
 *               \------/
 *                  |
 *                  -------------< CFG
 *
 *
 * Received clock is used to sample input serial data and de-serialize them 
 * using ISERDESE2. Same clock is also divided to make slower clock used for 
 * parallel data.
 * 
 * Because unknown starting phase relation between serial and parallel clock 
 * there is need to allign input data. This is done with bitslip functionality
 * (for 4-bits). In our case parallel data width is 16-bits so we need to slip
 * also nibbles (par_cnt) to achive correct received data. To have this
 * functionality working correctly module needs known received value. For now
 * this value is 16'h00FF.
 *
 * When link is trained, software can disable trainig and regular data can be
 * received (until connection is broken). 
 *
 * Clock which is received is the same as transmitted (other board clock domain) !!!!
 * 
 */





module red_pitaya_daisy_rx
(
   // serial ports
   input                 ser_clk_i       ,  //!< RX high-speed clock
   input                 ser_dat_i       ,  //!< RX high-speed data

   // paralel ports
   input                 cfg_en_i        ,  //!< global module enable
   input                 cfg_train_i     ,  //!< enable training
   output                cfg_trained_o   ,  //!< module trained
   input                 sync_mode_i     ,
   input                 dly_clk_i       ,  //!< IDELAY clock

   output                par_clk_o       ,  //!< parallel clock
   output reg            par_rstn_o      ,  //!< parallel reset - active low
   output                par_dv_o        ,  //!< parallel data enable
   output     [ 16-1: 0] par_dat_o          //!< parallel data
);





//---------------------------------------------------------------------------------
//
//  De-serialize - clock

wire           ser_clk     ;
wire           par_clk     ;
reg  [16-1: 0] par_rstn_r  ;
reg            par_rstn    ;


`ifdef SER_DLY
wire           ser_clk_dly ;
wire           dly_rdy     ;

// IDELAYCTRL is needed for calibration
//(* IODELAY_GROUP = "daisy_rx_clk_group" *)
IDELAYCTRL
delayctrl (
 .RDY    (  dly_rdy    ),
 .REFCLK (  dly_clk_i  ),
 .RST    ( !cfg_en_i   )
);

 // delay the input clock
//(* IODELAY_GROUP = "daisy_rx_clk_group" *)
IDELAYE2
# (
 .CINVCTRL_SEL           ( "FALSE"    ),  // TRUE, FALSE
 .DELAY_SRC              ( "IDATAIN"  ),  // IDATAIN, DATAIN
 .HIGH_PERFORMANCE_MODE  ( "TRUE"     ),  // TRUE, FALSE
 .IDELAY_TYPE            ( "FIXED"    ),  // FIXED, VARIABLE, or VAR_LOADABLE
 .IDELAY_VALUE           (  15         ),  // 0 to 31
 .REFCLK_FREQUENCY       (  200.0     ),
 .PIPE_SEL               ( "FALSE"    ),
 .SIGNAL_PATTERN         ( "CLOCK"    )   // CLOCK, DATA
)
idelaye2_clk
(
 .DATAOUT                (  ser_clk_dly  ),  // Delayed clock
 .DATAIN                 (  1'b0         ),  // Data from FPGA logic
 .C                      (  1'b0         ),
 .CE                     (  1'b0         ),
 .INC                    (  1'b0         ),
 .IDATAIN                (  ser_clk_i    ),
 .LD                     ( !cfg_en_i     ),
 .LDPIPEEN               (  1'b0         ),
 .REGRST                 (  1'b0         ),
 .CNTVALUEIN             (  5'b00000     ),
 .CNTVALUEOUT            (),
 .CINVCTRL               (  1'b0         )
);
`else
wire           ser_clk_dly = ser_clk_i;
wire           dly_rdy     = 1'b1;
`endif

// High Speed BUFIO clock buffer
BUFIO i_BUFIO_clk
(
  .O (  ser_clk      ),
  .I (  ser_clk_dly  )
);

BUFR #(.SIM_DEVICE("7SERIES"), .BUFR_DIVIDE("2")) i_BUFR_clk
(
  .O   (  par_clk      ),
  .CE  (  1'b1         ),
  .CLR (  1'b0         ),
  .I   (  ser_clk_dly  )
);

// Reset on receive clock domain
always @(posedge par_clk or negedge cfg_en_i) begin
   if (cfg_en_i == 1'b0) begin
      par_rstn_r <= 16'h0 ;
      par_rstn   <=  1'b0 ;
   end
   else begin
      par_rstn_r <= {par_rstn_r[16-2:0], dly_rdy} ;
      par_rstn   <=  par_rstn_r[16-1];
   end
end




//---------------------------------------------------------------------------------
//
//  De-serialize - data

reg  [ 4-1: 0] bitslip_r    ;
reg            bitslip_l    ;
reg            bitslip      ;
reg  [ 5-1: 0] bitslip_cnt  ;
reg  [ 3-1: 0] nibslip_cnt  ;
wire [ 8-1: 0] rxp_dat      ;
reg  [ 4-1: 0] rxp_dat_1r   ;
reg  [ 4-1: 0] rxp_dat_2r   ;
reg  [ 4-1: 0] rxp_dat_3r   ;
reg            par_dv       ;
reg  [16-1: 0] par_dat      ;
reg  [16-1: 0] par_dat_r    ;
reg            par_ok       ;
reg  [ 2-1: 0] par_cnt      ;
reg            par_val      ;
reg  [ 2-1: 0] par_train_r  ;
reg            par_train    ;

ISERDESE2
#(
  .DATA_RATE         ( "DDR"          ),
  .DATA_WIDTH        (  4             ),
  .INTERFACE_TYPE    ( "NETWORKING"   ), 
  .DYN_CLKDIV_INV_EN ( "FALSE"        ),
  .DYN_CLK_INV_EN    ( "FALSE"        ),
  .NUM_CE            (  2             ),
  .OFB_USED          ( "FALSE"        ),
  .IOBDELAY          ( "NONE"         ), // Use input at D to output the data on Q
  .SERDES_MODE       ( "MASTER"       )
)
i_iserdese 
(
  .Q1                (  rxp_dat[7]    ),
  .Q2                (  rxp_dat[6]    ),
  .Q3                (  rxp_dat[5]    ),
  .Q4                (  rxp_dat[4]    ),
  .Q5                (  rxp_dat[3]    ),
  .Q6                (  rxp_dat[2]    ),
  .Q7                (  rxp_dat[1]    ),
  .Q8                (  rxp_dat[0]    ),
  .SHIFTOUT1         (),
  .SHIFTOUT2         (),
  .BITSLIP           (  bitslip       ),  // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                          // The amount of bitslip is fixed by the DATA_WIDTH selection.
  .CE1               (  1'b1          ),  // 1-bit Clock enable input
  .CE2               (  1'b1          ),  // 1-bit Clock enable input
  .CLK               (  ser_clk       ),  // Fast source synchronous clock driven by BUFIO
  .CLKB              ( !ser_clk       ),  // Locally inverted fast 
  .CLKDIV            (  par_clk       ),  // Slow clock from BUFR.
  .CLKDIVP           (  1'b0          ),
  .D                 (  ser_dat_i     ),  // 1-bit Input signal from IOB 
  .DDLY              (  1'b0          ),  // 1-bit Input from Input Delay component 
  .RST               ( !cfg_en_i      ),  // 1-bit Asynchronous reset only.
  .SHIFTIN1          (  1'b0          ),
  .SHIFTIN2          (  1'b0          ),

  .DYNCLKDIVSEL      (  1'b0          ),
  .DYNCLKSEL         (  1'b0          ),
  .OFB               (  1'b0          ),
  .OCLK              (  1'b0          ),
  .OCLKB             (  1'b0          ),
  .O                 ()
);






//---------------------------------------------------------------------------------
//
//  Data control

// combining data - concentrate 4 nibbles
always @(posedge par_clk) begin
   rxp_dat_1r <= rxp_dat[3:0];
   rxp_dat_2r <= rxp_dat_1r  ;
   rxp_dat_3r <= rxp_dat_2r  ;

   par_dat <= {rxp_dat, rxp_dat_1r, rxp_dat_2r, rxp_dat_3r};
end


// synchronize bitslip control
always @(posedge par_clk) begin
   bitslip_r <= {bitslip_r[4-2:0], bitslip_l} ;

   bitslip <= (bitslip_r[4-2] ^ bitslip_r[4-1]) ; 
end



//---------------------------------------------------------------------------------
//
//  Data train

// connection training - bitslip and nibble "shift"
always @(posedge par_clk_o) begin
   if (par_rstn_o == 1'b0) begin
      bitslip_l   <=  1'b0 ;
      bitslip_cnt <=  5'b0 ;
      nibslip_cnt <=  3'h0 ;
      par_ok      <=  1'b0 ;
      par_cnt     <=  2'h0 ;
      par_val     <=  1'b0 ;
      par_dv      <=  1'b0 ;
      par_train_r <=  2'h0 ;
      par_train   <=  1'b0 ;
      par_dat_r   <= 16'h0 ;
   end
   else begin
      par_train_r <= {par_train_r[0], cfg_train_i} ;
      par_train   <=  par_train_r[1];

      if (par_val)
         par_dat_r <= par_dat ;

      // shifting input data by 1 bit
      if (par_train)
         bitslip_cnt <= bitslip_cnt + 5'h1 ;
      else
         bitslip_cnt <= 5'h0 ; 

      if ((bitslip_cnt[3:2] == 3'b10) && (par_dat_r != 16'h00FF) && par_dv && !par_ok)
         bitslip_l <= !bitslip_l ;


      // shifting input data by 4bits every 8 bitslips
      if (par_train && bitslip && !par_ok)
         nibslip_cnt <= nibslip_cnt + 3'h1 ;
      else if (!par_train || par_ok)
         nibslip_cnt <= 3'h0 ; 

      if ((nibslip_cnt == 3'h7) && bitslip)
         par_cnt <= par_cnt ; // "shift" input data by 4
      else
         par_cnt <= par_cnt + 2'h1 ;

      par_val <= (par_cnt==2'b01) ;
      par_dv  <=  par_val ;


      // testing if connection is trained
      if (par_train && (par_dat_r == 16'h00FF) && par_dv)
         par_ok <= 1'b1 ;
      else if ((bitslip_cnt[3:2] == 3'b10) && (par_dat_r != 16'h00FF) && par_dv)
         par_ok <= 1'b0 ;

   end
end







reg          par_dv_or;
reg [16-1:0] par_dat_or;

always @(posedge par_clk_o) begin
   par_dv_or   <= par_dv && par_ok && !par_train ;
   par_dat_or  <= par_dat_r;

   par_rstn_o  <= par_rstn ;
end

assign par_dat_o = sync_mode_i ? {8'h0,rxp_dat} : par_dat_or;
assign par_dv_o  = sync_mode_i ? 1'b1 : par_dv_or;

BUFG i_parclk_buf   (.O(par_clk_o), .I(par_clk));

assign cfg_trained_o = par_ok   ;












endmodule

