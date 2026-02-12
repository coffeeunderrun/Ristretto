# Ristretto

Ristretto is a 64-bit hobby operating system kernel written in Pascal.

Currently targets x86_64, but additional architecture support is planned.

Uses `Limine Bootloader` with `Limine Boot Protocol` support.

Barebones `uACPI` bindings with full support in progress.

## Dependencies

`fpc`
`make`
`git`
`qemu`

`nasm`
(build x86_64; might remove in favor of FPC asm)

`gcc`
(build uACPI, link kernel)

`curl`
`gunzip`
`tar`
(download external dependencies, e.g., OVFM)

`xorriso`
(build ISO)

`coreutils`
`mtools`
(build HDD image)

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
