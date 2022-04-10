module PanelDisplay (
	input logic clk,
	input logic rst,
	input logic deadOrAlive[19:0][19:0],
	output logic hsync,
	output logic vsync,
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue);
  
  
  localparam H_PIXELS = 800;//640;
  localparam H_FRONT= 56;//16;
  localparam H_SYNC = 120;//96;
  localparam H_BACK= 64;//48;
  localparam H_SUM = H_PIXELS + H_FRONT + H_SYNC + H_BACK;
  
  localparam V_LINES = 600;//480;
  localparam V_FRONT= 37;//11;
  localparam V_SYNC = 6;//2;
  localparam V_BACK= 23;//31;
  localparam V_SUM = V_LINES + V_FRONT + V_SYNC + V_BACK;
  
  
  logic [10:0] cntRow;
  logic [10:0] cntColumn;
  logic enable;
	
  //toggle ff for frequency division by 2
  always_ff @(posedge clk, posedge rst) begin
    if (rst)
      enable <= 1'b1;
    else
      enable <=  ~enable;
  end
  
  //counter for every collumn
  always_ff @(posedge clk, posedge rst) begin
    if (rst) 
      cntColumn <= 0;
    else begin
      if (enable) begin
        cntColumn <= cntColumn + 1;
        if (cntColumn == H_SUM-1)
          cntColumn <= 0;
      end
	end	
  end
  
  //counter for every row
  always_ff @(posedge clk,posedge rst) begin
    if (rst) 
      cntRow <= 0;
    else begin
      if (enable) begin
        if (cntColumn == H_SUM-1) begin
          cntRow <= cntRow + 1;
          if (cntRow == V_SUM-1)
            cntRow <= 0;
        end
      end
    end
  end
  
  assign hsync = (cntColumn >= H_PIXELS + H_FRONT && cntColumn <H_PIXELS+H_FRONT+H_SYNC) ? 1'b0 : 1'b1;
  assign vsync = (cntRow >= V_LINES + V_FRONT && cntRow <V_LINES+V_FRONT+V_SYNC) ? 1'b0 : 1'b1;
  
  
  
  logic [5:0] cx, cy, x,y;
  always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
   x<=0;
   y<=0;
   cx<=1;
   cy<=1;
  end else begin
    if (enable) begin
    if(cntColumn>=100 && cntColumn<H_PIXELS-100 && cntRow>=0 && cntRow<V_LINES) begin
      x <= (x==29 || cntColumn==H_PIXELS-100) ? 0 : x+1;
      if (x == 29) begin
        cx <= (cx==20 || cntColumn==H_PIXELS-100)? 1 : cx+1;
      end else cx <= cx;
      if (cx==20 && x==29 && cntColumn==H_PIXELS -101) begin
         y <= (y==29 || cntRow==V_LINES)? 0 : y+1;
      end else y <= y;
       if (y ==29 && cntColumn==H_PIXELS-101 ) begin
            cy <= (cy == 20 || cntRow==V_LINES) ? 1 : cy + 1;
      end else cy <= cy;
     
   end   
  end
  end
  
  end
  
  
  
  
logic temp;  
assign temp=deadOrAlive[cy-1][cx-1];  
  
  always_comb begin
	red = 4'b0000;
    green = 4'b0000;
	blue = 4'b0000;
		
			if(cntColumn<H_PIXELS && cntRow<V_LINES) begin
            if (cntColumn<100 || cntColumn>=H_PIXELS-100) begin
				red = 4'b1111;
				green = 4'b1001;
				blue = 4'b1111;	
			end else if (x==29 || x==30 || y==29 || y==30) begin
					red = 4'b1111;
					green = 4'b0000;
					blue = 4'b0000;						
			end else if(/*cntColumn<= cx*30-1 && cntColumn> (cx-1)*30-1 && cntRow<=cy*30-1 && cntRow>(cy-1)*30-1 &&*/ temp==1'b1)begin			        
					red = 4'b1111;
					green = 4'b1111;
					blue = 4'b1111;
				end else begin
	               red = 4'b0000;
	               green = 4'b0000;
	               blue = 4'b0000;								
				end		
	
  end
  
  end
  
  

  
  
  //always_comb begin
	//	
  //  red = 4'b0000;
  //  green = 4'b0000;
  //  blue = 4'b0000;	
  //  if ((cntColumn < 320) & (cntRow < 240)) begin
  //    red = 4'b1111;
  //    green = 4'b0000;
  //    blue = 4'b0000;
  //  end
  //  else if ((cntColumn < 640) & (cntRow < 240)) begin
  //    red = 4'b0000;
  //    green = 4'b1111;
  //    blue = 4'b0000;
  //  end
  //  else if ((cntColumn < 320) & (cntRow < 480)) begin
  //    red = 4'b0000;
  //    green = 4'b0000;
  //    blue = 4'b1111;
  //  end
  //  else if ((cntColumn < 640) & (cntRow < 480)) begin
  //    red = 4'b0101;
  //    green = 4'b0101;
  //    blue = 4'b0101;
  //  end
  //  else begin
  //    red = 4'b0000;
  //    green = 4'b0000;
  //    blue = 4'b0000;
  //  end
  //end
  
endmodule