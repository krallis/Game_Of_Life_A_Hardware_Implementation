# Game Of Life: A Hardware Implementation
This repo contains a System Verilog implementation of a Cellular Automata (CA) grid which runs under the rules of Conway's Game of Life (GoL). The size of the grid is modular and its initial dimensions are 20x20. The cells are connected in accordance with the Moore's neighborhood.
Along with the CA cell, there is also an implementation of a vga port so that the whole design can be loaded on an FPGA and the evolution of the CA can be previewed on a vga supported monitor.
The evolution of the CA and the VGA port are carefully synced, using the hsync signal of the VGA protocol.
This implementation was designed to be loaded on an fpga, thus there is a load button which loads on the CA the selected initial conditions. There is also a speed button which changes the number of frames that correspond to each generation of the CA, practically meaning that it changes the speed of the CA evolution on the screen.

# Future work
- A fully modular vga port that operates for every different size of CA grid
- Prepare under comment a bunch of popular initial conditions that create the most common patterns in GoL.

# Contents
- GameOfLife_20.sv -> This is the top level. It is used for the instantiation of the Cells and the VGA Port, as well as some other components (i.e. edge detectors) and for the interconnection of the submodules
- PanelDisplay.sv -> This is the VGA port module. It generates the appropriate signals of the VGA protocol and handles the output on the display.
- cellCA.sv -> This is the basic CA cell that operates under the rules of Conway's game of life.
- edge_detector.sv -> This is used for edge detection of different signals.
- GoL_sv_tb.sv -> This is very basic testbench script for behavioral simulations.

# Notes
This design was tested in Xilinx Vivado 2021.
