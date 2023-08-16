//  Class: i_packet
//
class i_packet extends uvm_sequence_item;


    //  Group: Variables
    rand bit [31:0]    	  	    hwdata;
    rand bit [31:0]    		    haddr;
    rand bit [2:0]                        hsize;
    rand bit [2:0]                        hburst;
    rand bit [1:0]                        htrans;
    rand bit                              hwrite;
    rand bit                              hsel;
    rand bit                              hready;    

    
    `uvm_object_utils_begin(i_packet)
        `uvm_field_int(hwdata		,UVM_ALL_ON)
        `uvm_field_int(haddr		,UVM_ALL_ON)
        `uvm_field_int(hsize		,UVM_ALL_ON)
        `uvm_field_int(hburst		,UVM_ALL_ON)
        `uvm_field_int(htrans		,UVM_ALL_ON)
        `uvm_field_int(hwrite		,UVM_ALL_ON)
        `uvm_field_int(hsel		,UVM_ALL_ON) 
        `uvm_field_int(hready	,UVM_ALL_ON)  
    `uvm_object_utils_end

    //  Group: Constraints
    constraint c_i_packet {
        haddr[31:16] == 0;
        hsel == 1;
    }
    

    //  Constructor: new
    function new(string name = "i_packet");
        super.new(name);
    endfunction: new

    
endclass: i_packet
