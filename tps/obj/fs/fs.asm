
obj/fs/fs:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 49 1c 00 00       	call   801c7a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <inb>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800033:	89 c2                	mov    %eax,%edx
  800035:	ec                   	in     (%dx),%al
	return data;
}
  800036:	c3                   	ret    

00800037 <insl>:
	return data;
}

static inline void
insl(int port, void *addr, int cnt)
{
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
	asm volatile("cld\n\trepne\n\tinsl"
  80003b:	89 d7                	mov    %edx,%edi
  80003d:	89 c2                	mov    %eax,%edx
  80003f:	fc                   	cld    
  800040:	f2 6d                	repnz insl (%dx),%es:(%edi)
		     : "=D" (addr), "=c" (cnt)
		     : "d" (port), "0" (addr), "1" (cnt)
		     : "memory", "cc");
}
  800042:	5f                   	pop    %edi
  800043:	5d                   	pop    %ebp
  800044:	c3                   	ret    

00800045 <outb>:

static inline void
outb(int port, uint8_t data)
{
  800045:	89 c1                	mov    %eax,%ecx
  800047:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800049:	89 ca                	mov    %ecx,%edx
  80004b:	ee                   	out    %al,(%dx)
}
  80004c:	c3                   	ret    

0080004d <outsl>:
		     : "cc");
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	56                   	push   %esi
	asm volatile("cld\n\trepne\n\toutsl"
  800051:	89 d6                	mov    %edx,%esi
  800053:	89 c2                	mov    %eax,%edx
  800055:	fc                   	cld    
  800056:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
		     : "=S" (addr), "=c" (cnt)
		     : "d" (port), "0" (addr), "1" (cnt)
		     : "cc");
}
  800058:	5e                   	pop    %esi
  800059:	5d                   	pop    %ebp
  80005a:	c3                   	ret    

0080005b <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  80005b:	55                   	push   %ebp
  80005c:	89 e5                	mov    %esp,%ebp
  80005e:	53                   	push   %ebx
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800064:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  800069:	e8 c5 ff ff ff       	call   800033 <inb>
  80006e:	89 c2                	mov    %eax,%edx
  800070:	83 e2 c0             	and    $0xffffffc0,%edx
  800073:	80 fa 40             	cmp    $0x40,%dl
  800076:	75 ec                	jne    800064 <ide_wait_ready+0x9>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800078:	ba 00 00 00 00       	mov    $0x0,%edx
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80007d:	84 db                	test   %bl,%bl
  80007f:	74 0a                	je     80008b <ide_wait_ready+0x30>
  800081:	a8 21                	test   $0x21,%al
  800083:	0f 95 c2             	setne  %dl
  800086:	0f b6 d2             	movzbl %dl,%edx
  800089:	f7 da                	neg    %edx
}
  80008b:	89 d0                	mov    %edx,%eax
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	5b                   	pop    %ebx
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800093:	f3 0f 1e fb          	endbr32 
  800097:	55                   	push   %ebp
  800098:	89 e5                	mov    %esp,%ebp
  80009a:	53                   	push   %ebx
  80009b:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a3:	e8 b3 ff ff ff       	call   80005b <ide_wait_ready>

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));
  8000a8:	ba f0 00 00 00       	mov    $0xf0,%edx
  8000ad:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8000b2:	e8 8e ff ff ff       	call   800045 <outb>

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000b7:	bb 00 00 00 00       	mov    $0x0,%ebx
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000bc:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8000c1:	e8 6d ff ff ff       	call   800033 <inb>
  8000c6:	a8 a1                	test   $0xa1,%al
  8000c8:	74 0b                	je     8000d5 <ide_probe_disk1+0x42>
	     x++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
	for (x = 0;
  8000cd:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  8000d3:	75 e7                	jne    8000bc <ide_probe_disk1+0x29>
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));
  8000d5:	ba e0 00 00 00       	mov    $0xe0,%edx
  8000da:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8000df:	e8 61 ff ff ff       	call   800045 <outb>

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000e4:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000ea:	0f 9e c3             	setle  %bl
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	0f b6 c3             	movzbl %bl,%eax
  8000f3:	50                   	push   %eax
  8000f4:	68 e0 3a 80 00       	push   $0x803ae0
  8000f9:	e8 cf 1c 00 00       	call   801dcd <cprintf>
	return (x < 1000);
}
  8000fe:	89 d8                	mov    %ebx,%eax
  800100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800105:	f3 0f 1e fb          	endbr32 
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  800112:	83 f8 01             	cmp    $0x1,%eax
  800115:	77 07                	ja     80011e <ide_set_disk+0x19>
		panic("bad disk number");
	diskno = d;
  800117:	a3 00 50 80 00       	mov    %eax,0x805000
}
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    
		panic("bad disk number");
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	68 f7 3a 80 00       	push   $0x803af7
  800126:	6a 3a                	push   $0x3a
  800128:	68 07 3b 80 00       	push   $0x803b07
  80012d:	e8 b4 1b 00 00       	call   801ce6 <_panic>

00800132 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800132:	f3 0f 1e fb          	endbr32 
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800145:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800148:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80014e:	0f 87 84 00 00 00    	ja     8001d8 <ide_read+0xa6>

	ide_wait_ready(0);
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	e8 fd fe ff ff       	call   80005b <ide_wait_ready>

	outb(0x1F2, nsecs);
  80015e:	89 f0                	mov    %esi,%eax
  800160:	0f b6 d0             	movzbl %al,%edx
  800163:	b8 f2 01 00 00       	mov    $0x1f2,%eax
  800168:	e8 d8 fe ff ff       	call   800045 <outb>
	outb(0x1F3, secno & 0xFF);
  80016d:	89 f8                	mov    %edi,%eax
  80016f:	0f b6 d0             	movzbl %al,%edx
  800172:	b8 f3 01 00 00       	mov    $0x1f3,%eax
  800177:	e8 c9 fe ff ff       	call   800045 <outb>
	outb(0x1F4, (secno >> 8) & 0xFF);
  80017c:	89 f8                	mov    %edi,%eax
  80017e:	0f b6 d4             	movzbl %ah,%edx
  800181:	b8 f4 01 00 00       	mov    $0x1f4,%eax
  800186:	e8 ba fe ff ff       	call   800045 <outb>
	outb(0x1F5, (secno >> 16) & 0xFF);
  80018b:	89 fa                	mov    %edi,%edx
  80018d:	c1 ea 10             	shr    $0x10,%edx
  800190:	0f b6 d2             	movzbl %dl,%edx
  800193:	b8 f5 01 00 00       	mov    $0x1f5,%eax
  800198:	e8 a8 fe ff ff       	call   800045 <outb>
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80019d:	0f b6 15 00 50 80 00 	movzbl 0x805000,%edx
  8001a4:	c1 e2 04             	shl    $0x4,%edx
  8001a7:	83 e2 10             	and    $0x10,%edx
  8001aa:	c1 ef 18             	shr    $0x18,%edi
  8001ad:	83 e7 0f             	and    $0xf,%edi
  8001b0:	09 fa                	or     %edi,%edx
  8001b2:	83 ca e0             	or     $0xffffffe0,%edx
  8001b5:	0f b6 d2             	movzbl %dl,%edx
  8001b8:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8001bd:	e8 83 fe ff ff       	call   800045 <outb>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector
  8001c2:	ba 20 00 00 00       	mov    $0x20,%edx
  8001c7:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8001cc:	e8 74 fe ff ff       	call   800045 <outb>
  8001d1:	c1 e6 09             	shl    $0x9,%esi
  8001d4:	01 de                	add    %ebx,%esi

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001d6:	eb 2d                	jmp    800205 <ide_read+0xd3>
	assert(nsecs <= 256);
  8001d8:	68 10 3b 80 00       	push   $0x803b10
  8001dd:	68 1d 3b 80 00       	push   $0x803b1d
  8001e2:	6a 44                	push   $0x44
  8001e4:	68 07 3b 80 00       	push   $0x803b07
  8001e9:	e8 f8 1a 00 00       	call   801ce6 <_panic>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
  8001ee:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001f3:	89 da                	mov    %ebx,%edx
  8001f5:	b8 f0 01 00 00       	mov    $0x1f0,%eax
  8001fa:	e8 38 fe ff ff       	call   800037 <insl>
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001ff:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800205:	39 f3                	cmp    %esi,%ebx
  800207:	74 10                	je     800219 <ide_read+0xe7>
		if ((r = ide_wait_ready(1)) < 0)
  800209:	b8 01 00 00 00       	mov    $0x1,%eax
  80020e:	e8 48 fe ff ff       	call   80005b <ide_wait_ready>
  800213:	85 c0                	test   %eax,%eax
  800215:	79 d7                	jns    8001ee <ide_read+0xbc>
  800217:	eb 05                	jmp    80021e <ide_read+0xec>
	}

	return 0;
  800219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80021e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5f                   	pop    %edi
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    

00800226 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800226:	f3 0f 1e fb          	endbr32 
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	8b 7d 08             	mov    0x8(%ebp),%edi
  800236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800239:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  80023c:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800242:	0f 87 84 00 00 00    	ja     8002cc <ide_write+0xa6>

	ide_wait_ready(0);
  800248:	b8 00 00 00 00       	mov    $0x0,%eax
  80024d:	e8 09 fe ff ff       	call   80005b <ide_wait_ready>

	outb(0x1F2, nsecs);
  800252:	89 f0                	mov    %esi,%eax
  800254:	0f b6 d0             	movzbl %al,%edx
  800257:	b8 f2 01 00 00       	mov    $0x1f2,%eax
  80025c:	e8 e4 fd ff ff       	call   800045 <outb>
	outb(0x1F3, secno & 0xFF);
  800261:	89 f8                	mov    %edi,%eax
  800263:	0f b6 d0             	movzbl %al,%edx
  800266:	b8 f3 01 00 00       	mov    $0x1f3,%eax
  80026b:	e8 d5 fd ff ff       	call   800045 <outb>
	outb(0x1F4, (secno >> 8) & 0xFF);
  800270:	89 f8                	mov    %edi,%eax
  800272:	0f b6 d4             	movzbl %ah,%edx
  800275:	b8 f4 01 00 00       	mov    $0x1f4,%eax
  80027a:	e8 c6 fd ff ff       	call   800045 <outb>
	outb(0x1F5, (secno >> 16) & 0xFF);
  80027f:	89 fa                	mov    %edi,%edx
  800281:	c1 ea 10             	shr    $0x10,%edx
  800284:	0f b6 d2             	movzbl %dl,%edx
  800287:	b8 f5 01 00 00       	mov    $0x1f5,%eax
  80028c:	e8 b4 fd ff ff       	call   800045 <outb>
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800291:	0f b6 15 00 50 80 00 	movzbl 0x805000,%edx
  800298:	c1 e2 04             	shl    $0x4,%edx
  80029b:	83 e2 10             	and    $0x10,%edx
  80029e:	c1 ef 18             	shr    $0x18,%edi
  8002a1:	83 e7 0f             	and    $0xf,%edi
  8002a4:	09 fa                	or     %edi,%edx
  8002a6:	83 ca e0             	or     $0xffffffe0,%edx
  8002a9:	0f b6 d2             	movzbl %dl,%edx
  8002ac:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8002b1:	e8 8f fd ff ff       	call   800045 <outb>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector
  8002b6:	ba 30 00 00 00       	mov    $0x30,%edx
  8002bb:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8002c0:	e8 80 fd ff ff       	call   800045 <outb>
  8002c5:	c1 e6 09             	shl    $0x9,%esi
  8002c8:	01 de                	add    %ebx,%esi

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002ca:	eb 2d                	jmp    8002f9 <ide_write+0xd3>
	assert(nsecs <= 256);
  8002cc:	68 10 3b 80 00       	push   $0x803b10
  8002d1:	68 1d 3b 80 00       	push   $0x803b1d
  8002d6:	6a 5d                	push   $0x5d
  8002d8:	68 07 3b 80 00       	push   $0x803b07
  8002dd:	e8 04 1a 00 00       	call   801ce6 <_panic>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
  8002e2:	b9 80 00 00 00       	mov    $0x80,%ecx
  8002e7:	89 da                	mov    %ebx,%edx
  8002e9:	b8 f0 01 00 00       	mov    $0x1f0,%eax
  8002ee:	e8 5a fd ff ff       	call   80004d <outsl>
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002f3:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8002f9:	39 f3                	cmp    %esi,%ebx
  8002fb:	74 10                	je     80030d <ide_write+0xe7>
		if ((r = ide_wait_ready(1)) < 0)
  8002fd:	b8 01 00 00 00       	mov    $0x1,%eax
  800302:	e8 54 fd ff ff       	call   80005b <ide_wait_ready>
  800307:	85 c0                	test   %eax,%eax
  800309:	79 d7                	jns    8002e2 <ide_write+0xbc>
  80030b:	eb 05                	jmp    800312 <ide_write+0xec>
	}

	return 0;
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80031a:	f3 0f 1e fb          	endbr32 
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800326:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t) addr - DISKMAP) / BLKSIZE;
  800328:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80032e:	89 c6                	mov    %eax,%esi
  800330:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void *) DISKMAP || addr >= (void *) (DISKMAP + DISKSIZE))
  800333:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800338:	0f 87 95 00 00 00    	ja     8003d3 <bc_pgfault+0xb9>
		      utf->utf_eip,
		      addr,
		      utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80033e:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800343:	85 c0                	test   %eax,%eax
  800345:	74 09                	je     800350 <bc_pgfault+0x36>
  800347:	39 70 04             	cmp    %esi,0x4(%eax)
  80034a:	0f 86 9e 00 00 00    	jbe    8003ee <bc_pgfault+0xd4>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  800350:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	r = sys_page_alloc(0, addr, PTE_W | PTE_U | PTE_P);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 07                	push   $0x7
  80035b:	53                   	push   %ebx
  80035c:	6a 00                	push   $0x0
  80035e:	e8 5c 24 00 00       	call   8027bf <sys_page_alloc>
	if (r < 0)
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	85 c0                	test   %eax,%eax
  800368:	0f 88 92 00 00 00    	js     800400 <bc_pgfault+0xe6>
		panic("[error] bc_pgfault: sys_page_alloc  %e", r);

	r = ide_read(blockno * BLKSECTS, addr, BLKSECTS);
  80036e:	83 ec 04             	sub    $0x4,%esp
  800371:	6a 08                	push   $0x8
  800373:	53                   	push   %ebx
  800374:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  80037b:	50                   	push   %eax
  80037c:	e8 b1 fd ff ff       	call   800132 <ide_read>
	if (r < 0)
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	85 c0                	test   %eax,%eax
  800386:	0f 88 86 00 00 00    	js     800412 <bc_pgfault+0xf8>
		panic("[error] bc_pgfault ide_read %e", r);


	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) <
  80038c:	89 d8                	mov    %ebx,%eax
  80038e:	c1 e8 0c             	shr    $0xc,%eax
  800391:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	25 07 0e 00 00       	and    $0xe07,%eax
  8003a0:	50                   	push   %eax
  8003a1:	53                   	push   %ebx
  8003a2:	6a 00                	push   $0x0
  8003a4:	53                   	push   %ebx
  8003a5:	6a 00                	push   $0x0
  8003a7:	e8 3b 24 00 00       	call   8027e7 <sys_page_map>
  8003ac:	83 c4 20             	add    $0x20,%esp
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 71                	js     800424 <bc_pgfault+0x10a>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003b3:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  8003ba:	74 10                	je     8003cc <bc_pgfault+0xb2>
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	56                   	push   %esi
  8003c0:	e8 3a 05 00 00       	call   8008ff <block_is_free>
  8003c5:	83 c4 10             	add    $0x10,%esp
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 6a                	jne    800436 <bc_pgfault+0x11c>
		panic("reading free block %08x\n", blockno);
}
  8003cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	ff 72 04             	pushl  0x4(%edx)
  8003d9:	53                   	push   %ebx
  8003da:	ff 72 28             	pushl  0x28(%edx)
  8003dd:	68 34 3b 80 00       	push   $0x803b34
  8003e2:	6a 26                	push   $0x26
  8003e4:	68 8c 3c 80 00       	push   $0x803c8c
  8003e9:	e8 f8 18 00 00       	call   801ce6 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  8003ee:	56                   	push   %esi
  8003ef:	68 64 3b 80 00       	push   $0x803b64
  8003f4:	6a 2d                	push   $0x2d
  8003f6:	68 8c 3c 80 00       	push   $0x803c8c
  8003fb:	e8 e6 18 00 00       	call   801ce6 <_panic>
		panic("[error] bc_pgfault: sys_page_alloc  %e", r);
  800400:	50                   	push   %eax
  800401:	68 88 3b 80 00       	push   $0x803b88
  800406:	6a 39                	push   $0x39
  800408:	68 8c 3c 80 00       	push   $0x803c8c
  80040d:	e8 d4 18 00 00       	call   801ce6 <_panic>
		panic("[error] bc_pgfault ide_read %e", r);
  800412:	50                   	push   %eax
  800413:	68 b0 3b 80 00       	push   $0x803bb0
  800418:	6a 3d                	push   $0x3d
  80041a:	68 8c 3c 80 00       	push   $0x803c8c
  80041f:	e8 c2 18 00 00       	call   801ce6 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800424:	50                   	push   %eax
  800425:	68 d0 3b 80 00       	push   $0x803bd0
  80042a:	6a 44                	push   $0x44
  80042c:	68 8c 3c 80 00       	push   $0x803c8c
  800431:	e8 b0 18 00 00       	call   801ce6 <_panic>
		panic("reading free block %08x\n", blockno);
  800436:	56                   	push   %esi
  800437:	68 94 3c 80 00       	push   $0x803c94
  80043c:	6a 4a                	push   $0x4a
  80043e:	68 8c 3c 80 00       	push   $0x803c8c
  800443:	e8 9e 18 00 00       	call   801ce6 <_panic>

00800448 <diskaddr>:
{
  800448:	f3 0f 1e fb          	endbr32 
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800455:	85 c0                	test   %eax,%eax
  800457:	74 19                	je     800472 <diskaddr+0x2a>
  800459:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80045f:	85 d2                	test   %edx,%edx
  800461:	74 05                	je     800468 <diskaddr+0x20>
  800463:	39 42 04             	cmp    %eax,0x4(%edx)
  800466:	76 0a                	jbe    800472 <diskaddr+0x2a>
	return (char *) (DISKMAP + blockno * BLKSIZE);
  800468:	05 00 00 01 00       	add    $0x10000,%eax
  80046d:	c1 e0 0c             	shl    $0xc,%eax
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  800472:	50                   	push   %eax
  800473:	68 f0 3b 80 00       	push   $0x803bf0
  800478:	6a 09                	push   $0x9
  80047a:	68 8c 3c 80 00       	push   $0x803c8c
  80047f:	e8 62 18 00 00       	call   801ce6 <_panic>

00800484 <va_is_mapped>:
{
  800484:	f3 0f 1e fb          	endbr32 
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80048e:	89 d0                	mov    %edx,%eax
  800490:	c1 e8 16             	shr    $0x16,%eax
  800493:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80049a:	b8 00 00 00 00       	mov    $0x0,%eax
  80049f:	f6 c1 01             	test   $0x1,%cl
  8004a2:	74 0d                	je     8004b1 <va_is_mapped+0x2d>
  8004a4:	c1 ea 0c             	shr    $0xc,%edx
  8004a7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8004ae:	83 e0 01             	and    $0x1,%eax
  8004b1:	83 e0 01             	and    $0x1,%eax
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <va_is_dirty>:
{
  8004b6:	f3 0f 1e fb          	endbr32 
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	c1 e8 0c             	shr    $0xc,%eax
  8004c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004ca:	c1 e8 06             	shr    $0x6,%eax
  8004cd:	83 e0 01             	and    $0x1,%eax
}
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    

008004d2 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8004d2:	f3 0f 1e fb          	endbr32 
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t) addr - DISKMAP) / BLKSIZE;
  8004de:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi
	int r;

	if (addr < (void *) DISKMAP || addr >= (void *) (DISKMAP + DISKSIZE))
  8004e4:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  8004ea:	77 1d                	ja     800509 <flush_block+0x37>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.

	addr = ROUNDDOWN(addr, BLKSIZE);
  8004ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	53                   	push   %ebx
  8004f6:	e8 89 ff ff ff       	call   800484 <va_is_mapped>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	84 c0                	test   %al,%al
  800500:	75 19                	jne    80051b <flush_block+0x49>
		panic("[error] flush_block: ide_write failed %e", r);

	r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL);
	if (r)
		panic("[error] flush_block: sys_page_map: %e", r);
}
  800502:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800505:	5b                   	pop    %ebx
  800506:	5e                   	pop    %esi
  800507:	5d                   	pop    %ebp
  800508:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800509:	53                   	push   %ebx
  80050a:	68 ad 3c 80 00       	push   $0x803cad
  80050f:	6a 5b                	push   $0x5b
  800511:	68 8c 3c 80 00       	push   $0x803c8c
  800516:	e8 cb 17 00 00       	call   801ce6 <_panic>
	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  80051b:	83 ec 0c             	sub    $0xc,%esp
  80051e:	53                   	push   %ebx
  80051f:	e8 92 ff ff ff       	call   8004b6 <va_is_dirty>
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	84 c0                	test   %al,%al
  800529:	74 d7                	je     800502 <flush_block+0x30>
	r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	6a 08                	push   $0x8
  800530:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t) addr - DISKMAP) / BLKSIZE;
  800531:	c1 ee 0c             	shr    $0xc,%esi
	r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800534:	c1 e6 03             	shl    $0x3,%esi
  800537:	56                   	push   %esi
  800538:	e8 e9 fc ff ff       	call   800226 <ide_write>
	if (r)
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	85 c0                	test   %eax,%eax
  800542:	75 39                	jne    80057d <flush_block+0xab>
	r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL);
  800544:	89 d8                	mov    %ebx,%eax
  800546:	c1 e8 0c             	shr    $0xc,%eax
  800549:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	25 07 0e 00 00       	and    $0xe07,%eax
  800558:	50                   	push   %eax
  800559:	53                   	push   %ebx
  80055a:	6a 00                	push   $0x0
  80055c:	53                   	push   %ebx
  80055d:	6a 00                	push   $0x0
  80055f:	e8 83 22 00 00       	call   8027e7 <sys_page_map>
	if (r)
  800564:	83 c4 20             	add    $0x20,%esp
  800567:	85 c0                	test   %eax,%eax
  800569:	74 97                	je     800502 <flush_block+0x30>
		panic("[error] flush_block: sys_page_map: %e", r);
  80056b:	50                   	push   %eax
  80056c:	68 40 3c 80 00       	push   $0x803c40
  800571:	6a 69                	push   $0x69
  800573:	68 8c 3c 80 00       	push   $0x803c8c
  800578:	e8 69 17 00 00       	call   801ce6 <_panic>
		panic("[error] flush_block: ide_write failed %e", r);
  80057d:	50                   	push   %eax
  80057e:	68 14 3c 80 00       	push   $0x803c14
  800583:	6a 65                	push   $0x65
  800585:	68 8c 3c 80 00       	push   $0x803c8c
  80058a:	e8 57 17 00 00       	call   801ce6 <_panic>

0080058f <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	81 ec 20 01 00 00    	sub    $0x120,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800599:	6a 01                	push   $0x1
  80059b:	e8 a8 fe ff ff       	call   800448 <diskaddr>
  8005a0:	83 c4 0c             	add    $0xc,%esp
  8005a3:	68 08 01 00 00       	push   $0x108
  8005a8:	50                   	push   %eax
  8005a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005af:	50                   	push   %eax
  8005b0:	e8 3a 1f 00 00       	call   8024ef <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8005b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005bc:	e8 87 fe ff ff       	call   800448 <diskaddr>
  8005c1:	83 c4 08             	add    $0x8,%esp
  8005c4:	68 c8 3c 80 00       	push   $0x803cc8
  8005c9:	50                   	push   %eax
  8005ca:	e8 68 1d 00 00       	call   802337 <strcpy>
	flush_block(diskaddr(1));
  8005cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d6:	e8 6d fe ff ff       	call   800448 <diskaddr>
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 ef fe ff ff       	call   8004d2 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8005e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005ea:	e8 59 fe ff ff       	call   800448 <diskaddr>
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	e8 8d fe ff ff       	call   800484 <va_is_mapped>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	84 c0                	test   %al,%al
  8005fc:	0f 84 b0 01 00 00    	je     8007b2 <check_bc+0x223>
	assert(!va_is_dirty(diskaddr(1)));
  800602:	83 ec 0c             	sub    $0xc,%esp
  800605:	6a 01                	push   $0x1
  800607:	e8 3c fe ff ff       	call   800448 <diskaddr>
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	e8 a2 fe ff ff       	call   8004b6 <va_is_dirty>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	84 c0                	test   %al,%al
  800619:	0f 85 a9 01 00 00    	jne    8007c8 <check_bc+0x239>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  80061f:	83 ec 0c             	sub    $0xc,%esp
  800622:	6a 01                	push   $0x1
  800624:	e8 1f fe ff ff       	call   800448 <diskaddr>
  800629:	83 c4 08             	add    $0x8,%esp
  80062c:	50                   	push   %eax
  80062d:	6a 00                	push   $0x0
  80062f:	e8 dd 21 00 00       	call   802811 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80063b:	e8 08 fe ff ff       	call   800448 <diskaddr>
  800640:	89 04 24             	mov    %eax,(%esp)
  800643:	e8 3c fe ff ff       	call   800484 <va_is_mapped>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	84 c0                	test   %al,%al
  80064d:	0f 85 8b 01 00 00    	jne    8007de <check_bc+0x24f>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	6a 01                	push   $0x1
  800658:	e8 eb fd ff ff       	call   800448 <diskaddr>
  80065d:	83 c4 08             	add    $0x8,%esp
  800660:	68 c8 3c 80 00       	push   $0x803cc8
  800665:	50                   	push   %eax
  800666:	e8 8b 1d 00 00       	call   8023f6 <strcmp>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	85 c0                	test   %eax,%eax
  800670:	0f 85 7e 01 00 00    	jne    8007f4 <check_bc+0x265>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	6a 01                	push   $0x1
  80067b:	e8 c8 fd ff ff       	call   800448 <diskaddr>
  800680:	83 c4 0c             	add    $0xc,%esp
  800683:	68 08 01 00 00       	push   $0x108
  800688:	8d 9d f0 fe ff ff    	lea    -0x110(%ebp),%ebx
  80068e:	53                   	push   %ebx
  80068f:	50                   	push   %eax
  800690:	e8 5a 1e 00 00       	call   8024ef <memmove>
	flush_block(diskaddr(1));
  800695:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80069c:	e8 a7 fd ff ff       	call   800448 <diskaddr>
  8006a1:	89 04 24             	mov    %eax,(%esp)
  8006a4:	e8 29 fe ff ff       	call   8004d2 <flush_block>

	// Now repeat the same experiment, but pass an unaligned address to
	// flush_block.

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8006a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b0:	e8 93 fd ff ff       	call   800448 <diskaddr>
  8006b5:	83 c4 0c             	add    $0xc,%esp
  8006b8:	68 08 01 00 00       	push   $0x108
  8006bd:	50                   	push   %eax
  8006be:	53                   	push   %ebx
  8006bf:	e8 2b 1e 00 00       	call   8024ef <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8006c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006cb:	e8 78 fd ff ff       	call   800448 <diskaddr>
  8006d0:	83 c4 08             	add    $0x8,%esp
  8006d3:	68 c8 3c 80 00       	push   $0x803cc8
  8006d8:	50                   	push   %eax
  8006d9:	e8 59 1c 00 00       	call   802337 <strcpy>

	// Pass an unaligned address to flush_block.
	flush_block(diskaddr(1) + 20);
  8006de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006e5:	e8 5e fd ff ff       	call   800448 <diskaddr>
  8006ea:	83 c0 14             	add    $0x14,%eax
  8006ed:	89 04 24             	mov    %eax,(%esp)
  8006f0:	e8 dd fd ff ff       	call   8004d2 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8006f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006fc:	e8 47 fd ff ff       	call   800448 <diskaddr>
  800701:	89 04 24             	mov    %eax,(%esp)
  800704:	e8 7b fd ff ff       	call   800484 <va_is_mapped>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	84 c0                	test   %al,%al
  80070e:	0f 84 f9 00 00 00    	je     80080d <check_bc+0x27e>
	// Skip the !va_is_dirty() check because it makes the bug somewhat
	// obscure and hence harder to debug.
	// assert(!va_is_dirty(diskaddr(1)));

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	6a 01                	push   $0x1
  800719:	e8 2a fd ff ff       	call   800448 <diskaddr>
  80071e:	83 c4 08             	add    $0x8,%esp
  800721:	50                   	push   %eax
  800722:	6a 00                	push   $0x0
  800724:	e8 e8 20 00 00       	call   802811 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800729:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800730:	e8 13 fd ff ff       	call   800448 <diskaddr>
  800735:	89 04 24             	mov    %eax,(%esp)
  800738:	e8 47 fd ff ff       	call   800484 <va_is_mapped>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	84 c0                	test   %al,%al
  800742:	0f 85 de 00 00 00    	jne    800826 <check_bc+0x297>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800748:	83 ec 0c             	sub    $0xc,%esp
  80074b:	6a 01                	push   $0x1
  80074d:	e8 f6 fc ff ff       	call   800448 <diskaddr>
  800752:	83 c4 08             	add    $0x8,%esp
  800755:	68 c8 3c 80 00       	push   $0x803cc8
  80075a:	50                   	push   %eax
  80075b:	e8 96 1c 00 00       	call   8023f6 <strcmp>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	85 c0                	test   %eax,%eax
  800765:	0f 85 d4 00 00 00    	jne    80083f <check_bc+0x2b0>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	6a 01                	push   $0x1
  800770:	e8 d3 fc ff ff       	call   800448 <diskaddr>
  800775:	83 c4 0c             	add    $0xc,%esp
  800778:	68 08 01 00 00       	push   $0x108
  80077d:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800783:	52                   	push   %edx
  800784:	50                   	push   %eax
  800785:	e8 65 1d 00 00       	call   8024ef <memmove>
	flush_block(diskaddr(1));
  80078a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800791:	e8 b2 fc ff ff       	call   800448 <diskaddr>
  800796:	89 04 24             	mov    %eax,(%esp)
  800799:	e8 34 fd ff ff       	call   8004d2 <flush_block>

	cprintf("block cache is good\n");
  80079e:	c7 04 24 04 3d 80 00 	movl   $0x803d04,(%esp)
  8007a5:	e8 23 16 00 00       	call   801dcd <cprintf>
}
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  8007b2:	68 ea 3c 80 00       	push   $0x803cea
  8007b7:	68 1d 3b 80 00       	push   $0x803b1d
  8007bc:	6a 79                	push   $0x79
  8007be:	68 8c 3c 80 00       	push   $0x803c8c
  8007c3:	e8 1e 15 00 00       	call   801ce6 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  8007c8:	68 cf 3c 80 00       	push   $0x803ccf
  8007cd:	68 1d 3b 80 00       	push   $0x803b1d
  8007d2:	6a 7a                	push   $0x7a
  8007d4:	68 8c 3c 80 00       	push   $0x803c8c
  8007d9:	e8 08 15 00 00       	call   801ce6 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007de:	68 e9 3c 80 00       	push   $0x803ce9
  8007e3:	68 1d 3b 80 00       	push   $0x803b1d
  8007e8:	6a 7e                	push   $0x7e
  8007ea:	68 8c 3c 80 00       	push   $0x803c8c
  8007ef:	e8 f2 14 00 00       	call   801ce6 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007f4:	68 68 3c 80 00       	push   $0x803c68
  8007f9:	68 1d 3b 80 00       	push   $0x803b1d
  8007fe:	68 81 00 00 00       	push   $0x81
  800803:	68 8c 3c 80 00       	push   $0x803c8c
  800808:	e8 d9 14 00 00       	call   801ce6 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  80080d:	68 ea 3c 80 00       	push   $0x803cea
  800812:	68 1d 3b 80 00       	push   $0x803b1d
  800817:	68 92 00 00 00       	push   $0x92
  80081c:	68 8c 3c 80 00       	push   $0x803c8c
  800821:	e8 c0 14 00 00       	call   801ce6 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800826:	68 e9 3c 80 00       	push   $0x803ce9
  80082b:	68 1d 3b 80 00       	push   $0x803b1d
  800830:	68 9a 00 00 00       	push   $0x9a
  800835:	68 8c 3c 80 00       	push   $0x803c8c
  80083a:	e8 a7 14 00 00       	call   801ce6 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80083f:	68 68 3c 80 00       	push   $0x803c68
  800844:	68 1d 3b 80 00       	push   $0x803b1d
  800849:	68 9d 00 00 00       	push   $0x9d
  80084e:	68 8c 3c 80 00       	push   $0x803c8c
  800853:	e8 8e 14 00 00       	call   801ce6 <_panic>

00800858 <bc_init>:

void
bc_init(void)
{
  800858:	f3 0f 1e fb          	endbr32 
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	81 ec 24 01 00 00    	sub    $0x124,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800865:	68 1a 03 80 00       	push   $0x80031a
  80086a:	e8 8d 20 00 00       	call   8028fc <set_pgfault_handler>
	check_bc();
  80086f:	e8 1b fd ff ff       	call   80058f <check_bc>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800874:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80087b:	e8 c8 fb ff ff       	call   800448 <diskaddr>
  800880:	83 c4 0c             	add    $0xc,%esp
  800883:	68 08 01 00 00       	push   $0x108
  800888:	50                   	push   %eax
  800889:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80088f:	50                   	push   %eax
  800890:	e8 5a 1c 00 00       	call   8024ef <memmove>
}
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <skip_slash>:

// Skip over slashes.
static const char *
skip_slash(const char *p)
{
	while (*p == '/')
  80089a:	80 38 2f             	cmpb   $0x2f,(%eax)
  80089d:	75 05                	jne    8008a4 <skip_slash+0xa>
		p++;
  80089f:	83 c0 01             	add    $0x1,%eax
  8008a2:	eb f6                	jmp    80089a <skip_slash>
	return p;
}
  8008a4:	c3                   	ret    

008008a5 <check_super>:
{
  8008a5:	f3 0f 1e fb          	endbr32 
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8008af:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8008b4:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8008ba:	75 1b                	jne    8008d7 <check_super+0x32>
	if (super->s_nblocks > DISKSIZE / BLKSIZE)
  8008bc:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8008c3:	77 26                	ja     8008eb <check_super+0x46>
	cprintf("superblock is good\n");
  8008c5:	83 ec 0c             	sub    $0xc,%esp
  8008c8:	68 57 3d 80 00       	push   $0x803d57
  8008cd:	e8 fb 14 00 00       	call   801dcd <cprintf>
}
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    
		panic("bad file system magic number");
  8008d7:	83 ec 04             	sub    $0x4,%esp
  8008da:	68 19 3d 80 00       	push   $0x803d19
  8008df:	6a 12                	push   $0x12
  8008e1:	68 36 3d 80 00       	push   $0x803d36
  8008e6:	e8 fb 13 00 00       	call   801ce6 <_panic>
		panic("file system is too large");
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	68 3e 3d 80 00       	push   $0x803d3e
  8008f3:	6a 15                	push   $0x15
  8008f5:	68 36 3d 80 00       	push   $0x803d36
  8008fa:	e8 e7 13 00 00       	call   801ce6 <_panic>

008008ff <block_is_free>:
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  80090a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80090f:	85 c0                	test   %eax,%eax
  800911:	74 27                	je     80093a <block_is_free+0x3b>
		return 0;
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800918:	39 48 04             	cmp    %ecx,0x4(%eax)
  80091b:	76 18                	jbe    800935 <block_is_free+0x36>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80091d:	89 cb                	mov    %ecx,%ebx
  80091f:	c1 eb 05             	shr    $0x5,%ebx
  800922:	b8 01 00 00 00       	mov    $0x1,%eax
  800927:	d3 e0                	shl    %cl,%eax
  800929:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80092f:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800932:	0f 95 c2             	setne  %dl
}
  800935:	89 d0                	mov    %edx,%eax
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    
		return 0;
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	eb f4                	jmp    800935 <block_is_free+0x36>

00800941 <free_block>:
{
  800941:	f3 0f 1e fb          	endbr32 
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	53                   	push   %ebx
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (blockno == 0)
  80094f:	85 c9                	test   %ecx,%ecx
  800951:	74 1a                	je     80096d <free_block+0x2c>
	bitmap[blockno / 32] |= 1 << (blockno % 32);
  800953:	89 cb                	mov    %ecx,%ebx
  800955:	c1 eb 05             	shr    $0x5,%ebx
  800958:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80095e:	b8 01 00 00 00       	mov    $0x1,%eax
  800963:	d3 e0                	shl    %cl,%eax
  800965:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    
		panic("attempt to free zero block");
  80096d:	83 ec 04             	sub    $0x4,%esp
  800970:	68 6b 3d 80 00       	push   $0x803d6b
  800975:	6a 30                	push   $0x30
  800977:	68 36 3d 80 00       	push   $0x803d36
  80097c:	e8 65 13 00 00       	call   801ce6 <_panic>

00800981 <alloc_block>:
{
  800981:	f3 0f 1e fb          	endbr32 
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
	for (int i = 0; i < super->s_nblocks; i++) {
  80098a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80098f:	8b 70 04             	mov    0x4(%eax),%esi
  800992:	bb 00 00 00 00       	mov    $0x0,%ebx
  800997:	39 f3                	cmp    %esi,%ebx
  800999:	74 53                	je     8009ee <alloc_block+0x6d>
		if (block_is_free(i)) {
  80099b:	83 ec 0c             	sub    $0xc,%esp
  80099e:	53                   	push   %ebx
  80099f:	e8 5b ff ff ff       	call   8008ff <block_is_free>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	84 c0                	test   %al,%al
  8009a9:	75 05                	jne    8009b0 <alloc_block+0x2f>
	for (int i = 0; i < super->s_nblocks; i++) {
  8009ab:	83 c3 01             	add    $0x1,%ebx
  8009ae:	eb e7                	jmp    800997 <alloc_block+0x16>
			bitmap[i / 32] &= ~(1 << (i % 32));
  8009b0:	8d 43 1f             	lea    0x1f(%ebx),%eax
  8009b3:	85 db                	test   %ebx,%ebx
  8009b5:	0f 49 c3             	cmovns %ebx,%eax
  8009b8:	c1 f8 05             	sar    $0x5,%eax
  8009bb:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8009c1:	89 de                	mov    %ebx,%esi
  8009c3:	c1 fe 1f             	sar    $0x1f,%esi
  8009c6:	c1 ee 1b             	shr    $0x1b,%esi
  8009c9:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  8009cc:	83 e1 1f             	and    $0x1f,%ecx
  8009cf:	29 f1                	sub    %esi,%ecx
  8009d1:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  8009d6:	d3 c6                	rol    %cl,%esi
  8009d8:	21 34 82             	and    %esi,(%edx,%eax,4)
			flush_block(bitmap);
  8009db:	83 ec 0c             	sub    $0xc,%esp
  8009de:	ff 35 04 a0 80 00    	pushl  0x80a004
  8009e4:	e8 e9 fa ff ff       	call   8004d2 <flush_block>
			return i;
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	eb 05                	jmp    8009f3 <alloc_block+0x72>
	return -E_NO_DISK;
  8009ee:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
}
  8009f3:	89 d8                	mov    %ebx,%eax
  8009f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <file_block_walk>:
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	83 ec 1c             	sub    $0x1c,%esp
  800a05:	89 c7                	mov    %eax,%edi
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
	if (filebno >= (NDIRECT + NINDIRECT)) {
  800a0a:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800a10:	0f 87 dd 00 00 00    	ja     800af3 <file_block_walk+0xf7>
  800a16:	89 d3                	mov    %edx,%ebx
  800a18:	89 ce                	mov    %ecx,%esi
	if (filebno < NDIRECT) {
  800a1a:	83 fa 09             	cmp    $0x9,%edx
  800a1d:	0f 86 a2 00 00 00    	jbe    800ac5 <file_block_walk+0xc9>
	if (f->f_indirect == 0) {
  800a23:	83 bf b0 00 00 00 00 	cmpl   $0x0,0xb0(%edi)
  800a2a:	75 6c                	jne    800a98 <file_block_walk+0x9c>
		if (alloc == false) {
  800a2c:	84 c0                	test   %al,%al
  800a2e:	0f 84 c6 00 00 00    	je     800afa <file_block_walk+0xfe>
		int indirect_block = alloc_block();
  800a34:	e8 48 ff ff ff       	call   800981 <alloc_block>
  800a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (indirect_block < 0) {
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	0f 88 bd 00 00 00    	js     800b01 <file_block_walk+0x105>
		f->f_indirect = indirect_block;
  800a44:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
		int error = sys_page_alloc(0,
  800a4a:	83 ec 0c             	sub    $0xc,%esp
  800a4d:	50                   	push   %eax
  800a4e:	e8 f5 f9 ff ff       	call   800448 <diskaddr>
  800a53:	83 c4 0c             	add    $0xc,%esp
  800a56:	6a 07                	push   $0x7
  800a58:	50                   	push   %eax
  800a59:	6a 00                	push   $0x0
  800a5b:	e8 5f 1d 00 00       	call   8027bf <sys_page_alloc>
		if (error) {
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	85 c0                	test   %eax,%eax
  800a65:	75 77                	jne    800ade <file_block_walk+0xe2>
		memset(diskaddr(indirect_block), 0, BLKSIZE);
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6d:	e8 d6 f9 ff ff       	call   800448 <diskaddr>
  800a72:	83 c4 0c             	add    $0xc,%esp
  800a75:	68 00 10 00 00       	push   $0x1000
  800a7a:	6a 00                	push   $0x0
  800a7c:	50                   	push   %eax
  800a7d:	e8 1f 1a 00 00       	call   8024a1 <memset>
		flush_block(diskaddr(indirect_block));
  800a82:	83 c4 04             	add    $0x4,%esp
  800a85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a88:	e8 bb f9 ff ff       	call   800448 <diskaddr>
  800a8d:	89 04 24             	mov    %eax,(%esp)
  800a90:	e8 3d fa ff ff       	call   8004d2 <flush_block>
  800a95:	83 c4 10             	add    $0x10,%esp
	return 0;
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
	if (ppdiskbno)
  800a9d:	85 f6                	test   %esi,%esi
  800a9f:	74 1c                	je     800abd <file_block_walk+0xc1>
		        (uint32_t *) diskaddr(f->f_indirect) + filebno - NDIRECT;
  800aa1:	83 ec 0c             	sub    $0xc,%esp
  800aa4:	ff b7 b0 00 00 00    	pushl  0xb0(%edi)
  800aaa:	e8 99 f9 ff ff       	call   800448 <diskaddr>
  800aaf:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800ab3:	89 06                	mov    %eax,(%esi)
		*ppdiskbno =
  800ab5:	83 c4 10             	add    $0x10,%esp
	return 0;
  800ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    
		return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ppdiskbno)
  800aca:	85 c9                	test   %ecx,%ecx
  800acc:	74 ef                	je     800abd <file_block_walk+0xc1>
			*ppdiskbno = &f->f_direct[filebno];
  800ace:	8d 84 97 88 00 00 00 	lea    0x88(%edi,%edx,4),%eax
  800ad5:	89 01                	mov    %eax,(%ecx)
		return 0;
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	eb df                	jmp    800abd <file_block_walk+0xc1>
			panic("[file_block_walk] sys_page_alloc failed %e", error);
  800ade:	50                   	push   %eax
  800adf:	68 0c 3e 80 00       	push   $0x803e0c
  800ae4:	68 af 00 00 00       	push   $0xaf
  800ae9:	68 36 3d 80 00       	push   $0x803d36
  800aee:	e8 f3 11 00 00       	call   801ce6 <_panic>
		return -E_INVAL;
  800af3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800af8:	eb c3                	jmp    800abd <file_block_walk+0xc1>
			return -E_NOT_FOUND;
  800afa:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800aff:	eb bc                	jmp    800abd <file_block_walk+0xc1>
			return -E_NO_DISK;
  800b01:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800b06:	eb b5                	jmp    800abd <file_block_walk+0xc1>

00800b08 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 24             	sub    $0x24,%esp
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800b0e:	6a 00                	push   $0x0
  800b10:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b13:	e8 e4 fe ff ff       	call   8009fc <file_block_walk>
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	85 c0                	test   %eax,%eax
  800b1d:	78 0e                	js     800b2d <file_free_block+0x25>
		return r;
	if (*ptr) {
  800b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b22:	8b 10                	mov    (%eax),%edx
		free_block(*ptr);
		*ptr = 0;
	}
	return 0;
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
	if (*ptr) {
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	75 02                	jne    800b2f <file_free_block+0x27>
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    
		free_block(*ptr);
  800b2f:	83 ec 0c             	sub    $0xc,%esp
  800b32:	52                   	push   %edx
  800b33:	e8 09 fe ff ff       	call   800941 <free_block>
		*ptr = 0;
  800b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800b41:	83 c4 10             	add    $0x10,%esp
	return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	eb e2                	jmp    800b2d <file_free_block+0x25>

00800b4b <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	57                   	push   %edi
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
  800b51:	83 ec 1c             	sub    $0x1c,%esp
  800b54:	89 c7                	mov    %eax,%edi
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800b56:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800b5c:	8d b0 fe 1f 00 00    	lea    0x1ffe(%eax),%esi
  800b62:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b67:	0f 49 f0             	cmovns %eax,%esi
  800b6a:	c1 fe 0c             	sar    $0xc,%esi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800b6d:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800b73:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800b79:	0f 48 d0             	cmovs  %eax,%edx
  800b7c:	c1 fa 0c             	sar    $0xc,%edx
  800b7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	eb 03                	jmp    800b89 <file_truncate_blocks+0x3e>
  800b86:	83 c3 01             	add    $0x1,%ebx
  800b89:	39 f3                	cmp    %esi,%ebx
  800b8b:	73 20                	jae    800bad <file_truncate_blocks+0x62>
		if ((r = file_free_block(f, bno)) < 0)
  800b8d:	89 da                	mov    %ebx,%edx
  800b8f:	89 f8                	mov    %edi,%eax
  800b91:	e8 72 ff ff ff       	call   800b08 <file_free_block>
  800b96:	85 c0                	test   %eax,%eax
  800b98:	79 ec                	jns    800b86 <file_truncate_blocks+0x3b>
			cprintf("warning: file_free_block: %e", r);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	50                   	push   %eax
  800b9e:	68 86 3d 80 00       	push   $0x803d86
  800ba3:	e8 25 12 00 00       	call   801dcd <cprintf>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	eb d9                	jmp    800b86 <file_truncate_blocks+0x3b>

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800bad:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%ebp)
  800bb1:	77 0a                	ja     800bbd <file_truncate_blocks+0x72>
  800bb3:	8b 87 b0 00 00 00    	mov    0xb0(%edi),%eax
  800bb9:	85 c0                	test   %eax,%eax
  800bbb:	75 08                	jne    800bc5 <file_truncate_blocks+0x7a>
		free_block(f->f_indirect);
		f->f_indirect = 0;
	}
}
  800bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    
		free_block(f->f_indirect);
  800bc5:	83 ec 0c             	sub    $0xc,%esp
  800bc8:	50                   	push   %eax
  800bc9:	e8 73 fd ff ff       	call   800941 <free_block>
		f->f_indirect = 0;
  800bce:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
  800bd5:	00 00 00 
  800bd8:	83 c4 10             	add    $0x10,%esp
}
  800bdb:	eb e0                	jmp    800bbd <file_truncate_blocks+0x72>

00800bdd <check_bitmap>:
{
  800bdd:	f3 0f 1e fb          	endbr32 
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800be6:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800beb:	8b 70 04             	mov    0x4(%eax),%esi
  800bee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf3:	89 d8                	mov    %ebx,%eax
  800bf5:	c1 e0 0f             	shl    $0xf,%eax
  800bf8:	39 c6                	cmp    %eax,%esi
  800bfa:	76 2e                	jbe    800c2a <check_bitmap+0x4d>
		assert(!block_is_free(2 + i));
  800bfc:	83 ec 0c             	sub    $0xc,%esp
  800bff:	8d 43 02             	lea    0x2(%ebx),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 f7 fc ff ff       	call   8008ff <block_is_free>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	84 c0                	test   %al,%al
  800c0d:	75 05                	jne    800c14 <check_bitmap+0x37>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800c0f:	83 c3 01             	add    $0x1,%ebx
  800c12:	eb df                	jmp    800bf3 <check_bitmap+0x16>
		assert(!block_is_free(2 + i));
  800c14:	68 a3 3d 80 00       	push   $0x803da3
  800c19:	68 1d 3b 80 00       	push   $0x803b1d
  800c1e:	6a 5a                	push   $0x5a
  800c20:	68 36 3d 80 00       	push   $0x803d36
  800c25:	e8 bc 10 00 00       	call   801ce6 <_panic>
	assert(!block_is_free(0));
  800c2a:	83 ec 0c             	sub    $0xc,%esp
  800c2d:	6a 00                	push   $0x0
  800c2f:	e8 cb fc ff ff       	call   8008ff <block_is_free>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	84 c0                	test   %al,%al
  800c39:	75 28                	jne    800c63 <check_bitmap+0x86>
	assert(!block_is_free(1));
  800c3b:	83 ec 0c             	sub    $0xc,%esp
  800c3e:	6a 01                	push   $0x1
  800c40:	e8 ba fc ff ff       	call   8008ff <block_is_free>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	84 c0                	test   %al,%al
  800c4a:	75 2d                	jne    800c79 <check_bitmap+0x9c>
	cprintf("bitmap is good\n");
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 dd 3d 80 00       	push   $0x803ddd
  800c54:	e8 74 11 00 00       	call   801dcd <cprintf>
}
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    
	assert(!block_is_free(0));
  800c63:	68 b9 3d 80 00       	push   $0x803db9
  800c68:	68 1d 3b 80 00       	push   $0x803b1d
  800c6d:	6a 5d                	push   $0x5d
  800c6f:	68 36 3d 80 00       	push   $0x803d36
  800c74:	e8 6d 10 00 00       	call   801ce6 <_panic>
	assert(!block_is_free(1));
  800c79:	68 cb 3d 80 00       	push   $0x803dcb
  800c7e:	68 1d 3b 80 00       	push   $0x803b1d
  800c83:	6a 5e                	push   $0x5e
  800c85:	68 36 3d 80 00       	push   $0x803d36
  800c8a:	e8 57 10 00 00       	call   801ce6 <_panic>

00800c8f <fs_init>:
{
  800c8f:	f3 0f 1e fb          	endbr32 
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800c99:	e8 f5 f3 ff ff       	call   800093 <ide_probe_disk1>
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 41                	je     800ce3 <fs_init+0x54>
		ide_set_disk(1);
  800ca2:	83 ec 0c             	sub    $0xc,%esp
  800ca5:	6a 01                	push   $0x1
  800ca7:	e8 59 f4 ff ff       	call   800105 <ide_set_disk>
  800cac:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800caf:	e8 a4 fb ff ff       	call   800858 <bc_init>
	super = diskaddr(1);
  800cb4:	83 ec 0c             	sub    $0xc,%esp
  800cb7:	6a 01                	push   $0x1
  800cb9:	e8 8a f7 ff ff       	call   800448 <diskaddr>
  800cbe:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800cc3:	e8 dd fb ff ff       	call   8008a5 <check_super>
	bitmap = diskaddr(2);
  800cc8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ccf:	e8 74 f7 ff ff       	call   800448 <diskaddr>
  800cd4:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800cd9:	e8 ff fe ff ff       	call   800bdd <check_bitmap>
}
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    
		ide_set_disk(0);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	6a 00                	push   $0x0
  800ce8:	e8 18 f4 ff ff       	call   800105 <ide_set_disk>
  800ced:	83 c4 10             	add    $0x10,%esp
  800cf0:	eb bd                	jmp    800caf <fs_init+0x20>

00800cf2 <file_get_block>:
{
  800cf2:	f3 0f 1e fb          	endbr32 
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 20             	sub    $0x20,%esp
	int errcode = file_block_walk(f, filebno, &global_block_ref, true);
  800cfd:	6a 01                	push   $0x1
  800cff:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	e8 ef fc ff ff       	call   8009fc <file_block_walk>
  800d0d:	89 c3                	mov    %eax,%ebx
	if (errcode) {
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	85 c0                	test   %eax,%eax
  800d14:	75 1d                	jne    800d33 <file_get_block+0x41>
	if (*global_block_ref == 0) {
  800d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d19:	83 38 00             	cmpl   $0x0,(%eax)
  800d1c:	74 1c                	je     800d3a <file_get_block+0x48>
	*blk = (char *) diskaddr(*global_block_ref);
  800d1e:	83 ec 0c             	sub    $0xc,%esp
  800d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d24:	ff 30                	pushl  (%eax)
  800d26:	e8 1d f7 ff ff       	call   800448 <diskaddr>
  800d2b:	8b 55 10             	mov    0x10(%ebp),%edx
  800d2e:	89 02                	mov    %eax,(%edx)
	return 0;
  800d30:	83 c4 10             	add    $0x10,%esp
}
  800d33:	89 d8                	mov    %ebx,%eax
  800d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    
		*global_block_ref = alloc_block();
  800d3a:	e8 42 fc ff ff       	call   800981 <alloc_block>
  800d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d42:	89 02                	mov    %eax,(%edx)
  800d44:	eb d8                	jmp    800d1e <file_get_block+0x2c>

00800d46 <dir_lookup>:
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 3c             	sub    $0x3c,%esp
  800d4f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800d52:	89 d6                	mov    %edx,%esi
  800d54:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	assert((dir->f_size % BLKSIZE) == 0);
  800d57:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800d5d:	89 c2                	mov    %eax,%edx
  800d5f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  800d65:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800d68:	75 5f                	jne    800dc9 <dir_lookup+0x83>
	nblock = dir->f_size / BLKSIZE;
  800d6a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800d70:	85 c0                	test   %eax,%eax
  800d72:	0f 48 c2             	cmovs  %edx,%eax
  800d75:	c1 f8 0c             	sar    $0xc,%eax
  800d78:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (i = 0; i < nblock; i++) {
  800d7b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800d7e:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
  800d81:	74 6f                	je     800df2 <dir_lookup+0xac>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800d83:	83 ec 04             	sub    $0x4,%esp
  800d86:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800d89:	50                   	push   %eax
  800d8a:	ff 75 d0             	pushl  -0x30(%ebp)
  800d8d:	ff 75 c8             	pushl  -0x38(%ebp)
  800d90:	e8 5d ff ff ff       	call   800cf2 <file_get_block>
  800d95:	83 c4 10             	add    $0x10,%esp
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	78 4e                	js     800dea <dir_lookup+0xa4>
  800d9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d9f:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800da5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	e8 44 16 00 00       	call   8023f6 <strcmp>
  800db2:	83 c4 10             	add    $0x10,%esp
  800db5:	85 c0                	test   %eax,%eax
  800db7:	74 29                	je     800de2 <dir_lookup+0x9c>
  800db9:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800dbf:	39 fb                	cmp    %edi,%ebx
  800dc1:	75 e2                	jne    800da5 <dir_lookup+0x5f>
	for (i = 0; i < nblock; i++) {
  800dc3:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
  800dc7:	eb b2                	jmp    800d7b <dir_lookup+0x35>
	assert((dir->f_size % BLKSIZE) == 0);
  800dc9:	68 ed 3d 80 00       	push   $0x803ded
  800dce:	68 1d 3b 80 00       	push   $0x803b1d
  800dd3:	68 eb 00 00 00       	push   $0xeb
  800dd8:	68 36 3d 80 00       	push   $0x803d36
  800ddd:	e8 04 0f 00 00       	call   801ce6 <_panic>
				*file = &f[j];
  800de2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800de5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800de8:	89 11                	mov    %edx,(%ecx)
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
	return -E_NOT_FOUND;
  800df2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800df7:	eb f1                	jmp    800dea <dir_lookup+0xa4>

00800df9 <walk_path>:
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	81 ec ac 00 00 00    	sub    $0xac,%esp
  800e05:	89 d7                	mov    %edx,%edi
  800e07:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
  800e0d:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	path = skip_slash(path);
  800e13:	e8 82 fa ff ff       	call   80089a <skip_slash>
  800e18:	89 c6                	mov    %eax,%esi
	f = &super->s_root;
  800e1a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800e1f:	83 c0 08             	add    $0x8,%eax
  800e22:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	name[0] = 0;
  800e28:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)
	if (pdir)
  800e2f:	85 ff                	test   %edi,%edi
  800e31:	74 06                	je     800e39 <walk_path+0x40>
		*pdir = 0;
  800e33:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*pf = 0;
  800e39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	dir = 0;
  800e45:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800e4c:	00 00 00 
	while (*path != '\0') {
  800e4f:	eb 68                	jmp    800eb9 <walk_path+0xc0>
			path++;
  800e51:	83 c3 01             	add    $0x1,%ebx
		while (*path != '/' && *path != '\0')
  800e54:	0f b6 03             	movzbl (%ebx),%eax
  800e57:	3c 2f                	cmp    $0x2f,%al
  800e59:	74 04                	je     800e5f <walk_path+0x66>
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 f2                	jne    800e51 <walk_path+0x58>
		if (path - p >= MAXNAMELEN)
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	29 f7                	sub    %esi,%edi
  800e63:	83 ff 7f             	cmp    $0x7f,%edi
  800e66:	0f 8f d8 00 00 00    	jg     800f44 <walk_path+0x14b>
		memmove(name, p, path - p);
  800e6c:	83 ec 04             	sub    $0x4,%esp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e77:	50                   	push   %eax
  800e78:	e8 72 16 00 00       	call   8024ef <memmove>
		name[path - p] = '\0';
  800e7d:	c6 84 3d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%edi,1)
  800e84:	00 
		path = skip_slash(path);
  800e85:	89 d8                	mov    %ebx,%eax
  800e87:	e8 0e fa ff ff       	call   80089a <skip_slash>
  800e8c:	89 c6                	mov    %eax,%esi
		if (dir->f_type != FTYPE_DIR)
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e97:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800e9e:	0f 85 a7 00 00 00    	jne    800f4b <walk_path+0x152>
		if ((r = dir_lookup(dir, name, &f)) < 0) {
  800ea4:	8d 8d 64 ff ff ff    	lea    -0x9c(%ebp),%ecx
  800eaa:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800eb0:	e8 91 fe ff ff       	call   800d46 <dir_lookup>
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	78 15                	js     800ece <walk_path+0xd5>
	while (*path != '\0') {
  800eb9:	80 3e 00             	cmpb   $0x0,(%esi)
  800ebc:	74 57                	je     800f15 <walk_path+0x11c>
		dir = f;
  800ebe:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ec4:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		while (*path != '/' && *path != '\0')
  800eca:	89 f3                	mov    %esi,%ebx
  800ecc:	eb 86                	jmp    800e54 <walk_path+0x5b>
  800ece:	89 c3                	mov    %eax,%ebx
			if (r == -E_NOT_FOUND && *path == '\0') {
  800ed0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800ed3:	75 65                	jne    800f3a <walk_path+0x141>
  800ed5:	80 3e 00             	cmpb   $0x0,(%esi)
  800ed8:	75 60                	jne    800f3a <walk_path+0x141>
				if (pdir)
  800eda:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	74 08                	je     800eec <walk_path+0xf3>
					*pdir = dir;
  800ee4:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800eea:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800eec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef0:	74 15                	je     800f07 <walk_path+0x10e>
					strcpy(lastelem, name);
  800ef2:	83 ec 08             	sub    $0x8,%esp
  800ef5:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800efb:	50                   	push   %eax
  800efc:	ff 75 08             	pushl  0x8(%ebp)
  800eff:	e8 33 14 00 00       	call   802337 <strcpy>
  800f04:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800f07:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800f0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f13:	eb 25                	jmp    800f3a <walk_path+0x141>
	if (pdir)
  800f15:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	74 08                	je     800f27 <walk_path+0x12e>
		*pdir = dir;
  800f1f:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800f25:	89 08                	mov    %ecx,(%eax)
	*pf = f;
  800f27:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800f2d:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800f33:	89 02                	mov    %eax,(%edx)
	return 0;
  800f35:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  800f3a:	89 d8                	mov    %ebx,%eax
  800f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    
			return -E_BAD_PATH;
  800f44:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f49:	eb ef                	jmp    800f3a <walk_path+0x141>
			return -E_NOT_FOUND;
  800f4b:	bb f5 ff ff ff       	mov    $0xfffffff5,%ebx
  800f50:	eb e8                	jmp    800f3a <walk_path+0x141>

00800f52 <dir_alloc_file>:
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	57                   	push   %edi
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	83 ec 2c             	sub    $0x2c,%esp
  800f5b:	89 c6                	mov    %eax,%esi
  800f5d:	89 55 d0             	mov    %edx,-0x30(%ebp)
	assert((dir->f_size % BLKSIZE) == 0);
  800f60:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800f66:	89 c3                	mov    %eax,%ebx
  800f68:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  800f6e:	75 4c                	jne    800fbc <dir_alloc_file+0x6a>
	nblock = dir->f_size / BLKSIZE;
  800f70:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800f76:	85 c0                	test   %eax,%eax
  800f78:	0f 48 c2             	cmovs  %edx,%eax
  800f7b:	c1 f8 0c             	sar    $0xc,%eax
  800f7e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800f81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800f84:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  800f87:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800f8a:	74 5b                	je     800fe7 <dir_alloc_file+0x95>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	57                   	push   %edi
  800f90:	53                   	push   %ebx
  800f91:	56                   	push   %esi
  800f92:	e8 5b fd ff ff       	call   800cf2 <file_get_block>
  800f97:	83 c4 10             	add    $0x10,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 41                	js     800fdf <dir_alloc_file+0x8d>
  800f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fa1:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  800fa7:	89 c1                	mov    %eax,%ecx
  800fa9:	80 38 00             	cmpb   $0x0,(%eax)
  800fac:	74 27                	je     800fd5 <dir_alloc_file+0x83>
  800fae:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  800fb3:	39 d0                	cmp    %edx,%eax
  800fb5:	75 f0                	jne    800fa7 <dir_alloc_file+0x55>
	for (i = 0; i < nblock; i++) {
  800fb7:	83 c3 01             	add    $0x1,%ebx
  800fba:	eb cb                	jmp    800f87 <dir_alloc_file+0x35>
	assert((dir->f_size % BLKSIZE) == 0);
  800fbc:	68 ed 3d 80 00       	push   $0x803ded
  800fc1:	68 1d 3b 80 00       	push   $0x803b1d
  800fc6:	68 04 01 00 00       	push   $0x104
  800fcb:	68 36 3d 80 00       	push   $0x803d36
  800fd0:	e8 11 0d 00 00       	call   801ce6 <_panic>
				*file = &f[j];
  800fd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fd8:	89 08                	mov    %ecx,(%eax)
				return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    
	dir->f_size += BLKSIZE;
  800fe7:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  800fee:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  800ff1:	83 ec 04             	sub    $0x4,%esp
  800ff4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff7:	50                   	push   %eax
  800ff8:	ff 75 cc             	pushl  -0x34(%ebp)
  800ffb:	56                   	push   %esi
  800ffc:	e8 f1 fc ff ff       	call   800cf2 <file_get_block>
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	78 d7                	js     800fdf <dir_alloc_file+0x8d>
	*file = &f[0];
  801008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80100b:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80100e:	89 07                	mov    %eax,(%edi)
	return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	eb c8                	jmp    800fdf <dir_alloc_file+0x8d>

00801017 <file_open>:
{
  801017:	f3 0f 1e fb          	endbr32 
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  801021:	6a 00                	push   $0x0
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	ba 00 00 00 00       	mov    $0x0,%edx
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	e8 c6 fd ff ff       	call   800df9 <walk_path>
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <file_read>:
{
  801035:	f3 0f 1e fb          	endbr32 
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 2c             	sub    $0x2c,%esp
  801042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801045:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801048:	8b 4d 14             	mov    0x14(%ebp),%ecx
	if (offset >= f->f_size)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  801059:	39 ca                	cmp    %ecx,%edx
  80105b:	7e 7e                	jle    8010db <file_read+0xa6>
	count = MIN(count, f->f_size - offset);
  80105d:	29 ca                	sub    %ecx,%edx
  80105f:	39 da                	cmp    %ebx,%edx
  801061:	89 d8                	mov    %ebx,%eax
  801063:	0f 46 c2             	cmovbe %edx,%eax
  801066:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (pos = offset; pos < offset + count;) {
  801069:	89 cb                	mov    %ecx,%ebx
  80106b:	01 c1                	add    %eax,%ecx
  80106d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801070:	89 de                	mov    %ebx,%esi
  801072:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  801075:	76 61                	jbe    8010d8 <file_read+0xa3>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801077:	83 ec 04             	sub    $0x4,%esp
  80107a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107d:	50                   	push   %eax
  80107e:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801084:	85 db                	test   %ebx,%ebx
  801086:	0f 49 c3             	cmovns %ebx,%eax
  801089:	c1 f8 0c             	sar    $0xc,%eax
  80108c:	50                   	push   %eax
  80108d:	ff 75 08             	pushl  0x8(%ebp)
  801090:	e8 5d fc ff ff       	call   800cf2 <file_get_block>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 3f                	js     8010db <file_read+0xa6>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80109c:	89 da                	mov    %ebx,%edx
  80109e:	c1 fa 1f             	sar    $0x1f,%edx
  8010a1:	c1 ea 14             	shr    $0x14,%edx
  8010a4:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8010a7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8010ac:	29 d0                	sub    %edx,%eax
  8010ae:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010b3:	29 c2                	sub    %eax,%edx
  8010b5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8010b8:	29 f1                	sub    %esi,%ecx
  8010ba:	89 ce                	mov    %ecx,%esi
  8010bc:	39 ca                	cmp    %ecx,%edx
  8010be:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	56                   	push   %esi
  8010c5:	03 45 e4             	add    -0x1c(%ebp),%eax
  8010c8:	50                   	push   %eax
  8010c9:	57                   	push   %edi
  8010ca:	e8 20 14 00 00       	call   8024ef <memmove>
		pos += bn;
  8010cf:	01 f3                	add    %esi,%ebx
		buf += bn;
  8010d1:	01 f7                	add    %esi,%edi
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	eb 98                	jmp    801070 <file_read+0x3b>
	return count;
  8010d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8010db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  8010e3:	f3 0f 1e fb          	endbr32 
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8010ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  8010f2:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
  8010f8:	7f 1b                	jg     801115 <file_set_size+0x32>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  8010fa:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	53                   	push   %ebx
  801104:	e8 c9 f3 ff ff       	call   8004d2 <flush_block>
	return 0;
}
  801109:	b8 00 00 00 00       	mov    $0x0,%eax
  80110e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    
		file_truncate_blocks(f, newsize);
  801115:	89 f2                	mov    %esi,%edx
  801117:	89 d8                	mov    %ebx,%eax
  801119:	e8 2d fa ff ff       	call   800b4b <file_truncate_blocks>
  80111e:	eb da                	jmp    8010fa <file_set_size+0x17>

00801120 <file_write>:
{
  801120:	f3 0f 1e fb          	endbr32 
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
  80112a:	83 ec 2c             	sub    $0x2c,%esp
  80112d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801130:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  801133:	89 d8                	mov    %ebx,%eax
  801135:	03 45 10             	add    0x10(%ebp),%eax
  801138:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80113b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113e:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  801144:	77 68                	ja     8011ae <file_write+0x8e>
	for (pos = offset; pos < offset + count;) {
  801146:	89 de                	mov    %ebx,%esi
  801148:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  80114b:	76 74                	jbe    8011c1 <file_write+0xa1>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801153:	50                   	push   %eax
  801154:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  80115a:	85 db                	test   %ebx,%ebx
  80115c:	0f 49 c3             	cmovns %ebx,%eax
  80115f:	c1 f8 0c             	sar    $0xc,%eax
  801162:	50                   	push   %eax
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 87 fb ff ff       	call   800cf2 <file_get_block>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 52                	js     8011c4 <file_write+0xa4>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801172:	89 da                	mov    %ebx,%edx
  801174:	c1 fa 1f             	sar    $0x1f,%edx
  801177:	c1 ea 14             	shr    $0x14,%edx
  80117a:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  80117d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801182:	29 d0                	sub    %edx,%eax
  801184:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801189:	29 c1                	sub    %eax,%ecx
  80118b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80118e:	29 f2                	sub    %esi,%edx
  801190:	39 d1                	cmp    %edx,%ecx
  801192:	89 d6                	mov    %edx,%esi
  801194:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	56                   	push   %esi
  80119b:	57                   	push   %edi
  80119c:	03 45 e4             	add    -0x1c(%ebp),%eax
  80119f:	50                   	push   %eax
  8011a0:	e8 4a 13 00 00       	call   8024ef <memmove>
		pos += bn;
  8011a5:	01 f3                	add    %esi,%ebx
		buf += bn;
  8011a7:	01 f7                	add    %esi,%edi
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	eb 98                	jmp    801146 <file_write+0x26>
		if ((r = file_set_size(f, offset + count)) < 0)
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	50                   	push   %eax
  8011b2:	51                   	push   %ecx
  8011b3:	e8 2b ff ff ff       	call   8010e3 <file_set_size>
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	79 87                	jns    801146 <file_write+0x26>
  8011bf:	eb 03                	jmp    8011c4 <file_write+0xa4>
	return count;
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  8011cc:	f3 0f 1e fb          	endbr32 
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 10             	sub    $0x10,%esp
  8011d8:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  8011db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e0:	eb 03                	jmp    8011e5 <file_flush+0x19>
  8011e2:	83 c3 01             	add    $0x1,%ebx
  8011e5:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  8011eb:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  8011f1:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8011f7:	0f 49 c2             	cmovns %edx,%eax
  8011fa:	c1 f8 0c             	sar    $0xc,%eax
  8011fd:	39 d8                	cmp    %ebx,%eax
  8011ff:	7e 3b                	jle    80123c <file_flush+0x70>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	6a 00                	push   $0x0
  801206:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801209:	89 da                	mov    %ebx,%edx
  80120b:	89 f0                	mov    %esi,%eax
  80120d:	e8 ea f7 ff ff       	call   8009fc <file_block_walk>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	78 c9                	js     8011e2 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  801219:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80121c:	85 c0                	test   %eax,%eax
  80121e:	74 c2                	je     8011e2 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  801220:	8b 00                	mov    (%eax),%eax
  801222:	85 c0                	test   %eax,%eax
  801224:	74 bc                	je     8011e2 <file_flush+0x16>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	50                   	push   %eax
  80122a:	e8 19 f2 ff ff       	call   800448 <diskaddr>
  80122f:	89 04 24             	mov    %eax,(%esp)
  801232:	e8 9b f2 ff ff       	call   8004d2 <flush_block>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	eb a6                	jmp    8011e2 <file_flush+0x16>
	}
	flush_block(f);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	56                   	push   %esi
  801240:	e8 8d f2 ff ff       	call   8004d2 <flush_block>
	if (f->f_indirect)
  801245:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	75 07                	jne    801259 <file_flush+0x8d>
		flush_block(diskaddr(f->f_indirect));
}
  801252:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	50                   	push   %eax
  80125d:	e8 e6 f1 ff ff       	call   800448 <diskaddr>
  801262:	89 04 24             	mov    %eax,(%esp)
  801265:	e8 68 f2 ff ff       	call   8004d2 <flush_block>
  80126a:	83 c4 10             	add    $0x10,%esp
}
  80126d:	eb e3                	jmp    801252 <file_flush+0x86>

0080126f <file_create>:
{
  80126f:	f3 0f 1e fb          	endbr32 
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80127c:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  801282:	50                   	push   %eax
  801283:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  801289:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	e8 62 fb ff ff       	call   800df9 <walk_path>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	74 58                	je     8012f6 <file_create+0x87>
	if (r != -E_NOT_FOUND || dir == 0)
  80129e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8012a1:	75 51                	jne    8012f4 <file_create+0x85>
  8012a3:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  8012a9:	85 c9                	test   %ecx,%ecx
  8012ab:	74 47                	je     8012f4 <file_create+0x85>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  8012ad:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8012b3:	89 c8                	mov    %ecx,%eax
  8012b5:	e8 98 fc ff ff       	call   800f52 <dir_alloc_file>
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 36                	js     8012f4 <file_create+0x85>
	strcpy(f->f_name, name);
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8012ce:	e8 64 10 00 00       	call   802337 <strcpy>
	*pf = f;
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  8012dc:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  8012e7:	e8 e0 fe ff ff       	call   8011cc <file_flush>
	return 0;
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    
		return -E_FILE_EXISTS;
  8012f6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8012fb:	eb f7                	jmp    8012f4 <file_create+0x85>

008012fd <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8012fd:	f3 0f 1e fb          	endbr32 
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	53                   	push   %ebx
  801305:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801308:	bb 01 00 00 00       	mov    $0x1,%ebx
  80130d:	a1 08 a0 80 00       	mov    0x80a008,%eax
  801312:	39 58 04             	cmp    %ebx,0x4(%eax)
  801315:	76 19                	jbe    801330 <fs_sync+0x33>
		flush_block(diskaddr(i));
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	53                   	push   %ebx
  80131b:	e8 28 f1 ff ff       	call   800448 <diskaddr>
  801320:	89 04 24             	mov    %eax,(%esp)
  801323:	e8 aa f1 ff ff       	call   8004d2 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  801328:	83 c3 01             	add    $0x1,%ebx
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	eb dd                	jmp    80130d <fs_sync+0x10>
}
  801330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <outw>:
{
  801335:	89 c1                	mov    %eax,%ecx
  801337:	89 d0                	mov    %edx,%eax
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801339:	89 ca                	mov    %ecx,%edx
  80133b:	66 ef                	out    %ax,(%dx)
}
  80133d:	c3                   	ret    

0080133e <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  80133e:	f3 0f 1e fb          	endbr32 
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801348:	e8 b0 ff ff ff       	call   8012fd <fs_sync>
	return 0;
}
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <serve_init>:
{
  801354:	f3 0f 1e fb          	endbr32 
  801358:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  80135d:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801367:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd *) va;
  801369:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  80136c:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801372:	83 c0 01             	add    $0x1,%eax
  801375:	83 c2 10             	add    $0x10,%edx
  801378:	3d 00 04 00 00       	cmp    $0x400,%eax
  80137d:	75 e8                	jne    801367 <serve_init+0x13>
}
  80137f:	c3                   	ret    

00801380 <openfile_alloc>:
{
  801380:	f3 0f 1e fb          	endbr32 
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	57                   	push   %edi
  801388:	56                   	push   %esi
  801389:	53                   	push   %ebx
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801390:	bb 00 00 00 00       	mov    $0x0,%ebx
  801395:	89 de                	mov    %ebx,%esi
  801397:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  8013a3:	e8 86 1f 00 00       	call   80332e <pageref>
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	74 17                	je     8013c6 <openfile_alloc+0x46>
  8013af:	83 f8 01             	cmp    $0x1,%eax
  8013b2:	74 30                	je     8013e4 <openfile_alloc+0x64>
	for (i = 0; i < MAXOPEN; i++) {
  8013b4:	83 c3 01             	add    $0x1,%ebx
  8013b7:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8013bd:	75 d6                	jne    801395 <openfile_alloc+0x15>
	return -E_MAX_OPEN;
  8013bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013c4:	eb 4f                	jmp    801415 <openfile_alloc+0x95>
			if ((r = sys_page_alloc(0,
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	6a 07                	push   $0x7
			                        opentab[i].o_fd,
  8013cb:	89 d8                	mov    %ebx,%eax
  8013cd:	c1 e0 04             	shl    $0x4,%eax
			if ((r = sys_page_alloc(0,
  8013d0:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 e2 13 00 00       	call   8027bf <sys_page_alloc>
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	78 31                	js     801415 <openfile_alloc+0x95>
			opentab[i].o_fileid += MAXOPEN;
  8013e4:	c1 e3 04             	shl    $0x4,%ebx
  8013e7:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8013ee:	04 00 00 
			*o = &opentab[i];
  8013f1:	81 c6 60 50 80 00    	add    $0x805060,%esi
  8013f7:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	68 00 10 00 00       	push   $0x1000
  801401:	6a 00                	push   $0x0
  801403:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  801409:	e8 93 10 00 00       	call   8024a1 <memset>
			return (*o)->o_fileid;
  80140e:	8b 07                	mov    (%edi),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	83 c4 10             	add    $0x10,%esp
}
  801415:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <openfile_lookup>:
{
  80141d:	f3 0f 1e fb          	endbr32 
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	57                   	push   %edi
  801425:	56                   	push   %esi
  801426:	53                   	push   %ebx
  801427:	83 ec 18             	sub    $0x18,%esp
  80142a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  80142d:	89 fb                	mov    %edi,%ebx
  80142f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801435:	89 de                	mov    %ebx,%esi
  801437:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80143a:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  801440:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801446:	e8 e3 1e 00 00       	call   80332e <pageref>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	83 f8 01             	cmp    $0x1,%eax
  801451:	7e 1d                	jle    801470 <openfile_lookup+0x53>
  801453:	c1 e3 04             	shl    $0x4,%ebx
  801456:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  80145c:	75 19                	jne    801477 <openfile_lookup+0x5a>
	*po = o;
  80145e:	8b 45 10             	mov    0x10(%ebp),%eax
  801461:	89 30                	mov    %esi,(%eax)
	return 0;
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	5f                   	pop    %edi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    
		return -E_INVAL;
  801470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801475:	eb f1                	jmp    801468 <openfile_lookup+0x4b>
  801477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147c:	eb ea                	jmp    801468 <openfile_lookup+0x4b>

0080147e <serve_set_size>:
{
  80147e:	f3 0f 1e fb          	endbr32 
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	53                   	push   %ebx
  801486:	83 ec 18             	sub    $0x18,%esp
  801489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80148c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148f:	50                   	push   %eax
  801490:	ff 33                	pushl  (%ebx)
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 83 ff ff ff       	call   80141d <openfile_lookup>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 14                	js     8014b5 <serve_set_size+0x37>
	return file_set_size(o->o_file, req->req_size);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 73 04             	pushl  0x4(%ebx)
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	ff 70 04             	pushl  0x4(%eax)
  8014ad:	e8 31 fc ff ff       	call   8010e3 <file_set_size>
  8014b2:	83 c4 10             	add    $0x10,%esp
}
  8014b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <serve_read>:
{
  8014ba:	f3 0f 1e fb          	endbr32 
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 18             	sub    $0x18,%esp
  8014c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r = openfile_lookup(envid, req->req_fileid, &open_file);
  8014c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cb:	50                   	push   %eax
  8014cc:	ff 33                	pushl  (%ebx)
  8014ce:	ff 75 08             	pushl  0x8(%ebp)
  8014d1:	e8 47 ff ff ff       	call   80141d <openfile_lookup>
	if (r < 0)
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 33                	js     801510 <serve_read+0x56>
	              open_file->o_fd->fd_offset);
  8014dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
	r = file_read(open_file->o_file,
  8014e0:	8b 42 0c             	mov    0xc(%edx),%eax
  8014e3:	ff 70 04             	pushl  0x4(%eax)
	              MIN(req->req_n, PGSIZE),
  8014e6:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  8014ed:	b8 00 10 00 00       	mov    $0x1000,%eax
  8014f2:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
	r = file_read(open_file->o_file,
  8014f6:	50                   	push   %eax
  8014f7:	53                   	push   %ebx
  8014f8:	ff 72 04             	pushl  0x4(%edx)
  8014fb:	e8 35 fb ff ff       	call   801035 <file_read>
	if (r < 0)
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 09                	js     801510 <serve_read+0x56>
	open_file->o_fd->fd_offset += r;
  801507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150a:	8b 52 0c             	mov    0xc(%edx),%edx
  80150d:	01 42 04             	add    %eax,0x4(%edx)
}
  801510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <serve_write>:
{
  801515:	f3 0f 1e fb          	endbr32 
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	53                   	push   %ebx
  80151d:	83 ec 18             	sub    $0x18,%esp
  801520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r = openfile_lookup(envid, req->req_fileid, &open_file);
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	ff 33                	pushl  (%ebx)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 ec fe ff ff       	call   80141d <openfile_lookup>
	if (r < 0)
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 28                	js     801560 <serve_write+0x4b>
	               open_file->o_fd->fd_offset);
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
	r = file_write(open_file->o_file,
  80153b:	8b 50 0c             	mov    0xc(%eax),%edx
  80153e:	ff 72 04             	pushl  0x4(%edx)
  801541:	ff 73 04             	pushl  0x4(%ebx)
	               req->req_buf,
  801544:	83 c3 08             	add    $0x8,%ebx
	r = file_write(open_file->o_file,
  801547:	53                   	push   %ebx
  801548:	ff 70 04             	pushl  0x4(%eax)
  80154b:	e8 d0 fb ff ff       	call   801120 <file_write>
	if (r < 0)
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 09                	js     801560 <serve_write+0x4b>
	open_file->o_fd->fd_offset += r;
  801557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155a:	8b 52 0c             	mov    0xc(%edx),%edx
  80155d:	01 42 04             	add    %eax,0x4(%edx)
}
  801560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <serve_stat>:
{
  801565:	f3 0f 1e fb          	endbr32 
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	53                   	push   %ebx
  80156d:	83 ec 18             	sub    $0x18,%esp
  801570:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801573:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	ff 33                	pushl  (%ebx)
  801579:	ff 75 08             	pushl  0x8(%ebp)
  80157c:	e8 9c fe ff ff       	call   80141d <openfile_lookup>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	85 c0                	test   %eax,%eax
  801586:	78 3f                	js     8015c7 <serve_stat+0x62>
	strcpy(ret->ret_name, o->o_file->f_name);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158e:	ff 70 04             	pushl  0x4(%eax)
  801591:	53                   	push   %ebx
  801592:	e8 a0 0d 00 00       	call   802337 <strcpy>
	ret->ret_size = o->o_file->f_size;
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 50 04             	mov    0x4(%eax),%edx
  80159d:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8015a3:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8015a9:	8b 40 04             	mov    0x4(%eax),%eax
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8015b6:	0f 94 c0             	sete   %al
  8015b9:	0f b6 c0             	movzbl %al,%eax
  8015bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <serve_flush>:
{
  8015cc:	f3 0f 1e fb          	endbr32 
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8015d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	ff 30                	pushl  (%eax)
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 36 fe ff ff       	call   80141d <openfile_lookup>
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	78 16                	js     801604 <serve_flush+0x38>
	file_flush(o->o_file);
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	ff 70 04             	pushl  0x4(%eax)
  8015f7:	e8 d0 fb ff ff       	call   8011cc <file_flush>
	return 0;
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <serve_open>:
{
  801606:	f3 0f 1e fb          	endbr32 
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801614:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  801617:	68 00 04 00 00       	push   $0x400
  80161c:	53                   	push   %ebx
  80161d:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	e8 c6 0e 00 00       	call   8024ef <memmove>
	path[MAXPATHLEN - 1] = 0;
  801629:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  80162d:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801633:	89 04 24             	mov    %eax,(%esp)
  801636:	e8 45 fd ff ff       	call   801380 <openfile_alloc>
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	85 c0                	test   %eax,%eax
  801640:	0f 88 f0 00 00 00    	js     801736 <serve_open+0x130>
	if (req->req_omode & O_CREAT) {
  801646:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80164d:	74 33                	je     801682 <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80165f:	50                   	push   %eax
  801660:	e8 0a fc ff ff       	call   80126f <file_create>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	85 c0                	test   %eax,%eax
  80166a:	79 37                	jns    8016a3 <serve_open+0x9d>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80166c:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801673:	0f 85 bd 00 00 00    	jne    801736 <serve_open+0x130>
  801679:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80167c:	0f 85 b4 00 00 00    	jne    801736 <serve_open+0x130>
		if ((r = file_open(path, &f)) < 0) {
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80168b:	50                   	push   %eax
  80168c:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	e8 7f f9 ff ff       	call   801017 <file_open>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	0f 88 93 00 00 00    	js     801736 <serve_open+0x130>
	if (req->req_omode & O_TRUNC) {
  8016a3:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8016aa:	74 17                	je     8016c3 <serve_open+0xbd>
		if ((r = file_set_size(f, 0)) < 0) {
  8016ac:	83 ec 08             	sub    $0x8,%esp
  8016af:	6a 00                	push   $0x0
  8016b1:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  8016b7:	e8 27 fa ff ff       	call   8010e3 <file_set_size>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 73                	js     801736 <serve_open+0x130>
	if ((r = file_open(path, &f)) < 0) {
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8016cc:	50                   	push   %eax
  8016cd:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8016d3:	50                   	push   %eax
  8016d4:	e8 3e f9 ff ff       	call   801017 <file_open>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 56                	js     801736 <serve_open+0x130>
	o->o_file = f;
  8016e0:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8016e6:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  8016ec:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  8016ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8016f2:	8b 08                	mov    (%eax),%ecx
  8016f4:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8016f7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8016fa:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801700:	83 e2 03             	and    $0x3,%edx
  801703:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801706:	8b 40 0c             	mov    0xc(%eax),%eax
  801709:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80170f:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801711:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801717:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80171d:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801720:	8b 50 0c             	mov    0xc(%eax),%edx
  801723:	8b 45 10             	mov    0x10(%ebp),%eax
  801726:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P | PTE_U | PTE_W | PTE_SHARE;
  801728:	8b 45 14             	mov    0x14(%ebp),%eax
  80172b:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <serve>:
	[FSREQ_SYNC] = serve_sync
};

void
serve(void)
{
  80173b:	f3 0f 1e fb          	endbr32 
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801747:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80174a:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80174d:	e9 82 00 00 00       	jmp    8017d4 <serve+0x99>
			cprintf("Invalid request from %08x: no argument page\n",
			        whom);
			continue;  // just leave it hanging...
		}

		pg = NULL;
  801752:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  801759:	83 f8 01             	cmp    $0x1,%eax
  80175c:	74 23                	je     801781 <serve+0x46>
			r = serve_open(whom, (struct Fsreq_open *) fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  80175e:	83 f8 08             	cmp    $0x8,%eax
  801761:	77 36                	ja     801799 <serve+0x5e>
  801763:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  80176a:	85 d2                	test   %edx,%edx
  80176c:	74 2b                	je     801799 <serve+0x5e>
			r = handlers[req](whom, fsreq);
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	ff 35 44 50 80 00    	pushl  0x805044
  801777:	ff 75 f4             	pushl  -0xc(%ebp)
  80177a:	ff d2                	call   *%edx
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	eb 31                	jmp    8017b2 <serve+0x77>
			r = serve_open(whom, (struct Fsreq_open *) fsreq, &pg, &perm);
  801781:	53                   	push   %ebx
  801782:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	ff 35 44 50 80 00    	pushl  0x805044
  80178c:	ff 75 f4             	pushl  -0xc(%ebp)
  80178f:	e8 72 fe ff ff       	call   801606 <serve_open>
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	eb 19                	jmp    8017b2 <serve+0x77>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	ff 75 f4             	pushl  -0xc(%ebp)
  80179f:	50                   	push   %eax
  8017a0:	68 68 3e 80 00       	push   $0x803e68
  8017a5:	e8 23 06 00 00       	call   801dcd <cprintf>
  8017aa:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8017ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8017b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8017b8:	50                   	push   %eax
  8017b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bc:	e8 4b 12 00 00       	call   802a0c <ipc_send>
		sys_page_unmap(0, fsreq);
  8017c1:	83 c4 08             	add    $0x8,%esp
  8017c4:	ff 35 44 50 80 00    	pushl  0x805044
  8017ca:	6a 00                	push   $0x0
  8017cc:	e8 40 10 00 00       	call   802811 <sys_page_unmap>
  8017d1:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8017d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	53                   	push   %ebx
  8017df:	ff 35 44 50 80 00    	pushl  0x805044
  8017e5:	56                   	push   %esi
  8017e6:	e8 b4 11 00 00       	call   80299f <ipc_recv>
		if (!(perm & PTE_P)) {
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8017f2:	0f 85 5a ff ff ff    	jne    801752 <serve+0x17>
			cprintf("Invalid request from %08x: no argument page\n",
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fe:	68 38 3e 80 00       	push   $0x803e38
  801803:	e8 c5 05 00 00       	call   801dcd <cprintf>
			continue;  // just leave it hanging...
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	eb c7                	jmp    8017d4 <serve+0x99>

0080180d <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80180d:	f3 0f 1e fb          	endbr32 
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801817:	c7 05 60 90 80 00 8b 	movl   $0x803e8b,0x809060
  80181e:	3e 80 00 
	cprintf("FS is running\n");
  801821:	68 8e 3e 80 00       	push   $0x803e8e
  801826:	e8 a2 05 00 00       	call   801dcd <cprintf>

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
  80182b:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801830:	b8 00 8a 00 00       	mov    $0x8a00,%eax
  801835:	e8 fb fa ff ff       	call   801335 <outw>
	cprintf("FS can do I/O\n");
  80183a:	c7 04 24 9d 3e 80 00 	movl   $0x803e9d,(%esp)
  801841:	e8 87 05 00 00       	call   801dcd <cprintf>

	serve_init();
  801846:	e8 09 fb ff ff       	call   801354 <serve_init>
	fs_init();
  80184b:	e8 3f f4 ff ff       	call   800c8f <fs_init>
	fs_test();
  801850:	e8 05 00 00 00       	call   80185a <fs_test>
	serve();
  801855:	e8 e1 fe ff ff       	call   80173b <serve>

0080185a <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  80185a:	f3 0f 1e fb          	endbr32 
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801865:	6a 07                	push   $0x7
  801867:	68 00 10 00 00       	push   $0x1000
  80186c:	6a 00                	push   $0x0
  80186e:	e8 4c 0f 00 00       	call   8027bf <sys_page_alloc>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	0f 88 68 02 00 00    	js     801ae6 <fs_test+0x28c>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 00 10 00 00       	push   $0x1000
  801886:	ff 35 04 a0 80 00    	pushl  0x80a004
  80188c:	68 00 10 00 00       	push   $0x1000
  801891:	e8 59 0c 00 00       	call   8024ef <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801896:	e8 e6 f0 ff ff       	call   800981 <alloc_block>
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	0f 88 52 02 00 00    	js     801af8 <fs_test+0x29e>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8018a6:	8d 50 1f             	lea    0x1f(%eax),%edx
  8018a9:	0f 49 d0             	cmovns %eax,%edx
  8018ac:	c1 fa 05             	sar    $0x5,%edx
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	c1 fb 1f             	sar    $0x1f,%ebx
  8018b4:	c1 eb 1b             	shr    $0x1b,%ebx
  8018b7:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8018ba:	83 e1 1f             	and    $0x1f,%ecx
  8018bd:	29 d9                	sub    %ebx,%ecx
  8018bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c4:	d3 e0                	shl    %cl,%eax
  8018c6:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  8018cd:	0f 84 37 02 00 00    	je     801b0a <fs_test+0x2b0>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8018d3:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  8018d9:	85 04 91             	test   %eax,(%ecx,%edx,4)
  8018dc:	0f 85 3e 02 00 00    	jne    801b20 <fs_test+0x2c6>
	cprintf("alloc_block is good\n");
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	68 f4 3e 80 00       	push   $0x803ef4
  8018ea:	e8 de 04 00 00       	call   801dcd <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8018ef:	83 c4 08             	add    $0x8,%esp
  8018f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	68 09 3f 80 00       	push   $0x803f09
  8018fb:	e8 17 f7 ff ff       	call   801017 <file_open>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801906:	74 08                	je     801910 <fs_test+0xb6>
  801908:	85 c0                	test   %eax,%eax
  80190a:	0f 88 26 02 00 00    	js     801b36 <fs_test+0x2dc>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801910:	85 c0                	test   %eax,%eax
  801912:	0f 84 30 02 00 00    	je     801b48 <fs_test+0x2ee>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801918:	83 ec 08             	sub    $0x8,%esp
  80191b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191e:	50                   	push   %eax
  80191f:	68 2d 3f 80 00       	push   $0x803f2d
  801924:	e8 ee f6 ff ff       	call   801017 <file_open>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	0f 88 28 02 00 00    	js     801b5c <fs_test+0x302>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	68 4d 3f 80 00       	push   $0x803f4d
  80193c:	e8 8c 04 00 00       	call   801dcd <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801941:	83 c4 0c             	add    $0xc,%esp
  801944:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801947:	50                   	push   %eax
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 f4             	pushl  -0xc(%ebp)
  80194d:	e8 a0 f3 ff ff       	call   800cf2 <file_get_block>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	0f 88 11 02 00 00    	js     801b6e <fs_test+0x314>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	68 94 40 80 00       	push   $0x804094
  801965:	ff 75 f0             	pushl  -0x10(%ebp)
  801968:	e8 89 0a 00 00       	call   8023f6 <strcmp>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	0f 85 08 02 00 00    	jne    801b80 <fs_test+0x326>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801978:	83 ec 0c             	sub    $0xc,%esp
  80197b:	68 73 3f 80 00       	push   $0x803f73
  801980:	e8 48 04 00 00       	call   801dcd <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801988:	0f b6 10             	movzbl (%eax),%edx
  80198b:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801990:	c1 e8 0c             	shr    $0xc,%eax
  801993:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	a8 40                	test   $0x40,%al
  80199f:	0f 84 ef 01 00 00    	je     801b94 <fs_test+0x33a>
	file_flush(f);
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ab:	e8 1c f8 ff ff       	call   8011cc <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b3:	c1 e8 0c             	shr    $0xc,%eax
  8019b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	a8 40                	test   $0x40,%al
  8019c2:	0f 85 e2 01 00 00    	jne    801baa <fs_test+0x350>
	cprintf("file_flush is good\n");
  8019c8:	83 ec 0c             	sub    $0xc,%esp
  8019cb:	68 a7 3f 80 00       	push   $0x803fa7
  8019d0:	e8 f8 03 00 00       	call   801dcd <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8019d5:	83 c4 08             	add    $0x8,%esp
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 f4             	pushl  -0xc(%ebp)
  8019dd:	e8 01 f7 ff ff       	call   8010e3 <file_set_size>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	0f 88 d3 01 00 00    	js     801bc0 <fs_test+0x366>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  8019ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f0:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8019f7:	0f 85 d5 01 00 00    	jne    801bd2 <fs_test+0x378>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019fd:	c1 e8 0c             	shr    $0xc,%eax
  801a00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a07:	a8 40                	test   $0x40,%al
  801a09:	0f 85 d9 01 00 00    	jne    801be8 <fs_test+0x38e>
	cprintf("file_truncate is good\n");
  801a0f:	83 ec 0c             	sub    $0xc,%esp
  801a12:	68 fb 3f 80 00       	push   $0x803ffb
  801a17:	e8 b1 03 00 00       	call   801dcd <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801a1c:	c7 04 24 94 40 80 00 	movl   $0x804094,(%esp)
  801a23:	e8 cc 08 00 00       	call   8022f4 <strlen>
  801a28:	83 c4 08             	add    $0x8,%esp
  801a2b:	50                   	push   %eax
  801a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2f:	e8 af f6 ff ff       	call   8010e3 <file_set_size>
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	85 c0                	test   %eax,%eax
  801a39:	0f 88 bf 01 00 00    	js     801bfe <fs_test+0x3a4>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a42:	89 c2                	mov    %eax,%edx
  801a44:	c1 ea 0c             	shr    $0xc,%edx
  801a47:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a4e:	f6 c2 40             	test   $0x40,%dl
  801a51:	0f 85 b9 01 00 00    	jne    801c10 <fs_test+0x3b6>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a5d:	52                   	push   %edx
  801a5e:	6a 00                	push   $0x0
  801a60:	50                   	push   %eax
  801a61:	e8 8c f2 ff ff       	call   800cf2 <file_get_block>
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	0f 88 b5 01 00 00    	js     801c26 <fs_test+0x3cc>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	68 94 40 80 00       	push   $0x804094
  801a79:	ff 75 f0             	pushl  -0x10(%ebp)
  801a7c:	e8 b6 08 00 00       	call   802337 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a84:	c1 e8 0c             	shr    $0xc,%eax
  801a87:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	a8 40                	test   $0x40,%al
  801a93:	0f 84 9f 01 00 00    	je     801c38 <fs_test+0x3de>
	file_flush(f);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	e8 28 f7 ff ff       	call   8011cc <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa7:	c1 e8 0c             	shr    $0xc,%eax
  801aaa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	a8 40                	test   $0x40,%al
  801ab6:	0f 85 92 01 00 00    	jne    801c4e <fs_test+0x3f4>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abf:	c1 e8 0c             	shr    $0xc,%eax
  801ac2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ac9:	a8 40                	test   $0x40,%al
  801acb:	0f 85 93 01 00 00    	jne    801c64 <fs_test+0x40a>
	cprintf("file rewrite is good\n");
  801ad1:	83 ec 0c             	sub    $0xc,%esp
  801ad4:	68 3b 40 80 00       	push   $0x80403b
  801ad9:	e8 ef 02 00 00       	call   801dcd <cprintf>
}
  801ade:	83 c4 10             	add    $0x10,%esp
  801ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801ae6:	50                   	push   %eax
  801ae7:	68 ac 3e 80 00       	push   $0x803eac
  801aec:	6a 12                	push   $0x12
  801aee:	68 bf 3e 80 00       	push   $0x803ebf
  801af3:	e8 ee 01 00 00       	call   801ce6 <_panic>
		panic("alloc_block: %e", r);
  801af8:	50                   	push   %eax
  801af9:	68 c9 3e 80 00       	push   $0x803ec9
  801afe:	6a 17                	push   $0x17
  801b00:	68 bf 3e 80 00       	push   $0x803ebf
  801b05:	e8 dc 01 00 00       	call   801ce6 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801b0a:	68 d9 3e 80 00       	push   $0x803ed9
  801b0f:	68 1d 3b 80 00       	push   $0x803b1d
  801b14:	6a 19                	push   $0x19
  801b16:	68 bf 3e 80 00       	push   $0x803ebf
  801b1b:	e8 c6 01 00 00       	call   801ce6 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801b20:	68 54 40 80 00       	push   $0x804054
  801b25:	68 1d 3b 80 00       	push   $0x803b1d
  801b2a:	6a 1b                	push   $0x1b
  801b2c:	68 bf 3e 80 00       	push   $0x803ebf
  801b31:	e8 b0 01 00 00       	call   801ce6 <_panic>
		panic("file_open /not-found: %e", r);
  801b36:	50                   	push   %eax
  801b37:	68 14 3f 80 00       	push   $0x803f14
  801b3c:	6a 1f                	push   $0x1f
  801b3e:	68 bf 3e 80 00       	push   $0x803ebf
  801b43:	e8 9e 01 00 00       	call   801ce6 <_panic>
		panic("file_open /not-found succeeded!");
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	68 74 40 80 00       	push   $0x804074
  801b50:	6a 21                	push   $0x21
  801b52:	68 bf 3e 80 00       	push   $0x803ebf
  801b57:	e8 8a 01 00 00       	call   801ce6 <_panic>
		panic("file_open /newmotd: %e", r);
  801b5c:	50                   	push   %eax
  801b5d:	68 36 3f 80 00       	push   $0x803f36
  801b62:	6a 23                	push   $0x23
  801b64:	68 bf 3e 80 00       	push   $0x803ebf
  801b69:	e8 78 01 00 00       	call   801ce6 <_panic>
		panic("file_get_block: %e", r);
  801b6e:	50                   	push   %eax
  801b6f:	68 60 3f 80 00       	push   $0x803f60
  801b74:	6a 27                	push   $0x27
  801b76:	68 bf 3e 80 00       	push   $0x803ebf
  801b7b:	e8 66 01 00 00       	call   801ce6 <_panic>
		panic("file_get_block returned wrong data");
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 bc 40 80 00       	push   $0x8040bc
  801b88:	6a 29                	push   $0x29
  801b8a:	68 bf 3e 80 00       	push   $0x803ebf
  801b8f:	e8 52 01 00 00       	call   801ce6 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b94:	68 8c 3f 80 00       	push   $0x803f8c
  801b99:	68 1d 3b 80 00       	push   $0x803b1d
  801b9e:	6a 2d                	push   $0x2d
  801ba0:	68 bf 3e 80 00       	push   $0x803ebf
  801ba5:	e8 3c 01 00 00       	call   801ce6 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801baa:	68 8b 3f 80 00       	push   $0x803f8b
  801baf:	68 1d 3b 80 00       	push   $0x803b1d
  801bb4:	6a 2f                	push   $0x2f
  801bb6:	68 bf 3e 80 00       	push   $0x803ebf
  801bbb:	e8 26 01 00 00       	call   801ce6 <_panic>
		panic("file_set_size: %e", r);
  801bc0:	50                   	push   %eax
  801bc1:	68 bb 3f 80 00       	push   $0x803fbb
  801bc6:	6a 33                	push   $0x33
  801bc8:	68 bf 3e 80 00       	push   $0x803ebf
  801bcd:	e8 14 01 00 00       	call   801ce6 <_panic>
	assert(f->f_direct[0] == 0);
  801bd2:	68 cd 3f 80 00       	push   $0x803fcd
  801bd7:	68 1d 3b 80 00       	push   $0x803b1d
  801bdc:	6a 34                	push   $0x34
  801bde:	68 bf 3e 80 00       	push   $0x803ebf
  801be3:	e8 fe 00 00 00       	call   801ce6 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801be8:	68 e1 3f 80 00       	push   $0x803fe1
  801bed:	68 1d 3b 80 00       	push   $0x803b1d
  801bf2:	6a 35                	push   $0x35
  801bf4:	68 bf 3e 80 00       	push   $0x803ebf
  801bf9:	e8 e8 00 00 00       	call   801ce6 <_panic>
		panic("file_set_size 2: %e", r);
  801bfe:	50                   	push   %eax
  801bff:	68 12 40 80 00       	push   $0x804012
  801c04:	6a 39                	push   $0x39
  801c06:	68 bf 3e 80 00       	push   $0x803ebf
  801c0b:	e8 d6 00 00 00       	call   801ce6 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c10:	68 e1 3f 80 00       	push   $0x803fe1
  801c15:	68 1d 3b 80 00       	push   $0x803b1d
  801c1a:	6a 3a                	push   $0x3a
  801c1c:	68 bf 3e 80 00       	push   $0x803ebf
  801c21:	e8 c0 00 00 00       	call   801ce6 <_panic>
		panic("file_get_block 2: %e", r);
  801c26:	50                   	push   %eax
  801c27:	68 26 40 80 00       	push   $0x804026
  801c2c:	6a 3c                	push   $0x3c
  801c2e:	68 bf 3e 80 00       	push   $0x803ebf
  801c33:	e8 ae 00 00 00       	call   801ce6 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801c38:	68 8c 3f 80 00       	push   $0x803f8c
  801c3d:	68 1d 3b 80 00       	push   $0x803b1d
  801c42:	6a 3e                	push   $0x3e
  801c44:	68 bf 3e 80 00       	push   $0x803ebf
  801c49:	e8 98 00 00 00       	call   801ce6 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801c4e:	68 8b 3f 80 00       	push   $0x803f8b
  801c53:	68 1d 3b 80 00       	push   $0x803b1d
  801c58:	6a 40                	push   $0x40
  801c5a:	68 bf 3e 80 00       	push   $0x803ebf
  801c5f:	e8 82 00 00 00       	call   801ce6 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c64:	68 e1 3f 80 00       	push   $0x803fe1
  801c69:	68 1d 3b 80 00       	push   $0x803b1d
  801c6e:	6a 41                	push   $0x41
  801c70:	68 bf 3e 80 00       	push   $0x803ebf
  801c75:	e8 6c 00 00 00       	call   801ce6 <_panic>

00801c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801c7a:	f3 0f 1e fb          	endbr32 
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	56                   	push   %esi
  801c82:	53                   	push   %ebx
  801c83:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c86:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  801c89:	e8 de 0a 00 00       	call   80276c <sys_getenvid>
	if (id >= 0)
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 12                	js     801ca4 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  801c92:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c97:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c9a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c9f:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801ca4:	85 db                	test   %ebx,%ebx
  801ca6:	7e 07                	jle    801caf <libmain+0x35>
		binaryname = argv[0];
  801ca8:	8b 06                	mov    (%esi),%eax
  801caa:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801caf:	83 ec 08             	sub    $0x8,%esp
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	e8 54 fb ff ff       	call   80180d <umain>

	// exit gracefully
	exit();
  801cb9:	e8 0a 00 00 00       	call   801cc8 <exit>
}
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    

00801cc8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801cc8:	f3 0f 1e fb          	endbr32 
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801cd2:	e8 bd 0f 00 00       	call   802c94 <close_all>
	sys_env_destroy(0);
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 65 0a 00 00       	call   802746 <sys_env_destroy>
}
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ce6:	f3 0f 1e fb          	endbr32 
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	56                   	push   %esi
  801cee:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801cef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cf2:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801cf8:	e8 6f 0a 00 00       	call   80276c <sys_getenvid>
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	56                   	push   %esi
  801d07:	50                   	push   %eax
  801d08:	68 ec 40 80 00       	push   $0x8040ec
  801d0d:	e8 bb 00 00 00       	call   801dcd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d12:	83 c4 18             	add    $0x18,%esp
  801d15:	53                   	push   %ebx
  801d16:	ff 75 10             	pushl  0x10(%ebp)
  801d19:	e8 5a 00 00 00       	call   801d78 <vcprintf>
	cprintf("\n");
  801d1e:	c7 04 24 8b 44 80 00 	movl   $0x80448b,(%esp)
  801d25:	e8 a3 00 00 00       	call   801dcd <cprintf>
  801d2a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d2d:	cc                   	int3   
  801d2e:	eb fd                	jmp    801d2d <_panic+0x47>

00801d30 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	53                   	push   %ebx
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801d3e:	8b 13                	mov    (%ebx),%edx
  801d40:	8d 42 01             	lea    0x1(%edx),%eax
  801d43:	89 03                	mov    %eax,(%ebx)
  801d45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d48:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d4c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d51:	74 09                	je     801d5c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801d53:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801d5c:	83 ec 08             	sub    $0x8,%esp
  801d5f:	68 ff 00 00 00       	push   $0xff
  801d64:	8d 43 08             	lea    0x8(%ebx),%eax
  801d67:	50                   	push   %eax
  801d68:	e8 87 09 00 00       	call   8026f4 <sys_cputs>
		b->idx = 0;
  801d6d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	eb db                	jmp    801d53 <putch+0x23>

00801d78 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d78:	f3 0f 1e fb          	endbr32 
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d85:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d8c:	00 00 00 
	b.cnt = 0;
  801d8f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d96:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801da5:	50                   	push   %eax
  801da6:	68 30 1d 80 00       	push   $0x801d30
  801dab:	e8 80 01 00 00       	call   801f30 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801db0:	83 c4 08             	add    $0x8,%esp
  801db3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801db9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801dbf:	50                   	push   %eax
  801dc0:	e8 2f 09 00 00       	call   8026f4 <sys_cputs>

	return b.cnt;
}
  801dc5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801dcd:	f3 0f 1e fb          	endbr32 
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dd7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801dda:	50                   	push   %eax
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	e8 95 ff ff ff       	call   801d78 <vcprintf>
	va_end(ap);

	return cnt;
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	57                   	push   %edi
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
  801deb:	83 ec 1c             	sub    $0x1c,%esp
  801dee:	89 c7                	mov    %eax,%edi
  801df0:	89 d6                	mov    %edx,%esi
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df8:	89 d1                	mov    %edx,%ecx
  801dfa:	89 c2                	mov    %eax,%edx
  801dfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801e12:	39 c2                	cmp    %eax,%edx
  801e14:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801e17:	72 3e                	jb     801e57 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	ff 75 18             	pushl  0x18(%ebp)
  801e1f:	83 eb 01             	sub    $0x1,%ebx
  801e22:	53                   	push   %ebx
  801e23:	50                   	push   %eax
  801e24:	83 ec 08             	sub    $0x8,%esp
  801e27:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e2a:	ff 75 e0             	pushl  -0x20(%ebp)
  801e2d:	ff 75 dc             	pushl  -0x24(%ebp)
  801e30:	ff 75 d8             	pushl  -0x28(%ebp)
  801e33:	e8 38 1a 00 00       	call   803870 <__udivdi3>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	52                   	push   %edx
  801e3c:	50                   	push   %eax
  801e3d:	89 f2                	mov    %esi,%edx
  801e3f:	89 f8                	mov    %edi,%eax
  801e41:	e8 9f ff ff ff       	call   801de5 <printnum>
  801e46:	83 c4 20             	add    $0x20,%esp
  801e49:	eb 13                	jmp    801e5e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e4b:	83 ec 08             	sub    $0x8,%esp
  801e4e:	56                   	push   %esi
  801e4f:	ff 75 18             	pushl  0x18(%ebp)
  801e52:	ff d7                	call   *%edi
  801e54:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801e57:	83 eb 01             	sub    $0x1,%ebx
  801e5a:	85 db                	test   %ebx,%ebx
  801e5c:	7f ed                	jg     801e4b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e5e:	83 ec 08             	sub    $0x8,%esp
  801e61:	56                   	push   %esi
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e68:	ff 75 e0             	pushl  -0x20(%ebp)
  801e6b:	ff 75 dc             	pushl  -0x24(%ebp)
  801e6e:	ff 75 d8             	pushl  -0x28(%ebp)
  801e71:	e8 0a 1b 00 00       	call   803980 <__umoddi3>
  801e76:	83 c4 14             	add    $0x14,%esp
  801e79:	0f be 80 0f 41 80 00 	movsbl 0x80410f(%eax),%eax
  801e80:	50                   	push   %eax
  801e81:	ff d7                	call   *%edi
}
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e89:	5b                   	pop    %ebx
  801e8a:	5e                   	pop    %esi
  801e8b:	5f                   	pop    %edi
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    

00801e8e <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e8e:	83 fa 01             	cmp    $0x1,%edx
  801e91:	7f 13                	jg     801ea6 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801e93:	85 d2                	test   %edx,%edx
  801e95:	74 1c                	je     801eb3 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801e97:	8b 10                	mov    (%eax),%edx
  801e99:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e9c:	89 08                	mov    %ecx,(%eax)
  801e9e:	8b 02                	mov    (%edx),%eax
  801ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea5:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801ea6:	8b 10                	mov    (%eax),%edx
  801ea8:	8d 4a 08             	lea    0x8(%edx),%ecx
  801eab:	89 08                	mov    %ecx,(%eax)
  801ead:	8b 02                	mov    (%edx),%eax
  801eaf:	8b 52 04             	mov    0x4(%edx),%edx
  801eb2:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801eb3:	8b 10                	mov    (%eax),%edx
  801eb5:	8d 4a 04             	lea    0x4(%edx),%ecx
  801eb8:	89 08                	mov    %ecx,(%eax)
  801eba:	8b 02                	mov    (%edx),%eax
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ec1:	c3                   	ret    

00801ec2 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801ec2:	83 fa 01             	cmp    $0x1,%edx
  801ec5:	7f 0f                	jg     801ed6 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801ec7:	85 d2                	test   %edx,%edx
  801ec9:	74 18                	je     801ee3 <getint+0x21>
		return va_arg(*ap, long);
  801ecb:	8b 10                	mov    (%eax),%edx
  801ecd:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ed0:	89 08                	mov    %ecx,(%eax)
  801ed2:	8b 02                	mov    (%edx),%eax
  801ed4:	99                   	cltd   
  801ed5:	c3                   	ret    
		return va_arg(*ap, long long);
  801ed6:	8b 10                	mov    (%eax),%edx
  801ed8:	8d 4a 08             	lea    0x8(%edx),%ecx
  801edb:	89 08                	mov    %ecx,(%eax)
  801edd:	8b 02                	mov    (%edx),%eax
  801edf:	8b 52 04             	mov    0x4(%edx),%edx
  801ee2:	c3                   	ret    
	else
		return va_arg(*ap, int);
  801ee3:	8b 10                	mov    (%eax),%edx
  801ee5:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ee8:	89 08                	mov    %ecx,(%eax)
  801eea:	8b 02                	mov    (%edx),%eax
  801eec:	99                   	cltd   
}
  801eed:	c3                   	ret    

00801eee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801eee:	f3 0f 1e fb          	endbr32 
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801ef8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801efc:	8b 10                	mov    (%eax),%edx
  801efe:	3b 50 04             	cmp    0x4(%eax),%edx
  801f01:	73 0a                	jae    801f0d <sprintputch+0x1f>
		*b->buf++ = ch;
  801f03:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f06:	89 08                	mov    %ecx,(%eax)
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	88 02                	mov    %al,(%edx)
}
  801f0d:	5d                   	pop    %ebp
  801f0e:	c3                   	ret    

00801f0f <printfmt>:
{
  801f0f:	f3 0f 1e fb          	endbr32 
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801f19:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801f1c:	50                   	push   %eax
  801f1d:	ff 75 10             	pushl  0x10(%ebp)
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	e8 05 00 00 00       	call   801f30 <vprintfmt>
}
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <vprintfmt>:
{
  801f30:	f3 0f 1e fb          	endbr32 
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	57                   	push   %edi
  801f38:	56                   	push   %esi
  801f39:	53                   	push   %ebx
  801f3a:	83 ec 2c             	sub    $0x2c,%esp
  801f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801f40:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f43:	8b 7d 10             	mov    0x10(%ebp),%edi
  801f46:	e9 86 02 00 00       	jmp    8021d1 <vprintfmt+0x2a1>
		padc = ' ';
  801f4b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801f4f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801f56:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801f5d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801f64:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801f69:	8d 47 01             	lea    0x1(%edi),%eax
  801f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f6f:	0f b6 17             	movzbl (%edi),%edx
  801f72:	8d 42 dd             	lea    -0x23(%edx),%eax
  801f75:	3c 55                	cmp    $0x55,%al
  801f77:	0f 87 df 02 00 00    	ja     80225c <vprintfmt+0x32c>
  801f7d:	0f b6 c0             	movzbl %al,%eax
  801f80:	3e ff 24 85 60 42 80 	notrack jmp *0x804260(,%eax,4)
  801f87:	00 
  801f88:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801f8b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801f8f:	eb d8                	jmp    801f69 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801f91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801f94:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801f98:	eb cf                	jmp    801f69 <vprintfmt+0x39>
  801f9a:	0f b6 d2             	movzbl %dl,%edx
  801f9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801fa8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801fab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801faf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801fb2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801fb5:	83 f9 09             	cmp    $0x9,%ecx
  801fb8:	77 52                	ja     80200c <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801fba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801fbd:	eb e9                	jmp    801fa8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc2:	8d 50 04             	lea    0x4(%eax),%edx
  801fc5:	89 55 14             	mov    %edx,0x14(%ebp)
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801fcd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801fd0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fd4:	79 93                	jns    801f69 <vprintfmt+0x39>
				width = precision, precision = -1;
  801fd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fdc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801fe3:	eb 84                	jmp    801f69 <vprintfmt+0x39>
  801fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	ba 00 00 00 00       	mov    $0x0,%edx
  801fef:	0f 49 d0             	cmovns %eax,%edx
  801ff2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801ff5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ff8:	e9 6c ff ff ff       	jmp    801f69 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801ffd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  802000:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  802007:	e9 5d ff ff ff       	jmp    801f69 <vprintfmt+0x39>
  80200c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80200f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802012:	eb bc                	jmp    801fd0 <vprintfmt+0xa0>
			lflag++;
  802014:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  802017:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80201a:	e9 4a ff ff ff       	jmp    801f69 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80201f:	8b 45 14             	mov    0x14(%ebp),%eax
  802022:	8d 50 04             	lea    0x4(%eax),%edx
  802025:	89 55 14             	mov    %edx,0x14(%ebp)
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	56                   	push   %esi
  80202c:	ff 30                	pushl  (%eax)
  80202e:	ff d3                	call   *%ebx
			break;
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	e9 96 01 00 00       	jmp    8021ce <vprintfmt+0x29e>
			err = va_arg(ap, int);
  802038:	8b 45 14             	mov    0x14(%ebp),%eax
  80203b:	8d 50 04             	lea    0x4(%eax),%edx
  80203e:	89 55 14             	mov    %edx,0x14(%ebp)
  802041:	8b 00                	mov    (%eax),%eax
  802043:	99                   	cltd   
  802044:	31 d0                	xor    %edx,%eax
  802046:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802048:	83 f8 0f             	cmp    $0xf,%eax
  80204b:	7f 20                	jg     80206d <vprintfmt+0x13d>
  80204d:	8b 14 85 c0 43 80 00 	mov    0x8043c0(,%eax,4),%edx
  802054:	85 d2                	test   %edx,%edx
  802056:	74 15                	je     80206d <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  802058:	52                   	push   %edx
  802059:	68 2f 3b 80 00       	push   $0x803b2f
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	e8 aa fe ff ff       	call   801f0f <printfmt>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	e9 61 01 00 00       	jmp    8021ce <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80206d:	50                   	push   %eax
  80206e:	68 27 41 80 00       	push   $0x804127
  802073:	56                   	push   %esi
  802074:	53                   	push   %ebx
  802075:	e8 95 fe ff ff       	call   801f0f <printfmt>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	e9 4c 01 00 00       	jmp    8021ce <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  802082:	8b 45 14             	mov    0x14(%ebp),%eax
  802085:	8d 50 04             	lea    0x4(%eax),%edx
  802088:	89 55 14             	mov    %edx,0x14(%ebp)
  80208b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80208d:	85 c9                	test   %ecx,%ecx
  80208f:	b8 20 41 80 00       	mov    $0x804120,%eax
  802094:	0f 45 c1             	cmovne %ecx,%eax
  802097:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80209a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80209e:	7e 06                	jle    8020a6 <vprintfmt+0x176>
  8020a0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8020a4:	75 0d                	jne    8020b3 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020a9:	89 c7                	mov    %eax,%edi
  8020ab:	03 45 e0             	add    -0x20(%ebp),%eax
  8020ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020b1:	eb 57                	jmp    80210a <vprintfmt+0x1da>
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8020b9:	ff 75 cc             	pushl  -0x34(%ebp)
  8020bc:	e8 4f 02 00 00       	call   802310 <strnlen>
  8020c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020c4:	29 c2                	sub    %eax,%edx
  8020c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8020c9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8020cc:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8020d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8020d3:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8020d5:	85 db                	test   %ebx,%ebx
  8020d7:	7e 10                	jle    8020e9 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	56                   	push   %esi
  8020dd:	57                   	push   %edi
  8020de:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8020e1:	83 eb 01             	sub    $0x1,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	eb ec                	jmp    8020d5 <vprintfmt+0x1a5>
  8020e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8020ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ef:	85 d2                	test   %edx,%edx
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	0f 49 c2             	cmovns %edx,%eax
  8020f9:	29 c2                	sub    %eax,%edx
  8020fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8020fe:	eb a6                	jmp    8020a6 <vprintfmt+0x176>
					putch(ch, putdat);
  802100:	83 ec 08             	sub    $0x8,%esp
  802103:	56                   	push   %esi
  802104:	52                   	push   %edx
  802105:	ff d3                	call   *%ebx
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80210d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80210f:	83 c7 01             	add    $0x1,%edi
  802112:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802116:	0f be d0             	movsbl %al,%edx
  802119:	85 d2                	test   %edx,%edx
  80211b:	74 42                	je     80215f <vprintfmt+0x22f>
  80211d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802121:	78 06                	js     802129 <vprintfmt+0x1f9>
  802123:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802127:	78 1e                	js     802147 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  802129:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80212d:	74 d1                	je     802100 <vprintfmt+0x1d0>
  80212f:	0f be c0             	movsbl %al,%eax
  802132:	83 e8 20             	sub    $0x20,%eax
  802135:	83 f8 5e             	cmp    $0x5e,%eax
  802138:	76 c6                	jbe    802100 <vprintfmt+0x1d0>
					putch('?', putdat);
  80213a:	83 ec 08             	sub    $0x8,%esp
  80213d:	56                   	push   %esi
  80213e:	6a 3f                	push   $0x3f
  802140:	ff d3                	call   *%ebx
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	eb c3                	jmp    80210a <vprintfmt+0x1da>
  802147:	89 cf                	mov    %ecx,%edi
  802149:	eb 0e                	jmp    802159 <vprintfmt+0x229>
				putch(' ', putdat);
  80214b:	83 ec 08             	sub    $0x8,%esp
  80214e:	56                   	push   %esi
  80214f:	6a 20                	push   $0x20
  802151:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  802153:	83 ef 01             	sub    $0x1,%edi
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	85 ff                	test   %edi,%edi
  80215b:	7f ee                	jg     80214b <vprintfmt+0x21b>
  80215d:	eb 6f                	jmp    8021ce <vprintfmt+0x29e>
  80215f:	89 cf                	mov    %ecx,%edi
  802161:	eb f6                	jmp    802159 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  802163:	89 ca                	mov    %ecx,%edx
  802165:	8d 45 14             	lea    0x14(%ebp),%eax
  802168:	e8 55 fd ff ff       	call   801ec2 <getint>
  80216d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802170:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  802173:	85 d2                	test   %edx,%edx
  802175:	78 0b                	js     802182 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  802177:	89 d1                	mov    %edx,%ecx
  802179:	89 c2                	mov    %eax,%edx
			base = 10;
  80217b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802180:	eb 32                	jmp    8021b4 <vprintfmt+0x284>
				putch('-', putdat);
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	56                   	push   %esi
  802186:	6a 2d                	push   $0x2d
  802188:	ff d3                	call   *%ebx
				num = -(long long) num;
  80218a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80218d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802190:	f7 da                	neg    %edx
  802192:	83 d1 00             	adc    $0x0,%ecx
  802195:	f7 d9                	neg    %ecx
  802197:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80219a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80219f:	eb 13                	jmp    8021b4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8021a1:	89 ca                	mov    %ecx,%edx
  8021a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8021a6:	e8 e3 fc ff ff       	call   801e8e <getuint>
  8021ab:	89 d1                	mov    %edx,%ecx
  8021ad:	89 c2                	mov    %eax,%edx
			base = 10;
  8021af:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8021b4:	83 ec 0c             	sub    $0xc,%esp
  8021b7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8021bb:	57                   	push   %edi
  8021bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8021bf:	50                   	push   %eax
  8021c0:	51                   	push   %ecx
  8021c1:	52                   	push   %edx
  8021c2:	89 f2                	mov    %esi,%edx
  8021c4:	89 d8                	mov    %ebx,%eax
  8021c6:	e8 1a fc ff ff       	call   801de5 <printnum>
			break;
  8021cb:	83 c4 20             	add    $0x20,%esp
{
  8021ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8021d1:	83 c7 01             	add    $0x1,%edi
  8021d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8021d8:	83 f8 25             	cmp    $0x25,%eax
  8021db:	0f 84 6a fd ff ff    	je     801f4b <vprintfmt+0x1b>
			if (ch == '\0')
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	0f 84 93 00 00 00    	je     80227c <vprintfmt+0x34c>
			putch(ch, putdat);
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	56                   	push   %esi
  8021ed:	50                   	push   %eax
  8021ee:	ff d3                	call   *%ebx
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	eb dc                	jmp    8021d1 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8021f5:	89 ca                	mov    %ecx,%edx
  8021f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8021fa:	e8 8f fc ff ff       	call   801e8e <getuint>
  8021ff:	89 d1                	mov    %edx,%ecx
  802201:	89 c2                	mov    %eax,%edx
			base = 8;
  802203:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  802208:	eb aa                	jmp    8021b4 <vprintfmt+0x284>
			putch('0', putdat);
  80220a:	83 ec 08             	sub    $0x8,%esp
  80220d:	56                   	push   %esi
  80220e:	6a 30                	push   $0x30
  802210:	ff d3                	call   *%ebx
			putch('x', putdat);
  802212:	83 c4 08             	add    $0x8,%esp
  802215:	56                   	push   %esi
  802216:	6a 78                	push   $0x78
  802218:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80221a:	8b 45 14             	mov    0x14(%ebp),%eax
  80221d:	8d 50 04             	lea    0x4(%eax),%edx
  802220:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  802223:	8b 10                	mov    (%eax),%edx
  802225:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80222a:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80222d:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  802232:	eb 80                	jmp    8021b4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  802234:	89 ca                	mov    %ecx,%edx
  802236:	8d 45 14             	lea    0x14(%ebp),%eax
  802239:	e8 50 fc ff ff       	call   801e8e <getuint>
  80223e:	89 d1                	mov    %edx,%ecx
  802240:	89 c2                	mov    %eax,%edx
			base = 16;
  802242:	b8 10 00 00 00       	mov    $0x10,%eax
  802247:	e9 68 ff ff ff       	jmp    8021b4 <vprintfmt+0x284>
			putch(ch, putdat);
  80224c:	83 ec 08             	sub    $0x8,%esp
  80224f:	56                   	push   %esi
  802250:	6a 25                	push   $0x25
  802252:	ff d3                	call   *%ebx
			break;
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	e9 72 ff ff ff       	jmp    8021ce <vprintfmt+0x29e>
			putch('%', putdat);
  80225c:	83 ec 08             	sub    $0x8,%esp
  80225f:	56                   	push   %esi
  802260:	6a 25                	push   $0x25
  802262:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 f8                	mov    %edi,%eax
  802269:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80226d:	74 05                	je     802274 <vprintfmt+0x344>
  80226f:	83 e8 01             	sub    $0x1,%eax
  802272:	eb f5                	jmp    802269 <vprintfmt+0x339>
  802274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802277:	e9 52 ff ff ff       	jmp    8021ce <vprintfmt+0x29e>
}
  80227c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    

00802284 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802284:	f3 0f 1e fb          	endbr32 
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 18             	sub    $0x18,%esp
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802294:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802297:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80229b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80229e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	74 26                	je     8022cf <vsnprintf+0x4b>
  8022a9:	85 d2                	test   %edx,%edx
  8022ab:	7e 22                	jle    8022cf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022ad:	ff 75 14             	pushl  0x14(%ebp)
  8022b0:	ff 75 10             	pushl  0x10(%ebp)
  8022b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022b6:	50                   	push   %eax
  8022b7:	68 ee 1e 80 00       	push   $0x801eee
  8022bc:	e8 6f fc ff ff       	call   801f30 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	83 c4 10             	add    $0x10,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    
		return -E_INVAL;
  8022cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d4:	eb f7                	jmp    8022cd <vsnprintf+0x49>

008022d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022d6:	f3 0f 1e fb          	endbr32 
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8022e3:	50                   	push   %eax
  8022e4:	ff 75 10             	pushl  0x10(%ebp)
  8022e7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ea:	ff 75 08             	pushl  0x8(%ebp)
  8022ed:	e8 92 ff ff ff       	call   802284 <vsnprintf>
	va_end(ap);

	return rc;
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8022f4:	f3 0f 1e fb          	endbr32 
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802307:	74 05                	je     80230e <strlen+0x1a>
		n++;
  802309:	83 c0 01             	add    $0x1,%eax
  80230c:	eb f5                	jmp    802303 <strlen+0xf>
	return n;
}
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    

00802310 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80231d:	b8 00 00 00 00       	mov    $0x0,%eax
  802322:	39 d0                	cmp    %edx,%eax
  802324:	74 0d                	je     802333 <strnlen+0x23>
  802326:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80232a:	74 05                	je     802331 <strnlen+0x21>
		n++;
  80232c:	83 c0 01             	add    $0x1,%eax
  80232f:	eb f1                	jmp    802322 <strnlen+0x12>
  802331:	89 c2                	mov    %eax,%edx
	return n;
}
  802333:	89 d0                	mov    %edx,%eax
  802335:	5d                   	pop    %ebp
  802336:	c3                   	ret    

00802337 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802337:	f3 0f 1e fb          	endbr32 
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	53                   	push   %ebx
  80233f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80234e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  802351:	83 c0 01             	add    $0x1,%eax
  802354:	84 d2                	test   %dl,%dl
  802356:	75 f2                	jne    80234a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  802358:	89 c8                	mov    %ecx,%eax
  80235a:	5b                   	pop    %ebx
  80235b:	5d                   	pop    %ebp
  80235c:	c3                   	ret    

0080235d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80235d:	f3 0f 1e fb          	endbr32 
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	53                   	push   %ebx
  802365:	83 ec 10             	sub    $0x10,%esp
  802368:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80236b:	53                   	push   %ebx
  80236c:	e8 83 ff ff ff       	call   8022f4 <strlen>
  802371:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	01 d8                	add    %ebx,%eax
  802379:	50                   	push   %eax
  80237a:	e8 b8 ff ff ff       	call   802337 <strcpy>
	return dst;
}
  80237f:	89 d8                	mov    %ebx,%eax
  802381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802386:	f3 0f 1e fb          	endbr32 
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	56                   	push   %esi
  80238e:	53                   	push   %ebx
  80238f:	8b 75 08             	mov    0x8(%ebp),%esi
  802392:	8b 55 0c             	mov    0xc(%ebp),%edx
  802395:	89 f3                	mov    %esi,%ebx
  802397:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80239a:	89 f0                	mov    %esi,%eax
  80239c:	39 d8                	cmp    %ebx,%eax
  80239e:	74 11                	je     8023b1 <strncpy+0x2b>
		*dst++ = *src;
  8023a0:	83 c0 01             	add    $0x1,%eax
  8023a3:	0f b6 0a             	movzbl (%edx),%ecx
  8023a6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8023a9:	80 f9 01             	cmp    $0x1,%cl
  8023ac:	83 da ff             	sbb    $0xffffffff,%edx
  8023af:	eb eb                	jmp    80239c <strncpy+0x16>
	}
	return ret;
}
  8023b1:	89 f0                	mov    %esi,%eax
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5d                   	pop    %ebp
  8023b6:	c3                   	ret    

008023b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8023b7:	f3 0f 1e fb          	endbr32 
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8023c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8023c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8023cb:	85 d2                	test   %edx,%edx
  8023cd:	74 21                	je     8023f0 <strlcpy+0x39>
  8023cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8023d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8023d5:	39 c2                	cmp    %eax,%edx
  8023d7:	74 14                	je     8023ed <strlcpy+0x36>
  8023d9:	0f b6 19             	movzbl (%ecx),%ebx
  8023dc:	84 db                	test   %bl,%bl
  8023de:	74 0b                	je     8023eb <strlcpy+0x34>
			*dst++ = *src++;
  8023e0:	83 c1 01             	add    $0x1,%ecx
  8023e3:	83 c2 01             	add    $0x1,%edx
  8023e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8023e9:	eb ea                	jmp    8023d5 <strlcpy+0x1e>
  8023eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8023ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8023f0:	29 f0                	sub    %esi,%eax
}
  8023f2:	5b                   	pop    %ebx
  8023f3:	5e                   	pop    %esi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    

008023f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023f6:	f3 0f 1e fb          	endbr32 
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802400:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802403:	0f b6 01             	movzbl (%ecx),%eax
  802406:	84 c0                	test   %al,%al
  802408:	74 0c                	je     802416 <strcmp+0x20>
  80240a:	3a 02                	cmp    (%edx),%al
  80240c:	75 08                	jne    802416 <strcmp+0x20>
		p++, q++;
  80240e:	83 c1 01             	add    $0x1,%ecx
  802411:	83 c2 01             	add    $0x1,%edx
  802414:	eb ed                	jmp    802403 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802416:	0f b6 c0             	movzbl %al,%eax
  802419:	0f b6 12             	movzbl (%edx),%edx
  80241c:	29 d0                	sub    %edx,%eax
}
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    

00802420 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802420:	f3 0f 1e fb          	endbr32 
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	53                   	push   %ebx
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242e:	89 c3                	mov    %eax,%ebx
  802430:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802433:	eb 06                	jmp    80243b <strncmp+0x1b>
		n--, p++, q++;
  802435:	83 c0 01             	add    $0x1,%eax
  802438:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80243b:	39 d8                	cmp    %ebx,%eax
  80243d:	74 16                	je     802455 <strncmp+0x35>
  80243f:	0f b6 08             	movzbl (%eax),%ecx
  802442:	84 c9                	test   %cl,%cl
  802444:	74 04                	je     80244a <strncmp+0x2a>
  802446:	3a 0a                	cmp    (%edx),%cl
  802448:	74 eb                	je     802435 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80244a:	0f b6 00             	movzbl (%eax),%eax
  80244d:	0f b6 12             	movzbl (%edx),%edx
  802450:	29 d0                	sub    %edx,%eax
}
  802452:	5b                   	pop    %ebx
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
		return 0;
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	eb f6                	jmp    802452 <strncmp+0x32>

0080245c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80245c:	f3 0f 1e fb          	endbr32 
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80246a:	0f b6 10             	movzbl (%eax),%edx
  80246d:	84 d2                	test   %dl,%dl
  80246f:	74 09                	je     80247a <strchr+0x1e>
		if (*s == c)
  802471:	38 ca                	cmp    %cl,%dl
  802473:	74 0a                	je     80247f <strchr+0x23>
	for (; *s; s++)
  802475:	83 c0 01             	add    $0x1,%eax
  802478:	eb f0                	jmp    80246a <strchr+0xe>
			return (char *) s;
	return 0;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802481:	f3 0f 1e fb          	endbr32 
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80248f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  802492:	38 ca                	cmp    %cl,%dl
  802494:	74 09                	je     80249f <strfind+0x1e>
  802496:	84 d2                	test   %dl,%dl
  802498:	74 05                	je     80249f <strfind+0x1e>
	for (; *s; s++)
  80249a:	83 c0 01             	add    $0x1,%eax
  80249d:	eb f0                	jmp    80248f <strfind+0xe>
			break;
	return (char *) s;
}
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    

008024a1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8024a1:	f3 0f 1e fb          	endbr32 
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	57                   	push   %edi
  8024a9:	56                   	push   %esi
  8024aa:	53                   	push   %ebx
  8024ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8024b1:	85 c9                	test   %ecx,%ecx
  8024b3:	74 33                	je     8024e8 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	09 c8                	or     %ecx,%eax
  8024b9:	a8 03                	test   $0x3,%al
  8024bb:	75 23                	jne    8024e0 <memset+0x3f>
		c &= 0xFF;
  8024bd:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8024c1:	89 d8                	mov    %ebx,%eax
  8024c3:	c1 e0 08             	shl    $0x8,%eax
  8024c6:	89 df                	mov    %ebx,%edi
  8024c8:	c1 e7 18             	shl    $0x18,%edi
  8024cb:	89 de                	mov    %ebx,%esi
  8024cd:	c1 e6 10             	shl    $0x10,%esi
  8024d0:	09 f7                	or     %esi,%edi
  8024d2:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8024d4:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8024d7:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8024d9:	89 d7                	mov    %edx,%edi
  8024db:	fc                   	cld    
  8024dc:	f3 ab                	rep stos %eax,%es:(%edi)
  8024de:	eb 08                	jmp    8024e8 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8024e0:	89 d7                	mov    %edx,%edi
  8024e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e5:	fc                   	cld    
  8024e6:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8024e8:	89 d0                	mov    %edx,%eax
  8024ea:	5b                   	pop    %ebx
  8024eb:	5e                   	pop    %esi
  8024ec:	5f                   	pop    %edi
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    

008024ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024ef:	f3 0f 1e fb          	endbr32 
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	57                   	push   %edi
  8024f7:	56                   	push   %esi
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802501:	39 c6                	cmp    %eax,%esi
  802503:	73 32                	jae    802537 <memmove+0x48>
  802505:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802508:	39 c2                	cmp    %eax,%edx
  80250a:	76 2b                	jbe    802537 <memmove+0x48>
		s += n;
		d += n;
  80250c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80250f:	89 fe                	mov    %edi,%esi
  802511:	09 ce                	or     %ecx,%esi
  802513:	09 d6                	or     %edx,%esi
  802515:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80251b:	75 0e                	jne    80252b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80251d:	83 ef 04             	sub    $0x4,%edi
  802520:	8d 72 fc             	lea    -0x4(%edx),%esi
  802523:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802526:	fd                   	std    
  802527:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802529:	eb 09                	jmp    802534 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80252b:	83 ef 01             	sub    $0x1,%edi
  80252e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802531:	fd                   	std    
  802532:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802534:	fc                   	cld    
  802535:	eb 1a                	jmp    802551 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802537:	89 c2                	mov    %eax,%edx
  802539:	09 ca                	or     %ecx,%edx
  80253b:	09 f2                	or     %esi,%edx
  80253d:	f6 c2 03             	test   $0x3,%dl
  802540:	75 0a                	jne    80254c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802542:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802545:	89 c7                	mov    %eax,%edi
  802547:	fc                   	cld    
  802548:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80254a:	eb 05                	jmp    802551 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	fc                   	cld    
  80254f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802551:	5e                   	pop    %esi
  802552:	5f                   	pop    %edi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    

00802555 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802555:	f3 0f 1e fb          	endbr32 
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80255f:	ff 75 10             	pushl  0x10(%ebp)
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	ff 75 08             	pushl  0x8(%ebp)
  802568:	e8 82 ff ff ff       	call   8024ef <memmove>
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80256f:	f3 0f 1e fb          	endbr32 
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	56                   	push   %esi
  802577:	53                   	push   %ebx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	89 c6                	mov    %eax,%esi
  802580:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802583:	39 f0                	cmp    %esi,%eax
  802585:	74 1c                	je     8025a3 <memcmp+0x34>
		if (*s1 != *s2)
  802587:	0f b6 08             	movzbl (%eax),%ecx
  80258a:	0f b6 1a             	movzbl (%edx),%ebx
  80258d:	38 d9                	cmp    %bl,%cl
  80258f:	75 08                	jne    802599 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802591:	83 c0 01             	add    $0x1,%eax
  802594:	83 c2 01             	add    $0x1,%edx
  802597:	eb ea                	jmp    802583 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  802599:	0f b6 c1             	movzbl %cl,%eax
  80259c:	0f b6 db             	movzbl %bl,%ebx
  80259f:	29 d8                	sub    %ebx,%eax
  8025a1:	eb 05                	jmp    8025a8 <memcmp+0x39>
	}

	return 0;
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a8:	5b                   	pop    %ebx
  8025a9:	5e                   	pop    %esi
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    

008025ac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8025ac:	f3 0f 1e fb          	endbr32 
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8025b9:	89 c2                	mov    %eax,%edx
  8025bb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8025be:	39 d0                	cmp    %edx,%eax
  8025c0:	73 09                	jae    8025cb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025c2:	38 08                	cmp    %cl,(%eax)
  8025c4:	74 05                	je     8025cb <memfind+0x1f>
	for (; s < ends; s++)
  8025c6:	83 c0 01             	add    $0x1,%eax
  8025c9:	eb f3                	jmp    8025be <memfind+0x12>
			break;
	return (void *) s;
}
  8025cb:	5d                   	pop    %ebp
  8025cc:	c3                   	ret    

008025cd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025cd:	f3 0f 1e fb          	endbr32 
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	57                   	push   %edi
  8025d5:	56                   	push   %esi
  8025d6:	53                   	push   %ebx
  8025d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025dd:	eb 03                	jmp    8025e2 <strtol+0x15>
		s++;
  8025df:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8025e2:	0f b6 01             	movzbl (%ecx),%eax
  8025e5:	3c 20                	cmp    $0x20,%al
  8025e7:	74 f6                	je     8025df <strtol+0x12>
  8025e9:	3c 09                	cmp    $0x9,%al
  8025eb:	74 f2                	je     8025df <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8025ed:	3c 2b                	cmp    $0x2b,%al
  8025ef:	74 2a                	je     80261b <strtol+0x4e>
	int neg = 0;
  8025f1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8025f6:	3c 2d                	cmp    $0x2d,%al
  8025f8:	74 2b                	je     802625 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025fa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802600:	75 0f                	jne    802611 <strtol+0x44>
  802602:	80 39 30             	cmpb   $0x30,(%ecx)
  802605:	74 28                	je     80262f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802607:	85 db                	test   %ebx,%ebx
  802609:	b8 0a 00 00 00       	mov    $0xa,%eax
  80260e:	0f 44 d8             	cmove  %eax,%ebx
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802619:	eb 46                	jmp    802661 <strtol+0x94>
		s++;
  80261b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80261e:	bf 00 00 00 00       	mov    $0x0,%edi
  802623:	eb d5                	jmp    8025fa <strtol+0x2d>
		s++, neg = 1;
  802625:	83 c1 01             	add    $0x1,%ecx
  802628:	bf 01 00 00 00       	mov    $0x1,%edi
  80262d:	eb cb                	jmp    8025fa <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80262f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802633:	74 0e                	je     802643 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  802635:	85 db                	test   %ebx,%ebx
  802637:	75 d8                	jne    802611 <strtol+0x44>
		s++, base = 8;
  802639:	83 c1 01             	add    $0x1,%ecx
  80263c:	bb 08 00 00 00       	mov    $0x8,%ebx
  802641:	eb ce                	jmp    802611 <strtol+0x44>
		s += 2, base = 16;
  802643:	83 c1 02             	add    $0x2,%ecx
  802646:	bb 10 00 00 00       	mov    $0x10,%ebx
  80264b:	eb c4                	jmp    802611 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80264d:	0f be d2             	movsbl %dl,%edx
  802650:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802653:	3b 55 10             	cmp    0x10(%ebp),%edx
  802656:	7d 3a                	jge    802692 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802658:	83 c1 01             	add    $0x1,%ecx
  80265b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80265f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802661:	0f b6 11             	movzbl (%ecx),%edx
  802664:	8d 72 d0             	lea    -0x30(%edx),%esi
  802667:	89 f3                	mov    %esi,%ebx
  802669:	80 fb 09             	cmp    $0x9,%bl
  80266c:	76 df                	jbe    80264d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80266e:	8d 72 9f             	lea    -0x61(%edx),%esi
  802671:	89 f3                	mov    %esi,%ebx
  802673:	80 fb 19             	cmp    $0x19,%bl
  802676:	77 08                	ja     802680 <strtol+0xb3>
			dig = *s - 'a' + 10;
  802678:	0f be d2             	movsbl %dl,%edx
  80267b:	83 ea 57             	sub    $0x57,%edx
  80267e:	eb d3                	jmp    802653 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802680:	8d 72 bf             	lea    -0x41(%edx),%esi
  802683:	89 f3                	mov    %esi,%ebx
  802685:	80 fb 19             	cmp    $0x19,%bl
  802688:	77 08                	ja     802692 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80268a:	0f be d2             	movsbl %dl,%edx
  80268d:	83 ea 37             	sub    $0x37,%edx
  802690:	eb c1                	jmp    802653 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802696:	74 05                	je     80269d <strtol+0xd0>
		*endptr = (char *) s;
  802698:	8b 75 0c             	mov    0xc(%ebp),%esi
  80269b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80269d:	89 c2                	mov    %eax,%edx
  80269f:	f7 da                	neg    %edx
  8026a1:	85 ff                	test   %edi,%edi
  8026a3:	0f 45 c2             	cmovne %edx,%eax
}
  8026a6:	5b                   	pop    %ebx
  8026a7:	5e                   	pop    %esi
  8026a8:	5f                   	pop    %edi
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    

008026ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	57                   	push   %edi
  8026af:	56                   	push   %esi
  8026b0:	53                   	push   %ebx
  8026b1:	83 ec 1c             	sub    $0x1c,%esp
  8026b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8026ba:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8026c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026c5:	8b 75 14             	mov    0x14(%ebp),%esi
  8026c8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8026ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026ce:	74 04                	je     8026d4 <syscall+0x29>
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	7f 08                	jg     8026dc <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8026d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5f                   	pop    %edi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	50                   	push   %eax
  8026e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8026e3:	68 1f 44 80 00       	push   $0x80441f
  8026e8:	6a 23                	push   $0x23
  8026ea:	68 3c 44 80 00       	push   $0x80443c
  8026ef:	e8 f2 f5 ff ff       	call   801ce6 <_panic>

008026f4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8026f4:	f3 0f 1e fb          	endbr32 
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	ff 75 0c             	pushl  0xc(%ebp)
  802707:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	e8 92 ff ff ff       	call   8026ab <syscall>
}
  802719:	83 c4 10             	add    $0x10,%esp
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_cgetc>:

int
sys_cgetc(void)
{
  80271e:	f3 0f 1e fb          	endbr32 
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	b9 00 00 00 00       	mov    $0x0,%ecx
  802735:	ba 00 00 00 00       	mov    $0x0,%edx
  80273a:	b8 01 00 00 00       	mov    $0x1,%eax
  80273f:	e8 67 ff ff ff       	call   8026ab <syscall>
}
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802746:	f3 0f 1e fb          	endbr32 
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275b:	ba 01 00 00 00       	mov    $0x1,%edx
  802760:	b8 03 00 00 00       	mov    $0x3,%eax
  802765:	e8 41 ff ff ff       	call   8026ab <syscall>
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80276c:	f3 0f 1e fb          	endbr32 
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802783:	ba 00 00 00 00       	mov    $0x0,%edx
  802788:	b8 02 00 00 00       	mov    $0x2,%eax
  80278d:	e8 19 ff ff ff       	call   8026ab <syscall>
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <sys_yield>:

void
sys_yield(void)
{
  802794:	f3 0f 1e fb          	endbr32 
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8027ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8027b5:	e8 f1 fe ff ff       	call   8026ab <syscall>
}
  8027ba:	83 c4 10             	add    $0x10,%esp
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8027bf:	f3 0f 1e fb          	endbr32 
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	ff 75 10             	pushl  0x10(%ebp)
  8027d0:	ff 75 0c             	pushl  0xc(%ebp)
  8027d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027d6:	ba 01 00 00 00       	mov    $0x1,%edx
  8027db:	b8 04 00 00 00       	mov    $0x4,%eax
  8027e0:	e8 c6 fe ff ff       	call   8026ab <syscall>
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8027e7:	f3 0f 1e fb          	endbr32 
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8027f1:	ff 75 18             	pushl  0x18(%ebp)
  8027f4:	ff 75 14             	pushl  0x14(%ebp)
  8027f7:	ff 75 10             	pushl  0x10(%ebp)
  8027fa:	ff 75 0c             	pushl  0xc(%ebp)
  8027fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802800:	ba 01 00 00 00       	mov    $0x1,%edx
  802805:	b8 05 00 00 00       	mov    $0x5,%eax
  80280a:	e8 9c fe ff ff       	call   8026ab <syscall>
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802811:	f3 0f 1e fb          	endbr32 
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	ff 75 0c             	pushl  0xc(%ebp)
  802824:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802827:	ba 01 00 00 00       	mov    $0x1,%edx
  80282c:	b8 06 00 00 00       	mov    $0x6,%eax
  802831:	e8 75 fe ff ff       	call   8026ab <syscall>
}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802838:	f3 0f 1e fb          	endbr32 
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	ff 75 0c             	pushl  0xc(%ebp)
  80284b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80284e:	ba 01 00 00 00       	mov    $0x1,%edx
  802853:	b8 08 00 00 00       	mov    $0x8,%eax
  802858:	e8 4e fe ff ff       	call   8026ab <syscall>
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80285f:	f3 0f 1e fb          	endbr32 
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	ff 75 0c             	pushl  0xc(%ebp)
  802872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802875:	ba 01 00 00 00       	mov    $0x1,%edx
  80287a:	b8 09 00 00 00       	mov    $0x9,%eax
  80287f:	e8 27 fe ff ff       	call   8026ab <syscall>
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802886:	f3 0f 1e fb          	endbr32 
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	ff 75 0c             	pushl  0xc(%ebp)
  802899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80289c:	ba 01 00 00 00       	mov    $0x1,%edx
  8028a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8028a6:	e8 00 fe ff ff       	call   8026ab <syscall>
}
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    

008028ad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028ad:	f3 0f 1e fb          	endbr32 
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8028b7:	6a 00                	push   $0x0
  8028b9:	ff 75 14             	pushl  0x14(%ebp)
  8028bc:	ff 75 10             	pushl  0x10(%ebp)
  8028bf:	ff 75 0c             	pushl  0xc(%ebp)
  8028c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ca:	b8 0c 00 00 00       	mov    $0xc,%eax
  8028cf:	e8 d7 fd ff ff       	call   8026ab <syscall>
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8028d6:	f3 0f 1e fb          	endbr32 
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028eb:	ba 01 00 00 00       	mov    $0x1,%edx
  8028f0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8028f5:	e8 b1 fd ff ff       	call   8026ab <syscall>
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028fc:	f3 0f 1e fb          	endbr32 
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802906:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  80290d:	74 0a                	je     802919 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  802917:	c9                   	leave  
  802918:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  802919:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80291e:	8b 40 48             	mov    0x48(%eax),%eax
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	6a 07                	push   $0x7
  802926:	68 00 f0 bf ee       	push   $0xeebff000
  80292b:	50                   	push   %eax
  80292c:	e8 8e fe ff ff       	call   8027bf <sys_page_alloc>
		if (r!= 0)
  802931:	83 c4 10             	add    $0x10,%esp
  802934:	85 c0                	test   %eax,%eax
  802936:	75 2f                	jne    802967 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802938:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80293d:	8b 40 48             	mov    0x48(%eax),%eax
  802940:	83 ec 08             	sub    $0x8,%esp
  802943:	68 79 29 80 00       	push   $0x802979
  802948:	50                   	push   %eax
  802949:	e8 38 ff ff ff       	call   802886 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  80294e:	83 c4 10             	add    $0x10,%esp
  802951:	85 c0                	test   %eax,%eax
  802953:	74 ba                	je     80290f <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802955:	50                   	push   %eax
  802956:	68 4a 44 80 00       	push   $0x80444a
  80295b:	6a 26                	push   $0x26
  80295d:	68 62 44 80 00       	push   $0x804462
  802962:	e8 7f f3 ff ff       	call   801ce6 <_panic>
			panic("set_pgfault_handler: %e", r);
  802967:	50                   	push   %eax
  802968:	68 4a 44 80 00       	push   $0x80444a
  80296d:	6a 22                	push   $0x22
  80296f:	68 62 44 80 00       	push   $0x804462
  802974:	e8 6d f3 ff ff       	call   801ce6 <_panic>

00802979 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802979:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80297a:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  80297f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802981:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802984:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  802988:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80298b:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  80298f:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802993:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802995:	83 c4 08             	add    $0x8,%esp
	popal
  802998:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802999:	83 c4 04             	add    $0x4,%esp
	popfl
  80299c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80299d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80299e:	c3                   	ret    

0080299f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80299f:	f3 0f 1e fb          	endbr32 
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	56                   	push   %esi
  8029a7:	53                   	push   %ebx
  8029a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8029ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029b8:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	50                   	push   %eax
  8029bf:	e8 12 ff ff ff       	call   8028d6 <sys_ipc_recv>
	if (r < 0) {
  8029c4:	83 c4 10             	add    $0x10,%esp
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	78 2b                	js     8029f6 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8029cb:	85 f6                	test   %esi,%esi
  8029cd:	74 0a                	je     8029d9 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8029cf:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8029d4:	8b 40 74             	mov    0x74(%eax),%eax
  8029d7:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8029d9:	85 db                	test   %ebx,%ebx
  8029db:	74 0a                	je     8029e7 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8029dd:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8029e2:	8b 40 78             	mov    0x78(%eax),%eax
  8029e5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8029e7:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8029ec:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029f2:	5b                   	pop    %ebx
  8029f3:	5e                   	pop    %esi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
		if (from_env_store) {
  8029f6:	85 f6                	test   %esi,%esi
  8029f8:	74 06                	je     802a00 <ipc_recv+0x61>
			*from_env_store = 0;
  8029fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  802a00:	85 db                	test   %ebx,%ebx
  802a02:	74 eb                	je     8029ef <ipc_recv+0x50>
			*perm_store = 0;
  802a04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a0a:	eb e3                	jmp    8029ef <ipc_recv+0x50>

00802a0c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a0c:	f3 0f 1e fb          	endbr32 
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	53                   	push   %ebx
  802a16:	83 ec 0c             	sub    $0xc,%esp
  802a19:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  802a22:	85 db                	test   %ebx,%ebx
  802a24:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a29:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802a2c:	ff 75 14             	pushl  0x14(%ebp)
  802a2f:	53                   	push   %ebx
  802a30:	56                   	push   %esi
  802a31:	57                   	push   %edi
  802a32:	e8 76 fe ff ff       	call   8028ad <sys_ipc_try_send>
  802a37:	83 c4 10             	add    $0x10,%esp
  802a3a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a3d:	75 07                	jne    802a46 <ipc_send+0x3a>
		sys_yield();
  802a3f:	e8 50 fd ff ff       	call   802794 <sys_yield>
  802a44:	eb e6                	jmp    802a2c <ipc_send+0x20>
	}

	if (ret < 0) {
  802a46:	85 c0                	test   %eax,%eax
  802a48:	78 08                	js     802a52 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a4d:	5b                   	pop    %ebx
  802a4e:	5e                   	pop    %esi
  802a4f:	5f                   	pop    %edi
  802a50:	5d                   	pop    %ebp
  802a51:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802a52:	50                   	push   %eax
  802a53:	68 70 44 80 00       	push   $0x804470
  802a58:	6a 48                	push   $0x48
  802a5a:	68 8d 44 80 00       	push   $0x80448d
  802a5f:	e8 82 f2 ff ff       	call   801ce6 <_panic>

00802a64 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a64:	f3 0f 1e fb          	endbr32 
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
  802a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a6e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a73:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802a76:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a7c:	8b 52 50             	mov    0x50(%edx),%edx
  802a7f:	39 ca                	cmp    %ecx,%edx
  802a81:	74 11                	je     802a94 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802a83:	83 c0 01             	add    $0x1,%eax
  802a86:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a8b:	75 e6                	jne    802a73 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	eb 0b                	jmp    802a9f <ipc_find_env+0x3b>
			return envs[i].env_id;
  802a94:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a97:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a9c:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    

00802aa1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802aa1:	f3 0f 1e fb          	endbr32 
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	05 00 00 00 30       	add    $0x30000000,%eax
  802ab0:	c1 e8 0c             	shr    $0xc,%eax
}
  802ab3:	5d                   	pop    %ebp
  802ab4:	c3                   	ret    

00802ab5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ab5:	f3 0f 1e fb          	endbr32 
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	e8 da ff ff ff       	call   802aa1 <fd2num>
  802ac7:	83 c4 10             	add    $0x10,%esp
  802aca:	c1 e0 0c             	shl    $0xc,%eax
  802acd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802ad2:	c9                   	leave  
  802ad3:	c3                   	ret    

00802ad4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ad4:	f3 0f 1e fb          	endbr32 
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802ae0:	89 c2                	mov    %eax,%edx
  802ae2:	c1 ea 16             	shr    $0x16,%edx
  802ae5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802aec:	f6 c2 01             	test   $0x1,%dl
  802aef:	74 2d                	je     802b1e <fd_alloc+0x4a>
  802af1:	89 c2                	mov    %eax,%edx
  802af3:	c1 ea 0c             	shr    $0xc,%edx
  802af6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802afd:	f6 c2 01             	test   $0x1,%dl
  802b00:	74 1c                	je     802b1e <fd_alloc+0x4a>
  802b02:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802b07:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802b0c:	75 d2                	jne    802ae0 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802b17:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802b1c:	eb 0a                	jmp    802b28 <fd_alloc+0x54>
			*fd_store = fd;
  802b1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b21:	89 01                	mov    %eax,(%ecx)
			return 0;
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b28:	5d                   	pop    %ebp
  802b29:	c3                   	ret    

00802b2a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b2a:	f3 0f 1e fb          	endbr32 
  802b2e:	55                   	push   %ebp
  802b2f:	89 e5                	mov    %esp,%ebp
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b34:	83 f8 1f             	cmp    $0x1f,%eax
  802b37:	77 30                	ja     802b69 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802b39:	c1 e0 0c             	shl    $0xc,%eax
  802b3c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b41:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802b47:	f6 c2 01             	test   $0x1,%dl
  802b4a:	74 24                	je     802b70 <fd_lookup+0x46>
  802b4c:	89 c2                	mov    %eax,%edx
  802b4e:	c1 ea 0c             	shr    $0xc,%edx
  802b51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b58:	f6 c2 01             	test   $0x1,%dl
  802b5b:	74 1a                	je     802b77 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b60:	89 02                	mov    %eax,(%edx)
	return 0;
  802b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b67:	5d                   	pop    %ebp
  802b68:	c3                   	ret    
		return -E_INVAL;
  802b69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6e:	eb f7                	jmp    802b67 <fd_lookup+0x3d>
		return -E_INVAL;
  802b70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b75:	eb f0                	jmp    802b67 <fd_lookup+0x3d>
  802b77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b7c:	eb e9                	jmp    802b67 <fd_lookup+0x3d>

00802b7e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802b7e:	f3 0f 1e fb          	endbr32 
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
  802b85:	83 ec 08             	sub    $0x8,%esp
  802b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b8b:	ba 14 45 80 00       	mov    $0x804514,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802b90:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802b95:	39 08                	cmp    %ecx,(%eax)
  802b97:	74 33                	je     802bcc <dev_lookup+0x4e>
  802b99:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802b9c:	8b 02                	mov    (%edx),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 f3                	jne    802b95 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ba2:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802ba7:	8b 40 48             	mov    0x48(%eax),%eax
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	51                   	push   %ecx
  802bae:	50                   	push   %eax
  802baf:	68 98 44 80 00       	push   $0x804498
  802bb4:	e8 14 f2 ff ff       	call   801dcd <cprintf>
	*dev = 0;
  802bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802bc2:	83 c4 10             	add    $0x10,%esp
  802bc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802bca:	c9                   	leave  
  802bcb:	c3                   	ret    
			*dev = devtab[i];
  802bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bcf:	89 01                	mov    %eax,(%ecx)
			return 0;
  802bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd6:	eb f2                	jmp    802bca <dev_lookup+0x4c>

00802bd8 <fd_close>:
{
  802bd8:	f3 0f 1e fb          	endbr32 
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
  802bdf:	57                   	push   %edi
  802be0:	56                   	push   %esi
  802be1:	53                   	push   %ebx
  802be2:	83 ec 28             	sub    $0x28,%esp
  802be5:	8b 75 08             	mov    0x8(%ebp),%esi
  802be8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802beb:	56                   	push   %esi
  802bec:	e8 b0 fe ff ff       	call   802aa1 <fd2num>
  802bf1:	83 c4 08             	add    $0x8,%esp
  802bf4:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802bf7:	52                   	push   %edx
  802bf8:	50                   	push   %eax
  802bf9:	e8 2c ff ff ff       	call   802b2a <fd_lookup>
  802bfe:	89 c3                	mov    %eax,%ebx
  802c00:	83 c4 10             	add    $0x10,%esp
  802c03:	85 c0                	test   %eax,%eax
  802c05:	78 05                	js     802c0c <fd_close+0x34>
	    || fd != fd2)
  802c07:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802c0a:	74 16                	je     802c22 <fd_close+0x4a>
		return (must_exist ? r : 0);
  802c0c:	89 f8                	mov    %edi,%eax
  802c0e:	84 c0                	test   %al,%al
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	0f 44 d8             	cmove  %eax,%ebx
}
  802c18:	89 d8                	mov    %ebx,%eax
  802c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c1d:	5b                   	pop    %ebx
  802c1e:	5e                   	pop    %esi
  802c1f:	5f                   	pop    %edi
  802c20:	5d                   	pop    %ebp
  802c21:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c22:	83 ec 08             	sub    $0x8,%esp
  802c25:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802c28:	50                   	push   %eax
  802c29:	ff 36                	pushl  (%esi)
  802c2b:	e8 4e ff ff ff       	call   802b7e <dev_lookup>
  802c30:	89 c3                	mov    %eax,%ebx
  802c32:	83 c4 10             	add    $0x10,%esp
  802c35:	85 c0                	test   %eax,%eax
  802c37:	78 1a                	js     802c53 <fd_close+0x7b>
		if (dev->dev_close)
  802c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802c3f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 0b                	je     802c53 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	56                   	push   %esi
  802c4c:	ff d0                	call   *%eax
  802c4e:	89 c3                	mov    %eax,%ebx
  802c50:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802c53:	83 ec 08             	sub    $0x8,%esp
  802c56:	56                   	push   %esi
  802c57:	6a 00                	push   $0x0
  802c59:	e8 b3 fb ff ff       	call   802811 <sys_page_unmap>
	return r;
  802c5e:	83 c4 10             	add    $0x10,%esp
  802c61:	eb b5                	jmp    802c18 <fd_close+0x40>

00802c63 <close>:

int
close(int fdnum)
{
  802c63:	f3 0f 1e fb          	endbr32 
  802c67:	55                   	push   %ebp
  802c68:	89 e5                	mov    %esp,%ebp
  802c6a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c70:	50                   	push   %eax
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	e8 b1 fe ff ff       	call   802b2a <fd_lookup>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	79 02                	jns    802c82 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    
		return fd_close(fd, 1);
  802c82:	83 ec 08             	sub    $0x8,%esp
  802c85:	6a 01                	push   $0x1
  802c87:	ff 75 f4             	pushl  -0xc(%ebp)
  802c8a:	e8 49 ff ff ff       	call   802bd8 <fd_close>
  802c8f:	83 c4 10             	add    $0x10,%esp
  802c92:	eb ec                	jmp    802c80 <close+0x1d>

00802c94 <close_all>:

void
close_all(void)
{
  802c94:	f3 0f 1e fb          	endbr32 
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	53                   	push   %ebx
  802c9c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c9f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802ca4:	83 ec 0c             	sub    $0xc,%esp
  802ca7:	53                   	push   %ebx
  802ca8:	e8 b6 ff ff ff       	call   802c63 <close>
	for (i = 0; i < MAXFD; i++)
  802cad:	83 c3 01             	add    $0x1,%ebx
  802cb0:	83 c4 10             	add    $0x10,%esp
  802cb3:	83 fb 20             	cmp    $0x20,%ebx
  802cb6:	75 ec                	jne    802ca4 <close_all+0x10>
}
  802cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cbd:	f3 0f 1e fb          	endbr32 
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	57                   	push   %edi
  802cc5:	56                   	push   %esi
  802cc6:	53                   	push   %ebx
  802cc7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802cca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ccd:	50                   	push   %eax
  802cce:	ff 75 08             	pushl  0x8(%ebp)
  802cd1:	e8 54 fe ff ff       	call   802b2a <fd_lookup>
  802cd6:	89 c3                	mov    %eax,%ebx
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	0f 88 81 00 00 00    	js     802d64 <dup+0xa7>
		return r;
	close(newfdnum);
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	ff 75 0c             	pushl  0xc(%ebp)
  802ce9:	e8 75 ff ff ff       	call   802c63 <close>

	newfd = INDEX2FD(newfdnum);
  802cee:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cf1:	c1 e6 0c             	shl    $0xc,%esi
  802cf4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802cfa:	83 c4 04             	add    $0x4,%esp
  802cfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d00:	e8 b0 fd ff ff       	call   802ab5 <fd2data>
  802d05:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802d07:	89 34 24             	mov    %esi,(%esp)
  802d0a:	e8 a6 fd ff ff       	call   802ab5 <fd2data>
  802d0f:	83 c4 10             	add    $0x10,%esp
  802d12:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d14:	89 d8                	mov    %ebx,%eax
  802d16:	c1 e8 16             	shr    $0x16,%eax
  802d19:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d20:	a8 01                	test   $0x1,%al
  802d22:	74 11                	je     802d35 <dup+0x78>
  802d24:	89 d8                	mov    %ebx,%eax
  802d26:	c1 e8 0c             	shr    $0xc,%eax
  802d29:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802d30:	f6 c2 01             	test   $0x1,%dl
  802d33:	75 39                	jne    802d6e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d38:	89 d0                	mov    %edx,%eax
  802d3a:	c1 e8 0c             	shr    $0xc,%eax
  802d3d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	25 07 0e 00 00       	and    $0xe07,%eax
  802d4c:	50                   	push   %eax
  802d4d:	56                   	push   %esi
  802d4e:	6a 00                	push   $0x0
  802d50:	52                   	push   %edx
  802d51:	6a 00                	push   $0x0
  802d53:	e8 8f fa ff ff       	call   8027e7 <sys_page_map>
  802d58:	89 c3                	mov    %eax,%ebx
  802d5a:	83 c4 20             	add    $0x20,%esp
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	78 31                	js     802d92 <dup+0xd5>
		goto err;

	return newfdnum;
  802d61:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802d64:	89 d8                	mov    %ebx,%eax
  802d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d69:	5b                   	pop    %ebx
  802d6a:	5e                   	pop    %esi
  802d6b:	5f                   	pop    %edi
  802d6c:	5d                   	pop    %ebp
  802d6d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802d6e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802d75:	83 ec 0c             	sub    $0xc,%esp
  802d78:	25 07 0e 00 00       	and    $0xe07,%eax
  802d7d:	50                   	push   %eax
  802d7e:	57                   	push   %edi
  802d7f:	6a 00                	push   $0x0
  802d81:	53                   	push   %ebx
  802d82:	6a 00                	push   $0x0
  802d84:	e8 5e fa ff ff       	call   8027e7 <sys_page_map>
  802d89:	89 c3                	mov    %eax,%ebx
  802d8b:	83 c4 20             	add    $0x20,%esp
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	79 a3                	jns    802d35 <dup+0x78>
	sys_page_unmap(0, newfd);
  802d92:	83 ec 08             	sub    $0x8,%esp
  802d95:	56                   	push   %esi
  802d96:	6a 00                	push   $0x0
  802d98:	e8 74 fa ff ff       	call   802811 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802d9d:	83 c4 08             	add    $0x8,%esp
  802da0:	57                   	push   %edi
  802da1:	6a 00                	push   $0x0
  802da3:	e8 69 fa ff ff       	call   802811 <sys_page_unmap>
	return r;
  802da8:	83 c4 10             	add    $0x10,%esp
  802dab:	eb b7                	jmp    802d64 <dup+0xa7>

00802dad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802dad:	f3 0f 1e fb          	endbr32 
  802db1:	55                   	push   %ebp
  802db2:	89 e5                	mov    %esp,%ebp
  802db4:	53                   	push   %ebx
  802db5:	83 ec 1c             	sub    $0x1c,%esp
  802db8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802dbe:	50                   	push   %eax
  802dbf:	53                   	push   %ebx
  802dc0:	e8 65 fd ff ff       	call   802b2a <fd_lookup>
  802dc5:	83 c4 10             	add    $0x10,%esp
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	78 3f                	js     802e0b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dcc:	83 ec 08             	sub    $0x8,%esp
  802dcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dd2:	50                   	push   %eax
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	ff 30                	pushl  (%eax)
  802dd8:	e8 a1 fd ff ff       	call   802b7e <dev_lookup>
  802ddd:	83 c4 10             	add    $0x10,%esp
  802de0:	85 c0                	test   %eax,%eax
  802de2:	78 27                	js     802e0b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802de4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de7:	8b 42 08             	mov    0x8(%edx),%eax
  802dea:	83 e0 03             	and    $0x3,%eax
  802ded:	83 f8 01             	cmp    $0x1,%eax
  802df0:	74 1e                	je     802e10 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 08             	mov    0x8(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 35                	je     802e31 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	ff 75 10             	pushl  0x10(%ebp)
  802e02:	ff 75 0c             	pushl  0xc(%ebp)
  802e05:	52                   	push   %edx
  802e06:	ff d0                	call   *%eax
  802e08:	83 c4 10             	add    $0x10,%esp
}
  802e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e10:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802e15:	8b 40 48             	mov    0x48(%eax),%eax
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	53                   	push   %ebx
  802e1c:	50                   	push   %eax
  802e1d:	68 d9 44 80 00       	push   $0x8044d9
  802e22:	e8 a6 ef ff ff       	call   801dcd <cprintf>
		return -E_INVAL;
  802e27:	83 c4 10             	add    $0x10,%esp
  802e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e2f:	eb da                	jmp    802e0b <read+0x5e>
		return -E_NOT_SUPP;
  802e31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e36:	eb d3                	jmp    802e0b <read+0x5e>

00802e38 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e38:	f3 0f 1e fb          	endbr32 
  802e3c:	55                   	push   %ebp
  802e3d:	89 e5                	mov    %esp,%ebp
  802e3f:	57                   	push   %edi
  802e40:	56                   	push   %esi
  802e41:	53                   	push   %ebx
  802e42:	83 ec 0c             	sub    $0xc,%esp
  802e45:	8b 7d 08             	mov    0x8(%ebp),%edi
  802e48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e50:	eb 02                	jmp    802e54 <readn+0x1c>
  802e52:	01 c3                	add    %eax,%ebx
  802e54:	39 f3                	cmp    %esi,%ebx
  802e56:	73 21                	jae    802e79 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	89 f0                	mov    %esi,%eax
  802e5d:	29 d8                	sub    %ebx,%eax
  802e5f:	50                   	push   %eax
  802e60:	89 d8                	mov    %ebx,%eax
  802e62:	03 45 0c             	add    0xc(%ebp),%eax
  802e65:	50                   	push   %eax
  802e66:	57                   	push   %edi
  802e67:	e8 41 ff ff ff       	call   802dad <read>
		if (m < 0)
  802e6c:	83 c4 10             	add    $0x10,%esp
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	78 04                	js     802e77 <readn+0x3f>
			return m;
		if (m == 0)
  802e73:	75 dd                	jne    802e52 <readn+0x1a>
  802e75:	eb 02                	jmp    802e79 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e77:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802e79:	89 d8                	mov    %ebx,%eax
  802e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e7e:	5b                   	pop    %ebx
  802e7f:	5e                   	pop    %esi
  802e80:	5f                   	pop    %edi
  802e81:	5d                   	pop    %ebp
  802e82:	c3                   	ret    

00802e83 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e83:	f3 0f 1e fb          	endbr32 
  802e87:	55                   	push   %ebp
  802e88:	89 e5                	mov    %esp,%ebp
  802e8a:	53                   	push   %ebx
  802e8b:	83 ec 1c             	sub    $0x1c,%esp
  802e8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e94:	50                   	push   %eax
  802e95:	53                   	push   %ebx
  802e96:	e8 8f fc ff ff       	call   802b2a <fd_lookup>
  802e9b:	83 c4 10             	add    $0x10,%esp
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	78 3a                	js     802edc <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ea2:	83 ec 08             	sub    $0x8,%esp
  802ea5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ea8:	50                   	push   %eax
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	ff 30                	pushl  (%eax)
  802eae:	e8 cb fc ff ff       	call   802b7e <dev_lookup>
  802eb3:	83 c4 10             	add    $0x10,%esp
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	78 22                	js     802edc <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802ec1:	74 1e                	je     802ee1 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec6:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec9:	85 d2                	test   %edx,%edx
  802ecb:	74 35                	je     802f02 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	ff 75 10             	pushl  0x10(%ebp)
  802ed3:	ff 75 0c             	pushl  0xc(%ebp)
  802ed6:	50                   	push   %eax
  802ed7:	ff d2                	call   *%edx
  802ed9:	83 c4 10             	add    $0x10,%esp
}
  802edc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802edf:	c9                   	leave  
  802ee0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ee1:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802ee6:	8b 40 48             	mov    0x48(%eax),%eax
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	53                   	push   %ebx
  802eed:	50                   	push   %eax
  802eee:	68 f5 44 80 00       	push   $0x8044f5
  802ef3:	e8 d5 ee ff ff       	call   801dcd <cprintf>
		return -E_INVAL;
  802ef8:	83 c4 10             	add    $0x10,%esp
  802efb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f00:	eb da                	jmp    802edc <write+0x59>
		return -E_NOT_SUPP;
  802f02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f07:	eb d3                	jmp    802edc <write+0x59>

00802f09 <seek>:

int
seek(int fdnum, off_t offset)
{
  802f09:	f3 0f 1e fb          	endbr32 
  802f0d:	55                   	push   %ebp
  802f0e:	89 e5                	mov    %esp,%ebp
  802f10:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f16:	50                   	push   %eax
  802f17:	ff 75 08             	pushl  0x8(%ebp)
  802f1a:	e8 0b fc ff ff       	call   802b2a <fd_lookup>
  802f1f:	83 c4 10             	add    $0x10,%esp
  802f22:	85 c0                	test   %eax,%eax
  802f24:	78 0e                	js     802f34 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802f2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f34:	c9                   	leave  
  802f35:	c3                   	ret    

00802f36 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f36:	f3 0f 1e fb          	endbr32 
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	53                   	push   %ebx
  802f3e:	83 ec 1c             	sub    $0x1c,%esp
  802f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f47:	50                   	push   %eax
  802f48:	53                   	push   %ebx
  802f49:	e8 dc fb ff ff       	call   802b2a <fd_lookup>
  802f4e:	83 c4 10             	add    $0x10,%esp
  802f51:	85 c0                	test   %eax,%eax
  802f53:	78 37                	js     802f8c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f55:	83 ec 08             	sub    $0x8,%esp
  802f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f5b:	50                   	push   %eax
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	ff 30                	pushl  (%eax)
  802f61:	e8 18 fc ff ff       	call   802b7e <dev_lookup>
  802f66:	83 c4 10             	add    $0x10,%esp
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	78 1f                	js     802f8c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802f74:	74 1b                	je     802f91 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f79:	8b 52 18             	mov    0x18(%edx),%edx
  802f7c:	85 d2                	test   %edx,%edx
  802f7e:	74 32                	je     802fb2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802f80:	83 ec 08             	sub    $0x8,%esp
  802f83:	ff 75 0c             	pushl  0xc(%ebp)
  802f86:	50                   	push   %eax
  802f87:	ff d2                	call   *%edx
  802f89:	83 c4 10             	add    $0x10,%esp
}
  802f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f8f:	c9                   	leave  
  802f90:	c3                   	ret    
			thisenv->env_id, fdnum);
  802f91:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f96:	8b 40 48             	mov    0x48(%eax),%eax
  802f99:	83 ec 04             	sub    $0x4,%esp
  802f9c:	53                   	push   %ebx
  802f9d:	50                   	push   %eax
  802f9e:	68 b8 44 80 00       	push   $0x8044b8
  802fa3:	e8 25 ee ff ff       	call   801dcd <cprintf>
		return -E_INVAL;
  802fa8:	83 c4 10             	add    $0x10,%esp
  802fab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fb0:	eb da                	jmp    802f8c <ftruncate+0x56>
		return -E_NOT_SUPP;
  802fb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802fb7:	eb d3                	jmp    802f8c <ftruncate+0x56>

00802fb9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fb9:	f3 0f 1e fb          	endbr32 
  802fbd:	55                   	push   %ebp
  802fbe:	89 e5                	mov    %esp,%ebp
  802fc0:	53                   	push   %ebx
  802fc1:	83 ec 1c             	sub    $0x1c,%esp
  802fc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802fca:	50                   	push   %eax
  802fcb:	ff 75 08             	pushl  0x8(%ebp)
  802fce:	e8 57 fb ff ff       	call   802b2a <fd_lookup>
  802fd3:	83 c4 10             	add    $0x10,%esp
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	78 4b                	js     803025 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fda:	83 ec 08             	sub    $0x8,%esp
  802fdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fe0:	50                   	push   %eax
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	ff 30                	pushl  (%eax)
  802fe6:	e8 93 fb ff ff       	call   802b7e <dev_lookup>
  802feb:	83 c4 10             	add    $0x10,%esp
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	78 33                	js     803025 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802ff9:	74 2f                	je     80302a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802ffb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802ffe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803005:	00 00 00 
	stat->st_isdir = 0;
  803008:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80300f:	00 00 00 
	stat->st_dev = dev;
  803012:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803018:	83 ec 08             	sub    $0x8,%esp
  80301b:	53                   	push   %ebx
  80301c:	ff 75 f0             	pushl  -0x10(%ebp)
  80301f:	ff 50 14             	call   *0x14(%eax)
  803022:	83 c4 10             	add    $0x10,%esp
}
  803025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803028:	c9                   	leave  
  803029:	c3                   	ret    
		return -E_NOT_SUPP;
  80302a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80302f:	eb f4                	jmp    803025 <fstat+0x6c>

00803031 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803031:	f3 0f 1e fb          	endbr32 
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	56                   	push   %esi
  803039:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80303a:	83 ec 08             	sub    $0x8,%esp
  80303d:	6a 00                	push   $0x0
  80303f:	ff 75 08             	pushl  0x8(%ebp)
  803042:	e8 3a 02 00 00       	call   803281 <open>
  803047:	89 c3                	mov    %eax,%ebx
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	85 c0                	test   %eax,%eax
  80304e:	78 1b                	js     80306b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  803050:	83 ec 08             	sub    $0x8,%esp
  803053:	ff 75 0c             	pushl  0xc(%ebp)
  803056:	50                   	push   %eax
  803057:	e8 5d ff ff ff       	call   802fb9 <fstat>
  80305c:	89 c6                	mov    %eax,%esi
	close(fd);
  80305e:	89 1c 24             	mov    %ebx,(%esp)
  803061:	e8 fd fb ff ff       	call   802c63 <close>
	return r;
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	89 f3                	mov    %esi,%ebx
}
  80306b:	89 d8                	mov    %ebx,%eax
  80306d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803070:	5b                   	pop    %ebx
  803071:	5e                   	pop    %esi
  803072:	5d                   	pop    %ebp
  803073:	c3                   	ret    

00803074 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803074:	55                   	push   %ebp
  803075:	89 e5                	mov    %esp,%ebp
  803077:	56                   	push   %esi
  803078:	53                   	push   %ebx
  803079:	89 c6                	mov    %eax,%esi
  80307b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80307d:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803084:	74 27                	je     8030ad <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803086:	6a 07                	push   $0x7
  803088:	68 00 b0 80 00       	push   $0x80b000
  80308d:	56                   	push   %esi
  80308e:	ff 35 00 a0 80 00    	pushl  0x80a000
  803094:	e8 73 f9 ff ff       	call   802a0c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  803099:	83 c4 0c             	add    $0xc,%esp
  80309c:	6a 00                	push   $0x0
  80309e:	53                   	push   %ebx
  80309f:	6a 00                	push   $0x0
  8030a1:	e8 f9 f8 ff ff       	call   80299f <ipc_recv>
}
  8030a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a9:	5b                   	pop    %ebx
  8030aa:	5e                   	pop    %esi
  8030ab:	5d                   	pop    %ebp
  8030ac:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8030ad:	83 ec 0c             	sub    $0xc,%esp
  8030b0:	6a 01                	push   $0x1
  8030b2:	e8 ad f9 ff ff       	call   802a64 <ipc_find_env>
  8030b7:	a3 00 a0 80 00       	mov    %eax,0x80a000
  8030bc:	83 c4 10             	add    $0x10,%esp
  8030bf:	eb c5                	jmp    803086 <fsipc+0x12>

008030c1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030c1:	f3 0f 1e fb          	endbr32 
  8030c5:	55                   	push   %ebp
  8030c6:	89 e5                	mov    %esp,%ebp
  8030c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d1:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  8030d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d9:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030de:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8030e8:	e8 87 ff ff ff       	call   803074 <fsipc>
}
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <devfile_flush>:
{
  8030ef:	f3 0f 1e fb          	endbr32 
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
  8030f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ff:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803104:	ba 00 00 00 00       	mov    $0x0,%edx
  803109:	b8 06 00 00 00       	mov    $0x6,%eax
  80310e:	e8 61 ff ff ff       	call   803074 <fsipc>
}
  803113:	c9                   	leave  
  803114:	c3                   	ret    

00803115 <devfile_stat>:
{
  803115:	f3 0f 1e fb          	endbr32 
  803119:	55                   	push   %ebp
  80311a:	89 e5                	mov    %esp,%ebp
  80311c:	53                   	push   %ebx
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 40 0c             	mov    0xc(%eax),%eax
  803129:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80312e:	ba 00 00 00 00       	mov    $0x0,%edx
  803133:	b8 05 00 00 00       	mov    $0x5,%eax
  803138:	e8 37 ff ff ff       	call   803074 <fsipc>
  80313d:	85 c0                	test   %eax,%eax
  80313f:	78 2c                	js     80316d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803141:	83 ec 08             	sub    $0x8,%esp
  803144:	68 00 b0 80 00       	push   $0x80b000
  803149:	53                   	push   %ebx
  80314a:	e8 e8 f1 ff ff       	call   802337 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80314f:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803154:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80315a:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80315f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <devfile_write>:
{
  803172:	f3 0f 1e fb          	endbr32 
  803176:	55                   	push   %ebp
  803177:	89 e5                	mov    %esp,%ebp
  803179:	53                   	push   %ebx
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 40 0c             	mov    0xc(%eax),%eax
  803186:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  80318b:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  803191:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  803197:	77 30                	ja     8031c9 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	53                   	push   %ebx
  80319d:	ff 75 0c             	pushl  0xc(%ebp)
  8031a0:	68 08 b0 80 00       	push   $0x80b008
  8031a5:	e8 45 f3 ff ff       	call   8024ef <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8031aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8031af:	b8 04 00 00 00       	mov    $0x4,%eax
  8031b4:	e8 bb fe ff ff       	call   803074 <fsipc>
  8031b9:	83 c4 10             	add    $0x10,%esp
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	78 04                	js     8031c4 <devfile_write+0x52>
	assert(r <= n);
  8031c0:	39 d8                	cmp    %ebx,%eax
  8031c2:	77 1e                	ja     8031e2 <devfile_write+0x70>
}
  8031c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c7:	c9                   	leave  
  8031c8:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8031c9:	68 24 45 80 00       	push   $0x804524
  8031ce:	68 1d 3b 80 00       	push   $0x803b1d
  8031d3:	68 94 00 00 00       	push   $0x94
  8031d8:	68 51 45 80 00       	push   $0x804551
  8031dd:	e8 04 eb ff ff       	call   801ce6 <_panic>
	assert(r <= n);
  8031e2:	68 5c 45 80 00       	push   $0x80455c
  8031e7:	68 1d 3b 80 00       	push   $0x803b1d
  8031ec:	68 98 00 00 00       	push   $0x98
  8031f1:	68 51 45 80 00       	push   $0x804551
  8031f6:	e8 eb ea ff ff       	call   801ce6 <_panic>

008031fb <devfile_read>:
{
  8031fb:	f3 0f 1e fb          	endbr32 
  8031ff:	55                   	push   %ebp
  803200:	89 e5                	mov    %esp,%ebp
  803202:	56                   	push   %esi
  803203:	53                   	push   %ebx
  803204:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 40 0c             	mov    0xc(%eax),%eax
  80320d:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803212:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803218:	ba 00 00 00 00       	mov    $0x0,%edx
  80321d:	b8 03 00 00 00       	mov    $0x3,%eax
  803222:	e8 4d fe ff ff       	call   803074 <fsipc>
  803227:	89 c3                	mov    %eax,%ebx
  803229:	85 c0                	test   %eax,%eax
  80322b:	78 1f                	js     80324c <devfile_read+0x51>
	assert(r <= n);
  80322d:	39 f0                	cmp    %esi,%eax
  80322f:	77 24                	ja     803255 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  803231:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803236:	7f 33                	jg     80326b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803238:	83 ec 04             	sub    $0x4,%esp
  80323b:	50                   	push   %eax
  80323c:	68 00 b0 80 00       	push   $0x80b000
  803241:	ff 75 0c             	pushl  0xc(%ebp)
  803244:	e8 a6 f2 ff ff       	call   8024ef <memmove>
	return r;
  803249:	83 c4 10             	add    $0x10,%esp
}
  80324c:	89 d8                	mov    %ebx,%eax
  80324e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803251:	5b                   	pop    %ebx
  803252:	5e                   	pop    %esi
  803253:	5d                   	pop    %ebp
  803254:	c3                   	ret    
	assert(r <= n);
  803255:	68 5c 45 80 00       	push   $0x80455c
  80325a:	68 1d 3b 80 00       	push   $0x803b1d
  80325f:	6a 7c                	push   $0x7c
  803261:	68 51 45 80 00       	push   $0x804551
  803266:	e8 7b ea ff ff       	call   801ce6 <_panic>
	assert(r <= PGSIZE);
  80326b:	68 63 45 80 00       	push   $0x804563
  803270:	68 1d 3b 80 00       	push   $0x803b1d
  803275:	6a 7d                	push   $0x7d
  803277:	68 51 45 80 00       	push   $0x804551
  80327c:	e8 65 ea ff ff       	call   801ce6 <_panic>

00803281 <open>:
{
  803281:	f3 0f 1e fb          	endbr32 
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
  803288:	56                   	push   %esi
  803289:	53                   	push   %ebx
  80328a:	83 ec 1c             	sub    $0x1c,%esp
  80328d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803290:	56                   	push   %esi
  803291:	e8 5e f0 ff ff       	call   8022f4 <strlen>
  803296:	83 c4 10             	add    $0x10,%esp
  803299:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80329e:	7f 6c                	jg     80330c <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8032a0:	83 ec 0c             	sub    $0xc,%esp
  8032a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032a6:	50                   	push   %eax
  8032a7:	e8 28 f8 ff ff       	call   802ad4 <fd_alloc>
  8032ac:	89 c3                	mov    %eax,%ebx
  8032ae:	83 c4 10             	add    $0x10,%esp
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	78 3c                	js     8032f1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8032b5:	83 ec 08             	sub    $0x8,%esp
  8032b8:	56                   	push   %esi
  8032b9:	68 00 b0 80 00       	push   $0x80b000
  8032be:	e8 74 f0 ff ff       	call   802337 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8032c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c6:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d3:	e8 9c fd ff ff       	call   803074 <fsipc>
  8032d8:	89 c3                	mov    %eax,%ebx
  8032da:	83 c4 10             	add    $0x10,%esp
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	78 19                	js     8032fa <open+0x79>
	return fd2num(fd);
  8032e1:	83 ec 0c             	sub    $0xc,%esp
  8032e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8032e7:	e8 b5 f7 ff ff       	call   802aa1 <fd2num>
  8032ec:	89 c3                	mov    %eax,%ebx
  8032ee:	83 c4 10             	add    $0x10,%esp
}
  8032f1:	89 d8                	mov    %ebx,%eax
  8032f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032f6:	5b                   	pop    %ebx
  8032f7:	5e                   	pop    %esi
  8032f8:	5d                   	pop    %ebp
  8032f9:	c3                   	ret    
		fd_close(fd, 0);
  8032fa:	83 ec 08             	sub    $0x8,%esp
  8032fd:	6a 00                	push   $0x0
  8032ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803302:	e8 d1 f8 ff ff       	call   802bd8 <fd_close>
		return r;
  803307:	83 c4 10             	add    $0x10,%esp
  80330a:	eb e5                	jmp    8032f1 <open+0x70>
		return -E_BAD_PATH;
  80330c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803311:	eb de                	jmp    8032f1 <open+0x70>

00803313 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803313:	f3 0f 1e fb          	endbr32 
  803317:	55                   	push   %ebp
  803318:	89 e5                	mov    %esp,%ebp
  80331a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80331d:	ba 00 00 00 00       	mov    $0x0,%edx
  803322:	b8 08 00 00 00       	mov    $0x8,%eax
  803327:	e8 48 fd ff ff       	call   803074 <fsipc>
}
  80332c:	c9                   	leave  
  80332d:	c3                   	ret    

0080332e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80332e:	f3 0f 1e fb          	endbr32 
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803338:	89 c2                	mov    %eax,%edx
  80333a:	c1 ea 16             	shr    $0x16,%edx
  80333d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803344:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  803349:	f6 c1 01             	test   $0x1,%cl
  80334c:	74 1c                	je     80336a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80334e:	c1 e8 0c             	shr    $0xc,%eax
  803351:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803358:	a8 01                	test   $0x1,%al
  80335a:	74 0e                	je     80336a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80335c:	c1 e8 0c             	shr    $0xc,%eax
  80335f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803366:	ef 
  803367:	0f b7 d2             	movzwl %dx,%edx
}
  80336a:	89 d0                	mov    %edx,%eax
  80336c:	5d                   	pop    %ebp
  80336d:	c3                   	ret    

0080336e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80336e:	f3 0f 1e fb          	endbr32 
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
  803375:	56                   	push   %esi
  803376:	53                   	push   %ebx
  803377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80337a:	83 ec 0c             	sub    $0xc,%esp
  80337d:	ff 75 08             	pushl  0x8(%ebp)
  803380:	e8 30 f7 ff ff       	call   802ab5 <fd2data>
  803385:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803387:	83 c4 08             	add    $0x8,%esp
  80338a:	68 6f 45 80 00       	push   $0x80456f
  80338f:	53                   	push   %ebx
  803390:	e8 a2 ef ff ff       	call   802337 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803395:	8b 46 04             	mov    0x4(%esi),%eax
  803398:	2b 06                	sub    (%esi),%eax
  80339a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8033a0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8033a7:	00 00 00 
	stat->st_dev = &devpipe;
  8033aa:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  8033b1:	90 80 00 
	return 0;
}
  8033b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033bc:	5b                   	pop    %ebx
  8033bd:	5e                   	pop    %esi
  8033be:	5d                   	pop    %ebp
  8033bf:	c3                   	ret    

008033c0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033c0:	f3 0f 1e fb          	endbr32 
  8033c4:	55                   	push   %ebp
  8033c5:	89 e5                	mov    %esp,%ebp
  8033c7:	53                   	push   %ebx
  8033c8:	83 ec 0c             	sub    $0xc,%esp
  8033cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8033ce:	53                   	push   %ebx
  8033cf:	6a 00                	push   $0x0
  8033d1:	e8 3b f4 ff ff       	call   802811 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8033d6:	89 1c 24             	mov    %ebx,(%esp)
  8033d9:	e8 d7 f6 ff ff       	call   802ab5 <fd2data>
  8033de:	83 c4 08             	add    $0x8,%esp
  8033e1:	50                   	push   %eax
  8033e2:	6a 00                	push   $0x0
  8033e4:	e8 28 f4 ff ff       	call   802811 <sys_page_unmap>
}
  8033e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <_pipeisclosed>:
{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	57                   	push   %edi
  8033f2:	56                   	push   %esi
  8033f3:	53                   	push   %ebx
  8033f4:	83 ec 1c             	sub    $0x1c,%esp
  8033f7:	89 c7                	mov    %eax,%edi
  8033f9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8033fb:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  803400:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803403:	83 ec 0c             	sub    $0xc,%esp
  803406:	57                   	push   %edi
  803407:	e8 22 ff ff ff       	call   80332e <pageref>
  80340c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80340f:	89 34 24             	mov    %esi,(%esp)
  803412:	e8 17 ff ff ff       	call   80332e <pageref>
		nn = thisenv->env_runs;
  803417:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80341d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803420:	83 c4 10             	add    $0x10,%esp
  803423:	39 cb                	cmp    %ecx,%ebx
  803425:	74 1b                	je     803442 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803427:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80342a:	75 cf                	jne    8033fb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80342c:	8b 42 58             	mov    0x58(%edx),%eax
  80342f:	6a 01                	push   $0x1
  803431:	50                   	push   %eax
  803432:	53                   	push   %ebx
  803433:	68 76 45 80 00       	push   $0x804576
  803438:	e8 90 e9 ff ff       	call   801dcd <cprintf>
  80343d:	83 c4 10             	add    $0x10,%esp
  803440:	eb b9                	jmp    8033fb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803442:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803445:	0f 94 c0             	sete   %al
  803448:	0f b6 c0             	movzbl %al,%eax
}
  80344b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80344e:	5b                   	pop    %ebx
  80344f:	5e                   	pop    %esi
  803450:	5f                   	pop    %edi
  803451:	5d                   	pop    %ebp
  803452:	c3                   	ret    

00803453 <devpipe_write>:
{
  803453:	f3 0f 1e fb          	endbr32 
  803457:	55                   	push   %ebp
  803458:	89 e5                	mov    %esp,%ebp
  80345a:	57                   	push   %edi
  80345b:	56                   	push   %esi
  80345c:	53                   	push   %ebx
  80345d:	83 ec 28             	sub    $0x28,%esp
  803460:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803463:	56                   	push   %esi
  803464:	e8 4c f6 ff ff       	call   802ab5 <fd2data>
  803469:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80346b:	83 c4 10             	add    $0x10,%esp
  80346e:	bf 00 00 00 00       	mov    $0x0,%edi
  803473:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803476:	74 4f                	je     8034c7 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803478:	8b 43 04             	mov    0x4(%ebx),%eax
  80347b:	8b 0b                	mov    (%ebx),%ecx
  80347d:	8d 51 20             	lea    0x20(%ecx),%edx
  803480:	39 d0                	cmp    %edx,%eax
  803482:	72 14                	jb     803498 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  803484:	89 da                	mov    %ebx,%edx
  803486:	89 f0                	mov    %esi,%eax
  803488:	e8 61 ff ff ff       	call   8033ee <_pipeisclosed>
  80348d:	85 c0                	test   %eax,%eax
  80348f:	75 3b                	jne    8034cc <devpipe_write+0x79>
			sys_yield();
  803491:	e8 fe f2 ff ff       	call   802794 <sys_yield>
  803496:	eb e0                	jmp    803478 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803498:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80349b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80349f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8034a2:	89 c2                	mov    %eax,%edx
  8034a4:	c1 fa 1f             	sar    $0x1f,%edx
  8034a7:	89 d1                	mov    %edx,%ecx
  8034a9:	c1 e9 1b             	shr    $0x1b,%ecx
  8034ac:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8034af:	83 e2 1f             	and    $0x1f,%edx
  8034b2:	29 ca                	sub    %ecx,%edx
  8034b4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8034b8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8034bc:	83 c0 01             	add    $0x1,%eax
  8034bf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8034c2:	83 c7 01             	add    $0x1,%edi
  8034c5:	eb ac                	jmp    803473 <devpipe_write+0x20>
	return i;
  8034c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ca:	eb 05                	jmp    8034d1 <devpipe_write+0x7e>
				return 0;
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034d4:	5b                   	pop    %ebx
  8034d5:	5e                   	pop    %esi
  8034d6:	5f                   	pop    %edi
  8034d7:	5d                   	pop    %ebp
  8034d8:	c3                   	ret    

008034d9 <devpipe_read>:
{
  8034d9:	f3 0f 1e fb          	endbr32 
  8034dd:	55                   	push   %ebp
  8034de:	89 e5                	mov    %esp,%ebp
  8034e0:	57                   	push   %edi
  8034e1:	56                   	push   %esi
  8034e2:	53                   	push   %ebx
  8034e3:	83 ec 18             	sub    $0x18,%esp
  8034e6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8034e9:	57                   	push   %edi
  8034ea:	e8 c6 f5 ff ff       	call   802ab5 <fd2data>
  8034ef:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8034f1:	83 c4 10             	add    $0x10,%esp
  8034f4:	be 00 00 00 00       	mov    $0x0,%esi
  8034f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8034fc:	75 14                	jne    803512 <devpipe_read+0x39>
	return i;
  8034fe:	8b 45 10             	mov    0x10(%ebp),%eax
  803501:	eb 02                	jmp    803505 <devpipe_read+0x2c>
				return i;
  803503:	89 f0                	mov    %esi,%eax
}
  803505:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803508:	5b                   	pop    %ebx
  803509:	5e                   	pop    %esi
  80350a:	5f                   	pop    %edi
  80350b:	5d                   	pop    %ebp
  80350c:	c3                   	ret    
			sys_yield();
  80350d:	e8 82 f2 ff ff       	call   802794 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803512:	8b 03                	mov    (%ebx),%eax
  803514:	3b 43 04             	cmp    0x4(%ebx),%eax
  803517:	75 18                	jne    803531 <devpipe_read+0x58>
			if (i > 0)
  803519:	85 f6                	test   %esi,%esi
  80351b:	75 e6                	jne    803503 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80351d:	89 da                	mov    %ebx,%edx
  80351f:	89 f8                	mov    %edi,%eax
  803521:	e8 c8 fe ff ff       	call   8033ee <_pipeisclosed>
  803526:	85 c0                	test   %eax,%eax
  803528:	74 e3                	je     80350d <devpipe_read+0x34>
				return 0;
  80352a:	b8 00 00 00 00       	mov    $0x0,%eax
  80352f:	eb d4                	jmp    803505 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803531:	99                   	cltd   
  803532:	c1 ea 1b             	shr    $0x1b,%edx
  803535:	01 d0                	add    %edx,%eax
  803537:	83 e0 1f             	and    $0x1f,%eax
  80353a:	29 d0                	sub    %edx,%eax
  80353c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803541:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803544:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803547:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80354a:	83 c6 01             	add    $0x1,%esi
  80354d:	eb aa                	jmp    8034f9 <devpipe_read+0x20>

0080354f <pipe>:
{
  80354f:	f3 0f 1e fb          	endbr32 
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
  803556:	56                   	push   %esi
  803557:	53                   	push   %ebx
  803558:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80355b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80355e:	50                   	push   %eax
  80355f:	e8 70 f5 ff ff       	call   802ad4 <fd_alloc>
  803564:	89 c3                	mov    %eax,%ebx
  803566:	83 c4 10             	add    $0x10,%esp
  803569:	85 c0                	test   %eax,%eax
  80356b:	0f 88 23 01 00 00    	js     803694 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803571:	83 ec 04             	sub    $0x4,%esp
  803574:	68 07 04 00 00       	push   $0x407
  803579:	ff 75 f4             	pushl  -0xc(%ebp)
  80357c:	6a 00                	push   $0x0
  80357e:	e8 3c f2 ff ff       	call   8027bf <sys_page_alloc>
  803583:	89 c3                	mov    %eax,%ebx
  803585:	83 c4 10             	add    $0x10,%esp
  803588:	85 c0                	test   %eax,%eax
  80358a:	0f 88 04 01 00 00    	js     803694 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803590:	83 ec 0c             	sub    $0xc,%esp
  803593:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803596:	50                   	push   %eax
  803597:	e8 38 f5 ff ff       	call   802ad4 <fd_alloc>
  80359c:	89 c3                	mov    %eax,%ebx
  80359e:	83 c4 10             	add    $0x10,%esp
  8035a1:	85 c0                	test   %eax,%eax
  8035a3:	0f 88 db 00 00 00    	js     803684 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035a9:	83 ec 04             	sub    $0x4,%esp
  8035ac:	68 07 04 00 00       	push   $0x407
  8035b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b4:	6a 00                	push   $0x0
  8035b6:	e8 04 f2 ff ff       	call   8027bf <sys_page_alloc>
  8035bb:	89 c3                	mov    %eax,%ebx
  8035bd:	83 c4 10             	add    $0x10,%esp
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	0f 88 bc 00 00 00    	js     803684 <pipe+0x135>
	va = fd2data(fd0);
  8035c8:	83 ec 0c             	sub    $0xc,%esp
  8035cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ce:	e8 e2 f4 ff ff       	call   802ab5 <fd2data>
  8035d3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d5:	83 c4 0c             	add    $0xc,%esp
  8035d8:	68 07 04 00 00       	push   $0x407
  8035dd:	50                   	push   %eax
  8035de:	6a 00                	push   $0x0
  8035e0:	e8 da f1 ff ff       	call   8027bf <sys_page_alloc>
  8035e5:	89 c3                	mov    %eax,%ebx
  8035e7:	83 c4 10             	add    $0x10,%esp
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	0f 88 82 00 00 00    	js     803674 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035f2:	83 ec 0c             	sub    $0xc,%esp
  8035f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8035f8:	e8 b8 f4 ff ff       	call   802ab5 <fd2data>
  8035fd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803604:	50                   	push   %eax
  803605:	6a 00                	push   $0x0
  803607:	56                   	push   %esi
  803608:	6a 00                	push   $0x0
  80360a:	e8 d8 f1 ff ff       	call   8027e7 <sys_page_map>
  80360f:	89 c3                	mov    %eax,%ebx
  803611:	83 c4 20             	add    $0x20,%esp
  803614:	85 c0                	test   %eax,%eax
  803616:	78 4e                	js     803666 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  803618:	a1 80 90 80 00       	mov    0x809080,%eax
  80361d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803620:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803625:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80362c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80362f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803634:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80363b:	83 ec 0c             	sub    $0xc,%esp
  80363e:	ff 75 f4             	pushl  -0xc(%ebp)
  803641:	e8 5b f4 ff ff       	call   802aa1 <fd2num>
  803646:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803649:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80364b:	83 c4 04             	add    $0x4,%esp
  80364e:	ff 75 f0             	pushl  -0x10(%ebp)
  803651:	e8 4b f4 ff ff       	call   802aa1 <fd2num>
  803656:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803659:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80365c:	83 c4 10             	add    $0x10,%esp
  80365f:	bb 00 00 00 00       	mov    $0x0,%ebx
  803664:	eb 2e                	jmp    803694 <pipe+0x145>
	sys_page_unmap(0, va);
  803666:	83 ec 08             	sub    $0x8,%esp
  803669:	56                   	push   %esi
  80366a:	6a 00                	push   $0x0
  80366c:	e8 a0 f1 ff ff       	call   802811 <sys_page_unmap>
  803671:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803674:	83 ec 08             	sub    $0x8,%esp
  803677:	ff 75 f0             	pushl  -0x10(%ebp)
  80367a:	6a 00                	push   $0x0
  80367c:	e8 90 f1 ff ff       	call   802811 <sys_page_unmap>
  803681:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803684:	83 ec 08             	sub    $0x8,%esp
  803687:	ff 75 f4             	pushl  -0xc(%ebp)
  80368a:	6a 00                	push   $0x0
  80368c:	e8 80 f1 ff ff       	call   802811 <sys_page_unmap>
  803691:	83 c4 10             	add    $0x10,%esp
}
  803694:	89 d8                	mov    %ebx,%eax
  803696:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803699:	5b                   	pop    %ebx
  80369a:	5e                   	pop    %esi
  80369b:	5d                   	pop    %ebp
  80369c:	c3                   	ret    

0080369d <pipeisclosed>:
{
  80369d:	f3 0f 1e fb          	endbr32 
  8036a1:	55                   	push   %ebp
  8036a2:	89 e5                	mov    %esp,%ebp
  8036a4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036aa:	50                   	push   %eax
  8036ab:	ff 75 08             	pushl  0x8(%ebp)
  8036ae:	e8 77 f4 ff ff       	call   802b2a <fd_lookup>
  8036b3:	83 c4 10             	add    $0x10,%esp
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	78 18                	js     8036d2 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8036ba:	83 ec 0c             	sub    $0xc,%esp
  8036bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c0:	e8 f0 f3 ff ff       	call   802ab5 <fd2data>
  8036c5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	e8 1f fd ff ff       	call   8033ee <_pipeisclosed>
  8036cf:	83 c4 10             	add    $0x10,%esp
}
  8036d2:	c9                   	leave  
  8036d3:	c3                   	ret    

008036d4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8036d4:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8036d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036dd:	c3                   	ret    

008036de <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8036de:	f3 0f 1e fb          	endbr32 
  8036e2:	55                   	push   %ebp
  8036e3:	89 e5                	mov    %esp,%ebp
  8036e5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8036e8:	68 8e 45 80 00       	push   $0x80458e
  8036ed:	ff 75 0c             	pushl  0xc(%ebp)
  8036f0:	e8 42 ec ff ff       	call   802337 <strcpy>
	return 0;
}
  8036f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fa:	c9                   	leave  
  8036fb:	c3                   	ret    

008036fc <devcons_write>:
{
  8036fc:	f3 0f 1e fb          	endbr32 
  803700:	55                   	push   %ebp
  803701:	89 e5                	mov    %esp,%ebp
  803703:	57                   	push   %edi
  803704:	56                   	push   %esi
  803705:	53                   	push   %ebx
  803706:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80370c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803711:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803717:	3b 75 10             	cmp    0x10(%ebp),%esi
  80371a:	73 31                	jae    80374d <devcons_write+0x51>
		m = n - tot;
  80371c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80371f:	29 f3                	sub    %esi,%ebx
  803721:	83 fb 7f             	cmp    $0x7f,%ebx
  803724:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803729:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	53                   	push   %ebx
  803730:	89 f0                	mov    %esi,%eax
  803732:	03 45 0c             	add    0xc(%ebp),%eax
  803735:	50                   	push   %eax
  803736:	57                   	push   %edi
  803737:	e8 b3 ed ff ff       	call   8024ef <memmove>
		sys_cputs(buf, m);
  80373c:	83 c4 08             	add    $0x8,%esp
  80373f:	53                   	push   %ebx
  803740:	57                   	push   %edi
  803741:	e8 ae ef ff ff       	call   8026f4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803746:	01 de                	add    %ebx,%esi
  803748:	83 c4 10             	add    $0x10,%esp
  80374b:	eb ca                	jmp    803717 <devcons_write+0x1b>
}
  80374d:	89 f0                	mov    %esi,%eax
  80374f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803752:	5b                   	pop    %ebx
  803753:	5e                   	pop    %esi
  803754:	5f                   	pop    %edi
  803755:	5d                   	pop    %ebp
  803756:	c3                   	ret    

00803757 <devcons_read>:
{
  803757:	f3 0f 1e fb          	endbr32 
  80375b:	55                   	push   %ebp
  80375c:	89 e5                	mov    %esp,%ebp
  80375e:	83 ec 08             	sub    $0x8,%esp
  803761:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803766:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80376a:	74 21                	je     80378d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80376c:	e8 ad ef ff ff       	call   80271e <sys_cgetc>
  803771:	85 c0                	test   %eax,%eax
  803773:	75 07                	jne    80377c <devcons_read+0x25>
		sys_yield();
  803775:	e8 1a f0 ff ff       	call   802794 <sys_yield>
  80377a:	eb f0                	jmp    80376c <devcons_read+0x15>
	if (c < 0)
  80377c:	78 0f                	js     80378d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80377e:	83 f8 04             	cmp    $0x4,%eax
  803781:	74 0c                	je     80378f <devcons_read+0x38>
	*(char*)vbuf = c;
  803783:	8b 55 0c             	mov    0xc(%ebp),%edx
  803786:	88 02                	mov    %al,(%edx)
	return 1;
  803788:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80378d:	c9                   	leave  
  80378e:	c3                   	ret    
		return 0;
  80378f:	b8 00 00 00 00       	mov    $0x0,%eax
  803794:	eb f7                	jmp    80378d <devcons_read+0x36>

00803796 <cputchar>:
{
  803796:	f3 0f 1e fb          	endbr32 
  80379a:	55                   	push   %ebp
  80379b:	89 e5                	mov    %esp,%ebp
  80379d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8037a6:	6a 01                	push   $0x1
  8037a8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8037ab:	50                   	push   %eax
  8037ac:	e8 43 ef ff ff       	call   8026f4 <sys_cputs>
}
  8037b1:	83 c4 10             	add    $0x10,%esp
  8037b4:	c9                   	leave  
  8037b5:	c3                   	ret    

008037b6 <getchar>:
{
  8037b6:	f3 0f 1e fb          	endbr32 
  8037ba:	55                   	push   %ebp
  8037bb:	89 e5                	mov    %esp,%ebp
  8037bd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8037c0:	6a 01                	push   $0x1
  8037c2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8037c5:	50                   	push   %eax
  8037c6:	6a 00                	push   $0x0
  8037c8:	e8 e0 f5 ff ff       	call   802dad <read>
	if (r < 0)
  8037cd:	83 c4 10             	add    $0x10,%esp
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	78 06                	js     8037da <getchar+0x24>
	if (r < 1)
  8037d4:	74 06                	je     8037dc <getchar+0x26>
	return c;
  8037d6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8037da:	c9                   	leave  
  8037db:	c3                   	ret    
		return -E_EOF;
  8037dc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8037e1:	eb f7                	jmp    8037da <getchar+0x24>

008037e3 <iscons>:
{
  8037e3:	f3 0f 1e fb          	endbr32 
  8037e7:	55                   	push   %ebp
  8037e8:	89 e5                	mov    %esp,%ebp
  8037ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037f0:	50                   	push   %eax
  8037f1:	ff 75 08             	pushl  0x8(%ebp)
  8037f4:	e8 31 f3 ff ff       	call   802b2a <fd_lookup>
  8037f9:	83 c4 10             	add    $0x10,%esp
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	78 11                	js     803811 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803809:	39 10                	cmp    %edx,(%eax)
  80380b:	0f 94 c0             	sete   %al
  80380e:	0f b6 c0             	movzbl %al,%eax
}
  803811:	c9                   	leave  
  803812:	c3                   	ret    

00803813 <opencons>:
{
  803813:	f3 0f 1e fb          	endbr32 
  803817:	55                   	push   %ebp
  803818:	89 e5                	mov    %esp,%ebp
  80381a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80381d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803820:	50                   	push   %eax
  803821:	e8 ae f2 ff ff       	call   802ad4 <fd_alloc>
  803826:	83 c4 10             	add    $0x10,%esp
  803829:	85 c0                	test   %eax,%eax
  80382b:	78 3a                	js     803867 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80382d:	83 ec 04             	sub    $0x4,%esp
  803830:	68 07 04 00 00       	push   $0x407
  803835:	ff 75 f4             	pushl  -0xc(%ebp)
  803838:	6a 00                	push   $0x0
  80383a:	e8 80 ef ff ff       	call   8027bf <sys_page_alloc>
  80383f:	83 c4 10             	add    $0x10,%esp
  803842:	85 c0                	test   %eax,%eax
  803844:	78 21                	js     803867 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803849:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  80384f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803854:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80385b:	83 ec 0c             	sub    $0xc,%esp
  80385e:	50                   	push   %eax
  80385f:	e8 3d f2 ff ff       	call   802aa1 <fd2num>
  803864:	83 c4 10             	add    $0x10,%esp
}
  803867:	c9                   	leave  
  803868:	c3                   	ret    
  803869:	66 90                	xchg   %ax,%ax
  80386b:	66 90                	xchg   %ax,%ax
  80386d:	66 90                	xchg   %ax,%ax
  80386f:	90                   	nop

00803870 <__udivdi3>:
  803870:	f3 0f 1e fb          	endbr32 
  803874:	55                   	push   %ebp
  803875:	57                   	push   %edi
  803876:	56                   	push   %esi
  803877:	53                   	push   %ebx
  803878:	83 ec 1c             	sub    $0x1c,%esp
  80387b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80387f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803883:	8b 74 24 34          	mov    0x34(%esp),%esi
  803887:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80388b:	85 d2                	test   %edx,%edx
  80388d:	75 19                	jne    8038a8 <__udivdi3+0x38>
  80388f:	39 f3                	cmp    %esi,%ebx
  803891:	76 4d                	jbe    8038e0 <__udivdi3+0x70>
  803893:	31 ff                	xor    %edi,%edi
  803895:	89 e8                	mov    %ebp,%eax
  803897:	89 f2                	mov    %esi,%edx
  803899:	f7 f3                	div    %ebx
  80389b:	89 fa                	mov    %edi,%edx
  80389d:	83 c4 1c             	add    $0x1c,%esp
  8038a0:	5b                   	pop    %ebx
  8038a1:	5e                   	pop    %esi
  8038a2:	5f                   	pop    %edi
  8038a3:	5d                   	pop    %ebp
  8038a4:	c3                   	ret    
  8038a5:	8d 76 00             	lea    0x0(%esi),%esi
  8038a8:	39 f2                	cmp    %esi,%edx
  8038aa:	76 14                	jbe    8038c0 <__udivdi3+0x50>
  8038ac:	31 ff                	xor    %edi,%edi
  8038ae:	31 c0                	xor    %eax,%eax
  8038b0:	89 fa                	mov    %edi,%edx
  8038b2:	83 c4 1c             	add    $0x1c,%esp
  8038b5:	5b                   	pop    %ebx
  8038b6:	5e                   	pop    %esi
  8038b7:	5f                   	pop    %edi
  8038b8:	5d                   	pop    %ebp
  8038b9:	c3                   	ret    
  8038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8038c0:	0f bd fa             	bsr    %edx,%edi
  8038c3:	83 f7 1f             	xor    $0x1f,%edi
  8038c6:	75 48                	jne    803910 <__udivdi3+0xa0>
  8038c8:	39 f2                	cmp    %esi,%edx
  8038ca:	72 06                	jb     8038d2 <__udivdi3+0x62>
  8038cc:	31 c0                	xor    %eax,%eax
  8038ce:	39 eb                	cmp    %ebp,%ebx
  8038d0:	77 de                	ja     8038b0 <__udivdi3+0x40>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	eb d7                	jmp    8038b0 <__udivdi3+0x40>
  8038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038e0:	89 d9                	mov    %ebx,%ecx
  8038e2:	85 db                	test   %ebx,%ebx
  8038e4:	75 0b                	jne    8038f1 <__udivdi3+0x81>
  8038e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038eb:	31 d2                	xor    %edx,%edx
  8038ed:	f7 f3                	div    %ebx
  8038ef:	89 c1                	mov    %eax,%ecx
  8038f1:	31 d2                	xor    %edx,%edx
  8038f3:	89 f0                	mov    %esi,%eax
  8038f5:	f7 f1                	div    %ecx
  8038f7:	89 c6                	mov    %eax,%esi
  8038f9:	89 e8                	mov    %ebp,%eax
  8038fb:	89 f7                	mov    %esi,%edi
  8038fd:	f7 f1                	div    %ecx
  8038ff:	89 fa                	mov    %edi,%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803910:	89 f9                	mov    %edi,%ecx
  803912:	b8 20 00 00 00       	mov    $0x20,%eax
  803917:	29 f8                	sub    %edi,%eax
  803919:	d3 e2                	shl    %cl,%edx
  80391b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80391f:	89 c1                	mov    %eax,%ecx
  803921:	89 da                	mov    %ebx,%edx
  803923:	d3 ea                	shr    %cl,%edx
  803925:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803929:	09 d1                	or     %edx,%ecx
  80392b:	89 f2                	mov    %esi,%edx
  80392d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803931:	89 f9                	mov    %edi,%ecx
  803933:	d3 e3                	shl    %cl,%ebx
  803935:	89 c1                	mov    %eax,%ecx
  803937:	d3 ea                	shr    %cl,%edx
  803939:	89 f9                	mov    %edi,%ecx
  80393b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80393f:	89 eb                	mov    %ebp,%ebx
  803941:	d3 e6                	shl    %cl,%esi
  803943:	89 c1                	mov    %eax,%ecx
  803945:	d3 eb                	shr    %cl,%ebx
  803947:	09 de                	or     %ebx,%esi
  803949:	89 f0                	mov    %esi,%eax
  80394b:	f7 74 24 08          	divl   0x8(%esp)
  80394f:	89 d6                	mov    %edx,%esi
  803951:	89 c3                	mov    %eax,%ebx
  803953:	f7 64 24 0c          	mull   0xc(%esp)
  803957:	39 d6                	cmp    %edx,%esi
  803959:	72 15                	jb     803970 <__udivdi3+0x100>
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e5                	shl    %cl,%ebp
  80395f:	39 c5                	cmp    %eax,%ebp
  803961:	73 04                	jae    803967 <__udivdi3+0xf7>
  803963:	39 d6                	cmp    %edx,%esi
  803965:	74 09                	je     803970 <__udivdi3+0x100>
  803967:	89 d8                	mov    %ebx,%eax
  803969:	31 ff                	xor    %edi,%edi
  80396b:	e9 40 ff ff ff       	jmp    8038b0 <__udivdi3+0x40>
  803970:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803973:	31 ff                	xor    %edi,%edi
  803975:	e9 36 ff ff ff       	jmp    8038b0 <__udivdi3+0x40>
  80397a:	66 90                	xchg   %ax,%ax
  80397c:	66 90                	xchg   %ax,%ax
  80397e:	66 90                	xchg   %ax,%ax

00803980 <__umoddi3>:
  803980:	f3 0f 1e fb          	endbr32 
  803984:	55                   	push   %ebp
  803985:	57                   	push   %edi
  803986:	56                   	push   %esi
  803987:	53                   	push   %ebx
  803988:	83 ec 1c             	sub    $0x1c,%esp
  80398b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80398f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803993:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399b:	85 c0                	test   %eax,%eax
  80399d:	75 19                	jne    8039b8 <__umoddi3+0x38>
  80399f:	39 df                	cmp    %ebx,%edi
  8039a1:	76 5d                	jbe    803a00 <__umoddi3+0x80>
  8039a3:	89 f0                	mov    %esi,%eax
  8039a5:	89 da                	mov    %ebx,%edx
  8039a7:	f7 f7                	div    %edi
  8039a9:	89 d0                	mov    %edx,%eax
  8039ab:	31 d2                	xor    %edx,%edx
  8039ad:	83 c4 1c             	add    $0x1c,%esp
  8039b0:	5b                   	pop    %ebx
  8039b1:	5e                   	pop    %esi
  8039b2:	5f                   	pop    %edi
  8039b3:	5d                   	pop    %ebp
  8039b4:	c3                   	ret    
  8039b5:	8d 76 00             	lea    0x0(%esi),%esi
  8039b8:	89 f2                	mov    %esi,%edx
  8039ba:	39 d8                	cmp    %ebx,%eax
  8039bc:	76 12                	jbe    8039d0 <__umoddi3+0x50>
  8039be:	89 f0                	mov    %esi,%eax
  8039c0:	89 da                	mov    %ebx,%edx
  8039c2:	83 c4 1c             	add    $0x1c,%esp
  8039c5:	5b                   	pop    %ebx
  8039c6:	5e                   	pop    %esi
  8039c7:	5f                   	pop    %edi
  8039c8:	5d                   	pop    %ebp
  8039c9:	c3                   	ret    
  8039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8039d0:	0f bd e8             	bsr    %eax,%ebp
  8039d3:	83 f5 1f             	xor    $0x1f,%ebp
  8039d6:	75 50                	jne    803a28 <__umoddi3+0xa8>
  8039d8:	39 d8                	cmp    %ebx,%eax
  8039da:	0f 82 e0 00 00 00    	jb     803ac0 <__umoddi3+0x140>
  8039e0:	89 d9                	mov    %ebx,%ecx
  8039e2:	39 f7                	cmp    %esi,%edi
  8039e4:	0f 86 d6 00 00 00    	jbe    803ac0 <__umoddi3+0x140>
  8039ea:	89 d0                	mov    %edx,%eax
  8039ec:	89 ca                	mov    %ecx,%edx
  8039ee:	83 c4 1c             	add    $0x1c,%esp
  8039f1:	5b                   	pop    %ebx
  8039f2:	5e                   	pop    %esi
  8039f3:	5f                   	pop    %edi
  8039f4:	5d                   	pop    %ebp
  8039f5:	c3                   	ret    
  8039f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8039fd:	8d 76 00             	lea    0x0(%esi),%esi
  803a00:	89 fd                	mov    %edi,%ebp
  803a02:	85 ff                	test   %edi,%edi
  803a04:	75 0b                	jne    803a11 <__umoddi3+0x91>
  803a06:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	f7 f7                	div    %edi
  803a0f:	89 c5                	mov    %eax,%ebp
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f5                	div    %ebp
  803a17:	89 f0                	mov    %esi,%eax
  803a19:	f7 f5                	div    %ebp
  803a1b:	89 d0                	mov    %edx,%eax
  803a1d:	31 d2                	xor    %edx,%edx
  803a1f:	eb 8c                	jmp    8039ad <__umoddi3+0x2d>
  803a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a28:	89 e9                	mov    %ebp,%ecx
  803a2a:	ba 20 00 00 00       	mov    $0x20,%edx
  803a2f:	29 ea                	sub    %ebp,%edx
  803a31:	d3 e0                	shl    %cl,%eax
  803a33:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a37:	89 d1                	mov    %edx,%ecx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	d3 e8                	shr    %cl,%eax
  803a3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803a41:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a45:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a49:	09 c1                	or     %eax,%ecx
  803a4b:	89 d8                	mov    %ebx,%eax
  803a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 e7                	shl    %cl,%edi
  803a55:	89 d1                	mov    %edx,%ecx
  803a57:	d3 e8                	shr    %cl,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a5f:	d3 e3                	shl    %cl,%ebx
  803a61:	89 c7                	mov    %eax,%edi
  803a63:	89 d1                	mov    %edx,%ecx
  803a65:	89 f0                	mov    %esi,%eax
  803a67:	d3 e8                	shr    %cl,%eax
  803a69:	89 e9                	mov    %ebp,%ecx
  803a6b:	89 fa                	mov    %edi,%edx
  803a6d:	d3 e6                	shl    %cl,%esi
  803a6f:	09 d8                	or     %ebx,%eax
  803a71:	f7 74 24 08          	divl   0x8(%esp)
  803a75:	89 d1                	mov    %edx,%ecx
  803a77:	89 f3                	mov    %esi,%ebx
  803a79:	f7 64 24 0c          	mull   0xc(%esp)
  803a7d:	89 c6                	mov    %eax,%esi
  803a7f:	89 d7                	mov    %edx,%edi
  803a81:	39 d1                	cmp    %edx,%ecx
  803a83:	72 06                	jb     803a8b <__umoddi3+0x10b>
  803a85:	75 10                	jne    803a97 <__umoddi3+0x117>
  803a87:	39 c3                	cmp    %eax,%ebx
  803a89:	73 0c                	jae    803a97 <__umoddi3+0x117>
  803a8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803a8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803a93:	89 d7                	mov    %edx,%edi
  803a95:	89 c6                	mov    %eax,%esi
  803a97:	89 ca                	mov    %ecx,%edx
  803a99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803a9e:	29 f3                	sub    %esi,%ebx
  803aa0:	19 fa                	sbb    %edi,%edx
  803aa2:	89 d0                	mov    %edx,%eax
  803aa4:	d3 e0                	shl    %cl,%eax
  803aa6:	89 e9                	mov    %ebp,%ecx
  803aa8:	d3 eb                	shr    %cl,%ebx
  803aaa:	d3 ea                	shr    %cl,%edx
  803aac:	09 d8                	or     %ebx,%eax
  803aae:	83 c4 1c             	add    $0x1c,%esp
  803ab1:	5b                   	pop    %ebx
  803ab2:	5e                   	pop    %esi
  803ab3:	5f                   	pop    %edi
  803ab4:	5d                   	pop    %ebp
  803ab5:	c3                   	ret    
  803ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	29 fe                	sub    %edi,%esi
  803ac2:	19 c3                	sbb    %eax,%ebx
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	89 d9                	mov    %ebx,%ecx
  803ac8:	e9 1d ff ff ff       	jmp    8039ea <__umoddi3+0x6a>
