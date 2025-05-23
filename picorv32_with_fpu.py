#!/usr/bin/env python3

from siliconcompiler import Chip
from siliconcompiler.targets import skywater130_demo
import argparse

def main(signoff):

    # Step 1: RTL2GDS
    chip = Chip('picorv32_with_fpu')
    chip.set('option', 'flow', 'asicflow')
    chip.set('option', 'jobname', 'rtl2gds')

    chip.input("picorv32_with_fpu.v")
    chip.input('picorv32.v')
    chip.input('fpu/fpu.v')
    chip.input('fpu/floating_point_add.v')
    chip.input('fpu/floating_point_multiply.v')

    chip.clock('clk', period=25)
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
    if signoff:
    
        chip = Chip('picorv32_with_fpu')

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
    parser.add_argument('-s', '--signoff', action='store_true')
    args = parser.parse_args()
    main(args.signoff)
