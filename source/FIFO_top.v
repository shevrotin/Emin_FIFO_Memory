`timescale 1ns / 1ps

module FIFO_top
    #(parameter MEMORY_WIDTH = 8, MEMORY_DEPTH = 8, POINTER_WIDTH = $clog2(MEMORY_DEPTH) )     // parameterized memory width and memory depth 
                                                                                               // pointer width is deciced according to memory depth
    (
    input clk, rst, wrEn, rdEn,
    input [MEMORY_WIDTH - 1:0] inData,
    
    output reg [MEMORY_WIDTH - 1:0] outData,
    output full, empty
    );
      
    reg [MEMORY_WIDTH - 1  : 0] mem [0:MEMORY_DEPTH - 1];                                      // FIFO memory
    reg [POINTER_WIDTH - 1 : 0] wrPtr, rdPtr;                                                  // read - write pointers
    reg [POINTER_WIDTH     : 0] fifoCounter;
    
    wire dbWrEn, dbRdEn;

    debouncer i_One (.dbClk(clk), .dbRst(rst), .dbButtonIn(wrEn),.dbButtonOut(dbWrEn));        // debouncer instantiations
    debouncer i_Two (.dbClk(clk), .dbRst(rst), .dbButtonIn(rdEn),.dbButtonOut(dbRdEn));

    assign empty = (fifoCounter == 0           );                                              // empty signal
    assign full  = (fifoCounter == MEMORY_DEPTH);                                              // full signal
     
    always@(posedge clk or negedge rst)
        begin
        if(!rst)           
            begin
            fifoCounter <= 0;
            end     
        else if( dbWrEn && !full )                      
            begin
            fifoCounter <= fifoCounter + 1;
            end
        else if( dbRdEn && !empty )                    
            begin
            fifoCounter <= fifoCounter - 1;
            end    
        end
   
    always@(posedge clk or negedge rst )                            // write - read
        begin
        if(!rst)               
            begin
            wrPtr <= 0; 
            rdPtr <= 0;                                            
             outData <= 0;
            end
        else
            begin
            if(dbWrEn && !full)                                     //  if(wrEn && !full)                                   
                begin                                                                   
                mem[wrPtr] <= inData;
                wrPtr <= wrPtr + 1;
                end
            if(dbRdEn && !empty)                                    //  if(rdEn && !empty)                                        
                begin
                outData <= mem[rdPtr];
                rdPtr <= rdPtr + 1;
                end
            end
        end    
endmodule
    

    