module GoL_sv_tb;

	logic clk,rst,load;
	//logic arrayOut[0:19][0:19];
	logic [3:0] red;
	logic [3:0] green;
	logic [3:0] blue;
	logic hsync,vsync;


	
	
always begin
	clk=1;
	#10ns;
	clk=0;
	#10ns;
end
	

GameOfLife_20 golGrid(.clk (clk),
					.rst (rst),
					.load (load),
					.hsync_out(hsync),
					.vsync_out(vsync),
					.red(red),
					.green(green),
					.blue(blue));
					
					
					





initial begin

	rst <=1'b0;
	load <=1'b0;
	@ (posedge clk)
	rst <=1'b1;
	@ (posedge clk)
	rst <=1'b0;
	@ (posedge clk)
	rst <=1'b0;
	@(posedge clk)
	load <= 1'b1;
	@ (posedge clk)
	load <= 1'b0;
	repeat(2000) @ (posedge clk);

end



		




endmodule