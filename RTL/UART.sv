`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 04:15:14 PM
// Design Name: 
// Module Name: UART
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


module UART #(parameter nBit = 8 ,
              SB_tic = 16 ,
              fifo_addr_wdth = 3            
             )  
    (
     input  logic clk , reset ,
     input  logic rx_data , wr_uart , rd_uart ,
     input  logic [7:0] wr_data ,
     input  logic [10:0] divisor , 
     output logic tx_data , tx_full , rx_empty ,
     output logic [7:0] rd_data 
    );
    
 // internal signals 
 logic tic , tx_done , rx_done ;
 logic [7:0] tx_fifo_data , dout ;
 logic tx_fifo_NOT_empty , tx_empty ;
  
    
 BaudRate_generator uart_baud_rate (.* , .tick(tic)) ;
 
 transmitter #(.nBit(nBit) , .SB_tic(SB_tic)) uart_tx 
 (.* , .din(tx_fifo_data) , .tx_start(tx_fifo_NOT_empty)) ;
 
 receiver #(.nBit(nBit) , .SB_tic(SB_tic)) uart_rx (.*) ;
 
 fifo #(.addr_width(fifo_addr_wdth) , .data_width(nBit)) tx_fifo 
 (.* , .wr(wr_uart) , .rd(tx_done) , .full(tx_full) , .empty(tx_empty) , .wr_data(wr_data) , .rd_data(tx_fifo_data)) ;
 
 fifo #(.addr_width(fifo_addr_wdth) , .data_width(nBit)) rx_fifo 
  (.* , .wr(rx_done) , .rd(rd_uart) , .full() , .empty(rx_empty) , .wr_data(dout) , .rd_data(rd_data)) ;
 
 assign tx_fifo_NOT_empty = ~tx_empty ;
 
endmodule
