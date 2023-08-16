//============================================================================
//  FileName    : ahb_slave_if.v                                              
//  Function    : AMBA 2.0 AHB Slave interface                                
//                Connect the sram controller into AHB bus and generate           
//                sram control signals: sram address, rd/wr operation and chip   
//                select signals etc.                                         
//  Author      : zhaoql                                                      
//  Date        : 2010-8-4                                                    
//  Version     : 0.1                                                         
//----------------------------------------------------------------------------
//  Version     : 1.0                                                         
//  Date        : 2010-8-24                                                   
//  Description : added "default case" in case(haddr_sel) list.               
//----------------------------------------------------------------------------
//  Version     : 1.1                                                         
//  Date        : 2010-9-30                                                   
//  Description : Added function which clear all the AHB control registers     
//                hsel actives low.                                           
//----------------------------------------------------------------------------
//  Version     : 1.2                                                         
//  Date        : 2010-10-14                                                  
//  Description : Modified hready in signals which "and" with sram control     
//                signals.                                                    
//============================================================================

module ahb_slave_if(

  //input signals
  input			   hclk,
  input			   hresetn,
  input			   hsel,
  input			   hwrite,
  input			   hready,
  input	[2:0]	 hsize,
  input [1:0]	 htrans,
  input [2:0]  hburst,   // hard code -> parameter
  input [31:0] hwdata,
  input [31:0] haddr,
  
  //output signals
  output		  	hready_resp,
  output [1:0]	hresp,
  output [31:0]	hrdata,
  
  //sram output
  input [7:0]	 sram_q0, // 8bits
  input [7:0]	 sram_q1,
  input [7:0]	 sram_q2,
  input [7:0]	 sram_q3,
  input [7:0]	 sram_q4,
  input [7:0]	 sram_q5,
  input [7:0]	 sram_q6,
  input [7:0]	 sram_q7,
  
  
  output		   	sram_w_en,      // 0:write, 1:read
  output [12:0]	sram_addr_out,
  output [31:0] sram_wdata,     //写sram数据
  output [3:0]	bank0_csn,      //四字节可以单独写入
  output [3:0]	bank1_csn
  );

  //-------------------------------------------------------
  //internal registers used for temp the input ahb signals
  //-------------------------------------------------------
  //temperate all the AHB input signals
  reg        hwrite_r;
  reg [2:0]  hsize_r ;    
  reg [2:0]  hburst_r;
  reg [1:0]  htrans_r;
  reg [31:0] haddr_r;

  reg [3:0]  sram_csn; 
  
  //------------------------------------------------------
  //Internal signals
  //------------------------------------------------------
  //"haddr_sel " and "hsize_sel" used to generate banks of
  //sram: "bank0_sel" and "bank1_sel".
  wire [1:0] haddr_sel;
  wire [1:0] hsize_sel;
  wire bank_sel;

  wire sram_csn_en;          //sram chip select enable

  wire sram_write;           //sram write enable signal from AHB bus
  wire sram_read;            //sram read enable signal from AHB bus
  wire [15:0] sram_addr;     //sram address from AHB bus
  wire [31:0] sram_data_out; //data read from sram and send to AHB bus

  parameter     IDLE   = 2'b00,
                BUSY   = 2'b01,
		            NONSEQ = 2'b10,
		            SEQ    = 2'b11;

  //---------------------------------------------------------
  //  Combinatorial portion
  //---------------------------------------------------------

  //assign the response and read data of the ahb slave 
  //In order to implement the sram function-writing or reading
  //in one cycle, the value of hready_resp is always "1". 
  assign hready_resp = 1'b1; // Singal Cycle
  assign hresp  = 2'b00;     // OK
  
  //---------------------------------------------------------
  //sram data output to AHB bus
  //---------------------------------------------------------
  assign   hrdata = sram_data_out; //组合逻辑读，CPU读SRAM，地址有效则立即读

  //Choose the right data output of the two banks(bank0, bank1) according
  //to the value of bank_sel. If bank_sel = 1'b1, bank0 sleceted, or 
  //bank1 selected.
  assign  sram_data_out = (bank_sel) ?  
                          {sram_q3, sram_q2, sram_q1, sram_q0} :
                          {sram_q7, sram_q6, sram_q5, sram_q4} ;

  //Generate sram write and read enable signals.
  assign sram_write = ((htrans_r == NONSEQ) || (htrans_r == SEQ)) && hwrite_r;
  assign sram_read =  ((htrans_r == NONSEQ) || (htrans_r == SEQ)) && (!hwrite_r);
  assign sram_w_en = !sram_write;

  //generate sram address
  //SRAM总寻址64K 0x0--0xffff
  assign sram_addr = haddr_r [15:0];//64K 8*8K
  assign sram_addr_out = sram_addr[14:2];
  
  //Generate bank select signals by the value of sram_addr[15].
  //Each bank(32kx32) comprises of four sram block(8kx8), and
  //the width of the address of the bank is 15 bits(14~0), so 
  //the sram_addr[15] is the minimun of the next bank. If its 
  //value is "1", it means the next bank is selcted. 
  assign sram_csn_en = (sram_write || sram_read);
  //低32K bank0 高32K bank1
  assign bank_sel  = (sram_csn_en && (sram_addr[15] == 1'b0)) ? 1'b1 : 1'b0;
  assign bank0_csn = (sram_csn_en && (sram_addr[15] == 1'b0)) ? sram_csn : 4'b1111;
  assign bank1_csn = (sram_csn_en && (sram_addr[15] == 1'b1)) ? sram_csn : 4'b1111;

  //signals used to generating sram chip select signal in one bank.
  assign haddr_sel = sram_addr[1:0];
  assign hsize_sel = hsize_r [1:0];

  //-------------------------------------------------------
  //data from ahb writing into sram
  //-------------------------------------------------------
  assign sram_wdata = hwdata;
  
  //-------------------------------------------------------
  //Generate the sram chip selecting signals in one bank.
  //The resluts show the AHB bus write or read how many data
  //once a time: byte, halfword or word.
  //---------------------------------------------------------
  always@(hsize_sel or haddr_sel) begin
    if(hsize_sel == 2'b10)//32bit
      sram_csn = 4'b0;
    else if(hsize_sel == 2'b01) begin//16bit
      if(haddr_sel[1] == 1'b0) //little-endian
        sram_csn = 4'b1100;
      else
        sram_csn = 4'b0011;
    end
    else if(hsize_sel == 2'b00) begin//8bit
      case(haddr_sel)
        2'b00 : sram_csn = 4'b1110;
        2'b01 : sram_csn = 4'b1101;
        2'b10 : sram_csn = 4'b1011;
        2'b11 : sram_csn = 4'b0111;
        default : sram_csn = 4'b1111;
      endcase
    end
    else
      sram_csn = 4'b1111;
  end

  //--------------------------------------------------------
  //  Sequential portion
  //--------------------------------------------------------

  //tmp the ahb address and control signals
  always@(posedge hclk , negedge hresetn) begin
    if(!hresetn) begin
      hwrite_r  <= 1'b0  ;
      hsize_r   <= 3'b0  ;  
      hburst_r  <= 3'b0  ;
      htrans_r  <= 2'b0  ;
      haddr_r   <= 32'b0 ;
    end
    else if(hsel && hready) begin //hsel要片选，否则信号一直在翻转，可能会功能错误，并且功耗大
      hwrite_r  <= hwrite ;//写SRAM时，把控制信号寄存。因为写操作时，要把地址打一拍，和数据对齐
      hsize_r   <= hsize  ;  
 //   hburst_r  <= hburst ;//AHB中master会把burst传输所有地址传递过来，AXI只传递起始地址。此处用处不大。减少一个REG
      htrans_r  <= htrans ;
      haddr_r   <= haddr  ;
    end else begin
      hwrite_r  <= 1'b0  ;
      hsize_r   <= 3'b0  ;  
      hburst_r  <= 3'b0  ;
      htrans_r  <= 2'b0  ;
      haddr_r   <= 32'b0 ;
    end
  end

endmodule
