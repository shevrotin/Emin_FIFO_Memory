`timescale 1ns / 1ps

module FIFO_tb

    #(parameter MEMORY_WIDTH_TB = 8, MEMORY_DEPTH_TB = 8)();
    
    reg clk_tb = 1, rst_tb, wrEn_tb, rdEn_tb; 
    reg [MEMORY_WIDTH_TB - 1 : 0] inData_tb; 
    wire [MEMORY_WIDTH_TB - 1 : 0] outData_tb;
    wire full_tb, empty_tb;

    FIFO_top
        #(
         .MEMORY_WIDTH(MEMORY_WIDTH_TB),
         .MEMORY_DEPTH(MEMORY_DEPTH_TB)
         ) 
        dut
        (
        .clk(clk_tb),
        .rst(rst_tb), 
        .wrEn(wrEn_tb), 
        .rdEn(rdEn_tb), 
        .full(full_tb),
        .empty(empty_tb),
        .inData(inData_tb), 
        .outData(outData_tb)
        );
    
    initial 
        begin
        rst_tb = 0;
        #40
        rst_tb = 1;
        #40
        inData_tb = 0;
        rdEn_tb   = 0;
        wrEn_tb   = 0;
        #2000     
        rdEn_tb = 0;
        wrEn_tb = 1;
        end

    always #10       clk_tb    = !clk_tb;
    always #20       inData_tb = inData_tb + 1;
    always #10000000 rdEn_tb   = !rdEn_tb;
    always #10000000 wrEn_tb   = !wrEn_tb;
endmodule