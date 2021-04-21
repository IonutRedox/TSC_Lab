/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/
 import instr_register_pkg::*;

 class Monitor;
    virtual tb_ifc vifc;

    function new(virtual tb_ifc new_ifc);
        vifc = new_ifc;
    endfunction

    task read_registers;
        // read back and display same three register locations
        $display("\nReading back the same register locations written...");
        for (int i=0; i<=2; i++) begin
            // A later lab will replace this loop with iterating through a
            // scoreboard to determine which address were written and the
            // expected values to be read back
            @vifc.cb vifc.cb.read_pointer <= i;
            @vifc.cb print_results;
        end
    endtask

    function void print_results;
        $display("Read from register location %0d: ", vifc.cb.read_pointer);
        $display("  opcode = %0d (%s)", vifc.cb.instruction_word.opc, vifc.cb.instruction_word.opc.name);
        $display("  operand_a = %0d",   vifc.cb.instruction_word.op_a);
        $display("  operand_b = %0d\n", vifc.cb.instruction_word.op_b);
    endfunction
 endclass