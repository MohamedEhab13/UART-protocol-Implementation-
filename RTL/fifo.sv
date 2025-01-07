`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2023 07:13:44 PM
// Design Name: 
// Module Name: fifo
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


module fifo #(parameter addr_width = 3 , data_width = 8)
    (
       input logic clk , reset ,
       input logic wr , rd ,
       output logic full , empty , 
       input logic [data_width-1 : 0] wr_data,
       output logic [data_width-1 : 0] rd_data
    );
    
 logic [data_width-1 : 0] wr_addr ;
 logic [data_width-1 : 0] rd_addr ;
 
 ram #(.addr_width(addr_width) , .data_width(data_width))
 ram_unit (.wr_en(wr & ~full) , .*);
 
 control #(.addr_width (addr_width))
 control_unit (.*);
 
 

       
    
endmodule
