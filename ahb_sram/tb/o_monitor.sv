//  Class: o_monitor
//
class o_monitor extends uvm_monitor#(o_packet);
    `uvm_component_utils(o_monitor);

    virtual ahb_if vif;
    uvm_analysis_port#(o_packet) ap;
    o_packet req;


    //  Constructor: new
    function new(string name = "o_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task get_pkt(o_packet req);

    
endclass: o_monitor

function void o_monitor::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_full_name(), "o_monitor interface not get")
endfunction: build_phase

task o_monitor::run_phase(uvm_phase phase);
    o_packet opkt;
    @(posedge vif.hresetn);
    // @(vif.o_monitor_cb);
    while (1) begin
    // @(vif.o_monitor_cb);
        if(!vif.hwrite)begin
            @(vif.o_monitor_cb);
            opkt = new("opkt");
            get_pkt(opkt);
            `uvm_info(get_full_name,"o_moniter start send opkt to scoreboard", UVM_LOW)
            ap.write(opkt);
            `uvm_info(get_full_name(), "o_monitor finish send opkt to scoreboard", UVM_LOW)
        end else begin
            @(vif.o_monitor_cb);
        end
    end
endtask: run_phase

task o_monitor::get_pkt(o_packet req);
    req.hready_resp <= vif.o_monitor_cb.hready_resp;
    req.hresp      <= vif.o_monitor_cb.hresp;
    req.hrdata     <= vif.o_monitor_cb.hrdata;
    req.bist_done  <= vif.o_monitor_cb.bist_done;
    req.bist_fail  <= vif.o_monitor_cb.bist_fail;
    @(vif.o_monitor_cb);
endtask
