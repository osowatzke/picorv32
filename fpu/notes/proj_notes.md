## Project Description : 

This project demonstrates the comprehensive workflow of designing, synthesizing, and integrating a basic System-on-Chip (SoC) using the PicoRV32 RISC-V CPU core with a floating-point unit (FPU), utilizing the open-source Skywater130 process node and SiliconCompiler framework. 

> [!NOTE]
>##  Tools
>   - _Compiler_         : Silicon Compiler, Ver 0.32.3
>   - _Simulator_        : GTK WaveVersion 


>## Reference links
>- _Silicon Compiler_
>   - [Installation](https://docs.siliconcompiler.com/en/latest/user_guide/installation.html#installation)
>   - _Quick Start_
>       - [HeartBeat Example](https://docs.siliconcompiler.com/en/latest/user_guide/quickstart.html#quickstart-guide)
>       - [Building SOC with SRAM](https://docs.siliconcompiler.com/en/stable/user_guide/tutorials/picorv32_ram.html)
>   - _Upgrade CMD_ 
>       -   pip install --upgrade siliconcompiler
>   - _Demo Proj Run CMD_
>       - sc -target asic_demo -remote
>- _RISCV_
>   -   [Insctruction Format](https://pcotret.gitlab.io/riscv-custom/sw_toolchain.html#existing-opcodes)
>   -   [List of Existing Opcodes in riscv-opcodes repo](https://github.com/riscv/riscv-opcodes/blob/7c3db437d8d3b6961f8eb2931792eaea1c469ff3/opcodes)
> - _Floating Point_
>   -   [Floating Point Instruction Format](https://msyksphinz-self.github.io/riscv-isadoc/html/rvfd.html)
>   -   [RISV Floating Point Documentation, Starting on Page 111 and 130 when searching](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view)
>- _PCPI_
>   - [Intro](https://kuleuven-diepenbeek.github.io/hwswcodesign-course/200_coprocessor/202_pcpi/)
>   - [HW/SW codesign,Github.io, 2025](https://kuleuven-diepenbeek.github.io/hwswcodesign-course/200_coprocessor/202_pcpi/)
>- _Project_ 
>   - [Requirement](https://docs.google.com/document/d/1w_6TcTO9ZfsKjH5dKjGZwSfvMj4INFzu/edit?tab=t.0#heading=h.gjdgxs)
>   - [Repo Path ](https://github.com/osowatzke/picorv32)
>- _HDL SOURCE_
>   - [PICORV32 Processor SRC](https://github.com/YosysHQ/picorv32)
>   - [cnn-hw-accelerator](https://github.com/osowatzke/cnn-hw-accelerator/tree/main)
>   - [FPU](https://github.com/osowatzke/picorv32/tree/main/fpu)
>- _SRAM From VLSIDA_
>   -    [“OpenSRAM: An Open-Source Static Random Access Memory (SRAM) Compiler”, GitHub Repository](https://github.com/VLSIDA/OpenRAM)
>   - [SRAM Macr0 : sky130_sram_2kbyte_1rw1r_32x512_8, GitHub Repository](https://github.com/VLSIDA/sky130_sram_macros/tree/main/sky130_sram_2kbyte_1rw1r_32x512_8)

---




>[!TIP]
>## Compilation Command :
>- _Simulation_ :
>    - Add : make test_fpu OP=add
>    - Subtraction : make test_fpu OP=sub
>- _Build_ :
>    - CPU Only (picorv32) : python python/picorv32.py
>    - CPU and Memory (picorv32 and SRAM) : python picorv32_with_sram.py
>    - CPU, Memory and FPU (picorv32, SRAM, and FPU) : python picorv32_with_sram_n_fpu.py. [Make sure parameter ENABLE_FPU and ENABLE_PCPI is set to 1'b'1' in picorv32_with_sram_n_fpu.v]

> - [For detailed instruction -> readme.txt](https://github.com/osowatzke/picorv32/blob/main/README.txt)
---


> [!IMPORTANT]
>   ## Simulation Result Waveform:
>   -  [_ADD_](https://raw.githubusercontent.com/osowatzke/picorv32/refs/heads/main/fpu/test/sim_results_wave_form/add_execution_time_19_clk_cycls.webp)
>   -  [_MULT_](https://github.com/osowatzke/picorv32/blob/main/fpu/test/sim_results_wave_form/mult_execution_time_16_clk_cycls.webp)
>   ## Build Result :
>-  _picorv32_
>    -  [picorv32 build artifacts](N/A)
>    -  [picorv32 build logs](N/A)
>-  _picorv32_with_SRAM_
>    -  [picorv32 with SRAM build artifact](https://drive.google.com/drive/folders/1HZIRYepXikbSZyNfd87qoUdz732yYRxX?usp=sharing)
>    -  [picorv32 wit SRAM build logs](https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_sram) : DRV fails, thus signoff fails
>-  _picorv32_with_native_multipication_n_division_Enabled_
>    -  [picorv32 with native multipication and division enabled](https://drive.google.com/drive/u/1/folders/1VlnNr_21aUsA_DjHPXHZn9BB6XyD7hkd)
>    -  [picorv32 with native mult n div build logs](https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_mult_div_en)
>-  _picorv32_with_fpu_
>    -  [picorv32 with FPU build artifact](https://drive.google.com/drive/u/1/folders/1kTCtYxuz99U9cSjo17kvR0XbPk3eu2aA)
>    -  [picorv32 with FPU build logs](https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv_with_fpu)
>-  _picorv32_with_SRAM_fpu_
>    -  [picorv32 with SRAM and FPU build artifact](https://drive.google.com/drive/u/1/folders/1UcBPUZK2ttfehgvwb2NUJgJjfC84vi1s)
>    -  [picorv32 with SRAM and FPU build logs](https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_with_sram_fpu)

---


## Project Structure / File add on to the fork

|Design Phase| Folder/File             | Description                                                                                  |
|-------|-------------------------|----------------------------------------------------------------------------------------------   |
| I     | `picorv32_with_sram.v`  | Top level of picorv32 that instantiates SRAM back box                                        |
| I     | `picorv32_with_sram.py` | Build script that configures sources all HDL path and SRAM Macro. Design contrains such as like die size and clock period are placed here         |
| II    | `picorv32_with_sram_n_fpu.v`  | Top level of picorv32 that instantiates SRAM black box and FPU                    top                                                |
| II    | `picorv32_with_sram_n_fpu.py` | Python Build script, similar as picorv32_with_sram.py                                                            |
| II    | `fpu\*.v`               | Custom FPU Source                                                                           |
| II    | `fpu\*\.txt\`           | Test Files for Mult, Add and Subtract                                                       |
| II    | `fpu\create_random.py`  | Test data creator                                                                          |
| II    | `testbench_fpu.v`       | Testbench                                                                                   | 