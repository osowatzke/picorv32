To run a behavioral simulation of the FPU. Execute the following command:

    make test_fpu OP=<operation>

Where operation is either 'add', 'sub', or 'mult'. For example

    make test_fpu OP=add

will run a behavioral simulation of the floating-point adder. 'OP' will default
to multiply if unspecified. To generate waveform data during simulation, run

    make test_fpu_vcd OP=<operation>

The waveform data can then be viewed by running

    gtkwave testbench.vcd

By default the simulation will running 100 floating-point operations with
random values through the PicoRV32. Each of these operations using data uniformly
over all exponents, increasing the probability of executing NaN's and subnormal
operations. The simulation data is passed to the testbench via text file, which
can be updated from the fpu/test folder by running the following command:

    python create_random_test_data.py <operation> -n <number of samples> -s <seed>

Both the <seed> and <number of samples> arguments are optional and if undefined
will default to 0 and 100 respectively. For example,

    python create_random_test_data.py add

will create 100 random adder inputs/outputs with a seed of 0. And the following
command will create 200 random subtraction input/outputs with a seed of 1.

    python create_random_test_data.py sub -n 200 -s 1

Note the verilog testbench has a timeout built into it, and may issue an error if
your input gets too large.

This README assumes that you have SiliconCompiler installed. If you do not, refer
to the following link for installation instructions:

    https://docs.siliconcompiler.com/en/stable/user_guide/installation.html#installation

Note that all of our scripts perform remote builds by default, so it is not
necessary to install all of the local build dependencies.

Run the following command to setup your environment for the build

    source ~/venv/bin/activate

Then, to build the PicoRV32 with SRAM and no FPU, run the following command from the
root of the repo:

    python picorv32_with_sram.py

Alternatively, to build the PicoRV32 with SRAM and an FPU, run the following command
from the root of the repo:

    python picorv32_with_sram_n_fpu.py

The results for both of these runs should be stored in the build/ folder. For the design
without an FPU, the results should be stored in build/picorv32_with_sram, and for the design
with an FPU, the results should be store in build/picorv32_with_sram_n_fpu.

Note that you can view the SiliconCompiler dashboard for either run, by running:

    sc-dashboard -cfg <json file>

where <json file> is the path to the JSON file generated during a run and placed at the root
of the rtl2gds subdirectory. For example to view the dashboard from a previously run
without an FPU, run the following from the root of the repo:

    cd ./build/picorv32_with_sram/rtl2gds

    sc-dashboard -cfg picorv32_with_sram.pkg.json
    
Note that if you are running a headless terminal, such as Ubuntu, you will need to copy the
provided URL into a web browser.

Our Silicon dashboard does not correctly render the design preview. However, it should be
accessible from the file explorer. It is placed in the rtl2gds subfolder of each run. The
design summary for a build without an FPU should be placed at
./build/picorv32_with_sram/rtl2gds/picorv32_with_sram.png
    
