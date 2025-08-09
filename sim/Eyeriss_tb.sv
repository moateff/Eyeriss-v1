`timescale 1ns / 1ps

import shared_pkg::*;
import file_pkg::*;
import cfg_pkg::*;
import fifo_if_pkg::*;
import load_pkg::*;
import scheduler_pkg::*;
import test_pkg::*;

module eyeriss_tb;
    
    Part_Scheduler #(
        .C_WIDTH(C_WIDTH),
        .M_WIDTH(M_WIDTH),
        .N_WIDTH(N_WIDTH),
        .n_WIDTH(n_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .r_WIDTH(r_WIDTH),
        .t_WIDTH(t_WIDTH)
    ) scheduler_inst (
        .clk(core_clk),
        .reset(reset),
        .start(start_scheduler),
        
        .pass_start(start_noc),
        .pass_ready(1),
        .pass_done(done_noc),
        
        .busy(busy_scheduler),
        .done(done_scheduler),
        .bias_sel(bias_sel),
                    
        .C(C),
        .M(M),
        .N(N),
        .n(n),
        .p(p),
        .q(q),
        .r(r),
        .t(t),
        
        .filter_ids(filter_ids),
        .filter_channel_ids(filter_channel_ids),
        .ifmap_ids(ifmap_ids),
        .ifmap_channel_ids(ifmap_channel_ids),
        .psum_ids(psum_ids),
        .psum_channel_ids(psum_channel_ids)
    ); 
    
    eyeriss #(
        .CHUNK_DEPTH(CHUNK_DEPTH),
    
        .WIIA(WIIA),
        .WIFA(WIFA),
        .WIIB(WIIB),
        .WIFB(WIFB),
        .WOI(WOI),
        .WOF(WOF),
    
        .DATA_WIDTH_IFMAP(DATA_WIDTH_IFMAP),
        .ROW_TAG_WIDTH_IFMAP(ROW_TAG_WIDTH_IFMAP),
        .COL_TAG_WIDTH_IFMAP(COL_TAG_WIDTH_IFMAP),
    
        .DATA_WIDTH_FILTER(DATA_WIDTH_FILTER),
        .ROW_TAG_WIDTH_FILTER(ROW_TAG_WIDTH_FILTER),
        .COL_TAG_WIDTH_FILTER(COL_TAG_WIDTH_FILTER),
    
        .DATA_WIDTH_PSUM(DATA_WIDTH_PSUM),
        .ROW_TAG_WIDTH_PSUM(ROW_TAG_WIDTH_PSUM),
        .COL_TAG_WIDTH_PSUM(COL_TAG_WIDTH_PSUM),
    
        .NUM_OF_ROWS(NUM_OF_ROWS),
        .NUM_OF_COLS(NUM_OF_COLS),
    
        .GIN_DATA_FIFO_DEPTH(GIN_DATA_FIFO_DEPTH),
        .GIN_TAGS_FIFO_DEPTH(GIN_TAGS_FIFO_DEPTH),
    
        .GON_DATA_FIFO_DEPTH(GON_DATA_FIFO_DEPTH),
        .GON_TAGS_FIFO_DEPTH(GON_TAGS_FIFO_DEPTH),
    
        .PE_IFMAP_FIFO_DEPTH(PE_IFMAP_FIFO_DEPTH),
        .PE_FILTER_FIFO_DEPTH(PE_FILTER_FIFO_DEPTH),
        .PE_PSUM_FIFO_DEPTH(PE_PSUM_FIFO_DEPTH),
    
        .IFMAP_SPAD_DEPTH(IFMAP_SPAD_DEPTH),
        .FILTER_SPAD_DEPTH(FILTER_SPAD_DEPTH),
        .PSUM_SPAD_DEPTH(PSUM_SPAD_DEPTH),
    
        .H_WIDTH(H_WIDTH),
        .W_WIDTH(W_WIDTH),
        .R_WIDTH(R_WIDTH),
        .S_WIDTH(S_WIDTH),
        .E_WIDTH(E_WIDTH),
        .F_WIDTH(F_WIDTH),
    
        .C_WIDTH(C_WIDTH),
        .M_WIDTH(M_WIDTH),
        .N_WIDTH(N_WIDTH),
        .U_WIDTH(U_WIDTH),
        .V_WIDTH(V_WIDTH),
    
        .n_WIDTH(n_WIDTH),
        .e_WIDTH(e_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        .r_WIDTH(r_WIDTH),
        .t_WIDTH(t_WIDTH),
    
        .X_WIDTH(X_WIDTH),
    
        .ROW_MAJOR(ROW_MAJOR),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
    
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
    
        .IFMAP_GLB_DEPTH(IFMAP_GLB_DEPTH),
        .FILTER_GLB_DEPTH(FILTER_GLB_DEPTH),
        .PSUM_GLB_DEPTH(PSUM_GLB_DEPTH),
        .BIAS_GLB_DEPTH(BIAS_GLB_DEPTH)
    ) DUT (
        .core_clk(core_clk),
        .link_clk(link_clk),
        .reset(reset),

        .scan_enable(scan_enable),
        .scan_in(scan_in),
        .scan_out(scan_out),

        .enable_noc(enable_noc),
        .enable_lrn(enable_lrn),
        .enable_pad(enable_pad),
        .start_noc(start_noc),
        .start_lrn(start_lrn),
        .start_pad(start_pad),
        .done_noc(done_noc),
        .done_lrn(done_lrn),
        .done_pad(done_pad),
        .bias_sel(bias_sel),
        .lrn_sel(lrn_sel),

        .ifmap_base(ifmap_ids[0]),
        .ifmap_channel_base(ifmap_channel_ids[0]),
        .filter_base(filter_ids[0]),
        .filter_channel_base(filter_channel_ids[0]),
        .ipsum_base(psum_ids[0]),
        .ipsum_channel_base(psum_channel_ids[0]),
        .opsum_base(psum_ids[0]),
        .opsum_channel_base(psum_channel_ids[0]),

        .ifmap_base_addr(ifmap_base_addr),
        .filter_base_addr(filter_base_addr),
        .ipsum_base_addr(ipsum_base_addr),
        .bias_base_addr(bias_base_addr),
        .opsum_base_addr(opsum_base_addr),

        .words_num(words_num),
        .base_addr(base_addr),
        .start_forward(start_forward),
        .transfer_type(transfer_type),
        .re_from_dram(re_from_dram),
        .rdata_from_dram(rdata_from_dram),
        .valid_from_dram(valid_from_dram),

        .start_backward(start_backward),
        .we_to_dram(we_to_dram),
        .wdata_to_dram(wdata_to_dram),
        
        .forward_transfer_done(forward_transfer_done),
        .backward_transfer_done(backward_transfer_done),
        
        .H(H),
        .R(R),
        .E(E),
        .C(C),
        .M(M),
        .N(N),
        .U(U),
        .V(V),
        .n(n),
        .e(e),
        .p(p),
        .q(q),
        .r(r),
        .t(t),
        .X(X)
    );
    
    initial begin
        fork
            forever begin
                #(CORE_CLK_PERIOD / 2.0) core_clk = ~core_clk;
            end

            forever begin
                #(LINK_CLK_PERIOD / 2.0) link_clk = ~link_clk;
            end
        join_none
    end
    
    string filename1, filename2;
    bit [ADDR_WIDTH-1:0] base_addr;
    bit [ADDR_WIDTH-1:0] num_words;
    data_t data_type;
        
    initial begin
//        filename1 = "D:/data/Graduation Project/GP_AlexNet/Results/Conv3/ifmap/conv3_ifmap_16.txt";
//        data_type = IFMAP;
//        base_addr = 0;
//        num_words = 43200;
//        write_data_to_glb(data_type, filename1, base_addr, num_words);
        
        run_test();
        
//        filename1 = "D:/data/Graduation Project/GP_AlexNet/Results/Conv3/ifmap/ouput.txt";
//        data_type = PSUM;
//        base_addr = 0;
//        num_words = 64896;
//        read_data_from_glb(data_type, filename1, base_addr, num_words);
        
        // filename2 = "D:/data/Graduation Project/GP_AlexNet/Results/Conv1/ofmap/lrn1_expected_ofmap.txt";
        // compare_files(filename1, filename2, num_words);
        $stop;
    end
        
    task read_data_from_glb(
        input bit [1:0] glb_name,
        input string filename,
        input bit [ADDR_WIDTH-1:0] base_addr,
        input bit [ADDR_WIDTH-1:0] words_num
    );
        int file;
        logic [DATA_WIDTH-1:0] word;
        bit   [ADDR_WIDTH-1:0] addr;
        
        file = $fopen(filename, "w");
        if (file == 0) begin
            $display("[ERROR] Could not open file %s", filename);
            return;
        end
    
        for (int i = 0; i < words_num; i++) begin
            addr = base_addr + i;
            
            case (glb_name)
                IFMAP: begin
                    case (addr[1:0])
                        2'b00: word = DUT.GLB.U1_IFMAP.U0_0.mem[addr/4];
                        2'b01: word = DUT.GLB.U1_IFMAP.U0_1.mem[addr/4];
                        2'b10: word = DUT.GLB.U1_IFMAP.U1_0.mem[addr/4];
                        2'b11: word = DUT.GLB.U1_IFMAP.U1_1.mem[addr/4];
                    endcase
                end 
                FILTER: begin
                    case (addr[1:0])
                        2'b00: word = DUT.GLB.U2_FILTER.U0_0.mem[addr/4];
                        2'b01: word = DUT.GLB.U2_FILTER.U0_1.mem[addr/4];
                        2'b10: word = DUT.GLB.U2_FILTER.U1_0.mem[addr/4];
                        2'b11: word = DUT.GLB.U2_FILTER.U1_1.mem[addr/4];
                    endcase
                end 
                BIAS: begin
                    case (addr[1:0])
                        2'b00: word = DUT.GLB.U3_BIAS.U0_0.mem[addr/4];
                        2'b01: word = DUT.GLB.U3_BIAS.U0_1.mem[addr/4];
                        2'b10: word = DUT.GLB.U3_BIAS.U1_0.mem[addr/4];
                        2'b11: word = DUT.GLB.U3_BIAS.U1_1.mem[addr/4];
                    endcase
                end 
                PSUM: begin
                    case (addr[1:0])
                        2'b00: word = DUT.GLB.U4_PSUM.U0_0.mem[addr/4];
                        2'b01: word = DUT.GLB.U4_PSUM.U0_1.mem[addr/4];
                        2'b10: word = DUT.GLB.U4_PSUM.U1_0.mem[addr/4];
                        2'b11: word = DUT.GLB.U4_PSUM.U1_1.mem[addr/4];
                    endcase
                end 
            endcase
                
            $fwrite(file, "%b\n", word);
        end
   
        $fclose(file);
    endtask
    
    task write_data_to_glb(
        input bit [1:0] glb_name,
        input string filename,
        input bit [ADDR_WIDTH-1:0] base_addr,
        input bit [ADDR_WIDTH-1:0] words_num
    );
        int file;
        logic [DATA_WIDTH-1:0] word;
        bit   [ADDR_WIDTH-1:0] addr;
    
        file = $fopen(filename, "r");
        if (file == 0) begin
            $display("[ERROR] Could not open file %s", filename);
            return;
        end
    
        for (int i = 0; i < words_num; i++) begin
            addr = base_addr + i;
    
            if ($feof(file)) begin
                $display("[WARNING] Reached EOF before expected word count at line %0d", i);
                break;
            end
    
            void'($fscanf(file, "%b\n", word));
    
            case (glb_name)
                IFMAP: begin
                    case (addr[1:0])
                        2'b00: DUT.GLB.U1_IFMAP.U0_0.mem[addr/4] = word;
                        2'b01: DUT.GLB.U1_IFMAP.U0_1.mem[addr/4] = word;
                        2'b10: DUT.GLB.U1_IFMAP.U1_0.mem[addr/4] = word;
                        2'b11: DUT.GLB.U1_IFMAP.U1_1.mem[addr/4] = word;
                    endcase
                end
                FILTER: begin
                    case (addr[1:0])
                        2'b00: DUT.GLB.U2_FILTER.U0_0.mem[addr/4] = word;
                        2'b01: DUT.GLB.U2_FILTER.U0_1.mem[addr/4] = word;
                        2'b10: DUT.GLB.U2_FILTER.U1_0.mem[addr/4] = word;
                        2'b11: DUT.GLB.U2_FILTER.U1_1.mem[addr/4] = word;
                    endcase
                end
                BIAS: begin
                    case (addr[1:0])
                        2'b00: DUT.GLB.U3_BIAS.U0_0.mem[addr/4] = word;
                        2'b01: DUT.GLB.U3_BIAS.U0_1.mem[addr/4] = word;
                        2'b10: DUT.GLB.U3_BIAS.U1_0.mem[addr/4] = word;
                        2'b11: DUT.GLB.U3_BIAS.U1_1.mem[addr/4] = word;
                    endcase
                end
                PSUM: begin
                    case (addr[1:0])
                        2'b00: DUT.GLB.U4_PSUM.U0_0.mem[addr/4] = word;
                        2'b01: DUT.GLB.U4_PSUM.U0_1.mem[addr/4] = word;
                        2'b10: DUT.GLB.U4_PSUM.U1_0.mem[addr/4] = word;
                        2'b11: DUT.GLB.U4_PSUM.U1_1.mem[addr/4] = word;
                    endcase
                end
            endcase
        end
    
        $fclose(file);
    endtask

endmodule

