`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 05:54:30 PM
// Design Name: 
// Module Name: receiver
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


module receiver #(parameter 
                  nBit = 8 ,   // number of data bits
                  SB_tic = 16  // number of ticks for stop bit 
                 )          
    (
     input  logic clk , reset ,
     input  logic rx_data ,
     input  logic tic ,
     output logic rx_done ,
     output logic [7:0] dout 
    );
    
logic [2:0] n , n_next ; // number of received bits 
logic [3:0] t , t_next ; // number of tics 
logic [7:0] r , r_next ; // register to store serial data 

typedef enum {idle , start , data ,stop} state ;

state st_reg , st_reg_next ;

always_ff @(posedge clk , posedge reset)
begin
    if (reset)
    begin
    st_reg <= idle ;
    n <= 0 ;
    r <= 0 ;
    t <= 0 ;
    end
    else 
    begin
    st_reg <= st_reg_next ;
    n <= n_next ;
    r <= r_next ;
    t <= t_next ;
    end
end
 
 always_comb 
  begin
  // defaults 
  st_reg_next = st_reg ;
  n_next = n ;
  r_next = r ;
  t_next = t ;
  
 // FSM 
 
  case (st_reg)
// idle case 
  idle : 
  begin
   if (rx_data)
   begin 
   st_reg_next = st_reg ;
   end
   else begin 
   st_reg_next = start ;
   t_next = 0 ;
   end
  end
 
// start case 
   start : 
   begin 
     if (tic)
     begin
     if (t == 7)
     begin
     st_reg_next = data ;
     t_next = 0 ;   // initialize number of tics for the next period 
     n_next = 0 ;   // initialize number of bits for the next data byte 
     end
     else begin
     t_next = t + 1 ;
     st_reg_next = st_reg ; 
     end
     end
   end
   
 // data case 
   data :
   begin
   if (tic)
   begin
   if (t == 15)
     begin
     t_next = 0 ;
     r_next = {rx_data , r[7:1] } ;
     if (n == nBit - 1)
     st_reg_next = stop ; 
     else 
     n_next = n + 1 ;
     end
   end
   else 
   t_next = t + 1 ; 
   end 
   
 // stop case 
   stop : 
   begin
   if (tic)
   if (t == SB_tic-1) begin
   st_reg_next = idle ; 
   rx_done = 1'b1 ;
   end
   else 
   t_next = t + 1 ;
   end   
  endcase  
 
 end  
endmodule
