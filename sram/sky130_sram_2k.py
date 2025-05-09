import siliconcompiler

def setup(chip):
    # Core values.
    design = 'sky130_sram_2k'
    stackup = chip.get('option', 'stackup')

    # Create Library object to represent the macro.
    lib = siliconcompiler.Library(chip, design)
    lib.set('output', stackup, 'gds', 'sram/sky130_sram_2kbyte_1rw1r_32x512_8.gds')
    lib.set('output', stackup, 'lef', 'sram/sky130_sram_2kbyte_1rw1r_32x512_8.lef')
    # Set the 'copy' field to True to pull these files into the build directory during
    # the 'import' task, which makes them available for the remote workflow to use.
    lib.set('output', stackup, 'gds', True, field='copy')
    lib.set('output', stackup, 'lef', True, field='copy')

    return lib