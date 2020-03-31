// File taken from: https://wiki.osdev.org/Bare_Bones#Testing_your_operating_system_.28QEMU.29
.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

// Multiboot header
.section multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

// Stack setup
.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp
    call kmain

    // Do nothing, the kernel is over
    cli
1:  hlt
    jmp 1

.size _start, . - _start

