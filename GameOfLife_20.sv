module GameOfLife_20(
	input logic clk,
	input logic rst,
	input logic load,
	input logic speedButton, //Attatched to the physical button of the board
	output logic vsync_out,
	output logic hsync_out,
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue);


localparam GRID_SIZE_H=20; //Horizontal size of the grid
localparam GRID_SIZE_V=20; //Vertical size of the grid

logic userIn[19:0][19:0];
logic [8:0] vsync_edge;
logic vsync, hsync;
logic arrayOut[19:0][19:0];
logic edgeDet;
logic [1:0] speedCounter; //Counts the numbers that button is pressed (uses the edge detector)

genvar i;
genvar j;

//Edge detector for the hsync.
edge_detector hsync_edge_det(.clk(clk),
                            .rst(rst),
                            .in(vsync),
                            .out(edgeDet));
                            
                           

assign vsync_out = vsync;
//assign arrayOut_out=arrayOut;
assign hsync_out=hsync;


generate
for (i=0;i<=GRID_SIZE_V-1;i++) begin
	for (j=0;j<=GRID_SIZE_H-1;j++) begin
	// Creating initial condition that loads when button "load" is pressed
	   if (i==7 && (j==6 || j==7 || j==8))
            assign userIn[i][j]=1'b1;
        else if (i==6 && j==7)
            assign userIn[i][j]=1'b1;
        else
            assign userIn[i][j]=1'b0;
		if(i==0 && j==0) //Generating the CA cells for the grid, with the appropriate connections
			cellCA_sv caCell00 (clk,rst,load,userIn[i][j],1'b0,arrayOut[i][j+1],1'b0,arrayOut[i+1][j],1'b0,1'b0,1'b0,arrayOut[i+1][j+1],arrayOut[i][j],vsync_edge,edgeDet,speedCounter);
		else if(i==0 && j==GRID_SIZE_H-1)
			cellCA_sv caCell1919 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],1'b0,1'b0,arrayOut[i+1][j],1'b0,1'b0,arrayOut[i+1][j-1],1'b0,arrayOut[i][j],vsync_edge,edgeDet,speedCounter);
		else if (i==GRID_SIZE_V-1 && j==0)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],1'b0,arrayOut[i][j+1],arrayOut[i-1][j],1'b0,1'b0,arrayOut[i-1][j+1],1'b0,1'b0,arrayOut[i][j],vsync_edge,edgeDet,speedCounter);	
		else if (i==GRID_SIZE_V-1 && j==GRID_SIZE_H-1)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],1'b0,arrayOut[i-1][j],1'b0,arrayOut[i-1][j-1],1'b0,1'b0,1'b0,arrayOut[i][j],vsync_edge,edgeDet,speedCounter);
		else if(i==0 && j <GRID_SIZE_H-1)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],arrayOut[i][j+1],1'b0,arrayOut[i+1][j],1'b0,1'b0,arrayOut[i+1][j-1],arrayOut[i+1][j+1],arrayOut[i][j],vsync_edge,edgeDet,speedCounter);
		else if(i<GRID_SIZE_V-1 && j==0)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],1'b0,arrayOut[i][j+1],arrayOut[i-1][j],arrayOut[i+1][j],1'b0,arrayOut[i-1][j+1],1'b0,arrayOut[i+1][j+1],arrayOut[i][j],vsync_edge,edgeDet,speedCounter);
		else if(i==GRID_SIZE_V-1 && j <GRID_SIZE_H-1)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],arrayOut[i][j+1],arrayOut[i-1][j],1'b0,arrayOut[i-1][j-1],arrayOut[i-1][j+1],1'b0,1'b0,arrayOut[i][j],vsync_edge,edgeDet,speedCounter);		
		else if(i<GRID_SIZE_V-1 && j==GRID_SIZE_H-1)
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],1'b0,arrayOut[i-1][j],arrayOut[i+1][j],arrayOut[i-1][j-1],1'b0,arrayOut[i+1][j-1],1'b0,arrayOut[i][j],vsync_edge,edgeDet,speedCounter);		
		else
			cellCA_sv caCell018 (clk,rst,load,userIn[i][j],arrayOut[i][j-1],arrayOut[i][j+1],arrayOut[i-1][j],arrayOut[i+1][j],arrayOut[i-1][j-1],arrayOut[i-1][j+1],arrayOut[i+1][j-1],arrayOut[i+1][j+1],arrayOut[i][j],vsync_edge,edgeDet,speedCounter);		
			
	end
end


endgenerate


PanelDisplay panel(.clk(clk),
                    .rst(rst),
                    .deadOrAlive(arrayOut),
                    .hsync(hsync),
                    .vsync(vsync),
                    .red(red),
                    .green(green),
                    .blue(blue));
                    
  logic speedButtonEdge; //Button Pressed edge detection variable
  //Counter for the number of times speedbutton is pressed
  always_ff @ (posedge clk, posedge rst) begin  
  if(rst) begin
    speedCounter<=0;
  end else begin
    if(speedButtonEdge)
     speedCounter <= speedCounter +1;
    end   
  end

//Edge detector for the press of the speed button
edge_detector speedButton_edge (.rst(rst),
                                .clk(clk),
                                .in(speedButton),
                                .out(speedButtonEdge));


// VSYNC counter for the total number of frames per generation
always_ff @(posedge clk, posedge rst) begin
    if (rst)
        vsync_edge<=0;
    else begin
        if(edgeDet) begin
            if (vsync_edge==199-speedCounter*50)
                vsync_edge<=0;
            else
                vsync_edge<=vsync_edge+1;
            end
        end
    end



endmodule