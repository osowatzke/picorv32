import argparse

def join_or(items):
    return ', '.join(items[:-1]) + ' or ' + items[-1]

supported_builds = ['base','sram','mdiv','fpu']
parser = argparse.ArgumentParser()
parser.add_argument('build_type', help=("Build type. Valid options:  " + str(supported_builds)))
args = parser.parse_args()

if args.build_type not in supported_builds:
    raise ValueError("Build Type must be " + join_or(supported_builds))

chip_name = 'picorv32'
if args.build_type != 'base':
    chip_name = 'picorv32_top'

print("Building", chip_name, "with configuration", args.build_type)

# Create Chip object.
chip = Chip(chip_name)

# Set default Skywater130 PDK / standard cell lib / flow.
chip.use(skywater130_demo)

# Set job name
chip.set('option', 'build_dir', './build/' + 
chip.set('option', 'jobname', args.build_type)
chip.set('option', 'jobincr', './build_the_future')

# Run remotely
chip.set('option', 'remote', True) 

chip.input('picorv32.v')

if args.build_type != 'base'
    chip.input('picorv32_top.v')
    

