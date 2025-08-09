package layer_pkg;
import shared_pkg::*;
import cfg_pkg::*;
import load_pkg::*;
import scheduler_pkg::*;
import lrn_pkg::*;
    
    task run_layer1();
        conv1_cfg();
        // run_conv1();
        run_lrn();
    endtask
    
    task run_layer2();
        max1_cfg();
        run_max();
        // run_pad();
    endtask
    
    task run_layer3();
        conv2_cfg();
        // run_conv2();
        run_lrn();
    endtask
    
    task run_layer4();
        max2_cfg();
        run_max();
        // run_pad();
    endtask
    
    task run_layer5();
        conv3_cfg();
        // run_conv3();
        run_lrn();
    endtask
    
    task run_layer6();
        conv4_cfg();
        // run_conv4();
        run_lrn();
    endtask
    
    task run_layer7();
        conv5_cfg();
        // run_conv5();
        run_lrn();
    endtask
    
    task run_layer8();
        max3_cfg();
        run_max();
        // run_pad();
    endtask
        
    task run_conv1();
        enable_array();
        
        conv1_load_data_seg1();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 385;
        shared_pkg::opsum_base_addr = 385;
        conv1_load_data_seg2();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 770;
        shared_pkg::opsum_base_addr = 770;
        conv1_load_data_seg3();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 1155;
        shared_pkg::opsum_base_addr = 1155;
        conv1_load_data_seg4();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 1540;
        shared_pkg::opsum_base_addr = 1540; 
        conv1_load_data_seg5();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 1925;
        shared_pkg::opsum_base_addr = 1925;
        conv1_load_data_seg6();
        scheduler();
        wait(shared_pkg::done_scheduler); 
        
        shared_pkg::ipsum_base_addr = 2310;
        shared_pkg::opsum_base_addr = 2310;
        conv1_load_data_seg7();
        scheduler();
        wait(shared_pkg::done_scheduler);
        
        shared_pkg::ipsum_base_addr = 2695;
        shared_pkg::opsum_base_addr = 2695;
        conv1_load_data_seg8();
        scheduler();
        wait(shared_pkg::done_scheduler);       
        disable_array();        
    endtask 
    
    task run_conv2();
        enable_array();
        conv2_load_data();
        scheduler();
        wait(shared_pkg::done_scheduler);
        disable_array();        
    endtask 
    
    task run_conv3();
        enable_array();
        conv3_load_data();
        scheduler();
        wait(shared_pkg::done_scheduler);
        disable_array();        
    endtask
    
    task run_conv4();
        enable_array();
        conv4_load_data();
        scheduler();
        wait(shared_pkg::done_scheduler);
        disable_array();        
    endtask

    task run_conv5();
        enable_array();
        conv5_load_data();
        scheduler();
        wait(shared_pkg::done_scheduler);
        disable_array();        
    endtask
            
    task run_max();
        enable_array();
        scheduler();
        wait(shared_pkg::done_scheduler);
        disable_array();        
    endtask 
        
    task enable_array();
        wait_core_cycle(1);
        shared_pkg::enable_noc = 1'b1;
        shared_pkg::enable_lrn = 1'b0;
        shared_pkg::enable_pad = 1'b0;
    endtask
    
    task disable_array();
        wait_core_cycle(1);
        shared_pkg::enable_noc = 1'b0;
        shared_pkg::enable_lrn = 1'b0;
        shared_pkg::enable_pad = 1'b0;
    endtask
    
    task enable_padding();
        wait_core_cycle(1);
        enable_noc = 1'b0;
        enable_lrn = 1'b0;
        enable_pad = 1'b1;
    endtask  
    
endpackage : layer_pkg
