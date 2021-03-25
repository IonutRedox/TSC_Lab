/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/


module instr_register_test (tb_ifc ifc);  // interface port
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;
  import instr_register_test_pkg::Driver;
  import instr_register_test_pkg::Monitor;

 
  int seed = 555;

  Driver driver;
  Monitor monitor;

  initial begin
    driver = new(ifc);
    monitor = new(ifc);

    driver.testbench_info();
    driver.init_signals();

    $display("\nWriting values to register stack...");
    @ifc.cb ifc.cb.load_en <= 1'b1;  // enable writing to register
    repeat (3) begin
      driver.drive_transaction();
    end
    @ifc.cb ifc.cb.load_en <= 1'b0;  // turn-off writing to register

    monitor.read_registers();

    @ifc.cb;
    driver.testbench_info();

    $finish;
  end

endmodule: instr_register_test
