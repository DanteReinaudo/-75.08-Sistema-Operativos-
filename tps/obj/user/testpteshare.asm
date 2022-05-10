
obj/user/testpteshare.debug:     formato del fichero elf32-i386


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
  80002c:	e8 71 01 00 00       	call   8001a2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <breakpoint>:
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800035:	f3 0f 1e fb          	endbr32 
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80003f:	ff 35 00 40 80 00    	pushl  0x804000
  800045:	68 00 00 00 a0       	push   $0xa0000000
  80004a:	e8 10 08 00 00       	call   80085f <strcpy>
	exit();
  80004f:	e8 9c 01 00 00       	call   8001f0 <exit>
}
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:
{
  800059:	f3 0f 1e fb          	endbr32 
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	53                   	push   %ebx
  800061:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  800064:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800068:	0f 85 d4 00 00 00    	jne    800142 <umain+0xe9>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80006e:	83 ec 04             	sub    $0x4,%esp
  800071:	68 07 04 00 00       	push   $0x407
  800076:	68 00 00 00 a0       	push   $0xa0000000
  80007b:	6a 00                	push   $0x0
  80007d:	e8 65 0c 00 00       	call   800ce7 <sys_page_alloc>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	85 c0                	test   %eax,%eax
  800087:	0f 88 bf 00 00 00    	js     80014c <umain+0xf3>
	if ((r = fork()) < 0)
  80008d:	e8 15 11 00 00       	call   8011a7 <fork>
  800092:	89 c3                	mov    %eax,%ebx
  800094:	85 c0                	test   %eax,%eax
  800096:	0f 88 c2 00 00 00    	js     80015e <umain+0x105>
	if (r == 0) {
  80009c:	0f 84 ce 00 00 00    	je     800170 <umain+0x117>
	wait(r);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	e8 d5 23 00 00       	call   802480 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000ab:	83 c4 08             	add    $0x8,%esp
  8000ae:	ff 35 04 40 80 00    	pushl  0x804004
  8000b4:	68 00 00 00 a0       	push   $0xa0000000
  8000b9:	e8 60 08 00 00       	call   80091e <strcmp>
  8000be:	83 c4 08             	add    $0x8,%esp
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	b8 c0 2a 80 00       	mov    $0x802ac0,%eax
  8000c8:	ba c6 2a 80 00       	mov    $0x802ac6,%edx
  8000cd:	0f 45 c2             	cmovne %edx,%eax
  8000d0:	50                   	push   %eax
  8000d1:	68 f3 2a 80 00       	push   $0x802af3
  8000d6:	e8 1a 02 00 00       	call   8002f5 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000db:	6a 00                	push   $0x0
  8000dd:	68 0e 2b 80 00       	push   $0x802b0e
  8000e2:	68 13 2b 80 00       	push   $0x802b13
  8000e7:	68 12 2b 80 00       	push   $0x802b12
  8000ec:	e8 77 1f 00 00       	call   802068 <spawnl>
  8000f1:	83 c4 20             	add    $0x20,%esp
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	0f 88 94 00 00 00    	js     800190 <umain+0x137>
	wait(r);
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	50                   	push   %eax
  800100:	e8 7b 23 00 00       	call   802480 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800105:	83 c4 08             	add    $0x8,%esp
  800108:	ff 35 00 40 80 00    	pushl  0x804000
  80010e:	68 00 00 00 a0       	push   $0xa0000000
  800113:	e8 06 08 00 00       	call   80091e <strcmp>
  800118:	83 c4 08             	add    $0x8,%esp
  80011b:	85 c0                	test   %eax,%eax
  80011d:	b8 c0 2a 80 00       	mov    $0x802ac0,%eax
  800122:	ba c6 2a 80 00       	mov    $0x802ac6,%edx
  800127:	0f 45 c2             	cmovne %edx,%eax
  80012a:	50                   	push   %eax
  80012b:	68 2a 2b 80 00       	push   $0x802b2a
  800130:	e8 c0 01 00 00       	call   8002f5 <cprintf>
	breakpoint();
  800135:	e8 f9 fe ff ff       	call   800033 <breakpoint>
}
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800140:	c9                   	leave  
  800141:	c3                   	ret    
		childofspawn();
  800142:	e8 ee fe ff ff       	call   800035 <childofspawn>
  800147:	e9 22 ff ff ff       	jmp    80006e <umain+0x15>
		panic("sys_page_alloc: %e", r);
  80014c:	50                   	push   %eax
  80014d:	68 cc 2a 80 00       	push   $0x802acc
  800152:	6a 13                	push   $0x13
  800154:	68 df 2a 80 00       	push   $0x802adf
  800159:	e8 b0 00 00 00       	call   80020e <_panic>
		panic("fork: %e", r);
  80015e:	50                   	push   %eax
  80015f:	68 34 2f 80 00       	push   $0x802f34
  800164:	6a 17                	push   $0x17
  800166:	68 df 2a 80 00       	push   $0x802adf
  80016b:	e8 9e 00 00 00       	call   80020e <_panic>
		strcpy(VA, msg);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 35 04 40 80 00    	pushl  0x804004
  800179:	68 00 00 00 a0       	push   $0xa0000000
  80017e:	e8 dc 06 00 00       	call   80085f <strcpy>
		exit();
  800183:	e8 68 00 00 00       	call   8001f0 <exit>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	e9 12 ff ff ff       	jmp    8000a2 <umain+0x49>
		panic("spawn: %e", r);
  800190:	50                   	push   %eax
  800191:	68 20 2b 80 00       	push   $0x802b20
  800196:	6a 21                	push   $0x21
  800198:	68 df 2a 80 00       	push   $0x802adf
  80019d:	e8 6c 00 00 00       	call   80020e <_panic>

008001a2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a2:	f3 0f 1e fb          	endbr32 
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ae:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001b1:	e8 de 0a 00 00       	call   800c94 <sys_getenvid>
	if (id >= 0)
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	78 12                	js     8001cc <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8001ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c7:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cc:	85 db                	test   %ebx,%ebx
  8001ce:	7e 07                	jle    8001d7 <libmain+0x35>
		binaryname = argv[0];
  8001d0:	8b 06                	mov    (%esi),%eax
  8001d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	e8 78 fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  8001e1:	e8 0a 00 00 00       	call   8001f0 <exit>
}
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ec:	5b                   	pop    %ebx
  8001ed:	5e                   	pop    %esi
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    

008001f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f0:	f3 0f 1e fb          	endbr32 
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001fa:	e8 e7 12 00 00       	call   8014e6 <close_all>
	sys_env_destroy(0);
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	6a 00                	push   $0x0
  800204:	e8 65 0a 00 00       	call   800c6e <sys_env_destroy>
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	c9                   	leave  
  80020d:	c3                   	ret    

0080020e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80020e:	f3 0f 1e fb          	endbr32 
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800217:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80021a:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800220:	e8 6f 0a 00 00       	call   800c94 <sys_getenvid>
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	ff 75 0c             	pushl  0xc(%ebp)
  80022b:	ff 75 08             	pushl  0x8(%ebp)
  80022e:	56                   	push   %esi
  80022f:	50                   	push   %eax
  800230:	68 70 2b 80 00       	push   $0x802b70
  800235:	e8 bb 00 00 00       	call   8002f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80023a:	83 c4 18             	add    $0x18,%esp
  80023d:	53                   	push   %ebx
  80023e:	ff 75 10             	pushl  0x10(%ebp)
  800241:	e8 5a 00 00 00       	call   8002a0 <vcprintf>
	cprintf("\n");
  800246:	c7 04 24 80 32 80 00 	movl   $0x803280,(%esp)
  80024d:	e8 a3 00 00 00       	call   8002f5 <cprintf>
  800252:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800255:	cc                   	int3   
  800256:	eb fd                	jmp    800255 <_panic+0x47>

00800258 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800258:	f3 0f 1e fb          	endbr32 
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	53                   	push   %ebx
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800266:	8b 13                	mov    (%ebx),%edx
  800268:	8d 42 01             	lea    0x1(%edx),%eax
  80026b:	89 03                	mov    %eax,(%ebx)
  80026d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800270:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800274:	3d ff 00 00 00       	cmp    $0xff,%eax
  800279:	74 09                	je     800284 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80027b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800282:	c9                   	leave  
  800283:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	68 ff 00 00 00       	push   $0xff
  80028c:	8d 43 08             	lea    0x8(%ebx),%eax
  80028f:	50                   	push   %eax
  800290:	e8 87 09 00 00       	call   800c1c <sys_cputs>
		b->idx = 0;
  800295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	eb db                	jmp    80027b <putch+0x23>

008002a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a0:	f3 0f 1e fb          	endbr32 
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b4:	00 00 00 
	b.cnt = 0;
  8002b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002be:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c1:	ff 75 0c             	pushl  0xc(%ebp)
  8002c4:	ff 75 08             	pushl  0x8(%ebp)
  8002c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	68 58 02 80 00       	push   $0x800258
  8002d3:	e8 80 01 00 00       	call   800458 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d8:	83 c4 08             	add    $0x8,%esp
  8002db:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 2f 09 00 00       	call   800c1c <sys_cputs>

	return b.cnt;
}
  8002ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f5:	f3 0f 1e fb          	endbr32 
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800302:	50                   	push   %eax
  800303:	ff 75 08             	pushl  0x8(%ebp)
  800306:	e8 95 ff ff ff       	call   8002a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 1c             	sub    $0x1c,%esp
  800316:	89 c7                	mov    %eax,%edi
  800318:	89 d6                	mov    %edx,%esi
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800320:	89 d1                	mov    %edx,%ecx
  800322:	89 c2                	mov    %eax,%edx
  800324:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800327:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80032a:	8b 45 10             	mov    0x10(%ebp),%eax
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800330:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800333:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80033a:	39 c2                	cmp    %eax,%edx
  80033c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80033f:	72 3e                	jb     80037f <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	ff 75 18             	pushl  0x18(%ebp)
  800347:	83 eb 01             	sub    $0x1,%ebx
  80034a:	53                   	push   %ebx
  80034b:	50                   	push   %eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800352:	ff 75 e0             	pushl  -0x20(%ebp)
  800355:	ff 75 dc             	pushl  -0x24(%ebp)
  800358:	ff 75 d8             	pushl  -0x28(%ebp)
  80035b:	e8 f0 24 00 00       	call   802850 <__udivdi3>
  800360:	83 c4 18             	add    $0x18,%esp
  800363:	52                   	push   %edx
  800364:	50                   	push   %eax
  800365:	89 f2                	mov    %esi,%edx
  800367:	89 f8                	mov    %edi,%eax
  800369:	e8 9f ff ff ff       	call   80030d <printnum>
  80036e:	83 c4 20             	add    $0x20,%esp
  800371:	eb 13                	jmp    800386 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	56                   	push   %esi
  800377:	ff 75 18             	pushl  0x18(%ebp)
  80037a:	ff d7                	call   *%edi
  80037c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	85 db                	test   %ebx,%ebx
  800384:	7f ed                	jg     800373 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	56                   	push   %esi
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800390:	ff 75 e0             	pushl  -0x20(%ebp)
  800393:	ff 75 dc             	pushl  -0x24(%ebp)
  800396:	ff 75 d8             	pushl  -0x28(%ebp)
  800399:	e8 c2 25 00 00       	call   802960 <__umoddi3>
  80039e:	83 c4 14             	add    $0x14,%esp
  8003a1:	0f be 80 93 2b 80 00 	movsbl 0x802b93(%eax),%eax
  8003a8:	50                   	push   %eax
  8003a9:	ff d7                	call   *%edi
}
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b1:	5b                   	pop    %ebx
  8003b2:	5e                   	pop    %esi
  8003b3:	5f                   	pop    %edi
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8003b6:	83 fa 01             	cmp    $0x1,%edx
  8003b9:	7f 13                	jg     8003ce <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8003bb:	85 d2                	test   %edx,%edx
  8003bd:	74 1c                	je     8003db <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8003bf:	8b 10                	mov    (%eax),%edx
  8003c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 02                	mov    (%edx),%eax
  8003c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cd:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8003ce:	8b 10                	mov    (%eax),%edx
  8003d0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003d3:	89 08                	mov    %ecx,(%eax)
  8003d5:	8b 02                	mov    (%edx),%eax
  8003d7:	8b 52 04             	mov    0x4(%edx),%edx
  8003da:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8003db:	8b 10                	mov    (%eax),%edx
  8003dd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e0:	89 08                	mov    %ecx,(%eax)
  8003e2:	8b 02                	mov    (%edx),%eax
  8003e4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e9:	c3                   	ret    

008003ea <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8003ea:	83 fa 01             	cmp    $0x1,%edx
  8003ed:	7f 0f                	jg     8003fe <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8003ef:	85 d2                	test   %edx,%edx
  8003f1:	74 18                	je     80040b <getint+0x21>
		return va_arg(*ap, long);
  8003f3:	8b 10                	mov    (%eax),%edx
  8003f5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f8:	89 08                	mov    %ecx,(%eax)
  8003fa:	8b 02                	mov    (%edx),%eax
  8003fc:	99                   	cltd   
  8003fd:	c3                   	ret    
		return va_arg(*ap, long long);
  8003fe:	8b 10                	mov    (%eax),%edx
  800400:	8d 4a 08             	lea    0x8(%edx),%ecx
  800403:	89 08                	mov    %ecx,(%eax)
  800405:	8b 02                	mov    (%edx),%eax
  800407:	8b 52 04             	mov    0x4(%edx),%edx
  80040a:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80040b:	8b 10                	mov    (%eax),%edx
  80040d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800410:	89 08                	mov    %ecx,(%eax)
  800412:	8b 02                	mov    (%edx),%eax
  800414:	99                   	cltd   
}
  800415:	c3                   	ret    

00800416 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800416:	f3 0f 1e fb          	endbr32 
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800420:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800424:	8b 10                	mov    (%eax),%edx
  800426:	3b 50 04             	cmp    0x4(%eax),%edx
  800429:	73 0a                	jae    800435 <sprintputch+0x1f>
		*b->buf++ = ch;
  80042b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80042e:	89 08                	mov    %ecx,(%eax)
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	88 02                	mov    %al,(%edx)
}
  800435:	5d                   	pop    %ebp
  800436:	c3                   	ret    

00800437 <printfmt>:
{
  800437:	f3 0f 1e fb          	endbr32 
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800441:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800444:	50                   	push   %eax
  800445:	ff 75 10             	pushl  0x10(%ebp)
  800448:	ff 75 0c             	pushl  0xc(%ebp)
  80044b:	ff 75 08             	pushl  0x8(%ebp)
  80044e:	e8 05 00 00 00       	call   800458 <vprintfmt>
}
  800453:	83 c4 10             	add    $0x10,%esp
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <vprintfmt>:
{
  800458:	f3 0f 1e fb          	endbr32 
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	57                   	push   %edi
  800460:	56                   	push   %esi
  800461:	53                   	push   %ebx
  800462:	83 ec 2c             	sub    $0x2c,%esp
  800465:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800468:	8b 75 0c             	mov    0xc(%ebp),%esi
  80046b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80046e:	e9 86 02 00 00       	jmp    8006f9 <vprintfmt+0x2a1>
		padc = ' ';
  800473:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800477:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80047e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800485:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8d 47 01             	lea    0x1(%edi),%eax
  800494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800497:	0f b6 17             	movzbl (%edi),%edx
  80049a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80049d:	3c 55                	cmp    $0x55,%al
  80049f:	0f 87 df 02 00 00    	ja     800784 <vprintfmt+0x32c>
  8004a5:	0f b6 c0             	movzbl %al,%eax
  8004a8:	3e ff 24 85 e0 2c 80 	notrack jmp *0x802ce0(,%eax,4)
  8004af:	00 
  8004b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004b3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004b7:	eb d8                	jmp    800491 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004bc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004c0:	eb cf                	jmp    800491 <vprintfmt+0x39>
  8004c2:	0f b6 d2             	movzbl %dl,%edx
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004d3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004d7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004da:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004dd:	83 f9 09             	cmp    $0x9,%ecx
  8004e0:	77 52                	ja     800534 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8004e2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e5:	eb e9                	jmp    8004d0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8d 50 04             	lea    0x4(%eax),%edx
  8004ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fc:	79 93                	jns    800491 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800501:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800504:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80050b:	eb 84                	jmp    800491 <vprintfmt+0x39>
  80050d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800510:	85 c0                	test   %eax,%eax
  800512:	ba 00 00 00 00       	mov    $0x0,%edx
  800517:	0f 49 d0             	cmovns %eax,%edx
  80051a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800520:	e9 6c ff ff ff       	jmp    800491 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800528:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80052f:	e9 5d ff ff ff       	jmp    800491 <vprintfmt+0x39>
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800537:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80053a:	eb bc                	jmp    8004f8 <vprintfmt+0xa0>
			lflag++;
  80053c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800542:	e9 4a ff ff ff       	jmp    800491 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 50 04             	lea    0x4(%eax),%edx
  80054d:	89 55 14             	mov    %edx,0x14(%ebp)
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	56                   	push   %esi
  800554:	ff 30                	pushl  (%eax)
  800556:	ff d3                	call   *%ebx
			break;
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	e9 96 01 00 00       	jmp    8006f6 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 50 04             	lea    0x4(%eax),%edx
  800566:	89 55 14             	mov    %edx,0x14(%ebp)
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	99                   	cltd   
  80056c:	31 d0                	xor    %edx,%eax
  80056e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800570:	83 f8 0f             	cmp    $0xf,%eax
  800573:	7f 20                	jg     800595 <vprintfmt+0x13d>
  800575:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  80057c:	85 d2                	test   %edx,%edx
  80057e:	74 15                	je     800595 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800580:	52                   	push   %edx
  800581:	68 2b 31 80 00       	push   $0x80312b
  800586:	56                   	push   %esi
  800587:	53                   	push   %ebx
  800588:	e8 aa fe ff ff       	call   800437 <printfmt>
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	e9 61 01 00 00       	jmp    8006f6 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800595:	50                   	push   %eax
  800596:	68 ab 2b 80 00       	push   $0x802bab
  80059b:	56                   	push   %esi
  80059c:	53                   	push   %ebx
  80059d:	e8 95 fe ff ff       	call   800437 <printfmt>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	e9 4c 01 00 00       	jmp    8006f6 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 50 04             	lea    0x4(%eax),%edx
  8005b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005b5:	85 c9                	test   %ecx,%ecx
  8005b7:	b8 a4 2b 80 00       	mov    $0x802ba4,%eax
  8005bc:	0f 45 c1             	cmovne %ecx,%eax
  8005bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c6:	7e 06                	jle    8005ce <vprintfmt+0x176>
  8005c8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005cc:	75 0d                	jne    8005db <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005d1:	89 c7                	mov    %eax,%edi
  8005d3:	03 45 e0             	add    -0x20(%ebp),%eax
  8005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d9:	eb 57                	jmp    800632 <vprintfmt+0x1da>
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	ff 75 d8             	pushl  -0x28(%ebp)
  8005e1:	ff 75 cc             	pushl  -0x34(%ebp)
  8005e4:	e8 4f 02 00 00       	call   800838 <strnlen>
  8005e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ec:	29 c2                	sub    %eax,%edx
  8005ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005f1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005f4:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005f8:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8005fb:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fd:	85 db                	test   %ebx,%ebx
  8005ff:	7e 10                	jle    800611 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	56                   	push   %esi
  800605:	57                   	push   %edi
  800606:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800609:	83 eb 01             	sub    $0x1,%ebx
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	eb ec                	jmp    8005fd <vprintfmt+0x1a5>
  800611:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800614:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	0f 49 c2             	cmovns %edx,%eax
  800621:	29 c2                	sub    %eax,%edx
  800623:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800626:	eb a6                	jmp    8005ce <vprintfmt+0x176>
					putch(ch, putdat);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	56                   	push   %esi
  80062c:	52                   	push   %edx
  80062d:	ff d3                	call   *%ebx
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800635:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800637:	83 c7 01             	add    $0x1,%edi
  80063a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063e:	0f be d0             	movsbl %al,%edx
  800641:	85 d2                	test   %edx,%edx
  800643:	74 42                	je     800687 <vprintfmt+0x22f>
  800645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800649:	78 06                	js     800651 <vprintfmt+0x1f9>
  80064b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80064f:	78 1e                	js     80066f <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800651:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800655:	74 d1                	je     800628 <vprintfmt+0x1d0>
  800657:	0f be c0             	movsbl %al,%eax
  80065a:	83 e8 20             	sub    $0x20,%eax
  80065d:	83 f8 5e             	cmp    $0x5e,%eax
  800660:	76 c6                	jbe    800628 <vprintfmt+0x1d0>
					putch('?', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	56                   	push   %esi
  800666:	6a 3f                	push   $0x3f
  800668:	ff d3                	call   *%ebx
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb c3                	jmp    800632 <vprintfmt+0x1da>
  80066f:	89 cf                	mov    %ecx,%edi
  800671:	eb 0e                	jmp    800681 <vprintfmt+0x229>
				putch(' ', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	56                   	push   %esi
  800677:	6a 20                	push   $0x20
  800679:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  80067b:	83 ef 01             	sub    $0x1,%edi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	85 ff                	test   %edi,%edi
  800683:	7f ee                	jg     800673 <vprintfmt+0x21b>
  800685:	eb 6f                	jmp    8006f6 <vprintfmt+0x29e>
  800687:	89 cf                	mov    %ecx,%edi
  800689:	eb f6                	jmp    800681 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  80068b:	89 ca                	mov    %ecx,%edx
  80068d:	8d 45 14             	lea    0x14(%ebp),%eax
  800690:	e8 55 fd ff ff       	call   8003ea <getint>
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80069b:	85 d2                	test   %edx,%edx
  80069d:	78 0b                	js     8006aa <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80069f:	89 d1                	mov    %edx,%ecx
  8006a1:	89 c2                	mov    %eax,%edx
			base = 10;
  8006a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a8:	eb 32                	jmp    8006dc <vprintfmt+0x284>
				putch('-', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	56                   	push   %esi
  8006ae:	6a 2d                	push   $0x2d
  8006b0:	ff d3                	call   *%ebx
				num = -(long long) num;
  8006b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006b8:	f7 da                	neg    %edx
  8006ba:	83 d1 00             	adc    $0x0,%ecx
  8006bd:	f7 d9                	neg    %ecx
  8006bf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c7:	eb 13                	jmp    8006dc <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006c9:	89 ca                	mov    %ecx,%edx
  8006cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ce:	e8 e3 fc ff ff       	call   8003b6 <getuint>
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	89 c2                	mov    %eax,%edx
			base = 10;
  8006d7:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	51                   	push   %ecx
  8006e9:	52                   	push   %edx
  8006ea:	89 f2                	mov    %esi,%edx
  8006ec:	89 d8                	mov    %ebx,%eax
  8006ee:	e8 1a fc ff ff       	call   80030d <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
{
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	83 c7 01             	add    $0x1,%edi
  8006fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800700:	83 f8 25             	cmp    $0x25,%eax
  800703:	0f 84 6a fd ff ff    	je     800473 <vprintfmt+0x1b>
			if (ch == '\0')
  800709:	85 c0                	test   %eax,%eax
  80070b:	0f 84 93 00 00 00    	je     8007a4 <vprintfmt+0x34c>
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	56                   	push   %esi
  800715:	50                   	push   %eax
  800716:	ff d3                	call   *%ebx
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb dc                	jmp    8006f9 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80071d:	89 ca                	mov    %ecx,%edx
  80071f:	8d 45 14             	lea    0x14(%ebp),%eax
  800722:	e8 8f fc ff ff       	call   8003b6 <getuint>
  800727:	89 d1                	mov    %edx,%ecx
  800729:	89 c2                	mov    %eax,%edx
			base = 8;
  80072b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800730:	eb aa                	jmp    8006dc <vprintfmt+0x284>
			putch('0', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	56                   	push   %esi
  800736:	6a 30                	push   $0x30
  800738:	ff d3                	call   *%ebx
			putch('x', putdat);
  80073a:	83 c4 08             	add    $0x8,%esp
  80073d:	56                   	push   %esi
  80073e:	6a 78                	push   $0x78
  800740:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8d 50 04             	lea    0x4(%eax),%edx
  800748:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80074b:	8b 10                	mov    (%eax),%edx
  80074d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800752:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800755:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80075a:	eb 80                	jmp    8006dc <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80075c:	89 ca                	mov    %ecx,%edx
  80075e:	8d 45 14             	lea    0x14(%ebp),%eax
  800761:	e8 50 fc ff ff       	call   8003b6 <getuint>
  800766:	89 d1                	mov    %edx,%ecx
  800768:	89 c2                	mov    %eax,%edx
			base = 16;
  80076a:	b8 10 00 00 00       	mov    $0x10,%eax
  80076f:	e9 68 ff ff ff       	jmp    8006dc <vprintfmt+0x284>
			putch(ch, putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	56                   	push   %esi
  800778:	6a 25                	push   $0x25
  80077a:	ff d3                	call   *%ebx
			break;
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	e9 72 ff ff ff       	jmp    8006f6 <vprintfmt+0x29e>
			putch('%', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	56                   	push   %esi
  800788:	6a 25                	push   $0x25
  80078a:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 f8                	mov    %edi,%eax
  800791:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800795:	74 05                	je     80079c <vprintfmt+0x344>
  800797:	83 e8 01             	sub    $0x1,%eax
  80079a:	eb f5                	jmp    800791 <vprintfmt+0x339>
  80079c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079f:	e9 52 ff ff ff       	jmp    8006f6 <vprintfmt+0x29e>
}
  8007a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a7:	5b                   	pop    %ebx
  8007a8:	5e                   	pop    %esi
  8007a9:	5f                   	pop    %edi
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cd:	85 c0                	test   %eax,%eax
  8007cf:	74 26                	je     8007f7 <vsnprintf+0x4b>
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	7e 22                	jle    8007f7 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d5:	ff 75 14             	pushl  0x14(%ebp)
  8007d8:	ff 75 10             	pushl  0x10(%ebp)
  8007db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	68 16 04 80 00       	push   $0x800416
  8007e4:	e8 6f fc ff ff       	call   800458 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f2:	83 c4 10             	add    $0x10,%esp
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    
		return -E_INVAL;
  8007f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fc:	eb f7                	jmp    8007f5 <vsnprintf+0x49>

008007fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080b:	50                   	push   %eax
  80080c:	ff 75 10             	pushl  0x10(%ebp)
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	ff 75 08             	pushl  0x8(%ebp)
  800815:	e8 92 ff ff ff       	call   8007ac <vsnprintf>
	va_end(ap);

	return rc;
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80081c:	f3 0f 1e fb          	endbr32 
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082f:	74 05                	je     800836 <strlen+0x1a>
		n++;
  800831:	83 c0 01             	add    $0x1,%eax
  800834:	eb f5                	jmp    80082b <strlen+0xf>
	return n;
}
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800838:	f3 0f 1e fb          	endbr32 
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	39 d0                	cmp    %edx,%eax
  80084c:	74 0d                	je     80085b <strnlen+0x23>
  80084e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800852:	74 05                	je     800859 <strnlen+0x21>
		n++;
  800854:	83 c0 01             	add    $0x1,%eax
  800857:	eb f1                	jmp    80084a <strnlen+0x12>
  800859:	89 c2                	mov    %eax,%edx
	return n;
}
  80085b:	89 d0                	mov    %edx,%eax
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085f:	f3 0f 1e fb          	endbr32 
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	53                   	push   %ebx
  800867:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80086d:	b8 00 00 00 00       	mov    $0x0,%eax
  800872:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800876:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800879:	83 c0 01             	add    $0x1,%eax
  80087c:	84 d2                	test   %dl,%dl
  80087e:	75 f2                	jne    800872 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800880:	89 c8                	mov    %ecx,%eax
  800882:	5b                   	pop    %ebx
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800885:	f3 0f 1e fb          	endbr32 
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	83 ec 10             	sub    $0x10,%esp
  800890:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800893:	53                   	push   %ebx
  800894:	e8 83 ff ff ff       	call   80081c <strlen>
  800899:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	01 d8                	add    %ebx,%eax
  8008a1:	50                   	push   %eax
  8008a2:	e8 b8 ff ff ff       	call   80085f <strcpy>
	return dst;
}
  8008a7:	89 d8                	mov    %ebx,%eax
  8008a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ae:	f3 0f 1e fb          	endbr32 
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f0                	mov    %esi,%eax
  8008c4:	39 d8                	cmp    %ebx,%eax
  8008c6:	74 11                	je     8008d9 <strncpy+0x2b>
		*dst++ = *src;
  8008c8:	83 c0 01             	add    $0x1,%eax
  8008cb:	0f b6 0a             	movzbl (%edx),%ecx
  8008ce:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d1:	80 f9 01             	cmp    $0x1,%cl
  8008d4:	83 da ff             	sbb    $0xffffffff,%edx
  8008d7:	eb eb                	jmp    8008c4 <strncpy+0x16>
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	56                   	push   %esi
  8008e7:	53                   	push   %ebx
  8008e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8008f1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 d2                	test   %edx,%edx
  8008f5:	74 21                	je     800918 <strlcpy+0x39>
  8008f7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008fb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008fd:	39 c2                	cmp    %eax,%edx
  8008ff:	74 14                	je     800915 <strlcpy+0x36>
  800901:	0f b6 19             	movzbl (%ecx),%ebx
  800904:	84 db                	test   %bl,%bl
  800906:	74 0b                	je     800913 <strlcpy+0x34>
			*dst++ = *src++;
  800908:	83 c1 01             	add    $0x1,%ecx
  80090b:	83 c2 01             	add    $0x1,%edx
  80090e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800911:	eb ea                	jmp    8008fd <strlcpy+0x1e>
  800913:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800915:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800918:	29 f0                	sub    %esi,%eax
}
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091e:	f3 0f 1e fb          	endbr32 
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800928:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092b:	0f b6 01             	movzbl (%ecx),%eax
  80092e:	84 c0                	test   %al,%al
  800930:	74 0c                	je     80093e <strcmp+0x20>
  800932:	3a 02                	cmp    (%edx),%al
  800934:	75 08                	jne    80093e <strcmp+0x20>
		p++, q++;
  800936:	83 c1 01             	add    $0x1,%ecx
  800939:	83 c2 01             	add    $0x1,%edx
  80093c:	eb ed                	jmp    80092b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80093e:	0f b6 c0             	movzbl %al,%eax
  800941:	0f b6 12             	movzbl (%edx),%edx
  800944:	29 d0                	sub    %edx,%eax
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 55 0c             	mov    0xc(%ebp),%edx
  800956:	89 c3                	mov    %eax,%ebx
  800958:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80095b:	eb 06                	jmp    800963 <strncmp+0x1b>
		n--, p++, q++;
  80095d:	83 c0 01             	add    $0x1,%eax
  800960:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800963:	39 d8                	cmp    %ebx,%eax
  800965:	74 16                	je     80097d <strncmp+0x35>
  800967:	0f b6 08             	movzbl (%eax),%ecx
  80096a:	84 c9                	test   %cl,%cl
  80096c:	74 04                	je     800972 <strncmp+0x2a>
  80096e:	3a 0a                	cmp    (%edx),%cl
  800970:	74 eb                	je     80095d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800972:	0f b6 00             	movzbl (%eax),%eax
  800975:	0f b6 12             	movzbl (%edx),%edx
  800978:	29 d0                	sub    %edx,%eax
}
  80097a:	5b                   	pop    %ebx
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    
		return 0;
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	eb f6                	jmp    80097a <strncmp+0x32>

00800984 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800984:	f3 0f 1e fb          	endbr32 
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800992:	0f b6 10             	movzbl (%eax),%edx
  800995:	84 d2                	test   %dl,%dl
  800997:	74 09                	je     8009a2 <strchr+0x1e>
		if (*s == c)
  800999:	38 ca                	cmp    %cl,%dl
  80099b:	74 0a                	je     8009a7 <strchr+0x23>
	for (; *s; s++)
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	eb f0                	jmp    800992 <strchr+0xe>
			return (char *) s;
	return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a9:	f3 0f 1e fb          	endbr32 
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ba:	38 ca                	cmp    %cl,%dl
  8009bc:	74 09                	je     8009c7 <strfind+0x1e>
  8009be:	84 d2                	test   %dl,%dl
  8009c0:	74 05                	je     8009c7 <strfind+0x1e>
	for (; *s; s++)
  8009c2:	83 c0 01             	add    $0x1,%eax
  8009c5:	eb f0                	jmp    8009b7 <strfind+0xe>
			break;
	return (char *) s;
}
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c9:	f3 0f 1e fb          	endbr32 
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	57                   	push   %edi
  8009d1:	56                   	push   %esi
  8009d2:	53                   	push   %ebx
  8009d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009d9:	85 c9                	test   %ecx,%ecx
  8009db:	74 33                	je     800a10 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	09 c8                	or     %ecx,%eax
  8009e1:	a8 03                	test   $0x3,%al
  8009e3:	75 23                	jne    800a08 <memset+0x3f>
		c &= 0xFF;
  8009e5:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e9:	89 d8                	mov    %ebx,%eax
  8009eb:	c1 e0 08             	shl    $0x8,%eax
  8009ee:	89 df                	mov    %ebx,%edi
  8009f0:	c1 e7 18             	shl    $0x18,%edi
  8009f3:	89 de                	mov    %ebx,%esi
  8009f5:	c1 e6 10             	shl    $0x10,%esi
  8009f8:	09 f7                	or     %esi,%edi
  8009fa:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009fc:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ff:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800a01:	89 d7                	mov    %edx,%edi
  800a03:	fc                   	cld    
  800a04:	f3 ab                	rep stos %eax,%es:(%edi)
  800a06:	eb 08                	jmp    800a10 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a08:	89 d7                	mov    %edx,%edi
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	fc                   	cld    
  800a0e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a10:	89 d0                	mov    %edx,%eax
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5f                   	pop    %edi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a17:	f3 0f 1e fb          	endbr32 
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	57                   	push   %edi
  800a1f:	56                   	push   %esi
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a29:	39 c6                	cmp    %eax,%esi
  800a2b:	73 32                	jae    800a5f <memmove+0x48>
  800a2d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	76 2b                	jbe    800a5f <memmove+0x48>
		s += n;
		d += n;
  800a34:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a37:	89 fe                	mov    %edi,%esi
  800a39:	09 ce                	or     %ecx,%esi
  800a3b:	09 d6                	or     %edx,%esi
  800a3d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a43:	75 0e                	jne    800a53 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a45:	83 ef 04             	sub    $0x4,%edi
  800a48:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a4e:	fd                   	std    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 09                	jmp    800a5c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a53:	83 ef 01             	sub    $0x1,%edi
  800a56:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a59:	fd                   	std    
  800a5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a5c:	fc                   	cld    
  800a5d:	eb 1a                	jmp    800a79 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	89 c2                	mov    %eax,%edx
  800a61:	09 ca                	or     %ecx,%edx
  800a63:	09 f2                	or     %esi,%edx
  800a65:	f6 c2 03             	test   $0x3,%dl
  800a68:	75 0a                	jne    800a74 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a6d:	89 c7                	mov    %eax,%edi
  800a6f:	fc                   	cld    
  800a70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a72:	eb 05                	jmp    800a79 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a74:	89 c7                	mov    %eax,%edi
  800a76:	fc                   	cld    
  800a77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a79:	5e                   	pop    %esi
  800a7a:	5f                   	pop    %edi
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7d:	f3 0f 1e fb          	endbr32 
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a87:	ff 75 10             	pushl  0x10(%ebp)
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	ff 75 08             	pushl  0x8(%ebp)
  800a90:	e8 82 ff ff ff       	call   800a17 <memmove>
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a97:	f3 0f 1e fb          	endbr32 
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	56                   	push   %esi
  800a9f:	53                   	push   %ebx
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa6:	89 c6                	mov    %eax,%esi
  800aa8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aab:	39 f0                	cmp    %esi,%eax
  800aad:	74 1c                	je     800acb <memcmp+0x34>
		if (*s1 != *s2)
  800aaf:	0f b6 08             	movzbl (%eax),%ecx
  800ab2:	0f b6 1a             	movzbl (%edx),%ebx
  800ab5:	38 d9                	cmp    %bl,%cl
  800ab7:	75 08                	jne    800ac1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	83 c2 01             	add    $0x1,%edx
  800abf:	eb ea                	jmp    800aab <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ac1:	0f b6 c1             	movzbl %cl,%eax
  800ac4:	0f b6 db             	movzbl %bl,%ebx
  800ac7:	29 d8                	sub    %ebx,%eax
  800ac9:	eb 05                	jmp    800ad0 <memcmp+0x39>
	}

	return 0;
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad4:	f3 0f 1e fb          	endbr32 
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ae1:	89 c2                	mov    %eax,%edx
  800ae3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae6:	39 d0                	cmp    %edx,%eax
  800ae8:	73 09                	jae    800af3 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aea:	38 08                	cmp    %cl,(%eax)
  800aec:	74 05                	je     800af3 <memfind+0x1f>
	for (; s < ends; s++)
  800aee:	83 c0 01             	add    $0x1,%eax
  800af1:	eb f3                	jmp    800ae6 <memfind+0x12>
			break;
	return (void *) s;
}
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af5:	f3 0f 1e fb          	endbr32 
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b05:	eb 03                	jmp    800b0a <strtol+0x15>
		s++;
  800b07:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b0a:	0f b6 01             	movzbl (%ecx),%eax
  800b0d:	3c 20                	cmp    $0x20,%al
  800b0f:	74 f6                	je     800b07 <strtol+0x12>
  800b11:	3c 09                	cmp    $0x9,%al
  800b13:	74 f2                	je     800b07 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b15:	3c 2b                	cmp    $0x2b,%al
  800b17:	74 2a                	je     800b43 <strtol+0x4e>
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b1e:	3c 2d                	cmp    $0x2d,%al
  800b20:	74 2b                	je     800b4d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b28:	75 0f                	jne    800b39 <strtol+0x44>
  800b2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2d:	74 28                	je     800b57 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b2f:	85 db                	test   %ebx,%ebx
  800b31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b36:	0f 44 d8             	cmove  %eax,%ebx
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b41:	eb 46                	jmp    800b89 <strtol+0x94>
		s++;
  800b43:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b46:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4b:	eb d5                	jmp    800b22 <strtol+0x2d>
		s++, neg = 1;
  800b4d:	83 c1 01             	add    $0x1,%ecx
  800b50:	bf 01 00 00 00       	mov    $0x1,%edi
  800b55:	eb cb                	jmp    800b22 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b57:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b5b:	74 0e                	je     800b6b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	75 d8                	jne    800b39 <strtol+0x44>
		s++, base = 8;
  800b61:	83 c1 01             	add    $0x1,%ecx
  800b64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b69:	eb ce                	jmp    800b39 <strtol+0x44>
		s += 2, base = 16;
  800b6b:	83 c1 02             	add    $0x2,%ecx
  800b6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b73:	eb c4                	jmp    800b39 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b75:	0f be d2             	movsbl %dl,%edx
  800b78:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b7e:	7d 3a                	jge    800bba <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b80:	83 c1 01             	add    $0x1,%ecx
  800b83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b89:	0f b6 11             	movzbl (%ecx),%edx
  800b8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 09             	cmp    $0x9,%bl
  800b94:	76 df                	jbe    800b75 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b99:	89 f3                	mov    %esi,%ebx
  800b9b:	80 fb 19             	cmp    $0x19,%bl
  800b9e:	77 08                	ja     800ba8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ba0:	0f be d2             	movsbl %dl,%edx
  800ba3:	83 ea 57             	sub    $0x57,%edx
  800ba6:	eb d3                	jmp    800b7b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ba8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bab:	89 f3                	mov    %esi,%ebx
  800bad:	80 fb 19             	cmp    $0x19,%bl
  800bb0:	77 08                	ja     800bba <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bb2:	0f be d2             	movsbl %dl,%edx
  800bb5:	83 ea 37             	sub    $0x37,%edx
  800bb8:	eb c1                	jmp    800b7b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbe:	74 05                	je     800bc5 <strtol+0xd0>
		*endptr = (char *) s;
  800bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	f7 da                	neg    %edx
  800bc9:	85 ff                	test   %edi,%edi
  800bcb:	0f 45 c2             	cmovne %edx,%eax
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 1c             	sub    $0x1c,%esp
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bdf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800be2:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bea:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bed:	8b 75 14             	mov    0x14(%ebp),%esi
  800bf0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf6:	74 04                	je     800bfc <syscall+0x29>
  800bf8:	85 c0                	test   %eax,%eax
  800bfa:	7f 08                	jg     800c04 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800bfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c04:	83 ec 0c             	sub    $0xc,%esp
  800c07:	50                   	push   %eax
  800c08:	ff 75 e0             	pushl  -0x20(%ebp)
  800c0b:	68 9f 2e 80 00       	push   $0x802e9f
  800c10:	6a 23                	push   $0x23
  800c12:	68 bc 2e 80 00       	push   $0x802ebc
  800c17:	e8 f2 f5 ff ff       	call   80020e <_panic>

00800c1c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c1c:	f3 0f 1e fb          	endbr32 
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c26:	6a 00                	push   $0x0
  800c28:	6a 00                	push   $0x0
  800c2a:	6a 00                	push   $0x0
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	e8 92 ff ff ff       	call   800bd3 <syscall>
}
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c46:	f3 0f 1e fb          	endbr32 
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c50:	6a 00                	push   $0x0
  800c52:	6a 00                	push   $0x0
  800c54:	6a 00                	push   $0x0
  800c56:	6a 00                	push   $0x0
  800c58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 01 00 00 00       	mov    $0x1,%eax
  800c67:	e8 67 ff ff ff       	call   800bd3 <syscall>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c78:	6a 00                	push   $0x0
  800c7a:	6a 00                	push   $0x0
  800c7c:	6a 00                	push   $0x0
  800c7e:	6a 00                	push   $0x0
  800c80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c83:	ba 01 00 00 00       	mov    $0x1,%edx
  800c88:	b8 03 00 00 00       	mov    $0x3,%eax
  800c8d:	e8 41 ff ff ff       	call   800bd3 <syscall>
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c94:	f3 0f 1e fb          	endbr32 
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c9e:	6a 00                	push   $0x0
  800ca0:	6a 00                	push   $0x0
  800ca2:	6a 00                	push   $0x0
  800ca4:	6a 00                	push   $0x0
  800ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb5:	e8 19 ff ff ff       	call   800bd3 <syscall>
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <sys_yield>:

void
sys_yield(void)
{
  800cbc:	f3 0f 1e fb          	endbr32 
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cc6:	6a 00                	push   $0x0
  800cc8:	6a 00                	push   $0x0
  800cca:	6a 00                	push   $0x0
  800ccc:	6a 00                	push   $0x0
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdd:	e8 f1 fe ff ff       	call   800bd3 <syscall>
}
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce7:	f3 0f 1e fb          	endbr32 
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cf1:	6a 00                	push   $0x0
  800cf3:	6a 00                	push   $0x0
  800cf5:	ff 75 10             	pushl  0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfe:	ba 01 00 00 00       	mov    $0x1,%edx
  800d03:	b8 04 00 00 00       	mov    $0x4,%eax
  800d08:	e8 c6 fe ff ff       	call   800bd3 <syscall>
}
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d0f:	f3 0f 1e fb          	endbr32 
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d19:	ff 75 18             	pushl  0x18(%ebp)
  800d1c:	ff 75 14             	pushl  0x14(%ebp)
  800d1f:	ff 75 10             	pushl  0x10(%ebp)
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d28:	ba 01 00 00 00       	mov    $0x1,%edx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	e8 9c fe ff ff       	call   800bd3 <syscall>
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d39:	f3 0f 1e fb          	endbr32 
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d43:	6a 00                	push   $0x0
  800d45:	6a 00                	push   $0x0
  800d47:	6a 00                	push   $0x0
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d54:	b8 06 00 00 00       	mov    $0x6,%eax
  800d59:	e8 75 fe ff ff       	call   800bd3 <syscall>
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d6a:	6a 00                	push   $0x0
  800d6c:	6a 00                	push   $0x0
  800d6e:	6a 00                	push   $0x0
  800d70:	ff 75 0c             	pushl  0xc(%ebp)
  800d73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d76:	ba 01 00 00 00       	mov    $0x1,%edx
  800d7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d80:	e8 4e fe ff ff       	call   800bd3 <syscall>
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d87:	f3 0f 1e fb          	endbr32 
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d91:	6a 00                	push   $0x0
  800d93:	6a 00                	push   $0x0
  800d95:	6a 00                	push   $0x0
  800d97:	ff 75 0c             	pushl  0xc(%ebp)
  800d9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9d:	ba 01 00 00 00       	mov    $0x1,%edx
  800da2:	b8 09 00 00 00       	mov    $0x9,%eax
  800da7:	e8 27 fe ff ff       	call   800bd3 <syscall>
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dae:	f3 0f 1e fb          	endbr32 
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800db8:	6a 00                	push   $0x0
  800dba:	6a 00                	push   $0x0
  800dbc:	6a 00                	push   $0x0
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc4:	ba 01 00 00 00       	mov    $0x1,%edx
  800dc9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dce:	e8 00 fe ff ff       	call   800bd3 <syscall>
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd5:	f3 0f 1e fb          	endbr32 
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800ddf:	6a 00                	push   $0x0
  800de1:	ff 75 14             	pushl  0x14(%ebp)
  800de4:	ff 75 10             	pushl  0x10(%ebp)
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df7:	e8 d7 fd ff ff       	call   800bd3 <syscall>
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfe:	f3 0f 1e fb          	endbr32 
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800e08:	6a 00                	push   $0x0
  800e0a:	6a 00                	push   $0x0
  800e0c:	6a 00                	push   $0x0
  800e0e:	6a 00                	push   $0x0
  800e10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e13:	ba 01 00 00 00       	mov    $0x1,%edx
  800e18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e1d:	e8 b1 fd ff ff       	call   800bd3 <syscall>
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	53                   	push   %ebx
  800e28:	83 ec 04             	sub    $0x4,%esp
  800e2b:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800e2d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800e34:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800e37:	f6 c6 04             	test   $0x4,%dh
  800e3a:	75 51                	jne    800e8d <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800e3c:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800e42:	0f 84 84 00 00 00    	je     800ecc <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	68 05 08 00 00       	push   $0x805
  800e50:	53                   	push   %ebx
  800e51:	50                   	push   %eax
  800e52:	53                   	push   %ebx
  800e53:	6a 00                	push   $0x0
  800e55:	e8 b5 fe ff ff       	call   800d0f <sys_page_map>
		if (r)
  800e5a:	83 c4 20             	add    $0x20,%esp
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 59                	jne    800eba <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	68 05 08 00 00       	push   $0x805
  800e69:	53                   	push   %ebx
  800e6a:	6a 00                	push   $0x0
  800e6c:	53                   	push   %ebx
  800e6d:	6a 00                	push   $0x0
  800e6f:	e8 9b fe ff ff       	call   800d0f <sys_page_map>
		if (r)
  800e74:	83 c4 20             	add    $0x20,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	74 67                	je     800ee2 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800e7b:	50                   	push   %eax
  800e7c:	68 ca 2e 80 00       	push   $0x802eca
  800e81:	6a 5f                	push   $0x5f
  800e83:	68 e5 2e 80 00       	push   $0x802ee5
  800e88:	e8 81 f3 ff ff       	call   80020e <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800e96:	52                   	push   %edx
  800e97:	53                   	push   %ebx
  800e98:	50                   	push   %eax
  800e99:	53                   	push   %ebx
  800e9a:	6a 00                	push   $0x0
  800e9c:	e8 6e fe ff ff       	call   800d0f <sys_page_map>
		if (r)
  800ea1:	83 c4 20             	add    $0x20,%esp
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	74 3a                	je     800ee2 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800ea8:	50                   	push   %eax
  800ea9:	68 ca 2e 80 00       	push   $0x802eca
  800eae:	6a 57                	push   $0x57
  800eb0:	68 e5 2e 80 00       	push   $0x802ee5
  800eb5:	e8 54 f3 ff ff       	call   80020e <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800eba:	50                   	push   %eax
  800ebb:	68 ca 2e 80 00       	push   $0x802eca
  800ec0:	6a 5b                	push   $0x5b
  800ec2:	68 e5 2e 80 00       	push   $0x802ee5
  800ec7:	e8 42 f3 ff ff       	call   80020e <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	6a 05                	push   $0x5
  800ed1:	53                   	push   %ebx
  800ed2:	50                   	push   %eax
  800ed3:	53                   	push   %ebx
  800ed4:	6a 00                	push   $0x0
  800ed6:	e8 34 fe ff ff       	call   800d0f <sys_page_map>
		if (r)
  800edb:	83 c4 20             	add    $0x20,%esp
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	75 0a                	jne    800eec <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800eec:	50                   	push   %eax
  800eed:	68 ca 2e 80 00       	push   $0x802eca
  800ef2:	6a 63                	push   $0x63
  800ef4:	68 e5 2e 80 00       	push   $0x802ee5
  800ef9:	e8 10 f3 ff ff       	call   80020e <_panic>

00800efe <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	89 c7                	mov    %eax,%edi
  800f09:	89 d6                	mov    %edx,%esi
  800f0b:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800f0d:	f6 c1 02             	test   $0x2,%cl
  800f10:	75 2f                	jne    800f41 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	51                   	push   %ecx
  800f16:	52                   	push   %edx
  800f17:	50                   	push   %eax
  800f18:	52                   	push   %edx
  800f19:	6a 00                	push   $0x0
  800f1b:	e8 ef fd ff ff       	call   800d0f <sys_page_map>
  800f20:	83 c4 20             	add    $0x20,%esp
  800f23:	85 c0                	test   %eax,%eax
  800f25:	78 08                	js     800f2f <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800f2f:	50                   	push   %eax
  800f30:	68 d4 2e 80 00       	push   $0x802ed4
  800f35:	6a 6f                	push   $0x6f
  800f37:	68 e5 2e 80 00       	push   $0x802ee5
  800f3c:	e8 cd f2 ff ff       	call   80020e <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	51                   	push   %ecx
  800f45:	52                   	push   %edx
  800f46:	50                   	push   %eax
  800f47:	e8 9b fd ff ff       	call   800ce7 <sys_page_alloc>
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 54                	js     800fa7 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800f53:	83 ec 0c             	sub    $0xc,%esp
  800f56:	53                   	push   %ebx
  800f57:	68 00 00 40 00       	push   $0x400000
  800f5c:	6a 00                	push   $0x0
  800f5e:	56                   	push   %esi
  800f5f:	57                   	push   %edi
  800f60:	e8 aa fd ff ff       	call   800d0f <sys_page_map>
  800f65:	83 c4 20             	add    $0x20,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 4d                	js     800fb9 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800f6c:	83 ec 04             	sub    $0x4,%esp
  800f6f:	68 00 10 00 00       	push   $0x1000
  800f74:	56                   	push   %esi
  800f75:	68 00 00 40 00       	push   $0x400000
  800f7a:	e8 98 fa ff ff       	call   800a17 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800f7f:	83 c4 08             	add    $0x8,%esp
  800f82:	68 00 00 40 00       	push   $0x400000
  800f87:	6a 00                	push   $0x0
  800f89:	e8 ab fd ff ff       	call   800d39 <sys_page_unmap>
  800f8e:	83 c4 10             	add    $0x10,%esp
  800f91:	85 c0                	test   %eax,%eax
  800f93:	79 92                	jns    800f27 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800f95:	50                   	push   %eax
  800f96:	68 f0 2e 80 00       	push   $0x802ef0
  800f9b:	6a 78                	push   $0x78
  800f9d:	68 e5 2e 80 00       	push   $0x802ee5
  800fa2:	e8 67 f2 ff ff       	call   80020e <_panic>
		panic("sys_page_alloc: %e", r);
  800fa7:	50                   	push   %eax
  800fa8:	68 cc 2a 80 00       	push   $0x802acc
  800fad:	6a 73                	push   $0x73
  800faf:	68 e5 2e 80 00       	push   $0x802ee5
  800fb4:	e8 55 f2 ff ff       	call   80020e <_panic>
		panic("sys_page_map: %e", r);
  800fb9:	50                   	push   %eax
  800fba:	68 d4 2e 80 00       	push   $0x802ed4
  800fbf:	6a 75                	push   $0x75
  800fc1:	68 e5 2e 80 00       	push   $0x802ee5
  800fc6:	e8 43 f2 ff ff       	call   80020e <_panic>

00800fcb <pgfault>:
{
  800fcb:	f3 0f 1e fb          	endbr32 
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 04             	sub    $0x4,%esp
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fd9:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800fdb:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800fde:	89 da                	mov    %ebx,%edx
  800fe0:	c1 ea 0c             	shr    $0xc,%edx
  800fe3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800fea:	a8 01                	test   $0x1,%al
  800fec:	74 7e                	je     80106c <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800fee:	a8 02                	test   $0x2,%al
  800ff0:	0f 84 8a 00 00 00    	je     801080 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800ff6:	f6 c6 08             	test   $0x8,%dh
  800ff9:	0f 84 95 00 00 00    	je     801094 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800fff:	83 ec 04             	sub    $0x4,%esp
  801002:	6a 07                	push   $0x7
  801004:	68 00 f0 7f 00       	push   $0x7ff000
  801009:	6a 00                	push   $0x0
  80100b:	e8 d7 fc ff ff       	call   800ce7 <sys_page_alloc>
	if (r)
  801010:	83 c4 10             	add    $0x10,%esp
  801013:	85 c0                	test   %eax,%eax
  801015:	0f 85 8d 00 00 00    	jne    8010a8 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80101b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801021:	83 ec 04             	sub    $0x4,%esp
  801024:	68 00 10 00 00       	push   $0x1000
  801029:	53                   	push   %ebx
  80102a:	68 00 f0 7f 00       	push   $0x7ff000
  80102f:	e8 49 fa ff ff       	call   800a7d <memcpy>
	r = sys_page_map(
  801034:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80103b:	53                   	push   %ebx
  80103c:	6a 00                	push   $0x0
  80103e:	68 00 f0 7f 00       	push   $0x7ff000
  801043:	6a 00                	push   $0x0
  801045:	e8 c5 fc ff ff       	call   800d0f <sys_page_map>
	if (r)
  80104a:	83 c4 20             	add    $0x20,%esp
  80104d:	85 c0                	test   %eax,%eax
  80104f:	75 69                	jne    8010ba <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	68 00 f0 7f 00       	push   $0x7ff000
  801059:	6a 00                	push   $0x0
  80105b:	e8 d9 fc ff ff       	call   800d39 <sys_page_unmap>
	if (r)
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	75 65                	jne    8010cc <pgfault+0x101>
}
  801067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  80106c:	83 ec 04             	sub    $0x4,%esp
  80106f:	68 74 2f 80 00       	push   $0x802f74
  801074:	6a 20                	push   $0x20
  801076:	68 e5 2e 80 00       	push   $0x802ee5
  80107b:	e8 8e f1 ff ff       	call   80020e <_panic>
		panic("[pgfault] pgfault por lectura");
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	68 03 2f 80 00       	push   $0x802f03
  801088:	6a 23                	push   $0x23
  80108a:	68 e5 2e 80 00       	push   $0x802ee5
  80108f:	e8 7a f1 ff ff       	call   80020e <_panic>
		panic("[pgfault] pgfault COW no configurado");
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	68 a0 2f 80 00       	push   $0x802fa0
  80109c:	6a 27                	push   $0x27
  80109e:	68 e5 2e 80 00       	push   $0x802ee5
  8010a3:	e8 66 f1 ff ff       	call   80020e <_panic>
		panic("pgfault: %e", r);
  8010a8:	50                   	push   %eax
  8010a9:	68 21 2f 80 00       	push   $0x802f21
  8010ae:	6a 32                	push   $0x32
  8010b0:	68 e5 2e 80 00       	push   $0x802ee5
  8010b5:	e8 54 f1 ff ff       	call   80020e <_panic>
		panic("pgfault: %e", r);
  8010ba:	50                   	push   %eax
  8010bb:	68 21 2f 80 00       	push   $0x802f21
  8010c0:	6a 39                	push   $0x39
  8010c2:	68 e5 2e 80 00       	push   $0x802ee5
  8010c7:	e8 42 f1 ff ff       	call   80020e <_panic>
		panic("pgfault: %e", r);
  8010cc:	50                   	push   %eax
  8010cd:	68 21 2f 80 00       	push   $0x802f21
  8010d2:	6a 3d                	push   $0x3d
  8010d4:	68 e5 2e 80 00       	push   $0x802ee5
  8010d9:	e8 30 f1 ff ff       	call   80020e <_panic>

008010de <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  8010de:	f3 0f 1e fb          	endbr32 
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	57                   	push   %edi
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8010f0:	cd 30                	int    $0x30
  8010f2:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	78 22                	js     80111a <fork_v0+0x3c>
  8010f8:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8010fa:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010ff:	75 52                	jne    801153 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801101:	e8 8e fb ff ff       	call   800c94 <sys_getenvid>
  801106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80110b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80110e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801113:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801118:	eb 6e                	jmp    801188 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80111a:	50                   	push   %eax
  80111b:	68 c8 2f 80 00       	push   $0x802fc8
  801120:	68 8a 00 00 00       	push   $0x8a
  801125:	68 e5 2e 80 00       	push   $0x802ee5
  80112a:	e8 df f0 ff ff       	call   80020e <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  80112f:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801136:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80113c:	89 da                	mov    %ebx,%edx
  80113e:	89 f0                	mov    %esi,%eax
  801140:	e8 b9 fd ff ff       	call   800efe <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801145:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80114b:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801151:	74 23                	je     801176 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801153:	89 d8                	mov    %ebx,%eax
  801155:	c1 e8 16             	shr    $0x16,%eax
  801158:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115f:	a8 01                	test   $0x1,%al
  801161:	74 e2                	je     801145 <fork_v0+0x67>
  801163:	89 d8                	mov    %ebx,%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
  801168:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116f:	f6 c2 01             	test   $0x1,%dl
  801172:	74 d1                	je     801145 <fork_v0+0x67>
  801174:	eb b9                	jmp    80112f <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	6a 02                	push   $0x2
  80117b:	57                   	push   %edi
  80117c:	e8 df fb ff ff       	call   800d60 <sys_env_set_status>
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	85 c0                	test   %eax,%eax
  801186:	78 0a                	js     801192 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  801188:	89 f8                	mov    %edi,%eax
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  801192:	50                   	push   %eax
  801193:	68 ec 2f 80 00       	push   $0x802fec
  801198:	68 98 00 00 00       	push   $0x98
  80119d:	68 e5 2e 80 00       	push   $0x802ee5
  8011a2:	e8 67 f0 ff ff       	call   80020e <_panic>

008011a7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a7:	f3 0f 1e fb          	endbr32 
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	57                   	push   %edi
  8011af:	56                   	push   %esi
  8011b0:	53                   	push   %ebx
  8011b1:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8011b4:	68 cb 0f 80 00       	push   $0x800fcb
  8011b9:	e8 aa 14 00 00       	call   802668 <set_pgfault_handler>
  8011be:	b8 07 00 00 00       	mov    $0x7,%eax
  8011c3:	cd 30                	int    $0x30
  8011c5:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	78 37                	js     801205 <fork+0x5e>
  8011ce:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8011d0:	74 48                	je     80121a <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	6a 07                	push   $0x7
  8011d7:	68 00 f0 bf ee       	push   $0xeebff000
  8011dc:	50                   	push   %eax
  8011dd:	e8 05 fb ff ff       	call   800ce7 <sys_page_alloc>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 4d                	js     801236 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	68 e5 26 80 00       	push   $0x8026e5
  8011f1:	56                   	push   %esi
  8011f2:	e8 b7 fb ff ff       	call   800dae <sys_env_set_pgfault_upcall>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	78 4d                	js     80124b <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8011fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801203:	eb 70                	jmp    801275 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801205:	50                   	push   %eax
  801206:	68 2d 2f 80 00       	push   $0x802f2d
  80120b:	68 b7 00 00 00       	push   $0xb7
  801210:	68 e5 2e 80 00       	push   $0x802ee5
  801215:	e8 f4 ef ff ff       	call   80020e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80121a:	e8 75 fa ff ff       	call   800c94 <sys_getenvid>
  80121f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801224:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801227:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80122c:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801231:	e9 80 00 00 00       	jmp    8012b6 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801236:	50                   	push   %eax
  801237:	68 3d 2f 80 00       	push   $0x802f3d
  80123c:	68 c0 00 00 00       	push   $0xc0
  801241:	68 e5 2e 80 00       	push   $0x802ee5
  801246:	e8 c3 ef ff ff       	call   80020e <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80124b:	50                   	push   %eax
  80124c:	68 10 30 80 00       	push   $0x803010
  801251:	68 c3 00 00 00       	push   $0xc3
  801256:	68 e5 2e 80 00       	push   $0x802ee5
  80125b:	e8 ae ef ff ff       	call   80020e <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801260:	89 f8                	mov    %edi,%eax
  801262:	e8 bd fb ff ff       	call   800e24 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801267:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80126d:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801273:	74 2f                	je     8012a4 <fork+0xfd>
  801275:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  801277:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  80127d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  801282:	76 e3                	jbe    801267 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801284:	89 d8                	mov    %ebx,%eax
  801286:	c1 e8 16             	shr    $0x16,%eax
  801289:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801290:	a8 01                	test   $0x1,%al
  801292:	74 d3                	je     801267 <fork+0xc0>
  801294:	c1 ea 0c             	shr    $0xc,%edx
  801297:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80129e:	a8 01                	test   $0x1,%al
  8012a0:	74 c5                	je     801267 <fork+0xc0>
  8012a2:	eb bc                	jmp    801260 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	6a 02                	push   $0x2
  8012a9:	56                   	push   %esi
  8012aa:	e8 b1 fa ff ff       	call   800d60 <sys_env_set_status>
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 0a                	js     8012c0 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8012b6:	89 f0                	mov    %esi,%eax
  8012b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8012c0:	50                   	push   %eax
  8012c1:	68 3c 30 80 00       	push   $0x80303c
  8012c6:	68 ce 00 00 00       	push   $0xce
  8012cb:	68 e5 2e 80 00       	push   $0x802ee5
  8012d0:	e8 39 ef ff ff       	call   80020e <_panic>

008012d5 <sfork>:

// Challenge!
int
sfork(void)
{
  8012d5:	f3 0f 1e fb          	endbr32 
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012df:	68 5b 2f 80 00       	push   $0x802f5b
  8012e4:	68 d7 00 00 00       	push   $0xd7
  8012e9:	68 e5 2e 80 00       	push   $0x802ee5
  8012ee:	e8 1b ef ff ff       	call   80020e <_panic>

008012f3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f3:	f3 0f 1e fb          	endbr32 
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	05 00 00 00 30       	add    $0x30000000,%eax
  801302:	c1 e8 0c             	shr    $0xc,%eax
}
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801307:	f3 0f 1e fb          	endbr32 
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801311:	ff 75 08             	pushl  0x8(%ebp)
  801314:	e8 da ff ff ff       	call   8012f3 <fd2num>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	c1 e0 0c             	shl    $0xc,%eax
  80131f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801326:	f3 0f 1e fb          	endbr32 
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801332:	89 c2                	mov    %eax,%edx
  801334:	c1 ea 16             	shr    $0x16,%edx
  801337:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133e:	f6 c2 01             	test   $0x1,%dl
  801341:	74 2d                	je     801370 <fd_alloc+0x4a>
  801343:	89 c2                	mov    %eax,%edx
  801345:	c1 ea 0c             	shr    $0xc,%edx
  801348:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134f:	f6 c2 01             	test   $0x1,%dl
  801352:	74 1c                	je     801370 <fd_alloc+0x4a>
  801354:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801359:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80135e:	75 d2                	jne    801332 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801369:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80136e:	eb 0a                	jmp    80137a <fd_alloc+0x54>
			*fd_store = fd;
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	89 01                	mov    %eax,(%ecx)
			return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80137c:	f3 0f 1e fb          	endbr32 
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801386:	83 f8 1f             	cmp    $0x1f,%eax
  801389:	77 30                	ja     8013bb <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80138b:	c1 e0 0c             	shl    $0xc,%eax
  80138e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801393:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801399:	f6 c2 01             	test   $0x1,%dl
  80139c:	74 24                	je     8013c2 <fd_lookup+0x46>
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	c1 ea 0c             	shr    $0xc,%edx
  8013a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013aa:	f6 c2 01             	test   $0x1,%dl
  8013ad:	74 1a                	je     8013c9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b2:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    
		return -E_INVAL;
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb f7                	jmp    8013b9 <fd_lookup+0x3d>
		return -E_INVAL;
  8013c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c7:	eb f0                	jmp    8013b9 <fd_lookup+0x3d>
  8013c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ce:	eb e9                	jmp    8013b9 <fd_lookup+0x3d>

008013d0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013d0:	f3 0f 1e fb          	endbr32 
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013dd:	ba dc 30 80 00       	mov    $0x8030dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013e2:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013e7:	39 08                	cmp    %ecx,(%eax)
  8013e9:	74 33                	je     80141e <dev_lookup+0x4e>
  8013eb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013ee:	8b 02                	mov    (%edx),%eax
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	75 f3                	jne    8013e7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8013f9:	8b 40 48             	mov    0x48(%eax),%eax
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	51                   	push   %ecx
  801400:	50                   	push   %eax
  801401:	68 60 30 80 00       	push   $0x803060
  801406:	e8 ea ee ff ff       	call   8002f5 <cprintf>
	*dev = 0;
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    
			*dev = devtab[i];
  80141e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801421:	89 01                	mov    %eax,(%ecx)
			return 0;
  801423:	b8 00 00 00 00       	mov    $0x0,%eax
  801428:	eb f2                	jmp    80141c <dev_lookup+0x4c>

0080142a <fd_close>:
{
  80142a:	f3 0f 1e fb          	endbr32 
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	57                   	push   %edi
  801432:	56                   	push   %esi
  801433:	53                   	push   %ebx
  801434:	83 ec 28             	sub    $0x28,%esp
  801437:	8b 75 08             	mov    0x8(%ebp),%esi
  80143a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80143d:	56                   	push   %esi
  80143e:	e8 b0 fe ff ff       	call   8012f3 <fd2num>
  801443:	83 c4 08             	add    $0x8,%esp
  801446:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801449:	52                   	push   %edx
  80144a:	50                   	push   %eax
  80144b:	e8 2c ff ff ff       	call   80137c <fd_lookup>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	78 05                	js     80145e <fd_close+0x34>
	    || fd != fd2)
  801459:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80145c:	74 16                	je     801474 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80145e:	89 f8                	mov    %edi,%eax
  801460:	84 c0                	test   %al,%al
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	0f 44 d8             	cmove  %eax,%ebx
}
  80146a:	89 d8                	mov    %ebx,%eax
  80146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801474:	83 ec 08             	sub    $0x8,%esp
  801477:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80147a:	50                   	push   %eax
  80147b:	ff 36                	pushl  (%esi)
  80147d:	e8 4e ff ff ff       	call   8013d0 <dev_lookup>
  801482:	89 c3                	mov    %eax,%ebx
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 1a                	js     8014a5 <fd_close+0x7b>
		if (dev->dev_close)
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801491:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801496:	85 c0                	test   %eax,%eax
  801498:	74 0b                	je     8014a5 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	56                   	push   %esi
  80149e:	ff d0                	call   *%eax
  8014a0:	89 c3                	mov    %eax,%ebx
  8014a2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	56                   	push   %esi
  8014a9:	6a 00                	push   $0x0
  8014ab:	e8 89 f8 ff ff       	call   800d39 <sys_page_unmap>
	return r;
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	eb b5                	jmp    80146a <fd_close+0x40>

008014b5 <close>:

int
close(int fdnum)
{
  8014b5:	f3 0f 1e fb          	endbr32 
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	ff 75 08             	pushl  0x8(%ebp)
  8014c6:	e8 b1 fe ff ff       	call   80137c <fd_lookup>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	79 02                	jns    8014d4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    
		return fd_close(fd, 1);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	6a 01                	push   $0x1
  8014d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014dc:	e8 49 ff ff ff       	call   80142a <fd_close>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	eb ec                	jmp    8014d2 <close+0x1d>

008014e6 <close_all>:

void
close_all(void)
{
  8014e6:	f3 0f 1e fb          	endbr32 
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014f6:	83 ec 0c             	sub    $0xc,%esp
  8014f9:	53                   	push   %ebx
  8014fa:	e8 b6 ff ff ff       	call   8014b5 <close>
	for (i = 0; i < MAXFD; i++)
  8014ff:	83 c3 01             	add    $0x1,%ebx
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	83 fb 20             	cmp    $0x20,%ebx
  801508:	75 ec                	jne    8014f6 <close_all+0x10>
}
  80150a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80150f:	f3 0f 1e fb          	endbr32 
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	57                   	push   %edi
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80151c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80151f:	50                   	push   %eax
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	e8 54 fe ff ff       	call   80137c <fd_lookup>
  801528:	89 c3                	mov    %eax,%ebx
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	0f 88 81 00 00 00    	js     8015b6 <dup+0xa7>
		return r;
	close(newfdnum);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	e8 75 ff ff ff       	call   8014b5 <close>

	newfd = INDEX2FD(newfdnum);
  801540:	8b 75 0c             	mov    0xc(%ebp),%esi
  801543:	c1 e6 0c             	shl    $0xc,%esi
  801546:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80154c:	83 c4 04             	add    $0x4,%esp
  80154f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801552:	e8 b0 fd ff ff       	call   801307 <fd2data>
  801557:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801559:	89 34 24             	mov    %esi,(%esp)
  80155c:	e8 a6 fd ff ff       	call   801307 <fd2data>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801566:	89 d8                	mov    %ebx,%eax
  801568:	c1 e8 16             	shr    $0x16,%eax
  80156b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801572:	a8 01                	test   $0x1,%al
  801574:	74 11                	je     801587 <dup+0x78>
  801576:	89 d8                	mov    %ebx,%eax
  801578:	c1 e8 0c             	shr    $0xc,%eax
  80157b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801582:	f6 c2 01             	test   $0x1,%dl
  801585:	75 39                	jne    8015c0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801587:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80158a:	89 d0                	mov    %edx,%eax
  80158c:	c1 e8 0c             	shr    $0xc,%eax
  80158f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	25 07 0e 00 00       	and    $0xe07,%eax
  80159e:	50                   	push   %eax
  80159f:	56                   	push   %esi
  8015a0:	6a 00                	push   $0x0
  8015a2:	52                   	push   %edx
  8015a3:	6a 00                	push   $0x0
  8015a5:	e8 65 f7 ff ff       	call   800d0f <sys_page_map>
  8015aa:	89 c3                	mov    %eax,%ebx
  8015ac:	83 c4 20             	add    $0x20,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 31                	js     8015e4 <dup+0xd5>
		goto err;

	return newfdnum;
  8015b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c7:	83 ec 0c             	sub    $0xc,%esp
  8015ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8015cf:	50                   	push   %eax
  8015d0:	57                   	push   %edi
  8015d1:	6a 00                	push   $0x0
  8015d3:	53                   	push   %ebx
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 34 f7 ff ff       	call   800d0f <sys_page_map>
  8015db:	89 c3                	mov    %eax,%ebx
  8015dd:	83 c4 20             	add    $0x20,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	79 a3                	jns    801587 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	56                   	push   %esi
  8015e8:	6a 00                	push   $0x0
  8015ea:	e8 4a f7 ff ff       	call   800d39 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015ef:	83 c4 08             	add    $0x8,%esp
  8015f2:	57                   	push   %edi
  8015f3:	6a 00                	push   $0x0
  8015f5:	e8 3f f7 ff ff       	call   800d39 <sys_page_unmap>
	return r;
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	eb b7                	jmp    8015b6 <dup+0xa7>

008015ff <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ff:	f3 0f 1e fb          	endbr32 
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 1c             	sub    $0x1c,%esp
  80160a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	53                   	push   %ebx
  801612:	e8 65 fd ff ff       	call   80137c <fd_lookup>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 3f                	js     80165d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801624:	50                   	push   %eax
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	ff 30                	pushl  (%eax)
  80162a:	e8 a1 fd ff ff       	call   8013d0 <dev_lookup>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 27                	js     80165d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801636:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801639:	8b 42 08             	mov    0x8(%edx),%eax
  80163c:	83 e0 03             	and    $0x3,%eax
  80163f:	83 f8 01             	cmp    $0x1,%eax
  801642:	74 1e                	je     801662 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801647:	8b 40 08             	mov    0x8(%eax),%eax
  80164a:	85 c0                	test   %eax,%eax
  80164c:	74 35                	je     801683 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	ff 75 10             	pushl  0x10(%ebp)
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	52                   	push   %edx
  801658:	ff d0                	call   *%eax
  80165a:	83 c4 10             	add    $0x10,%esp
}
  80165d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801660:	c9                   	leave  
  801661:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801662:	a1 04 50 80 00       	mov    0x805004,%eax
  801667:	8b 40 48             	mov    0x48(%eax),%eax
  80166a:	83 ec 04             	sub    $0x4,%esp
  80166d:	53                   	push   %ebx
  80166e:	50                   	push   %eax
  80166f:	68 a1 30 80 00       	push   $0x8030a1
  801674:	e8 7c ec ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801681:	eb da                	jmp    80165d <read+0x5e>
		return -E_NOT_SUPP;
  801683:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801688:	eb d3                	jmp    80165d <read+0x5e>

0080168a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80168a:	f3 0f 1e fb          	endbr32 
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	57                   	push   %edi
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a2:	eb 02                	jmp    8016a6 <readn+0x1c>
  8016a4:	01 c3                	add    %eax,%ebx
  8016a6:	39 f3                	cmp    %esi,%ebx
  8016a8:	73 21                	jae    8016cb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	89 f0                	mov    %esi,%eax
  8016af:	29 d8                	sub    %ebx,%eax
  8016b1:	50                   	push   %eax
  8016b2:	89 d8                	mov    %ebx,%eax
  8016b4:	03 45 0c             	add    0xc(%ebp),%eax
  8016b7:	50                   	push   %eax
  8016b8:	57                   	push   %edi
  8016b9:	e8 41 ff ff ff       	call   8015ff <read>
		if (m < 0)
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 04                	js     8016c9 <readn+0x3f>
			return m;
		if (m == 0)
  8016c5:	75 dd                	jne    8016a4 <readn+0x1a>
  8016c7:	eb 02                	jmp    8016cb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5e                   	pop    %esi
  8016d2:	5f                   	pop    %edi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d5:	f3 0f 1e fb          	endbr32 
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 1c             	sub    $0x1c,%esp
  8016e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e6:	50                   	push   %eax
  8016e7:	53                   	push   %ebx
  8016e8:	e8 8f fc ff ff       	call   80137c <fd_lookup>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 3a                	js     80172e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fa:	50                   	push   %eax
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	ff 30                	pushl  (%eax)
  801700:	e8 cb fc ff ff       	call   8013d0 <dev_lookup>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	85 c0                	test   %eax,%eax
  80170a:	78 22                	js     80172e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801713:	74 1e                	je     801733 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801718:	8b 52 0c             	mov    0xc(%edx),%edx
  80171b:	85 d2                	test   %edx,%edx
  80171d:	74 35                	je     801754 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	ff 75 10             	pushl  0x10(%ebp)
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	50                   	push   %eax
  801729:	ff d2                	call   *%edx
  80172b:	83 c4 10             	add    $0x10,%esp
}
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801733:	a1 04 50 80 00       	mov    0x805004,%eax
  801738:	8b 40 48             	mov    0x48(%eax),%eax
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	53                   	push   %ebx
  80173f:	50                   	push   %eax
  801740:	68 bd 30 80 00       	push   $0x8030bd
  801745:	e8 ab eb ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801752:	eb da                	jmp    80172e <write+0x59>
		return -E_NOT_SUPP;
  801754:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801759:	eb d3                	jmp    80172e <write+0x59>

0080175b <seek>:

int
seek(int fdnum, off_t offset)
{
  80175b:	f3 0f 1e fb          	endbr32 
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801768:	50                   	push   %eax
  801769:	ff 75 08             	pushl  0x8(%ebp)
  80176c:	e8 0b fc ff ff       	call   80137c <fd_lookup>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 0e                	js     801786 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801788:	f3 0f 1e fb          	endbr32 
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 1c             	sub    $0x1c,%esp
  801793:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	53                   	push   %ebx
  80179b:	e8 dc fb ff ff       	call   80137c <fd_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 37                	js     8017de <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	ff 30                	pushl  (%eax)
  8017b3:	e8 18 fc ff ff       	call   8013d0 <dev_lookup>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 1f                	js     8017de <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c6:	74 1b                	je     8017e3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cb:	8b 52 18             	mov    0x18(%edx),%edx
  8017ce:	85 d2                	test   %edx,%edx
  8017d0:	74 32                	je     801804 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d2:	83 ec 08             	sub    $0x8,%esp
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	50                   	push   %eax
  8017d9:	ff d2                	call   *%edx
  8017db:	83 c4 10             	add    $0x10,%esp
}
  8017de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017e3:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e8:	8b 40 48             	mov    0x48(%eax),%eax
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	53                   	push   %ebx
  8017ef:	50                   	push   %eax
  8017f0:	68 80 30 80 00       	push   $0x803080
  8017f5:	e8 fb ea ff ff       	call   8002f5 <cprintf>
		return -E_INVAL;
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801802:	eb da                	jmp    8017de <ftruncate+0x56>
		return -E_NOT_SUPP;
  801804:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801809:	eb d3                	jmp    8017de <ftruncate+0x56>

0080180b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80180b:	f3 0f 1e fb          	endbr32 
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	53                   	push   %ebx
  801813:	83 ec 1c             	sub    $0x1c,%esp
  801816:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801819:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181c:	50                   	push   %eax
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	e8 57 fb ff ff       	call   80137c <fd_lookup>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 4b                	js     801877 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80182c:	83 ec 08             	sub    $0x8,%esp
  80182f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801832:	50                   	push   %eax
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	ff 30                	pushl  (%eax)
  801838:	e8 93 fb ff ff       	call   8013d0 <dev_lookup>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 33                	js     801877 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80184b:	74 2f                	je     80187c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80184d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801850:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801857:	00 00 00 
	stat->st_isdir = 0;
  80185a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801861:	00 00 00 
	stat->st_dev = dev;
  801864:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	53                   	push   %ebx
  80186e:	ff 75 f0             	pushl  -0x10(%ebp)
  801871:	ff 50 14             	call   *0x14(%eax)
  801874:	83 c4 10             	add    $0x10,%esp
}
  801877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    
		return -E_NOT_SUPP;
  80187c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801881:	eb f4                	jmp    801877 <fstat+0x6c>

00801883 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801883:	f3 0f 1e fb          	endbr32 
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	6a 00                	push   $0x0
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	e8 3a 02 00 00       	call   801ad3 <open>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 1b                	js     8018bd <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	50                   	push   %eax
  8018a9:	e8 5d ff ff ff       	call   80180b <fstat>
  8018ae:	89 c6                	mov    %eax,%esi
	close(fd);
  8018b0:	89 1c 24             	mov    %ebx,(%esp)
  8018b3:	e8 fd fb ff ff       	call   8014b5 <close>
	return r;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 f3                	mov    %esi,%ebx
}
  8018bd:	89 d8                	mov    %ebx,%eax
  8018bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	89 c6                	mov    %eax,%esi
  8018cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018cf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8018d6:	74 27                	je     8018ff <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d8:	6a 07                	push   $0x7
  8018da:	68 00 60 80 00       	push   $0x806000
  8018df:	56                   	push   %esi
  8018e0:	ff 35 00 50 80 00    	pushl  0x805000
  8018e6:	e8 8d 0e 00 00       	call   802778 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018eb:	83 c4 0c             	add    $0xc,%esp
  8018ee:	6a 00                	push   $0x0
  8018f0:	53                   	push   %ebx
  8018f1:	6a 00                	push   $0x0
  8018f3:	e8 13 0e 00 00       	call   80270b <ipc_recv>
}
  8018f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5e                   	pop    %esi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	6a 01                	push   $0x1
  801904:	e8 c7 0e 00 00       	call   8027d0 <ipc_find_env>
  801909:	a3 00 50 80 00       	mov    %eax,0x805000
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	eb c5                	jmp    8018d8 <fsipc+0x12>

00801913 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801913:	f3 0f 1e fb          	endbr32 
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8b 40 0c             	mov    0xc(%eax),%eax
  801923:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	b8 02 00 00 00       	mov    $0x2,%eax
  80193a:	e8 87 ff ff ff       	call   8018c6 <fsipc>
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <devfile_flush>:
{
  801941:	f3 0f 1e fb          	endbr32 
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8b 40 0c             	mov    0xc(%eax),%eax
  801951:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801956:	ba 00 00 00 00       	mov    $0x0,%edx
  80195b:	b8 06 00 00 00       	mov    $0x6,%eax
  801960:	e8 61 ff ff ff       	call   8018c6 <fsipc>
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <devfile_stat>:
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8b 40 0c             	mov    0xc(%eax),%eax
  80197b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801980:	ba 00 00 00 00       	mov    $0x0,%edx
  801985:	b8 05 00 00 00       	mov    $0x5,%eax
  80198a:	e8 37 ff ff ff       	call   8018c6 <fsipc>
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 2c                	js     8019bf <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	68 00 60 80 00       	push   $0x806000
  80199b:	53                   	push   %ebx
  80199c:	e8 be ee ff ff       	call   80085f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a1:	a1 80 60 80 00       	mov    0x806080,%eax
  8019a6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ac:	a1 84 60 80 00       	mov    0x806084,%eax
  8019b1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <devfile_write>:
{
  8019c4:	f3 0f 1e fb          	endbr32 
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8019dd:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019e3:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019e9:	77 30                	ja     801a1b <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	53                   	push   %ebx
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	68 08 60 80 00       	push   $0x806008
  8019f7:	e8 1b f0 ff ff       	call   800a17 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801a01:	b8 04 00 00 00       	mov    $0x4,%eax
  801a06:	e8 bb fe ff ff       	call   8018c6 <fsipc>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 04                	js     801a16 <devfile_write+0x52>
	assert(r <= n);
  801a12:	39 d8                	cmp    %ebx,%eax
  801a14:	77 1e                	ja     801a34 <devfile_write+0x70>
}
  801a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a1b:	68 ec 30 80 00       	push   $0x8030ec
  801a20:	68 19 31 80 00       	push   $0x803119
  801a25:	68 94 00 00 00       	push   $0x94
  801a2a:	68 2e 31 80 00       	push   $0x80312e
  801a2f:	e8 da e7 ff ff       	call   80020e <_panic>
	assert(r <= n);
  801a34:	68 39 31 80 00       	push   $0x803139
  801a39:	68 19 31 80 00       	push   $0x803119
  801a3e:	68 98 00 00 00       	push   $0x98
  801a43:	68 2e 31 80 00       	push   $0x80312e
  801a48:	e8 c1 e7 ff ff       	call   80020e <_panic>

00801a4d <devfile_read>:
{
  801a4d:	f3 0f 1e fb          	endbr32 
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a64:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a74:	e8 4d fe ff ff       	call   8018c6 <fsipc>
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 1f                	js     801a9e <devfile_read+0x51>
	assert(r <= n);
  801a7f:	39 f0                	cmp    %esi,%eax
  801a81:	77 24                	ja     801aa7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a83:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a88:	7f 33                	jg     801abd <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	50                   	push   %eax
  801a8e:	68 00 60 80 00       	push   $0x806000
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	e8 7c ef ff ff       	call   800a17 <memmove>
	return r;
  801a9b:	83 c4 10             	add    $0x10,%esp
}
  801a9e:	89 d8                	mov    %ebx,%eax
  801aa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5d                   	pop    %ebp
  801aa6:	c3                   	ret    
	assert(r <= n);
  801aa7:	68 39 31 80 00       	push   $0x803139
  801aac:	68 19 31 80 00       	push   $0x803119
  801ab1:	6a 7c                	push   $0x7c
  801ab3:	68 2e 31 80 00       	push   $0x80312e
  801ab8:	e8 51 e7 ff ff       	call   80020e <_panic>
	assert(r <= PGSIZE);
  801abd:	68 40 31 80 00       	push   $0x803140
  801ac2:	68 19 31 80 00       	push   $0x803119
  801ac7:	6a 7d                	push   $0x7d
  801ac9:	68 2e 31 80 00       	push   $0x80312e
  801ace:	e8 3b e7 ff ff       	call   80020e <_panic>

00801ad3 <open>:
{
  801ad3:	f3 0f 1e fb          	endbr32 
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 1c             	sub    $0x1c,%esp
  801adf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ae2:	56                   	push   %esi
  801ae3:	e8 34 ed ff ff       	call   80081c <strlen>
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801af0:	7f 6c                	jg     801b5e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af8:	50                   	push   %eax
  801af9:	e8 28 f8 ff ff       	call   801326 <fd_alloc>
  801afe:	89 c3                	mov    %eax,%ebx
  801b00:	83 c4 10             	add    $0x10,%esp
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 3c                	js     801b43 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	56                   	push   %esi
  801b0b:	68 00 60 80 00       	push   $0x806000
  801b10:	e8 4a ed ff ff       	call   80085f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b20:	b8 01 00 00 00       	mov    $0x1,%eax
  801b25:	e8 9c fd ff ff       	call   8018c6 <fsipc>
  801b2a:	89 c3                	mov    %eax,%ebx
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	78 19                	js     801b4c <open+0x79>
	return fd2num(fd);
  801b33:	83 ec 0c             	sub    $0xc,%esp
  801b36:	ff 75 f4             	pushl  -0xc(%ebp)
  801b39:	e8 b5 f7 ff ff       	call   8012f3 <fd2num>
  801b3e:	89 c3                	mov    %eax,%ebx
  801b40:	83 c4 10             	add    $0x10,%esp
}
  801b43:	89 d8                	mov    %ebx,%eax
  801b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b48:	5b                   	pop    %ebx
  801b49:	5e                   	pop    %esi
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    
		fd_close(fd, 0);
  801b4c:	83 ec 08             	sub    $0x8,%esp
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 f4             	pushl  -0xc(%ebp)
  801b54:	e8 d1 f8 ff ff       	call   80142a <fd_close>
		return r;
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	eb e5                	jmp    801b43 <open+0x70>
		return -E_BAD_PATH;
  801b5e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b63:	eb de                	jmp    801b43 <open+0x70>

00801b65 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b65:	f3 0f 1e fb          	endbr32 
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	b8 08 00 00 00       	mov    $0x8,%eax
  801b79:	e8 48 fd ff ff       	call   8018c6 <fsipc>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <copy_shared_pages>:
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	return 0;
}
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	c3                   	ret    

00801b86 <init_stack>:
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 2c             	sub    $0x2c,%esp
  801b8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b92:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801b95:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (argc = 0; argv[argc] != 0; argc++)
  801b98:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b9d:	be 00 00 00 00       	mov    $0x0,%esi
  801ba2:	89 d7                	mov    %edx,%edi
  801ba4:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801bab:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	74 15                	je     801bc7 <init_stack+0x41>
		string_size += strlen(argv[argc]) + 1;
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	50                   	push   %eax
  801bb6:	e8 61 ec ff ff       	call   80081c <strlen>
  801bbb:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801bbf:	83 c3 01             	add    $0x1,%ebx
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	eb dd                	jmp    801ba4 <init_stack+0x1e>
  801bc7:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  801bca:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801bcd:	bf 00 10 40 00       	mov    $0x401000,%edi
  801bd2:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801bd4:	89 fa                	mov    %edi,%edx
  801bd6:	83 e2 fc             	and    $0xfffffffc,%edx
  801bd9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801be0:	29 c2                	sub    %eax,%edx
  801be2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  801be5:	8d 42 f8             	lea    -0x8(%edx),%eax
  801be8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801bed:	0f 86 06 01 00 00    	jbe    801cf9 <init_stack+0x173>
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	6a 07                	push   $0x7
  801bf8:	68 00 00 40 00       	push   $0x400000
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 e3 f0 ff ff       	call   800ce7 <sys_page_alloc>
  801c04:	89 c6                	mov    %eax,%esi
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	0f 88 de 00 00 00    	js     801cef <init_stack+0x169>
	for (i = 0; i < argc; i++) {
  801c11:	be 00 00 00 00       	mov    $0x0,%esi
  801c16:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801c19:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801c1c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  801c1f:	7e 2f                	jle    801c50 <init_stack+0xca>
		argv_store[i] = UTEMP2USTACK(string_store);
  801c21:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c27:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801c2a:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c33:	57                   	push   %edi
  801c34:	e8 26 ec ff ff       	call   80085f <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c39:	83 c4 04             	add    $0x4,%esp
  801c3c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c3f:	e8 d8 eb ff ff       	call   80081c <strlen>
  801c44:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c48:	83 c6 01             	add    $0x1,%esi
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	eb cc                	jmp    801c1c <init_stack+0x96>
	argv_store[argc] = 0;
  801c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c53:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801c56:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801c5d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c63:	75 5f                	jne    801cc4 <init_stack+0x13e>
	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c68:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801c6e:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801c76:	89 4a f8             	mov    %ecx,-0x8(%edx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c79:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c7e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801c81:	89 01                	mov    %eax,(%ecx)
	if ((r = sys_page_map(0,
  801c83:	83 ec 0c             	sub    $0xc,%esp
  801c86:	6a 07                	push   $0x7
  801c88:	68 00 d0 bf ee       	push   $0xeebfd000
  801c8d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c90:	68 00 00 40 00       	push   $0x400000
  801c95:	6a 00                	push   $0x0
  801c97:	e8 73 f0 ff ff       	call   800d0f <sys_page_map>
  801c9c:	89 c6                	mov    %eax,%esi
  801c9e:	83 c4 20             	add    $0x20,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 38                	js     801cdd <init_stack+0x157>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	68 00 00 40 00       	push   $0x400000
  801cad:	6a 00                	push   $0x0
  801caf:	e8 85 f0 ff ff       	call   800d39 <sys_page_unmap>
  801cb4:	89 c6                	mov    %eax,%esi
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	78 20                	js     801cdd <init_stack+0x157>
	return 0;
  801cbd:	be 00 00 00 00       	mov    $0x0,%esi
  801cc2:	eb 2b                	jmp    801cef <init_stack+0x169>
	assert(string_store == (char *) UTEMP + PGSIZE);
  801cc4:	68 4c 31 80 00       	push   $0x80314c
  801cc9:	68 19 31 80 00       	push   $0x803119
  801cce:	68 fc 00 00 00       	push   $0xfc
  801cd3:	68 74 31 80 00       	push   $0x803174
  801cd8:	e8 31 e5 ff ff       	call   80020e <_panic>
	sys_page_unmap(0, UTEMP);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	68 00 00 40 00       	push   $0x400000
  801ce5:	6a 00                	push   $0x0
  801ce7:	e8 4d f0 ff ff       	call   800d39 <sys_page_unmap>
	return r;
  801cec:	83 c4 10             	add    $0x10,%esp
}
  801cef:	89 f0                	mov    %esi,%eax
  801cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5f                   	pop    %edi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    
		return -E_NO_MEM;
  801cf9:	be fc ff ff ff       	mov    $0xfffffffc,%esi
  801cfe:	eb ef                	jmp    801cef <init_stack+0x169>

00801d00 <map_segment>:
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	57                   	push   %edi
  801d04:	56                   	push   %esi
  801d05:	53                   	push   %ebx
  801d06:	83 ec 1c             	sub    $0x1c,%esp
  801d09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d0c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801d0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801d12:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((i = PGOFF(va))) {
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d1c:	74 0f                	je     801d2d <map_segment+0x2d>
		va -= i;
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 55 e0             	mov    %edx,-0x20(%ebp)
		memsz += i;
  801d23:	01 c1                	add    %eax,%ecx
  801d25:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  801d28:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  801d2a:	29 45 10             	sub    %eax,0x10(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d32:	e9 99 00 00 00       	jmp    801dd0 <map_segment+0xd0>
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  801d37:	83 ec 04             	sub    $0x4,%esp
  801d3a:	6a 07                	push   $0x7
  801d3c:	68 00 00 40 00       	push   $0x400000
  801d41:	6a 00                	push   $0x0
  801d43:	e8 9f ef ff ff       	call   800ce7 <sys_page_alloc>
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 88 c1 00 00 00    	js     801e14 <map_segment+0x114>
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	89 f0                	mov    %esi,%eax
  801d58:	03 45 10             	add    0x10(%ebp),%eax
  801d5b:	50                   	push   %eax
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	e8 f7 f9 ff ff       	call   80175b <seek>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	85 c0                	test   %eax,%eax
  801d69:	0f 88 a5 00 00 00    	js     801e14 <map_segment+0x114>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801d6f:	83 ec 04             	sub    $0x4,%esp
  801d72:	89 f8                	mov    %edi,%eax
  801d74:	29 f0                	sub    %esi,%eax
  801d76:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d7b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d80:	0f 47 c2             	cmova  %edx,%eax
  801d83:	50                   	push   %eax
  801d84:	68 00 00 40 00       	push   $0x400000
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	e8 f9 f8 ff ff       	call   80168a <readn>
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 7c                	js     801e14 <map_segment+0x114>
			if ((r = sys_page_map(
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	ff 75 14             	pushl  0x14(%ebp)
  801d9e:	03 75 e0             	add    -0x20(%ebp),%esi
  801da1:	56                   	push   %esi
  801da2:	ff 75 dc             	pushl  -0x24(%ebp)
  801da5:	68 00 00 40 00       	push   $0x400000
  801daa:	6a 00                	push   $0x0
  801dac:	e8 5e ef ff ff       	call   800d0f <sys_page_map>
  801db1:	83 c4 20             	add    $0x20,%esp
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 42                	js     801dfa <map_segment+0xfa>
			sys_page_unmap(0, UTEMP);
  801db8:	83 ec 08             	sub    $0x8,%esp
  801dbb:	68 00 00 40 00       	push   $0x400000
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 72 ef ff ff       	call   800d39 <sys_page_unmap>
  801dc7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801dca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dd0:	89 de                	mov    %ebx,%esi
  801dd2:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801dd5:	76 38                	jbe    801e0f <map_segment+0x10f>
		if (i >= filesz) {
  801dd7:	39 df                	cmp    %ebx,%edi
  801dd9:	0f 87 58 ff ff ff    	ja     801d37 <map_segment+0x37>
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	ff 75 14             	pushl  0x14(%ebp)
  801de5:	03 75 e0             	add    -0x20(%ebp),%esi
  801de8:	56                   	push   %esi
  801de9:	ff 75 dc             	pushl  -0x24(%ebp)
  801dec:	e8 f6 ee ff ff       	call   800ce7 <sys_page_alloc>
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	79 d2                	jns    801dca <map_segment+0xca>
  801df8:	eb 1a                	jmp    801e14 <map_segment+0x114>
				panic("spawn: sys_page_map data: %e", r);
  801dfa:	50                   	push   %eax
  801dfb:	68 80 31 80 00       	push   $0x803180
  801e00:	68 3a 01 00 00       	push   $0x13a
  801e05:	68 74 31 80 00       	push   $0x803174
  801e0a:	e8 ff e3 ff ff       	call   80020e <_panic>
	return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    

00801e1c <spawn>:
{
  801e1c:	f3 0f 1e fb          	endbr32 
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	57                   	push   %edi
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	81 ec 74 02 00 00    	sub    $0x274,%esp
	if ((r = open(prog, O_RDONLY)) < 0)
  801e2c:	6a 00                	push   $0x0
  801e2e:	ff 75 08             	pushl  0x8(%ebp)
  801e31:	e8 9d fc ff ff       	call   801ad3 <open>
  801e36:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 88 0b 02 00 00    	js     802052 <spawn+0x236>
  801e47:	89 c7                	mov    %eax,%edi
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 00 02 00 00       	push   $0x200
  801e51:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e57:	50                   	push   %eax
  801e58:	57                   	push   %edi
  801e59:	e8 2c f8 ff ff       	call   80168a <readn>
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e66:	0f 85 85 00 00 00    	jne    801ef1 <spawn+0xd5>
  801e6c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e73:	45 4c 46 
  801e76:	75 79                	jne    801ef1 <spawn+0xd5>
  801e78:	b8 07 00 00 00       	mov    $0x7,%eax
  801e7d:	cd 30                	int    $0x30
  801e7f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801e85:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	if ((r = sys_exofork()) < 0)
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 88 b1 01 00 00    	js     802046 <spawn+0x22a>
	child_tf = envs[ENVX(child)].env_tf;
  801e95:	89 c6                	mov    %eax,%esi
  801e97:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801e9d:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801ea0:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801ea6:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801eac:	b9 11 00 00 00       	mov    $0x11,%ecx
  801eb1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801eb3:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801eb9:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  801ebf:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  801ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	e8 b7 fc ff ff       	call   801b86 <init_stack>
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 88 89 01 00 00    	js     802060 <spawn+0x244>
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  801ed7:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801edd:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ee4:	be 00 00 00 00       	mov    $0x0,%esi
  801ee9:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801eef:	eb 3e                	jmp    801f2f <spawn+0x113>
		close(fd);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801efa:	e8 b6 f5 ff ff       	call   8014b5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801eff:	83 c4 0c             	add    $0xc,%esp
  801f02:	68 7f 45 4c 46       	push   $0x464c457f
  801f07:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f0d:	68 9d 31 80 00       	push   $0x80319d
  801f12:	e8 de e3 ff ff       	call   8002f5 <cprintf>
		return -E_NOT_EXEC;
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f21:	ff ff ff 
  801f24:	e9 29 01 00 00       	jmp    802052 <spawn+0x236>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f29:	83 c6 01             	add    $0x1,%esi
  801f2c:	83 c3 20             	add    $0x20,%ebx
  801f2f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f36:	39 f0                	cmp    %esi,%eax
  801f38:	7e 62                	jle    801f9c <spawn+0x180>
		if (ph->p_type != ELF_PROG_LOAD)
  801f3a:	83 3b 01             	cmpl   $0x1,(%ebx)
  801f3d:	75 ea                	jne    801f29 <spawn+0x10d>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f3f:	8b 43 18             	mov    0x18(%ebx),%eax
  801f42:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801f45:	83 f8 01             	cmp    $0x1,%eax
  801f48:	19 c0                	sbb    %eax,%eax
  801f4a:	83 e0 fe             	and    $0xfffffffe,%eax
  801f4d:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  801f50:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801f53:	8b 53 08             	mov    0x8(%ebx),%edx
  801f56:	50                   	push   %eax
  801f57:	ff 73 04             	pushl  0x4(%ebx)
  801f5a:	ff 73 10             	pushl  0x10(%ebx)
  801f5d:	57                   	push   %edi
  801f5e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f64:	e8 97 fd ff ff       	call   801d00 <map_segment>
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	79 b9                	jns    801f29 <spawn+0x10d>
  801f70:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f7b:	e8 ee ec ff ff       	call   800c6e <sys_env_destroy>
	close(fd);
  801f80:	83 c4 04             	add    $0x4,%esp
  801f83:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f89:	e8 27 f5 ff ff       	call   8014b5 <close>
	return r;
  801f8e:	83 c4 10             	add    $0x10,%esp
		if ((r = map_segment(child,
  801f91:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
	return r;
  801f97:	e9 b6 00 00 00       	jmp    802052 <spawn+0x236>
	close(fd);
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fa5:	e8 0b f5 ff ff       	call   8014b5 <close>
	if ((r = copy_shared_pages(child)) < 0)
  801faa:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801fb0:	e8 cb fb ff ff       	call   801b80 <copy_shared_pages>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 4b                	js     802007 <spawn+0x1eb>
	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  801fbc:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801fc3:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801fcf:	50                   	push   %eax
  801fd0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801fd6:	e8 ac ed ff ff       	call   800d87 <sys_env_set_trapframe>
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	78 3a                	js     80201c <spawn+0x200>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	6a 02                	push   $0x2
  801fe7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801fed:	e8 6e ed ff ff       	call   800d60 <sys_env_set_status>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 38                	js     802031 <spawn+0x215>
	return child;
  801ff9:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801fff:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802005:	eb 4b                	jmp    802052 <spawn+0x236>
		panic("copy_shared_pages: %e", r);
  802007:	50                   	push   %eax
  802008:	68 b7 31 80 00       	push   $0x8031b7
  80200d:	68 8c 00 00 00       	push   $0x8c
  802012:	68 74 31 80 00       	push   $0x803174
  802017:	e8 f2 e1 ff ff       	call   80020e <_panic>
		panic("sys_env_set_trapframe: %e", r);
  80201c:	50                   	push   %eax
  80201d:	68 cd 31 80 00       	push   $0x8031cd
  802022:	68 90 00 00 00       	push   $0x90
  802027:	68 74 31 80 00       	push   $0x803174
  80202c:	e8 dd e1 ff ff       	call   80020e <_panic>
		panic("sys_env_set_status: %e", r);
  802031:	50                   	push   %eax
  802032:	68 e7 31 80 00       	push   $0x8031e7
  802037:	68 93 00 00 00       	push   $0x93
  80203c:	68 74 31 80 00       	push   $0x803174
  802041:	e8 c8 e1 ff ff       	call   80020e <_panic>
		return r;
  802046:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80204c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802052:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5f                   	pop    %edi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    
		return r;
  802060:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802066:	eb ea                	jmp    802052 <spawn+0x236>

00802068 <spawnl>:
{
  802068:	f3 0f 1e fb          	endbr32 
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	57                   	push   %edi
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802075:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  80207d:	8d 4a 04             	lea    0x4(%edx),%ecx
  802080:	83 3a 00             	cmpl   $0x0,(%edx)
  802083:	74 07                	je     80208c <spawnl+0x24>
		argc++;
  802085:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  802088:	89 ca                	mov    %ecx,%edx
  80208a:	eb f1                	jmp    80207d <spawnl+0x15>
	const char *argv[argc + 2];
  80208c:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802093:	89 d1                	mov    %edx,%ecx
  802095:	83 e1 f0             	and    $0xfffffff0,%ecx
  802098:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80209e:	89 e6                	mov    %esp,%esi
  8020a0:	29 d6                	sub    %edx,%esi
  8020a2:	89 f2                	mov    %esi,%edx
  8020a4:	39 d4                	cmp    %edx,%esp
  8020a6:	74 10                	je     8020b8 <spawnl+0x50>
  8020a8:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8020ae:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8020b5:	00 
  8020b6:	eb ec                	jmp    8020a4 <spawnl+0x3c>
  8020b8:	89 ca                	mov    %ecx,%edx
  8020ba:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8020c0:	29 d4                	sub    %edx,%esp
  8020c2:	85 d2                	test   %edx,%edx
  8020c4:	74 05                	je     8020cb <spawnl+0x63>
  8020c6:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8020cb:	8d 74 24 03          	lea    0x3(%esp),%esi
  8020cf:	89 f2                	mov    %esi,%edx
  8020d1:	c1 ea 02             	shr    $0x2,%edx
  8020d4:	83 e6 fc             	and    $0xfffffffc,%esi
  8020d7:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8020d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020dc:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  8020e3:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8020ea:	00 
	va_start(vl, arg0);
  8020eb:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8020ee:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f5:	eb 0b                	jmp    802102 <spawnl+0x9a>
		argv[i + 1] = va_arg(vl, const char *);
  8020f7:	83 c0 01             	add    $0x1,%eax
  8020fa:	8b 39                	mov    (%ecx),%edi
  8020fc:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8020ff:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  802102:	39 d0                	cmp    %edx,%eax
  802104:	75 f1                	jne    8020f7 <spawnl+0x8f>
	return spawn(prog, argv);
  802106:	83 ec 08             	sub    $0x8,%esp
  802109:	56                   	push   %esi
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	e8 0a fd ff ff       	call   801e1c <spawn>
}
  802112:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5f                   	pop    %edi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80211a:	f3 0f 1e fb          	endbr32 
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	56                   	push   %esi
  802122:	53                   	push   %ebx
  802123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	e8 d6 f1 ff ff       	call   801307 <fd2data>
  802131:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802133:	83 c4 08             	add    $0x8,%esp
  802136:	68 fe 31 80 00       	push   $0x8031fe
  80213b:	53                   	push   %ebx
  80213c:	e8 1e e7 ff ff       	call   80085f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802141:	8b 46 04             	mov    0x4(%esi),%eax
  802144:	2b 06                	sub    (%esi),%eax
  802146:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80214c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802153:	00 00 00 
	stat->st_dev = &devpipe;
  802156:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  80215d:	40 80 00 
	return 0;
}
  802160:	b8 00 00 00 00       	mov    $0x0,%eax
  802165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802168:	5b                   	pop    %ebx
  802169:	5e                   	pop    %esi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    

0080216c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80216c:	f3 0f 1e fb          	endbr32 
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	53                   	push   %ebx
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80217a:	53                   	push   %ebx
  80217b:	6a 00                	push   $0x0
  80217d:	e8 b7 eb ff ff       	call   800d39 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802182:	89 1c 24             	mov    %ebx,(%esp)
  802185:	e8 7d f1 ff ff       	call   801307 <fd2data>
  80218a:	83 c4 08             	add    $0x8,%esp
  80218d:	50                   	push   %eax
  80218e:	6a 00                	push   $0x0
  802190:	e8 a4 eb ff ff       	call   800d39 <sys_page_unmap>
}
  802195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <_pipeisclosed>:
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	57                   	push   %edi
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 1c             	sub    $0x1c,%esp
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021a7:	a1 04 50 80 00       	mov    0x805004,%eax
  8021ac:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021af:	83 ec 0c             	sub    $0xc,%esp
  8021b2:	57                   	push   %edi
  8021b3:	e8 55 06 00 00       	call   80280d <pageref>
  8021b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021bb:	89 34 24             	mov    %esi,(%esp)
  8021be:	e8 4a 06 00 00       	call   80280d <pageref>
		nn = thisenv->env_runs;
  8021c3:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8021c9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	39 cb                	cmp    %ecx,%ebx
  8021d1:	74 1b                	je     8021ee <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021d6:	75 cf                	jne    8021a7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021d8:	8b 42 58             	mov    0x58(%edx),%eax
  8021db:	6a 01                	push   $0x1
  8021dd:	50                   	push   %eax
  8021de:	53                   	push   %ebx
  8021df:	68 05 32 80 00       	push   $0x803205
  8021e4:	e8 0c e1 ff ff       	call   8002f5 <cprintf>
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	eb b9                	jmp    8021a7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021f1:	0f 94 c0             	sete   %al
  8021f4:	0f b6 c0             	movzbl %al,%eax
}
  8021f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fa:	5b                   	pop    %ebx
  8021fb:	5e                   	pop    %esi
  8021fc:	5f                   	pop    %edi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    

008021ff <devpipe_write>:
{
  8021ff:	f3 0f 1e fb          	endbr32 
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 28             	sub    $0x28,%esp
  80220c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80220f:	56                   	push   %esi
  802210:	e8 f2 f0 ff ff       	call   801307 <fd2data>
  802215:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802217:	83 c4 10             	add    $0x10,%esp
  80221a:	bf 00 00 00 00       	mov    $0x0,%edi
  80221f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802222:	74 4f                	je     802273 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802224:	8b 43 04             	mov    0x4(%ebx),%eax
  802227:	8b 0b                	mov    (%ebx),%ecx
  802229:	8d 51 20             	lea    0x20(%ecx),%edx
  80222c:	39 d0                	cmp    %edx,%eax
  80222e:	72 14                	jb     802244 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802230:	89 da                	mov    %ebx,%edx
  802232:	89 f0                	mov    %esi,%eax
  802234:	e8 61 ff ff ff       	call   80219a <_pipeisclosed>
  802239:	85 c0                	test   %eax,%eax
  80223b:	75 3b                	jne    802278 <devpipe_write+0x79>
			sys_yield();
  80223d:	e8 7a ea ff ff       	call   800cbc <sys_yield>
  802242:	eb e0                	jmp    802224 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802244:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802247:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80224b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80224e:	89 c2                	mov    %eax,%edx
  802250:	c1 fa 1f             	sar    $0x1f,%edx
  802253:	89 d1                	mov    %edx,%ecx
  802255:	c1 e9 1b             	shr    $0x1b,%ecx
  802258:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80225b:	83 e2 1f             	and    $0x1f,%edx
  80225e:	29 ca                	sub    %ecx,%edx
  802260:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802264:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802268:	83 c0 01             	add    $0x1,%eax
  80226b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80226e:	83 c7 01             	add    $0x1,%edi
  802271:	eb ac                	jmp    80221f <devpipe_write+0x20>
	return i;
  802273:	8b 45 10             	mov    0x10(%ebp),%eax
  802276:	eb 05                	jmp    80227d <devpipe_write+0x7e>
				return 0;
  802278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <devpipe_read>:
{
  802285:	f3 0f 1e fb          	endbr32 
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	57                   	push   %edi
  80228d:	56                   	push   %esi
  80228e:	53                   	push   %ebx
  80228f:	83 ec 18             	sub    $0x18,%esp
  802292:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802295:	57                   	push   %edi
  802296:	e8 6c f0 ff ff       	call   801307 <fd2data>
  80229b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	be 00 00 00 00       	mov    $0x0,%esi
  8022a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a8:	75 14                	jne    8022be <devpipe_read+0x39>
	return i;
  8022aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ad:	eb 02                	jmp    8022b1 <devpipe_read+0x2c>
				return i;
  8022af:	89 f0                	mov    %esi,%eax
}
  8022b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
			sys_yield();
  8022b9:	e8 fe e9 ff ff       	call   800cbc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022be:	8b 03                	mov    (%ebx),%eax
  8022c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022c3:	75 18                	jne    8022dd <devpipe_read+0x58>
			if (i > 0)
  8022c5:	85 f6                	test   %esi,%esi
  8022c7:	75 e6                	jne    8022af <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8022c9:	89 da                	mov    %ebx,%edx
  8022cb:	89 f8                	mov    %edi,%eax
  8022cd:	e8 c8 fe ff ff       	call   80219a <_pipeisclosed>
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	74 e3                	je     8022b9 <devpipe_read+0x34>
				return 0;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022db:	eb d4                	jmp    8022b1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022dd:	99                   	cltd   
  8022de:	c1 ea 1b             	shr    $0x1b,%edx
  8022e1:	01 d0                	add    %edx,%eax
  8022e3:	83 e0 1f             	and    $0x1f,%eax
  8022e6:	29 d0                	sub    %edx,%eax
  8022e8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022f3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022f6:	83 c6 01             	add    $0x1,%esi
  8022f9:	eb aa                	jmp    8022a5 <devpipe_read+0x20>

008022fb <pipe>:
{
  8022fb:	f3 0f 1e fb          	endbr32 
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802307:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80230a:	50                   	push   %eax
  80230b:	e8 16 f0 ff ff       	call   801326 <fd_alloc>
  802310:	89 c3                	mov    %eax,%ebx
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 88 23 01 00 00    	js     802440 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 07 04 00 00       	push   $0x407
  802325:	ff 75 f4             	pushl  -0xc(%ebp)
  802328:	6a 00                	push   $0x0
  80232a:	e8 b8 e9 ff ff       	call   800ce7 <sys_page_alloc>
  80232f:	89 c3                	mov    %eax,%ebx
  802331:	83 c4 10             	add    $0x10,%esp
  802334:	85 c0                	test   %eax,%eax
  802336:	0f 88 04 01 00 00    	js     802440 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802342:	50                   	push   %eax
  802343:	e8 de ef ff ff       	call   801326 <fd_alloc>
  802348:	89 c3                	mov    %eax,%ebx
  80234a:	83 c4 10             	add    $0x10,%esp
  80234d:	85 c0                	test   %eax,%eax
  80234f:	0f 88 db 00 00 00    	js     802430 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 07 04 00 00       	push   $0x407
  80235d:	ff 75 f0             	pushl  -0x10(%ebp)
  802360:	6a 00                	push   $0x0
  802362:	e8 80 e9 ff ff       	call   800ce7 <sys_page_alloc>
  802367:	89 c3                	mov    %eax,%ebx
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	85 c0                	test   %eax,%eax
  80236e:	0f 88 bc 00 00 00    	js     802430 <pipe+0x135>
	va = fd2data(fd0);
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	ff 75 f4             	pushl  -0xc(%ebp)
  80237a:	e8 88 ef ff ff       	call   801307 <fd2data>
  80237f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802381:	83 c4 0c             	add    $0xc,%esp
  802384:	68 07 04 00 00       	push   $0x407
  802389:	50                   	push   %eax
  80238a:	6a 00                	push   $0x0
  80238c:	e8 56 e9 ff ff       	call   800ce7 <sys_page_alloc>
  802391:	89 c3                	mov    %eax,%ebx
  802393:	83 c4 10             	add    $0x10,%esp
  802396:	85 c0                	test   %eax,%eax
  802398:	0f 88 82 00 00 00    	js     802420 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239e:	83 ec 0c             	sub    $0xc,%esp
  8023a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a4:	e8 5e ef ff ff       	call   801307 <fd2data>
  8023a9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023b0:	50                   	push   %eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	56                   	push   %esi
  8023b4:	6a 00                	push   $0x0
  8023b6:	e8 54 e9 ff ff       	call   800d0f <sys_page_map>
  8023bb:	89 c3                	mov    %eax,%ebx
  8023bd:	83 c4 20             	add    $0x20,%esp
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	78 4e                	js     802412 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8023c4:	a1 28 40 80 00       	mov    0x804028,%eax
  8023c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023db:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8023ed:	e8 01 ef ff ff       	call   8012f3 <fd2num>
  8023f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023f7:	83 c4 04             	add    $0x4,%esp
  8023fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8023fd:	e8 f1 ee ff ff       	call   8012f3 <fd2num>
  802402:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802405:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802410:	eb 2e                	jmp    802440 <pipe+0x145>
	sys_page_unmap(0, va);
  802412:	83 ec 08             	sub    $0x8,%esp
  802415:	56                   	push   %esi
  802416:	6a 00                	push   $0x0
  802418:	e8 1c e9 ff ff       	call   800d39 <sys_page_unmap>
  80241d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802420:	83 ec 08             	sub    $0x8,%esp
  802423:	ff 75 f0             	pushl  -0x10(%ebp)
  802426:	6a 00                	push   $0x0
  802428:	e8 0c e9 ff ff       	call   800d39 <sys_page_unmap>
  80242d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802430:	83 ec 08             	sub    $0x8,%esp
  802433:	ff 75 f4             	pushl  -0xc(%ebp)
  802436:	6a 00                	push   $0x0
  802438:	e8 fc e8 ff ff       	call   800d39 <sys_page_unmap>
  80243d:	83 c4 10             	add    $0x10,%esp
}
  802440:	89 d8                	mov    %ebx,%eax
  802442:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    

00802449 <pipeisclosed>:
{
  802449:	f3 0f 1e fb          	endbr32 
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802453:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802456:	50                   	push   %eax
  802457:	ff 75 08             	pushl  0x8(%ebp)
  80245a:	e8 1d ef ff ff       	call   80137c <fd_lookup>
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	85 c0                	test   %eax,%eax
  802464:	78 18                	js     80247e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802466:	83 ec 0c             	sub    $0xc,%esp
  802469:	ff 75 f4             	pushl  -0xc(%ebp)
  80246c:	e8 96 ee ff ff       	call   801307 <fd2data>
  802471:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	e8 1f fd ff ff       	call   80219a <_pipeisclosed>
  80247b:	83 c4 10             	add    $0x10,%esp
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802480:	f3 0f 1e fb          	endbr32 
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	56                   	push   %esi
  802488:	53                   	push   %ebx
  802489:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80248c:	85 f6                	test   %esi,%esi
  80248e:	74 13                	je     8024a3 <wait+0x23>
	e = &envs[ENVX(envid)];
  802490:	89 f3                	mov    %esi,%ebx
  802492:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802498:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80249b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8024a1:	eb 1b                	jmp    8024be <wait+0x3e>
	assert(envid != 0);
  8024a3:	68 1d 32 80 00       	push   $0x80321d
  8024a8:	68 19 31 80 00       	push   $0x803119
  8024ad:	6a 09                	push   $0x9
  8024af:	68 28 32 80 00       	push   $0x803228
  8024b4:	e8 55 dd ff ff       	call   80020e <_panic>
		sys_yield();
  8024b9:	e8 fe e7 ff ff       	call   800cbc <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8024be:	8b 43 48             	mov    0x48(%ebx),%eax
  8024c1:	39 f0                	cmp    %esi,%eax
  8024c3:	75 07                	jne    8024cc <wait+0x4c>
  8024c5:	8b 43 54             	mov    0x54(%ebx),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	75 ed                	jne    8024b9 <wait+0x39>
}
  8024cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024cf:	5b                   	pop    %ebx
  8024d0:	5e                   	pop    %esi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    

008024d3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024d3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	c3                   	ret    

008024dd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024dd:	f3 0f 1e fb          	endbr32 
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024e7:	68 33 32 80 00       	push   $0x803233
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	e8 6b e3 ff ff       	call   80085f <strcpy>
	return 0;
}
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <devcons_write>:
{
  8024fb:	f3 0f 1e fb          	endbr32 
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	57                   	push   %edi
  802503:	56                   	push   %esi
  802504:	53                   	push   %ebx
  802505:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80250b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802510:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802516:	3b 75 10             	cmp    0x10(%ebp),%esi
  802519:	73 31                	jae    80254c <devcons_write+0x51>
		m = n - tot;
  80251b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80251e:	29 f3                	sub    %esi,%ebx
  802520:	83 fb 7f             	cmp    $0x7f,%ebx
  802523:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802528:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	53                   	push   %ebx
  80252f:	89 f0                	mov    %esi,%eax
  802531:	03 45 0c             	add    0xc(%ebp),%eax
  802534:	50                   	push   %eax
  802535:	57                   	push   %edi
  802536:	e8 dc e4 ff ff       	call   800a17 <memmove>
		sys_cputs(buf, m);
  80253b:	83 c4 08             	add    $0x8,%esp
  80253e:	53                   	push   %ebx
  80253f:	57                   	push   %edi
  802540:	e8 d7 e6 ff ff       	call   800c1c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802545:	01 de                	add    %ebx,%esi
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	eb ca                	jmp    802516 <devcons_write+0x1b>
}
  80254c:	89 f0                	mov    %esi,%eax
  80254e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    

00802556 <devcons_read>:
{
  802556:	f3 0f 1e fb          	endbr32 
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 08             	sub    $0x8,%esp
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802569:	74 21                	je     80258c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80256b:	e8 d6 e6 ff ff       	call   800c46 <sys_cgetc>
  802570:	85 c0                	test   %eax,%eax
  802572:	75 07                	jne    80257b <devcons_read+0x25>
		sys_yield();
  802574:	e8 43 e7 ff ff       	call   800cbc <sys_yield>
  802579:	eb f0                	jmp    80256b <devcons_read+0x15>
	if (c < 0)
  80257b:	78 0f                	js     80258c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80257d:	83 f8 04             	cmp    $0x4,%eax
  802580:	74 0c                	je     80258e <devcons_read+0x38>
	*(char*)vbuf = c;
  802582:	8b 55 0c             	mov    0xc(%ebp),%edx
  802585:	88 02                	mov    %al,(%edx)
	return 1;
  802587:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    
		return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	eb f7                	jmp    80258c <devcons_read+0x36>

00802595 <cputchar>:
{
  802595:	f3 0f 1e fb          	endbr32 
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025a5:	6a 01                	push   $0x1
  8025a7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025aa:	50                   	push   %eax
  8025ab:	e8 6c e6 ff ff       	call   800c1c <sys_cputs>
}
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <getchar>:
{
  8025b5:	f3 0f 1e fb          	endbr32 
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025bf:	6a 01                	push   $0x1
  8025c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025c4:	50                   	push   %eax
  8025c5:	6a 00                	push   $0x0
  8025c7:	e8 33 f0 ff ff       	call   8015ff <read>
	if (r < 0)
  8025cc:	83 c4 10             	add    $0x10,%esp
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 06                	js     8025d9 <getchar+0x24>
	if (r < 1)
  8025d3:	74 06                	je     8025db <getchar+0x26>
	return c;
  8025d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    
		return -E_EOF;
  8025db:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025e0:	eb f7                	jmp    8025d9 <getchar+0x24>

008025e2 <iscons>:
{
  8025e2:	f3 0f 1e fb          	endbr32 
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ef:	50                   	push   %eax
  8025f0:	ff 75 08             	pushl  0x8(%ebp)
  8025f3:	e8 84 ed ff ff       	call   80137c <fd_lookup>
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	78 11                	js     802610 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802608:	39 10                	cmp    %edx,(%eax)
  80260a:	0f 94 c0             	sete   %al
  80260d:	0f b6 c0             	movzbl %al,%eax
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <opencons>:
{
  802612:	f3 0f 1e fb          	endbr32 
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80261c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80261f:	50                   	push   %eax
  802620:	e8 01 ed ff ff       	call   801326 <fd_alloc>
  802625:	83 c4 10             	add    $0x10,%esp
  802628:	85 c0                	test   %eax,%eax
  80262a:	78 3a                	js     802666 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	68 07 04 00 00       	push   $0x407
  802634:	ff 75 f4             	pushl  -0xc(%ebp)
  802637:	6a 00                	push   $0x0
  802639:	e8 a9 e6 ff ff       	call   800ce7 <sys_page_alloc>
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	85 c0                	test   %eax,%eax
  802643:	78 21                	js     802666 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80264e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80265a:	83 ec 0c             	sub    $0xc,%esp
  80265d:	50                   	push   %eax
  80265e:	e8 90 ec ff ff       	call   8012f3 <fd2num>
  802663:	83 c4 10             	add    $0x10,%esp
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802668:	f3 0f 1e fb          	endbr32 
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802672:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802679:	74 0a                	je     802685 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  802685:	a1 04 50 80 00       	mov    0x805004,%eax
  80268a:	8b 40 48             	mov    0x48(%eax),%eax
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	6a 07                	push   $0x7
  802692:	68 00 f0 bf ee       	push   $0xeebff000
  802697:	50                   	push   %eax
  802698:	e8 4a e6 ff ff       	call   800ce7 <sys_page_alloc>
		if (r!= 0)
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	75 2f                	jne    8026d3 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8026a4:	a1 04 50 80 00       	mov    0x805004,%eax
  8026a9:	8b 40 48             	mov    0x48(%eax),%eax
  8026ac:	83 ec 08             	sub    $0x8,%esp
  8026af:	68 e5 26 80 00       	push   $0x8026e5
  8026b4:	50                   	push   %eax
  8026b5:	e8 f4 e6 ff ff       	call   800dae <sys_env_set_pgfault_upcall>
		if (r!= 0)
  8026ba:	83 c4 10             	add    $0x10,%esp
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 ba                	je     80267b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  8026c1:	50                   	push   %eax
  8026c2:	68 3f 32 80 00       	push   $0x80323f
  8026c7:	6a 26                	push   $0x26
  8026c9:	68 57 32 80 00       	push   $0x803257
  8026ce:	e8 3b db ff ff       	call   80020e <_panic>
			panic("set_pgfault_handler: %e", r);
  8026d3:	50                   	push   %eax
  8026d4:	68 3f 32 80 00       	push   $0x80323f
  8026d9:	6a 22                	push   $0x22
  8026db:	68 57 32 80 00       	push   $0x803257
  8026e0:	e8 29 db ff ff       	call   80020e <_panic>

008026e5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8026e5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8026e6:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8026eb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8026ed:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  8026f0:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  8026f4:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  8026f7:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  8026fb:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  8026ff:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802701:	83 c4 08             	add    $0x8,%esp
	popal
  802704:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802705:	83 c4 04             	add    $0x4,%esp
	popfl
  802708:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802709:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80270a:	c3                   	ret    

0080270b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80270b:	f3 0f 1e fb          	endbr32 
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	8b 75 08             	mov    0x8(%ebp),%esi
  802717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  80271d:	85 c0                	test   %eax,%eax
  80271f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802724:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  802727:	83 ec 0c             	sub    $0xc,%esp
  80272a:	50                   	push   %eax
  80272b:	e8 ce e6 ff ff       	call   800dfe <sys_ipc_recv>
	if (r < 0) {
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	85 c0                	test   %eax,%eax
  802735:	78 2b                	js     802762 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  802737:	85 f6                	test   %esi,%esi
  802739:	74 0a                	je     802745 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  80273b:	a1 04 50 80 00       	mov    0x805004,%eax
  802740:	8b 40 74             	mov    0x74(%eax),%eax
  802743:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  802745:	85 db                	test   %ebx,%ebx
  802747:	74 0a                	je     802753 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  802749:	a1 04 50 80 00       	mov    0x805004,%eax
  80274e:	8b 40 78             	mov    0x78(%eax),%eax
  802751:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802753:	a1 04 50 80 00       	mov    0x805004,%eax
  802758:	8b 40 70             	mov    0x70(%eax),%eax
}
  80275b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80275e:	5b                   	pop    %ebx
  80275f:	5e                   	pop    %esi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    
		if (from_env_store) {
  802762:	85 f6                	test   %esi,%esi
  802764:	74 06                	je     80276c <ipc_recv+0x61>
			*from_env_store = 0;
  802766:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  80276c:	85 db                	test   %ebx,%ebx
  80276e:	74 eb                	je     80275b <ipc_recv+0x50>
			*perm_store = 0;
  802770:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802776:	eb e3                	jmp    80275b <ipc_recv+0x50>

00802778 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802778:	f3 0f 1e fb          	endbr32 
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	57                   	push   %edi
  802780:	56                   	push   %esi
  802781:	53                   	push   %ebx
  802782:	83 ec 0c             	sub    $0xc,%esp
  802785:	8b 7d 08             	mov    0x8(%ebp),%edi
  802788:	8b 75 0c             	mov    0xc(%ebp),%esi
  80278b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  80278e:	85 db                	test   %ebx,%ebx
  802790:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802795:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802798:	ff 75 14             	pushl  0x14(%ebp)
  80279b:	53                   	push   %ebx
  80279c:	56                   	push   %esi
  80279d:	57                   	push   %edi
  80279e:	e8 32 e6 ff ff       	call   800dd5 <sys_ipc_try_send>
  8027a3:	83 c4 10             	add    $0x10,%esp
  8027a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027a9:	75 07                	jne    8027b2 <ipc_send+0x3a>
		sys_yield();
  8027ab:	e8 0c e5 ff ff       	call   800cbc <sys_yield>
  8027b0:	eb e6                	jmp    802798 <ipc_send+0x20>
	}

	if (ret < 0) {
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	78 08                	js     8027be <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8027b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027b9:	5b                   	pop    %ebx
  8027ba:	5e                   	pop    %esi
  8027bb:	5f                   	pop    %edi
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  8027be:	50                   	push   %eax
  8027bf:	68 65 32 80 00       	push   $0x803265
  8027c4:	6a 48                	push   $0x48
  8027c6:	68 82 32 80 00       	push   $0x803282
  8027cb:	e8 3e da ff ff       	call   80020e <_panic>

008027d0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027d0:	f3 0f 1e fb          	endbr32 
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027df:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027e2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027e8:	8b 52 50             	mov    0x50(%edx),%edx
  8027eb:	39 ca                	cmp    %ecx,%edx
  8027ed:	74 11                	je     802800 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8027ef:	83 c0 01             	add    $0x1,%eax
  8027f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027f7:	75 e6                	jne    8027df <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	eb 0b                	jmp    80280b <ipc_find_env+0x3b>
			return envs[i].env_id;
  802800:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802803:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802808:	8b 40 48             	mov    0x48(%eax),%eax
}
  80280b:	5d                   	pop    %ebp
  80280c:	c3                   	ret    

0080280d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80280d:	f3 0f 1e fb          	endbr32 
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802817:	89 c2                	mov    %eax,%edx
  802819:	c1 ea 16             	shr    $0x16,%edx
  80281c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802823:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802828:	f6 c1 01             	test   $0x1,%cl
  80282b:	74 1c                	je     802849 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80282d:	c1 e8 0c             	shr    $0xc,%eax
  802830:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802837:	a8 01                	test   $0x1,%al
  802839:	74 0e                	je     802849 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80283b:	c1 e8 0c             	shr    $0xc,%eax
  80283e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802845:	ef 
  802846:	0f b7 d2             	movzwl %dx,%edx
}
  802849:	89 d0                	mov    %edx,%eax
  80284b:	5d                   	pop    %ebp
  80284c:	c3                   	ret    
  80284d:	66 90                	xchg   %ax,%ax
  80284f:	90                   	nop

00802850 <__udivdi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80285f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802863:	8b 74 24 34          	mov    0x34(%esp),%esi
  802867:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80286b:	85 d2                	test   %edx,%edx
  80286d:	75 19                	jne    802888 <__udivdi3+0x38>
  80286f:	39 f3                	cmp    %esi,%ebx
  802871:	76 4d                	jbe    8028c0 <__udivdi3+0x70>
  802873:	31 ff                	xor    %edi,%edi
  802875:	89 e8                	mov    %ebp,%eax
  802877:	89 f2                	mov    %esi,%edx
  802879:	f7 f3                	div    %ebx
  80287b:	89 fa                	mov    %edi,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	39 f2                	cmp    %esi,%edx
  80288a:	76 14                	jbe    8028a0 <__udivdi3+0x50>
  80288c:	31 ff                	xor    %edi,%edi
  80288e:	31 c0                	xor    %eax,%eax
  802890:	89 fa                	mov    %edi,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028a0:	0f bd fa             	bsr    %edx,%edi
  8028a3:	83 f7 1f             	xor    $0x1f,%edi
  8028a6:	75 48                	jne    8028f0 <__udivdi3+0xa0>
  8028a8:	39 f2                	cmp    %esi,%edx
  8028aa:	72 06                	jb     8028b2 <__udivdi3+0x62>
  8028ac:	31 c0                	xor    %eax,%eax
  8028ae:	39 eb                	cmp    %ebp,%ebx
  8028b0:	77 de                	ja     802890 <__udivdi3+0x40>
  8028b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b7:	eb d7                	jmp    802890 <__udivdi3+0x40>
  8028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c0:	89 d9                	mov    %ebx,%ecx
  8028c2:	85 db                	test   %ebx,%ebx
  8028c4:	75 0b                	jne    8028d1 <__udivdi3+0x81>
  8028c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	f7 f3                	div    %ebx
  8028cf:	89 c1                	mov    %eax,%ecx
  8028d1:	31 d2                	xor    %edx,%edx
  8028d3:	89 f0                	mov    %esi,%eax
  8028d5:	f7 f1                	div    %ecx
  8028d7:	89 c6                	mov    %eax,%esi
  8028d9:	89 e8                	mov    %ebp,%eax
  8028db:	89 f7                	mov    %esi,%edi
  8028dd:	f7 f1                	div    %ecx
  8028df:	89 fa                	mov    %edi,%edx
  8028e1:	83 c4 1c             	add    $0x1c,%esp
  8028e4:	5b                   	pop    %ebx
  8028e5:	5e                   	pop    %esi
  8028e6:	5f                   	pop    %edi
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    
  8028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f0:	89 f9                	mov    %edi,%ecx
  8028f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028f7:	29 f8                	sub    %edi,%eax
  8028f9:	d3 e2                	shl    %cl,%edx
  8028fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028ff:	89 c1                	mov    %eax,%ecx
  802901:	89 da                	mov    %ebx,%edx
  802903:	d3 ea                	shr    %cl,%edx
  802905:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802909:	09 d1                	or     %edx,%ecx
  80290b:	89 f2                	mov    %esi,%edx
  80290d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802911:	89 f9                	mov    %edi,%ecx
  802913:	d3 e3                	shl    %cl,%ebx
  802915:	89 c1                	mov    %eax,%ecx
  802917:	d3 ea                	shr    %cl,%edx
  802919:	89 f9                	mov    %edi,%ecx
  80291b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80291f:	89 eb                	mov    %ebp,%ebx
  802921:	d3 e6                	shl    %cl,%esi
  802923:	89 c1                	mov    %eax,%ecx
  802925:	d3 eb                	shr    %cl,%ebx
  802927:	09 de                	or     %ebx,%esi
  802929:	89 f0                	mov    %esi,%eax
  80292b:	f7 74 24 08          	divl   0x8(%esp)
  80292f:	89 d6                	mov    %edx,%esi
  802931:	89 c3                	mov    %eax,%ebx
  802933:	f7 64 24 0c          	mull   0xc(%esp)
  802937:	39 d6                	cmp    %edx,%esi
  802939:	72 15                	jb     802950 <__udivdi3+0x100>
  80293b:	89 f9                	mov    %edi,%ecx
  80293d:	d3 e5                	shl    %cl,%ebp
  80293f:	39 c5                	cmp    %eax,%ebp
  802941:	73 04                	jae    802947 <__udivdi3+0xf7>
  802943:	39 d6                	cmp    %edx,%esi
  802945:	74 09                	je     802950 <__udivdi3+0x100>
  802947:	89 d8                	mov    %ebx,%eax
  802949:	31 ff                	xor    %edi,%edi
  80294b:	e9 40 ff ff ff       	jmp    802890 <__udivdi3+0x40>
  802950:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802953:	31 ff                	xor    %edi,%edi
  802955:	e9 36 ff ff ff       	jmp    802890 <__udivdi3+0x40>
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__umoddi3>:
  802960:	f3 0f 1e fb          	endbr32 
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80296f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802973:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 19                	jne    802998 <__umoddi3+0x38>
  80297f:	39 df                	cmp    %ebx,%edi
  802981:	76 5d                	jbe    8029e0 <__umoddi3+0x80>
  802983:	89 f0                	mov    %esi,%eax
  802985:	89 da                	mov    %ebx,%edx
  802987:	f7 f7                	div    %edi
  802989:	89 d0                	mov    %edx,%eax
  80298b:	31 d2                	xor    %edx,%edx
  80298d:	83 c4 1c             	add    $0x1c,%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	89 f2                	mov    %esi,%edx
  80299a:	39 d8                	cmp    %ebx,%eax
  80299c:	76 12                	jbe    8029b0 <__umoddi3+0x50>
  80299e:	89 f0                	mov    %esi,%eax
  8029a0:	89 da                	mov    %ebx,%edx
  8029a2:	83 c4 1c             	add    $0x1c,%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5f                   	pop    %edi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
  8029aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b0:	0f bd e8             	bsr    %eax,%ebp
  8029b3:	83 f5 1f             	xor    $0x1f,%ebp
  8029b6:	75 50                	jne    802a08 <__umoddi3+0xa8>
  8029b8:	39 d8                	cmp    %ebx,%eax
  8029ba:	0f 82 e0 00 00 00    	jb     802aa0 <__umoddi3+0x140>
  8029c0:	89 d9                	mov    %ebx,%ecx
  8029c2:	39 f7                	cmp    %esi,%edi
  8029c4:	0f 86 d6 00 00 00    	jbe    802aa0 <__umoddi3+0x140>
  8029ca:	89 d0                	mov    %edx,%eax
  8029cc:	89 ca                	mov    %ecx,%edx
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	89 fd                	mov    %edi,%ebp
  8029e2:	85 ff                	test   %edi,%edi
  8029e4:	75 0b                	jne    8029f1 <__umoddi3+0x91>
  8029e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f7                	div    %edi
  8029ef:	89 c5                	mov    %eax,%ebp
  8029f1:	89 d8                	mov    %ebx,%eax
  8029f3:	31 d2                	xor    %edx,%edx
  8029f5:	f7 f5                	div    %ebp
  8029f7:	89 f0                	mov    %esi,%eax
  8029f9:	f7 f5                	div    %ebp
  8029fb:	89 d0                	mov    %edx,%eax
  8029fd:	31 d2                	xor    %edx,%edx
  8029ff:	eb 8c                	jmp    80298d <__umoddi3+0x2d>
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 e9                	mov    %ebp,%ecx
  802a0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a0f:	29 ea                	sub    %ebp,%edx
  802a11:	d3 e0                	shl    %cl,%eax
  802a13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a17:	89 d1                	mov    %edx,%ecx
  802a19:	89 f8                	mov    %edi,%eax
  802a1b:	d3 e8                	shr    %cl,%eax
  802a1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a29:	09 c1                	or     %eax,%ecx
  802a2b:	89 d8                	mov    %ebx,%eax
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 e9                	mov    %ebp,%ecx
  802a33:	d3 e7                	shl    %cl,%edi
  802a35:	89 d1                	mov    %edx,%ecx
  802a37:	d3 e8                	shr    %cl,%eax
  802a39:	89 e9                	mov    %ebp,%ecx
  802a3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a3f:	d3 e3                	shl    %cl,%ebx
  802a41:	89 c7                	mov    %eax,%edi
  802a43:	89 d1                	mov    %edx,%ecx
  802a45:	89 f0                	mov    %esi,%eax
  802a47:	d3 e8                	shr    %cl,%eax
  802a49:	89 e9                	mov    %ebp,%ecx
  802a4b:	89 fa                	mov    %edi,%edx
  802a4d:	d3 e6                	shl    %cl,%esi
  802a4f:	09 d8                	or     %ebx,%eax
  802a51:	f7 74 24 08          	divl   0x8(%esp)
  802a55:	89 d1                	mov    %edx,%ecx
  802a57:	89 f3                	mov    %esi,%ebx
  802a59:	f7 64 24 0c          	mull   0xc(%esp)
  802a5d:	89 c6                	mov    %eax,%esi
  802a5f:	89 d7                	mov    %edx,%edi
  802a61:	39 d1                	cmp    %edx,%ecx
  802a63:	72 06                	jb     802a6b <__umoddi3+0x10b>
  802a65:	75 10                	jne    802a77 <__umoddi3+0x117>
  802a67:	39 c3                	cmp    %eax,%ebx
  802a69:	73 0c                	jae    802a77 <__umoddi3+0x117>
  802a6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a73:	89 d7                	mov    %edx,%edi
  802a75:	89 c6                	mov    %eax,%esi
  802a77:	89 ca                	mov    %ecx,%edx
  802a79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a7e:	29 f3                	sub    %esi,%ebx
  802a80:	19 fa                	sbb    %edi,%edx
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	d3 e0                	shl    %cl,%eax
  802a86:	89 e9                	mov    %ebp,%ecx
  802a88:	d3 eb                	shr    %cl,%ebx
  802a8a:	d3 ea                	shr    %cl,%edx
  802a8c:	09 d8                	or     %ebx,%eax
  802a8e:	83 c4 1c             	add    $0x1c,%esp
  802a91:	5b                   	pop    %ebx
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    
  802a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a9d:	8d 76 00             	lea    0x0(%esi),%esi
  802aa0:	29 fe                	sub    %edi,%esi
  802aa2:	19 c3                	sbb    %eax,%ebx
  802aa4:	89 f2                	mov    %esi,%edx
  802aa6:	89 d9                	mov    %ebx,%ecx
  802aa8:	e9 1d ff ff ff       	jmp    8029ca <__umoddi3+0x6a>
