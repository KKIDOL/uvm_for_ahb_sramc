//  Class: sram_env
//
class sram_env extends uvm_env;
    `uvm_component_utils(sram_env);

    i_agent i_agt;
    o_agent o_agt;
    scoreboard scb;
    ref_model model;

    uvm_tlm_analysis_fifo #(i_packet) imon2model_fifo;
    uvm_tlm_analysis_fifo #(o_packet) model2scb_fifo;
    uvm_tlm_analysis_fifo #(o_packet) omon2scb_fifo;

    
    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    
endclass: sram_env

function void sram_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	i_agt = i_agent::type_id::create("i_agt", this);
	o_agt = o_agent::type_id::create("o_agt", this);
	scb = scoreboard::type_id::create("scb", this);
	model = ref_model::type_id::create("model", this);
	imon2model_fifo = new("imon2model_fifo", this);
  	model2scb_fifo = new("model2scb_fifo", this);
    	omon2scb_fifo = new("omon2scb_fifo", this);
endfunction: build_phase

function void sram_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // imon and ref_model connect
    i_agt.i_mon.ap.connect(imon2model_fifo.analysis_export);
    model.ipkt_port.connect(imon2model_fifo.blocking_get_export);
    // ref_model and scb
    model.opkt_ap.connect(model2scb_fifo.analysis_export);
    scb.exp_port.connect(model2scb_fifo.blocking_get_export);
    //o_mon and scb
    o_agt.o_mon.ap.connect(omon2scb_fifo.analysis_export);
    scb.act_port.connect(omon2scb_fifo.blocking_get_export);

    
endfunction: connect_phase

