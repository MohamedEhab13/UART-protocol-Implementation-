`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2023 06:00:47 PM
// Design Name: 
// Module Name: ram
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


module ram #(parameter addr_width = 3 , data_width = 8)
    (
       input logic clk ,
       input logic wr_en ,
       input logic [addr_width-1 : 0] wr_addr,
       input logic [data_width-1 : 0] wr_data,
       input logic [addr_width-1 : 0] rd_addr,
       output logic [data_width-1 : 0] rd_data
    );
    
 logic [data_width-1 : 0] memory [0 : 2**addr_width - 1] ;
 
 always_ff @(posedge clk)
       begin
        if (wr_en)
        memory [wr_addr] = wr_data ;
       end   
   
 assign rd_data = memory[rd_addr] ;
    
                 
endmodule
