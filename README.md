# Ristretto

Ristretto is a 64-bit hobby operating system kernel written in Pascal.

It currently targets x86_64 (support for additional architectures is planned) and uses the Limine bootloader.

## Required

### Build
`fpc` Free Pascal compiler

`fpcdep` [Free Pascal dependency generator](https://codeberg.org/coffeeunderrun/fpcdep)

`gcc` or `clang` C cross-compiler

`nasm`
`curl`
`gunzip`
`tar`
`make`
`git`

### Run (w/ QEMU)
`coreutils`
`mtools`
`qemu`

### Generate ISO
`xorriso`

## Build

```bash
make
```

```bash
make all-iso
```

## Run (w/ QEMU)

```bash
make run
```

```bash
make run-iso
```

## Clean

```bash
make clean
```

```bash
make distclean
```

## License

MIT License.
See [LICENSE](LICENSE) file.
