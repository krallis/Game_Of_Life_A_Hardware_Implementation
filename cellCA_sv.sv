module cellCA_sv(
	input logic clk,
	input logic rst,
	input logic load,
	input logic userIn,
	input logic l,
	input logic r,
	input logic u,
	input logic d,
	input logic ul,
	input logic ur,
	input logic dl,
	input logic dr,
	output logic sigOut,
	input logic [8:0] vsync_edge,
	input logic edgeDet,
	input logic [1:0] speedCounter);


logic cellState;
logic [3:0] neighboursSum;







always_comb
begin
	neighboursSum=l+r+u+d+ul+ur+dl+dr;
end


always_ff @ (posedge clk, posedge rst)
	begin
		if(rst)
			cellState<=1'b0;
		else if (load)
		  cellState<=userIn;
		else begin
		if(vsync_edge==199-speedCounter*50 && edgeDet)
			begin
                if (cellState==1 && (neighboursSum==2 || neighboursSum==3))
					cellState <= 1'b1;
				else if (cellState==0 && neighboursSum==3)
					cellState <= 1'b1;
				else
					cellState <=1'b0;
			end
		end
	end	

	assign sigOut=cellState;


endmodule