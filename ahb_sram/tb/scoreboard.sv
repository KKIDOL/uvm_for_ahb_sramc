//  Class: scoreboard
//
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard);

    i_packet ipkt;
    uvm_blocking_get_port #(o_packet) exp_port;
    uvm_blocking_get_port #(o_packet) act_port;

    //  Constructor: new
    function new(string name = "scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);

endclass: scoreboard

function void scoreboard::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    exp_port = new("exp_port", this);
    act_port = new("act_port", this);
    
endfunction: build_phase

task scoreboard::main_phase(uvm_phase phase);
    o_packet get_expecet, get_actual, tmp_tran_exp;
    o_packet expect_queue[$];
    fork
        while (1) begin
            exp_port.get(get_expecet);
            expect_queue.push_back(get_expecet);
        end

        while (1) begin
            #20;
            tmp_tran_exp = new("tmp_tran_exp");
            act_port.get(get_actual);
            if(expect_queue.size() > 0)begin
                tmp_tran_exp = expect_queue.pop_front();
                `uvm_info(get_full_name(), "print tmp_tran_exp", UVM_LOW)
                tmp_tran_exp.print();
            end

            if(tmp_tran_exp.hrdata == get_actual.hrdata)begin
                `uvm_info(get_full_name(), "compare pass", UVM_LOW)   
            end else begin
                `uvm_error(get_full_name(), "compare fail")
                $display("the expect pkt is: \n");
                tmp_tran_exp.print();
                $display("the actual pkt is: \n");
                get_actual.print();
            end
        end
    join
endtask: main_phase
