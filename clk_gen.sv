module clk_gen (
  input   logic   i_clk_in,
  input   logic   i_reset,
  output  logic   o_clk_out,
  output  logic   o_locked
);

// Input buffering
logic w_clk_in_clk_wiz_gen;
IBUF clkin1_ibufg
  (.O (w_clk_in_clk_wiz_gen),
   .I (i_clk_in));

// Clocking PRIMITIVE

// Instantiation of the MMCM PRIMITIVE
// * Unused inputs are tied off
// * Unused outputs are labeled unused
logic w_clk_out_clk_wiz_gen;
logic [0:15] w_do_unused;
logic w_drdy_unused;
logic w_psdone_unused;
logic w_locked_int;
logic w_clkfbout_clk_wiz_gen;
logic w_clkfbout_buf_clk_wiz_gen;
logic w_clkfboutb_unused;
logic w_clkout0b_unused;
logic w_clkout1_unused;
logic w_clkout1b_unused;
logic w_clkout2_unused;
logic w_clkout2b_unused;
logic w_clkout3_unused;
logic w_clkout3b_unused;
logic w_clkout4_unused;
logic w_clkout5_unused;
logic w_clkout6_unused;
logic w_clkfbstopped_unused;
logic w_clkinstopped_unused;
logic w_reset_high;

MMCME2_ADV
#(.BANDWIDTH            ("OPTIMIZED"),
  .CLKOUT4_CASCADE      ("FALSE"),
  .COMPENSATION         ("ZHOLD"),
  .STARTUP_WAIT         ("FALSE"),
  .DIVCLK_DIVIDE        (1),
  .CLKFBOUT_MULT_F      (40.00),//55.250, 60.000 works as well
  .CLKFBOUT_PHASE       (0.000),
  .CLKFBOUT_USE_FINE_PS ("FALSE"),
  .CLKOUT0_DIVIDE_F     (10.000),//11 originally. 60 / 55 now most
  .CLKOUT0_PHASE        (0.000),
  .CLKOUT0_DUTY_CYCLE   (0.500),
  .CLKOUT0_USE_FINE_PS  ("FALSE"),
  .CLKIN1_PERIOD        (10.0))

mmcm_adv_inst
 (
  // Disable all but output clock 0
  .CLKFBOUT            (w_clkfbout_clk_wiz_gen),
  .CLKFBOUTB           (w_clkfboutb_unused),
  .CLKOUT0             (w_clk_out_clk_wiz_gen),
  .CLKOUT0B            (w_clkout0b_unused),
  .CLKOUT1             (w_clkout1_unused),
  .CLKOUT1B            (w_clkout1b_unused),
  .CLKOUT2             (w_clkout2_unused),
  .CLKOUT2B            (w_clkout2b_unused),
  .CLKOUT3             (w_clkout3_unused),
  .CLKOUT3B            (w_clkout3b_unused),
  .CLKOUT4             (w_clkout4_unused),
  .CLKOUT5             (w_clkout5_unused),
  .CLKOUT6             (w_clkout6_unused),
   // Input clock control
  .CLKFBIN             (w_clkfbout_buf_clk_wiz_gen),
  .CLKIN1              (w_clk_in_clk_wiz_gen),
  .CLKIN2              (1'b0),
   // Tied to always select the primary input clock
  .CLKINSEL            (1'b1),
  // Ports for dynamic reconfiguration
  .DADDR               (7'h0),
  .DCLK                (1'b0),
  .DEN                 (1'b0),
  .DI                  (16'h0),
  .DO                  (w_do_unused),
  .DRDY                (w_drdy_unused),
  .DWE                 (1'b0),
  // Ports for dynamic phase shift
  .PSCLK               (1'b0),
  .PSEN                (1'b0),
  .PSINCDEC            (1'b0),
  .PSDONE              (w_psdone_unused),
  // Other control and status signals
  .LOCKED              (w_locked_int),
  .CLKINSTOPPED        (w_clkinstopped_unused),
  .CLKFBSTOPPED        (w_clkfbstopped_unused),
  .PWRDWN              (1'b0),
  .RST                 (w_reset_high));

assign w_reset_high = i_reset;
assign o_locked     = w_locked_int;
 
// Output buffering
BUFG clkf_buf
 (.O (w_clkfbout_buf_clk_wiz_gen),
  .I (w_clkfbout_clk_wiz_gen));

BUFG clkout1_buf
 (.O (o_clk_out),
  .I (w_clk_out_clk_wiz_gen));

endmodule
