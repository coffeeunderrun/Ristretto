# Ristretto

Ristretto is a 64-bit hobby operating system kernel written in Pascal.

Currently targets x86_64, but additional architecture support is planned.

Uses `Limine Bootloader` with `Limine Boot Protocol` support.

Barebones `uACPI` bindings with full support in progress.

## Dependencies

### Build
`fpc` Free Pascal compiler

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
make img
```

## Run

```bash
make run
```

```bash
make run-img
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
