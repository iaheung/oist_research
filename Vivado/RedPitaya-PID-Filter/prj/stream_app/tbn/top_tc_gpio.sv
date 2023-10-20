

`timescale 1ns / 1ps

module top_tc_gpio ();


default clocking cb @ (posedge gpio_sim.clk);
endclocking: cb
// DMA status reg
localparam READ_STATE_BUF1      = 0;
localparam END_STATE_BUF1       = 1;
localparam READ_STATE_BUF2      = 2;
localparam END_STATE_BUF2       = 3;
localparam RESET_STATE          = 4;

// DMA control reg
localparam CTRL_STRT            = 0;
localparam CTRL_RESET           = 1;
localparam CTRL_MODE_NORM       = 4;
localparam CTRL_MODE_STREAM     = 5;
localparam CTRL_BUF1_RDY        = 6;
localparam CTRL_BUF2_RDY        = 7;

logic [12-1:0] id_test;

task test_hk (
  int unsigned offset,
  int unsigned led=0 
);
  int unsigned dat;
  // test registers
  axi_read(offset+'h0, dat); //ID
  axi_read(offset+'h4, dat); //DNA
  axi_read(offset+'h8, dat); //DNA
  axi_write(offset+'h30, led); // LED
  axi_read(offset+'h30, dat); // LED

  ##1000;
  axi_write(offset+'h40, 1); // enable PLL
  ##1000;
  axi_read(offset+'h40, dat); // PLL status


  axi_write(offset+'h44, 32'hFFFF); // reset IDELAY

  //ADC SPI
  axi_write(offset+'h50, 32'h8016); // SPI offset
  axi_write(offset+'h54, 32'h20); // SPI offset
  ##1000;
  axi_read(offset+'h58, dat); // SPI offset

  //DAC SPI
  axi_write(offset+'h60, 32'h83); // SPI offset
  axi_write(offset+'h64, 32'h54); // SPI offset
  ##1000;
  axi_read(offset+'h68, dat); // SPI offset


  for (int k=0; k<4; k++) begin
  ##100;
   $display("%m - Increment IDELAY @%0t.", $time) ;
   axi_write(offset+'h48, 32'hFFFF); // increment IDELAY A
   //axi_write(offset+'h4C, 32'hFFFF); // increment IDELAY B
  end
  axi_write(offset+'h44, 32'hFFFF); // reset IDELAY

endtask: test_hk



////////////////////////////////////////////////////////////////////////////////
// Testing osciloscope
////////////////////////////////////////////////////////////////////////////////

task test_osc(
  int unsigned offset,
  int unsigned evnt_in
);

   int unsigned dat;
id_test = {4'h0,offset[27:20]};

  ##100;
  // configure
  // DMA control address (80) controls ack signals for buffers. for breakdown see rp_dma_s2mm_ctrl


  axi_write(offset+'h0,   'd4);  // start
  axi_write(offset+'h04,   evnt_in);  // osc1 events
  axi_write(offset+'h10,  'h2000);  // pre trigger samples
  axi_write(offset+'h14,  'h6000);  // pre trigger samples
  axi_write(offset+'h20,  'd30);  // LOW LEVEL TRIG
  axi_write(offset+'h24,  'd50);  // HI LEVEL TRIG
  ##5;
  axi_write(offset+'h28, 'd0);  // TRIG EDGE
  ##5
  axi_write(offset+'h38, 'd0);  // decimation enable
  axi_write(offset+'h3C, 'd0);  // decimation enable
  axi_write(offset+'h30, 'd1);  // decimation factor
  axi_write(offset+'h34, 'd1);  // decimation shift
  axi_write(offset+'h0,   'd2);  // start
  axi_write(offset+'h08,   'd4);  // start

  ##5;
  axi_write(offset+'h64, 'h1000);  // buffer 1 address
  ##5;
  axi_write(offset+'h68, 'h2000);  // buffer 2 address
  ##5;
  axi_write(offset+'h6C, 'd30000);  // buffer 1 address
  ##5;
  axi_write(offset+'h70, 'd40000);  // buffer 2 address
  ##5;
  axi_write(offset+'hC0, 'h100);  // buffer 2 address
  ##5;
  axi_read(offset+'hC0, dat);  // buffer 2 address
  ##5;
  axi_write(offset+'hD0, 'h100);  // buffer 2 address
    ##5;
  axi_read(offset+'h64, dat);  // buffer 2 address
  ##5;
  axi_read(offset+'hD0, dat);  // buffer 2 address
  ##5;
  axi_read(offset+'hD8, dat);  // buffer 2 address
  ##5;

  /*
  ##5;
  axi_write(offset+'h74, 'h800);  // calibration offset
  ##5;
  axi_write(offset+'h78, 'h8000);  // calibration gain
  */
  ##5;
  axi_write(offset+'h58, 'h400);  // buffer size - must be greater than axi burst size (128)
  ##5;
      axi_write(offset+'h50, 'h212);  // streaming DMA
      axi_write(offset+'h50, 'h2);  // streaming DMA
      axi_write(offset+'h50, 'h1);  // streaming DMA
        axi_write(offset+'h0,   'd0);  // start
  axi_write(offset+'h0,   'd1);  // start
  axi_write(offset+'h0,   'd2);  // start


  //axi_write(offset+'h00, 4'b1000);  // trigger

  int_ack(offset,'h50);
   // axi_write(offset+'h74, 'hFFFFF800);  // calibration offset
  ##5;
  axi_write(offset+'hC4, 'h1000);  // buffer 2 address
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);
  int_ack(offset,'h50);

  /*
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);
  int_ack(offset);*/
  
  
  /*##1300;
  axi_write(offset+'d80,   'd4);  // BUF1 ACK
  ##1300;
  axi_write(offset+'d80,   'd8);  // BUF2 ACK
  ##1300;
  axi_write(offset+'d80,   'd4);  // BUF1 ACK
  ##1300;
  axi_write(offset+'d80,   'd8);  // BUF2 ACK*/
##10000;
endtask: test_osc

////////////////////////////////////////////////////////////////////////////////
// Testing osciloscope
////////////////////////////////////////////////////////////////////////////////

task test_gpio(
  int unsigned offset,
  int unsigned ctrl_addr,
  int unsigned evnt_in
);

   int unsigned dat;
id_test = {4'h0,offset[27:20]};

  ##100;
  // configure


  axi_write(offset+'h80,   evnt_in);  // la events
  axi_write(offset+'h88,   'd8);  // RESET
  axi_write(offset+'h88,   'd4);  // start    
  axi_write(offset+'h88,   'd4);  // start    

  axi_write(offset+'h10,  'h2000);  // pre trigger samples
  axi_write(offset+'h14,  'h6000);  // pre trigger samples
  axi_write(offset+'h44,  'h10);  // trig mask
  ##5;
  axi_write(offset+'h48, 'd1);  // TRIG EDGE POS
  ##5
  axi_write(offset+'h50, 'd1);  // decimation enable
    axi_write(offset+'h54, 'd1);  // RLE enable

  axi_write(offset+'h3C, 'd0);  // decimation enable
  axi_write(offset+'h30, 'd1);  // decimation factor
  axi_write(offset+'h34, 'd1);  // decimation shift

  axi_write(offset+'h84,   'd4);  // trigger

  ##5;
  axi_write(offset+'hA0, 'h1000);  // buffer 1 address
  ##5;
  axi_write(offset+'hA8, 'h2000);  // buffer 2 address
  ##5;
  axi_write(offset+'hA4, 'h30000);  // buffer 1 address
  ##5;
  axi_write(offset+'hAC, 'h40000);  // buffer 2 address
  ##5;
  axi_write(offset+'hC0, 'h2    );  // DMA adr step
/*
  ##5;
  axi_read(offset+'hA0, dat);  // buffer 2 address
  ##5;
  axi_read(offset+'hA8, dat);  // buffer 2 address
*/

  ##5;
  axi_write(offset+'h9C, 'h400);  // buffer size - must be greater than axi burst size (128)

  ##5;
  /*
  axi_write(offset+ctrl_addr, 'h212);  // streaming DMA
  axi_write(offset+ctrl_addr, 'h2);  // streaming DMA
  axi_write(offset+ctrl_addr, 'h1);  // streaming DMA*/
  axi_write(offset+ctrl_addr, 'h22);  // streaming DMA, reset buffers and flags
  axi_write(offset+ctrl_addr,   'd1);  // start DMA

  axi_write(offset+'h88,   'd0);  // no event
  axi_write(offset+'h88,   'd2);  // start event

  //axi_write(offset+'h88,   'd1);  // trrig
  //axi_write(offset+'h88,   'd2);  // start

  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
  buf_ack(offset+ctrl_addr);
/*
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
  int_ack(offset,ctrl_addr);
*/
##10000;
endtask: test_gpio

task buf_ack(
  int unsigned offset
);
  int unsigned dat;
  //axi_read(offset+'d80, dat);
  ##10;

  // configure
  // DMA control address (80) controls ack signals for buffers. for breakdown see rp_dma_s2mm_ctrl

  do begin
    axi_read(offset+'h8, dat);
    ##5;
    $display("reading state of buffers @%h 1: %h", offset+'h8, dat) ;

  end while (dat[END_STATE_BUF1] != 1'b1); // BUF 1 is full
  ##1000;
      axi_read(offset, dat);

  $display("writing new value of buffers @%h 1, %t", offset, $time) ;

  axi_write(offset, 1 << CTRL_BUF2_RDY);  // BUF1 ACK
##100;
  do begin
    axi_read(offset+'h8, dat);
    ##5;
    $display("reading state of buffers @%h 2: %h", offset+'h8, dat) ;

  end while (dat[END_STATE_BUF2] != 1'b1); // BUF 1 is full
        axi_read(offset, dat);

  ##1000;
  $display("writing new value of buffers @%h 2, %t", offset, $time) ;

  axi_write(offset, 1 << CTRL_BUF1_RDY);  // BUF1 ACK
##100;
endtask: buf_ack

task int_ack(
  int unsigned offset,
  int unsigned ctrl_addr
);
  int unsigned dat;
  ##20;

  // configure
  // DMA control address (80) controls ack signals for buffers. for breakdown see rp_dma_s2mm_ctrl
  do begin
    ##5;
  end while (gpio_sim.rp_gpio_mod.intr != 1'b1); // BUF 1 is full
  ##5;
  axi_write(offset+ctrl_addr, 'h2);  // INTR ACK
  ##500;
  axi_write(offset+ctrl_addr, 'h4);  // BUF1 ACK

  do begin
        ##5;
  end while (gpio_sim.rp_gpio_mod.intr != 1'b1); // BUF 1 is full
  ##5;
  axi_write(offset+ctrl_addr, 'd2);  // INTR ACK
  ##500;
  axi_write(offset+ctrl_addr,   'h8);  // BUF2 ACK 

endtask: int_ack



task int_ack_del(
  int unsigned offset
);
  int unsigned dat;
  axi_read(offset+'h8C, dat);
  ##10;

  // configure
  // DMA control address (80) controls ack signals for buffers. for breakdown see rp_dma_s2mm_ctrl

  //do begin
  //  ##5;
  //end while (gpio_sim.red_pitaya_top_sim.system_wrapper_i.system_i.processing_system7_0.IRQ_F2P[1] != 1'b1); // BUF 1 is full
  ##5;
  axi_write(offset+'h8C, 'd2);  // INTR ACK
  ##40000;
  axi_write(offset+'h8C, 'h4);  // BUF1 ACK

  //do begin
  //      ##5;
  //end while (gpio_sim.red_pitaya_top_sim.system_wrapper_i.system_i.processing_system7_0.IRQ_F2P[1] != 1'b1); // BUF 2 is full
  ##5;
  axi_write(offset+'h8C, 'd2);  // INTR ACK
  ##50000;
  axi_write(offset+'h8C, 'h8);  // BUF2 ACK


endtask: int_ack_del

////////////////////////////////////////////////////////////////////////////////
// Testing DAC stream
////////////////////////////////////////////////////////////////////////////////

task test_dac(
  int unsigned offset,
  int unsigned evnt_in
);
   int unsigned dat;
##1000;
  // configure
  axi_write(offset+'h1C,   'd0);  // stop event
  ##10;
  axi_write(offset+'h1C,   'd4);  // stop event
  ##10;
  axi_write(offset+'h20,   evnt_in);  // gen1 events
  ##10;
  axi_write(offset+'h0,   'd0);  // DAC module setup, currently unsupported
  ##10;
  axi_write(offset+'h04,   'd0);  // scale and offset
  ##10;
  axi_write(offset+'h08,  'd4);  // step
  ##10;
  axi_write(offset+'h1C,   'd2);  // start event
  ##10;
  axi_write(offset+'h24,   'd1);  // DAC1 trigger
  ##10;
  axi_write(offset+'h38, 'h1000);  // buffer address
  ##10;
  axi_write(offset+'h3C, 'h2000);  // buffer address
  ##20;
  axi_write(offset+'h34, 'h100);  // buffer size
  axi_write(offset+'h58, 'h22);  // streaming DMA, reset buffers and flags
  axi_write(offset+'h58,   'd1);  // start DMA
  axi_write(offset+'h1C,   'd2);  // start event
  buf_ack(offset);
  buf_ack(offset);
  buf_ack(offset);
  buf_ack(offset);
  buf_ack(offset);
##100000;
endtask: test_dac

////////////////////////////////////////////////////////////////////////////////
// Testing arbitrary signal generator
////////////////////////////////////////////////////////////////////////////////

task test_asg(
  int unsigned offset,
  int unsigned buffer,
  int unsigned sh = 0
);

reg [9-1: 0] ch0_set;
reg [9-1: 0] ch1_set;
logic        [ 32-1: 0] rdata;
logic signed [ 32-1: 0] rdata_blk [];

  ##10;

  // CH0 DAC data
  axi_write(offset+32'h10000, 32'd3     );  // write table
  axi_write(offset+32'h10004, 32'd30    );  // write table
  axi_write(offset+32'h10008, 32'd8000  );  // write table
  axi_write(offset+32'h1000C,-32'd4     );  // write table
  axi_write(offset+32'h10010,-32'd40    );  // write table
  axi_write(offset+32'h10014,-32'd8000  );  // write table
  axi_write(offset+32'h10018,-32'd2000  );  // write table
  axi_write(offset+32'h1001c, 32'd250   );  // write table

  // CH0 DAC settings
  axi_write(offset+32'h00004,{2'h0,-14'd500, 2'h0, 14'h2F00}  );  // DC offset, amplitude
  axi_write(offset+32'h00008,{2'h0, 14'd7, 16'hffff}          );  // table size
  axi_write(offset+32'h0000C,{2'h0, 14'h1, 16'h0}             );  // reset offset
  axi_write(offset+32'h00010,{2'h0, 14'h2, 16'h0}             );  // table step
  axi_write(offset+32'h00018,{16'h0, 16'd0}                   );  // number of cycles
  axi_write(offset+32'h0001C,{16'h0, 16'd0}                   );  // number of repetitions
  axi_write(offset+32'h00020,{32'd3}                          );  // number of 1us delay between repetitions

  ch0_set = {1'b0 ,1'b0, 1'b0, 1'b0, 1'b1,    1'b0, 3'h2} ;  // set_rgate, set_zero, set_rst, set_once(NA), set_wrap, 1'b0, trig_src

  // CH1 DAC data
  for (int k=0; k<8000; k++) begin
    axi_write(offset+32'h20000 + (k*4), k);  // write table
  end

  // CH1 DAC settings
  axi_write(offset+32'h00024,{2'h0, 14'd0, 2'h0, 14'h2000}    );  // DC offset, amplitude
  axi_write(offset+32'h00028,{2'h0, 14'd7999, 16'hffff}       );  // table size
  axi_write(offset+32'h0002C,{2'h0, 14'h5, 16'h0}             );  // reset offset
  axi_write(offset+32'h00030,{2'h0, 14'h9, 16'h0}             );  // table step
  axi_write(offset+32'h00038,{16'h0, 16'd0}                   );  // number of cycles
  axi_write(offset+32'h0003C,{16'h0, 16'd5}                   );  // number of repetitions
  axi_write(offset+32'h00040,{32'd10}                         );  // number of 1us delay between repetitions

  ch1_set = {1'b0, 1'b0, 1'b0, 1'b1, 1'b1,    1'b0, 3'h1} ;  // set_rgate, set_zero, set_rst, set_once(NA), set_wrap, 1'b0, trig_src

  axi_write(offset+32'h00000,{8'h0, ch1_set,  8'h0, ch0_set}  ); // write configuration

  ##2000;

  ch1_set = {1'b0, 1'b0, 1'b1, 1'b1,    1'b0, 3'h1} ;  // set_a_zero, set_a_rst, set_a_once, set_a_wrap, 1'b0, trig_src

  axi_write(offset+32'h00000,{7'h0, ch1_set,  7'h0, ch0_set}  ); // write configuration

  ##200;

  // CH1 table data readback
  rdata_blk = new [80];
  for (int k=0; k<80; k++) begin
    axi_read(offset+32'h20000 + (k*4), rdata_blk [k]);  // read table
  end

  // CH1 table data readback
  for (int k=0; k<20; k++) begin
    axi_read(offset+32'h00014, rdata);  // read read pointer
    axi_read(offset+32'h00034, rdata);  // read read pointer
    ##1737;
  end

  ##20000;

endtask: test_asg





////////////////////////////////////////////////////////////////////////////////
// Testing SATA
////////////////////////////////////////////////////////////////////////////////

task test_sata(
  int unsigned offset,
  int unsigned sh = 0
);
logic        [ 32-1: 0] rdata;
  ##10;

  // configure
  ##100; axi_write(offset+'h0, 32'h1      );        // Enable transmitter
  ##20;  axi_write(offset+'h0, 32'h3      );        // Enable transmitter & receiver
  ##101; axi_write(offset+'h4, 32'h3      );        // enable TX train
  ##10;  axi_write(offset+'h8, 32'h1      );        // enable RX train
  ##1500; axi_read (offset+'hC, rdata      );        // Return read value
  ##20;  axi_write(offset+'h8, 32'h0      );        // disable RX train
  ##20;  axi_write(offset+'h4, {16'hF419, 16'h2});  // Custom value
  ##20;  axi_write(offset+'h4, {16'hF419, 16'h5});  // Random valu
  ##20;  axi_write(offset+'h10, 32'h1      );       // Clear error counter
  ##20;  axi_write(offset+'h10, 32'h0      );       // Enable error counter
  ##404; axi_write(offset+'h4, {16'h0, 16'h4});     // Sent back read value

  ##1000;

endtask: test_sata


































////////////////////////////////////////////////////////////////////////////////
// AXI4 read/write tasks
////////////////////////////////////////////////////////////////////////////////

task axi_read (
  input  logic [32-1:0] adr,
  output logic [32-1:0] dat
);
  gpio_sim.axi_bm_reg.ReadTransaction (
    .ARDelay (0),  .ar ('{
                          id    : id_test,
                          addr  : adr,
                          region: 0,
                          len   : 0,
                          size  : 3'b010,
                          burst : 0,
                          lock  : 0,
                          cache : 0,
                          prot  : 0,
                          qos   : 0
                         }),
     .RDelay (0),   .rdat (dat)
  );
endtask: axi_read

/*task axi_read_osc2 (
  input  logic [32-1:0] adr,
  output logic [32-1:0] dat
);
  gpio_sim.axi_bm_osc2.ReadTransaction (
    .ARDelay (0),  .ar ('{
                          id    : 0,
                          addr  : adr,
                          region: 0,
                          len   : 0,
                          size  : 3'b010,
                          burst : 0,
                          lock  : 0,
                          cache : 0,
                          prot  : 0,
                          qos   : 0
                         }),
     .RDelay (0),   .rdat (dat)
  );
endtask: axi_read_osc2*/


task axi_write (
  input  logic [32-1:0] adr,
  input  logic [32-1:0] dat
);
  int b;
  gpio_sim.axi_bm_reg.WriteTransaction (
    .AWDelay (0),  .aw ('{
                          id    : id_test,
                          addr  : adr,
                          region: 0,
                          len   : 0,
                          size  : 3'b010,
                          burst : 0,
                          lock  : 0,
                          cache : 0,
                          prot  : 0,
                          qos   : 0
                         }),
     .WDelay (0),   .w ('{
                          id    : id_test,
                          data  : dat,
                          strb  : '1,
                          last  : 1
                         }),
     .BDelay (0),   .b (b)
  );
endtask: axi_write






endmodule
