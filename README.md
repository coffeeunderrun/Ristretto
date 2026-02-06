# Ristretto

Ristretto is a 64-bit hobby operating system kernel written in Pascal.

It currently targets x86_64 (support for additional architectures is planned) and uses the Limine bootloader.

**Features**
- **Language:** Pascal
- **Target:** x86_64 (current; future multi-architecture support planned)
- **Boot:** Limine Bootloader

**Requirements**
- `fpc` (Free Pascal Compiler)
- `cc` / `gcc` (C compiler)
- `ld` (GNU binutils)
- `nasm` (Netwide Assembler)
- `dd` (coreutils; used to create disk images)
- `mtools` (`mformat`, `mmd`, `mcopy` used to create FAT images)
- `curl`, `gunzip` and `tar` (used to fetch and extract vendor OVMF)
- `make`
- `qemu`
- `git`

**Build**

```bash
make
```

**Run (QEMU)**

```bash
make run
```

**Clean**

```bash
make clean
```

**License**

MIT License.
See [LICENSE](LICENSE) file.
