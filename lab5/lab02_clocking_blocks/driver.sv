/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/

 class Driver;
    Transaction transaction;
    Monitor monitor;
    virtual tb_ifc vifc;

    function new(virtual tb_ifc new_ifc);
        vifc = new_ifc;
        transaction = new();
        monitor = new(vifc);
    endfunction

    function void testbench_info;
        $display("\n\n***********************************************************");
        $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
        $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
        $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
        $display(    "***********************************************************");
    endfunction

    task init_signals;
        $display("\nReseting the instruction register...");
        vifc.cb.write_pointer <= 5'h00;      // initialize write pointer
        vifc.cb.read_pointer  <= 5'h1F;      // initialize read pointer
        vifc.cb.load_en       <= 1'b0;       // initialize load control line
        vifc.cb.reset_n       <= 1'b0;       // assert reset_n (active low)
        repeat (2) @vifc.cb;                 // hold in reset for 2 clock cycles
        vifc.cb.reset_n       <= 1'b1;       // assert reset_n (active low)
    endtask

    task drive_transaction;
        @(vifc.cb) transaction.randomize_transaction;
        @(vifc.cb) transaction.print_transaction;
        
        vifc.cb.operand_a <= transaction.operand_a;
        vifc.cb.operand_b <= transaction.operand_b;
        vifc.cb.opcode <= transaction.opcode;
        vifc.cb.write_pointer <= transaction.write_pointer;
        vifc.cb.read_pointer <= transaction.read_pointer;
    endtask

    task drive;
       testbench_info();
       init_signals();

       $display("\nWriting values to register stack...");
       @vifc.cb vifc.cb.load_en <= 1'b1;  // enable writing to register
       repeat (3) begin
          drive_transaction();
       end
       @vifc.cb vifc.cb.load_en <= 1'b0;  // turn-off writing to register
       monitor.read_registers();
       @vifc.cb;
       testbench_info();
    endtask

 endclass 