`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2023 04:15:33 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter #(parameter 
                  nBit = 8 ,   // number of data bits
                  SB_tic = 16  // number of ticks for stop bit 
                 )          
    (
     input   logic clk , reset ,
     output  logic tx_data ,
     input   logic tic ,
     output  logic tx_done ,
     input   logic [7:0] din , 
     input   logic tx_start 
    );
 
 logic [2:0] n , n_next ; // number of received bits 
    logic [3:0] t , t_next ; // number of tics 
    logic [7:0] r , r_next ; // register to store serial data 
    logic tx_reg , tx_next ; // to store transmitted serial data 
    
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
        tx_reg <= 1'b1 ;
        end
        else 
        begin
        st_reg <= st_reg_next ;
        n <= n_next ;
        r <= r_next ;
        t <= t_next ;
        tx_reg <= tx_next ;
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
         if (tx_start)
         begin
         tx_next = 1'b1 ;
         st_reg_next = start ;
         t = 0 ;
         end
       end   
      
      start : 
       begin
       tx_next = 1'b0 ;  
       if (tic)
       if (t == 15)
        begin
        st_reg_next = data ; 
        t = 0 ;
        n = 0 ;       
        end
        else 
        t_next = t + 1 ;
       end
      
      data : 
      begin 
      tx_next = r [0] ;
      if (tic)
      if (t == 15)
        begin 
        r_next = r >> 1 ; 
        t_next = 0 ;
        if (n == (nBit -1) )
        st_reg_next = stop ;
      else 
      t_next = t + 1 ; 
      end
      end  
    
   stop : 
   begin 
   tx_next = 1'b1 ;
   if (tic)
   if (t == (SB_tic-1) )
    begin
    st_reg_next = idle ; 
    tx_done = 1'b1 ;
    end
   else 
   t_next = t + 1 ; 
   end    
      
      endcase 
   end
       
  assign tx_data = tx_reg ;   
endmodule
