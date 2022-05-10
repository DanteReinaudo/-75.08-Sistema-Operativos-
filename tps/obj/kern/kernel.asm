
obj/kern/kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

f0100000 <_start+0xeffffff4>:
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
_start = RELOC(entry)

.globl entry
.func entry
entry:
	movw	$0x1234,0x472			# warm boot
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3

	# Turn on large paging.
	movl	%cr4, %eax
f010001d:	0f 20 e0             	mov    %cr4,%eax
	orl	$(CR4_PSE), %eax
f0100020:	83 c8 10             	or     $0x10,%eax
	movl	%eax, %cr4
f0100023:	0f 22 e0             	mov    %eax,%cr4

	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100031:	b8 38 00 10 f0       	mov    $0xf0100038,%eax
	jmp	*%eax
f0100036:	ff e0                	jmp    *%eax

f0100038 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f0100038:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f010003d:	bc 00 10 12 f0       	mov    $0xf0121000,%esp

	# now to C code
	call	i386_init
f0100042:	e8 83 01 00 00       	call   f01001ca <i386_init>

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>

f0100049 <lcr3>:
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100049:	0f 22 d8             	mov    %eax,%cr3
}
f010004c:	c3                   	ret    

f010004d <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f010004d:	89 c1                	mov    %eax,%ecx
f010004f:	89 d0                	mov    %edx,%eax
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100051:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f0100054:	c3                   	ret    

f0100055 <lock_kernel>:

extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
f0100055:	55                   	push   %ebp
f0100056:	89 e5                	mov    %esp,%ebp
f0100058:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f010005b:	68 c0 23 12 f0       	push   $0xf01223c0
f0100060:	e8 e0 60 00 00       	call   f0106145 <spin_lock>
}
f0100065:	83 c4 10             	add    $0x10,%esp
f0100068:	c9                   	leave  
f0100069:	c3                   	ret    

f010006a <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
f010006a:	f3 0f 1e fb          	endbr32 
f010006e:	55                   	push   %ebp
f010006f:	89 e5                	mov    %esp,%ebp
f0100071:	56                   	push   %esi
f0100072:	53                   	push   %ebx
f0100073:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100076:	83 3d 80 2e 22 f0 00 	cmpl   $0x0,0xf0222e80
f010007d:	74 0f                	je     f010008e <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010007f:	83 ec 0c             	sub    $0xc,%esp
f0100082:	6a 00                	push   $0x0
f0100084:	e8 ea 0a 00 00       	call   f0100b73 <monitor>
f0100089:	83 c4 10             	add    $0x10,%esp
f010008c:	eb f1                	jmp    f010007f <_panic+0x15>
	panicstr = fmt;
f010008e:	89 35 80 2e 22 f0    	mov    %esi,0xf0222e80
	asm volatile("cli; cld");
f0100094:	fa                   	cli    
f0100095:	fc                   	cld    
	va_start(ap, fmt);
f0100096:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf(">>>\n>>> kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100099:	e8 a2 5d 00 00       	call   f0105e40 <cpunum>
f010009e:	ff 75 0c             	pushl  0xc(%ebp)
f01000a1:	ff 75 08             	pushl  0x8(%ebp)
f01000a4:	50                   	push   %eax
f01000a5:	68 00 65 10 f0       	push   $0xf0106500
f01000aa:	e8 0d 39 00 00       	call   f01039bc <cprintf>
	vcprintf(fmt, ap);
f01000af:	83 c4 08             	add    $0x8,%esp
f01000b2:	53                   	push   %ebx
f01000b3:	56                   	push   %esi
f01000b4:	e8 d9 38 00 00       	call   f0103992 <vcprintf>
	cprintf("\n>>>\n");
f01000b9:	c7 04 24 74 65 10 f0 	movl   $0xf0106574,(%esp)
f01000c0:	e8 f7 38 00 00       	call   f01039bc <cprintf>
f01000c5:	83 c4 10             	add    $0x10,%esp
f01000c8:	eb b5                	jmp    f010007f <_panic+0x15>

f01000ca <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f01000ca:	55                   	push   %ebp
f01000cb:	89 e5                	mov    %esp,%ebp
f01000cd:	53                   	push   %ebx
f01000ce:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f01000d1:	89 cb                	mov    %ecx,%ebx
f01000d3:	c1 eb 0c             	shr    $0xc,%ebx
f01000d6:	3b 1d 88 2e 22 f0    	cmp    0xf0222e88,%ebx
f01000dc:	73 0b                	jae    f01000e9 <_kaddr+0x1f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
	return (void *)(pa + KERNBASE);
f01000de:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f01000e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01000e7:	c9                   	leave  
f01000e8:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01000e9:	51                   	push   %ecx
f01000ea:	68 2c 65 10 f0       	push   $0xf010652c
f01000ef:	52                   	push   %edx
f01000f0:	50                   	push   %eax
f01000f1:	e8 74 ff ff ff       	call   f010006a <_panic>

f01000f6 <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f01000f6:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01000fc:	76 07                	jbe    f0100105 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f01000fe:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100104:	c3                   	ret    
{
f0100105:	55                   	push   %ebp
f0100106:	89 e5                	mov    %esp,%ebp
f0100108:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010010b:	51                   	push   %ecx
f010010c:	68 50 65 10 f0       	push   $0xf0106550
f0100111:	52                   	push   %edx
f0100112:	50                   	push   %eax
f0100113:	e8 52 ff ff ff       	call   f010006a <_panic>

f0100118 <boot_aps>:
{
f0100118:	55                   	push   %ebp
f0100119:	89 e5                	mov    %esp,%ebp
f010011b:	56                   	push   %esi
f010011c:	53                   	push   %ebx
	code = KADDR(MPENTRY_PADDR);
f010011d:	b9 00 70 00 00       	mov    $0x7000,%ecx
f0100122:	ba 62 00 00 00       	mov    $0x62,%edx
f0100127:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f010012c:	e8 99 ff ff ff       	call   f01000ca <_kaddr>
f0100131:	89 c6                	mov    %eax,%esi
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100133:	83 ec 04             	sub    $0x4,%esp
f0100136:	b8 3e 5a 10 f0       	mov    $0xf0105a3e,%eax
f010013b:	2d bc 59 10 f0       	sub    $0xf01059bc,%eax
f0100140:	50                   	push   %eax
f0100141:	68 bc 59 10 f0       	push   $0xf01059bc
f0100146:	56                   	push   %esi
f0100147:	e8 b4 56 00 00       	call   f0105800 <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f010014c:	83 c4 10             	add    $0x10,%esp
f010014f:	bb 20 30 22 f0       	mov    $0xf0223020,%ebx
f0100154:	eb 4a                	jmp    f01001a0 <boot_aps+0x88>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100156:	89 d8                	mov    %ebx,%eax
f0100158:	2d 20 30 22 f0       	sub    $0xf0223020,%eax
f010015d:	c1 f8 02             	sar    $0x2,%eax
f0100160:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100166:	c1 e0 0f             	shl    $0xf,%eax
f0100169:	8d 80 00 c0 22 f0    	lea    -0xfdd4000(%eax),%eax
f010016f:	a3 84 2e 22 f0       	mov    %eax,0xf0222e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100174:	89 f1                	mov    %esi,%ecx
f0100176:	ba 6d 00 00 00       	mov    $0x6d,%edx
f010017b:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f0100180:	e8 71 ff ff ff       	call   f01000f6 <_paddr>
f0100185:	83 ec 08             	sub    $0x8,%esp
f0100188:	50                   	push   %eax
f0100189:	0f b6 03             	movzbl (%ebx),%eax
f010018c:	50                   	push   %eax
f010018d:	e8 22 5e 00 00       	call   f0105fb4 <lapic_startap>
		while (c->cpu_status != CPU_STARTED)
f0100192:	83 c4 10             	add    $0x10,%esp
f0100195:	8b 43 04             	mov    0x4(%ebx),%eax
f0100198:	83 f8 01             	cmp    $0x1,%eax
f010019b:	75 f8                	jne    f0100195 <boot_aps+0x7d>
	for (c = cpus; c < cpus + ncpu; c++) {
f010019d:	83 c3 74             	add    $0x74,%ebx
f01001a0:	6b 05 c4 33 22 f0 74 	imul   $0x74,0xf02233c4,%eax
f01001a7:	05 20 30 22 f0       	add    $0xf0223020,%eax
f01001ac:	39 c3                	cmp    %eax,%ebx
f01001ae:	73 13                	jae    f01001c3 <boot_aps+0xab>
		if (c == cpus + cpunum())  // We've started already.
f01001b0:	e8 8b 5c 00 00       	call   f0105e40 <cpunum>
f01001b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01001b8:	05 20 30 22 f0       	add    $0xf0223020,%eax
f01001bd:	39 c3                	cmp    %eax,%ebx
f01001bf:	74 dc                	je     f010019d <boot_aps+0x85>
f01001c1:	eb 93                	jmp    f0100156 <boot_aps+0x3e>
}
f01001c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01001c6:	5b                   	pop    %ebx
f01001c7:	5e                   	pop    %esi
f01001c8:	5d                   	pop    %ebp
f01001c9:	c3                   	ret    

f01001ca <i386_init>:
{
f01001ca:	f3 0f 1e fb          	endbr32 
f01001ce:	55                   	push   %ebp
f01001cf:	89 e5                	mov    %esp,%ebp
f01001d1:	83 ec 0c             	sub    $0xc,%esp
	memset(__bss_start, 0, end - __bss_start);
f01001d4:	b8 08 40 26 f0       	mov    $0xf0264008,%eax
f01001d9:	2d 00 10 22 f0       	sub    $0xf0221000,%eax
f01001de:	50                   	push   %eax
f01001df:	6a 00                	push   $0x0
f01001e1:	68 00 10 22 f0       	push   $0xf0221000
f01001e6:	e8 c7 55 00 00       	call   f01057b2 <memset>
	cons_init();
f01001eb:	e8 1a 07 00 00       	call   f010090a <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01001f0:	83 c4 08             	add    $0x8,%esp
f01001f3:	68 ac 1a 00 00       	push   $0x1aac
f01001f8:	68 86 65 10 f0       	push   $0xf0106586
f01001fd:	e8 ba 37 00 00       	call   f01039bc <cprintf>
	mem_init();
f0100202:	e8 cf 2a 00 00       	call   f0102cd6 <mem_init>
	env_init();
f0100207:	e8 03 31 00 00       	call   f010330f <env_init>
	trap_init();
f010020c:	e8 af 38 00 00       	call   f0103ac0 <trap_init>
	mp_init();
f0100211:	e8 6d 5a 00 00       	call   f0105c83 <mp_init>
	lapic_init();
f0100216:	e8 3f 5c 00 00       	call   f0105e5a <lapic_init>
	pic_init();
f010021b:	e8 4e 36 00 00       	call   f010386e <pic_init>
	lock_kernel();
f0100220:	e8 30 fe ff ff       	call   f0100055 <lock_kernel>
	boot_aps();
f0100225:	e8 ee fe ff ff       	call   f0100118 <boot_aps>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010022a:	83 c4 08             	add    $0x8,%esp
f010022d:	6a 01                	push   $0x1
f010022f:	68 cc d2 1d f0       	push   $0xf01dd2cc
f0100234:	e8 2b 32 00 00       	call   f0103464 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100239:	83 c4 08             	add    $0x8,%esp
f010023c:	6a 00                	push   $0x0
f010023e:	68 38 07 21 f0       	push   $0xf0210738
f0100243:	e8 1c 32 00 00       	call   f0103464 <env_create>
	kbd_intr();
f0100248:	e8 3c 06 00 00       	call   f0100889 <kbd_intr>
	sched_yield();
f010024d:	e8 c7 42 00 00       	call   f0104519 <sched_yield>

f0100252 <mp_main>:
{
f0100252:	f3 0f 1e fb          	endbr32 
f0100256:	55                   	push   %ebp
f0100257:	89 e5                	mov    %esp,%ebp
f0100259:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f010025c:	8b 0d 8c 2e 22 f0    	mov    0xf0222e8c,%ecx
f0100262:	ba 79 00 00 00       	mov    $0x79,%edx
f0100267:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f010026c:	e8 85 fe ff ff       	call   f01000f6 <_paddr>
f0100271:	e8 d3 fd ff ff       	call   f0100049 <lcr3>
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100276:	e8 c5 5b 00 00       	call   f0105e40 <cpunum>
f010027b:	83 ec 08             	sub    $0x8,%esp
f010027e:	50                   	push   %eax
f010027f:	68 a1 65 10 f0       	push   $0xf01065a1
f0100284:	e8 33 37 00 00       	call   f01039bc <cprintf>
	lapic_init();
f0100289:	e8 cc 5b 00 00       	call   f0105e5a <lapic_init>
	env_init_percpu();
f010028e:	e8 41 30 00 00       	call   f01032d4 <env_init_percpu>
	trap_init_percpu();
f0100293:	e8 96 37 00 00       	call   f0103a2e <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED);  // tell boot_aps() we're up
f0100298:	e8 a3 5b 00 00       	call   f0105e40 <cpunum>
f010029d:	6b c0 74             	imul   $0x74,%eax,%eax
f01002a0:	05 24 30 22 f0       	add    $0xf0223024,%eax
f01002a5:	ba 01 00 00 00       	mov    $0x1,%edx
f01002aa:	e8 9e fd ff ff       	call   f010004d <xchg>
	lock_kernel();
f01002af:	e8 a1 fd ff ff       	call   f0100055 <lock_kernel>
	sched_yield();
f01002b4:	e8 60 42 00 00       	call   f0104519 <sched_yield>

f01002b9 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...)
{
f01002b9:	f3 0f 1e fb          	endbr32 
f01002bd:	55                   	push   %ebp
f01002be:	89 e5                	mov    %esp,%ebp
f01002c0:	53                   	push   %ebx
f01002c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002c4:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002c7:	ff 75 0c             	pushl  0xc(%ebp)
f01002ca:	ff 75 08             	pushl  0x8(%ebp)
f01002cd:	68 b7 65 10 f0       	push   $0xf01065b7
f01002d2:	e8 e5 36 00 00       	call   f01039bc <cprintf>
	vcprintf(fmt, ap);
f01002d7:	83 c4 08             	add    $0x8,%esp
f01002da:	53                   	push   %ebx
f01002db:	ff 75 10             	pushl  0x10(%ebp)
f01002de:	e8 af 36 00 00       	call   f0103992 <vcprintf>
	cprintf("\n");
f01002e3:	c7 04 24 3b 77 10 f0 	movl   $0xf010773b,(%esp)
f01002ea:	e8 cd 36 00 00       	call   f01039bc <cprintf>
	va_end(ap);
}
f01002ef:	83 c4 10             	add    $0x10,%esp
f01002f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002f5:	c9                   	leave  
f01002f6:	c3                   	ret    

f01002f7 <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002f7:	89 c2                	mov    %eax,%edx
f01002f9:	ec                   	in     (%dx),%al
}
f01002fa:	c3                   	ret    

f01002fb <outb>:
{
f01002fb:	89 c1                	mov    %eax,%ecx
f01002fd:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002ff:	89 ca                	mov    %ecx,%edx
f0100301:	ee                   	out    %al,(%dx)
}
f0100302:	c3                   	ret    

f0100303 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100303:	55                   	push   %ebp
f0100304:	89 e5                	mov    %esp,%ebp
f0100306:	83 ec 08             	sub    $0x8,%esp
	inb(0x84);
f0100309:	b8 84 00 00 00       	mov    $0x84,%eax
f010030e:	e8 e4 ff ff ff       	call   f01002f7 <inb>
	inb(0x84);
f0100313:	b8 84 00 00 00       	mov    $0x84,%eax
f0100318:	e8 da ff ff ff       	call   f01002f7 <inb>
	inb(0x84);
f010031d:	b8 84 00 00 00       	mov    $0x84,%eax
f0100322:	e8 d0 ff ff ff       	call   f01002f7 <inb>
	inb(0x84);
f0100327:	b8 84 00 00 00       	mov    $0x84,%eax
f010032c:	e8 c6 ff ff ff       	call   f01002f7 <inb>
}
f0100331:	c9                   	leave  
f0100332:	c3                   	ret    

f0100333 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100333:	f3 0f 1e fb          	endbr32 
f0100337:	55                   	push   %ebp
f0100338:	89 e5                	mov    %esp,%ebp
f010033a:	83 ec 08             	sub    $0x8,%esp
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010033d:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100342:	e8 b0 ff ff ff       	call   f01002f7 <inb>
f0100347:	a8 01                	test   $0x1,%al
f0100349:	74 0f                	je     f010035a <serial_proc_data+0x27>
		return -1;
	return inb(COM1+COM_RX);
f010034b:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100350:	e8 a2 ff ff ff       	call   f01002f7 <inb>
f0100355:	0f b6 c0             	movzbl %al,%eax
}
f0100358:	c9                   	leave  
f0100359:	c3                   	ret    
		return -1;
f010035a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010035f:	eb f7                	jmp    f0100358 <serial_proc_data+0x25>

f0100361 <serial_putc>:
		cons_intr(serial_proc_data);
}

static void
serial_putc(int c)
{
f0100361:	55                   	push   %ebp
f0100362:	89 e5                	mov    %esp,%ebp
f0100364:	56                   	push   %esi
f0100365:	53                   	push   %ebx
f0100366:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0;
f0100368:	bb 00 00 00 00       	mov    $0x0,%ebx
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010036d:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100372:	e8 80 ff ff ff       	call   f01002f7 <inb>
f0100377:	a8 20                	test   $0x20,%al
f0100379:	75 12                	jne    f010038d <serial_putc+0x2c>
f010037b:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100381:	7f 0a                	jg     f010038d <serial_putc+0x2c>
	     i++)
		delay();
f0100383:	e8 7b ff ff ff       	call   f0100303 <delay>
	     i++)
f0100388:	83 c3 01             	add    $0x1,%ebx
f010038b:	eb e0                	jmp    f010036d <serial_putc+0xc>

	outb(COM1 + COM_TX, c);
f010038d:	89 f0                	mov    %esi,%eax
f010038f:	0f b6 d0             	movzbl %al,%edx
f0100392:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100397:	e8 5f ff ff ff       	call   f01002fb <outb>
}
f010039c:	5b                   	pop    %ebx
f010039d:	5e                   	pop    %esi
f010039e:	5d                   	pop    %ebp
f010039f:	c3                   	ret    

f01003a0 <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f01003a0:	55                   	push   %ebp
f01003a1:	89 e5                	mov    %esp,%ebp
f01003a3:	56                   	push   %esi
f01003a4:	53                   	push   %ebx
f01003a5:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003a7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003ac:	b8 79 03 00 00       	mov    $0x379,%eax
f01003b1:	e8 41 ff ff ff       	call   f01002f7 <inb>
f01003b6:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01003bc:	7f 0e                	jg     f01003cc <lpt_putc+0x2c>
f01003be:	84 c0                	test   %al,%al
f01003c0:	78 0a                	js     f01003cc <lpt_putc+0x2c>
		delay();
f01003c2:	e8 3c ff ff ff       	call   f0100303 <delay>
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003c7:	83 c3 01             	add    $0x1,%ebx
f01003ca:	eb e0                	jmp    f01003ac <lpt_putc+0xc>
	outb(0x378+0, c);
f01003cc:	89 f0                	mov    %esi,%eax
f01003ce:	0f b6 d0             	movzbl %al,%edx
f01003d1:	b8 78 03 00 00       	mov    $0x378,%eax
f01003d6:	e8 20 ff ff ff       	call   f01002fb <outb>
	outb(0x378+2, 0x08|0x04|0x01);
f01003db:	ba 0d 00 00 00       	mov    $0xd,%edx
f01003e0:	b8 7a 03 00 00       	mov    $0x37a,%eax
f01003e5:	e8 11 ff ff ff       	call   f01002fb <outb>
	outb(0x378+2, 0x08);
f01003ea:	ba 08 00 00 00       	mov    $0x8,%edx
f01003ef:	b8 7a 03 00 00       	mov    $0x37a,%eax
f01003f4:	e8 02 ff ff ff       	call   f01002fb <outb>
}
f01003f9:	5b                   	pop    %ebx
f01003fa:	5e                   	pop    %esi
f01003fb:	5d                   	pop    %ebp
f01003fc:	c3                   	ret    

f01003fd <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f01003fd:	55                   	push   %ebp
f01003fe:	89 e5                	mov    %esp,%ebp
f0100400:	57                   	push   %edi
f0100401:	56                   	push   %esi
f0100402:	53                   	push   %ebx
f0100403:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f0100406:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010040d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100414:	5a a5 
	if (*cp != 0xA55A) {
f0100416:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010041d:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100421:	74 63                	je     f0100486 <cga_init+0x89>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f0100423:	c7 05 30 12 22 f0 b4 	movl   $0x3b4,0xf0221230
f010042a:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010042d:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f0100434:	8b 35 30 12 22 f0    	mov    0xf0221230,%esi
f010043a:	ba 0e 00 00 00       	mov    $0xe,%edx
f010043f:	89 f0                	mov    %esi,%eax
f0100441:	e8 b5 fe ff ff       	call   f01002fb <outb>
	pos = inb(addr_6845 + 1) << 8;
f0100446:	8d 7e 01             	lea    0x1(%esi),%edi
f0100449:	89 f8                	mov    %edi,%eax
f010044b:	e8 a7 fe ff ff       	call   f01002f7 <inb>
f0100450:	0f b6 d8             	movzbl %al,%ebx
f0100453:	c1 e3 08             	shl    $0x8,%ebx
	outb(addr_6845, 15);
f0100456:	ba 0f 00 00 00       	mov    $0xf,%edx
f010045b:	89 f0                	mov    %esi,%eax
f010045d:	e8 99 fe ff ff       	call   f01002fb <outb>
	pos |= inb(addr_6845 + 1);
f0100462:	89 f8                	mov    %edi,%eax
f0100464:	e8 8e fe ff ff       	call   f01002f7 <inb>

	crt_buf = (uint16_t*) cp;
f0100469:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010046c:	89 0d 2c 12 22 f0    	mov    %ecx,0xf022122c
	pos |= inb(addr_6845 + 1);
f0100472:	0f b6 c0             	movzbl %al,%eax
f0100475:	09 c3                	or     %eax,%ebx
	crt_pos = pos;
f0100477:	66 89 1d 28 12 22 f0 	mov    %bx,0xf0221228
}
f010047e:	83 c4 1c             	add    $0x1c,%esp
f0100481:	5b                   	pop    %ebx
f0100482:	5e                   	pop    %esi
f0100483:	5f                   	pop    %edi
f0100484:	5d                   	pop    %ebp
f0100485:	c3                   	ret    
		*cp = was;
f0100486:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010048d:	c7 05 30 12 22 f0 d4 	movl   $0x3d4,0xf0221230
f0100494:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100497:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f010049e:	eb 94                	jmp    f0100434 <cga_init+0x37>

f01004a0 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01004a0:	55                   	push   %ebp
f01004a1:	89 e5                	mov    %esp,%ebp
f01004a3:	53                   	push   %ebx
f01004a4:	83 ec 04             	sub    $0x4,%esp
f01004a7:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01004a9:	ff d3                	call   *%ebx
f01004ab:	83 f8 ff             	cmp    $0xffffffff,%eax
f01004ae:	74 29                	je     f01004d9 <cons_intr+0x39>
		if (c == 0)
f01004b0:	85 c0                	test   %eax,%eax
f01004b2:	74 f5                	je     f01004a9 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01004b4:	8b 0d 24 12 22 f0    	mov    0xf0221224,%ecx
f01004ba:	8d 51 01             	lea    0x1(%ecx),%edx
f01004bd:	88 81 20 10 22 f0    	mov    %al,-0xfddefe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01004c3:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01004c9:	b8 00 00 00 00       	mov    $0x0,%eax
f01004ce:	0f 44 d0             	cmove  %eax,%edx
f01004d1:	89 15 24 12 22 f0    	mov    %edx,0xf0221224
f01004d7:	eb d0                	jmp    f01004a9 <cons_intr+0x9>
	}
}
f01004d9:	83 c4 04             	add    $0x4,%esp
f01004dc:	5b                   	pop    %ebx
f01004dd:	5d                   	pop    %ebp
f01004de:	c3                   	ret    

f01004df <kbd_proc_data>:
{
f01004df:	f3 0f 1e fb          	endbr32 
f01004e3:	55                   	push   %ebp
f01004e4:	89 e5                	mov    %esp,%ebp
f01004e6:	53                   	push   %ebx
f01004e7:	83 ec 04             	sub    $0x4,%esp
	stat = inb(KBSTATP);
f01004ea:	b8 64 00 00 00       	mov    $0x64,%eax
f01004ef:	e8 03 fe ff ff       	call   f01002f7 <inb>
	if ((stat & KBS_DIB) == 0)
f01004f4:	a8 01                	test   $0x1,%al
f01004f6:	0f 84 f7 00 00 00    	je     f01005f3 <kbd_proc_data+0x114>
	if (stat & KBS_TERR)
f01004fc:	a8 20                	test   $0x20,%al
f01004fe:	0f 85 f6 00 00 00    	jne    f01005fa <kbd_proc_data+0x11b>
	data = inb(KBDATAP);
f0100504:	b8 60 00 00 00       	mov    $0x60,%eax
f0100509:	e8 e9 fd ff ff       	call   f01002f7 <inb>
	if (data == 0xE0) {
f010050e:	3c e0                	cmp    $0xe0,%al
f0100510:	74 61                	je     f0100573 <kbd_proc_data+0x94>
	} else if (data & 0x80) {
f0100512:	84 c0                	test   %al,%al
f0100514:	78 70                	js     f0100586 <kbd_proc_data+0xa7>
	} else if (shift & E0ESC) {
f0100516:	8b 15 00 10 22 f0    	mov    0xf0221000,%edx
f010051c:	f6 c2 40             	test   $0x40,%dl
f010051f:	74 0c                	je     f010052d <kbd_proc_data+0x4e>
		data |= 0x80;
f0100521:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f0100524:	83 e2 bf             	and    $0xffffffbf,%edx
f0100527:	89 15 00 10 22 f0    	mov    %edx,0xf0221000
	shift |= shiftcode[data];
f010052d:	0f b6 c0             	movzbl %al,%eax
f0100530:	0f b6 90 20 67 10 f0 	movzbl -0xfef98e0(%eax),%edx
f0100537:	0b 15 00 10 22 f0    	or     0xf0221000,%edx
	shift ^= togglecode[data];
f010053d:	0f b6 88 20 66 10 f0 	movzbl -0xfef99e0(%eax),%ecx
f0100544:	31 ca                	xor    %ecx,%edx
f0100546:	89 15 00 10 22 f0    	mov    %edx,0xf0221000
	c = charcode[shift & (CTL | SHIFT)][data];
f010054c:	89 d1                	mov    %edx,%ecx
f010054e:	83 e1 03             	and    $0x3,%ecx
f0100551:	8b 0c 8d 00 66 10 f0 	mov    -0xfef9a00(,%ecx,4),%ecx
f0100558:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
f010055c:	0f b6 d8             	movzbl %al,%ebx
	if (shift & CAPSLOCK) {
f010055f:	f6 c2 08             	test   $0x8,%dl
f0100562:	74 5f                	je     f01005c3 <kbd_proc_data+0xe4>
		if ('a' <= c && c <= 'z')
f0100564:	89 d8                	mov    %ebx,%eax
f0100566:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100569:	83 f9 19             	cmp    $0x19,%ecx
f010056c:	77 49                	ja     f01005b7 <kbd_proc_data+0xd8>
			c += 'A' - 'a';
f010056e:	83 eb 20             	sub    $0x20,%ebx
f0100571:	eb 0c                	jmp    f010057f <kbd_proc_data+0xa0>
		shift |= E0ESC;
f0100573:	83 0d 00 10 22 f0 40 	orl    $0x40,0xf0221000
		return 0;
f010057a:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010057f:	89 d8                	mov    %ebx,%eax
f0100581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100584:	c9                   	leave  
f0100585:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100586:	8b 15 00 10 22 f0    	mov    0xf0221000,%edx
f010058c:	89 c1                	mov    %eax,%ecx
f010058e:	83 e1 7f             	and    $0x7f,%ecx
f0100591:	f6 c2 40             	test   $0x40,%dl
f0100594:	0f 44 c1             	cmove  %ecx,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f0100597:	0f b6 c0             	movzbl %al,%eax
f010059a:	0f b6 80 20 67 10 f0 	movzbl -0xfef98e0(%eax),%eax
f01005a1:	83 c8 40             	or     $0x40,%eax
f01005a4:	0f b6 c0             	movzbl %al,%eax
f01005a7:	f7 d0                	not    %eax
f01005a9:	21 d0                	and    %edx,%eax
f01005ab:	a3 00 10 22 f0       	mov    %eax,0xf0221000
		return 0;
f01005b0:	bb 00 00 00 00       	mov    $0x0,%ebx
f01005b5:	eb c8                	jmp    f010057f <kbd_proc_data+0xa0>
		else if ('A' <= c && c <= 'Z')
f01005b7:	83 e8 41             	sub    $0x41,%eax
			c += 'a' - 'A';
f01005ba:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01005bd:	83 f8 1a             	cmp    $0x1a,%eax
f01005c0:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01005c3:	f7 d2                	not    %edx
f01005c5:	f6 c2 06             	test   $0x6,%dl
f01005c8:	75 b5                	jne    f010057f <kbd_proc_data+0xa0>
f01005ca:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01005d0:	75 ad                	jne    f010057f <kbd_proc_data+0xa0>
		cprintf("Rebooting!\n");
f01005d2:	83 ec 0c             	sub    $0xc,%esp
f01005d5:	68 d1 65 10 f0       	push   $0xf01065d1
f01005da:	e8 dd 33 00 00       	call   f01039bc <cprintf>
		outb(0x92, 0x3); // courtesy of Chris Frost
f01005df:	ba 03 00 00 00       	mov    $0x3,%edx
f01005e4:	b8 92 00 00 00       	mov    $0x92,%eax
f01005e9:	e8 0d fd ff ff       	call   f01002fb <outb>
f01005ee:	83 c4 10             	add    $0x10,%esp
f01005f1:	eb 8c                	jmp    f010057f <kbd_proc_data+0xa0>
		return -1;
f01005f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01005f8:	eb 85                	jmp    f010057f <kbd_proc_data+0xa0>
		return -1;
f01005fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01005ff:	e9 7b ff ff ff       	jmp    f010057f <kbd_proc_data+0xa0>

f0100604 <serial_init>:
{
f0100604:	55                   	push   %ebp
f0100605:	89 e5                	mov    %esp,%ebp
f0100607:	53                   	push   %ebx
f0100608:	83 ec 04             	sub    $0x4,%esp
	outb(COM1+COM_FCR, 0);
f010060b:	ba 00 00 00 00       	mov    $0x0,%edx
f0100610:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f0100615:	e8 e1 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_LCR, COM_LCR_DLAB);
f010061a:	ba 80 00 00 00       	mov    $0x80,%edx
f010061f:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f0100624:	e8 d2 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_DLL, (uint8_t) (115200 / 9600));
f0100629:	ba 0c 00 00 00       	mov    $0xc,%edx
f010062e:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100633:	e8 c3 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_DLM, 0);
f0100638:	ba 00 00 00 00       	mov    $0x0,%edx
f010063d:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f0100642:	e8 b4 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
f0100647:	ba 03 00 00 00       	mov    $0x3,%edx
f010064c:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f0100651:	e8 a5 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_MCR, 0);
f0100656:	ba 00 00 00 00       	mov    $0x0,%edx
f010065b:	b8 fc 03 00 00       	mov    $0x3fc,%eax
f0100660:	e8 96 fc ff ff       	call   f01002fb <outb>
	outb(COM1+COM_IER, COM_IER_RDI);
f0100665:	ba 01 00 00 00       	mov    $0x1,%edx
f010066a:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f010066f:	e8 87 fc ff ff       	call   f01002fb <outb>
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100674:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100679:	e8 79 fc ff ff       	call   f01002f7 <inb>
f010067e:	89 c3                	mov    %eax,%ebx
f0100680:	3c ff                	cmp    $0xff,%al
f0100682:	0f 95 05 34 12 22 f0 	setne  0xf0221234
	(void) inb(COM1+COM_IIR);
f0100689:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f010068e:	e8 64 fc ff ff       	call   f01002f7 <inb>
	(void) inb(COM1+COM_RX);
f0100693:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100698:	e8 5a fc ff ff       	call   f01002f7 <inb>
	if (serial_exists)
f010069d:	80 fb ff             	cmp    $0xff,%bl
f01006a0:	75 05                	jne    f01006a7 <serial_init+0xa3>
}
f01006a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01006a5:	c9                   	leave  
f01006a6:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f01006a7:	83 ec 0c             	sub    $0xc,%esp
f01006aa:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01006b1:	25 ef ff 00 00       	and    $0xffef,%eax
f01006b6:	50                   	push   %eax
f01006b7:	e8 25 31 00 00       	call   f01037e1 <irq_setmask_8259A>
f01006bc:	83 c4 10             	add    $0x10,%esp
}
f01006bf:	eb e1                	jmp    f01006a2 <serial_init+0x9e>

f01006c1 <cga_putc>:
{
f01006c1:	55                   	push   %ebp
f01006c2:	89 e5                	mov    %esp,%ebp
f01006c4:	57                   	push   %edi
f01006c5:	56                   	push   %esi
f01006c6:	53                   	push   %ebx
f01006c7:	83 ec 0c             	sub    $0xc,%esp
		c |= 0x0700;
f01006ca:	89 c2                	mov    %eax,%edx
f01006cc:	80 ce 07             	or     $0x7,%dh
f01006cf:	a9 00 ff ff ff       	test   $0xffffff00,%eax
f01006d4:	0f 44 c2             	cmove  %edx,%eax
	switch (c & 0xff) {
f01006d7:	3c 0a                	cmp    $0xa,%al
f01006d9:	0f 84 f0 00 00 00    	je     f01007cf <cga_putc+0x10e>
f01006df:	0f b6 d0             	movzbl %al,%edx
f01006e2:	83 fa 0a             	cmp    $0xa,%edx
f01006e5:	7f 46                	jg     f010072d <cga_putc+0x6c>
f01006e7:	83 fa 08             	cmp    $0x8,%edx
f01006ea:	0f 84 b5 00 00 00    	je     f01007a5 <cga_putc+0xe4>
f01006f0:	83 fa 09             	cmp    $0x9,%edx
f01006f3:	0f 85 e3 00 00 00    	jne    f01007dc <cga_putc+0x11b>
		cons_putc(' ');
f01006f9:	b8 20 00 00 00       	mov    $0x20,%eax
f01006fe:	e8 44 01 00 00       	call   f0100847 <cons_putc>
		cons_putc(' ');
f0100703:	b8 20 00 00 00       	mov    $0x20,%eax
f0100708:	e8 3a 01 00 00       	call   f0100847 <cons_putc>
		cons_putc(' ');
f010070d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100712:	e8 30 01 00 00       	call   f0100847 <cons_putc>
		cons_putc(' ');
f0100717:	b8 20 00 00 00       	mov    $0x20,%eax
f010071c:	e8 26 01 00 00       	call   f0100847 <cons_putc>
		cons_putc(' ');
f0100721:	b8 20 00 00 00       	mov    $0x20,%eax
f0100726:	e8 1c 01 00 00       	call   f0100847 <cons_putc>
		break;
f010072b:	eb 25                	jmp    f0100752 <cga_putc+0x91>
	switch (c & 0xff) {
f010072d:	83 fa 0d             	cmp    $0xd,%edx
f0100730:	0f 85 a6 00 00 00    	jne    f01007dc <cga_putc+0x11b>
		crt_pos -= (crt_pos % CRT_COLS);
f0100736:	0f b7 05 28 12 22 f0 	movzwl 0xf0221228,%eax
f010073d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100743:	c1 e8 16             	shr    $0x16,%eax
f0100746:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100749:	c1 e0 04             	shl    $0x4,%eax
f010074c:	66 a3 28 12 22 f0    	mov    %ax,0xf0221228
	if (crt_pos >= CRT_SIZE) {
f0100752:	66 81 3d 28 12 22 f0 	cmpw   $0x7cf,0xf0221228
f0100759:	cf 07 
f010075b:	0f 87 9e 00 00 00    	ja     f01007ff <cga_putc+0x13e>
	outb(addr_6845, 14);
f0100761:	8b 3d 30 12 22 f0    	mov    0xf0221230,%edi
f0100767:	ba 0e 00 00 00       	mov    $0xe,%edx
f010076c:	89 f8                	mov    %edi,%eax
f010076e:	e8 88 fb ff ff       	call   f01002fb <outb>
	outb(addr_6845 + 1, crt_pos >> 8);
f0100773:	0f b7 1d 28 12 22 f0 	movzwl 0xf0221228,%ebx
f010077a:	8d 77 01             	lea    0x1(%edi),%esi
f010077d:	0f b6 d7             	movzbl %bh,%edx
f0100780:	89 f0                	mov    %esi,%eax
f0100782:	e8 74 fb ff ff       	call   f01002fb <outb>
	outb(addr_6845, 15);
f0100787:	ba 0f 00 00 00       	mov    $0xf,%edx
f010078c:	89 f8                	mov    %edi,%eax
f010078e:	e8 68 fb ff ff       	call   f01002fb <outb>
	outb(addr_6845 + 1, crt_pos);
f0100793:	0f b6 d3             	movzbl %bl,%edx
f0100796:	89 f0                	mov    %esi,%eax
f0100798:	e8 5e fb ff ff       	call   f01002fb <outb>
}
f010079d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007a0:	5b                   	pop    %ebx
f01007a1:	5e                   	pop    %esi
f01007a2:	5f                   	pop    %edi
f01007a3:	5d                   	pop    %ebp
f01007a4:	c3                   	ret    
		if (crt_pos > 0) {
f01007a5:	0f b7 15 28 12 22 f0 	movzwl 0xf0221228,%edx
f01007ac:	66 85 d2             	test   %dx,%dx
f01007af:	74 b0                	je     f0100761 <cga_putc+0xa0>
			crt_pos--;
f01007b1:	83 ea 01             	sub    $0x1,%edx
f01007b4:	66 89 15 28 12 22 f0 	mov    %dx,0xf0221228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01007bb:	0f b7 d2             	movzwl %dx,%edx
f01007be:	b0 00                	mov    $0x0,%al
f01007c0:	83 c8 20             	or     $0x20,%eax
f01007c3:	8b 0d 2c 12 22 f0    	mov    0xf022122c,%ecx
f01007c9:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f01007cd:	eb 83                	jmp    f0100752 <cga_putc+0x91>
		crt_pos += CRT_COLS;
f01007cf:	66 83 05 28 12 22 f0 	addw   $0x50,0xf0221228
f01007d6:	50 
f01007d7:	e9 5a ff ff ff       	jmp    f0100736 <cga_putc+0x75>
		crt_buf[crt_pos++] = c;		/* write the character */
f01007dc:	0f b7 15 28 12 22 f0 	movzwl 0xf0221228,%edx
f01007e3:	8d 4a 01             	lea    0x1(%edx),%ecx
f01007e6:	66 89 0d 28 12 22 f0 	mov    %cx,0xf0221228
f01007ed:	0f b7 d2             	movzwl %dx,%edx
f01007f0:	8b 0d 2c 12 22 f0    	mov    0xf022122c,%ecx
f01007f6:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
		break;
f01007fa:	e9 53 ff ff ff       	jmp    f0100752 <cga_putc+0x91>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01007ff:	a1 2c 12 22 f0       	mov    0xf022122c,%eax
f0100804:	83 ec 04             	sub    $0x4,%esp
f0100807:	68 00 0f 00 00       	push   $0xf00
f010080c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100812:	52                   	push   %edx
f0100813:	50                   	push   %eax
f0100814:	e8 e7 4f 00 00       	call   f0105800 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100819:	8b 15 2c 12 22 f0    	mov    0xf022122c,%edx
f010081f:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100825:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010082b:	83 c4 10             	add    $0x10,%esp
f010082e:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100833:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100836:	39 d0                	cmp    %edx,%eax
f0100838:	75 f4                	jne    f010082e <cga_putc+0x16d>
		crt_pos -= CRT_COLS;
f010083a:	66 83 2d 28 12 22 f0 	subw   $0x50,0xf0221228
f0100841:	50 
f0100842:	e9 1a ff ff ff       	jmp    f0100761 <cga_putc+0xa0>

f0100847 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100847:	55                   	push   %ebp
f0100848:	89 e5                	mov    %esp,%ebp
f010084a:	53                   	push   %ebx
f010084b:	83 ec 04             	sub    $0x4,%esp
f010084e:	89 c3                	mov    %eax,%ebx
	serial_putc(c);
f0100850:	e8 0c fb ff ff       	call   f0100361 <serial_putc>
	lpt_putc(c);
f0100855:	89 d8                	mov    %ebx,%eax
f0100857:	e8 44 fb ff ff       	call   f01003a0 <lpt_putc>
	cga_putc(c);
f010085c:	89 d8                	mov    %ebx,%eax
f010085e:	e8 5e fe ff ff       	call   f01006c1 <cga_putc>
}
f0100863:	83 c4 04             	add    $0x4,%esp
f0100866:	5b                   	pop    %ebx
f0100867:	5d                   	pop    %ebp
f0100868:	c3                   	ret    

f0100869 <serial_intr>:
{
f0100869:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f010086d:	80 3d 34 12 22 f0 00 	cmpb   $0x0,0xf0221234
f0100874:	75 01                	jne    f0100877 <serial_intr+0xe>
f0100876:	c3                   	ret    
{
f0100877:	55                   	push   %ebp
f0100878:	89 e5                	mov    %esp,%ebp
f010087a:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010087d:	b8 33 03 10 f0       	mov    $0xf0100333,%eax
f0100882:	e8 19 fc ff ff       	call   f01004a0 <cons_intr>
}
f0100887:	c9                   	leave  
f0100888:	c3                   	ret    

f0100889 <kbd_intr>:
{
f0100889:	f3 0f 1e fb          	endbr32 
f010088d:	55                   	push   %ebp
f010088e:	89 e5                	mov    %esp,%ebp
f0100890:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100893:	b8 df 04 10 f0       	mov    $0xf01004df,%eax
f0100898:	e8 03 fc ff ff       	call   f01004a0 <cons_intr>
}
f010089d:	c9                   	leave  
f010089e:	c3                   	ret    

f010089f <kbd_init>:
{
f010089f:	55                   	push   %ebp
f01008a0:	89 e5                	mov    %esp,%ebp
f01008a2:	83 ec 08             	sub    $0x8,%esp
	kbd_intr();
f01008a5:	e8 df ff ff ff       	call   f0100889 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01008aa:	83 ec 0c             	sub    $0xc,%esp
f01008ad:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01008b4:	25 fd ff 00 00       	and    $0xfffd,%eax
f01008b9:	50                   	push   %eax
f01008ba:	e8 22 2f 00 00       	call   f01037e1 <irq_setmask_8259A>
}
f01008bf:	83 c4 10             	add    $0x10,%esp
f01008c2:	c9                   	leave  
f01008c3:	c3                   	ret    

f01008c4 <cons_getc>:
{
f01008c4:	f3 0f 1e fb          	endbr32 
f01008c8:	55                   	push   %ebp
f01008c9:	89 e5                	mov    %esp,%ebp
f01008cb:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01008ce:	e8 96 ff ff ff       	call   f0100869 <serial_intr>
	kbd_intr();
f01008d3:	e8 b1 ff ff ff       	call   f0100889 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01008d8:	a1 20 12 22 f0       	mov    0xf0221220,%eax
	return 0;
f01008dd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f01008e2:	3b 05 24 12 22 f0    	cmp    0xf0221224,%eax
f01008e8:	74 1c                	je     f0100906 <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f01008ea:	8d 48 01             	lea    0x1(%eax),%ecx
f01008ed:	0f b6 90 20 10 22 f0 	movzbl -0xfddefe0(%eax),%edx
			cons.rpos = 0;
f01008f4:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f01008f9:	b8 00 00 00 00       	mov    $0x0,%eax
f01008fe:	0f 45 c1             	cmovne %ecx,%eax
f0100901:	a3 20 12 22 f0       	mov    %eax,0xf0221220
}
f0100906:	89 d0                	mov    %edx,%eax
f0100908:	c9                   	leave  
f0100909:	c3                   	ret    

f010090a <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010090a:	f3 0f 1e fb          	endbr32 
f010090e:	55                   	push   %ebp
f010090f:	89 e5                	mov    %esp,%ebp
f0100911:	83 ec 08             	sub    $0x8,%esp
	cga_init();
f0100914:	e8 e4 fa ff ff       	call   f01003fd <cga_init>
	kbd_init();
f0100919:	e8 81 ff ff ff       	call   f010089f <kbd_init>
	serial_init();
f010091e:	e8 e1 fc ff ff       	call   f0100604 <serial_init>

	if (!serial_exists)
f0100923:	80 3d 34 12 22 f0 00 	cmpb   $0x0,0xf0221234
f010092a:	74 02                	je     f010092e <cons_init+0x24>
		cprintf("Serial port does not exist!\n");
}
f010092c:	c9                   	leave  
f010092d:	c3                   	ret    
		cprintf("Serial port does not exist!\n");
f010092e:	83 ec 0c             	sub    $0xc,%esp
f0100931:	68 dd 65 10 f0       	push   $0xf01065dd
f0100936:	e8 81 30 00 00       	call   f01039bc <cprintf>
f010093b:	83 c4 10             	add    $0x10,%esp
}
f010093e:	eb ec                	jmp    f010092c <cons_init+0x22>

f0100940 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100940:	f3 0f 1e fb          	endbr32 
f0100944:	55                   	push   %ebp
f0100945:	89 e5                	mov    %esp,%ebp
f0100947:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010094a:	8b 45 08             	mov    0x8(%ebp),%eax
f010094d:	e8 f5 fe ff ff       	call   f0100847 <cons_putc>
}
f0100952:	c9                   	leave  
f0100953:	c3                   	ret    

f0100954 <getchar>:

int
getchar(void)
{
f0100954:	f3 0f 1e fb          	endbr32 
f0100958:	55                   	push   %ebp
f0100959:	89 e5                	mov    %esp,%ebp
f010095b:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010095e:	e8 61 ff ff ff       	call   f01008c4 <cons_getc>
f0100963:	85 c0                	test   %eax,%eax
f0100965:	74 f7                	je     f010095e <getchar+0xa>
		/* do nothing */;
	return c;
}
f0100967:	c9                   	leave  
f0100968:	c3                   	ret    

f0100969 <iscons>:

int
iscons(int fdnum)
{
f0100969:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f010096d:	b8 01 00 00 00       	mov    $0x1,%eax
f0100972:	c3                   	ret    

f0100973 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100973:	f3 0f 1e fb          	endbr32 
f0100977:	55                   	push   %ebp
f0100978:	89 e5                	mov    %esp,%ebp
f010097a:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010097d:	68 20 68 10 f0       	push   $0xf0106820
f0100982:	68 3e 68 10 f0       	push   $0xf010683e
f0100987:	68 43 68 10 f0       	push   $0xf0106843
f010098c:	e8 2b 30 00 00       	call   f01039bc <cprintf>
f0100991:	83 c4 0c             	add    $0xc,%esp
f0100994:	68 ac 68 10 f0       	push   $0xf01068ac
f0100999:	68 4c 68 10 f0       	push   $0xf010684c
f010099e:	68 43 68 10 f0       	push   $0xf0106843
f01009a3:	e8 14 30 00 00       	call   f01039bc <cprintf>
	return 0;
}
f01009a8:	b8 00 00 00 00       	mov    $0x0,%eax
f01009ad:	c9                   	leave  
f01009ae:	c3                   	ret    

f01009af <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01009af:	f3 0f 1e fb          	endbr32 
f01009b3:	55                   	push   %ebp
f01009b4:	89 e5                	mov    %esp,%ebp
f01009b6:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01009b9:	68 55 68 10 f0       	push   $0xf0106855
f01009be:	e8 f9 2f 00 00       	call   f01039bc <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01009c3:	83 c4 08             	add    $0x8,%esp
f01009c6:	68 0c 00 10 00       	push   $0x10000c
f01009cb:	68 d4 68 10 f0       	push   $0xf01068d4
f01009d0:	e8 e7 2f 00 00       	call   f01039bc <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01009d5:	83 c4 0c             	add    $0xc,%esp
f01009d8:	68 0c 00 10 00       	push   $0x10000c
f01009dd:	68 0c 00 10 f0       	push   $0xf010000c
f01009e2:	68 fc 68 10 f0       	push   $0xf01068fc
f01009e7:	e8 d0 2f 00 00       	call   f01039bc <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01009ec:	83 c4 0c             	add    $0xc,%esp
f01009ef:	68 ed 64 10 00       	push   $0x1064ed
f01009f4:	68 ed 64 10 f0       	push   $0xf01064ed
f01009f9:	68 20 69 10 f0       	push   $0xf0106920
f01009fe:	e8 b9 2f 00 00       	call   f01039bc <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100a03:	83 c4 0c             	add    $0xc,%esp
f0100a06:	68 0c 06 22 00       	push   $0x22060c
f0100a0b:	68 0c 06 22 f0       	push   $0xf022060c
f0100a10:	68 44 69 10 f0       	push   $0xf0106944
f0100a15:	e8 a2 2f 00 00       	call   f01039bc <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100a1a:	83 c4 0c             	add    $0xc,%esp
f0100a1d:	68 08 40 26 00       	push   $0x264008
f0100a22:	68 08 40 26 f0       	push   $0xf0264008
f0100a27:	68 68 69 10 f0       	push   $0xf0106968
f0100a2c:	e8 8b 2f 00 00       	call   f01039bc <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100a31:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100a34:	b8 08 40 26 f0       	mov    $0xf0264008,%eax
f0100a39:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100a3e:	c1 f8 0a             	sar    $0xa,%eax
f0100a41:	50                   	push   %eax
f0100a42:	68 8c 69 10 f0       	push   $0xf010698c
f0100a47:	e8 70 2f 00 00       	call   f01039bc <cprintf>
	return 0;
}
f0100a4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a51:	c9                   	leave  
f0100a52:	c3                   	ret    

f0100a53 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100a53:	55                   	push   %ebp
f0100a54:	89 e5                	mov    %esp,%ebp
f0100a56:	57                   	push   %edi
f0100a57:	56                   	push   %esi
f0100a58:	53                   	push   %ebx
f0100a59:	83 ec 5c             	sub    $0x5c,%esp
f0100a5c:	89 c3                	mov    %eax,%ebx
f0100a5e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a61:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a68:	be 00 00 00 00       	mov    $0x0,%esi
f0100a6d:	eb 5d                	jmp    f0100acc <runcmd+0x79>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a6f:	83 ec 08             	sub    $0x8,%esp
f0100a72:	0f be c0             	movsbl %al,%eax
f0100a75:	50                   	push   %eax
f0100a76:	68 6e 68 10 f0       	push   $0xf010686e
f0100a7b:	e8 ed 4c 00 00       	call   f010576d <strchr>
f0100a80:	83 c4 10             	add    $0x10,%esp
f0100a83:	85 c0                	test   %eax,%eax
f0100a85:	74 0a                	je     f0100a91 <runcmd+0x3e>
			*buf++ = 0;
f0100a87:	c6 03 00             	movb   $0x0,(%ebx)
f0100a8a:	89 f7                	mov    %esi,%edi
f0100a8c:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100a8f:	eb 39                	jmp    f0100aca <runcmd+0x77>
		if (*buf == 0)
f0100a91:	0f b6 03             	movzbl (%ebx),%eax
f0100a94:	84 c0                	test   %al,%al
f0100a96:	74 3b                	je     f0100ad3 <runcmd+0x80>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a98:	83 fe 0f             	cmp    $0xf,%esi
f0100a9b:	0f 84 86 00 00 00    	je     f0100b27 <runcmd+0xd4>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
f0100aa1:	8d 7e 01             	lea    0x1(%esi),%edi
f0100aa4:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100aa8:	83 ec 08             	sub    $0x8,%esp
f0100aab:	0f be c0             	movsbl %al,%eax
f0100aae:	50                   	push   %eax
f0100aaf:	68 6e 68 10 f0       	push   $0xf010686e
f0100ab4:	e8 b4 4c 00 00       	call   f010576d <strchr>
f0100ab9:	83 c4 10             	add    $0x10,%esp
f0100abc:	85 c0                	test   %eax,%eax
f0100abe:	75 0a                	jne    f0100aca <runcmd+0x77>
			buf++;
f0100ac0:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100ac3:	0f b6 03             	movzbl (%ebx),%eax
f0100ac6:	84 c0                	test   %al,%al
f0100ac8:	75 de                	jne    f0100aa8 <runcmd+0x55>
			*buf++ = 0;
f0100aca:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100acc:	0f b6 03             	movzbl (%ebx),%eax
f0100acf:	84 c0                	test   %al,%al
f0100ad1:	75 9c                	jne    f0100a6f <runcmd+0x1c>
	}
	argv[argc] = 0;
f0100ad3:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ada:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100adb:	85 f6                	test   %esi,%esi
f0100add:	74 5f                	je     f0100b3e <runcmd+0xeb>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100adf:	83 ec 08             	sub    $0x8,%esp
f0100ae2:	68 3e 68 10 f0       	push   $0xf010683e
f0100ae7:	ff 75 a8             	pushl  -0x58(%ebp)
f0100aea:	e8 18 4c 00 00       	call   f0105707 <strcmp>
f0100aef:	83 c4 10             	add    $0x10,%esp
f0100af2:	85 c0                	test   %eax,%eax
f0100af4:	74 57                	je     f0100b4d <runcmd+0xfa>
f0100af6:	83 ec 08             	sub    $0x8,%esp
f0100af9:	68 4c 68 10 f0       	push   $0xf010684c
f0100afe:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b01:	e8 01 4c 00 00       	call   f0105707 <strcmp>
f0100b06:	83 c4 10             	add    $0x10,%esp
f0100b09:	85 c0                	test   %eax,%eax
f0100b0b:	74 3b                	je     f0100b48 <runcmd+0xf5>
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100b0d:	83 ec 08             	sub    $0x8,%esp
f0100b10:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b13:	68 90 68 10 f0       	push   $0xf0106890
f0100b18:	e8 9f 2e 00 00       	call   f01039bc <cprintf>
	return 0;
f0100b1d:	83 c4 10             	add    $0x10,%esp
f0100b20:	be 00 00 00 00       	mov    $0x0,%esi
f0100b25:	eb 17                	jmp    f0100b3e <runcmd+0xeb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100b27:	83 ec 08             	sub    $0x8,%esp
f0100b2a:	6a 10                	push   $0x10
f0100b2c:	68 73 68 10 f0       	push   $0xf0106873
f0100b31:	e8 86 2e 00 00       	call   f01039bc <cprintf>
			return 0;
f0100b36:	83 c4 10             	add    $0x10,%esp
f0100b39:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100b3e:	89 f0                	mov    %esi,%eax
f0100b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b43:	5b                   	pop    %ebx
f0100b44:	5e                   	pop    %esi
f0100b45:	5f                   	pop    %edi
f0100b46:	5d                   	pop    %ebp
f0100b47:	c3                   	ret    
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100b48:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f0100b4d:	83 ec 04             	sub    $0x4,%esp
f0100b50:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100b53:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100b56:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100b59:	52                   	push   %edx
f0100b5a:	56                   	push   %esi
f0100b5b:	ff 14 85 0c 6a 10 f0 	call   *-0xfef95f4(,%eax,4)
f0100b62:	89 c6                	mov    %eax,%esi
f0100b64:	83 c4 10             	add    $0x10,%esp
f0100b67:	eb d5                	jmp    f0100b3e <runcmd+0xeb>

f0100b69 <mon_backtrace>:
{
f0100b69:	f3 0f 1e fb          	endbr32 
}
f0100b6d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b72:	c3                   	ret    

f0100b73 <monitor>:

void
monitor(struct Trapframe *tf)
{
f0100b73:	f3 0f 1e fb          	endbr32 
f0100b77:	55                   	push   %ebp
f0100b78:	89 e5                	mov    %esp,%ebp
f0100b7a:	53                   	push   %ebx
f0100b7b:	83 ec 10             	sub    $0x10,%esp
f0100b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b81:	68 b8 69 10 f0       	push   $0xf01069b8
f0100b86:	e8 31 2e 00 00       	call   f01039bc <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b8b:	c7 04 24 dc 69 10 f0 	movl   $0xf01069dc,(%esp)
f0100b92:	e8 25 2e 00 00       	call   f01039bc <cprintf>

	if (tf != NULL)
f0100b97:	83 c4 10             	add    $0x10,%esp
f0100b9a:	85 db                	test   %ebx,%ebx
f0100b9c:	74 0c                	je     f0100baa <monitor+0x37>
		print_trapframe(tf);
f0100b9e:	83 ec 0c             	sub    $0xc,%esp
f0100ba1:	53                   	push   %ebx
f0100ba2:	e8 18 33 00 00       	call   f0103ebf <print_trapframe>
f0100ba7:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100baa:	83 ec 0c             	sub    $0xc,%esp
f0100bad:	68 a6 68 10 f0       	push   $0xf01068a6
f0100bb2:	e8 5c 49 00 00       	call   f0105513 <readline>
		if (buf != NULL)
f0100bb7:	83 c4 10             	add    $0x10,%esp
f0100bba:	85 c0                	test   %eax,%eax
f0100bbc:	74 ec                	je     f0100baa <monitor+0x37>
			if (runcmd(buf, tf) < 0)
f0100bbe:	89 da                	mov    %ebx,%edx
f0100bc0:	e8 8e fe ff ff       	call   f0100a53 <runcmd>
f0100bc5:	85 c0                	test   %eax,%eax
f0100bc7:	79 e1                	jns    f0100baa <monitor+0x37>
				break;
	}
}
f0100bc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bcc:	c9                   	leave  
f0100bcd:	c3                   	ret    

f0100bce <invlpg>:
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100bce:	0f 01 38             	invlpg (%eax)
}
f0100bd1:	c3                   	ret    

f0100bd2 <lcr0>:
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0100bd2:	0f 22 c0             	mov    %eax,%cr0
}
f0100bd5:	c3                   	ret    

f0100bd6 <rcr0>:
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0100bd6:	0f 20 c0             	mov    %cr0,%eax
}
f0100bd9:	c3                   	ret    

f0100bda <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100bda:	0f 22 d8             	mov    %eax,%cr3
}
f0100bdd:	c3                   	ret    

f0100bde <page2pa>:
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bde:	2b 05 90 2e 22 f0    	sub    0xf0222e90,%eax
f0100be4:	c1 f8 03             	sar    $0x3,%eax
f0100be7:	c1 e0 0c             	shl    $0xc,%eax
}
f0100bea:	c3                   	ret    

f0100beb <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100beb:	55                   	push   %ebp
f0100bec:	89 e5                	mov    %esp,%ebp
f0100bee:	56                   	push   %esi
f0100bef:	53                   	push   %ebx
f0100bf0:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100bf2:	83 ec 0c             	sub    $0xc,%esp
f0100bf5:	50                   	push   %eax
f0100bf6:	e8 8f 2b 00 00       	call   f010378a <mc146818_read>
f0100bfb:	89 c6                	mov    %eax,%esi
f0100bfd:	83 c3 01             	add    $0x1,%ebx
f0100c00:	89 1c 24             	mov    %ebx,(%esp)
f0100c03:	e8 82 2b 00 00       	call   f010378a <mc146818_read>
f0100c08:	c1 e0 08             	shl    $0x8,%eax
f0100c0b:	09 f0                	or     %esi,%eax
}
f0100c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c10:	5b                   	pop    %ebx
f0100c11:	5e                   	pop    %esi
f0100c12:	5d                   	pop    %ebp
f0100c13:	c3                   	ret    

f0100c14 <i386_detect_memory>:

static void
i386_detect_memory(void)
{
f0100c14:	55                   	push   %ebp
f0100c15:	89 e5                	mov    %esp,%ebp
f0100c17:	56                   	push   %esi
f0100c18:	53                   	push   %ebx
	size_t basemem, extmem, ext16mem, totalmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	basemem = nvram_read(NVRAM_BASELO);
f0100c19:	b8 15 00 00 00       	mov    $0x15,%eax
f0100c1e:	e8 c8 ff ff ff       	call   f0100beb <nvram_read>
f0100c23:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0100c25:	b8 17 00 00 00       	mov    $0x17,%eax
f0100c2a:	e8 bc ff ff ff       	call   f0100beb <nvram_read>
f0100c2f:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0100c31:	b8 34 00 00 00       	mov    $0x34,%eax
f0100c36:	e8 b0 ff ff ff       	call   f0100beb <nvram_read>

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (ext16mem)
f0100c3b:	c1 e0 06             	shl    $0x6,%eax
f0100c3e:	74 2b                	je     f0100c6b <i386_detect_memory+0x57>
		totalmem = 16 * 1024 + ext16mem;
f0100c40:	05 00 40 00 00       	add    $0x4000,%eax
	else if (extmem)
		totalmem = 1 * 1024 + extmem;
	else
		totalmem = basemem;

	npages = totalmem / (PGSIZE / 1024);
f0100c45:	89 c2                	mov    %eax,%edx
f0100c47:	c1 ea 02             	shr    $0x2,%edx
f0100c4a:	89 15 88 2e 22 f0    	mov    %edx,0xf0222e88
	npages_basemem = basemem / (PGSIZE / 1024);

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0100c50:	89 c2                	mov    %eax,%edx
f0100c52:	29 da                	sub    %ebx,%edx
f0100c54:	52                   	push   %edx
f0100c55:	53                   	push   %ebx
f0100c56:	50                   	push   %eax
f0100c57:	68 1c 6a 10 f0       	push   $0xf0106a1c
f0100c5c:	e8 5b 2d 00 00       	call   f01039bc <cprintf>
	        totalmem,
	        basemem,
	        totalmem - basemem);
}
f0100c61:	83 c4 10             	add    $0x10,%esp
f0100c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c67:	5b                   	pop    %ebx
f0100c68:	5e                   	pop    %esi
f0100c69:	5d                   	pop    %ebp
f0100c6a:	c3                   	ret    
		totalmem = 1 * 1024 + extmem;
f0100c6b:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0100c71:	85 f6                	test   %esi,%esi
f0100c73:	0f 44 c3             	cmove  %ebx,%eax
f0100c76:	eb cd                	jmp    f0100c45 <i386_detect_memory+0x31>

f0100c78 <_kaddr>:
{
f0100c78:	55                   	push   %ebp
f0100c79:	89 e5                	mov    %esp,%ebp
f0100c7b:	53                   	push   %ebx
f0100c7c:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0100c7f:	89 cb                	mov    %ecx,%ebx
f0100c81:	c1 eb 0c             	shr    $0xc,%ebx
f0100c84:	3b 1d 88 2e 22 f0    	cmp    0xf0222e88,%ebx
f0100c8a:	73 0b                	jae    f0100c97 <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0100c8c:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0100c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100c95:	c9                   	leave  
f0100c96:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c97:	51                   	push   %ecx
f0100c98:	68 2c 65 10 f0       	push   $0xf010652c
f0100c9d:	52                   	push   %edx
f0100c9e:	50                   	push   %eax
f0100c9f:	e8 c6 f3 ff ff       	call   f010006a <_panic>

f0100ca4 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100ca4:	55                   	push   %ebp
f0100ca5:	89 e5                	mov    %esp,%ebp
f0100ca7:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0100caa:	e8 2f ff ff ff       	call   f0100bde <page2pa>
f0100caf:	89 c1                	mov    %eax,%ecx
f0100cb1:	ba 58 00 00 00       	mov    $0x58,%edx
f0100cb6:	b8 71 74 10 f0       	mov    $0xf0107471,%eax
f0100cbb:	e8 b8 ff ff ff       	call   f0100c78 <_kaddr>
}
f0100cc0:	c9                   	leave  
f0100cc1:	c3                   	ret    

f0100cc2 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100cc2:	55                   	push   %ebp
f0100cc3:	89 e5                	mov    %esp,%ebp
f0100cc5:	53                   	push   %ebx
f0100cc6:	83 ec 04             	sub    $0x4,%esp
f0100cc9:	89 d3                	mov    %edx,%ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100ccb:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P))
f0100cce:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
		return ~0;
f0100cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if (!(*pgdir & PTE_P))
f0100cd6:	f6 c1 01             	test   $0x1,%cl
f0100cd9:	74 14                	je     f0100cef <check_va2pa+0x2d>
	if (*pgdir & PTE_PS)
f0100cdb:	f6 c1 80             	test   $0x80,%cl
f0100cde:	74 15                	je     f0100cf5 <check_va2pa+0x33>
		return (physaddr_t) PGADDR(PDX(*pgdir), PTX(va), PGOFF(va));
f0100ce0:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
f0100ce6:	89 d8                	mov    %ebx,%eax
f0100ce8:	25 ff ff 3f 00       	and    $0x3fffff,%eax
f0100ced:	09 c8                	or     %ecx,%eax
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100cef:	83 c4 04             	add    $0x4,%esp
f0100cf2:	5b                   	pop    %ebx
f0100cf3:	5d                   	pop    %ebp
f0100cf4:	c3                   	ret    
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100cf5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100cfb:	ba e6 03 00 00       	mov    $0x3e6,%edx
f0100d00:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0100d05:	e8 6e ff ff ff       	call   f0100c78 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f0100d0a:	c1 eb 0c             	shr    $0xc,%ebx
f0100d0d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0100d13:	8b 14 98             	mov    (%eax,%ebx,4),%edx
	return PTE_ADDR(p[PTX(va)]);
f0100d16:	89 d0                	mov    %edx,%eax
f0100d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d1d:	f6 c2 01             	test   $0x1,%dl
f0100d20:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0100d25:	0f 44 c1             	cmove  %ecx,%eax
f0100d28:	eb c5                	jmp    f0100cef <check_va2pa+0x2d>

f0100d2a <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f0100d2a:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100d30:	76 07                	jbe    f0100d39 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0100d32:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100d38:	c3                   	ret    
{
f0100d39:	55                   	push   %ebp
f0100d3a:	89 e5                	mov    %esp,%ebp
f0100d3c:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100d3f:	51                   	push   %ecx
f0100d40:	68 50 65 10 f0       	push   $0xf0106550
f0100d45:	52                   	push   %edx
f0100d46:	50                   	push   %eax
f0100d47:	e8 1e f3 ff ff       	call   f010006a <_panic>

f0100d4c <boot_alloc>:
{
f0100d4c:	55                   	push   %ebp
f0100d4d:	89 e5                	mov    %esp,%ebp
f0100d4f:	56                   	push   %esi
f0100d50:	53                   	push   %ebx
f0100d51:	89 c3                	mov    %eax,%ebx
	if (!nextfree) {
f0100d53:	83 3d 38 12 22 f0 00 	cmpl   $0x0,0xf0221238
f0100d5a:	74 43                	je     f0100d9f <boot_alloc+0x53>
	result = nextfree;
f0100d5c:	8b 35 38 12 22 f0    	mov    0xf0221238,%esi
	physaddr_t next_free_physical = PADDR(nextfree);
f0100d62:	89 f1                	mov    %esi,%ecx
f0100d64:	ba 72 00 00 00       	mov    $0x72,%edx
f0100d69:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0100d6e:	e8 b7 ff ff ff       	call   f0100d2a <_paddr>
f0100d73:	89 c2                	mov    %eax,%edx
	if (next_free_physical >= (npages * PGSIZE))
f0100d75:	a1 88 2e 22 f0       	mov    0xf0222e88,%eax
f0100d7a:	c1 e0 0c             	shl    $0xc,%eax
f0100d7d:	39 d0                	cmp    %edx,%eax
f0100d7f:	76 2f                	jbe    f0100db0 <boot_alloc+0x64>
	if (n > 0) {
f0100d81:	85 db                	test   %ebx,%ebx
f0100d83:	74 11                	je     f0100d96 <boot_alloc+0x4a>
		nextfree = ROUNDUP(nextfree, PGSIZE);
f0100d85:	8d 84 1e ff 0f 00 00 	lea    0xfff(%esi,%ebx,1),%eax
f0100d8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d91:	a3 38 12 22 f0       	mov    %eax,0xf0221238
}
f0100d96:	89 f0                	mov    %esi,%eax
f0100d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100d9b:	5b                   	pop    %ebx
f0100d9c:	5e                   	pop    %esi
f0100d9d:	5d                   	pop    %ebp
f0100d9e:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100d9f:	b8 07 50 26 f0       	mov    $0xf0265007,%eax
f0100da4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100da9:	a3 38 12 22 f0       	mov    %eax,0xf0221238
f0100dae:	eb ac                	jmp    f0100d5c <boot_alloc+0x10>
		panic("boot_alloc: No hay suficiente memoria.");
f0100db0:	83 ec 04             	sub    $0x4,%esp
f0100db3:	68 58 6a 10 f0       	push   $0xf0106a58
f0100db8:	6a 74                	push   $0x74
f0100dba:	68 7f 74 10 f0       	push   $0xf010747f
f0100dbf:	e8 a6 f2 ff ff       	call   f010006a <_panic>

f0100dc4 <check_page_free_list>:
{
f0100dc4:	55                   	push   %ebp
f0100dc5:	89 e5                	mov    %esp,%ebp
f0100dc7:	57                   	push   %edi
f0100dc8:	56                   	push   %esi
f0100dc9:	53                   	push   %ebx
f0100dca:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100dcd:	84 c0                	test   %al,%al
f0100dcf:	0f 85 3f 02 00 00    	jne    f0101014 <check_page_free_list+0x250>
	if (!page_free_list)
f0100dd5:	83 3d 40 12 22 f0 00 	cmpl   $0x0,0xf0221240
f0100ddc:	74 0a                	je     f0100de8 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100dde:	be 00 04 00 00       	mov    $0x400,%esi
f0100de3:	e9 84 02 00 00       	jmp    f010106c <check_page_free_list+0x2a8>
		panic("'page_free_list' is a null pointer!");
f0100de8:	83 ec 04             	sub    $0x4,%esp
f0100deb:	68 80 6a 10 f0       	push   $0xf0106a80
f0100df0:	68 04 03 00 00       	push   $0x304
f0100df5:	68 7f 74 10 f0       	push   $0xf010747f
f0100dfa:	e8 6b f2 ff ff       	call   f010006a <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100dff:	8b 1b                	mov    (%ebx),%ebx
f0100e01:	85 db                	test   %ebx,%ebx
f0100e03:	74 2d                	je     f0100e32 <check_page_free_list+0x6e>
		if (PDX(page2pa(pp)) < pdx_limit)
f0100e05:	89 d8                	mov    %ebx,%eax
f0100e07:	e8 d2 fd ff ff       	call   f0100bde <page2pa>
f0100e0c:	c1 e8 16             	shr    $0x16,%eax
f0100e0f:	39 f0                	cmp    %esi,%eax
f0100e11:	73 ec                	jae    f0100dff <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100e13:	89 d8                	mov    %ebx,%eax
f0100e15:	e8 8a fe ff ff       	call   f0100ca4 <page2kva>
f0100e1a:	83 ec 04             	sub    $0x4,%esp
f0100e1d:	68 80 00 00 00       	push   $0x80
f0100e22:	68 97 00 00 00       	push   $0x97
f0100e27:	50                   	push   %eax
f0100e28:	e8 85 49 00 00       	call   f01057b2 <memset>
f0100e2d:	83 c4 10             	add    $0x10,%esp
f0100e30:	eb cd                	jmp    f0100dff <check_page_free_list+0x3b>
	first_free_page = (char *) boot_alloc(0);
f0100e32:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e37:	e8 10 ff ff ff       	call   f0100d4c <boot_alloc>
f0100e3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e3f:	8b 1d 40 12 22 f0    	mov    0xf0221240,%ebx
		assert(pp >= pages);
f0100e45:	8b 35 90 2e 22 f0    	mov    0xf0222e90,%esi
		assert(pp < pages + npages);
f0100e4b:	a1 88 2e 22 f0       	mov    0xf0222e88,%eax
f0100e50:	8d 3c c6             	lea    (%esi,%eax,8),%edi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100e53:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f0100e5a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e61:	e9 e0 00 00 00       	jmp    f0100f46 <check_page_free_list+0x182>
		assert(pp >= pages);
f0100e66:	68 8b 74 10 f0       	push   $0xf010748b
f0100e6b:	68 97 74 10 f0       	push   $0xf0107497
f0100e70:	68 1e 03 00 00       	push   $0x31e
f0100e75:	68 7f 74 10 f0       	push   $0xf010747f
f0100e7a:	e8 eb f1 ff ff       	call   f010006a <_panic>
		assert(pp < pages + npages);
f0100e7f:	68 ac 74 10 f0       	push   $0xf01074ac
f0100e84:	68 97 74 10 f0       	push   $0xf0107497
f0100e89:	68 1f 03 00 00       	push   $0x31f
f0100e8e:	68 7f 74 10 f0       	push   $0xf010747f
f0100e93:	e8 d2 f1 ff ff       	call   f010006a <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100e98:	68 a4 6a 10 f0       	push   $0xf0106aa4
f0100e9d:	68 97 74 10 f0       	push   $0xf0107497
f0100ea2:	68 20 03 00 00       	push   $0x320
f0100ea7:	68 7f 74 10 f0       	push   $0xf010747f
f0100eac:	e8 b9 f1 ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != 0);
f0100eb1:	68 c0 74 10 f0       	push   $0xf01074c0
f0100eb6:	68 97 74 10 f0       	push   $0xf0107497
f0100ebb:	68 23 03 00 00       	push   $0x323
f0100ec0:	68 7f 74 10 f0       	push   $0xf010747f
f0100ec5:	e8 a0 f1 ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100eca:	68 d1 74 10 f0       	push   $0xf01074d1
f0100ecf:	68 97 74 10 f0       	push   $0xf0107497
f0100ed4:	68 24 03 00 00       	push   $0x324
f0100ed9:	68 7f 74 10 f0       	push   $0xf010747f
f0100ede:	e8 87 f1 ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ee3:	68 d8 6a 10 f0       	push   $0xf0106ad8
f0100ee8:	68 97 74 10 f0       	push   $0xf0107497
f0100eed:	68 25 03 00 00       	push   $0x325
f0100ef2:	68 7f 74 10 f0       	push   $0xf010747f
f0100ef7:	e8 6e f1 ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100efc:	68 ea 74 10 f0       	push   $0xf01074ea
f0100f01:	68 97 74 10 f0       	push   $0xf0107497
f0100f06:	68 26 03 00 00       	push   $0x326
f0100f0b:	68 7f 74 10 f0       	push   $0xf010747f
f0100f10:	e8 55 f1 ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) < EXTPHYSMEM ||
f0100f15:	89 d8                	mov    %ebx,%eax
f0100f17:	e8 88 fd ff ff       	call   f0100ca4 <page2kva>
f0100f1c:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100f1f:	77 06                	ja     f0100f27 <check_page_free_list+0x163>
			++nfree_extmem;
f0100f21:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f0100f25:	eb 1d                	jmp    f0100f44 <check_page_free_list+0x180>
		assert(page2pa(pp) < EXTPHYSMEM ||
f0100f27:	68 fc 6a 10 f0       	push   $0xf0106afc
f0100f2c:	68 97 74 10 f0       	push   $0xf0107497
f0100f31:	68 27 03 00 00       	push   $0x327
f0100f36:	68 7f 74 10 f0       	push   $0xf010747f
f0100f3b:	e8 2a f1 ff ff       	call   f010006a <_panic>
			++nfree_basemem;
f0100f40:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f44:	8b 1b                	mov    (%ebx),%ebx
f0100f46:	85 db                	test   %ebx,%ebx
f0100f48:	74 77                	je     f0100fc1 <check_page_free_list+0x1fd>
		assert(pp >= pages);
f0100f4a:	39 de                	cmp    %ebx,%esi
f0100f4c:	0f 87 14 ff ff ff    	ja     f0100e66 <check_page_free_list+0xa2>
		assert(pp < pages + npages);
f0100f52:	39 df                	cmp    %ebx,%edi
f0100f54:	0f 86 25 ff ff ff    	jbe    f0100e7f <check_page_free_list+0xbb>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100f5a:	89 d8                	mov    %ebx,%eax
f0100f5c:	29 f0                	sub    %esi,%eax
f0100f5e:	a8 07                	test   $0x7,%al
f0100f60:	0f 85 32 ff ff ff    	jne    f0100e98 <check_page_free_list+0xd4>
		assert(page2pa(pp) != 0);
f0100f66:	89 d8                	mov    %ebx,%eax
f0100f68:	e8 71 fc ff ff       	call   f0100bde <page2pa>
f0100f6d:	85 c0                	test   %eax,%eax
f0100f6f:	0f 84 3c ff ff ff    	je     f0100eb1 <check_page_free_list+0xed>
		assert(page2pa(pp) != IOPHYSMEM);
f0100f75:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100f7a:	0f 84 4a ff ff ff    	je     f0100eca <check_page_free_list+0x106>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100f80:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100f85:	0f 84 58 ff ff ff    	je     f0100ee3 <check_page_free_list+0x11f>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100f8b:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100f90:	0f 84 66 ff ff ff    	je     f0100efc <check_page_free_list+0x138>
		assert(page2pa(pp) < EXTPHYSMEM ||
f0100f96:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100f9b:	0f 87 74 ff ff ff    	ja     f0100f15 <check_page_free_list+0x151>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100fa1:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100fa6:	75 98                	jne    f0100f40 <check_page_free_list+0x17c>
f0100fa8:	68 04 75 10 f0       	push   $0xf0107504
f0100fad:	68 97 74 10 f0       	push   $0xf0107497
f0100fb2:	68 2a 03 00 00       	push   $0x32a
f0100fb7:	68 7f 74 10 f0       	push   $0xf010747f
f0100fbc:	e8 a9 f0 ff ff       	call   f010006a <_panic>
	assert(nfree_basemem > 0);
f0100fc1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0100fc5:	7e 1b                	jle    f0100fe2 <check_page_free_list+0x21e>
	assert(nfree_extmem > 0);
f0100fc7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0100fcb:	7e 2e                	jle    f0100ffb <check_page_free_list+0x237>
	cprintf("check_page_free_list() succeeded!\n");
f0100fcd:	83 ec 0c             	sub    $0xc,%esp
f0100fd0:	68 44 6b 10 f0       	push   $0xf0106b44
f0100fd5:	e8 e2 29 00 00       	call   f01039bc <cprintf>
}
f0100fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100fdd:	5b                   	pop    %ebx
f0100fde:	5e                   	pop    %esi
f0100fdf:	5f                   	pop    %edi
f0100fe0:	5d                   	pop    %ebp
f0100fe1:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100fe2:	68 21 75 10 f0       	push   $0xf0107521
f0100fe7:	68 97 74 10 f0       	push   $0xf0107497
f0100fec:	68 32 03 00 00       	push   $0x332
f0100ff1:	68 7f 74 10 f0       	push   $0xf010747f
f0100ff6:	e8 6f f0 ff ff       	call   f010006a <_panic>
	assert(nfree_extmem > 0);
f0100ffb:	68 33 75 10 f0       	push   $0xf0107533
f0101000:	68 97 74 10 f0       	push   $0xf0107497
f0101005:	68 33 03 00 00       	push   $0x333
f010100a:	68 7f 74 10 f0       	push   $0xf010747f
f010100f:	e8 56 f0 ff ff       	call   f010006a <_panic>
	if (!page_free_list)
f0101014:	8b 1d 40 12 22 f0    	mov    0xf0221240,%ebx
f010101a:	85 db                	test   %ebx,%ebx
f010101c:	0f 84 c6 fd ff ff    	je     f0100de8 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0101022:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0101025:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101028:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010102b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f010102e:	89 d8                	mov    %ebx,%eax
f0101030:	e8 a9 fb ff ff       	call   f0100bde <page2pa>
f0101035:	c1 e8 16             	shr    $0x16,%eax
f0101038:	0f 95 c0             	setne  %al
f010103b:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f010103e:	8b 54 85 e0          	mov    -0x20(%ebp,%eax,4),%edx
f0101042:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f0101044:	89 5c 85 e0          	mov    %ebx,-0x20(%ebp,%eax,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101048:	8b 1b                	mov    (%ebx),%ebx
f010104a:	85 db                	test   %ebx,%ebx
f010104c:	75 e0                	jne    f010102e <check_page_free_list+0x26a>
		*tp[1] = 0;
f010104e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101051:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101057:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010105a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010105d:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010105f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101062:	a3 40 12 22 f0       	mov    %eax,0xf0221240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101067:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010106c:	8b 1d 40 12 22 f0    	mov    0xf0221240,%ebx
f0101072:	e9 8a fd ff ff       	jmp    f0100e01 <check_page_free_list+0x3d>

f0101077 <pa2page>:
	if (PGNUM(pa) >= npages)
f0101077:	c1 e8 0c             	shr    $0xc,%eax
f010107a:	3b 05 88 2e 22 f0    	cmp    0xf0222e88,%eax
f0101080:	73 0a                	jae    f010108c <pa2page+0x15>
	return &pages[PGNUM(pa)];
f0101082:	8b 15 90 2e 22 f0    	mov    0xf0222e90,%edx
f0101088:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f010108b:	c3                   	ret    
{
f010108c:	55                   	push   %ebp
f010108d:	89 e5                	mov    %esp,%ebp
f010108f:	83 ec 0c             	sub    $0xc,%esp
		panic("pa2page called with invalid pa");
f0101092:	68 68 6b 10 f0       	push   $0xf0106b68
f0101097:	6a 51                	push   $0x51
f0101099:	68 71 74 10 f0       	push   $0xf0107471
f010109e:	e8 c7 ef ff ff       	call   f010006a <_panic>

f01010a3 <page_init>:
{
f01010a3:	f3 0f 1e fb          	endbr32 
f01010a7:	55                   	push   %ebp
f01010a8:	89 e5                	mov    %esp,%ebp
f01010aa:	57                   	push   %edi
f01010ab:	56                   	push   %esi
f01010ac:	53                   	push   %ebx
f01010ad:	83 ec 0c             	sub    $0xc,%esp
	int end_page_kernel = PADDR(boot_alloc(0)) / PGSIZE;
f01010b0:	b8 00 00 00 00       	mov    $0x0,%eax
f01010b5:	e8 92 fc ff ff       	call   f0100d4c <boot_alloc>
f01010ba:	89 c1                	mov    %eax,%ecx
f01010bc:	ba 5a 01 00 00       	mov    $0x15a,%edx
f01010c1:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f01010c6:	e8 5f fc ff ff       	call   f0100d2a <_paddr>
f01010cb:	c1 e8 0c             	shr    $0xc,%eax
f01010ce:	8b 1d 40 12 22 f0    	mov    0xf0221240,%ebx
	for (i = 1; i < npages; i++) {
f01010d4:	be 00 00 00 00       	mov    $0x0,%esi
f01010d9:	ba 01 00 00 00       	mov    $0x1,%edx
			page_free_list = &pages[i];
f01010de:	bf 01 00 00 00       	mov    $0x1,%edi
	for (i = 1; i < npages; i++) {
f01010e3:	eb 18                	jmp    f01010fd <page_init+0x5a>
			pages[i].pp_ref = 1;
f01010e5:	8b 0d 90 2e 22 f0    	mov    0xf0222e90,%ecx
f01010eb:	8d 0c d1             	lea    (%ecx,%edx,8),%ecx
f01010ee:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
			pages[i].pp_link = NULL;
f01010f4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	for (i = 1; i < npages; i++) {
f01010fa:	83 c2 01             	add    $0x1,%edx
f01010fd:	39 15 88 2e 22 f0    	cmp    %edx,0xf0222e88
f0101103:	76 49                	jbe    f010114e <page_init+0xab>
		if (i >= start_page_io && i < end_page_kernel) {
f0101105:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
f010110b:	76 04                	jbe    f0101111 <page_init+0x6e>
f010110d:	39 d0                	cmp    %edx,%eax
f010110f:	77 d4                	ja     f01010e5 <page_init+0x42>
		} else if (i == MPENTRY_PADDR / PGSIZE) {
f0101111:	83 fa 07             	cmp    $0x7,%edx
f0101114:	74 23                	je     f0101139 <page_init+0x96>
f0101116:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
			pages[i].pp_ref = 0;
f010111d:	89 ce                	mov    %ecx,%esi
f010111f:	03 35 90 2e 22 f0    	add    0xf0222e90,%esi
f0101125:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
			pages[i].pp_link = page_free_list;
f010112b:	89 1e                	mov    %ebx,(%esi)
			page_free_list = &pages[i];
f010112d:	89 cb                	mov    %ecx,%ebx
f010112f:	03 1d 90 2e 22 f0    	add    0xf0222e90,%ebx
f0101135:	89 fe                	mov    %edi,%esi
f0101137:	eb c1                	jmp    f01010fa <page_init+0x57>
			pages[i].pp_ref = 1;
f0101139:	8b 0d 90 2e 22 f0    	mov    0xf0222e90,%ecx
f010113f:	66 c7 41 3c 01 00    	movw   $0x1,0x3c(%ecx)
			pages[i].pp_link = NULL;
f0101145:	c7 41 38 00 00 00 00 	movl   $0x0,0x38(%ecx)
f010114c:	eb ac                	jmp    f01010fa <page_init+0x57>
f010114e:	89 f0                	mov    %esi,%eax
f0101150:	84 c0                	test   %al,%al
f0101152:	74 06                	je     f010115a <page_init+0xb7>
f0101154:	89 1d 40 12 22 f0    	mov    %ebx,0xf0221240
}
f010115a:	83 c4 0c             	add    $0xc,%esp
f010115d:	5b                   	pop    %ebx
f010115e:	5e                   	pop    %esi
f010115f:	5f                   	pop    %edi
f0101160:	5d                   	pop    %ebp
f0101161:	c3                   	ret    

f0101162 <page_alloc>:
{
f0101162:	f3 0f 1e fb          	endbr32 
f0101166:	55                   	push   %ebp
f0101167:	89 e5                	mov    %esp,%ebp
f0101169:	53                   	push   %ebx
f010116a:	83 ec 04             	sub    $0x4,%esp
	struct PageInfo *return_page = page_free_list;
f010116d:	8b 1d 40 12 22 f0    	mov    0xf0221240,%ebx
	if (return_page != NULL) {
f0101173:	85 db                	test   %ebx,%ebx
f0101175:	74 13                	je     f010118a <page_alloc+0x28>
		page_free_list = page_free_list->pp_link;
f0101177:	8b 03                	mov    (%ebx),%eax
f0101179:	a3 40 12 22 f0       	mov    %eax,0xf0221240
		return_page->pp_link = NULL;
f010117e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if (alloc_flags & ALLOC_ZERO) {
f0101184:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101188:	75 07                	jne    f0101191 <page_alloc+0x2f>
}
f010118a:	89 d8                	mov    %ebx,%eax
f010118c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010118f:	c9                   	leave  
f0101190:	c3                   	ret    
			char *kva = page2kva(return_page);
f0101191:	89 d8                	mov    %ebx,%eax
f0101193:	e8 0c fb ff ff       	call   f0100ca4 <page2kva>
			memset(kva, '\0', PGSIZE);
f0101198:	83 ec 04             	sub    $0x4,%esp
f010119b:	68 00 10 00 00       	push   $0x1000
f01011a0:	6a 00                	push   $0x0
f01011a2:	50                   	push   %eax
f01011a3:	e8 0a 46 00 00       	call   f01057b2 <memset>
f01011a8:	83 c4 10             	add    $0x10,%esp
	return return_page;
f01011ab:	eb dd                	jmp    f010118a <page_alloc+0x28>

f01011ad <page_free>:
{
f01011ad:	f3 0f 1e fb          	endbr32 
f01011b1:	55                   	push   %ebp
f01011b2:	89 e5                	mov    %esp,%ebp
f01011b4:	83 ec 08             	sub    $0x8,%esp
f01011b7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_ref != 0) {
f01011ba:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01011bf:	75 14                	jne    f01011d5 <page_free+0x28>
	if (pp->pp_link != NULL) {
f01011c1:	83 38 00             	cmpl   $0x0,(%eax)
f01011c4:	75 26                	jne    f01011ec <page_free+0x3f>
	pp->pp_link = page_free_list;
f01011c6:	8b 15 40 12 22 f0    	mov    0xf0221240,%edx
f01011cc:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f01011ce:	a3 40 12 22 f0       	mov    %eax,0xf0221240
}
f01011d3:	c9                   	leave  
f01011d4:	c3                   	ret    
		panic("page_free: pp->pp_ref no es cero");
f01011d5:	83 ec 04             	sub    $0x4,%esp
f01011d8:	68 88 6b 10 f0       	push   $0xf0106b88
f01011dd:	68 95 01 00 00       	push   $0x195
f01011e2:	68 7f 74 10 f0       	push   $0xf010747f
f01011e7:	e8 7e ee ff ff       	call   f010006a <_panic>
		panic("page_free: pp->pp_link es distinto de NULL");
f01011ec:	83 ec 04             	sub    $0x4,%esp
f01011ef:	68 ac 6b 10 f0       	push   $0xf0106bac
f01011f4:	68 98 01 00 00       	push   $0x198
f01011f9:	68 7f 74 10 f0       	push   $0xf010747f
f01011fe:	e8 67 ee ff ff       	call   f010006a <_panic>

f0101203 <check_page_alloc>:
{
f0101203:	55                   	push   %ebp
f0101204:	89 e5                	mov    %esp,%ebp
f0101206:	57                   	push   %edi
f0101207:	56                   	push   %esi
f0101208:	53                   	push   %ebx
f0101209:	83 ec 1c             	sub    $0x1c,%esp
	if (!pages)
f010120c:	83 3d 90 2e 22 f0 00 	cmpl   $0x0,0xf0222e90
f0101213:	74 0c                	je     f0101221 <check_page_alloc+0x1e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101215:	a1 40 12 22 f0       	mov    0xf0221240,%eax
f010121a:	be 00 00 00 00       	mov    $0x0,%esi
f010121f:	eb 1c                	jmp    f010123d <check_page_alloc+0x3a>
		panic("'pages' is a null pointer!");
f0101221:	83 ec 04             	sub    $0x4,%esp
f0101224:	68 44 75 10 f0       	push   $0xf0107544
f0101229:	68 46 03 00 00       	push   $0x346
f010122e:	68 7f 74 10 f0       	push   $0xf010747f
f0101233:	e8 32 ee ff ff       	call   f010006a <_panic>
		++nfree;
f0101238:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010123b:	8b 00                	mov    (%eax),%eax
f010123d:	85 c0                	test   %eax,%eax
f010123f:	75 f7                	jne    f0101238 <check_page_alloc+0x35>
	assert((pp0 = page_alloc(0)));
f0101241:	83 ec 0c             	sub    $0xc,%esp
f0101244:	6a 00                	push   $0x0
f0101246:	e8 17 ff ff ff       	call   f0101162 <page_alloc>
f010124b:	89 c7                	mov    %eax,%edi
f010124d:	83 c4 10             	add    $0x10,%esp
f0101250:	85 c0                	test   %eax,%eax
f0101252:	0f 84 d3 01 00 00    	je     f010142b <check_page_alloc+0x228>
	assert((pp1 = page_alloc(0)));
f0101258:	83 ec 0c             	sub    $0xc,%esp
f010125b:	6a 00                	push   $0x0
f010125d:	e8 00 ff ff ff       	call   f0101162 <page_alloc>
f0101262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101265:	83 c4 10             	add    $0x10,%esp
f0101268:	85 c0                	test   %eax,%eax
f010126a:	0f 84 d4 01 00 00    	je     f0101444 <check_page_alloc+0x241>
	assert((pp2 = page_alloc(0)));
f0101270:	83 ec 0c             	sub    $0xc,%esp
f0101273:	6a 00                	push   $0x0
f0101275:	e8 e8 fe ff ff       	call   f0101162 <page_alloc>
f010127a:	89 c3                	mov    %eax,%ebx
f010127c:	83 c4 10             	add    $0x10,%esp
f010127f:	85 c0                	test   %eax,%eax
f0101281:	0f 84 d6 01 00 00    	je     f010145d <check_page_alloc+0x25a>
	assert(pp1 && pp1 != pp0);
f0101287:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f010128a:	0f 84 e6 01 00 00    	je     f0101476 <check_page_alloc+0x273>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101290:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0101293:	0f 84 f6 01 00 00    	je     f010148f <check_page_alloc+0x28c>
f0101299:	39 c7                	cmp    %eax,%edi
f010129b:	0f 84 ee 01 00 00    	je     f010148f <check_page_alloc+0x28c>
	assert(page2pa(pp0) < npages * PGSIZE);
f01012a1:	89 f8                	mov    %edi,%eax
f01012a3:	e8 36 f9 ff ff       	call   f0100bde <page2pa>
f01012a8:	8b 0d 88 2e 22 f0    	mov    0xf0222e88,%ecx
f01012ae:	c1 e1 0c             	shl    $0xc,%ecx
f01012b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01012b4:	39 c8                	cmp    %ecx,%eax
f01012b6:	0f 83 ec 01 00 00    	jae    f01014a8 <check_page_alloc+0x2a5>
	assert(page2pa(pp1) < npages * PGSIZE);
f01012bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012bf:	e8 1a f9 ff ff       	call   f0100bde <page2pa>
f01012c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f01012c7:	0f 86 f4 01 00 00    	jbe    f01014c1 <check_page_alloc+0x2be>
	assert(page2pa(pp2) < npages * PGSIZE);
f01012cd:	89 d8                	mov    %ebx,%eax
f01012cf:	e8 0a f9 ff ff       	call   f0100bde <page2pa>
f01012d4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f01012d7:	0f 86 fd 01 00 00    	jbe    f01014da <check_page_alloc+0x2d7>
	fl = page_free_list;
f01012dd:	a1 40 12 22 f0       	mov    0xf0221240,%eax
f01012e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	page_free_list = 0;
f01012e5:	c7 05 40 12 22 f0 00 	movl   $0x0,0xf0221240
f01012ec:	00 00 00 
	assert(!page_alloc(0));
f01012ef:	83 ec 0c             	sub    $0xc,%esp
f01012f2:	6a 00                	push   $0x0
f01012f4:	e8 69 fe ff ff       	call   f0101162 <page_alloc>
f01012f9:	83 c4 10             	add    $0x10,%esp
f01012fc:	85 c0                	test   %eax,%eax
f01012fe:	0f 85 ef 01 00 00    	jne    f01014f3 <check_page_alloc+0x2f0>
	page_free(pp0);
f0101304:	83 ec 0c             	sub    $0xc,%esp
f0101307:	57                   	push   %edi
f0101308:	e8 a0 fe ff ff       	call   f01011ad <page_free>
	page_free(pp1);
f010130d:	83 c4 04             	add    $0x4,%esp
f0101310:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101313:	e8 95 fe ff ff       	call   f01011ad <page_free>
	page_free(pp2);
f0101318:	89 1c 24             	mov    %ebx,(%esp)
f010131b:	e8 8d fe ff ff       	call   f01011ad <page_free>
	assert((pp0 = page_alloc(0)));
f0101320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101327:	e8 36 fe ff ff       	call   f0101162 <page_alloc>
f010132c:	89 c3                	mov    %eax,%ebx
f010132e:	83 c4 10             	add    $0x10,%esp
f0101331:	85 c0                	test   %eax,%eax
f0101333:	0f 84 d3 01 00 00    	je     f010150c <check_page_alloc+0x309>
	assert((pp1 = page_alloc(0)));
f0101339:	83 ec 0c             	sub    $0xc,%esp
f010133c:	6a 00                	push   $0x0
f010133e:	e8 1f fe ff ff       	call   f0101162 <page_alloc>
f0101343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101346:	83 c4 10             	add    $0x10,%esp
f0101349:	85 c0                	test   %eax,%eax
f010134b:	0f 84 d4 01 00 00    	je     f0101525 <check_page_alloc+0x322>
	assert((pp2 = page_alloc(0)));
f0101351:	83 ec 0c             	sub    $0xc,%esp
f0101354:	6a 00                	push   $0x0
f0101356:	e8 07 fe ff ff       	call   f0101162 <page_alloc>
f010135b:	89 c7                	mov    %eax,%edi
f010135d:	83 c4 10             	add    $0x10,%esp
f0101360:	85 c0                	test   %eax,%eax
f0101362:	0f 84 d6 01 00 00    	je     f010153e <check_page_alloc+0x33b>
	assert(pp1 && pp1 != pp0);
f0101368:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010136b:	0f 84 e6 01 00 00    	je     f0101557 <check_page_alloc+0x354>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101371:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0101374:	0f 84 f6 01 00 00    	je     f0101570 <check_page_alloc+0x36d>
f010137a:	39 c3                	cmp    %eax,%ebx
f010137c:	0f 84 ee 01 00 00    	je     f0101570 <check_page_alloc+0x36d>
	assert(!page_alloc(0));
f0101382:	83 ec 0c             	sub    $0xc,%esp
f0101385:	6a 00                	push   $0x0
f0101387:	e8 d6 fd ff ff       	call   f0101162 <page_alloc>
f010138c:	83 c4 10             	add    $0x10,%esp
f010138f:	85 c0                	test   %eax,%eax
f0101391:	0f 85 f2 01 00 00    	jne    f0101589 <check_page_alloc+0x386>
	memset(page2kva(pp0), 1, PGSIZE);
f0101397:	89 d8                	mov    %ebx,%eax
f0101399:	e8 06 f9 ff ff       	call   f0100ca4 <page2kva>
f010139e:	83 ec 04             	sub    $0x4,%esp
f01013a1:	68 00 10 00 00       	push   $0x1000
f01013a6:	6a 01                	push   $0x1
f01013a8:	50                   	push   %eax
f01013a9:	e8 04 44 00 00       	call   f01057b2 <memset>
	page_free(pp0);
f01013ae:	89 1c 24             	mov    %ebx,(%esp)
f01013b1:	e8 f7 fd ff ff       	call   f01011ad <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01013b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01013bd:	e8 a0 fd ff ff       	call   f0101162 <page_alloc>
f01013c2:	83 c4 10             	add    $0x10,%esp
f01013c5:	85 c0                	test   %eax,%eax
f01013c7:	0f 84 d5 01 00 00    	je     f01015a2 <check_page_alloc+0x39f>
	assert(pp && pp0 == pp);
f01013cd:	39 c3                	cmp    %eax,%ebx
f01013cf:	0f 85 e6 01 00 00    	jne    f01015bb <check_page_alloc+0x3b8>
	c = page2kva(pp);
f01013d5:	e8 ca f8 ff ff       	call   f0100ca4 <page2kva>
f01013da:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
		assert(c[i] == 0);
f01013e0:	80 38 00             	cmpb   $0x0,(%eax)
f01013e3:	0f 85 eb 01 00 00    	jne    f01015d4 <check_page_alloc+0x3d1>
f01013e9:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f01013ec:	39 d0                	cmp    %edx,%eax
f01013ee:	75 f0                	jne    f01013e0 <check_page_alloc+0x1dd>
	page_free_list = fl;
f01013f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01013f3:	a3 40 12 22 f0       	mov    %eax,0xf0221240
	page_free(pp0);
f01013f8:	83 ec 0c             	sub    $0xc,%esp
f01013fb:	53                   	push   %ebx
f01013fc:	e8 ac fd ff ff       	call   f01011ad <page_free>
	page_free(pp1);
f0101401:	83 c4 04             	add    $0x4,%esp
f0101404:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101407:	e8 a1 fd ff ff       	call   f01011ad <page_free>
	page_free(pp2);
f010140c:	89 3c 24             	mov    %edi,(%esp)
f010140f:	e8 99 fd ff ff       	call   f01011ad <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101414:	a1 40 12 22 f0       	mov    0xf0221240,%eax
f0101419:	83 c4 10             	add    $0x10,%esp
f010141c:	85 c0                	test   %eax,%eax
f010141e:	0f 84 c9 01 00 00    	je     f01015ed <check_page_alloc+0x3ea>
		--nfree;
f0101424:	83 ee 01             	sub    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101427:	8b 00                	mov    (%eax),%eax
f0101429:	eb f1                	jmp    f010141c <check_page_alloc+0x219>
	assert((pp0 = page_alloc(0)));
f010142b:	68 5f 75 10 f0       	push   $0xf010755f
f0101430:	68 97 74 10 f0       	push   $0xf0107497
f0101435:	68 4e 03 00 00       	push   $0x34e
f010143a:	68 7f 74 10 f0       	push   $0xf010747f
f010143f:	e8 26 ec ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f0101444:	68 75 75 10 f0       	push   $0xf0107575
f0101449:	68 97 74 10 f0       	push   $0xf0107497
f010144e:	68 4f 03 00 00       	push   $0x34f
f0101453:	68 7f 74 10 f0       	push   $0xf010747f
f0101458:	e8 0d ec ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f010145d:	68 8b 75 10 f0       	push   $0xf010758b
f0101462:	68 97 74 10 f0       	push   $0xf0107497
f0101467:	68 50 03 00 00       	push   $0x350
f010146c:	68 7f 74 10 f0       	push   $0xf010747f
f0101471:	e8 f4 eb ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f0101476:	68 a1 75 10 f0       	push   $0xf01075a1
f010147b:	68 97 74 10 f0       	push   $0xf0107497
f0101480:	68 53 03 00 00       	push   $0x353
f0101485:	68 7f 74 10 f0       	push   $0xf010747f
f010148a:	e8 db eb ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010148f:	68 d8 6b 10 f0       	push   $0xf0106bd8
f0101494:	68 97 74 10 f0       	push   $0xf0107497
f0101499:	68 54 03 00 00       	push   $0x354
f010149e:	68 7f 74 10 f0       	push   $0xf010747f
f01014a3:	e8 c2 eb ff ff       	call   f010006a <_panic>
	assert(page2pa(pp0) < npages * PGSIZE);
f01014a8:	68 f8 6b 10 f0       	push   $0xf0106bf8
f01014ad:	68 97 74 10 f0       	push   $0xf0107497
f01014b2:	68 55 03 00 00       	push   $0x355
f01014b7:	68 7f 74 10 f0       	push   $0xf010747f
f01014bc:	e8 a9 eb ff ff       	call   f010006a <_panic>
	assert(page2pa(pp1) < npages * PGSIZE);
f01014c1:	68 18 6c 10 f0       	push   $0xf0106c18
f01014c6:	68 97 74 10 f0       	push   $0xf0107497
f01014cb:	68 56 03 00 00       	push   $0x356
f01014d0:	68 7f 74 10 f0       	push   $0xf010747f
f01014d5:	e8 90 eb ff ff       	call   f010006a <_panic>
	assert(page2pa(pp2) < npages * PGSIZE);
f01014da:	68 38 6c 10 f0       	push   $0xf0106c38
f01014df:	68 97 74 10 f0       	push   $0xf0107497
f01014e4:	68 57 03 00 00       	push   $0x357
f01014e9:	68 7f 74 10 f0       	push   $0xf010747f
f01014ee:	e8 77 eb ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f01014f3:	68 b3 75 10 f0       	push   $0xf01075b3
f01014f8:	68 97 74 10 f0       	push   $0xf0107497
f01014fd:	68 5e 03 00 00       	push   $0x35e
f0101502:	68 7f 74 10 f0       	push   $0xf010747f
f0101507:	e8 5e eb ff ff       	call   f010006a <_panic>
	assert((pp0 = page_alloc(0)));
f010150c:	68 5f 75 10 f0       	push   $0xf010755f
f0101511:	68 97 74 10 f0       	push   $0xf0107497
f0101516:	68 65 03 00 00       	push   $0x365
f010151b:	68 7f 74 10 f0       	push   $0xf010747f
f0101520:	e8 45 eb ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f0101525:	68 75 75 10 f0       	push   $0xf0107575
f010152a:	68 97 74 10 f0       	push   $0xf0107497
f010152f:	68 66 03 00 00       	push   $0x366
f0101534:	68 7f 74 10 f0       	push   $0xf010747f
f0101539:	e8 2c eb ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f010153e:	68 8b 75 10 f0       	push   $0xf010758b
f0101543:	68 97 74 10 f0       	push   $0xf0107497
f0101548:	68 67 03 00 00       	push   $0x367
f010154d:	68 7f 74 10 f0       	push   $0xf010747f
f0101552:	e8 13 eb ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f0101557:	68 a1 75 10 f0       	push   $0xf01075a1
f010155c:	68 97 74 10 f0       	push   $0xf0107497
f0101561:	68 69 03 00 00       	push   $0x369
f0101566:	68 7f 74 10 f0       	push   $0xf010747f
f010156b:	e8 fa ea ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101570:	68 d8 6b 10 f0       	push   $0xf0106bd8
f0101575:	68 97 74 10 f0       	push   $0xf0107497
f010157a:	68 6a 03 00 00       	push   $0x36a
f010157f:	68 7f 74 10 f0       	push   $0xf010747f
f0101584:	e8 e1 ea ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0101589:	68 b3 75 10 f0       	push   $0xf01075b3
f010158e:	68 97 74 10 f0       	push   $0xf0107497
f0101593:	68 6b 03 00 00       	push   $0x36b
f0101598:	68 7f 74 10 f0       	push   $0xf010747f
f010159d:	e8 c8 ea ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01015a2:	68 c2 75 10 f0       	push   $0xf01075c2
f01015a7:	68 97 74 10 f0       	push   $0xf0107497
f01015ac:	68 70 03 00 00       	push   $0x370
f01015b1:	68 7f 74 10 f0       	push   $0xf010747f
f01015b6:	e8 af ea ff ff       	call   f010006a <_panic>
	assert(pp && pp0 == pp);
f01015bb:	68 e0 75 10 f0       	push   $0xf01075e0
f01015c0:	68 97 74 10 f0       	push   $0xf0107497
f01015c5:	68 71 03 00 00       	push   $0x371
f01015ca:	68 7f 74 10 f0       	push   $0xf010747f
f01015cf:	e8 96 ea ff ff       	call   f010006a <_panic>
		assert(c[i] == 0);
f01015d4:	68 f0 75 10 f0       	push   $0xf01075f0
f01015d9:	68 97 74 10 f0       	push   $0xf0107497
f01015de:	68 74 03 00 00       	push   $0x374
f01015e3:	68 7f 74 10 f0       	push   $0xf010747f
f01015e8:	e8 7d ea ff ff       	call   f010006a <_panic>
	assert(nfree == 0);
f01015ed:	85 f6                	test   %esi,%esi
f01015ef:	75 18                	jne    f0101609 <check_page_alloc+0x406>
	cprintf("check_page_alloc() succeeded!\n");
f01015f1:	83 ec 0c             	sub    $0xc,%esp
f01015f4:	68 58 6c 10 f0       	push   $0xf0106c58
f01015f9:	e8 be 23 00 00       	call   f01039bc <cprintf>
}
f01015fe:	83 c4 10             	add    $0x10,%esp
f0101601:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101604:	5b                   	pop    %ebx
f0101605:	5e                   	pop    %esi
f0101606:	5f                   	pop    %edi
f0101607:	5d                   	pop    %ebp
f0101608:	c3                   	ret    
	assert(nfree == 0);
f0101609:	68 fa 75 10 f0       	push   $0xf01075fa
f010160e:	68 97 74 10 f0       	push   $0xf0107497
f0101613:	68 81 03 00 00       	push   $0x381
f0101618:	68 7f 74 10 f0       	push   $0xf010747f
f010161d:	e8 48 ea ff ff       	call   f010006a <_panic>

f0101622 <page_decref>:
{
f0101622:	f3 0f 1e fb          	endbr32 
f0101626:	55                   	push   %ebp
f0101627:	89 e5                	mov    %esp,%ebp
f0101629:	83 ec 08             	sub    $0x8,%esp
f010162c:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f010162f:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0101633:	83 e8 01             	sub    $0x1,%eax
f0101636:	66 89 42 04          	mov    %ax,0x4(%edx)
f010163a:	66 85 c0             	test   %ax,%ax
f010163d:	74 02                	je     f0101641 <page_decref+0x1f>
}
f010163f:	c9                   	leave  
f0101640:	c3                   	ret    
		page_free(pp);
f0101641:	83 ec 0c             	sub    $0xc,%esp
f0101644:	52                   	push   %edx
f0101645:	e8 63 fb ff ff       	call   f01011ad <page_free>
f010164a:	83 c4 10             	add    $0x10,%esp
}
f010164d:	eb f0                	jmp    f010163f <page_decref+0x1d>

f010164f <pgdir_walk>:
{
f010164f:	f3 0f 1e fb          	endbr32 
f0101653:	55                   	push   %ebp
f0101654:	89 e5                	mov    %esp,%ebp
f0101656:	57                   	push   %edi
f0101657:	56                   	push   %esi
f0101658:	53                   	push   %ebx
f0101659:	83 ec 0c             	sub    $0xc,%esp
f010165c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int page_directory_index = PDX(va);
f010165f:	89 ce                	mov    %ecx,%esi
f0101661:	c1 ee 16             	shr    $0x16,%esi
	pte_t *page_table_entry = (pte_t *) PTE_ADDR(pgdir[page_directory_index]);
f0101664:	c1 e6 02             	shl    $0x2,%esi
f0101667:	03 75 08             	add    0x8(%ebp),%esi
	int page_table_index = PTX(va);
f010166a:	c1 e9 0a             	shr    $0xa,%ecx
	pte_t *result = page_table_entry + page_table_index;
f010166d:	89 cf                	mov    %ecx,%edi
f010166f:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
	if (!page_table_entry) {
f0101675:	8b 0e                	mov    (%esi),%ecx
f0101677:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010167d:	75 4b                	jne    f01016ca <pgdir_walk+0x7b>
			return NULL;
f010167f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (create == false)
f0101684:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101688:	74 36                	je     f01016c0 <pgdir_walk+0x71>
		page = page_alloc(ALLOC_ZERO);
f010168a:	83 ec 0c             	sub    $0xc,%esp
f010168d:	6a 01                	push   $0x1
f010168f:	e8 ce fa ff ff       	call   f0101162 <page_alloc>
f0101694:	89 c3                	mov    %eax,%ebx
		if (!page)
f0101696:	83 c4 10             	add    $0x10,%esp
f0101699:	85 c0                	test   %eax,%eax
f010169b:	74 23                	je     f01016c0 <pgdir_walk+0x71>
		physical_addr = page2pa(page);
f010169d:	e8 3c f5 ff ff       	call   f0100bde <page2pa>
f01016a2:	89 c1                	mov    %eax,%ecx
		        physical_addr | PTE_P | PTE_W | PTE_U;
f01016a4:	83 c8 07             	or     $0x7,%eax
f01016a7:	89 06                	mov    %eax,(%esi)
		page->pp_ref++;
f01016a9:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
		return (pte_t *) KADDR(physical_addr) + page_table_index;
f01016ae:	ba d8 01 00 00       	mov    $0x1d8,%edx
f01016b3:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f01016b8:	e8 bb f5 ff ff       	call   f0100c78 <_kaddr>
f01016bd:	8d 1c 38             	lea    (%eax,%edi,1),%ebx
}
f01016c0:	89 d8                	mov    %ebx,%eax
f01016c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01016c5:	5b                   	pop    %ebx
f01016c6:	5e                   	pop    %esi
f01016c7:	5f                   	pop    %edi
f01016c8:	5d                   	pop    %ebp
f01016c9:	c3                   	ret    
	pte_t *result = page_table_entry + page_table_index;
f01016ca:	01 f9                	add    %edi,%ecx
	return KADDR((physaddr_t) result);
f01016cc:	ba da 01 00 00       	mov    $0x1da,%edx
f01016d1:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f01016d6:	e8 9d f5 ff ff       	call   f0100c78 <_kaddr>
f01016db:	89 c3                	mov    %eax,%ebx
f01016dd:	eb e1                	jmp    f01016c0 <pgdir_walk+0x71>

f01016df <boot_map_region>:
{
f01016df:	55                   	push   %ebp
f01016e0:	89 e5                	mov    %esp,%ebp
f01016e2:	57                   	push   %edi
f01016e3:	56                   	push   %esi
f01016e4:	53                   	push   %ebx
f01016e5:	83 ec 1c             	sub    $0x1c,%esp
f01016e8:	89 c7                	mov    %eax,%edi
f01016ea:	8b 45 08             	mov    0x8(%ebp),%eax
f01016ed:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01016f3:	01 c1                	add    %eax,%ecx
f01016f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	while (size >= PGSIZE) {
f01016f8:	89 c3                	mov    %eax,%ebx
		pte_t *page_table_entry = pgdir_walk(pgdir, (void *) va, 1);
f01016fa:	89 d6                	mov    %edx,%esi
f01016fc:	29 c6                	sub    %eax,%esi
	while (size >= PGSIZE) {
f01016fe:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101701:	74 3f                	je     f0101742 <boot_map_region+0x63>
		pte_t *page_table_entry = pgdir_walk(pgdir, (void *) va, 1);
f0101703:	83 ec 04             	sub    $0x4,%esp
f0101706:	6a 01                	push   $0x1
f0101708:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010170b:	50                   	push   %eax
f010170c:	57                   	push   %edi
f010170d:	e8 3d ff ff ff       	call   f010164f <pgdir_walk>
		if (page_table_entry == NULL) {
f0101712:	83 c4 10             	add    $0x10,%esp
f0101715:	85 c0                	test   %eax,%eax
f0101717:	74 12                	je     f010172b <boot_map_region+0x4c>
		*page_table_entry = pa | perm | PTE_P;
f0101719:	89 da                	mov    %ebx,%edx
f010171b:	0b 55 0c             	or     0xc(%ebp),%edx
f010171e:	83 ca 01             	or     $0x1,%edx
f0101721:	89 10                	mov    %edx,(%eax)
		pa = pa + PGSIZE;
f0101723:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101729:	eb d3                	jmp    f01016fe <boot_map_region+0x1f>
			panic("boot_map_region: No hay suficiente memoria.");
f010172b:	83 ec 04             	sub    $0x4,%esp
f010172e:	68 78 6c 10 f0       	push   $0xf0106c78
f0101733:	68 f3 01 00 00       	push   $0x1f3
f0101738:	68 7f 74 10 f0       	push   $0xf010747f
f010173d:	e8 28 e9 ff ff       	call   f010006a <_panic>
}
f0101742:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101745:	5b                   	pop    %ebx
f0101746:	5e                   	pop    %esi
f0101747:	5f                   	pop    %edi
f0101748:	5d                   	pop    %ebp
f0101749:	c3                   	ret    

f010174a <mem_init_mp>:
{
f010174a:	55                   	push   %ebp
f010174b:	89 e5                	mov    %esp,%ebp
f010174d:	57                   	push   %edi
f010174e:	56                   	push   %esi
f010174f:	53                   	push   %ebx
f0101750:	83 ec 0c             	sub    $0xc,%esp
f0101753:	bb 00 40 22 f0       	mov    $0xf0224000,%ebx
f0101758:	bf 00 40 26 f0       	mov    $0xf0264000,%edi
f010175d:	be 00 80 ff ef       	mov    $0xefff8000,%esi
		boot_map_region(kern_pgdir,
f0101762:	89 d9                	mov    %ebx,%ecx
f0101764:	ba 2f 01 00 00       	mov    $0x12f,%edx
f0101769:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f010176e:	e8 b7 f5 ff ff       	call   f0100d2a <_paddr>
f0101773:	83 ec 08             	sub    $0x8,%esp
f0101776:	6a 02                	push   $0x2
f0101778:	50                   	push   %eax
f0101779:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010177e:	89 f2                	mov    %esi,%edx
f0101780:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0101785:	e8 55 ff ff ff       	call   f01016df <boot_map_region>
f010178a:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0101790:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f0101796:	83 c4 10             	add    $0x10,%esp
f0101799:	39 fb                	cmp    %edi,%ebx
f010179b:	75 c5                	jne    f0101762 <mem_init_mp+0x18>
}
f010179d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01017a0:	5b                   	pop    %ebx
f01017a1:	5e                   	pop    %esi
f01017a2:	5f                   	pop    %edi
f01017a3:	5d                   	pop    %ebp
f01017a4:	c3                   	ret    

f01017a5 <check_kern_pgdir>:
{
f01017a5:	55                   	push   %ebp
f01017a6:	89 e5                	mov    %esp,%ebp
f01017a8:	57                   	push   %edi
f01017a9:	56                   	push   %esi
f01017aa:	53                   	push   %ebx
f01017ab:	83 ec 1c             	sub    $0x1c,%esp
	pgdir = kern_pgdir;
f01017ae:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f01017b4:	a1 88 2e 22 f0       	mov    0xf0222e88,%eax
f01017b9:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01017c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01017c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (i = 0; i < n; i += PGSIZE) {
f01017c8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01017cd:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
f01017d0:	0f 83 83 00 00 00    	jae    f0101859 <check_kern_pgdir+0xb4>
f01017d6:	8d b3 00 00 00 ef    	lea    -0x11000000(%ebx),%esi
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01017dc:	89 f2                	mov    %esi,%edx
f01017de:	89 f8                	mov    %edi,%eax
f01017e0:	e8 dd f4 ff ff       	call   f0100cc2 <check_va2pa>
f01017e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01017e8:	8b 0d 90 2e 22 f0    	mov    0xf0222e90,%ecx
f01017ee:	ba 9a 03 00 00       	mov    $0x39a,%edx
f01017f3:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f01017f8:	e8 2d f5 ff ff       	call   f0100d2a <_paddr>
f01017fd:	01 d8                	add    %ebx,%eax
f01017ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0101802:	75 23                	jne    f0101827 <check_kern_pgdir+0x82>
		pte = pgdir_walk(pgdir, (void *) (UPAGES + i), 0);
f0101804:	83 ec 04             	sub    $0x4,%esp
f0101807:	6a 00                	push   $0x0
f0101809:	56                   	push   %esi
f010180a:	57                   	push   %edi
f010180b:	e8 3f fe ff ff       	call   f010164f <pgdir_walk>
		assert(PGOFF(*pte) == (PTE_U | PTE_P));
f0101810:	8b 00                	mov    (%eax),%eax
f0101812:	25 ff 0f 00 00       	and    $0xfff,%eax
f0101817:	83 c4 10             	add    $0x10,%esp
f010181a:	83 f8 05             	cmp    $0x5,%eax
f010181d:	75 21                	jne    f0101840 <check_kern_pgdir+0x9b>
	for (i = 0; i < n; i += PGSIZE) {
f010181f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101825:	eb a6                	jmp    f01017cd <check_kern_pgdir+0x28>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0101827:	68 a4 6c 10 f0       	push   $0xf0106ca4
f010182c:	68 97 74 10 f0       	push   $0xf0107497
f0101831:	68 9a 03 00 00       	push   $0x39a
f0101836:	68 7f 74 10 f0       	push   $0xf010747f
f010183b:	e8 2a e8 ff ff       	call   f010006a <_panic>
		assert(PGOFF(*pte) == (PTE_U | PTE_P));
f0101840:	68 d8 6c 10 f0       	push   $0xf0106cd8
f0101845:	68 97 74 10 f0       	push   $0xf0107497
f010184a:	68 9d 03 00 00       	push   $0x39d
f010184f:	68 7f 74 10 f0       	push   $0xf010747f
f0101854:	e8 11 e8 ff ff       	call   f010006a <_panic>
f0101859:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010185e:	89 da                	mov    %ebx,%edx
f0101860:	89 f8                	mov    %edi,%eax
f0101862:	e8 5b f4 ff ff       	call   f0100cc2 <check_va2pa>
f0101867:	89 c6                	mov    %eax,%esi
f0101869:	8b 0d 44 12 22 f0    	mov    0xf0221244,%ecx
f010186f:	ba a3 03 00 00       	mov    $0x3a3,%edx
f0101874:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0101879:	e8 ac f4 ff ff       	call   f0100d2a <_paddr>
f010187e:	8d 84 03 00 00 40 11 	lea    0x11400000(%ebx,%eax,1),%eax
f0101885:	39 c6                	cmp    %eax,%esi
f0101887:	75 54                	jne    f01018dd <check_kern_pgdir+0x138>
		pte = pgdir_walk(pgdir, (void *) (UENVS + i), 0);
f0101889:	83 ec 04             	sub    $0x4,%esp
f010188c:	6a 00                	push   $0x0
f010188e:	53                   	push   %ebx
f010188f:	57                   	push   %edi
f0101890:	e8 ba fd ff ff       	call   f010164f <pgdir_walk>
		assert(PGOFF(*pte) == (PTE_U | PTE_P));
f0101895:	8b 00                	mov    (%eax),%eax
f0101897:	25 ff 0f 00 00       	and    $0xfff,%eax
f010189c:	83 c4 10             	add    $0x10,%esp
f010189f:	83 f8 05             	cmp    $0x5,%eax
f01018a2:	75 52                	jne    f01018f6 <check_kern_pgdir+0x151>
f01018a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE) {
f01018aa:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f01018b0:	75 ac                	jne    f010185e <check_kern_pgdir+0xb9>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01018b2:	8b 35 88 2e 22 f0    	mov    0xf0222e88,%esi
f01018b8:	c1 e6 0c             	shl    $0xc,%esi
f01018bb:	bb 00 00 00 00       	mov    $0x0,%ebx
f01018c0:	39 de                	cmp    %ebx,%esi
f01018c2:	76 64                	jbe    f0101928 <check_kern_pgdir+0x183>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01018c4:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f01018ca:	89 f8                	mov    %edi,%eax
f01018cc:	e8 f1 f3 ff ff       	call   f0100cc2 <check_va2pa>
f01018d1:	39 d8                	cmp    %ebx,%eax
f01018d3:	75 3a                	jne    f010190f <check_kern_pgdir+0x16a>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01018d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01018db:	eb e3                	jmp    f01018c0 <check_kern_pgdir+0x11b>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01018dd:	68 f8 6c 10 f0       	push   $0xf0106cf8
f01018e2:	68 97 74 10 f0       	push   $0xf0107497
f01018e7:	68 a3 03 00 00       	push   $0x3a3
f01018ec:	68 7f 74 10 f0       	push   $0xf010747f
f01018f1:	e8 74 e7 ff ff       	call   f010006a <_panic>
		assert(PGOFF(*pte) == (PTE_U | PTE_P));
f01018f6:	68 d8 6c 10 f0       	push   $0xf0106cd8
f01018fb:	68 97 74 10 f0       	push   $0xf0107497
f0101900:	68 a6 03 00 00       	push   $0x3a6
f0101905:	68 7f 74 10 f0       	push   $0xf010747f
f010190a:	e8 5b e7 ff ff       	call   f010006a <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010190f:	68 2c 6d 10 f0       	push   $0xf0106d2c
f0101914:	68 97 74 10 f0       	push   $0xf0107497
f0101919:	68 ab 03 00 00       	push   $0x3ab
f010191e:	68 7f 74 10 f0       	push   $0xf010747f
f0101923:	e8 42 e7 ff ff       	call   f010006a <_panic>
f0101928:	c7 45 dc 00 40 22 f0 	movl   $0xf0224000,-0x24(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010192f:	b8 00 80 ff ef       	mov    $0xefff8000,%eax
f0101934:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0101937:	89 c7                	mov    %eax,%edi
f0101939:	8d b7 00 80 ff ff    	lea    -0x8000(%edi),%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f010193f:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101942:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0101945:	bb 00 00 00 00       	mov    $0x0,%ebx
f010194a:	89 75 d8             	mov    %esi,-0x28(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f010194d:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0101950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101953:	e8 6a f3 ff ff       	call   f0100cc2 <check_va2pa>
f0101958:	89 c6                	mov    %eax,%esi
f010195a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010195d:	ba b3 03 00 00       	mov    $0x3b3,%edx
f0101962:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0101967:	e8 be f3 ff ff       	call   f0100d2a <_paddr>
f010196c:	01 d8                	add    %ebx,%eax
f010196e:	39 c6                	cmp    %eax,%esi
f0101970:	75 4d                	jne    f01019bf <check_kern_pgdir+0x21a>
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0101972:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101978:	81 fb 00 80 00 00    	cmp    $0x8000,%ebx
f010197e:	75 cd                	jne    f010194d <check_kern_pgdir+0x1a8>
f0101980:	8b 75 d8             	mov    -0x28(%ebp),%esi
f0101983:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0101986:	89 f2                	mov    %esi,%edx
f0101988:	89 d8                	mov    %ebx,%eax
f010198a:	e8 33 f3 ff ff       	call   f0100cc2 <check_va2pa>
f010198f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101992:	75 44                	jne    f01019d8 <check_kern_pgdir+0x233>
f0101994:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f010199a:	39 fe                	cmp    %edi,%esi
f010199c:	75 e8                	jne    f0101986 <check_kern_pgdir+0x1e1>
f010199e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f01019a1:	81 ef 00 00 01 00    	sub    $0x10000,%edi
f01019a7:	81 45 dc 00 80 00 00 	addl   $0x8000,-0x24(%ebp)
	for (n = 0; n < NCPU; n++) {
f01019ae:	81 ff 00 80 f7 ef    	cmp    $0xeff78000,%edi
f01019b4:	75 83                	jne    f0101939 <check_kern_pgdir+0x194>
f01019b6:	89 df                	mov    %ebx,%edi
	for (i = 0; i < NPDENTRIES; i++) {
f01019b8:	b8 00 00 00 00       	mov    $0x0,%eax
f01019bd:	eb 68                	jmp    f0101a27 <check_kern_pgdir+0x282>
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f01019bf:	68 54 6d 10 f0       	push   $0xf0106d54
f01019c4:	68 97 74 10 f0       	push   $0xf0107497
f01019c9:	68 b2 03 00 00       	push   $0x3b2
f01019ce:	68 7f 74 10 f0       	push   $0xf010747f
f01019d3:	e8 92 e6 ff ff       	call   f010006a <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f01019d8:	68 9c 6d 10 f0       	push   $0xf0106d9c
f01019dd:	68 97 74 10 f0       	push   $0xf0107497
f01019e2:	68 b5 03 00 00       	push   $0x3b5
f01019e7:	68 7f 74 10 f0       	push   $0xf010747f
f01019ec:	e8 79 e6 ff ff       	call   f010006a <_panic>
			assert(pgdir[i] & PTE_P);
f01019f1:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f01019f5:	75 48                	jne    f0101a3f <check_kern_pgdir+0x29a>
f01019f7:	68 05 76 10 f0       	push   $0xf0107605
f01019fc:	68 97 74 10 f0       	push   $0xf0107497
f0101a01:	68 c0 03 00 00       	push   $0x3c0
f0101a06:	68 7f 74 10 f0       	push   $0xf010747f
f0101a0b:	e8 5a e6 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] & PTE_P);
f0101a10:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0101a13:	f6 c2 01             	test   $0x1,%dl
f0101a16:	74 2c                	je     f0101a44 <check_kern_pgdir+0x29f>
				assert(pgdir[i] & PTE_W);
f0101a18:	f6 c2 02             	test   $0x2,%dl
f0101a1b:	74 40                	je     f0101a5d <check_kern_pgdir+0x2b8>
	for (i = 0; i < NPDENTRIES; i++) {
f0101a1d:	83 c0 01             	add    $0x1,%eax
f0101a20:	3d 00 04 00 00       	cmp    $0x400,%eax
f0101a25:	74 68                	je     f0101a8f <check_kern_pgdir+0x2ea>
		switch (i) {
f0101a27:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0101a2d:	83 fa 04             	cmp    $0x4,%edx
f0101a30:	76 bf                	jbe    f01019f1 <check_kern_pgdir+0x24c>
			if (i >= PDX(KERNBASE)) {
f0101a32:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0101a37:	77 d7                	ja     f0101a10 <check_kern_pgdir+0x26b>
				assert(pgdir[i] == 0);
f0101a39:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0101a3d:	75 37                	jne    f0101a76 <check_kern_pgdir+0x2d1>
	for (i = 0; i < NPDENTRIES; i++) {
f0101a3f:	83 c0 01             	add    $0x1,%eax
f0101a42:	eb e3                	jmp    f0101a27 <check_kern_pgdir+0x282>
				assert(pgdir[i] & PTE_P);
f0101a44:	68 05 76 10 f0       	push   $0xf0107605
f0101a49:	68 97 74 10 f0       	push   $0xf0107497
f0101a4e:	68 c4 03 00 00       	push   $0x3c4
f0101a53:	68 7f 74 10 f0       	push   $0xf010747f
f0101a58:	e8 0d e6 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] & PTE_W);
f0101a5d:	68 16 76 10 f0       	push   $0xf0107616
f0101a62:	68 97 74 10 f0       	push   $0xf0107497
f0101a67:	68 c5 03 00 00       	push   $0x3c5
f0101a6c:	68 7f 74 10 f0       	push   $0xf010747f
f0101a71:	e8 f4 e5 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] == 0);
f0101a76:	68 27 76 10 f0       	push   $0xf0107627
f0101a7b:	68 97 74 10 f0       	push   $0xf0107497
f0101a80:	68 c7 03 00 00       	push   $0x3c7
f0101a85:	68 7f 74 10 f0       	push   $0xf010747f
f0101a8a:	e8 db e5 ff ff       	call   f010006a <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0101a8f:	83 ec 0c             	sub    $0xc,%esp
f0101a92:	68 c0 6d 10 f0       	push   $0xf0106dc0
f0101a97:	e8 20 1f 00 00       	call   f01039bc <cprintf>
}
f0101a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101a9f:	5b                   	pop    %ebx
f0101aa0:	5e                   	pop    %esi
f0101aa1:	5f                   	pop    %edi
f0101aa2:	5d                   	pop    %ebp
f0101aa3:	c3                   	ret    

f0101aa4 <page_lookup>:
{
f0101aa4:	f3 0f 1e fb          	endbr32 
f0101aa8:	55                   	push   %ebp
f0101aa9:	89 e5                	mov    %esp,%ebp
f0101aab:	53                   	push   %ebx
f0101aac:	83 ec 08             	sub    $0x8,%esp
f0101aaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *page_table_entry = pgdir_walk(pgdir, va, 0);
f0101ab2:	6a 00                	push   $0x0
f0101ab4:	ff 75 0c             	pushl  0xc(%ebp)
f0101ab7:	ff 75 08             	pushl  0x8(%ebp)
f0101aba:	e8 90 fb ff ff       	call   f010164f <pgdir_walk>
	if (!page_table_entry)
f0101abf:	83 c4 10             	add    $0x10,%esp
f0101ac2:	85 c0                	test   %eax,%eax
f0101ac4:	74 12                	je     f0101ad8 <page_lookup+0x34>
	if (pte_store)
f0101ac6:	85 db                	test   %ebx,%ebx
f0101ac8:	74 02                	je     f0101acc <page_lookup+0x28>
		*pte_store = page_table_entry;
f0101aca:	89 03                	mov    %eax,(%ebx)
	return pa2page(PTE_ADDR(*page_table_entry));
f0101acc:	8b 00                	mov    (%eax),%eax
f0101ace:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101ad3:	e8 9f f5 ff ff       	call   f0101077 <pa2page>
}
f0101ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101adb:	c9                   	leave  
f0101adc:	c3                   	ret    

f0101add <tlb_invalidate>:
{
f0101add:	f3 0f 1e fb          	endbr32 
f0101ae1:	55                   	push   %ebp
f0101ae2:	89 e5                	mov    %esp,%ebp
f0101ae4:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101ae7:	e8 54 43 00 00       	call   f0105e40 <cpunum>
f0101aec:	6b c0 74             	imul   $0x74,%eax,%eax
f0101aef:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f0101af6:	74 16                	je     f0101b0e <tlb_invalidate+0x31>
f0101af8:	e8 43 43 00 00       	call   f0105e40 <cpunum>
f0101afd:	6b c0 74             	imul   $0x74,%eax,%eax
f0101b00:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0101b06:	8b 55 08             	mov    0x8(%ebp),%edx
f0101b09:	39 50 60             	cmp    %edx,0x60(%eax)
f0101b0c:	75 08                	jne    f0101b16 <tlb_invalidate+0x39>
		invlpg(va);
f0101b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101b11:	e8 b8 f0 ff ff       	call   f0100bce <invlpg>
}
f0101b16:	c9                   	leave  
f0101b17:	c3                   	ret    

f0101b18 <page_remove>:
{
f0101b18:	f3 0f 1e fb          	endbr32 
f0101b1c:	55                   	push   %ebp
f0101b1d:	89 e5                	mov    %esp,%ebp
f0101b1f:	57                   	push   %edi
f0101b20:	56                   	push   %esi
f0101b21:	53                   	push   %ebx
f0101b22:	83 ec 10             	sub    $0x10,%esp
f0101b25:	8b 75 08             	mov    0x8(%ebp),%esi
f0101b28:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct PageInfo *page = page_lookup(pgdir, va, NULL);
f0101b2b:	6a 00                	push   $0x0
f0101b2d:	57                   	push   %edi
f0101b2e:	56                   	push   %esi
f0101b2f:	e8 70 ff ff ff       	call   f0101aa4 <page_lookup>
	if (!page)
f0101b34:	83 c4 10             	add    $0x10,%esp
f0101b37:	85 c0                	test   %eax,%eax
f0101b39:	74 31                	je     f0101b6c <page_remove+0x54>
f0101b3b:	89 c3                	mov    %eax,%ebx
	pte_t *page_table_entry = pgdir_walk(pgdir, va, false);
f0101b3d:	83 ec 04             	sub    $0x4,%esp
f0101b40:	6a 00                	push   $0x0
f0101b42:	57                   	push   %edi
f0101b43:	56                   	push   %esi
f0101b44:	e8 06 fb ff ff       	call   f010164f <pgdir_walk>
	if (page_table_entry)
f0101b49:	83 c4 10             	add    $0x10,%esp
f0101b4c:	85 c0                	test   %eax,%eax
f0101b4e:	74 06                	je     f0101b56 <page_remove+0x3e>
		*page_table_entry = 0;
f0101b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	page_decref(page);
f0101b56:	83 ec 0c             	sub    $0xc,%esp
f0101b59:	53                   	push   %ebx
f0101b5a:	e8 c3 fa ff ff       	call   f0101622 <page_decref>
	tlb_invalidate(pgdir, va);
f0101b5f:	83 c4 08             	add    $0x8,%esp
f0101b62:	57                   	push   %edi
f0101b63:	56                   	push   %esi
f0101b64:	e8 74 ff ff ff       	call   f0101add <tlb_invalidate>
f0101b69:	83 c4 10             	add    $0x10,%esp
}
f0101b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101b6f:	5b                   	pop    %ebx
f0101b70:	5e                   	pop    %esi
f0101b71:	5f                   	pop    %edi
f0101b72:	5d                   	pop    %ebp
f0101b73:	c3                   	ret    

f0101b74 <page_insert>:
{
f0101b74:	f3 0f 1e fb          	endbr32 
f0101b78:	55                   	push   %ebp
f0101b79:	89 e5                	mov    %esp,%ebp
f0101b7b:	57                   	push   %edi
f0101b7c:	56                   	push   %esi
f0101b7d:	53                   	push   %ebx
f0101b7e:	83 ec 10             	sub    $0x10,%esp
f0101b81:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101b84:	8b 7d 10             	mov    0x10(%ebp),%edi
	pte_t *page_table_entry = pgdir_walk(pgdir, va, 1);
f0101b87:	6a 01                	push   $0x1
f0101b89:	57                   	push   %edi
f0101b8a:	ff 75 08             	pushl  0x8(%ebp)
f0101b8d:	e8 bd fa ff ff       	call   f010164f <pgdir_walk>
	if (!page_table_entry)
f0101b92:	83 c4 10             	add    $0x10,%esp
f0101b95:	85 c0                	test   %eax,%eax
f0101b97:	74 39                	je     f0101bd2 <page_insert+0x5e>
f0101b99:	89 c3                	mov    %eax,%ebx
	pp->pp_ref++;
f0101b9b:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	if ((*page_table_entry) & PTE_P) {
f0101ba0:	f6 00 01             	testb  $0x1,(%eax)
f0101ba3:	75 1c                	jne    f0101bc1 <page_insert+0x4d>
	*page_table_entry = page2pa(pp) | perm | PTE_P;
f0101ba5:	89 f0                	mov    %esi,%eax
f0101ba7:	e8 32 f0 ff ff       	call   f0100bde <page2pa>
f0101bac:	0b 45 14             	or     0x14(%ebp),%eax
f0101baf:	83 c8 01             	or     $0x1,%eax
f0101bb2:	89 03                	mov    %eax,(%ebx)
	return 0;
f0101bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101bbc:	5b                   	pop    %ebx
f0101bbd:	5e                   	pop    %esi
f0101bbe:	5f                   	pop    %edi
f0101bbf:	5d                   	pop    %ebp
f0101bc0:	c3                   	ret    
		page_remove(pgdir, va);
f0101bc1:	83 ec 08             	sub    $0x8,%esp
f0101bc4:	57                   	push   %edi
f0101bc5:	ff 75 08             	pushl  0x8(%ebp)
f0101bc8:	e8 4b ff ff ff       	call   f0101b18 <page_remove>
f0101bcd:	83 c4 10             	add    $0x10,%esp
f0101bd0:	eb d3                	jmp    f0101ba5 <page_insert+0x31>
		return -E_NO_MEM;
f0101bd2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101bd7:	eb e0                	jmp    f0101bb9 <page_insert+0x45>

f0101bd9 <check_page_installed_pgdir>:
}

// check page_insert, page_remove, &c, with an installed kern_pgdir
static void
check_page_installed_pgdir(void)
{
f0101bd9:	55                   	push   %ebp
f0101bda:	89 e5                	mov    %esp,%ebp
f0101bdc:	57                   	push   %edi
f0101bdd:	56                   	push   %esi
f0101bde:	53                   	push   %ebx
f0101bdf:	83 ec 18             	sub    $0x18,%esp
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101be2:	6a 00                	push   $0x0
f0101be4:	e8 79 f5 ff ff       	call   f0101162 <page_alloc>
f0101be9:	83 c4 10             	add    $0x10,%esp
f0101bec:	85 c0                	test   %eax,%eax
f0101bee:	0f 84 67 01 00 00    	je     f0101d5b <check_page_installed_pgdir+0x182>
f0101bf4:	89 c6                	mov    %eax,%esi
	assert((pp1 = page_alloc(0)));
f0101bf6:	83 ec 0c             	sub    $0xc,%esp
f0101bf9:	6a 00                	push   $0x0
f0101bfb:	e8 62 f5 ff ff       	call   f0101162 <page_alloc>
f0101c00:	89 c7                	mov    %eax,%edi
f0101c02:	83 c4 10             	add    $0x10,%esp
f0101c05:	85 c0                	test   %eax,%eax
f0101c07:	0f 84 67 01 00 00    	je     f0101d74 <check_page_installed_pgdir+0x19b>
	assert((pp2 = page_alloc(0)));
f0101c0d:	83 ec 0c             	sub    $0xc,%esp
f0101c10:	6a 00                	push   $0x0
f0101c12:	e8 4b f5 ff ff       	call   f0101162 <page_alloc>
f0101c17:	89 c3                	mov    %eax,%ebx
f0101c19:	83 c4 10             	add    $0x10,%esp
f0101c1c:	85 c0                	test   %eax,%eax
f0101c1e:	0f 84 69 01 00 00    	je     f0101d8d <check_page_installed_pgdir+0x1b4>
	page_free(pp0);
f0101c24:	83 ec 0c             	sub    $0xc,%esp
f0101c27:	56                   	push   %esi
f0101c28:	e8 80 f5 ff ff       	call   f01011ad <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f0101c2d:	89 f8                	mov    %edi,%eax
f0101c2f:	e8 70 f0 ff ff       	call   f0100ca4 <page2kva>
f0101c34:	83 c4 0c             	add    $0xc,%esp
f0101c37:	68 00 10 00 00       	push   $0x1000
f0101c3c:	6a 01                	push   $0x1
f0101c3e:	50                   	push   %eax
f0101c3f:	e8 6e 3b 00 00       	call   f01057b2 <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0101c44:	89 d8                	mov    %ebx,%eax
f0101c46:	e8 59 f0 ff ff       	call   f0100ca4 <page2kva>
f0101c4b:	83 c4 0c             	add    $0xc,%esp
f0101c4e:	68 00 10 00 00       	push   $0x1000
f0101c53:	6a 02                	push   $0x2
f0101c55:	50                   	push   %eax
f0101c56:	e8 57 3b 00 00       	call   f01057b2 <memset>
	page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f0101c5b:	6a 02                	push   $0x2
f0101c5d:	68 00 10 00 00       	push   $0x1000
f0101c62:	57                   	push   %edi
f0101c63:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101c69:	e8 06 ff ff ff       	call   f0101b74 <page_insert>
	assert(pp1->pp_ref == 1);
f0101c6e:	83 c4 20             	add    $0x20,%esp
f0101c71:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101c76:	0f 85 2a 01 00 00    	jne    f0101da6 <check_page_installed_pgdir+0x1cd>
	assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0101c7c:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0101c83:	01 01 01 
f0101c86:	0f 85 33 01 00 00    	jne    f0101dbf <check_page_installed_pgdir+0x1e6>
	page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0101c8c:	6a 02                	push   $0x2
f0101c8e:	68 00 10 00 00       	push   $0x1000
f0101c93:	53                   	push   %ebx
f0101c94:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101c9a:	e8 d5 fe ff ff       	call   f0101b74 <page_insert>
	assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0101c9f:	83 c4 10             	add    $0x10,%esp
f0101ca2:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0101ca9:	02 02 02 
f0101cac:	0f 85 26 01 00 00    	jne    f0101dd8 <check_page_installed_pgdir+0x1ff>
	assert(pp2->pp_ref == 1);
f0101cb2:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101cb7:	0f 85 34 01 00 00    	jne    f0101df1 <check_page_installed_pgdir+0x218>
	assert(pp1->pp_ref == 0);
f0101cbd:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101cc2:	0f 85 42 01 00 00    	jne    f0101e0a <check_page_installed_pgdir+0x231>
	*(uint32_t *) PGSIZE = 0x03030303U;
f0101cc8:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0101ccf:	03 03 03 
	assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0101cd2:	89 d8                	mov    %ebx,%eax
f0101cd4:	e8 cb ef ff ff       	call   f0100ca4 <page2kva>
f0101cd9:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0101cdf:	0f 85 3e 01 00 00    	jne    f0101e23 <check_page_installed_pgdir+0x24a>
	page_remove(kern_pgdir, (void *) PGSIZE);
f0101ce5:	83 ec 08             	sub    $0x8,%esp
f0101ce8:	68 00 10 00 00       	push   $0x1000
f0101ced:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101cf3:	e8 20 fe ff ff       	call   f0101b18 <page_remove>
	assert(pp2->pp_ref == 0);
f0101cf8:	83 c4 10             	add    $0x10,%esp
f0101cfb:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d00:	0f 85 36 01 00 00    	jne    f0101e3c <check_page_installed_pgdir+0x263>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d06:	8b 1d 8c 2e 22 f0    	mov    0xf0222e8c,%ebx
f0101d0c:	89 f0                	mov    %esi,%eax
f0101d0e:	e8 cb ee ff ff       	call   f0100bde <page2pa>
f0101d13:	89 c2                	mov    %eax,%edx
f0101d15:	8b 03                	mov    (%ebx),%eax
f0101d17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101d1c:	39 d0                	cmp    %edx,%eax
f0101d1e:	0f 85 31 01 00 00    	jne    f0101e55 <check_page_installed_pgdir+0x27c>
	kern_pgdir[0] = 0;
f0101d24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f0101d2a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101d2f:	0f 85 39 01 00 00    	jne    f0101e6e <check_page_installed_pgdir+0x295>
	pp0->pp_ref = 0;
f0101d35:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0101d3b:	83 ec 0c             	sub    $0xc,%esp
f0101d3e:	56                   	push   %esi
f0101d3f:	e8 69 f4 ff ff       	call   f01011ad <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0101d44:	c7 04 24 7c 6e 10 f0 	movl   $0xf0106e7c,(%esp)
f0101d4b:	e8 6c 1c 00 00       	call   f01039bc <cprintf>
}
f0101d50:	83 c4 10             	add    $0x10,%esp
f0101d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101d56:	5b                   	pop    %ebx
f0101d57:	5e                   	pop    %esi
f0101d58:	5f                   	pop    %edi
f0101d59:	5d                   	pop    %ebp
f0101d5a:	c3                   	ret    
	assert((pp0 = page_alloc(0)));
f0101d5b:	68 5f 75 10 f0       	push   $0xf010755f
f0101d60:	68 97 74 10 f0       	push   $0xf0107497
f0101d65:	68 ad 04 00 00       	push   $0x4ad
f0101d6a:	68 7f 74 10 f0       	push   $0xf010747f
f0101d6f:	e8 f6 e2 ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f0101d74:	68 75 75 10 f0       	push   $0xf0107575
f0101d79:	68 97 74 10 f0       	push   $0xf0107497
f0101d7e:	68 ae 04 00 00       	push   $0x4ae
f0101d83:	68 7f 74 10 f0       	push   $0xf010747f
f0101d88:	e8 dd e2 ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f0101d8d:	68 8b 75 10 f0       	push   $0xf010758b
f0101d92:	68 97 74 10 f0       	push   $0xf0107497
f0101d97:	68 af 04 00 00       	push   $0x4af
f0101d9c:	68 7f 74 10 f0       	push   $0xf010747f
f0101da1:	e8 c4 e2 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f0101da6:	68 35 76 10 f0       	push   $0xf0107635
f0101dab:	68 97 74 10 f0       	push   $0xf0107497
f0101db0:	68 b4 04 00 00       	push   $0x4b4
f0101db5:	68 7f 74 10 f0       	push   $0xf010747f
f0101dba:	e8 ab e2 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0101dbf:	68 e0 6d 10 f0       	push   $0xf0106de0
f0101dc4:	68 97 74 10 f0       	push   $0xf0107497
f0101dc9:	68 b5 04 00 00       	push   $0x4b5
f0101dce:	68 7f 74 10 f0       	push   $0xf010747f
f0101dd3:	e8 92 e2 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0101dd8:	68 04 6e 10 f0       	push   $0xf0106e04
f0101ddd:	68 97 74 10 f0       	push   $0xf0107497
f0101de2:	68 b7 04 00 00       	push   $0x4b7
f0101de7:	68 7f 74 10 f0       	push   $0xf010747f
f0101dec:	e8 79 e2 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f0101df1:	68 46 76 10 f0       	push   $0xf0107646
f0101df6:	68 97 74 10 f0       	push   $0xf0107497
f0101dfb:	68 b8 04 00 00       	push   $0x4b8
f0101e00:	68 7f 74 10 f0       	push   $0xf010747f
f0101e05:	e8 60 e2 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 0);
f0101e0a:	68 57 76 10 f0       	push   $0xf0107657
f0101e0f:	68 97 74 10 f0       	push   $0xf0107497
f0101e14:	68 b9 04 00 00       	push   $0x4b9
f0101e19:	68 7f 74 10 f0       	push   $0xf010747f
f0101e1e:	e8 47 e2 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0101e23:	68 28 6e 10 f0       	push   $0xf0106e28
f0101e28:	68 97 74 10 f0       	push   $0xf0107497
f0101e2d:	68 bb 04 00 00       	push   $0x4bb
f0101e32:	68 7f 74 10 f0       	push   $0xf010747f
f0101e37:	e8 2e e2 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0101e3c:	68 68 76 10 f0       	push   $0xf0107668
f0101e41:	68 97 74 10 f0       	push   $0xf0107497
f0101e46:	68 bd 04 00 00       	push   $0x4bd
f0101e4b:	68 7f 74 10 f0       	push   $0xf010747f
f0101e50:	e8 15 e2 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e55:	68 54 6e 10 f0       	push   $0xf0106e54
f0101e5a:	68 97 74 10 f0       	push   $0xf0107497
f0101e5f:	68 c0 04 00 00       	push   $0x4c0
f0101e64:	68 7f 74 10 f0       	push   $0xf010747f
f0101e69:	e8 fc e1 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f0101e6e:	68 79 76 10 f0       	push   $0xf0107679
f0101e73:	68 97 74 10 f0       	push   $0xf0107497
f0101e78:	68 c2 04 00 00       	push   $0x4c2
f0101e7d:	68 7f 74 10 f0       	push   $0xf010747f
f0101e82:	e8 e3 e1 ff ff       	call   f010006a <_panic>

f0101e87 <mmio_map_region>:
{
f0101e87:	f3 0f 1e fb          	endbr32 
f0101e8b:	55                   	push   %ebp
f0101e8c:	89 e5                	mov    %esp,%ebp
f0101e8e:	53                   	push   %ebx
f0101e8f:	83 ec 04             	sub    $0x4,%esp
	size_t rounded_size = ROUNDUP(size, PGSIZE);
f0101e92:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101e95:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0101e9b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (base + rounded_size >= MMIOLIM) {
f0101ea1:	8b 15 00 23 12 f0    	mov    0xf0122300,%edx
f0101ea7:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f0101eaa:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101eaf:	77 26                	ja     f0101ed7 <mmio_map_region+0x50>
	boot_map_region(
f0101eb1:	83 ec 08             	sub    $0x8,%esp
f0101eb4:	6a 1a                	push   $0x1a
f0101eb6:	ff 75 08             	pushl  0x8(%ebp)
f0101eb9:	89 d9                	mov    %ebx,%ecx
f0101ebb:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0101ec0:	e8 1a f8 ff ff       	call   f01016df <boot_map_region>
	uintptr_t base_i = base;
f0101ec5:	a1 00 23 12 f0       	mov    0xf0122300,%eax
	base += rounded_size;
f0101eca:	01 c3                	add    %eax,%ebx
f0101ecc:	89 1d 00 23 12 f0    	mov    %ebx,0xf0122300
}
f0101ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101ed5:	c9                   	leave  
f0101ed6:	c3                   	ret    
		panic("MMIOLIM overflow");
f0101ed7:	83 ec 04             	sub    $0x4,%esp
f0101eda:	68 8a 76 10 f0       	push   $0xf010768a
f0101edf:	68 a8 02 00 00       	push   $0x2a8
f0101ee4:	68 7f 74 10 f0       	push   $0xf010747f
f0101ee9:	e8 7c e1 ff ff       	call   f010006a <_panic>

f0101eee <check_page>:
{
f0101eee:	55                   	push   %ebp
f0101eef:	89 e5                	mov    %esp,%ebp
f0101ef1:	57                   	push   %edi
f0101ef2:	56                   	push   %esi
f0101ef3:	53                   	push   %ebx
f0101ef4:	83 ec 38             	sub    $0x38,%esp
	assert((pp0 = page_alloc(0)));
f0101ef7:	6a 00                	push   $0x0
f0101ef9:	e8 64 f2 ff ff       	call   f0101162 <page_alloc>
f0101efe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f01:	83 c4 10             	add    $0x10,%esp
f0101f04:	85 c0                	test   %eax,%eax
f0101f06:	0f 84 71 07 00 00    	je     f010267d <check_page+0x78f>
	assert((pp1 = page_alloc(0)));
f0101f0c:	83 ec 0c             	sub    $0xc,%esp
f0101f0f:	6a 00                	push   $0x0
f0101f11:	e8 4c f2 ff ff       	call   f0101162 <page_alloc>
f0101f16:	89 c6                	mov    %eax,%esi
f0101f18:	83 c4 10             	add    $0x10,%esp
f0101f1b:	85 c0                	test   %eax,%eax
f0101f1d:	0f 84 73 07 00 00    	je     f0102696 <check_page+0x7a8>
	assert((pp2 = page_alloc(0)));
f0101f23:	83 ec 0c             	sub    $0xc,%esp
f0101f26:	6a 00                	push   $0x0
f0101f28:	e8 35 f2 ff ff       	call   f0101162 <page_alloc>
f0101f2d:	89 c3                	mov    %eax,%ebx
f0101f2f:	83 c4 10             	add    $0x10,%esp
f0101f32:	85 c0                	test   %eax,%eax
f0101f34:	0f 84 75 07 00 00    	je     f01026af <check_page+0x7c1>
	assert(pp1 && pp1 != pp0);
f0101f3a:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0101f3d:	0f 84 85 07 00 00    	je     f01026c8 <check_page+0x7da>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101f43:	39 c6                	cmp    %eax,%esi
f0101f45:	0f 84 96 07 00 00    	je     f01026e1 <check_page+0x7f3>
f0101f4b:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101f4e:	0f 84 8d 07 00 00    	je     f01026e1 <check_page+0x7f3>
	fl = page_free_list;
f0101f54:	a1 40 12 22 f0       	mov    0xf0221240,%eax
f0101f59:	89 45 c8             	mov    %eax,-0x38(%ebp)
	page_free_list = 0;
f0101f5c:	c7 05 40 12 22 f0 00 	movl   $0x0,0xf0221240
f0101f63:	00 00 00 
	assert(!page_alloc(0));
f0101f66:	83 ec 0c             	sub    $0xc,%esp
f0101f69:	6a 00                	push   $0x0
f0101f6b:	e8 f2 f1 ff ff       	call   f0101162 <page_alloc>
f0101f70:	83 c4 10             	add    $0x10,%esp
f0101f73:	85 c0                	test   %eax,%eax
f0101f75:	0f 85 7f 07 00 00    	jne    f01026fa <check_page+0x80c>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101f7b:	83 ec 04             	sub    $0x4,%esp
f0101f7e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101f81:	50                   	push   %eax
f0101f82:	6a 00                	push   $0x0
f0101f84:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101f8a:	e8 15 fb ff ff       	call   f0101aa4 <page_lookup>
f0101f8f:	83 c4 10             	add    $0x10,%esp
f0101f92:	85 c0                	test   %eax,%eax
f0101f94:	0f 85 79 07 00 00    	jne    f0102713 <check_page+0x825>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101f9a:	6a 02                	push   $0x2
f0101f9c:	6a 00                	push   $0x0
f0101f9e:	56                   	push   %esi
f0101f9f:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101fa5:	e8 ca fb ff ff       	call   f0101b74 <page_insert>
f0101faa:	83 c4 10             	add    $0x10,%esp
f0101fad:	85 c0                	test   %eax,%eax
f0101faf:	0f 89 77 07 00 00    	jns    f010272c <check_page+0x83e>
	page_free(pp0);
f0101fb5:	83 ec 0c             	sub    $0xc,%esp
f0101fb8:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fbb:	e8 ed f1 ff ff       	call   f01011ad <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101fc0:	6a 02                	push   $0x2
f0101fc2:	6a 00                	push   $0x0
f0101fc4:	56                   	push   %esi
f0101fc5:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0101fcb:	e8 a4 fb ff ff       	call   f0101b74 <page_insert>
f0101fd0:	83 c4 20             	add    $0x20,%esp
f0101fd3:	85 c0                	test   %eax,%eax
f0101fd5:	0f 85 6a 07 00 00    	jne    f0102745 <check_page+0x857>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101fdb:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0101fe1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fe4:	e8 f5 eb ff ff       	call   f0100bde <page2pa>
f0101fe9:	89 c2                	mov    %eax,%edx
f0101feb:	8b 07                	mov    (%edi),%eax
f0101fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101ff2:	39 d0                	cmp    %edx,%eax
f0101ff4:	0f 85 64 07 00 00    	jne    f010275e <check_page+0x870>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101ffa:	ba 00 00 00 00       	mov    $0x0,%edx
f0101fff:	89 f8                	mov    %edi,%eax
f0102001:	e8 bc ec ff ff       	call   f0100cc2 <check_va2pa>
f0102006:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102009:	89 f0                	mov    %esi,%eax
f010200b:	e8 ce eb ff ff       	call   f0100bde <page2pa>
f0102010:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102013:	0f 85 5e 07 00 00    	jne    f0102777 <check_page+0x889>
	assert(pp1->pp_ref == 1);
f0102019:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010201e:	0f 85 6c 07 00 00    	jne    f0102790 <check_page+0x8a2>
	assert(pp0->pp_ref == 1);
f0102024:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102027:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010202c:	0f 85 77 07 00 00    	jne    f01027a9 <check_page+0x8bb>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102032:	6a 02                	push   $0x2
f0102034:	68 00 10 00 00       	push   $0x1000
f0102039:	53                   	push   %ebx
f010203a:	57                   	push   %edi
f010203b:	e8 34 fb ff ff       	call   f0101b74 <page_insert>
f0102040:	83 c4 10             	add    $0x10,%esp
f0102043:	85 c0                	test   %eax,%eax
f0102045:	0f 85 77 07 00 00    	jne    f01027c2 <check_page+0x8d4>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010204b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102050:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0102055:	e8 68 ec ff ff       	call   f0100cc2 <check_va2pa>
f010205a:	89 c7                	mov    %eax,%edi
f010205c:	89 d8                	mov    %ebx,%eax
f010205e:	e8 7b eb ff ff       	call   f0100bde <page2pa>
f0102063:	39 c7                	cmp    %eax,%edi
f0102065:	0f 85 70 07 00 00    	jne    f01027db <check_page+0x8ed>
	assert(pp2->pp_ref == 1);
f010206b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102070:	0f 85 7e 07 00 00    	jne    f01027f4 <check_page+0x906>
	assert(!page_alloc(0));
f0102076:	83 ec 0c             	sub    $0xc,%esp
f0102079:	6a 00                	push   $0x0
f010207b:	e8 e2 f0 ff ff       	call   f0101162 <page_alloc>
f0102080:	83 c4 10             	add    $0x10,%esp
f0102083:	85 c0                	test   %eax,%eax
f0102085:	0f 85 82 07 00 00    	jne    f010280d <check_page+0x91f>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f010208b:	6a 02                	push   $0x2
f010208d:	68 00 10 00 00       	push   $0x1000
f0102092:	53                   	push   %ebx
f0102093:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0102099:	e8 d6 fa ff ff       	call   f0101b74 <page_insert>
f010209e:	83 c4 10             	add    $0x10,%esp
f01020a1:	85 c0                	test   %eax,%eax
f01020a3:	0f 85 7d 07 00 00    	jne    f0102826 <check_page+0x938>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01020a9:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020ae:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f01020b3:	e8 0a ec ff ff       	call   f0100cc2 <check_va2pa>
f01020b8:	89 c7                	mov    %eax,%edi
f01020ba:	89 d8                	mov    %ebx,%eax
f01020bc:	e8 1d eb ff ff       	call   f0100bde <page2pa>
f01020c1:	39 c7                	cmp    %eax,%edi
f01020c3:	0f 85 76 07 00 00    	jne    f010283f <check_page+0x951>
	assert(pp2->pp_ref == 1);
f01020c9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01020ce:	0f 85 84 07 00 00    	jne    f0102858 <check_page+0x96a>
	assert(!page_alloc(0));
f01020d4:	83 ec 0c             	sub    $0xc,%esp
f01020d7:	6a 00                	push   $0x0
f01020d9:	e8 84 f0 ff ff       	call   f0101162 <page_alloc>
f01020de:	83 c4 10             	add    $0x10,%esp
f01020e1:	85 c0                	test   %eax,%eax
f01020e3:	0f 85 88 07 00 00    	jne    f0102871 <check_page+0x983>
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01020e9:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f01020ef:	8b 0f                	mov    (%edi),%ecx
f01020f1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01020f7:	ba 2b 04 00 00       	mov    $0x42b,%edx
f01020fc:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102101:	e8 72 eb ff ff       	call   f0100c78 <_kaddr>
f0102106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102109:	83 ec 04             	sub    $0x4,%esp
f010210c:	6a 00                	push   $0x0
f010210e:	68 00 10 00 00       	push   $0x1000
f0102113:	57                   	push   %edi
f0102114:	e8 36 f5 ff ff       	call   f010164f <pgdir_walk>
f0102119:	89 c2                	mov    %eax,%edx
f010211b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010211e:	83 c0 04             	add    $0x4,%eax
f0102121:	83 c4 10             	add    $0x10,%esp
f0102124:	39 d0                	cmp    %edx,%eax
f0102126:	0f 85 5e 07 00 00    	jne    f010288a <check_page+0x99c>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f010212c:	6a 06                	push   $0x6
f010212e:	68 00 10 00 00       	push   $0x1000
f0102133:	53                   	push   %ebx
f0102134:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010213a:	e8 35 fa ff ff       	call   f0101b74 <page_insert>
f010213f:	83 c4 10             	add    $0x10,%esp
f0102142:	85 c0                	test   %eax,%eax
f0102144:	0f 85 59 07 00 00    	jne    f01028a3 <check_page+0x9b5>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010214a:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0102150:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102155:	89 f8                	mov    %edi,%eax
f0102157:	e8 66 eb ff ff       	call   f0100cc2 <check_va2pa>
f010215c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010215f:	89 d8                	mov    %ebx,%eax
f0102161:	e8 78 ea ff ff       	call   f0100bde <page2pa>
f0102166:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102169:	0f 85 4d 07 00 00    	jne    f01028bc <check_page+0x9ce>
	assert(pp2->pp_ref == 1);
f010216f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102174:	0f 85 5b 07 00 00    	jne    f01028d5 <check_page+0x9e7>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f010217a:	83 ec 04             	sub    $0x4,%esp
f010217d:	6a 00                	push   $0x0
f010217f:	68 00 10 00 00       	push   $0x1000
f0102184:	57                   	push   %edi
f0102185:	e8 c5 f4 ff ff       	call   f010164f <pgdir_walk>
f010218a:	83 c4 10             	add    $0x10,%esp
f010218d:	f6 00 04             	testb  $0x4,(%eax)
f0102190:	0f 84 58 07 00 00    	je     f01028ee <check_page+0xa00>
	assert(kern_pgdir[0] & PTE_U);
f0102196:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f010219b:	f6 00 04             	testb  $0x4,(%eax)
f010219e:	0f 84 63 07 00 00    	je     f0102907 <check_page+0xa19>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01021a4:	6a 02                	push   $0x2
f01021a6:	68 00 10 00 00       	push   $0x1000
f01021ab:	53                   	push   %ebx
f01021ac:	50                   	push   %eax
f01021ad:	e8 c2 f9 ff ff       	call   f0101b74 <page_insert>
f01021b2:	83 c4 10             	add    $0x10,%esp
f01021b5:	85 c0                	test   %eax,%eax
f01021b7:	0f 85 63 07 00 00    	jne    f0102920 <check_page+0xa32>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f01021bd:	83 ec 04             	sub    $0x4,%esp
f01021c0:	6a 00                	push   $0x0
f01021c2:	68 00 10 00 00       	push   $0x1000
f01021c7:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f01021cd:	e8 7d f4 ff ff       	call   f010164f <pgdir_walk>
f01021d2:	83 c4 10             	add    $0x10,%esp
f01021d5:	f6 00 02             	testb  $0x2,(%eax)
f01021d8:	0f 84 5b 07 00 00    	je     f0102939 <check_page+0xa4b>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01021de:	83 ec 04             	sub    $0x4,%esp
f01021e1:	6a 00                	push   $0x0
f01021e3:	68 00 10 00 00       	push   $0x1000
f01021e8:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f01021ee:	e8 5c f4 ff ff       	call   f010164f <pgdir_walk>
f01021f3:	83 c4 10             	add    $0x10,%esp
f01021f6:	f6 00 04             	testb  $0x4,(%eax)
f01021f9:	0f 85 53 07 00 00    	jne    f0102952 <check_page+0xa64>
	assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f01021ff:	6a 02                	push   $0x2
f0102201:	68 00 00 40 00       	push   $0x400000
f0102206:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102209:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010220f:	e8 60 f9 ff ff       	call   f0101b74 <page_insert>
f0102214:	83 c4 10             	add    $0x10,%esp
f0102217:	85 c0                	test   %eax,%eax
f0102219:	0f 89 4c 07 00 00    	jns    f010296b <check_page+0xa7d>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f010221f:	6a 02                	push   $0x2
f0102221:	68 00 10 00 00       	push   $0x1000
f0102226:	56                   	push   %esi
f0102227:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010222d:	e8 42 f9 ff ff       	call   f0101b74 <page_insert>
f0102232:	83 c4 10             	add    $0x10,%esp
f0102235:	85 c0                	test   %eax,%eax
f0102237:	0f 85 47 07 00 00    	jne    f0102984 <check_page+0xa96>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f010223d:	83 ec 04             	sub    $0x4,%esp
f0102240:	6a 00                	push   $0x0
f0102242:	68 00 10 00 00       	push   $0x1000
f0102247:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010224d:	e8 fd f3 ff ff       	call   f010164f <pgdir_walk>
f0102252:	83 c4 10             	add    $0x10,%esp
f0102255:	f6 00 04             	testb  $0x4,(%eax)
f0102258:	0f 85 3f 07 00 00    	jne    f010299d <check_page+0xaaf>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010225e:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0102264:	ba 00 00 00 00       	mov    $0x0,%edx
f0102269:	89 f8                	mov    %edi,%eax
f010226b:	e8 52 ea ff ff       	call   f0100cc2 <check_va2pa>
f0102270:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102273:	89 f0                	mov    %esi,%eax
f0102275:	e8 64 e9 ff ff       	call   f0100bde <page2pa>
f010227a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010227d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102280:	0f 85 30 07 00 00    	jne    f01029b6 <check_page+0xac8>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102286:	ba 00 10 00 00       	mov    $0x1000,%edx
f010228b:	89 f8                	mov    %edi,%eax
f010228d:	e8 30 ea ff ff       	call   f0100cc2 <check_va2pa>
f0102292:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0102295:	0f 85 34 07 00 00    	jne    f01029cf <check_page+0xae1>
	assert(pp1->pp_ref == 2);
f010229b:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f01022a0:	0f 85 42 07 00 00    	jne    f01029e8 <check_page+0xafa>
	assert(pp2->pp_ref == 0);
f01022a6:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01022ab:	0f 85 50 07 00 00    	jne    f0102a01 <check_page+0xb13>
	assert((pp = page_alloc(0)) && pp == pp2);
f01022b1:	83 ec 0c             	sub    $0xc,%esp
f01022b4:	6a 00                	push   $0x0
f01022b6:	e8 a7 ee ff ff       	call   f0101162 <page_alloc>
f01022bb:	83 c4 10             	add    $0x10,%esp
f01022be:	39 c3                	cmp    %eax,%ebx
f01022c0:	0f 85 54 07 00 00    	jne    f0102a1a <check_page+0xb2c>
f01022c6:	85 c0                	test   %eax,%eax
f01022c8:	0f 84 4c 07 00 00    	je     f0102a1a <check_page+0xb2c>
	page_remove(kern_pgdir, 0x0);
f01022ce:	83 ec 08             	sub    $0x8,%esp
f01022d1:	6a 00                	push   $0x0
f01022d3:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f01022d9:	e8 3a f8 ff ff       	call   f0101b18 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01022de:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f01022e4:	ba 00 00 00 00       	mov    $0x0,%edx
f01022e9:	89 f8                	mov    %edi,%eax
f01022eb:	e8 d2 e9 ff ff       	call   f0100cc2 <check_va2pa>
f01022f0:	83 c4 10             	add    $0x10,%esp
f01022f3:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022f6:	0f 85 37 07 00 00    	jne    f0102a33 <check_page+0xb45>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01022fc:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102301:	89 f8                	mov    %edi,%eax
f0102303:	e8 ba e9 ff ff       	call   f0100cc2 <check_va2pa>
f0102308:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010230b:	89 f0                	mov    %esi,%eax
f010230d:	e8 cc e8 ff ff       	call   f0100bde <page2pa>
f0102312:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102315:	0f 85 31 07 00 00    	jne    f0102a4c <check_page+0xb5e>
	assert(pp1->pp_ref == 1);
f010231b:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102320:	0f 85 3f 07 00 00    	jne    f0102a65 <check_page+0xb77>
	assert(pp2->pp_ref == 0);
f0102326:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010232b:	0f 85 4d 07 00 00    	jne    f0102a7e <check_page+0xb90>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102331:	6a 00                	push   $0x0
f0102333:	68 00 10 00 00       	push   $0x1000
f0102338:	56                   	push   %esi
f0102339:	57                   	push   %edi
f010233a:	e8 35 f8 ff ff       	call   f0101b74 <page_insert>
f010233f:	83 c4 10             	add    $0x10,%esp
f0102342:	85 c0                	test   %eax,%eax
f0102344:	0f 85 4d 07 00 00    	jne    f0102a97 <check_page+0xba9>
	assert(pp1->pp_ref);
f010234a:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f010234f:	0f 84 5b 07 00 00    	je     f0102ab0 <check_page+0xbc2>
	assert(pp1->pp_link == NULL);
f0102355:	83 3e 00             	cmpl   $0x0,(%esi)
f0102358:	0f 85 6b 07 00 00    	jne    f0102ac9 <check_page+0xbdb>
	page_remove(kern_pgdir, (void *) PGSIZE);
f010235e:	83 ec 08             	sub    $0x8,%esp
f0102361:	68 00 10 00 00       	push   $0x1000
f0102366:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010236c:	e8 a7 f7 ff ff       	call   f0101b18 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102371:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0102377:	ba 00 00 00 00       	mov    $0x0,%edx
f010237c:	89 f8                	mov    %edi,%eax
f010237e:	e8 3f e9 ff ff       	call   f0100cc2 <check_va2pa>
f0102383:	83 c4 10             	add    $0x10,%esp
f0102386:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102389:	0f 85 53 07 00 00    	jne    f0102ae2 <check_page+0xbf4>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010238f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102394:	89 f8                	mov    %edi,%eax
f0102396:	e8 27 e9 ff ff       	call   f0100cc2 <check_va2pa>
f010239b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010239e:	0f 85 57 07 00 00    	jne    f0102afb <check_page+0xc0d>
	assert(pp1->pp_ref == 0);
f01023a4:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01023a9:	0f 85 65 07 00 00    	jne    f0102b14 <check_page+0xc26>
	assert(pp2->pp_ref == 0);
f01023af:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01023b4:	0f 85 73 07 00 00    	jne    f0102b2d <check_page+0xc3f>
	assert((pp = page_alloc(0)) && pp == pp1);
f01023ba:	83 ec 0c             	sub    $0xc,%esp
f01023bd:	6a 00                	push   $0x0
f01023bf:	e8 9e ed ff ff       	call   f0101162 <page_alloc>
f01023c4:	83 c4 10             	add    $0x10,%esp
f01023c7:	39 c6                	cmp    %eax,%esi
f01023c9:	0f 85 77 07 00 00    	jne    f0102b46 <check_page+0xc58>
f01023cf:	85 c0                	test   %eax,%eax
f01023d1:	0f 84 6f 07 00 00    	je     f0102b46 <check_page+0xc58>
	assert(!page_alloc(0));
f01023d7:	83 ec 0c             	sub    $0xc,%esp
f01023da:	6a 00                	push   $0x0
f01023dc:	e8 81 ed ff ff       	call   f0101162 <page_alloc>
f01023e1:	83 c4 10             	add    $0x10,%esp
f01023e4:	85 c0                	test   %eax,%eax
f01023e6:	0f 85 73 07 00 00    	jne    f0102b5f <check_page+0xc71>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01023ec:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f01023f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01023f5:	e8 e4 e7 ff ff       	call   f0100bde <page2pa>
f01023fa:	89 c2                	mov    %eax,%edx
f01023fc:	8b 07                	mov    (%edi),%eax
f01023fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102403:	39 d0                	cmp    %edx,%eax
f0102405:	0f 85 6d 07 00 00    	jne    f0102b78 <check_page+0xc8a>
	kern_pgdir[0] = 0;
f010240b:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	assert(pp0->pp_ref == 1);
f0102411:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102414:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102419:	0f 85 72 07 00 00    	jne    f0102b91 <check_page+0xca3>
	pp0->pp_ref = 0;
f010241f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102422:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	page_free(pp0);
f0102428:	83 ec 0c             	sub    $0xc,%esp
f010242b:	50                   	push   %eax
f010242c:	e8 7c ed ff ff       	call   f01011ad <page_free>
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102431:	83 c4 0c             	add    $0xc,%esp
f0102434:	6a 01                	push   $0x1
f0102436:	68 00 10 40 00       	push   $0x401000
f010243b:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0102441:	e8 09 f2 ff ff       	call   f010164f <pgdir_walk>
f0102446:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010244c:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0102452:	8b 4f 04             	mov    0x4(%edi),%ecx
f0102455:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010245b:	ba 6f 04 00 00       	mov    $0x46f,%edx
f0102460:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102465:	e8 0e e8 ff ff       	call   f0100c78 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f010246a:	83 c0 04             	add    $0x4,%eax
f010246d:	83 c4 10             	add    $0x10,%esp
f0102470:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102473:	0f 85 31 07 00 00    	jne    f0102baa <check_page+0xcbc>
	kern_pgdir[PDX(va)] = 0;
f0102479:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	pp0->pp_ref = 0;
f0102480:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102483:	89 f8                	mov    %edi,%eax
f0102485:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
	memset(page2kva(pp0), 0xFF, PGSIZE);
f010248b:	e8 14 e8 ff ff       	call   f0100ca4 <page2kva>
f0102490:	83 ec 04             	sub    $0x4,%esp
f0102493:	68 00 10 00 00       	push   $0x1000
f0102498:	68 ff 00 00 00       	push   $0xff
f010249d:	50                   	push   %eax
f010249e:	e8 0f 33 00 00       	call   f01057b2 <memset>
	page_free(pp0);
f01024a3:	89 3c 24             	mov    %edi,(%esp)
f01024a6:	e8 02 ed ff ff       	call   f01011ad <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01024ab:	83 c4 0c             	add    $0xc,%esp
f01024ae:	6a 01                	push   $0x1
f01024b0:	6a 00                	push   $0x0
f01024b2:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f01024b8:	e8 92 f1 ff ff       	call   f010164f <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f01024bd:	89 f8                	mov    %edi,%eax
f01024bf:	e8 e0 e7 ff ff       	call   f0100ca4 <page2kva>
f01024c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01024c7:	89 c2                	mov    %eax,%edx
f01024c9:	05 00 10 00 00       	add    $0x1000,%eax
f01024ce:	83 c4 10             	add    $0x10,%esp
		assert((ptep[i] & PTE_P) == 0);
f01024d1:	f6 02 01             	testb  $0x1,(%edx)
f01024d4:	0f 85 e9 06 00 00    	jne    f0102bc3 <check_page+0xcd5>
f01024da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; i < NPTENTRIES; i++)
f01024dd:	39 c2                	cmp    %eax,%edx
f01024df:	75 f0                	jne    f01024d1 <check_page+0x5e3>
	kern_pgdir[0] = 0;
f01024e1:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f01024e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01024ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01024ef:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	page_free_list = fl;
f01024f5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01024f8:	89 0d 40 12 22 f0    	mov    %ecx,0xf0221240
	page_free(pp0);
f01024fe:	83 ec 0c             	sub    $0xc,%esp
f0102501:	50                   	push   %eax
f0102502:	e8 a6 ec ff ff       	call   f01011ad <page_free>
	page_free(pp1);
f0102507:	89 34 24             	mov    %esi,(%esp)
f010250a:	e8 9e ec ff ff       	call   f01011ad <page_free>
	page_free(pp2);
f010250f:	89 1c 24             	mov    %ebx,(%esp)
f0102512:	e8 96 ec ff ff       	call   f01011ad <page_free>
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102517:	83 c4 08             	add    $0x8,%esp
f010251a:	68 01 10 00 00       	push   $0x1001
f010251f:	6a 00                	push   $0x0
f0102521:	e8 61 f9 ff ff       	call   f0101e87 <mmio_map_region>
f0102526:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102528:	83 c4 08             	add    $0x8,%esp
f010252b:	68 00 10 00 00       	push   $0x1000
f0102530:	6a 00                	push   $0x0
f0102532:	e8 50 f9 ff ff       	call   f0101e87 <mmio_map_region>
f0102537:	89 c6                	mov    %eax,%esi
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102539:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f010253f:	83 c4 10             	add    $0x10,%esp
f0102542:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102548:	0f 86 8e 06 00 00    	jbe    f0102bdc <check_page+0xcee>
f010254e:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102553:	0f 87 83 06 00 00    	ja     f0102bdc <check_page+0xcee>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102559:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f010255f:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102565:	0f 87 8a 06 00 00    	ja     f0102bf5 <check_page+0xd07>
f010256b:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102571:	0f 86 7e 06 00 00    	jbe    f0102bf5 <check_page+0xd07>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102577:	89 da                	mov    %ebx,%edx
f0102579:	09 f2                	or     %esi,%edx
f010257b:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102581:	0f 85 87 06 00 00    	jne    f0102c0e <check_page+0xd20>
	assert(mm1 + 8096 <= mm2);
f0102587:	39 f0                	cmp    %esi,%eax
f0102589:	0f 87 98 06 00 00    	ja     f0102c27 <check_page+0xd39>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010258f:	8b 3d 8c 2e 22 f0    	mov    0xf0222e8c,%edi
f0102595:	89 da                	mov    %ebx,%edx
f0102597:	89 f8                	mov    %edi,%eax
f0102599:	e8 24 e7 ff ff       	call   f0100cc2 <check_va2pa>
f010259e:	85 c0                	test   %eax,%eax
f01025a0:	0f 85 9a 06 00 00    	jne    f0102c40 <check_page+0xd52>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f01025a6:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01025ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01025af:	89 c2                	mov    %eax,%edx
f01025b1:	89 f8                	mov    %edi,%eax
f01025b3:	e8 0a e7 ff ff       	call   f0100cc2 <check_va2pa>
f01025b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01025bd:	0f 85 96 06 00 00    	jne    f0102c59 <check_page+0xd6b>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01025c3:	89 f2                	mov    %esi,%edx
f01025c5:	89 f8                	mov    %edi,%eax
f01025c7:	e8 f6 e6 ff ff       	call   f0100cc2 <check_va2pa>
f01025cc:	85 c0                	test   %eax,%eax
f01025ce:	0f 85 9e 06 00 00    	jne    f0102c72 <check_page+0xd84>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f01025d4:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01025da:	89 f8                	mov    %edi,%eax
f01025dc:	e8 e1 e6 ff ff       	call   f0100cc2 <check_va2pa>
f01025e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01025e4:	0f 85 a1 06 00 00    	jne    f0102c8b <check_page+0xd9d>
	assert(*pgdir_walk(kern_pgdir, (void *) mm1, 0) &
f01025ea:	83 ec 04             	sub    $0x4,%esp
f01025ed:	6a 00                	push   $0x0
f01025ef:	53                   	push   %ebx
f01025f0:	57                   	push   %edi
f01025f1:	e8 59 f0 ff ff       	call   f010164f <pgdir_walk>
f01025f6:	83 c4 10             	add    $0x10,%esp
f01025f9:	f6 00 1a             	testb  $0x1a,(%eax)
f01025fc:	0f 84 a2 06 00 00    	je     f0102ca4 <check_page+0xdb6>
	assert(!(*pgdir_walk(kern_pgdir, (void *) mm1, 0) & PTE_U));
f0102602:	83 ec 04             	sub    $0x4,%esp
f0102605:	6a 00                	push   $0x0
f0102607:	53                   	push   %ebx
f0102608:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010260e:	e8 3c f0 ff ff       	call   f010164f <pgdir_walk>
f0102613:	83 c4 10             	add    $0x10,%esp
f0102616:	f6 00 04             	testb  $0x4,(%eax)
f0102619:	0f 85 9e 06 00 00    	jne    f0102cbd <check_page+0xdcf>
	*pgdir_walk(kern_pgdir, (void *) mm1, 0) = 0;
f010261f:	83 ec 04             	sub    $0x4,%esp
f0102622:	6a 00                	push   $0x0
f0102624:	53                   	push   %ebx
f0102625:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010262b:	e8 1f f0 ff ff       	call   f010164f <pgdir_walk>
f0102630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm1 + PGSIZE, 0) = 0;
f0102636:	83 c4 0c             	add    $0xc,%esp
f0102639:	6a 00                	push   $0x0
f010263b:	ff 75 d4             	pushl  -0x2c(%ebp)
f010263e:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f0102644:	e8 06 f0 ff ff       	call   f010164f <pgdir_walk>
f0102649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm2, 0) = 0;
f010264f:	83 c4 0c             	add    $0xc,%esp
f0102652:	6a 00                	push   $0x0
f0102654:	56                   	push   %esi
f0102655:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010265b:	e8 ef ef ff ff       	call   f010164f <pgdir_walk>
f0102660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	cprintf("check_page() succeeded!\n");
f0102666:	c7 04 24 24 77 10 f0 	movl   $0xf0107724,(%esp)
f010266d:	e8 4a 13 00 00       	call   f01039bc <cprintf>
}
f0102672:	83 c4 10             	add    $0x10,%esp
f0102675:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102678:	5b                   	pop    %ebx
f0102679:	5e                   	pop    %esi
f010267a:	5f                   	pop    %edi
f010267b:	5d                   	pop    %ebp
f010267c:	c3                   	ret    
	assert((pp0 = page_alloc(0)));
f010267d:	68 5f 75 10 f0       	push   $0xf010755f
f0102682:	68 97 74 10 f0       	push   $0xf0107497
f0102687:	68 fb 03 00 00       	push   $0x3fb
f010268c:	68 7f 74 10 f0       	push   $0xf010747f
f0102691:	e8 d4 d9 ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f0102696:	68 75 75 10 f0       	push   $0xf0107575
f010269b:	68 97 74 10 f0       	push   $0xf0107497
f01026a0:	68 fc 03 00 00       	push   $0x3fc
f01026a5:	68 7f 74 10 f0       	push   $0xf010747f
f01026aa:	e8 bb d9 ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f01026af:	68 8b 75 10 f0       	push   $0xf010758b
f01026b4:	68 97 74 10 f0       	push   $0xf0107497
f01026b9:	68 fd 03 00 00       	push   $0x3fd
f01026be:	68 7f 74 10 f0       	push   $0xf010747f
f01026c3:	e8 a2 d9 ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f01026c8:	68 a1 75 10 f0       	push   $0xf01075a1
f01026cd:	68 97 74 10 f0       	push   $0xf0107497
f01026d2:	68 00 04 00 00       	push   $0x400
f01026d7:	68 7f 74 10 f0       	push   $0xf010747f
f01026dc:	e8 89 d9 ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01026e1:	68 d8 6b 10 f0       	push   $0xf0106bd8
f01026e6:	68 97 74 10 f0       	push   $0xf0107497
f01026eb:	68 01 04 00 00       	push   $0x401
f01026f0:	68 7f 74 10 f0       	push   $0xf010747f
f01026f5:	e8 70 d9 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f01026fa:	68 b3 75 10 f0       	push   $0xf01075b3
f01026ff:	68 97 74 10 f0       	push   $0xf0107497
f0102704:	68 08 04 00 00       	push   $0x408
f0102709:	68 7f 74 10 f0       	push   $0xf010747f
f010270e:	e8 57 d9 ff ff       	call   f010006a <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102713:	68 a8 6e 10 f0       	push   $0xf0106ea8
f0102718:	68 97 74 10 f0       	push   $0xf0107497
f010271d:	68 0b 04 00 00       	push   $0x40b
f0102722:	68 7f 74 10 f0       	push   $0xf010747f
f0102727:	e8 3e d9 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010272c:	68 e0 6e 10 f0       	push   $0xf0106ee0
f0102731:	68 97 74 10 f0       	push   $0xf0107497
f0102736:	68 0e 04 00 00       	push   $0x40e
f010273b:	68 7f 74 10 f0       	push   $0xf010747f
f0102740:	e8 25 d9 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102745:	68 10 6f 10 f0       	push   $0xf0106f10
f010274a:	68 97 74 10 f0       	push   $0xf0107497
f010274f:	68 12 04 00 00       	push   $0x412
f0102754:	68 7f 74 10 f0       	push   $0xf010747f
f0102759:	e8 0c d9 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010275e:	68 54 6e 10 f0       	push   $0xf0106e54
f0102763:	68 97 74 10 f0       	push   $0xf0107497
f0102768:	68 13 04 00 00       	push   $0x413
f010276d:	68 7f 74 10 f0       	push   $0xf010747f
f0102772:	e8 f3 d8 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102777:	68 40 6f 10 f0       	push   $0xf0106f40
f010277c:	68 97 74 10 f0       	push   $0xf0107497
f0102781:	68 14 04 00 00       	push   $0x414
f0102786:	68 7f 74 10 f0       	push   $0xf010747f
f010278b:	e8 da d8 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f0102790:	68 35 76 10 f0       	push   $0xf0107635
f0102795:	68 97 74 10 f0       	push   $0xf0107497
f010279a:	68 15 04 00 00       	push   $0x415
f010279f:	68 7f 74 10 f0       	push   $0xf010747f
f01027a4:	e8 c1 d8 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f01027a9:	68 79 76 10 f0       	push   $0xf0107679
f01027ae:	68 97 74 10 f0       	push   $0xf0107497
f01027b3:	68 16 04 00 00       	push   $0x416
f01027b8:	68 7f 74 10 f0       	push   $0xf010747f
f01027bd:	e8 a8 d8 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01027c2:	68 70 6f 10 f0       	push   $0xf0106f70
f01027c7:	68 97 74 10 f0       	push   $0xf0107497
f01027cc:	68 1a 04 00 00       	push   $0x41a
f01027d1:	68 7f 74 10 f0       	push   $0xf010747f
f01027d6:	e8 8f d8 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027db:	68 ac 6f 10 f0       	push   $0xf0106fac
f01027e0:	68 97 74 10 f0       	push   $0xf0107497
f01027e5:	68 1b 04 00 00       	push   $0x41b
f01027ea:	68 7f 74 10 f0       	push   $0xf010747f
f01027ef:	e8 76 d8 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f01027f4:	68 46 76 10 f0       	push   $0xf0107646
f01027f9:	68 97 74 10 f0       	push   $0xf0107497
f01027fe:	68 1c 04 00 00       	push   $0x41c
f0102803:	68 7f 74 10 f0       	push   $0xf010747f
f0102808:	e8 5d d8 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f010280d:	68 b3 75 10 f0       	push   $0xf01075b3
f0102812:	68 97 74 10 f0       	push   $0xf0107497
f0102817:	68 1f 04 00 00       	push   $0x41f
f010281c:	68 7f 74 10 f0       	push   $0xf010747f
f0102821:	e8 44 d8 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102826:	68 70 6f 10 f0       	push   $0xf0106f70
f010282b:	68 97 74 10 f0       	push   $0xf0107497
f0102830:	68 22 04 00 00       	push   $0x422
f0102835:	68 7f 74 10 f0       	push   $0xf010747f
f010283a:	e8 2b d8 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010283f:	68 ac 6f 10 f0       	push   $0xf0106fac
f0102844:	68 97 74 10 f0       	push   $0xf0107497
f0102849:	68 23 04 00 00       	push   $0x423
f010284e:	68 7f 74 10 f0       	push   $0xf010747f
f0102853:	e8 12 d8 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f0102858:	68 46 76 10 f0       	push   $0xf0107646
f010285d:	68 97 74 10 f0       	push   $0xf0107497
f0102862:	68 24 04 00 00       	push   $0x424
f0102867:	68 7f 74 10 f0       	push   $0xf010747f
f010286c:	e8 f9 d7 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0102871:	68 b3 75 10 f0       	push   $0xf01075b3
f0102876:	68 97 74 10 f0       	push   $0xf0107497
f010287b:	68 28 04 00 00       	push   $0x428
f0102880:	68 7f 74 10 f0       	push   $0xf010747f
f0102885:	e8 e0 d7 ff ff       	call   f010006a <_panic>
	assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f010288a:	68 dc 6f 10 f0       	push   $0xf0106fdc
f010288f:	68 97 74 10 f0       	push   $0xf0107497
f0102894:	68 2c 04 00 00       	push   $0x42c
f0102899:	68 7f 74 10 f0       	push   $0xf010747f
f010289e:	e8 c7 d7 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f01028a3:	68 20 70 10 f0       	push   $0xf0107020
f01028a8:	68 97 74 10 f0       	push   $0xf0107497
f01028ad:	68 2f 04 00 00       	push   $0x42f
f01028b2:	68 7f 74 10 f0       	push   $0xf010747f
f01028b7:	e8 ae d7 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01028bc:	68 ac 6f 10 f0       	push   $0xf0106fac
f01028c1:	68 97 74 10 f0       	push   $0xf0107497
f01028c6:	68 30 04 00 00       	push   $0x430
f01028cb:	68 7f 74 10 f0       	push   $0xf010747f
f01028d0:	e8 95 d7 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f01028d5:	68 46 76 10 f0       	push   $0xf0107646
f01028da:	68 97 74 10 f0       	push   $0xf0107497
f01028df:	68 31 04 00 00       	push   $0x431
f01028e4:	68 7f 74 10 f0       	push   $0xf010747f
f01028e9:	e8 7c d7 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01028ee:	68 64 70 10 f0       	push   $0xf0107064
f01028f3:	68 97 74 10 f0       	push   $0xf0107497
f01028f8:	68 32 04 00 00       	push   $0x432
f01028fd:	68 7f 74 10 f0       	push   $0xf010747f
f0102902:	e8 63 d7 ff ff       	call   f010006a <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102907:	68 9b 76 10 f0       	push   $0xf010769b
f010290c:	68 97 74 10 f0       	push   $0xf0107497
f0102911:	68 33 04 00 00       	push   $0x433
f0102916:	68 7f 74 10 f0       	push   $0xf010747f
f010291b:	e8 4a d7 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102920:	68 70 6f 10 f0       	push   $0xf0106f70
f0102925:	68 97 74 10 f0       	push   $0xf0107497
f010292a:	68 36 04 00 00       	push   $0x436
f010292f:	68 7f 74 10 f0       	push   $0xf010747f
f0102934:	e8 31 d7 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102939:	68 98 70 10 f0       	push   $0xf0107098
f010293e:	68 97 74 10 f0       	push   $0xf0107497
f0102943:	68 37 04 00 00       	push   $0x437
f0102948:	68 7f 74 10 f0       	push   $0xf010747f
f010294d:	e8 18 d7 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102952:	68 cc 70 10 f0       	push   $0xf01070cc
f0102957:	68 97 74 10 f0       	push   $0xf0107497
f010295c:	68 38 04 00 00       	push   $0x438
f0102961:	68 7f 74 10 f0       	push   $0xf010747f
f0102966:	e8 ff d6 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f010296b:	68 04 71 10 f0       	push   $0xf0107104
f0102970:	68 97 74 10 f0       	push   $0xf0107497
f0102975:	68 3c 04 00 00       	push   $0x43c
f010297a:	68 7f 74 10 f0       	push   $0xf010747f
f010297f:	e8 e6 d6 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102984:	68 40 71 10 f0       	push   $0xf0107140
f0102989:	68 97 74 10 f0       	push   $0xf0107497
f010298e:	68 3f 04 00 00       	push   $0x43f
f0102993:	68 7f 74 10 f0       	push   $0xf010747f
f0102998:	e8 cd d6 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f010299d:	68 cc 70 10 f0       	push   $0xf01070cc
f01029a2:	68 97 74 10 f0       	push   $0xf0107497
f01029a7:	68 40 04 00 00       	push   $0x440
f01029ac:	68 7f 74 10 f0       	push   $0xf010747f
f01029b1:	e8 b4 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01029b6:	68 7c 71 10 f0       	push   $0xf010717c
f01029bb:	68 97 74 10 f0       	push   $0xf0107497
f01029c0:	68 43 04 00 00       	push   $0x443
f01029c5:	68 7f 74 10 f0       	push   $0xf010747f
f01029ca:	e8 9b d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01029cf:	68 a8 71 10 f0       	push   $0xf01071a8
f01029d4:	68 97 74 10 f0       	push   $0xf0107497
f01029d9:	68 44 04 00 00       	push   $0x444
f01029de:	68 7f 74 10 f0       	push   $0xf010747f
f01029e3:	e8 82 d6 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 2);
f01029e8:	68 b1 76 10 f0       	push   $0xf01076b1
f01029ed:	68 97 74 10 f0       	push   $0xf0107497
f01029f2:	68 46 04 00 00       	push   $0x446
f01029f7:	68 7f 74 10 f0       	push   $0xf010747f
f01029fc:	e8 69 d6 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0102a01:	68 68 76 10 f0       	push   $0xf0107668
f0102a06:	68 97 74 10 f0       	push   $0xf0107497
f0102a0b:	68 47 04 00 00       	push   $0x447
f0102a10:	68 7f 74 10 f0       	push   $0xf010747f
f0102a15:	e8 50 d6 ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102a1a:	68 d8 71 10 f0       	push   $0xf01071d8
f0102a1f:	68 97 74 10 f0       	push   $0xf0107497
f0102a24:	68 4a 04 00 00       	push   $0x44a
f0102a29:	68 7f 74 10 f0       	push   $0xf010747f
f0102a2e:	e8 37 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a33:	68 fc 71 10 f0       	push   $0xf01071fc
f0102a38:	68 97 74 10 f0       	push   $0xf0107497
f0102a3d:	68 4e 04 00 00       	push   $0x44e
f0102a42:	68 7f 74 10 f0       	push   $0xf010747f
f0102a47:	e8 1e d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a4c:	68 a8 71 10 f0       	push   $0xf01071a8
f0102a51:	68 97 74 10 f0       	push   $0xf0107497
f0102a56:	68 4f 04 00 00       	push   $0x44f
f0102a5b:	68 7f 74 10 f0       	push   $0xf010747f
f0102a60:	e8 05 d6 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f0102a65:	68 35 76 10 f0       	push   $0xf0107635
f0102a6a:	68 97 74 10 f0       	push   $0xf0107497
f0102a6f:	68 50 04 00 00       	push   $0x450
f0102a74:	68 7f 74 10 f0       	push   $0xf010747f
f0102a79:	e8 ec d5 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0102a7e:	68 68 76 10 f0       	push   $0xf0107668
f0102a83:	68 97 74 10 f0       	push   $0xf0107497
f0102a88:	68 51 04 00 00       	push   $0x451
f0102a8d:	68 7f 74 10 f0       	push   $0xf010747f
f0102a92:	e8 d3 d5 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102a97:	68 20 72 10 f0       	push   $0xf0107220
f0102a9c:	68 97 74 10 f0       	push   $0xf0107497
f0102aa1:	68 54 04 00 00       	push   $0x454
f0102aa6:	68 7f 74 10 f0       	push   $0xf010747f
f0102aab:	e8 ba d5 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref);
f0102ab0:	68 c2 76 10 f0       	push   $0xf01076c2
f0102ab5:	68 97 74 10 f0       	push   $0xf0107497
f0102aba:	68 55 04 00 00       	push   $0x455
f0102abf:	68 7f 74 10 f0       	push   $0xf010747f
f0102ac4:	e8 a1 d5 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_link == NULL);
f0102ac9:	68 ce 76 10 f0       	push   $0xf01076ce
f0102ace:	68 97 74 10 f0       	push   $0xf0107497
f0102ad3:	68 56 04 00 00       	push   $0x456
f0102ad8:	68 7f 74 10 f0       	push   $0xf010747f
f0102add:	e8 88 d5 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102ae2:	68 fc 71 10 f0       	push   $0xf01071fc
f0102ae7:	68 97 74 10 f0       	push   $0xf0107497
f0102aec:	68 5a 04 00 00       	push   $0x45a
f0102af1:	68 7f 74 10 f0       	push   $0xf010747f
f0102af6:	e8 6f d5 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102afb:	68 58 72 10 f0       	push   $0xf0107258
f0102b00:	68 97 74 10 f0       	push   $0xf0107497
f0102b05:	68 5b 04 00 00       	push   $0x45b
f0102b0a:	68 7f 74 10 f0       	push   $0xf010747f
f0102b0f:	e8 56 d5 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 0);
f0102b14:	68 57 76 10 f0       	push   $0xf0107657
f0102b19:	68 97 74 10 f0       	push   $0xf0107497
f0102b1e:	68 5c 04 00 00       	push   $0x45c
f0102b23:	68 7f 74 10 f0       	push   $0xf010747f
f0102b28:	e8 3d d5 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0102b2d:	68 68 76 10 f0       	push   $0xf0107668
f0102b32:	68 97 74 10 f0       	push   $0xf0107497
f0102b37:	68 5d 04 00 00       	push   $0x45d
f0102b3c:	68 7f 74 10 f0       	push   $0xf010747f
f0102b41:	e8 24 d5 ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b46:	68 80 72 10 f0       	push   $0xf0107280
f0102b4b:	68 97 74 10 f0       	push   $0xf0107497
f0102b50:	68 60 04 00 00       	push   $0x460
f0102b55:	68 7f 74 10 f0       	push   $0xf010747f
f0102b5a:	e8 0b d5 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0102b5f:	68 b3 75 10 f0       	push   $0xf01075b3
f0102b64:	68 97 74 10 f0       	push   $0xf0107497
f0102b69:	68 63 04 00 00       	push   $0x463
f0102b6e:	68 7f 74 10 f0       	push   $0xf010747f
f0102b73:	e8 f2 d4 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b78:	68 54 6e 10 f0       	push   $0xf0106e54
f0102b7d:	68 97 74 10 f0       	push   $0xf0107497
f0102b82:	68 66 04 00 00       	push   $0x466
f0102b87:	68 7f 74 10 f0       	push   $0xf010747f
f0102b8c:	e8 d9 d4 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f0102b91:	68 79 76 10 f0       	push   $0xf0107679
f0102b96:	68 97 74 10 f0       	push   $0xf0107497
f0102b9b:	68 68 04 00 00       	push   $0x468
f0102ba0:	68 7f 74 10 f0       	push   $0xf010747f
f0102ba5:	e8 c0 d4 ff ff       	call   f010006a <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102baa:	68 e3 76 10 f0       	push   $0xf01076e3
f0102baf:	68 97 74 10 f0       	push   $0xf0107497
f0102bb4:	68 70 04 00 00       	push   $0x470
f0102bb9:	68 7f 74 10 f0       	push   $0xf010747f
f0102bbe:	e8 a7 d4 ff ff       	call   f010006a <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bc3:	68 fb 76 10 f0       	push   $0xf01076fb
f0102bc8:	68 97 74 10 f0       	push   $0xf0107497
f0102bcd:	68 7a 04 00 00       	push   $0x47a
f0102bd2:	68 7f 74 10 f0       	push   $0xf010747f
f0102bd7:	e8 8e d4 ff ff       	call   f010006a <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102bdc:	68 a4 72 10 f0       	push   $0xf01072a4
f0102be1:	68 97 74 10 f0       	push   $0xf0107497
f0102be6:	68 8a 04 00 00       	push   $0x48a
f0102beb:	68 7f 74 10 f0       	push   $0xf010747f
f0102bf0:	e8 75 d4 ff ff       	call   f010006a <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102bf5:	68 cc 72 10 f0       	push   $0xf01072cc
f0102bfa:	68 97 74 10 f0       	push   $0xf0107497
f0102bff:	68 8b 04 00 00       	push   $0x48b
f0102c04:	68 7f 74 10 f0       	push   $0xf010747f
f0102c09:	e8 5c d4 ff ff       	call   f010006a <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c0e:	68 f4 72 10 f0       	push   $0xf01072f4
f0102c13:	68 97 74 10 f0       	push   $0xf0107497
f0102c18:	68 8d 04 00 00       	push   $0x48d
f0102c1d:	68 7f 74 10 f0       	push   $0xf010747f
f0102c22:	e8 43 d4 ff ff       	call   f010006a <_panic>
	assert(mm1 + 8096 <= mm2);
f0102c27:	68 12 77 10 f0       	push   $0xf0107712
f0102c2c:	68 97 74 10 f0       	push   $0xf0107497
f0102c31:	68 8f 04 00 00       	push   $0x48f
f0102c36:	68 7f 74 10 f0       	push   $0xf010747f
f0102c3b:	e8 2a d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c40:	68 1c 73 10 f0       	push   $0xf010731c
f0102c45:	68 97 74 10 f0       	push   $0xf0107497
f0102c4a:	68 91 04 00 00       	push   $0x491
f0102c4f:	68 7f 74 10 f0       	push   $0xf010747f
f0102c54:	e8 11 d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f0102c59:	68 40 73 10 f0       	push   $0xf0107340
f0102c5e:	68 97 74 10 f0       	push   $0xf0107497
f0102c63:	68 92 04 00 00       	push   $0x492
f0102c68:	68 7f 74 10 f0       	push   $0xf010747f
f0102c6d:	e8 f8 d3 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c72:	68 70 73 10 f0       	push   $0xf0107370
f0102c77:	68 97 74 10 f0       	push   $0xf0107497
f0102c7c:	68 93 04 00 00       	push   $0x493
f0102c81:	68 7f 74 10 f0       	push   $0xf010747f
f0102c86:	e8 df d3 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f0102c8b:	68 94 73 10 f0       	push   $0xf0107394
f0102c90:	68 97 74 10 f0       	push   $0xf0107497
f0102c95:	68 94 04 00 00       	push   $0x494
f0102c9a:	68 7f 74 10 f0       	push   $0xf010747f
f0102c9f:	e8 c6 d3 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) mm1, 0) &
f0102ca4:	68 c0 73 10 f0       	push   $0xf01073c0
f0102ca9:	68 97 74 10 f0       	push   $0xf0107497
f0102cae:	68 96 04 00 00       	push   $0x496
f0102cb3:	68 7f 74 10 f0       	push   $0xf010747f
f0102cb8:	e8 ad d3 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) mm1, 0) & PTE_U));
f0102cbd:	68 08 74 10 f0       	push   $0xf0107408
f0102cc2:	68 97 74 10 f0       	push   $0xf0107497
f0102cc7:	68 98 04 00 00       	push   $0x498
f0102ccc:	68 7f 74 10 f0       	push   $0xf010747f
f0102cd1:	e8 94 d3 ff ff       	call   f010006a <_panic>

f0102cd6 <mem_init>:
{
f0102cd6:	f3 0f 1e fb          	endbr32 
f0102cda:	55                   	push   %ebp
f0102cdb:	89 e5                	mov    %esp,%ebp
f0102cdd:	53                   	push   %ebx
f0102cde:	83 ec 04             	sub    $0x4,%esp
	i386_detect_memory();
f0102ce1:	e8 2e df ff ff       	call   f0100c14 <i386_detect_memory>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0102ce6:	b8 00 10 00 00       	mov    $0x1000,%eax
f0102ceb:	e8 5c e0 ff ff       	call   f0100d4c <boot_alloc>
f0102cf0:	a3 8c 2e 22 f0       	mov    %eax,0xf0222e8c
	memset(kern_pgdir, 0, PGSIZE);
f0102cf5:	83 ec 04             	sub    $0x4,%esp
f0102cf8:	68 00 10 00 00       	push   $0x1000
f0102cfd:	6a 00                	push   $0x0
f0102cff:	50                   	push   %eax
f0102d00:	e8 ad 2a 00 00       	call   f01057b2 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0102d05:	8b 1d 8c 2e 22 f0    	mov    0xf0222e8c,%ebx
f0102d0b:	89 d9                	mov    %ebx,%ecx
f0102d0d:	ba 9f 00 00 00       	mov    $0x9f,%edx
f0102d12:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102d17:	e8 0e e0 ff ff       	call   f0100d2a <_paddr>
f0102d1c:	83 c8 05             	or     $0x5,%eax
f0102d1f:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	int size_pages = sizeof(struct PageInfo) * npages;
f0102d25:	a1 88 2e 22 f0       	mov    0xf0222e88,%eax
f0102d2a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
	pages = boot_alloc(size_pages);
f0102d31:	89 d8                	mov    %ebx,%eax
f0102d33:	e8 14 e0 ff ff       	call   f0100d4c <boot_alloc>
f0102d38:	a3 90 2e 22 f0       	mov    %eax,0xf0222e90
	memset(pages, 0, size_pages);
f0102d3d:	83 c4 0c             	add    $0xc,%esp
f0102d40:	53                   	push   %ebx
f0102d41:	6a 00                	push   $0x0
f0102d43:	50                   	push   %eax
f0102d44:	e8 69 2a 00 00       	call   f01057b2 <memset>
	envs = (struct Env *) boot_alloc(size_envs);
f0102d49:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0102d4e:	e8 f9 df ff ff       	call   f0100d4c <boot_alloc>
f0102d53:	a3 44 12 22 f0       	mov    %eax,0xf0221244
	memset(envs, 0, size_envs);
f0102d58:	83 c4 0c             	add    $0xc,%esp
f0102d5b:	68 00 f0 01 00       	push   $0x1f000
f0102d60:	6a 00                	push   $0x0
f0102d62:	50                   	push   %eax
f0102d63:	e8 4a 2a 00 00       	call   f01057b2 <memset>
	page_init();
f0102d68:	e8 36 e3 ff ff       	call   f01010a3 <page_init>
	check_page_free_list(1);
f0102d6d:	b8 01 00 00 00       	mov    $0x1,%eax
f0102d72:	e8 4d e0 ff ff       	call   f0100dc4 <check_page_free_list>
	check_page_alloc();
f0102d77:	e8 87 e4 ff ff       	call   f0101203 <check_page_alloc>
	check_page();
f0102d7c:	e8 6d f1 ff ff       	call   f0101eee <check_page>
	boot_map_region(kern_pgdir,
f0102d81:	8b 0d 90 2e 22 f0    	mov    0xf0222e90,%ecx
f0102d87:	ba d0 00 00 00       	mov    $0xd0,%edx
f0102d8c:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102d91:	e8 94 df ff ff       	call   f0100d2a <_paddr>
	                ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE),
f0102d96:	8b 15 88 2e 22 f0    	mov    0xf0222e88,%edx
f0102d9c:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
	boot_map_region(kern_pgdir,
f0102da3:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102da9:	83 c4 08             	add    $0x8,%esp
f0102dac:	6a 05                	push   $0x5
f0102dae:	50                   	push   %eax
f0102daf:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102db4:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0102db9:	e8 21 e9 ff ff       	call   f01016df <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U | PTE_P);
f0102dbe:	8b 0d 44 12 22 f0    	mov    0xf0221244,%ecx
f0102dc4:	ba da 00 00 00       	mov    $0xda,%edx
f0102dc9:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102dce:	e8 57 df ff ff       	call   f0100d2a <_paddr>
f0102dd3:	83 c4 08             	add    $0x8,%esp
f0102dd6:	6a 05                	push   $0x5
f0102dd8:	50                   	push   %eax
f0102dd9:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102dde:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102de3:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0102de8:	e8 f2 e8 ff ff       	call   f01016df <boot_map_region>
	boot_map_region(kern_pgdir,
f0102ded:	b9 00 90 11 f0       	mov    $0xf0119000,%ecx
f0102df2:	ba eb 00 00 00       	mov    $0xeb,%edx
f0102df7:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102dfc:	e8 29 df ff ff       	call   f0100d2a <_paddr>
f0102e01:	83 c4 08             	add    $0x8,%esp
f0102e04:	6a 02                	push   $0x2
f0102e06:	50                   	push   %eax
f0102e07:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102e0c:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102e11:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0102e16:	e8 c4 e8 ff ff       	call   f01016df <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, -KERNBASE, 0, PTE_W);
f0102e1b:	83 c4 08             	add    $0x8,%esp
f0102e1e:	6a 02                	push   $0x2
f0102e20:	6a 00                	push   $0x0
f0102e22:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102e27:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102e2c:	a1 8c 2e 22 f0       	mov    0xf0222e8c,%eax
f0102e31:	e8 a9 e8 ff ff       	call   f01016df <boot_map_region>
	mem_init_mp();
f0102e36:	e8 0f e9 ff ff       	call   f010174a <mem_init_mp>
	check_kern_pgdir();
f0102e3b:	e8 65 e9 ff ff       	call   f01017a5 <check_kern_pgdir>
	lcr3(PADDR(kern_pgdir));
f0102e40:	8b 0d 8c 2e 22 f0    	mov    0xf0222e8c,%ecx
f0102e46:	ba 05 01 00 00       	mov    $0x105,%edx
f0102e4b:	b8 7f 74 10 f0       	mov    $0xf010747f,%eax
f0102e50:	e8 d5 de ff ff       	call   f0100d2a <_paddr>
f0102e55:	e8 80 dd ff ff       	call   f0100bda <lcr3>
	check_page_free_list(0);
f0102e5a:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e5f:	e8 60 df ff ff       	call   f0100dc4 <check_page_free_list>
	cr0 = rcr0();
f0102e64:	e8 6d dd ff ff       	call   f0100bd6 <rcr0>
f0102e69:	83 e0 f3             	and    $0xfffffff3,%eax
	cr0 &= ~(CR0_TS | CR0_EM);
f0102e6c:	0d 23 00 05 80       	or     $0x80050023,%eax
	lcr0(cr0);
f0102e71:	e8 5c dd ff ff       	call   f0100bd2 <lcr0>
	check_page_installed_pgdir();
f0102e76:	e8 5e ed ff ff       	call   f0101bd9 <check_page_installed_pgdir>
}
f0102e7b:	83 c4 10             	add    $0x10,%esp
f0102e7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102e81:	c9                   	leave  
f0102e82:	c3                   	ret    

f0102e83 <user_mem_check>:
{
f0102e83:	f3 0f 1e fb          	endbr32 
f0102e87:	55                   	push   %ebp
f0102e88:	89 e5                	mov    %esp,%ebp
f0102e8a:	57                   	push   %edi
f0102e8b:	56                   	push   %esi
f0102e8c:	53                   	push   %ebx
f0102e8d:	83 ec 0c             	sub    $0xc,%esp
f0102e90:	8b 75 14             	mov    0x14(%ebp),%esi
	uint32_t inicio = ROUNDDOWN(virtual_address, PGSIZE);
f0102e93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102e96:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t fin = ROUNDUP(virtual_address + len, PGSIZE);
f0102e9c:	8b 45 10             	mov    0x10(%ebp),%eax
f0102e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0102ea2:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f0102ea9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	while (inicio < fin) {
f0102eaf:	eb 13                	jmp    f0102ec4 <user_mem_check+0x41>
				user_mem_check_addr = inicio;
f0102eb1:	89 1d 3c 12 22 f0    	mov    %ebx,0xf022123c
			return -E_FAULT;
f0102eb7:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102ebc:	eb 4a                	jmp    f0102f08 <user_mem_check+0x85>
		inicio += PGSIZE;
f0102ebe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	while (inicio < fin) {
f0102ec4:	39 fb                	cmp    %edi,%ebx
f0102ec6:	73 48                	jae    f0102f10 <user_mem_check+0x8d>
		pte_t *pte = pgdir_walk(env->env_pgdir, (void *) inicio, 0);
f0102ec8:	83 ec 04             	sub    $0x4,%esp
f0102ecb:	6a 00                	push   $0x0
f0102ecd:	53                   	push   %ebx
f0102ece:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ed1:	ff 70 60             	pushl  0x60(%eax)
f0102ed4:	e8 76 e7 ff ff       	call   f010164f <pgdir_walk>
		if (!pte || inicio >= ULIM || (*pte & perm) != perm ||
f0102ed9:	83 c4 10             	add    $0x10,%esp
f0102edc:	85 c0                	test   %eax,%eax
f0102ede:	74 16                	je     f0102ef6 <user_mem_check+0x73>
f0102ee0:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102ee6:	77 0e                	ja     f0102ef6 <user_mem_check+0x73>
f0102ee8:	8b 00                	mov    (%eax),%eax
f0102eea:	89 c2                	mov    %eax,%edx
f0102eec:	21 f2                	and    %esi,%edx
f0102eee:	39 d6                	cmp    %edx,%esi
f0102ef0:	75 04                	jne    f0102ef6 <user_mem_check+0x73>
f0102ef2:	a8 01                	test   $0x1,%al
f0102ef4:	75 c8                	jne    f0102ebe <user_mem_check+0x3b>
			if (inicio < virtual_address) {
f0102ef6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102ef9:	73 b6                	jae    f0102eb1 <user_mem_check+0x2e>
				user_mem_check_addr = virtual_address;
f0102efb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102efe:	a3 3c 12 22 f0       	mov    %eax,0xf022123c
			return -E_FAULT;
f0102f03:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f0b:	5b                   	pop    %ebx
f0102f0c:	5e                   	pop    %esi
f0102f0d:	5f                   	pop    %edi
f0102f0e:	5d                   	pop    %ebp
f0102f0f:	c3                   	ret    
	return 0;
f0102f10:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f15:	eb f1                	jmp    f0102f08 <user_mem_check+0x85>

f0102f17 <user_mem_assert>:
{
f0102f17:	f3 0f 1e fb          	endbr32 
f0102f1b:	55                   	push   %ebp
f0102f1c:	89 e5                	mov    %esp,%ebp
f0102f1e:	53                   	push   %ebx
f0102f1f:	83 ec 04             	sub    $0x4,%esp
f0102f22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102f25:	8b 45 14             	mov    0x14(%ebp),%eax
f0102f28:	83 c8 04             	or     $0x4,%eax
f0102f2b:	50                   	push   %eax
f0102f2c:	ff 75 10             	pushl  0x10(%ebp)
f0102f2f:	ff 75 0c             	pushl  0xc(%ebp)
f0102f32:	53                   	push   %ebx
f0102f33:	e8 4b ff ff ff       	call   f0102e83 <user_mem_check>
f0102f38:	83 c4 10             	add    $0x10,%esp
f0102f3b:	85 c0                	test   %eax,%eax
f0102f3d:	78 05                	js     f0102f44 <user_mem_assert+0x2d>
}
f0102f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102f42:	c9                   	leave  
f0102f43:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102f44:	83 ec 04             	sub    $0x4,%esp
f0102f47:	ff 35 3c 12 22 f0    	pushl  0xf022123c
f0102f4d:	ff 73 48             	pushl  0x48(%ebx)
f0102f50:	68 3c 74 10 f0       	push   $0xf010743c
f0102f55:	e8 62 0a 00 00       	call   f01039bc <cprintf>
		env_destroy(env);  // may not return
f0102f5a:	89 1c 24             	mov    %ebx,(%esp)
f0102f5d:	e8 b4 06 00 00       	call   f0103616 <env_destroy>
f0102f62:	83 c4 10             	add    $0x10,%esp
}
f0102f65:	eb d8                	jmp    f0102f3f <user_mem_assert+0x28>

f0102f67 <lgdt>:
	asm volatile("lgdt (%0)" : : "r" (p));
f0102f67:	0f 01 10             	lgdtl  (%eax)
}
f0102f6a:	c3                   	ret    

f0102f6b <lldt>:
	asm volatile("lldt %0" : : "r" (sel));
f0102f6b:	0f 00 d0             	lldt   %ax
}
f0102f6e:	c3                   	ret    

f0102f6f <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102f6f:	0f 22 d8             	mov    %eax,%cr3
}
f0102f72:	c3                   	ret    

f0102f73 <page2pa>:
	return (pp - pages) << PGSHIFT;
f0102f73:	2b 05 90 2e 22 f0    	sub    0xf0222e90,%eax
f0102f79:	c1 f8 03             	sar    $0x3,%eax
f0102f7c:	c1 e0 0c             	shl    $0xc,%eax
}
f0102f7f:	c3                   	ret    

f0102f80 <_kaddr>:
{
f0102f80:	55                   	push   %ebp
f0102f81:	89 e5                	mov    %esp,%ebp
f0102f83:	53                   	push   %ebx
f0102f84:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0102f87:	89 cb                	mov    %ecx,%ebx
f0102f89:	c1 eb 0c             	shr    $0xc,%ebx
f0102f8c:	3b 1d 88 2e 22 f0    	cmp    0xf0222e88,%ebx
f0102f92:	73 0b                	jae    f0102f9f <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0102f94:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102f9d:	c9                   	leave  
f0102f9e:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f9f:	51                   	push   %ecx
f0102fa0:	68 2c 65 10 f0       	push   $0xf010652c
f0102fa5:	52                   	push   %edx
f0102fa6:	50                   	push   %eax
f0102fa7:	e8 be d0 ff ff       	call   f010006a <_panic>

f0102fac <page2kva>:
{
f0102fac:	55                   	push   %ebp
f0102fad:	89 e5                	mov    %esp,%ebp
f0102faf:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0102fb2:	e8 bc ff ff ff       	call   f0102f73 <page2pa>
f0102fb7:	89 c1                	mov    %eax,%ecx
f0102fb9:	ba 58 00 00 00       	mov    $0x58,%edx
f0102fbe:	b8 71 74 10 f0       	mov    $0xf0107471,%eax
f0102fc3:	e8 b8 ff ff ff       	call   f0102f80 <_kaddr>
}
f0102fc8:	c9                   	leave  
f0102fc9:	c3                   	ret    

f0102fca <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f0102fca:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0102fd0:	76 07                	jbe    f0102fd9 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0102fd2:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0102fd8:	c3                   	ret    
{
f0102fd9:	55                   	push   %ebp
f0102fda:	89 e5                	mov    %esp,%ebp
f0102fdc:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102fdf:	51                   	push   %ecx
f0102fe0:	68 50 65 10 f0       	push   $0xf0106550
f0102fe5:	52                   	push   %edx
f0102fe6:	50                   	push   %eax
f0102fe7:	e8 7e d0 ff ff       	call   f010006a <_panic>

f0102fec <env_setup_vm>:
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f0102fec:	55                   	push   %ebp
f0102fed:	89 e5                	mov    %esp,%ebp
f0102fef:	53                   	push   %ebx
f0102ff0:	83 ec 10             	sub    $0x10,%esp
f0102ff3:	89 c3                	mov    %eax,%ebx
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0102ff5:	6a 01                	push   $0x1
f0102ff7:	e8 66 e1 ff ff       	call   f0101162 <page_alloc>
f0102ffc:	83 c4 10             	add    $0x10,%esp
f0102fff:	85 c0                	test   %eax,%eax
f0103001:	74 4b                	je     f010304e <env_setup_vm+0x62>
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	p->pp_ref++;
f0103003:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	e->env_pgdir = (pde_t *) page2kva(p);
f0103008:	e8 9f ff ff ff       	call   f0102fac <page2kva>
f010300d:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103010:	83 ec 04             	sub    $0x4,%esp
f0103013:	68 00 10 00 00       	push   $0x1000
f0103018:	ff 35 8c 2e 22 f0    	pushl  0xf0222e8c
f010301e:	50                   	push   %eax
f010301f:	e8 42 28 00 00       	call   f0105866 <memcpy>


	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103024:	8b 5b 60             	mov    0x60(%ebx),%ebx
f0103027:	89 d9                	mov    %ebx,%ecx
f0103029:	ba c6 00 00 00       	mov    $0xc6,%edx
f010302e:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f0103033:	e8 92 ff ff ff       	call   f0102fca <_paddr>
f0103038:	83 c8 05             	or     $0x5,%eax
f010303b:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)

	return 0;
f0103041:	83 c4 10             	add    $0x10,%esp
f0103044:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103049:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010304c:	c9                   	leave  
f010304d:	c3                   	ret    
		return -E_NO_MEM;
f010304e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103053:	eb f4                	jmp    f0103049 <env_setup_vm+0x5d>

f0103055 <pa2page>:
	if (PGNUM(pa) >= npages)
f0103055:	c1 e8 0c             	shr    $0xc,%eax
f0103058:	3b 05 88 2e 22 f0    	cmp    0xf0222e88,%eax
f010305e:	73 0a                	jae    f010306a <pa2page+0x15>
	return &pages[PGNUM(pa)];
f0103060:	8b 15 90 2e 22 f0    	mov    0xf0222e90,%edx
f0103066:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0103069:	c3                   	ret    
{
f010306a:	55                   	push   %ebp
f010306b:	89 e5                	mov    %esp,%ebp
f010306d:	83 ec 0c             	sub    $0xc,%esp
		panic("pa2page called with invalid pa");
f0103070:	68 68 6b 10 f0       	push   $0xf0106b68
f0103075:	6a 51                	push   $0x51
f0103077:	68 71 74 10 f0       	push   $0xf0107471
f010307c:	e8 e9 cf ff ff       	call   f010006a <_panic>

f0103081 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103081:	55                   	push   %ebp
f0103082:	89 e5                	mov    %esp,%ebp
f0103084:	57                   	push   %edi
f0103085:	56                   	push   %esi
f0103086:	53                   	push   %ebx
f0103087:	83 ec 0c             	sub    $0xc,%esp
f010308a:	89 c6                	mov    %eax,%esi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)

	void *inicio = ROUNDDOWN(va, PGSIZE);
f010308c:	89 d3                	mov    %edx,%ebx
f010308e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void *fin = ROUNDUP(va + len, PGSIZE);
f0103094:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f010309b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01030a0:	89 c7                	mov    %eax,%edi
	if ((uint32_t) fin > UTOP) {
f01030a2:	3d 00 00 c0 ee       	cmp    $0xeec00000,%eax
f01030a7:	77 30                	ja     f01030d9 <region_alloc+0x58>
		panic("[Error] Se sobrepasa el limite UTOP");
	}

	while (inicio < fin) {
f01030a9:	39 fb                	cmp    %edi,%ebx
f01030ab:	73 71                	jae    f010311e <region_alloc+0x9d>
		struct PageInfo *pg = page_alloc(0);
f01030ad:	83 ec 0c             	sub    $0xc,%esp
f01030b0:	6a 00                	push   $0x0
f01030b2:	e8 ab e0 ff ff       	call   f0101162 <page_alloc>
		if (!pg) {
f01030b7:	83 c4 10             	add    $0x10,%esp
f01030ba:	85 c0                	test   %eax,%eax
f01030bc:	74 32                	je     f01030f0 <region_alloc+0x6f>
			panic("[Error]: No hay memoria disponible");
		}
		int page_flag =
		        page_insert(e->env_pgdir, pg, inicio, PTE_W | PTE_U);
f01030be:	6a 06                	push   $0x6
f01030c0:	53                   	push   %ebx
f01030c1:	50                   	push   %eax
f01030c2:	ff 76 60             	pushl  0x60(%esi)
f01030c5:	e8 aa ea ff ff       	call   f0101b74 <page_insert>
		if (page_flag != 0) {
f01030ca:	83 c4 10             	add    $0x10,%esp
f01030cd:	85 c0                	test   %eax,%eax
f01030cf:	75 36                	jne    f0103107 <region_alloc+0x86>
			panic("[Error]: Fallo al intentar insertar la pagina");
		}
		inicio += PGSIZE;
f01030d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01030d7:	eb d0                	jmp    f01030a9 <region_alloc+0x28>
		panic("[Error] Se sobrepasa el limite UTOP");
f01030d9:	83 ec 04             	sub    $0x4,%esp
f01030dc:	68 40 77 10 f0       	push   $0xf0107740
f01030e1:	68 29 01 00 00       	push   $0x129
f01030e6:	68 37 78 10 f0       	push   $0xf0107837
f01030eb:	e8 7a cf ff ff       	call   f010006a <_panic>
			panic("[Error]: No hay memoria disponible");
f01030f0:	83 ec 04             	sub    $0x4,%esp
f01030f3:	68 64 77 10 f0       	push   $0xf0107764
f01030f8:	68 2f 01 00 00       	push   $0x12f
f01030fd:	68 37 78 10 f0       	push   $0xf0107837
f0103102:	e8 63 cf ff ff       	call   f010006a <_panic>
			panic("[Error]: Fallo al intentar insertar la pagina");
f0103107:	83 ec 04             	sub    $0x4,%esp
f010310a:	68 88 77 10 f0       	push   $0xf0107788
f010310f:	68 34 01 00 00       	push   $0x134
f0103114:	68 37 78 10 f0       	push   $0xf0107837
f0103119:	e8 4c cf ff ff       	call   f010006a <_panic>
	}
}
f010311e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103121:	5b                   	pop    %ebx
f0103122:	5e                   	pop    %esi
f0103123:	5f                   	pop    %edi
f0103124:	5d                   	pop    %ebp
f0103125:	c3                   	ret    

f0103126 <load_icode>:
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary)
{
f0103126:	55                   	push   %ebp
f0103127:	89 e5                	mov    %esp,%ebp
f0103129:	57                   	push   %edi
f010312a:	56                   	push   %esi
f010312b:	53                   	push   %ebx
f010312c:	83 ec 1c             	sub    $0x1c,%esp
f010312f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	//  What?  (See env_run() and env_pop_tf() below.)

	// LAB 3: Your code here.
	struct Elf *elf = (struct Elf *) binary;

	if (elf->e_magic != ELF_MAGIC)
f0103132:	81 3a 7f 45 4c 46    	cmpl   $0x464c457f,(%edx)
f0103138:	75 2c                	jne    f0103166 <load_icode+0x40>
f010313a:	89 d7                	mov    %edx,%edi
		panic("[Error] Binario no está en formato ELF.");

	struct Proghdr *ph = (struct Proghdr *) (binary + elf->e_phoff);
f010313c:	89 d3                	mov    %edx,%ebx
f010313e:	03 5a 1c             	add    0x1c(%edx),%ebx
	struct Proghdr *eph = ph + elf->e_phnum;
f0103141:	0f b7 72 2c          	movzwl 0x2c(%edx),%esi
f0103145:	c1 e6 05             	shl    $0x5,%esi
f0103148:	01 de                	add    %ebx,%esi

	lcr3(PADDR(e->env_pgdir));
f010314a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010314d:	8b 48 60             	mov    0x60(%eax),%ecx
f0103150:	ba 78 01 00 00       	mov    $0x178,%edx
f0103155:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f010315a:	e8 6b fe ff ff       	call   f0102fca <_paddr>
f010315f:	e8 0b fe ff ff       	call   f0102f6f <lcr3>

	for (; ph < eph; ph++) {
f0103164:	eb 31                	jmp    f0103197 <load_icode+0x71>
		panic("[Error] Binario no está en formato ELF.");
f0103166:	83 ec 04             	sub    $0x4,%esp
f0103169:	68 b8 77 10 f0       	push   $0xf01077b8
f010316e:	68 73 01 00 00       	push   $0x173
f0103173:	68 37 78 10 f0       	push   $0xf0107837
f0103178:	e8 ed ce ff ff       	call   f010006a <_panic>
		if (ph->p_type == ELF_PROG_LOAD) {
			if (ph->p_filesz > ph->p_memsz)
				panic("[Error]: El tamanio del archivo debe "
f010317d:	83 ec 04             	sub    $0x4,%esp
f0103180:	68 e4 77 10 f0       	push   $0xf01077e4
f0103185:	68 7d 01 00 00       	push   $0x17d
f010318a:	68 37 78 10 f0       	push   $0xf0107837
f010318f:	e8 d6 ce ff ff       	call   f010006a <_panic>
	for (; ph < eph; ph++) {
f0103194:	83 c3 20             	add    $0x20,%ebx
f0103197:	39 f3                	cmp    %esi,%ebx
f0103199:	73 48                	jae    f01031e3 <load_icode+0xbd>
		if (ph->p_type == ELF_PROG_LOAD) {
f010319b:	83 3b 01             	cmpl   $0x1,(%ebx)
f010319e:	75 f4                	jne    f0103194 <load_icode+0x6e>
			if (ph->p_filesz > ph->p_memsz)
f01031a0:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01031a3:	39 4b 10             	cmp    %ecx,0x10(%ebx)
f01031a6:	77 d5                	ja     f010317d <load_icode+0x57>
				      "ser menor.");

			region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f01031a8:	8b 53 08             	mov    0x8(%ebx),%edx
f01031ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01031ae:	e8 ce fe ff ff       	call   f0103081 <region_alloc>
			memcpy((void *) ph->p_va,
f01031b3:	83 ec 04             	sub    $0x4,%esp
f01031b6:	ff 73 10             	pushl  0x10(%ebx)
f01031b9:	89 f8                	mov    %edi,%eax
f01031bb:	03 43 04             	add    0x4(%ebx),%eax
f01031be:	50                   	push   %eax
f01031bf:	ff 73 08             	pushl  0x8(%ebx)
f01031c2:	e8 9f 26 00 00       	call   f0105866 <memcpy>
			       (void *) binary + ph->p_offset,
			       ph->p_filesz);
			memset((void *) (ph->p_va + ph->p_filesz),
			       0,
			       ph->p_memsz - ph->p_filesz);
f01031c7:	8b 43 10             	mov    0x10(%ebx),%eax
			memset((void *) (ph->p_va + ph->p_filesz),
f01031ca:	83 c4 0c             	add    $0xc,%esp
f01031cd:	8b 53 14             	mov    0x14(%ebx),%edx
f01031d0:	29 c2                	sub    %eax,%edx
f01031d2:	52                   	push   %edx
f01031d3:	6a 00                	push   $0x0
f01031d5:	03 43 08             	add    0x8(%ebx),%eax
f01031d8:	50                   	push   %eax
f01031d9:	e8 d4 25 00 00       	call   f01057b2 <memset>
f01031de:	83 c4 10             	add    $0x10,%esp
f01031e1:	eb b1                	jmp    f0103194 <load_icode+0x6e>
		}
	}

	lcr3(PADDR(kern_pgdir));
f01031e3:	8b 0d 8c 2e 22 f0    	mov    0xf0222e8c,%ecx
f01031e9:	ba 8a 01 00 00       	mov    $0x18a,%edx
f01031ee:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f01031f3:	e8 d2 fd ff ff       	call   f0102fca <_paddr>
f01031f8:	e8 72 fd ff ff       	call   f0102f6f <lcr3>
	e->env_tf.tf_eip = elf->e_entry;
f01031fd:	8b 47 18             	mov    0x18(%edi),%eax
f0103200:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103203:	89 47 30             	mov    %eax,0x30(%edi)

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
	region_alloc(e, (void *) (USTACKTOP - PGSIZE), PGSIZE);
f0103206:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010320b:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103210:	89 f8                	mov    %edi,%eax
f0103212:	e8 6a fe ff ff       	call   f0103081 <region_alloc>
}
f0103217:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010321a:	5b                   	pop    %ebx
f010321b:	5e                   	pop    %esi
f010321c:	5f                   	pop    %edi
f010321d:	5d                   	pop    %ebp
f010321e:	c3                   	ret    

f010321f <unlock_kernel>:

static inline void
unlock_kernel(void)
{
f010321f:	55                   	push   %ebp
f0103220:	89 e5                	mov    %esp,%ebp
f0103222:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f0103225:	68 c0 23 12 f0       	push   $0xf01223c0
f010322a:	e8 7c 2f 00 00       	call   f01061ab <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f010322f:	f3 90                	pause  
}
f0103231:	83 c4 10             	add    $0x10,%esp
f0103234:	c9                   	leave  
f0103235:	c3                   	ret    

f0103236 <envid2env>:
{
f0103236:	f3 0f 1e fb          	endbr32 
f010323a:	55                   	push   %ebp
f010323b:	89 e5                	mov    %esp,%ebp
f010323d:	56                   	push   %esi
f010323e:	53                   	push   %ebx
f010323f:	8b 75 08             	mov    0x8(%ebp),%esi
f0103242:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103245:	85 f6                	test   %esi,%esi
f0103247:	74 2e                	je     f0103277 <envid2env+0x41>
	e = &envs[ENVX(envid)];
f0103249:	89 f3                	mov    %esi,%ebx
f010324b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103251:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103254:	03 1d 44 12 22 f0    	add    0xf0221244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010325a:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010325e:	74 2e                	je     f010328e <envid2env+0x58>
f0103260:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103263:	75 29                	jne    f010328e <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103265:	84 c0                	test   %al,%al
f0103267:	75 35                	jne    f010329e <envid2env+0x68>
	*env_store = e;
f0103269:	8b 45 0c             	mov    0xc(%ebp),%eax
f010326c:	89 18                	mov    %ebx,(%eax)
	return 0;
f010326e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103273:	5b                   	pop    %ebx
f0103274:	5e                   	pop    %esi
f0103275:	5d                   	pop    %ebp
f0103276:	c3                   	ret    
		*env_store = curenv;
f0103277:	e8 c4 2b 00 00       	call   f0105e40 <cpunum>
f010327c:	6b c0 74             	imul   $0x74,%eax,%eax
f010327f:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0103285:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103288:	89 02                	mov    %eax,(%edx)
		return 0;
f010328a:	89 f0                	mov    %esi,%eax
f010328c:	eb e5                	jmp    f0103273 <envid2env+0x3d>
		*env_store = 0;
f010328e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103291:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103297:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010329c:	eb d5                	jmp    f0103273 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010329e:	e8 9d 2b 00 00       	call   f0105e40 <cpunum>
f01032a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01032a6:	39 98 28 30 22 f0    	cmp    %ebx,-0xfddcfd8(%eax)
f01032ac:	74 bb                	je     f0103269 <envid2env+0x33>
f01032ae:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01032b1:	e8 8a 2b 00 00       	call   f0105e40 <cpunum>
f01032b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01032b9:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01032bf:	3b 70 48             	cmp    0x48(%eax),%esi
f01032c2:	74 a5                	je     f0103269 <envid2env+0x33>
		*env_store = 0;
f01032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01032cd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01032d2:	eb 9f                	jmp    f0103273 <envid2env+0x3d>

f01032d4 <env_init_percpu>:
{
f01032d4:	f3 0f 1e fb          	endbr32 
f01032d8:	55                   	push   %ebp
f01032d9:	89 e5                	mov    %esp,%ebp
f01032db:	83 ec 08             	sub    $0x8,%esp
	lgdt(&gdt_pd);
f01032de:	b8 20 23 12 f0       	mov    $0xf0122320,%eax
f01032e3:	e8 7f fc ff ff       	call   f0102f67 <lgdt>
	asm volatile("movw %%ax,%%gs" : : "a"(GD_UD | 3));
f01032e8:	b8 23 00 00 00       	mov    $0x23,%eax
f01032ed:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a"(GD_UD | 3));
f01032ef:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a"(GD_KD));
f01032f1:	b8 10 00 00 00       	mov    $0x10,%eax
f01032f6:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a"(GD_KD));
f01032f8:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a"(GD_KD));
f01032fa:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i"(GD_KT));
f01032fc:	ea 03 33 10 f0 08 00 	ljmp   $0x8,$0xf0103303
	lldt(0);
f0103303:	b8 00 00 00 00       	mov    $0x0,%eax
f0103308:	e8 5e fc ff ff       	call   f0102f6b <lldt>
}
f010330d:	c9                   	leave  
f010330e:	c3                   	ret    

f010330f <env_init>:
{
f010330f:	f3 0f 1e fb          	endbr32 
f0103313:	55                   	push   %ebp
f0103314:	89 e5                	mov    %esp,%ebp
f0103316:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f0103319:	8b 15 44 12 22 f0    	mov    0xf0221244,%edx
f010331f:	8d 42 7c             	lea    0x7c(%edx),%eax
f0103322:	81 c2 00 f0 01 00    	add    $0x1f000,%edx
f0103328:	c7 40 cc 00 00 00 00 	movl   $0x0,-0x34(%eax)
		envs[i].env_status = ENV_FREE;
f010332f:	c7 40 d8 00 00 00 00 	movl   $0x0,-0x28(%eax)
		envs[i].env_link = &envs[i + 1];
f0103336:	89 40 c8             	mov    %eax,-0x38(%eax)
f0103339:	83 c0 7c             	add    $0x7c,%eax
	for (size_t i = 0; i < NENV - 1; i++) {
f010333c:	39 d0                	cmp    %edx,%eax
f010333e:	75 e8                	jne    f0103328 <env_init+0x19>
	envs[NENV - 1].env_link = NULL;
f0103340:	a1 44 12 22 f0       	mov    0xf0221244,%eax
f0103345:	c7 80 c8 ef 01 00 00 	movl   $0x0,0x1efc8(%eax)
f010334c:	00 00 00 
	env_free_list = &envs[0];
f010334f:	a3 48 12 22 f0       	mov    %eax,0xf0221248
	env_init_percpu();
f0103354:	e8 7b ff ff ff       	call   f01032d4 <env_init_percpu>
}
f0103359:	c9                   	leave  
f010335a:	c3                   	ret    

f010335b <env_alloc>:
{
f010335b:	f3 0f 1e fb          	endbr32 
f010335f:	55                   	push   %ebp
f0103360:	89 e5                	mov    %esp,%ebp
f0103362:	53                   	push   %ebx
f0103363:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103366:	8b 1d 48 12 22 f0    	mov    0xf0221248,%ebx
f010336c:	85 db                	test   %ebx,%ebx
f010336e:	0f 84 e9 00 00 00    	je     f010345d <env_alloc+0x102>
	if ((r = env_setup_vm(e)) < 0)
f0103374:	89 d8                	mov    %ebx,%eax
f0103376:	e8 71 fc ff ff       	call   f0102fec <env_setup_vm>
f010337b:	85 c0                	test   %eax,%eax
f010337d:	0f 88 d5 00 00 00    	js     f0103458 <env_alloc+0xfd>
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103383:	8b 43 48             	mov    0x48(%ebx),%eax
f0103386:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f010338b:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0103390:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103395:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103398:	89 da                	mov    %ebx,%edx
f010339a:	2b 15 44 12 22 f0    	sub    0xf0221244,%edx
f01033a0:	c1 fa 02             	sar    $0x2,%edx
f01033a3:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01033a9:	09 d0                	or     %edx,%eax
f01033ab:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01033ae:	8b 45 0c             	mov    0xc(%ebp),%eax
f01033b1:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01033b4:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01033bb:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01033c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01033c9:	83 ec 04             	sub    $0x4,%esp
f01033cc:	6a 44                	push   $0x44
f01033ce:	6a 00                	push   $0x0
f01033d0:	53                   	push   %ebx
f01033d1:	e8 dc 23 00 00       	call   f01057b2 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01033d6:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01033dc:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01033e2:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01033e8:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01033ef:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags = e->env_tf.tf_eflags | FL_IF;
f01033f5:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f01033fc:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103403:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103407:	8b 43 44             	mov    0x44(%ebx),%eax
f010340a:	a3 48 12 22 f0       	mov    %eax,0xf0221248
	*newenv_store = e;
f010340f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103412:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103414:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103417:	e8 24 2a 00 00       	call   f0105e40 <cpunum>
f010341c:	6b c0 74             	imul   $0x74,%eax,%eax
f010341f:	83 c4 10             	add    $0x10,%esp
f0103422:	ba 00 00 00 00       	mov    $0x0,%edx
f0103427:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f010342e:	74 11                	je     f0103441 <env_alloc+0xe6>
f0103430:	e8 0b 2a 00 00       	call   f0105e40 <cpunum>
f0103435:	6b c0 74             	imul   $0x74,%eax,%eax
f0103438:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010343e:	8b 50 48             	mov    0x48(%eax),%edx
f0103441:	83 ec 04             	sub    $0x4,%esp
f0103444:	53                   	push   %ebx
f0103445:	52                   	push   %edx
f0103446:	68 42 78 10 f0       	push   $0xf0107842
f010344b:	e8 6c 05 00 00       	call   f01039bc <cprintf>
	return 0;
f0103450:	83 c4 10             	add    $0x10,%esp
f0103453:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010345b:	c9                   	leave  
f010345c:	c3                   	ret    
		return -E_NO_FREE_ENV;
f010345d:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103462:	eb f4                	jmp    f0103458 <env_alloc+0xfd>

f0103464 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103464:	f3 0f 1e fb          	endbr32 
f0103468:	55                   	push   %ebp
f0103469:	89 e5                	mov    %esp,%ebp
f010346b:	53                   	push   %ebx
f010346c:	83 ec 1c             	sub    $0x1c,%esp
f010346f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.
	struct Env *env;
	int err = env_alloc(&env, 0);
f0103472:	6a 00                	push   $0x0
f0103474:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103477:	50                   	push   %eax
f0103478:	e8 de fe ff ff       	call   f010335b <env_alloc>

	if (err != 0)
f010347d:	83 c4 10             	add    $0x10,%esp
f0103480:	85 c0                	test   %eax,%eax
f0103482:	75 1b                	jne    f010349f <env_create+0x3b>
		panic("[Error] No se creo el ambiente: %e", err);

	load_icode(env, binary);
f0103484:	8b 55 08             	mov    0x8(%ebp),%edx
f0103487:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010348a:	e8 97 fc ff ff       	call   f0103126 <load_icode>
	env->env_type = type;
f010348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103492:	89 58 50             	mov    %ebx,0x50(%eax)


	// If this is the file server (type == ENV_TYPE_FS) give it I/O
	// privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS) {
f0103495:	83 fb 01             	cmp    $0x1,%ebx
f0103498:	74 1a                	je     f01034b4 <env_create+0x50>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
	}
}
f010349a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010349d:	c9                   	leave  
f010349e:	c3                   	ret    
		panic("[Error] No se creo el ambiente: %e", err);
f010349f:	50                   	push   %eax
f01034a0:	68 14 78 10 f0       	push   $0xf0107814
f01034a5:	68 a3 01 00 00       	push   $0x1a3
f01034aa:	68 37 78 10 f0       	push   $0xf0107837
f01034af:	e8 b6 cb ff ff       	call   f010006a <_panic>
		env->env_tf.tf_eflags |= FL_IOPL_MASK;
f01034b4:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f01034bb:	eb dd                	jmp    f010349a <env_create+0x36>

f01034bd <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01034bd:	f3 0f 1e fb          	endbr32 
f01034c1:	55                   	push   %ebp
f01034c2:	89 e5                	mov    %esp,%ebp
f01034c4:	57                   	push   %edi
f01034c5:	56                   	push   %esi
f01034c6:	53                   	push   %ebx
f01034c7:	83 ec 1c             	sub    $0x1c,%esp
f01034ca:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01034cd:	e8 6e 29 00 00       	call   f0105e40 <cpunum>
f01034d2:	6b c0 74             	imul   $0x74,%eax,%eax
f01034d5:	39 b8 28 30 22 f0    	cmp    %edi,-0xfddcfd8(%eax)
f01034db:	74 45                	je     f0103522 <env_free+0x65>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01034dd:	8b 5f 48             	mov    0x48(%edi),%ebx
f01034e0:	e8 5b 29 00 00       	call   f0105e40 <cpunum>
f01034e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01034e8:	ba 00 00 00 00       	mov    $0x0,%edx
f01034ed:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f01034f4:	74 11                	je     f0103507 <env_free+0x4a>
f01034f6:	e8 45 29 00 00       	call   f0105e40 <cpunum>
f01034fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01034fe:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0103504:	8b 50 48             	mov    0x48(%eax),%edx
f0103507:	83 ec 04             	sub    $0x4,%esp
f010350a:	53                   	push   %ebx
f010350b:	52                   	push   %edx
f010350c:	68 57 78 10 f0       	push   $0xf0107857
f0103511:	e8 a6 04 00 00       	call   f01039bc <cprintf>
f0103516:	83 c4 10             	add    $0x10,%esp
f0103519:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103520:	eb 75                	jmp    f0103597 <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f0103522:	8b 0d 8c 2e 22 f0    	mov    0xf0222e8c,%ecx
f0103528:	ba bf 01 00 00       	mov    $0x1bf,%edx
f010352d:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f0103532:	e8 93 fa ff ff       	call   f0102fca <_paddr>
f0103537:	e8 33 fa ff ff       	call   f0102f6f <lcr3>
f010353c:	eb 9f                	jmp    f01034dd <env_free+0x20>
		pt = (pte_t *) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010353e:	83 ec 08             	sub    $0x8,%esp
f0103541:	89 d8                	mov    %ebx,%eax
f0103543:	c1 e0 0c             	shl    $0xc,%eax
f0103546:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103549:	50                   	push   %eax
f010354a:	ff 77 60             	pushl  0x60(%edi)
f010354d:	e8 c6 e5 ff ff       	call   f0101b18 <page_remove>
f0103552:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103555:	83 c3 01             	add    $0x1,%ebx
f0103558:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010355e:	74 08                	je     f0103568 <env_free+0xab>
			if (pt[pteno] & PTE_P)
f0103560:	f6 04 9e 01          	testb  $0x1,(%esi,%ebx,4)
f0103564:	74 ef                	je     f0103555 <env_free+0x98>
f0103566:	eb d6                	jmp    f010353e <env_free+0x81>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103568:	8b 47 60             	mov    0x60(%edi),%eax
f010356b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010356e:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
		page_decref(pa2page(pa));
f0103575:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103578:	e8 d8 fa ff ff       	call   f0103055 <pa2page>
f010357d:	83 ec 0c             	sub    $0xc,%esp
f0103580:	50                   	push   %eax
f0103581:	e8 9c e0 ff ff       	call   f0101622 <page_decref>
f0103586:	83 c4 10             	add    $0x10,%esp
f0103589:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f010358d:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103590:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103595:	74 38                	je     f01035cf <env_free+0x112>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103597:	8b 47 60             	mov    0x60(%edi),%eax
f010359a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010359d:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01035a0:	a8 01                	test   $0x1,%al
f01035a2:	74 e5                	je     f0103589 <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01035a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01035a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		pt = (pte_t *) KADDR(pa);
f01035ac:	89 c1                	mov    %eax,%ecx
f01035ae:	ba cd 01 00 00       	mov    $0x1cd,%edx
f01035b3:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f01035b8:	e8 c3 f9 ff ff       	call   f0102f80 <_kaddr>
f01035bd:	89 c6                	mov    %eax,%esi
f01035bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01035c2:	c1 e0 14             	shl    $0x14,%eax
f01035c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01035c8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01035cd:	eb 91                	jmp    f0103560 <env_free+0xa3>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01035cf:	8b 4f 60             	mov    0x60(%edi),%ecx
f01035d2:	ba db 01 00 00       	mov    $0x1db,%edx
f01035d7:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f01035dc:	e8 e9 f9 ff ff       	call   f0102fca <_paddr>
	e->env_pgdir = 0;
f01035e1:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	page_decref(pa2page(pa));
f01035e8:	e8 68 fa ff ff       	call   f0103055 <pa2page>
f01035ed:	83 ec 0c             	sub    $0xc,%esp
f01035f0:	50                   	push   %eax
f01035f1:	e8 2c e0 ff ff       	call   f0101622 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01035f6:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01035fd:	a1 48 12 22 f0       	mov    0xf0221248,%eax
f0103602:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103605:	89 3d 48 12 22 f0    	mov    %edi,0xf0221248
}
f010360b:	83 c4 10             	add    $0x10,%esp
f010360e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103611:	5b                   	pop    %ebx
f0103612:	5e                   	pop    %esi
f0103613:	5f                   	pop    %edi
f0103614:	5d                   	pop    %ebp
f0103615:	c3                   	ret    

f0103616 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103616:	f3 0f 1e fb          	endbr32 
f010361a:	55                   	push   %ebp
f010361b:	89 e5                	mov    %esp,%ebp
f010361d:	53                   	push   %ebx
f010361e:	83 ec 04             	sub    $0x4,%esp
f0103621:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103624:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103628:	74 21                	je     f010364b <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f010362a:	83 ec 0c             	sub    $0xc,%esp
f010362d:	53                   	push   %ebx
f010362e:	e8 8a fe ff ff       	call   f01034bd <env_free>

	if (curenv == e) {
f0103633:	e8 08 28 00 00       	call   f0105e40 <cpunum>
f0103638:	6b c0 74             	imul   $0x74,%eax,%eax
f010363b:	83 c4 10             	add    $0x10,%esp
f010363e:	39 98 28 30 22 f0    	cmp    %ebx,-0xfddcfd8(%eax)
f0103644:	74 1e                	je     f0103664 <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f0103646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103649:	c9                   	leave  
f010364a:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010364b:	e8 f0 27 00 00       	call   f0105e40 <cpunum>
f0103650:	6b c0 74             	imul   $0x74,%eax,%eax
f0103653:	39 98 28 30 22 f0    	cmp    %ebx,-0xfddcfd8(%eax)
f0103659:	74 cf                	je     f010362a <env_destroy+0x14>
		e->env_status = ENV_DYING;
f010365b:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103662:	eb e2                	jmp    f0103646 <env_destroy+0x30>
		curenv = NULL;
f0103664:	e8 d7 27 00 00       	call   f0105e40 <cpunum>
f0103669:	6b c0 74             	imul   $0x74,%eax,%eax
f010366c:	c7 80 28 30 22 f0 00 	movl   $0x0,-0xfddcfd8(%eax)
f0103673:	00 00 00 
		sched_yield();
f0103676:	e8 9e 0e 00 00       	call   f0104519 <sched_yield>

f010367b <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010367b:	f3 0f 1e fb          	endbr32 
f010367f:	55                   	push   %ebp
f0103680:	89 e5                	mov    %esp,%ebp
f0103682:	53                   	push   %ebx
f0103683:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103686:	e8 b5 27 00 00       	call   f0105e40 <cpunum>
f010368b:	6b c0 74             	imul   $0x74,%eax,%eax
f010368e:	8b 98 28 30 22 f0    	mov    -0xfddcfd8(%eax),%ebx
f0103694:	e8 a7 27 00 00       	call   f0105e40 <cpunum>
f0103699:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile("\tmovl %0,%%esp\n"
f010369c:	8b 65 08             	mov    0x8(%ebp),%esp
f010369f:	61                   	popa   
f01036a0:	07                   	pop    %es
f01036a1:	1f                   	pop    %ds
f01036a2:	83 c4 08             	add    $0x8,%esp
f01036a5:	cf                   	iret   
	             "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
	             "\tiret\n"
	             :
	             : "g"(tf)
	             : "memory");
	panic("iret failed"); /* mostly to placate the compiler */
f01036a6:	83 ec 04             	sub    $0x4,%esp
f01036a9:	68 6d 78 10 f0       	push   $0xf010786d
f01036ae:	68 13 02 00 00       	push   $0x213
f01036b3:	68 37 78 10 f0       	push   $0xf0107837
f01036b8:	e8 ad c9 ff ff       	call   f010006a <_panic>

f01036bd <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01036bd:	f3 0f 1e fb          	endbr32 
f01036c1:	55                   	push   %ebp
f01036c2:	89 e5                	mov    %esp,%ebp
f01036c4:	83 ec 08             	sub    $0x8,%esp
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.

	if (curenv != NULL && curenv->env_status == ENV_RUNNING) {
f01036c7:	e8 74 27 00 00       	call   f0105e40 <cpunum>
f01036cc:	6b c0 74             	imul   $0x74,%eax,%eax
f01036cf:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f01036d6:	74 14                	je     f01036ec <env_run+0x2f>
f01036d8:	e8 63 27 00 00       	call   f0105e40 <cpunum>
f01036dd:	6b c0 74             	imul   $0x74,%eax,%eax
f01036e0:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01036e6:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01036ea:	74 78                	je     f0103764 <env_run+0xa7>
		curenv->env_status = ENV_RUNNABLE;
	}
	curenv = e;
f01036ec:	e8 4f 27 00 00       	call   f0105e40 <cpunum>
f01036f1:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f4:	8b 55 08             	mov    0x8(%ebp),%edx
f01036f7:	89 90 28 30 22 f0    	mov    %edx,-0xfddcfd8(%eax)
	curenv->env_status = ENV_RUNNING;
f01036fd:	e8 3e 27 00 00       	call   f0105e40 <cpunum>
f0103702:	6b c0 74             	imul   $0x74,%eax,%eax
f0103705:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010370b:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	curenv->env_runs++;
f0103712:	e8 29 27 00 00       	call   f0105e40 <cpunum>
f0103717:	6b c0 74             	imul   $0x74,%eax,%eax
f010371a:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0103720:	83 40 58 01          	addl   $0x1,0x58(%eax)

	lcr3(PADDR(curenv->env_pgdir));
f0103724:	e8 17 27 00 00       	call   f0105e40 <cpunum>
f0103729:	6b c0 74             	imul   $0x74,%eax,%eax
f010372c:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0103732:	8b 48 60             	mov    0x60(%eax),%ecx
f0103735:	ba 39 02 00 00       	mov    $0x239,%edx
f010373a:	b8 37 78 10 f0       	mov    $0xf0107837,%eax
f010373f:	e8 86 f8 ff ff       	call   f0102fca <_paddr>
f0103744:	e8 26 f8 ff ff       	call   f0102f6f <lcr3>
	unlock_kernel();
f0103749:	e8 d1 fa ff ff       	call   f010321f <unlock_kernel>
	env_pop_tf(&(curenv->env_tf));
f010374e:	e8 ed 26 00 00       	call   f0105e40 <cpunum>
f0103753:	83 ec 0c             	sub    $0xc,%esp
f0103756:	6b c0 74             	imul   $0x74,%eax,%eax
f0103759:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f010375f:	e8 17 ff ff ff       	call   f010367b <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f0103764:	e8 d7 26 00 00       	call   f0105e40 <cpunum>
f0103769:	6b c0 74             	imul   $0x74,%eax,%eax
f010376c:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0103772:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103779:	e9 6e ff ff ff       	jmp    f01036ec <env_run+0x2f>

f010377e <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010377e:	89 c2                	mov    %eax,%edx
f0103780:	ec                   	in     (%dx),%al
}
f0103781:	c3                   	ret    

f0103782 <outb>:
{
f0103782:	89 c1                	mov    %eax,%ecx
f0103784:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103786:	89 ca                	mov    %ecx,%edx
f0103788:	ee                   	out    %al,(%dx)
}
f0103789:	c3                   	ret    

f010378a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010378a:	f3 0f 1e fb          	endbr32 
f010378e:	55                   	push   %ebp
f010378f:	89 e5                	mov    %esp,%ebp
f0103791:	83 ec 08             	sub    $0x8,%esp
	outb(IO_RTC, reg);
f0103794:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f0103798:	b8 70 00 00 00       	mov    $0x70,%eax
f010379d:	e8 e0 ff ff ff       	call   f0103782 <outb>
	return inb(IO_RTC+1);
f01037a2:	b8 71 00 00 00       	mov    $0x71,%eax
f01037a7:	e8 d2 ff ff ff       	call   f010377e <inb>
f01037ac:	0f b6 c0             	movzbl %al,%eax
}
f01037af:	c9                   	leave  
f01037b0:	c3                   	ret    

f01037b1 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01037b1:	f3 0f 1e fb          	endbr32 
f01037b5:	55                   	push   %ebp
f01037b6:	89 e5                	mov    %esp,%ebp
f01037b8:	83 ec 08             	sub    $0x8,%esp
	outb(IO_RTC, reg);
f01037bb:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f01037bf:	b8 70 00 00 00       	mov    $0x70,%eax
f01037c4:	e8 b9 ff ff ff       	call   f0103782 <outb>
	outb(IO_RTC+1, datum);
f01037c9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
f01037cd:	b8 71 00 00 00       	mov    $0x71,%eax
f01037d2:	e8 ab ff ff ff       	call   f0103782 <outb>
}
f01037d7:	c9                   	leave  
f01037d8:	c3                   	ret    

f01037d9 <outb>:
{
f01037d9:	89 c1                	mov    %eax,%ecx
f01037db:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037dd:	89 ca                	mov    %ecx,%edx
f01037df:	ee                   	out    %al,(%dx)
}
f01037e0:	c3                   	ret    

f01037e1 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01037e1:	f3 0f 1e fb          	endbr32 
f01037e5:	55                   	push   %ebp
f01037e6:	89 e5                	mov    %esp,%ebp
f01037e8:	56                   	push   %esi
f01037e9:	53                   	push   %ebx
f01037ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	irq_mask_8259A = mask;
f01037ed:	66 89 1d a8 23 12 f0 	mov    %bx,0xf01223a8
	if (!didinit)
f01037f4:	80 3d 4c 12 22 f0 00 	cmpb   $0x0,0xf022124c
f01037fb:	75 07                	jne    f0103804 <irq_setmask_8259A+0x23>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01037fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103800:	5b                   	pop    %ebx
f0103801:	5e                   	pop    %esi
f0103802:	5d                   	pop    %ebp
f0103803:	c3                   	ret    
f0103804:	89 de                	mov    %ebx,%esi
	outb(IO_PIC1+1, (char)mask);
f0103806:	0f b6 d3             	movzbl %bl,%edx
f0103809:	b8 21 00 00 00       	mov    $0x21,%eax
f010380e:	e8 c6 ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103813:	0f b6 d7             	movzbl %bh,%edx
f0103816:	b8 a1 00 00 00       	mov    $0xa1,%eax
f010381b:	e8 b9 ff ff ff       	call   f01037d9 <outb>
	cprintf("enabled interrupts:");
f0103820:	83 ec 0c             	sub    $0xc,%esp
f0103823:	68 79 78 10 f0       	push   $0xf0107879
f0103828:	e8 8f 01 00 00       	call   f01039bc <cprintf>
f010382d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103830:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103835:	0f b7 f6             	movzwl %si,%esi
f0103838:	f7 d6                	not    %esi
f010383a:	eb 19                	jmp    f0103855 <irq_setmask_8259A+0x74>
			cprintf(" %d", i);
f010383c:	83 ec 08             	sub    $0x8,%esp
f010383f:	53                   	push   %ebx
f0103840:	68 4f 7d 10 f0       	push   $0xf0107d4f
f0103845:	e8 72 01 00 00       	call   f01039bc <cprintf>
f010384a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f010384d:	83 c3 01             	add    $0x1,%ebx
f0103850:	83 fb 10             	cmp    $0x10,%ebx
f0103853:	74 07                	je     f010385c <irq_setmask_8259A+0x7b>
		if (~mask & (1<<i))
f0103855:	0f a3 de             	bt     %ebx,%esi
f0103858:	73 f3                	jae    f010384d <irq_setmask_8259A+0x6c>
f010385a:	eb e0                	jmp    f010383c <irq_setmask_8259A+0x5b>
	cprintf("\n");
f010385c:	83 ec 0c             	sub    $0xc,%esp
f010385f:	68 3b 77 10 f0       	push   $0xf010773b
f0103864:	e8 53 01 00 00       	call   f01039bc <cprintf>
f0103869:	83 c4 10             	add    $0x10,%esp
f010386c:	eb 8f                	jmp    f01037fd <irq_setmask_8259A+0x1c>

f010386e <pic_init>:
{
f010386e:	f3 0f 1e fb          	endbr32 
f0103872:	55                   	push   %ebp
f0103873:	89 e5                	mov    %esp,%ebp
f0103875:	83 ec 08             	sub    $0x8,%esp
	didinit = 1;
f0103878:	c6 05 4c 12 22 f0 01 	movb   $0x1,0xf022124c
	outb(IO_PIC1+1, 0xFF);
f010387f:	ba ff 00 00 00       	mov    $0xff,%edx
f0103884:	b8 21 00 00 00       	mov    $0x21,%eax
f0103889:	e8 4b ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2+1, 0xFF);
f010388e:	ba ff 00 00 00       	mov    $0xff,%edx
f0103893:	b8 a1 00 00 00       	mov    $0xa1,%eax
f0103898:	e8 3c ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1, 0x11);
f010389d:	ba 11 00 00 00       	mov    $0x11,%edx
f01038a2:	b8 20 00 00 00       	mov    $0x20,%eax
f01038a7:	e8 2d ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1+1, IRQ_OFFSET);
f01038ac:	ba 20 00 00 00       	mov    $0x20,%edx
f01038b1:	b8 21 00 00 00       	mov    $0x21,%eax
f01038b6:	e8 1e ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
f01038bb:	ba 04 00 00 00       	mov    $0x4,%edx
f01038c0:	b8 21 00 00 00       	mov    $0x21,%eax
f01038c5:	e8 0f ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1+1, 0x3);
f01038ca:	ba 03 00 00 00       	mov    $0x3,%edx
f01038cf:	b8 21 00 00 00       	mov    $0x21,%eax
f01038d4:	e8 00 ff ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2, 0x11);			// ICW1
f01038d9:	ba 11 00 00 00       	mov    $0x11,%edx
f01038de:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01038e3:	e8 f1 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2+1, IRQ_OFFSET + 8);	// ICW2
f01038e8:	ba 28 00 00 00       	mov    $0x28,%edx
f01038ed:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01038f2:	e8 e2 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
f01038f7:	ba 02 00 00 00       	mov    $0x2,%edx
f01038fc:	b8 a1 00 00 00       	mov    $0xa1,%eax
f0103901:	e8 d3 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2+1, 0x01);			// ICW4
f0103906:	ba 01 00 00 00       	mov    $0x1,%edx
f010390b:	b8 a1 00 00 00       	mov    $0xa1,%eax
f0103910:	e8 c4 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1, 0x68);             /* clear specific mask */
f0103915:	ba 68 00 00 00       	mov    $0x68,%edx
f010391a:	b8 20 00 00 00       	mov    $0x20,%eax
f010391f:	e8 b5 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
f0103924:	ba 0a 00 00 00       	mov    $0xa,%edx
f0103929:	b8 20 00 00 00       	mov    $0x20,%eax
f010392e:	e8 a6 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2, 0x68);               /* OCW3 */
f0103933:	ba 68 00 00 00       	mov    $0x68,%edx
f0103938:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010393d:	e8 97 fe ff ff       	call   f01037d9 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
f0103942:	ba 0a 00 00 00       	mov    $0xa,%edx
f0103947:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010394c:	e8 88 fe ff ff       	call   f01037d9 <outb>
	if (irq_mask_8259A != 0xFFFF)
f0103951:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f0103958:	66 83 f8 ff          	cmp    $0xffff,%ax
f010395c:	75 02                	jne    f0103960 <pic_init+0xf2>
}
f010395e:	c9                   	leave  
f010395f:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103960:	83 ec 0c             	sub    $0xc,%esp
f0103963:	0f b7 c0             	movzwl %ax,%eax
f0103966:	50                   	push   %eax
f0103967:	e8 75 fe ff ff       	call   f01037e1 <irq_setmask_8259A>
f010396c:	83 c4 10             	add    $0x10,%esp
}
f010396f:	eb ed                	jmp    f010395e <pic_init+0xf0>

f0103971 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103971:	f3 0f 1e fb          	endbr32 
f0103975:	55                   	push   %ebp
f0103976:	89 e5                	mov    %esp,%ebp
f0103978:	53                   	push   %ebx
f0103979:	83 ec 10             	sub    $0x10,%esp
f010397c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f010397f:	ff 75 08             	pushl  0x8(%ebp)
f0103982:	e8 b9 cf ff ff       	call   f0100940 <cputchar>
	(*cnt)++;
f0103987:	83 03 01             	addl   $0x1,(%ebx)
}
f010398a:	83 c4 10             	add    $0x10,%esp
f010398d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103990:	c9                   	leave  
f0103991:	c3                   	ret    

f0103992 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103992:	f3 0f 1e fb          	endbr32 
f0103996:	55                   	push   %ebp
f0103997:	89 e5                	mov    %esp,%ebp
f0103999:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f010399c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01039a3:	ff 75 0c             	pushl  0xc(%ebp)
f01039a6:	ff 75 08             	pushl  0x8(%ebp)
f01039a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01039ac:	50                   	push   %eax
f01039ad:	68 71 39 10 f0       	push   $0xf0103971
f01039b2:	e8 98 17 00 00       	call   f010514f <vprintfmt>
	return cnt;
}
f01039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01039ba:	c9                   	leave  
f01039bb:	c3                   	ret    

f01039bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01039bc:	f3 0f 1e fb          	endbr32 
f01039c0:	55                   	push   %ebp
f01039c1:	89 e5                	mov    %esp,%ebp
f01039c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01039c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01039c9:	50                   	push   %eax
f01039ca:	ff 75 08             	pushl  0x8(%ebp)
f01039cd:	e8 c0 ff ff ff       	call   f0103992 <vcprintf>
	va_end(ap);

	return cnt;
}
f01039d2:	c9                   	leave  
f01039d3:	c3                   	ret    

f01039d4 <lidt>:
	asm volatile("lidt (%0)" : : "r" (p));
f01039d4:	0f 01 18             	lidtl  (%eax)
}
f01039d7:	c3                   	ret    

f01039d8 <ltr>:
	asm volatile("ltr %0" : : "r" (sel));
f01039d8:	0f 00 d8             	ltr    %ax
}
f01039db:	c3                   	ret    

f01039dc <rcr2>:
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01039dc:	0f 20 d0             	mov    %cr2,%eax
}
f01039df:	c3                   	ret    

f01039e0 <read_eflags>:
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01039e0:	9c                   	pushf  
f01039e1:	58                   	pop    %eax
}
f01039e2:	c3                   	ret    

f01039e3 <xchg>:
{
f01039e3:	89 c1                	mov    %eax,%ecx
f01039e5:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f01039e7:	f0 87 01             	lock xchg %eax,(%ecx)
}
f01039ea:	c3                   	ret    

f01039eb <trapname>:
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < ARRAY_SIZE(excnames))
f01039eb:	83 f8 13             	cmp    $0x13,%eax
f01039ee:	76 20                	jbe    f0103a10 <trapname+0x25>
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f01039f0:	ba 9c 78 10 f0       	mov    $0xf010789c,%edx
	if (trapno == T_SYSCALL)
f01039f5:	83 f8 30             	cmp    $0x30,%eax
f01039f8:	74 13                	je     f0103a0d <trapname+0x22>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01039fa:	83 e8 20             	sub    $0x20,%eax
		return "Hardware Interrupt";
f01039fd:	83 f8 0f             	cmp    $0xf,%eax
f0103a00:	ba 8d 78 10 f0       	mov    $0xf010788d,%edx
f0103a05:	b8 a8 78 10 f0       	mov    $0xf01078a8,%eax
f0103a0a:	0f 46 d0             	cmovbe %eax,%edx
	return "(unknown trap)";
}
f0103a0d:	89 d0                	mov    %edx,%eax
f0103a0f:	c3                   	ret    
		return excnames[trapno];
f0103a10:	8b 14 85 20 7c 10 f0 	mov    -0xfef83e0(,%eax,4),%edx
f0103a17:	eb f4                	jmp    f0103a0d <trapname+0x22>

f0103a19 <lock_kernel>:
{
f0103a19:	55                   	push   %ebp
f0103a1a:	89 e5                	mov    %esp,%ebp
f0103a1c:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f0103a1f:	68 c0 23 12 f0       	push   $0xf01223c0
f0103a24:	e8 1c 27 00 00       	call   f0106145 <spin_lock>
}
f0103a29:	83 c4 10             	add    $0x10,%esp
f0103a2c:	c9                   	leave  
f0103a2d:	c3                   	ret    

f0103a2e <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103a2e:	f3 0f 1e fb          	endbr32 
f0103a32:	55                   	push   %ebp
f0103a33:	89 e5                	mov    %esp,%ebp
f0103a35:	56                   	push   %esi
f0103a36:	53                   	push   %ebx
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:

	int id = cpunum();
f0103a37:	e8 04 24 00 00       	call   f0105e40 <cpunum>
	struct CpuInfo *cpu = &cpus[id];
	struct Taskstate *ts = &cpu->cpu_ts;
f0103a3c:	6b d0 74             	imul   $0x74,%eax,%edx
f0103a3f:	8d 8a 2c 30 22 f0    	lea    -0xfddcfd4(%edx),%ecx

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts->ts_esp0 = KSTACKTOP - (id * (KSTKSIZE + KSTKGAP));
f0103a45:	89 c6                	mov    %eax,%esi
f0103a47:	c1 e6 10             	shl    $0x10,%esi
f0103a4a:	bb 00 00 00 f0       	mov    $0xf0000000,%ebx
f0103a4f:	29 f3                	sub    %esi,%ebx
f0103a51:	89 9a 30 30 22 f0    	mov    %ebx,-0xfddcfd0(%edx)
	ts->ts_ss0 = GD_KD;
f0103a57:	66 c7 82 34 30 22 f0 	movw   $0x10,-0xfddcfcc(%edx)
f0103a5e:	10 00 
	ts->ts_iomb = sizeof(struct Taskstate);
f0103a60:	66 c7 82 92 30 22 f0 	movw   $0x68,-0xfddcf6e(%edx)
f0103a67:	68 00 

	uint16_t idx = (GD_TSS0 >> 3) + id;
f0103a69:	83 c0 05             	add    $0x5,%eax
	uint16_t seg = idx << 3;

	// Initialize the TSS slot of the gdt.
	gdt[idx] =
f0103a6c:	0f b7 d0             	movzwl %ax,%edx
f0103a6f:	66 c7 04 d5 40 23 12 	movw   $0x67,-0xfeddcc0(,%edx,8)
f0103a76:	f0 67 00 
f0103a79:	66 89 0c d5 42 23 12 	mov    %cx,-0xfeddcbe(,%edx,8)
f0103a80:	f0 
	        SEG16(STS_T32A, (uint32_t)(ts), sizeof(struct Taskstate) - 1, 0);
f0103a81:	89 cb                	mov    %ecx,%ebx
f0103a83:	c1 eb 10             	shr    $0x10,%ebx
	gdt[idx] =
f0103a86:	88 1c d5 44 23 12 f0 	mov    %bl,-0xfeddcbc(,%edx,8)
f0103a8d:	c6 04 d5 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%edx,8)
f0103a94:	40 
	        SEG16(STS_T32A, (uint32_t)(ts), sizeof(struct Taskstate) - 1, 0);
f0103a95:	c1 e9 18             	shr    $0x18,%ecx
	gdt[idx] =
f0103a98:	88 0c d5 47 23 12 f0 	mov    %cl,-0xfeddcb9(,%edx,8)
	gdt[idx].sd_s = 0;
f0103a9f:	c6 04 d5 45 23 12 f0 	movb   $0x89,-0xfeddcbb(,%edx,8)
f0103aa6:	89 
	uint16_t seg = idx << 3;
f0103aa7:	c1 e0 03             	shl    $0x3,%eax

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(seg);
f0103aaa:	0f b7 c0             	movzwl %ax,%eax
f0103aad:	e8 26 ff ff ff       	call   f01039d8 <ltr>

	// Load the IDT
	lidt(&idt_pd);
f0103ab2:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f0103ab7:	e8 18 ff ff ff       	call   f01039d4 <lidt>
}
f0103abc:	5b                   	pop    %ebx
f0103abd:	5e                   	pop    %esi
f0103abe:	5d                   	pop    %ebp
f0103abf:	c3                   	ret    

f0103ac0 <trap_init>:
{
f0103ac0:	f3 0f 1e fb          	endbr32 
f0103ac4:	55                   	push   %ebp
f0103ac5:	89 e5                	mov    %esp,%ebp
f0103ac7:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, &thn_divide, 0);
f0103aca:	b8 a4 43 10 f0       	mov    $0xf01043a4,%eax
f0103acf:	66 a3 60 12 22 f0    	mov    %ax,0xf0221260
f0103ad5:	66 c7 05 62 12 22 f0 	movw   $0x8,0xf0221262
f0103adc:	08 00 
f0103ade:	c6 05 64 12 22 f0 00 	movb   $0x0,0xf0221264
f0103ae5:	c6 05 65 12 22 f0 8e 	movb   $0x8e,0xf0221265
f0103aec:	c1 e8 10             	shr    $0x10,%eax
f0103aef:	66 a3 66 12 22 f0    	mov    %ax,0xf0221266
	SETGATE(idt[T_DEBUG], 0, GD_KT, &thn_debug, 0);
f0103af5:	b8 aa 43 10 f0       	mov    $0xf01043aa,%eax
f0103afa:	66 a3 68 12 22 f0    	mov    %ax,0xf0221268
f0103b00:	66 c7 05 6a 12 22 f0 	movw   $0x8,0xf022126a
f0103b07:	08 00 
f0103b09:	c6 05 6c 12 22 f0 00 	movb   $0x0,0xf022126c
f0103b10:	c6 05 6d 12 22 f0 8e 	movb   $0x8e,0xf022126d
f0103b17:	c1 e8 10             	shr    $0x10,%eax
f0103b1a:	66 a3 6e 12 22 f0    	mov    %ax,0xf022126e
	SETGATE(idt[T_NMI], 0, GD_KT, &thn_nmi, 0);
f0103b20:	b8 b0 43 10 f0       	mov    $0xf01043b0,%eax
f0103b25:	66 a3 70 12 22 f0    	mov    %ax,0xf0221270
f0103b2b:	66 c7 05 72 12 22 f0 	movw   $0x8,0xf0221272
f0103b32:	08 00 
f0103b34:	c6 05 74 12 22 f0 00 	movb   $0x0,0xf0221274
f0103b3b:	c6 05 75 12 22 f0 8e 	movb   $0x8e,0xf0221275
f0103b42:	c1 e8 10             	shr    $0x10,%eax
f0103b45:	66 a3 76 12 22 f0    	mov    %ax,0xf0221276
	SETGATE(idt[T_BRKPT], 0, GD_KT, &thn_brkpt, 3);
f0103b4b:	b8 b6 43 10 f0       	mov    $0xf01043b6,%eax
f0103b50:	66 a3 78 12 22 f0    	mov    %ax,0xf0221278
f0103b56:	66 c7 05 7a 12 22 f0 	movw   $0x8,0xf022127a
f0103b5d:	08 00 
f0103b5f:	c6 05 7c 12 22 f0 00 	movb   $0x0,0xf022127c
f0103b66:	c6 05 7d 12 22 f0 ee 	movb   $0xee,0xf022127d
f0103b6d:	c1 e8 10             	shr    $0x10,%eax
f0103b70:	66 a3 7e 12 22 f0    	mov    %ax,0xf022127e
	SETGATE(idt[T_OFLOW], 0, GD_KT, &thn_oflow, 0);
f0103b76:	b8 bc 43 10 f0       	mov    $0xf01043bc,%eax
f0103b7b:	66 a3 80 12 22 f0    	mov    %ax,0xf0221280
f0103b81:	66 c7 05 82 12 22 f0 	movw   $0x8,0xf0221282
f0103b88:	08 00 
f0103b8a:	c6 05 84 12 22 f0 00 	movb   $0x0,0xf0221284
f0103b91:	c6 05 85 12 22 f0 8e 	movb   $0x8e,0xf0221285
f0103b98:	c1 e8 10             	shr    $0x10,%eax
f0103b9b:	66 a3 86 12 22 f0    	mov    %ax,0xf0221286
	SETGATE(idt[T_BOUND], 0, GD_KT, &thn_bound, 0);
f0103ba1:	b8 c2 43 10 f0       	mov    $0xf01043c2,%eax
f0103ba6:	66 a3 88 12 22 f0    	mov    %ax,0xf0221288
f0103bac:	66 c7 05 8a 12 22 f0 	movw   $0x8,0xf022128a
f0103bb3:	08 00 
f0103bb5:	c6 05 8c 12 22 f0 00 	movb   $0x0,0xf022128c
f0103bbc:	c6 05 8d 12 22 f0 8e 	movb   $0x8e,0xf022128d
f0103bc3:	c1 e8 10             	shr    $0x10,%eax
f0103bc6:	66 a3 8e 12 22 f0    	mov    %ax,0xf022128e
	SETGATE(idt[T_ILLOP], 0, GD_KT, &thn_illop, 0);
f0103bcc:	b8 c8 43 10 f0       	mov    $0xf01043c8,%eax
f0103bd1:	66 a3 90 12 22 f0    	mov    %ax,0xf0221290
f0103bd7:	66 c7 05 92 12 22 f0 	movw   $0x8,0xf0221292
f0103bde:	08 00 
f0103be0:	c6 05 94 12 22 f0 00 	movb   $0x0,0xf0221294
f0103be7:	c6 05 95 12 22 f0 8e 	movb   $0x8e,0xf0221295
f0103bee:	c1 e8 10             	shr    $0x10,%eax
f0103bf1:	66 a3 96 12 22 f0    	mov    %ax,0xf0221296
	SETGATE(idt[T_DEVICE], 0, GD_KT, &thn_device, 0);
f0103bf7:	b8 ce 43 10 f0       	mov    $0xf01043ce,%eax
f0103bfc:	66 a3 98 12 22 f0    	mov    %ax,0xf0221298
f0103c02:	66 c7 05 9a 12 22 f0 	movw   $0x8,0xf022129a
f0103c09:	08 00 
f0103c0b:	c6 05 9c 12 22 f0 00 	movb   $0x0,0xf022129c
f0103c12:	c6 05 9d 12 22 f0 8e 	movb   $0x8e,0xf022129d
f0103c19:	c1 e8 10             	shr    $0x10,%eax
f0103c1c:	66 a3 9e 12 22 f0    	mov    %ax,0xf022129e
	SETGATE(idt[T_FPERR], 0, GD_KT, &thn_fperr, 0);
f0103c22:	b8 d4 43 10 f0       	mov    $0xf01043d4,%eax
f0103c27:	66 a3 e0 12 22 f0    	mov    %ax,0xf02212e0
f0103c2d:	66 c7 05 e2 12 22 f0 	movw   $0x8,0xf02212e2
f0103c34:	08 00 
f0103c36:	c6 05 e4 12 22 f0 00 	movb   $0x0,0xf02212e4
f0103c3d:	c6 05 e5 12 22 f0 8e 	movb   $0x8e,0xf02212e5
f0103c44:	c1 e8 10             	shr    $0x10,%eax
f0103c47:	66 a3 e6 12 22 f0    	mov    %ax,0xf02212e6
	SETGATE(idt[T_MCHK], 0, GD_KT, &thn_mchk, 0);
f0103c4d:	b8 da 43 10 f0       	mov    $0xf01043da,%eax
f0103c52:	66 a3 f0 12 22 f0    	mov    %ax,0xf02212f0
f0103c58:	66 c7 05 f2 12 22 f0 	movw   $0x8,0xf02212f2
f0103c5f:	08 00 
f0103c61:	c6 05 f4 12 22 f0 00 	movb   $0x0,0xf02212f4
f0103c68:	c6 05 f5 12 22 f0 8e 	movb   $0x8e,0xf02212f5
f0103c6f:	c1 e8 10             	shr    $0x10,%eax
f0103c72:	66 a3 f6 12 22 f0    	mov    %ax,0xf02212f6
	SETGATE(idt[T_SYSCALL], 0, GD_KT, &thn_syscall, 3);
f0103c78:	b8 e6 43 10 f0       	mov    $0xf01043e6,%eax
f0103c7d:	66 a3 e0 13 22 f0    	mov    %ax,0xf02213e0
f0103c83:	66 c7 05 e2 13 22 f0 	movw   $0x8,0xf02213e2
f0103c8a:	08 00 
f0103c8c:	c6 05 e4 13 22 f0 00 	movb   $0x0,0xf02213e4
f0103c93:	c6 05 e5 13 22 f0 ee 	movb   $0xee,0xf02213e5
f0103c9a:	c1 e8 10             	shr    $0x10,%eax
f0103c9d:	66 a3 e6 13 22 f0    	mov    %ax,0xf02213e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, &thn_irq_timer, 0);
f0103ca3:	b8 ec 43 10 f0       	mov    $0xf01043ec,%eax
f0103ca8:	66 a3 60 13 22 f0    	mov    %ax,0xf0221360
f0103cae:	66 c7 05 62 13 22 f0 	movw   $0x8,0xf0221362
f0103cb5:	08 00 
f0103cb7:	c6 05 64 13 22 f0 00 	movb   $0x0,0xf0221364
f0103cbe:	c6 05 65 13 22 f0 8e 	movb   $0x8e,0xf0221365
f0103cc5:	c1 e8 10             	shr    $0x10,%eax
f0103cc8:	66 a3 66 13 22 f0    	mov    %ax,0xf0221366
	SETGATE(idt[T_SIMDERR], 0, GD_KT, &thn_simderr, 0);
f0103cce:	b8 e0 43 10 f0       	mov    $0xf01043e0,%eax
f0103cd3:	66 a3 f8 12 22 f0    	mov    %ax,0xf02212f8
f0103cd9:	66 c7 05 fa 12 22 f0 	movw   $0x8,0xf02212fa
f0103ce0:	08 00 
f0103ce2:	c6 05 fc 12 22 f0 00 	movb   $0x0,0xf02212fc
f0103ce9:	c6 05 fd 12 22 f0 8e 	movb   $0x8e,0xf02212fd
f0103cf0:	c1 e8 10             	shr    $0x10,%eax
f0103cf3:	66 a3 fe 12 22 f0    	mov    %ax,0xf02212fe
	SETGATE(idt[T_DBLFLT], 0, GD_KT, &th_dblflt, 0);
f0103cf9:	b8 f2 43 10 f0       	mov    $0xf01043f2,%eax
f0103cfe:	66 a3 a0 12 22 f0    	mov    %ax,0xf02212a0
f0103d04:	66 c7 05 a2 12 22 f0 	movw   $0x8,0xf02212a2
f0103d0b:	08 00 
f0103d0d:	c6 05 a4 12 22 f0 00 	movb   $0x0,0xf02212a4
f0103d14:	c6 05 a5 12 22 f0 8e 	movb   $0x8e,0xf02212a5
f0103d1b:	c1 e8 10             	shr    $0x10,%eax
f0103d1e:	66 a3 a6 12 22 f0    	mov    %ax,0xf02212a6
	SETGATE(idt[T_TSS], 0, GD_KT, &th_tss, 0);
f0103d24:	b8 f6 43 10 f0       	mov    $0xf01043f6,%eax
f0103d29:	66 a3 b0 12 22 f0    	mov    %ax,0xf02212b0
f0103d2f:	66 c7 05 b2 12 22 f0 	movw   $0x8,0xf02212b2
f0103d36:	08 00 
f0103d38:	c6 05 b4 12 22 f0 00 	movb   $0x0,0xf02212b4
f0103d3f:	c6 05 b5 12 22 f0 8e 	movb   $0x8e,0xf02212b5
f0103d46:	c1 e8 10             	shr    $0x10,%eax
f0103d49:	66 a3 b6 12 22 f0    	mov    %ax,0xf02212b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, &th_segnp, 0);
f0103d4f:	b8 fa 43 10 f0       	mov    $0xf01043fa,%eax
f0103d54:	66 a3 b8 12 22 f0    	mov    %ax,0xf02212b8
f0103d5a:	66 c7 05 ba 12 22 f0 	movw   $0x8,0xf02212ba
f0103d61:	08 00 
f0103d63:	c6 05 bc 12 22 f0 00 	movb   $0x0,0xf02212bc
f0103d6a:	c6 05 bd 12 22 f0 8e 	movb   $0x8e,0xf02212bd
f0103d71:	c1 e8 10             	shr    $0x10,%eax
f0103d74:	66 a3 be 12 22 f0    	mov    %ax,0xf02212be
	SETGATE(idt[T_STACK], 0, GD_KT, &th_stack, 0);
f0103d7a:	b8 fe 43 10 f0       	mov    $0xf01043fe,%eax
f0103d7f:	66 a3 c0 12 22 f0    	mov    %ax,0xf02212c0
f0103d85:	66 c7 05 c2 12 22 f0 	movw   $0x8,0xf02212c2
f0103d8c:	08 00 
f0103d8e:	c6 05 c4 12 22 f0 00 	movb   $0x0,0xf02212c4
f0103d95:	c6 05 c5 12 22 f0 8e 	movb   $0x8e,0xf02212c5
f0103d9c:	c1 e8 10             	shr    $0x10,%eax
f0103d9f:	66 a3 c6 12 22 f0    	mov    %ax,0xf02212c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, &th_gpflt, 0);
f0103da5:	b8 02 44 10 f0       	mov    $0xf0104402,%eax
f0103daa:	66 a3 c8 12 22 f0    	mov    %ax,0xf02212c8
f0103db0:	66 c7 05 ca 12 22 f0 	movw   $0x8,0xf02212ca
f0103db7:	08 00 
f0103db9:	c6 05 cc 12 22 f0 00 	movb   $0x0,0xf02212cc
f0103dc0:	c6 05 cd 12 22 f0 8e 	movb   $0x8e,0xf02212cd
f0103dc7:	c1 e8 10             	shr    $0x10,%eax
f0103dca:	66 a3 ce 12 22 f0    	mov    %ax,0xf02212ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, &th_pgflt, 0);
f0103dd0:	b8 06 44 10 f0       	mov    $0xf0104406,%eax
f0103dd5:	66 a3 d0 12 22 f0    	mov    %ax,0xf02212d0
f0103ddb:	66 c7 05 d2 12 22 f0 	movw   $0x8,0xf02212d2
f0103de2:	08 00 
f0103de4:	c6 05 d4 12 22 f0 00 	movb   $0x0,0xf02212d4
f0103deb:	c6 05 d5 12 22 f0 8e 	movb   $0x8e,0xf02212d5
f0103df2:	c1 e8 10             	shr    $0x10,%eax
f0103df5:	66 a3 d6 12 22 f0    	mov    %ax,0xf02212d6
	SETGATE(idt[T_ALIGN], 0, GD_KT, &th_align, 0);
f0103dfb:	b8 0a 44 10 f0       	mov    $0xf010440a,%eax
f0103e00:	66 a3 e8 12 22 f0    	mov    %ax,0xf02212e8
f0103e06:	66 c7 05 ea 12 22 f0 	movw   $0x8,0xf02212ea
f0103e0d:	08 00 
f0103e0f:	c6 05 ec 12 22 f0 00 	movb   $0x0,0xf02212ec
f0103e16:	c6 05 ed 12 22 f0 8e 	movb   $0x8e,0xf02212ed
f0103e1d:	c1 e8 10             	shr    $0x10,%eax
f0103e20:	66 a3 ee 12 22 f0    	mov    %ax,0xf02212ee
	trap_init_percpu();
f0103e26:	e8 03 fc ff ff       	call   f0103a2e <trap_init_percpu>
}
f0103e2b:	c9                   	leave  
f0103e2c:	c3                   	ret    

f0103e2d <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103e2d:	f3 0f 1e fb          	endbr32 
f0103e31:	55                   	push   %ebp
f0103e32:	89 e5                	mov    %esp,%ebp
f0103e34:	53                   	push   %ebx
f0103e35:	83 ec 0c             	sub    $0xc,%esp
f0103e38:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103e3b:	ff 33                	pushl  (%ebx)
f0103e3d:	68 bb 78 10 f0       	push   $0xf01078bb
f0103e42:	e8 75 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103e47:	83 c4 08             	add    $0x8,%esp
f0103e4a:	ff 73 04             	pushl  0x4(%ebx)
f0103e4d:	68 ca 78 10 f0       	push   $0xf01078ca
f0103e52:	e8 65 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103e57:	83 c4 08             	add    $0x8,%esp
f0103e5a:	ff 73 08             	pushl  0x8(%ebx)
f0103e5d:	68 d9 78 10 f0       	push   $0xf01078d9
f0103e62:	e8 55 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103e67:	83 c4 08             	add    $0x8,%esp
f0103e6a:	ff 73 0c             	pushl  0xc(%ebx)
f0103e6d:	68 e8 78 10 f0       	push   $0xf01078e8
f0103e72:	e8 45 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103e77:	83 c4 08             	add    $0x8,%esp
f0103e7a:	ff 73 10             	pushl  0x10(%ebx)
f0103e7d:	68 f7 78 10 f0       	push   $0xf01078f7
f0103e82:	e8 35 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103e87:	83 c4 08             	add    $0x8,%esp
f0103e8a:	ff 73 14             	pushl  0x14(%ebx)
f0103e8d:	68 06 79 10 f0       	push   $0xf0107906
f0103e92:	e8 25 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103e97:	83 c4 08             	add    $0x8,%esp
f0103e9a:	ff 73 18             	pushl  0x18(%ebx)
f0103e9d:	68 15 79 10 f0       	push   $0xf0107915
f0103ea2:	e8 15 fb ff ff       	call   f01039bc <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103ea7:	83 c4 08             	add    $0x8,%esp
f0103eaa:	ff 73 1c             	pushl  0x1c(%ebx)
f0103ead:	68 24 79 10 f0       	push   $0xf0107924
f0103eb2:	e8 05 fb ff ff       	call   f01039bc <cprintf>
}
f0103eb7:	83 c4 10             	add    $0x10,%esp
f0103eba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103ebd:	c9                   	leave  
f0103ebe:	c3                   	ret    

f0103ebf <print_trapframe>:
{
f0103ebf:	f3 0f 1e fb          	endbr32 
f0103ec3:	55                   	push   %ebp
f0103ec4:	89 e5                	mov    %esp,%ebp
f0103ec6:	56                   	push   %esi
f0103ec7:	53                   	push   %ebx
f0103ec8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103ecb:	e8 70 1f 00 00       	call   f0105e40 <cpunum>
f0103ed0:	83 ec 04             	sub    $0x4,%esp
f0103ed3:	50                   	push   %eax
f0103ed4:	53                   	push   %ebx
f0103ed5:	68 5a 79 10 f0       	push   $0xf010795a
f0103eda:	e8 dd fa ff ff       	call   f01039bc <cprintf>
	print_regs(&tf->tf_regs);
f0103edf:	89 1c 24             	mov    %ebx,(%esp)
f0103ee2:	e8 46 ff ff ff       	call   f0103e2d <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103ee7:	83 c4 08             	add    $0x8,%esp
f0103eea:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103eee:	50                   	push   %eax
f0103eef:	68 78 79 10 f0       	push   $0xf0107978
f0103ef4:	e8 c3 fa ff ff       	call   f01039bc <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103ef9:	83 c4 08             	add    $0x8,%esp
f0103efc:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103f00:	50                   	push   %eax
f0103f01:	68 8b 79 10 f0       	push   $0xf010798b
f0103f06:	e8 b1 fa ff ff       	call   f01039bc <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f0b:	8b 73 28             	mov    0x28(%ebx),%esi
f0103f0e:	89 f0                	mov    %esi,%eax
f0103f10:	e8 d6 fa ff ff       	call   f01039eb <trapname>
f0103f15:	83 c4 0c             	add    $0xc,%esp
f0103f18:	50                   	push   %eax
f0103f19:	56                   	push   %esi
f0103f1a:	68 9e 79 10 f0       	push   $0xf010799e
f0103f1f:	e8 98 fa ff ff       	call   f01039bc <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103f24:	83 c4 10             	add    $0x10,%esp
f0103f27:	39 1d 60 1a 22 f0    	cmp    %ebx,0xf0221a60
f0103f2d:	0f 84 9f 00 00 00    	je     f0103fd2 <print_trapframe+0x113>
	cprintf("  err  0x%08x", tf->tf_err);
f0103f33:	83 ec 08             	sub    $0x8,%esp
f0103f36:	ff 73 2c             	pushl  0x2c(%ebx)
f0103f39:	68 bf 79 10 f0       	push   $0xf01079bf
f0103f3e:	e8 79 fa ff ff       	call   f01039bc <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103f43:	83 c4 10             	add    $0x10,%esp
f0103f46:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103f4a:	0f 85 a7 00 00 00    	jne    f0103ff7 <print_trapframe+0x138>
		        tf->tf_err & 1 ? "protection" : "not-present");
f0103f50:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103f53:	a8 01                	test   $0x1,%al
f0103f55:	b9 33 79 10 f0       	mov    $0xf0107933,%ecx
f0103f5a:	ba 3e 79 10 f0       	mov    $0xf010793e,%edx
f0103f5f:	0f 44 ca             	cmove  %edx,%ecx
f0103f62:	a8 02                	test   $0x2,%al
f0103f64:	be 4a 79 10 f0       	mov    $0xf010794a,%esi
f0103f69:	ba 50 79 10 f0       	mov    $0xf0107950,%edx
f0103f6e:	0f 45 d6             	cmovne %esi,%edx
f0103f71:	a8 04                	test   $0x4,%al
f0103f73:	b8 55 79 10 f0       	mov    $0xf0107955,%eax
f0103f78:	be 6a 7a 10 f0       	mov    $0xf0107a6a,%esi
f0103f7d:	0f 44 c6             	cmove  %esi,%eax
f0103f80:	51                   	push   %ecx
f0103f81:	52                   	push   %edx
f0103f82:	50                   	push   %eax
f0103f83:	68 cd 79 10 f0       	push   $0xf01079cd
f0103f88:	e8 2f fa ff ff       	call   f01039bc <cprintf>
f0103f8d:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103f90:	83 ec 08             	sub    $0x8,%esp
f0103f93:	ff 73 30             	pushl  0x30(%ebx)
f0103f96:	68 dc 79 10 f0       	push   $0xf01079dc
f0103f9b:	e8 1c fa ff ff       	call   f01039bc <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103fa0:	83 c4 08             	add    $0x8,%esp
f0103fa3:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103fa7:	50                   	push   %eax
f0103fa8:	68 eb 79 10 f0       	push   $0xf01079eb
f0103fad:	e8 0a fa ff ff       	call   f01039bc <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103fb2:	83 c4 08             	add    $0x8,%esp
f0103fb5:	ff 73 38             	pushl  0x38(%ebx)
f0103fb8:	68 fe 79 10 f0       	push   $0xf01079fe
f0103fbd:	e8 fa f9 ff ff       	call   f01039bc <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103fc2:	83 c4 10             	add    $0x10,%esp
f0103fc5:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103fc9:	75 3e                	jne    f0104009 <print_trapframe+0x14a>
}
f0103fcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103fce:	5b                   	pop    %ebx
f0103fcf:	5e                   	pop    %esi
f0103fd0:	5d                   	pop    %ebp
f0103fd1:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103fd2:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103fd6:	0f 85 57 ff ff ff    	jne    f0103f33 <print_trapframe+0x74>
		cprintf("  cr2  0x%08x\n", rcr2());
f0103fdc:	e8 fb f9 ff ff       	call   f01039dc <rcr2>
f0103fe1:	83 ec 08             	sub    $0x8,%esp
f0103fe4:	50                   	push   %eax
f0103fe5:	68 b0 79 10 f0       	push   $0xf01079b0
f0103fea:	e8 cd f9 ff ff       	call   f01039bc <cprintf>
f0103fef:	83 c4 10             	add    $0x10,%esp
f0103ff2:	e9 3c ff ff ff       	jmp    f0103f33 <print_trapframe+0x74>
		cprintf("\n");
f0103ff7:	83 ec 0c             	sub    $0xc,%esp
f0103ffa:	68 3b 77 10 f0       	push   $0xf010773b
f0103fff:	e8 b8 f9 ff ff       	call   f01039bc <cprintf>
f0104004:	83 c4 10             	add    $0x10,%esp
f0104007:	eb 87                	jmp    f0103f90 <print_trapframe+0xd1>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104009:	83 ec 08             	sub    $0x8,%esp
f010400c:	ff 73 3c             	pushl  0x3c(%ebx)
f010400f:	68 0d 7a 10 f0       	push   $0xf0107a0d
f0104014:	e8 a3 f9 ff ff       	call   f01039bc <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104019:	83 c4 08             	add    $0x8,%esp
f010401c:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104020:	50                   	push   %eax
f0104021:	68 1c 7a 10 f0       	push   $0xf0107a1c
f0104026:	e8 91 f9 ff ff       	call   f01039bc <cprintf>
f010402b:	83 c4 10             	add    $0x10,%esp
}
f010402e:	eb 9b                	jmp    f0103fcb <print_trapframe+0x10c>

f0104030 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104030:	f3 0f 1e fb          	endbr32 
f0104034:	55                   	push   %ebp
f0104035:	89 e5                	mov    %esp,%ebp
f0104037:	57                   	push   %edi
f0104038:	56                   	push   %esi
f0104039:	53                   	push   %ebx
f010403a:	83 ec 0c             	sub    $0xc,%esp
f010403d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
f0104040:	e8 97 f9 ff ff       	call   f01039dc <rcr2>

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs & 0x3) == 0) {
f0104045:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104049:	74 5f                	je     f01040aa <page_fault_handler+0x7a>
f010404b:	89 c6                	mov    %eax,%esi
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if (curenv->env_pgfault_upcall) {
f010404d:	e8 ee 1d 00 00       	call   f0105e40 <cpunum>
f0104052:	6b c0 74             	imul   $0x74,%eax,%eax
f0104055:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010405b:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010405f:	75 60                	jne    f01040c1 <page_fault_handler+0x91>
		tf->tf_esp = (uint32_t) u;

		env_run(curenv);
	}

	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104061:	8b 7b 30             	mov    0x30(%ebx),%edi
	        curenv->env_id,
f0104064:	e8 d7 1d 00 00       	call   f0105e40 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104069:	57                   	push   %edi
f010406a:	56                   	push   %esi
	        curenv->env_id,
f010406b:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010406e:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104074:	ff 70 48             	pushl  0x48(%eax)
f0104077:	68 f8 7b 10 f0       	push   $0xf0107bf8
f010407c:	e8 3b f9 ff ff       	call   f01039bc <cprintf>
	        fault_va,
	        tf->tf_eip);
	print_trapframe(tf);
f0104081:	89 1c 24             	mov    %ebx,(%esp)
f0104084:	e8 36 fe ff ff       	call   f0103ebf <print_trapframe>
	env_destroy(curenv);
f0104089:	e8 b2 1d 00 00       	call   f0105e40 <cpunum>
f010408e:	83 c4 04             	add    $0x4,%esp
f0104091:	6b c0 74             	imul   $0x74,%eax,%eax
f0104094:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f010409a:	e8 77 f5 ff ff       	call   f0103616 <env_destroy>
}
f010409f:	83 c4 10             	add    $0x10,%esp
f01040a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01040a5:	5b                   	pop    %ebx
f01040a6:	5e                   	pop    %esi
f01040a7:	5f                   	pop    %edi
f01040a8:	5d                   	pop    %ebp
f01040a9:	c3                   	ret    
		panic("[Error]: page fault en el ring 0.");
f01040aa:	83 ec 04             	sub    $0x4,%esp
f01040ad:	68 d4 7b 10 f0       	push   $0xf0107bd4
f01040b2:	68 5e 01 00 00       	push   $0x15e
f01040b7:	68 2f 7a 10 f0       	push   $0xf0107a2f
f01040bc:	e8 a9 bf ff ff       	call   f010006a <_panic>
		if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
f01040c1:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01040c4:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
f01040ca:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01040d0:	0f 87 81 00 00 00    	ja     f0104157 <page_fault_handler+0x127>
			*(uint32_t *) (tf->tf_esp - 4) = 0;
f01040d6:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
			u = (struct UTrapframe *) (tf->tf_esp - 4 -
f01040dd:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01040e0:	83 e8 38             	sub    $0x38,%eax
f01040e3:	89 c7                	mov    %eax,%edi
			user_mem_assert(curenv,
f01040e5:	e8 56 1d 00 00       	call   f0105e40 <cpunum>
f01040ea:	6a 06                	push   $0x6
f01040ec:	6a 34                	push   $0x34
f01040ee:	57                   	push   %edi
f01040ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01040f2:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f01040f8:	e8 1a ee ff ff       	call   f0102f17 <user_mem_assert>
f01040fd:	83 c4 10             	add    $0x10,%esp
		u->utf_fault_va = fault_va;
f0104100:	89 fa                	mov    %edi,%edx
f0104102:	89 37                	mov    %esi,(%edi)
		u->utf_esp = tf->tf_esp;
f0104104:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104107:	89 47 30             	mov    %eax,0x30(%edi)
		u->utf_eflags = tf->tf_eflags;
f010410a:	8b 43 38             	mov    0x38(%ebx),%eax
f010410d:	89 47 2c             	mov    %eax,0x2c(%edi)
		u->utf_eip = tf->tf_eip;
f0104110:	8b 43 30             	mov    0x30(%ebx),%eax
f0104113:	89 47 28             	mov    %eax,0x28(%edi)
		u->utf_regs = tf->tf_regs;
f0104116:	8d 7f 08             	lea    0x8(%edi),%edi
f0104119:	b9 08 00 00 00       	mov    $0x8,%ecx
f010411e:	89 de                	mov    %ebx,%esi
f0104120:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		u->utf_err = tf->tf_err;
f0104122:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104125:	89 d7                	mov    %edx,%edi
f0104127:	89 42 04             	mov    %eax,0x4(%edx)
		tf->tf_eip = (uint32_t) curenv->env_pgfault_upcall;
f010412a:	e8 11 1d 00 00       	call   f0105e40 <cpunum>
f010412f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104132:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104138:	8b 40 64             	mov    0x64(%eax),%eax
f010413b:	89 43 30             	mov    %eax,0x30(%ebx)
		tf->tf_esp = (uint32_t) u;
f010413e:	89 7b 3c             	mov    %edi,0x3c(%ebx)
		env_run(curenv);
f0104141:	e8 fa 1c 00 00       	call   f0105e40 <cpunum>
f0104146:	83 ec 0c             	sub    $0xc,%esp
f0104149:	6b c0 74             	imul   $0x74,%eax,%eax
f010414c:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f0104152:	e8 66 f5 ff ff       	call   f01036bd <env_run>
			user_mem_assert(curenv,
f0104157:	e8 e4 1c 00 00       	call   f0105e40 <cpunum>
f010415c:	6a 06                	push   $0x6
f010415e:	6a 34                	push   $0x34
f0104160:	68 cc ff bf ee       	push   $0xeebfffcc
f0104165:	6b c0 74             	imul   $0x74,%eax,%eax
f0104168:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f010416e:	e8 a4 ed ff ff       	call   f0102f17 <user_mem_assert>
f0104173:	83 c4 10             	add    $0x10,%esp
			u = (struct UTrapframe *) (UXSTACKTOP -
f0104176:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
f010417b:	eb 83                	jmp    f0104100 <page_fault_handler+0xd0>

f010417d <trap_dispatch>:
{
f010417d:	55                   	push   %ebp
f010417e:	89 e5                	mov    %esp,%ebp
f0104180:	53                   	push   %ebx
f0104181:	83 ec 04             	sub    $0x4,%esp
f0104184:	89 c3                	mov    %eax,%ebx
	if (tf->tf_trapno == T_PGFLT) {
f0104186:	8b 40 28             	mov    0x28(%eax),%eax
f0104189:	83 f8 0e             	cmp    $0xe,%eax
f010418c:	74 49                	je     f01041d7 <trap_dispatch+0x5a>
	if (tf->tf_trapno == T_BRKPT) {
f010418e:	83 f8 03             	cmp    $0x3,%eax
f0104191:	74 52                	je     f01041e5 <trap_dispatch+0x68>
	if (tf->tf_trapno == T_SYSCALL) {
f0104193:	83 f8 30             	cmp    $0x30,%eax
f0104196:	74 5b                	je     f01041f3 <trap_dispatch+0x76>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104198:	83 f8 27             	cmp    $0x27,%eax
f010419b:	74 77                	je     f0104214 <trap_dispatch+0x97>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f010419d:	83 f8 20             	cmp    $0x20,%eax
f01041a0:	0f 84 88 00 00 00    	je     f010422e <trap_dispatch+0xb1>
	print_trapframe(tf);
f01041a6:	83 ec 0c             	sub    $0xc,%esp
f01041a9:	53                   	push   %ebx
f01041aa:	e8 10 fd ff ff       	call   f0103ebf <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01041af:	83 c4 10             	add    $0x10,%esp
f01041b2:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f01041b7:	74 7f                	je     f0104238 <trap_dispatch+0xbb>
		env_destroy(curenv);
f01041b9:	e8 82 1c 00 00       	call   f0105e40 <cpunum>
f01041be:	83 ec 0c             	sub    $0xc,%esp
f01041c1:	6b c0 74             	imul   $0x74,%eax,%eax
f01041c4:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f01041ca:	e8 47 f4 ff ff       	call   f0103616 <env_destroy>
		return;
f01041cf:	83 c4 10             	add    $0x10,%esp
}
f01041d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01041d5:	c9                   	leave  
f01041d6:	c3                   	ret    
		page_fault_handler(tf);
f01041d7:	83 ec 0c             	sub    $0xc,%esp
f01041da:	53                   	push   %ebx
f01041db:	e8 50 fe ff ff       	call   f0104030 <page_fault_handler>
		return;
f01041e0:	83 c4 10             	add    $0x10,%esp
f01041e3:	eb ed                	jmp    f01041d2 <trap_dispatch+0x55>
		monitor(tf);
f01041e5:	83 ec 0c             	sub    $0xc,%esp
f01041e8:	53                   	push   %ebx
f01041e9:	e8 85 c9 ff ff       	call   f0100b73 <monitor>
		return;
f01041ee:	83 c4 10             	add    $0x10,%esp
f01041f1:	eb df                	jmp    f01041d2 <trap_dispatch+0x55>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
f01041f3:	83 ec 08             	sub    $0x8,%esp
f01041f6:	ff 73 04             	pushl  0x4(%ebx)
f01041f9:	ff 33                	pushl  (%ebx)
f01041fb:	ff 73 10             	pushl  0x10(%ebx)
f01041fe:	ff 73 18             	pushl  0x18(%ebx)
f0104201:	ff 73 14             	pushl  0x14(%ebx)
f0104204:	ff 73 1c             	pushl  0x1c(%ebx)
f0104207:	e8 0d 09 00 00       	call   f0104b19 <syscall>
f010420c:	89 43 1c             	mov    %eax,0x1c(%ebx)
		return;
f010420f:	83 c4 20             	add    $0x20,%esp
f0104212:	eb be                	jmp    f01041d2 <trap_dispatch+0x55>
		cprintf("Spurious interrupt on irq 7\n");
f0104214:	83 ec 0c             	sub    $0xc,%esp
f0104217:	68 3b 7a 10 f0       	push   $0xf0107a3b
f010421c:	e8 9b f7 ff ff       	call   f01039bc <cprintf>
		print_trapframe(tf);
f0104221:	89 1c 24             	mov    %ebx,(%esp)
f0104224:	e8 96 fc ff ff       	call   f0103ebf <print_trapframe>
		return;
f0104229:	83 c4 10             	add    $0x10,%esp
f010422c:	eb a4                	jmp    f01041d2 <trap_dispatch+0x55>
		lapic_eoi();
f010422e:	e8 5c 1d 00 00       	call   f0105f8f <lapic_eoi>
		sched_yield();
f0104233:	e8 e1 02 00 00       	call   f0104519 <sched_yield>
		panic("unhandled trap in kernel");
f0104238:	83 ec 04             	sub    $0x4,%esp
f010423b:	68 58 7a 10 f0       	push   $0xf0107a58
f0104240:	68 0d 01 00 00       	push   $0x10d
f0104245:	68 2f 7a 10 f0       	push   $0xf0107a2f
f010424a:	e8 1b be ff ff       	call   f010006a <_panic>

f010424f <trap>:
{
f010424f:	f3 0f 1e fb          	endbr32 
f0104253:	55                   	push   %ebp
f0104254:	89 e5                	mov    %esp,%ebp
f0104256:	57                   	push   %edi
f0104257:	56                   	push   %esi
f0104258:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f010425b:	fc                   	cld    
	if (panicstr)
f010425c:	83 3d 80 2e 22 f0 00 	cmpl   $0x0,0xf0222e80
f0104263:	74 01                	je     f0104266 <trap+0x17>
		asm volatile("hlt");
f0104265:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED) {
f0104266:	e8 d5 1b 00 00       	call   f0105e40 <cpunum>
f010426b:	6b c0 74             	imul   $0x74,%eax,%eax
f010426e:	05 24 30 22 f0       	add    $0xf0223024,%eax
f0104273:	ba 01 00 00 00       	mov    $0x1,%edx
f0104278:	e8 66 f7 ff ff       	call   f01039e3 <xchg>
f010427d:	83 f8 02             	cmp    $0x2,%eax
f0104280:	74 52                	je     f01042d4 <trap+0x85>
	assert(!(read_eflags() & FL_IF));
f0104282:	e8 59 f7 ff ff       	call   f01039e0 <read_eflags>
f0104287:	f6 c4 02             	test   $0x2,%ah
f010428a:	75 4f                	jne    f01042db <trap+0x8c>
	if ((tf->tf_cs & 3) == 3) {
f010428c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104290:	83 e0 03             	and    $0x3,%eax
f0104293:	66 83 f8 03          	cmp    $0x3,%ax
f0104297:	74 5b                	je     f01042f4 <trap+0xa5>
	last_tf = tf;
f0104299:	89 35 60 1a 22 f0    	mov    %esi,0xf0221a60
	trap_dispatch(tf);
f010429f:	89 f0                	mov    %esi,%eax
f01042a1:	e8 d7 fe ff ff       	call   f010417d <trap_dispatch>
	if (curenv && curenv->env_status == ENV_RUNNING)
f01042a6:	e8 95 1b 00 00       	call   f0105e40 <cpunum>
f01042ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01042ae:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f01042b5:	74 18                	je     f01042cf <trap+0x80>
f01042b7:	e8 84 1b 00 00       	call   f0105e40 <cpunum>
f01042bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01042bf:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01042c5:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01042c9:	0f 84 bf 00 00 00    	je     f010438e <trap+0x13f>
		sched_yield();
f01042cf:	e8 45 02 00 00       	call   f0104519 <sched_yield>
		lock_kernel();
f01042d4:	e8 40 f7 ff ff       	call   f0103a19 <lock_kernel>
f01042d9:	eb a7                	jmp    f0104282 <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f01042db:	68 71 7a 10 f0       	push   $0xf0107a71
f01042e0:	68 97 74 10 f0       	push   $0xf0107497
f01042e5:	68 28 01 00 00       	push   $0x128
f01042ea:	68 2f 7a 10 f0       	push   $0xf0107a2f
f01042ef:	e8 76 bd ff ff       	call   f010006a <_panic>
		lock_kernel();
f01042f4:	e8 20 f7 ff ff       	call   f0103a19 <lock_kernel>
		assert(curenv);
f01042f9:	e8 42 1b 00 00       	call   f0105e40 <cpunum>
f01042fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0104301:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f0104308:	74 3e                	je     f0104348 <trap+0xf9>
		if (curenv->env_status == ENV_DYING) {
f010430a:	e8 31 1b 00 00       	call   f0105e40 <cpunum>
f010430f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104312:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104318:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010431c:	74 43                	je     f0104361 <trap+0x112>
		curenv->env_tf = *tf;
f010431e:	e8 1d 1b 00 00       	call   f0105e40 <cpunum>
f0104323:	6b c0 74             	imul   $0x74,%eax,%eax
f0104326:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010432c:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104331:	89 c7                	mov    %eax,%edi
f0104333:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104335:	e8 06 1b 00 00       	call   f0105e40 <cpunum>
f010433a:	6b c0 74             	imul   $0x74,%eax,%eax
f010433d:	8b b0 28 30 22 f0    	mov    -0xfddcfd8(%eax),%esi
f0104343:	e9 51 ff ff ff       	jmp    f0104299 <trap+0x4a>
		assert(curenv);
f0104348:	68 8a 7a 10 f0       	push   $0xf0107a8a
f010434d:	68 97 74 10 f0       	push   $0xf0107497
f0104352:	68 30 01 00 00       	push   $0x130
f0104357:	68 2f 7a 10 f0       	push   $0xf0107a2f
f010435c:	e8 09 bd ff ff       	call   f010006a <_panic>
			env_free(curenv);
f0104361:	e8 da 1a 00 00       	call   f0105e40 <cpunum>
f0104366:	83 ec 0c             	sub    $0xc,%esp
f0104369:	6b c0 74             	imul   $0x74,%eax,%eax
f010436c:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f0104372:	e8 46 f1 ff ff       	call   f01034bd <env_free>
			curenv = NULL;
f0104377:	e8 c4 1a 00 00       	call   f0105e40 <cpunum>
f010437c:	6b c0 74             	imul   $0x74,%eax,%eax
f010437f:	c7 80 28 30 22 f0 00 	movl   $0x0,-0xfddcfd8(%eax)
f0104386:	00 00 00 
			sched_yield();
f0104389:	e8 8b 01 00 00       	call   f0104519 <sched_yield>
		env_run(curenv);
f010438e:	e8 ad 1a 00 00       	call   f0105e40 <cpunum>
f0104393:	83 ec 0c             	sub    $0xc,%esp
f0104396:	6b c0 74             	imul   $0x74,%eax,%eax
f0104399:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f010439f:	e8 19 f3 ff ff       	call   f01036bd <env_run>

f01043a4 <thn_divide>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(thn_divide, T_DIVIDE)
f01043a4:	6a 00                	push   $0x0
f01043a6:	6a 00                	push   $0x0
f01043a8:	eb 64                	jmp    f010440e <_alltraps>

f01043aa <thn_debug>:
TRAPHANDLER_NOEC(thn_debug, T_DEBUG)
f01043aa:	6a 00                	push   $0x0
f01043ac:	6a 01                	push   $0x1
f01043ae:	eb 5e                	jmp    f010440e <_alltraps>

f01043b0 <thn_nmi>:
TRAPHANDLER_NOEC(thn_nmi, T_NMI)
f01043b0:	6a 00                	push   $0x0
f01043b2:	6a 02                	push   $0x2
f01043b4:	eb 58                	jmp    f010440e <_alltraps>

f01043b6 <thn_brkpt>:
TRAPHANDLER_NOEC(thn_brkpt, T_BRKPT)
f01043b6:	6a 00                	push   $0x0
f01043b8:	6a 03                	push   $0x3
f01043ba:	eb 52                	jmp    f010440e <_alltraps>

f01043bc <thn_oflow>:
TRAPHANDLER_NOEC(thn_oflow, T_OFLOW)
f01043bc:	6a 00                	push   $0x0
f01043be:	6a 04                	push   $0x4
f01043c0:	eb 4c                	jmp    f010440e <_alltraps>

f01043c2 <thn_bound>:
TRAPHANDLER_NOEC(thn_bound, T_BOUND)
f01043c2:	6a 00                	push   $0x0
f01043c4:	6a 05                	push   $0x5
f01043c6:	eb 46                	jmp    f010440e <_alltraps>

f01043c8 <thn_illop>:
TRAPHANDLER_NOEC(thn_illop, T_ILLOP)
f01043c8:	6a 00                	push   $0x0
f01043ca:	6a 06                	push   $0x6
f01043cc:	eb 40                	jmp    f010440e <_alltraps>

f01043ce <thn_device>:
TRAPHANDLER_NOEC(thn_device, T_DEVICE)
f01043ce:	6a 00                	push   $0x0
f01043d0:	6a 07                	push   $0x7
f01043d2:	eb 3a                	jmp    f010440e <_alltraps>

f01043d4 <thn_fperr>:
TRAPHANDLER_NOEC(thn_fperr, T_FPERR)
f01043d4:	6a 00                	push   $0x0
f01043d6:	6a 10                	push   $0x10
f01043d8:	eb 34                	jmp    f010440e <_alltraps>

f01043da <thn_mchk>:
TRAPHANDLER_NOEC(thn_mchk, T_MCHK)
f01043da:	6a 00                	push   $0x0
f01043dc:	6a 12                	push   $0x12
f01043de:	eb 2e                	jmp    f010440e <_alltraps>

f01043e0 <thn_simderr>:
TRAPHANDLER_NOEC(thn_simderr, T_SIMDERR)
f01043e0:	6a 00                	push   $0x0
f01043e2:	6a 13                	push   $0x13
f01043e4:	eb 28                	jmp    f010440e <_alltraps>

f01043e6 <thn_syscall>:
TRAPHANDLER_NOEC(thn_syscall, T_SYSCALL)
f01043e6:	6a 00                	push   $0x0
f01043e8:	6a 30                	push   $0x30
f01043ea:	eb 22                	jmp    f010440e <_alltraps>

f01043ec <thn_irq_timer>:
TRAPHANDLER_NOEC(thn_irq_timer, IRQ_OFFSET + IRQ_TIMER)
f01043ec:	6a 00                	push   $0x0
f01043ee:	6a 20                	push   $0x20
f01043f0:	eb 1c                	jmp    f010440e <_alltraps>

f01043f2 <th_dblflt>:
TRAPHANDLER(th_dblflt, T_DBLFLT)
f01043f2:	6a 08                	push   $0x8
f01043f4:	eb 18                	jmp    f010440e <_alltraps>

f01043f6 <th_tss>:
TRAPHANDLER(th_tss, T_TSS)
f01043f6:	6a 0a                	push   $0xa
f01043f8:	eb 14                	jmp    f010440e <_alltraps>

f01043fa <th_segnp>:
TRAPHANDLER(th_segnp, T_SEGNP)
f01043fa:	6a 0b                	push   $0xb
f01043fc:	eb 10                	jmp    f010440e <_alltraps>

f01043fe <th_stack>:
TRAPHANDLER(th_stack, T_STACK)
f01043fe:	6a 0c                	push   $0xc
f0104400:	eb 0c                	jmp    f010440e <_alltraps>

f0104402 <th_gpflt>:
TRAPHANDLER(th_gpflt, T_GPFLT)
f0104402:	6a 0d                	push   $0xd
f0104404:	eb 08                	jmp    f010440e <_alltraps>

f0104406 <th_pgflt>:
TRAPHANDLER(th_pgflt, T_PGFLT)
f0104406:	6a 0e                	push   $0xe
f0104408:	eb 04                	jmp    f010440e <_alltraps>

f010440a <th_align>:
TRAPHANDLER(th_align, T_ALIGN)
f010440a:	6a 11                	push   $0x11
f010440c:	eb 00                	jmp    f010440e <_alltraps>

f010440e <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
f010440e:	1e                   	push   %ds
	pushl %es
f010440f:	06                   	push   %es
	pushal
f0104410:	60                   	pusha  
	movw $GD_KD, %ax
f0104411:	66 b8 10 00          	mov    $0x10,%ax
	movw %ax, %ds
f0104415:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f0104417:	8e c0                	mov    %eax,%es
	pushl %esp
f0104419:	54                   	push   %esp
	call trap
f010441a:	e8 30 fe ff ff       	call   f010424f <trap>

f010441f <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010441f:	0f 22 d8             	mov    %eax,%cr3
}
f0104422:	c3                   	ret    

f0104423 <xchg>:
{
f0104423:	89 c1                	mov    %eax,%ecx
f0104425:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f0104427:	f0 87 01             	lock xchg %eax,(%ecx)
}
f010442a:	c3                   	ret    

f010442b <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f010442b:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0104431:	76 07                	jbe    f010443a <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0104433:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0104439:	c3                   	ret    
{
f010443a:	55                   	push   %ebp
f010443b:	89 e5                	mov    %esp,%ebp
f010443d:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104440:	51                   	push   %ecx
f0104441:	68 50 65 10 f0       	push   $0xf0106550
f0104446:	52                   	push   %edx
f0104447:	50                   	push   %eax
f0104448:	e8 1d bc ff ff       	call   f010006a <_panic>

f010444d <unlock_kernel>:
{
f010444d:	55                   	push   %ebp
f010444e:	89 e5                	mov    %esp,%ebp
f0104450:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f0104453:	68 c0 23 12 f0       	push   $0xf01223c0
f0104458:	e8 4e 1d 00 00       	call   f01061ab <spin_unlock>
	asm volatile("pause");
f010445d:	f3 90                	pause  
}
f010445f:	83 c4 10             	add    $0x10,%esp
f0104462:	c9                   	leave  
f0104463:	c3                   	ret    

f0104464 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104464:	f3 0f 1e fb          	endbr32 
f0104468:	55                   	push   %ebp
f0104469:	89 e5                	mov    %esp,%ebp
f010446b:	83 ec 08             	sub    $0x8,%esp
f010446e:	a1 44 12 22 f0       	mov    0xf0221244,%eax
f0104473:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104476:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f010447b:	8b 02                	mov    (%edx),%eax
f010447d:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104480:	83 f8 02             	cmp    $0x2,%eax
f0104483:	76 2d                	jbe    f01044b2 <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f0104485:	83 c1 01             	add    $0x1,%ecx
f0104488:	83 c2 7c             	add    $0x7c,%edx
f010448b:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104491:	75 e8                	jne    f010447b <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104493:	83 ec 0c             	sub    $0xc,%esp
f0104496:	68 70 7c 10 f0       	push   $0xf0107c70
f010449b:	e8 1c f5 ff ff       	call   f01039bc <cprintf>
f01044a0:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01044a3:	83 ec 0c             	sub    $0xc,%esp
f01044a6:	6a 00                	push   $0x0
f01044a8:	e8 c6 c6 ff ff       	call   f0100b73 <monitor>
f01044ad:	83 c4 10             	add    $0x10,%esp
f01044b0:	eb f1                	jmp    f01044a3 <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01044b2:	e8 89 19 00 00       	call   f0105e40 <cpunum>
f01044b7:	6b c0 74             	imul   $0x74,%eax,%eax
f01044ba:	c7 80 28 30 22 f0 00 	movl   $0x0,-0xfddcfd8(%eax)
f01044c1:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01044c4:	8b 0d 8c 2e 22 f0    	mov    0xf0222e8c,%ecx
f01044ca:	ba 4d 00 00 00       	mov    $0x4d,%edx
f01044cf:	b8 99 7c 10 f0       	mov    $0xf0107c99,%eax
f01044d4:	e8 52 ff ff ff       	call   f010442b <_paddr>
f01044d9:	e8 41 ff ff ff       	call   f010441f <lcr3>

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01044de:	e8 5d 19 00 00       	call   f0105e40 <cpunum>
f01044e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01044e6:	05 24 30 22 f0       	add    $0xf0223024,%eax
f01044eb:	ba 02 00 00 00       	mov    $0x2,%edx
f01044f0:	e8 2e ff ff ff       	call   f0104423 <xchg>

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();
f01044f5:	e8 53 ff ff ff       	call   f010444d <unlock_kernel>
	             "sti\n"
	             "1:\n"
	             "hlt\n"
	             "jmp 1b\n"
	             :
	             : "a"(thiscpu->cpu_ts.ts_esp0));
f01044fa:	e8 41 19 00 00       	call   f0105e40 <cpunum>
f01044ff:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile("movl $0, %%ebp\n"
f0104502:	8b 80 30 30 22 f0    	mov    -0xfddcfd0(%eax),%eax
f0104508:	bd 00 00 00 00       	mov    $0x0,%ebp
f010450d:	89 c4                	mov    %eax,%esp
f010450f:	6a 00                	push   $0x0
f0104511:	6a 00                	push   $0x0
f0104513:	fb                   	sti    
f0104514:	f4                   	hlt    
f0104515:	eb fd                	jmp    f0104514 <sched_halt+0xb0>
}
f0104517:	c9                   	leave  
f0104518:	c3                   	ret    

f0104519 <sched_yield>:
{
f0104519:	f3 0f 1e fb          	endbr32 
f010451d:	55                   	push   %ebp
f010451e:	89 e5                	mov    %esp,%ebp
f0104520:	53                   	push   %ebx
f0104521:	83 ec 04             	sub    $0x4,%esp
	if (curenv != NULL) {
f0104524:	e8 17 19 00 00       	call   f0105e40 <cpunum>
f0104529:	6b c0 74             	imul   $0x74,%eax,%eax
	size_t curenv_idx = 0;
f010452c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (curenv != NULL) {
f0104531:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f0104538:	74 17                	je     f0104551 <sched_yield+0x38>
		curenv_idx = ENVX(curenv->env_id);
f010453a:	e8 01 19 00 00       	call   f0105e40 <cpunum>
f010453f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104542:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104548:	8b 50 48             	mov    0x48(%eax),%edx
f010454b:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
		idle = envs + ((curenv_idx + i) % NENV);
f0104551:	8b 0d 44 12 22 f0    	mov    0xf0221244,%ecx
f0104557:	8d 9a 00 04 00 00    	lea    0x400(%edx),%ebx
f010455d:	89 d0                	mov    %edx,%eax
f010455f:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104564:	6b c0 7c             	imul   $0x7c,%eax,%eax
f0104567:	01 c8                	add    %ecx,%eax
		if (idle->env_status == ENV_RUNNABLE) {
f0104569:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010456d:	74 36                	je     f01045a5 <sched_yield+0x8c>
f010456f:	83 c2 01             	add    $0x1,%edx
	for (size_t i = 0; i < NENV; i++) {
f0104572:	39 da                	cmp    %ebx,%edx
f0104574:	75 e7                	jne    f010455d <sched_yield+0x44>
	if (curenv != NULL && curenv->env_status == ENV_RUNNING) {
f0104576:	e8 c5 18 00 00       	call   f0105e40 <cpunum>
f010457b:	6b c0 74             	imul   $0x74,%eax,%eax
f010457e:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f0104585:	74 14                	je     f010459b <sched_yield+0x82>
f0104587:	e8 b4 18 00 00       	call   f0105e40 <cpunum>
f010458c:	6b c0 74             	imul   $0x74,%eax,%eax
f010458f:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104595:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104599:	74 13                	je     f01045ae <sched_yield+0x95>
	sched_halt();
f010459b:	e8 c4 fe ff ff       	call   f0104464 <sched_halt>
}
f01045a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01045a3:	c9                   	leave  
f01045a4:	c3                   	ret    
			env_run(idle);
f01045a5:	83 ec 0c             	sub    $0xc,%esp
f01045a8:	50                   	push   %eax
f01045a9:	e8 0f f1 ff ff       	call   f01036bd <env_run>
		env_run(curenv);
f01045ae:	e8 8d 18 00 00       	call   f0105e40 <cpunum>
f01045b3:	83 ec 0c             	sub    $0xc,%esp
f01045b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01045b9:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f01045bf:	e8 f9 f0 ff ff       	call   f01036bd <env_run>

f01045c4 <sys_getenvid>:
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f01045c4:	55                   	push   %ebp
f01045c5:	89 e5                	mov    %esp,%ebp
f01045c7:	83 ec 08             	sub    $0x8,%esp
	return curenv->env_id;
f01045ca:	e8 71 18 00 00       	call   f0105e40 <cpunum>
f01045cf:	6b c0 74             	imul   $0x74,%eax,%eax
f01045d2:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01045d8:	8b 40 48             	mov    0x48(%eax),%eax
}
f01045db:	c9                   	leave  
f01045dc:	c3                   	ret    

f01045dd <sys_cputs>:
{
f01045dd:	55                   	push   %ebp
f01045de:	89 e5                	mov    %esp,%ebp
f01045e0:	56                   	push   %esi
f01045e1:	53                   	push   %ebx
f01045e2:	89 c6                	mov    %eax,%esi
f01045e4:	89 d3                	mov    %edx,%ebx
	user_mem_assert(curenv, s, len, PTE_U);
f01045e6:	e8 55 18 00 00       	call   f0105e40 <cpunum>
f01045eb:	6a 04                	push   $0x4
f01045ed:	53                   	push   %ebx
f01045ee:	56                   	push   %esi
f01045ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01045f2:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f01045f8:	e8 1a e9 ff ff       	call   f0102f17 <user_mem_assert>
	cprintf("%.*s", len, s);
f01045fd:	83 c4 0c             	add    $0xc,%esp
f0104600:	56                   	push   %esi
f0104601:	53                   	push   %ebx
f0104602:	68 a6 7c 10 f0       	push   $0xf0107ca6
f0104607:	e8 b0 f3 ff ff       	call   f01039bc <cprintf>
}
f010460c:	83 c4 10             	add    $0x10,%esp
f010460f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104612:	5b                   	pop    %ebx
f0104613:	5e                   	pop    %esi
f0104614:	5d                   	pop    %ebp
f0104615:	c3                   	ret    

f0104616 <sys_cgetc>:
{
f0104616:	55                   	push   %ebp
f0104617:	89 e5                	mov    %esp,%ebp
f0104619:	83 ec 08             	sub    $0x8,%esp
	return cons_getc();
f010461c:	e8 a3 c2 ff ff       	call   f01008c4 <cons_getc>
}
f0104621:	c9                   	leave  
f0104622:	c3                   	ret    

f0104623 <sys_env_set_status>:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
f0104623:	55                   	push   %ebp
f0104624:	89 e5                	mov    %esp,%ebp
f0104626:	53                   	push   %ebx
f0104627:	83 ec 14             	sub    $0x14,%esp
f010462a:	89 d3                	mov    %edx,%ebx
	// envid's status.

	// LAB 4: Your code here.
	struct Env *env;

	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f010462c:	8d 52 fe             	lea    -0x2(%edx),%edx
f010462f:	f7 c2 fd ff ff ff    	test   $0xfffffffd,%edx
f0104635:	75 21                	jne    f0104658 <sys_env_set_status+0x35>
		return -E_INVAL;

	int error_code = envid2env(envid, &env, 1);
f0104637:	83 ec 04             	sub    $0x4,%esp
f010463a:	6a 01                	push   $0x1
f010463c:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010463f:	52                   	push   %edx
f0104640:	50                   	push   %eax
f0104641:	e8 f0 eb ff ff       	call   f0103236 <envid2env>
	if (error_code != 0) {
f0104646:	83 c4 10             	add    $0x10,%esp
f0104649:	85 c0                	test   %eax,%eax
f010464b:	75 06                	jne    f0104653 <sys_env_set_status+0x30>
		return error_code;
	}

	env->env_status = status;
f010464d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104650:	89 5a 54             	mov    %ebx,0x54(%edx)
	return 0;
}
f0104653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104656:	c9                   	leave  
f0104657:	c3                   	ret    
		return -E_INVAL;
f0104658:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010465d:	eb f4                	jmp    f0104653 <sys_env_set_status+0x30>

f010465f <sys_env_set_pgfault_upcall>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
f010465f:	55                   	push   %ebp
f0104660:	89 e5                	mov    %esp,%ebp
f0104662:	53                   	push   %ebx
f0104663:	83 ec 18             	sub    $0x18,%esp
f0104666:	89 d3                	mov    %edx,%ebx
	// LAB 4: Your code here.
	struct Env *env;

	if (envid2env(envid, &env, true) < 0) {
f0104668:	6a 01                	push   $0x1
f010466a:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010466d:	52                   	push   %edx
f010466e:	50                   	push   %eax
f010466f:	e8 c2 eb ff ff       	call   f0103236 <envid2env>
f0104674:	83 c4 10             	add    $0x10,%esp
f0104677:	85 c0                	test   %eax,%eax
f0104679:	78 10                	js     f010468b <sys_env_set_pgfault_upcall+0x2c>
		return -E_BAD_ENV;
	}

	env->env_pgfault_upcall = func;
f010467b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010467e:	89 58 64             	mov    %ebx,0x64(%eax)

	return 0;
f0104681:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104689:	c9                   	leave  
f010468a:	c3                   	ret    
		return -E_BAD_ENV;
f010468b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104690:	eb f4                	jmp    f0104686 <sys_env_set_pgfault_upcall+0x27>

f0104692 <sys_env_destroy>:
{
f0104692:	55                   	push   %ebp
f0104693:	89 e5                	mov    %esp,%ebp
f0104695:	53                   	push   %ebx
f0104696:	83 ec 18             	sub    $0x18,%esp
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104699:	6a 01                	push   $0x1
f010469b:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010469e:	52                   	push   %edx
f010469f:	50                   	push   %eax
f01046a0:	e8 91 eb ff ff       	call   f0103236 <envid2env>
f01046a5:	83 c4 10             	add    $0x10,%esp
f01046a8:	85 c0                	test   %eax,%eax
f01046aa:	78 4b                	js     f01046f7 <sys_env_destroy+0x65>
	if (e == curenv)
f01046ac:	e8 8f 17 00 00       	call   f0105e40 <cpunum>
f01046b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01046b4:	6b c0 74             	imul   $0x74,%eax,%eax
f01046b7:	39 90 28 30 22 f0    	cmp    %edx,-0xfddcfd8(%eax)
f01046bd:	74 3d                	je     f01046fc <sys_env_destroy+0x6a>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01046bf:	8b 5a 48             	mov    0x48(%edx),%ebx
f01046c2:	e8 79 17 00 00       	call   f0105e40 <cpunum>
f01046c7:	83 ec 04             	sub    $0x4,%esp
f01046ca:	53                   	push   %ebx
f01046cb:	6b c0 74             	imul   $0x74,%eax,%eax
f01046ce:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01046d4:	ff 70 48             	pushl  0x48(%eax)
f01046d7:	68 c6 7c 10 f0       	push   $0xf0107cc6
f01046dc:	e8 db f2 ff ff       	call   f01039bc <cprintf>
f01046e1:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01046e4:	83 ec 0c             	sub    $0xc,%esp
f01046e7:	ff 75 f4             	pushl  -0xc(%ebp)
f01046ea:	e8 27 ef ff ff       	call   f0103616 <env_destroy>
	return 0;
f01046ef:	83 c4 10             	add    $0x10,%esp
f01046f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01046f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01046fa:	c9                   	leave  
f01046fb:	c3                   	ret    
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01046fc:	e8 3f 17 00 00       	call   f0105e40 <cpunum>
f0104701:	83 ec 08             	sub    $0x8,%esp
f0104704:	6b c0 74             	imul   $0x74,%eax,%eax
f0104707:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010470d:	ff 70 48             	pushl  0x48(%eax)
f0104710:	68 ab 7c 10 f0       	push   $0xf0107cab
f0104715:	e8 a2 f2 ff ff       	call   f01039bc <cprintf>
f010471a:	83 c4 10             	add    $0x10,%esp
f010471d:	eb c5                	jmp    f01046e4 <sys_env_destroy+0x52>

f010471f <sys_yield>:
{
f010471f:	55                   	push   %ebp
f0104720:	89 e5                	mov    %esp,%ebp
f0104722:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f0104725:	e8 ef fd ff ff       	call   f0104519 <sched_yield>

f010472a <sys_ipc_recv>:
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
f010472a:	55                   	push   %ebp
f010472b:	89 e5                	mov    %esp,%ebp
f010472d:	53                   	push   %ebx
f010472e:	83 ec 04             	sub    $0x4,%esp
f0104731:	89 c3                	mov    %eax,%ebx
	// LAB 4: Your code here.
	if ((uint32_t) dstva < UTOP && PGOFF(dstva) != 0) {
f0104733:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f0104738:	77 12                	ja     f010474c <sys_ipc_recv+0x22>
f010473a:	a9 ff 0f 00 00       	test   $0xfff,%eax
f010473f:	74 0b                	je     f010474c <sys_ipc_recv+0x22>

	curenv->env_tf.tf_regs.reg_eax = 0;
	sys_yield();

	return 0;
}
f0104741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104746:	83 c4 04             	add    $0x4,%esp
f0104749:	5b                   	pop    %ebx
f010474a:	5d                   	pop    %ebp
f010474b:	c3                   	ret    
	curenv->env_ipc_recving = true;
f010474c:	e8 ef 16 00 00       	call   f0105e40 <cpunum>
f0104751:	6b c0 74             	imul   $0x74,%eax,%eax
f0104754:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010475a:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f010475e:	e8 dd 16 00 00       	call   f0105e40 <cpunum>
f0104763:	6b c0 74             	imul   $0x74,%eax,%eax
f0104766:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010476c:	89 58 6c             	mov    %ebx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f010476f:	e8 cc 16 00 00       	call   f0105e40 <cpunum>
f0104774:	6b c0 74             	imul   $0x74,%eax,%eax
f0104777:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f010477d:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f0104784:	e8 b7 16 00 00       	call   f0105e40 <cpunum>
f0104789:	6b c0 74             	imul   $0x74,%eax,%eax
f010478c:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104792:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	sys_yield();
f0104799:	e8 81 ff ff ff       	call   f010471f <sys_yield>

f010479e <sys_exofork>:
{
f010479e:	55                   	push   %ebp
f010479f:	89 e5                	mov    %esp,%ebp
f01047a1:	57                   	push   %edi
f01047a2:	56                   	push   %esi
f01047a3:	83 ec 10             	sub    $0x10,%esp
	int error_code = env_alloc(&env, curenv->env_id);
f01047a6:	e8 95 16 00 00       	call   f0105e40 <cpunum>
f01047ab:	83 ec 08             	sub    $0x8,%esp
f01047ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01047b1:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f01047b7:	ff 70 48             	pushl  0x48(%eax)
f01047ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01047bd:	50                   	push   %eax
f01047be:	e8 98 eb ff ff       	call   f010335b <env_alloc>
	if (error_code != 0) {
f01047c3:	83 c4 10             	add    $0x10,%esp
f01047c6:	85 c0                	test   %eax,%eax
f01047c8:	74 07                	je     f01047d1 <sys_exofork+0x33>
}
f01047ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01047cd:	5e                   	pop    %esi
f01047ce:	5f                   	pop    %edi
f01047cf:	5d                   	pop    %ebp
f01047d0:	c3                   	ret    
	env->env_status = ENV_NOT_RUNNABLE;
f01047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01047d4:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	env->env_tf = curenv->env_tf;
f01047db:	e8 60 16 00 00       	call   f0105e40 <cpunum>
f01047e0:	6b c0 74             	imul   $0x74,%eax,%eax
f01047e3:	8b b0 28 30 22 f0    	mov    -0xfddcfd8(%eax),%esi
f01047e9:	b9 11 00 00 00       	mov    $0x11,%ecx
f01047ee:	8b 7d f4             	mov    -0xc(%ebp),%edi
f01047f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	env->env_tf.tf_regs.reg_eax = 0;
f01047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01047f6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return env->env_id;
f01047fd:	8b 40 48             	mov    0x48(%eax),%eax
f0104800:	eb c8                	jmp    f01047ca <sys_exofork+0x2c>

f0104802 <sys_page_alloc>:
	if ((uint32_t) va >= UTOP || PGOFF(va) != 0)
f0104802:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0104808:	77 7a                	ja     f0104884 <sys_page_alloc+0x82>
{
f010480a:	55                   	push   %ebp
f010480b:	89 e5                	mov    %esp,%ebp
f010480d:	57                   	push   %edi
f010480e:	56                   	push   %esi
f010480f:	53                   	push   %ebx
f0104810:	83 ec 1c             	sub    $0x1c,%esp
f0104813:	89 d3                	mov    %edx,%ebx
f0104815:	89 ce                	mov    %ecx,%esi
	if ((uint32_t) va >= UTOP || PGOFF(va) != 0)
f0104817:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010481d:	75 6b                	jne    f010488a <sys_page_alloc+0x88>
	if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P) ||
f010481f:	89 ca                	mov    %ecx,%edx
f0104821:	81 e2 fd f1 ff ff    	and    $0xfffff1fd,%edx
f0104827:	83 fa 05             	cmp    $0x5,%edx
f010482a:	75 65                	jne    f0104891 <sys_page_alloc+0x8f>
	if ((error_code = envid2env(envid, &env, 1)) != 0)
f010482c:	83 ec 04             	sub    $0x4,%esp
f010482f:	6a 01                	push   $0x1
f0104831:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104834:	52                   	push   %edx
f0104835:	50                   	push   %eax
f0104836:	e8 fb e9 ff ff       	call   f0103236 <envid2env>
f010483b:	83 c4 10             	add    $0x10,%esp
f010483e:	85 c0                	test   %eax,%eax
f0104840:	74 08                	je     f010484a <sys_page_alloc+0x48>
}
f0104842:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104845:	5b                   	pop    %ebx
f0104846:	5e                   	pop    %esi
f0104847:	5f                   	pop    %edi
f0104848:	5d                   	pop    %ebp
f0104849:	c3                   	ret    
	if ((page_info = page_alloc(perm)) == NULL)
f010484a:	83 ec 0c             	sub    $0xc,%esp
f010484d:	56                   	push   %esi
f010484e:	e8 0f c9 ff ff       	call   f0101162 <page_alloc>
f0104853:	89 c7                	mov    %eax,%edi
f0104855:	83 c4 10             	add    $0x10,%esp
f0104858:	85 c0                	test   %eax,%eax
f010485a:	74 3c                	je     f0104898 <sys_page_alloc+0x96>
	if ((error_code = page_insert(env->env_pgdir, page_info, va, perm)) != 0) {
f010485c:	56                   	push   %esi
f010485d:	53                   	push   %ebx
f010485e:	50                   	push   %eax
f010485f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104862:	ff 70 60             	pushl  0x60(%eax)
f0104865:	e8 0a d3 ff ff       	call   f0101b74 <page_insert>
f010486a:	83 c4 10             	add    $0x10,%esp
f010486d:	85 c0                	test   %eax,%eax
f010486f:	74 d1                	je     f0104842 <sys_page_alloc+0x40>
		page_free(page_info);
f0104871:	83 ec 0c             	sub    $0xc,%esp
f0104874:	57                   	push   %edi
f0104875:	e8 33 c9 ff ff       	call   f01011ad <page_free>
		return -E_NO_MEM;
f010487a:	83 c4 10             	add    $0x10,%esp
f010487d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104882:	eb be                	jmp    f0104842 <sys_page_alloc+0x40>
		return -E_INVAL;
f0104884:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
f0104889:	c3                   	ret    
		return -E_INVAL;
f010488a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010488f:	eb b1                	jmp    f0104842 <sys_page_alloc+0x40>
		return -E_INVAL;
f0104891:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104896:	eb aa                	jmp    f0104842 <sys_page_alloc+0x40>
		return -E_NO_MEM;
f0104898:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010489d:	eb a3                	jmp    f0104842 <sys_page_alloc+0x40>

f010489f <sys_page_map>:
{
f010489f:	55                   	push   %ebp
f01048a0:	89 e5                	mov    %esp,%ebp
f01048a2:	57                   	push   %edi
f01048a3:	56                   	push   %esi
f01048a4:	53                   	push   %ebx
f01048a5:	83 ec 2c             	sub    $0x2c,%esp
f01048a8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f01048ab:	8b 7d 08             	mov    0x8(%ebp),%edi
f01048ae:	8b 75 0c             	mov    0xc(%ebp),%esi
	if ((uint32_t) srcva >= UTOP || PGOFF(srcva) != 0)
f01048b1:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f01048b7:	0f 87 b5 00 00 00    	ja     f0104972 <sys_page_map+0xd3>
f01048bd:	89 d3                	mov    %edx,%ebx
f01048bf:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01048c5:	0f 85 ae 00 00 00    	jne    f0104979 <sys_page_map+0xda>
	if ((uint32_t) dstva >= UTOP || PGOFF(dstva) != 0)
f01048cb:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f01048d1:	0f 87 a9 00 00 00    	ja     f0104980 <sys_page_map+0xe1>
f01048d7:	89 fa                	mov    %edi,%edx
f01048d9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01048df:	89 d1                	mov    %edx,%ecx
	if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01048e1:	89 f2                	mov    %esi,%edx
f01048e3:	83 e2 05             	and    $0x5,%edx
f01048e6:	83 fa 05             	cmp    $0x5,%edx
f01048e9:	0f 85 98 00 00 00    	jne    f0104987 <sys_page_map+0xe8>
	if ((perm & ~(PTE_SYSCALL)) != 0)
f01048ef:	89 f2                	mov    %esi,%edx
f01048f1:	81 e2 f8 f1 ff ff    	and    $0xfffff1f8,%edx
f01048f7:	09 ca                	or     %ecx,%edx
f01048f9:	0f 85 8f 00 00 00    	jne    f010498e <sys_page_map+0xef>
	if ((error_code = envid2env(srcenvid, &source_env, 1)) != 0)
f01048ff:	83 ec 04             	sub    $0x4,%esp
f0104902:	6a 01                	push   $0x1
f0104904:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104907:	52                   	push   %edx
f0104908:	50                   	push   %eax
f0104909:	e8 28 e9 ff ff       	call   f0103236 <envid2env>
f010490e:	83 c4 10             	add    $0x10,%esp
f0104911:	85 c0                	test   %eax,%eax
f0104913:	74 08                	je     f010491d <sys_page_map+0x7e>
}
f0104915:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104918:	5b                   	pop    %ebx
f0104919:	5e                   	pop    %esi
f010491a:	5f                   	pop    %edi
f010491b:	5d                   	pop    %ebp
f010491c:	c3                   	ret    
	if ((error_code = envid2env(dstenvid, &dest_env, 1)) != 0)
f010491d:	83 ec 04             	sub    $0x4,%esp
f0104920:	6a 01                	push   $0x1
f0104922:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104925:	50                   	push   %eax
f0104926:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104929:	e8 08 e9 ff ff       	call   f0103236 <envid2env>
f010492e:	83 c4 10             	add    $0x10,%esp
f0104931:	85 c0                	test   %eax,%eax
f0104933:	75 e0                	jne    f0104915 <sys_page_map+0x76>
	if ((page_info = page_lookup(source_env->env_pgdir, srcva, &pte)) == NULL)
f0104935:	83 ec 04             	sub    $0x4,%esp
f0104938:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010493b:	50                   	push   %eax
f010493c:	53                   	push   %ebx
f010493d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104940:	ff 70 60             	pushl  0x60(%eax)
f0104943:	e8 5c d1 ff ff       	call   f0101aa4 <page_lookup>
f0104948:	83 c4 10             	add    $0x10,%esp
f010494b:	85 c0                	test   %eax,%eax
f010494d:	74 46                	je     f0104995 <sys_page_map+0xf6>
	if ((*pte & PTE_W) == 0 && (perm & PTE_W) == PTE_W)
f010494f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104952:	f6 02 02             	testb  $0x2,(%edx)
f0104955:	75 08                	jne    f010495f <sys_page_map+0xc0>
f0104957:	f7 c6 02 00 00 00    	test   $0x2,%esi
f010495d:	75 40                	jne    f010499f <sys_page_map+0x100>
	             page_insert(dest_env->env_pgdir, page_info, dstva, perm)) != 0)
f010495f:	56                   	push   %esi
f0104960:	57                   	push   %edi
f0104961:	50                   	push   %eax
f0104962:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104965:	ff 70 60             	pushl  0x60(%eax)
f0104968:	e8 07 d2 ff ff       	call   f0101b74 <page_insert>
f010496d:	83 c4 10             	add    $0x10,%esp
f0104970:	eb a3                	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f0104972:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104977:	eb 9c                	jmp    f0104915 <sys_page_map+0x76>
f0104979:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010497e:	eb 95                	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f0104980:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104985:	eb 8e                	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f0104987:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010498c:	eb 87                	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f010498e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104993:	eb 80                	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f0104995:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010499a:	e9 76 ff ff ff       	jmp    f0104915 <sys_page_map+0x76>
		return -E_INVAL;
f010499f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01049a4:	e9 6c ff ff ff       	jmp    f0104915 <sys_page_map+0x76>

f01049a9 <sys_ipc_try_send>:
{
f01049a9:	55                   	push   %ebp
f01049aa:	89 e5                	mov    %esp,%ebp
f01049ac:	57                   	push   %edi
f01049ad:	56                   	push   %esi
f01049ae:	53                   	push   %ebx
f01049af:	83 ec 20             	sub    $0x20,%esp
f01049b2:	89 d7                	mov    %edx,%edi
f01049b4:	89 ce                	mov    %ecx,%esi
	if ((r = envid2env(envid, &e, 0)) != 0)
f01049b6:	6a 00                	push   $0x0
f01049b8:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01049bb:	52                   	push   %edx
f01049bc:	50                   	push   %eax
f01049bd:	e8 74 e8 ff ff       	call   f0103236 <envid2env>
f01049c2:	89 c3                	mov    %eax,%ebx
f01049c4:	83 c4 10             	add    $0x10,%esp
f01049c7:	85 c0                	test   %eax,%eax
f01049c9:	0f 85 bc 00 00 00    	jne    f0104a8b <sys_ipc_try_send+0xe2>
	if (e->env_ipc_recving == 0)
f01049cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049d2:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01049d6:	0f 84 b9 00 00 00    	je     f0104a95 <sys_ipc_try_send+0xec>
	if ((uint32_t) srcva < UTOP) {
f01049dc:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f01049e2:	77 78                	ja     f0104a5c <sys_ipc_try_send+0xb3>
		if (PGOFF(srcva) != 0)
f01049e4:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f01049ea:	0f 85 ac 00 00 00    	jne    f0104a9c <sys_ipc_try_send+0xf3>
		if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P) ||
f01049f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01049f3:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f01049f8:	83 f8 05             	cmp    $0x5,%eax
f01049fb:	0f 85 a2 00 00 00    	jne    f0104aa3 <sys_ipc_try_send+0xfa>
		if ((pp = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
f0104a01:	e8 3a 14 00 00       	call   f0105e40 <cpunum>
f0104a06:	83 ec 04             	sub    $0x4,%esp
f0104a09:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104a0c:	52                   	push   %edx
f0104a0d:	56                   	push   %esi
f0104a0e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a11:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104a17:	ff 70 60             	pushl  0x60(%eax)
f0104a1a:	e8 85 d0 ff ff       	call   f0101aa4 <page_lookup>
f0104a1f:	83 c4 10             	add    $0x10,%esp
f0104a22:	85 c0                	test   %eax,%eax
f0104a24:	0f 84 80 00 00 00    	je     f0104aaa <sys_ipc_try_send+0x101>
		if ((*pte & PTE_W) == 0 && (perm & PTE_W) == PTE_W)
f0104a2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104a2d:	f6 02 02             	testb  $0x2,(%edx)
f0104a30:	75 06                	jne    f0104a38 <sys_ipc_try_send+0x8f>
f0104a32:	f6 45 08 02          	testb  $0x2,0x8(%ebp)
f0104a36:	75 79                	jne    f0104ab1 <sys_ipc_try_send+0x108>
		if ((r = page_insert(e->env_pgdir, pp, e->env_ipc_dstva, perm)) != 0)
f0104a38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104a3b:	ff 75 08             	pushl  0x8(%ebp)
f0104a3e:	ff 72 6c             	pushl  0x6c(%edx)
f0104a41:	50                   	push   %eax
f0104a42:	ff 72 60             	pushl  0x60(%edx)
f0104a45:	e8 2a d1 ff ff       	call   f0101b74 <page_insert>
f0104a4a:	83 c4 10             	add    $0x10,%esp
f0104a4d:	85 c0                	test   %eax,%eax
f0104a4f:	75 67                	jne    f0104ab8 <sys_ipc_try_send+0x10f>
		e->env_ipc_perm = perm;
f0104a51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a54:	8b 75 08             	mov    0x8(%ebp),%esi
f0104a57:	89 70 78             	mov    %esi,0x78(%eax)
f0104a5a:	eb 07                	jmp    f0104a63 <sys_ipc_try_send+0xba>
		e->env_ipc_perm = 0;
f0104a5c:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	e->env_ipc_recving = 0;
f0104a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a66:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	e->env_ipc_from = curenv->env_id;
f0104a6a:	e8 d1 13 00 00       	call   f0105e40 <cpunum>
f0104a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104a72:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a75:	8b 80 28 30 22 f0    	mov    -0xfddcfd8(%eax),%eax
f0104a7b:	8b 40 48             	mov    0x48(%eax),%eax
f0104a7e:	89 42 74             	mov    %eax,0x74(%edx)
	e->env_ipc_value = value;
f0104a81:	89 7a 70             	mov    %edi,0x70(%edx)
	e->env_status = ENV_RUNNABLE;
f0104a84:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
}
f0104a8b:	89 d8                	mov    %ebx,%eax
f0104a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104a90:	5b                   	pop    %ebx
f0104a91:	5e                   	pop    %esi
f0104a92:	5f                   	pop    %edi
f0104a93:	5d                   	pop    %ebp
f0104a94:	c3                   	ret    
		return -E_IPC_NOT_RECV;
f0104a95:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104a9a:	eb ef                	jmp    f0104a8b <sys_ipc_try_send+0xe2>
			return -E_INVAL;
f0104a9c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aa1:	eb e8                	jmp    f0104a8b <sys_ipc_try_send+0xe2>
			return -E_INVAL;
f0104aa3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aa8:	eb e1                	jmp    f0104a8b <sys_ipc_try_send+0xe2>
			return -E_INVAL;
f0104aaa:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aaf:	eb da                	jmp    f0104a8b <sys_ipc_try_send+0xe2>
			return -E_INVAL;
f0104ab1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ab6:	eb d3                	jmp    f0104a8b <sys_ipc_try_send+0xe2>
			return r;
f0104ab8:	89 c3                	mov    %eax,%ebx
f0104aba:	eb cf                	jmp    f0104a8b <sys_ipc_try_send+0xe2>

f0104abc <sys_page_unmap>:
{
f0104abc:	55                   	push   %ebp
f0104abd:	89 e5                	mov    %esp,%ebp
f0104abf:	56                   	push   %esi
f0104ac0:	53                   	push   %ebx
f0104ac1:	83 ec 10             	sub    $0x10,%esp
	if ((uint32_t) va >= UTOP || PGOFF(va) != 0) {
f0104ac4:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0104aca:	77 3f                	ja     f0104b0b <sys_page_unmap+0x4f>
f0104acc:	89 d3                	mov    %edx,%ebx
f0104ace:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0104ad4:	75 3c                	jne    f0104b12 <sys_page_unmap+0x56>
	if ((error_code = envid2env(envid, &env, 1)) != 0) {
f0104ad6:	83 ec 04             	sub    $0x4,%esp
f0104ad9:	6a 01                	push   $0x1
f0104adb:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104ade:	52                   	push   %edx
f0104adf:	50                   	push   %eax
f0104ae0:	e8 51 e7 ff ff       	call   f0103236 <envid2env>
f0104ae5:	89 c6                	mov    %eax,%esi
f0104ae7:	83 c4 10             	add    $0x10,%esp
f0104aea:	85 c0                	test   %eax,%eax
f0104aec:	74 09                	je     f0104af7 <sys_page_unmap+0x3b>
}
f0104aee:	89 f0                	mov    %esi,%eax
f0104af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104af3:	5b                   	pop    %ebx
f0104af4:	5e                   	pop    %esi
f0104af5:	5d                   	pop    %ebp
f0104af6:	c3                   	ret    
	page_remove(env->env_pgdir, va);
f0104af7:	83 ec 08             	sub    $0x8,%esp
f0104afa:	53                   	push   %ebx
f0104afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104afe:	ff 70 60             	pushl  0x60(%eax)
f0104b01:	e8 12 d0 ff ff       	call   f0101b18 <page_remove>
	return 0;
f0104b06:	83 c4 10             	add    $0x10,%esp
f0104b09:	eb e3                	jmp    f0104aee <sys_page_unmap+0x32>
		return -E_INVAL;
f0104b0b:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0104b10:	eb dc                	jmp    f0104aee <sys_page_unmap+0x32>
f0104b12:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0104b17:	eb d5                	jmp    f0104aee <sys_page_unmap+0x32>

f0104b19 <syscall>:

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104b19:	f3 0f 1e fb          	endbr32 
f0104b1d:	55                   	push   %ebp
f0104b1e:	89 e5                	mov    %esp,%ebp
f0104b20:	83 ec 08             	sub    $0x8,%esp
f0104b23:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b26:	83 f8 0d             	cmp    $0xd,%eax
f0104b29:	0f 87 e6 00 00 00    	ja     f0104c15 <syscall+0xfc>
f0104b2f:	3e ff 24 85 f0 7c 10 	notrack jmp *-0xfef8310(,%eax,4)
f0104b36:	f0 
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {
	case SYS_cputs:
		sys_cputs((char *) a1, (size_t) a2);
f0104b37:	8b 55 10             	mov    0x10(%ebp),%edx
f0104b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104b3d:	e8 9b fa ff ff       	call   f01045dd <sys_cputs>

	case SYS_cgetc:
		return sys_cgetc();
f0104b42:	e8 cf fa ff ff       	call   f0104616 <sys_cgetc>
		return sys_env_set_pgfault_upcall(a1, (void *) a2);

	default:
		return -E_INVAL;
	}
}
f0104b47:	c9                   	leave  
f0104b48:	c3                   	ret    
		assert(curenv);
f0104b49:	e8 f2 12 00 00       	call   f0105e40 <cpunum>
f0104b4e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b51:	83 b8 28 30 22 f0 00 	cmpl   $0x0,-0xfddcfd8(%eax)
f0104b58:	74 07                	je     f0104b61 <syscall+0x48>
		return sys_getenvid();
f0104b5a:	e8 65 fa ff ff       	call   f01045c4 <sys_getenvid>
f0104b5f:	eb e6                	jmp    f0104b47 <syscall+0x2e>
		assert(curenv);
f0104b61:	68 8a 7a 10 f0       	push   $0xf0107a8a
f0104b66:	68 97 74 10 f0       	push   $0xf0107497
f0104b6b:	68 b5 01 00 00       	push   $0x1b5
f0104b70:	68 de 7c 10 f0       	push   $0xf0107cde
f0104b75:	e8 f0 b4 ff ff       	call   f010006a <_panic>
		return sys_env_destroy(a1);
f0104b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104b7d:	e8 10 fb ff ff       	call   f0104692 <sys_env_destroy>
f0104b82:	eb c3                	jmp    f0104b47 <syscall+0x2e>
		sys_yield();
f0104b84:	e8 96 fb ff ff       	call   f010471f <sys_yield>
		return sys_exofork();
f0104b89:	e8 10 fc ff ff       	call   f010479e <sys_exofork>
f0104b8e:	eb b7                	jmp    f0104b47 <syscall+0x2e>
		return sys_env_set_status(a1, a2);
f0104b90:	8b 55 10             	mov    0x10(%ebp),%edx
f0104b93:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104b96:	e8 88 fa ff ff       	call   f0104623 <sys_env_set_status>
f0104b9b:	eb aa                	jmp    f0104b47 <syscall+0x2e>
		return sys_page_alloc(a1, (void *) a2, a3);
f0104b9d:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104ba0:	8b 55 10             	mov    0x10(%ebp),%edx
f0104ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ba6:	e8 57 fc ff ff       	call   f0104802 <sys_page_alloc>
f0104bab:	eb 9a                	jmp    f0104b47 <syscall+0x2e>
		return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104bad:	83 ec 08             	sub    $0x8,%esp
f0104bb0:	ff 75 1c             	pushl  0x1c(%ebp)
f0104bb3:	ff 75 18             	pushl  0x18(%ebp)
f0104bb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104bb9:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bbf:	e8 db fc ff ff       	call   f010489f <sys_page_map>
f0104bc4:	83 c4 10             	add    $0x10,%esp
f0104bc7:	e9 7b ff ff ff       	jmp    f0104b47 <syscall+0x2e>
		return sys_page_unmap(a1, (void *) a2);
f0104bcc:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bd2:	e8 e5 fe ff ff       	call   f0104abc <sys_page_unmap>
f0104bd7:	e9 6b ff ff ff       	jmp    f0104b47 <syscall+0x2e>
		return sys_ipc_recv((void *) a1);
f0104bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bdf:	e8 46 fb ff ff       	call   f010472a <sys_ipc_recv>
f0104be4:	e9 5e ff ff ff       	jmp    f0104b47 <syscall+0x2e>
		return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f0104be9:	83 ec 0c             	sub    $0xc,%esp
f0104bec:	ff 75 18             	pushl  0x18(%ebp)
f0104bef:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104bf2:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bf8:	e8 ac fd ff ff       	call   f01049a9 <sys_ipc_try_send>
f0104bfd:	83 c4 10             	add    $0x10,%esp
f0104c00:	e9 42 ff ff ff       	jmp    f0104b47 <syscall+0x2e>
		return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104c05:	8b 55 10             	mov    0x10(%ebp),%edx
f0104c08:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104c0b:	e8 4f fa ff ff       	call   f010465f <sys_env_set_pgfault_upcall>
f0104c10:	e9 32 ff ff ff       	jmp    f0104b47 <syscall+0x2e>
{
f0104c15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c1a:	e9 28 ff ff ff       	jmp    f0104b47 <syscall+0x2e>

f0104c1f <stab_binsearch>:
stab_binsearch(const struct Stab *stabs,
               int *region_left,
               int *region_right,
               int type,
               uintptr_t addr)
{
f0104c1f:	55                   	push   %ebp
f0104c20:	89 e5                	mov    %esp,%ebp
f0104c22:	57                   	push   %edi
f0104c23:	56                   	push   %esi
f0104c24:	53                   	push   %ebx
f0104c25:	83 ec 14             	sub    $0x14,%esp
f0104c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104c2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104c2e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104c31:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104c34:	8b 1a                	mov    (%edx),%ebx
f0104c36:	8b 01                	mov    (%ecx),%eax
f0104c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c3b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104c42:	eb 23                	jmp    f0104c67 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {  // no match in [l, m]
			l = true_m + 1;
f0104c44:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104c47:	eb 1e                	jmp    f0104c67 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104c49:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c4c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c4f:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104c53:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c56:	73 46                	jae    f0104c9e <stab_binsearch+0x7f>
			*region_left = m;
f0104c58:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104c5b:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104c5d:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104c60:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104c67:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104c6a:	7f 5f                	jg     f0104ccb <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104c6f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104c72:	89 d0                	mov    %edx,%eax
f0104c74:	c1 e8 1f             	shr    $0x1f,%eax
f0104c77:	01 d0                	add    %edx,%eax
f0104c79:	89 c7                	mov    %eax,%edi
f0104c7b:	d1 ff                	sar    %edi
f0104c7d:	83 e0 fe             	and    $0xfffffffe,%eax
f0104c80:	01 f8                	add    %edi,%eax
f0104c82:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c85:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104c89:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104c8b:	39 c3                	cmp    %eax,%ebx
f0104c8d:	7f b5                	jg     f0104c44 <stab_binsearch+0x25>
f0104c8f:	0f b6 0a             	movzbl (%edx),%ecx
f0104c92:	83 ea 0c             	sub    $0xc,%edx
f0104c95:	39 f1                	cmp    %esi,%ecx
f0104c97:	74 b0                	je     f0104c49 <stab_binsearch+0x2a>
			m--;
f0104c99:	83 e8 01             	sub    $0x1,%eax
f0104c9c:	eb ed                	jmp    f0104c8b <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104c9e:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104ca1:	76 14                	jbe    f0104cb7 <stab_binsearch+0x98>
			*region_right = m - 1;
f0104ca3:	83 e8 01             	sub    $0x1,%eax
f0104ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104ca9:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104cac:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104cae:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cb5:	eb b0                	jmp    f0104c67 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104cba:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104cbc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104cc0:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104cc2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cc9:	eb 9c                	jmp    f0104c67 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104ccb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104ccf:	75 15                	jne    f0104ce6 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cd4:	8b 00                	mov    (%eax),%eax
f0104cd6:	83 e8 01             	sub    $0x1,%eax
f0104cd9:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104cdc:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104cde:	83 c4 14             	add    $0x14,%esp
f0104ce1:	5b                   	pop    %ebx
f0104ce2:	5e                   	pop    %esi
f0104ce3:	5f                   	pop    %edi
f0104ce4:	5d                   	pop    %ebp
f0104ce5:	c3                   	ret    
		for (l = *region_right;
f0104ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ce9:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104ceb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104cee:	8b 0f                	mov    (%edi),%ecx
f0104cf0:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104cf3:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104cf6:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104cfa:	eb 03                	jmp    f0104cff <stab_binsearch+0xe0>
		     l--)
f0104cfc:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104cff:	39 c1                	cmp    %eax,%ecx
f0104d01:	7d 0a                	jge    f0104d0d <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104d03:	0f b6 1a             	movzbl (%edx),%ebx
f0104d06:	83 ea 0c             	sub    $0xc,%edx
f0104d09:	39 f3                	cmp    %esi,%ebx
f0104d0b:	75 ef                	jne    f0104cfc <stab_binsearch+0xdd>
		*region_left = l;
f0104d0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d10:	89 07                	mov    %eax,(%edi)
}
f0104d12:	eb ca                	jmp    f0104cde <stab_binsearch+0xbf>

f0104d14 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104d14:	f3 0f 1e fb          	endbr32 
f0104d18:	55                   	push   %ebp
f0104d19:	89 e5                	mov    %esp,%ebp
f0104d1b:	57                   	push   %edi
f0104d1c:	56                   	push   %esi
f0104d1d:	53                   	push   %ebx
f0104d1e:	83 ec 4c             	sub    $0x4c,%esp
f0104d21:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104d24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104d27:	c7 03 28 7d 10 f0    	movl   $0xf0107d28,(%ebx)
	info->eip_line = 0;
f0104d2d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104d34:	c7 43 08 28 7d 10 f0 	movl   $0xf0107d28,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104d3b:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104d42:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104d45:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104d4c:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104d52:	0f 86 21 01 00 00    	jbe    f0104e79 <debuginfo_eip+0x165>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104d58:	c7 45 b8 e9 8c 11 f0 	movl   $0xf0118ce9,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104d5f:	c7 45 b4 19 4c 11 f0 	movl   $0xf0114c19,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104d66:	be 18 4c 11 f0       	mov    $0xf0114c18,%esi
		stabs = __STAB_BEGIN__;
f0104d6b:	c7 45 bc d0 82 10 f0 	movl   $0xf01082d0,-0x44(%ebp)
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104d72:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104d75:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104d78:	0f 83 62 02 00 00    	jae    f0104fe0 <debuginfo_eip+0x2cc>
f0104d7e:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104d82:	0f 85 5f 02 00 00    	jne    f0104fe7 <debuginfo_eip+0x2d3>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104d88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104d8f:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0104d92:	c1 fe 02             	sar    $0x2,%esi
f0104d95:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104d9b:	83 e8 01             	sub    $0x1,%eax
f0104d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104da1:	83 ec 08             	sub    $0x8,%esp
f0104da4:	57                   	push   %edi
f0104da5:	6a 64                	push   $0x64
f0104da7:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104daa:	89 d1                	mov    %edx,%ecx
f0104dac:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104daf:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104db2:	89 f0                	mov    %esi,%eax
f0104db4:	e8 66 fe ff ff       	call   f0104c1f <stab_binsearch>
	if (lfile == 0)
f0104db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104dbc:	83 c4 10             	add    $0x10,%esp
f0104dbf:	85 c0                	test   %eax,%eax
f0104dc1:	0f 84 27 02 00 00    	je     f0104fee <debuginfo_eip+0x2da>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104dcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104dd0:	83 ec 08             	sub    $0x8,%esp
f0104dd3:	57                   	push   %edi
f0104dd4:	6a 24                	push   $0x24
f0104dd6:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104dd9:	89 d1                	mov    %edx,%ecx
f0104ddb:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104dde:	89 f0                	mov    %esi,%eax
f0104de0:	e8 3a fe ff ff       	call   f0104c1f <stab_binsearch>

	if (lfun <= rfun) {
f0104de5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104de8:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104deb:	83 c4 10             	add    $0x10,%esp
f0104dee:	39 d0                	cmp    %edx,%eax
f0104df0:	0f 8f 32 01 00 00    	jg     f0104f28 <debuginfo_eip+0x214>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104df6:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104df9:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104dfc:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104dff:	8b 36                	mov    (%esi),%esi
f0104e01:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104e04:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0104e07:	39 ce                	cmp    %ecx,%esi
f0104e09:	73 06                	jae    f0104e11 <debuginfo_eip+0xfd>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104e0b:	03 75 b4             	add    -0x4c(%ebp),%esi
f0104e0e:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104e11:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104e14:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104e17:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104e1a:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104e1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104e1f:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104e22:	83 ec 08             	sub    $0x8,%esp
f0104e25:	6a 3a                	push   $0x3a
f0104e27:	ff 73 08             	pushl  0x8(%ebx)
f0104e2a:	e8 63 09 00 00       	call   f0105792 <strfind>
f0104e2f:	2b 43 08             	sub    0x8(%ebx),%eax
f0104e32:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104e35:	83 c4 08             	add    $0x8,%esp
f0104e38:	57                   	push   %edi
f0104e39:	6a 44                	push   $0x44
f0104e3b:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104e3e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104e41:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104e44:	89 f8                	mov    %edi,%eax
f0104e46:	e8 d4 fd ff ff       	call   f0104c1f <stab_binsearch>
	if (lline <= rline) {
f0104e4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104e4e:	83 c4 10             	add    $0x10,%esp
f0104e51:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104e54:	7f 0b                	jg     f0104e61 <debuginfo_eip+0x14d>
		info->eip_line = stabs[lline].n_desc;
f0104e56:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104e59:	0f b7 44 87 06       	movzwl 0x6(%edi,%eax,4),%eax
f0104e5e:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile && stabs[lline].n_type != N_SOL &&
f0104e61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e64:	89 d0                	mov    %edx,%eax
f0104e66:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104e69:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104e6c:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0104e70:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104e74:	e9 cd 00 00 00       	jmp    f0104f46 <debuginfo_eip+0x232>
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), 0))
f0104e79:	e8 c2 0f 00 00       	call   f0105e40 <cpunum>
f0104e7e:	6a 00                	push   $0x0
f0104e80:	6a 10                	push   $0x10
f0104e82:	68 00 00 20 00       	push   $0x200000
f0104e87:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e8a:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f0104e90:	e8 ee df ff ff       	call   f0102e83 <user_mem_check>
f0104e95:	83 c4 10             	add    $0x10,%esp
f0104e98:	85 c0                	test   %eax,%eax
f0104e9a:	0f 85 32 01 00 00    	jne    f0104fd2 <debuginfo_eip+0x2be>
		stabs = usd->stabs;
f0104ea0:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0104ea6:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0104ea9:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0104eaf:	a1 08 00 20 00       	mov    0x200008,%eax
f0104eb4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0104eb7:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104ebd:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104ec0:	e8 7b 0f 00 00       	call   f0105e40 <cpunum>
f0104ec5:	89 c2                	mov    %eax,%edx
f0104ec7:	6a 00                	push   $0x0
f0104ec9:	89 f0                	mov    %esi,%eax
f0104ecb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0104ece:	29 c8                	sub    %ecx,%eax
f0104ed0:	c1 f8 02             	sar    $0x2,%eax
f0104ed3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104ed9:	50                   	push   %eax
f0104eda:	51                   	push   %ecx
f0104edb:	6b d2 74             	imul   $0x74,%edx,%edx
f0104ede:	ff b2 28 30 22 f0    	pushl  -0xfddcfd8(%edx)
f0104ee4:	e8 9a df ff ff       	call   f0102e83 <user_mem_check>
f0104ee9:	83 c4 10             	add    $0x10,%esp
f0104eec:	85 c0                	test   %eax,%eax
f0104eee:	0f 85 e5 00 00 00    	jne    f0104fd9 <debuginfo_eip+0x2c5>
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
f0104ef4:	e8 47 0f 00 00       	call   f0105e40 <cpunum>
f0104ef9:	6a 00                	push   $0x0
f0104efb:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0104efe:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0104f01:	29 ca                	sub    %ecx,%edx
f0104f03:	52                   	push   %edx
f0104f04:	51                   	push   %ecx
f0104f05:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f08:	ff b0 28 30 22 f0    	pushl  -0xfddcfd8(%eax)
f0104f0e:	e8 70 df ff ff       	call   f0102e83 <user_mem_check>
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104f13:	83 c4 10             	add    $0x10,%esp
f0104f16:	85 c0                	test   %eax,%eax
f0104f18:	0f 84 54 fe ff ff    	je     f0104d72 <debuginfo_eip+0x5e>
			return -1;
f0104f1e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f23:	e9 d2 00 00 00       	jmp    f0104ffa <debuginfo_eip+0x2e6>
		info->eip_fn_addr = addr;
f0104f28:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0104f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f34:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104f37:	e9 e6 fe ff ff       	jmp    f0104e22 <debuginfo_eip+0x10e>
f0104f3c:	83 e8 01             	sub    $0x1,%eax
f0104f3f:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile && stabs[lline].n_type != N_SOL &&
f0104f42:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104f46:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0104f49:	39 c7                	cmp    %eax,%edi
f0104f4b:	7f 45                	jg     f0104f92 <debuginfo_eip+0x27e>
f0104f4d:	0f b6 0a             	movzbl (%edx),%ecx
f0104f50:	80 f9 84             	cmp    $0x84,%cl
f0104f53:	74 19                	je     f0104f6e <debuginfo_eip+0x25a>
f0104f55:	80 f9 64             	cmp    $0x64,%cl
f0104f58:	75 e2                	jne    f0104f3c <debuginfo_eip+0x228>
	       (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104f5a:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104f5e:	74 dc                	je     f0104f3c <debuginfo_eip+0x228>
f0104f60:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104f64:	74 11                	je     f0104f77 <debuginfo_eip+0x263>
f0104f66:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104f69:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104f6c:	eb 09                	jmp    f0104f77 <debuginfo_eip+0x263>
f0104f6e:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104f72:	74 03                	je     f0104f77 <debuginfo_eip+0x263>
f0104f74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104f77:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104f7a:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104f7d:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104f80:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0104f83:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0104f86:	29 f8                	sub    %edi,%eax
f0104f88:	39 c2                	cmp    %eax,%edx
f0104f8a:	73 06                	jae    f0104f92 <debuginfo_eip+0x27e>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104f8c:	89 f8                	mov    %edi,%eax
f0104f8e:	01 d0                	add    %edx,%eax
f0104f90:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104f92:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104f95:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104f98:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f0104f9d:	39 f0                	cmp    %esi,%eax
f0104f9f:	7d 59                	jge    f0104ffa <debuginfo_eip+0x2e6>
		for (lline = lfun + 1;
f0104fa1:	8d 50 01             	lea    0x1(%eax),%edx
f0104fa4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104fa7:	89 d0                	mov    %edx,%eax
f0104fa9:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104fac:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104faf:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104fb3:	eb 04                	jmp    f0104fb9 <debuginfo_eip+0x2a5>
			info->eip_fn_narg++;
f0104fb5:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0104fb9:	39 c6                	cmp    %eax,%esi
f0104fbb:	7e 38                	jle    f0104ff5 <debuginfo_eip+0x2e1>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104fbd:	0f b6 0a             	movzbl (%edx),%ecx
f0104fc0:	83 c0 01             	add    $0x1,%eax
f0104fc3:	83 c2 0c             	add    $0xc,%edx
f0104fc6:	80 f9 a0             	cmp    $0xa0,%cl
f0104fc9:	74 ea                	je     f0104fb5 <debuginfo_eip+0x2a1>
	return 0;
f0104fcb:	ba 00 00 00 00       	mov    $0x0,%edx
f0104fd0:	eb 28                	jmp    f0104ffa <debuginfo_eip+0x2e6>
			return -1;
f0104fd2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104fd7:	eb 21                	jmp    f0104ffa <debuginfo_eip+0x2e6>
			return -1;
f0104fd9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104fde:	eb 1a                	jmp    f0104ffa <debuginfo_eip+0x2e6>
		return -1;
f0104fe0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104fe5:	eb 13                	jmp    f0104ffa <debuginfo_eip+0x2e6>
f0104fe7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104fec:	eb 0c                	jmp    f0104ffa <debuginfo_eip+0x2e6>
		return -1;
f0104fee:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104ff3:	eb 05                	jmp    f0104ffa <debuginfo_eip+0x2e6>
	return 0;
f0104ff5:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0104ffa:	89 d0                	mov    %edx,%eax
f0104ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104fff:	5b                   	pop    %ebx
f0105000:	5e                   	pop    %esi
f0105001:	5f                   	pop    %edi
f0105002:	5d                   	pop    %ebp
f0105003:	c3                   	ret    

f0105004 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105004:	55                   	push   %ebp
f0105005:	89 e5                	mov    %esp,%ebp
f0105007:	57                   	push   %edi
f0105008:	56                   	push   %esi
f0105009:	53                   	push   %ebx
f010500a:	83 ec 1c             	sub    $0x1c,%esp
f010500d:	89 c7                	mov    %eax,%edi
f010500f:	89 d6                	mov    %edx,%esi
f0105011:	8b 45 08             	mov    0x8(%ebp),%eax
f0105014:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105017:	89 d1                	mov    %edx,%ecx
f0105019:	89 c2                	mov    %eax,%edx
f010501b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010501e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105021:	8b 45 10             	mov    0x10(%ebp),%eax
f0105024:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105027:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010502a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0105031:	39 c2                	cmp    %eax,%edx
f0105033:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0105036:	72 3e                	jb     f0105076 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105038:	83 ec 0c             	sub    $0xc,%esp
f010503b:	ff 75 18             	pushl  0x18(%ebp)
f010503e:	83 eb 01             	sub    $0x1,%ebx
f0105041:	53                   	push   %ebx
f0105042:	50                   	push   %eax
f0105043:	83 ec 08             	sub    $0x8,%esp
f0105046:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105049:	ff 75 e0             	pushl  -0x20(%ebp)
f010504c:	ff 75 dc             	pushl  -0x24(%ebp)
f010504f:	ff 75 d8             	pushl  -0x28(%ebp)
f0105052:	e8 39 12 00 00       	call   f0106290 <__udivdi3>
f0105057:	83 c4 18             	add    $0x18,%esp
f010505a:	52                   	push   %edx
f010505b:	50                   	push   %eax
f010505c:	89 f2                	mov    %esi,%edx
f010505e:	89 f8                	mov    %edi,%eax
f0105060:	e8 9f ff ff ff       	call   f0105004 <printnum>
f0105065:	83 c4 20             	add    $0x20,%esp
f0105068:	eb 13                	jmp    f010507d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f010506a:	83 ec 08             	sub    $0x8,%esp
f010506d:	56                   	push   %esi
f010506e:	ff 75 18             	pushl  0x18(%ebp)
f0105071:	ff d7                	call   *%edi
f0105073:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0105076:	83 eb 01             	sub    $0x1,%ebx
f0105079:	85 db                	test   %ebx,%ebx
f010507b:	7f ed                	jg     f010506a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010507d:	83 ec 08             	sub    $0x8,%esp
f0105080:	56                   	push   %esi
f0105081:	83 ec 04             	sub    $0x4,%esp
f0105084:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105087:	ff 75 e0             	pushl  -0x20(%ebp)
f010508a:	ff 75 dc             	pushl  -0x24(%ebp)
f010508d:	ff 75 d8             	pushl  -0x28(%ebp)
f0105090:	e8 0b 13 00 00       	call   f01063a0 <__umoddi3>
f0105095:	83 c4 14             	add    $0x14,%esp
f0105098:	0f be 80 32 7d 10 f0 	movsbl -0xfef82ce(%eax),%eax
f010509f:	50                   	push   %eax
f01050a0:	ff d7                	call   *%edi
}
f01050a2:	83 c4 10             	add    $0x10,%esp
f01050a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01050a8:	5b                   	pop    %ebx
f01050a9:	5e                   	pop    %esi
f01050aa:	5f                   	pop    %edi
f01050ab:	5d                   	pop    %ebp
f01050ac:	c3                   	ret    

f01050ad <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01050ad:	83 fa 01             	cmp    $0x1,%edx
f01050b0:	7f 13                	jg     f01050c5 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
f01050b2:	85 d2                	test   %edx,%edx
f01050b4:	74 1c                	je     f01050d2 <getuint+0x25>
		return va_arg(*ap, unsigned long);
f01050b6:	8b 10                	mov    (%eax),%edx
f01050b8:	8d 4a 04             	lea    0x4(%edx),%ecx
f01050bb:	89 08                	mov    %ecx,(%eax)
f01050bd:	8b 02                	mov    (%edx),%eax
f01050bf:	ba 00 00 00 00       	mov    $0x0,%edx
f01050c4:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
f01050c5:	8b 10                	mov    (%eax),%edx
f01050c7:	8d 4a 08             	lea    0x8(%edx),%ecx
f01050ca:	89 08                	mov    %ecx,(%eax)
f01050cc:	8b 02                	mov    (%edx),%eax
f01050ce:	8b 52 04             	mov    0x4(%edx),%edx
f01050d1:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
f01050d2:	8b 10                	mov    (%eax),%edx
f01050d4:	8d 4a 04             	lea    0x4(%edx),%ecx
f01050d7:	89 08                	mov    %ecx,(%eax)
f01050d9:	8b 02                	mov    (%edx),%eax
f01050db:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01050e0:	c3                   	ret    

f01050e1 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01050e1:	83 fa 01             	cmp    $0x1,%edx
f01050e4:	7f 0f                	jg     f01050f5 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
f01050e6:	85 d2                	test   %edx,%edx
f01050e8:	74 18                	je     f0105102 <getint+0x21>
		return va_arg(*ap, long);
f01050ea:	8b 10                	mov    (%eax),%edx
f01050ec:	8d 4a 04             	lea    0x4(%edx),%ecx
f01050ef:	89 08                	mov    %ecx,(%eax)
f01050f1:	8b 02                	mov    (%edx),%eax
f01050f3:	99                   	cltd   
f01050f4:	c3                   	ret    
		return va_arg(*ap, long long);
f01050f5:	8b 10                	mov    (%eax),%edx
f01050f7:	8d 4a 08             	lea    0x8(%edx),%ecx
f01050fa:	89 08                	mov    %ecx,(%eax)
f01050fc:	8b 02                	mov    (%edx),%eax
f01050fe:	8b 52 04             	mov    0x4(%edx),%edx
f0105101:	c3                   	ret    
	else
		return va_arg(*ap, int);
f0105102:	8b 10                	mov    (%eax),%edx
f0105104:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105107:	89 08                	mov    %ecx,(%eax)
f0105109:	8b 02                	mov    (%edx),%eax
f010510b:	99                   	cltd   
}
f010510c:	c3                   	ret    

f010510d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010510d:	f3 0f 1e fb          	endbr32 
f0105111:	55                   	push   %ebp
f0105112:	89 e5                	mov    %esp,%ebp
f0105114:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105117:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010511b:	8b 10                	mov    (%eax),%edx
f010511d:	3b 50 04             	cmp    0x4(%eax),%edx
f0105120:	73 0a                	jae    f010512c <sprintputch+0x1f>
		*b->buf++ = ch;
f0105122:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105125:	89 08                	mov    %ecx,(%eax)
f0105127:	8b 45 08             	mov    0x8(%ebp),%eax
f010512a:	88 02                	mov    %al,(%edx)
}
f010512c:	5d                   	pop    %ebp
f010512d:	c3                   	ret    

f010512e <printfmt>:
{
f010512e:	f3 0f 1e fb          	endbr32 
f0105132:	55                   	push   %ebp
f0105133:	89 e5                	mov    %esp,%ebp
f0105135:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105138:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010513b:	50                   	push   %eax
f010513c:	ff 75 10             	pushl  0x10(%ebp)
f010513f:	ff 75 0c             	pushl  0xc(%ebp)
f0105142:	ff 75 08             	pushl  0x8(%ebp)
f0105145:	e8 05 00 00 00       	call   f010514f <vprintfmt>
}
f010514a:	83 c4 10             	add    $0x10,%esp
f010514d:	c9                   	leave  
f010514e:	c3                   	ret    

f010514f <vprintfmt>:
{
f010514f:	f3 0f 1e fb          	endbr32 
f0105153:	55                   	push   %ebp
f0105154:	89 e5                	mov    %esp,%ebp
f0105156:	57                   	push   %edi
f0105157:	56                   	push   %esi
f0105158:	53                   	push   %ebx
f0105159:	83 ec 2c             	sub    $0x2c,%esp
f010515c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010515f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105162:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105165:	e9 86 02 00 00       	jmp    f01053f0 <vprintfmt+0x2a1>
		padc = ' ';
f010516a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f010516e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105175:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f010517c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105183:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105188:	8d 47 01             	lea    0x1(%edi),%eax
f010518b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010518e:	0f b6 17             	movzbl (%edi),%edx
f0105191:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105194:	3c 55                	cmp    $0x55,%al
f0105196:	0f 87 df 02 00 00    	ja     f010547b <vprintfmt+0x32c>
f010519c:	0f b6 c0             	movzbl %al,%eax
f010519f:	3e ff 24 85 80 7e 10 	notrack jmp *-0xfef8180(,%eax,4)
f01051a6:	f0 
f01051a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01051aa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01051ae:	eb d8                	jmp    f0105188 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01051b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01051b3:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01051b7:	eb cf                	jmp    f0105188 <vprintfmt+0x39>
f01051b9:	0f b6 d2             	movzbl %dl,%edx
f01051bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01051bf:	b8 00 00 00 00       	mov    $0x0,%eax
f01051c4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01051c7:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01051ca:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01051ce:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01051d1:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01051d4:	83 f9 09             	cmp    $0x9,%ecx
f01051d7:	77 52                	ja     f010522b <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
f01051d9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01051dc:	eb e9                	jmp    f01051c7 <vprintfmt+0x78>
			precision = va_arg(ap, int);
f01051de:	8b 45 14             	mov    0x14(%ebp),%eax
f01051e1:	8d 50 04             	lea    0x4(%eax),%edx
f01051e4:	89 55 14             	mov    %edx,0x14(%ebp)
f01051e7:	8b 00                	mov    (%eax),%eax
f01051e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01051ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01051ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01051f3:	79 93                	jns    f0105188 <vprintfmt+0x39>
				width = precision, precision = -1;
f01051f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01051f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01051fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105202:	eb 84                	jmp    f0105188 <vprintfmt+0x39>
f0105204:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105207:	85 c0                	test   %eax,%eax
f0105209:	ba 00 00 00 00       	mov    $0x0,%edx
f010520e:	0f 49 d0             	cmovns %eax,%edx
f0105211:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105214:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105217:	e9 6c ff ff ff       	jmp    f0105188 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f010521c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010521f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105226:	e9 5d ff ff ff       	jmp    f0105188 <vprintfmt+0x39>
f010522b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010522e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105231:	eb bc                	jmp    f01051ef <vprintfmt+0xa0>
			lflag++;
f0105233:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105236:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105239:	e9 4a ff ff ff       	jmp    f0105188 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f010523e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105241:	8d 50 04             	lea    0x4(%eax),%edx
f0105244:	89 55 14             	mov    %edx,0x14(%ebp)
f0105247:	83 ec 08             	sub    $0x8,%esp
f010524a:	56                   	push   %esi
f010524b:	ff 30                	pushl  (%eax)
f010524d:	ff d3                	call   *%ebx
			break;
f010524f:	83 c4 10             	add    $0x10,%esp
f0105252:	e9 96 01 00 00       	jmp    f01053ed <vprintfmt+0x29e>
			err = va_arg(ap, int);
f0105257:	8b 45 14             	mov    0x14(%ebp),%eax
f010525a:	8d 50 04             	lea    0x4(%eax),%edx
f010525d:	89 55 14             	mov    %edx,0x14(%ebp)
f0105260:	8b 00                	mov    (%eax),%eax
f0105262:	99                   	cltd   
f0105263:	31 d0                	xor    %edx,%eax
f0105265:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105267:	83 f8 0f             	cmp    $0xf,%eax
f010526a:	7f 20                	jg     f010528c <vprintfmt+0x13d>
f010526c:	8b 14 85 e0 7f 10 f0 	mov    -0xfef8020(,%eax,4),%edx
f0105273:	85 d2                	test   %edx,%edx
f0105275:	74 15                	je     f010528c <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
f0105277:	52                   	push   %edx
f0105278:	68 a9 74 10 f0       	push   $0xf01074a9
f010527d:	56                   	push   %esi
f010527e:	53                   	push   %ebx
f010527f:	e8 aa fe ff ff       	call   f010512e <printfmt>
f0105284:	83 c4 10             	add    $0x10,%esp
f0105287:	e9 61 01 00 00       	jmp    f01053ed <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
f010528c:	50                   	push   %eax
f010528d:	68 4a 7d 10 f0       	push   $0xf0107d4a
f0105292:	56                   	push   %esi
f0105293:	53                   	push   %ebx
f0105294:	e8 95 fe ff ff       	call   f010512e <printfmt>
f0105299:	83 c4 10             	add    $0x10,%esp
f010529c:	e9 4c 01 00 00       	jmp    f01053ed <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
f01052a1:	8b 45 14             	mov    0x14(%ebp),%eax
f01052a4:	8d 50 04             	lea    0x4(%eax),%edx
f01052a7:	89 55 14             	mov    %edx,0x14(%ebp)
f01052aa:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f01052ac:	85 c9                	test   %ecx,%ecx
f01052ae:	b8 43 7d 10 f0       	mov    $0xf0107d43,%eax
f01052b3:	0f 45 c1             	cmovne %ecx,%eax
f01052b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01052b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01052bd:	7e 06                	jle    f01052c5 <vprintfmt+0x176>
f01052bf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01052c3:	75 0d                	jne    f01052d2 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
f01052c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01052c8:	89 c7                	mov    %eax,%edi
f01052ca:	03 45 e0             	add    -0x20(%ebp),%eax
f01052cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01052d0:	eb 57                	jmp    f0105329 <vprintfmt+0x1da>
f01052d2:	83 ec 08             	sub    $0x8,%esp
f01052d5:	ff 75 d8             	pushl  -0x28(%ebp)
f01052d8:	ff 75 cc             	pushl  -0x34(%ebp)
f01052db:	e8 41 03 00 00       	call   f0105621 <strnlen>
f01052e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01052e3:	29 c2                	sub    %eax,%edx
f01052e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01052e8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01052eb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01052ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
f01052f2:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
f01052f4:	85 db                	test   %ebx,%ebx
f01052f6:	7e 10                	jle    f0105308 <vprintfmt+0x1b9>
					putch(padc, putdat);
f01052f8:	83 ec 08             	sub    $0x8,%esp
f01052fb:	56                   	push   %esi
f01052fc:	57                   	push   %edi
f01052fd:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105300:	83 eb 01             	sub    $0x1,%ebx
f0105303:	83 c4 10             	add    $0x10,%esp
f0105306:	eb ec                	jmp    f01052f4 <vprintfmt+0x1a5>
f0105308:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010530b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010530e:	85 d2                	test   %edx,%edx
f0105310:	b8 00 00 00 00       	mov    $0x0,%eax
f0105315:	0f 49 c2             	cmovns %edx,%eax
f0105318:	29 c2                	sub    %eax,%edx
f010531a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010531d:	eb a6                	jmp    f01052c5 <vprintfmt+0x176>
					putch(ch, putdat);
f010531f:	83 ec 08             	sub    $0x8,%esp
f0105322:	56                   	push   %esi
f0105323:	52                   	push   %edx
f0105324:	ff d3                	call   *%ebx
f0105326:	83 c4 10             	add    $0x10,%esp
f0105329:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010532c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010532e:	83 c7 01             	add    $0x1,%edi
f0105331:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105335:	0f be d0             	movsbl %al,%edx
f0105338:	85 d2                	test   %edx,%edx
f010533a:	74 42                	je     f010537e <vprintfmt+0x22f>
f010533c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105340:	78 06                	js     f0105348 <vprintfmt+0x1f9>
f0105342:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105346:	78 1e                	js     f0105366 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
f0105348:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010534c:	74 d1                	je     f010531f <vprintfmt+0x1d0>
f010534e:	0f be c0             	movsbl %al,%eax
f0105351:	83 e8 20             	sub    $0x20,%eax
f0105354:	83 f8 5e             	cmp    $0x5e,%eax
f0105357:	76 c6                	jbe    f010531f <vprintfmt+0x1d0>
					putch('?', putdat);
f0105359:	83 ec 08             	sub    $0x8,%esp
f010535c:	56                   	push   %esi
f010535d:	6a 3f                	push   $0x3f
f010535f:	ff d3                	call   *%ebx
f0105361:	83 c4 10             	add    $0x10,%esp
f0105364:	eb c3                	jmp    f0105329 <vprintfmt+0x1da>
f0105366:	89 cf                	mov    %ecx,%edi
f0105368:	eb 0e                	jmp    f0105378 <vprintfmt+0x229>
				putch(' ', putdat);
f010536a:	83 ec 08             	sub    $0x8,%esp
f010536d:	56                   	push   %esi
f010536e:	6a 20                	push   $0x20
f0105370:	ff d3                	call   *%ebx
			for (; width > 0; width--)
f0105372:	83 ef 01             	sub    $0x1,%edi
f0105375:	83 c4 10             	add    $0x10,%esp
f0105378:	85 ff                	test   %edi,%edi
f010537a:	7f ee                	jg     f010536a <vprintfmt+0x21b>
f010537c:	eb 6f                	jmp    f01053ed <vprintfmt+0x29e>
f010537e:	89 cf                	mov    %ecx,%edi
f0105380:	eb f6                	jmp    f0105378 <vprintfmt+0x229>
			num = getint(&ap, lflag);
f0105382:	89 ca                	mov    %ecx,%edx
f0105384:	8d 45 14             	lea    0x14(%ebp),%eax
f0105387:	e8 55 fd ff ff       	call   f01050e1 <getint>
f010538c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010538f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0105392:	85 d2                	test   %edx,%edx
f0105394:	78 0b                	js     f01053a1 <vprintfmt+0x252>
			num = getint(&ap, lflag);
f0105396:	89 d1                	mov    %edx,%ecx
f0105398:	89 c2                	mov    %eax,%edx
			base = 10;
f010539a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010539f:	eb 32                	jmp    f01053d3 <vprintfmt+0x284>
				putch('-', putdat);
f01053a1:	83 ec 08             	sub    $0x8,%esp
f01053a4:	56                   	push   %esi
f01053a5:	6a 2d                	push   $0x2d
f01053a7:	ff d3                	call   *%ebx
				num = -(long long) num;
f01053a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01053ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01053af:	f7 da                	neg    %edx
f01053b1:	83 d1 00             	adc    $0x0,%ecx
f01053b4:	f7 d9                	neg    %ecx
f01053b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01053b9:	b8 0a 00 00 00       	mov    $0xa,%eax
f01053be:	eb 13                	jmp    f01053d3 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
f01053c0:	89 ca                	mov    %ecx,%edx
f01053c2:	8d 45 14             	lea    0x14(%ebp),%eax
f01053c5:	e8 e3 fc ff ff       	call   f01050ad <getuint>
f01053ca:	89 d1                	mov    %edx,%ecx
f01053cc:	89 c2                	mov    %eax,%edx
			base = 10;
f01053ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
f01053d3:	83 ec 0c             	sub    $0xc,%esp
f01053d6:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01053da:	57                   	push   %edi
f01053db:	ff 75 e0             	pushl  -0x20(%ebp)
f01053de:	50                   	push   %eax
f01053df:	51                   	push   %ecx
f01053e0:	52                   	push   %edx
f01053e1:	89 f2                	mov    %esi,%edx
f01053e3:	89 d8                	mov    %ebx,%eax
f01053e5:	e8 1a fc ff ff       	call   f0105004 <printnum>
			break;
f01053ea:	83 c4 20             	add    $0x20,%esp
{
f01053ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01053f0:	83 c7 01             	add    $0x1,%edi
f01053f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01053f7:	83 f8 25             	cmp    $0x25,%eax
f01053fa:	0f 84 6a fd ff ff    	je     f010516a <vprintfmt+0x1b>
			if (ch == '\0')
f0105400:	85 c0                	test   %eax,%eax
f0105402:	0f 84 93 00 00 00    	je     f010549b <vprintfmt+0x34c>
			putch(ch, putdat);
f0105408:	83 ec 08             	sub    $0x8,%esp
f010540b:	56                   	push   %esi
f010540c:	50                   	push   %eax
f010540d:	ff d3                	call   *%ebx
f010540f:	83 c4 10             	add    $0x10,%esp
f0105412:	eb dc                	jmp    f01053f0 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
f0105414:	89 ca                	mov    %ecx,%edx
f0105416:	8d 45 14             	lea    0x14(%ebp),%eax
f0105419:	e8 8f fc ff ff       	call   f01050ad <getuint>
f010541e:	89 d1                	mov    %edx,%ecx
f0105420:	89 c2                	mov    %eax,%edx
			base = 8;
f0105422:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
f0105427:	eb aa                	jmp    f01053d3 <vprintfmt+0x284>
			putch('0', putdat);
f0105429:	83 ec 08             	sub    $0x8,%esp
f010542c:	56                   	push   %esi
f010542d:	6a 30                	push   $0x30
f010542f:	ff d3                	call   *%ebx
			putch('x', putdat);
f0105431:	83 c4 08             	add    $0x8,%esp
f0105434:	56                   	push   %esi
f0105435:	6a 78                	push   $0x78
f0105437:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
f0105439:	8b 45 14             	mov    0x14(%ebp),%eax
f010543c:	8d 50 04             	lea    0x4(%eax),%edx
f010543f:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
f0105442:	8b 10                	mov    (%eax),%edx
f0105444:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f0105449:	83 c4 10             	add    $0x10,%esp
			base = 16;
f010544c:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0105451:	eb 80                	jmp    f01053d3 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
f0105453:	89 ca                	mov    %ecx,%edx
f0105455:	8d 45 14             	lea    0x14(%ebp),%eax
f0105458:	e8 50 fc ff ff       	call   f01050ad <getuint>
f010545d:	89 d1                	mov    %edx,%ecx
f010545f:	89 c2                	mov    %eax,%edx
			base = 16;
f0105461:	b8 10 00 00 00       	mov    $0x10,%eax
f0105466:	e9 68 ff ff ff       	jmp    f01053d3 <vprintfmt+0x284>
			putch(ch, putdat);
f010546b:	83 ec 08             	sub    $0x8,%esp
f010546e:	56                   	push   %esi
f010546f:	6a 25                	push   $0x25
f0105471:	ff d3                	call   *%ebx
			break;
f0105473:	83 c4 10             	add    $0x10,%esp
f0105476:	e9 72 ff ff ff       	jmp    f01053ed <vprintfmt+0x29e>
			putch('%', putdat);
f010547b:	83 ec 08             	sub    $0x8,%esp
f010547e:	56                   	push   %esi
f010547f:	6a 25                	push   $0x25
f0105481:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105483:	83 c4 10             	add    $0x10,%esp
f0105486:	89 f8                	mov    %edi,%eax
f0105488:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010548c:	74 05                	je     f0105493 <vprintfmt+0x344>
f010548e:	83 e8 01             	sub    $0x1,%eax
f0105491:	eb f5                	jmp    f0105488 <vprintfmt+0x339>
f0105493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105496:	e9 52 ff ff ff       	jmp    f01053ed <vprintfmt+0x29e>
}
f010549b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010549e:	5b                   	pop    %ebx
f010549f:	5e                   	pop    %esi
f01054a0:	5f                   	pop    %edi
f01054a1:	5d                   	pop    %ebp
f01054a2:	c3                   	ret    

f01054a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01054a3:	f3 0f 1e fb          	endbr32 
f01054a7:	55                   	push   %ebp
f01054a8:	89 e5                	mov    %esp,%ebp
f01054aa:	83 ec 18             	sub    $0x18,%esp
f01054ad:	8b 45 08             	mov    0x8(%ebp),%eax
f01054b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01054b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01054b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01054ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01054bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01054c4:	85 c0                	test   %eax,%eax
f01054c6:	74 26                	je     f01054ee <vsnprintf+0x4b>
f01054c8:	85 d2                	test   %edx,%edx
f01054ca:	7e 22                	jle    f01054ee <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01054cc:	ff 75 14             	pushl  0x14(%ebp)
f01054cf:	ff 75 10             	pushl  0x10(%ebp)
f01054d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01054d5:	50                   	push   %eax
f01054d6:	68 0d 51 10 f0       	push   $0xf010510d
f01054db:	e8 6f fc ff ff       	call   f010514f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01054e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01054e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01054e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01054e9:	83 c4 10             	add    $0x10,%esp
}
f01054ec:	c9                   	leave  
f01054ed:	c3                   	ret    
		return -E_INVAL;
f01054ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01054f3:	eb f7                	jmp    f01054ec <vsnprintf+0x49>

f01054f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01054f5:	f3 0f 1e fb          	endbr32 
f01054f9:	55                   	push   %ebp
f01054fa:	89 e5                	mov    %esp,%ebp
f01054fc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01054ff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105502:	50                   	push   %eax
f0105503:	ff 75 10             	pushl  0x10(%ebp)
f0105506:	ff 75 0c             	pushl  0xc(%ebp)
f0105509:	ff 75 08             	pushl  0x8(%ebp)
f010550c:	e8 92 ff ff ff       	call   f01054a3 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105511:	c9                   	leave  
f0105512:	c3                   	ret    

f0105513 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105513:	f3 0f 1e fb          	endbr32 
f0105517:	55                   	push   %ebp
f0105518:	89 e5                	mov    %esp,%ebp
f010551a:	57                   	push   %edi
f010551b:	56                   	push   %esi
f010551c:	53                   	push   %ebx
f010551d:	83 ec 0c             	sub    $0xc,%esp
f0105520:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105523:	85 c0                	test   %eax,%eax
f0105525:	74 11                	je     f0105538 <readline+0x25>
		cprintf("%s", prompt);
f0105527:	83 ec 08             	sub    $0x8,%esp
f010552a:	50                   	push   %eax
f010552b:	68 a9 74 10 f0       	push   $0xf01074a9
f0105530:	e8 87 e4 ff ff       	call   f01039bc <cprintf>
f0105535:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105538:	83 ec 0c             	sub    $0xc,%esp
f010553b:	6a 00                	push   $0x0
f010553d:	e8 27 b4 ff ff       	call   f0100969 <iscons>
f0105542:	89 c7                	mov    %eax,%edi
f0105544:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105547:	be 00 00 00 00       	mov    $0x0,%esi
f010554c:	eb 57                	jmp    f01055a5 <readline+0x92>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010554e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0105553:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105556:	75 08                	jne    f0105560 <readline+0x4d>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105558:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010555b:	5b                   	pop    %ebx
f010555c:	5e                   	pop    %esi
f010555d:	5f                   	pop    %edi
f010555e:	5d                   	pop    %ebp
f010555f:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105560:	83 ec 08             	sub    $0x8,%esp
f0105563:	53                   	push   %ebx
f0105564:	68 3f 80 10 f0       	push   $0xf010803f
f0105569:	e8 4e e4 ff ff       	call   f01039bc <cprintf>
f010556e:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105571:	b8 00 00 00 00       	mov    $0x0,%eax
f0105576:	eb e0                	jmp    f0105558 <readline+0x45>
			if (echoing)
f0105578:	85 ff                	test   %edi,%edi
f010557a:	75 05                	jne    f0105581 <readline+0x6e>
			i--;
f010557c:	83 ee 01             	sub    $0x1,%esi
f010557f:	eb 24                	jmp    f01055a5 <readline+0x92>
				cputchar('\b');
f0105581:	83 ec 0c             	sub    $0xc,%esp
f0105584:	6a 08                	push   $0x8
f0105586:	e8 b5 b3 ff ff       	call   f0100940 <cputchar>
f010558b:	83 c4 10             	add    $0x10,%esp
f010558e:	eb ec                	jmp    f010557c <readline+0x69>
				cputchar(c);
f0105590:	83 ec 0c             	sub    $0xc,%esp
f0105593:	53                   	push   %ebx
f0105594:	e8 a7 b3 ff ff       	call   f0100940 <cputchar>
f0105599:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010559c:	88 9e 80 1a 22 f0    	mov    %bl,-0xfdde580(%esi)
f01055a2:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01055a5:	e8 aa b3 ff ff       	call   f0100954 <getchar>
f01055aa:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01055ac:	85 c0                	test   %eax,%eax
f01055ae:	78 9e                	js     f010554e <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01055b0:	83 f8 08             	cmp    $0x8,%eax
f01055b3:	0f 94 c2             	sete   %dl
f01055b6:	83 f8 7f             	cmp    $0x7f,%eax
f01055b9:	0f 94 c0             	sete   %al
f01055bc:	08 c2                	or     %al,%dl
f01055be:	74 04                	je     f01055c4 <readline+0xb1>
f01055c0:	85 f6                	test   %esi,%esi
f01055c2:	7f b4                	jg     f0105578 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01055c4:	83 fb 1f             	cmp    $0x1f,%ebx
f01055c7:	7e 0e                	jle    f01055d7 <readline+0xc4>
f01055c9:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01055cf:	7f 06                	jg     f01055d7 <readline+0xc4>
			if (echoing)
f01055d1:	85 ff                	test   %edi,%edi
f01055d3:	74 c7                	je     f010559c <readline+0x89>
f01055d5:	eb b9                	jmp    f0105590 <readline+0x7d>
		} else if (c == '\n' || c == '\r') {
f01055d7:	83 fb 0a             	cmp    $0xa,%ebx
f01055da:	74 05                	je     f01055e1 <readline+0xce>
f01055dc:	83 fb 0d             	cmp    $0xd,%ebx
f01055df:	75 c4                	jne    f01055a5 <readline+0x92>
			if (echoing)
f01055e1:	85 ff                	test   %edi,%edi
f01055e3:	75 11                	jne    f01055f6 <readline+0xe3>
			buf[i] = 0;
f01055e5:	c6 86 80 1a 22 f0 00 	movb   $0x0,-0xfdde580(%esi)
			return buf;
f01055ec:	b8 80 1a 22 f0       	mov    $0xf0221a80,%eax
f01055f1:	e9 62 ff ff ff       	jmp    f0105558 <readline+0x45>
				cputchar('\n');
f01055f6:	83 ec 0c             	sub    $0xc,%esp
f01055f9:	6a 0a                	push   $0xa
f01055fb:	e8 40 b3 ff ff       	call   f0100940 <cputchar>
f0105600:	83 c4 10             	add    $0x10,%esp
f0105603:	eb e0                	jmp    f01055e5 <readline+0xd2>

f0105605 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105605:	f3 0f 1e fb          	endbr32 
f0105609:	55                   	push   %ebp
f010560a:	89 e5                	mov    %esp,%ebp
f010560c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010560f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105614:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105618:	74 05                	je     f010561f <strlen+0x1a>
		n++;
f010561a:	83 c0 01             	add    $0x1,%eax
f010561d:	eb f5                	jmp    f0105614 <strlen+0xf>
	return n;
}
f010561f:	5d                   	pop    %ebp
f0105620:	c3                   	ret    

f0105621 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105621:	f3 0f 1e fb          	endbr32 
f0105625:	55                   	push   %ebp
f0105626:	89 e5                	mov    %esp,%ebp
f0105628:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010562b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010562e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105633:	39 d0                	cmp    %edx,%eax
f0105635:	74 0d                	je     f0105644 <strnlen+0x23>
f0105637:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010563b:	74 05                	je     f0105642 <strnlen+0x21>
		n++;
f010563d:	83 c0 01             	add    $0x1,%eax
f0105640:	eb f1                	jmp    f0105633 <strnlen+0x12>
f0105642:	89 c2                	mov    %eax,%edx
	return n;
}
f0105644:	89 d0                	mov    %edx,%eax
f0105646:	5d                   	pop    %ebp
f0105647:	c3                   	ret    

f0105648 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105648:	f3 0f 1e fb          	endbr32 
f010564c:	55                   	push   %ebp
f010564d:	89 e5                	mov    %esp,%ebp
f010564f:	53                   	push   %ebx
f0105650:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105653:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105656:	b8 00 00 00 00       	mov    $0x0,%eax
f010565b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f010565f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f0105662:	83 c0 01             	add    $0x1,%eax
f0105665:	84 d2                	test   %dl,%dl
f0105667:	75 f2                	jne    f010565b <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105669:	89 c8                	mov    %ecx,%eax
f010566b:	5b                   	pop    %ebx
f010566c:	5d                   	pop    %ebp
f010566d:	c3                   	ret    

f010566e <strcat>:

char *
strcat(char *dst, const char *src)
{
f010566e:	f3 0f 1e fb          	endbr32 
f0105672:	55                   	push   %ebp
f0105673:	89 e5                	mov    %esp,%ebp
f0105675:	53                   	push   %ebx
f0105676:	83 ec 10             	sub    $0x10,%esp
f0105679:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010567c:	53                   	push   %ebx
f010567d:	e8 83 ff ff ff       	call   f0105605 <strlen>
f0105682:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0105685:	ff 75 0c             	pushl  0xc(%ebp)
f0105688:	01 d8                	add    %ebx,%eax
f010568a:	50                   	push   %eax
f010568b:	e8 b8 ff ff ff       	call   f0105648 <strcpy>
	return dst;
}
f0105690:	89 d8                	mov    %ebx,%eax
f0105692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105695:	c9                   	leave  
f0105696:	c3                   	ret    

f0105697 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105697:	f3 0f 1e fb          	endbr32 
f010569b:	55                   	push   %ebp
f010569c:	89 e5                	mov    %esp,%ebp
f010569e:	56                   	push   %esi
f010569f:	53                   	push   %ebx
f01056a0:	8b 75 08             	mov    0x8(%ebp),%esi
f01056a3:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056a6:	89 f3                	mov    %esi,%ebx
f01056a8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01056ab:	89 f0                	mov    %esi,%eax
f01056ad:	39 d8                	cmp    %ebx,%eax
f01056af:	74 11                	je     f01056c2 <strncpy+0x2b>
		*dst++ = *src;
f01056b1:	83 c0 01             	add    $0x1,%eax
f01056b4:	0f b6 0a             	movzbl (%edx),%ecx
f01056b7:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01056ba:	80 f9 01             	cmp    $0x1,%cl
f01056bd:	83 da ff             	sbb    $0xffffffff,%edx
f01056c0:	eb eb                	jmp    f01056ad <strncpy+0x16>
	}
	return ret;
}
f01056c2:	89 f0                	mov    %esi,%eax
f01056c4:	5b                   	pop    %ebx
f01056c5:	5e                   	pop    %esi
f01056c6:	5d                   	pop    %ebp
f01056c7:	c3                   	ret    

f01056c8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01056c8:	f3 0f 1e fb          	endbr32 
f01056cc:	55                   	push   %ebp
f01056cd:	89 e5                	mov    %esp,%ebp
f01056cf:	56                   	push   %esi
f01056d0:	53                   	push   %ebx
f01056d1:	8b 75 08             	mov    0x8(%ebp),%esi
f01056d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01056d7:	8b 55 10             	mov    0x10(%ebp),%edx
f01056da:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01056dc:	85 d2                	test   %edx,%edx
f01056de:	74 21                	je     f0105701 <strlcpy+0x39>
f01056e0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01056e4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01056e6:	39 c2                	cmp    %eax,%edx
f01056e8:	74 14                	je     f01056fe <strlcpy+0x36>
f01056ea:	0f b6 19             	movzbl (%ecx),%ebx
f01056ed:	84 db                	test   %bl,%bl
f01056ef:	74 0b                	je     f01056fc <strlcpy+0x34>
			*dst++ = *src++;
f01056f1:	83 c1 01             	add    $0x1,%ecx
f01056f4:	83 c2 01             	add    $0x1,%edx
f01056f7:	88 5a ff             	mov    %bl,-0x1(%edx)
f01056fa:	eb ea                	jmp    f01056e6 <strlcpy+0x1e>
f01056fc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01056fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105701:	29 f0                	sub    %esi,%eax
}
f0105703:	5b                   	pop    %ebx
f0105704:	5e                   	pop    %esi
f0105705:	5d                   	pop    %ebp
f0105706:	c3                   	ret    

f0105707 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105707:	f3 0f 1e fb          	endbr32 
f010570b:	55                   	push   %ebp
f010570c:	89 e5                	mov    %esp,%ebp
f010570e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105711:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105714:	0f b6 01             	movzbl (%ecx),%eax
f0105717:	84 c0                	test   %al,%al
f0105719:	74 0c                	je     f0105727 <strcmp+0x20>
f010571b:	3a 02                	cmp    (%edx),%al
f010571d:	75 08                	jne    f0105727 <strcmp+0x20>
		p++, q++;
f010571f:	83 c1 01             	add    $0x1,%ecx
f0105722:	83 c2 01             	add    $0x1,%edx
f0105725:	eb ed                	jmp    f0105714 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105727:	0f b6 c0             	movzbl %al,%eax
f010572a:	0f b6 12             	movzbl (%edx),%edx
f010572d:	29 d0                	sub    %edx,%eax
}
f010572f:	5d                   	pop    %ebp
f0105730:	c3                   	ret    

f0105731 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105731:	f3 0f 1e fb          	endbr32 
f0105735:	55                   	push   %ebp
f0105736:	89 e5                	mov    %esp,%ebp
f0105738:	53                   	push   %ebx
f0105739:	8b 45 08             	mov    0x8(%ebp),%eax
f010573c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010573f:	89 c3                	mov    %eax,%ebx
f0105741:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105744:	eb 06                	jmp    f010574c <strncmp+0x1b>
		n--, p++, q++;
f0105746:	83 c0 01             	add    $0x1,%eax
f0105749:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010574c:	39 d8                	cmp    %ebx,%eax
f010574e:	74 16                	je     f0105766 <strncmp+0x35>
f0105750:	0f b6 08             	movzbl (%eax),%ecx
f0105753:	84 c9                	test   %cl,%cl
f0105755:	74 04                	je     f010575b <strncmp+0x2a>
f0105757:	3a 0a                	cmp    (%edx),%cl
f0105759:	74 eb                	je     f0105746 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010575b:	0f b6 00             	movzbl (%eax),%eax
f010575e:	0f b6 12             	movzbl (%edx),%edx
f0105761:	29 d0                	sub    %edx,%eax
}
f0105763:	5b                   	pop    %ebx
f0105764:	5d                   	pop    %ebp
f0105765:	c3                   	ret    
		return 0;
f0105766:	b8 00 00 00 00       	mov    $0x0,%eax
f010576b:	eb f6                	jmp    f0105763 <strncmp+0x32>

f010576d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010576d:	f3 0f 1e fb          	endbr32 
f0105771:	55                   	push   %ebp
f0105772:	89 e5                	mov    %esp,%ebp
f0105774:	8b 45 08             	mov    0x8(%ebp),%eax
f0105777:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010577b:	0f b6 10             	movzbl (%eax),%edx
f010577e:	84 d2                	test   %dl,%dl
f0105780:	74 09                	je     f010578b <strchr+0x1e>
		if (*s == c)
f0105782:	38 ca                	cmp    %cl,%dl
f0105784:	74 0a                	je     f0105790 <strchr+0x23>
	for (; *s; s++)
f0105786:	83 c0 01             	add    $0x1,%eax
f0105789:	eb f0                	jmp    f010577b <strchr+0xe>
			return (char *) s;
	return 0;
f010578b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105790:	5d                   	pop    %ebp
f0105791:	c3                   	ret    

f0105792 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105792:	f3 0f 1e fb          	endbr32 
f0105796:	55                   	push   %ebp
f0105797:	89 e5                	mov    %esp,%ebp
f0105799:	8b 45 08             	mov    0x8(%ebp),%eax
f010579c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01057a0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01057a3:	38 ca                	cmp    %cl,%dl
f01057a5:	74 09                	je     f01057b0 <strfind+0x1e>
f01057a7:	84 d2                	test   %dl,%dl
f01057a9:	74 05                	je     f01057b0 <strfind+0x1e>
	for (; *s; s++)
f01057ab:	83 c0 01             	add    $0x1,%eax
f01057ae:	eb f0                	jmp    f01057a0 <strfind+0xe>
			break;
	return (char *) s;
}
f01057b0:	5d                   	pop    %ebp
f01057b1:	c3                   	ret    

f01057b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01057b2:	f3 0f 1e fb          	endbr32 
f01057b6:	55                   	push   %ebp
f01057b7:	89 e5                	mov    %esp,%ebp
f01057b9:	57                   	push   %edi
f01057ba:	56                   	push   %esi
f01057bb:	53                   	push   %ebx
f01057bc:	8b 55 08             	mov    0x8(%ebp),%edx
f01057bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
f01057c2:	85 c9                	test   %ecx,%ecx
f01057c4:	74 33                	je     f01057f9 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01057c6:	89 d0                	mov    %edx,%eax
f01057c8:	09 c8                	or     %ecx,%eax
f01057ca:	a8 03                	test   $0x3,%al
f01057cc:	75 23                	jne    f01057f1 <memset+0x3f>
		c &= 0xFF;
f01057ce:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01057d2:	89 d8                	mov    %ebx,%eax
f01057d4:	c1 e0 08             	shl    $0x8,%eax
f01057d7:	89 df                	mov    %ebx,%edi
f01057d9:	c1 e7 18             	shl    $0x18,%edi
f01057dc:	89 de                	mov    %ebx,%esi
f01057de:	c1 e6 10             	shl    $0x10,%esi
f01057e1:	09 f7                	or     %esi,%edi
f01057e3:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
f01057e5:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01057e8:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
f01057ea:	89 d7                	mov    %edx,%edi
f01057ec:	fc                   	cld    
f01057ed:	f3 ab                	rep stos %eax,%es:(%edi)
f01057ef:	eb 08                	jmp    f01057f9 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01057f1:	89 d7                	mov    %edx,%edi
f01057f3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01057f6:	fc                   	cld    
f01057f7:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
f01057f9:	89 d0                	mov    %edx,%eax
f01057fb:	5b                   	pop    %ebx
f01057fc:	5e                   	pop    %esi
f01057fd:	5f                   	pop    %edi
f01057fe:	5d                   	pop    %ebp
f01057ff:	c3                   	ret    

f0105800 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105800:	f3 0f 1e fb          	endbr32 
f0105804:	55                   	push   %ebp
f0105805:	89 e5                	mov    %esp,%ebp
f0105807:	57                   	push   %edi
f0105808:	56                   	push   %esi
f0105809:	8b 45 08             	mov    0x8(%ebp),%eax
f010580c:	8b 75 0c             	mov    0xc(%ebp),%esi
f010580f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105812:	39 c6                	cmp    %eax,%esi
f0105814:	73 32                	jae    f0105848 <memmove+0x48>
f0105816:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105819:	39 c2                	cmp    %eax,%edx
f010581b:	76 2b                	jbe    f0105848 <memmove+0x48>
		s += n;
		d += n;
f010581d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105820:	89 fe                	mov    %edi,%esi
f0105822:	09 ce                	or     %ecx,%esi
f0105824:	09 d6                	or     %edx,%esi
f0105826:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010582c:	75 0e                	jne    f010583c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010582e:	83 ef 04             	sub    $0x4,%edi
f0105831:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105834:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105837:	fd                   	std    
f0105838:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010583a:	eb 09                	jmp    f0105845 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010583c:	83 ef 01             	sub    $0x1,%edi
f010583f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105842:	fd                   	std    
f0105843:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105845:	fc                   	cld    
f0105846:	eb 1a                	jmp    f0105862 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105848:	89 c2                	mov    %eax,%edx
f010584a:	09 ca                	or     %ecx,%edx
f010584c:	09 f2                	or     %esi,%edx
f010584e:	f6 c2 03             	test   $0x3,%dl
f0105851:	75 0a                	jne    f010585d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105853:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105856:	89 c7                	mov    %eax,%edi
f0105858:	fc                   	cld    
f0105859:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010585b:	eb 05                	jmp    f0105862 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f010585d:	89 c7                	mov    %eax,%edi
f010585f:	fc                   	cld    
f0105860:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105862:	5e                   	pop    %esi
f0105863:	5f                   	pop    %edi
f0105864:	5d                   	pop    %ebp
f0105865:	c3                   	ret    

f0105866 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105866:	f3 0f 1e fb          	endbr32 
f010586a:	55                   	push   %ebp
f010586b:	89 e5                	mov    %esp,%ebp
f010586d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105870:	ff 75 10             	pushl  0x10(%ebp)
f0105873:	ff 75 0c             	pushl  0xc(%ebp)
f0105876:	ff 75 08             	pushl  0x8(%ebp)
f0105879:	e8 82 ff ff ff       	call   f0105800 <memmove>
}
f010587e:	c9                   	leave  
f010587f:	c3                   	ret    

f0105880 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105880:	f3 0f 1e fb          	endbr32 
f0105884:	55                   	push   %ebp
f0105885:	89 e5                	mov    %esp,%ebp
f0105887:	56                   	push   %esi
f0105888:	53                   	push   %ebx
f0105889:	8b 45 08             	mov    0x8(%ebp),%eax
f010588c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010588f:	89 c6                	mov    %eax,%esi
f0105891:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105894:	39 f0                	cmp    %esi,%eax
f0105896:	74 1c                	je     f01058b4 <memcmp+0x34>
		if (*s1 != *s2)
f0105898:	0f b6 08             	movzbl (%eax),%ecx
f010589b:	0f b6 1a             	movzbl (%edx),%ebx
f010589e:	38 d9                	cmp    %bl,%cl
f01058a0:	75 08                	jne    f01058aa <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01058a2:	83 c0 01             	add    $0x1,%eax
f01058a5:	83 c2 01             	add    $0x1,%edx
f01058a8:	eb ea                	jmp    f0105894 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f01058aa:	0f b6 c1             	movzbl %cl,%eax
f01058ad:	0f b6 db             	movzbl %bl,%ebx
f01058b0:	29 d8                	sub    %ebx,%eax
f01058b2:	eb 05                	jmp    f01058b9 <memcmp+0x39>
	}

	return 0;
f01058b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01058b9:	5b                   	pop    %ebx
f01058ba:	5e                   	pop    %esi
f01058bb:	5d                   	pop    %ebp
f01058bc:	c3                   	ret    

f01058bd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01058bd:	f3 0f 1e fb          	endbr32 
f01058c1:	55                   	push   %ebp
f01058c2:	89 e5                	mov    %esp,%ebp
f01058c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01058c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01058ca:	89 c2                	mov    %eax,%edx
f01058cc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01058cf:	39 d0                	cmp    %edx,%eax
f01058d1:	73 09                	jae    f01058dc <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f01058d3:	38 08                	cmp    %cl,(%eax)
f01058d5:	74 05                	je     f01058dc <memfind+0x1f>
	for (; s < ends; s++)
f01058d7:	83 c0 01             	add    $0x1,%eax
f01058da:	eb f3                	jmp    f01058cf <memfind+0x12>
			break;
	return (void *) s;
}
f01058dc:	5d                   	pop    %ebp
f01058dd:	c3                   	ret    

f01058de <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01058de:	f3 0f 1e fb          	endbr32 
f01058e2:	55                   	push   %ebp
f01058e3:	89 e5                	mov    %esp,%ebp
f01058e5:	57                   	push   %edi
f01058e6:	56                   	push   %esi
f01058e7:	53                   	push   %ebx
f01058e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01058eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01058ee:	eb 03                	jmp    f01058f3 <strtol+0x15>
		s++;
f01058f0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01058f3:	0f b6 01             	movzbl (%ecx),%eax
f01058f6:	3c 20                	cmp    $0x20,%al
f01058f8:	74 f6                	je     f01058f0 <strtol+0x12>
f01058fa:	3c 09                	cmp    $0x9,%al
f01058fc:	74 f2                	je     f01058f0 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f01058fe:	3c 2b                	cmp    $0x2b,%al
f0105900:	74 2a                	je     f010592c <strtol+0x4e>
	int neg = 0;
f0105902:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105907:	3c 2d                	cmp    $0x2d,%al
f0105909:	74 2b                	je     f0105936 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010590b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105911:	75 0f                	jne    f0105922 <strtol+0x44>
f0105913:	80 39 30             	cmpb   $0x30,(%ecx)
f0105916:	74 28                	je     f0105940 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105918:	85 db                	test   %ebx,%ebx
f010591a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010591f:	0f 44 d8             	cmove  %eax,%ebx
f0105922:	b8 00 00 00 00       	mov    $0x0,%eax
f0105927:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010592a:	eb 46                	jmp    f0105972 <strtol+0x94>
		s++;
f010592c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f010592f:	bf 00 00 00 00       	mov    $0x0,%edi
f0105934:	eb d5                	jmp    f010590b <strtol+0x2d>
		s++, neg = 1;
f0105936:	83 c1 01             	add    $0x1,%ecx
f0105939:	bf 01 00 00 00       	mov    $0x1,%edi
f010593e:	eb cb                	jmp    f010590b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105940:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105944:	74 0e                	je     f0105954 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105946:	85 db                	test   %ebx,%ebx
f0105948:	75 d8                	jne    f0105922 <strtol+0x44>
		s++, base = 8;
f010594a:	83 c1 01             	add    $0x1,%ecx
f010594d:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105952:	eb ce                	jmp    f0105922 <strtol+0x44>
		s += 2, base = 16;
f0105954:	83 c1 02             	add    $0x2,%ecx
f0105957:	bb 10 00 00 00       	mov    $0x10,%ebx
f010595c:	eb c4                	jmp    f0105922 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f010595e:	0f be d2             	movsbl %dl,%edx
f0105961:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105964:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105967:	7d 3a                	jge    f01059a3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105969:	83 c1 01             	add    $0x1,%ecx
f010596c:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105970:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105972:	0f b6 11             	movzbl (%ecx),%edx
f0105975:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105978:	89 f3                	mov    %esi,%ebx
f010597a:	80 fb 09             	cmp    $0x9,%bl
f010597d:	76 df                	jbe    f010595e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f010597f:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105982:	89 f3                	mov    %esi,%ebx
f0105984:	80 fb 19             	cmp    $0x19,%bl
f0105987:	77 08                	ja     f0105991 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105989:	0f be d2             	movsbl %dl,%edx
f010598c:	83 ea 57             	sub    $0x57,%edx
f010598f:	eb d3                	jmp    f0105964 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105991:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105994:	89 f3                	mov    %esi,%ebx
f0105996:	80 fb 19             	cmp    $0x19,%bl
f0105999:	77 08                	ja     f01059a3 <strtol+0xc5>
			dig = *s - 'A' + 10;
f010599b:	0f be d2             	movsbl %dl,%edx
f010599e:	83 ea 37             	sub    $0x37,%edx
f01059a1:	eb c1                	jmp    f0105964 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f01059a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01059a7:	74 05                	je     f01059ae <strtol+0xd0>
		*endptr = (char *) s;
f01059a9:	8b 75 0c             	mov    0xc(%ebp),%esi
f01059ac:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01059ae:	89 c2                	mov    %eax,%edx
f01059b0:	f7 da                	neg    %edx
f01059b2:	85 ff                	test   %edi,%edi
f01059b4:	0f 45 c2             	cmovne %edx,%eax
}
f01059b7:	5b                   	pop    %ebx
f01059b8:	5e                   	pop    %esi
f01059b9:	5f                   	pop    %edi
f01059ba:	5d                   	pop    %ebp
f01059bb:	c3                   	ret    

f01059bc <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01059bc:	fa                   	cli    

	xorw    %ax, %ax
f01059bd:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01059bf:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059c1:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059c3:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01059c5:	0f 01 16             	lgdtl  (%esi)
f01059c8:	7c 70                	jl     f0105a3a <gdtdesc+0x2>
	movl    %cr0, %eax
f01059ca:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01059cd:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01059d1:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01059d4:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01059da:	08 00                	or     %al,(%eax)

f01059dc <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01059dc:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01059e0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059e2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059e4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01059e6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01059ea:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01059ec:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01059ee:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl    %eax, %cr3
f01059f3:	0f 22 d8             	mov    %eax,%cr3

	# Turn on large paging.
	movl	%cr4, %eax
f01059f6:	0f 20 e0             	mov    %cr4,%eax
	orl	$(CR4_PSE), %eax
f01059f9:	83 c8 10             	or     $0x10,%eax
	movl	%eax, %cr4
f01059fc:	0f 22 e0             	mov    %eax,%cr4

	# Turn on paging.
	movl    %cr0, %eax
f01059ff:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105a02:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105a07:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105a0a:	8b 25 84 2e 22 f0    	mov    0xf0222e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105a10:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105a15:	b8 52 02 10 f0       	mov    $0xf0100252,%eax
	call    *%eax
f0105a1a:	ff d0                	call   *%eax

f0105a1c <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105a1c:	eb fe                	jmp    f0105a1c <spin>
f0105a1e:	66 90                	xchg   %ax,%ax

f0105a20 <gdt>:
	...
f0105a28:	ff                   	(bad)  
f0105a29:	ff 00                	incl   (%eax)
f0105a2b:	00 00                	add    %al,(%eax)
f0105a2d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105a34:	00                   	.byte 0x0
f0105a35:	92                   	xchg   %eax,%edx
f0105a36:	cf                   	iret   
	...

f0105a38 <gdtdesc>:
f0105a38:	17                   	pop    %ss
f0105a39:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0105a3e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105a3e:	90                   	nop

f0105a3f <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105a3f:	89 c2                	mov    %eax,%edx
f0105a41:	ec                   	in     (%dx),%al
}
f0105a42:	c3                   	ret    

f0105a43 <outb>:
{
f0105a43:	89 c1                	mov    %eax,%ecx
f0105a45:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105a47:	89 ca                	mov    %ecx,%edx
f0105a49:	ee                   	out    %al,(%dx)
}
f0105a4a:	c3                   	ret    

f0105a4b <sum>:
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
f0105a4b:	55                   	push   %ebp
f0105a4c:	89 e5                	mov    %esp,%ebp
f0105a4e:	56                   	push   %esi
f0105a4f:	53                   	push   %ebx
f0105a50:	89 c6                	mov    %eax,%esi
	int i, sum;

	sum = 0;
f0105a52:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < len; i++)
f0105a57:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105a5c:	39 d1                	cmp    %edx,%ecx
f0105a5e:	7d 0b                	jge    f0105a6b <sum+0x20>
		sum += ((uint8_t *)addr)[i];
f0105a60:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
f0105a64:	01 d8                	add    %ebx,%eax
	for (i = 0; i < len; i++)
f0105a66:	83 c1 01             	add    $0x1,%ecx
f0105a69:	eb f1                	jmp    f0105a5c <sum+0x11>
	return sum;
}
f0105a6b:	5b                   	pop    %ebx
f0105a6c:	5e                   	pop    %esi
f0105a6d:	5d                   	pop    %ebp
f0105a6e:	c3                   	ret    

f0105a6f <_kaddr>:
{
f0105a6f:	55                   	push   %ebp
f0105a70:	89 e5                	mov    %esp,%ebp
f0105a72:	53                   	push   %ebx
f0105a73:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0105a76:	89 cb                	mov    %ecx,%ebx
f0105a78:	c1 eb 0c             	shr    $0xc,%ebx
f0105a7b:	3b 1d 88 2e 22 f0    	cmp    0xf0222e88,%ebx
f0105a81:	73 0b                	jae    f0105a8e <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0105a83:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0105a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105a8c:	c9                   	leave  
f0105a8d:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105a8e:	51                   	push   %ecx
f0105a8f:	68 2c 65 10 f0       	push   $0xf010652c
f0105a94:	52                   	push   %edx
f0105a95:	50                   	push   %eax
f0105a96:	e8 cf a5 ff ff       	call   f010006a <_panic>

f0105a9b <mpsearch1>:

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105a9b:	55                   	push   %ebp
f0105a9c:	89 e5                	mov    %esp,%ebp
f0105a9e:	57                   	push   %edi
f0105a9f:	56                   	push   %esi
f0105aa0:	53                   	push   %ebx
f0105aa1:	83 ec 0c             	sub    $0xc,%esp
f0105aa4:	89 c7                	mov    %eax,%edi
f0105aa6:	89 d6                	mov    %edx,%esi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105aa8:	89 c1                	mov    %eax,%ecx
f0105aaa:	ba 57 00 00 00       	mov    $0x57,%edx
f0105aaf:	b8 dd 81 10 f0       	mov    $0xf01081dd,%eax
f0105ab4:	e8 b6 ff ff ff       	call   f0105a6f <_kaddr>
f0105ab9:	89 c3                	mov    %eax,%ebx
f0105abb:	8d 0c 3e             	lea    (%esi,%edi,1),%ecx
f0105abe:	ba 57 00 00 00       	mov    $0x57,%edx
f0105ac3:	b8 dd 81 10 f0       	mov    $0xf01081dd,%eax
f0105ac8:	e8 a2 ff ff ff       	call   f0105a6f <_kaddr>
f0105acd:	89 c6                	mov    %eax,%esi

	for (; mp < end; mp++)
f0105acf:	eb 03                	jmp    f0105ad4 <mpsearch1+0x39>
f0105ad1:	83 c3 10             	add    $0x10,%ebx
f0105ad4:	39 f3                	cmp    %esi,%ebx
f0105ad6:	73 29                	jae    f0105b01 <mpsearch1+0x66>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105ad8:	83 ec 04             	sub    $0x4,%esp
f0105adb:	6a 04                	push   $0x4
f0105add:	68 ed 81 10 f0       	push   $0xf01081ed
f0105ae2:	53                   	push   %ebx
f0105ae3:	e8 98 fd ff ff       	call   f0105880 <memcmp>
f0105ae8:	83 c4 10             	add    $0x10,%esp
f0105aeb:	85 c0                	test   %eax,%eax
f0105aed:	75 e2                	jne    f0105ad1 <mpsearch1+0x36>
		    sum(mp, sizeof(*mp)) == 0)
f0105aef:	ba 10 00 00 00       	mov    $0x10,%edx
f0105af4:	89 d8                	mov    %ebx,%eax
f0105af6:	e8 50 ff ff ff       	call   f0105a4b <sum>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105afb:	84 c0                	test   %al,%al
f0105afd:	75 d2                	jne    f0105ad1 <mpsearch1+0x36>
f0105aff:	eb 05                	jmp    f0105b06 <mpsearch1+0x6b>
			return mp;
	return NULL;
f0105b01:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105b06:	89 d8                	mov    %ebx,%eax
f0105b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b0b:	5b                   	pop    %ebx
f0105b0c:	5e                   	pop    %esi
f0105b0d:	5f                   	pop    %edi
f0105b0e:	5d                   	pop    %ebp
f0105b0f:	c3                   	ret    

f0105b10 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) if there is no EBDA, in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp *
mpsearch(void)
{
f0105b10:	55                   	push   %ebp
f0105b11:	89 e5                	mov    %esp,%ebp
f0105b13:	83 ec 08             	sub    $0x8,%esp
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f0105b16:	b9 00 04 00 00       	mov    $0x400,%ecx
f0105b1b:	ba 6f 00 00 00       	mov    $0x6f,%edx
f0105b20:	b8 dd 81 10 f0       	mov    $0xf01081dd,%eax
f0105b25:	e8 45 ff ff ff       	call   f0105a6f <_kaddr>

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105b2a:	0f b7 50 0e          	movzwl 0xe(%eax),%edx
f0105b2e:	85 d2                	test   %edx,%edx
f0105b30:	74 24                	je     f0105b56 <mpsearch+0x46>
		p <<= 4;	// Translate from segment to PA
f0105b32:	89 d0                	mov    %edx,%eax
f0105b34:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105b37:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b3c:	e8 5a ff ff ff       	call   f0105a9b <mpsearch1>
f0105b41:	85 c0                	test   %eax,%eax
f0105b43:	75 0f                	jne    f0105b54 <mpsearch+0x44>
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0105b45:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105b4a:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105b4f:	e8 47 ff ff ff       	call   f0105a9b <mpsearch1>
}
f0105b54:	c9                   	leave  
f0105b55:	c3                   	ret    
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105b56:	0f b7 40 13          	movzwl 0x13(%eax),%eax
f0105b5a:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105b5d:	2d 00 04 00 00       	sub    $0x400,%eax
f0105b62:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b67:	e8 2f ff ff ff       	call   f0105a9b <mpsearch1>
f0105b6c:	85 c0                	test   %eax,%eax
f0105b6e:	75 e4                	jne    f0105b54 <mpsearch+0x44>
f0105b70:	eb d3                	jmp    f0105b45 <mpsearch+0x35>

f0105b72 <mpconfig>:
// Search for an MP configuration table.  For now, don't accept the
// default configurations (physaddr == 0).
// Check for the correct signature, checksum, and version.
static struct mpconf *
mpconfig(struct mp **pmp)
{
f0105b72:	55                   	push   %ebp
f0105b73:	89 e5                	mov    %esp,%ebp
f0105b75:	57                   	push   %edi
f0105b76:	56                   	push   %esi
f0105b77:	53                   	push   %ebx
f0105b78:	83 ec 1c             	sub    $0x1c,%esp
f0105b7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0105b7e:	e8 8d ff ff ff       	call   f0105b10 <mpsearch>
f0105b83:	89 c6                	mov    %eax,%esi
f0105b85:	85 c0                	test   %eax,%eax
f0105b87:	0f 84 ef 00 00 00    	je     f0105c7c <mpconfig+0x10a>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0105b8d:	8b 48 04             	mov    0x4(%eax),%ecx
f0105b90:	85 c9                	test   %ecx,%ecx
f0105b92:	74 6e                	je     f0105c02 <mpconfig+0x90>
f0105b94:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105b98:	75 68                	jne    f0105c02 <mpconfig+0x90>
		cprintf("SMP: Default configurations not implemented\n");
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f0105b9a:	ba 90 00 00 00       	mov    $0x90,%edx
f0105b9f:	b8 dd 81 10 f0       	mov    $0xf01081dd,%eax
f0105ba4:	e8 c6 fe ff ff       	call   f0105a6f <_kaddr>
f0105ba9:	89 c3                	mov    %eax,%ebx
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105bab:	83 ec 04             	sub    $0x4,%esp
f0105bae:	6a 04                	push   $0x4
f0105bb0:	68 f2 81 10 f0       	push   $0xf01081f2
f0105bb5:	50                   	push   %eax
f0105bb6:	e8 c5 fc ff ff       	call   f0105880 <memcmp>
f0105bbb:	83 c4 10             	add    $0x10,%esp
f0105bbe:	85 c0                	test   %eax,%eax
f0105bc0:	75 57                	jne    f0105c19 <mpconfig+0xa7>
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0105bc2:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105bc6:	0f b7 d7             	movzwl %di,%edx
f0105bc9:	89 d8                	mov    %ebx,%eax
f0105bcb:	e8 7b fe ff ff       	call   f0105a4b <sum>
f0105bd0:	84 c0                	test   %al,%al
f0105bd2:	75 5c                	jne    f0105c30 <mpconfig+0xbe>
		cprintf("SMP: Bad MP configuration checksum\n");
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0105bd4:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0105bd8:	3c 01                	cmp    $0x1,%al
f0105bda:	74 04                	je     f0105be0 <mpconfig+0x6e>
f0105bdc:	3c 04                	cmp    $0x4,%al
f0105bde:	75 67                	jne    f0105c47 <mpconfig+0xd5>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105be0:	0f b7 53 28          	movzwl 0x28(%ebx),%edx
f0105be4:	0f b7 c7             	movzwl %di,%eax
f0105be7:	01 d8                	add    %ebx,%eax
f0105be9:	e8 5d fe ff ff       	call   f0105a4b <sum>
f0105bee:	02 43 2a             	add    0x2a(%ebx),%al
f0105bf1:	75 6f                	jne    f0105c62 <mpconfig+0xf0>
		cprintf("SMP: Bad MP configuration extended checksum\n");
		return NULL;
	}
	*pmp = mp;
f0105bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105bf6:	89 30                	mov    %esi,(%eax)
	return conf;
}
f0105bf8:	89 d8                	mov    %ebx,%eax
f0105bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105bfd:	5b                   	pop    %ebx
f0105bfe:	5e                   	pop    %esi
f0105bff:	5f                   	pop    %edi
f0105c00:	5d                   	pop    %ebp
f0105c01:	c3                   	ret    
		cprintf("SMP: Default configurations not implemented\n");
f0105c02:	83 ec 0c             	sub    $0xc,%esp
f0105c05:	68 50 80 10 f0       	push   $0xf0108050
f0105c0a:	e8 ad dd ff ff       	call   f01039bc <cprintf>
		return NULL;
f0105c0f:	83 c4 10             	add    $0x10,%esp
f0105c12:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c17:	eb df                	jmp    f0105bf8 <mpconfig+0x86>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105c19:	83 ec 0c             	sub    $0xc,%esp
f0105c1c:	68 80 80 10 f0       	push   $0xf0108080
f0105c21:	e8 96 dd ff ff       	call   f01039bc <cprintf>
		return NULL;
f0105c26:	83 c4 10             	add    $0x10,%esp
f0105c29:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c2e:	eb c8                	jmp    f0105bf8 <mpconfig+0x86>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105c30:	83 ec 0c             	sub    $0xc,%esp
f0105c33:	68 b4 80 10 f0       	push   $0xf01080b4
f0105c38:	e8 7f dd ff ff       	call   f01039bc <cprintf>
		return NULL;
f0105c3d:	83 c4 10             	add    $0x10,%esp
f0105c40:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c45:	eb b1                	jmp    f0105bf8 <mpconfig+0x86>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105c47:	83 ec 08             	sub    $0x8,%esp
f0105c4a:	0f b6 c0             	movzbl %al,%eax
f0105c4d:	50                   	push   %eax
f0105c4e:	68 d8 80 10 f0       	push   $0xf01080d8
f0105c53:	e8 64 dd ff ff       	call   f01039bc <cprintf>
		return NULL;
f0105c58:	83 c4 10             	add    $0x10,%esp
f0105c5b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c60:	eb 96                	jmp    f0105bf8 <mpconfig+0x86>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105c62:	83 ec 0c             	sub    $0xc,%esp
f0105c65:	68 f8 80 10 f0       	push   $0xf01080f8
f0105c6a:	e8 4d dd ff ff       	call   f01039bc <cprintf>
		return NULL;
f0105c6f:	83 c4 10             	add    $0x10,%esp
f0105c72:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c77:	e9 7c ff ff ff       	jmp    f0105bf8 <mpconfig+0x86>
		return NULL;
f0105c7c:	89 c3                	mov    %eax,%ebx
f0105c7e:	e9 75 ff ff ff       	jmp    f0105bf8 <mpconfig+0x86>

f0105c83 <mp_init>:

void
mp_init(void)
{
f0105c83:	f3 0f 1e fb          	endbr32 
f0105c87:	55                   	push   %ebp
f0105c88:	89 e5                	mov    %esp,%ebp
f0105c8a:	57                   	push   %edi
f0105c8b:	56                   	push   %esi
f0105c8c:	53                   	push   %ebx
f0105c8d:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105c90:	c7 05 c0 33 22 f0 20 	movl   $0xf0223020,0xf02233c0
f0105c97:	30 22 f0 
	if ((conf = mpconfig(&mp)) == 0)
f0105c9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105c9d:	e8 d0 fe ff ff       	call   f0105b72 <mpconfig>
f0105ca2:	85 c0                	test   %eax,%eax
f0105ca4:	0f 84 e5 00 00 00    	je     f0105d8f <mp_init+0x10c>
f0105caa:	89 c7                	mov    %eax,%edi
		return;
	ismp = 1;
f0105cac:	c7 05 00 30 22 f0 01 	movl   $0x1,0xf0223000
f0105cb3:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105cb6:	8b 40 24             	mov    0x24(%eax),%eax
f0105cb9:	a3 00 40 26 f0       	mov    %eax,0xf0264000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105cbe:	8d 77 2c             	lea    0x2c(%edi),%esi
f0105cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105cc6:	eb 38                	jmp    f0105d00 <mp_init+0x7d>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105cc8:	f6 46 03 02          	testb  $0x2,0x3(%esi)
f0105ccc:	74 11                	je     f0105cdf <mp_init+0x5c>
				bootcpu = &cpus[ncpu];
f0105cce:	6b 05 c4 33 22 f0 74 	imul   $0x74,0xf02233c4,%eax
f0105cd5:	05 20 30 22 f0       	add    $0xf0223020,%eax
f0105cda:	a3 c0 33 22 f0       	mov    %eax,0xf02233c0
			if (ncpu < NCPU) {
f0105cdf:	a1 c4 33 22 f0       	mov    0xf02233c4,%eax
f0105ce4:	83 f8 07             	cmp    $0x7,%eax
f0105ce7:	7f 33                	jg     f0105d1c <mp_init+0x99>
				cpus[ncpu].cpu_id = ncpu;
f0105ce9:	6b d0 74             	imul   $0x74,%eax,%edx
f0105cec:	88 82 20 30 22 f0    	mov    %al,-0xfddcfe0(%edx)
				ncpu++;
f0105cf2:	83 c0 01             	add    $0x1,%eax
f0105cf5:	a3 c4 33 22 f0       	mov    %eax,0xf02233c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105cfa:	83 c6 14             	add    $0x14,%esi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105cfd:	83 c3 01             	add    $0x1,%ebx
f0105d00:	0f b7 47 22          	movzwl 0x22(%edi),%eax
f0105d04:	39 d8                	cmp    %ebx,%eax
f0105d06:	76 4f                	jbe    f0105d57 <mp_init+0xd4>
		switch (*p) {
f0105d08:	0f b6 06             	movzbl (%esi),%eax
f0105d0b:	84 c0                	test   %al,%al
f0105d0d:	74 b9                	je     f0105cc8 <mp_init+0x45>
f0105d0f:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105d12:	80 fa 03             	cmp    $0x3,%dl
f0105d15:	77 1c                	ja     f0105d33 <mp_init+0xb0>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105d17:	83 c6 08             	add    $0x8,%esi
			continue;
f0105d1a:	eb e1                	jmp    f0105cfd <mp_init+0x7a>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105d1c:	83 ec 08             	sub    $0x8,%esp
f0105d1f:	0f b6 46 01          	movzbl 0x1(%esi),%eax
f0105d23:	50                   	push   %eax
f0105d24:	68 28 81 10 f0       	push   $0xf0108128
f0105d29:	e8 8e dc ff ff       	call   f01039bc <cprintf>
f0105d2e:	83 c4 10             	add    $0x10,%esp
f0105d31:	eb c7                	jmp    f0105cfa <mp_init+0x77>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d33:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105d36:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d39:	50                   	push   %eax
f0105d3a:	68 50 81 10 f0       	push   $0xf0108150
f0105d3f:	e8 78 dc ff ff       	call   f01039bc <cprintf>
			ismp = 0;
f0105d44:	c7 05 00 30 22 f0 00 	movl   $0x0,0xf0223000
f0105d4b:	00 00 00 
			i = conf->entry;
f0105d4e:	0f b7 5f 22          	movzwl 0x22(%edi),%ebx
f0105d52:	83 c4 10             	add    $0x10,%esp
f0105d55:	eb a6                	jmp    f0105cfd <mp_init+0x7a>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105d57:	a1 c0 33 22 f0       	mov    0xf02233c0,%eax
f0105d5c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105d63:	83 3d 00 30 22 f0 00 	cmpl   $0x0,0xf0223000
f0105d6a:	74 2b                	je     f0105d97 <mp_init+0x114>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105d6c:	83 ec 04             	sub    $0x4,%esp
f0105d6f:	ff 35 c4 33 22 f0    	pushl  0xf02233c4
f0105d75:	0f b6 00             	movzbl (%eax),%eax
f0105d78:	50                   	push   %eax
f0105d79:	68 f7 81 10 f0       	push   $0xf01081f7
f0105d7e:	e8 39 dc ff ff       	call   f01039bc <cprintf>

	if (mp->imcrp) {
f0105d83:	83 c4 10             	add    $0x10,%esp
f0105d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d89:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105d8d:	75 2e                	jne    f0105dbd <mp_init+0x13a>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d92:	5b                   	pop    %ebx
f0105d93:	5e                   	pop    %esi
f0105d94:	5f                   	pop    %edi
f0105d95:	5d                   	pop    %ebp
f0105d96:	c3                   	ret    
		ncpu = 1;
f0105d97:	c7 05 c4 33 22 f0 01 	movl   $0x1,0xf02233c4
f0105d9e:	00 00 00 
		lapicaddr = 0;
f0105da1:	c7 05 00 40 26 f0 00 	movl   $0x0,0xf0264000
f0105da8:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105dab:	83 ec 0c             	sub    $0xc,%esp
f0105dae:	68 70 81 10 f0       	push   $0xf0108170
f0105db3:	e8 04 dc ff ff       	call   f01039bc <cprintf>
		return;
f0105db8:	83 c4 10             	add    $0x10,%esp
f0105dbb:	eb d2                	jmp    f0105d8f <mp_init+0x10c>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105dbd:	83 ec 0c             	sub    $0xc,%esp
f0105dc0:	68 9c 81 10 f0       	push   $0xf010819c
f0105dc5:	e8 f2 db ff ff       	call   f01039bc <cprintf>
		outb(0x22, 0x70);   // Select IMCR
f0105dca:	ba 70 00 00 00       	mov    $0x70,%edx
f0105dcf:	b8 22 00 00 00       	mov    $0x22,%eax
f0105dd4:	e8 6a fc ff ff       	call   f0105a43 <outb>
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105dd9:	b8 23 00 00 00       	mov    $0x23,%eax
f0105dde:	e8 5c fc ff ff       	call   f0105a3f <inb>
f0105de3:	83 c8 01             	or     $0x1,%eax
f0105de6:	0f b6 d0             	movzbl %al,%edx
f0105de9:	b8 23 00 00 00       	mov    $0x23,%eax
f0105dee:	e8 50 fc ff ff       	call   f0105a43 <outb>
f0105df3:	83 c4 10             	add    $0x10,%esp
f0105df6:	eb 97                	jmp    f0105d8f <mp_init+0x10c>

f0105df8 <outb>:
{
f0105df8:	89 c1                	mov    %eax,%ecx
f0105dfa:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105dfc:	89 ca                	mov    %ecx,%edx
f0105dfe:	ee                   	out    %al,(%dx)
}
f0105dff:	c3                   	ret    

f0105e00 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105e00:	8b 0d 04 40 26 f0    	mov    0xf0264004,%ecx
f0105e06:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105e09:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105e0b:	a1 04 40 26 f0       	mov    0xf0264004,%eax
f0105e10:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105e13:	c3                   	ret    

f0105e14 <_kaddr>:
{
f0105e14:	55                   	push   %ebp
f0105e15:	89 e5                	mov    %esp,%ebp
f0105e17:	53                   	push   %ebx
f0105e18:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0105e1b:	89 cb                	mov    %ecx,%ebx
f0105e1d:	c1 eb 0c             	shr    $0xc,%ebx
f0105e20:	3b 1d 88 2e 22 f0    	cmp    0xf0222e88,%ebx
f0105e26:	73 0b                	jae    f0105e33 <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0105e28:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0105e2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105e31:	c9                   	leave  
f0105e32:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105e33:	51                   	push   %ecx
f0105e34:	68 2c 65 10 f0       	push   $0xf010652c
f0105e39:	52                   	push   %edx
f0105e3a:	50                   	push   %eax
f0105e3b:	e8 2a a2 ff ff       	call   f010006a <_panic>

f0105e40 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105e40:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105e44:	8b 15 04 40 26 f0    	mov    0xf0264004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105e4a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105e4f:	85 d2                	test   %edx,%edx
f0105e51:	74 06                	je     f0105e59 <cpunum+0x19>
		return lapic[ID] >> 24;
f0105e53:	8b 42 20             	mov    0x20(%edx),%eax
f0105e56:	c1 e8 18             	shr    $0x18,%eax
}
f0105e59:	c3                   	ret    

f0105e5a <lapic_init>:
{
f0105e5a:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0105e5e:	a1 00 40 26 f0       	mov    0xf0264000,%eax
f0105e63:	85 c0                	test   %eax,%eax
f0105e65:	75 01                	jne    f0105e68 <lapic_init+0xe>
f0105e67:	c3                   	ret    
{
f0105e68:	55                   	push   %ebp
f0105e69:	89 e5                	mov    %esp,%ebp
f0105e6b:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105e6e:	68 00 10 00 00       	push   $0x1000
f0105e73:	50                   	push   %eax
f0105e74:	e8 0e c0 ff ff       	call   f0101e87 <mmio_map_region>
f0105e79:	a3 04 40 26 f0       	mov    %eax,0xf0264004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105e7e:	ba 27 01 00 00       	mov    $0x127,%edx
f0105e83:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105e88:	e8 73 ff ff ff       	call   f0105e00 <lapicw>
	lapicw(TDCR, X1);
f0105e8d:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105e92:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105e97:	e8 64 ff ff ff       	call   f0105e00 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105e9c:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105ea1:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105ea6:	e8 55 ff ff ff       	call   f0105e00 <lapicw>
	lapicw(TICR, 10000000); 
f0105eab:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105eb0:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105eb5:	e8 46 ff ff ff       	call   f0105e00 <lapicw>
	if (thiscpu != bootcpu)
f0105eba:	e8 81 ff ff ff       	call   f0105e40 <cpunum>
f0105ebf:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ec2:	05 20 30 22 f0       	add    $0xf0223020,%eax
f0105ec7:	83 c4 10             	add    $0x10,%esp
f0105eca:	39 05 c0 33 22 f0    	cmp    %eax,0xf02233c0
f0105ed0:	74 0f                	je     f0105ee1 <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f0105ed2:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ed7:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105edc:	e8 1f ff ff ff       	call   f0105e00 <lapicw>
	lapicw(LINT1, MASKED);
f0105ee1:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ee6:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105eeb:	e8 10 ff ff ff       	call   f0105e00 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105ef0:	a1 04 40 26 f0       	mov    0xf0264004,%eax
f0105ef5:	8b 40 30             	mov    0x30(%eax),%eax
f0105ef8:	c1 e8 10             	shr    $0x10,%eax
f0105efb:	a8 fc                	test   $0xfc,%al
f0105efd:	75 7c                	jne    f0105f7b <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105eff:	ba 33 00 00 00       	mov    $0x33,%edx
f0105f04:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105f09:	e8 f2 fe ff ff       	call   f0105e00 <lapicw>
	lapicw(ESR, 0);
f0105f0e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f13:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f18:	e8 e3 fe ff ff       	call   f0105e00 <lapicw>
	lapicw(ESR, 0);
f0105f1d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f22:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f27:	e8 d4 fe ff ff       	call   f0105e00 <lapicw>
	lapicw(EOI, 0);
f0105f2c:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f31:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f36:	e8 c5 fe ff ff       	call   f0105e00 <lapicw>
	lapicw(ICRHI, 0);
f0105f3b:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f40:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105f45:	e8 b6 fe ff ff       	call   f0105e00 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105f4a:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105f4f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f54:	e8 a7 fe ff ff       	call   f0105e00 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105f59:	8b 15 04 40 26 f0    	mov    0xf0264004,%edx
f0105f5f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105f65:	f6 c4 10             	test   $0x10,%ah
f0105f68:	75 f5                	jne    f0105f5f <lapic_init+0x105>
	lapicw(TPR, 0);
f0105f6a:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f6f:	b8 20 00 00 00       	mov    $0x20,%eax
f0105f74:	e8 87 fe ff ff       	call   f0105e00 <lapicw>
}
f0105f79:	c9                   	leave  
f0105f7a:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105f7b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f80:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105f85:	e8 76 fe ff ff       	call   f0105e00 <lapicw>
f0105f8a:	e9 70 ff ff ff       	jmp    f0105eff <lapic_init+0xa5>

f0105f8f <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0105f8f:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105f93:	83 3d 04 40 26 f0 00 	cmpl   $0x0,0xf0264004
f0105f9a:	74 17                	je     f0105fb3 <lapic_eoi+0x24>
{
f0105f9c:	55                   	push   %ebp
f0105f9d:	89 e5                	mov    %esp,%ebp
f0105f9f:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0105fa2:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fa7:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105fac:	e8 4f fe ff ff       	call   f0105e00 <lapicw>
}
f0105fb1:	c9                   	leave  
f0105fb2:	c3                   	ret    
f0105fb3:	c3                   	ret    

f0105fb4 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105fb4:	f3 0f 1e fb          	endbr32 
f0105fb8:	55                   	push   %ebp
f0105fb9:	89 e5                	mov    %esp,%ebp
f0105fbb:	56                   	push   %esi
f0105fbc:	53                   	push   %ebx
f0105fbd:	8b 75 08             	mov    0x8(%ebp),%esi
f0105fc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uint16_t *wrv;

	// "The BSP must initialize CMOS shutdown code to 0AH
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
f0105fc3:	ba 0f 00 00 00       	mov    $0xf,%edx
f0105fc8:	b8 70 00 00 00       	mov    $0x70,%eax
f0105fcd:	e8 26 fe ff ff       	call   f0105df8 <outb>
	outb(IO_RTC+1, 0x0A);
f0105fd2:	ba 0a 00 00 00       	mov    $0xa,%edx
f0105fd7:	b8 71 00 00 00       	mov    $0x71,%eax
f0105fdc:	e8 17 fe ff ff       	call   f0105df8 <outb>
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
f0105fe1:	b9 67 04 00 00       	mov    $0x467,%ecx
f0105fe6:	ba 98 00 00 00       	mov    $0x98,%edx
f0105feb:	b8 14 82 10 f0       	mov    $0xf0108214,%eax
f0105ff0:	e8 1f fe ff ff       	call   f0105e14 <_kaddr>
	wrv[0] = 0;
f0105ff5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	wrv[1] = addr >> 4;
f0105ffa:	89 da                	mov    %ebx,%edx
f0105ffc:	c1 ea 04             	shr    $0x4,%edx
f0105fff:	66 89 50 02          	mov    %dx,0x2(%eax)

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106003:	c1 e6 18             	shl    $0x18,%esi
f0106006:	89 f2                	mov    %esi,%edx
f0106008:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010600d:	e8 ee fd ff ff       	call   f0105e00 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106012:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106017:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010601c:	e8 df fd ff ff       	call   f0105e00 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106021:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106026:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010602b:	e8 d0 fd ff ff       	call   f0105e00 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106030:	c1 eb 0c             	shr    $0xc,%ebx
f0106033:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106036:	89 f2                	mov    %esi,%edx
f0106038:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010603d:	e8 be fd ff ff       	call   f0105e00 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106042:	89 da                	mov    %ebx,%edx
f0106044:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106049:	e8 b2 fd ff ff       	call   f0105e00 <lapicw>
		lapicw(ICRHI, apicid << 24);
f010604e:	89 f2                	mov    %esi,%edx
f0106050:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106055:	e8 a6 fd ff ff       	call   f0105e00 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010605a:	89 da                	mov    %ebx,%edx
f010605c:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106061:	e8 9a fd ff ff       	call   f0105e00 <lapicw>
		microdelay(200);
	}
}
f0106066:	5b                   	pop    %ebx
f0106067:	5e                   	pop    %esi
f0106068:	5d                   	pop    %ebp
f0106069:	c3                   	ret    

f010606a <lapic_ipi>:

void
lapic_ipi(int vector)
{
f010606a:	f3 0f 1e fb          	endbr32 
f010606e:	55                   	push   %ebp
f010606f:	89 e5                	mov    %esp,%ebp
f0106071:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106074:	8b 55 08             	mov    0x8(%ebp),%edx
f0106077:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010607d:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106082:	e8 79 fd ff ff       	call   f0105e00 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106087:	8b 15 04 40 26 f0    	mov    0xf0264004,%edx
f010608d:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106093:	f6 c4 10             	test   $0x10,%ah
f0106096:	75 f5                	jne    f010608d <lapic_ipi+0x23>
		;
}
f0106098:	c9                   	leave  
f0106099:	c3                   	ret    

f010609a <xchg>:
{
f010609a:	89 c1                	mov    %eax,%ecx
f010609c:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f010609e:	f0 87 01             	lock xchg %eax,(%ecx)
}
f01060a1:	c3                   	ret    

f01060a2 <get_caller_pcs>:
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01060a2:	89 e9                	mov    %ebp,%ecx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f01060a4:	ba 00 00 00 00       	mov    $0x0,%edx
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060a9:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f01060af:	76 3f                	jbe    f01060f0 <get_caller_pcs+0x4e>
f01060b1:	83 fa 09             	cmp    $0x9,%edx
f01060b4:	7f 3a                	jg     f01060f0 <get_caller_pcs+0x4e>
{
f01060b6:	55                   	push   %ebp
f01060b7:	89 e5                	mov    %esp,%ebp
f01060b9:	53                   	push   %ebx
			break;
		pcs[i] = ebp[1];          // saved %eip
f01060ba:	8b 59 04             	mov    0x4(%ecx),%ebx
f01060bd:	89 1c 90             	mov    %ebx,(%eax,%edx,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01060c0:	8b 09                	mov    (%ecx),%ecx
	for (i = 0; i < 10; i++){
f01060c2:	83 c2 01             	add    $0x1,%edx
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060c5:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f01060cb:	76 11                	jbe    f01060de <get_caller_pcs+0x3c>
f01060cd:	83 fa 09             	cmp    $0x9,%edx
f01060d0:	7e e8                	jle    f01060ba <get_caller_pcs+0x18>
f01060d2:	eb 0a                	jmp    f01060de <get_caller_pcs+0x3c>
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f01060d4:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	for (; i < 10; i++)
f01060db:	83 c2 01             	add    $0x1,%edx
f01060de:	83 fa 09             	cmp    $0x9,%edx
f01060e1:	7e f1                	jle    f01060d4 <get_caller_pcs+0x32>
}
f01060e3:	5b                   	pop    %ebx
f01060e4:	5d                   	pop    %ebp
f01060e5:	c3                   	ret    
		pcs[i] = 0;
f01060e6:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	for (; i < 10; i++)
f01060ed:	83 c2 01             	add    $0x1,%edx
f01060f0:	83 fa 09             	cmp    $0x9,%edx
f01060f3:	7e f1                	jle    f01060e6 <get_caller_pcs+0x44>
f01060f5:	c3                   	ret    

f01060f6 <holding>:

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f01060f6:	83 38 00             	cmpl   $0x0,(%eax)
f01060f9:	75 06                	jne    f0106101 <holding+0xb>
f01060fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106100:	c3                   	ret    
{
f0106101:	55                   	push   %ebp
f0106102:	89 e5                	mov    %esp,%ebp
f0106104:	53                   	push   %ebx
f0106105:	83 ec 04             	sub    $0x4,%esp
	return lock->locked && lock->cpu == thiscpu;
f0106108:	8b 58 08             	mov    0x8(%eax),%ebx
f010610b:	e8 30 fd ff ff       	call   f0105e40 <cpunum>
f0106110:	6b c0 74             	imul   $0x74,%eax,%eax
f0106113:	05 20 30 22 f0       	add    $0xf0223020,%eax
f0106118:	39 c3                	cmp    %eax,%ebx
f010611a:	0f 94 c0             	sete   %al
f010611d:	0f b6 c0             	movzbl %al,%eax
}
f0106120:	83 c4 04             	add    $0x4,%esp
f0106123:	5b                   	pop    %ebx
f0106124:	5d                   	pop    %ebp
f0106125:	c3                   	ret    

f0106126 <__spin_initlock>:
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106126:	f3 0f 1e fb          	endbr32 
f010612a:	55                   	push   %ebp
f010612b:	89 e5                	mov    %esp,%ebp
f010612d:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106136:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106139:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010613c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106143:	5d                   	pop    %ebp
f0106144:	c3                   	ret    

f0106145 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106145:	f3 0f 1e fb          	endbr32 
f0106149:	55                   	push   %ebp
f010614a:	89 e5                	mov    %esp,%ebp
f010614c:	53                   	push   %ebx
f010614d:	83 ec 04             	sub    $0x4,%esp
f0106150:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106153:	89 d8                	mov    %ebx,%eax
f0106155:	e8 9c ff ff ff       	call   f01060f6 <holding>
f010615a:	85 c0                	test   %eax,%eax
f010615c:	74 20                	je     f010617e <spin_lock+0x39>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010615e:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106161:	e8 da fc ff ff       	call   f0105e40 <cpunum>
f0106166:	83 ec 0c             	sub    $0xc,%esp
f0106169:	53                   	push   %ebx
f010616a:	50                   	push   %eax
f010616b:	68 24 82 10 f0       	push   $0xf0108224
f0106170:	6a 41                	push   $0x41
f0106172:	68 86 82 10 f0       	push   $0xf0108286
f0106177:	e8 ee 9e ff ff       	call   f010006a <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f010617c:	f3 90                	pause  
	while (xchg(&lk->locked, 1) != 0)
f010617e:	ba 01 00 00 00       	mov    $0x1,%edx
f0106183:	89 d8                	mov    %ebx,%eax
f0106185:	e8 10 ff ff ff       	call   f010609a <xchg>
f010618a:	85 c0                	test   %eax,%eax
f010618c:	75 ee                	jne    f010617c <spin_lock+0x37>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f010618e:	e8 ad fc ff ff       	call   f0105e40 <cpunum>
f0106193:	6b c0 74             	imul   $0x74,%eax,%eax
f0106196:	05 20 30 22 f0       	add    $0xf0223020,%eax
f010619b:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f010619e:	8d 43 0c             	lea    0xc(%ebx),%eax
f01061a1:	e8 fc fe ff ff       	call   f01060a2 <get_caller_pcs>
#endif
}
f01061a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01061a9:	c9                   	leave  
f01061aa:	c3                   	ret    

f01061ab <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01061ab:	f3 0f 1e fb          	endbr32 
f01061af:	55                   	push   %ebp
f01061b0:	89 e5                	mov    %esp,%ebp
f01061b2:	57                   	push   %edi
f01061b3:	56                   	push   %esi
f01061b4:	53                   	push   %ebx
f01061b5:	83 ec 4c             	sub    $0x4c,%esp
f01061b8:	8b 75 08             	mov    0x8(%ebp),%esi
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f01061bb:	89 f0                	mov    %esi,%eax
f01061bd:	e8 34 ff ff ff       	call   f01060f6 <holding>
f01061c2:	85 c0                	test   %eax,%eax
f01061c4:	74 22                	je     f01061e8 <spin_unlock+0x3d>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f01061c6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f01061cd:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	// The xchg instruction is atomic (i.e. uses the "lock" prefix) with
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
f01061d4:	ba 00 00 00 00       	mov    $0x0,%edx
f01061d9:	89 f0                	mov    %esi,%eax
f01061db:	e8 ba fe ff ff       	call   f010609a <xchg>
}
f01061e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01061e3:	5b                   	pop    %ebx
f01061e4:	5e                   	pop    %esi
f01061e5:	5f                   	pop    %edi
f01061e6:	5d                   	pop    %ebp
f01061e7:	c3                   	ret    
		memmove(pcs, lk->pcs, sizeof pcs);
f01061e8:	83 ec 04             	sub    $0x4,%esp
f01061eb:	6a 28                	push   $0x28
f01061ed:	8d 46 0c             	lea    0xc(%esi),%eax
f01061f0:	50                   	push   %eax
f01061f1:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01061f4:	53                   	push   %ebx
f01061f5:	e8 06 f6 ff ff       	call   f0105800 <memmove>
			cpunum(), lk->name, lk->cpu->cpu_id);
f01061fa:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01061fd:	0f b6 38             	movzbl (%eax),%edi
f0106200:	8b 76 04             	mov    0x4(%esi),%esi
f0106203:	e8 38 fc ff ff       	call   f0105e40 <cpunum>
f0106208:	57                   	push   %edi
f0106209:	56                   	push   %esi
f010620a:	50                   	push   %eax
f010620b:	68 50 82 10 f0       	push   $0xf0108250
f0106210:	e8 a7 d7 ff ff       	call   f01039bc <cprintf>
f0106215:	83 c4 20             	add    $0x20,%esp
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106218:	8d 7d a8             	lea    -0x58(%ebp),%edi
f010621b:	eb 1c                	jmp    f0106239 <spin_unlock+0x8e>
				cprintf("  %08x\n", pcs[i]);
f010621d:	83 ec 08             	sub    $0x8,%esp
f0106220:	ff 36                	pushl  (%esi)
f0106222:	68 ad 82 10 f0       	push   $0xf01082ad
f0106227:	e8 90 d7 ff ff       	call   f01039bc <cprintf>
f010622c:	83 c4 10             	add    $0x10,%esp
f010622f:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106232:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106235:	39 c3                	cmp    %eax,%ebx
f0106237:	74 40                	je     f0106279 <spin_unlock+0xce>
f0106239:	89 de                	mov    %ebx,%esi
f010623b:	8b 03                	mov    (%ebx),%eax
f010623d:	85 c0                	test   %eax,%eax
f010623f:	74 38                	je     f0106279 <spin_unlock+0xce>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106241:	83 ec 08             	sub    $0x8,%esp
f0106244:	57                   	push   %edi
f0106245:	50                   	push   %eax
f0106246:	e8 c9 ea ff ff       	call   f0104d14 <debuginfo_eip>
f010624b:	83 c4 10             	add    $0x10,%esp
f010624e:	85 c0                	test   %eax,%eax
f0106250:	78 cb                	js     f010621d <spin_unlock+0x72>
					pcs[i] - info.eip_fn_addr);
f0106252:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106254:	83 ec 04             	sub    $0x4,%esp
f0106257:	89 c2                	mov    %eax,%edx
f0106259:	2b 55 b8             	sub    -0x48(%ebp),%edx
f010625c:	52                   	push   %edx
f010625d:	ff 75 b0             	pushl  -0x50(%ebp)
f0106260:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106263:	ff 75 ac             	pushl  -0x54(%ebp)
f0106266:	ff 75 a8             	pushl  -0x58(%ebp)
f0106269:	50                   	push   %eax
f010626a:	68 96 82 10 f0       	push   $0xf0108296
f010626f:	e8 48 d7 ff ff       	call   f01039bc <cprintf>
f0106274:	83 c4 20             	add    $0x20,%esp
f0106277:	eb b6                	jmp    f010622f <spin_unlock+0x84>
		panic("spin_unlock");
f0106279:	83 ec 04             	sub    $0x4,%esp
f010627c:	68 b5 82 10 f0       	push   $0xf01082b5
f0106281:	6a 67                	push   $0x67
f0106283:	68 86 82 10 f0       	push   $0xf0108286
f0106288:	e8 dd 9d ff ff       	call   f010006a <_panic>
f010628d:	66 90                	xchg   %ax,%ax
f010628f:	90                   	nop

f0106290 <__udivdi3>:
f0106290:	f3 0f 1e fb          	endbr32 
f0106294:	55                   	push   %ebp
f0106295:	57                   	push   %edi
f0106296:	56                   	push   %esi
f0106297:	53                   	push   %ebx
f0106298:	83 ec 1c             	sub    $0x1c,%esp
f010629b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010629f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01062a3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01062a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01062ab:	85 d2                	test   %edx,%edx
f01062ad:	75 19                	jne    f01062c8 <__udivdi3+0x38>
f01062af:	39 f3                	cmp    %esi,%ebx
f01062b1:	76 4d                	jbe    f0106300 <__udivdi3+0x70>
f01062b3:	31 ff                	xor    %edi,%edi
f01062b5:	89 e8                	mov    %ebp,%eax
f01062b7:	89 f2                	mov    %esi,%edx
f01062b9:	f7 f3                	div    %ebx
f01062bb:	89 fa                	mov    %edi,%edx
f01062bd:	83 c4 1c             	add    $0x1c,%esp
f01062c0:	5b                   	pop    %ebx
f01062c1:	5e                   	pop    %esi
f01062c2:	5f                   	pop    %edi
f01062c3:	5d                   	pop    %ebp
f01062c4:	c3                   	ret    
f01062c5:	8d 76 00             	lea    0x0(%esi),%esi
f01062c8:	39 f2                	cmp    %esi,%edx
f01062ca:	76 14                	jbe    f01062e0 <__udivdi3+0x50>
f01062cc:	31 ff                	xor    %edi,%edi
f01062ce:	31 c0                	xor    %eax,%eax
f01062d0:	89 fa                	mov    %edi,%edx
f01062d2:	83 c4 1c             	add    $0x1c,%esp
f01062d5:	5b                   	pop    %ebx
f01062d6:	5e                   	pop    %esi
f01062d7:	5f                   	pop    %edi
f01062d8:	5d                   	pop    %ebp
f01062d9:	c3                   	ret    
f01062da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01062e0:	0f bd fa             	bsr    %edx,%edi
f01062e3:	83 f7 1f             	xor    $0x1f,%edi
f01062e6:	75 48                	jne    f0106330 <__udivdi3+0xa0>
f01062e8:	39 f2                	cmp    %esi,%edx
f01062ea:	72 06                	jb     f01062f2 <__udivdi3+0x62>
f01062ec:	31 c0                	xor    %eax,%eax
f01062ee:	39 eb                	cmp    %ebp,%ebx
f01062f0:	77 de                	ja     f01062d0 <__udivdi3+0x40>
f01062f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01062f7:	eb d7                	jmp    f01062d0 <__udivdi3+0x40>
f01062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106300:	89 d9                	mov    %ebx,%ecx
f0106302:	85 db                	test   %ebx,%ebx
f0106304:	75 0b                	jne    f0106311 <__udivdi3+0x81>
f0106306:	b8 01 00 00 00       	mov    $0x1,%eax
f010630b:	31 d2                	xor    %edx,%edx
f010630d:	f7 f3                	div    %ebx
f010630f:	89 c1                	mov    %eax,%ecx
f0106311:	31 d2                	xor    %edx,%edx
f0106313:	89 f0                	mov    %esi,%eax
f0106315:	f7 f1                	div    %ecx
f0106317:	89 c6                	mov    %eax,%esi
f0106319:	89 e8                	mov    %ebp,%eax
f010631b:	89 f7                	mov    %esi,%edi
f010631d:	f7 f1                	div    %ecx
f010631f:	89 fa                	mov    %edi,%edx
f0106321:	83 c4 1c             	add    $0x1c,%esp
f0106324:	5b                   	pop    %ebx
f0106325:	5e                   	pop    %esi
f0106326:	5f                   	pop    %edi
f0106327:	5d                   	pop    %ebp
f0106328:	c3                   	ret    
f0106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106330:	89 f9                	mov    %edi,%ecx
f0106332:	b8 20 00 00 00       	mov    $0x20,%eax
f0106337:	29 f8                	sub    %edi,%eax
f0106339:	d3 e2                	shl    %cl,%edx
f010633b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010633f:	89 c1                	mov    %eax,%ecx
f0106341:	89 da                	mov    %ebx,%edx
f0106343:	d3 ea                	shr    %cl,%edx
f0106345:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106349:	09 d1                	or     %edx,%ecx
f010634b:	89 f2                	mov    %esi,%edx
f010634d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106351:	89 f9                	mov    %edi,%ecx
f0106353:	d3 e3                	shl    %cl,%ebx
f0106355:	89 c1                	mov    %eax,%ecx
f0106357:	d3 ea                	shr    %cl,%edx
f0106359:	89 f9                	mov    %edi,%ecx
f010635b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010635f:	89 eb                	mov    %ebp,%ebx
f0106361:	d3 e6                	shl    %cl,%esi
f0106363:	89 c1                	mov    %eax,%ecx
f0106365:	d3 eb                	shr    %cl,%ebx
f0106367:	09 de                	or     %ebx,%esi
f0106369:	89 f0                	mov    %esi,%eax
f010636b:	f7 74 24 08          	divl   0x8(%esp)
f010636f:	89 d6                	mov    %edx,%esi
f0106371:	89 c3                	mov    %eax,%ebx
f0106373:	f7 64 24 0c          	mull   0xc(%esp)
f0106377:	39 d6                	cmp    %edx,%esi
f0106379:	72 15                	jb     f0106390 <__udivdi3+0x100>
f010637b:	89 f9                	mov    %edi,%ecx
f010637d:	d3 e5                	shl    %cl,%ebp
f010637f:	39 c5                	cmp    %eax,%ebp
f0106381:	73 04                	jae    f0106387 <__udivdi3+0xf7>
f0106383:	39 d6                	cmp    %edx,%esi
f0106385:	74 09                	je     f0106390 <__udivdi3+0x100>
f0106387:	89 d8                	mov    %ebx,%eax
f0106389:	31 ff                	xor    %edi,%edi
f010638b:	e9 40 ff ff ff       	jmp    f01062d0 <__udivdi3+0x40>
f0106390:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106393:	31 ff                	xor    %edi,%edi
f0106395:	e9 36 ff ff ff       	jmp    f01062d0 <__udivdi3+0x40>
f010639a:	66 90                	xchg   %ax,%ax
f010639c:	66 90                	xchg   %ax,%ax
f010639e:	66 90                	xchg   %ax,%ax

f01063a0 <__umoddi3>:
f01063a0:	f3 0f 1e fb          	endbr32 
f01063a4:	55                   	push   %ebp
f01063a5:	57                   	push   %edi
f01063a6:	56                   	push   %esi
f01063a7:	53                   	push   %ebx
f01063a8:	83 ec 1c             	sub    $0x1c,%esp
f01063ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01063af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01063b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01063b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01063bb:	85 c0                	test   %eax,%eax
f01063bd:	75 19                	jne    f01063d8 <__umoddi3+0x38>
f01063bf:	39 df                	cmp    %ebx,%edi
f01063c1:	76 5d                	jbe    f0106420 <__umoddi3+0x80>
f01063c3:	89 f0                	mov    %esi,%eax
f01063c5:	89 da                	mov    %ebx,%edx
f01063c7:	f7 f7                	div    %edi
f01063c9:	89 d0                	mov    %edx,%eax
f01063cb:	31 d2                	xor    %edx,%edx
f01063cd:	83 c4 1c             	add    $0x1c,%esp
f01063d0:	5b                   	pop    %ebx
f01063d1:	5e                   	pop    %esi
f01063d2:	5f                   	pop    %edi
f01063d3:	5d                   	pop    %ebp
f01063d4:	c3                   	ret    
f01063d5:	8d 76 00             	lea    0x0(%esi),%esi
f01063d8:	89 f2                	mov    %esi,%edx
f01063da:	39 d8                	cmp    %ebx,%eax
f01063dc:	76 12                	jbe    f01063f0 <__umoddi3+0x50>
f01063de:	89 f0                	mov    %esi,%eax
f01063e0:	89 da                	mov    %ebx,%edx
f01063e2:	83 c4 1c             	add    $0x1c,%esp
f01063e5:	5b                   	pop    %ebx
f01063e6:	5e                   	pop    %esi
f01063e7:	5f                   	pop    %edi
f01063e8:	5d                   	pop    %ebp
f01063e9:	c3                   	ret    
f01063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01063f0:	0f bd e8             	bsr    %eax,%ebp
f01063f3:	83 f5 1f             	xor    $0x1f,%ebp
f01063f6:	75 50                	jne    f0106448 <__umoddi3+0xa8>
f01063f8:	39 d8                	cmp    %ebx,%eax
f01063fa:	0f 82 e0 00 00 00    	jb     f01064e0 <__umoddi3+0x140>
f0106400:	89 d9                	mov    %ebx,%ecx
f0106402:	39 f7                	cmp    %esi,%edi
f0106404:	0f 86 d6 00 00 00    	jbe    f01064e0 <__umoddi3+0x140>
f010640a:	89 d0                	mov    %edx,%eax
f010640c:	89 ca                	mov    %ecx,%edx
f010640e:	83 c4 1c             	add    $0x1c,%esp
f0106411:	5b                   	pop    %ebx
f0106412:	5e                   	pop    %esi
f0106413:	5f                   	pop    %edi
f0106414:	5d                   	pop    %ebp
f0106415:	c3                   	ret    
f0106416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010641d:	8d 76 00             	lea    0x0(%esi),%esi
f0106420:	89 fd                	mov    %edi,%ebp
f0106422:	85 ff                	test   %edi,%edi
f0106424:	75 0b                	jne    f0106431 <__umoddi3+0x91>
f0106426:	b8 01 00 00 00       	mov    $0x1,%eax
f010642b:	31 d2                	xor    %edx,%edx
f010642d:	f7 f7                	div    %edi
f010642f:	89 c5                	mov    %eax,%ebp
f0106431:	89 d8                	mov    %ebx,%eax
f0106433:	31 d2                	xor    %edx,%edx
f0106435:	f7 f5                	div    %ebp
f0106437:	89 f0                	mov    %esi,%eax
f0106439:	f7 f5                	div    %ebp
f010643b:	89 d0                	mov    %edx,%eax
f010643d:	31 d2                	xor    %edx,%edx
f010643f:	eb 8c                	jmp    f01063cd <__umoddi3+0x2d>
f0106441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106448:	89 e9                	mov    %ebp,%ecx
f010644a:	ba 20 00 00 00       	mov    $0x20,%edx
f010644f:	29 ea                	sub    %ebp,%edx
f0106451:	d3 e0                	shl    %cl,%eax
f0106453:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106457:	89 d1                	mov    %edx,%ecx
f0106459:	89 f8                	mov    %edi,%eax
f010645b:	d3 e8                	shr    %cl,%eax
f010645d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106461:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106465:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106469:	09 c1                	or     %eax,%ecx
f010646b:	89 d8                	mov    %ebx,%eax
f010646d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106471:	89 e9                	mov    %ebp,%ecx
f0106473:	d3 e7                	shl    %cl,%edi
f0106475:	89 d1                	mov    %edx,%ecx
f0106477:	d3 e8                	shr    %cl,%eax
f0106479:	89 e9                	mov    %ebp,%ecx
f010647b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010647f:	d3 e3                	shl    %cl,%ebx
f0106481:	89 c7                	mov    %eax,%edi
f0106483:	89 d1                	mov    %edx,%ecx
f0106485:	89 f0                	mov    %esi,%eax
f0106487:	d3 e8                	shr    %cl,%eax
f0106489:	89 e9                	mov    %ebp,%ecx
f010648b:	89 fa                	mov    %edi,%edx
f010648d:	d3 e6                	shl    %cl,%esi
f010648f:	09 d8                	or     %ebx,%eax
f0106491:	f7 74 24 08          	divl   0x8(%esp)
f0106495:	89 d1                	mov    %edx,%ecx
f0106497:	89 f3                	mov    %esi,%ebx
f0106499:	f7 64 24 0c          	mull   0xc(%esp)
f010649d:	89 c6                	mov    %eax,%esi
f010649f:	89 d7                	mov    %edx,%edi
f01064a1:	39 d1                	cmp    %edx,%ecx
f01064a3:	72 06                	jb     f01064ab <__umoddi3+0x10b>
f01064a5:	75 10                	jne    f01064b7 <__umoddi3+0x117>
f01064a7:	39 c3                	cmp    %eax,%ebx
f01064a9:	73 0c                	jae    f01064b7 <__umoddi3+0x117>
f01064ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01064af:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01064b3:	89 d7                	mov    %edx,%edi
f01064b5:	89 c6                	mov    %eax,%esi
f01064b7:	89 ca                	mov    %ecx,%edx
f01064b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01064be:	29 f3                	sub    %esi,%ebx
f01064c0:	19 fa                	sbb    %edi,%edx
f01064c2:	89 d0                	mov    %edx,%eax
f01064c4:	d3 e0                	shl    %cl,%eax
f01064c6:	89 e9                	mov    %ebp,%ecx
f01064c8:	d3 eb                	shr    %cl,%ebx
f01064ca:	d3 ea                	shr    %cl,%edx
f01064cc:	09 d8                	or     %ebx,%eax
f01064ce:	83 c4 1c             	add    $0x1c,%esp
f01064d1:	5b                   	pop    %ebx
f01064d2:	5e                   	pop    %esi
f01064d3:	5f                   	pop    %edi
f01064d4:	5d                   	pop    %ebp
f01064d5:	c3                   	ret    
f01064d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01064dd:	8d 76 00             	lea    0x0(%esi),%esi
f01064e0:	29 fe                	sub    %edi,%esi
f01064e2:	19 c3                	sbb    %eax,%ebx
f01064e4:	89 f2                	mov    %esi,%edx
f01064e6:	89 d9                	mov    %ebx,%ecx
f01064e8:	e9 1d ff ff ff       	jmp    f010640a <__umoddi3+0x6a>
