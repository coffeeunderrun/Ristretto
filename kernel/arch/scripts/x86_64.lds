OUTPUT_FORMAT(elf64-x86-64)
ENTRY(_entry)

PHDRS {
  limine_requests PT_LOAD;
  text PT_LOAD;
  rodata PT_LOAD;
  data PT_LOAD;
}

SECTIONS {
  . = 0xFFFFFFFF80000000;

  _kernel_start = .;

  .limine_requests : {
    _kernel_limine_start = .;
    KEEP(*(.data.*_limine_request_*))
    _kernel_limine_end = .;
  } :limine_requests

  .text BLOCK(CONSTANT(MAXPAGESIZE)) : {
    _kernel_text_start = .;
    *(.text .text.*)
    _kernel_text_end = .;
  } :text

  .rodata BLOCK(CONSTANT(MAXPAGESIZE)) : {
    _kernel_rodata_start = .;
    *(.rodata .rodata.*)
    *(.note.gnu.build-id)
    _kernel_rodata_end = .;
  } :rodata

  .driver BLOCK(CONSTANT(MAXPAGESIZE)) : {
    _driver_start = .;
    *(.data.*_driver_*)
    _driver_end = .;
  } :data

  .data BLOCK(CONSTANT(MAXPAGESIZE)) : {
    _kernel_data_start = .;
    *(.data .data.*)
    _kernel_data_end = .;
  } :data

  .bss BLOCK(CONSTANT(MAXPAGESIZE)) : {
    _kernel_bss_start = .;
    *(.bss .bss.*)
    _kernel_bss_end = .;
  } :data

  _kernel_end = .;

  /DISCARD/ : {
    *(.comment)
    *(.note .note.*)
  }
}
