
obj/user/faultallocbad.debug:     formato del fichero elf32-i386


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
  80002c:	e8 8c 00 00 00       	call   8000bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003e:	8b 45 08             	mov    0x8(%ebp),%eax
  800041:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800043:	53                   	push   %ebx
  800044:	68 20 1f 80 00       	push   $0x801f20
  800049:	e8 c2 01 00 00       	call   800210 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 a0 0b 00 00       	call   800c02 <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 6c 1f 80 00       	push   $0x801f6c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 a2 06 00 00       	call   800719 <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 40 1f 80 00       	push   $0x801f40
  800089:	6a 0f                	push   $0xf
  80008b:	68 2a 1f 80 00       	push   $0x801f2a
  800090:	e8 94 00 00 00       	call   800129 <_panic>

00800095 <umain>:

void
umain(int argc, char **argv)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80009f:	68 33 00 80 00       	push   $0x800033
  8000a4:	e8 96 0c 00 00       	call   800d3f <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	68 ef be ad de       	push   $0xdeadbeef
  8000b3:	e8 7f 0a 00 00       	call   800b37 <sys_cputs>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bd:	f3 0f 1e fb          	endbr32 
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000cc:	e8 de 0a 00 00       	call   800baf <sys_getenvid>
	if (id >= 0)
  8000d1:	85 c0                	test   %eax,%eax
  8000d3:	78 12                	js     8000e7 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e7:	85 db                	test   %ebx,%ebx
  8000e9:	7e 07                	jle    8000f2 <libmain+0x35>
		binaryname = argv[0];
  8000eb:	8b 06                	mov    (%esi),%eax
  8000ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	e8 99 ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  8000fc:	e8 0a 00 00 00       	call   80010b <exit>
}
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010b:	f3 0f 1e fb          	endbr32 
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800115:	e8 bb 0e 00 00       	call   800fd5 <close_all>
	sys_env_destroy(0);
  80011a:	83 ec 0c             	sub    $0xc,%esp
  80011d:	6a 00                	push   $0x0
  80011f:	e8 65 0a 00 00       	call   800b89 <sys_env_destroy>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800129:	f3 0f 1e fb          	endbr32 
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800132:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800135:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80013b:	e8 6f 0a 00 00       	call   800baf <sys_getenvid>
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	ff 75 0c             	pushl  0xc(%ebp)
  800146:	ff 75 08             	pushl  0x8(%ebp)
  800149:	56                   	push   %esi
  80014a:	50                   	push   %eax
  80014b:	68 98 1f 80 00       	push   $0x801f98
  800150:	e8 bb 00 00 00       	call   800210 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800155:	83 c4 18             	add    $0x18,%esp
  800158:	53                   	push   %ebx
  800159:	ff 75 10             	pushl  0x10(%ebp)
  80015c:	e8 5a 00 00 00       	call   8001bb <vcprintf>
	cprintf("\n");
  800161:	c7 04 24 42 24 80 00 	movl   $0x802442,(%esp)
  800168:	e8 a3 00 00 00       	call   800210 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800170:	cc                   	int3   
  800171:	eb fd                	jmp    800170 <_panic+0x47>

00800173 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800173:	f3 0f 1e fb          	endbr32 
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	53                   	push   %ebx
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800181:	8b 13                	mov    (%ebx),%edx
  800183:	8d 42 01             	lea    0x1(%edx),%eax
  800186:	89 03                	mov    %eax,(%ebx)
  800188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800194:	74 09                	je     80019f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800196:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	68 ff 00 00 00       	push   $0xff
  8001a7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 87 09 00 00       	call   800b37 <sys_cputs>
		b->idx = 0;
  8001b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	eb db                	jmp    800196 <putch+0x23>

008001bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001bb:	f3 0f 1e fb          	endbr32 
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cf:	00 00 00 
	b.cnt = 0;
  8001d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e8:	50                   	push   %eax
  8001e9:	68 73 01 80 00       	push   $0x800173
  8001ee:	e8 80 01 00 00       	call   800373 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f3:	83 c4 08             	add    $0x8,%esp
  8001f6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800202:	50                   	push   %eax
  800203:	e8 2f 09 00 00       	call   800b37 <sys_cputs>

	return b.cnt;
}
  800208:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021d:	50                   	push   %eax
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	e8 95 ff ff ff       	call   8001bb <vcprintf>
	va_end(ap);

	return cnt;
}
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 1c             	sub    $0x1c,%esp
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 d6                	mov    %edx,%esi
  800235:	8b 45 08             	mov    0x8(%ebp),%eax
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	89 d1                	mov    %edx,%ecx
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800242:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800245:	8b 45 10             	mov    0x10(%ebp),%eax
  800248:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800255:	39 c2                	cmp    %eax,%edx
  800257:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80025a:	72 3e                	jb     80029a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	ff 75 18             	pushl  0x18(%ebp)
  800262:	83 eb 01             	sub    $0x1,%ebx
  800265:	53                   	push   %ebx
  800266:	50                   	push   %eax
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026d:	ff 75 e0             	pushl  -0x20(%ebp)
  800270:	ff 75 dc             	pushl  -0x24(%ebp)
  800273:	ff 75 d8             	pushl  -0x28(%ebp)
  800276:	e8 35 1a 00 00       	call   801cb0 <__udivdi3>
  80027b:	83 c4 18             	add    $0x18,%esp
  80027e:	52                   	push   %edx
  80027f:	50                   	push   %eax
  800280:	89 f2                	mov    %esi,%edx
  800282:	89 f8                	mov    %edi,%eax
  800284:	e8 9f ff ff ff       	call   800228 <printnum>
  800289:	83 c4 20             	add    $0x20,%esp
  80028c:	eb 13                	jmp    8002a1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	56                   	push   %esi
  800292:	ff 75 18             	pushl  0x18(%ebp)
  800295:	ff d7                	call   *%edi
  800297:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029a:	83 eb 01             	sub    $0x1,%ebx
  80029d:	85 db                	test   %ebx,%ebx
  80029f:	7f ed                	jg     80028e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	56                   	push   %esi
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b4:	e8 07 1b 00 00       	call   801dc0 <__umoddi3>
  8002b9:	83 c4 14             	add    $0x14,%esp
  8002bc:	0f be 80 bb 1f 80 00 	movsbl 0x801fbb(%eax),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff d7                	call   *%edi
}
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    

008002d1 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002d1:	83 fa 01             	cmp    $0x1,%edx
  8002d4:	7f 13                	jg     8002e9 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002d6:	85 d2                	test   %edx,%edx
  8002d8:	74 1c                	je     8002f6 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002da:	8b 10                	mov    (%eax),%edx
  8002dc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002df:	89 08                	mov    %ecx,(%eax)
  8002e1:	8b 02                	mov    (%edx),%eax
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 02                	mov    (%edx),%eax
  8002f2:	8b 52 04             	mov    0x4(%edx),%edx
  8002f5:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 02                	mov    (%edx),%eax
  8002ff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800304:	c3                   	ret    

00800305 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800305:	83 fa 01             	cmp    $0x1,%edx
  800308:	7f 0f                	jg     800319 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80030a:	85 d2                	test   %edx,%edx
  80030c:	74 18                	je     800326 <getint+0x21>
		return va_arg(*ap, long);
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8d 4a 04             	lea    0x4(%edx),%ecx
  800313:	89 08                	mov    %ecx,(%eax)
  800315:	8b 02                	mov    (%edx),%eax
  800317:	99                   	cltd   
  800318:	c3                   	ret    
		return va_arg(*ap, long long);
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	8d 4a 08             	lea    0x8(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 02                	mov    (%edx),%eax
  800322:	8b 52 04             	mov    0x4(%edx),%edx
  800325:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800326:	8b 10                	mov    (%eax),%edx
  800328:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032b:	89 08                	mov    %ecx,(%eax)
  80032d:	8b 02                	mov    (%edx),%eax
  80032f:	99                   	cltd   
}
  800330:	c3                   	ret    

00800331 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800331:	f3 0f 1e fb          	endbr32 
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033f:	8b 10                	mov    (%eax),%edx
  800341:	3b 50 04             	cmp    0x4(%eax),%edx
  800344:	73 0a                	jae    800350 <sprintputch+0x1f>
		*b->buf++ = ch;
  800346:	8d 4a 01             	lea    0x1(%edx),%ecx
  800349:	89 08                	mov    %ecx,(%eax)
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	88 02                	mov    %al,(%edx)
}
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <printfmt>:
{
  800352:	f3 0f 1e fb          	endbr32 
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80035c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035f:	50                   	push   %eax
  800360:	ff 75 10             	pushl  0x10(%ebp)
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	e8 05 00 00 00       	call   800373 <vprintfmt>
}
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <vprintfmt>:
{
  800373:	f3 0f 1e fb          	endbr32 
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	57                   	push   %edi
  80037b:	56                   	push   %esi
  80037c:	53                   	push   %ebx
  80037d:	83 ec 2c             	sub    $0x2c,%esp
  800380:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800383:	8b 75 0c             	mov    0xc(%ebp),%esi
  800386:	8b 7d 10             	mov    0x10(%ebp),%edi
  800389:	e9 86 02 00 00       	jmp    800614 <vprintfmt+0x2a1>
		padc = ' ';
  80038e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800392:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800399:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003a0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8d 47 01             	lea    0x1(%edi),%eax
  8003af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b2:	0f b6 17             	movzbl (%edi),%edx
  8003b5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b8:	3c 55                	cmp    $0x55,%al
  8003ba:	0f 87 df 02 00 00    	ja     80069f <vprintfmt+0x32c>
  8003c0:	0f b6 c0             	movzbl %al,%eax
  8003c3:	3e ff 24 85 00 21 80 	notrack jmp *0x802100(,%eax,4)
  8003ca:	00 
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d2:	eb d8                	jmp    8003ac <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003db:	eb cf                	jmp    8003ac <vprintfmt+0x39>
  8003dd:	0f b6 d2             	movzbl %dl,%edx
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003f8:	83 f9 09             	cmp    $0x9,%ecx
  8003fb:	77 52                	ja     80044f <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8003fd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800400:	eb e9                	jmp    8003eb <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 50 04             	lea    0x4(%eax),%edx
  800408:	89 55 14             	mov    %edx,0x14(%ebp)
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800413:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800417:	79 93                	jns    8003ac <vprintfmt+0x39>
				width = precision, precision = -1;
  800419:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800426:	eb 84                	jmp    8003ac <vprintfmt+0x39>
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	85 c0                	test   %eax,%eax
  80042d:	ba 00 00 00 00       	mov    $0x0,%edx
  800432:	0f 49 d0             	cmovns %eax,%edx
  800435:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043b:	e9 6c ff ff ff       	jmp    8003ac <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800443:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80044a:	e9 5d ff ff ff       	jmp    8003ac <vprintfmt+0x39>
  80044f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800452:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800455:	eb bc                	jmp    800413 <vprintfmt+0xa0>
			lflag++;
  800457:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045d:	e9 4a ff ff ff       	jmp    8003ac <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800462:	8b 45 14             	mov    0x14(%ebp),%eax
  800465:	8d 50 04             	lea    0x4(%eax),%edx
  800468:	89 55 14             	mov    %edx,0x14(%ebp)
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	56                   	push   %esi
  80046f:	ff 30                	pushl  (%eax)
  800471:	ff d3                	call   *%ebx
			break;
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	e9 96 01 00 00       	jmp    800611 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	8d 50 04             	lea    0x4(%eax),%edx
  800481:	89 55 14             	mov    %edx,0x14(%ebp)
  800484:	8b 00                	mov    (%eax),%eax
  800486:	99                   	cltd   
  800487:	31 d0                	xor    %edx,%eax
  800489:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048b:	83 f8 0f             	cmp    $0xf,%eax
  80048e:	7f 20                	jg     8004b0 <vprintfmt+0x13d>
  800490:	8b 14 85 60 22 80 00 	mov    0x802260(,%eax,4),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	74 15                	je     8004b0 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80049b:	52                   	push   %edx
  80049c:	68 db 23 80 00       	push   $0x8023db
  8004a1:	56                   	push   %esi
  8004a2:	53                   	push   %ebx
  8004a3:	e8 aa fe ff ff       	call   800352 <printfmt>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	e9 61 01 00 00       	jmp    800611 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004b0:	50                   	push   %eax
  8004b1:	68 d3 1f 80 00       	push   $0x801fd3
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	e8 95 fe ff ff       	call   800352 <printfmt>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	e9 4c 01 00 00       	jmp    800611 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8d 50 04             	lea    0x4(%eax),%edx
  8004cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ce:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	b8 cc 1f 80 00       	mov    $0x801fcc,%eax
  8004d7:	0f 45 c1             	cmovne %ecx,%eax
  8004da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e1:	7e 06                	jle    8004e9 <vprintfmt+0x176>
  8004e3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004e7:	75 0d                	jne    8004f6 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ec:	89 c7                	mov    %eax,%edi
  8004ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	eb 57                	jmp    80054d <vprintfmt+0x1da>
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8004ff:	e8 4f 02 00 00       	call   800753 <strnlen>
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800513:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800516:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	85 db                	test   %ebx,%ebx
  80051a:	7e 10                	jle    80052c <vprintfmt+0x1b9>
					putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	56                   	push   %esi
  800520:	57                   	push   %edi
  800521:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	83 eb 01             	sub    $0x1,%ebx
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	eb ec                	jmp    800518 <vprintfmt+0x1a5>
  80052c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80052f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800532:	85 d2                	test   %edx,%edx
  800534:	b8 00 00 00 00       	mov    $0x0,%eax
  800539:	0f 49 c2             	cmovns %edx,%eax
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800541:	eb a6                	jmp    8004e9 <vprintfmt+0x176>
					putch(ch, putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	56                   	push   %esi
  800547:	52                   	push   %edx
  800548:	ff d3                	call   *%ebx
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800550:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800552:	83 c7 01             	add    $0x1,%edi
  800555:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800559:	0f be d0             	movsbl %al,%edx
  80055c:	85 d2                	test   %edx,%edx
  80055e:	74 42                	je     8005a2 <vprintfmt+0x22f>
  800560:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800564:	78 06                	js     80056c <vprintfmt+0x1f9>
  800566:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056a:	78 1e                	js     80058a <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80056c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800570:	74 d1                	je     800543 <vprintfmt+0x1d0>
  800572:	0f be c0             	movsbl %al,%eax
  800575:	83 e8 20             	sub    $0x20,%eax
  800578:	83 f8 5e             	cmp    $0x5e,%eax
  80057b:	76 c6                	jbe    800543 <vprintfmt+0x1d0>
					putch('?', putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	56                   	push   %esi
  800581:	6a 3f                	push   $0x3f
  800583:	ff d3                	call   *%ebx
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	eb c3                	jmp    80054d <vprintfmt+0x1da>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb 0e                	jmp    80059c <vprintfmt+0x229>
				putch(' ', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	56                   	push   %esi
  800592:	6a 20                	push   $0x20
  800594:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7f ee                	jg     80058e <vprintfmt+0x21b>
  8005a0:	eb 6f                	jmp    800611 <vprintfmt+0x29e>
  8005a2:	89 cf                	mov    %ecx,%edi
  8005a4:	eb f6                	jmp    80059c <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005a6:	89 ca                	mov    %ecx,%edx
  8005a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ab:	e8 55 fd ff ff       	call   800305 <getint>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005b6:	85 d2                	test   %edx,%edx
  8005b8:	78 0b                	js     8005c5 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005ba:	89 d1                	mov    %edx,%ecx
  8005bc:	89 c2                	mov    %eax,%edx
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c3:	eb 32                	jmp    8005f7 <vprintfmt+0x284>
				putch('-', putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	56                   	push   %esi
  8005c9:	6a 2d                	push   $0x2d
  8005cb:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d3:	f7 da                	neg    %edx
  8005d5:	83 d1 00             	adc    $0x0,%ecx
  8005d8:	f7 d9                	neg    %ecx
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	eb 13                	jmp    8005f7 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005e4:	89 ca                	mov    %ecx,%edx
  8005e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e9:	e8 e3 fc ff ff       	call   8002d1 <getuint>
  8005ee:	89 d1                	mov    %edx,%ecx
  8005f0:	89 c2                	mov    %eax,%edx
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f7:	83 ec 0c             	sub    $0xc,%esp
  8005fa:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005fe:	57                   	push   %edi
  8005ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800602:	50                   	push   %eax
  800603:	51                   	push   %ecx
  800604:	52                   	push   %edx
  800605:	89 f2                	mov    %esi,%edx
  800607:	89 d8                	mov    %ebx,%eax
  800609:	e8 1a fc ff ff       	call   800228 <printnum>
			break;
  80060e:	83 c4 20             	add    $0x20,%esp
{
  800611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800614:	83 c7 01             	add    $0x1,%edi
  800617:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061b:	83 f8 25             	cmp    $0x25,%eax
  80061e:	0f 84 6a fd ff ff    	je     80038e <vprintfmt+0x1b>
			if (ch == '\0')
  800624:	85 c0                	test   %eax,%eax
  800626:	0f 84 93 00 00 00    	je     8006bf <vprintfmt+0x34c>
			putch(ch, putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	56                   	push   %esi
  800630:	50                   	push   %eax
  800631:	ff d3                	call   *%ebx
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	eb dc                	jmp    800614 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800638:	89 ca                	mov    %ecx,%edx
  80063a:	8d 45 14             	lea    0x14(%ebp),%eax
  80063d:	e8 8f fc ff ff       	call   8002d1 <getuint>
  800642:	89 d1                	mov    %edx,%ecx
  800644:	89 c2                	mov    %eax,%edx
			base = 8;
  800646:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  80064b:	eb aa                	jmp    8005f7 <vprintfmt+0x284>
			putch('0', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	56                   	push   %esi
  800651:	6a 30                	push   $0x30
  800653:	ff d3                	call   *%ebx
			putch('x', putdat);
  800655:	83 c4 08             	add    $0x8,%esp
  800658:	56                   	push   %esi
  800659:	6a 78                	push   $0x78
  80065b:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8d 50 04             	lea    0x4(%eax),%edx
  800663:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800666:	8b 10                	mov    (%eax),%edx
  800668:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800670:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800675:	eb 80                	jmp    8005f7 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800677:	89 ca                	mov    %ecx,%edx
  800679:	8d 45 14             	lea    0x14(%ebp),%eax
  80067c:	e8 50 fc ff ff       	call   8002d1 <getuint>
  800681:	89 d1                	mov    %edx,%ecx
  800683:	89 c2                	mov    %eax,%edx
			base = 16;
  800685:	b8 10 00 00 00       	mov    $0x10,%eax
  80068a:	e9 68 ff ff ff       	jmp    8005f7 <vprintfmt+0x284>
			putch(ch, putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	56                   	push   %esi
  800693:	6a 25                	push   $0x25
  800695:	ff d3                	call   *%ebx
			break;
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	e9 72 ff ff ff       	jmp    800611 <vprintfmt+0x29e>
			putch('%', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	56                   	push   %esi
  8006a3:	6a 25                	push   $0x25
  8006a5:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	89 f8                	mov    %edi,%eax
  8006ac:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006b0:	74 05                	je     8006b7 <vprintfmt+0x344>
  8006b2:	83 e8 01             	sub    $0x1,%eax
  8006b5:	eb f5                	jmp    8006ac <vprintfmt+0x339>
  8006b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ba:	e9 52 ff ff ff       	jmp    800611 <vprintfmt+0x29e>
}
  8006bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c2:	5b                   	pop    %ebx
  8006c3:	5e                   	pop    %esi
  8006c4:	5f                   	pop    %edi
  8006c5:	5d                   	pop    %ebp
  8006c6:	c3                   	ret    

008006c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c7:	f3 0f 1e fb          	endbr32 
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 18             	sub    $0x18,%esp
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006da:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006de:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	74 26                	je     800712 <vsnprintf+0x4b>
  8006ec:	85 d2                	test   %edx,%edx
  8006ee:	7e 22                	jle    800712 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f0:	ff 75 14             	pushl  0x14(%ebp)
  8006f3:	ff 75 10             	pushl  0x10(%ebp)
  8006f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	68 31 03 80 00       	push   $0x800331
  8006ff:	e8 6f fc ff ff       	call   800373 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800707:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070d:	83 c4 10             	add    $0x10,%esp
}
  800710:	c9                   	leave  
  800711:	c3                   	ret    
		return -E_INVAL;
  800712:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800717:	eb f7                	jmp    800710 <vsnprintf+0x49>

00800719 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800719:	f3 0f 1e fb          	endbr32 
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800726:	50                   	push   %eax
  800727:	ff 75 10             	pushl  0x10(%ebp)
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	e8 92 ff ff ff       	call   8006c7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800737:	f3 0f 1e fb          	endbr32 
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800741:	b8 00 00 00 00       	mov    $0x0,%eax
  800746:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80074a:	74 05                	je     800751 <strlen+0x1a>
		n++;
  80074c:	83 c0 01             	add    $0x1,%eax
  80074f:	eb f5                	jmp    800746 <strlen+0xf>
	return n;
}
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800760:	b8 00 00 00 00       	mov    $0x0,%eax
  800765:	39 d0                	cmp    %edx,%eax
  800767:	74 0d                	je     800776 <strnlen+0x23>
  800769:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80076d:	74 05                	je     800774 <strnlen+0x21>
		n++;
  80076f:	83 c0 01             	add    $0x1,%eax
  800772:	eb f1                	jmp    800765 <strnlen+0x12>
  800774:	89 c2                	mov    %eax,%edx
	return n;
}
  800776:	89 d0                	mov    %edx,%eax
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80077a:	f3 0f 1e fb          	endbr32 
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	53                   	push   %ebx
  800782:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800785:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800788:	b8 00 00 00 00       	mov    $0x0,%eax
  80078d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800791:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800794:	83 c0 01             	add    $0x1,%eax
  800797:	84 d2                	test   %dl,%dl
  800799:	75 f2                	jne    80078d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80079b:	89 c8                	mov    %ecx,%eax
  80079d:	5b                   	pop    %ebx
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a0:	f3 0f 1e fb          	endbr32 
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 10             	sub    $0x10,%esp
  8007ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007ae:	53                   	push   %ebx
  8007af:	e8 83 ff ff ff       	call   800737 <strlen>
  8007b4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	01 d8                	add    %ebx,%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 b8 ff ff ff       	call   80077a <strcpy>
	return dst;
}
  8007c2:	89 d8                	mov    %ebx,%eax
  8007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c9:	f3 0f 1e fb          	endbr32 
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d8:	89 f3                	mov    %esi,%ebx
  8007da:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007dd:	89 f0                	mov    %esi,%eax
  8007df:	39 d8                	cmp    %ebx,%eax
  8007e1:	74 11                	je     8007f4 <strncpy+0x2b>
		*dst++ = *src;
  8007e3:	83 c0 01             	add    $0x1,%eax
  8007e6:	0f b6 0a             	movzbl (%edx),%ecx
  8007e9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ec:	80 f9 01             	cmp    $0x1,%cl
  8007ef:	83 da ff             	sbb    $0xffffffff,%edx
  8007f2:	eb eb                	jmp    8007df <strncpy+0x16>
	}
	return ret;
}
  8007f4:	89 f0                	mov    %esi,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5e                   	pop    %esi
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007fa:	f3 0f 1e fb          	endbr32 
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	56                   	push   %esi
  800802:	53                   	push   %ebx
  800803:	8b 75 08             	mov    0x8(%ebp),%esi
  800806:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800809:	8b 55 10             	mov    0x10(%ebp),%edx
  80080c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080e:	85 d2                	test   %edx,%edx
  800810:	74 21                	je     800833 <strlcpy+0x39>
  800812:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800816:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800818:	39 c2                	cmp    %eax,%edx
  80081a:	74 14                	je     800830 <strlcpy+0x36>
  80081c:	0f b6 19             	movzbl (%ecx),%ebx
  80081f:	84 db                	test   %bl,%bl
  800821:	74 0b                	je     80082e <strlcpy+0x34>
			*dst++ = *src++;
  800823:	83 c1 01             	add    $0x1,%ecx
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082c:	eb ea                	jmp    800818 <strlcpy+0x1e>
  80082e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800830:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800833:	29 f0                	sub    %esi,%eax
}
  800835:	5b                   	pop    %ebx
  800836:	5e                   	pop    %esi
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800839:	f3 0f 1e fb          	endbr32 
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800846:	0f b6 01             	movzbl (%ecx),%eax
  800849:	84 c0                	test   %al,%al
  80084b:	74 0c                	je     800859 <strcmp+0x20>
  80084d:	3a 02                	cmp    (%edx),%al
  80084f:	75 08                	jne    800859 <strcmp+0x20>
		p++, q++;
  800851:	83 c1 01             	add    $0x1,%ecx
  800854:	83 c2 01             	add    $0x1,%edx
  800857:	eb ed                	jmp    800846 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800859:	0f b6 c0             	movzbl %al,%eax
  80085c:	0f b6 12             	movzbl (%edx),%edx
  80085f:	29 d0                	sub    %edx,%eax
}
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800863:	f3 0f 1e fb          	endbr32 
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	89 c3                	mov    %eax,%ebx
  800873:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800876:	eb 06                	jmp    80087e <strncmp+0x1b>
		n--, p++, q++;
  800878:	83 c0 01             	add    $0x1,%eax
  80087b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	74 16                	je     800898 <strncmp+0x35>
  800882:	0f b6 08             	movzbl (%eax),%ecx
  800885:	84 c9                	test   %cl,%cl
  800887:	74 04                	je     80088d <strncmp+0x2a>
  800889:	3a 0a                	cmp    (%edx),%cl
  80088b:	74 eb                	je     800878 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80088d:	0f b6 00             	movzbl (%eax),%eax
  800890:	0f b6 12             	movzbl (%edx),%edx
  800893:	29 d0                	sub    %edx,%eax
}
  800895:	5b                   	pop    %ebx
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    
		return 0;
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
  80089d:	eb f6                	jmp    800895 <strncmp+0x32>

0080089f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ad:	0f b6 10             	movzbl (%eax),%edx
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	74 09                	je     8008bd <strchr+0x1e>
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 0a                	je     8008c2 <strchr+0x23>
	for (; *s; s++)
  8008b8:	83 c0 01             	add    $0x1,%eax
  8008bb:	eb f0                	jmp    8008ad <strchr+0xe>
			return (char *) s;
	return 0;
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c4:	f3 0f 1e fb          	endbr32 
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d5:	38 ca                	cmp    %cl,%dl
  8008d7:	74 09                	je     8008e2 <strfind+0x1e>
  8008d9:	84 d2                	test   %dl,%dl
  8008db:	74 05                	je     8008e2 <strfind+0x1e>
	for (; *s; s++)
  8008dd:	83 c0 01             	add    $0x1,%eax
  8008e0:	eb f0                	jmp    8008d2 <strfind+0xe>
			break;
	return (char *) s;
}
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	57                   	push   %edi
  8008ec:	56                   	push   %esi
  8008ed:	53                   	push   %ebx
  8008ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008f4:	85 c9                	test   %ecx,%ecx
  8008f6:	74 33                	je     80092b <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	09 c8                	or     %ecx,%eax
  8008fc:	a8 03                	test   $0x3,%al
  8008fe:	75 23                	jne    800923 <memset+0x3f>
		c &= 0xFF;
  800900:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800904:	89 d8                	mov    %ebx,%eax
  800906:	c1 e0 08             	shl    $0x8,%eax
  800909:	89 df                	mov    %ebx,%edi
  80090b:	c1 e7 18             	shl    $0x18,%edi
  80090e:	89 de                	mov    %ebx,%esi
  800910:	c1 e6 10             	shl    $0x10,%esi
  800913:	09 f7                	or     %esi,%edi
  800915:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800917:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80091a:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80091c:	89 d7                	mov    %edx,%edi
  80091e:	fc                   	cld    
  80091f:	f3 ab                	rep stos %eax,%es:(%edi)
  800921:	eb 08                	jmp    80092b <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800923:	89 d7                	mov    %edx,%edi
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	fc                   	cld    
  800929:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5f                   	pop    %edi
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	57                   	push   %edi
  80093a:	56                   	push   %esi
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800941:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800944:	39 c6                	cmp    %eax,%esi
  800946:	73 32                	jae    80097a <memmove+0x48>
  800948:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094b:	39 c2                	cmp    %eax,%edx
  80094d:	76 2b                	jbe    80097a <memmove+0x48>
		s += n;
		d += n;
  80094f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800952:	89 fe                	mov    %edi,%esi
  800954:	09 ce                	or     %ecx,%esi
  800956:	09 d6                	or     %edx,%esi
  800958:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095e:	75 0e                	jne    80096e <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800960:	83 ef 04             	sub    $0x4,%edi
  800963:	8d 72 fc             	lea    -0x4(%edx),%esi
  800966:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800969:	fd                   	std    
  80096a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096c:	eb 09                	jmp    800977 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096e:	83 ef 01             	sub    $0x1,%edi
  800971:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800974:	fd                   	std    
  800975:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800977:	fc                   	cld    
  800978:	eb 1a                	jmp    800994 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	09 ca                	or     %ecx,%edx
  80097e:	09 f2                	or     %esi,%edx
  800980:	f6 c2 03             	test   $0x3,%dl
  800983:	75 0a                	jne    80098f <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800985:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800988:	89 c7                	mov    %eax,%edi
  80098a:	fc                   	cld    
  80098b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098d:	eb 05                	jmp    800994 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80098f:	89 c7                	mov    %eax,%edi
  800991:	fc                   	cld    
  800992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800994:	5e                   	pop    %esi
  800995:	5f                   	pop    %edi
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800998:	f3 0f 1e fb          	endbr32 
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a2:	ff 75 10             	pushl  0x10(%ebp)
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	ff 75 08             	pushl  0x8(%ebp)
  8009ab:	e8 82 ff ff ff       	call   800932 <memmove>
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b2:	f3 0f 1e fb          	endbr32 
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 c6                	mov    %eax,%esi
  8009c3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c6:	39 f0                	cmp    %esi,%eax
  8009c8:	74 1c                	je     8009e6 <memcmp+0x34>
		if (*s1 != *s2)
  8009ca:	0f b6 08             	movzbl (%eax),%ecx
  8009cd:	0f b6 1a             	movzbl (%edx),%ebx
  8009d0:	38 d9                	cmp    %bl,%cl
  8009d2:	75 08                	jne    8009dc <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	eb ea                	jmp    8009c6 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009dc:	0f b6 c1             	movzbl %cl,%eax
  8009df:	0f b6 db             	movzbl %bl,%ebx
  8009e2:	29 d8                	sub    %ebx,%eax
  8009e4:	eb 05                	jmp    8009eb <memcmp+0x39>
	}

	return 0;
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a01:	39 d0                	cmp    %edx,%eax
  800a03:	73 09                	jae    800a0e <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a05:	38 08                	cmp    %cl,(%eax)
  800a07:	74 05                	je     800a0e <memfind+0x1f>
	for (; s < ends; s++)
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	eb f3                	jmp    800a01 <memfind+0x12>
			break;
	return (void *) s;
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a20:	eb 03                	jmp    800a25 <strtol+0x15>
		s++;
  800a22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	3c 20                	cmp    $0x20,%al
  800a2a:	74 f6                	je     800a22 <strtol+0x12>
  800a2c:	3c 09                	cmp    $0x9,%al
  800a2e:	74 f2                	je     800a22 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a30:	3c 2b                	cmp    $0x2b,%al
  800a32:	74 2a                	je     800a5e <strtol+0x4e>
	int neg = 0;
  800a34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a39:	3c 2d                	cmp    $0x2d,%al
  800a3b:	74 2b                	je     800a68 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a43:	75 0f                	jne    800a54 <strtol+0x44>
  800a45:	80 39 30             	cmpb   $0x30,(%ecx)
  800a48:	74 28                	je     800a72 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a51:	0f 44 d8             	cmove  %eax,%ebx
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a5c:	eb 46                	jmp    800aa4 <strtol+0x94>
		s++;
  800a5e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a61:	bf 00 00 00 00       	mov    $0x0,%edi
  800a66:	eb d5                	jmp    800a3d <strtol+0x2d>
		s++, neg = 1;
  800a68:	83 c1 01             	add    $0x1,%ecx
  800a6b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a70:	eb cb                	jmp    800a3d <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a72:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a76:	74 0e                	je     800a86 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a78:	85 db                	test   %ebx,%ebx
  800a7a:	75 d8                	jne    800a54 <strtol+0x44>
		s++, base = 8;
  800a7c:	83 c1 01             	add    $0x1,%ecx
  800a7f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a84:	eb ce                	jmp    800a54 <strtol+0x44>
		s += 2, base = 16;
  800a86:	83 c1 02             	add    $0x2,%ecx
  800a89:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a8e:	eb c4                	jmp    800a54 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a90:	0f be d2             	movsbl %dl,%edx
  800a93:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a96:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a99:	7d 3a                	jge    800ad5 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a9b:	83 c1 01             	add    $0x1,%ecx
  800a9e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aa4:	0f b6 11             	movzbl (%ecx),%edx
  800aa7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aaa:	89 f3                	mov    %esi,%ebx
  800aac:	80 fb 09             	cmp    $0x9,%bl
  800aaf:	76 df                	jbe    800a90 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ab1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab4:	89 f3                	mov    %esi,%ebx
  800ab6:	80 fb 19             	cmp    $0x19,%bl
  800ab9:	77 08                	ja     800ac3 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800abb:	0f be d2             	movsbl %dl,%edx
  800abe:	83 ea 57             	sub    $0x57,%edx
  800ac1:	eb d3                	jmp    800a96 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ac3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac6:	89 f3                	mov    %esi,%ebx
  800ac8:	80 fb 19             	cmp    $0x19,%bl
  800acb:	77 08                	ja     800ad5 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800acd:	0f be d2             	movsbl %dl,%edx
  800ad0:	83 ea 37             	sub    $0x37,%edx
  800ad3:	eb c1                	jmp    800a96 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad9:	74 05                	je     800ae0 <strtol+0xd0>
		*endptr = (char *) s;
  800adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ade:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	f7 da                	neg    %edx
  800ae4:	85 ff                	test   %edi,%edi
  800ae6:	0f 45 c2             	cmovne %edx,%eax
}
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 1c             	sub    $0x1c,%esp
  800af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800afa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800afd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b05:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b08:	8b 75 14             	mov    0x14(%ebp),%esi
  800b0b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b11:	74 04                	je     800b17 <syscall+0x29>
  800b13:	85 c0                	test   %eax,%eax
  800b15:	7f 08                	jg     800b1f <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	50                   	push   %eax
  800b23:	ff 75 e0             	pushl  -0x20(%ebp)
  800b26:	68 bf 22 80 00       	push   $0x8022bf
  800b2b:	6a 23                	push   $0x23
  800b2d:	68 dc 22 80 00       	push   $0x8022dc
  800b32:	e8 f2 f5 ff ff       	call   800129 <_panic>

00800b37 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b37:	f3 0f 1e fb          	endbr32 
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b41:	6a 00                	push   $0x0
  800b43:	6a 00                	push   $0x0
  800b45:	6a 00                	push   $0x0
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	e8 92 ff ff ff       	call   800aee <syscall>
}
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b61:	f3 0f 1e fb          	endbr32 
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b6b:	6a 00                	push   $0x0
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	6a 00                	push   $0x0
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b82:	e8 67 ff ff ff       	call   800aee <syscall>
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b93:	6a 00                	push   $0x0
  800b95:	6a 00                	push   $0x0
  800b97:	6a 00                	push   $0x0
  800b99:	6a 00                	push   $0x0
  800b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9e:	ba 01 00 00 00       	mov    $0x1,%edx
  800ba3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba8:	e8 41 ff ff ff       	call   800aee <syscall>
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bb9:	6a 00                	push   $0x0
  800bbb:	6a 00                	push   $0x0
  800bbd:	6a 00                	push   $0x0
  800bbf:	6a 00                	push   $0x0
  800bc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd0:	e8 19 ff ff ff       	call   800aee <syscall>
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sys_yield>:

void
sys_yield(void)
{
  800bd7:	f3 0f 1e fb          	endbr32 
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800be1:	6a 00                	push   $0x0
  800be3:	6a 00                	push   $0x0
  800be5:	6a 00                	push   $0x0
  800be7:	6a 00                	push   $0x0
  800be9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bee:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf8:	e8 f1 fe ff ff       	call   800aee <syscall>
}
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c0c:	6a 00                	push   $0x0
  800c0e:	6a 00                	push   $0x0
  800c10:	ff 75 10             	pushl  0x10(%ebp)
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c23:	e8 c6 fe ff ff       	call   800aee <syscall>
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2a:	f3 0f 1e fb          	endbr32 
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c34:	ff 75 18             	pushl  0x18(%ebp)
  800c37:	ff 75 14             	pushl  0x14(%ebp)
  800c3a:	ff 75 10             	pushl  0x10(%ebp)
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c43:	ba 01 00 00 00       	mov    $0x1,%edx
  800c48:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4d:	e8 9c fe ff ff       	call   800aee <syscall>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c5e:	6a 00                	push   $0x0
  800c60:	6a 00                	push   $0x0
  800c62:	6a 00                	push   $0x0
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c74:	e8 75 fe ff ff       	call   800aee <syscall>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c85:	6a 00                	push   $0x0
  800c87:	6a 00                	push   $0x0
  800c89:	6a 00                	push   $0x0
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	ba 01 00 00 00       	mov    $0x1,%edx
  800c96:	b8 08 00 00 00       	mov    $0x8,%eax
  800c9b:	e8 4e fe ff ff       	call   800aee <syscall>
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cac:	6a 00                	push   $0x0
  800cae:	6a 00                	push   $0x0
  800cb0:	6a 00                	push   $0x0
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb8:	ba 01 00 00 00       	mov    $0x1,%edx
  800cbd:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc2:	e8 27 fe ff ff       	call   800aee <syscall>
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800cd3:	6a 00                	push   $0x0
  800cd5:	6a 00                	push   $0x0
  800cd7:	6a 00                	push   $0x0
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdf:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce9:	e8 00 fe ff ff       	call   800aee <syscall>
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cfa:	6a 00                	push   $0x0
  800cfc:	ff 75 14             	pushl  0x14(%ebp)
  800cff:	ff 75 10             	pushl  0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d12:	e8 d7 fd ff ff       	call   800aee <syscall>
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d19:	f3 0f 1e fb          	endbr32 
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d23:	6a 00                	push   $0x0
  800d25:	6a 00                	push   $0x0
  800d27:	6a 00                	push   $0x0
  800d29:	6a 00                	push   $0x0
  800d2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d33:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d38:	e8 b1 fd ff ff       	call   800aee <syscall>
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d3f:	f3 0f 1e fb          	endbr32 
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d49:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800d50:	74 0a                	je     800d5c <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  800d5c:	a1 04 40 80 00       	mov    0x804004,%eax
  800d61:	8b 40 48             	mov    0x48(%eax),%eax
  800d64:	83 ec 04             	sub    $0x4,%esp
  800d67:	6a 07                	push   $0x7
  800d69:	68 00 f0 bf ee       	push   $0xeebff000
  800d6e:	50                   	push   %eax
  800d6f:	e8 8e fe ff ff       	call   800c02 <sys_page_alloc>
		if (r!= 0)
  800d74:	83 c4 10             	add    $0x10,%esp
  800d77:	85 c0                	test   %eax,%eax
  800d79:	75 2f                	jne    800daa <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800d7b:	a1 04 40 80 00       	mov    0x804004,%eax
  800d80:	8b 40 48             	mov    0x48(%eax),%eax
  800d83:	83 ec 08             	sub    $0x8,%esp
  800d86:	68 bc 0d 80 00       	push   $0x800dbc
  800d8b:	50                   	push   %eax
  800d8c:	e8 38 ff ff ff       	call   800cc9 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  800d91:	83 c4 10             	add    $0x10,%esp
  800d94:	85 c0                	test   %eax,%eax
  800d96:	74 ba                	je     800d52 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  800d98:	50                   	push   %eax
  800d99:	68 ea 22 80 00       	push   $0x8022ea
  800d9e:	6a 26                	push   $0x26
  800da0:	68 02 23 80 00       	push   $0x802302
  800da5:	e8 7f f3 ff ff       	call   800129 <_panic>
			panic("set_pgfault_handler: %e", r);
  800daa:	50                   	push   %eax
  800dab:	68 ea 22 80 00       	push   $0x8022ea
  800db0:	6a 22                	push   $0x22
  800db2:	68 02 23 80 00       	push   $0x802302
  800db7:	e8 6d f3 ff ff       	call   800129 <_panic>

00800dbc <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800dbc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800dbd:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800dc2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800dc4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  800dc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  800dcb:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  800dce:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  800dd2:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  800dd6:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800dd8:	83 c4 08             	add    $0x8,%esp
	popal
  800ddb:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800ddc:	83 c4 04             	add    $0x4,%esp
	popfl
  800ddf:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800de0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800de1:	c3                   	ret    

00800de2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800de2:	f3 0f 1e fb          	endbr32 
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	05 00 00 00 30       	add    $0x30000000,%eax
  800df1:	c1 e8 0c             	shr    $0xc,%eax
}
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800df6:	f3 0f 1e fb          	endbr32 
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800e00:	ff 75 08             	pushl  0x8(%ebp)
  800e03:	e8 da ff ff ff       	call   800de2 <fd2num>
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	c1 e0 0c             	shl    $0xc,%eax
  800e0e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e15:	f3 0f 1e fb          	endbr32 
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	c1 ea 16             	shr    $0x16,%edx
  800e26:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e2d:	f6 c2 01             	test   $0x1,%dl
  800e30:	74 2d                	je     800e5f <fd_alloc+0x4a>
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	c1 ea 0c             	shr    $0xc,%edx
  800e37:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e3e:	f6 c2 01             	test   $0x1,%dl
  800e41:	74 1c                	je     800e5f <fd_alloc+0x4a>
  800e43:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e48:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e4d:	75 d2                	jne    800e21 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e58:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e5d:	eb 0a                	jmp    800e69 <fd_alloc+0x54>
			*fd_store = fd;
  800e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e62:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e6b:	f3 0f 1e fb          	endbr32 
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e75:	83 f8 1f             	cmp    $0x1f,%eax
  800e78:	77 30                	ja     800eaa <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e7a:	c1 e0 0c             	shl    $0xc,%eax
  800e7d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e82:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e88:	f6 c2 01             	test   $0x1,%dl
  800e8b:	74 24                	je     800eb1 <fd_lookup+0x46>
  800e8d:	89 c2                	mov    %eax,%edx
  800e8f:	c1 ea 0c             	shr    $0xc,%edx
  800e92:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e99:	f6 c2 01             	test   $0x1,%dl
  800e9c:	74 1a                	je     800eb8 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea1:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		return -E_INVAL;
  800eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eaf:	eb f7                	jmp    800ea8 <fd_lookup+0x3d>
		return -E_INVAL;
  800eb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb6:	eb f0                	jmp    800ea8 <fd_lookup+0x3d>
  800eb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebd:	eb e9                	jmp    800ea8 <fd_lookup+0x3d>

00800ebf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ebf:	f3 0f 1e fb          	endbr32 
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecc:	ba 8c 23 80 00       	mov    $0x80238c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ed1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ed6:	39 08                	cmp    %ecx,(%eax)
  800ed8:	74 33                	je     800f0d <dev_lookup+0x4e>
  800eda:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800edd:	8b 02                	mov    (%edx),%eax
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	75 f3                	jne    800ed6 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee3:	a1 04 40 80 00       	mov    0x804004,%eax
  800ee8:	8b 40 48             	mov    0x48(%eax),%eax
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	51                   	push   %ecx
  800eef:	50                   	push   %eax
  800ef0:	68 10 23 80 00       	push   $0x802310
  800ef5:	e8 16 f3 ff ff       	call   800210 <cprintf>
	*dev = 0;
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    
			*dev = devtab[i];
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
  800f17:	eb f2                	jmp    800f0b <dev_lookup+0x4c>

00800f19 <fd_close>:
{
  800f19:	f3 0f 1e fb          	endbr32 
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 28             	sub    $0x28,%esp
  800f26:	8b 75 08             	mov    0x8(%ebp),%esi
  800f29:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f2c:	56                   	push   %esi
  800f2d:	e8 b0 fe ff ff       	call   800de2 <fd2num>
  800f32:	83 c4 08             	add    $0x8,%esp
  800f35:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800f38:	52                   	push   %edx
  800f39:	50                   	push   %eax
  800f3a:	e8 2c ff ff ff       	call   800e6b <fd_lookup>
  800f3f:	89 c3                	mov    %eax,%ebx
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 05                	js     800f4d <fd_close+0x34>
	    || fd != fd2)
  800f48:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f4b:	74 16                	je     800f63 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f4d:	89 f8                	mov    %edi,%eax
  800f4f:	84 c0                	test   %al,%al
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	0f 44 d8             	cmove  %eax,%ebx
}
  800f59:	89 d8                	mov    %ebx,%eax
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f69:	50                   	push   %eax
  800f6a:	ff 36                	pushl  (%esi)
  800f6c:	e8 4e ff ff ff       	call   800ebf <dev_lookup>
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	85 c0                	test   %eax,%eax
  800f78:	78 1a                	js     800f94 <fd_close+0x7b>
		if (dev->dev_close)
  800f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f7d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f80:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	74 0b                	je     800f94 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	56                   	push   %esi
  800f8d:	ff d0                	call   *%eax
  800f8f:	89 c3                	mov    %eax,%ebx
  800f91:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	56                   	push   %esi
  800f98:	6a 00                	push   $0x0
  800f9a:	e8 b5 fc ff ff       	call   800c54 <sys_page_unmap>
	return r;
  800f9f:	83 c4 10             	add    $0x10,%esp
  800fa2:	eb b5                	jmp    800f59 <fd_close+0x40>

00800fa4 <close>:

int
close(int fdnum)
{
  800fa4:	f3 0f 1e fb          	endbr32 
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb1:	50                   	push   %eax
  800fb2:	ff 75 08             	pushl  0x8(%ebp)
  800fb5:	e8 b1 fe ff ff       	call   800e6b <fd_lookup>
  800fba:	83 c4 10             	add    $0x10,%esp
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	79 02                	jns    800fc3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    
		return fd_close(fd, 1);
  800fc3:	83 ec 08             	sub    $0x8,%esp
  800fc6:	6a 01                	push   $0x1
  800fc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800fcb:	e8 49 ff ff ff       	call   800f19 <fd_close>
  800fd0:	83 c4 10             	add    $0x10,%esp
  800fd3:	eb ec                	jmp    800fc1 <close+0x1d>

00800fd5 <close_all>:

void
close_all(void)
{
  800fd5:	f3 0f 1e fb          	endbr32 
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	53                   	push   %ebx
  800fdd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fe0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	53                   	push   %ebx
  800fe9:	e8 b6 ff ff ff       	call   800fa4 <close>
	for (i = 0; i < MAXFD; i++)
  800fee:	83 c3 01             	add    $0x1,%ebx
  800ff1:	83 c4 10             	add    $0x10,%esp
  800ff4:	83 fb 20             	cmp    $0x20,%ebx
  800ff7:	75 ec                	jne    800fe5 <close_all+0x10>
}
  800ff9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ffe:	f3 0f 1e fb          	endbr32 
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	57                   	push   %edi
  801006:	56                   	push   %esi
  801007:	53                   	push   %ebx
  801008:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80100b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80100e:	50                   	push   %eax
  80100f:	ff 75 08             	pushl  0x8(%ebp)
  801012:	e8 54 fe ff ff       	call   800e6b <fd_lookup>
  801017:	89 c3                	mov    %eax,%ebx
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	0f 88 81 00 00 00    	js     8010a5 <dup+0xa7>
		return r;
	close(newfdnum);
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	ff 75 0c             	pushl  0xc(%ebp)
  80102a:	e8 75 ff ff ff       	call   800fa4 <close>

	newfd = INDEX2FD(newfdnum);
  80102f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801032:	c1 e6 0c             	shl    $0xc,%esi
  801035:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80103b:	83 c4 04             	add    $0x4,%esp
  80103e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801041:	e8 b0 fd ff ff       	call   800df6 <fd2data>
  801046:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801048:	89 34 24             	mov    %esi,(%esp)
  80104b:	e8 a6 fd ff ff       	call   800df6 <fd2data>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801055:	89 d8                	mov    %ebx,%eax
  801057:	c1 e8 16             	shr    $0x16,%eax
  80105a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801061:	a8 01                	test   $0x1,%al
  801063:	74 11                	je     801076 <dup+0x78>
  801065:	89 d8                	mov    %ebx,%eax
  801067:	c1 e8 0c             	shr    $0xc,%eax
  80106a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801071:	f6 c2 01             	test   $0x1,%dl
  801074:	75 39                	jne    8010af <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801076:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801079:	89 d0                	mov    %edx,%eax
  80107b:	c1 e8 0c             	shr    $0xc,%eax
  80107e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	25 07 0e 00 00       	and    $0xe07,%eax
  80108d:	50                   	push   %eax
  80108e:	56                   	push   %esi
  80108f:	6a 00                	push   $0x0
  801091:	52                   	push   %edx
  801092:	6a 00                	push   $0x0
  801094:	e8 91 fb ff ff       	call   800c2a <sys_page_map>
  801099:	89 c3                	mov    %eax,%ebx
  80109b:	83 c4 20             	add    $0x20,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	78 31                	js     8010d3 <dup+0xd5>
		goto err;

	return newfdnum;
  8010a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010a5:	89 d8                	mov    %ebx,%eax
  8010a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8010be:	50                   	push   %eax
  8010bf:	57                   	push   %edi
  8010c0:	6a 00                	push   $0x0
  8010c2:	53                   	push   %ebx
  8010c3:	6a 00                	push   $0x0
  8010c5:	e8 60 fb ff ff       	call   800c2a <sys_page_map>
  8010ca:	89 c3                	mov    %eax,%ebx
  8010cc:	83 c4 20             	add    $0x20,%esp
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	79 a3                	jns    801076 <dup+0x78>
	sys_page_unmap(0, newfd);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	56                   	push   %esi
  8010d7:	6a 00                	push   $0x0
  8010d9:	e8 76 fb ff ff       	call   800c54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010de:	83 c4 08             	add    $0x8,%esp
  8010e1:	57                   	push   %edi
  8010e2:	6a 00                	push   $0x0
  8010e4:	e8 6b fb ff ff       	call   800c54 <sys_page_unmap>
	return r;
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	eb b7                	jmp    8010a5 <dup+0xa7>

008010ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010ee:	f3 0f 1e fb          	endbr32 
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 1c             	sub    $0x1c,%esp
  8010f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ff:	50                   	push   %eax
  801100:	53                   	push   %ebx
  801101:	e8 65 fd ff ff       	call   800e6b <fd_lookup>
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	85 c0                	test   %eax,%eax
  80110b:	78 3f                	js     80114c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801113:	50                   	push   %eax
  801114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801117:	ff 30                	pushl  (%eax)
  801119:	e8 a1 fd ff ff       	call   800ebf <dev_lookup>
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	78 27                	js     80114c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801125:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801128:	8b 42 08             	mov    0x8(%edx),%eax
  80112b:	83 e0 03             	and    $0x3,%eax
  80112e:	83 f8 01             	cmp    $0x1,%eax
  801131:	74 1e                	je     801151 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801136:	8b 40 08             	mov    0x8(%eax),%eax
  801139:	85 c0                	test   %eax,%eax
  80113b:	74 35                	je     801172 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	ff 75 10             	pushl  0x10(%ebp)
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	52                   	push   %edx
  801147:	ff d0                	call   *%eax
  801149:	83 c4 10             	add    $0x10,%esp
}
  80114c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114f:	c9                   	leave  
  801150:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801151:	a1 04 40 80 00       	mov    0x804004,%eax
  801156:	8b 40 48             	mov    0x48(%eax),%eax
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	53                   	push   %ebx
  80115d:	50                   	push   %eax
  80115e:	68 51 23 80 00       	push   $0x802351
  801163:	e8 a8 f0 ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801170:	eb da                	jmp    80114c <read+0x5e>
		return -E_NOT_SUPP;
  801172:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801177:	eb d3                	jmp    80114c <read+0x5e>

00801179 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801179:	f3 0f 1e fb          	endbr32 
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	8b 7d 08             	mov    0x8(%ebp),%edi
  801189:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80118c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801191:	eb 02                	jmp    801195 <readn+0x1c>
  801193:	01 c3                	add    %eax,%ebx
  801195:	39 f3                	cmp    %esi,%ebx
  801197:	73 21                	jae    8011ba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801199:	83 ec 04             	sub    $0x4,%esp
  80119c:	89 f0                	mov    %esi,%eax
  80119e:	29 d8                	sub    %ebx,%eax
  8011a0:	50                   	push   %eax
  8011a1:	89 d8                	mov    %ebx,%eax
  8011a3:	03 45 0c             	add    0xc(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	57                   	push   %edi
  8011a8:	e8 41 ff ff ff       	call   8010ee <read>
		if (m < 0)
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 04                	js     8011b8 <readn+0x3f>
			return m;
		if (m == 0)
  8011b4:	75 dd                	jne    801193 <readn+0x1a>
  8011b6:	eb 02                	jmp    8011ba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ba:	89 d8                	mov    %ebx,%eax
  8011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bf:	5b                   	pop    %ebx
  8011c0:	5e                   	pop    %esi
  8011c1:	5f                   	pop    %edi
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011c4:	f3 0f 1e fb          	endbr32 
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 1c             	sub    $0x1c,%esp
  8011cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d5:	50                   	push   %eax
  8011d6:	53                   	push   %ebx
  8011d7:	e8 8f fc ff ff       	call   800e6b <fd_lookup>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	78 3a                	js     80121d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ed:	ff 30                	pushl  (%eax)
  8011ef:	e8 cb fc ff ff       	call   800ebf <dev_lookup>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	78 22                	js     80121d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fe:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801202:	74 1e                	je     801222 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801207:	8b 52 0c             	mov    0xc(%edx),%edx
  80120a:	85 d2                	test   %edx,%edx
  80120c:	74 35                	je     801243 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	ff 75 10             	pushl  0x10(%ebp)
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	50                   	push   %eax
  801218:	ff d2                	call   *%edx
  80121a:	83 c4 10             	add    $0x10,%esp
}
  80121d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801220:	c9                   	leave  
  801221:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801222:	a1 04 40 80 00       	mov    0x804004,%eax
  801227:	8b 40 48             	mov    0x48(%eax),%eax
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	53                   	push   %ebx
  80122e:	50                   	push   %eax
  80122f:	68 6d 23 80 00       	push   $0x80236d
  801234:	e8 d7 ef ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801241:	eb da                	jmp    80121d <write+0x59>
		return -E_NOT_SUPP;
  801243:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801248:	eb d3                	jmp    80121d <write+0x59>

0080124a <seek>:

int
seek(int fdnum, off_t offset)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 0b fc ff ff       	call   800e6b <fd_lookup>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 0e                	js     801275 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801277:	f3 0f 1e fb          	endbr32 
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	53                   	push   %ebx
  80127f:	83 ec 1c             	sub    $0x1c,%esp
  801282:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801285:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	53                   	push   %ebx
  80128a:	e8 dc fb ff ff       	call   800e6b <fd_lookup>
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 37                	js     8012cd <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a0:	ff 30                	pushl  (%eax)
  8012a2:	e8 18 fc ff ff       	call   800ebf <dev_lookup>
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 1f                	js     8012cd <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012b5:	74 1b                	je     8012d2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ba:	8b 52 18             	mov    0x18(%edx),%edx
  8012bd:	85 d2                	test   %edx,%edx
  8012bf:	74 32                	je     8012f3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	50                   	push   %eax
  8012c8:	ff d2                	call   *%edx
  8012ca:	83 c4 10             	add    $0x10,%esp
}
  8012cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012d2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012d7:	8b 40 48             	mov    0x48(%eax),%eax
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	53                   	push   %ebx
  8012de:	50                   	push   %eax
  8012df:	68 30 23 80 00       	push   $0x802330
  8012e4:	e8 27 ef ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f1:	eb da                	jmp    8012cd <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f8:	eb d3                	jmp    8012cd <ftruncate+0x56>

008012fa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012fa:	f3 0f 1e fb          	endbr32 
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	53                   	push   %ebx
  801302:	83 ec 1c             	sub    $0x1c,%esp
  801305:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801308:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130b:	50                   	push   %eax
  80130c:	ff 75 08             	pushl  0x8(%ebp)
  80130f:	e8 57 fb ff ff       	call   800e6b <fd_lookup>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 4b                	js     801366 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801325:	ff 30                	pushl  (%eax)
  801327:	e8 93 fb ff ff       	call   800ebf <dev_lookup>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 33                	js     801366 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80133a:	74 2f                	je     80136b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80133c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80133f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801346:	00 00 00 
	stat->st_isdir = 0;
  801349:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801350:	00 00 00 
	stat->st_dev = dev;
  801353:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	53                   	push   %ebx
  80135d:	ff 75 f0             	pushl  -0x10(%ebp)
  801360:	ff 50 14             	call   *0x14(%eax)
  801363:	83 c4 10             	add    $0x10,%esp
}
  801366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801369:	c9                   	leave  
  80136a:	c3                   	ret    
		return -E_NOT_SUPP;
  80136b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801370:	eb f4                	jmp    801366 <fstat+0x6c>

00801372 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801372:	f3 0f 1e fb          	endbr32 
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	6a 00                	push   $0x0
  801380:	ff 75 08             	pushl  0x8(%ebp)
  801383:	e8 3a 02 00 00       	call   8015c2 <open>
  801388:	89 c3                	mov    %eax,%ebx
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 1b                	js     8013ac <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	ff 75 0c             	pushl  0xc(%ebp)
  801397:	50                   	push   %eax
  801398:	e8 5d ff ff ff       	call   8012fa <fstat>
  80139d:	89 c6                	mov    %eax,%esi
	close(fd);
  80139f:	89 1c 24             	mov    %ebx,(%esp)
  8013a2:	e8 fd fb ff ff       	call   800fa4 <close>
	return r;
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	89 f3                	mov    %esi,%ebx
}
  8013ac:	89 d8                	mov    %ebx,%eax
  8013ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
  8013ba:	89 c6                	mov    %eax,%esi
  8013bc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013be:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013c5:	74 27                	je     8013ee <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013c7:	6a 07                	push   $0x7
  8013c9:	68 00 50 80 00       	push   $0x805000
  8013ce:	56                   	push   %esi
  8013cf:	ff 35 00 40 80 00    	pushl  0x804000
  8013d5:	e8 fd 07 00 00       	call   801bd7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013da:	83 c4 0c             	add    $0xc,%esp
  8013dd:	6a 00                	push   $0x0
  8013df:	53                   	push   %ebx
  8013e0:	6a 00                	push   $0x0
  8013e2:	e8 83 07 00 00       	call   801b6a <ipc_recv>
}
  8013e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ea:	5b                   	pop    %ebx
  8013eb:	5e                   	pop    %esi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	6a 01                	push   $0x1
  8013f3:	e8 37 08 00 00       	call   801c2f <ipc_find_env>
  8013f8:	a3 00 40 80 00       	mov    %eax,0x804000
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	eb c5                	jmp    8013c7 <fsipc+0x12>

00801402 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801402:	f3 0f 1e fb          	endbr32 
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8b 40 0c             	mov    0xc(%eax),%eax
  801412:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80141f:	ba 00 00 00 00       	mov    $0x0,%edx
  801424:	b8 02 00 00 00       	mov    $0x2,%eax
  801429:	e8 87 ff ff ff       	call   8013b5 <fsipc>
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <devfile_flush>:
{
  801430:	f3 0f 1e fb          	endbr32 
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8b 40 0c             	mov    0xc(%eax),%eax
  801440:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801445:	ba 00 00 00 00       	mov    $0x0,%edx
  80144a:	b8 06 00 00 00       	mov    $0x6,%eax
  80144f:	e8 61 ff ff ff       	call   8013b5 <fsipc>
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <devfile_stat>:
{
  801456:	f3 0f 1e fb          	endbr32 
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	53                   	push   %ebx
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8b 40 0c             	mov    0xc(%eax),%eax
  80146a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80146f:	ba 00 00 00 00       	mov    $0x0,%edx
  801474:	b8 05 00 00 00       	mov    $0x5,%eax
  801479:	e8 37 ff ff ff       	call   8013b5 <fsipc>
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 2c                	js     8014ae <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	68 00 50 80 00       	push   $0x805000
  80148a:	53                   	push   %ebx
  80148b:	e8 ea f2 ff ff       	call   80077a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801490:	a1 80 50 80 00       	mov    0x805080,%eax
  801495:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80149b:	a1 84 50 80 00       	mov    0x805084,%eax
  8014a0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <devfile_write>:
{
  8014b3:	f3 0f 1e fb          	endbr32 
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014cc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014d2:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014d8:	77 30                	ja     80150a <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	53                   	push   %ebx
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	68 08 50 80 00       	push   $0x805008
  8014e6:	e8 47 f4 ff ff       	call   800932 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f0:	b8 04 00 00 00       	mov    $0x4,%eax
  8014f5:	e8 bb fe ff ff       	call   8013b5 <fsipc>
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	78 04                	js     801505 <devfile_write+0x52>
	assert(r <= n);
  801501:	39 d8                	cmp    %ebx,%eax
  801503:	77 1e                	ja     801523 <devfile_write+0x70>
}
  801505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801508:	c9                   	leave  
  801509:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80150a:	68 9c 23 80 00       	push   $0x80239c
  80150f:	68 c9 23 80 00       	push   $0x8023c9
  801514:	68 94 00 00 00       	push   $0x94
  801519:	68 de 23 80 00       	push   $0x8023de
  80151e:	e8 06 ec ff ff       	call   800129 <_panic>
	assert(r <= n);
  801523:	68 e9 23 80 00       	push   $0x8023e9
  801528:	68 c9 23 80 00       	push   $0x8023c9
  80152d:	68 98 00 00 00       	push   $0x98
  801532:	68 de 23 80 00       	push   $0x8023de
  801537:	e8 ed eb ff ff       	call   800129 <_panic>

0080153c <devfile_read>:
{
  80153c:	f3 0f 1e fb          	endbr32 
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	56                   	push   %esi
  801544:	53                   	push   %ebx
  801545:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8b 40 0c             	mov    0xc(%eax),%eax
  80154e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801553:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801559:	ba 00 00 00 00       	mov    $0x0,%edx
  80155e:	b8 03 00 00 00       	mov    $0x3,%eax
  801563:	e8 4d fe ff ff       	call   8013b5 <fsipc>
  801568:	89 c3                	mov    %eax,%ebx
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 1f                	js     80158d <devfile_read+0x51>
	assert(r <= n);
  80156e:	39 f0                	cmp    %esi,%eax
  801570:	77 24                	ja     801596 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801572:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801577:	7f 33                	jg     8015ac <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	50                   	push   %eax
  80157d:	68 00 50 80 00       	push   $0x805000
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	e8 a8 f3 ff ff       	call   800932 <memmove>
	return r;
  80158a:	83 c4 10             	add    $0x10,%esp
}
  80158d:	89 d8                	mov    %ebx,%eax
  80158f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801592:	5b                   	pop    %ebx
  801593:	5e                   	pop    %esi
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    
	assert(r <= n);
  801596:	68 e9 23 80 00       	push   $0x8023e9
  80159b:	68 c9 23 80 00       	push   $0x8023c9
  8015a0:	6a 7c                	push   $0x7c
  8015a2:	68 de 23 80 00       	push   $0x8023de
  8015a7:	e8 7d eb ff ff       	call   800129 <_panic>
	assert(r <= PGSIZE);
  8015ac:	68 f0 23 80 00       	push   $0x8023f0
  8015b1:	68 c9 23 80 00       	push   $0x8023c9
  8015b6:	6a 7d                	push   $0x7d
  8015b8:	68 de 23 80 00       	push   $0x8023de
  8015bd:	e8 67 eb ff ff       	call   800129 <_panic>

008015c2 <open>:
{
  8015c2:	f3 0f 1e fb          	endbr32 
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 1c             	sub    $0x1c,%esp
  8015ce:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015d1:	56                   	push   %esi
  8015d2:	e8 60 f1 ff ff       	call   800737 <strlen>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015df:	7f 6c                	jg     80164d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e7:	50                   	push   %eax
  8015e8:	e8 28 f8 ff ff       	call   800e15 <fd_alloc>
  8015ed:	89 c3                	mov    %eax,%ebx
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 3c                	js     801632 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	56                   	push   %esi
  8015fa:	68 00 50 80 00       	push   $0x805000
  8015ff:	e8 76 f1 ff ff       	call   80077a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80160c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160f:	b8 01 00 00 00       	mov    $0x1,%eax
  801614:	e8 9c fd ff ff       	call   8013b5 <fsipc>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 19                	js     80163b <open+0x79>
	return fd2num(fd);
  801622:	83 ec 0c             	sub    $0xc,%esp
  801625:	ff 75 f4             	pushl  -0xc(%ebp)
  801628:	e8 b5 f7 ff ff       	call   800de2 <fd2num>
  80162d:	89 c3                	mov    %eax,%ebx
  80162f:	83 c4 10             	add    $0x10,%esp
}
  801632:	89 d8                	mov    %ebx,%eax
  801634:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801637:	5b                   	pop    %ebx
  801638:	5e                   	pop    %esi
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    
		fd_close(fd, 0);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	6a 00                	push   $0x0
  801640:	ff 75 f4             	pushl  -0xc(%ebp)
  801643:	e8 d1 f8 ff ff       	call   800f19 <fd_close>
		return r;
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	eb e5                	jmp    801632 <open+0x70>
		return -E_BAD_PATH;
  80164d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801652:	eb de                	jmp    801632 <open+0x70>

00801654 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801654:	f3 0f 1e fb          	endbr32 
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	b8 08 00 00 00       	mov    $0x8,%eax
  801668:	e8 48 fd ff ff       	call   8013b5 <fsipc>
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80166f:	f3 0f 1e fb          	endbr32 
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
  801678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	e8 70 f7 ff ff       	call   800df6 <fd2data>
  801686:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801688:	83 c4 08             	add    $0x8,%esp
  80168b:	68 fc 23 80 00       	push   $0x8023fc
  801690:	53                   	push   %ebx
  801691:	e8 e4 f0 ff ff       	call   80077a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801696:	8b 46 04             	mov    0x4(%esi),%eax
  801699:	2b 06                	sub    (%esi),%eax
  80169b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a8:	00 00 00 
	stat->st_dev = &devpipe;
  8016ab:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016b2:	30 80 00 
	return 0;
}
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5e                   	pop    %esi
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016c1:	f3 0f 1e fb          	endbr32 
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	53                   	push   %ebx
  8016c9:	83 ec 0c             	sub    $0xc,%esp
  8016cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016cf:	53                   	push   %ebx
  8016d0:	6a 00                	push   $0x0
  8016d2:	e8 7d f5 ff ff       	call   800c54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 17 f7 ff ff       	call   800df6 <fd2data>
  8016df:	83 c4 08             	add    $0x8,%esp
  8016e2:	50                   	push   %eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 6a f5 ff ff       	call   800c54 <sys_page_unmap>
}
  8016ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <_pipeisclosed>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	57                   	push   %edi
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 1c             	sub    $0x1c,%esp
  8016f8:	89 c7                	mov    %eax,%edi
  8016fa:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016fc:	a1 04 40 80 00       	mov    0x804004,%eax
  801701:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801704:	83 ec 0c             	sub    $0xc,%esp
  801707:	57                   	push   %edi
  801708:	e8 5f 05 00 00       	call   801c6c <pageref>
  80170d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801710:	89 34 24             	mov    %esi,(%esp)
  801713:	e8 54 05 00 00       	call   801c6c <pageref>
		nn = thisenv->env_runs;
  801718:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80171e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	39 cb                	cmp    %ecx,%ebx
  801726:	74 1b                	je     801743 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801728:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80172b:	75 cf                	jne    8016fc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80172d:	8b 42 58             	mov    0x58(%edx),%eax
  801730:	6a 01                	push   $0x1
  801732:	50                   	push   %eax
  801733:	53                   	push   %ebx
  801734:	68 03 24 80 00       	push   $0x802403
  801739:	e8 d2 ea ff ff       	call   800210 <cprintf>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	eb b9                	jmp    8016fc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801743:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801746:	0f 94 c0             	sete   %al
  801749:	0f b6 c0             	movzbl %al,%eax
}
  80174c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <devpipe_write>:
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 28             	sub    $0x28,%esp
  801761:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801764:	56                   	push   %esi
  801765:	e8 8c f6 ff ff       	call   800df6 <fd2data>
  80176a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	bf 00 00 00 00       	mov    $0x0,%edi
  801774:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801777:	74 4f                	je     8017c8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801779:	8b 43 04             	mov    0x4(%ebx),%eax
  80177c:	8b 0b                	mov    (%ebx),%ecx
  80177e:	8d 51 20             	lea    0x20(%ecx),%edx
  801781:	39 d0                	cmp    %edx,%eax
  801783:	72 14                	jb     801799 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801785:	89 da                	mov    %ebx,%edx
  801787:	89 f0                	mov    %esi,%eax
  801789:	e8 61 ff ff ff       	call   8016ef <_pipeisclosed>
  80178e:	85 c0                	test   %eax,%eax
  801790:	75 3b                	jne    8017cd <devpipe_write+0x79>
			sys_yield();
  801792:	e8 40 f4 ff ff       	call   800bd7 <sys_yield>
  801797:	eb e0                	jmp    801779 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017a0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017a3:	89 c2                	mov    %eax,%edx
  8017a5:	c1 fa 1f             	sar    $0x1f,%edx
  8017a8:	89 d1                	mov    %edx,%ecx
  8017aa:	c1 e9 1b             	shr    $0x1b,%ecx
  8017ad:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017b0:	83 e2 1f             	and    $0x1f,%edx
  8017b3:	29 ca                	sub    %ecx,%edx
  8017b5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017b9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017bd:	83 c0 01             	add    $0x1,%eax
  8017c0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017c3:	83 c7 01             	add    $0x1,%edi
  8017c6:	eb ac                	jmp    801774 <devpipe_write+0x20>
	return i;
  8017c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cb:	eb 05                	jmp    8017d2 <devpipe_write+0x7e>
				return 0;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <devpipe_read>:
{
  8017da:	f3 0f 1e fb          	endbr32 
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	57                   	push   %edi
  8017e2:	56                   	push   %esi
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 18             	sub    $0x18,%esp
  8017e7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017ea:	57                   	push   %edi
  8017eb:	e8 06 f6 ff ff       	call   800df6 <fd2data>
  8017f0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	be 00 00 00 00       	mov    $0x0,%esi
  8017fa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017fd:	75 14                	jne    801813 <devpipe_read+0x39>
	return i;
  8017ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801802:	eb 02                	jmp    801806 <devpipe_read+0x2c>
				return i;
  801804:	89 f0                	mov    %esi,%eax
}
  801806:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801809:	5b                   	pop    %ebx
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    
			sys_yield();
  80180e:	e8 c4 f3 ff ff       	call   800bd7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801813:	8b 03                	mov    (%ebx),%eax
  801815:	3b 43 04             	cmp    0x4(%ebx),%eax
  801818:	75 18                	jne    801832 <devpipe_read+0x58>
			if (i > 0)
  80181a:	85 f6                	test   %esi,%esi
  80181c:	75 e6                	jne    801804 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80181e:	89 da                	mov    %ebx,%edx
  801820:	89 f8                	mov    %edi,%eax
  801822:	e8 c8 fe ff ff       	call   8016ef <_pipeisclosed>
  801827:	85 c0                	test   %eax,%eax
  801829:	74 e3                	je     80180e <devpipe_read+0x34>
				return 0;
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	eb d4                	jmp    801806 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801832:	99                   	cltd   
  801833:	c1 ea 1b             	shr    $0x1b,%edx
  801836:	01 d0                	add    %edx,%eax
  801838:	83 e0 1f             	and    $0x1f,%eax
  80183b:	29 d0                	sub    %edx,%eax
  80183d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801845:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801848:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80184b:	83 c6 01             	add    $0x1,%esi
  80184e:	eb aa                	jmp    8017fa <devpipe_read+0x20>

00801850 <pipe>:
{
  801850:	f3 0f 1e fb          	endbr32 
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
  801859:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80185c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185f:	50                   	push   %eax
  801860:	e8 b0 f5 ff ff       	call   800e15 <fd_alloc>
  801865:	89 c3                	mov    %eax,%ebx
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	0f 88 23 01 00 00    	js     801995 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 07 04 00 00       	push   $0x407
  80187a:	ff 75 f4             	pushl  -0xc(%ebp)
  80187d:	6a 00                	push   $0x0
  80187f:	e8 7e f3 ff ff       	call   800c02 <sys_page_alloc>
  801884:	89 c3                	mov    %eax,%ebx
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	0f 88 04 01 00 00    	js     801995 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801897:	50                   	push   %eax
  801898:	e8 78 f5 ff ff       	call   800e15 <fd_alloc>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	0f 88 db 00 00 00    	js     801985 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 07 04 00 00       	push   $0x407
  8018b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 46 f3 ff ff       	call   800c02 <sys_page_alloc>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 88 bc 00 00 00    	js     801985 <pipe+0x135>
	va = fd2data(fd0);
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cf:	e8 22 f5 ff ff       	call   800df6 <fd2data>
  8018d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d6:	83 c4 0c             	add    $0xc,%esp
  8018d9:	68 07 04 00 00       	push   $0x407
  8018de:	50                   	push   %eax
  8018df:	6a 00                	push   $0x0
  8018e1:	e8 1c f3 ff ff       	call   800c02 <sys_page_alloc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	0f 88 82 00 00 00    	js     801975 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f9:	e8 f8 f4 ff ff       	call   800df6 <fd2data>
  8018fe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801905:	50                   	push   %eax
  801906:	6a 00                	push   $0x0
  801908:	56                   	push   %esi
  801909:	6a 00                	push   $0x0
  80190b:	e8 1a f3 ff ff       	call   800c2a <sys_page_map>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	83 c4 20             	add    $0x20,%esp
  801915:	85 c0                	test   %eax,%eax
  801917:	78 4e                	js     801967 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801919:	a1 20 30 80 00       	mov    0x803020,%eax
  80191e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801921:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801926:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80192d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801930:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 f4             	pushl  -0xc(%ebp)
  801942:	e8 9b f4 ff ff       	call   800de2 <fd2num>
  801947:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80194c:	83 c4 04             	add    $0x4,%esp
  80194f:	ff 75 f0             	pushl  -0x10(%ebp)
  801952:	e8 8b f4 ff ff       	call   800de2 <fd2num>
  801957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	bb 00 00 00 00       	mov    $0x0,%ebx
  801965:	eb 2e                	jmp    801995 <pipe+0x145>
	sys_page_unmap(0, va);
  801967:	83 ec 08             	sub    $0x8,%esp
  80196a:	56                   	push   %esi
  80196b:	6a 00                	push   $0x0
  80196d:	e8 e2 f2 ff ff       	call   800c54 <sys_page_unmap>
  801972:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	ff 75 f0             	pushl  -0x10(%ebp)
  80197b:	6a 00                	push   $0x0
  80197d:	e8 d2 f2 ff ff       	call   800c54 <sys_page_unmap>
  801982:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801985:	83 ec 08             	sub    $0x8,%esp
  801988:	ff 75 f4             	pushl  -0xc(%ebp)
  80198b:	6a 00                	push   $0x0
  80198d:	e8 c2 f2 ff ff       	call   800c54 <sys_page_unmap>
  801992:	83 c4 10             	add    $0x10,%esp
}
  801995:	89 d8                	mov    %ebx,%eax
  801997:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199a:	5b                   	pop    %ebx
  80199b:	5e                   	pop    %esi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <pipeisclosed>:
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ab:	50                   	push   %eax
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	e8 b7 f4 ff ff       	call   800e6b <fd_lookup>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 18                	js     8019d3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	e8 30 f4 ff ff       	call   800df6 <fd2data>
  8019c6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cb:	e8 1f fd ff ff       	call   8016ef <_pipeisclosed>
  8019d0:	83 c4 10             	add    $0x10,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019d5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019de:	c3                   	ret    

008019df <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019df:	f3 0f 1e fb          	endbr32 
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019e9:	68 1b 24 80 00       	push   $0x80241b
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	e8 84 ed ff ff       	call   80077a <strcpy>
	return 0;
}
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <devcons_write>:
{
  8019fd:	f3 0f 1e fb          	endbr32 
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	57                   	push   %edi
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
  801a07:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a0d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a12:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a18:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a1b:	73 31                	jae    801a4e <devcons_write+0x51>
		m = n - tot;
  801a1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a20:	29 f3                	sub    %esi,%ebx
  801a22:	83 fb 7f             	cmp    $0x7f,%ebx
  801a25:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a2a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	53                   	push   %ebx
  801a31:	89 f0                	mov    %esi,%eax
  801a33:	03 45 0c             	add    0xc(%ebp),%eax
  801a36:	50                   	push   %eax
  801a37:	57                   	push   %edi
  801a38:	e8 f5 ee ff ff       	call   800932 <memmove>
		sys_cputs(buf, m);
  801a3d:	83 c4 08             	add    $0x8,%esp
  801a40:	53                   	push   %ebx
  801a41:	57                   	push   %edi
  801a42:	e8 f0 f0 ff ff       	call   800b37 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a47:	01 de                	add    %ebx,%esi
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	eb ca                	jmp    801a18 <devcons_write+0x1b>
}
  801a4e:	89 f0                	mov    %esi,%eax
  801a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <devcons_read>:
{
  801a58:	f3 0f 1e fb          	endbr32 
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a6b:	74 21                	je     801a8e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a6d:	e8 ef f0 ff ff       	call   800b61 <sys_cgetc>
  801a72:	85 c0                	test   %eax,%eax
  801a74:	75 07                	jne    801a7d <devcons_read+0x25>
		sys_yield();
  801a76:	e8 5c f1 ff ff       	call   800bd7 <sys_yield>
  801a7b:	eb f0                	jmp    801a6d <devcons_read+0x15>
	if (c < 0)
  801a7d:	78 0f                	js     801a8e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a7f:	83 f8 04             	cmp    $0x4,%eax
  801a82:	74 0c                	je     801a90 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	88 02                	mov    %al,(%edx)
	return 1;
  801a89:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    
		return 0;
  801a90:	b8 00 00 00 00       	mov    $0x0,%eax
  801a95:	eb f7                	jmp    801a8e <devcons_read+0x36>

00801a97 <cputchar>:
{
  801a97:	f3 0f 1e fb          	endbr32 
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801aa7:	6a 01                	push   $0x1
  801aa9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aac:	50                   	push   %eax
  801aad:	e8 85 f0 ff ff       	call   800b37 <sys_cputs>
}
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <getchar>:
{
  801ab7:	f3 0f 1e fb          	endbr32 
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ac1:	6a 01                	push   $0x1
  801ac3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ac6:	50                   	push   %eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	e8 20 f6 ff ff       	call   8010ee <read>
	if (r < 0)
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	78 06                	js     801adb <getchar+0x24>
	if (r < 1)
  801ad5:	74 06                	je     801add <getchar+0x26>
	return c;
  801ad7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    
		return -E_EOF;
  801add:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ae2:	eb f7                	jmp    801adb <getchar+0x24>

00801ae4 <iscons>:
{
  801ae4:	f3 0f 1e fb          	endbr32 
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	ff 75 08             	pushl  0x8(%ebp)
  801af5:	e8 71 f3 ff ff       	call   800e6b <fd_lookup>
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 11                	js     801b12 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b04:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b0a:	39 10                	cmp    %edx,(%eax)
  801b0c:	0f 94 c0             	sete   %al
  801b0f:	0f b6 c0             	movzbl %al,%eax
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <opencons>:
{
  801b14:	f3 0f 1e fb          	endbr32 
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b21:	50                   	push   %eax
  801b22:	e8 ee f2 ff ff       	call   800e15 <fd_alloc>
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 3a                	js     801b68 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	68 07 04 00 00       	push   $0x407
  801b36:	ff 75 f4             	pushl  -0xc(%ebp)
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 c2 f0 ff ff       	call   800c02 <sys_page_alloc>
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 21                	js     801b68 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b50:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b55:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b5c:	83 ec 0c             	sub    $0xc,%esp
  801b5f:	50                   	push   %eax
  801b60:	e8 7d f2 ff ff       	call   800de2 <fd2num>
  801b65:	83 c4 10             	add    $0x10,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b6a:	f3 0f 1e fb          	endbr32 
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	8b 75 08             	mov    0x8(%ebp),%esi
  801b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b83:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b86:	83 ec 0c             	sub    $0xc,%esp
  801b89:	50                   	push   %eax
  801b8a:	e8 8a f1 ff ff       	call   800d19 <sys_ipc_recv>
	if (r < 0) {
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 2b                	js     801bc1 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b96:	85 f6                	test   %esi,%esi
  801b98:	74 0a                	je     801ba4 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b9f:	8b 40 74             	mov    0x74(%eax),%eax
  801ba2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801ba4:	85 db                	test   %ebx,%ebx
  801ba6:	74 0a                	je     801bb2 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801ba8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bad:	8b 40 78             	mov    0x78(%eax),%eax
  801bb0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801bb2:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5e                   	pop    %esi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    
		if (from_env_store) {
  801bc1:	85 f6                	test   %esi,%esi
  801bc3:	74 06                	je     801bcb <ipc_recv+0x61>
			*from_env_store = 0;
  801bc5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801bcb:	85 db                	test   %ebx,%ebx
  801bcd:	74 eb                	je     801bba <ipc_recv+0x50>
			*perm_store = 0;
  801bcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bd5:	eb e3                	jmp    801bba <ipc_recv+0x50>

00801bd7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bd7:	f3 0f 1e fb          	endbr32 
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	57                   	push   %edi
  801bdf:	56                   	push   %esi
  801be0:	53                   	push   %ebx
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801be7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801bed:	85 db                	test   %ebx,%ebx
  801bef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bf4:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801bf7:	ff 75 14             	pushl  0x14(%ebp)
  801bfa:	53                   	push   %ebx
  801bfb:	56                   	push   %esi
  801bfc:	57                   	push   %edi
  801bfd:	e8 ee f0 ff ff       	call   800cf0 <sys_ipc_try_send>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c08:	75 07                	jne    801c11 <ipc_send+0x3a>
		sys_yield();
  801c0a:	e8 c8 ef ff ff       	call   800bd7 <sys_yield>
  801c0f:	eb e6                	jmp    801bf7 <ipc_send+0x20>
	}

	if (ret < 0) {
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 08                	js     801c1d <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801c1d:	50                   	push   %eax
  801c1e:	68 27 24 80 00       	push   $0x802427
  801c23:	6a 48                	push   $0x48
  801c25:	68 44 24 80 00       	push   $0x802444
  801c2a:	e8 fa e4 ff ff       	call   800129 <_panic>

00801c2f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c2f:	f3 0f 1e fb          	endbr32 
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c3e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c41:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c47:	8b 52 50             	mov    0x50(%edx),%edx
  801c4a:	39 ca                	cmp    %ecx,%edx
  801c4c:	74 11                	je     801c5f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c4e:	83 c0 01             	add    $0x1,%eax
  801c51:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c56:	75 e6                	jne    801c3e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c58:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5d:	eb 0b                	jmp    801c6a <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c5f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c62:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c67:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    

00801c6c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c6c:	f3 0f 1e fb          	endbr32 
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c76:	89 c2                	mov    %eax,%edx
  801c78:	c1 ea 16             	shr    $0x16,%edx
  801c7b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c82:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c87:	f6 c1 01             	test   $0x1,%cl
  801c8a:	74 1c                	je     801ca8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c8c:	c1 e8 0c             	shr    $0xc,%eax
  801c8f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c96:	a8 01                	test   $0x1,%al
  801c98:	74 0e                	je     801ca8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c9a:	c1 e8 0c             	shr    $0xc,%eax
  801c9d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ca4:	ef 
  801ca5:	0f b7 d2             	movzwl %dx,%edx
}
  801ca8:	89 d0                	mov    %edx,%eax
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	66 90                	xchg   %ax,%ax
  801cae:	66 90                	xchg   %ax,%ax

00801cb0 <__udivdi3>:
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 1c             	sub    $0x1c,%esp
  801cbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	75 19                	jne    801ce8 <__udivdi3+0x38>
  801ccf:	39 f3                	cmp    %esi,%ebx
  801cd1:	76 4d                	jbe    801d20 <__udivdi3+0x70>
  801cd3:	31 ff                	xor    %edi,%edi
  801cd5:	89 e8                	mov    %ebp,%eax
  801cd7:	89 f2                	mov    %esi,%edx
  801cd9:	f7 f3                	div    %ebx
  801cdb:	89 fa                	mov    %edi,%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	39 f2                	cmp    %esi,%edx
  801cea:	76 14                	jbe    801d00 <__udivdi3+0x50>
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	31 c0                	xor    %eax,%eax
  801cf0:	89 fa                	mov    %edi,%edx
  801cf2:	83 c4 1c             	add    $0x1c,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
  801cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d00:	0f bd fa             	bsr    %edx,%edi
  801d03:	83 f7 1f             	xor    $0x1f,%edi
  801d06:	75 48                	jne    801d50 <__udivdi3+0xa0>
  801d08:	39 f2                	cmp    %esi,%edx
  801d0a:	72 06                	jb     801d12 <__udivdi3+0x62>
  801d0c:	31 c0                	xor    %eax,%eax
  801d0e:	39 eb                	cmp    %ebp,%ebx
  801d10:	77 de                	ja     801cf0 <__udivdi3+0x40>
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	eb d7                	jmp    801cf0 <__udivdi3+0x40>
  801d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d20:	89 d9                	mov    %ebx,%ecx
  801d22:	85 db                	test   %ebx,%ebx
  801d24:	75 0b                	jne    801d31 <__udivdi3+0x81>
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	f7 f3                	div    %ebx
  801d2f:	89 c1                	mov    %eax,%ecx
  801d31:	31 d2                	xor    %edx,%edx
  801d33:	89 f0                	mov    %esi,%eax
  801d35:	f7 f1                	div    %ecx
  801d37:	89 c6                	mov    %eax,%esi
  801d39:	89 e8                	mov    %ebp,%eax
  801d3b:	89 f7                	mov    %esi,%edi
  801d3d:	f7 f1                	div    %ecx
  801d3f:	89 fa                	mov    %edi,%edx
  801d41:	83 c4 1c             	add    $0x1c,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	b8 20 00 00 00       	mov    $0x20,%eax
  801d57:	29 f8                	sub    %edi,%eax
  801d59:	d3 e2                	shl    %cl,%edx
  801d5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d5f:	89 c1                	mov    %eax,%ecx
  801d61:	89 da                	mov    %ebx,%edx
  801d63:	d3 ea                	shr    %cl,%edx
  801d65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d69:	09 d1                	or     %edx,%ecx
  801d6b:	89 f2                	mov    %esi,%edx
  801d6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d71:	89 f9                	mov    %edi,%ecx
  801d73:	d3 e3                	shl    %cl,%ebx
  801d75:	89 c1                	mov    %eax,%ecx
  801d77:	d3 ea                	shr    %cl,%edx
  801d79:	89 f9                	mov    %edi,%ecx
  801d7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d7f:	89 eb                	mov    %ebp,%ebx
  801d81:	d3 e6                	shl    %cl,%esi
  801d83:	89 c1                	mov    %eax,%ecx
  801d85:	d3 eb                	shr    %cl,%ebx
  801d87:	09 de                	or     %ebx,%esi
  801d89:	89 f0                	mov    %esi,%eax
  801d8b:	f7 74 24 08          	divl   0x8(%esp)
  801d8f:	89 d6                	mov    %edx,%esi
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	f7 64 24 0c          	mull   0xc(%esp)
  801d97:	39 d6                	cmp    %edx,%esi
  801d99:	72 15                	jb     801db0 <__udivdi3+0x100>
  801d9b:	89 f9                	mov    %edi,%ecx
  801d9d:	d3 e5                	shl    %cl,%ebp
  801d9f:	39 c5                	cmp    %eax,%ebp
  801da1:	73 04                	jae    801da7 <__udivdi3+0xf7>
  801da3:	39 d6                	cmp    %edx,%esi
  801da5:	74 09                	je     801db0 <__udivdi3+0x100>
  801da7:	89 d8                	mov    %ebx,%eax
  801da9:	31 ff                	xor    %edi,%edi
  801dab:	e9 40 ff ff ff       	jmp    801cf0 <__udivdi3+0x40>
  801db0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801db3:	31 ff                	xor    %edi,%edi
  801db5:	e9 36 ff ff ff       	jmp    801cf0 <__udivdi3+0x40>
  801dba:	66 90                	xchg   %ax,%ax
  801dbc:	66 90                	xchg   %ax,%ax
  801dbe:	66 90                	xchg   %ax,%ax

00801dc0 <__umoddi3>:
  801dc0:	f3 0f 1e fb          	endbr32 
  801dc4:	55                   	push   %ebp
  801dc5:	57                   	push   %edi
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 1c             	sub    $0x1c,%esp
  801dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dcf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801dd3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	75 19                	jne    801df8 <__umoddi3+0x38>
  801ddf:	39 df                	cmp    %ebx,%edi
  801de1:	76 5d                	jbe    801e40 <__umoddi3+0x80>
  801de3:	89 f0                	mov    %esi,%eax
  801de5:	89 da                	mov    %ebx,%edx
  801de7:	f7 f7                	div    %edi
  801de9:	89 d0                	mov    %edx,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	83 c4 1c             	add    $0x1c,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5f                   	pop    %edi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	89 f2                	mov    %esi,%edx
  801dfa:	39 d8                	cmp    %ebx,%eax
  801dfc:	76 12                	jbe    801e10 <__umoddi3+0x50>
  801dfe:	89 f0                	mov    %esi,%eax
  801e00:	89 da                	mov    %ebx,%edx
  801e02:	83 c4 1c             	add    $0x1c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
  801e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e10:	0f bd e8             	bsr    %eax,%ebp
  801e13:	83 f5 1f             	xor    $0x1f,%ebp
  801e16:	75 50                	jne    801e68 <__umoddi3+0xa8>
  801e18:	39 d8                	cmp    %ebx,%eax
  801e1a:	0f 82 e0 00 00 00    	jb     801f00 <__umoddi3+0x140>
  801e20:	89 d9                	mov    %ebx,%ecx
  801e22:	39 f7                	cmp    %esi,%edi
  801e24:	0f 86 d6 00 00 00    	jbe    801f00 <__umoddi3+0x140>
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	89 ca                	mov    %ecx,%edx
  801e2e:	83 c4 1c             	add    $0x1c,%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5f                   	pop    %edi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    
  801e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e3d:	8d 76 00             	lea    0x0(%esi),%esi
  801e40:	89 fd                	mov    %edi,%ebp
  801e42:	85 ff                	test   %edi,%edi
  801e44:	75 0b                	jne    801e51 <__umoddi3+0x91>
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f7                	div    %edi
  801e4f:	89 c5                	mov    %eax,%ebp
  801e51:	89 d8                	mov    %ebx,%eax
  801e53:	31 d2                	xor    %edx,%edx
  801e55:	f7 f5                	div    %ebp
  801e57:	89 f0                	mov    %esi,%eax
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	31 d2                	xor    %edx,%edx
  801e5f:	eb 8c                	jmp    801ded <__umoddi3+0x2d>
  801e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e68:	89 e9                	mov    %ebp,%ecx
  801e6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e6f:	29 ea                	sub    %ebp,%edx
  801e71:	d3 e0                	shl    %cl,%eax
  801e73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e77:	89 d1                	mov    %edx,%ecx
  801e79:	89 f8                	mov    %edi,%eax
  801e7b:	d3 e8                	shr    %cl,%eax
  801e7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e89:	09 c1                	or     %eax,%ecx
  801e8b:	89 d8                	mov    %ebx,%eax
  801e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 e7                	shl    %cl,%edi
  801e95:	89 d1                	mov    %edx,%ecx
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e9f:	d3 e3                	shl    %cl,%ebx
  801ea1:	89 c7                	mov    %eax,%edi
  801ea3:	89 d1                	mov    %edx,%ecx
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	d3 e8                	shr    %cl,%eax
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	89 fa                	mov    %edi,%edx
  801ead:	d3 e6                	shl    %cl,%esi
  801eaf:	09 d8                	or     %ebx,%eax
  801eb1:	f7 74 24 08          	divl   0x8(%esp)
  801eb5:	89 d1                	mov    %edx,%ecx
  801eb7:	89 f3                	mov    %esi,%ebx
  801eb9:	f7 64 24 0c          	mull   0xc(%esp)
  801ebd:	89 c6                	mov    %eax,%esi
  801ebf:	89 d7                	mov    %edx,%edi
  801ec1:	39 d1                	cmp    %edx,%ecx
  801ec3:	72 06                	jb     801ecb <__umoddi3+0x10b>
  801ec5:	75 10                	jne    801ed7 <__umoddi3+0x117>
  801ec7:	39 c3                	cmp    %eax,%ebx
  801ec9:	73 0c                	jae    801ed7 <__umoddi3+0x117>
  801ecb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ecf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ed3:	89 d7                	mov    %edx,%edi
  801ed5:	89 c6                	mov    %eax,%esi
  801ed7:	89 ca                	mov    %ecx,%edx
  801ed9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ede:	29 f3                	sub    %esi,%ebx
  801ee0:	19 fa                	sbb    %edi,%edx
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	d3 e0                	shl    %cl,%eax
  801ee6:	89 e9                	mov    %ebp,%ecx
  801ee8:	d3 eb                	shr    %cl,%ebx
  801eea:	d3 ea                	shr    %cl,%edx
  801eec:	09 d8                	or     %ebx,%eax
  801eee:	83 c4 1c             	add    $0x1c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
  801ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801efd:	8d 76 00             	lea    0x0(%esi),%esi
  801f00:	29 fe                	sub    %edi,%esi
  801f02:	19 c3                	sbb    %eax,%ebx
  801f04:	89 f2                	mov    %esi,%edx
  801f06:	89 d9                	mov    %ebx,%ecx
  801f08:	e9 1d ff ff ff       	jmp    801e2a <__umoddi3+0x6a>
