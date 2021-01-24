`timescale 1ns/1ns
module pps_tb;

   parameter clk_freq_hz = 50_000;
   localparam clk_half_period = 1000_000_000/clk_freq_hz/2;

   reg clk = 1'b1;

   always #clk_half_period clk <= !clk;


   wire pps;

   pps
     #(.clk_freq_hz (clk_freq_hz))
   dut
     (.clk   (clk),
      .pps_o (pps));

   integer i;
   time last_edge = 0;

   initial begin
      @(pps);
      last_edge = $time;
      for (i=0; i<10;i=i+1) begin
     @(pps);
     if (($time-last_edge) != 1_000_000_000) begin
        $display("Error! Length of pulse was %0d ns", $time-last_edge);
        $finish;
     end else
       $display("Pulse %0d/10 OK!", i+1);
     last_edge = $time;
      end
      $display("Testbench finished OK");
      $finish;
   end

endmodule
