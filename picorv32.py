# Build the PicoRV32 Core using SiliconCompiler

#!/usr/bin/env python3
import siliconcompiler
from siliconcompiler.targets import skywater130_demo

if __name__ == "__main__":
    chip = siliconcompiler.Chip('picorv32')   # create chip object
    chip.input('picorv32.v')                  # define list of source files
    chip.clock('clk', period=10)              # define clock speed of design
    chip.use(skywater130_demo)                # load predefined technology and flow target
    chip.set('option', 'remote', True)        # run remote in the cloud
    chip.run()                                # run compilation of design and target
    chip.summary()                            # print results summary
    chip.show()                               # show layout
