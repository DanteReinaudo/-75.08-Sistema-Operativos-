
obj/boot/boot.out:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1         # protected mode enable flag

.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64 7c 0f             	fs jl  7c33 <protcseg+0x1>
  movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
  orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call bootmain
    7c45:	e8 28 01 00 00       	call   7d72 <bootmain>

00007c4a <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00                   	.byte 0x0
    7c61:	92                   	xchg   %eax,%edx
    7c62:	cf                   	iret   
	...

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
	...

00007c6a <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
    7c6a:	89 c1                	mov    %eax,%ecx
    7c6c:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c6e:	89 ca                	mov    %ecx,%edx
    7c70:	ee                   	out    %al,(%dx)
}
    7c71:	c3                   	ret    

00007c72 <outw.constprop.0>:
}

static inline void
outw(int port, uint16_t data)
{
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7c72:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7c77:	66 ef                	out    %ax,(%dx)
}
    7c79:	c3                   	ret    

00007c7a <insl.constprop.0>:
insl(int port, void *addr, int cnt)
    7c7a:	55                   	push   %ebp
	asm volatile("cld\n\trepne\n\tinsl"
    7c7b:	b9 80 00 00 00       	mov    $0x80,%ecx
    7c80:	ba f0 01 00 00       	mov    $0x1f0,%edx
insl(int port, void *addr, int cnt)
    7c85:	89 e5                	mov    %esp,%ebp
    7c87:	57                   	push   %edi
	asm volatile("cld\n\trepne\n\tinsl"
    7c88:	89 c7                	mov    %eax,%edi
    7c8a:	fc                   	cld    
    7c8b:	f2 6d                	repnz insl (%dx),%es:(%edi)
}
    7c8d:	5f                   	pop    %edi
    7c8e:	5d                   	pop    %ebp
    7c8f:	c3                   	ret    

00007c90 <inb.constprop.0>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c90:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c95:	ec                   	in     (%dx),%al
}
    7c96:	c3                   	ret    

00007c97 <waitdisk>:
	}
}

void
waitdisk(void)
{
    7c97:	f3 0f 1e fb          	endbr32 
    7c9b:	55                   	push   %ebp
    7c9c:	89 e5                	mov    %esp,%ebp
    7c9e:	83 ec 08             	sub    $0x8,%esp
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7ca1:	e8 ea ff ff ff       	call   7c90 <inb.constprop.0>
    7ca6:	83 e0 c0             	and    $0xffffffc0,%eax
    7ca9:	3c 40                	cmp    $0x40,%al
    7cab:	75 f4                	jne    7ca1 <waitdisk+0xa>
		/* do nothing */;
}
    7cad:	c9                   	leave  
    7cae:	c3                   	ret    

00007caf <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7caf:	f3 0f 1e fb          	endbr32 
    7cb3:	55                   	push   %ebp
    7cb4:	89 e5                	mov    %esp,%ebp
    7cb6:	56                   	push   %esi
    7cb7:	53                   	push   %ebx
    7cb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7cbb:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for disk to be ready
	waitdisk();
    7cbe:	e8 d4 ff ff ff       	call   7c97 <waitdisk>

	outb(0x1F2, 1);		// count = 1
    7cc3:	ba 01 00 00 00       	mov    $0x1,%edx
    7cc8:	b8 f2 01 00 00       	mov    $0x1f2,%eax
    7ccd:	e8 98 ff ff ff       	call   7c6a <outb>
	outb(0x1F3, offset);
    7cd2:	0f b6 d3             	movzbl %bl,%edx
    7cd5:	b8 f3 01 00 00       	mov    $0x1f3,%eax
    7cda:	e8 8b ff ff ff       	call   7c6a <outb>
	outb(0x1F4, offset >> 8);
    7cdf:	0f b6 d7             	movzbl %bh,%edx
    7ce2:	b8 f4 01 00 00       	mov    $0x1f4,%eax
    7ce7:	e8 7e ff ff ff       	call   7c6a <outb>
	outb(0x1F5, offset >> 16);
    7cec:	89 da                	mov    %ebx,%edx
	outb(0x1F6, (offset >> 24) | 0xE0);
    7cee:	c1 eb 18             	shr    $0x18,%ebx
	outb(0x1F5, offset >> 16);
    7cf1:	b8 f5 01 00 00       	mov    $0x1f5,%eax
    7cf6:	c1 ea 10             	shr    $0x10,%edx
	outb(0x1F6, (offset >> 24) | 0xE0);
    7cf9:	83 cb e0             	or     $0xffffffe0,%ebx
	outb(0x1F5, offset >> 16);
    7cfc:	0f b6 d2             	movzbl %dl,%edx
    7cff:	e8 66 ff ff ff       	call   7c6a <outb>
	outb(0x1F6, (offset >> 24) | 0xE0);
    7d04:	0f b6 d3             	movzbl %bl,%edx
    7d07:	b8 f6 01 00 00       	mov    $0x1f6,%eax
    7d0c:	e8 59 ff ff ff       	call   7c6a <outb>
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors
    7d11:	b8 f7 01 00 00       	mov    $0x1f7,%eax
    7d16:	ba 20 00 00 00       	mov    $0x20,%edx
    7d1b:	e8 4a ff ff ff       	call   7c6a <outb>

	// wait for disk to be ready
	waitdisk();
    7d20:	e8 72 ff ff ff       	call   7c97 <waitdisk>

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7d25:	5b                   	pop    %ebx
	insl(0x1F0, dst, SECTSIZE/4);
    7d26:	89 f0                	mov    %esi,%eax
}
    7d28:	5e                   	pop    %esi
    7d29:	5d                   	pop    %ebp
	insl(0x1F0, dst, SECTSIZE/4);
    7d2a:	e9 4b ff ff ff       	jmp    7c7a <insl.constprop.0>

00007d2f <readseg>:
{
    7d2f:	f3 0f 1e fb          	endbr32 
    7d33:	55                   	push   %ebp
    7d34:	89 e5                	mov    %esp,%ebp
    7d36:	57                   	push   %edi
    7d37:	56                   	push   %esi
    7d38:	53                   	push   %ebx
    7d39:	83 ec 0c             	sub    $0xc,%esp
	offset = (offset / SECTSIZE) + 1;
    7d3c:	8b 7d 10             	mov    0x10(%ebp),%edi
{
    7d3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	end_pa = pa + count;
    7d42:	8b 75 0c             	mov    0xc(%ebp),%esi
	offset = (offset / SECTSIZE) + 1;
    7d45:	c1 ef 09             	shr    $0x9,%edi
	end_pa = pa + count;
    7d48:	01 de                	add    %ebx,%esi
	offset = (offset / SECTSIZE) + 1;
    7d4a:	47                   	inc    %edi
	pa &= ~(SECTSIZE - 1);
    7d4b:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	while (pa < end_pa) {
    7d51:	39 f3                	cmp    %esi,%ebx
    7d53:	73 15                	jae    7d6a <readseg+0x3b>
		readsect((uint8_t*) pa, offset);
    7d55:	50                   	push   %eax
    7d56:	50                   	push   %eax
    7d57:	57                   	push   %edi
		offset++;
    7d58:	47                   	inc    %edi
		readsect((uint8_t*) pa, offset);
    7d59:	53                   	push   %ebx
		pa += SECTSIZE;
    7d5a:	81 c3 00 02 00 00    	add    $0x200,%ebx
		readsect((uint8_t*) pa, offset);
    7d60:	e8 4a ff ff ff       	call   7caf <readsect>
		offset++;
    7d65:	83 c4 10             	add    $0x10,%esp
    7d68:	eb e7                	jmp    7d51 <readseg+0x22>
}
    7d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d6d:	5b                   	pop    %ebx
    7d6e:	5e                   	pop    %esi
    7d6f:	5f                   	pop    %edi
    7d70:	5d                   	pop    %ebp
    7d71:	c3                   	ret    

00007d72 <bootmain>:
{
    7d72:	f3 0f 1e fb          	endbr32 
    7d76:	55                   	push   %ebp
    7d77:	89 e5                	mov    %esp,%ebp
    7d79:	56                   	push   %esi
    7d7a:	53                   	push   %ebx
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d7b:	52                   	push   %edx
    7d7c:	6a 00                	push   $0x0
    7d7e:	68 00 10 00 00       	push   $0x1000
    7d83:	68 00 00 01 00       	push   $0x10000
    7d88:	e8 a2 ff ff ff       	call   7d2f <readseg>
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d8d:	83 c4 10             	add    $0x10,%esp
    7d90:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d97:	45 4c 46 
    7d9a:	75 38                	jne    7dd4 <bootmain+0x62>
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d9c:	a1 1c 00 01 00       	mov    0x1001c,%eax
	eph = ph + ELFHDR->e_phnum;
    7da1:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7da8:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    7dae:	c1 e6 05             	shl    $0x5,%esi
    7db1:	01 de                	add    %ebx,%esi
	for (; ph < eph; ph++)
    7db3:	39 f3                	cmp    %esi,%ebx
    7db5:	73 17                	jae    7dce <bootmain+0x5c>
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7db7:	50                   	push   %eax
	for (; ph < eph; ph++)
    7db8:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7dbb:	ff 73 e4             	pushl  -0x1c(%ebx)
    7dbe:	ff 73 f4             	pushl  -0xc(%ebx)
    7dc1:	ff 73 ec             	pushl  -0x14(%ebx)
    7dc4:	e8 66 ff ff ff       	call   7d2f <readseg>
	for (; ph < eph; ph++)
    7dc9:	83 c4 10             	add    $0x10,%esp
    7dcc:	eb e5                	jmp    7db3 <bootmain+0x41>
	((void (*)(void)) (ELFHDR->e_entry))();
    7dce:	ff 15 18 00 01 00    	call   *0x10018
	outw(0x8A00, 0x8A00);
    7dd4:	b8 00 8a 00 00       	mov    $0x8a00,%eax
    7dd9:	e8 94 fe ff ff       	call   7c72 <outw.constprop.0>
	outw(0x8A00, 0x8E00);
    7dde:	b8 00 8e 00 00       	mov    $0x8e00,%eax
    7de3:	e8 8a fe ff ff       	call   7c72 <outw.constprop.0>
    7de8:	eb fe                	jmp    7de8 <bootmain+0x76>
