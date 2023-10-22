# Using Xilinx Vivado

Vivado is a software that is used for FPGA programming. The version that is required for the Red Pitaya is Vivado 2020.1. I will go through the installation procedure and provide a brief tutorial of how to use the software.

## Installation and Setup

1. **Vivado Installation**:
   - Create a [Xilinx account](https://www.amd.com/en/registration/create-account.html).
   - Required Version: Vivado 2020.1.
   - [Download Page](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)
   - Download the installer and follow the setup instructions.
   - Additionally, follow the installation instructions on the [Red Pitaya website](https://redpitaya-knowledge-base.readthedocs.io/en/latest/learn_fpga/3_vivado_env/tutorfpga1.html).
   - Depending on your OS, you might need to install certain packages.


2. **RedPitaya-FPGA-Master.zip**:
   - Download from the shared folder on Microsoft Teams (Documents/Rotation+Interns/IanHeung).
   - Move the folder to an easily accessible location.
   
   > **Note**: You can also download from [this](https://github.com/RedPitaya/RedPitaya-FPGA) repository as a ZIP file and extract it onto your computer. Be aware, the version in the shared folder might differ from the one on GitHub. This framework is essential to create a Red Pitaya project on Vivado. For those familiar with git, you can clone the GitHub repository. For more details, visit [this website](https://redpitaya-knowledge-base.readthedocs.io/en/latest/learn_fpga/3_vivado_env/tutorfpga2.html).

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

