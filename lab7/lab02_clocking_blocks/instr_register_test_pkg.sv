/***********************************************************************
 * A SystemVerilog RTL model of an instruction register:
 * User-defined type definitions
 **********************************************************************/
package instr_register_test_pkg;

  import instr_register_pkg::*;
  int seed = 555;

  `include "transaction.sv";
  `include "monitor.sv";
  `include "driver.sv";

endpackage
