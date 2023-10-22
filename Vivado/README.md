# Using Xilinx Vivado

Vivado is a software that is used for FPGA programming. The version that is required for the Red Pitaya is Vivado 2020.1. I will go through the installation procedure and provide a brief tutorial of how to use the software.

## Installation and Setup

1. **Vivado Installation**:
   - Required Version: Vivado 2020.1.
   - [Download Page](#) (Replace `#` with the actual link).
   - Download the installer and follow the setup instructions.
   - Additionally, follow the installation instructions on the [Red Pitaya website](#) (Replace `#` with the actual link).
   - Depending on your OS, you might need to install certain packages.
   - Create a [Xilinx account](#) (Replace `#` with the actual link).

2. **RedPitaya-FPGA-Master.zip**:
   - Download from the shared folder on Microsoft Teams (Documents/Rotation+Interns/IanHeung).
   - Move the folder to an easily accessible location.
   
   > **Note**: You can also download from this repository as a ZIP file and extract it onto your computer. Be aware, the version in the shared folder might differ from the one on GitHub. This framework is essential to create a Red Pitaya project on Vivado. For those familiar with git, you can clone the GitHub repository. For more details, visit [this website](#) (Replace `#` with the actual link).

3. **Creating a Vivado Project**:
   - After installing Vivado and its dependencies, launch Vivado. You'll be greeted with the initial screen.
   
     ![Vivado Initial Screen](#) (Replace `#` with the actual path or link to the image)
     
   - At the bottom, you should see the TCL console. Use this console to type the following commands to initiate a Red Pitaya project:
   
     ```bash
     cd /path/to/folder/RedPitaya-FPGA-master
     cmd /c "C:\Xilinx\Vivado\2020.1\settings64.sh"
     make project PRJ=v0.94 MODEL=Z10
     ```

   > **Note**: Instead of creating a project through the GUI, we utilize these commands to ensure all the modules within the Red Pitaya are incorporated.

