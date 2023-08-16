//  Class: i_agent
//
typedef uvm_sequencer #(i_packet) sequencer;

class i_agent extends uvm_agent;
    `uvm_component_utils(i_agent);

    i_driver    drv;
    i_monitor   i_mon;
    sequencer   sqr;


    //  Constructor: new
    function new(string name = "i_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: i_agent

function void i_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = i_driver::type_id::create("drv", this);
    sqr = sequencer::type_id::create("sqr", this);
    i_mon = i_monitor::type_id::create("i_mon", this);
endfunction

function void i_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction
