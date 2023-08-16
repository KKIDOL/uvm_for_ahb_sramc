interface ahb_if(input logic hclk, input logic hresetn);
    // ahb signal
    logic  [31:0]   		       	haddr;
    logic  [1:0]                      	htrans;
    logic                             	hwrite;
    logic  [2:0]                     		hsize;
    logic  [2:0]                       	hburst;
    logic  [3:0]                       	hprot;
    logic  [31:0]                      	hwdata;
    logic                              	hsel;
    logic  [31:0]		        	hrdata;
    logic                              	hready;
    logic                              	hready_resp;
    logic  [1:0]                       	hresp;
    logic                              	hbusreq;
    logic                              	hlock;
    logic                              	hgrant;
    logic  [3:0]                       	hmaster;
    logic                              	hmastlock;
    logic  [15:0]                      	hsplit;
    // sram signal
    logic                              	sram_clk;
    logic                              	dft_en;
    logic                           	   	bist_en;
    logic                              	bist_done;
    logic  [7:0]                       	bist_fail;


    clocking i_driver_cb@(posedge hclk);
        // default input #1 output #1;
        output      sram_clk;
        output      hsel;
        output      hwrite;
        output      hready;
        output      hsize;
        output      hburst;
        output      htrans;
        output      hwdata;
        output      haddr;
        input       dft_en;
        input       bist_en;
        input       hready_resp;
        input       hresp;
        input       hrdata;
        input       bist_done;
        input       bist_fail;
    endclocking

    clocking i_monitor_cb@(posedge hclk);
        default input #1 output #1;
        input      sram_clk;
        input      hsel;
        input      hwrite;
        input      hready;
        input      hsize;
        input      hburst;
        input      htrans;
        input      hwdata;
        input      haddr;
    endclocking

    clocking o_monitor_cb@(posedge hclk);
        default input #1 output #1;
        input       hready_resp;
        input       hresp;
        input       hrdata;
        input       bist_done;
        input       bist_fail;
    endclocking

    modport i_driver (
        input hclk, hresetn,clocking i_driver_cb
    );

    modport i_monitor(
        input hclk, hresetn, clocking i_monitor_cb
    );

    modport o_monitor (
    input hclk, hresetn, clocking o_monitor_cb
    );

    
endinterface //ahb_if
