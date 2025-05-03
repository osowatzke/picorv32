import siliconcompiler
from siliconcompiler.targets import skywater130_demo    
design = 'picorv32_top'
die_width = 1000
die_height = 1000

chip = siliconcompiler.Chip(design)
chip.use(skywater130_demo)

# Set input source files.
chip.input(f'{design}.v')
chip.input('picorv32.v')
chip.input('sram/sky130_sram_2k.bb.v')

# Set clock period, so that we won't need to provide an SDC constraints file.
chip.clock('clk', period=10)

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
chip.set('constraint', 'component', 'sram', 'placement', (150, 150))
chip.set('constraint', 'component', 'sram', 'rotation', 'R180')

# Set clock period, so that we won't need to provide an SDC constraints file.
chip.clock('clk', period=25)

# Build on a remote server and generate summary
chip.set('option', 'remote', True)
chip.run()
chip.summary()
chip.show()
