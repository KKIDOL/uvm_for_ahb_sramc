//  Class: o_packet
//
class o_packet extends uvm_sequence_item;

    //  Group: Variables
    rand bit                                  hready_resp;
    rand bit [1:0]                            hresp;
    rand bit [31:0]                           hrdata;
    rand bit                                  bist_done;
    rand bit [7:0]                            bist_fail;

    `uvm_object_utils_begin(o_packet)
        `uvm_field_int(hready_resp,	UVM_ALL_ON)
        `uvm_field_int(hresp, 	UVM_ALL_ON)
        `uvm_field_int(hrdata, 	UVM_ALL_ON)
        `uvm_field_int(bist_done, 	UVM_ALL_ON)
        `uvm_field_int(bist_fail, 	UVM_ALL_ON)
    `uvm_object_utils_end


    //  Group: Constraints



    //  Constructor: new
    function new(string name = "o_packet");
        super.new(name);
    endfunction: new

endclass: o_packet
