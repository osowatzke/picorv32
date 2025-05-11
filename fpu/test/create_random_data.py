import argparse
import numpy as np
import os
from   pathlib import Path
import warnings

def gen_random_data(op='mult', N=100, seed=0):

    # Information messsage for user
    print(f'Generating {N} Random Samples for \'{op}\' with seed={seed}')

    # Set seed
    np.random.seed(seed)

    # Generate random data
    # Use randint to generate uniform data over exponents
    # Proves 1/256 chance of getting a NaN, Infinity, or subnormal number
    A = np.random.randint(0, 2**32-1, size=N, dtype=np.uint32).view(np.float32)
    B = np.random.randint(0, 2**32-1, size=N, dtype=np.uint32).view(np.float32)

    # Perform reference operation
    if op == 'mult' :
        Y = np.multiply(A, B)
    elif op == 'add':
        Y = A + B
    elif op == 'sub':
        Y = A - B
    else:
        ValueError("Unsupported Value for op. Should be member of ['mult','add','sub']")

    # NaN is max exponent + a non-zero mantissa
    # HDL implementation only uses one variation of NaN
    # So force all reference outputs to that value
    Y[np.isnan(Y)] = np.uint32(0x7FC0_0000).view(np.float32)

    # View each number as a uint32
    A = A.view(np.uint32)
    B = B.view(np.uint32)
    Y = Y.view(np.uint32)

    # Determine output directory
    out_dir = os.path.join(os.path.split(__file__)[0],op)

    # Create output directory if it does not exist
    Path(out_dir).mkdir(parents=True, exist_ok=True)

    # Create files
    np.savetxt(os.path.join(out_dir,'dataA.txt'), A, fmt="%08X")
    np.savetxt(os.path.join(out_dir,'dataB.txt'), B, fmt="%08X")
    np.savetxt(os.path.join(out_dir,'dataY.txt'), Y, fmt="%08X")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('op')
    parser.add_argument('-s','--seed',     type=int, default=0  )
    parser.add_argument('-n','--num-samp', type=int, default=100)
    args = parser.parse_args()
    warnings.filterwarnings('ignore')
    gen_random_data(args.op, args.num_samp, args.seed)

