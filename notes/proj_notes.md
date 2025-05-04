# Notes 

## Project Description : 
Bla Bla Bla !! Done !
 
## Tools
   - Compiler         : Silicon Compiler, Ver 0.32.3
   - Simulator        : GTK WaveVersion 

## Compilation Command :
- Simulation :
    - Add : make test_fpu OP=add
    - Subtraction : make test_fpu OP=sub
     
- Build :
    - CPU Only (picorv32) : python python/picorv32.py
    - CPU and Memory (picorv32 and SRAM) : python picorv32_with_sram.py
    - CPU, Memory and FPU (picorv32, SRAM, and FPU) : python picorv32_with_sram_n_fpu.py. [Make sure parameter ENABLE_FPU and ENABLE_PCPI is set to 1'b'1' in picorv32_with_sram_n_fpu.v
 
---

## Build Result :
-  _picorv32_
    -  [picorv32_ build_artifacts]()
    -  [picorv32_build_logs]()

-  _picorv32_with_SRAM_
    -  [picorv32 with SRAM build artifact](https://drive.google.com/drive/folders/1HZIRYepXikbSZyNfd87qoUdz732yYRxX?usp=sharing)
    -  [picorv32 wit SRAM build_logs] (https://github.com/osowatzke/picorv32/tree/main/build_reports/picorv32_sram) : DRV fails, thus signoff fails

-  _picorv32_with_fpu_
    -  [picorv32 with SRAM and_FPU_build artifact]()
    -  [picorv32 with SRAM and FPU build_logs] () 

-  _picorv32_with_SRAM_fpu_
    -  [picorv32 with SRAM and_FPU_build artifact]()
    -  [picorv32 with SRAM and FPU build_logs] () 

---

## Reference links
- _Silicon Compiler_
   - [Installation](https://docs.siliconcompiler.com/en/latest/user_guide/installation.html#installation)
   - [Quick Start Guide HeartBeat Example](https://docs.siliconcompiler.com/en/latest/user_guide/quickstart.html#quickstart-guide)
   - [Quick Start](https://docs.siliconcompiler.com/en/latest/user_guide/quickstart.html#quickstart-guide)
   - [Upgrade CMD] (pip install --upgrade siliconcompiler)
   - [Demo Proj Run CMD ] (sc -target asic_demo -remote)

- _Project_ 
   - [Requirement](https://docs.google.com/document/d/1w_6TcTO9ZfsKjH5dKjGZwSfvMj4INFzu/edit?tab=t.0#heading=h.gjdgxs)
   - [Repo Path ](https://github.com/osowatzke/picorv32)

- _HDL_
   - [PICORV32 Processor SRC](https://github.com/YosysHQ/picorv32)
   - [cnn-hw-accelerator](https://github.com/osowatzke/cnn-hw-accelerator/tree/main)
   - [FPU Source](https://github.com/osowatzke/picorv32/tree/main/fpu)

- _SRAM MACRO_
   - [sky130_sram_2kbyte_1rw1r_32x512_8](https://github.com/VLSIDA/sky130_sram_macros/tree/main/sky130_sram_2kbyte_1rw1r_32x512_8)

---

## Project Structure

| Folder/File           | Description                                                                                 |
|-----------------------|---------------------------------------------------------------------------------------------|
| `fpu\`                | FPU Source                                                                                  |
| `picorv32_with_sram.v`| Top level of picorv32 that instantiates sram                                                |
| `picorv32_top.v`      | Top level of picorv32 that instantiates CPU, FPU and SRAM, to do !                          |

## To Do
    - Use one design_topvv file for build and same for python. Parse argument from given command line.
    - Investigate signoff failure. SRAM macro is depricated, see build_report/
---
