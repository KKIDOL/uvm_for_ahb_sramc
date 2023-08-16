//  Class: ref_model
//
class ref_model extends uvm_component;
    `uvm_component_utils(ref_model);
    bit hready_resp = 1;
    bit  [1:0] hresp = 1;

    bit [31:0] hrdata;
    bit         bist_done = 1;
    bit         bist_fail = 8'hff;

    bit         bank_sel;
    static  bit [31:0]  ram_data_w;
    static  bit [31:0]  ram_data_r0;
    static  bit [31:0]  ram_data_r1;

    bit [14:0] ram_addr;
    bit [1:0]  ram_size;
    bit [1:0]  byte_sel;
    static  bit [31:0] ram0[16'd32000];
    static  bit [31:0] ram1[16'd32000];

    parameter   IDLE    = 2'b00,
                BUSY    = 2'b01,
                NONSEQ  = 2'b10,
                SEQ     = 2'b11;

    uvm_blocking_get_port#(i_packet) ipkt_port;
    uvm_analysis_port#(o_packet) opkt_ap;

    //  Constructor: new
    function new(string name = "ref_model", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern function void build_phase (uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task model (input i_packet ipkt, output o_packet opkt);
    extern virtual task write_function() ;
    extern virtual task read_function();

    
endclass: ref_model

    function void ref_model::build_phase(uvm_phase phase);
        super.build_phase(phase);
        ipkt_port = new("ipkt_port", this);
        opkt_ap= new("opkt_ap",this);
    endfunction

    task ref_model::run_phase(uvm_phase phase);
        i_packet ipkt;
        i_packet new_ipkt;
        o_packet opkt;
        o_packet new_opkt;
        forever begin
            ipkt_port.get(ipkt);
	    `uvm_info(get_full_name, "get the i_packet", UVM_NONE)
            ipkt.print();
            new_ipkt = new("new_ipkt");
            opkt = new("opkt");
            new_ipkt.copy(ipkt);
	    // COMPARE THE PACKET, IF !hwrite read the packet
            model(new_ipkt ,opkt);
            new_opkt = new("new_opkt");
            new_opkt.copy(opkt);
            `uvm_info(get_full_name(), "start send new_opkt to scb", UVM_NONE)
            new_opkt.print();
            opkt_ap.write(new_opkt);
            `uvm_info(get_full_name(), "end send new_opkt to scb", UVM_NONE)
        end 
    endtask

    task ref_model::model(input i_packet ipkt, output o_packet opkt);
            bank_sel = ipkt.haddr[15];
            ram_addr = ipkt.haddr[14:2];
            byte_sel = ipkt.haddr[1:0];
            ram_size = ipkt.hsize[1:0];
            fork
                if((ipkt.hsel)&&(ipkt.hready)&&(ipkt.htrans == NONSEQ))begin
                    ram_data_w = ipkt.hwdata;
                    write_function();
                    read_function();
                end
            join

            opkt = new("opkt");
            opkt.hready_resp = 1;
            opkt.hresp = 2'b00;
            opkt.bist_done = 1'b0;
            opkt.bist_fail = 8'hff;
            if(bank_sel == 0)begin
                opkt.hrdata = ram_data_r0;
            end else begin
                opkt.hrdata = ram_data_r1;
            end

    endtask

    task ref_model::write_function();
        casex({ram_size,bank_sel,byte_sel})
            // bank0 byte write
            5'b00_0_00: ram0[ram_addr][7:0]     = ram_data_w[7:0]   ;
            5'b00_0_01: ram0[ram_addr][15:8]    = ram_data_w[15:8]  ;
            5'b00_0_10: ram0[ram_addr][23:16]   = ram_data_w[23:16] ;
            5'b00_0_11: ram0[ram_addr][31:24]   = ram_data_w[31:24] ;
            // bank0 half-word write
            5'b01_0_0x: ram0[ram_addr][15:0]    = ram_data_w[15:0]  ;
            5'b01_0_1x: ram0[ram_addr][31:16]   = ram_data_w[31:16] ;
            // bank0 word write
            5'b10_0_xx: ram0[ram_addr][31:0]    = ram_data_w[31:0]  ;

            // bank1 byte write
            5'b00_1_00: ram1[ram_addr][7:0]     = ram_data_w[7:0]   ;
            5'b00_1_01: ram1[ram_addr][15:8]    = ram_data_w[15:8]  ;
            5'b00_1_10: ram1[ram_addr][23:16]   = ram_data_w[23:16] ;
            5'b00_1_11: ram1[ram_addr][31:24]   = ram_data_w[31:24] ;
            // bank1 half-word write
            5'b01_1_0x: ram1[ram_addr][15:0]    = ram_data_w[15:0]  ;
            5'b01_1_1x: ram1[ram_addr][31:16]   = ram_data_w[31:16] ;
            // bank1 word write
            5'b10_1_xx: ram1[ram_addr][31:0]    = ram_data_w[31:0]  ;
            default: begin
                ram0[ram_addr][31:0]    = 32'h0000  ;
                ram1[ram_addr][31:0]    = 32'h0000  ;
            end
        endcase
    endtask
    
    task ref_model::read_function();
        casex({ram_size,bank_sel,byte_sel})
            // bank0 byte write
            5'b00_0_00: ram_data_r0[7:0]        = ram0[ram_addr][7:0]       ;
            5'b00_0_01: ram_data_r0[15:8]       = ram0[ram_addr][15:8]      ;
            5'b00_0_10: ram_data_r0[23:16]      = ram0[ram_addr][23:16]     ;
            5'b00_0_11: ram_data_r0[31:24]      = ram0[ram_addr][31:24]     ;
            // bank0 half-word read
            5'b01_0_0x: ram_data_r0[15:0]       = ram0[ram_addr][15:0]      ;
            5'b01_0_1x: ram_data_r0[31:16]      = ram0[ram_addr][31:16]     ;
            // bank0 word read
            5'b10_0_xx: ram_data_r0[31:0]       = ram0[ram_addr][31:0]      ;

            // bank1 byte read
            5'b00_1_00: ram_data_r1[7:0]        = ram1[ram_addr][7:0]       ;
            5'b00_1_01: ram_data_r1[15:8]       = ram1[ram_addr][15:8]      ;
            5'b00_1_10: ram_data_r1[23:16]      = ram1[ram_addr][23:16]     ;
            5'b00_1_11: ram_data_r1[31:24]      = ram1[ram_addr][31:24]     ;
            // bank1 half-word read
            5'b01_1_0x: ram_data_r1[15:0]       = ram1[ram_addr][15:0]      ;
            5'b01_1_1x: ram_data_r1[31:16]      = ram1[ram_addr][31:16]     ;
            // bank1 word read
            5'b10_1_xx: ram_data_r1[31:0]       = ram1[ram_addr][31:0]      ;
            default: begin
                ram_data_r0[31:0] = 32'h0000 ;
                ram_data_r1[31:0] = 32'h0000 ;
            end
        endcase
    endtask
