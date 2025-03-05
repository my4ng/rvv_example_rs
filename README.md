# RVV Example

This is a Rust example using the RISC-V Vector extension (RVV) version 1.0 instructions with inline assembly. It is designed to be cross-compiled from a UNIX x86 machine and run with QEMU, or it can be run natively on some RISC-V boards.

## Prerequisites for QEMU

- [Rust toolchain](https://rustup.rs)
- [QEMU RISC-V emulator](https://www.qemu.org/docs/master/system/target-riscv.html)
- `git`
- [`cross`](https://github.com/cross-rs/cross)
- [`just`](https://github.com/casey/just)

## Prerequisites for RISC-V boards

- v1.0 Vector Extension support (TODO: add support for v0.7.1 vector extension)
- [Rust toolchain](https://rustup.rs)
- `git`, `gcc` and `binutils`

## Build and Run for QEMU

- You can add a `.env` file to the root of the directory to supply environment variables to the just scripts. `QEMU` is defaulted to `qemu-riscv64`.
- `just test` builds and runs the test which should display the computed results.
- `just build` simply builds the library.

## Build and Run for RISC-V boards

- `cargo test`

## License

All assembly files (`*.s`) are modified from the RISC-V Vector Extension document under the [Creative Commons Attribution 4.0 International License](https://github.com/riscv/riscv-v-spec/blob/master/LICENSE).

All other files are dual-licensed under Apache-2.0/MIT.
