`include "uvm_pkg.sv"  
`include "uvm_macros.svh"
// `include "../tb/ahb_if.sv"

module simtop();

    import uvm_pkg::*;
    
    bit hclk, hresetn;
    ahb_if vif(hclk, hresetn);

    sramc_top dut(
        .hclk                (hclk	 	        ),
        .sram_clk            (vif.sram_clk      ),
        .hresetn             (hresetn           ),
        .hsel                (vif.hsel          ),
        .hwrite              (vif.hwrite        ),
        .hready              (vif.hready        ),
        .hsize               (vif.hsize         ),    
        .hburst              (vif.hburst        ),
        .htrans              (vif.htrans        ),
        .hwdata              (vif.hwdata        ),
        .haddr               (vif.haddr         ),		
        .dft_en              ('d0               ),
        .bist_en             ('d0               ),
        .hready_resp         (vif.hready_resp   ),
        .hresp               ('d0               ),
        .hrdata              (vif.hrdata        ),
        .bist_done           (vif.bist_done     ),
        .bist_fail           (vif.bist_fail     )
        );
        
        
    initial begin
        uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", vif);
        uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top.env.i_agt.i_mon", "vif", vif);
        uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top.env.o_agt.o_mon", "vif", vif);
    end

    initial begin
        hclk = 0;
        forever begin
            #10 hclk = ~hclk;
        end
    end

    initial begin
        vif.sram_clk = 0;
        forever begin
            #10 vif.sram_clk = ~vif.sram_clk;
        end
    end

    initial begin
        hresetn = 0;
        repeat(5)begin
            @(posedge hclk);
        end
        hresetn = 1;
    end

    // initial begin
    //     hresetn = 0;
    //     #5;
    //     hresetn = 1;
    // end

    initial begin
        vif.hready = 1;
    end

    

    initial begin
       run_test();
    end

    initial	begin
        $fsdbDumpfile("simtop.fsdb");
        $fsdbDumpvars;
        $fsdbDumpSVA; // for assertion
   end
            

endmodule
