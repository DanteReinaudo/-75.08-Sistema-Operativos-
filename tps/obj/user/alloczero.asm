
obj/user/alloczero.debug:     formato del fichero elf32-i386


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
  80002c:	e8 0f 01 00 00       	call   800140 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <write_page>:

#include <inc/lib.h>

void
write_page(uint16_t *addr, uint16_t value)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;

	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	6a 07                	push   $0x7
  800047:	53                   	push   %ebx
  800048:	6a 00                	push   $0x0
  80004a:	e8 36 0c 00 00       	call   800c85 <sys_page_alloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	85 c0                	test   %eax,%eax
  800054:	78 1c                	js     800072 <write_page+0x3f>
		panic("sys_page_alloc: %e", r);
	addr[0] = value;
  800056:	66 89 33             	mov    %si,(%ebx)
	if ((r = sys_page_unmap(0, addr)) < 0)
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	53                   	push   %ebx
  80005d:	6a 00                	push   $0x0
  80005f:	e8 73 0c 00 00       	call   800cd7 <sys_page_unmap>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 19                	js     800084 <write_page+0x51>
		panic("sys_page_unmap: %e", r);
}
  80006b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80006e:	5b                   	pop    %ebx
  80006f:	5e                   	pop    %esi
  800070:	5d                   	pop    %ebp
  800071:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  800072:	50                   	push   %eax
  800073:	68 00 1f 80 00       	push   $0x801f00
  800078:	6a 0b                	push   $0xb
  80007a:	68 13 1f 80 00       	push   $0x801f13
  80007f:	e8 28 01 00 00       	call   8001ac <_panic>
		panic("sys_page_unmap: %e", r);
  800084:	50                   	push   %eax
  800085:	68 24 1f 80 00       	push   $0x801f24
  80008a:	6a 0e                	push   $0xe
  80008c:	68 13 1f 80 00       	push   $0x801f13
  800091:	e8 16 01 00 00       	call   8001ac <_panic>

00800096 <check>:

void
check(uint16_t *addr)
{
  800096:	f3 0f 1e fb          	endbr32 
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	53                   	push   %ebx
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;

	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U)) < 0)
  8000a4:	6a 05                	push   $0x5
  8000a6:	53                   	push   %ebx
  8000a7:	6a 00                	push   $0x0
  8000a9:	e8 d7 0b 00 00       	call   800c85 <sys_page_alloc>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	85 c0                	test   %eax,%eax
  8000b3:	78 1d                	js     8000d2 <check+0x3c>
		panic("sys_page_alloc: %e", r);
	if (addr[0] != '\0')
  8000b5:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  8000b9:	75 29                	jne    8000e4 <check+0x4e>
		panic("The allocated memory is not initialized to zero");
	if ((r = sys_page_unmap(0, addr)) < 0)
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	6a 00                	push   $0x0
  8000c1:	e8 11 0c 00 00       	call   800cd7 <sys_page_unmap>
  8000c6:	83 c4 10             	add    $0x10,%esp
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	78 2b                	js     8000f8 <check+0x62>
		panic("sys_page_unmap: %e", r);
}
  8000cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d0:	c9                   	leave  
  8000d1:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8000d2:	50                   	push   %eax
  8000d3:	68 00 1f 80 00       	push   $0x801f00
  8000d8:	6a 17                	push   $0x17
  8000da:	68 13 1f 80 00       	push   $0x801f13
  8000df:	e8 c8 00 00 00       	call   8001ac <_panic>
		panic("The allocated memory is not initialized to zero");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 38 1f 80 00       	push   $0x801f38
  8000ec:	6a 19                	push   $0x19
  8000ee:	68 13 1f 80 00       	push   $0x801f13
  8000f3:	e8 b4 00 00 00       	call   8001ac <_panic>
		panic("sys_page_unmap: %e", r);
  8000f8:	50                   	push   %eax
  8000f9:	68 24 1f 80 00       	push   $0x801f24
  8000fe:	6a 1b                	push   $0x1b
  800100:	68 13 1f 80 00       	push   $0x801f13
  800105:	e8 a2 00 00 00       	call   8001ac <_panic>

0080010a <umain>:

void
umain(int argc, char **argv)
{
  80010a:	f3 0f 1e fb          	endbr32 
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	83 ec 10             	sub    $0x10,%esp
	write_page(UTEMP, 0x7508);
  800114:	68 08 75 00 00       	push   $0x7508
  800119:	68 00 00 40 00       	push   $0x400000
  80011e:	e8 10 ff ff ff       	call   800033 <write_page>
	check(UTEMP);
  800123:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80012a:	e8 67 ff ff ff       	call   800096 <check>
	cprintf("The allocated memory is initialized to zero\n");
  80012f:	c7 04 24 68 1f 80 00 	movl   $0x801f68,(%esp)
  800136:	e8 58 01 00 00       	call   800293 <cprintf>
}
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800140:	f3 0f 1e fb          	endbr32 
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
  800149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80014c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80014f:	e8 de 0a 00 00       	call   800c32 <sys_getenvid>
	if (id >= 0)
  800154:	85 c0                	test   %eax,%eax
  800156:	78 12                	js     80016a <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016a:	85 db                	test   %ebx,%ebx
  80016c:	7e 07                	jle    800175 <libmain+0x35>
		binaryname = argv[0];
  80016e:	8b 06                	mov    (%esi),%eax
  800170:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	56                   	push   %esi
  800179:	53                   	push   %ebx
  80017a:	e8 8b ff ff ff       	call   80010a <umain>

	// exit gracefully
	exit();
  80017f:	e8 0a 00 00 00       	call   80018e <exit>
}
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80018a:	5b                   	pop    %ebx
  80018b:	5e                   	pop    %esi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    

0080018e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018e:	f3 0f 1e fb          	endbr32 
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800198:	e8 18 0e 00 00       	call   800fb5 <close_all>
	sys_env_destroy(0);
  80019d:	83 ec 0c             	sub    $0xc,%esp
  8001a0:	6a 00                	push   $0x0
  8001a2:	e8 65 0a 00 00       	call   800c0c <sys_env_destroy>
}
  8001a7:	83 c4 10             	add    $0x10,%esp
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ac:	f3 0f 1e fb          	endbr32 
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001b5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001b8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001be:	e8 6f 0a 00 00       	call   800c32 <sys_getenvid>
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	ff 75 0c             	pushl  0xc(%ebp)
  8001c9:	ff 75 08             	pushl  0x8(%ebp)
  8001cc:	56                   	push   %esi
  8001cd:	50                   	push   %eax
  8001ce:	68 a0 1f 80 00       	push   $0x801fa0
  8001d3:	e8 bb 00 00 00       	call   800293 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001d8:	83 c4 18             	add    $0x18,%esp
  8001db:	53                   	push   %ebx
  8001dc:	ff 75 10             	pushl  0x10(%ebp)
  8001df:	e8 5a 00 00 00       	call   80023e <vcprintf>
	cprintf("\n");
  8001e4:	c7 04 24 1e 24 80 00 	movl   $0x80241e,(%esp)
  8001eb:	e8 a3 00 00 00       	call   800293 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001f3:	cc                   	int3   
  8001f4:	eb fd                	jmp    8001f3 <_panic+0x47>

008001f6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f6:	f3 0f 1e fb          	endbr32 
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	53                   	push   %ebx
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800204:	8b 13                	mov    (%ebx),%edx
  800206:	8d 42 01             	lea    0x1(%edx),%eax
  800209:	89 03                	mov    %eax,(%ebx)
  80020b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800212:	3d ff 00 00 00       	cmp    $0xff,%eax
  800217:	74 09                	je     800222 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800219:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800220:	c9                   	leave  
  800221:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	68 ff 00 00 00       	push   $0xff
  80022a:	8d 43 08             	lea    0x8(%ebx),%eax
  80022d:	50                   	push   %eax
  80022e:	e8 87 09 00 00       	call   800bba <sys_cputs>
		b->idx = 0;
  800233:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb db                	jmp    800219 <putch+0x23>

0080023e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023e:	f3 0f 1e fb          	endbr32 
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800252:	00 00 00 
	b.cnt = 0;
  800255:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025f:	ff 75 0c             	pushl  0xc(%ebp)
  800262:	ff 75 08             	pushl  0x8(%ebp)
  800265:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	68 f6 01 80 00       	push   $0x8001f6
  800271:	e8 80 01 00 00       	call   8003f6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800276:	83 c4 08             	add    $0x8,%esp
  800279:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80027f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	e8 2f 09 00 00       	call   800bba <sys_cputs>

	return b.cnt;
}
  80028b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800293:	f3 0f 1e fb          	endbr32 
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a0:	50                   	push   %eax
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	e8 95 ff ff ff       	call   80023e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 1c             	sub    $0x1c,%esp
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	89 d6                	mov    %edx,%esi
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002be:	89 d1                	mov    %edx,%ecx
  8002c0:	89 c2                	mov    %eax,%edx
  8002c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002dd:	72 3e                	jb     80031d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	ff 75 18             	pushl  0x18(%ebp)
  8002e5:	83 eb 01             	sub    $0x1,%ebx
  8002e8:	53                   	push   %ebx
  8002e9:	50                   	push   %eax
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f9:	e8 92 19 00 00       	call   801c90 <__udivdi3>
  8002fe:	83 c4 18             	add    $0x18,%esp
  800301:	52                   	push   %edx
  800302:	50                   	push   %eax
  800303:	89 f2                	mov    %esi,%edx
  800305:	89 f8                	mov    %edi,%eax
  800307:	e8 9f ff ff ff       	call   8002ab <printnum>
  80030c:	83 c4 20             	add    $0x20,%esp
  80030f:	eb 13                	jmp    800324 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	56                   	push   %esi
  800315:	ff 75 18             	pushl  0x18(%ebp)
  800318:	ff d7                	call   *%edi
  80031a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031d:	83 eb 01             	sub    $0x1,%ebx
  800320:	85 db                	test   %ebx,%ebx
  800322:	7f ed                	jg     800311 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	56                   	push   %esi
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032e:	ff 75 e0             	pushl  -0x20(%ebp)
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	ff 75 d8             	pushl  -0x28(%ebp)
  800337:	e8 64 1a 00 00       	call   801da0 <__umoddi3>
  80033c:	83 c4 14             	add    $0x14,%esp
  80033f:	0f be 80 c3 1f 80 00 	movsbl 0x801fc3(%eax),%eax
  800346:	50                   	push   %eax
  800347:	ff d7                	call   *%edi
}
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034f:	5b                   	pop    %ebx
  800350:	5e                   	pop    %esi
  800351:	5f                   	pop    %edi
  800352:	5d                   	pop    %ebp
  800353:	c3                   	ret    

00800354 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800354:	83 fa 01             	cmp    $0x1,%edx
  800357:	7f 13                	jg     80036c <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800359:	85 d2                	test   %edx,%edx
  80035b:	74 1c                	je     800379 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80035d:	8b 10                	mov    (%eax),%edx
  80035f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800362:	89 08                	mov    %ecx,(%eax)
  800364:	8b 02                	mov    (%edx),%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80036c:	8b 10                	mov    (%eax),%edx
  80036e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800371:	89 08                	mov    %ecx,(%eax)
  800373:	8b 02                	mov    (%edx),%eax
  800375:	8b 52 04             	mov    0x4(%edx),%edx
  800378:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	c3                   	ret    

00800388 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800388:	83 fa 01             	cmp    $0x1,%edx
  80038b:	7f 0f                	jg     80039c <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80038d:	85 d2                	test   %edx,%edx
  80038f:	74 18                	je     8003a9 <getint+0x21>
		return va_arg(*ap, long);
  800391:	8b 10                	mov    (%eax),%edx
  800393:	8d 4a 04             	lea    0x4(%edx),%ecx
  800396:	89 08                	mov    %ecx,(%eax)
  800398:	8b 02                	mov    (%edx),%eax
  80039a:	99                   	cltd   
  80039b:	c3                   	ret    
		return va_arg(*ap, long long);
  80039c:	8b 10                	mov    (%eax),%edx
  80039e:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003a1:	89 08                	mov    %ecx,(%eax)
  8003a3:	8b 02                	mov    (%edx),%eax
  8003a5:	8b 52 04             	mov    0x4(%edx),%edx
  8003a8:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	99                   	cltd   
}
  8003b3:	c3                   	ret    

008003b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b4:	f3 0f 1e fb          	endbr32 
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003be:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c2:	8b 10                	mov    (%eax),%edx
  8003c4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c7:	73 0a                	jae    8003d3 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cc:	89 08                	mov    %ecx,(%eax)
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	88 02                	mov    %al,(%edx)
}
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    

008003d5 <printfmt>:
{
  8003d5:	f3 0f 1e fb          	endbr32 
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003df:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e2:	50                   	push   %eax
  8003e3:	ff 75 10             	pushl  0x10(%ebp)
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	ff 75 08             	pushl  0x8(%ebp)
  8003ec:	e8 05 00 00 00       	call   8003f6 <vprintfmt>
}
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    

008003f6 <vprintfmt>:
{
  8003f6:	f3 0f 1e fb          	endbr32 
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	83 ec 2c             	sub    $0x2c,%esp
  800403:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800406:	8b 75 0c             	mov    0xc(%ebp),%esi
  800409:	8b 7d 10             	mov    0x10(%ebp),%edi
  80040c:	e9 86 02 00 00       	jmp    800697 <vprintfmt+0x2a1>
		padc = ' ';
  800411:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800415:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80041c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800423:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8d 47 01             	lea    0x1(%edi),%eax
  800432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800435:	0f b6 17             	movzbl (%edi),%edx
  800438:	8d 42 dd             	lea    -0x23(%edx),%eax
  80043b:	3c 55                	cmp    $0x55,%al
  80043d:	0f 87 df 02 00 00    	ja     800722 <vprintfmt+0x32c>
  800443:	0f b6 c0             	movzbl %al,%eax
  800446:	3e ff 24 85 00 21 80 	notrack jmp *0x802100(,%eax,4)
  80044d:	00 
  80044e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800451:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800455:	eb d8                	jmp    80042f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80045a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80045e:	eb cf                	jmp    80042f <vprintfmt+0x39>
  800460:	0f b6 d2             	movzbl %dl,%edx
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
  80046b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80046e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800471:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800475:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800478:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80047b:	83 f9 09             	cmp    $0x9,%ecx
  80047e:	77 52                	ja     8004d2 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800480:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800483:	eb e9                	jmp    80046e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 50 04             	lea    0x4(%eax),%edx
  80048b:	89 55 14             	mov    %edx,0x14(%ebp)
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049a:	79 93                	jns    80042f <vprintfmt+0x39>
				width = precision, precision = -1;
  80049c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a9:	eb 84                	jmp    80042f <vprintfmt+0x39>
  8004ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b5:	0f 49 d0             	cmovns %eax,%edx
  8004b8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004be:	e9 6c ff ff ff       	jmp    80042f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004cd:	e9 5d ff ff ff       	jmp    80042f <vprintfmt+0x39>
  8004d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d8:	eb bc                	jmp    800496 <vprintfmt+0xa0>
			lflag++;
  8004da:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004e0:	e9 4a ff ff ff       	jmp    80042f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	8d 50 04             	lea    0x4(%eax),%edx
  8004eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	56                   	push   %esi
  8004f2:	ff 30                	pushl  (%eax)
  8004f4:	ff d3                	call   *%ebx
			break;
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	e9 96 01 00 00       	jmp    800694 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 50 04             	lea    0x4(%eax),%edx
  800504:	89 55 14             	mov    %edx,0x14(%ebp)
  800507:	8b 00                	mov    (%eax),%eax
  800509:	99                   	cltd   
  80050a:	31 d0                	xor    %edx,%eax
  80050c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050e:	83 f8 0f             	cmp    $0xf,%eax
  800511:	7f 20                	jg     800533 <vprintfmt+0x13d>
  800513:	8b 14 85 60 22 80 00 	mov    0x802260(,%eax,4),%edx
  80051a:	85 d2                	test   %edx,%edx
  80051c:	74 15                	je     800533 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80051e:	52                   	push   %edx
  80051f:	68 b7 23 80 00       	push   $0x8023b7
  800524:	56                   	push   %esi
  800525:	53                   	push   %ebx
  800526:	e8 aa fe ff ff       	call   8003d5 <printfmt>
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	e9 61 01 00 00       	jmp    800694 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800533:	50                   	push   %eax
  800534:	68 db 1f 80 00       	push   $0x801fdb
  800539:	56                   	push   %esi
  80053a:	53                   	push   %ebx
  80053b:	e8 95 fe ff ff       	call   8003d5 <printfmt>
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	e9 4c 01 00 00       	jmp    800694 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 50 04             	lea    0x4(%eax),%edx
  80054e:	89 55 14             	mov    %edx,0x14(%ebp)
  800551:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800553:	85 c9                	test   %ecx,%ecx
  800555:	b8 d4 1f 80 00       	mov    $0x801fd4,%eax
  80055a:	0f 45 c1             	cmovne %ecx,%eax
  80055d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800560:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800564:	7e 06                	jle    80056c <vprintfmt+0x176>
  800566:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80056a:	75 0d                	jne    800579 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056f:	89 c7                	mov    %eax,%edi
  800571:	03 45 e0             	add    -0x20(%ebp),%eax
  800574:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800577:	eb 57                	jmp    8005d0 <vprintfmt+0x1da>
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	ff 75 d8             	pushl  -0x28(%ebp)
  80057f:	ff 75 cc             	pushl  -0x34(%ebp)
  800582:	e8 4f 02 00 00       	call   8007d6 <strnlen>
  800587:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058a:	29 c2                	sub    %eax,%edx
  80058c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80058f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800592:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800596:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800599:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80059b:	85 db                	test   %ebx,%ebx
  80059d:	7e 10                	jle    8005af <vprintfmt+0x1b9>
					putch(padc, putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	56                   	push   %esi
  8005a3:	57                   	push   %edi
  8005a4:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a7:	83 eb 01             	sub    $0x1,%ebx
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	eb ec                	jmp    80059b <vprintfmt+0x1a5>
  8005af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bc:	0f 49 c2             	cmovns %edx,%eax
  8005bf:	29 c2                	sub    %eax,%edx
  8005c1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005c4:	eb a6                	jmp    80056c <vprintfmt+0x176>
					putch(ch, putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	56                   	push   %esi
  8005ca:	52                   	push   %edx
  8005cb:	ff d3                	call   *%ebx
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d5:	83 c7 01             	add    $0x1,%edi
  8005d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005dc:	0f be d0             	movsbl %al,%edx
  8005df:	85 d2                	test   %edx,%edx
  8005e1:	74 42                	je     800625 <vprintfmt+0x22f>
  8005e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e7:	78 06                	js     8005ef <vprintfmt+0x1f9>
  8005e9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ed:	78 1e                	js     80060d <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f3:	74 d1                	je     8005c6 <vprintfmt+0x1d0>
  8005f5:	0f be c0             	movsbl %al,%eax
  8005f8:	83 e8 20             	sub    $0x20,%eax
  8005fb:	83 f8 5e             	cmp    $0x5e,%eax
  8005fe:	76 c6                	jbe    8005c6 <vprintfmt+0x1d0>
					putch('?', putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	56                   	push   %esi
  800604:	6a 3f                	push   $0x3f
  800606:	ff d3                	call   *%ebx
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	eb c3                	jmp    8005d0 <vprintfmt+0x1da>
  80060d:	89 cf                	mov    %ecx,%edi
  80060f:	eb 0e                	jmp    80061f <vprintfmt+0x229>
				putch(' ', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	56                   	push   %esi
  800615:	6a 20                	push   $0x20
  800617:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800619:	83 ef 01             	sub    $0x1,%edi
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	85 ff                	test   %edi,%edi
  800621:	7f ee                	jg     800611 <vprintfmt+0x21b>
  800623:	eb 6f                	jmp    800694 <vprintfmt+0x29e>
  800625:	89 cf                	mov    %ecx,%edi
  800627:	eb f6                	jmp    80061f <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800629:	89 ca                	mov    %ecx,%edx
  80062b:	8d 45 14             	lea    0x14(%ebp),%eax
  80062e:	e8 55 fd ff ff       	call   800388 <getint>
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800639:	85 d2                	test   %edx,%edx
  80063b:	78 0b                	js     800648 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80063d:	89 d1                	mov    %edx,%ecx
  80063f:	89 c2                	mov    %eax,%edx
			base = 10;
  800641:	b8 0a 00 00 00       	mov    $0xa,%eax
  800646:	eb 32                	jmp    80067a <vprintfmt+0x284>
				putch('-', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	56                   	push   %esi
  80064c:	6a 2d                	push   $0x2d
  80064e:	ff d3                	call   *%ebx
				num = -(long long) num;
  800650:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800653:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800656:	f7 da                	neg    %edx
  800658:	83 d1 00             	adc    $0x0,%ecx
  80065b:	f7 d9                	neg    %ecx
  80065d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800660:	b8 0a 00 00 00       	mov    $0xa,%eax
  800665:	eb 13                	jmp    80067a <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800667:	89 ca                	mov    %ecx,%edx
  800669:	8d 45 14             	lea    0x14(%ebp),%eax
  80066c:	e8 e3 fc ff ff       	call   800354 <getuint>
  800671:	89 d1                	mov    %edx,%ecx
  800673:	89 c2                	mov    %eax,%edx
			base = 10;
  800675:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800681:	57                   	push   %edi
  800682:	ff 75 e0             	pushl  -0x20(%ebp)
  800685:	50                   	push   %eax
  800686:	51                   	push   %ecx
  800687:	52                   	push   %edx
  800688:	89 f2                	mov    %esi,%edx
  80068a:	89 d8                	mov    %ebx,%eax
  80068c:	e8 1a fc ff ff       	call   8002ab <printnum>
			break;
  800691:	83 c4 20             	add    $0x20,%esp
{
  800694:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800697:	83 c7 01             	add    $0x1,%edi
  80069a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069e:	83 f8 25             	cmp    $0x25,%eax
  8006a1:	0f 84 6a fd ff ff    	je     800411 <vprintfmt+0x1b>
			if (ch == '\0')
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	0f 84 93 00 00 00    	je     800742 <vprintfmt+0x34c>
			putch(ch, putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	56                   	push   %esi
  8006b3:	50                   	push   %eax
  8006b4:	ff d3                	call   *%ebx
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	eb dc                	jmp    800697 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8006bb:	89 ca                	mov    %ecx,%edx
  8006bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c0:	e8 8f fc ff ff       	call   800354 <getuint>
  8006c5:	89 d1                	mov    %edx,%ecx
  8006c7:	89 c2                	mov    %eax,%edx
			base = 8;
  8006c9:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006ce:	eb aa                	jmp    80067a <vprintfmt+0x284>
			putch('0', putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	56                   	push   %esi
  8006d4:	6a 30                	push   $0x30
  8006d6:	ff d3                	call   *%ebx
			putch('x', putdat);
  8006d8:	83 c4 08             	add    $0x8,%esp
  8006db:	56                   	push   %esi
  8006dc:	6a 78                	push   $0x78
  8006de:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 50 04             	lea    0x4(%eax),%edx
  8006e6:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8006e9:	8b 10                	mov    (%eax),%edx
  8006eb:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006f0:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8006f3:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006f8:	eb 80                	jmp    80067a <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006fa:	89 ca                	mov    %ecx,%edx
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ff:	e8 50 fc ff ff       	call   800354 <getuint>
  800704:	89 d1                	mov    %edx,%ecx
  800706:	89 c2                	mov    %eax,%edx
			base = 16;
  800708:	b8 10 00 00 00       	mov    $0x10,%eax
  80070d:	e9 68 ff ff ff       	jmp    80067a <vprintfmt+0x284>
			putch(ch, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	56                   	push   %esi
  800716:	6a 25                	push   $0x25
  800718:	ff d3                	call   *%ebx
			break;
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	e9 72 ff ff ff       	jmp    800694 <vprintfmt+0x29e>
			putch('%', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	56                   	push   %esi
  800726:	6a 25                	push   $0x25
  800728:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 f8                	mov    %edi,%eax
  80072f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800733:	74 05                	je     80073a <vprintfmt+0x344>
  800735:	83 e8 01             	sub    $0x1,%eax
  800738:	eb f5                	jmp    80072f <vprintfmt+0x339>
  80073a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073d:	e9 52 ff ff ff       	jmp    800694 <vprintfmt+0x29e>
}
  800742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800745:	5b                   	pop    %ebx
  800746:	5e                   	pop    %esi
  800747:	5f                   	pop    %edi
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074a:	f3 0f 1e fb          	endbr32 
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 18             	sub    $0x18,%esp
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800761:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 26                	je     800795 <vsnprintf+0x4b>
  80076f:	85 d2                	test   %edx,%edx
  800771:	7e 22                	jle    800795 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800773:	ff 75 14             	pushl  0x14(%ebp)
  800776:	ff 75 10             	pushl  0x10(%ebp)
  800779:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	68 b4 03 80 00       	push   $0x8003b4
  800782:	e8 6f fc ff ff       	call   8003f6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800790:	83 c4 10             	add    $0x10,%esp
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    
		return -E_INVAL;
  800795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079a:	eb f7                	jmp    800793 <vsnprintf+0x49>

0080079c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079c:	f3 0f 1e fb          	endbr32 
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a9:	50                   	push   %eax
  8007aa:	ff 75 10             	pushl  0x10(%ebp)
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 92 ff ff ff       	call   80074a <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ba:	f3 0f 1e fb          	endbr32 
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cd:	74 05                	je     8007d4 <strlen+0x1a>
		n++;
  8007cf:	83 c0 01             	add    $0x1,%eax
  8007d2:	eb f5                	jmp    8007c9 <strlen+0xf>
	return n;
}
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d6:	f3 0f 1e fb          	endbr32 
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e8:	39 d0                	cmp    %edx,%eax
  8007ea:	74 0d                	je     8007f9 <strnlen+0x23>
  8007ec:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f0:	74 05                	je     8007f7 <strnlen+0x21>
		n++;
  8007f2:	83 c0 01             	add    $0x1,%eax
  8007f5:	eb f1                	jmp    8007e8 <strnlen+0x12>
  8007f7:	89 c2                	mov    %eax,%edx
	return n;
}
  8007f9:	89 d0                	mov    %edx,%eax
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
  800810:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800814:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800817:	83 c0 01             	add    $0x1,%eax
  80081a:	84 d2                	test   %dl,%dl
  80081c:	75 f2                	jne    800810 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80081e:	89 c8                	mov    %ecx,%eax
  800820:	5b                   	pop    %ebx
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800823:	f3 0f 1e fb          	endbr32 
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	83 ec 10             	sub    $0x10,%esp
  80082e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800831:	53                   	push   %ebx
  800832:	e8 83 ff ff ff       	call   8007ba <strlen>
  800837:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	01 d8                	add    %ebx,%eax
  80083f:	50                   	push   %eax
  800840:	e8 b8 ff ff ff       	call   8007fd <strcpy>
	return dst;
}
  800845:	89 d8                	mov    %ebx,%eax
  800847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084c:	f3 0f 1e fb          	endbr32 
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	56                   	push   %esi
  800854:	53                   	push   %ebx
  800855:	8b 75 08             	mov    0x8(%ebp),%esi
  800858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085b:	89 f3                	mov    %esi,%ebx
  80085d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800860:	89 f0                	mov    %esi,%eax
  800862:	39 d8                	cmp    %ebx,%eax
  800864:	74 11                	je     800877 <strncpy+0x2b>
		*dst++ = *src;
  800866:	83 c0 01             	add    $0x1,%eax
  800869:	0f b6 0a             	movzbl (%edx),%ecx
  80086c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086f:	80 f9 01             	cmp    $0x1,%cl
  800872:	83 da ff             	sbb    $0xffffffff,%edx
  800875:	eb eb                	jmp    800862 <strncpy+0x16>
	}
	return ret;
}
  800877:	89 f0                	mov    %esi,%eax
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087d:	f3 0f 1e fb          	endbr32 
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	56                   	push   %esi
  800885:	53                   	push   %ebx
  800886:	8b 75 08             	mov    0x8(%ebp),%esi
  800889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088c:	8b 55 10             	mov    0x10(%ebp),%edx
  80088f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800891:	85 d2                	test   %edx,%edx
  800893:	74 21                	je     8008b6 <strlcpy+0x39>
  800895:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800899:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80089b:	39 c2                	cmp    %eax,%edx
  80089d:	74 14                	je     8008b3 <strlcpy+0x36>
  80089f:	0f b6 19             	movzbl (%ecx),%ebx
  8008a2:	84 db                	test   %bl,%bl
  8008a4:	74 0b                	je     8008b1 <strlcpy+0x34>
			*dst++ = *src++;
  8008a6:	83 c1 01             	add    $0x1,%ecx
  8008a9:	83 c2 01             	add    $0x1,%edx
  8008ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008af:	eb ea                	jmp    80089b <strlcpy+0x1e>
  8008b1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b6:	29 f0                	sub    %esi,%eax
}
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	84 c0                	test   %al,%al
  8008ce:	74 0c                	je     8008dc <strcmp+0x20>
  8008d0:	3a 02                	cmp    (%edx),%al
  8008d2:	75 08                	jne    8008dc <strcmp+0x20>
		p++, q++;
  8008d4:	83 c1 01             	add    $0x1,%ecx
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	eb ed                	jmp    8008c9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dc:	0f b6 c0             	movzbl %al,%eax
  8008df:	0f b6 12             	movzbl (%edx),%edx
  8008e2:	29 d0                	sub    %edx,%eax
}
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e6:	f3 0f 1e fb          	endbr32 
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f4:	89 c3                	mov    %eax,%ebx
  8008f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f9:	eb 06                	jmp    800901 <strncmp+0x1b>
		n--, p++, q++;
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800901:	39 d8                	cmp    %ebx,%eax
  800903:	74 16                	je     80091b <strncmp+0x35>
  800905:	0f b6 08             	movzbl (%eax),%ecx
  800908:	84 c9                	test   %cl,%cl
  80090a:	74 04                	je     800910 <strncmp+0x2a>
  80090c:	3a 0a                	cmp    (%edx),%cl
  80090e:	74 eb                	je     8008fb <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800910:	0f b6 00             	movzbl (%eax),%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    
		return 0;
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	eb f6                	jmp    800918 <strncmp+0x32>

00800922 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	0f b6 10             	movzbl (%eax),%edx
  800933:	84 d2                	test   %dl,%dl
  800935:	74 09                	je     800940 <strchr+0x1e>
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	74 0a                	je     800945 <strchr+0x23>
	for (; *s; s++)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	eb f0                	jmp    800930 <strchr+0xe>
			return (char *) s;
	return 0;
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800947:	f3 0f 1e fb          	endbr32 
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800958:	38 ca                	cmp    %cl,%dl
  80095a:	74 09                	je     800965 <strfind+0x1e>
  80095c:	84 d2                	test   %dl,%dl
  80095e:	74 05                	je     800965 <strfind+0x1e>
	for (; *s; s++)
  800960:	83 c0 01             	add    $0x1,%eax
  800963:	eb f0                	jmp    800955 <strfind+0xe>
			break;
	return (char *) s;
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800967:	f3 0f 1e fb          	endbr32 
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	57                   	push   %edi
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
  800971:	8b 55 08             	mov    0x8(%ebp),%edx
  800974:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800977:	85 c9                	test   %ecx,%ecx
  800979:	74 33                	je     8009ae <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097b:	89 d0                	mov    %edx,%eax
  80097d:	09 c8                	or     %ecx,%eax
  80097f:	a8 03                	test   $0x3,%al
  800981:	75 23                	jne    8009a6 <memset+0x3f>
		c &= 0xFF;
  800983:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800987:	89 d8                	mov    %ebx,%eax
  800989:	c1 e0 08             	shl    $0x8,%eax
  80098c:	89 df                	mov    %ebx,%edi
  80098e:	c1 e7 18             	shl    $0x18,%edi
  800991:	89 de                	mov    %ebx,%esi
  800993:	c1 e6 10             	shl    $0x10,%esi
  800996:	09 f7                	or     %esi,%edi
  800998:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80099a:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80099f:	89 d7                	mov    %edx,%edi
  8009a1:	fc                   	cld    
  8009a2:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a4:	eb 08                	jmp    8009ae <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a6:	89 d7                	mov    %edx,%edi
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	fc                   	cld    
  8009ac:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009ae:	89 d0                	mov    %edx,%eax
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5f                   	pop    %edi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b5:	f3 0f 1e fb          	endbr32 
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	57                   	push   %edi
  8009bd:	56                   	push   %esi
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c7:	39 c6                	cmp    %eax,%esi
  8009c9:	73 32                	jae    8009fd <memmove+0x48>
  8009cb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ce:	39 c2                	cmp    %eax,%edx
  8009d0:	76 2b                	jbe    8009fd <memmove+0x48>
		s += n;
		d += n;
  8009d2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d5:	89 fe                	mov    %edi,%esi
  8009d7:	09 ce                	or     %ecx,%esi
  8009d9:	09 d6                	or     %edx,%esi
  8009db:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e1:	75 0e                	jne    8009f1 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e3:	83 ef 04             	sub    $0x4,%edi
  8009e6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ec:	fd                   	std    
  8009ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ef:	eb 09                	jmp    8009fa <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f1:	83 ef 01             	sub    $0x1,%edi
  8009f4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f7:	fd                   	std    
  8009f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009fa:	fc                   	cld    
  8009fb:	eb 1a                	jmp    800a17 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fd:	89 c2                	mov    %eax,%edx
  8009ff:	09 ca                	or     %ecx,%edx
  800a01:	09 f2                	or     %esi,%edx
  800a03:	f6 c2 03             	test   $0x3,%dl
  800a06:	75 0a                	jne    800a12 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a08:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0b:	89 c7                	mov    %eax,%edi
  800a0d:	fc                   	cld    
  800a0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a10:	eb 05                	jmp    800a17 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a12:	89 c7                	mov    %eax,%edi
  800a14:	fc                   	cld    
  800a15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a17:	5e                   	pop    %esi
  800a18:	5f                   	pop    %edi
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1b:	f3 0f 1e fb          	endbr32 
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a25:	ff 75 10             	pushl  0x10(%ebp)
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	ff 75 08             	pushl  0x8(%ebp)
  800a2e:	e8 82 ff ff ff       	call   8009b5 <memmove>
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a35:	f3 0f 1e fb          	endbr32 
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a44:	89 c6                	mov    %eax,%esi
  800a46:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a49:	39 f0                	cmp    %esi,%eax
  800a4b:	74 1c                	je     800a69 <memcmp+0x34>
		if (*s1 != *s2)
  800a4d:	0f b6 08             	movzbl (%eax),%ecx
  800a50:	0f b6 1a             	movzbl (%edx),%ebx
  800a53:	38 d9                	cmp    %bl,%cl
  800a55:	75 08                	jne    800a5f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a57:	83 c0 01             	add    $0x1,%eax
  800a5a:	83 c2 01             	add    $0x1,%edx
  800a5d:	eb ea                	jmp    800a49 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a5f:	0f b6 c1             	movzbl %cl,%eax
  800a62:	0f b6 db             	movzbl %bl,%ebx
  800a65:	29 d8                	sub    %ebx,%eax
  800a67:	eb 05                	jmp    800a6e <memcmp+0x39>
	}

	return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6e:	5b                   	pop    %ebx
  800a6f:	5e                   	pop    %esi
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a72:	f3 0f 1e fb          	endbr32 
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a84:	39 d0                	cmp    %edx,%eax
  800a86:	73 09                	jae    800a91 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a88:	38 08                	cmp    %cl,(%eax)
  800a8a:	74 05                	je     800a91 <memfind+0x1f>
	for (; s < ends; s++)
  800a8c:	83 c0 01             	add    $0x1,%eax
  800a8f:	eb f3                	jmp    800a84 <memfind+0x12>
			break;
	return (void *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a93:	f3 0f 1e fb          	endbr32 
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa3:	eb 03                	jmp    800aa8 <strtol+0x15>
		s++;
  800aa5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa8:	0f b6 01             	movzbl (%ecx),%eax
  800aab:	3c 20                	cmp    $0x20,%al
  800aad:	74 f6                	je     800aa5 <strtol+0x12>
  800aaf:	3c 09                	cmp    $0x9,%al
  800ab1:	74 f2                	je     800aa5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ab3:	3c 2b                	cmp    $0x2b,%al
  800ab5:	74 2a                	je     800ae1 <strtol+0x4e>
	int neg = 0;
  800ab7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abc:	3c 2d                	cmp    $0x2d,%al
  800abe:	74 2b                	je     800aeb <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac6:	75 0f                	jne    800ad7 <strtol+0x44>
  800ac8:	80 39 30             	cmpb   $0x30,(%ecx)
  800acb:	74 28                	je     800af5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad4:	0f 44 d8             	cmove  %eax,%ebx
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800adf:	eb 46                	jmp    800b27 <strtol+0x94>
		s++;
  800ae1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae9:	eb d5                	jmp    800ac0 <strtol+0x2d>
		s++, neg = 1;
  800aeb:	83 c1 01             	add    $0x1,%ecx
  800aee:	bf 01 00 00 00       	mov    $0x1,%edi
  800af3:	eb cb                	jmp    800ac0 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af9:	74 0e                	je     800b09 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afb:	85 db                	test   %ebx,%ebx
  800afd:	75 d8                	jne    800ad7 <strtol+0x44>
		s++, base = 8;
  800aff:	83 c1 01             	add    $0x1,%ecx
  800b02:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b07:	eb ce                	jmp    800ad7 <strtol+0x44>
		s += 2, base = 16;
  800b09:	83 c1 02             	add    $0x2,%ecx
  800b0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b11:	eb c4                	jmp    800ad7 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b13:	0f be d2             	movsbl %dl,%edx
  800b16:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1c:	7d 3a                	jge    800b58 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1e:	83 c1 01             	add    $0x1,%ecx
  800b21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b27:	0f b6 11             	movzbl (%ecx),%edx
  800b2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2d:	89 f3                	mov    %esi,%ebx
  800b2f:	80 fb 09             	cmp    $0x9,%bl
  800b32:	76 df                	jbe    800b13 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b34:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b37:	89 f3                	mov    %esi,%ebx
  800b39:	80 fb 19             	cmp    $0x19,%bl
  800b3c:	77 08                	ja     800b46 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3e:	0f be d2             	movsbl %dl,%edx
  800b41:	83 ea 57             	sub    $0x57,%edx
  800b44:	eb d3                	jmp    800b19 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b46:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b49:	89 f3                	mov    %esi,%ebx
  800b4b:	80 fb 19             	cmp    $0x19,%bl
  800b4e:	77 08                	ja     800b58 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b50:	0f be d2             	movsbl %dl,%edx
  800b53:	83 ea 37             	sub    $0x37,%edx
  800b56:	eb c1                	jmp    800b19 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5c:	74 05                	je     800b63 <strtol+0xd0>
		*endptr = (char *) s;
  800b5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b61:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b63:	89 c2                	mov    %eax,%edx
  800b65:	f7 da                	neg    %edx
  800b67:	85 ff                	test   %edi,%edi
  800b69:	0f 45 c2             	cmovne %edx,%eax
}
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
  800b77:	83 ec 1c             	sub    $0x1c,%esp
  800b7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b80:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b88:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b8b:	8b 75 14             	mov    0x14(%ebp),%esi
  800b8e:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b94:	74 04                	je     800b9a <syscall+0x29>
  800b96:	85 c0                	test   %eax,%eax
  800b98:	7f 08                	jg     800ba2 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	50                   	push   %eax
  800ba6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba9:	68 bf 22 80 00       	push   $0x8022bf
  800bae:	6a 23                	push   $0x23
  800bb0:	68 dc 22 80 00       	push   $0x8022dc
  800bb5:	e8 f2 f5 ff ff       	call   8001ac <_panic>

00800bba <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800bba:	f3 0f 1e fb          	endbr32 
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800bc4:	6a 00                	push   $0x0
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bda:	e8 92 ff ff ff       	call   800b71 <syscall>
}
  800bdf:	83 c4 10             	add    $0x10,%esp
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	f3 0f 1e fb          	endbr32 
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800bee:	6a 00                	push   $0x0
  800bf0:	6a 00                	push   $0x0
  800bf2:	6a 00                	push   $0x0
  800bf4:	6a 00                	push   $0x0
  800bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	b8 01 00 00 00       	mov    $0x1,%eax
  800c05:	e8 67 ff ff ff       	call   800b71 <syscall>
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0c:	f3 0f 1e fb          	endbr32 
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c16:	6a 00                	push   $0x0
  800c18:	6a 00                	push   $0x0
  800c1a:	6a 00                	push   $0x0
  800c1c:	6a 00                	push   $0x0
  800c1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c21:	ba 01 00 00 00       	mov    $0x1,%edx
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	e8 41 ff ff ff       	call   800b71 <syscall>
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c32:	f3 0f 1e fb          	endbr32 
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c3c:	6a 00                	push   $0x0
  800c3e:	6a 00                	push   $0x0
  800c40:	6a 00                	push   $0x0
  800c42:	6a 00                	push   $0x0
  800c44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c53:	e8 19 ff ff ff       	call   800b71 <syscall>
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <sys_yield>:

void
sys_yield(void)
{
  800c5a:	f3 0f 1e fb          	endbr32 
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c64:	6a 00                	push   $0x0
  800c66:	6a 00                	push   $0x0
  800c68:	6a 00                	push   $0x0
  800c6a:	6a 00                	push   $0x0
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	ba 00 00 00 00       	mov    $0x0,%edx
  800c76:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c7b:	e8 f1 fe ff ff       	call   800b71 <syscall>
}
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c85:	f3 0f 1e fb          	endbr32 
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c8f:	6a 00                	push   $0x0
  800c91:	6a 00                	push   $0x0
  800c93:	ff 75 10             	pushl  0x10(%ebp)
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9c:	ba 01 00 00 00       	mov    $0x1,%edx
  800ca1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca6:	e8 c6 fe ff ff       	call   800b71 <syscall>
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800cb7:	ff 75 18             	pushl  0x18(%ebp)
  800cba:	ff 75 14             	pushl  0x14(%ebp)
  800cbd:	ff 75 10             	pushl  0x10(%ebp)
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc6:	ba 01 00 00 00       	mov    $0x1,%edx
  800ccb:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd0:	e8 9c fe ff ff       	call   800b71 <syscall>
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd7:	f3 0f 1e fb          	endbr32 
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ce1:	6a 00                	push   $0x0
  800ce3:	6a 00                	push   $0x0
  800ce5:	6a 00                	push   $0x0
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ced:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf2:	b8 06 00 00 00       	mov    $0x6,%eax
  800cf7:	e8 75 fe ff ff       	call   800b71 <syscall>
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cfe:	f3 0f 1e fb          	endbr32 
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d08:	6a 00                	push   $0x0
  800d0a:	6a 00                	push   $0x0
  800d0c:	6a 00                	push   $0x0
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d14:	ba 01 00 00 00       	mov    $0x1,%edx
  800d19:	b8 08 00 00 00       	mov    $0x8,%eax
  800d1e:	e8 4e fe ff ff       	call   800b71 <syscall>
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d25:	f3 0f 1e fb          	endbr32 
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d2f:	6a 00                	push   $0x0
  800d31:	6a 00                	push   $0x0
  800d33:	6a 00                	push   $0x0
  800d35:	ff 75 0c             	pushl  0xc(%ebp)
  800d38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d3b:	ba 01 00 00 00       	mov    $0x1,%edx
  800d40:	b8 09 00 00 00       	mov    $0x9,%eax
  800d45:	e8 27 fe ff ff       	call   800b71 <syscall>
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d56:	6a 00                	push   $0x0
  800d58:	6a 00                	push   $0x0
  800d5a:	6a 00                	push   $0x0
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d62:	ba 01 00 00 00       	mov    $0x1,%edx
  800d67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6c:	e8 00 fe ff ff       	call   800b71 <syscall>
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d73:	f3 0f 1e fb          	endbr32 
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d7d:	6a 00                	push   $0x0
  800d7f:	ff 75 14             	pushl  0x14(%ebp)
  800d82:	ff 75 10             	pushl  0x10(%ebp)
  800d85:	ff 75 0c             	pushl  0xc(%ebp)
  800d88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d95:	e8 d7 fd ff ff       	call   800b71 <syscall>
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d9c:	f3 0f 1e fb          	endbr32 
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800da6:	6a 00                	push   $0x0
  800da8:	6a 00                	push   $0x0
  800daa:	6a 00                	push   $0x0
  800dac:	6a 00                	push   $0x0
  800dae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db1:	ba 01 00 00 00       	mov    $0x1,%edx
  800db6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dbb:	e8 b1 fd ff ff       	call   800b71 <syscall>
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	05 00 00 00 30       	add    $0x30000000,%eax
  800dd1:	c1 e8 0c             	shr    $0xc,%eax
}
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800de0:	ff 75 08             	pushl  0x8(%ebp)
  800de3:	e8 da ff ff ff       	call   800dc2 <fd2num>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	c1 e0 0c             	shl    $0xc,%eax
  800dee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df5:	f3 0f 1e fb          	endbr32 
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e01:	89 c2                	mov    %eax,%edx
  800e03:	c1 ea 16             	shr    $0x16,%edx
  800e06:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e0d:	f6 c2 01             	test   $0x1,%dl
  800e10:	74 2d                	je     800e3f <fd_alloc+0x4a>
  800e12:	89 c2                	mov    %eax,%edx
  800e14:	c1 ea 0c             	shr    $0xc,%edx
  800e17:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1e:	f6 c2 01             	test   $0x1,%dl
  800e21:	74 1c                	je     800e3f <fd_alloc+0x4a>
  800e23:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e28:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e2d:	75 d2                	jne    800e01 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e38:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e3d:	eb 0a                	jmp    800e49 <fd_alloc+0x54>
			*fd_store = fd;
  800e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e42:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e4b:	f3 0f 1e fb          	endbr32 
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e55:	83 f8 1f             	cmp    $0x1f,%eax
  800e58:	77 30                	ja     800e8a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e5a:	c1 e0 0c             	shl    $0xc,%eax
  800e5d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e62:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e68:	f6 c2 01             	test   $0x1,%dl
  800e6b:	74 24                	je     800e91 <fd_lookup+0x46>
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	c1 ea 0c             	shr    $0xc,%edx
  800e72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e79:	f6 c2 01             	test   $0x1,%dl
  800e7c:	74 1a                	je     800e98 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e81:	89 02                	mov    %eax,(%edx)
	return 0;
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		return -E_INVAL;
  800e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8f:	eb f7                	jmp    800e88 <fd_lookup+0x3d>
		return -E_INVAL;
  800e91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e96:	eb f0                	jmp    800e88 <fd_lookup+0x3d>
  800e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9d:	eb e9                	jmp    800e88 <fd_lookup+0x3d>

00800e9f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 08             	sub    $0x8,%esp
  800ea9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eac:	ba 68 23 80 00       	mov    $0x802368,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eb1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eb6:	39 08                	cmp    %ecx,(%eax)
  800eb8:	74 33                	je     800eed <dev_lookup+0x4e>
  800eba:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ebd:	8b 02                	mov    (%edx),%eax
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 f3                	jne    800eb6 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ec3:	a1 04 40 80 00       	mov    0x804004,%eax
  800ec8:	8b 40 48             	mov    0x48(%eax),%eax
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	51                   	push   %ecx
  800ecf:	50                   	push   %eax
  800ed0:	68 ec 22 80 00       	push   $0x8022ec
  800ed5:	e8 b9 f3 ff ff       	call   800293 <cprintf>
	*dev = 0;
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    
			*dev = devtab[i];
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef7:	eb f2                	jmp    800eeb <dev_lookup+0x4c>

00800ef9 <fd_close>:
{
  800ef9:	f3 0f 1e fb          	endbr32 
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 28             	sub    $0x28,%esp
  800f06:	8b 75 08             	mov    0x8(%ebp),%esi
  800f09:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0c:	56                   	push   %esi
  800f0d:	e8 b0 fe ff ff       	call   800dc2 <fd2num>
  800f12:	83 c4 08             	add    $0x8,%esp
  800f15:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800f18:	52                   	push   %edx
  800f19:	50                   	push   %eax
  800f1a:	e8 2c ff ff ff       	call   800e4b <fd_lookup>
  800f1f:	89 c3                	mov    %eax,%ebx
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	85 c0                	test   %eax,%eax
  800f26:	78 05                	js     800f2d <fd_close+0x34>
	    || fd != fd2)
  800f28:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f2b:	74 16                	je     800f43 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f2d:	89 f8                	mov    %edi,%eax
  800f2f:	84 c0                	test   %al,%al
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	0f 44 d8             	cmove  %eax,%ebx
}
  800f39:	89 d8                	mov    %ebx,%eax
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f49:	50                   	push   %eax
  800f4a:	ff 36                	pushl  (%esi)
  800f4c:	e8 4e ff ff ff       	call   800e9f <dev_lookup>
  800f51:	89 c3                	mov    %eax,%ebx
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	78 1a                	js     800f74 <fd_close+0x7b>
		if (dev->dev_close)
  800f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f5d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f60:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	74 0b                	je     800f74 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	56                   	push   %esi
  800f6d:	ff d0                	call   *%eax
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	56                   	push   %esi
  800f78:	6a 00                	push   $0x0
  800f7a:	e8 58 fd ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	eb b5                	jmp    800f39 <fd_close+0x40>

00800f84 <close>:

int
close(int fdnum)
{
  800f84:	f3 0f 1e fb          	endbr32 
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	ff 75 08             	pushl  0x8(%ebp)
  800f95:	e8 b1 fe ff ff       	call   800e4b <fd_lookup>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	79 02                	jns    800fa3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    
		return fd_close(fd, 1);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	6a 01                	push   $0x1
  800fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  800fab:	e8 49 ff ff ff       	call   800ef9 <fd_close>
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	eb ec                	jmp    800fa1 <close+0x1d>

00800fb5 <close_all>:

void
close_all(void)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	53                   	push   %ebx
  800fc9:	e8 b6 ff ff ff       	call   800f84 <close>
	for (i = 0; i < MAXFD; i++)
  800fce:	83 c3 01             	add    $0x1,%ebx
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	83 fb 20             	cmp    $0x20,%ebx
  800fd7:	75 ec                	jne    800fc5 <close_all+0x10>
}
  800fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fdc:	c9                   	leave  
  800fdd:	c3                   	ret    

00800fde <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fde:	f3 0f 1e fb          	endbr32 
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800feb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 54 fe ff ff       	call   800e4b <fd_lookup>
  800ff7:	89 c3                	mov    %eax,%ebx
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	0f 88 81 00 00 00    	js     801085 <dup+0xa7>
		return r;
	close(newfdnum);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	ff 75 0c             	pushl  0xc(%ebp)
  80100a:	e8 75 ff ff ff       	call   800f84 <close>

	newfd = INDEX2FD(newfdnum);
  80100f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801012:	c1 e6 0c             	shl    $0xc,%esi
  801015:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80101b:	83 c4 04             	add    $0x4,%esp
  80101e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801021:	e8 b0 fd ff ff       	call   800dd6 <fd2data>
  801026:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801028:	89 34 24             	mov    %esi,(%esp)
  80102b:	e8 a6 fd ff ff       	call   800dd6 <fd2data>
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801035:	89 d8                	mov    %ebx,%eax
  801037:	c1 e8 16             	shr    $0x16,%eax
  80103a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801041:	a8 01                	test   $0x1,%al
  801043:	74 11                	je     801056 <dup+0x78>
  801045:	89 d8                	mov    %ebx,%eax
  801047:	c1 e8 0c             	shr    $0xc,%eax
  80104a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801051:	f6 c2 01             	test   $0x1,%dl
  801054:	75 39                	jne    80108f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801056:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
  80105e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801065:	83 ec 0c             	sub    $0xc,%esp
  801068:	25 07 0e 00 00       	and    $0xe07,%eax
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	6a 00                	push   $0x0
  801071:	52                   	push   %edx
  801072:	6a 00                	push   $0x0
  801074:	e8 34 fc ff ff       	call   800cad <sys_page_map>
  801079:	89 c3                	mov    %eax,%ebx
  80107b:	83 c4 20             	add    $0x20,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 31                	js     8010b3 <dup+0xd5>
		goto err;

	return newfdnum;
  801082:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801085:	89 d8                	mov    %ebx,%eax
  801087:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80108f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	25 07 0e 00 00       	and    $0xe07,%eax
  80109e:	50                   	push   %eax
  80109f:	57                   	push   %edi
  8010a0:	6a 00                	push   $0x0
  8010a2:	53                   	push   %ebx
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 03 fc ff ff       	call   800cad <sys_page_map>
  8010aa:	89 c3                	mov    %eax,%ebx
  8010ac:	83 c4 20             	add    $0x20,%esp
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	79 a3                	jns    801056 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	56                   	push   %esi
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 19 fc ff ff       	call   800cd7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010be:	83 c4 08             	add    $0x8,%esp
  8010c1:	57                   	push   %edi
  8010c2:	6a 00                	push   $0x0
  8010c4:	e8 0e fc ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	eb b7                	jmp    801085 <dup+0xa7>

008010ce <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 1c             	sub    $0x1c,%esp
  8010d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	53                   	push   %ebx
  8010e1:	e8 65 fd ff ff       	call   800e4b <fd_lookup>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 3f                	js     80112c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f7:	ff 30                	pushl  (%eax)
  8010f9:	e8 a1 fd ff ff       	call   800e9f <dev_lookup>
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	78 27                	js     80112c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801105:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801108:	8b 42 08             	mov    0x8(%edx),%eax
  80110b:	83 e0 03             	and    $0x3,%eax
  80110e:	83 f8 01             	cmp    $0x1,%eax
  801111:	74 1e                	je     801131 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	8b 40 08             	mov    0x8(%eax),%eax
  801119:	85 c0                	test   %eax,%eax
  80111b:	74 35                	je     801152 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	ff 75 10             	pushl  0x10(%ebp)
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	52                   	push   %edx
  801127:	ff d0                	call   *%eax
  801129:	83 c4 10             	add    $0x10,%esp
}
  80112c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112f:	c9                   	leave  
  801130:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801131:	a1 04 40 80 00       	mov    0x804004,%eax
  801136:	8b 40 48             	mov    0x48(%eax),%eax
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	53                   	push   %ebx
  80113d:	50                   	push   %eax
  80113e:	68 2d 23 80 00       	push   $0x80232d
  801143:	e8 4b f1 ff ff       	call   800293 <cprintf>
		return -E_INVAL;
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801150:	eb da                	jmp    80112c <read+0x5e>
		return -E_NOT_SUPP;
  801152:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801157:	eb d3                	jmp    80112c <read+0x5e>

00801159 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801159:	f3 0f 1e fb          	endbr32 
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	8b 7d 08             	mov    0x8(%ebp),%edi
  801169:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	eb 02                	jmp    801175 <readn+0x1c>
  801173:	01 c3                	add    %eax,%ebx
  801175:	39 f3                	cmp    %esi,%ebx
  801177:	73 21                	jae    80119a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	89 f0                	mov    %esi,%eax
  80117e:	29 d8                	sub    %ebx,%eax
  801180:	50                   	push   %eax
  801181:	89 d8                	mov    %ebx,%eax
  801183:	03 45 0c             	add    0xc(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	57                   	push   %edi
  801188:	e8 41 ff ff ff       	call   8010ce <read>
		if (m < 0)
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 04                	js     801198 <readn+0x3f>
			return m;
		if (m == 0)
  801194:	75 dd                	jne    801173 <readn+0x1a>
  801196:	eb 02                	jmp    80119a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801198:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80119a:	89 d8                	mov    %ebx,%eax
  80119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a4:	f3 0f 1e fb          	endbr32 
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 1c             	sub    $0x1c,%esp
  8011af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b5:	50                   	push   %eax
  8011b6:	53                   	push   %ebx
  8011b7:	e8 8f fc ff ff       	call   800e4b <fd_lookup>
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 3a                	js     8011fd <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c9:	50                   	push   %eax
  8011ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cd:	ff 30                	pushl  (%eax)
  8011cf:	e8 cb fc ff ff       	call   800e9f <dev_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 22                	js     8011fd <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e2:	74 1e                	je     801202 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8011ea:	85 d2                	test   %edx,%edx
  8011ec:	74 35                	je     801223 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	ff 75 10             	pushl  0x10(%ebp)
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	ff d2                	call   *%edx
  8011fa:	83 c4 10             	add    $0x10,%esp
}
  8011fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801200:	c9                   	leave  
  801201:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801202:	a1 04 40 80 00       	mov    0x804004,%eax
  801207:	8b 40 48             	mov    0x48(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	53                   	push   %ebx
  80120e:	50                   	push   %eax
  80120f:	68 49 23 80 00       	push   $0x802349
  801214:	e8 7a f0 ff ff       	call   800293 <cprintf>
		return -E_INVAL;
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801221:	eb da                	jmp    8011fd <write+0x59>
		return -E_NOT_SUPP;
  801223:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801228:	eb d3                	jmp    8011fd <write+0x59>

0080122a <seek>:

int
seek(int fdnum, off_t offset)
{
  80122a:	f3 0f 1e fb          	endbr32 
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	ff 75 08             	pushl  0x8(%ebp)
  80123b:	e8 0b fc ff ff       	call   800e4b <fd_lookup>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	78 0e                	js     801255 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801257:	f3 0f 1e fb          	endbr32 
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 1c             	sub    $0x1c,%esp
  801262:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801265:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	53                   	push   %ebx
  80126a:	e8 dc fb ff ff       	call   800e4b <fd_lookup>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 37                	js     8012ad <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801280:	ff 30                	pushl  (%eax)
  801282:	e8 18 fc ff ff       	call   800e9f <dev_lookup>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 1f                	js     8012ad <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801291:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801295:	74 1b                	je     8012b2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	8b 52 18             	mov    0x18(%edx),%edx
  80129d:	85 d2                	test   %edx,%edx
  80129f:	74 32                	je     8012d3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	ff d2                	call   *%edx
  8012aa:	83 c4 10             	add    $0x10,%esp
}
  8012ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	53                   	push   %ebx
  8012be:	50                   	push   %eax
  8012bf:	68 0c 23 80 00       	push   $0x80230c
  8012c4:	e8 ca ef ff ff       	call   800293 <cprintf>
		return -E_INVAL;
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb da                	jmp    8012ad <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d8:	eb d3                	jmp    8012ad <ftruncate+0x56>

008012da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012da:	f3 0f 1e fb          	endbr32 
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 1c             	sub    $0x1c,%esp
  8012e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 57 fb ff ff       	call   800e4b <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 4b                	js     801346 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801301:	50                   	push   %eax
  801302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801305:	ff 30                	pushl  (%eax)
  801307:	e8 93 fb ff ff       	call   800e9f <dev_lookup>
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	78 33                	js     801346 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801316:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80131a:	74 2f                	je     80134b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80131c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80131f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801326:	00 00 00 
	stat->st_isdir = 0;
  801329:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801330:	00 00 00 
	stat->st_dev = dev;
  801333:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	53                   	push   %ebx
  80133d:	ff 75 f0             	pushl  -0x10(%ebp)
  801340:	ff 50 14             	call   *0x14(%eax)
  801343:	83 c4 10             	add    $0x10,%esp
}
  801346:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801349:	c9                   	leave  
  80134a:	c3                   	ret    
		return -E_NOT_SUPP;
  80134b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801350:	eb f4                	jmp    801346 <fstat+0x6c>

00801352 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801352:	f3 0f 1e fb          	endbr32 
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	56                   	push   %esi
  80135a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	6a 00                	push   $0x0
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 3a 02 00 00       	call   8015a2 <open>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 1b                	js     80138c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	ff 75 0c             	pushl  0xc(%ebp)
  801377:	50                   	push   %eax
  801378:	e8 5d ff ff ff       	call   8012da <fstat>
  80137d:	89 c6                	mov    %eax,%esi
	close(fd);
  80137f:	89 1c 24             	mov    %ebx,(%esp)
  801382:	e8 fd fb ff ff       	call   800f84 <close>
	return r;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	89 f3                	mov    %esi,%ebx
}
  80138c:	89 d8                	mov    %ebx,%eax
  80138e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801391:	5b                   	pop    %ebx
  801392:	5e                   	pop    %esi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
  80139a:	89 c6                	mov    %eax,%esi
  80139c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80139e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013a5:	74 27                	je     8013ce <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013a7:	6a 07                	push   $0x7
  8013a9:	68 00 50 80 00       	push   $0x805000
  8013ae:	56                   	push   %esi
  8013af:	ff 35 00 40 80 00    	pushl  0x804000
  8013b5:	e8 fd 07 00 00       	call   801bb7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013ba:	83 c4 0c             	add    $0xc,%esp
  8013bd:	6a 00                	push   $0x0
  8013bf:	53                   	push   %ebx
  8013c0:	6a 00                	push   $0x0
  8013c2:	e8 83 07 00 00       	call   801b4a <ipc_recv>
}
  8013c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ca:	5b                   	pop    %ebx
  8013cb:	5e                   	pop    %esi
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	6a 01                	push   $0x1
  8013d3:	e8 37 08 00 00       	call   801c0f <ipc_find_env>
  8013d8:	a3 00 40 80 00       	mov    %eax,0x804000
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	eb c5                	jmp    8013a7 <fsipc+0x12>

008013e2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013e2:	f3 0f 1e fb          	endbr32 
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801404:	b8 02 00 00 00       	mov    $0x2,%eax
  801409:	e8 87 ff ff ff       	call   801395 <fsipc>
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <devfile_flush>:
{
  801410:	f3 0f 1e fb          	endbr32 
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8b 40 0c             	mov    0xc(%eax),%eax
  801420:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	b8 06 00 00 00       	mov    $0x6,%eax
  80142f:	e8 61 ff ff ff       	call   801395 <fsipc>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <devfile_stat>:
{
  801436:	f3 0f 1e fb          	endbr32 
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 40 0c             	mov    0xc(%eax),%eax
  80144a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 05 00 00 00       	mov    $0x5,%eax
  801459:	e8 37 ff ff ff       	call   801395 <fsipc>
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 2c                	js     80148e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	68 00 50 80 00       	push   $0x805000
  80146a:	53                   	push   %ebx
  80146b:	e8 8d f3 ff ff       	call   8007fd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801470:	a1 80 50 80 00       	mov    0x805080,%eax
  801475:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80147b:	a1 84 50 80 00       	mov    0x805084,%eax
  801480:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <devfile_write>:
{
  801493:	f3 0f 1e fb          	endbr32 
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014ac:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014b2:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014b8:	77 30                	ja     8014ea <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	53                   	push   %ebx
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	68 08 50 80 00       	push   $0x805008
  8014c6:	e8 ea f4 ff ff       	call   8009b5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d0:	b8 04 00 00 00       	mov    $0x4,%eax
  8014d5:	e8 bb fe ff ff       	call   801395 <fsipc>
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 04                	js     8014e5 <devfile_write+0x52>
	assert(r <= n);
  8014e1:	39 d8                	cmp    %ebx,%eax
  8014e3:	77 1e                	ja     801503 <devfile_write+0x70>
}
  8014e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014ea:	68 78 23 80 00       	push   $0x802378
  8014ef:	68 a5 23 80 00       	push   $0x8023a5
  8014f4:	68 94 00 00 00       	push   $0x94
  8014f9:	68 ba 23 80 00       	push   $0x8023ba
  8014fe:	e8 a9 ec ff ff       	call   8001ac <_panic>
	assert(r <= n);
  801503:	68 c5 23 80 00       	push   $0x8023c5
  801508:	68 a5 23 80 00       	push   $0x8023a5
  80150d:	68 98 00 00 00       	push   $0x98
  801512:	68 ba 23 80 00       	push   $0x8023ba
  801517:	e8 90 ec ff ff       	call   8001ac <_panic>

0080151c <devfile_read>:
{
  80151c:	f3 0f 1e fb          	endbr32 
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8b 40 0c             	mov    0xc(%eax),%eax
  80152e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801533:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801539:	ba 00 00 00 00       	mov    $0x0,%edx
  80153e:	b8 03 00 00 00       	mov    $0x3,%eax
  801543:	e8 4d fe ff ff       	call   801395 <fsipc>
  801548:	89 c3                	mov    %eax,%ebx
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 1f                	js     80156d <devfile_read+0x51>
	assert(r <= n);
  80154e:	39 f0                	cmp    %esi,%eax
  801550:	77 24                	ja     801576 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801552:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801557:	7f 33                	jg     80158c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	50                   	push   %eax
  80155d:	68 00 50 80 00       	push   $0x805000
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	e8 4b f4 ff ff       	call   8009b5 <memmove>
	return r;
  80156a:	83 c4 10             	add    $0x10,%esp
}
  80156d:	89 d8                	mov    %ebx,%eax
  80156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
	assert(r <= n);
  801576:	68 c5 23 80 00       	push   $0x8023c5
  80157b:	68 a5 23 80 00       	push   $0x8023a5
  801580:	6a 7c                	push   $0x7c
  801582:	68 ba 23 80 00       	push   $0x8023ba
  801587:	e8 20 ec ff ff       	call   8001ac <_panic>
	assert(r <= PGSIZE);
  80158c:	68 cc 23 80 00       	push   $0x8023cc
  801591:	68 a5 23 80 00       	push   $0x8023a5
  801596:	6a 7d                	push   $0x7d
  801598:	68 ba 23 80 00       	push   $0x8023ba
  80159d:	e8 0a ec ff ff       	call   8001ac <_panic>

008015a2 <open>:
{
  8015a2:	f3 0f 1e fb          	endbr32 
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	83 ec 1c             	sub    $0x1c,%esp
  8015ae:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015b1:	56                   	push   %esi
  8015b2:	e8 03 f2 ff ff       	call   8007ba <strlen>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015bf:	7f 6c                	jg     80162d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	e8 28 f8 ff ff       	call   800df5 <fd_alloc>
  8015cd:	89 c3                	mov    %eax,%ebx
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 3c                	js     801612 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	56                   	push   %esi
  8015da:	68 00 50 80 00       	push   $0x805000
  8015df:	e8 19 f2 ff ff       	call   8007fd <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f4:	e8 9c fd ff ff       	call   801395 <fsipc>
  8015f9:	89 c3                	mov    %eax,%ebx
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 19                	js     80161b <open+0x79>
	return fd2num(fd);
  801602:	83 ec 0c             	sub    $0xc,%esp
  801605:	ff 75 f4             	pushl  -0xc(%ebp)
  801608:	e8 b5 f7 ff ff       	call   800dc2 <fd2num>
  80160d:	89 c3                	mov    %eax,%ebx
  80160f:	83 c4 10             	add    $0x10,%esp
}
  801612:	89 d8                	mov    %ebx,%eax
  801614:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    
		fd_close(fd, 0);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	6a 00                	push   $0x0
  801620:	ff 75 f4             	pushl  -0xc(%ebp)
  801623:	e8 d1 f8 ff ff       	call   800ef9 <fd_close>
		return r;
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	eb e5                	jmp    801612 <open+0x70>
		return -E_BAD_PATH;
  80162d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801632:	eb de                	jmp    801612 <open+0x70>

00801634 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801634:	f3 0f 1e fb          	endbr32 
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 08 00 00 00       	mov    $0x8,%eax
  801648:	e8 48 fd ff ff       	call   801395 <fsipc>
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80164f:	f3 0f 1e fb          	endbr32 
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	e8 70 f7 ff ff       	call   800dd6 <fd2data>
  801666:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	68 d8 23 80 00       	push   $0x8023d8
  801670:	53                   	push   %ebx
  801671:	e8 87 f1 ff ff       	call   8007fd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801676:	8b 46 04             	mov    0x4(%esi),%eax
  801679:	2b 06                	sub    (%esi),%eax
  80167b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801681:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801688:	00 00 00 
	stat->st_dev = &devpipe;
  80168b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801692:	30 80 00 
	return 0;
}
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
  80169a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    

008016a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016a1:	f3 0f 1e fb          	endbr32 
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016af:	53                   	push   %ebx
  8016b0:	6a 00                	push   $0x0
  8016b2:	e8 20 f6 ff ff       	call   800cd7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016b7:	89 1c 24             	mov    %ebx,(%esp)
  8016ba:	e8 17 f7 ff ff       	call   800dd6 <fd2data>
  8016bf:	83 c4 08             	add    $0x8,%esp
  8016c2:	50                   	push   %eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	e8 0d f6 ff ff       	call   800cd7 <sys_page_unmap>
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <_pipeisclosed>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	57                   	push   %edi
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 1c             	sub    $0x1c,%esp
  8016d8:	89 c7                	mov    %eax,%edi
  8016da:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8016e1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	57                   	push   %edi
  8016e8:	e8 5f 05 00 00       	call   801c4c <pageref>
  8016ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016f0:	89 34 24             	mov    %esi,(%esp)
  8016f3:	e8 54 05 00 00       	call   801c4c <pageref>
		nn = thisenv->env_runs;
  8016f8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016fe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	39 cb                	cmp    %ecx,%ebx
  801706:	74 1b                	je     801723 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801708:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80170b:	75 cf                	jne    8016dc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80170d:	8b 42 58             	mov    0x58(%edx),%eax
  801710:	6a 01                	push   $0x1
  801712:	50                   	push   %eax
  801713:	53                   	push   %ebx
  801714:	68 df 23 80 00       	push   $0x8023df
  801719:	e8 75 eb ff ff       	call   800293 <cprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	eb b9                	jmp    8016dc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801723:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801726:	0f 94 c0             	sete   %al
  801729:	0f b6 c0             	movzbl %al,%eax
}
  80172c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5f                   	pop    %edi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <devpipe_write>:
{
  801734:	f3 0f 1e fb          	endbr32 
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	57                   	push   %edi
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	83 ec 28             	sub    $0x28,%esp
  801741:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801744:	56                   	push   %esi
  801745:	e8 8c f6 ff ff       	call   800dd6 <fd2data>
  80174a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	bf 00 00 00 00       	mov    $0x0,%edi
  801754:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801757:	74 4f                	je     8017a8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801759:	8b 43 04             	mov    0x4(%ebx),%eax
  80175c:	8b 0b                	mov    (%ebx),%ecx
  80175e:	8d 51 20             	lea    0x20(%ecx),%edx
  801761:	39 d0                	cmp    %edx,%eax
  801763:	72 14                	jb     801779 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801765:	89 da                	mov    %ebx,%edx
  801767:	89 f0                	mov    %esi,%eax
  801769:	e8 61 ff ff ff       	call   8016cf <_pipeisclosed>
  80176e:	85 c0                	test   %eax,%eax
  801770:	75 3b                	jne    8017ad <devpipe_write+0x79>
			sys_yield();
  801772:	e8 e3 f4 ff ff       	call   800c5a <sys_yield>
  801777:	eb e0                	jmp    801759 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801779:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80177c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801780:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801783:	89 c2                	mov    %eax,%edx
  801785:	c1 fa 1f             	sar    $0x1f,%edx
  801788:	89 d1                	mov    %edx,%ecx
  80178a:	c1 e9 1b             	shr    $0x1b,%ecx
  80178d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801790:	83 e2 1f             	and    $0x1f,%edx
  801793:	29 ca                	sub    %ecx,%edx
  801795:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801799:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80179d:	83 c0 01             	add    $0x1,%eax
  8017a0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017a3:	83 c7 01             	add    $0x1,%edi
  8017a6:	eb ac                	jmp    801754 <devpipe_write+0x20>
	return i;
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	eb 05                	jmp    8017b2 <devpipe_write+0x7e>
				return 0;
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5f                   	pop    %edi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <devpipe_read>:
{
  8017ba:	f3 0f 1e fb          	endbr32 
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	57                   	push   %edi
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 18             	sub    $0x18,%esp
  8017c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017ca:	57                   	push   %edi
  8017cb:	e8 06 f6 ff ff       	call   800dd6 <fd2data>
  8017d0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	be 00 00 00 00       	mov    $0x0,%esi
  8017da:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017dd:	75 14                	jne    8017f3 <devpipe_read+0x39>
	return i;
  8017df:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e2:	eb 02                	jmp    8017e6 <devpipe_read+0x2c>
				return i;
  8017e4:	89 f0                	mov    %esi,%eax
}
  8017e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
			sys_yield();
  8017ee:	e8 67 f4 ff ff       	call   800c5a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8017f3:	8b 03                	mov    (%ebx),%eax
  8017f5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017f8:	75 18                	jne    801812 <devpipe_read+0x58>
			if (i > 0)
  8017fa:	85 f6                	test   %esi,%esi
  8017fc:	75 e6                	jne    8017e4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8017fe:	89 da                	mov    %ebx,%edx
  801800:	89 f8                	mov    %edi,%eax
  801802:	e8 c8 fe ff ff       	call   8016cf <_pipeisclosed>
  801807:	85 c0                	test   %eax,%eax
  801809:	74 e3                	je     8017ee <devpipe_read+0x34>
				return 0;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	eb d4                	jmp    8017e6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801812:	99                   	cltd   
  801813:	c1 ea 1b             	shr    $0x1b,%edx
  801816:	01 d0                	add    %edx,%eax
  801818:	83 e0 1f             	and    $0x1f,%eax
  80181b:	29 d0                	sub    %edx,%eax
  80181d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801822:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801825:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801828:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80182b:	83 c6 01             	add    $0x1,%esi
  80182e:	eb aa                	jmp    8017da <devpipe_read+0x20>

00801830 <pipe>:
{
  801830:	f3 0f 1e fb          	endbr32 
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80183c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183f:	50                   	push   %eax
  801840:	e8 b0 f5 ff ff       	call   800df5 <fd_alloc>
  801845:	89 c3                	mov    %eax,%ebx
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	0f 88 23 01 00 00    	js     801975 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	68 07 04 00 00       	push   $0x407
  80185a:	ff 75 f4             	pushl  -0xc(%ebp)
  80185d:	6a 00                	push   $0x0
  80185f:	e8 21 f4 ff ff       	call   800c85 <sys_page_alloc>
  801864:	89 c3                	mov    %eax,%ebx
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	0f 88 04 01 00 00    	js     801975 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801877:	50                   	push   %eax
  801878:	e8 78 f5 ff ff       	call   800df5 <fd_alloc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	0f 88 db 00 00 00    	js     801965 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 07 04 00 00       	push   $0x407
  801892:	ff 75 f0             	pushl  -0x10(%ebp)
  801895:	6a 00                	push   $0x0
  801897:	e8 e9 f3 ff ff       	call   800c85 <sys_page_alloc>
  80189c:	89 c3                	mov    %eax,%ebx
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	0f 88 bc 00 00 00    	js     801965 <pipe+0x135>
	va = fd2data(fd0);
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8018af:	e8 22 f5 ff ff       	call   800dd6 <fd2data>
  8018b4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b6:	83 c4 0c             	add    $0xc,%esp
  8018b9:	68 07 04 00 00       	push   $0x407
  8018be:	50                   	push   %eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	e8 bf f3 ff ff       	call   800c85 <sys_page_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	0f 88 82 00 00 00    	js     801955 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d9:	e8 f8 f4 ff ff       	call   800dd6 <fd2data>
  8018de:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018e5:	50                   	push   %eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	56                   	push   %esi
  8018e9:	6a 00                	push   $0x0
  8018eb:	e8 bd f3 ff ff       	call   800cad <sys_page_map>
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	83 c4 20             	add    $0x20,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 4e                	js     801947 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8018f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8018fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801901:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801906:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80190d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801910:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801915:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	ff 75 f4             	pushl  -0xc(%ebp)
  801922:	e8 9b f4 ff ff       	call   800dc2 <fd2num>
  801927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80192c:	83 c4 04             	add    $0x4,%esp
  80192f:	ff 75 f0             	pushl  -0x10(%ebp)
  801932:	e8 8b f4 ff ff       	call   800dc2 <fd2num>
  801937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	bb 00 00 00 00       	mov    $0x0,%ebx
  801945:	eb 2e                	jmp    801975 <pipe+0x145>
	sys_page_unmap(0, va);
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	56                   	push   %esi
  80194b:	6a 00                	push   $0x0
  80194d:	e8 85 f3 ff ff       	call   800cd7 <sys_page_unmap>
  801952:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	ff 75 f0             	pushl  -0x10(%ebp)
  80195b:	6a 00                	push   $0x0
  80195d:	e8 75 f3 ff ff       	call   800cd7 <sys_page_unmap>
  801962:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	ff 75 f4             	pushl  -0xc(%ebp)
  80196b:	6a 00                	push   $0x0
  80196d:	e8 65 f3 ff ff       	call   800cd7 <sys_page_unmap>
  801972:	83 c4 10             	add    $0x10,%esp
}
  801975:	89 d8                	mov    %ebx,%eax
  801977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <pipeisclosed>:
{
  80197e:	f3 0f 1e fb          	endbr32 
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801988:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198b:	50                   	push   %eax
  80198c:	ff 75 08             	pushl  0x8(%ebp)
  80198f:	e8 b7 f4 ff ff       	call   800e4b <fd_lookup>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 18                	js     8019b3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a1:	e8 30 f4 ff ff       	call   800dd6 <fd2data>
  8019a6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ab:	e8 1f fd ff ff       	call   8016cf <_pipeisclosed>
  8019b0:	83 c4 10             	add    $0x10,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019b5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	c3                   	ret    

008019bf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019bf:	f3 0f 1e fb          	endbr32 
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019c9:	68 f7 23 80 00       	push   $0x8023f7
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	e8 27 ee ff ff       	call   8007fd <strcpy>
	return 0;
}
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <devcons_write>:
{
  8019dd:	f3 0f 1e fb          	endbr32 
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	57                   	push   %edi
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019fb:	73 31                	jae    801a2e <devcons_write+0x51>
		m = n - tot;
  8019fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a00:	29 f3                	sub    %esi,%ebx
  801a02:	83 fb 7f             	cmp    $0x7f,%ebx
  801a05:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a0a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	53                   	push   %ebx
  801a11:	89 f0                	mov    %esi,%eax
  801a13:	03 45 0c             	add    0xc(%ebp),%eax
  801a16:	50                   	push   %eax
  801a17:	57                   	push   %edi
  801a18:	e8 98 ef ff ff       	call   8009b5 <memmove>
		sys_cputs(buf, m);
  801a1d:	83 c4 08             	add    $0x8,%esp
  801a20:	53                   	push   %ebx
  801a21:	57                   	push   %edi
  801a22:	e8 93 f1 ff ff       	call   800bba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a27:	01 de                	add    %ebx,%esi
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	eb ca                	jmp    8019f8 <devcons_write+0x1b>
}
  801a2e:	89 f0                	mov    %esi,%eax
  801a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    

00801a38 <devcons_read>:
{
  801a38:	f3 0f 1e fb          	endbr32 
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a4b:	74 21                	je     801a6e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a4d:	e8 92 f1 ff ff       	call   800be4 <sys_cgetc>
  801a52:	85 c0                	test   %eax,%eax
  801a54:	75 07                	jne    801a5d <devcons_read+0x25>
		sys_yield();
  801a56:	e8 ff f1 ff ff       	call   800c5a <sys_yield>
  801a5b:	eb f0                	jmp    801a4d <devcons_read+0x15>
	if (c < 0)
  801a5d:	78 0f                	js     801a6e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a5f:	83 f8 04             	cmp    $0x4,%eax
  801a62:	74 0c                	je     801a70 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	88 02                	mov    %al,(%edx)
	return 1;
  801a69:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    
		return 0;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	eb f7                	jmp    801a6e <devcons_read+0x36>

00801a77 <cputchar>:
{
  801a77:	f3 0f 1e fb          	endbr32 
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a87:	6a 01                	push   $0x1
  801a89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a8c:	50                   	push   %eax
  801a8d:	e8 28 f1 ff ff       	call   800bba <sys_cputs>
}
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <getchar>:
{
  801a97:	f3 0f 1e fb          	endbr32 
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801aa1:	6a 01                	push   $0x1
  801aa3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aa6:	50                   	push   %eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	e8 20 f6 ff ff       	call   8010ce <read>
	if (r < 0)
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 06                	js     801abb <getchar+0x24>
	if (r < 1)
  801ab5:	74 06                	je     801abd <getchar+0x26>
	return c;
  801ab7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    
		return -E_EOF;
  801abd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ac2:	eb f7                	jmp    801abb <getchar+0x24>

00801ac4 <iscons>:
{
  801ac4:	f3 0f 1e fb          	endbr32 
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ace:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad1:	50                   	push   %eax
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	e8 71 f3 ff ff       	call   800e4b <fd_lookup>
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 11                	js     801af2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aea:	39 10                	cmp    %edx,(%eax)
  801aec:	0f 94 c0             	sete   %al
  801aef:	0f b6 c0             	movzbl %al,%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <opencons>:
{
  801af4:	f3 0f 1e fb          	endbr32 
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801afe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b01:	50                   	push   %eax
  801b02:	e8 ee f2 ff ff       	call   800df5 <fd_alloc>
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 3a                	js     801b48 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	68 07 04 00 00       	push   $0x407
  801b16:	ff 75 f4             	pushl  -0xc(%ebp)
  801b19:	6a 00                	push   $0x0
  801b1b:	e8 65 f1 ff ff       	call   800c85 <sys_page_alloc>
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 21                	js     801b48 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b30:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	50                   	push   %eax
  801b40:	e8 7d f2 ff ff       	call   800dc2 <fd2num>
  801b45:	83 c4 10             	add    $0x10,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	56                   	push   %esi
  801b52:	53                   	push   %ebx
  801b53:	8b 75 08             	mov    0x8(%ebp),%esi
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b63:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	50                   	push   %eax
  801b6a:	e8 2d f2 ff ff       	call   800d9c <sys_ipc_recv>
	if (r < 0) {
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 2b                	js     801ba1 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b76:	85 f6                	test   %esi,%esi
  801b78:	74 0a                	je     801b84 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b7a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b7f:	8b 40 74             	mov    0x74(%eax),%eax
  801b82:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801b84:	85 db                	test   %ebx,%ebx
  801b86:	74 0a                	je     801b92 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801b88:	a1 04 40 80 00       	mov    0x804004,%eax
  801b8d:	8b 40 78             	mov    0x78(%eax),%eax
  801b90:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801b92:	a1 04 40 80 00       	mov    0x804004,%eax
  801b97:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
		if (from_env_store) {
  801ba1:	85 f6                	test   %esi,%esi
  801ba3:	74 06                	je     801bab <ipc_recv+0x61>
			*from_env_store = 0;
  801ba5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801bab:	85 db                	test   %ebx,%ebx
  801bad:	74 eb                	je     801b9a <ipc_recv+0x50>
			*perm_store = 0;
  801baf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bb5:	eb e3                	jmp    801b9a <ipc_recv+0x50>

00801bb7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb7:	f3 0f 1e fb          	endbr32 
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	57                   	push   %edi
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bc7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801bcd:	85 db                	test   %ebx,%ebx
  801bcf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bd4:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801bd7:	ff 75 14             	pushl  0x14(%ebp)
  801bda:	53                   	push   %ebx
  801bdb:	56                   	push   %esi
  801bdc:	57                   	push   %edi
  801bdd:	e8 91 f1 ff ff       	call   800d73 <sys_ipc_try_send>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801be8:	75 07                	jne    801bf1 <ipc_send+0x3a>
		sys_yield();
  801bea:	e8 6b f0 ff ff       	call   800c5a <sys_yield>
  801bef:	eb e6                	jmp    801bd7 <ipc_send+0x20>
	}

	if (ret < 0) {
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 08                	js     801bfd <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801bfd:	50                   	push   %eax
  801bfe:	68 03 24 80 00       	push   $0x802403
  801c03:	6a 48                	push   $0x48
  801c05:	68 20 24 80 00       	push   $0x802420
  801c0a:	e8 9d e5 ff ff       	call   8001ac <_panic>

00801c0f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c0f:	f3 0f 1e fb          	endbr32 
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c1e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c21:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c27:	8b 52 50             	mov    0x50(%edx),%edx
  801c2a:	39 ca                	cmp    %ecx,%edx
  801c2c:	74 11                	je     801c3f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c2e:	83 c0 01             	add    $0x1,%eax
  801c31:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c36:	75 e6                	jne    801c1e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3d:	eb 0b                	jmp    801c4a <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c3f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c42:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c47:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c4c:	f3 0f 1e fb          	endbr32 
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c56:	89 c2                	mov    %eax,%edx
  801c58:	c1 ea 16             	shr    $0x16,%edx
  801c5b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c67:	f6 c1 01             	test   $0x1,%cl
  801c6a:	74 1c                	je     801c88 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c6c:	c1 e8 0c             	shr    $0xc,%eax
  801c6f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c76:	a8 01                	test   $0x1,%al
  801c78:	74 0e                	je     801c88 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c7a:	c1 e8 0c             	shr    $0xc,%eax
  801c7d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c84:	ef 
  801c85:	0f b7 d2             	movzwl %dx,%edx
}
  801c88:	89 d0                	mov    %edx,%eax
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
  801c8c:	66 90                	xchg   %ax,%ax
  801c8e:	66 90                	xchg   %ax,%ax

00801c90 <__udivdi3>:
  801c90:	f3 0f 1e fb          	endbr32 
  801c94:	55                   	push   %ebp
  801c95:	57                   	push   %edi
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 1c             	sub    $0x1c,%esp
  801c9b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c9f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cab:	85 d2                	test   %edx,%edx
  801cad:	75 19                	jne    801cc8 <__udivdi3+0x38>
  801caf:	39 f3                	cmp    %esi,%ebx
  801cb1:	76 4d                	jbe    801d00 <__udivdi3+0x70>
  801cb3:	31 ff                	xor    %edi,%edi
  801cb5:	89 e8                	mov    %ebp,%eax
  801cb7:	89 f2                	mov    %esi,%edx
  801cb9:	f7 f3                	div    %ebx
  801cbb:	89 fa                	mov    %edi,%edx
  801cbd:	83 c4 1c             	add    $0x1c,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    
  801cc5:	8d 76 00             	lea    0x0(%esi),%esi
  801cc8:	39 f2                	cmp    %esi,%edx
  801cca:	76 14                	jbe    801ce0 <__udivdi3+0x50>
  801ccc:	31 ff                	xor    %edi,%edi
  801cce:	31 c0                	xor    %eax,%eax
  801cd0:	89 fa                	mov    %edi,%edx
  801cd2:	83 c4 1c             	add    $0x1c,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
  801cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ce0:	0f bd fa             	bsr    %edx,%edi
  801ce3:	83 f7 1f             	xor    $0x1f,%edi
  801ce6:	75 48                	jne    801d30 <__udivdi3+0xa0>
  801ce8:	39 f2                	cmp    %esi,%edx
  801cea:	72 06                	jb     801cf2 <__udivdi3+0x62>
  801cec:	31 c0                	xor    %eax,%eax
  801cee:	39 eb                	cmp    %ebp,%ebx
  801cf0:	77 de                	ja     801cd0 <__udivdi3+0x40>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	eb d7                	jmp    801cd0 <__udivdi3+0x40>
  801cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d00:	89 d9                	mov    %ebx,%ecx
  801d02:	85 db                	test   %ebx,%ebx
  801d04:	75 0b                	jne    801d11 <__udivdi3+0x81>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	31 d2                	xor    %edx,%edx
  801d0d:	f7 f3                	div    %ebx
  801d0f:	89 c1                	mov    %eax,%ecx
  801d11:	31 d2                	xor    %edx,%edx
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	f7 f1                	div    %ecx
  801d17:	89 c6                	mov    %eax,%esi
  801d19:	89 e8                	mov    %ebp,%eax
  801d1b:	89 f7                	mov    %esi,%edi
  801d1d:	f7 f1                	div    %ecx
  801d1f:	89 fa                	mov    %edi,%edx
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	89 f9                	mov    %edi,%ecx
  801d32:	b8 20 00 00 00       	mov    $0x20,%eax
  801d37:	29 f8                	sub    %edi,%eax
  801d39:	d3 e2                	shl    %cl,%edx
  801d3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d3f:	89 c1                	mov    %eax,%ecx
  801d41:	89 da                	mov    %ebx,%edx
  801d43:	d3 ea                	shr    %cl,%edx
  801d45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d49:	09 d1                	or     %edx,%ecx
  801d4b:	89 f2                	mov    %esi,%edx
  801d4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d51:	89 f9                	mov    %edi,%ecx
  801d53:	d3 e3                	shl    %cl,%ebx
  801d55:	89 c1                	mov    %eax,%ecx
  801d57:	d3 ea                	shr    %cl,%edx
  801d59:	89 f9                	mov    %edi,%ecx
  801d5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d5f:	89 eb                	mov    %ebp,%ebx
  801d61:	d3 e6                	shl    %cl,%esi
  801d63:	89 c1                	mov    %eax,%ecx
  801d65:	d3 eb                	shr    %cl,%ebx
  801d67:	09 de                	or     %ebx,%esi
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	f7 74 24 08          	divl   0x8(%esp)
  801d6f:	89 d6                	mov    %edx,%esi
  801d71:	89 c3                	mov    %eax,%ebx
  801d73:	f7 64 24 0c          	mull   0xc(%esp)
  801d77:	39 d6                	cmp    %edx,%esi
  801d79:	72 15                	jb     801d90 <__udivdi3+0x100>
  801d7b:	89 f9                	mov    %edi,%ecx
  801d7d:	d3 e5                	shl    %cl,%ebp
  801d7f:	39 c5                	cmp    %eax,%ebp
  801d81:	73 04                	jae    801d87 <__udivdi3+0xf7>
  801d83:	39 d6                	cmp    %edx,%esi
  801d85:	74 09                	je     801d90 <__udivdi3+0x100>
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	31 ff                	xor    %edi,%edi
  801d8b:	e9 40 ff ff ff       	jmp    801cd0 <__udivdi3+0x40>
  801d90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d93:	31 ff                	xor    %edi,%edi
  801d95:	e9 36 ff ff ff       	jmp    801cd0 <__udivdi3+0x40>
  801d9a:	66 90                	xchg   %ax,%ax
  801d9c:	66 90                	xchg   %ax,%ax
  801d9e:	66 90                	xchg   %ax,%ax

00801da0 <__umoddi3>:
  801da0:	f3 0f 1e fb          	endbr32 
  801da4:	55                   	push   %ebp
  801da5:	57                   	push   %edi
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	83 ec 1c             	sub    $0x1c,%esp
  801dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801daf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801db3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801db7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	75 19                	jne    801dd8 <__umoddi3+0x38>
  801dbf:	39 df                	cmp    %ebx,%edi
  801dc1:	76 5d                	jbe    801e20 <__umoddi3+0x80>
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	f7 f7                	div    %edi
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	89 f2                	mov    %esi,%edx
  801dda:	39 d8                	cmp    %ebx,%eax
  801ddc:	76 12                	jbe    801df0 <__umoddi3+0x50>
  801dde:	89 f0                	mov    %esi,%eax
  801de0:	89 da                	mov    %ebx,%edx
  801de2:	83 c4 1c             	add    $0x1c,%esp
  801de5:	5b                   	pop    %ebx
  801de6:	5e                   	pop    %esi
  801de7:	5f                   	pop    %edi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    
  801dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801df0:	0f bd e8             	bsr    %eax,%ebp
  801df3:	83 f5 1f             	xor    $0x1f,%ebp
  801df6:	75 50                	jne    801e48 <__umoddi3+0xa8>
  801df8:	39 d8                	cmp    %ebx,%eax
  801dfa:	0f 82 e0 00 00 00    	jb     801ee0 <__umoddi3+0x140>
  801e00:	89 d9                	mov    %ebx,%ecx
  801e02:	39 f7                	cmp    %esi,%edi
  801e04:	0f 86 d6 00 00 00    	jbe    801ee0 <__umoddi3+0x140>
  801e0a:	89 d0                	mov    %edx,%eax
  801e0c:	89 ca                	mov    %ecx,%edx
  801e0e:	83 c4 1c             	add    $0x1c,%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5f                   	pop    %edi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
  801e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e1d:	8d 76 00             	lea    0x0(%esi),%esi
  801e20:	89 fd                	mov    %edi,%ebp
  801e22:	85 ff                	test   %edi,%edi
  801e24:	75 0b                	jne    801e31 <__umoddi3+0x91>
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f7                	div    %edi
  801e2f:	89 c5                	mov    %eax,%ebp
  801e31:	89 d8                	mov    %ebx,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f5                	div    %ebp
  801e37:	89 f0                	mov    %esi,%eax
  801e39:	f7 f5                	div    %ebp
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	31 d2                	xor    %edx,%edx
  801e3f:	eb 8c                	jmp    801dcd <__umoddi3+0x2d>
  801e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e48:	89 e9                	mov    %ebp,%ecx
  801e4a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e4f:	29 ea                	sub    %ebp,%edx
  801e51:	d3 e0                	shl    %cl,%eax
  801e53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e57:	89 d1                	mov    %edx,%ecx
  801e59:	89 f8                	mov    %edi,%eax
  801e5b:	d3 e8                	shr    %cl,%eax
  801e5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e65:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e69:	09 c1                	or     %eax,%ecx
  801e6b:	89 d8                	mov    %ebx,%eax
  801e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e71:	89 e9                	mov    %ebp,%ecx
  801e73:	d3 e7                	shl    %cl,%edi
  801e75:	89 d1                	mov    %edx,%ecx
  801e77:	d3 e8                	shr    %cl,%eax
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e7f:	d3 e3                	shl    %cl,%ebx
  801e81:	89 c7                	mov    %eax,%edi
  801e83:	89 d1                	mov    %edx,%ecx
  801e85:	89 f0                	mov    %esi,%eax
  801e87:	d3 e8                	shr    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	89 fa                	mov    %edi,%edx
  801e8d:	d3 e6                	shl    %cl,%esi
  801e8f:	09 d8                	or     %ebx,%eax
  801e91:	f7 74 24 08          	divl   0x8(%esp)
  801e95:	89 d1                	mov    %edx,%ecx
  801e97:	89 f3                	mov    %esi,%ebx
  801e99:	f7 64 24 0c          	mull   0xc(%esp)
  801e9d:	89 c6                	mov    %eax,%esi
  801e9f:	89 d7                	mov    %edx,%edi
  801ea1:	39 d1                	cmp    %edx,%ecx
  801ea3:	72 06                	jb     801eab <__umoddi3+0x10b>
  801ea5:	75 10                	jne    801eb7 <__umoddi3+0x117>
  801ea7:	39 c3                	cmp    %eax,%ebx
  801ea9:	73 0c                	jae    801eb7 <__umoddi3+0x117>
  801eab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801eaf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801eb3:	89 d7                	mov    %edx,%edi
  801eb5:	89 c6                	mov    %eax,%esi
  801eb7:	89 ca                	mov    %ecx,%edx
  801eb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ebe:	29 f3                	sub    %esi,%ebx
  801ec0:	19 fa                	sbb    %edi,%edx
  801ec2:	89 d0                	mov    %edx,%eax
  801ec4:	d3 e0                	shl    %cl,%eax
  801ec6:	89 e9                	mov    %ebp,%ecx
  801ec8:	d3 eb                	shr    %cl,%ebx
  801eca:	d3 ea                	shr    %cl,%edx
  801ecc:	09 d8                	or     %ebx,%eax
  801ece:	83 c4 1c             	add    $0x1c,%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
  801ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	29 fe                	sub    %edi,%esi
  801ee2:	19 c3                	sbb    %eax,%ebx
  801ee4:	89 f2                	mov    %esi,%edx
  801ee6:	89 d9                	mov    %ebx,%ecx
  801ee8:	e9 1d ff ff ff       	jmp    801e0a <__umoddi3+0x6a>
