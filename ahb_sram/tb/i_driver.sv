//  Class: i_driver
//
class i_driver extends uvm_driver#(i_packet);
    `uvm_component_utils(i_driver);

    virtual ahb_if vif;

    i_packet req;

    function new(string name = "i_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual task pre_configure_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task reset();
    extern virtual task drive_data(i_packet tr);

endclass: i_driver


function void i_driver::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_full_name(), "i_driver interface not get")

endfunction: build_phase

// task i_driver::pre_configure_phase(uvm_phase phase);
//     `uvm_info(get_full_name(),"pre_configure_phase",UVM_LOW)
//     super.pre_configure_phase(phase);
//     vif.i_driver_cb.hsel <= 'd0;
//     vif.i_driver_cb.haddr <= 'd0;
//     vif.i_driver_cb.hwdata <= 'd0;
//     vif.i_driver_cb.hsize <= 'd0;
//     vif.i_driver_cb.hburst <= 'd0;
//     vif.i_driver_cb.hwrite <= 'd0;
//     vif.i_driver_cb.htrans <= 'd0;
//     vif.i_driver_cb.hready <= 'd0;
// endtask: pre_configure_phase

task i_driver::run_phase(uvm_phase phase);
    // @(vif.i_driver_cb);
    `uvm_info(get_full_name(),"start the run_phase",UVM_LOW)
    forever begin
        reset();
    	@(posedge vif.hresetn);
    	forever begin
    		`uvm_info(get_full_name(),"main phase get xact before",UVM_LOW)
        	seq_item_port.get_next_item(req);
        	`uvm_info(get_full_name(),"main phase get xact after",UVM_LOW)
        	req.print();
        	drive_data(req);
        	seq_item_port.item_done(req);
        end
    end
endtask: run_phase

task i_driver::reset();
    `uvm_info(get_full_name(), "start i_driver reset phase", UVM_LOW)
    wait(!vif.hresetn);
    `uvm_info(get_full_name(), "get hresetn == 0", UVM_LOW)
    vif.i_driver_cb.hsel <= 'd0;
    `uvm_info(get_full_name(), "reset hsel", UVM_LOW)
    vif.i_driver_cb.haddr <= 'd0;
    vif.i_driver_cb.hwdata <= 'd0;
    vif.i_driver_cb.hsize <= 'd0;
    vif.i_driver_cb.hburst <= 'd0;
    vif.i_driver_cb.hwrite <= 'd0;
    vif.i_driver_cb.htrans <= 'd0;
    vif.i_driver_cb.hready <= 'd0;
    `uvm_info(get_full_name(), "end i_driver reset phase", UVM_LOW)
endtask

task i_driver::drive_data(i_packet tr);
    `uvm_info(get_full_name(),"start drive packet addr",UVM_LOW)
    vif.i_driver_cb.hsel <= tr.hsel;
    vif.i_driver_cb.haddr <= tr.haddr;
    vif.i_driver_cb.hsize <= tr.hsize;
    vif.i_driver_cb.hburst <= tr.hburst;
    vif.i_driver_cb.hwrite <= tr.hwrite;
    vif.i_driver_cb.htrans <= tr.htrans;
    vif.i_driver_cb.hready <= tr.hready;
    `uvm_info(get_full_name(),"end drive packet addr",UVM_LOW)
    `uvm_info(get_full_name(),"start drive packet data",UVM_LOW)
    @vif.i_driver_cb;
    if(vif.hwrite && vif.hready)begin
        vif.i_driver_cb.hwdata <= tr.hwdata;
    end
    `uvm_info(get_full_name(), "driver send packet successful", UVM_LOW) 
    @vif.i_driver_cb;
endtask


