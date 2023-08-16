//  Class: sequencer
//
class sequencer extends uvm_sequencer #(i_packet);
 
  `uvm_component_utils(sequencer)
  extern function new(string name ="sequencer",uvm_component parent = null);
  extern function void build();
endclass
//--------------------------------------------------------------------------------------------------------
// sv
//--------------------------------------------------------------------------------------------------------
function sequencer::new(string name ="sequencer",uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), $sformatf("created"), UVM_LOW)
endfunction : new
 
function void sequencer::build();
	super.build();
	`uvm_info(get_type_name(), "built", UVM_LOW)
endfunction : build




