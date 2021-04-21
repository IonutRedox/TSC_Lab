/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/
 
class Transaction;
  rand opcode_t       opcode;
  rand operand_t    operand_a, operand_b;
  address_t      write_pointer;

  constraint operand_a_const{
    operand_a > -16;operand_a<16;
  }
  constraint operand_b_const{
    operand_b >= 0;operand_b<16;
  }
  constraint opcode_const{
    opcode >= 0;opcode<8;
  }

  function void print_transaction;
    $display("Writing to register location %0d: ", write_pointer);
    $display("  opcode = %0d (%s)", opcode, opcode.name);
    $display("  operand_a = %0d",   operand_a);
    $display("  operand_b = %0d\n", operand_b);
  endfunction

endclass

class TransactionExtended extends Transaction;

  virtual function void print_transaction;
    $display("Extended transaction print");
    super.print_transaction();
  endfunction: print_transaction

  function new();

  endfunction
endclass