# RISC-V SystemVerilog model

## Requirements

You need to have nix package manager installed.

## How to build

### 0) Make sure you are in the root directory of the project (i.e. RISCV-model/)

### 1) Installing dependencies

```bash
nix develop
```

You may need to pass additional options to nix in case you do not have corresponding features set
in nix.conf.

```bash
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
```

### 2) Build the project

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```
