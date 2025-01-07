`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 03:48:14 AM
// Design Name: 
// Module Name: control
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
module control #(parameter addr_width = 3)
    (
     output logic [addr_width-1 : 0] wr_addr ,
     output logic [addr_width-1 : 0] rd_addr ,
     output logic full , empty , 
     input logic clk , reset ,
     input logic wr , rd 
    );
    
 logic [addr_width-1 : 0] rd_ptr  ; 
 logic [addr_width-1 : 0] wr_ptr  ; 
 logic [addr_width-1 : 0] rd_ptr_next ;
 logic [addr_width-1 : 0] wr_ptr_next ; 
 
 logic full_next  ;
 logic empty_next ;
 
 always_ff @(posedge clk , posedge reset)
  begin
   if (reset)
   begin
     rd_ptr <= 0 ;
     wr_ptr <= 0 ;
     full   <= 0 ;
     empty  <= 1 ;
   end  
   else 
   begin
     rd_ptr <= rd_ptr_next ;
     wr_ptr <= wr_ptr_next ;
     full   <= full_next   ;
     empty  <= empty_next  ;
   end
  end  
  
 always_comb
   begin 
     rd_ptr_next = rd_ptr  ;
     wr_ptr_next = wr_ptr  ;
     full_next   = full    ;
     empty_next  = empty   ;
   end  
   
 case ({wr,rd})
 
 2'b01 : 
  begin
     if (~empty)
      begin
        rd_ptr_next = rd_ptr + 1 ;
        full_next = 1'b0 ;
        if (rd_ptr_next == wr_ptr)
         empty_next = 1'b1 ; 
        end  
     end
  end  
    2'b10 : 
      begin
       if (~full)
        begin
          wr_ptr_next = wr_ptr + 1 ;
          empty_next = 1'b0 ;
          if (wr_ptr_next == rd_ptr)
           begin
           full_next = 1'b1 ; 
           end
        end  
      end
      
    2'b11 
        begin
         if (empty)
         begin
          wr_ptr_next = wr_ptr  ;
          rd_ptr_next = rd_ptr  ; 
         end
         else
         begin
         wr_ptr_next = wr_ptr  +1 ;
         rd_ptr_next = rd_ptr  +1 ; 
         end
        end 
        
       defult : ;
       
       endcase
       
       assign wr_addr = wr_ptr ;
       assign rd_addr = rd_ptr ;
endmodule
