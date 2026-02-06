# Ristretto

Ristretto is a 64-bit hobby operating system kernel written in Pascal.

It currently targets x86_64 (support for additional architectures is planned) and uses the Limine bootloader.

**Features**
- **Language:** Pascal
- **Target:** x86_64 (current; future multi-architecture support planned)
- **Boot:** Limine Bootloader

**Required**

Build:
- `fpc` (Free Pascal compiler)
- `cc` / `gcc` (C compiler)
- `ld` (Linker)
- `nasm` (Netwide assembler)
- `curl`, `gunzip` and `tar` (used to fetch and extract vendor OVMF)
- `make`
- `git`

Run (w/ QEMU):
- `coreutils` (used to create disk images)
- `mtools` (used to create FAT images)
- `qemu`

Generate ISO:
- `xorriso`

**Build**

```bash
make
```

```bash
make all-iso
```

**Run (w/ QEMU)**

```bash
make run
```

```bash
make run-iso
```

**Clean**

```bash
make clean
```

```bash
make distclean
```

**License**

MIT License.
See [LICENSE](LICENSE) file.
