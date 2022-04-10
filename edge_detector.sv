module edge_detector(
  input  logic clk,
  input  logic rst,
  input  logic in,
  output logic out
);
 
  logic [1:0] s_reg;
  always_ff @(posedge clk,posedge rst) begin
    if (rst)
      s_reg <= 2'b0;
    else begin
      s_reg[1] <= s_reg[0];
      s_reg[0] <= in;
    end
  end
  
  assign out = ~s_reg[1] & s_reg[0];
  
    
endmodule