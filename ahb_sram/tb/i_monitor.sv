//  Class: i_monitor
//
class i_monitor extends uvm_monitor;
    `uvm_component_utils(i_monitor);

    virtual ahb_if vif;
    uvm_analysis_port#(i_packet) ap;
    i_packet ipkt;


    //  Constructor: new
    function new(string name = "i_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task get_data(i_packet ipkt);

    
endclass: i_monitor

function void i_monitor::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_full_name(), "i_monitor interface not get")
endfunction: build_phase

task i_monitor::run_phase(uvm_phase phase);
    @(posedge vif.hresetn);
    // @(vif.i_monitor_cb);
    forever begin
        if(vif.hwrite && vif.hready)begin
            ipkt = new("ipkt");
            get_data(ipkt);
            `uvm_info(get_full_name(), "i_monitor start send ipkt to ref_model", UVM_LOW)
            ipkt.print();
            ap.write(ipkt);
        end else begin
            @(vif.i_monitor_cb);
        end
    end
endtask: run_phase

task i_monitor::get_data(i_packet ipkt);
    ipkt.hsel         <= vif.i_monitor_cb.hsel;
    ipkt.haddr        <= vif.i_monitor_cb.haddr;
    ipkt.hsize        <= vif.i_monitor_cb.hsize;
    ipkt.hburst       <= vif.i_monitor_cb.hburst;
    ipkt.hwrite       <= vif.i_monitor_cb.hwrite;
    ipkt.htrans       <= vif.i_monitor_cb.htrans;
    ipkt.hready       <= vif.i_monitor_cb.hready;
    @(vif.i_monitor_cb);
    ipkt.hwdata       <= vif.i_monitor_cb.hwdata;
    @(vif.i_monitor_cb);
endtask


