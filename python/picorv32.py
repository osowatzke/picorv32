#!/usr/bin/env python3

from siliconcompiler import Chip
from siliconcompiler.targets import skywater130_demo
import argparse

def main(signoff_only):

    # Step 1: RTL2GDS
    chip = Chip('picorv32')
    chip.set('option', 'flow', 'asicflow')
    chip.set('option', 'jobname', 'rtl2gds')

    if not signoff_only:
        chip.input("picorv32.v")
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
    chip = Chip('picorv32')

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
    parser.add_argument('-s', '--signoff-only', action='store_true')
    args = parser.parse_args()
    main(args.signoff_only)