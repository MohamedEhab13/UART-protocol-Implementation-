`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 02:41:08 AM
// Design Name: 
// Module Name: BaudRate_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


    module BaudRate_generator
    (
      input logic clk , reset , 
      input logic [10:0] divisor ,
      output logic tick 
    );
    
 logic count , next_count ;
 
 always_ff @(posedge clk , posedge reset)
 begin 
     if (reset)  
     count <= 0 ;
     else
     count <= next_count ;
 end   
 
 assign next_count = (count == divisor) ? 1'b0 : count + 1 ;
 assign tick = (count == 1) ;
endmodule
