package scheduler_pkg;
import shared_pkg::*;

    task initialize_scheduler();
        start_scheduler = 0;
    	pass_ready = 1;
    endtask

    task scheduler();
        wait_core_cycle(1);
        start_scheduler = 1;
        wait_core_cycle(1);
        start_scheduler = 0;
    endtask

endpackage : scheduler_pkg
