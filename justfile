set dotenv-load

default: test

test:
    #!/usr/bin/env sh
    set -euxo pipefail

    EXE=$(cross rustc --tests --target riscv64gc-unknown-linux-gnu --message-format=json | \
    jq -r '.executable  | select( . != null )')

    ${QEMU:-"qemu-riscv64"} -cpu rv64,v=true,zba=true,vlen=256 .${EXE} --nocapture

build:
    cross build --target riscv64gc-unknown-linux-gnu 