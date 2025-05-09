#!/usr/bin/bash

make download-tools
make -j$(nproc) build-tools

cd riscv-gnu-toolchain-rv32i/build
../configure --with-arch=rv32i --prefix=/opt/riscv32i
make -j$(nproc)
