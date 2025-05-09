# Build the PicoRV32 Core using SiliconCompiler

#!/usr/bin/env python3
import os
from siliconcompiler import Chip
from siliconcompiler.targets import skywater130_demo

#Navigate to repo root
# file_path = os.path.split(__file__)[0]
# print(file_path)
# root_dir = os.path.join(file_path, '..')
# os.chdir(root_dir)

# Create Chip object.
chip = Chip('picorv32')

# Set default Skywater130 PDK / standard cell lib / flow.
chip.use(skywater130_demo)
    
# chip = siliconcompiler.Chip('picorv32')     # create chip object
# chip.load_target('skywater130_demo')        # load predefined target
chip.input('../picorv32.v')                 # define list of source files
chip.clock('clk', period=10)                # define clock speed of design
chip.set('option', 'remote', True)          # run remote in the cloud
chip.run()                                  # run chip compilation
chip.summary()                              # print results summary with PNG screenshot and HTML report