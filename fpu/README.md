# FPU Behavioral Simulation and PicoRV32 Build Instructions with SiliconCompiler

## Behavioral Simulation Instructions

To run a behavioral simulation of the **FPU**, execute the following command:

```bash
make test_fpu OP=<operation>
```

Where `<operation>` is either `'add'`, `'sub'`, or `'mult'`. For example:

```bash
make test_fpu OP=add
```

This will run a behavioral simulation of the floating-point adder. If `<operation>` is unspecified, it defaults to `'mult'`.

### Generating Waveform Data

To generate waveform data during simulation, run:

```bash
make test_fpu_vcd OP=<operation>
```

The waveform data can then be viewed using:

```bash
gtkwave testbench.vcd
```

### Random Test Data Generation

By default, the simulation executes 100 floating-point operations with random values through the **PicoRV32**. These values are uniformly distributed, increasing the chance of encountering NaNs and subnormal operations.

To update the simulation data from the `fpu/test` folder, run:

```bash
python create_random_test_data.py <operation> -n <number_of_samples> -s <seed>
```

Both `<seed>` and `<number_of_samples>` are optional and default to `0` and `100`, respectively. Examples:

```bash
python create_random_test_data.py add
```

This generates 100 random adder inputs/outputs with a seed of `0`.

```bash
python create_random_test_data.py sub -n 200 -s 1
```

This creates 200 random subtraction input/outputs with a seed of `1`.

> **Note:** The Verilog testbench includes a timeout mechanism that may trigger errors if your input is too large.

---

## Build Instructions

Ensure **SiliconCompiler** is installed. If not, refer to the [installation guide](https://docs.siliconcompiler.com/en/stable/user_guide/installation.html#installation).

### Setting Up the Environment

Activate your Python virtual environment:

```bash
source ~/venv/bin/activate
```

### Building PicoRV32

- **Without FPU:**

  ```bash
  python picorv32_with_sram.py
  ```

- **With FPU:**

  ```bash
  python picorv32_with_sram_n_fpu.py
  ```

The results are stored in the `build/` folder:

- For builds without FPU → `build/picorv32_with_sram`
- For builds with FPU → `build/picorv32_with_sram_n_fpu`

### Viewing the SiliconCompiler Dashboard

To view the **SiliconCompiler Dashboard**:

```bash
sc-dashboard -cfg <json_file>
```

Navigate to the `rtl2gds` subdirectory of the respective build folder to find the JSON configuration. Example:

```bash
cd ./build/picorv32_with_sram/rtl2gds
sc-dashboard -cfg picorv32_with_sram.pkg.json
```

If running on a headless terminal, copy the provided URL into a browser.

> **Note:** The dashboard may not render the design preview correctly, but the design summary image is available as:
> `./build/picorv32_with_sram/rtl2gds/picorv32_with_sram.png`

---

## Build Artifacts

The build directory also includes:

- `build_log.txt`: Terminal output logs.
- `rtl2gds.png`: Screenshot showing passing results.

### Timing Analysis

The top **N setup paths** (longest setup time violations) are stored in:

```
./rtl2gds/write.views/0/reports/timing/setup.topN.rpt
```