#!/usr/bin/env python3
#import os, sys
from siliconcompiler import Chip
from siliconcompiler.targets import skywater130_demo
import argparse

die_width = 1000
die_height = 1000

design = 'picorv32_with_sram_n_fpu'

def main(signoff_only):
    target = skywater130_demo
    
    # Create Chip object.
    chip = Chip(design)

    # Set default Skywater130 PDK / standard cell lib / flow.
    chip.use(target)

    # Step 1: RTL2GDS
    chip.set('option', 'flow', 'asicflow')
    chip.set('option', 'jobname', 'rtl2gds')

    if not signoff_only:
        # Set input source files.
        chip.input(f'{design}.v')
        chip.input('picorv32.v')
        chip.input('fpu/floating_point_add.v')
        chip.input('fpu/floating_point_multiply.v')
        #chip.input('fpu/fmuls.v')
        chip.input('fpu/fpu.v')
        chip.input('sram/sky130_sram_2k.bb.v')

        # Set clock period, so that we won't need to provide an SDC constraints file.
        chip.clock('clk', period=25)

        # Set die outline and core area.
        chip.set('constraint', 'outline', [(0,0), (die_width, die_height)])
        chip.set('constraint', 'corearea', [(10,10), (die_width-10, die_height-10)])

        # Setup SRAM macro library.
        from sram import sky130_sram_2k
        chip.use(sky130_sram_2k)
        chip.add('asic', 'macrolib', 'sky130_sram_2k')

        # SRAM pins are inside the macro boundary; no routing blockage padding is needed.
        chip.set('tool', 'openroad', 'task', 'route', 'var', 'grt_macro_extension', '0')
        # Disable CDL file generation until we can find a CDL file for the SRAM block.
        chip.set('tool', 'openroad', 'task', 'export', 'var', 'write_cdl', 'false')

        # Place macro instance.
        # https://github.com/siliconcompiler/siliconcompiler/blob/main/examples/picorv32_ram/picorv32_ram.py
        # Example
        chip.set('constraint', 'component', 'sram', 'placement', (150, 150))
        chip.set('constraint', 'component', 'sram', 'rotation', 'R180')

        chip.set('option', 'remote', True)
        chip.set('option', 'nodisplay', True)
        chip.set('option', 'clean', True)

        chip.use(skywater130_demo)
        chip.run()
        chip.summary()
        chip.snapshot()

    gds_path = chip.find_result('gds', step='write.gds')
    vg_path = chip.find_result('vg', step='write.views')

    # Step 2: Signoff Run
    chip = Chip(design)

    chip.input(gds_path)
    chip.input(vg_path)

    chip.set('option', 'flow', 'signoffflow')
    chip.set('option', 'jobname', 'signoff')
    chip.set('option', 'remote', True)
    chip.set('option', 'nodisplay', True)
    chip.set('option', 'clean', True)

    chip.use(skywater130_demo)
    chip.run()
    chip.summary()
    chip.snapshot()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    #if additional args are passed with -s or --signoff-only signoff_only true
    parser.add_argument('-s', '--signoff-only', action='store_true')
    args = parser.parse_args()
    main(args.signoff_only)
