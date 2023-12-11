`timescale 1ns / 1ps

module debouncer                                       // Debouncer Module
    (
    input dbButtonIn,
    input dbClk, dbRst,
    output reg dbButtonOut
    );
    
    reg [3:0] shift;
    reg [1:0] state;
    wire sum;
    reg clock;
    integer clockCounter;  
    
    always@(posedge dbClk or negedge dbRst)            // Debouncer clock = 1000Hz
        begin
        if(!dbRst)   
            begin
            clockCounter <= 0;                              
            clock <= 0;
            end 
        else
            begin 
            if(clockCounter >= 24999)                  //  For 1000Hz clock ---> clockCounter ---> 24999
                begin                                       
                clockCounter <= 0;                          
                clock <= !clock;
                end
            else
                begin
                clockCounter <= clockCounter + 1;
                clock <= clock;
                end 
            end
        end
        
    always@(posedge clock)
        begin
        shift[3] <= dbButtonIn;
        shift[2:0] <= shift [3:1];
        end 
    
    assign sum = &shift;
    
    always@(posedge dbClk, negedge dbRst)              // FSM - Finite State Machine
        begin
        if(!dbRst)
            begin
            state <= 2'b00;
            end
        else if(state == 2'b00 && sum)
            begin
            state <= 2'b01;
            end
        else if(state == 2'b01)
            begin
            state <= 2'b10;
            end
        else if(state == 2'b10 && !sum)
            begin
            state <= 2'b00;
            end
        end
    
    always@(posedge dbClk or negedge dbRst)            // State Outputs
        begin
        case(state)
            2'b00:
                begin
                dbButtonOut <= 0;
                end
            2'b01: 
                begin
                dbButtonOut <= 1;
                end
            2'b10: 
                begin
                dbButtonOut <= 0;
                end
            default:
                begin 
                dbButtonOut <= 0; 
                end   
        endcase
        end
endmodule