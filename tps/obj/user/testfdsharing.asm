
obj/user/testfdsharing.debug:     formato del fichero elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
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

00800035 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800035:	f3 0f 1e fb          	endbr32 
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	57                   	push   %edi
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800042:	6a 00                	push   $0x0
  800044:	68 60 25 80 00       	push   $0x802560
  800049:	e8 b7 1a 00 00       	call   801b05 <open>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 03 01 00 00    	js     80015e <umain+0x129>
		panic("open motd: %e", fd);
	seek(fd, 0);
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	6a 00                	push   $0x0
  800060:	50                   	push   %eax
  800061:	e8 27 17 00 00       	call   80178d <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800066:	83 c4 0c             	add    $0xc,%esp
  800069:	68 00 02 00 00       	push   $0x200
  80006e:	68 20 42 80 00       	push   $0x804220
  800073:	53                   	push   %ebx
  800074:	e8 43 16 00 00       	call   8016bc <readn>
  800079:	89 c6                	mov    %eax,%esi
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	85 c0                	test   %eax,%eax
  800080:	0f 8e ea 00 00 00    	jle    800170 <umain+0x13b>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800086:	e8 4e 11 00 00       	call   8011d9 <fork>
  80008b:	89 c7                	mov    %eax,%edi
  80008d:	85 c0                	test   %eax,%eax
  80008f:	0f 88 ed 00 00 00    	js     800182 <umain+0x14d>
		panic("fork: %e", r);
	if (r == 0) {
  800095:	75 7b                	jne    800112 <umain+0xdd>
		seek(fd, 0);
  800097:	83 ec 08             	sub    $0x8,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	53                   	push   %ebx
  80009d:	e8 eb 16 00 00       	call   80178d <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000a2:	c7 04 24 c8 25 80 00 	movl   $0x8025c8,(%esp)
  8000a9:	e8 79 02 00 00       	call   800327 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 02 00 00       	push   $0x200
  8000b6:	68 20 40 80 00       	push   $0x804020
  8000bb:	53                   	push   %ebx
  8000bc:	e8 fb 15 00 00       	call   8016bc <readn>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	39 c6                	cmp    %eax,%esi
  8000c6:	0f 85 c8 00 00 00    	jne    800194 <umain+0x15f>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	56                   	push   %esi
  8000d0:	68 20 40 80 00       	push   $0x804020
  8000d5:	68 20 42 80 00       	push   $0x804220
  8000da:	e8 ea 09 00 00       	call   800ac9 <memcmp>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	0f 85 c0 00 00 00    	jne    8001aa <umain+0x175>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 92 25 80 00       	push   $0x802592
  8000f2:	e8 30 02 00 00       	call   800327 <cprintf>
		seek(fd, 0);
  8000f7:	83 c4 08             	add    $0x8,%esp
  8000fa:	6a 00                	push   $0x0
  8000fc:	53                   	push   %ebx
  8000fd:	e8 8b 16 00 00       	call   80178d <seek>
		close(fd);
  800102:	89 1c 24             	mov    %ebx,(%esp)
  800105:	e8 dd 13 00 00       	call   8014e7 <close>
		exit();
  80010a:	e8 13 01 00 00       	call   800222 <exit>
  80010f:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	57                   	push   %edi
  800116:	e8 fd 1d 00 00       	call   801f18 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  80011b:	83 c4 0c             	add    $0xc,%esp
  80011e:	68 00 02 00 00       	push   $0x200
  800123:	68 20 40 80 00       	push   $0x804020
  800128:	53                   	push   %ebx
  800129:	e8 8e 15 00 00       	call   8016bc <readn>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	39 c6                	cmp    %eax,%esi
  800133:	0f 85 85 00 00 00    	jne    8001be <umain+0x189>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	68 ab 25 80 00       	push   $0x8025ab
  800141:	e8 e1 01 00 00       	call   800327 <cprintf>
	close(fd);
  800146:	89 1c 24             	mov    %ebx,(%esp)
  800149:	e8 99 13 00 00       	call   8014e7 <close>

	breakpoint();
  80014e:	e8 e0 fe ff ff       	call   800033 <breakpoint>
}
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    
		panic("open motd: %e", fd);
  80015e:	50                   	push   %eax
  80015f:	68 65 25 80 00       	push   $0x802565
  800164:	6a 0c                	push   $0xc
  800166:	68 73 25 80 00       	push   $0x802573
  80016b:	e8 d0 00 00 00       	call   800240 <_panic>
		panic("readn: %e", n);
  800170:	50                   	push   %eax
  800171:	68 88 25 80 00       	push   $0x802588
  800176:	6a 0f                	push   $0xf
  800178:	68 73 25 80 00       	push   $0x802573
  80017d:	e8 be 00 00 00       	call   800240 <_panic>
		panic("fork: %e", r);
  800182:	50                   	push   %eax
  800183:	68 67 2a 80 00       	push   $0x802a67
  800188:	6a 12                	push   $0x12
  80018a:	68 73 25 80 00       	push   $0x802573
  80018f:	e8 ac 00 00 00       	call   800240 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	56                   	push   %esi
  800199:	68 0c 26 80 00       	push   $0x80260c
  80019e:	6a 17                	push   $0x17
  8001a0:	68 73 25 80 00       	push   $0x802573
  8001a5:	e8 96 00 00 00       	call   800240 <_panic>
			panic("read in parent got different bytes from read in child");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 38 26 80 00       	push   $0x802638
  8001b2:	6a 19                	push   $0x19
  8001b4:	68 73 25 80 00       	push   $0x802573
  8001b9:	e8 82 00 00 00       	call   800240 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	50                   	push   %eax
  8001c2:	56                   	push   %esi
  8001c3:	68 70 26 80 00       	push   $0x802670
  8001c8:	6a 21                	push   $0x21
  8001ca:	68 73 25 80 00       	push   $0x802573
  8001cf:	e8 6c 00 00 00       	call   800240 <_panic>

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	f3 0f 1e fb          	endbr32 
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001e3:	e8 de 0a 00 00       	call   800cc6 <sys_getenvid>
	if (id >= 0)
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	78 12                	js     8001fe <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8001ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f9:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fe:	85 db                	test   %ebx,%ebx
  800200:	7e 07                	jle    800209 <libmain+0x35>
		binaryname = argv[0];
  800202:	8b 06                	mov    (%esi),%eax
  800204:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	56                   	push   %esi
  80020d:	53                   	push   %ebx
  80020e:	e8 22 fe ff ff       	call   800035 <umain>

	// exit gracefully
	exit();
  800213:	e8 0a 00 00 00       	call   800222 <exit>
}
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021e:	5b                   	pop    %ebx
  80021f:	5e                   	pop    %esi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    

00800222 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800222:	f3 0f 1e fb          	endbr32 
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80022c:	e8 e7 12 00 00       	call   801518 <close_all>
	sys_env_destroy(0);
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	6a 00                	push   $0x0
  800236:	e8 65 0a 00 00       	call   800ca0 <sys_env_destroy>
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800240:	f3 0f 1e fb          	endbr32 
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800249:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80024c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800252:	e8 6f 0a 00 00       	call   800cc6 <sys_getenvid>
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 0c             	pushl  0xc(%ebp)
  80025d:	ff 75 08             	pushl  0x8(%ebp)
  800260:	56                   	push   %esi
  800261:	50                   	push   %eax
  800262:	68 a0 26 80 00       	push   $0x8026a0
  800267:	e8 bb 00 00 00       	call   800327 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026c:	83 c4 18             	add    $0x18,%esp
  80026f:	53                   	push   %ebx
  800270:	ff 75 10             	pushl  0x10(%ebp)
  800273:	e8 5a 00 00 00       	call   8002d2 <vcprintf>
	cprintf("\n");
  800278:	c7 04 24 fe 2c 80 00 	movl   $0x802cfe,(%esp)
  80027f:	e8 a3 00 00 00       	call   800327 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800287:	cc                   	int3   
  800288:	eb fd                	jmp    800287 <_panic+0x47>

0080028a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	53                   	push   %ebx
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800298:	8b 13                	mov    (%ebx),%edx
  80029a:	8d 42 01             	lea    0x1(%edx),%eax
  80029d:	89 03                	mov    %eax,(%ebx)
  80029f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ab:	74 09                	je     8002b6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	68 ff 00 00 00       	push   $0xff
  8002be:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c1:	50                   	push   %eax
  8002c2:	e8 87 09 00 00       	call   800c4e <sys_cputs>
		b->idx = 0;
  8002c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	eb db                	jmp    8002ad <putch+0x23>

008002d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d2:	f3 0f 1e fb          	endbr32 
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e6:	00 00 00 
	b.cnt = 0;
  8002e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	68 8a 02 80 00       	push   $0x80028a
  800305:	e8 80 01 00 00       	call   80048a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030a:	83 c4 08             	add    $0x8,%esp
  80030d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800313:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	e8 2f 09 00 00       	call   800c4e <sys_cputs>

	return b.cnt;
}
  80031f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800327:	f3 0f 1e fb          	endbr32 
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800331:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800334:	50                   	push   %eax
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	e8 95 ff ff ff       	call   8002d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 1c             	sub    $0x1c,%esp
  800348:	89 c7                	mov    %eax,%edi
  80034a:	89 d6                	mov    %edx,%esi
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800352:	89 d1                	mov    %edx,%ecx
  800354:	89 c2                	mov    %eax,%edx
  800356:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800359:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800365:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800371:	72 3e                	jb     8003b1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	ff 75 18             	pushl  0x18(%ebp)
  800379:	83 eb 01             	sub    $0x1,%ebx
  80037c:	53                   	push   %ebx
  80037d:	50                   	push   %eax
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	ff 75 e4             	pushl  -0x1c(%ebp)
  800384:	ff 75 e0             	pushl  -0x20(%ebp)
  800387:	ff 75 dc             	pushl  -0x24(%ebp)
  80038a:	ff 75 d8             	pushl  -0x28(%ebp)
  80038d:	e8 5e 1f 00 00       	call   8022f0 <__udivdi3>
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	89 f2                	mov    %esi,%edx
  800399:	89 f8                	mov    %edi,%eax
  80039b:	e8 9f ff ff ff       	call   80033f <printnum>
  8003a0:	83 c4 20             	add    $0x20,%esp
  8003a3:	eb 13                	jmp    8003b8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	56                   	push   %esi
  8003a9:	ff 75 18             	pushl  0x18(%ebp)
  8003ac:	ff d7                	call   *%edi
  8003ae:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b1:	83 eb 01             	sub    $0x1,%ebx
  8003b4:	85 db                	test   %ebx,%ebx
  8003b6:	7f ed                	jg     8003a5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	56                   	push   %esi
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cb:	e8 30 20 00 00       	call   802400 <__umoddi3>
  8003d0:	83 c4 14             	add    $0x14,%esp
  8003d3:	0f be 80 c3 26 80 00 	movsbl 0x8026c3(%eax),%eax
  8003da:	50                   	push   %eax
  8003db:	ff d7                	call   *%edi
}
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8003e8:	83 fa 01             	cmp    $0x1,%edx
  8003eb:	7f 13                	jg     800400 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8003ed:	85 d2                	test   %edx,%edx
  8003ef:	74 1c                	je     80040d <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 02                	mov    (%edx),%eax
  8003fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ff:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 08             	lea    0x8(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	8b 52 04             	mov    0x4(%edx),%edx
  80040c:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80040d:	8b 10                	mov    (%eax),%edx
  80040f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800412:	89 08                	mov    %ecx,(%eax)
  800414:	8b 02                	mov    (%edx),%eax
  800416:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041b:	c3                   	ret    

0080041c <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80041c:	83 fa 01             	cmp    $0x1,%edx
  80041f:	7f 0f                	jg     800430 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800421:	85 d2                	test   %edx,%edx
  800423:	74 18                	je     80043d <getint+0x21>
		return va_arg(*ap, long);
  800425:	8b 10                	mov    (%eax),%edx
  800427:	8d 4a 04             	lea    0x4(%edx),%ecx
  80042a:	89 08                	mov    %ecx,(%eax)
  80042c:	8b 02                	mov    (%edx),%eax
  80042e:	99                   	cltd   
  80042f:	c3                   	ret    
		return va_arg(*ap, long long);
  800430:	8b 10                	mov    (%eax),%edx
  800432:	8d 4a 08             	lea    0x8(%edx),%ecx
  800435:	89 08                	mov    %ecx,(%eax)
  800437:	8b 02                	mov    (%edx),%eax
  800439:	8b 52 04             	mov    0x4(%edx),%edx
  80043c:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80043d:	8b 10                	mov    (%eax),%edx
  80043f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800442:	89 08                	mov    %ecx,(%eax)
  800444:	8b 02                	mov    (%edx),%eax
  800446:	99                   	cltd   
}
  800447:	c3                   	ret    

00800448 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800448:	f3 0f 1e fb          	endbr32 
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800452:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800456:	8b 10                	mov    (%eax),%edx
  800458:	3b 50 04             	cmp    0x4(%eax),%edx
  80045b:	73 0a                	jae    800467 <sprintputch+0x1f>
		*b->buf++ = ch;
  80045d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800460:	89 08                	mov    %ecx,(%eax)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	88 02                	mov    %al,(%edx)
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <printfmt>:
{
  800469:	f3 0f 1e fb          	endbr32 
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800473:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800476:	50                   	push   %eax
  800477:	ff 75 10             	pushl  0x10(%ebp)
  80047a:	ff 75 0c             	pushl  0xc(%ebp)
  80047d:	ff 75 08             	pushl  0x8(%ebp)
  800480:	e8 05 00 00 00       	call   80048a <vprintfmt>
}
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <vprintfmt>:
{
  80048a:	f3 0f 1e fb          	endbr32 
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	57                   	push   %edi
  800492:	56                   	push   %esi
  800493:	53                   	push   %ebx
  800494:	83 ec 2c             	sub    $0x2c,%esp
  800497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80049a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80049d:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a0:	e9 86 02 00 00       	jmp    80072b <vprintfmt+0x2a1>
		padc = ' ';
  8004a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004be:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8d 47 01             	lea    0x1(%edi),%eax
  8004c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004c9:	0f b6 17             	movzbl (%edi),%edx
  8004cc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004cf:	3c 55                	cmp    $0x55,%al
  8004d1:	0f 87 df 02 00 00    	ja     8007b6 <vprintfmt+0x32c>
  8004d7:	0f b6 c0             	movzbl %al,%eax
  8004da:	3e ff 24 85 00 28 80 	notrack jmp *0x802800(,%eax,4)
  8004e1:	00 
  8004e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004e5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004e9:	eb d8                	jmp    8004c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004f2:	eb cf                	jmp    8004c3 <vprintfmt+0x39>
  8004f4:	0f b6 d2             	movzbl %dl,%edx
  8004f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800502:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800505:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800509:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80050c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80050f:	83 f9 09             	cmp    $0x9,%ecx
  800512:	77 52                	ja     800566 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800514:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800517:	eb e9                	jmp    800502 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 50 04             	lea    0x4(%eax),%edx
  80051f:	89 55 14             	mov    %edx,0x14(%ebp)
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80052a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052e:	79 93                	jns    8004c3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800530:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800536:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053d:	eb 84                	jmp    8004c3 <vprintfmt+0x39>
  80053f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800542:	85 c0                	test   %eax,%eax
  800544:	ba 00 00 00 00       	mov    $0x0,%edx
  800549:	0f 49 d0             	cmovns %eax,%edx
  80054c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800552:	e9 6c ff ff ff       	jmp    8004c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800557:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80055a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800561:	e9 5d ff ff ff       	jmp    8004c3 <vprintfmt+0x39>
  800566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800569:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80056c:	eb bc                	jmp    80052a <vprintfmt+0xa0>
			lflag++;
  80056e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800574:	e9 4a ff ff ff       	jmp    8004c3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 50 04             	lea    0x4(%eax),%edx
  80057f:	89 55 14             	mov    %edx,0x14(%ebp)
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	56                   	push   %esi
  800586:	ff 30                	pushl  (%eax)
  800588:	ff d3                	call   *%ebx
			break;
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	e9 96 01 00 00       	jmp    800728 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 50 04             	lea    0x4(%eax),%edx
  800598:	89 55 14             	mov    %edx,0x14(%ebp)
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	99                   	cltd   
  80059e:	31 d0                	xor    %edx,%eax
  8005a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a2:	83 f8 0f             	cmp    $0xf,%eax
  8005a5:	7f 20                	jg     8005c7 <vprintfmt+0x13d>
  8005a7:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	74 15                	je     8005c7 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8005b2:	52                   	push   %edx
  8005b3:	68 5b 2c 80 00       	push   $0x802c5b
  8005b8:	56                   	push   %esi
  8005b9:	53                   	push   %ebx
  8005ba:	e8 aa fe ff ff       	call   800469 <printfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	e9 61 01 00 00       	jmp    800728 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8005c7:	50                   	push   %eax
  8005c8:	68 db 26 80 00       	push   $0x8026db
  8005cd:	56                   	push   %esi
  8005ce:	53                   	push   %ebx
  8005cf:	e8 95 fe ff ff       	call   800469 <printfmt>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	e9 4c 01 00 00       	jmp    800728 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 50 04             	lea    0x4(%eax),%edx
  8005e2:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e7:	85 c9                	test   %ecx,%ecx
  8005e9:	b8 d4 26 80 00       	mov    $0x8026d4,%eax
  8005ee:	0f 45 c1             	cmovne %ecx,%eax
  8005f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f8:	7e 06                	jle    800600 <vprintfmt+0x176>
  8005fa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005fe:	75 0d                	jne    80060d <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800600:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800603:	89 c7                	mov    %eax,%edi
  800605:	03 45 e0             	add    -0x20(%ebp),%eax
  800608:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060b:	eb 57                	jmp    800664 <vprintfmt+0x1da>
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	ff 75 d8             	pushl  -0x28(%ebp)
  800613:	ff 75 cc             	pushl  -0x34(%ebp)
  800616:	e8 4f 02 00 00       	call   80086a <strnlen>
  80061b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061e:	29 c2                	sub    %eax,%edx
  800620:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800623:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800626:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80062a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80062d:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80062f:	85 db                	test   %ebx,%ebx
  800631:	7e 10                	jle    800643 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	56                   	push   %esi
  800637:	57                   	push   %edi
  800638:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80063b:	83 eb 01             	sub    $0x1,%ebx
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	eb ec                	jmp    80062f <vprintfmt+0x1a5>
  800643:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800646:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800649:	85 d2                	test   %edx,%edx
  80064b:	b8 00 00 00 00       	mov    $0x0,%eax
  800650:	0f 49 c2             	cmovns %edx,%eax
  800653:	29 c2                	sub    %eax,%edx
  800655:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800658:	eb a6                	jmp    800600 <vprintfmt+0x176>
					putch(ch, putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	56                   	push   %esi
  80065e:	52                   	push   %edx
  80065f:	ff d3                	call   *%ebx
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800669:	83 c7 01             	add    $0x1,%edi
  80066c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800670:	0f be d0             	movsbl %al,%edx
  800673:	85 d2                	test   %edx,%edx
  800675:	74 42                	je     8006b9 <vprintfmt+0x22f>
  800677:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80067b:	78 06                	js     800683 <vprintfmt+0x1f9>
  80067d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800681:	78 1e                	js     8006a1 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800683:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800687:	74 d1                	je     80065a <vprintfmt+0x1d0>
  800689:	0f be c0             	movsbl %al,%eax
  80068c:	83 e8 20             	sub    $0x20,%eax
  80068f:	83 f8 5e             	cmp    $0x5e,%eax
  800692:	76 c6                	jbe    80065a <vprintfmt+0x1d0>
					putch('?', putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	56                   	push   %esi
  800698:	6a 3f                	push   $0x3f
  80069a:	ff d3                	call   *%ebx
  80069c:	83 c4 10             	add    $0x10,%esp
  80069f:	eb c3                	jmp    800664 <vprintfmt+0x1da>
  8006a1:	89 cf                	mov    %ecx,%edi
  8006a3:	eb 0e                	jmp    8006b3 <vprintfmt+0x229>
				putch(' ', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	56                   	push   %esi
  8006a9:	6a 20                	push   $0x20
  8006ab:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8006ad:	83 ef 01             	sub    $0x1,%edi
  8006b0:	83 c4 10             	add    $0x10,%esp
  8006b3:	85 ff                	test   %edi,%edi
  8006b5:	7f ee                	jg     8006a5 <vprintfmt+0x21b>
  8006b7:	eb 6f                	jmp    800728 <vprintfmt+0x29e>
  8006b9:	89 cf                	mov    %ecx,%edi
  8006bb:	eb f6                	jmp    8006b3 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8006bd:	89 ca                	mov    %ecx,%edx
  8006bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c2:	e8 55 fd ff ff       	call   80041c <getint>
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006cd:	85 d2                	test   %edx,%edx
  8006cf:	78 0b                	js     8006dc <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8006d1:	89 d1                	mov    %edx,%ecx
  8006d3:	89 c2                	mov    %eax,%edx
			base = 10;
  8006d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006da:	eb 32                	jmp    80070e <vprintfmt+0x284>
				putch('-', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	56                   	push   %esi
  8006e0:	6a 2d                	push   $0x2d
  8006e2:	ff d3                	call   *%ebx
				num = -(long long) num;
  8006e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006ea:	f7 da                	neg    %edx
  8006ec:	83 d1 00             	adc    $0x0,%ecx
  8006ef:	f7 d9                	neg    %ecx
  8006f1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f9:	eb 13                	jmp    80070e <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006fb:	89 ca                	mov    %ecx,%edx
  8006fd:	8d 45 14             	lea    0x14(%ebp),%eax
  800700:	e8 e3 fc ff ff       	call   8003e8 <getuint>
  800705:	89 d1                	mov    %edx,%ecx
  800707:	89 c2                	mov    %eax,%edx
			base = 10;
  800709:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800715:	57                   	push   %edi
  800716:	ff 75 e0             	pushl  -0x20(%ebp)
  800719:	50                   	push   %eax
  80071a:	51                   	push   %ecx
  80071b:	52                   	push   %edx
  80071c:	89 f2                	mov    %esi,%edx
  80071e:	89 d8                	mov    %ebx,%eax
  800720:	e8 1a fc ff ff       	call   80033f <printnum>
			break;
  800725:	83 c4 20             	add    $0x20,%esp
{
  800728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072b:	83 c7 01             	add    $0x1,%edi
  80072e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800732:	83 f8 25             	cmp    $0x25,%eax
  800735:	0f 84 6a fd ff ff    	je     8004a5 <vprintfmt+0x1b>
			if (ch == '\0')
  80073b:	85 c0                	test   %eax,%eax
  80073d:	0f 84 93 00 00 00    	je     8007d6 <vprintfmt+0x34c>
			putch(ch, putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	56                   	push   %esi
  800747:	50                   	push   %eax
  800748:	ff d3                	call   *%ebx
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	eb dc                	jmp    80072b <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80074f:	89 ca                	mov    %ecx,%edx
  800751:	8d 45 14             	lea    0x14(%ebp),%eax
  800754:	e8 8f fc ff ff       	call   8003e8 <getuint>
  800759:	89 d1                	mov    %edx,%ecx
  80075b:	89 c2                	mov    %eax,%edx
			base = 8;
  80075d:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800762:	eb aa                	jmp    80070e <vprintfmt+0x284>
			putch('0', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	56                   	push   %esi
  800768:	6a 30                	push   $0x30
  80076a:	ff d3                	call   *%ebx
			putch('x', putdat);
  80076c:	83 c4 08             	add    $0x8,%esp
  80076f:	56                   	push   %esi
  800770:	6a 78                	push   $0x78
  800772:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80077d:	8b 10                	mov    (%eax),%edx
  80077f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800784:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800787:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80078c:	eb 80                	jmp    80070e <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80078e:	89 ca                	mov    %ecx,%edx
  800790:	8d 45 14             	lea    0x14(%ebp),%eax
  800793:	e8 50 fc ff ff       	call   8003e8 <getuint>
  800798:	89 d1                	mov    %edx,%ecx
  80079a:	89 c2                	mov    %eax,%edx
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a1:	e9 68 ff ff ff       	jmp    80070e <vprintfmt+0x284>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	56                   	push   %esi
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d3                	call   *%ebx
			break;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	e9 72 ff ff ff       	jmp    800728 <vprintfmt+0x29e>
			putch('%', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	56                   	push   %esi
  8007ba:	6a 25                	push   $0x25
  8007bc:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 f8                	mov    %edi,%eax
  8007c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c7:	74 05                	je     8007ce <vprintfmt+0x344>
  8007c9:	83 e8 01             	sub    $0x1,%eax
  8007cc:	eb f5                	jmp    8007c3 <vprintfmt+0x339>
  8007ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d1:	e9 52 ff ff ff       	jmp    800728 <vprintfmt+0x29e>
}
  8007d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5e                   	pop    %esi
  8007db:	5f                   	pop    %edi
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 26                	je     800829 <vsnprintf+0x4b>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 22                	jle    800829 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	ff 75 14             	pushl  0x14(%ebp)
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	68 48 04 80 00       	push   $0x800448
  800816:	e8 6f fc ff ff       	call   80048a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082e:	eb f7                	jmp    800827 <vsnprintf+0x49>

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083d:	50                   	push   %eax
  80083e:	ff 75 10             	pushl  0x10(%ebp)
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 08             	pushl  0x8(%ebp)
  800847:	e8 92 ff ff ff       	call   8007de <vsnprintf>
	va_end(ap);

	return rc;
}
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800861:	74 05                	je     800868 <strlen+0x1a>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	eb f5                	jmp    80085d <strlen+0xf>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	f3 0f 1e fb          	endbr32 
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	39 d0                	cmp    %edx,%eax
  80087e:	74 0d                	je     80088d <strnlen+0x23>
  800880:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800884:	74 05                	je     80088b <strnlen+0x21>
		n++;
  800886:	83 c0 01             	add    $0x1,%eax
  800889:	eb f1                	jmp    80087c <strnlen+0x12>
  80088b:	89 c2                	mov    %eax,%edx
	return n;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800891:	f3 0f 1e fb          	endbr32 
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	84 d2                	test   %dl,%dl
  8008b0:	75 f2                	jne    8008a4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008b2:	89 c8                	mov    %ecx,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	83 ec 10             	sub    $0x10,%esp
  8008c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c5:	53                   	push   %ebx
  8008c6:	e8 83 ff ff ff       	call   80084e <strlen>
  8008cb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	01 d8                	add    %ebx,%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 b8 ff ff ff       	call   800891 <strcpy>
	return dst;
}
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	89 f3                	mov    %esi,%ebx
  8008f1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	39 d8                	cmp    %ebx,%eax
  8008f8:	74 11                	je     80090b <strncpy+0x2b>
		*dst++ = *src;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 0a             	movzbl (%edx),%ecx
  800900:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800903:	80 f9 01             	cmp    $0x1,%cl
  800906:	83 da ff             	sbb    $0xffffffff,%edx
  800909:	eb eb                	jmp    8008f6 <strncpy+0x16>
	}
	return ret;
}
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	56                   	push   %esi
  800919:	53                   	push   %ebx
  80091a:	8b 75 08             	mov    0x8(%ebp),%esi
  80091d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800920:	8b 55 10             	mov    0x10(%ebp),%edx
  800923:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800925:	85 d2                	test   %edx,%edx
  800927:	74 21                	je     80094a <strlcpy+0x39>
  800929:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	74 14                	je     800947 <strlcpy+0x36>
  800933:	0f b6 19             	movzbl (%ecx),%ebx
  800936:	84 db                	test   %bl,%bl
  800938:	74 0b                	je     800945 <strlcpy+0x34>
			*dst++ = *src++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	88 5a ff             	mov    %bl,-0x1(%edx)
  800943:	eb ea                	jmp    80092f <strlcpy+0x1e>
  800945:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800947:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094a:	29 f0                	sub    %esi,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5e                   	pop    %esi
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 0c                	je     800970 <strcmp+0x20>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	75 08                	jne    800970 <strcmp+0x20>
		p++, q++;
  800968:	83 c1 01             	add    $0x1,%ecx
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	eb ed                	jmp    80095d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 c0             	movzbl %al,%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strncmp+0x1b>
		n--, p++, q++;
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800995:	39 d8                	cmp    %ebx,%eax
  800997:	74 16                	je     8009af <strncmp+0x35>
  800999:	0f b6 08             	movzbl (%eax),%ecx
  80099c:	84 c9                	test   %cl,%cl
  80099e:	74 04                	je     8009a4 <strncmp+0x2a>
  8009a0:	3a 0a                	cmp    (%edx),%cl
  8009a2:	74 eb                	je     80098f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a4:	0f b6 00             	movzbl (%eax),%eax
  8009a7:	0f b6 12             	movzbl (%edx),%edx
  8009aa:	29 d0                	sub    %edx,%eax
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    
		return 0;
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	eb f6                	jmp    8009ac <strncmp+0x32>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	f3 0f 1e fb          	endbr32 
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	0f b6 10             	movzbl (%eax),%edx
  8009c7:	84 d2                	test   %dl,%dl
  8009c9:	74 09                	je     8009d4 <strchr+0x1e>
		if (*s == c)
  8009cb:	38 ca                	cmp    %cl,%dl
  8009cd:	74 0a                	je     8009d9 <strchr+0x23>
	for (; *s; s++)
  8009cf:	83 c0 01             	add    $0x1,%eax
  8009d2:	eb f0                	jmp    8009c4 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ec:	38 ca                	cmp    %cl,%dl
  8009ee:	74 09                	je     8009f9 <strfind+0x1e>
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	74 05                	je     8009f9 <strfind+0x1e>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 55 08             	mov    0x8(%ebp),%edx
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	74 33                	je     800a42 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0f:	89 d0                	mov    %edx,%eax
  800a11:	09 c8                	or     %ecx,%eax
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 23                	jne    800a3a <memset+0x3f>
		c &= 0xFF;
  800a17:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1b:	89 d8                	mov    %ebx,%eax
  800a1d:	c1 e0 08             	shl    $0x8,%eax
  800a20:	89 df                	mov    %ebx,%edi
  800a22:	c1 e7 18             	shl    $0x18,%edi
  800a25:	89 de                	mov    %ebx,%esi
  800a27:	c1 e6 10             	shl    $0x10,%esi
  800a2a:	09 f7                	or     %esi,%edi
  800a2c:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a2e:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a31:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800a33:	89 d7                	mov    %edx,%edi
  800a35:	fc                   	cld    
  800a36:	f3 ab                	rep stos %eax,%es:(%edi)
  800a38:	eb 08                	jmp    800a42 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3a:	89 d7                	mov    %edx,%edi
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	fc                   	cld    
  800a40:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5f                   	pop    %edi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a49:	f3 0f 1e fb          	endbr32 
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	57                   	push   %edi
  800a51:	56                   	push   %esi
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5b:	39 c6                	cmp    %eax,%esi
  800a5d:	73 32                	jae    800a91 <memmove+0x48>
  800a5f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	76 2b                	jbe    800a91 <memmove+0x48>
		s += n;
		d += n;
  800a66:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a69:	89 fe                	mov    %edi,%esi
  800a6b:	09 ce                	or     %ecx,%esi
  800a6d:	09 d6                	or     %edx,%esi
  800a6f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a75:	75 0e                	jne    800a85 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a77:	83 ef 04             	sub    $0x4,%edi
  800a7a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a80:	fd                   	std    
  800a81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a83:	eb 09                	jmp    800a8e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a85:	83 ef 01             	sub    $0x1,%edi
  800a88:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a8b:	fd                   	std    
  800a8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8e:	fc                   	cld    
  800a8f:	eb 1a                	jmp    800aab <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	89 c2                	mov    %eax,%edx
  800a93:	09 ca                	or     %ecx,%edx
  800a95:	09 f2                	or     %esi,%edx
  800a97:	f6 c2 03             	test   $0x3,%dl
  800a9a:	75 0a                	jne    800aa6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9f:	89 c7                	mov    %eax,%edi
  800aa1:	fc                   	cld    
  800aa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa4:	eb 05                	jmp    800aab <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	fc                   	cld    
  800aa9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaf:	f3 0f 1e fb          	endbr32 
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab9:	ff 75 10             	pushl  0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 82 ff ff ff       	call   800a49 <memmove>
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac9:	f3 0f 1e fb          	endbr32 
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad8:	89 c6                	mov    %eax,%esi
  800ada:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800add:	39 f0                	cmp    %esi,%eax
  800adf:	74 1c                	je     800afd <memcmp+0x34>
		if (*s1 != *s2)
  800ae1:	0f b6 08             	movzbl (%eax),%ecx
  800ae4:	0f b6 1a             	movzbl (%edx),%ebx
  800ae7:	38 d9                	cmp    %bl,%cl
  800ae9:	75 08                	jne    800af3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	eb ea                	jmp    800add <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800af3:	0f b6 c1             	movzbl %cl,%eax
  800af6:	0f b6 db             	movzbl %bl,%ebx
  800af9:	29 d8                	sub    %ebx,%eax
  800afb:	eb 05                	jmp    800b02 <memcmp+0x39>
	}

	return 0;
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b06:	f3 0f 1e fb          	endbr32 
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b13:	89 c2                	mov    %eax,%edx
  800b15:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b18:	39 d0                	cmp    %edx,%eax
  800b1a:	73 09                	jae    800b25 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1c:	38 08                	cmp    %cl,(%eax)
  800b1e:	74 05                	je     800b25 <memfind+0x1f>
	for (; s < ends; s++)
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	eb f3                	jmp    800b18 <memfind+0x12>
			break;
	return (void *) s;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b27:	f3 0f 1e fb          	endbr32 
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b37:	eb 03                	jmp    800b3c <strtol+0x15>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3c:	0f b6 01             	movzbl (%ecx),%eax
  800b3f:	3c 20                	cmp    $0x20,%al
  800b41:	74 f6                	je     800b39 <strtol+0x12>
  800b43:	3c 09                	cmp    $0x9,%al
  800b45:	74 f2                	je     800b39 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b47:	3c 2b                	cmp    $0x2b,%al
  800b49:	74 2a                	je     800b75 <strtol+0x4e>
	int neg = 0;
  800b4b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b50:	3c 2d                	cmp    $0x2d,%al
  800b52:	74 2b                	je     800b7f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b54:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5a:	75 0f                	jne    800b6b <strtol+0x44>
  800b5c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5f:	74 28                	je     800b89 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b68:	0f 44 d8             	cmove  %eax,%ebx
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b73:	eb 46                	jmp    800bbb <strtol+0x94>
		s++;
  800b75:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b78:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7d:	eb d5                	jmp    800b54 <strtol+0x2d>
		s++, neg = 1;
  800b7f:	83 c1 01             	add    $0x1,%ecx
  800b82:	bf 01 00 00 00       	mov    $0x1,%edi
  800b87:	eb cb                	jmp    800b54 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b89:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8d:	74 0e                	je     800b9d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8f:	85 db                	test   %ebx,%ebx
  800b91:	75 d8                	jne    800b6b <strtol+0x44>
		s++, base = 8;
  800b93:	83 c1 01             	add    $0x1,%ecx
  800b96:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b9b:	eb ce                	jmp    800b6b <strtol+0x44>
		s += 2, base = 16;
  800b9d:	83 c1 02             	add    $0x2,%ecx
  800ba0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba5:	eb c4                	jmp    800b6b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba7:	0f be d2             	movsbl %dl,%edx
  800baa:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bad:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bb0:	7d 3a                	jge    800bec <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bb2:	83 c1 01             	add    $0x1,%ecx
  800bb5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bbb:	0f b6 11             	movzbl (%ecx),%edx
  800bbe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bc1:	89 f3                	mov    %esi,%ebx
  800bc3:	80 fb 09             	cmp    $0x9,%bl
  800bc6:	76 df                	jbe    800ba7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bcb:	89 f3                	mov    %esi,%ebx
  800bcd:	80 fb 19             	cmp    $0x19,%bl
  800bd0:	77 08                	ja     800bda <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd2:	0f be d2             	movsbl %dl,%edx
  800bd5:	83 ea 57             	sub    $0x57,%edx
  800bd8:	eb d3                	jmp    800bad <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	80 fb 19             	cmp    $0x19,%bl
  800be2:	77 08                	ja     800bec <strtol+0xc5>
			dig = *s - 'A' + 10;
  800be4:	0f be d2             	movsbl %dl,%edx
  800be7:	83 ea 37             	sub    $0x37,%edx
  800bea:	eb c1                	jmp    800bad <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf0:	74 05                	je     800bf7 <strtol+0xd0>
		*endptr = (char *) s;
  800bf2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf7:	89 c2                	mov    %eax,%edx
  800bf9:	f7 da                	neg    %edx
  800bfb:	85 ff                	test   %edi,%edi
  800bfd:	0f 45 c2             	cmovne %edx,%eax
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
  800c0b:	83 ec 1c             	sub    $0x1c,%esp
  800c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c14:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c1c:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c1f:	8b 75 14             	mov    0x14(%ebp),%esi
  800c22:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c28:	74 04                	je     800c2e <syscall+0x29>
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	7f 08                	jg     800c36 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c36:	83 ec 0c             	sub    $0xc,%esp
  800c39:	50                   	push   %eax
  800c3a:	ff 75 e0             	pushl  -0x20(%ebp)
  800c3d:	68 bf 29 80 00       	push   $0x8029bf
  800c42:	6a 23                	push   $0x23
  800c44:	68 dc 29 80 00       	push   $0x8029dc
  800c49:	e8 f2 f5 ff ff       	call   800240 <_panic>

00800c4e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c4e:	f3 0f 1e fb          	endbr32 
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c58:	6a 00                	push   $0x0
  800c5a:	6a 00                	push   $0x0
  800c5c:	6a 00                	push   $0x0
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6e:	e8 92 ff ff ff       	call   800c05 <syscall>
}
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c78:	f3 0f 1e fb          	endbr32 
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c82:	6a 00                	push   $0x0
  800c84:	6a 00                	push   $0x0
  800c86:	6a 00                	push   $0x0
  800c88:	6a 00                	push   $0x0
  800c8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	b8 01 00 00 00       	mov    $0x1,%eax
  800c99:	e8 67 ff ff ff       	call   800c05 <syscall>
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca0:	f3 0f 1e fb          	endbr32 
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800caa:	6a 00                	push   $0x0
  800cac:	6a 00                	push   $0x0
  800cae:	6a 00                	push   $0x0
  800cb0:	6a 00                	push   $0x0
  800cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb5:	ba 01 00 00 00       	mov    $0x1,%edx
  800cba:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbf:	e8 41 ff ff ff       	call   800c05 <syscall>
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800cd0:	6a 00                	push   $0x0
  800cd2:	6a 00                	push   $0x0
  800cd4:	6a 00                	push   $0x0
  800cd6:	6a 00                	push   $0x0
  800cd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce7:	e8 19 ff ff ff       	call   800c05 <syscall>
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <sys_yield>:

void
sys_yield(void)
{
  800cee:	f3 0f 1e fb          	endbr32 
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cf8:	6a 00                	push   $0x0
  800cfa:	6a 00                	push   $0x0
  800cfc:	6a 00                	push   $0x0
  800cfe:	6a 00                	push   $0x0
  800d00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0f:	e8 f1 fe ff ff       	call   800c05 <syscall>
}
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d19:	f3 0f 1e fb          	endbr32 
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800d23:	6a 00                	push   $0x0
  800d25:	6a 00                	push   $0x0
  800d27:	ff 75 10             	pushl  0x10(%ebp)
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d30:	ba 01 00 00 00       	mov    $0x1,%edx
  800d35:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3a:	e8 c6 fe ff ff       	call   800c05 <syscall>
}
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d41:	f3 0f 1e fb          	endbr32 
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d4b:	ff 75 18             	pushl  0x18(%ebp)
  800d4e:	ff 75 14             	pushl  0x14(%ebp)
  800d51:	ff 75 10             	pushl  0x10(%ebp)
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5a:	ba 01 00 00 00       	mov    $0x1,%edx
  800d5f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d64:	e8 9c fe ff ff       	call   800c05 <syscall>
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6b:	f3 0f 1e fb          	endbr32 
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d75:	6a 00                	push   $0x0
  800d77:	6a 00                	push   $0x0
  800d79:	6a 00                	push   $0x0
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d81:	ba 01 00 00 00       	mov    $0x1,%edx
  800d86:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8b:	e8 75 fe ff ff       	call   800c05 <syscall>
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d92:	f3 0f 1e fb          	endbr32 
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d9c:	6a 00                	push   $0x0
  800d9e:	6a 00                	push   $0x0
  800da0:	6a 00                	push   $0x0
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da8:	ba 01 00 00 00       	mov    $0x1,%edx
  800dad:	b8 08 00 00 00       	mov    $0x8,%eax
  800db2:	e8 4e fe ff ff       	call   800c05 <syscall>
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db9:	f3 0f 1e fb          	endbr32 
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800dc3:	6a 00                	push   $0x0
  800dc5:	6a 00                	push   $0x0
  800dc7:	6a 00                	push   $0x0
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcf:	ba 01 00 00 00       	mov    $0x1,%edx
  800dd4:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd9:	e8 27 fe ff ff       	call   800c05 <syscall>
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de0:	f3 0f 1e fb          	endbr32 
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800dea:	6a 00                	push   $0x0
  800dec:	6a 00                	push   $0x0
  800dee:	6a 00                	push   $0x0
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df6:	ba 01 00 00 00       	mov    $0x1,%edx
  800dfb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e00:	e8 00 fe ff ff       	call   800c05 <syscall>
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e11:	6a 00                	push   $0x0
  800e13:	ff 75 14             	pushl  0x14(%ebp)
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e24:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e29:	e8 d7 fd ff ff       	call   800c05 <syscall>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e30:	f3 0f 1e fb          	endbr32 
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800e3a:	6a 00                	push   $0x0
  800e3c:	6a 00                	push   $0x0
  800e3e:	6a 00                	push   $0x0
  800e40:	6a 00                	push   $0x0
  800e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e45:	ba 01 00 00 00       	mov    $0x1,%edx
  800e4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4f:	e8 b1 fd ff ff       	call   800c05 <syscall>
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 04             	sub    $0x4,%esp
  800e5d:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800e5f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800e66:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800e69:	f6 c6 04             	test   $0x4,%dh
  800e6c:	75 51                	jne    800ebf <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800e6e:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800e74:	0f 84 84 00 00 00    	je     800efe <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	68 05 08 00 00       	push   $0x805
  800e82:	53                   	push   %ebx
  800e83:	50                   	push   %eax
  800e84:	53                   	push   %ebx
  800e85:	6a 00                	push   $0x0
  800e87:	e8 b5 fe ff ff       	call   800d41 <sys_page_map>
		if (r)
  800e8c:	83 c4 20             	add    $0x20,%esp
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	75 59                	jne    800eec <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	68 05 08 00 00       	push   $0x805
  800e9b:	53                   	push   %ebx
  800e9c:	6a 00                	push   $0x0
  800e9e:	53                   	push   %ebx
  800e9f:	6a 00                	push   $0x0
  800ea1:	e8 9b fe ff ff       	call   800d41 <sys_page_map>
		if (r)
  800ea6:	83 c4 20             	add    $0x20,%esp
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	74 67                	je     800f14 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800ead:	50                   	push   %eax
  800eae:	68 ea 29 80 00       	push   $0x8029ea
  800eb3:	6a 5f                	push   $0x5f
  800eb5:	68 05 2a 80 00       	push   $0x802a05
  800eba:	e8 81 f3 ff ff       	call   800240 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800ec8:	52                   	push   %edx
  800ec9:	53                   	push   %ebx
  800eca:	50                   	push   %eax
  800ecb:	53                   	push   %ebx
  800ecc:	6a 00                	push   $0x0
  800ece:	e8 6e fe ff ff       	call   800d41 <sys_page_map>
		if (r)
  800ed3:	83 c4 20             	add    $0x20,%esp
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 3a                	je     800f14 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800eda:	50                   	push   %eax
  800edb:	68 ea 29 80 00       	push   $0x8029ea
  800ee0:	6a 57                	push   $0x57
  800ee2:	68 05 2a 80 00       	push   $0x802a05
  800ee7:	e8 54 f3 ff ff       	call   800240 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800eec:	50                   	push   %eax
  800eed:	68 ea 29 80 00       	push   $0x8029ea
  800ef2:	6a 5b                	push   $0x5b
  800ef4:	68 05 2a 80 00       	push   $0x802a05
  800ef9:	e8 42 f3 ff ff       	call   800240 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	6a 05                	push   $0x5
  800f03:	53                   	push   %ebx
  800f04:	50                   	push   %eax
  800f05:	53                   	push   %ebx
  800f06:	6a 00                	push   $0x0
  800f08:	e8 34 fe ff ff       	call   800d41 <sys_page_map>
		if (r)
  800f0d:	83 c4 20             	add    $0x20,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 0a                	jne    800f1e <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800f1e:	50                   	push   %eax
  800f1f:	68 ea 29 80 00       	push   $0x8029ea
  800f24:	6a 63                	push   $0x63
  800f26:	68 05 2a 80 00       	push   $0x802a05
  800f2b:	e8 10 f3 ff ff       	call   800240 <_panic>

00800f30 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	83 ec 0c             	sub    $0xc,%esp
  800f39:	89 c7                	mov    %eax,%edi
  800f3b:	89 d6                	mov    %edx,%esi
  800f3d:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800f3f:	f6 c1 02             	test   $0x2,%cl
  800f42:	75 2f                	jne    800f73 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800f44:	83 ec 0c             	sub    $0xc,%esp
  800f47:	51                   	push   %ecx
  800f48:	52                   	push   %edx
  800f49:	50                   	push   %eax
  800f4a:	52                   	push   %edx
  800f4b:	6a 00                	push   $0x0
  800f4d:	e8 ef fd ff ff       	call   800d41 <sys_page_map>
  800f52:	83 c4 20             	add    $0x20,%esp
  800f55:	85 c0                	test   %eax,%eax
  800f57:	78 08                	js     800f61 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800f61:	50                   	push   %eax
  800f62:	68 f4 29 80 00       	push   $0x8029f4
  800f67:	6a 6f                	push   $0x6f
  800f69:	68 05 2a 80 00       	push   $0x802a05
  800f6e:	e8 cd f2 ff ff       	call   800240 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	51                   	push   %ecx
  800f77:	52                   	push   %edx
  800f78:	50                   	push   %eax
  800f79:	e8 9b fd ff ff       	call   800d19 <sys_page_alloc>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	85 c0                	test   %eax,%eax
  800f83:	78 54                	js     800fd9 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	53                   	push   %ebx
  800f89:	68 00 00 40 00       	push   $0x400000
  800f8e:	6a 00                	push   $0x0
  800f90:	56                   	push   %esi
  800f91:	57                   	push   %edi
  800f92:	e8 aa fd ff ff       	call   800d41 <sys_page_map>
  800f97:	83 c4 20             	add    $0x20,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 4d                	js     800feb <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800f9e:	83 ec 04             	sub    $0x4,%esp
  800fa1:	68 00 10 00 00       	push   $0x1000
  800fa6:	56                   	push   %esi
  800fa7:	68 00 00 40 00       	push   $0x400000
  800fac:	e8 98 fa ff ff       	call   800a49 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800fb1:	83 c4 08             	add    $0x8,%esp
  800fb4:	68 00 00 40 00       	push   $0x400000
  800fb9:	6a 00                	push   $0x0
  800fbb:	e8 ab fd ff ff       	call   800d6b <sys_page_unmap>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	79 92                	jns    800f59 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800fc7:	50                   	push   %eax
  800fc8:	68 23 2a 80 00       	push   $0x802a23
  800fcd:	6a 78                	push   $0x78
  800fcf:	68 05 2a 80 00       	push   $0x802a05
  800fd4:	e8 67 f2 ff ff       	call   800240 <_panic>
		panic("sys_page_alloc: %e", r);
  800fd9:	50                   	push   %eax
  800fda:	68 10 2a 80 00       	push   $0x802a10
  800fdf:	6a 73                	push   $0x73
  800fe1:	68 05 2a 80 00       	push   $0x802a05
  800fe6:	e8 55 f2 ff ff       	call   800240 <_panic>
		panic("sys_page_map: %e", r);
  800feb:	50                   	push   %eax
  800fec:	68 f4 29 80 00       	push   $0x8029f4
  800ff1:	6a 75                	push   $0x75
  800ff3:	68 05 2a 80 00       	push   $0x802a05
  800ff8:	e8 43 f2 ff ff       	call   800240 <_panic>

00800ffd <pgfault>:
{
  800ffd:	f3 0f 1e fb          	endbr32 
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	53                   	push   %ebx
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80100b:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80100d:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  801010:	89 da                	mov    %ebx,%edx
  801012:	c1 ea 0c             	shr    $0xc,%edx
  801015:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  80101c:	a8 01                	test   $0x1,%al
  80101e:	74 7e                	je     80109e <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  801020:	a8 02                	test   $0x2,%al
  801022:	0f 84 8a 00 00 00    	je     8010b2 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  801028:	f6 c6 08             	test   $0x8,%dh
  80102b:	0f 84 95 00 00 00    	je     8010c6 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	6a 07                	push   $0x7
  801036:	68 00 f0 7f 00       	push   $0x7ff000
  80103b:	6a 00                	push   $0x0
  80103d:	e8 d7 fc ff ff       	call   800d19 <sys_page_alloc>
	if (r)
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	0f 85 8d 00 00 00    	jne    8010da <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80104d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	68 00 10 00 00       	push   $0x1000
  80105b:	53                   	push   %ebx
  80105c:	68 00 f0 7f 00       	push   $0x7ff000
  801061:	e8 49 fa ff ff       	call   800aaf <memcpy>
	r = sys_page_map(
  801066:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80106d:	53                   	push   %ebx
  80106e:	6a 00                	push   $0x0
  801070:	68 00 f0 7f 00       	push   $0x7ff000
  801075:	6a 00                	push   $0x0
  801077:	e8 c5 fc ff ff       	call   800d41 <sys_page_map>
	if (r)
  80107c:	83 c4 20             	add    $0x20,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 69                	jne    8010ec <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	68 00 f0 7f 00       	push   $0x7ff000
  80108b:	6a 00                	push   $0x0
  80108d:	e8 d9 fc ff ff       	call   800d6b <sys_page_unmap>
	if (r)
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	75 65                	jne    8010fe <pgfault+0x101>
}
  801099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  80109e:	83 ec 04             	sub    $0x4,%esp
  8010a1:	68 a4 2a 80 00       	push   $0x802aa4
  8010a6:	6a 20                	push   $0x20
  8010a8:	68 05 2a 80 00       	push   $0x802a05
  8010ad:	e8 8e f1 ff ff       	call   800240 <_panic>
		panic("[pgfault] pgfault por lectura");
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	68 36 2a 80 00       	push   $0x802a36
  8010ba:	6a 23                	push   $0x23
  8010bc:	68 05 2a 80 00       	push   $0x802a05
  8010c1:	e8 7a f1 ff ff       	call   800240 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	68 d0 2a 80 00       	push   $0x802ad0
  8010ce:	6a 27                	push   $0x27
  8010d0:	68 05 2a 80 00       	push   $0x802a05
  8010d5:	e8 66 f1 ff ff       	call   800240 <_panic>
		panic("pgfault: %e", r);
  8010da:	50                   	push   %eax
  8010db:	68 54 2a 80 00       	push   $0x802a54
  8010e0:	6a 32                	push   $0x32
  8010e2:	68 05 2a 80 00       	push   $0x802a05
  8010e7:	e8 54 f1 ff ff       	call   800240 <_panic>
		panic("pgfault: %e", r);
  8010ec:	50                   	push   %eax
  8010ed:	68 54 2a 80 00       	push   $0x802a54
  8010f2:	6a 39                	push   $0x39
  8010f4:	68 05 2a 80 00       	push   $0x802a05
  8010f9:	e8 42 f1 ff ff       	call   800240 <_panic>
		panic("pgfault: %e", r);
  8010fe:	50                   	push   %eax
  8010ff:	68 54 2a 80 00       	push   $0x802a54
  801104:	6a 3d                	push   $0x3d
  801106:	68 05 2a 80 00       	push   $0x802a05
  80110b:	e8 30 f1 ff ff       	call   800240 <_panic>

00801110 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80111d:	b8 07 00 00 00       	mov    $0x7,%eax
  801122:	cd 30                	int    $0x30
  801124:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801126:	85 c0                	test   %eax,%eax
  801128:	78 22                	js     80114c <fork_v0+0x3c>
  80112a:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80112c:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801131:	75 52                	jne    801185 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801133:	e8 8e fb ff ff       	call   800cc6 <sys_getenvid>
  801138:	25 ff 03 00 00       	and    $0x3ff,%eax
  80113d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801140:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801145:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  80114a:	eb 6e                	jmp    8011ba <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80114c:	50                   	push   %eax
  80114d:	68 f8 2a 80 00       	push   $0x802af8
  801152:	68 8a 00 00 00       	push   $0x8a
  801157:	68 05 2a 80 00       	push   $0x802a05
  80115c:	e8 df f0 ff ff       	call   800240 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801161:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801168:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80116e:	89 da                	mov    %ebx,%edx
  801170:	89 f0                	mov    %esi,%eax
  801172:	e8 b9 fd ff ff       	call   800f30 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801177:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80117d:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801183:	74 23                	je     8011a8 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801185:	89 d8                	mov    %ebx,%eax
  801187:	c1 e8 16             	shr    $0x16,%eax
  80118a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801191:	a8 01                	test   $0x1,%al
  801193:	74 e2                	je     801177 <fork_v0+0x67>
  801195:	89 d8                	mov    %ebx,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
  80119a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a1:	f6 c2 01             	test   $0x1,%dl
  8011a4:	74 d1                	je     801177 <fork_v0+0x67>
  8011a6:	eb b9                	jmp    801161 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011a8:	83 ec 08             	sub    $0x8,%esp
  8011ab:	6a 02                	push   $0x2
  8011ad:	57                   	push   %edi
  8011ae:	e8 df fb ff ff       	call   800d92 <sys_env_set_status>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 0a                	js     8011c4 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8011ba:	89 f8                	mov    %edi,%eax
  8011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bf:	5b                   	pop    %ebx
  8011c0:	5e                   	pop    %esi
  8011c1:	5f                   	pop    %edi
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8011c4:	50                   	push   %eax
  8011c5:	68 1c 2b 80 00       	push   $0x802b1c
  8011ca:	68 98 00 00 00       	push   $0x98
  8011cf:	68 05 2a 80 00       	push   $0x802a05
  8011d4:	e8 67 f0 ff ff       	call   800240 <_panic>

008011d9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011d9:	f3 0f 1e fb          	endbr32 
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8011e6:	68 fd 0f 80 00       	push   $0x800ffd
  8011eb:	e8 10 0f 00 00       	call   802100 <set_pgfault_handler>
  8011f0:	b8 07 00 00 00       	mov    $0x7,%eax
  8011f5:	cd 30                	int    $0x30
  8011f7:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 37                	js     801237 <fork+0x5e>
  801200:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801202:	74 48                	je     80124c <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	6a 07                	push   $0x7
  801209:	68 00 f0 bf ee       	push   $0xeebff000
  80120e:	50                   	push   %eax
  80120f:	e8 05 fb ff ff       	call   800d19 <sys_page_alloc>
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 4d                	js     801268 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80121b:	83 ec 08             	sub    $0x8,%esp
  80121e:	68 7d 21 80 00       	push   $0x80217d
  801223:	56                   	push   %esi
  801224:	e8 b7 fb ff ff       	call   800de0 <sys_env_set_pgfault_upcall>
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 4d                	js     80127d <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	eb 70                	jmp    8012a7 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801237:	50                   	push   %eax
  801238:	68 60 2a 80 00       	push   $0x802a60
  80123d:	68 b7 00 00 00       	push   $0xb7
  801242:	68 05 2a 80 00       	push   $0x802a05
  801247:	e8 f4 ef ff ff       	call   800240 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80124c:	e8 75 fa ff ff       	call   800cc6 <sys_getenvid>
  801251:	25 ff 03 00 00       	and    $0x3ff,%eax
  801256:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801259:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125e:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801263:	e9 80 00 00 00       	jmp    8012e8 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801268:	50                   	push   %eax
  801269:	68 70 2a 80 00       	push   $0x802a70
  80126e:	68 c0 00 00 00       	push   $0xc0
  801273:	68 05 2a 80 00       	push   $0x802a05
  801278:	e8 c3 ef ff ff       	call   800240 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80127d:	50                   	push   %eax
  80127e:	68 40 2b 80 00       	push   $0x802b40
  801283:	68 c3 00 00 00       	push   $0xc3
  801288:	68 05 2a 80 00       	push   $0x802a05
  80128d:	e8 ae ef ff ff       	call   800240 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801292:	89 f8                	mov    %edi,%eax
  801294:	e8 bd fb ff ff       	call   800e56 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801299:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80129f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8012a5:	74 2f                	je     8012d6 <fork+0xfd>
  8012a7:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  8012a9:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  8012af:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8012b4:	76 e3                	jbe    801299 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8012b6:	89 d8                	mov    %ebx,%eax
  8012b8:	c1 e8 16             	shr    $0x16,%eax
  8012bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c2:	a8 01                	test   $0x1,%al
  8012c4:	74 d3                	je     801299 <fork+0xc0>
  8012c6:	c1 ea 0c             	shr    $0xc,%edx
  8012c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012d0:	a8 01                	test   $0x1,%al
  8012d2:	74 c5                	je     801299 <fork+0xc0>
  8012d4:	eb bc                	jmp    801292 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	6a 02                	push   $0x2
  8012db:	56                   	push   %esi
  8012dc:	e8 b1 fa ff ff       	call   800d92 <sys_env_set_status>
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 0a                	js     8012f2 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8012e8:	89 f0                	mov    %esi,%eax
  8012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8012f2:	50                   	push   %eax
  8012f3:	68 6c 2b 80 00       	push   $0x802b6c
  8012f8:	68 ce 00 00 00       	push   $0xce
  8012fd:	68 05 2a 80 00       	push   $0x802a05
  801302:	e8 39 ef ff ff       	call   800240 <_panic>

00801307 <sfork>:

// Challenge!
int
sfork(void)
{
  801307:	f3 0f 1e fb          	endbr32 
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801311:	68 8e 2a 80 00       	push   $0x802a8e
  801316:	68 d7 00 00 00       	push   $0xd7
  80131b:	68 05 2a 80 00       	push   $0x802a05
  801320:	e8 1b ef ff ff       	call   800240 <_panic>

00801325 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801325:	f3 0f 1e fb          	endbr32 
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	05 00 00 00 30       	add    $0x30000000,%eax
  801334:	c1 e8 0c             	shr    $0xc,%eax
}
  801337:	5d                   	pop    %ebp
  801338:	c3                   	ret    

00801339 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801339:	f3 0f 1e fb          	endbr32 
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	e8 da ff ff ff       	call   801325 <fd2num>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	c1 e0 0c             	shl    $0xc,%eax
  801351:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801358:	f3 0f 1e fb          	endbr32 
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801364:	89 c2                	mov    %eax,%edx
  801366:	c1 ea 16             	shr    $0x16,%edx
  801369:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801370:	f6 c2 01             	test   $0x1,%dl
  801373:	74 2d                	je     8013a2 <fd_alloc+0x4a>
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 ea 0c             	shr    $0xc,%edx
  80137a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801381:	f6 c2 01             	test   $0x1,%dl
  801384:	74 1c                	je     8013a2 <fd_alloc+0x4a>
  801386:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80138b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801390:	75 d2                	jne    801364 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80139b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013a0:	eb 0a                	jmp    8013ac <fd_alloc+0x54>
			*fd_store = fd;
  8013a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ae:	f3 0f 1e fb          	endbr32 
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b8:	83 f8 1f             	cmp    $0x1f,%eax
  8013bb:	77 30                	ja     8013ed <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013bd:	c1 e0 0c             	shl    $0xc,%eax
  8013c0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013cb:	f6 c2 01             	test   $0x1,%dl
  8013ce:	74 24                	je     8013f4 <fd_lookup+0x46>
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 0c             	shr    $0xc,%edx
  8013d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	74 1a                	je     8013fb <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    
		return -E_INVAL;
  8013ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f2:	eb f7                	jmp    8013eb <fd_lookup+0x3d>
		return -E_INVAL;
  8013f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f9:	eb f0                	jmp    8013eb <fd_lookup+0x3d>
  8013fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801400:	eb e9                	jmp    8013eb <fd_lookup+0x3d>

00801402 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801402:	f3 0f 1e fb          	endbr32 
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140f:	ba 0c 2c 80 00       	mov    $0x802c0c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801414:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801419:	39 08                	cmp    %ecx,(%eax)
  80141b:	74 33                	je     801450 <dev_lookup+0x4e>
  80141d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801420:	8b 02                	mov    (%edx),%eax
  801422:	85 c0                	test   %eax,%eax
  801424:	75 f3                	jne    801419 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801426:	a1 20 44 80 00       	mov    0x804420,%eax
  80142b:	8b 40 48             	mov    0x48(%eax),%eax
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	51                   	push   %ecx
  801432:	50                   	push   %eax
  801433:	68 90 2b 80 00       	push   $0x802b90
  801438:	e8 ea ee ff ff       	call   800327 <cprintf>
	*dev = 0;
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    
			*dev = devtab[i];
  801450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801453:	89 01                	mov    %eax,(%ecx)
			return 0;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	eb f2                	jmp    80144e <dev_lookup+0x4c>

0080145c <fd_close>:
{
  80145c:	f3 0f 1e fb          	endbr32 
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	83 ec 28             	sub    $0x28,%esp
  801469:	8b 75 08             	mov    0x8(%ebp),%esi
  80146c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146f:	56                   	push   %esi
  801470:	e8 b0 fe ff ff       	call   801325 <fd2num>
  801475:	83 c4 08             	add    $0x8,%esp
  801478:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80147b:	52                   	push   %edx
  80147c:	50                   	push   %eax
  80147d:	e8 2c ff ff ff       	call   8013ae <fd_lookup>
  801482:	89 c3                	mov    %eax,%ebx
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 05                	js     801490 <fd_close+0x34>
	    || fd != fd2)
  80148b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80148e:	74 16                	je     8014a6 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801490:	89 f8                	mov    %edi,%eax
  801492:	84 c0                	test   %al,%al
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
  801499:	0f 44 d8             	cmove  %eax,%ebx
}
  80149c:	89 d8                	mov    %ebx,%eax
  80149e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a1:	5b                   	pop    %ebx
  8014a2:	5e                   	pop    %esi
  8014a3:	5f                   	pop    %edi
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014ac:	50                   	push   %eax
  8014ad:	ff 36                	pushl  (%esi)
  8014af:	e8 4e ff ff ff       	call   801402 <dev_lookup>
  8014b4:	89 c3                	mov    %eax,%ebx
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 1a                	js     8014d7 <fd_close+0x7b>
		if (dev->dev_close)
  8014bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	74 0b                	je     8014d7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	56                   	push   %esi
  8014d0:	ff d0                	call   *%eax
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	56                   	push   %esi
  8014db:	6a 00                	push   $0x0
  8014dd:	e8 89 f8 ff ff       	call   800d6b <sys_page_unmap>
	return r;
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	eb b5                	jmp    80149c <fd_close+0x40>

008014e7 <close>:

int
close(int fdnum)
{
  8014e7:	f3 0f 1e fb          	endbr32 
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	ff 75 08             	pushl  0x8(%ebp)
  8014f8:	e8 b1 fe ff ff       	call   8013ae <fd_lookup>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	79 02                	jns    801506 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    
		return fd_close(fd, 1);
  801506:	83 ec 08             	sub    $0x8,%esp
  801509:	6a 01                	push   $0x1
  80150b:	ff 75 f4             	pushl  -0xc(%ebp)
  80150e:	e8 49 ff ff ff       	call   80145c <fd_close>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	eb ec                	jmp    801504 <close+0x1d>

00801518 <close_all>:

void
close_all(void)
{
  801518:	f3 0f 1e fb          	endbr32 
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	53                   	push   %ebx
  801520:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801523:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	53                   	push   %ebx
  80152c:	e8 b6 ff ff ff       	call   8014e7 <close>
	for (i = 0; i < MAXFD; i++)
  801531:	83 c3 01             	add    $0x1,%ebx
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	83 fb 20             	cmp    $0x20,%ebx
  80153a:	75 ec                	jne    801528 <close_all+0x10>
}
  80153c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801541:	f3 0f 1e fb          	endbr32 
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80154e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 54 fe ff ff       	call   8013ae <fd_lookup>
  80155a:	89 c3                	mov    %eax,%ebx
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	0f 88 81 00 00 00    	js     8015e8 <dup+0xa7>
		return r;
	close(newfdnum);
  801567:	83 ec 0c             	sub    $0xc,%esp
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	e8 75 ff ff ff       	call   8014e7 <close>

	newfd = INDEX2FD(newfdnum);
  801572:	8b 75 0c             	mov    0xc(%ebp),%esi
  801575:	c1 e6 0c             	shl    $0xc,%esi
  801578:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80157e:	83 c4 04             	add    $0x4,%esp
  801581:	ff 75 e4             	pushl  -0x1c(%ebp)
  801584:	e8 b0 fd ff ff       	call   801339 <fd2data>
  801589:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80158b:	89 34 24             	mov    %esi,(%esp)
  80158e:	e8 a6 fd ff ff       	call   801339 <fd2data>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801598:	89 d8                	mov    %ebx,%eax
  80159a:	c1 e8 16             	shr    $0x16,%eax
  80159d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a4:	a8 01                	test   $0x1,%al
  8015a6:	74 11                	je     8015b9 <dup+0x78>
  8015a8:	89 d8                	mov    %ebx,%eax
  8015aa:	c1 e8 0c             	shr    $0xc,%eax
  8015ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015b4:	f6 c2 01             	test   $0x1,%dl
  8015b7:	75 39                	jne    8015f2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015bc:	89 d0                	mov    %edx,%eax
  8015be:	c1 e8 0c             	shr    $0xc,%eax
  8015c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c8:	83 ec 0c             	sub    $0xc,%esp
  8015cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d0:	50                   	push   %eax
  8015d1:	56                   	push   %esi
  8015d2:	6a 00                	push   $0x0
  8015d4:	52                   	push   %edx
  8015d5:	6a 00                	push   $0x0
  8015d7:	e8 65 f7 ff ff       	call   800d41 <sys_page_map>
  8015dc:	89 c3                	mov    %eax,%ebx
  8015de:	83 c4 20             	add    $0x20,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 31                	js     801616 <dup+0xd5>
		goto err;

	return newfdnum;
  8015e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015e8:	89 d8                	mov    %ebx,%eax
  8015ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5f                   	pop    %edi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	25 07 0e 00 00       	and    $0xe07,%eax
  801601:	50                   	push   %eax
  801602:	57                   	push   %edi
  801603:	6a 00                	push   $0x0
  801605:	53                   	push   %ebx
  801606:	6a 00                	push   $0x0
  801608:	e8 34 f7 ff ff       	call   800d41 <sys_page_map>
  80160d:	89 c3                	mov    %eax,%ebx
  80160f:	83 c4 20             	add    $0x20,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	79 a3                	jns    8015b9 <dup+0x78>
	sys_page_unmap(0, newfd);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	56                   	push   %esi
  80161a:	6a 00                	push   $0x0
  80161c:	e8 4a f7 ff ff       	call   800d6b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801621:	83 c4 08             	add    $0x8,%esp
  801624:	57                   	push   %edi
  801625:	6a 00                	push   $0x0
  801627:	e8 3f f7 ff ff       	call   800d6b <sys_page_unmap>
	return r;
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	eb b7                	jmp    8015e8 <dup+0xa7>

00801631 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801631:	f3 0f 1e fb          	endbr32 
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 1c             	sub    $0x1c,%esp
  80163c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	53                   	push   %ebx
  801644:	e8 65 fd ff ff       	call   8013ae <fd_lookup>
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 3f                	js     80168f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801656:	50                   	push   %eax
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	ff 30                	pushl  (%eax)
  80165c:	e8 a1 fd ff ff       	call   801402 <dev_lookup>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 27                	js     80168f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166b:	8b 42 08             	mov    0x8(%edx),%eax
  80166e:	83 e0 03             	and    $0x3,%eax
  801671:	83 f8 01             	cmp    $0x1,%eax
  801674:	74 1e                	je     801694 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	8b 40 08             	mov    0x8(%eax),%eax
  80167c:	85 c0                	test   %eax,%eax
  80167e:	74 35                	je     8016b5 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	ff 75 10             	pushl  0x10(%ebp)
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	52                   	push   %edx
  80168a:	ff d0                	call   *%eax
  80168c:	83 c4 10             	add    $0x10,%esp
}
  80168f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801692:	c9                   	leave  
  801693:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801694:	a1 20 44 80 00       	mov    0x804420,%eax
  801699:	8b 40 48             	mov    0x48(%eax),%eax
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	53                   	push   %ebx
  8016a0:	50                   	push   %eax
  8016a1:	68 d1 2b 80 00       	push   $0x802bd1
  8016a6:	e8 7c ec ff ff       	call   800327 <cprintf>
		return -E_INVAL;
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b3:	eb da                	jmp    80168f <read+0x5e>
		return -E_NOT_SUPP;
  8016b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ba:	eb d3                	jmp    80168f <read+0x5e>

008016bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016bc:	f3 0f 1e fb          	endbr32 
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	57                   	push   %edi
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d4:	eb 02                	jmp    8016d8 <readn+0x1c>
  8016d6:	01 c3                	add    %eax,%ebx
  8016d8:	39 f3                	cmp    %esi,%ebx
  8016da:	73 21                	jae    8016fd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	89 f0                	mov    %esi,%eax
  8016e1:	29 d8                	sub    %ebx,%eax
  8016e3:	50                   	push   %eax
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	03 45 0c             	add    0xc(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	57                   	push   %edi
  8016eb:	e8 41 ff ff ff       	call   801631 <read>
		if (m < 0)
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 04                	js     8016fb <readn+0x3f>
			return m;
		if (m == 0)
  8016f7:	75 dd                	jne    8016d6 <readn+0x1a>
  8016f9:	eb 02                	jmp    8016fd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016fb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016fd:	89 d8                	mov    %ebx,%eax
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801707:	f3 0f 1e fb          	endbr32 
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	53                   	push   %ebx
  80170f:	83 ec 1c             	sub    $0x1c,%esp
  801712:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801715:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801718:	50                   	push   %eax
  801719:	53                   	push   %ebx
  80171a:	e8 8f fc ff ff       	call   8013ae <fd_lookup>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	85 c0                	test   %eax,%eax
  801724:	78 3a                	js     801760 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801726:	83 ec 08             	sub    $0x8,%esp
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	50                   	push   %eax
  80172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801730:	ff 30                	pushl  (%eax)
  801732:	e8 cb fc ff ff       	call   801402 <dev_lookup>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 22                	js     801760 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80173e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801741:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801745:	74 1e                	je     801765 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174a:	8b 52 0c             	mov    0xc(%edx),%edx
  80174d:	85 d2                	test   %edx,%edx
  80174f:	74 35                	je     801786 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	50                   	push   %eax
  80175b:	ff d2                	call   *%edx
  80175d:	83 c4 10             	add    $0x10,%esp
}
  801760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801765:	a1 20 44 80 00       	mov    0x804420,%eax
  80176a:	8b 40 48             	mov    0x48(%eax),%eax
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	53                   	push   %ebx
  801771:	50                   	push   %eax
  801772:	68 ed 2b 80 00       	push   $0x802bed
  801777:	e8 ab eb ff ff       	call   800327 <cprintf>
		return -E_INVAL;
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801784:	eb da                	jmp    801760 <write+0x59>
		return -E_NOT_SUPP;
  801786:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178b:	eb d3                	jmp    801760 <write+0x59>

0080178d <seek>:

int
seek(int fdnum, off_t offset)
{
  80178d:	f3 0f 1e fb          	endbr32 
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801797:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179a:	50                   	push   %eax
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	e8 0b fc ff ff       	call   8013ae <fd_lookup>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 0e                	js     8017b8 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017ba:	f3 0f 1e fb          	endbr32 
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017cb:	50                   	push   %eax
  8017cc:	53                   	push   %ebx
  8017cd:	e8 dc fb ff ff       	call   8013ae <fd_lookup>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 37                	js     801810 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017df:	50                   	push   %eax
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	ff 30                	pushl  (%eax)
  8017e5:	e8 18 fc ff ff       	call   801402 <dev_lookup>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	78 1f                	js     801810 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f8:	74 1b                	je     801815 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fd:	8b 52 18             	mov    0x18(%edx),%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	74 32                	je     801836 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801804:	83 ec 08             	sub    $0x8,%esp
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	50                   	push   %eax
  80180b:	ff d2                	call   *%edx
  80180d:	83 c4 10             	add    $0x10,%esp
}
  801810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801813:	c9                   	leave  
  801814:	c3                   	ret    
			thisenv->env_id, fdnum);
  801815:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80181a:	8b 40 48             	mov    0x48(%eax),%eax
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	53                   	push   %ebx
  801821:	50                   	push   %eax
  801822:	68 b0 2b 80 00       	push   $0x802bb0
  801827:	e8 fb ea ff ff       	call   800327 <cprintf>
		return -E_INVAL;
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801834:	eb da                	jmp    801810 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801836:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183b:	eb d3                	jmp    801810 <ftruncate+0x56>

0080183d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80183d:	f3 0f 1e fb          	endbr32 
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	53                   	push   %ebx
  801845:	83 ec 1c             	sub    $0x1c,%esp
  801848:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	e8 57 fb ff ff       	call   8013ae <fd_lookup>
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 4b                	js     8018a9 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801868:	ff 30                	pushl  (%eax)
  80186a:	e8 93 fb ff ff       	call   801402 <dev_lookup>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	78 33                	js     8018a9 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80187d:	74 2f                	je     8018ae <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80187f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801882:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801889:	00 00 00 
	stat->st_isdir = 0;
  80188c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801893:	00 00 00 
	stat->st_dev = dev;
  801896:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	53                   	push   %ebx
  8018a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a3:	ff 50 14             	call   *0x14(%eax)
  8018a6:	83 c4 10             	add    $0x10,%esp
}
  8018a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b3:	eb f4                	jmp    8018a9 <fstat+0x6c>

008018b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018b5:	f3 0f 1e fb          	endbr32 
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018be:	83 ec 08             	sub    $0x8,%esp
  8018c1:	6a 00                	push   $0x0
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	e8 3a 02 00 00       	call   801b05 <open>
  8018cb:	89 c3                	mov    %eax,%ebx
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	78 1b                	js     8018ef <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018d4:	83 ec 08             	sub    $0x8,%esp
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	50                   	push   %eax
  8018db:	e8 5d ff ff ff       	call   80183d <fstat>
  8018e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018e2:	89 1c 24             	mov    %ebx,(%esp)
  8018e5:	e8 fd fb ff ff       	call   8014e7 <close>
	return r;
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	89 f3                	mov    %esi,%ebx
}
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    

008018f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	89 c6                	mov    %eax,%esi
  8018ff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801901:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801908:	74 27                	je     801931 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80190a:	6a 07                	push   $0x7
  80190c:	68 00 50 80 00       	push   $0x805000
  801911:	56                   	push   %esi
  801912:	ff 35 00 40 80 00    	pushl  0x804000
  801918:	e8 f3 08 00 00       	call   802210 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80191d:	83 c4 0c             	add    $0xc,%esp
  801920:	6a 00                	push   $0x0
  801922:	53                   	push   %ebx
  801923:	6a 00                	push   $0x0
  801925:	e8 79 08 00 00       	call   8021a3 <ipc_recv>
}
  80192a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801931:	83 ec 0c             	sub    $0xc,%esp
  801934:	6a 01                	push   $0x1
  801936:	e8 2d 09 00 00       	call   802268 <ipc_find_env>
  80193b:	a3 00 40 80 00       	mov    %eax,0x804000
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb c5                	jmp    80190a <fsipc+0x12>

00801945 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801945:	f3 0f 1e fb          	endbr32 
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
  801955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801962:	ba 00 00 00 00       	mov    $0x0,%edx
  801967:	b8 02 00 00 00       	mov    $0x2,%eax
  80196c:	e8 87 ff ff ff       	call   8018f8 <fsipc>
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <devfile_flush>:
{
  801973:	f3 0f 1e fb          	endbr32 
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8b 40 0c             	mov    0xc(%eax),%eax
  801983:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801988:	ba 00 00 00 00       	mov    $0x0,%edx
  80198d:	b8 06 00 00 00       	mov    $0x6,%eax
  801992:	e8 61 ff ff ff       	call   8018f8 <fsipc>
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <devfile_stat>:
{
  801999:	f3 0f 1e fb          	endbr32 
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ad:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8019bc:	e8 37 ff ff ff       	call   8018f8 <fsipc>
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 2c                	js     8019f1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	68 00 50 80 00       	push   $0x805000
  8019cd:	53                   	push   %ebx
  8019ce:	e8 be ee ff ff       	call   800891 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d3:	a1 80 50 80 00       	mov    0x805080,%eax
  8019d8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019de:	a1 84 50 80 00       	mov    0x805084,%eax
  8019e3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <devfile_write>:
{
  8019f6:	f3 0f 1e fb          	endbr32 
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a0f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a15:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a1b:	77 30                	ja     801a4d <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	53                   	push   %ebx
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	68 08 50 80 00       	push   $0x805008
  801a29:	e8 1b f0 ff ff       	call   800a49 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	b8 04 00 00 00       	mov    $0x4,%eax
  801a38:	e8 bb fe ff ff       	call   8018f8 <fsipc>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 04                	js     801a48 <devfile_write+0x52>
	assert(r <= n);
  801a44:	39 d8                	cmp    %ebx,%eax
  801a46:	77 1e                	ja     801a66 <devfile_write+0x70>
}
  801a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a4d:	68 1c 2c 80 00       	push   $0x802c1c
  801a52:	68 49 2c 80 00       	push   $0x802c49
  801a57:	68 94 00 00 00       	push   $0x94
  801a5c:	68 5e 2c 80 00       	push   $0x802c5e
  801a61:	e8 da e7 ff ff       	call   800240 <_panic>
	assert(r <= n);
  801a66:	68 69 2c 80 00       	push   $0x802c69
  801a6b:	68 49 2c 80 00       	push   $0x802c49
  801a70:	68 98 00 00 00       	push   $0x98
  801a75:	68 5e 2c 80 00       	push   $0x802c5e
  801a7a:	e8 c1 e7 ff ff       	call   800240 <_panic>

00801a7f <devfile_read>:
{
  801a7f:	f3 0f 1e fb          	endbr32 
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a91:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a96:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa1:	b8 03 00 00 00       	mov    $0x3,%eax
  801aa6:	e8 4d fe ff ff       	call   8018f8 <fsipc>
  801aab:	89 c3                	mov    %eax,%ebx
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 1f                	js     801ad0 <devfile_read+0x51>
	assert(r <= n);
  801ab1:	39 f0                	cmp    %esi,%eax
  801ab3:	77 24                	ja     801ad9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801ab5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aba:	7f 33                	jg     801aef <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	50                   	push   %eax
  801ac0:	68 00 50 80 00       	push   $0x805000
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	e8 7c ef ff ff       	call   800a49 <memmove>
	return r;
  801acd:	83 c4 10             	add    $0x10,%esp
}
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5e                   	pop    %esi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
	assert(r <= n);
  801ad9:	68 69 2c 80 00       	push   $0x802c69
  801ade:	68 49 2c 80 00       	push   $0x802c49
  801ae3:	6a 7c                	push   $0x7c
  801ae5:	68 5e 2c 80 00       	push   $0x802c5e
  801aea:	e8 51 e7 ff ff       	call   800240 <_panic>
	assert(r <= PGSIZE);
  801aef:	68 70 2c 80 00       	push   $0x802c70
  801af4:	68 49 2c 80 00       	push   $0x802c49
  801af9:	6a 7d                	push   $0x7d
  801afb:	68 5e 2c 80 00       	push   $0x802c5e
  801b00:	e8 3b e7 ff ff       	call   800240 <_panic>

00801b05 <open>:
{
  801b05:	f3 0f 1e fb          	endbr32 
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 1c             	sub    $0x1c,%esp
  801b11:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b14:	56                   	push   %esi
  801b15:	e8 34 ed ff ff       	call   80084e <strlen>
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b22:	7f 6c                	jg     801b90 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b2a:	50                   	push   %eax
  801b2b:	e8 28 f8 ff ff       	call   801358 <fd_alloc>
  801b30:	89 c3                	mov    %eax,%ebx
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 3c                	js     801b75 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b39:	83 ec 08             	sub    $0x8,%esp
  801b3c:	56                   	push   %esi
  801b3d:	68 00 50 80 00       	push   $0x805000
  801b42:	e8 4a ed ff ff       	call   800891 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	e8 9c fd ff ff       	call   8018f8 <fsipc>
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 19                	js     801b7e <open+0x79>
	return fd2num(fd);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6b:	e8 b5 f7 ff ff       	call   801325 <fd2num>
  801b70:	89 c3                	mov    %eax,%ebx
  801b72:	83 c4 10             	add    $0x10,%esp
}
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    
		fd_close(fd, 0);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 f4             	pushl  -0xc(%ebp)
  801b86:	e8 d1 f8 ff ff       	call   80145c <fd_close>
		return r;
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	eb e5                	jmp    801b75 <open+0x70>
		return -E_BAD_PATH;
  801b90:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b95:	eb de                	jmp    801b75 <open+0x70>

00801b97 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b97:	f3 0f 1e fb          	endbr32 
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba6:	b8 08 00 00 00       	mov    $0x8,%eax
  801bab:	e8 48 fd ff ff       	call   8018f8 <fsipc>
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bb2:	f3 0f 1e fb          	endbr32 
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
  801bbb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	e8 70 f7 ff ff       	call   801339 <fd2data>
  801bc9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bcb:	83 c4 08             	add    $0x8,%esp
  801bce:	68 7c 2c 80 00       	push   $0x802c7c
  801bd3:	53                   	push   %ebx
  801bd4:	e8 b8 ec ff ff       	call   800891 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bd9:	8b 46 04             	mov    0x4(%esi),%eax
  801bdc:	2b 06                	sub    (%esi),%eax
  801bde:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801be4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801beb:	00 00 00 
	stat->st_dev = &devpipe;
  801bee:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bf5:	30 80 00 
	return 0;
}
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c04:	f3 0f 1e fb          	endbr32 
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 0c             	sub    $0xc,%esp
  801c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c12:	53                   	push   %ebx
  801c13:	6a 00                	push   $0x0
  801c15:	e8 51 f1 ff ff       	call   800d6b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c1a:	89 1c 24             	mov    %ebx,(%esp)
  801c1d:	e8 17 f7 ff ff       	call   801339 <fd2data>
  801c22:	83 c4 08             	add    $0x8,%esp
  801c25:	50                   	push   %eax
  801c26:	6a 00                	push   $0x0
  801c28:	e8 3e f1 ff ff       	call   800d6b <sys_page_unmap>
}
  801c2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <_pipeisclosed>:
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	57                   	push   %edi
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 1c             	sub    $0x1c,%esp
  801c3b:	89 c7                	mov    %eax,%edi
  801c3d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c3f:	a1 20 44 80 00       	mov    0x804420,%eax
  801c44:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	57                   	push   %edi
  801c4b:	e8 55 06 00 00       	call   8022a5 <pageref>
  801c50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c53:	89 34 24             	mov    %esi,(%esp)
  801c56:	e8 4a 06 00 00       	call   8022a5 <pageref>
		nn = thisenv->env_runs;
  801c5b:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801c61:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	39 cb                	cmp    %ecx,%ebx
  801c69:	74 1b                	je     801c86 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c6e:	75 cf                	jne    801c3f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c70:	8b 42 58             	mov    0x58(%edx),%eax
  801c73:	6a 01                	push   $0x1
  801c75:	50                   	push   %eax
  801c76:	53                   	push   %ebx
  801c77:	68 83 2c 80 00       	push   $0x802c83
  801c7c:	e8 a6 e6 ff ff       	call   800327 <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	eb b9                	jmp    801c3f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c89:	0f 94 c0             	sete   %al
  801c8c:	0f b6 c0             	movzbl %al,%eax
}
  801c8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5e                   	pop    %esi
  801c94:	5f                   	pop    %edi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    

00801c97 <devpipe_write>:
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	57                   	push   %edi
  801c9f:	56                   	push   %esi
  801ca0:	53                   	push   %ebx
  801ca1:	83 ec 28             	sub    $0x28,%esp
  801ca4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ca7:	56                   	push   %esi
  801ca8:	e8 8c f6 ff ff       	call   801339 <fd2data>
  801cad:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cba:	74 4f                	je     801d0b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cbc:	8b 43 04             	mov    0x4(%ebx),%eax
  801cbf:	8b 0b                	mov    (%ebx),%ecx
  801cc1:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc4:	39 d0                	cmp    %edx,%eax
  801cc6:	72 14                	jb     801cdc <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801cc8:	89 da                	mov    %ebx,%edx
  801cca:	89 f0                	mov    %esi,%eax
  801ccc:	e8 61 ff ff ff       	call   801c32 <_pipeisclosed>
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	75 3b                	jne    801d10 <devpipe_write+0x79>
			sys_yield();
  801cd5:	e8 14 f0 ff ff       	call   800cee <sys_yield>
  801cda:	eb e0                	jmp    801cbc <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cdf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ce3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ce6:	89 c2                	mov    %eax,%edx
  801ce8:	c1 fa 1f             	sar    $0x1f,%edx
  801ceb:	89 d1                	mov    %edx,%ecx
  801ced:	c1 e9 1b             	shr    $0x1b,%ecx
  801cf0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cf3:	83 e2 1f             	and    $0x1f,%edx
  801cf6:	29 ca                	sub    %ecx,%edx
  801cf8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cfc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d00:	83 c0 01             	add    $0x1,%eax
  801d03:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d06:	83 c7 01             	add    $0x1,%edi
  801d09:	eb ac                	jmp    801cb7 <devpipe_write+0x20>
	return i;
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	eb 05                	jmp    801d15 <devpipe_write+0x7e>
				return 0;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <devpipe_read>:
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	57                   	push   %edi
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	83 ec 18             	sub    $0x18,%esp
  801d2a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d2d:	57                   	push   %edi
  801d2e:	e8 06 f6 ff ff       	call   801339 <fd2data>
  801d33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	be 00 00 00 00       	mov    $0x0,%esi
  801d3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d40:	75 14                	jne    801d56 <devpipe_read+0x39>
	return i;
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	eb 02                	jmp    801d49 <devpipe_read+0x2c>
				return i;
  801d47:	89 f0                	mov    %esi,%eax
}
  801d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5f                   	pop    %edi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    
			sys_yield();
  801d51:	e8 98 ef ff ff       	call   800cee <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d56:	8b 03                	mov    (%ebx),%eax
  801d58:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d5b:	75 18                	jne    801d75 <devpipe_read+0x58>
			if (i > 0)
  801d5d:	85 f6                	test   %esi,%esi
  801d5f:	75 e6                	jne    801d47 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d61:	89 da                	mov    %ebx,%edx
  801d63:	89 f8                	mov    %edi,%eax
  801d65:	e8 c8 fe ff ff       	call   801c32 <_pipeisclosed>
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	74 e3                	je     801d51 <devpipe_read+0x34>
				return 0;
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d73:	eb d4                	jmp    801d49 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d75:	99                   	cltd   
  801d76:	c1 ea 1b             	shr    $0x1b,%edx
  801d79:	01 d0                	add    %edx,%eax
  801d7b:	83 e0 1f             	and    $0x1f,%eax
  801d7e:	29 d0                	sub    %edx,%eax
  801d80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d8b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d8e:	83 c6 01             	add    $0x1,%esi
  801d91:	eb aa                	jmp    801d3d <devpipe_read+0x20>

00801d93 <pipe>:
{
  801d93:	f3 0f 1e fb          	endbr32 
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da2:	50                   	push   %eax
  801da3:	e8 b0 f5 ff ff       	call   801358 <fd_alloc>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	0f 88 23 01 00 00    	js     801ed8 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	68 07 04 00 00       	push   $0x407
  801dbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 52 ef ff ff       	call   800d19 <sys_page_alloc>
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	83 c4 10             	add    $0x10,%esp
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	0f 88 04 01 00 00    	js     801ed8 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dda:	50                   	push   %eax
  801ddb:	e8 78 f5 ff ff       	call   801358 <fd_alloc>
  801de0:	89 c3                	mov    %eax,%ebx
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	85 c0                	test   %eax,%eax
  801de7:	0f 88 db 00 00 00    	js     801ec8 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ded:	83 ec 04             	sub    $0x4,%esp
  801df0:	68 07 04 00 00       	push   $0x407
  801df5:	ff 75 f0             	pushl  -0x10(%ebp)
  801df8:	6a 00                	push   $0x0
  801dfa:	e8 1a ef ff ff       	call   800d19 <sys_page_alloc>
  801dff:	89 c3                	mov    %eax,%ebx
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	85 c0                	test   %eax,%eax
  801e06:	0f 88 bc 00 00 00    	js     801ec8 <pipe+0x135>
	va = fd2data(fd0);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e12:	e8 22 f5 ff ff       	call   801339 <fd2data>
  801e17:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e19:	83 c4 0c             	add    $0xc,%esp
  801e1c:	68 07 04 00 00       	push   $0x407
  801e21:	50                   	push   %eax
  801e22:	6a 00                	push   $0x0
  801e24:	e8 f0 ee ff ff       	call   800d19 <sys_page_alloc>
  801e29:	89 c3                	mov    %eax,%ebx
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	0f 88 82 00 00 00    	js     801eb8 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3c:	e8 f8 f4 ff ff       	call   801339 <fd2data>
  801e41:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e48:	50                   	push   %eax
  801e49:	6a 00                	push   $0x0
  801e4b:	56                   	push   %esi
  801e4c:	6a 00                	push   $0x0
  801e4e:	e8 ee ee ff ff       	call   800d41 <sys_page_map>
  801e53:	89 c3                	mov    %eax,%ebx
  801e55:	83 c4 20             	add    $0x20,%esp
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	78 4e                	js     801eaa <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e5c:	a1 20 30 80 00       	mov    0x803020,%eax
  801e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e64:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e69:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e73:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e78:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff 75 f4             	pushl  -0xc(%ebp)
  801e85:	e8 9b f4 ff ff       	call   801325 <fd2num>
  801e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e8d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e8f:	83 c4 04             	add    $0x4,%esp
  801e92:	ff 75 f0             	pushl  -0x10(%ebp)
  801e95:	e8 8b f4 ff ff       	call   801325 <fd2num>
  801e9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e9d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ea8:	eb 2e                	jmp    801ed8 <pipe+0x145>
	sys_page_unmap(0, va);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	56                   	push   %esi
  801eae:	6a 00                	push   $0x0
  801eb0:	e8 b6 ee ff ff       	call   800d6b <sys_page_unmap>
  801eb5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801eb8:	83 ec 08             	sub    $0x8,%esp
  801ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebe:	6a 00                	push   $0x0
  801ec0:	e8 a6 ee ff ff       	call   800d6b <sys_page_unmap>
  801ec5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 96 ee ff ff       	call   800d6b <sys_page_unmap>
  801ed5:	83 c4 10             	add    $0x10,%esp
}
  801ed8:	89 d8                	mov    %ebx,%eax
  801eda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5e                   	pop    %esi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <pipeisclosed>:
{
  801ee1:	f3 0f 1e fb          	endbr32 
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eee:	50                   	push   %eax
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	e8 b7 f4 ff ff       	call   8013ae <fd_lookup>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 18                	js     801f16 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff 75 f4             	pushl  -0xc(%ebp)
  801f04:	e8 30 f4 ff ff       	call   801339 <fd2data>
  801f09:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	e8 1f fd ff ff       	call   801c32 <_pipeisclosed>
  801f13:	83 c4 10             	add    $0x10,%esp
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f18:	f3 0f 1e fb          	endbr32 
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	56                   	push   %esi
  801f20:	53                   	push   %ebx
  801f21:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f24:	85 f6                	test   %esi,%esi
  801f26:	74 13                	je     801f3b <wait+0x23>
	e = &envs[ENVX(envid)];
  801f28:	89 f3                	mov    %esi,%ebx
  801f2a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f30:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f33:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f39:	eb 1b                	jmp    801f56 <wait+0x3e>
	assert(envid != 0);
  801f3b:	68 9b 2c 80 00       	push   $0x802c9b
  801f40:	68 49 2c 80 00       	push   $0x802c49
  801f45:	6a 09                	push   $0x9
  801f47:	68 a6 2c 80 00       	push   $0x802ca6
  801f4c:	e8 ef e2 ff ff       	call   800240 <_panic>
		sys_yield();
  801f51:	e8 98 ed ff ff       	call   800cee <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f56:	8b 43 48             	mov    0x48(%ebx),%eax
  801f59:	39 f0                	cmp    %esi,%eax
  801f5b:	75 07                	jne    801f64 <wait+0x4c>
  801f5d:	8b 43 54             	mov    0x54(%ebx),%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	75 ed                	jne    801f51 <wait+0x39>
}
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f6b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	c3                   	ret    

00801f75 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f75:	f3 0f 1e fb          	endbr32 
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f7f:	68 b1 2c 80 00       	push   $0x802cb1
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	e8 05 e9 ff ff       	call   800891 <strcpy>
	return 0;
}
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <devcons_write>:
{
  801f93:	f3 0f 1e fb          	endbr32 
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	57                   	push   %edi
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fa3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fa8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fae:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb1:	73 31                	jae    801fe4 <devcons_write+0x51>
		m = n - tot;
  801fb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fb6:	29 f3                	sub    %esi,%ebx
  801fb8:	83 fb 7f             	cmp    $0x7f,%ebx
  801fbb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fc0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	53                   	push   %ebx
  801fc7:	89 f0                	mov    %esi,%eax
  801fc9:	03 45 0c             	add    0xc(%ebp),%eax
  801fcc:	50                   	push   %eax
  801fcd:	57                   	push   %edi
  801fce:	e8 76 ea ff ff       	call   800a49 <memmove>
		sys_cputs(buf, m);
  801fd3:	83 c4 08             	add    $0x8,%esp
  801fd6:	53                   	push   %ebx
  801fd7:	57                   	push   %edi
  801fd8:	e8 71 ec ff ff       	call   800c4e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fdd:	01 de                	add    %ebx,%esi
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	eb ca                	jmp    801fae <devcons_write+0x1b>
}
  801fe4:	89 f0                	mov    %esi,%eax
  801fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5f                   	pop    %edi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <devcons_read>:
{
  801fee:	f3 0f 1e fb          	endbr32 
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 08             	sub    $0x8,%esp
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ffd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802001:	74 21                	je     802024 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802003:	e8 70 ec ff ff       	call   800c78 <sys_cgetc>
  802008:	85 c0                	test   %eax,%eax
  80200a:	75 07                	jne    802013 <devcons_read+0x25>
		sys_yield();
  80200c:	e8 dd ec ff ff       	call   800cee <sys_yield>
  802011:	eb f0                	jmp    802003 <devcons_read+0x15>
	if (c < 0)
  802013:	78 0f                	js     802024 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802015:	83 f8 04             	cmp    $0x4,%eax
  802018:	74 0c                	je     802026 <devcons_read+0x38>
	*(char*)vbuf = c;
  80201a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201d:	88 02                	mov    %al,(%edx)
	return 1;
  80201f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    
		return 0;
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
  80202b:	eb f7                	jmp    802024 <devcons_read+0x36>

0080202d <cputchar>:
{
  80202d:	f3 0f 1e fb          	endbr32 
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80203d:	6a 01                	push   $0x1
  80203f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802042:	50                   	push   %eax
  802043:	e8 06 ec ff ff       	call   800c4e <sys_cputs>
}
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <getchar>:
{
  80204d:	f3 0f 1e fb          	endbr32 
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802057:	6a 01                	push   $0x1
  802059:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	6a 00                	push   $0x0
  80205f:	e8 cd f5 ff ff       	call   801631 <read>
	if (r < 0)
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	78 06                	js     802071 <getchar+0x24>
	if (r < 1)
  80206b:	74 06                	je     802073 <getchar+0x26>
	return c;
  80206d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    
		return -E_EOF;
  802073:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802078:	eb f7                	jmp    802071 <getchar+0x24>

0080207a <iscons>:
{
  80207a:	f3 0f 1e fb          	endbr32 
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802087:	50                   	push   %eax
  802088:	ff 75 08             	pushl  0x8(%ebp)
  80208b:	e8 1e f3 ff ff       	call   8013ae <fd_lookup>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 11                	js     8020a8 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020a0:	39 10                	cmp    %edx,(%eax)
  8020a2:	0f 94 c0             	sete   %al
  8020a5:	0f b6 c0             	movzbl %al,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <opencons>:
{
  8020aa:	f3 0f 1e fb          	endbr32 
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b7:	50                   	push   %eax
  8020b8:	e8 9b f2 ff ff       	call   801358 <fd_alloc>
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	78 3a                	js     8020fe <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	68 07 04 00 00       	push   $0x407
  8020cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8020cf:	6a 00                	push   $0x0
  8020d1:	e8 43 ec ff ff       	call   800d19 <sys_page_alloc>
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	78 21                	js     8020fe <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020e6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	50                   	push   %eax
  8020f6:	e8 2a f2 ff ff       	call   801325 <fd2num>
  8020fb:	83 c4 10             	add    $0x10,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80210a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802111:	74 0a                	je     80211d <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  80211d:	a1 20 44 80 00       	mov    0x804420,%eax
  802122:	8b 40 48             	mov    0x48(%eax),%eax
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	6a 07                	push   $0x7
  80212a:	68 00 f0 bf ee       	push   $0xeebff000
  80212f:	50                   	push   %eax
  802130:	e8 e4 eb ff ff       	call   800d19 <sys_page_alloc>
		if (r!= 0)
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 2f                	jne    80216b <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80213c:	a1 20 44 80 00       	mov    0x804420,%eax
  802141:	8b 40 48             	mov    0x48(%eax),%eax
  802144:	83 ec 08             	sub    $0x8,%esp
  802147:	68 7d 21 80 00       	push   $0x80217d
  80214c:	50                   	push   %eax
  80214d:	e8 8e ec ff ff       	call   800de0 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	74 ba                	je     802113 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802159:	50                   	push   %eax
  80215a:	68 bd 2c 80 00       	push   $0x802cbd
  80215f:	6a 26                	push   $0x26
  802161:	68 d5 2c 80 00       	push   $0x802cd5
  802166:	e8 d5 e0 ff ff       	call   800240 <_panic>
			panic("set_pgfault_handler: %e", r);
  80216b:	50                   	push   %eax
  80216c:	68 bd 2c 80 00       	push   $0x802cbd
  802171:	6a 22                	push   $0x22
  802173:	68 d5 2c 80 00       	push   $0x802cd5
  802178:	e8 c3 e0 ff ff       	call   800240 <_panic>

0080217d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80217d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80217e:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802183:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802185:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802188:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80218c:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80218f:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802193:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802197:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802199:	83 c4 08             	add    $0x8,%esp
	popal
  80219c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80219d:	83 c4 04             	add    $0x4,%esp
	popfl
  8021a0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8021a1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8021a2:	c3                   	ret    

008021a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021a3:	f3 0f 1e fb          	endbr32 
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8021af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021bc:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	50                   	push   %eax
  8021c3:	e8 68 ec ff ff       	call   800e30 <sys_ipc_recv>
	if (r < 0) {
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	78 2b                	js     8021fa <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8021cf:	85 f6                	test   %esi,%esi
  8021d1:	74 0a                	je     8021dd <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8021d3:	a1 20 44 80 00       	mov    0x804420,%eax
  8021d8:	8b 40 74             	mov    0x74(%eax),%eax
  8021db:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8021dd:	85 db                	test   %ebx,%ebx
  8021df:	74 0a                	je     8021eb <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8021e1:	a1 20 44 80 00       	mov    0x804420,%eax
  8021e6:	8b 40 78             	mov    0x78(%eax),%eax
  8021e9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021eb:	a1 20 44 80 00       	mov    0x804420,%eax
  8021f0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5e                   	pop    %esi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
		if (from_env_store) {
  8021fa:	85 f6                	test   %esi,%esi
  8021fc:	74 06                	je     802204 <ipc_recv+0x61>
			*from_env_store = 0;
  8021fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  802204:	85 db                	test   %ebx,%ebx
  802206:	74 eb                	je     8021f3 <ipc_recv+0x50>
			*perm_store = 0;
  802208:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80220e:	eb e3                	jmp    8021f3 <ipc_recv+0x50>

00802210 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	57                   	push   %edi
  802218:	56                   	push   %esi
  802219:	53                   	push   %ebx
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802220:	8b 75 0c             	mov    0xc(%ebp),%esi
  802223:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  802226:	85 db                	test   %ebx,%ebx
  802228:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80222d:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802230:	ff 75 14             	pushl  0x14(%ebp)
  802233:	53                   	push   %ebx
  802234:	56                   	push   %esi
  802235:	57                   	push   %edi
  802236:	e8 cc eb ff ff       	call   800e07 <sys_ipc_try_send>
  80223b:	83 c4 10             	add    $0x10,%esp
  80223e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802241:	75 07                	jne    80224a <ipc_send+0x3a>
		sys_yield();
  802243:	e8 a6 ea ff ff       	call   800cee <sys_yield>
  802248:	eb e6                	jmp    802230 <ipc_send+0x20>
	}

	if (ret < 0) {
  80224a:	85 c0                	test   %eax,%eax
  80224c:	78 08                	js     802256 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  80224e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802256:	50                   	push   %eax
  802257:	68 e3 2c 80 00       	push   $0x802ce3
  80225c:	6a 48                	push   $0x48
  80225e:	68 00 2d 80 00       	push   $0x802d00
  802263:	e8 d8 df ff ff       	call   800240 <_panic>

00802268 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802268:	f3 0f 1e fb          	endbr32 
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802277:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80227a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802280:	8b 52 50             	mov    0x50(%edx),%edx
  802283:	39 ca                	cmp    %ecx,%edx
  802285:	74 11                	je     802298 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802287:	83 c0 01             	add    $0x1,%eax
  80228a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80228f:	75 e6                	jne    802277 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
  802296:	eb 0b                	jmp    8022a3 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802298:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80229b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022a0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    

008022a5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022a5:	f3 0f 1e fb          	endbr32 
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022af:	89 c2                	mov    %eax,%edx
  8022b1:	c1 ea 16             	shr    $0x16,%edx
  8022b4:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022bb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c0:	f6 c1 01             	test   $0x1,%cl
  8022c3:	74 1c                	je     8022e1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022c5:	c1 e8 0c             	shr    $0xc,%eax
  8022c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022cf:	a8 01                	test   $0x1,%al
  8022d1:	74 0e                	je     8022e1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022d3:	c1 e8 0c             	shr    $0xc,%eax
  8022d6:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022dd:	ef 
  8022de:	0f b7 d2             	movzwl %dx,%edx
}
  8022e1:	89 d0                	mov    %edx,%eax
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
  8022e5:	66 90                	xchg   %ax,%ax
  8022e7:	66 90                	xchg   %ax,%ax
  8022e9:	66 90                	xchg   %ax,%ax
  8022eb:	66 90                	xchg   %ax,%ax
  8022ed:	66 90                	xchg   %ax,%ax
  8022ef:	90                   	nop

008022f0 <__udivdi3>:
  8022f0:	f3 0f 1e fb          	endbr32 
  8022f4:	55                   	push   %ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802303:	8b 74 24 34          	mov    0x34(%esp),%esi
  802307:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80230b:	85 d2                	test   %edx,%edx
  80230d:	75 19                	jne    802328 <__udivdi3+0x38>
  80230f:	39 f3                	cmp    %esi,%ebx
  802311:	76 4d                	jbe    802360 <__udivdi3+0x70>
  802313:	31 ff                	xor    %edi,%edi
  802315:	89 e8                	mov    %ebp,%eax
  802317:	89 f2                	mov    %esi,%edx
  802319:	f7 f3                	div    %ebx
  80231b:	89 fa                	mov    %edi,%edx
  80231d:	83 c4 1c             	add    $0x1c,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	76 14                	jbe    802340 <__udivdi3+0x50>
  80232c:	31 ff                	xor    %edi,%edi
  80232e:	31 c0                	xor    %eax,%eax
  802330:	89 fa                	mov    %edi,%edx
  802332:	83 c4 1c             	add    $0x1c,%esp
  802335:	5b                   	pop    %ebx
  802336:	5e                   	pop    %esi
  802337:	5f                   	pop    %edi
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    
  80233a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802340:	0f bd fa             	bsr    %edx,%edi
  802343:	83 f7 1f             	xor    $0x1f,%edi
  802346:	75 48                	jne    802390 <__udivdi3+0xa0>
  802348:	39 f2                	cmp    %esi,%edx
  80234a:	72 06                	jb     802352 <__udivdi3+0x62>
  80234c:	31 c0                	xor    %eax,%eax
  80234e:	39 eb                	cmp    %ebp,%ebx
  802350:	77 de                	ja     802330 <__udivdi3+0x40>
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	eb d7                	jmp    802330 <__udivdi3+0x40>
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	89 d9                	mov    %ebx,%ecx
  802362:	85 db                	test   %ebx,%ebx
  802364:	75 0b                	jne    802371 <__udivdi3+0x81>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f3                	div    %ebx
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	31 d2                	xor    %edx,%edx
  802373:	89 f0                	mov    %esi,%eax
  802375:	f7 f1                	div    %ecx
  802377:	89 c6                	mov    %eax,%esi
  802379:	89 e8                	mov    %ebp,%eax
  80237b:	89 f7                	mov    %esi,%edi
  80237d:	f7 f1                	div    %ecx
  80237f:	89 fa                	mov    %edi,%edx
  802381:	83 c4 1c             	add    $0x1c,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5f                   	pop    %edi
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 40 ff ff ff       	jmp    802330 <__udivdi3+0x40>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 36 ff ff ff       	jmp    802330 <__udivdi3+0x40>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	f3 0f 1e fb          	endbr32 
  802404:	55                   	push   %ebp
  802405:	57                   	push   %edi
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	83 ec 1c             	sub    $0x1c,%esp
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80241b:	85 c0                	test   %eax,%eax
  80241d:	75 19                	jne    802438 <__umoddi3+0x38>
  80241f:	39 df                	cmp    %ebx,%edi
  802421:	76 5d                	jbe    802480 <__umoddi3+0x80>
  802423:	89 f0                	mov    %esi,%eax
  802425:	89 da                	mov    %ebx,%edx
  802427:	f7 f7                	div    %edi
  802429:	89 d0                	mov    %edx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	83 c4 1c             	add    $0x1c,%esp
  802430:	5b                   	pop    %ebx
  802431:	5e                   	pop    %esi
  802432:	5f                   	pop    %edi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	89 f2                	mov    %esi,%edx
  80243a:	39 d8                	cmp    %ebx,%eax
  80243c:	76 12                	jbe    802450 <__umoddi3+0x50>
  80243e:	89 f0                	mov    %esi,%eax
  802440:	89 da                	mov    %ebx,%edx
  802442:	83 c4 1c             	add    $0x1c,%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5f                   	pop    %edi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    
  80244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802450:	0f bd e8             	bsr    %eax,%ebp
  802453:	83 f5 1f             	xor    $0x1f,%ebp
  802456:	75 50                	jne    8024a8 <__umoddi3+0xa8>
  802458:	39 d8                	cmp    %ebx,%eax
  80245a:	0f 82 e0 00 00 00    	jb     802540 <__umoddi3+0x140>
  802460:	89 d9                	mov    %ebx,%ecx
  802462:	39 f7                	cmp    %esi,%edi
  802464:	0f 86 d6 00 00 00    	jbe    802540 <__umoddi3+0x140>
  80246a:	89 d0                	mov    %edx,%eax
  80246c:	89 ca                	mov    %ecx,%edx
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	89 fd                	mov    %edi,%ebp
  802482:	85 ff                	test   %edi,%edi
  802484:	75 0b                	jne    802491 <__umoddi3+0x91>
  802486:	b8 01 00 00 00       	mov    $0x1,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f7                	div    %edi
  80248f:	89 c5                	mov    %eax,%ebp
  802491:	89 d8                	mov    %ebx,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f5                	div    %ebp
  802497:	89 f0                	mov    %esi,%eax
  802499:	f7 f5                	div    %ebp
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	31 d2                	xor    %edx,%edx
  80249f:	eb 8c                	jmp    80242d <__umoddi3+0x2d>
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024af:	29 ea                	sub    %ebp,%edx
  8024b1:	d3 e0                	shl    %cl,%eax
  8024b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b7:	89 d1                	mov    %edx,%ecx
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	d3 e8                	shr    %cl,%eax
  8024bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024c9:	09 c1                	or     %eax,%ecx
  8024cb:	89 d8                	mov    %ebx,%eax
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 e9                	mov    %ebp,%ecx
  8024d3:	d3 e7                	shl    %cl,%edi
  8024d5:	89 d1                	mov    %edx,%ecx
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024df:	d3 e3                	shl    %cl,%ebx
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	89 d1                	mov    %edx,%ecx
  8024e5:	89 f0                	mov    %esi,%eax
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 fa                	mov    %edi,%edx
  8024ed:	d3 e6                	shl    %cl,%esi
  8024ef:	09 d8                	or     %ebx,%eax
  8024f1:	f7 74 24 08          	divl   0x8(%esp)
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	89 f3                	mov    %esi,%ebx
  8024f9:	f7 64 24 0c          	mull   0xc(%esp)
  8024fd:	89 c6                	mov    %eax,%esi
  8024ff:	89 d7                	mov    %edx,%edi
  802501:	39 d1                	cmp    %edx,%ecx
  802503:	72 06                	jb     80250b <__umoddi3+0x10b>
  802505:	75 10                	jne    802517 <__umoddi3+0x117>
  802507:	39 c3                	cmp    %eax,%ebx
  802509:	73 0c                	jae    802517 <__umoddi3+0x117>
  80250b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80250f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802513:	89 d7                	mov    %edx,%edi
  802515:	89 c6                	mov    %eax,%esi
  802517:	89 ca                	mov    %ecx,%edx
  802519:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251e:	29 f3                	sub    %esi,%ebx
  802520:	19 fa                	sbb    %edi,%edx
  802522:	89 d0                	mov    %edx,%eax
  802524:	d3 e0                	shl    %cl,%eax
  802526:	89 e9                	mov    %ebp,%ecx
  802528:	d3 eb                	shr    %cl,%ebx
  80252a:	d3 ea                	shr    %cl,%edx
  80252c:	09 d8                	or     %ebx,%eax
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	29 fe                	sub    %edi,%esi
  802542:	19 c3                	sbb    %eax,%ebx
  802544:	89 f2                	mov    %esi,%edx
  802546:	89 d9                	mov    %ebx,%ecx
  802548:	e9 1d ff ff ff       	jmp    80246a <__umoddi3+0x6a>
