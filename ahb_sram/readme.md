------------------------------------------------------------------
Name                       Type                        Size  Value
------------------------------------------------------------------
uvm_test_top               my_test                     -     @342 
  env                      sram_env                    -     @355 
    i_agt                  i_agent                     -     @368 
      drv                  i_driver                    -     @582 
        rsp_port           uvm_analysis_port           -     @601 
        seq_item_port      uvm_seq_item_pull_port      -     @591 
      i_mon                i_monitor                   -     @748 
        ap                 uvm_analysis_port           -     @758 
      sqr                  uvm_sequencer               -     @611 
        rsp_export         uvm_analysis_export         -     @620 
        seq_item_export    uvm_seq_item_pull_imp       -     @738 
        arbitration_queue  array                       0     -    
        lock_queue         array                       0     -    
        num_last_reqs      integral                    32    'd1  
        num_last_rsps      integral                    32    'd1  
    imon2model_fifo        uvm_tlm_analysis_fifo #(T)  -     @404 
      analysis_export      uvm_analysis_imp            -     @453 
      get_ap               uvm_analysis_port           -     @443 
      get_peek_export      uvm_get_peek_imp            -     @423 
      put_ap               uvm_analysis_port           -     @433 
      put_export           uvm_put_imp                 -     @413 
    model                  ref_model                   -     @395 
      ipkt_port            uvm_blocking_get_port       -     @774 
      opkt_ap              uvm_analysis_port           -     @784 
    model2scb_fifo         uvm_tlm_analysis_fifo #(T)  -     @463 
      analysis_export      uvm_analysis_imp            -     @512 
      get_ap               uvm_analysis_port           -     @502 
      get_peek_export      uvm_get_peek_imp            -     @482 
      put_ap               uvm_analysis_port           -     @492 
      put_export           uvm_put_imp                 -     @472 
    o_agt                  o_agent                     -     @377 
      o_mon                o_monitor                   -     @795 
        ap                 uvm_analysis_port           -     @804 
    omon2scb_fifo          uvm_tlm_analysis_fifo #(T)  -     @522 
      analysis_export      uvm_analysis_imp            -     @571 
      get_ap               uvm_analysis_port           -     @561 
      get_peek_export      uvm_get_peek_imp            -     @541 
      put_ap               uvm_analysis_port           -     @551 
      put_export           uvm_put_imp                 -     @531 
    scb                    scoreboard                  -     @386 
      act_port             uvm_blocking_get_port       -     @825 
      exp_port             uvm_blocking_get_port       -     @815 
------------------------------------------------------------------
------------------------------------------------------------------

