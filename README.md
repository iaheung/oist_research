# Experimental Quantum Information Physics Unit Research

## Introduction
In this repository, I showcase some of my work I did at the Okinawa Institute of Science and Technology.

I was assigned a project to implement a PID controller and digital filters to control the laser frequency of a cooling laser. The laser was previously controlled using mechanical devices, so this effor to digitize the controlling would allow autonomous digital control of the apparatus. To implement the PID controller and digital filters, I used a experimental board called a Red Pitaya. I wrote Verilog code onto the FPGA board of the Red Pitaya using FPGA programming software Xilinx Vivado. 

## What is in the Repository
The main file I used is `red_pitaya_top.sv`. I adapted the original file from the following [repo](https://github.com/RedPitaya/RedPitaya-FPGA) for programming the Red Pitaya FPGA. The `red_pitaya_top.sv` file is also in the Vivado folder, but I put it in the root directory of this repo for ease of access. The PID control module is implemented in the file.

### Filters
This folder contains the filters I designed for the PID controller. There are FIR and IIR filters, and also filters I created on MATLAB.

### Vivado
The software I used for writing the Verilog code onto the FPGA of the Red Pitaya is called Xilinx Vivado. In the folder, there is a folder called **RedPitaya-PID-Filter**, which contains all the nessesary files for use in Vivado to upload a bitstream file onto the Red Pitaya FPGA. Instructions are also listed in the README file in the folder.
