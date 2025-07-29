package test_pkg;
import shared_pkg::*;
import scheduler_pkg::*;
import layer_pkg::*;
    
    task run_test();
        initialize_dut();
        initialize_scheduler();
        
        wait_core_cycle(1);
        assert_reset();
        
//        wait_core_cycle(1);
//        run_layer1();
        
//        wait_core_cycle(1);
//        run_layer2();
        
//        wait_core_cycle(1);
//        run_layer3();
        
//        wait_core_cycle(1);
//        run_layer4();
        
        wait_core_cycle(1);
        run_layer5();
        
//        wait_core_cycle(1);
//        run_layer6();
        
//        wait_core_cycle(1);
//        run_layer7();
        
//        wait_core_cycle(1);
//        run_layer8();
    endtask 
    
endpackage
