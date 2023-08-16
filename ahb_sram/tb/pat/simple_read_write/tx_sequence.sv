//  Class: tx_sequence
//
class tx_sequence extends uvm_sequence#(i_packet);
    `uvm_object_utils(tx_sequence);

    //  Group: Variables


    //  Group: Constraints


    //  Group: Functions

    //  Constructor: new
    function new(string name = "tx_sequence");
        super.new(name);
	// UVM-1.2 auto objection raise/drop
	//
	set_automatic_phase_objection(1);
    endfunction: new


    extern virtual task body();
    
endclass: tx_sequence

task tx_sequence::body();
    `uvm_info(get_full_name(), "this is tx_sequence", UVM_LOW)
    #100;
    `uvm_info(get_full_name(), "sequence: uvm_do_with start", UVM_NONE)

    `uvm_do_with(req,{
        hsel == 1;
        hwrite == 1;
        hready == 1;
        hsize == 3'b010;
        hburst == 3'b000;
        htrans == 2'b10;
        hwdata == 32'hffff_ffff;
        haddr[15] == 0;
        haddr[14:2] == 13'd0;
        haddr[1:0] == 2'b11;
    });

    #100;
    `uvm_do_with(req,{
        hsel == 1;
        hwrite == 0;
        hready == 1;
        hsize == 3'b010;
        hburst == 3'b000;
        htrans == 2'b10;
        hwdata == 32'hffff_ffff;
        haddr[15] == 0;
        haddr[14:2] == 13'd0;
        haddr[1:0] == 2'b11;
    });

    `uvm_info(get_full_name(), "sequece: uvm_do_with stop", UVM_NONE)
    
    #100;


endtask


