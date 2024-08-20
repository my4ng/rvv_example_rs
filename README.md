# RVV Example

This is a Rust example using the RISC-V Vector extension (RVV) version 1.0 instructions with inline assembly. It is designed to be cross-compiled from a UNIX x86 machine.

## Prerequisites

- Rust toolchain
- [QEMU RISC-V emulator](https://www.qemu.org/docs/master/system/target-riscv.html)
- `git`
- [`cross`](https://github.com/cross-rs/cross)
- [`just`](https://github.com/casey/just)

## Build

- You can add a `.env` file to the root of the directory to supply environment variables to the just scripts. `QEMU` is defaulted to `qemu-riscv64`.
- `just test` builds and runs the test which should display the computed results.
- `just build` simply builds the library.

## License

All assembly files (`*.s`) are modified from the RISC-V Vector Extension document under the [Creative Commons Attribution 4.0 International License](https://github.com/riscv/riscv-v-spec/blob/master/LICENSE).

All other files are dual-licensed under Apache-2.0/MIT.
