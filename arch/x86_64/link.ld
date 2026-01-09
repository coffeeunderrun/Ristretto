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

  .limine_requests : {
    KEEP(*(.data.*_limine_request_*))
  } :limine_requests

  .text BLOCK(CONSTANT(MAXPAGESIZE)) : {
    *(.text .text.*)
  } :text

  .rodata BLOCK(CONSTANT(MAXPAGESIZE)) : {
    *(.rodata .rodata.*)
  } :rodata

  .data BLOCK(CONSTANT(MAXPAGESIZE)) : {
    *(.data .data.*)
  } :data

  .bss BLOCK(CONSTANT(MAXPAGESIZE)) : {
    *(.bss .bss.*)
  } :data

  /DISCARD/ :
  {
    *(.comment)
    *(.note .note.*)
  }
}
