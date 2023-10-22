# Using Xilinx Vivado

Vivado is a software that is used for FPGA programming. The version that is required for the Red Pitaya is Vivado 2020.1. I will go through the installation procedure and provide a brief tutorial of how to use the software.

## Installation and Usage

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

   > **Note**: You can also download from [this repository](https://github.com/RedPitaya/RedPitaya-FPGA) as a ZIP file and extract it onto your computer. The version in the shared folder might differ from the one on GitHub. This framework is essential to create a Red Pitaya project on Vivado. For those familiar with git, you can clone the GitHub repository. More details can be found on [this website](https://redpitaya-knowledge-base.readthedocs.io/en/latest/learn_fpga/3_vivado_env/tutorfpga2.html).

3. **Creating a Vivado Project**:
   - After installing Vivado and its dependencies, launch Vivado. You'll be greeted by the initial screen.
     ![Vivado Initial Screen](assets/vivado.png)
   - At the bottom, you'll find the TCL console. Use this console to input the commands below to initiate a Red Pitaya project:
     ```bash
     cd /path/to/folder/RedPitaya-FPGA-master
     cmd /c "C:\Xilinx\Vivado\2020.1\settings64.sh"
     make project PRJ=v0.94 MODEL=Z10
     ```

   > **Note**: Rather than creating a project via the GUI, we use these commands to ensure all the modules within the Red Pitaya are included.

4. **red_pitaya_top.sv**
   - When you execute the above commands, a new instance of Vivado should launch and load the Red Pitaya project. 
   - Once loaded, you should see a file named `red_pitaya_top` in the **Sources** tab, which will be your main file when tweaking connections or adding/removing modules.
   ![Sources Tab](assets/sources.png)

5. **RTL Analysis**
   - On the left, there's an **RTL Analysis** section.
   - Clicking on it will show a visual schematic of the design, helping you understand how different modules connect.
   ![RTL Analysis](assets/rtl.png)
   ![Schematic](assets/schematic.png)

6. **Adding Design Sources** 
   - To include new design sources, press the "Add Sources" button.
   - If you're using the MATLAB HDL coder, this is where you'd incorporate extra modules.
   ![Add Sources](assets/addsources.png)

7. **Generate Bitstream** 
   - Once all sources are added and necessary modifications are made in the code, click on "Generate Bitstream" to the left.
   - This will generate the bitstream file for uploading to the Red Pitaya.
   ![Generate Bitstream](assets/generatebitstream.png)

## Transferring the Bitstream to Red Pitaya

1. **Locate Bitstream File**:
   - Post bitstream creation, find the bitstream file on your computer.
   - Typically, its location resembles: `C:\Users\[YourUsername]\Desktop\RedPitaya-FPGA-master\[project_name]\red_pitaya_top.bit`

2. **Using Another Command Prompt Window**
   - Use terminal commands to send the bitstream file to Red Pitaya.
   - Launch two command prompts: one for setting up an SSH connection to Red Pitaya, the other for transferring the bitstream.

3. **Connecting to Red Pitaya**
   - Connect to the Red Pitaya via this command:
   ```bash
   ssh root@your.ip.static.address
   ```
   
Note: Use the static IP address you've set previously. After a successful connection, you'll need to provide the password (default is `root`).

4. **Write Permissions** 
   - After establishing an SSH connection, use the following command to grant write permissions:
```rw```

You can navigate the Red Pitaya's directory structure to ensure the correct location for the bitstream.

![Directory Structure](assets/redpitayadir.png)

5. **Transferring Bitstream File**
   - To transfer the bitstream file to the Red Pitaya, use the second command prompt window you opened.
   - Navigate to where the bitstream file is located using:
     ```
     cd .\Desktop\OIST\RedPitaya\RedPitaya-FilterTest\prj\v0.94\project\redpitaya.runs\impl_1\
     ```
   - Transfer the file using SCP:
     ```
     scp .\red_pitaya_top.bit root@192.168.0.5:/opt/redpitaya/fpga
     ```
   - You will be prompted to enter the Red Pitaya password again. Once done, the bitstream file should have transferred successfully.

## Additional Resources
   - For more information about using Vivado and transferring the bitstream file, check out [this link](https://redpitaya-knowledge-base.readthedocs.io/en/latest/learn_fpga/3_vivado_env/tutorfpga2.html) on the Red Pitaya official documentation website. (Note: replace `#` with the actual link)
