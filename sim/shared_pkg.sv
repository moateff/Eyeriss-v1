package shared_pkg;
    
    int error_count;
    int pass_count;
        
    typedef enum bit [1:0] {
        IFMAP  = 2'b00, 
        FILTER = 2'b01, 
        BIAS   = 2'b10,
        PSUM   = 2'b11
    } data_t;
    
    typedef enum bit {
        CONV = 1'b0, 
        MAX  = 1'b1
    } layer_t;
    
    // CONV1 Mapping Parameters
    layer_t CONV1_X = CONV;
    
    localparam CONV1_H = 227;
    localparam CONV1_W = 227;
    localparam CONV1_D = 35;
    localparam CONV1_R = 11;
    localparam CONV1_S = 11;
    localparam CONV1_E = 55;
    localparam CONV1_F = 55;

    localparam CONV1_C = 3;
    localparam CONV1_M = 64;
    localparam CONV1_N = 1;
    localparam CONV1_U = 4;
    localparam CONV1_V = 0; 
    
    localparam CONV1_n = 1;
    localparam CONV1_e = 7;
    localparam CONV1_p = 16;
    localparam CONV1_q = 1;
    localparam CONV1_r = 1;
    localparam CONV1_t = 2;
    
    // CONV2 Mapping Parameters
    layer_t CONV2_X = CONV;
    
    localparam CONV2_H = 31;
    localparam CONV2_W = 31;
    localparam CONV2_R = 5;
    localparam CONV2_S = 5;
    localparam CONV2_E = 27;
    localparam CONV2_F = 27;

    localparam CONV2_C = 64;
    localparam CONV2_M = 192;
    localparam CONV2_N = 1;
    localparam CONV2_U = 1;
    localparam CONV2_V = 0; 
    
    localparam CONV2_n = 1;
    localparam CONV2_e = 27;
    localparam CONV2_p = 16;
    localparam CONV2_q = 2;
    localparam CONV2_r = 1;
    localparam CONV2_t = 1;
    
    // CONV3 Mapping Parameters
    layer_t CONV3_X = CONV;
    
    localparam CONV3_H = 15;
    localparam CONV3_W = 15;
    localparam CONV3_R = 3;
    localparam CONV3_S = 3;
    localparam CONV3_E = 13;
    localparam CONV3_F = 13;

    localparam CONV3_C = 192;
    localparam CONV3_M = 384;
    localparam CONV3_N = 1;
    localparam CONV3_U = 1;
    localparam CONV3_V = 1; 
    
    localparam CONV3_n = 1;
    localparam CONV3_e = 13;
    localparam CONV3_p = 16;
    localparam CONV3_q = 4;
    localparam CONV3_r = 1;
    localparam CONV3_t = 4;
    
    // CONV4 Mapping Parameters
    layer_t CONV4_X = CONV;

    localparam CONV4_H = 15;
    localparam CONV4_W = 15;
    localparam CONV4_R = 3;
    localparam CONV4_S = 3;
    localparam CONV4_E = 13;
    localparam CONV4_F = 13;

    localparam CONV4_C = 384;
    localparam CONV4_M = 256;
    localparam CONV4_N = 1;
    localparam CONV4_U = 1;
    localparam CONV4_V = 1; 
    
    localparam CONV4_n = 1;
    localparam CONV4_e = 13;
    localparam CONV4_p = 16;
    localparam CONV4_q = 3;
    localparam CONV4_r = 2;
    localparam CONV4_t = 2;
    
    // CONV5 Mapping Parameters
    layer_t CONV5_X = CONV;
    
    localparam CONV5_H = 15;
    localparam CONV5_W = 15;
    localparam CONV5_R = 3;
    localparam CONV5_S = 3;
    localparam CONV5_E = 13;
    localparam CONV5_F = 13;

    localparam CONV5_C = 256;
    localparam CONV5_M = 256;
    localparam CONV5_N = 1;
    localparam CONV5_U = 1;
    localparam CONV5_V = 0; 
    
    localparam CONV5_n = 1;
    localparam CONV5_e = 13;
    localparam CONV5_p = 16;
    localparam CONV5_q = 3;
    localparam CONV5_r = 2;
    localparam CONV5_t = 2;

    // MAX1 Mapping Parameters
    layer_t MAX1_X = MAX;
    
    localparam MAX1_H = 55;
    localparam MAX1_W = 55;
    localparam MAX1_R = 3;
    localparam MAX1_S = 3;
    localparam MAX1_E = 27;
    localparam MAX1_F = 27;

    localparam MAX1_C = 64;
    localparam MAX1_M = 1;
    localparam MAX1_N = 1;
    localparam MAX1_U = 2;
    localparam MAX1_V = 2; 
    
    localparam MAX1_n = 1;
    localparam MAX1_e = 27;
    localparam MAX1_p = 1;
    localparam MAX1_q = 1;
    localparam MAX1_r = 1;
    localparam MAX1_t = 1;
    
    // MAX2 Mapping Parameters
    layer_t MAX2_X = MAX;
    
    localparam MAX2_H = 27;
    localparam MAX2_W = 27;
    localparam MAX2_R = 3;
    localparam MAX2_S = 3;
    localparam MAX2_E = 13;
    localparam MAX2_F = 13;

    localparam MAX2_C = 192;
    localparam MAX2_M = 1;
    localparam MAX2_N = 1;
    localparam MAX2_U = 2;
    localparam MAX2_V = 1; 
    
    localparam MAX2_n = 1;
    localparam MAX2_e = 13;
    localparam MAX2_p = 1;
    localparam MAX2_q = 1;
    localparam MAX2_r = 1;
    localparam MAX2_t = 1;
    
    // MAX3 Mapping Parameters
    layer_t MAX3_X = MAX;
    
    localparam MAX3_H = 13;
    localparam MAX3_W = 13;
    localparam MAX3_R = 3;
    localparam MAX3_S = 3;
    localparam MAX3_E = 6;
    localparam MAX3_F = 6;

    localparam MAX3_C = 192;
    localparam MAX3_M = 1;
    localparam MAX3_N = 1;
    localparam MAX3_U = 2;
    localparam MAX3_V = 0; 
    
    localparam MAX3_n = 1;
    localparam MAX3_e = 6;
    localparam MAX3_p = 1;
    localparam MAX3_q = 1;
    localparam MAX3_r = 1;
    localparam MAX3_t = 1;
               
    // Integer Parameters
    parameter CORE_CLK_PERIOD = 5;            
    parameter LINK_CLK_PERIOD = 11.1111111;      

    parameter CHUNK_DEPTH = 384;
    parameter WIIA = 3; 
    parameter WIFA = 13; 
    parameter WIIB = 3;  
    parameter WIFB = 13;  
    parameter WOI  = 3; 
    parameter WOF  = 13;   
    
    parameter DATA_WIDTH_IFMAP     = 16; 
    parameter ROW_TAG_WIDTH_IFMAP  = 4;
    parameter COL_TAG_WIDTH_IFMAP  = 5;
    
    parameter DATA_WIDTH_FILTER    = 64; 
    parameter ROW_TAG_WIDTH_FILTER = 4;
    parameter COL_TAG_WIDTH_FILTER = 4;
    
    parameter DATA_WIDTH_PSUM      = 64; 
    parameter ROW_TAG_WIDTH_PSUM   = 4;
    parameter COL_TAG_WIDTH_PSUM   = 4;
    
    parameter NUM_OF_ROWS = 12;
    parameter NUM_OF_COLS = 14;

    parameter GIN_DATA_FIFO_DEPTH = 16;
    parameter GIN_TAGS_FIFO_DEPTH = 16;

    parameter GON_DATA_FIFO_DEPTH = 16;
    parameter GON_TAGS_FIFO_DEPTH = 16;
    
    parameter PE_IFMAP_FIFO_DEPTH  = 16;
    parameter PE_FILTER_FIFO_DEPTH = 16;
    parameter PE_PSUM_FIFO_DEPTH   = 32;
    
    parameter IFMAP_SPAD_DEPTH  = 12;
    parameter FILTER_SPAD_DEPTH = 224;
    parameter PSUM_SPAD_DEPTH   = 24;
    
    parameter H_WIDTH = 8;
    parameter W_WIDTH = 8;
    parameter R_WIDTH = 4;
    parameter S_WIDTH = 4;
    parameter E_WIDTH = 6;
    parameter F_WIDTH = 6;

    parameter C_WIDTH = 10;
    parameter M_WIDTH = 10;
    parameter N_WIDTH = 3;
    parameter U_WIDTH = 3;
    parameter V_WIDTH = 2; 
    
    parameter n_WIDTH = 3;
    parameter e_WIDTH = 6;
    parameter p_WIDTH = 5;
    parameter q_WIDTH = 3;
    parameter r_WIDTH = 2;
    parameter t_WIDTH = 3;

    parameter X_WIDTH = 1; 

    parameter ROW_MAJOR  = 1;
    parameter ADDR_WIDTH = 20;
    parameter DATA_WIDTH = 16;

    // parameters for Interface unit 
    parameter FIFO_WIDTH = 64;
    parameter FIFO_DEPTH = 16;

    //parameters for GLB's 
    parameter IFMAP_GLB_DEPTH  = 154587;
    parameter FILTER_GLB_DEPTH = 884736;
    parameter PSUM_GLB_DEPTH   = 193600;
    parameter BIAS_GLB_DEPTH   = 384;

    // Logic Signals
    logic core_clk;
    logic link_clk;
    logic reset;

    logic scan_enable;
    logic scan_in;
    logic scan_out;

    logic enable_noc;
    logic enable_lrn;
    logic enable_pad;

    logic start_noc;
    logic start_lrn;
    logic start_pad;

    logic done_noc;
    logic done_lrn;
    logic done_pad;

    logic bias_sel;
    logic lrn_sel;

    logic [N_WIDTH-1:0] ifmap_base;
    logic [C_WIDTH-1:0] ifmap_channel_base;
    logic [M_WIDTH-1:0] filter_base;
    logic [C_WIDTH-1:0] filter_channel_base;
    logic [N_WIDTH-1:0] ipsum_base;
    logic [M_WIDTH-1:0] ipsum_channel_base;
    logic [N_WIDTH-1:0] opsum_base;
    logic [M_WIDTH-1:0] opsum_channel_base;

    logic [ADDR_WIDTH-1:0] ifmap_base_addr;
    logic [ADDR_WIDTH-1:0] filter_base_addr;
    logic [ADDR_WIDTH-1:0] ipsum_base_addr;
    logic [ADDR_WIDTH-1:0] bias_base_addr;
    logic [ADDR_WIDTH-1:0] opsum_base_addr;

    logic [ADDR_WIDTH-1:0] words_num;
    logic [ADDR_WIDTH-1:0] base_addr;

    logic [1:0] transfer_type;
    
    logic                  start_forward;
    logic                  re_from_dram;
    logic [FIFO_WIDTH-1:0] rdata_from_dram;
    logic                  valid_from_dram;

    logic                  start_backward;
    logic                  we_to_dram;
    logic [FIFO_WIDTH-1:0] wdata_to_dram;

    logic forward_transfer_done;
    logic backward_transfer_done;
    
    logic  [H_WIDTH - 1:0] H;
    logic  [R_WIDTH - 1:0] R;
    logic  [E_WIDTH - 1:0] E;
    logic  [C_WIDTH - 1:0] C;
    logic  [M_WIDTH - 1:0] M;
    logic  [N_WIDTH - 1:0] N;
    logic  [U_WIDTH - 1:0] U;
    logic  [V_WIDTH - 1:0] V;
    logic  [n_WIDTH - 1:0] n;
    logic  [e_WIDTH - 1:0] e;
    logic  [p_WIDTH - 1:0] p;
    logic  [q_WIDTH - 1:0] q;
    logic  [r_WIDTH - 1:0] r;
    logic  [t_WIDTH - 1:0] t;
    logic  [X_WIDTH - 1:0] X;
    
    // Scheduler Signals
    logic start_scheduler;
    logic busy_scheduler;
    logic done_scheduler;
    logic pass_ready;
    
    logic [M_WIDTH - 1:0] filter_ids [0:1];
    logic [C_WIDTH - 1:0] filter_channel_ids [0:1];
    logic [N_WIDTH - 1:0] ifmap_ids [0:1]; 
    logic [C_WIDTH - 1:0] ifmap_channel_ids [0:1]; 
    logic [N_WIDTH - 1:0] psum_ids [0:1];
    logic [M_WIDTH - 1:0] psum_channel_ids [0:1];
            
    task initialize_dut();
        begin
            // Clock & reset
            core_clk = 0;
            link_clk = 0;
            reset    = 0;

            // Scan chain
            scan_enable = 0;
            scan_in     = 0;

            // Control signals
            enable_noc = 0;
            enable_lrn = 0;
            enable_pad = 0;
            // start_noc  = 0;
            start_lrn  = 0;
            start_pad  = 0;

            // Access control
            // bias_sel = 0;
            lrn_sel  = 0;

            // Processing unit config
            ifmap_base          = '0;
            ifmap_channel_base  = '0;
            filter_base         = '0;
            filter_channel_base = '0;
            ipsum_base          = '0;
            ipsum_channel_base  = '0;
            opsum_base          = '0;
            opsum_channel_base  = '0;

            ifmap_base_addr  = '0;
            filter_base_addr = '0;
            ipsum_base_addr  = '0;
            bias_base_addr   = '0;
            opsum_base_addr  = '0;

            // FIFO/memory related
            words_num = '0;
            base_addr = '0;

            start_forward   = 0;
            start_backward  = 0;
            transfer_type   = '0;
            rdata_from_dram = '0;
            valid_from_dram = 0;
        end
    endtask

    task wait_core_cycle(
        input int num_cycle
    );
        repeat(num_cycle) @(posedge core_clk);
    endtask
    
    task wait_link_cycle(
        input int num_cycle
    );
        repeat(num_cycle) @(posedge link_clk);
    endtask
    
    task assert_reset();
        begin
            shared_pkg::reset = 1;
            wait_core_cycle(1);
            shared_pkg::reset = 0;
        end
    endtask
        
endpackage : shared_pkg
