//  Class: o_agent
//
class o_agent extends uvm_agent;
    `uvm_component_utils(o_agent);

    o_monitor o_mon;


    //  Constructor: new
    function new(string name = "o_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    
endclass: o_agent

function void o_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    o_mon = o_monitor::type_id::create("o_mon", this);
endfunction

function void o_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction
