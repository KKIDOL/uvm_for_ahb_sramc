//  Class: my_test
//
class my_test extends uvm_test;
    `uvm_component_utils(my_test);

    //  Group: Configuration Object(s)
    

    //  Group: Components
    sram_env        env;
    

    //  Group: Variables


    //  Group: Functions

    //  Constructor: new
    function new(string name = "my_test", uvm_component parent);
        super.new(name, parent);
        // `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH)
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
   
    
endclass: my_test

function void my_test::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    // `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH)
    env = sram_env::type_id::create("env", this);
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", tx_sequence::type_id::get());
    
endfunction: build_phase


function void my_test::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    // `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH)
    uvm_top.print_topology();
endfunction: start_of_simulation_phase
