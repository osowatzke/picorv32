# Project Information

## Project Description : 
Bla Bla Bla !! Done !

> [!NOTE]
>##  Tools
>   - _Compiler_         : Silicon Compiler, Ver 0.32.3
>   - _Simulator_        : GTK WaveVersion 
>## Reference links
>- _Silicon Compiler_
>   - [Installation](https://docs.siliconcompiler.com/en/latest/user_guide/installation.html#installation)
>   - [Quick Start Guide HeartBeat Example](https://docs.siliconcompiler.com/en/latest/user_guide/quickstart.html#quickstart-guide)
>   - [Quick Start](https://docs.siliconcompiler.com/en/latest/user_guide/quickstart.html#quickstart-guide)
>   - [Upgrade CMD] (pip install --upgrade siliconcompiler)
>   - [Demo Proj Run CMD ] (sc -target asic_demo -remote)
>- _Project_ 
>   - [Requirement](https://docs.google.com/document/d/1w_6TcTO9ZfsKjH5dKjGZwSfvMj4INFzu/edit?tab=t.0#heading=h.gjdgxs)
>   - [Repo Path ](https://github.com/osowatzke/picorv32)
>- _HDL_
>   - [PICORV32 Processor SRC](https://github.com/YosysHQ/picorv32)
>   - [cnn-hw-accelerator](https://github.com/osowatzke/cnn-hw-accelerator/tree/main)
>   - [FPU Source](https://github.com/osowatzke/picorv32/tree/main/fpu)
>- _SRAM MACRO_
>   - [sky130_sram_2kbyte_1rw1r_32x512_8](https://github.com/VLSIDA/sky130_sram_macros/tree/main/sky130_sram_2kbyte_1rw1r_32x512_8)

---

>[!TIP]
>## Compilation Command :
>- Simulation :
>    - Add : make test_fpu OP=add
>    - Subtraction : make test_fpu OP=sub
>- Build :
>    - CPU Only (picorv32) : python python/picorv32.py
>    - CPU and Memory (picorv32 and SRAM) : python picorv32_with_sram.py
>    - CPU, Memory and FPU (picorv32, SRAM, and FPU) : python picorv32_with_sram_n_fpu.py. [Make sure parameter ENABLE_FPU and ENABLE_PCPI is set to 1'b'1' in picorv32_with_sram_n_fpu.v]


---


> [!IMPORTANT]
>   ## Build Result :
>-  _picorv32_
>    -  [picorv32 build artifacts](N/A)
>    -  [picorv32 build logs](N/A)
>-  _picorv32_with_SRAM_
>    -  [picorv32 with SRAM build artifact](https://drive.google.com/drive/folders/1HZIRYepXikbSZyNfd87qoUdz732yYRxX?usp=sharing)
>    -  [picorv32 wit SRAM build logs] (https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_sram) : DRV fails, thus signoff fails
>-  _picorv32_with_native_multipication_n_division_Enabled_
>    -  [picorv32 with native multipication and division enabled](https://drive.google.com/drive/u/1/folders/1VlnNr_21aUsA_DjHPXHZn9BB6XyD7hkd)
>    -  [picorv32 with native mult n div build logs] (https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_mult_div_en)
>-  _picorv32_with_fpu_
>    -  [picorv32 with FPU build artifact](https://drive.google.com/drive/u/1/folders/1kTCtYxuz99U9cSjo17kvR0XbPk3eu2aA)
>    -  [picorv32 with FPU build logs](https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv_with_fpu)
>-  _picorv32_with_SRAM_fpu_
>    -  [picorv32 with SRAM and FPU build artifact](https://drive.google.com/drive/u/1/folders/1UcBPUZK2ttfehgvwb2NUJgJjfC84vi1s)
>    -  [picorv32 with SRAM and FPU build logs] (https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_with_sram_fpu)

---


## Project Structure

| Folder/File           | Description                                                                                 |
|-----------------------|---------------------------------------------------------------------------------------------|
| `fpu\`                | FPU Source                                                                                  |
| `picorv32_with_sram.v`| Top level of picorv32 that instantiates sram                                                |
| `picorv32_top.v`      | Top level of picorv32 that instantiates CPU, FPU and SRAM, to do !                          |

> [!WARNING] 
> ## To Do
>    - Use one design_topv.v file for build and same for python.
>        - Use parameter to enable/disable the modules, like SRAM, FPU, etc.
>    - Python : Parse argument from given command line and run build accordingly.
>        - SRAM Signoff failure
>        - SRAM macro is depricated, see build_report/
>        - Tried both macros
>            - https://github.com/VLSIDA/sky130_sram_macros
>            - https://github.com/VLSIDA/sky130_sram_macros/tree/main/sky130_sram_2kbyte_1rw1r_32x512_8
>       - Pre and post layout simulation
---
