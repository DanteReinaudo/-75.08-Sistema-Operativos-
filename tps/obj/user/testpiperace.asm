
obj/user/testpiperace.debug:     formato del fichero elf32-i386


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
  80002c:	e8 c1 01 00 00       	call   8001f2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003f:	68 20 25 80 00       	push   $0x802520
  800044:	e8 fc 02 00 00       	call   800345 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 9f 1e 00 00       	call   801ef3 <pipe>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	78 59                	js     8000b4 <umain+0x81>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 97 11 00 00       	call   8011f7 <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	78 60                	js     8000c6 <umain+0x93>
		panic("fork: %e", r);
	if (r == 0) {
  800066:	74 70                	je     8000d8 <umain+0xa5>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 71 25 80 00       	push   $0x802571
  800071:	e8 cf 02 00 00       	call   800345 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800082:	c1 f8 02             	sar    $0x2,%eax
  800085:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  80008b:	50                   	push   %eax
  80008c:	68 7c 25 80 00       	push   $0x80257c
  800091:	e8 af 02 00 00       	call   800345 <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 be 15 00 00       	call   801661 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	e9 92 00 00 00       	jmp    800146 <umain+0x113>
		panic("pipe: %e", r);
  8000b4:	50                   	push   %eax
  8000b5:	68 39 25 80 00       	push   $0x802539
  8000ba:	6a 0d                	push   $0xd
  8000bc:	68 42 25 80 00       	push   $0x802542
  8000c1:	e8 98 01 00 00       	call   80025e <_panic>
		panic("fork: %e", r);
  8000c6:	50                   	push   %eax
  8000c7:	68 e7 29 80 00       	push   $0x8029e7
  8000cc:	6a 10                	push   $0x10
  8000ce:	68 42 25 80 00       	push   $0x802542
  8000d3:	e8 86 01 00 00       	call   80025e <_panic>
		close(p[1]);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 f4             	pushl  -0xc(%ebp)
  8000de:	e8 24 15 00 00       	call   801607 <close>
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000eb:	eb 1f                	jmp    80010c <umain+0xd9>
				cprintf("RACE: pipe appears closed\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 56 25 80 00       	push   $0x802556
  8000f5:	e8 4b 02 00 00       	call   800345 <cprintf>
				exit();
  8000fa:	e8 41 01 00 00       	call   800240 <exit>
  8000ff:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800102:	e8 05 0c 00 00       	call   800d0c <sys_yield>
		for (i=0; i<max; i++) {
  800107:	83 eb 01             	sub    $0x1,%ebx
  80010a:	74 14                	je     800120 <umain+0xed>
			if(pipeisclosed(p[0])){
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	e8 2a 1f 00 00       	call   802041 <pipeisclosed>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	85 c0                	test   %eax,%eax
  80011c:	74 e4                	je     800102 <umain+0xcf>
  80011e:	eb cd                	jmp    8000ed <umain+0xba>
		ipc_recv(0,0,0);
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	e8 15 12 00 00       	call   801343 <ipc_recv>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	e9 32 ff ff ff       	jmp    800068 <umain+0x35>
		dup(p[0], 10);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	6a 0a                	push   $0xa
  80013b:	ff 75 f0             	pushl  -0x10(%ebp)
  80013e:	e8 1e 15 00 00       	call   801661 <dup>
  800143:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 43 54             	mov    0x54(%ebx),%eax
  800149:	83 f8 02             	cmp    $0x2,%eax
  80014c:	74 e8                	je     800136 <umain+0x103>

	cprintf("child done with loop\n");
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	68 87 25 80 00       	push   $0x802587
  800156:	e8 ea 01 00 00       	call   800345 <cprintf>
	if (pipeisclosed(p[0]))
  80015b:	83 c4 04             	add    $0x4,%esp
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 db 1e 00 00       	call   802041 <pipeisclosed>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	75 48                	jne    8001b5 <umain+0x182>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	ff 75 f0             	pushl  -0x10(%ebp)
  800177:	e8 52 13 00 00       	call   8014ce <fd_lookup>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	85 c0                	test   %eax,%eax
  800181:	78 46                	js     8001c9 <umain+0x196>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	e8 cb 12 00 00       	call   801459 <fd2data>
	if (pageref(va) != 3+1)
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 3c 1b 00 00       	call   801cd2 <pageref>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	83 f8 04             	cmp    $0x4,%eax
  80019c:	74 3d                	je     8001db <umain+0x1a8>
		cprintf("\nchild detected race\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 b5 25 80 00       	push   $0x8025b5
  8001a6:	e8 9a 01 00 00       	call   800345 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 e0 25 80 00       	push   $0x8025e0
  8001bd:	6a 3a                	push   $0x3a
  8001bf:	68 42 25 80 00       	push   $0x802542
  8001c4:	e8 95 00 00 00       	call   80025e <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c9:	50                   	push   %eax
  8001ca:	68 9d 25 80 00       	push   $0x80259d
  8001cf:	6a 3c                	push   $0x3c
  8001d1:	68 42 25 80 00       	push   $0x802542
  8001d6:	e8 83 00 00 00       	call   80025e <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	68 c8 00 00 00       	push   $0xc8
  8001e3:	68 cb 25 80 00       	push   $0x8025cb
  8001e8:	e8 58 01 00 00       	call   800345 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	eb bc                	jmp    8001ae <umain+0x17b>

008001f2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800201:	e8 de 0a 00 00       	call   800ce4 <sys_getenvid>
	if (id >= 0)
  800206:	85 c0                	test   %eax,%eax
  800208:	78 12                	js     80021c <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80020a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80020f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021c:	85 db                	test   %ebx,%ebx
  80021e:	7e 07                	jle    800227 <libmain+0x35>
		binaryname = argv[0];
  800220:	8b 06                	mov    (%esi),%eax
  800222:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	e8 02 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800231:	e8 0a 00 00 00       	call   800240 <exit>
}
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80023c:	5b                   	pop    %ebx
  80023d:	5e                   	pop    %esi
  80023e:	5d                   	pop    %ebp
  80023f:	c3                   	ret    

00800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	f3 0f 1e fb          	endbr32 
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80024a:	e8 e9 13 00 00       	call   801638 <close_all>
	sys_env_destroy(0);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	6a 00                	push   $0x0
  800254:	e8 65 0a 00 00       	call   800cbe <sys_env_destroy>
}
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025e:	f3 0f 1e fb          	endbr32 
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800267:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80026a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800270:	e8 6f 0a 00 00       	call   800ce4 <sys_getenvid>
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	56                   	push   %esi
  80027f:	50                   	push   %eax
  800280:	68 14 26 80 00       	push   $0x802614
  800285:	e8 bb 00 00 00       	call   800345 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80028a:	83 c4 18             	add    $0x18,%esp
  80028d:	53                   	push   %ebx
  80028e:	ff 75 10             	pushl  0x10(%ebp)
  800291:	e8 5a 00 00 00       	call   8002f0 <vcprintf>
	cprintf("\n");
  800296:	c7 04 24 29 2b 80 00 	movl   $0x802b29,(%esp)
  80029d:	e8 a3 00 00 00       	call   800345 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a5:	cc                   	int3   
  8002a6:	eb fd                	jmp    8002a5 <_panic+0x47>

008002a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a8:	f3 0f 1e fb          	endbr32 
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b6:	8b 13                	mov    (%ebx),%edx
  8002b8:	8d 42 01             	lea    0x1(%edx),%eax
  8002bb:	89 03                	mov    %eax,(%ebx)
  8002bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c9:	74 09                	je     8002d4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002cb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	68 ff 00 00 00       	push   $0xff
  8002dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8002df:	50                   	push   %eax
  8002e0:	e8 87 09 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  8002e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb db                	jmp    8002cb <putch+0x23>

008002f0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f0:	f3 0f 1e fb          	endbr32 
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800304:	00 00 00 
	b.cnt = 0;
  800307:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031d:	50                   	push   %eax
  80031e:	68 a8 02 80 00       	push   $0x8002a8
  800323:	e8 80 01 00 00       	call   8004a8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800328:	83 c4 08             	add    $0x8,%esp
  80032b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800331:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800337:	50                   	push   %eax
  800338:	e8 2f 09 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  80033d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800345:	f3 0f 1e fb          	endbr32 
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800352:	50                   	push   %eax
  800353:	ff 75 08             	pushl  0x8(%ebp)
  800356:	e8 95 ff ff ff       	call   8002f0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	57                   	push   %edi
  800361:	56                   	push   %esi
  800362:	53                   	push   %ebx
  800363:	83 ec 1c             	sub    $0x1c,%esp
  800366:	89 c7                	mov    %eax,%edi
  800368:	89 d6                	mov    %edx,%esi
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800370:	89 d1                	mov    %edx,%ecx
  800372:	89 c2                	mov    %eax,%edx
  800374:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800377:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80037a:	8b 45 10             	mov    0x10(%ebp),%eax
  80037d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800380:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800383:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80038a:	39 c2                	cmp    %eax,%edx
  80038c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80038f:	72 3e                	jb     8003cf <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	ff 75 18             	pushl  0x18(%ebp)
  800397:	83 eb 01             	sub    $0x1,%ebx
  80039a:	53                   	push   %ebx
  80039b:	50                   	push   %eax
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ab:	e8 00 1f 00 00       	call   8022b0 <__udivdi3>
  8003b0:	83 c4 18             	add    $0x18,%esp
  8003b3:	52                   	push   %edx
  8003b4:	50                   	push   %eax
  8003b5:	89 f2                	mov    %esi,%edx
  8003b7:	89 f8                	mov    %edi,%eax
  8003b9:	e8 9f ff ff ff       	call   80035d <printnum>
  8003be:	83 c4 20             	add    $0x20,%esp
  8003c1:	eb 13                	jmp    8003d6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	56                   	push   %esi
  8003c7:	ff 75 18             	pushl  0x18(%ebp)
  8003ca:	ff d7                	call   *%edi
  8003cc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003cf:	83 eb 01             	sub    $0x1,%ebx
  8003d2:	85 db                	test   %ebx,%ebx
  8003d4:	7f ed                	jg     8003c3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	56                   	push   %esi
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e9:	e8 d2 1f 00 00       	call   8023c0 <__umoddi3>
  8003ee:	83 c4 14             	add    $0x14,%esp
  8003f1:	0f be 80 37 26 80 00 	movsbl 0x802637(%eax),%eax
  8003f8:	50                   	push   %eax
  8003f9:	ff d7                	call   *%edi
}
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800406:	83 fa 01             	cmp    $0x1,%edx
  800409:	7f 13                	jg     80041e <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  80040b:	85 d2                	test   %edx,%edx
  80040d:	74 1c                	je     80042b <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80040f:	8b 10                	mov    (%eax),%edx
  800411:	8d 4a 04             	lea    0x4(%edx),%ecx
  800414:	89 08                	mov    %ecx,(%eax)
  800416:	8b 02                	mov    (%edx),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
  80041d:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80041e:	8b 10                	mov    (%eax),%edx
  800420:	8d 4a 08             	lea    0x8(%edx),%ecx
  800423:	89 08                	mov    %ecx,(%eax)
  800425:	8b 02                	mov    (%edx),%eax
  800427:	8b 52 04             	mov    0x4(%edx),%edx
  80042a:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80042b:	8b 10                	mov    (%eax),%edx
  80042d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800430:	89 08                	mov    %ecx,(%eax)
  800432:	8b 02                	mov    (%edx),%eax
  800434:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800439:	c3                   	ret    

0080043a <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80043a:	83 fa 01             	cmp    $0x1,%edx
  80043d:	7f 0f                	jg     80044e <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 18                	je     80045b <getint+0x21>
		return va_arg(*ap, long);
  800443:	8b 10                	mov    (%eax),%edx
  800445:	8d 4a 04             	lea    0x4(%edx),%ecx
  800448:	89 08                	mov    %ecx,(%eax)
  80044a:	8b 02                	mov    (%edx),%eax
  80044c:	99                   	cltd   
  80044d:	c3                   	ret    
		return va_arg(*ap, long long);
  80044e:	8b 10                	mov    (%eax),%edx
  800450:	8d 4a 08             	lea    0x8(%edx),%ecx
  800453:	89 08                	mov    %ecx,(%eax)
  800455:	8b 02                	mov    (%edx),%eax
  800457:	8b 52 04             	mov    0x4(%edx),%edx
  80045a:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80045b:	8b 10                	mov    (%eax),%edx
  80045d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800460:	89 08                	mov    %ecx,(%eax)
  800462:	8b 02                	mov    (%edx),%eax
  800464:	99                   	cltd   
}
  800465:	c3                   	ret    

00800466 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800466:	f3 0f 1e fb          	endbr32 
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800470:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800474:	8b 10                	mov    (%eax),%edx
  800476:	3b 50 04             	cmp    0x4(%eax),%edx
  800479:	73 0a                	jae    800485 <sprintputch+0x1f>
		*b->buf++ = ch;
  80047b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80047e:	89 08                	mov    %ecx,(%eax)
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	88 02                	mov    %al,(%edx)
}
  800485:	5d                   	pop    %ebp
  800486:	c3                   	ret    

00800487 <printfmt>:
{
  800487:	f3 0f 1e fb          	endbr32 
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800491:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800494:	50                   	push   %eax
  800495:	ff 75 10             	pushl  0x10(%ebp)
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	e8 05 00 00 00       	call   8004a8 <vprintfmt>
}
  8004a3:	83 c4 10             	add    $0x10,%esp
  8004a6:	c9                   	leave  
  8004a7:	c3                   	ret    

008004a8 <vprintfmt>:
{
  8004a8:	f3 0f 1e fb          	endbr32 
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	57                   	push   %edi
  8004b0:	56                   	push   %esi
  8004b1:	53                   	push   %ebx
  8004b2:	83 ec 2c             	sub    $0x2c,%esp
  8004b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004be:	e9 86 02 00 00       	jmp    800749 <vprintfmt+0x2a1>
		padc = ' ';
  8004c3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004c7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e1:	8d 47 01             	lea    0x1(%edi),%eax
  8004e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e7:	0f b6 17             	movzbl (%edi),%edx
  8004ea:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ed:	3c 55                	cmp    $0x55,%al
  8004ef:	0f 87 df 02 00 00    	ja     8007d4 <vprintfmt+0x32c>
  8004f5:	0f b6 c0             	movzbl %al,%eax
  8004f8:	3e ff 24 85 80 27 80 	notrack jmp *0x802780(,%eax,4)
  8004ff:	00 
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800503:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800507:	eb d8                	jmp    8004e1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800510:	eb cf                	jmp    8004e1 <vprintfmt+0x39>
  800512:	0f b6 d2             	movzbl %dl,%edx
  800515:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800518:	b8 00 00 00 00       	mov    $0x0,%eax
  80051d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800520:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800523:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800527:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80052a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80052d:	83 f9 09             	cmp    $0x9,%ecx
  800530:	77 52                	ja     800584 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800532:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800535:	eb e9                	jmp    800520 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8d 50 04             	lea    0x4(%eax),%edx
  80053d:	89 55 14             	mov    %edx,0x14(%ebp)
  800540:	8b 00                	mov    (%eax),%eax
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800548:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054c:	79 93                	jns    8004e1 <vprintfmt+0x39>
				width = precision, precision = -1;
  80054e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800554:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80055b:	eb 84                	jmp    8004e1 <vprintfmt+0x39>
  80055d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800560:	85 c0                	test   %eax,%eax
  800562:	ba 00 00 00 00       	mov    $0x0,%edx
  800567:	0f 49 d0             	cmovns %eax,%edx
  80056a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800570:	e9 6c ff ff ff       	jmp    8004e1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800578:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80057f:	e9 5d ff ff ff       	jmp    8004e1 <vprintfmt+0x39>
  800584:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800587:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80058a:	eb bc                	jmp    800548 <vprintfmt+0xa0>
			lflag++;
  80058c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800592:	e9 4a ff ff ff       	jmp    8004e1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 50 04             	lea    0x4(%eax),%edx
  80059d:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	ff 30                	pushl  (%eax)
  8005a6:	ff d3                	call   *%ebx
			break;
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	e9 96 01 00 00       	jmp    800746 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8d 50 04             	lea    0x4(%eax),%edx
  8005b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	99                   	cltd   
  8005bc:	31 d0                	xor    %edx,%eax
  8005be:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c0:	83 f8 0f             	cmp    $0xf,%eax
  8005c3:	7f 20                	jg     8005e5 <vprintfmt+0x13d>
  8005c5:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  8005cc:	85 d2                	test   %edx,%edx
  8005ce:	74 15                	je     8005e5 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8005d0:	52                   	push   %edx
  8005d1:	68 03 2c 80 00       	push   $0x802c03
  8005d6:	56                   	push   %esi
  8005d7:	53                   	push   %ebx
  8005d8:	e8 aa fe ff ff       	call   800487 <printfmt>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	e9 61 01 00 00       	jmp    800746 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8005e5:	50                   	push   %eax
  8005e6:	68 4f 26 80 00       	push   $0x80264f
  8005eb:	56                   	push   %esi
  8005ec:	53                   	push   %ebx
  8005ed:	e8 95 fe ff ff       	call   800487 <printfmt>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	e9 4c 01 00 00       	jmp    800746 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 50 04             	lea    0x4(%eax),%edx
  800600:	89 55 14             	mov    %edx,0x14(%ebp)
  800603:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800605:	85 c9                	test   %ecx,%ecx
  800607:	b8 48 26 80 00       	mov    $0x802648,%eax
  80060c:	0f 45 c1             	cmovne %ecx,%eax
  80060f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800612:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800616:	7e 06                	jle    80061e <vprintfmt+0x176>
  800618:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80061c:	75 0d                	jne    80062b <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800621:	89 c7                	mov    %eax,%edi
  800623:	03 45 e0             	add    -0x20(%ebp),%eax
  800626:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800629:	eb 57                	jmp    800682 <vprintfmt+0x1da>
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 d8             	pushl  -0x28(%ebp)
  800631:	ff 75 cc             	pushl  -0x34(%ebp)
  800634:	e8 4f 02 00 00       	call   800888 <strnlen>
  800639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063c:	29 c2                	sub    %eax,%edx
  80063e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800641:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800644:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800648:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80064b:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	7e 10                	jle    800661 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	56                   	push   %esi
  800655:	57                   	push   %edi
  800656:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800659:	83 eb 01             	sub    $0x1,%ebx
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb ec                	jmp    80064d <vprintfmt+0x1a5>
  800661:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800667:	85 d2                	test   %edx,%edx
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	0f 49 c2             	cmovns %edx,%eax
  800671:	29 c2                	sub    %eax,%edx
  800673:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800676:	eb a6                	jmp    80061e <vprintfmt+0x176>
					putch(ch, putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	56                   	push   %esi
  80067c:	52                   	push   %edx
  80067d:	ff d3                	call   *%ebx
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800685:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800687:	83 c7 01             	add    $0x1,%edi
  80068a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068e:	0f be d0             	movsbl %al,%edx
  800691:	85 d2                	test   %edx,%edx
  800693:	74 42                	je     8006d7 <vprintfmt+0x22f>
  800695:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800699:	78 06                	js     8006a1 <vprintfmt+0x1f9>
  80069b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80069f:	78 1e                	js     8006bf <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a5:	74 d1                	je     800678 <vprintfmt+0x1d0>
  8006a7:	0f be c0             	movsbl %al,%eax
  8006aa:	83 e8 20             	sub    $0x20,%eax
  8006ad:	83 f8 5e             	cmp    $0x5e,%eax
  8006b0:	76 c6                	jbe    800678 <vprintfmt+0x1d0>
					putch('?', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	6a 3f                	push   $0x3f
  8006b8:	ff d3                	call   *%ebx
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	eb c3                	jmp    800682 <vprintfmt+0x1da>
  8006bf:	89 cf                	mov    %ecx,%edi
  8006c1:	eb 0e                	jmp    8006d1 <vprintfmt+0x229>
				putch(' ', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	56                   	push   %esi
  8006c7:	6a 20                	push   $0x20
  8006c9:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8006cb:	83 ef 01             	sub    $0x1,%edi
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	85 ff                	test   %edi,%edi
  8006d3:	7f ee                	jg     8006c3 <vprintfmt+0x21b>
  8006d5:	eb 6f                	jmp    800746 <vprintfmt+0x29e>
  8006d7:	89 cf                	mov    %ecx,%edi
  8006d9:	eb f6                	jmp    8006d1 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8006db:	89 ca                	mov    %ecx,%edx
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e0:	e8 55 fd ff ff       	call   80043a <getint>
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	78 0b                	js     8006fa <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8006ef:	89 d1                	mov    %edx,%ecx
  8006f1:	89 c2                	mov    %eax,%edx
			base = 10;
  8006f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f8:	eb 32                	jmp    80072c <vprintfmt+0x284>
				putch('-', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	56                   	push   %esi
  8006fe:	6a 2d                	push   $0x2d
  800700:	ff d3                	call   *%ebx
				num = -(long long) num;
  800702:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800705:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800708:	f7 da                	neg    %edx
  80070a:	83 d1 00             	adc    $0x0,%ecx
  80070d:	f7 d9                	neg    %ecx
  80070f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	eb 13                	jmp    80072c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800719:	89 ca                	mov    %ecx,%edx
  80071b:	8d 45 14             	lea    0x14(%ebp),%eax
  80071e:	e8 e3 fc ff ff       	call   800406 <getuint>
  800723:	89 d1                	mov    %edx,%ecx
  800725:	89 c2                	mov    %eax,%edx
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800733:	57                   	push   %edi
  800734:	ff 75 e0             	pushl  -0x20(%ebp)
  800737:	50                   	push   %eax
  800738:	51                   	push   %ecx
  800739:	52                   	push   %edx
  80073a:	89 f2                	mov    %esi,%edx
  80073c:	89 d8                	mov    %ebx,%eax
  80073e:	e8 1a fc ff ff       	call   80035d <printnum>
			break;
  800743:	83 c4 20             	add    $0x20,%esp
{
  800746:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800749:	83 c7 01             	add    $0x1,%edi
  80074c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800750:	83 f8 25             	cmp    $0x25,%eax
  800753:	0f 84 6a fd ff ff    	je     8004c3 <vprintfmt+0x1b>
			if (ch == '\0')
  800759:	85 c0                	test   %eax,%eax
  80075b:	0f 84 93 00 00 00    	je     8007f4 <vprintfmt+0x34c>
			putch(ch, putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	56                   	push   %esi
  800765:	50                   	push   %eax
  800766:	ff d3                	call   *%ebx
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	eb dc                	jmp    800749 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80076d:	89 ca                	mov    %ecx,%edx
  80076f:	8d 45 14             	lea    0x14(%ebp),%eax
  800772:	e8 8f fc ff ff       	call   800406 <getuint>
  800777:	89 d1                	mov    %edx,%ecx
  800779:	89 c2                	mov    %eax,%edx
			base = 8;
  80077b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800780:	eb aa                	jmp    80072c <vprintfmt+0x284>
			putch('0', putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	56                   	push   %esi
  800786:	6a 30                	push   $0x30
  800788:	ff d3                	call   *%ebx
			putch('x', putdat);
  80078a:	83 c4 08             	add    $0x8,%esp
  80078d:	56                   	push   %esi
  80078e:	6a 78                	push   $0x78
  800790:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80079b:	8b 10                	mov    (%eax),%edx
  80079d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a2:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8007a5:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007aa:	eb 80                	jmp    80072c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8007ac:	89 ca                	mov    %ecx,%edx
  8007ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b1:	e8 50 fc ff ff       	call   800406 <getuint>
  8007b6:	89 d1                	mov    %edx,%ecx
  8007b8:	89 c2                	mov    %eax,%edx
			base = 16;
  8007ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bf:	e9 68 ff ff ff       	jmp    80072c <vprintfmt+0x284>
			putch(ch, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	56                   	push   %esi
  8007c8:	6a 25                	push   $0x25
  8007ca:	ff d3                	call   *%ebx
			break;
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	e9 72 ff ff ff       	jmp    800746 <vprintfmt+0x29e>
			putch('%', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	56                   	push   %esi
  8007d8:	6a 25                	push   $0x25
  8007da:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	89 f8                	mov    %edi,%eax
  8007e1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e5:	74 05                	je     8007ec <vprintfmt+0x344>
  8007e7:	83 e8 01             	sub    $0x1,%eax
  8007ea:	eb f5                	jmp    8007e1 <vprintfmt+0x339>
  8007ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ef:	e9 52 ff ff ff       	jmp    800746 <vprintfmt+0x29e>
}
  8007f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800813:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081d:	85 c0                	test   %eax,%eax
  80081f:	74 26                	je     800847 <vsnprintf+0x4b>
  800821:	85 d2                	test   %edx,%edx
  800823:	7e 22                	jle    800847 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800825:	ff 75 14             	pushl  0x14(%ebp)
  800828:	ff 75 10             	pushl  0x10(%ebp)
  80082b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80082e:	50                   	push   %eax
  80082f:	68 66 04 80 00       	push   $0x800466
  800834:	e8 6f fc ff ff       	call   8004a8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800842:	83 c4 10             	add    $0x10,%esp
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    
		return -E_INVAL;
  800847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084c:	eb f7                	jmp    800845 <vsnprintf+0x49>

0080084e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085b:	50                   	push   %eax
  80085c:	ff 75 10             	pushl  0x10(%ebp)
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 92 ff ff ff       	call   8007fc <vsnprintf>
	va_end(ap);

	return rc;
}
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086c:	f3 0f 1e fb          	endbr32 
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087f:	74 05                	je     800886 <strlen+0x1a>
		n++;
  800881:	83 c0 01             	add    $0x1,%eax
  800884:	eb f5                	jmp    80087b <strlen+0xf>
	return n;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800888:	f3 0f 1e fb          	endbr32 
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800895:	b8 00 00 00 00       	mov    $0x0,%eax
  80089a:	39 d0                	cmp    %edx,%eax
  80089c:	74 0d                	je     8008ab <strnlen+0x23>
  80089e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a2:	74 05                	je     8008a9 <strnlen+0x21>
		n++;
  8008a4:	83 c0 01             	add    $0x1,%eax
  8008a7:	eb f1                	jmp    80089a <strnlen+0x12>
  8008a9:	89 c2                	mov    %eax,%edx
	return n;
}
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008af:	f3 0f 1e fb          	endbr32 
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008c6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	84 d2                	test   %dl,%dl
  8008ce:	75 f2                	jne    8008c2 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008d0:	89 c8                	mov    %ecx,%eax
  8008d2:	5b                   	pop    %ebx
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	83 ec 10             	sub    $0x10,%esp
  8008e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e3:	53                   	push   %ebx
  8008e4:	e8 83 ff ff ff       	call   80086c <strlen>
  8008e9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	01 d8                	add    %ebx,%eax
  8008f1:	50                   	push   %eax
  8008f2:	e8 b8 ff ff ff       	call   8008af <strcpy>
	return dst;
}
  8008f7:	89 d8                	mov    %ebx,%eax
  8008f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fe:	f3 0f 1e fb          	endbr32 
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	56                   	push   %esi
  800906:	53                   	push   %ebx
  800907:	8b 75 08             	mov    0x8(%ebp),%esi
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 f3                	mov    %esi,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800912:	89 f0                	mov    %esi,%eax
  800914:	39 d8                	cmp    %ebx,%eax
  800916:	74 11                	je     800929 <strncpy+0x2b>
		*dst++ = *src;
  800918:	83 c0 01             	add    $0x1,%eax
  80091b:	0f b6 0a             	movzbl (%edx),%ecx
  80091e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800921:	80 f9 01             	cmp    $0x1,%cl
  800924:	83 da ff             	sbb    $0xffffffff,%edx
  800927:	eb eb                	jmp    800914 <strncpy+0x16>
	}
	return ret;
}
  800929:	89 f0                	mov    %esi,%eax
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	f3 0f 1e fb          	endbr32 
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	56                   	push   %esi
  800937:	53                   	push   %ebx
  800938:	8b 75 08             	mov    0x8(%ebp),%esi
  80093b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093e:	8b 55 10             	mov    0x10(%ebp),%edx
  800941:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800943:	85 d2                	test   %edx,%edx
  800945:	74 21                	je     800968 <strlcpy+0x39>
  800947:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80094b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80094d:	39 c2                	cmp    %eax,%edx
  80094f:	74 14                	je     800965 <strlcpy+0x36>
  800951:	0f b6 19             	movzbl (%ecx),%ebx
  800954:	84 db                	test   %bl,%bl
  800956:	74 0b                	je     800963 <strlcpy+0x34>
			*dst++ = *src++;
  800958:	83 c1 01             	add    $0x1,%ecx
  80095b:	83 c2 01             	add    $0x1,%edx
  80095e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800961:	eb ea                	jmp    80094d <strlcpy+0x1e>
  800963:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800965:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800968:	29 f0                	sub    %esi,%eax
}
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096e:	f3 0f 1e fb          	endbr32 
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097b:	0f b6 01             	movzbl (%ecx),%eax
  80097e:	84 c0                	test   %al,%al
  800980:	74 0c                	je     80098e <strcmp+0x20>
  800982:	3a 02                	cmp    (%edx),%al
  800984:	75 08                	jne    80098e <strcmp+0x20>
		p++, q++;
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	eb ed                	jmp    80097b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098e:	0f b6 c0             	movzbl %al,%eax
  800991:	0f b6 12             	movzbl (%edx),%edx
  800994:	29 d0                	sub    %edx,%eax
}
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800998:	f3 0f 1e fb          	endbr32 
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ab:	eb 06                	jmp    8009b3 <strncmp+0x1b>
		n--, p++, q++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b3:	39 d8                	cmp    %ebx,%eax
  8009b5:	74 16                	je     8009cd <strncmp+0x35>
  8009b7:	0f b6 08             	movzbl (%eax),%ecx
  8009ba:	84 c9                	test   %cl,%cl
  8009bc:	74 04                	je     8009c2 <strncmp+0x2a>
  8009be:	3a 0a                	cmp    (%edx),%cl
  8009c0:	74 eb                	je     8009ad <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 00             	movzbl (%eax),%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	eb f6                	jmp    8009ca <strncmp+0x32>

008009d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d4:	f3 0f 1e fb          	endbr32 
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e2:	0f b6 10             	movzbl (%eax),%edx
  8009e5:	84 d2                	test   %dl,%dl
  8009e7:	74 09                	je     8009f2 <strchr+0x1e>
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	74 0a                	je     8009f7 <strchr+0x23>
	for (; *s; s++)
  8009ed:	83 c0 01             	add    $0x1,%eax
  8009f0:	eb f0                	jmp    8009e2 <strchr+0xe>
			return (char *) s;
	return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f9:	f3 0f 1e fb          	endbr32 
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a07:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0a:	38 ca                	cmp    %cl,%dl
  800a0c:	74 09                	je     800a17 <strfind+0x1e>
  800a0e:	84 d2                	test   %dl,%dl
  800a10:	74 05                	je     800a17 <strfind+0x1e>
	for (; *s; s++)
  800a12:	83 c0 01             	add    $0x1,%eax
  800a15:	eb f0                	jmp    800a07 <strfind+0xe>
			break;
	return (char *) s;
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a19:	f3 0f 1e fb          	endbr32 
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	57                   	push   %edi
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 55 08             	mov    0x8(%ebp),%edx
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	74 33                	je     800a60 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	09 c8                	or     %ecx,%eax
  800a31:	a8 03                	test   $0x3,%al
  800a33:	75 23                	jne    800a58 <memset+0x3f>
		c &= 0xFF;
  800a35:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a39:	89 d8                	mov    %ebx,%eax
  800a3b:	c1 e0 08             	shl    $0x8,%eax
  800a3e:	89 df                	mov    %ebx,%edi
  800a40:	c1 e7 18             	shl    $0x18,%edi
  800a43:	89 de                	mov    %ebx,%esi
  800a45:	c1 e6 10             	shl    $0x10,%esi
  800a48:	09 f7                	or     %esi,%edi
  800a4a:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a4c:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800a51:	89 d7                	mov    %edx,%edi
  800a53:	fc                   	cld    
  800a54:	f3 ab                	rep stos %eax,%es:(%edi)
  800a56:	eb 08                	jmp    800a60 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a58:	89 d7                	mov    %edx,%edi
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	fc                   	cld    
  800a5e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5f                   	pop    %edi
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a79:	39 c6                	cmp    %eax,%esi
  800a7b:	73 32                	jae    800aaf <memmove+0x48>
  800a7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a80:	39 c2                	cmp    %eax,%edx
  800a82:	76 2b                	jbe    800aaf <memmove+0x48>
		s += n;
		d += n;
  800a84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a87:	89 fe                	mov    %edi,%esi
  800a89:	09 ce                	or     %ecx,%esi
  800a8b:	09 d6                	or     %edx,%esi
  800a8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a93:	75 0e                	jne    800aa3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a95:	83 ef 04             	sub    $0x4,%edi
  800a98:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a9e:	fd                   	std    
  800a9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa1:	eb 09                	jmp    800aac <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa3:	83 ef 01             	sub    $0x1,%edi
  800aa6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa9:	fd                   	std    
  800aaa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aac:	fc                   	cld    
  800aad:	eb 1a                	jmp    800ac9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	89 c2                	mov    %eax,%edx
  800ab1:	09 ca                	or     %ecx,%edx
  800ab3:	09 f2                	or     %esi,%edx
  800ab5:	f6 c2 03             	test   $0x3,%dl
  800ab8:	75 0a                	jne    800ac4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800abd:	89 c7                	mov    %eax,%edi
  800abf:	fc                   	cld    
  800ac0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac2:	eb 05                	jmp    800ac9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	fc                   	cld    
  800ac7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac9:	5e                   	pop    %esi
  800aca:	5f                   	pop    %edi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acd:	f3 0f 1e fb          	endbr32 
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad7:	ff 75 10             	pushl  0x10(%ebp)
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 82 ff ff ff       	call   800a67 <memmove>
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae7:	f3 0f 1e fb          	endbr32 
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	56                   	push   %esi
  800aef:	53                   	push   %ebx
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	89 c6                	mov    %eax,%esi
  800af8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afb:	39 f0                	cmp    %esi,%eax
  800afd:	74 1c                	je     800b1b <memcmp+0x34>
		if (*s1 != *s2)
  800aff:	0f b6 08             	movzbl (%eax),%ecx
  800b02:	0f b6 1a             	movzbl (%edx),%ebx
  800b05:	38 d9                	cmp    %bl,%cl
  800b07:	75 08                	jne    800b11 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b09:	83 c0 01             	add    $0x1,%eax
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	eb ea                	jmp    800afb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b11:	0f b6 c1             	movzbl %cl,%eax
  800b14:	0f b6 db             	movzbl %bl,%ebx
  800b17:	29 d8                	sub    %ebx,%eax
  800b19:	eb 05                	jmp    800b20 <memcmp+0x39>
	}

	return 0;
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b24:	f3 0f 1e fb          	endbr32 
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b36:	39 d0                	cmp    %edx,%eax
  800b38:	73 09                	jae    800b43 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3a:	38 08                	cmp    %cl,(%eax)
  800b3c:	74 05                	je     800b43 <memfind+0x1f>
	for (; s < ends; s++)
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	eb f3                	jmp    800b36 <memfind+0x12>
			break;
	return (void *) s;
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b45:	f3 0f 1e fb          	endbr32 
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b55:	eb 03                	jmp    800b5a <strtol+0x15>
		s++;
  800b57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b5a:	0f b6 01             	movzbl (%ecx),%eax
  800b5d:	3c 20                	cmp    $0x20,%al
  800b5f:	74 f6                	je     800b57 <strtol+0x12>
  800b61:	3c 09                	cmp    $0x9,%al
  800b63:	74 f2                	je     800b57 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b65:	3c 2b                	cmp    $0x2b,%al
  800b67:	74 2a                	je     800b93 <strtol+0x4e>
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6e:	3c 2d                	cmp    $0x2d,%al
  800b70:	74 2b                	je     800b9d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b78:	75 0f                	jne    800b89 <strtol+0x44>
  800b7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7d:	74 28                	je     800ba7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b86:	0f 44 d8             	cmove  %eax,%ebx
  800b89:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b91:	eb 46                	jmp    800bd9 <strtol+0x94>
		s++;
  800b93:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b96:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9b:	eb d5                	jmp    800b72 <strtol+0x2d>
		s++, neg = 1;
  800b9d:	83 c1 01             	add    $0x1,%ecx
  800ba0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba5:	eb cb                	jmp    800b72 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bab:	74 0e                	je     800bbb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	75 d8                	jne    800b89 <strtol+0x44>
		s++, base = 8;
  800bb1:	83 c1 01             	add    $0x1,%ecx
  800bb4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb9:	eb ce                	jmp    800b89 <strtol+0x44>
		s += 2, base = 16;
  800bbb:	83 c1 02             	add    $0x2,%ecx
  800bbe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc3:	eb c4                	jmp    800b89 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bc5:	0f be d2             	movsbl %dl,%edx
  800bc8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bcb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bce:	7d 3a                	jge    800c0a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bd0:	83 c1 01             	add    $0x1,%ecx
  800bd3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd9:	0f b6 11             	movzbl (%ecx),%edx
  800bdc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 09             	cmp    $0x9,%bl
  800be4:	76 df                	jbe    800bc5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800be6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be9:	89 f3                	mov    %esi,%ebx
  800beb:	80 fb 19             	cmp    $0x19,%bl
  800bee:	77 08                	ja     800bf8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf0:	0f be d2             	movsbl %dl,%edx
  800bf3:	83 ea 57             	sub    $0x57,%edx
  800bf6:	eb d3                	jmp    800bcb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bf8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bfb:	89 f3                	mov    %esi,%ebx
  800bfd:	80 fb 19             	cmp    $0x19,%bl
  800c00:	77 08                	ja     800c0a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c02:	0f be d2             	movsbl %dl,%edx
  800c05:	83 ea 37             	sub    $0x37,%edx
  800c08:	eb c1                	jmp    800bcb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0e:	74 05                	je     800c15 <strtol+0xd0>
		*endptr = (char *) s;
  800c10:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c13:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c15:	89 c2                	mov    %eax,%edx
  800c17:	f7 da                	neg    %edx
  800c19:	85 ff                	test   %edi,%edi
  800c1b:	0f 45 c2             	cmovne %edx,%eax
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 1c             	sub    $0x1c,%esp
  800c2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c2f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c32:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c3a:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c3d:	8b 75 14             	mov    0x14(%ebp),%esi
  800c40:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c46:	74 04                	je     800c4c <syscall+0x29>
  800c48:	85 c0                	test   %eax,%eax
  800c4a:	7f 08                	jg     800c54 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c54:	83 ec 0c             	sub    $0xc,%esp
  800c57:	50                   	push   %eax
  800c58:	ff 75 e0             	pushl  -0x20(%ebp)
  800c5b:	68 3f 29 80 00       	push   $0x80293f
  800c60:	6a 23                	push   $0x23
  800c62:	68 5c 29 80 00       	push   $0x80295c
  800c67:	e8 f2 f5 ff ff       	call   80025e <_panic>

00800c6c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	f3 0f 1e fb          	endbr32 
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c76:	6a 00                	push   $0x0
  800c78:	6a 00                	push   $0x0
  800c7a:	6a 00                	push   $0x0
  800c7c:	ff 75 0c             	pushl  0xc(%ebp)
  800c7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c82:	ba 00 00 00 00       	mov    $0x0,%edx
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	e8 92 ff ff ff       	call   800c23 <syscall>
}
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c96:	f3 0f 1e fb          	endbr32 
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ca0:	6a 00                	push   $0x0
  800ca2:	6a 00                	push   $0x0
  800ca4:	6a 00                	push   $0x0
  800ca6:	6a 00                	push   $0x0
  800ca8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb7:	e8 67 ff ff ff       	call   800c23 <syscall>
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbe:	f3 0f 1e fb          	endbr32 
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800cc8:	6a 00                	push   $0x0
  800cca:	6a 00                	push   $0x0
  800ccc:	6a 00                	push   $0x0
  800cce:	6a 00                	push   $0x0
  800cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd3:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd8:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdd:	e8 41 ff ff ff       	call   800c23 <syscall>
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce4:	f3 0f 1e fb          	endbr32 
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800cee:	6a 00                	push   $0x0
  800cf0:	6a 00                	push   $0x0
  800cf2:	6a 00                	push   $0x0
  800cf4:	6a 00                	push   $0x0
  800cf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	e8 19 ff ff ff       	call   800c23 <syscall>
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <sys_yield>:

void
sys_yield(void)
{
  800d0c:	f3 0f 1e fb          	endbr32 
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800d16:	6a 00                	push   $0x0
  800d18:	6a 00                	push   $0x0
  800d1a:	6a 00                	push   $0x0
  800d1c:	6a 00                	push   $0x0
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	ba 00 00 00 00       	mov    $0x0,%edx
  800d28:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2d:	e8 f1 fe ff ff       	call   800c23 <syscall>
}
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d37:	f3 0f 1e fb          	endbr32 
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800d41:	6a 00                	push   $0x0
  800d43:	6a 00                	push   $0x0
  800d45:	ff 75 10             	pushl  0x10(%ebp)
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d53:	b8 04 00 00 00       	mov    $0x4,%eax
  800d58:	e8 c6 fe ff ff       	call   800c23 <syscall>
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d5f:	f3 0f 1e fb          	endbr32 
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d69:	ff 75 18             	pushl  0x18(%ebp)
  800d6c:	ff 75 14             	pushl  0x14(%ebp)
  800d6f:	ff 75 10             	pushl  0x10(%ebp)
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d78:	ba 01 00 00 00       	mov    $0x1,%edx
  800d7d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d82:	e8 9c fe ff ff       	call   800c23 <syscall>
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d89:	f3 0f 1e fb          	endbr32 
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d93:	6a 00                	push   $0x0
  800d95:	6a 00                	push   $0x0
  800d97:	6a 00                	push   $0x0
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9f:	ba 01 00 00 00       	mov    $0x1,%edx
  800da4:	b8 06 00 00 00       	mov    $0x6,%eax
  800da9:	e8 75 fe ff ff       	call   800c23 <syscall>
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800dba:	6a 00                	push   $0x0
  800dbc:	6a 00                	push   $0x0
  800dbe:	6a 00                	push   $0x0
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc6:	ba 01 00 00 00       	mov    $0x1,%edx
  800dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd0:	e8 4e fe ff ff       	call   800c23 <syscall>
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd7:	f3 0f 1e fb          	endbr32 
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800de1:	6a 00                	push   $0x0
  800de3:	6a 00                	push   $0x0
  800de5:	6a 00                	push   $0x0
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	ba 01 00 00 00       	mov    $0x1,%edx
  800df2:	b8 09 00 00 00       	mov    $0x9,%eax
  800df7:	e8 27 fe ff ff       	call   800c23 <syscall>
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dfe:	f3 0f 1e fb          	endbr32 
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800e08:	6a 00                	push   $0x0
  800e0a:	6a 00                	push   $0x0
  800e0c:	6a 00                	push   $0x0
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e14:	ba 01 00 00 00       	mov    $0x1,%edx
  800e19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1e:	e8 00 fe ff ff       	call   800c23 <syscall>
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e25:	f3 0f 1e fb          	endbr32 
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e2f:	6a 00                	push   $0x0
  800e31:	ff 75 14             	pushl  0x14(%ebp)
  800e34:	ff 75 10             	pushl  0x10(%ebp)
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e47:	e8 d7 fd ff ff       	call   800c23 <syscall>
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800e58:	6a 00                	push   $0x0
  800e5a:	6a 00                	push   $0x0
  800e5c:	6a 00                	push   $0x0
  800e5e:	6a 00                	push   $0x0
  800e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e63:	ba 01 00 00 00       	mov    $0x1,%edx
  800e68:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6d:	e8 b1 fd ff ff       	call   800c23 <syscall>
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	53                   	push   %ebx
  800e78:	83 ec 04             	sub    $0x4,%esp
  800e7b:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800e7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800e84:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800e87:	f6 c6 04             	test   $0x4,%dh
  800e8a:	75 51                	jne    800edd <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800e8c:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800e92:	0f 84 84 00 00 00    	je     800f1c <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	68 05 08 00 00       	push   $0x805
  800ea0:	53                   	push   %ebx
  800ea1:	50                   	push   %eax
  800ea2:	53                   	push   %ebx
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 b5 fe ff ff       	call   800d5f <sys_page_map>
		if (r)
  800eaa:	83 c4 20             	add    $0x20,%esp
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 59                	jne    800f0a <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	68 05 08 00 00       	push   $0x805
  800eb9:	53                   	push   %ebx
  800eba:	6a 00                	push   $0x0
  800ebc:	53                   	push   %ebx
  800ebd:	6a 00                	push   $0x0
  800ebf:	e8 9b fe ff ff       	call   800d5f <sys_page_map>
		if (r)
  800ec4:	83 c4 20             	add    $0x20,%esp
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	74 67                	je     800f32 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800ecb:	50                   	push   %eax
  800ecc:	68 6a 29 80 00       	push   $0x80296a
  800ed1:	6a 5f                	push   $0x5f
  800ed3:	68 85 29 80 00       	push   $0x802985
  800ed8:	e8 81 f3 ff ff       	call   80025e <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800ee6:	52                   	push   %edx
  800ee7:	53                   	push   %ebx
  800ee8:	50                   	push   %eax
  800ee9:	53                   	push   %ebx
  800eea:	6a 00                	push   $0x0
  800eec:	e8 6e fe ff ff       	call   800d5f <sys_page_map>
		if (r)
  800ef1:	83 c4 20             	add    $0x20,%esp
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	74 3a                	je     800f32 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800ef8:	50                   	push   %eax
  800ef9:	68 6a 29 80 00       	push   $0x80296a
  800efe:	6a 57                	push   $0x57
  800f00:	68 85 29 80 00       	push   $0x802985
  800f05:	e8 54 f3 ff ff       	call   80025e <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800f0a:	50                   	push   %eax
  800f0b:	68 6a 29 80 00       	push   $0x80296a
  800f10:	6a 5b                	push   $0x5b
  800f12:	68 85 29 80 00       	push   $0x802985
  800f17:	e8 42 f3 ff ff       	call   80025e <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	6a 05                	push   $0x5
  800f21:	53                   	push   %ebx
  800f22:	50                   	push   %eax
  800f23:	53                   	push   %ebx
  800f24:	6a 00                	push   $0x0
  800f26:	e8 34 fe ff ff       	call   800d5f <sys_page_map>
		if (r)
  800f2b:	83 c4 20             	add    $0x20,%esp
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	75 0a                	jne    800f3c <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
  800f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800f3c:	50                   	push   %eax
  800f3d:	68 6a 29 80 00       	push   $0x80296a
  800f42:	6a 63                	push   $0x63
  800f44:	68 85 29 80 00       	push   $0x802985
  800f49:	e8 10 f3 ff ff       	call   80025e <_panic>

00800f4e <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	89 c7                	mov    %eax,%edi
  800f59:	89 d6                	mov    %edx,%esi
  800f5b:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800f5d:	f6 c1 02             	test   $0x2,%cl
  800f60:	75 2f                	jne    800f91 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	51                   	push   %ecx
  800f66:	52                   	push   %edx
  800f67:	50                   	push   %eax
  800f68:	52                   	push   %edx
  800f69:	6a 00                	push   $0x0
  800f6b:	e8 ef fd ff ff       	call   800d5f <sys_page_map>
  800f70:	83 c4 20             	add    $0x20,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	78 08                	js     800f7f <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800f7f:	50                   	push   %eax
  800f80:	68 74 29 80 00       	push   $0x802974
  800f85:	6a 6f                	push   $0x6f
  800f87:	68 85 29 80 00       	push   $0x802985
  800f8c:	e8 cd f2 ff ff       	call   80025e <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	51                   	push   %ecx
  800f95:	52                   	push   %edx
  800f96:	50                   	push   %eax
  800f97:	e8 9b fd ff ff       	call   800d37 <sys_page_alloc>
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	78 54                	js     800ff7 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	53                   	push   %ebx
  800fa7:	68 00 00 40 00       	push   $0x400000
  800fac:	6a 00                	push   $0x0
  800fae:	56                   	push   %esi
  800faf:	57                   	push   %edi
  800fb0:	e8 aa fd ff ff       	call   800d5f <sys_page_map>
  800fb5:	83 c4 20             	add    $0x20,%esp
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	78 4d                	js     801009 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 00 10 00 00       	push   $0x1000
  800fc4:	56                   	push   %esi
  800fc5:	68 00 00 40 00       	push   $0x400000
  800fca:	e8 98 fa ff ff       	call   800a67 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800fcf:	83 c4 08             	add    $0x8,%esp
  800fd2:	68 00 00 40 00       	push   $0x400000
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 ab fd ff ff       	call   800d89 <sys_page_unmap>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	79 92                	jns    800f77 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800fe5:	50                   	push   %eax
  800fe6:	68 a3 29 80 00       	push   $0x8029a3
  800feb:	6a 78                	push   $0x78
  800fed:	68 85 29 80 00       	push   $0x802985
  800ff2:	e8 67 f2 ff ff       	call   80025e <_panic>
		panic("sys_page_alloc: %e", r);
  800ff7:	50                   	push   %eax
  800ff8:	68 90 29 80 00       	push   $0x802990
  800ffd:	6a 73                	push   $0x73
  800fff:	68 85 29 80 00       	push   $0x802985
  801004:	e8 55 f2 ff ff       	call   80025e <_panic>
		panic("sys_page_map: %e", r);
  801009:	50                   	push   %eax
  80100a:	68 74 29 80 00       	push   $0x802974
  80100f:	6a 75                	push   $0x75
  801011:	68 85 29 80 00       	push   $0x802985
  801016:	e8 43 f2 ff ff       	call   80025e <_panic>

0080101b <pgfault>:
{
  80101b:	f3 0f 1e fb          	endbr32 
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	53                   	push   %ebx
  801023:	83 ec 04             	sub    $0x4,%esp
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801029:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80102b:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  80102e:	89 da                	mov    %ebx,%edx
  801030:	c1 ea 0c             	shr    $0xc,%edx
  801033:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  80103a:	a8 01                	test   $0x1,%al
  80103c:	74 7e                	je     8010bc <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  80103e:	a8 02                	test   $0x2,%al
  801040:	0f 84 8a 00 00 00    	je     8010d0 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  801046:	f6 c6 08             	test   $0x8,%dh
  801049:	0f 84 95 00 00 00    	je     8010e4 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	6a 07                	push   $0x7
  801054:	68 00 f0 7f 00       	push   $0x7ff000
  801059:	6a 00                	push   $0x0
  80105b:	e8 d7 fc ff ff       	call   800d37 <sys_page_alloc>
	if (r)
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	0f 85 8d 00 00 00    	jne    8010f8 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80106b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	68 00 10 00 00       	push   $0x1000
  801079:	53                   	push   %ebx
  80107a:	68 00 f0 7f 00       	push   $0x7ff000
  80107f:	e8 49 fa ff ff       	call   800acd <memcpy>
	r = sys_page_map(
  801084:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80108b:	53                   	push   %ebx
  80108c:	6a 00                	push   $0x0
  80108e:	68 00 f0 7f 00       	push   $0x7ff000
  801093:	6a 00                	push   $0x0
  801095:	e8 c5 fc ff ff       	call   800d5f <sys_page_map>
	if (r)
  80109a:	83 c4 20             	add    $0x20,%esp
  80109d:	85 c0                	test   %eax,%eax
  80109f:	75 69                	jne    80110a <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  8010a1:	83 ec 08             	sub    $0x8,%esp
  8010a4:	68 00 f0 7f 00       	push   $0x7ff000
  8010a9:	6a 00                	push   $0x0
  8010ab:	e8 d9 fc ff ff       	call   800d89 <sys_page_unmap>
	if (r)
  8010b0:	83 c4 10             	add    $0x10,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	75 65                	jne    80111c <pgfault+0x101>
}
  8010b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	68 24 2a 80 00       	push   $0x802a24
  8010c4:	6a 20                	push   $0x20
  8010c6:	68 85 29 80 00       	push   $0x802985
  8010cb:	e8 8e f1 ff ff       	call   80025e <_panic>
		panic("[pgfault] pgfault por lectura");
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	68 b6 29 80 00       	push   $0x8029b6
  8010d8:	6a 23                	push   $0x23
  8010da:	68 85 29 80 00       	push   $0x802985
  8010df:	e8 7a f1 ff ff       	call   80025e <_panic>
		panic("[pgfault] pgfault COW no configurado");
  8010e4:	83 ec 04             	sub    $0x4,%esp
  8010e7:	68 50 2a 80 00       	push   $0x802a50
  8010ec:	6a 27                	push   $0x27
  8010ee:	68 85 29 80 00       	push   $0x802985
  8010f3:	e8 66 f1 ff ff       	call   80025e <_panic>
		panic("pgfault: %e", r);
  8010f8:	50                   	push   %eax
  8010f9:	68 d4 29 80 00       	push   $0x8029d4
  8010fe:	6a 32                	push   $0x32
  801100:	68 85 29 80 00       	push   $0x802985
  801105:	e8 54 f1 ff ff       	call   80025e <_panic>
		panic("pgfault: %e", r);
  80110a:	50                   	push   %eax
  80110b:	68 d4 29 80 00       	push   $0x8029d4
  801110:	6a 39                	push   $0x39
  801112:	68 85 29 80 00       	push   $0x802985
  801117:	e8 42 f1 ff ff       	call   80025e <_panic>
		panic("pgfault: %e", r);
  80111c:	50                   	push   %eax
  80111d:	68 d4 29 80 00       	push   $0x8029d4
  801122:	6a 3d                	push   $0x3d
  801124:	68 85 29 80 00       	push   $0x802985
  801129:	e8 30 f1 ff ff       	call   80025e <_panic>

0080112e <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  80112e:	f3 0f 1e fb          	endbr32 
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80113b:	b8 07 00 00 00       	mov    $0x7,%eax
  801140:	cd 30                	int    $0x30
  801142:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801144:	85 c0                	test   %eax,%eax
  801146:	78 22                	js     80116a <fork_v0+0x3c>
  801148:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80114a:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80114f:	75 52                	jne    8011a3 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801151:	e8 8e fb ff ff       	call   800ce4 <sys_getenvid>
  801156:	25 ff 03 00 00       	and    $0x3ff,%eax
  80115b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80115e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801163:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801168:	eb 6e                	jmp    8011d8 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80116a:	50                   	push   %eax
  80116b:	68 78 2a 80 00       	push   $0x802a78
  801170:	68 8a 00 00 00       	push   $0x8a
  801175:	68 85 29 80 00       	push   $0x802985
  80117a:	e8 df f0 ff ff       	call   80025e <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  80117f:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801186:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80118c:	89 da                	mov    %ebx,%edx
  80118e:	89 f0                	mov    %esi,%eax
  801190:	e8 b9 fd ff ff       	call   800f4e <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801195:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80119b:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011a1:	74 23                	je     8011c6 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8011a3:	89 d8                	mov    %ebx,%eax
  8011a5:	c1 e8 16             	shr    $0x16,%eax
  8011a8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011af:	a8 01                	test   $0x1,%al
  8011b1:	74 e2                	je     801195 <fork_v0+0x67>
  8011b3:	89 d8                	mov    %ebx,%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
  8011b8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011bf:	f6 c2 01             	test   $0x1,%dl
  8011c2:	74 d1                	je     801195 <fork_v0+0x67>
  8011c4:	eb b9                	jmp    80117f <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	6a 02                	push   $0x2
  8011cb:	57                   	push   %edi
  8011cc:	e8 df fb ff ff       	call   800db0 <sys_env_set_status>
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 0a                	js     8011e2 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8011d8:	89 f8                	mov    %edi,%eax
  8011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dd:	5b                   	pop    %ebx
  8011de:	5e                   	pop    %esi
  8011df:	5f                   	pop    %edi
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8011e2:	50                   	push   %eax
  8011e3:	68 9c 2a 80 00       	push   $0x802a9c
  8011e8:	68 98 00 00 00       	push   $0x98
  8011ed:	68 85 29 80 00       	push   $0x802985
  8011f2:	e8 67 f0 ff ff       	call   80025e <_panic>

008011f7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
  801201:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  801204:	68 1b 10 80 00       	push   $0x80101b
  801209:	e8 ff 0f 00 00       	call   80220d <set_pgfault_handler>
  80120e:	b8 07 00 00 00       	mov    $0x7,%eax
  801213:	cd 30                	int    $0x30
  801215:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	78 37                	js     801255 <fork+0x5e>
  80121e:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801220:	74 48                	je     80126a <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	6a 07                	push   $0x7
  801227:	68 00 f0 bf ee       	push   $0xeebff000
  80122c:	50                   	push   %eax
  80122d:	e8 05 fb ff ff       	call   800d37 <sys_page_alloc>
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 4d                	js     801286 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	68 8a 22 80 00       	push   $0x80228a
  801241:	56                   	push   %esi
  801242:	e8 b7 fb ff ff       	call   800dfe <sys_env_set_pgfault_upcall>
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	85 c0                	test   %eax,%eax
  80124c:	78 4d                	js     80129b <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80124e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801253:	eb 70                	jmp    8012c5 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801255:	50                   	push   %eax
  801256:	68 e0 29 80 00       	push   $0x8029e0
  80125b:	68 b7 00 00 00       	push   $0xb7
  801260:	68 85 29 80 00       	push   $0x802985
  801265:	e8 f4 ef ff ff       	call   80025e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80126a:	e8 75 fa ff ff       	call   800ce4 <sys_getenvid>
  80126f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801274:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801277:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80127c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801281:	e9 80 00 00 00       	jmp    801306 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801286:	50                   	push   %eax
  801287:	68 f0 29 80 00       	push   $0x8029f0
  80128c:	68 c0 00 00 00       	push   $0xc0
  801291:	68 85 29 80 00       	push   $0x802985
  801296:	e8 c3 ef ff ff       	call   80025e <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80129b:	50                   	push   %eax
  80129c:	68 c0 2a 80 00       	push   $0x802ac0
  8012a1:	68 c3 00 00 00       	push   $0xc3
  8012a6:	68 85 29 80 00       	push   $0x802985
  8012ab:	e8 ae ef ff ff       	call   80025e <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  8012b0:	89 f8                	mov    %edi,%eax
  8012b2:	e8 bd fb ff ff       	call   800e74 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8012b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012bd:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8012c3:	74 2f                	je     8012f4 <fork+0xfd>
  8012c5:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  8012c7:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  8012cd:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8012d2:	76 e3                	jbe    8012b7 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8012d4:	89 d8                	mov    %ebx,%eax
  8012d6:	c1 e8 16             	shr    $0x16,%eax
  8012d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012e0:	a8 01                	test   $0x1,%al
  8012e2:	74 d3                	je     8012b7 <fork+0xc0>
  8012e4:	c1 ea 0c             	shr    $0xc,%edx
  8012e7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012ee:	a8 01                	test   $0x1,%al
  8012f0:	74 c5                	je     8012b7 <fork+0xc0>
  8012f2:	eb bc                	jmp    8012b0 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	6a 02                	push   $0x2
  8012f9:	56                   	push   %esi
  8012fa:	e8 b1 fa ff ff       	call   800db0 <sys_env_set_status>
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 0a                	js     801310 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  801306:	89 f0                	mov    %esi,%eax
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801310:	50                   	push   %eax
  801311:	68 ec 2a 80 00       	push   $0x802aec
  801316:	68 ce 00 00 00       	push   $0xce
  80131b:	68 85 29 80 00       	push   $0x802985
  801320:	e8 39 ef ff ff       	call   80025e <_panic>

00801325 <sfork>:

// Challenge!
int
sfork(void)
{
  801325:	f3 0f 1e fb          	endbr32 
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80132f:	68 0e 2a 80 00       	push   $0x802a0e
  801334:	68 d7 00 00 00       	push   $0xd7
  801339:	68 85 29 80 00       	push   $0x802985
  80133e:	e8 1b ef ff ff       	call   80025e <_panic>

00801343 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801343:	f3 0f 1e fb          	endbr32 
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	56                   	push   %esi
  80134b:	53                   	push   %ebx
  80134c:	8b 75 08             	mov    0x8(%ebp),%esi
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801355:	85 c0                	test   %eax,%eax
  801357:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80135c:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  80135f:	83 ec 0c             	sub    $0xc,%esp
  801362:	50                   	push   %eax
  801363:	e8 e6 fa ff ff       	call   800e4e <sys_ipc_recv>
	if (r < 0) {
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 2b                	js     80139a <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  80136f:	85 f6                	test   %esi,%esi
  801371:	74 0a                	je     80137d <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801373:	a1 04 40 80 00       	mov    0x804004,%eax
  801378:	8b 40 74             	mov    0x74(%eax),%eax
  80137b:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  80137d:	85 db                	test   %ebx,%ebx
  80137f:	74 0a                	je     80138b <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801381:	a1 04 40 80 00       	mov    0x804004,%eax
  801386:	8b 40 78             	mov    0x78(%eax),%eax
  801389:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80138b:	a1 04 40 80 00       	mov    0x804004,%eax
  801390:	8b 40 70             	mov    0x70(%eax),%eax
}
  801393:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    
		if (from_env_store) {
  80139a:	85 f6                	test   %esi,%esi
  80139c:	74 06                	je     8013a4 <ipc_recv+0x61>
			*from_env_store = 0;
  80139e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8013a4:	85 db                	test   %ebx,%ebx
  8013a6:	74 eb                	je     801393 <ipc_recv+0x50>
			*perm_store = 0;
  8013a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013ae:	eb e3                	jmp    801393 <ipc_recv+0x50>

008013b0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	57                   	push   %edi
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
  8013ba:	83 ec 0c             	sub    $0xc,%esp
  8013bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8013c6:	85 db                	test   %ebx,%ebx
  8013c8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8013cd:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8013d0:	ff 75 14             	pushl  0x14(%ebp)
  8013d3:	53                   	push   %ebx
  8013d4:	56                   	push   %esi
  8013d5:	57                   	push   %edi
  8013d6:	e8 4a fa ff ff       	call   800e25 <sys_ipc_try_send>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013e1:	75 07                	jne    8013ea <ipc_send+0x3a>
		sys_yield();
  8013e3:	e8 24 f9 ff ff       	call   800d0c <sys_yield>
  8013e8:	eb e6                	jmp    8013d0 <ipc_send+0x20>
	}

	if (ret < 0) {
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 08                	js     8013f6 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8013ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5f                   	pop    %edi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  8013f6:	50                   	push   %eax
  8013f7:	68 0e 2b 80 00       	push   $0x802b0e
  8013fc:	6a 48                	push   $0x48
  8013fe:	68 2b 2b 80 00       	push   $0x802b2b
  801403:	e8 56 ee ff ff       	call   80025e <_panic>

00801408 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801408:	f3 0f 1e fb          	endbr32 
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801417:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80141a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801420:	8b 52 50             	mov    0x50(%edx),%edx
  801423:	39 ca                	cmp    %ecx,%edx
  801425:	74 11                	je     801438 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801427:	83 c0 01             	add    $0x1,%eax
  80142a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80142f:	75 e6                	jne    801417 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 0b                	jmp    801443 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801438:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80143b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801440:	8b 40 48             	mov    0x48(%eax),%eax
}
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801445:	f3 0f 1e fb          	endbr32 
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	05 00 00 00 30       	add    $0x30000000,%eax
  801454:	c1 e8 0c             	shr    $0xc,%eax
}
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801459:	f3 0f 1e fb          	endbr32 
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801463:	ff 75 08             	pushl  0x8(%ebp)
  801466:	e8 da ff ff ff       	call   801445 <fd2num>
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	c1 e0 0c             	shl    $0xc,%eax
  801471:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801478:	f3 0f 1e fb          	endbr32 
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801484:	89 c2                	mov    %eax,%edx
  801486:	c1 ea 16             	shr    $0x16,%edx
  801489:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801490:	f6 c2 01             	test   $0x1,%dl
  801493:	74 2d                	je     8014c2 <fd_alloc+0x4a>
  801495:	89 c2                	mov    %eax,%edx
  801497:	c1 ea 0c             	shr    $0xc,%edx
  80149a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a1:	f6 c2 01             	test   $0x1,%dl
  8014a4:	74 1c                	je     8014c2 <fd_alloc+0x4a>
  8014a6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014ab:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b0:	75 d2                	jne    801484 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014bb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014c0:	eb 0a                	jmp    8014cc <fd_alloc+0x54>
			*fd_store = fd;
  8014c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cc:	5d                   	pop    %ebp
  8014cd:	c3                   	ret    

008014ce <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014ce:	f3 0f 1e fb          	endbr32 
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014d8:	83 f8 1f             	cmp    $0x1f,%eax
  8014db:	77 30                	ja     80150d <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014dd:	c1 e0 0c             	shl    $0xc,%eax
  8014e0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014eb:	f6 c2 01             	test   $0x1,%dl
  8014ee:	74 24                	je     801514 <fd_lookup+0x46>
  8014f0:	89 c2                	mov    %eax,%edx
  8014f2:	c1 ea 0c             	shr    $0xc,%edx
  8014f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014fc:	f6 c2 01             	test   $0x1,%dl
  8014ff:	74 1a                	je     80151b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801501:	8b 55 0c             	mov    0xc(%ebp),%edx
  801504:	89 02                	mov    %eax,(%edx)
	return 0;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150b:	5d                   	pop    %ebp
  80150c:	c3                   	ret    
		return -E_INVAL;
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801512:	eb f7                	jmp    80150b <fd_lookup+0x3d>
		return -E_INVAL;
  801514:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801519:	eb f0                	jmp    80150b <fd_lookup+0x3d>
  80151b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801520:	eb e9                	jmp    80150b <fd_lookup+0x3d>

00801522 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801522:	f3 0f 1e fb          	endbr32 
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152f:	ba b4 2b 80 00       	mov    $0x802bb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801534:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801539:	39 08                	cmp    %ecx,(%eax)
  80153b:	74 33                	je     801570 <dev_lookup+0x4e>
  80153d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801540:	8b 02                	mov    (%edx),%eax
  801542:	85 c0                	test   %eax,%eax
  801544:	75 f3                	jne    801539 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801546:	a1 04 40 80 00       	mov    0x804004,%eax
  80154b:	8b 40 48             	mov    0x48(%eax),%eax
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	51                   	push   %ecx
  801552:	50                   	push   %eax
  801553:	68 38 2b 80 00       	push   $0x802b38
  801558:	e8 e8 ed ff ff       	call   800345 <cprintf>
	*dev = 0;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    
			*dev = devtab[i];
  801570:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801573:	89 01                	mov    %eax,(%ecx)
			return 0;
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
  80157a:	eb f2                	jmp    80156e <dev_lookup+0x4c>

0080157c <fd_close>:
{
  80157c:	f3 0f 1e fb          	endbr32 
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	57                   	push   %edi
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 28             	sub    $0x28,%esp
  801589:	8b 75 08             	mov    0x8(%ebp),%esi
  80158c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80158f:	56                   	push   %esi
  801590:	e8 b0 fe ff ff       	call   801445 <fd2num>
  801595:	83 c4 08             	add    $0x8,%esp
  801598:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80159b:	52                   	push   %edx
  80159c:	50                   	push   %eax
  80159d:	e8 2c ff ff ff       	call   8014ce <fd_lookup>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 05                	js     8015b0 <fd_close+0x34>
	    || fd != fd2)
  8015ab:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015ae:	74 16                	je     8015c6 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8015b0:	89 f8                	mov    %edi,%eax
  8015b2:	84 c0                	test   %al,%al
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b9:	0f 44 d8             	cmove  %eax,%ebx
}
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 36                	pushl  (%esi)
  8015cf:	e8 4e ff ff ff       	call   801522 <dev_lookup>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 1a                	js     8015f7 <fd_close+0x7b>
		if (dev->dev_close)
  8015dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015e3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 0b                	je     8015f7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	56                   	push   %esi
  8015f0:	ff d0                	call   *%eax
  8015f2:	89 c3                	mov    %eax,%ebx
  8015f4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	56                   	push   %esi
  8015fb:	6a 00                	push   $0x0
  8015fd:	e8 87 f7 ff ff       	call   800d89 <sys_page_unmap>
	return r;
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	eb b5                	jmp    8015bc <fd_close+0x40>

00801607 <close>:

int
close(int fdnum)
{
  801607:	f3 0f 1e fb          	endbr32 
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801611:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801614:	50                   	push   %eax
  801615:	ff 75 08             	pushl  0x8(%ebp)
  801618:	e8 b1 fe ff ff       	call   8014ce <fd_lookup>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	85 c0                	test   %eax,%eax
  801622:	79 02                	jns    801626 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    
		return fd_close(fd, 1);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	6a 01                	push   $0x1
  80162b:	ff 75 f4             	pushl  -0xc(%ebp)
  80162e:	e8 49 ff ff ff       	call   80157c <fd_close>
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	eb ec                	jmp    801624 <close+0x1d>

00801638 <close_all>:

void
close_all(void)
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801643:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801648:	83 ec 0c             	sub    $0xc,%esp
  80164b:	53                   	push   %ebx
  80164c:	e8 b6 ff ff ff       	call   801607 <close>
	for (i = 0; i < MAXFD; i++)
  801651:	83 c3 01             	add    $0x1,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	83 fb 20             	cmp    $0x20,%ebx
  80165a:	75 ec                	jne    801648 <close_all+0x10>
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801661:	f3 0f 1e fb          	endbr32 
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	57                   	push   %edi
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80166e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	e8 54 fe ff ff       	call   8014ce <fd_lookup>
  80167a:	89 c3                	mov    %eax,%ebx
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	85 c0                	test   %eax,%eax
  801681:	0f 88 81 00 00 00    	js     801708 <dup+0xa7>
		return r;
	close(newfdnum);
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	e8 75 ff ff ff       	call   801607 <close>

	newfd = INDEX2FD(newfdnum);
  801692:	8b 75 0c             	mov    0xc(%ebp),%esi
  801695:	c1 e6 0c             	shl    $0xc,%esi
  801698:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016a4:	e8 b0 fd ff ff       	call   801459 <fd2data>
  8016a9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016ab:	89 34 24             	mov    %esi,(%esp)
  8016ae:	e8 a6 fd ff ff       	call   801459 <fd2data>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016b8:	89 d8                	mov    %ebx,%eax
  8016ba:	c1 e8 16             	shr    $0x16,%eax
  8016bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c4:	a8 01                	test   $0x1,%al
  8016c6:	74 11                	je     8016d9 <dup+0x78>
  8016c8:	89 d8                	mov    %ebx,%eax
  8016ca:	c1 e8 0c             	shr    $0xc,%eax
  8016cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016d4:	f6 c2 01             	test   $0x1,%dl
  8016d7:	75 39                	jne    801712 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016dc:	89 d0                	mov    %edx,%eax
  8016de:	c1 e8 0c             	shr    $0xc,%eax
  8016e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e8:	83 ec 0c             	sub    $0xc,%esp
  8016eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f0:	50                   	push   %eax
  8016f1:	56                   	push   %esi
  8016f2:	6a 00                	push   $0x0
  8016f4:	52                   	push   %edx
  8016f5:	6a 00                	push   $0x0
  8016f7:	e8 63 f6 ff ff       	call   800d5f <sys_page_map>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 20             	add    $0x20,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 31                	js     801736 <dup+0xd5>
		goto err;

	return newfdnum;
  801705:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5f                   	pop    %edi
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801712:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	25 07 0e 00 00       	and    $0xe07,%eax
  801721:	50                   	push   %eax
  801722:	57                   	push   %edi
  801723:	6a 00                	push   $0x0
  801725:	53                   	push   %ebx
  801726:	6a 00                	push   $0x0
  801728:	e8 32 f6 ff ff       	call   800d5f <sys_page_map>
  80172d:	89 c3                	mov    %eax,%ebx
  80172f:	83 c4 20             	add    $0x20,%esp
  801732:	85 c0                	test   %eax,%eax
  801734:	79 a3                	jns    8016d9 <dup+0x78>
	sys_page_unmap(0, newfd);
  801736:	83 ec 08             	sub    $0x8,%esp
  801739:	56                   	push   %esi
  80173a:	6a 00                	push   $0x0
  80173c:	e8 48 f6 ff ff       	call   800d89 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801741:	83 c4 08             	add    $0x8,%esp
  801744:	57                   	push   %edi
  801745:	6a 00                	push   $0x0
  801747:	e8 3d f6 ff ff       	call   800d89 <sys_page_unmap>
	return r;
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	eb b7                	jmp    801708 <dup+0xa7>

00801751 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801751:	f3 0f 1e fb          	endbr32 
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	53                   	push   %ebx
  801759:	83 ec 1c             	sub    $0x1c,%esp
  80175c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801762:	50                   	push   %eax
  801763:	53                   	push   %ebx
  801764:	e8 65 fd ff ff       	call   8014ce <fd_lookup>
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 3f                	js     8017af <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	ff 30                	pushl  (%eax)
  80177c:	e8 a1 fd ff ff       	call   801522 <dev_lookup>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	85 c0                	test   %eax,%eax
  801786:	78 27                	js     8017af <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801788:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178b:	8b 42 08             	mov    0x8(%edx),%eax
  80178e:	83 e0 03             	and    $0x3,%eax
  801791:	83 f8 01             	cmp    $0x1,%eax
  801794:	74 1e                	je     8017b4 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 35                	je     8017d5 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	ff 75 10             	pushl  0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	52                   	push   %edx
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
}
  8017af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8017b9:	8b 40 48             	mov    0x48(%eax),%eax
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	53                   	push   %ebx
  8017c0:	50                   	push   %eax
  8017c1:	68 79 2b 80 00       	push   $0x802b79
  8017c6:	e8 7a eb ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d3:	eb da                	jmp    8017af <read+0x5e>
		return -E_NOT_SUPP;
  8017d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017da:	eb d3                	jmp    8017af <read+0x5e>

008017dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	57                   	push   %edi
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017ec:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f4:	eb 02                	jmp    8017f8 <readn+0x1c>
  8017f6:	01 c3                	add    %eax,%ebx
  8017f8:	39 f3                	cmp    %esi,%ebx
  8017fa:	73 21                	jae    80181d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	89 f0                	mov    %esi,%eax
  801801:	29 d8                	sub    %ebx,%eax
  801803:	50                   	push   %eax
  801804:	89 d8                	mov    %ebx,%eax
  801806:	03 45 0c             	add    0xc(%ebp),%eax
  801809:	50                   	push   %eax
  80180a:	57                   	push   %edi
  80180b:	e8 41 ff ff ff       	call   801751 <read>
		if (m < 0)
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	85 c0                	test   %eax,%eax
  801815:	78 04                	js     80181b <readn+0x3f>
			return m;
		if (m == 0)
  801817:	75 dd                	jne    8017f6 <readn+0x1a>
  801819:	eb 02                	jmp    80181d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80181b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5f                   	pop    %edi
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    

00801827 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801827:	f3 0f 1e fb          	endbr32 
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	53                   	push   %ebx
  80182f:	83 ec 1c             	sub    $0x1c,%esp
  801832:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801835:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	53                   	push   %ebx
  80183a:	e8 8f fc ff ff       	call   8014ce <fd_lookup>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 3a                	js     801880 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801850:	ff 30                	pushl  (%eax)
  801852:	e8 cb fc ff ff       	call   801522 <dev_lookup>
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 22                	js     801880 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801861:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801865:	74 1e                	je     801885 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186a:	8b 52 0c             	mov    0xc(%edx),%edx
  80186d:	85 d2                	test   %edx,%edx
  80186f:	74 35                	je     8018a6 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	ff 75 10             	pushl  0x10(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	50                   	push   %eax
  80187b:	ff d2                	call   *%edx
  80187d:	83 c4 10             	add    $0x10,%esp
}
  801880:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801883:	c9                   	leave  
  801884:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801885:	a1 04 40 80 00       	mov    0x804004,%eax
  80188a:	8b 40 48             	mov    0x48(%eax),%eax
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	53                   	push   %ebx
  801891:	50                   	push   %eax
  801892:	68 95 2b 80 00       	push   $0x802b95
  801897:	e8 a9 ea ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a4:	eb da                	jmp    801880 <write+0x59>
		return -E_NOT_SUPP;
  8018a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ab:	eb d3                	jmp    801880 <write+0x59>

008018ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8018ad:	f3 0f 1e fb          	endbr32 
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ba:	50                   	push   %eax
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	e8 0b fc ff ff       	call   8014ce <fd_lookup>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 0e                	js     8018d8 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018da:	f3 0f 1e fb          	endbr32 
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 1c             	sub    $0x1c,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	53                   	push   %ebx
  8018ed:	e8 dc fb ff ff       	call   8014ce <fd_lookup>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 37                	js     801930 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	ff 30                	pushl  (%eax)
  801905:	e8 18 fc ff ff       	call   801522 <dev_lookup>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 1f                	js     801930 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801914:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801918:	74 1b                	je     801935 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80191a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191d:	8b 52 18             	mov    0x18(%edx),%edx
  801920:	85 d2                	test   %edx,%edx
  801922:	74 32                	je     801956 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	50                   	push   %eax
  80192b:	ff d2                	call   *%edx
  80192d:	83 c4 10             	add    $0x10,%esp
}
  801930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801933:	c9                   	leave  
  801934:	c3                   	ret    
			thisenv->env_id, fdnum);
  801935:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80193a:	8b 40 48             	mov    0x48(%eax),%eax
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	53                   	push   %ebx
  801941:	50                   	push   %eax
  801942:	68 58 2b 80 00       	push   $0x802b58
  801947:	e8 f9 e9 ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801954:	eb da                	jmp    801930 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801956:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80195b:	eb d3                	jmp    801930 <ftruncate+0x56>

0080195d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80195d:	f3 0f 1e fb          	endbr32 
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	53                   	push   %ebx
  801965:	83 ec 1c             	sub    $0x1c,%esp
  801968:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80196b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80196e:	50                   	push   %eax
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	e8 57 fb ff ff       	call   8014ce <fd_lookup>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 4b                	js     8019c9 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80197e:	83 ec 08             	sub    $0x8,%esp
  801981:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801988:	ff 30                	pushl  (%eax)
  80198a:	e8 93 fb ff ff       	call   801522 <dev_lookup>
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 33                	js     8019c9 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801999:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80199d:	74 2f                	je     8019ce <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80199f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019a9:	00 00 00 
	stat->st_isdir = 0;
  8019ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019b3:	00 00 00 
	stat->st_dev = dev;
  8019b6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019bc:	83 ec 08             	sub    $0x8,%esp
  8019bf:	53                   	push   %ebx
  8019c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c3:	ff 50 14             	call   *0x14(%eax)
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d3:	eb f4                	jmp    8019c9 <fstat+0x6c>

008019d5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019d5:	f3 0f 1e fb          	endbr32 
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	56                   	push   %esi
  8019dd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	6a 00                	push   $0x0
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	e8 3a 02 00 00       	call   801c25 <open>
  8019eb:	89 c3                	mov    %eax,%ebx
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 1b                	js     801a0f <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019f4:	83 ec 08             	sub    $0x8,%esp
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	50                   	push   %eax
  8019fb:	e8 5d ff ff ff       	call   80195d <fstat>
  801a00:	89 c6                	mov    %eax,%esi
	close(fd);
  801a02:	89 1c 24             	mov    %ebx,(%esp)
  801a05:	e8 fd fb ff ff       	call   801607 <close>
	return r;
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	89 f3                	mov    %esi,%ebx
}
  801a0f:	89 d8                	mov    %ebx,%eax
  801a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    

00801a18 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	56                   	push   %esi
  801a1c:	53                   	push   %ebx
  801a1d:	89 c6                	mov    %eax,%esi
  801a1f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a21:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a28:	74 27                	je     801a51 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a2a:	6a 07                	push   $0x7
  801a2c:	68 00 50 80 00       	push   $0x805000
  801a31:	56                   	push   %esi
  801a32:	ff 35 00 40 80 00    	pushl  0x804000
  801a38:	e8 73 f9 ff ff       	call   8013b0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a3d:	83 c4 0c             	add    $0xc,%esp
  801a40:	6a 00                	push   $0x0
  801a42:	53                   	push   %ebx
  801a43:	6a 00                	push   $0x0
  801a45:	e8 f9 f8 ff ff       	call   801343 <ipc_recv>
}
  801a4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a51:	83 ec 0c             	sub    $0xc,%esp
  801a54:	6a 01                	push   $0x1
  801a56:	e8 ad f9 ff ff       	call   801408 <ipc_find_env>
  801a5b:	a3 00 40 80 00       	mov    %eax,0x804000
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	eb c5                	jmp    801a2a <fsipc+0x12>

00801a65 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a65:	f3 0f 1e fb          	endbr32 
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8c:	e8 87 ff ff ff       	call   801a18 <fsipc>
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <devfile_flush>:
{
  801a93:	f3 0f 1e fb          	endbr32 
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aad:	b8 06 00 00 00       	mov    $0x6,%eax
  801ab2:	e8 61 ff ff ff       	call   801a18 <fsipc>
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <devfile_stat>:
{
  801ab9:	f3 0f 1e fb          	endbr32 
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	53                   	push   %ebx
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8b 40 0c             	mov    0xc(%eax),%eax
  801acd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad7:	b8 05 00 00 00       	mov    $0x5,%eax
  801adc:	e8 37 ff ff ff       	call   801a18 <fsipc>
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 2c                	js     801b11 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ae5:	83 ec 08             	sub    $0x8,%esp
  801ae8:	68 00 50 80 00       	push   $0x805000
  801aed:	53                   	push   %ebx
  801aee:	e8 bc ed ff ff       	call   8008af <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801af3:	a1 80 50 80 00       	mov    0x805080,%eax
  801af8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801afe:	a1 84 50 80 00       	mov    0x805084,%eax
  801b03:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <devfile_write>:
{
  801b16:	f3 0f 1e fb          	endbr32 
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801b2f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801b35:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b3b:	77 30                	ja     801b6d <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	53                   	push   %ebx
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	68 08 50 80 00       	push   $0x805008
  801b49:	e8 19 ef ff ff       	call   800a67 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 04 00 00 00       	mov    $0x4,%eax
  801b58:	e8 bb fe ff ff       	call   801a18 <fsipc>
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 04                	js     801b68 <devfile_write+0x52>
	assert(r <= n);
  801b64:	39 d8                	cmp    %ebx,%eax
  801b66:	77 1e                	ja     801b86 <devfile_write+0x70>
}
  801b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801b6d:	68 c4 2b 80 00       	push   $0x802bc4
  801b72:	68 f1 2b 80 00       	push   $0x802bf1
  801b77:	68 94 00 00 00       	push   $0x94
  801b7c:	68 06 2c 80 00       	push   $0x802c06
  801b81:	e8 d8 e6 ff ff       	call   80025e <_panic>
	assert(r <= n);
  801b86:	68 11 2c 80 00       	push   $0x802c11
  801b8b:	68 f1 2b 80 00       	push   $0x802bf1
  801b90:	68 98 00 00 00       	push   $0x98
  801b95:	68 06 2c 80 00       	push   $0x802c06
  801b9a:	e8 bf e6 ff ff       	call   80025e <_panic>

00801b9f <devfile_read>:
{
  801b9f:	f3 0f 1e fb          	endbr32 
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801bb6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc6:	e8 4d fe ff ff       	call   801a18 <fsipc>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 1f                	js     801bf0 <devfile_read+0x51>
	assert(r <= n);
  801bd1:	39 f0                	cmp    %esi,%eax
  801bd3:	77 24                	ja     801bf9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801bd5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bda:	7f 33                	jg     801c0f <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	50                   	push   %eax
  801be0:	68 00 50 80 00       	push   $0x805000
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	e8 7a ee ff ff       	call   800a67 <memmove>
	return r;
  801bed:	83 c4 10             	add    $0x10,%esp
}
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    
	assert(r <= n);
  801bf9:	68 11 2c 80 00       	push   $0x802c11
  801bfe:	68 f1 2b 80 00       	push   $0x802bf1
  801c03:	6a 7c                	push   $0x7c
  801c05:	68 06 2c 80 00       	push   $0x802c06
  801c0a:	e8 4f e6 ff ff       	call   80025e <_panic>
	assert(r <= PGSIZE);
  801c0f:	68 18 2c 80 00       	push   $0x802c18
  801c14:	68 f1 2b 80 00       	push   $0x802bf1
  801c19:	6a 7d                	push   $0x7d
  801c1b:	68 06 2c 80 00       	push   $0x802c06
  801c20:	e8 39 e6 ff ff       	call   80025e <_panic>

00801c25 <open>:
{
  801c25:	f3 0f 1e fb          	endbr32 
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	56                   	push   %esi
  801c2d:	53                   	push   %ebx
  801c2e:	83 ec 1c             	sub    $0x1c,%esp
  801c31:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c34:	56                   	push   %esi
  801c35:	e8 32 ec ff ff       	call   80086c <strlen>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c42:	7f 6c                	jg     801cb0 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4a:	50                   	push   %eax
  801c4b:	e8 28 f8 ff ff       	call   801478 <fd_alloc>
  801c50:	89 c3                	mov    %eax,%ebx
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 3c                	js     801c95 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	56                   	push   %esi
  801c5d:	68 00 50 80 00       	push   $0x805000
  801c62:	e8 48 ec ff ff       	call   8008af <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c72:	b8 01 00 00 00       	mov    $0x1,%eax
  801c77:	e8 9c fd ff ff       	call   801a18 <fsipc>
  801c7c:	89 c3                	mov    %eax,%ebx
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 19                	js     801c9e <open+0x79>
	return fd2num(fd);
  801c85:	83 ec 0c             	sub    $0xc,%esp
  801c88:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8b:	e8 b5 f7 ff ff       	call   801445 <fd2num>
  801c90:	89 c3                	mov    %eax,%ebx
  801c92:	83 c4 10             	add    $0x10,%esp
}
  801c95:	89 d8                	mov    %ebx,%eax
  801c97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    
		fd_close(fd, 0);
  801c9e:	83 ec 08             	sub    $0x8,%esp
  801ca1:	6a 00                	push   $0x0
  801ca3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca6:	e8 d1 f8 ff ff       	call   80157c <fd_close>
		return r;
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	eb e5                	jmp    801c95 <open+0x70>
		return -E_BAD_PATH;
  801cb0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cb5:	eb de                	jmp    801c95 <open+0x70>

00801cb7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cb7:	f3 0f 1e fb          	endbr32 
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc6:	b8 08 00 00 00       	mov    $0x8,%eax
  801ccb:	e8 48 fd ff ff       	call   801a18 <fsipc>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cd2:	f3 0f 1e fb          	endbr32 
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cdc:	89 c2                	mov    %eax,%edx
  801cde:	c1 ea 16             	shr    $0x16,%edx
  801ce1:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801ce8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801ced:	f6 c1 01             	test   $0x1,%cl
  801cf0:	74 1c                	je     801d0e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801cf2:	c1 e8 0c             	shr    $0xc,%eax
  801cf5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cfc:	a8 01                	test   $0x1,%al
  801cfe:	74 0e                	je     801d0e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d00:	c1 e8 0c             	shr    $0xc,%eax
  801d03:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d0a:	ef 
  801d0b:	0f b7 d2             	movzwl %dx,%edx
}
  801d0e:	89 d0                	mov    %edx,%eax
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d12:	f3 0f 1e fb          	endbr32 
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	56                   	push   %esi
  801d1a:	53                   	push   %ebx
  801d1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	ff 75 08             	pushl  0x8(%ebp)
  801d24:	e8 30 f7 ff ff       	call   801459 <fd2data>
  801d29:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d2b:	83 c4 08             	add    $0x8,%esp
  801d2e:	68 24 2c 80 00       	push   $0x802c24
  801d33:	53                   	push   %ebx
  801d34:	e8 76 eb ff ff       	call   8008af <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d39:	8b 46 04             	mov    0x4(%esi),%eax
  801d3c:	2b 06                	sub    (%esi),%eax
  801d3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d44:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d4b:	00 00 00 
	stat->st_dev = &devpipe;
  801d4e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d55:	30 80 00 
	return 0;
}
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d64:	f3 0f 1e fb          	endbr32 
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d72:	53                   	push   %ebx
  801d73:	6a 00                	push   $0x0
  801d75:	e8 0f f0 ff ff       	call   800d89 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d7a:	89 1c 24             	mov    %ebx,(%esp)
  801d7d:	e8 d7 f6 ff ff       	call   801459 <fd2data>
  801d82:	83 c4 08             	add    $0x8,%esp
  801d85:	50                   	push   %eax
  801d86:	6a 00                	push   $0x0
  801d88:	e8 fc ef ff ff       	call   800d89 <sys_page_unmap>
}
  801d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <_pipeisclosed>:
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	57                   	push   %edi
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
  801d98:	83 ec 1c             	sub    $0x1c,%esp
  801d9b:	89 c7                	mov    %eax,%edi
  801d9d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d9f:	a1 04 40 80 00       	mov    0x804004,%eax
  801da4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	57                   	push   %edi
  801dab:	e8 22 ff ff ff       	call   801cd2 <pageref>
  801db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801db3:	89 34 24             	mov    %esi,(%esp)
  801db6:	e8 17 ff ff ff       	call   801cd2 <pageref>
		nn = thisenv->env_runs;
  801dbb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801dc1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	39 cb                	cmp    %ecx,%ebx
  801dc9:	74 1b                	je     801de6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dcb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dce:	75 cf                	jne    801d9f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dd0:	8b 42 58             	mov    0x58(%edx),%eax
  801dd3:	6a 01                	push   $0x1
  801dd5:	50                   	push   %eax
  801dd6:	53                   	push   %ebx
  801dd7:	68 2b 2c 80 00       	push   $0x802c2b
  801ddc:	e8 64 e5 ff ff       	call   800345 <cprintf>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	eb b9                	jmp    801d9f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801de6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de9:	0f 94 c0             	sete   %al
  801dec:	0f b6 c0             	movzbl %al,%eax
}
  801def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5f                   	pop    %edi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    

00801df7 <devpipe_write>:
{
  801df7:	f3 0f 1e fb          	endbr32 
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	57                   	push   %edi
  801dff:	56                   	push   %esi
  801e00:	53                   	push   %ebx
  801e01:	83 ec 28             	sub    $0x28,%esp
  801e04:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e07:	56                   	push   %esi
  801e08:	e8 4c f6 ff ff       	call   801459 <fd2data>
  801e0d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	bf 00 00 00 00       	mov    $0x0,%edi
  801e17:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e1a:	74 4f                	je     801e6b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e1c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e1f:	8b 0b                	mov    (%ebx),%ecx
  801e21:	8d 51 20             	lea    0x20(%ecx),%edx
  801e24:	39 d0                	cmp    %edx,%eax
  801e26:	72 14                	jb     801e3c <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801e28:	89 da                	mov    %ebx,%edx
  801e2a:	89 f0                	mov    %esi,%eax
  801e2c:	e8 61 ff ff ff       	call   801d92 <_pipeisclosed>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 3b                	jne    801e70 <devpipe_write+0x79>
			sys_yield();
  801e35:	e8 d2 ee ff ff       	call   800d0c <sys_yield>
  801e3a:	eb e0                	jmp    801e1c <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e3f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e43:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e46:	89 c2                	mov    %eax,%edx
  801e48:	c1 fa 1f             	sar    $0x1f,%edx
  801e4b:	89 d1                	mov    %edx,%ecx
  801e4d:	c1 e9 1b             	shr    $0x1b,%ecx
  801e50:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e53:	83 e2 1f             	and    $0x1f,%edx
  801e56:	29 ca                	sub    %ecx,%edx
  801e58:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e5c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e60:	83 c0 01             	add    $0x1,%eax
  801e63:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e66:	83 c7 01             	add    $0x1,%edi
  801e69:	eb ac                	jmp    801e17 <devpipe_write+0x20>
	return i;
  801e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6e:	eb 05                	jmp    801e75 <devpipe_write+0x7e>
				return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    

00801e7d <devpipe_read>:
{
  801e7d:	f3 0f 1e fb          	endbr32 
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	57                   	push   %edi
  801e85:	56                   	push   %esi
  801e86:	53                   	push   %ebx
  801e87:	83 ec 18             	sub    $0x18,%esp
  801e8a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e8d:	57                   	push   %edi
  801e8e:	e8 c6 f5 ff ff       	call   801459 <fd2data>
  801e93:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	be 00 00 00 00       	mov    $0x0,%esi
  801e9d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea0:	75 14                	jne    801eb6 <devpipe_read+0x39>
	return i;
  801ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea5:	eb 02                	jmp    801ea9 <devpipe_read+0x2c>
				return i;
  801ea7:	89 f0                	mov    %esi,%eax
}
  801ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    
			sys_yield();
  801eb1:	e8 56 ee ff ff       	call   800d0c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eb6:	8b 03                	mov    (%ebx),%eax
  801eb8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ebb:	75 18                	jne    801ed5 <devpipe_read+0x58>
			if (i > 0)
  801ebd:	85 f6                	test   %esi,%esi
  801ebf:	75 e6                	jne    801ea7 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801ec1:	89 da                	mov    %ebx,%edx
  801ec3:	89 f8                	mov    %edi,%eax
  801ec5:	e8 c8 fe ff ff       	call   801d92 <_pipeisclosed>
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	74 e3                	je     801eb1 <devpipe_read+0x34>
				return 0;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	eb d4                	jmp    801ea9 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ed5:	99                   	cltd   
  801ed6:	c1 ea 1b             	shr    $0x1b,%edx
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	83 e0 1f             	and    $0x1f,%eax
  801ede:	29 d0                	sub    %edx,%eax
  801ee0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eeb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eee:	83 c6 01             	add    $0x1,%esi
  801ef1:	eb aa                	jmp    801e9d <devpipe_read+0x20>

00801ef3 <pipe>:
{
  801ef3:	f3 0f 1e fb          	endbr32 
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f02:	50                   	push   %eax
  801f03:	e8 70 f5 ff ff       	call   801478 <fd_alloc>
  801f08:	89 c3                	mov    %eax,%ebx
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	0f 88 23 01 00 00    	js     802038 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	68 07 04 00 00       	push   $0x407
  801f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f20:	6a 00                	push   $0x0
  801f22:	e8 10 ee ff ff       	call   800d37 <sys_page_alloc>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 04 01 00 00    	js     802038 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	e8 38 f5 ff ff       	call   801478 <fd_alloc>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	0f 88 db 00 00 00    	js     802028 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	68 07 04 00 00       	push   $0x407
  801f55:	ff 75 f0             	pushl  -0x10(%ebp)
  801f58:	6a 00                	push   $0x0
  801f5a:	e8 d8 ed ff ff       	call   800d37 <sys_page_alloc>
  801f5f:	89 c3                	mov    %eax,%ebx
  801f61:	83 c4 10             	add    $0x10,%esp
  801f64:	85 c0                	test   %eax,%eax
  801f66:	0f 88 bc 00 00 00    	js     802028 <pipe+0x135>
	va = fd2data(fd0);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f72:	e8 e2 f4 ff ff       	call   801459 <fd2data>
  801f77:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f79:	83 c4 0c             	add    $0xc,%esp
  801f7c:	68 07 04 00 00       	push   $0x407
  801f81:	50                   	push   %eax
  801f82:	6a 00                	push   $0x0
  801f84:	e8 ae ed ff ff       	call   800d37 <sys_page_alloc>
  801f89:	89 c3                	mov    %eax,%ebx
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	0f 88 82 00 00 00    	js     802018 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9c:	e8 b8 f4 ff ff       	call   801459 <fd2data>
  801fa1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fa8:	50                   	push   %eax
  801fa9:	6a 00                	push   $0x0
  801fab:	56                   	push   %esi
  801fac:	6a 00                	push   $0x0
  801fae:	e8 ac ed ff ff       	call   800d5f <sys_page_map>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	83 c4 20             	add    $0x20,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 4e                	js     80200a <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801fbc:	a1 20 30 80 00       	mov    0x803020,%eax
  801fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe5:	e8 5b f4 ff ff       	call   801445 <fd2num>
  801fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fed:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fef:	83 c4 04             	add    $0x4,%esp
  801ff2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff5:	e8 4b f4 ff ff       	call   801445 <fd2num>
  801ffa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ffd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	bb 00 00 00 00       	mov    $0x0,%ebx
  802008:	eb 2e                	jmp    802038 <pipe+0x145>
	sys_page_unmap(0, va);
  80200a:	83 ec 08             	sub    $0x8,%esp
  80200d:	56                   	push   %esi
  80200e:	6a 00                	push   $0x0
  802010:	e8 74 ed ff ff       	call   800d89 <sys_page_unmap>
  802015:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	ff 75 f0             	pushl  -0x10(%ebp)
  80201e:	6a 00                	push   $0x0
  802020:	e8 64 ed ff ff       	call   800d89 <sys_page_unmap>
  802025:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	ff 75 f4             	pushl  -0xc(%ebp)
  80202e:	6a 00                	push   $0x0
  802030:	e8 54 ed ff ff       	call   800d89 <sys_page_unmap>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	89 d8                	mov    %ebx,%eax
  80203a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <pipeisclosed>:
{
  802041:	f3 0f 1e fb          	endbr32 
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204e:	50                   	push   %eax
  80204f:	ff 75 08             	pushl  0x8(%ebp)
  802052:	e8 77 f4 ff ff       	call   8014ce <fd_lookup>
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 18                	js     802076 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	ff 75 f4             	pushl  -0xc(%ebp)
  802064:	e8 f0 f3 ff ff       	call   801459 <fd2data>
  802069:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	e8 1f fd ff ff       	call   801d92 <_pipeisclosed>
  802073:	83 c4 10             	add    $0x10,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802078:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
  802081:	c3                   	ret    

00802082 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802082:	f3 0f 1e fb          	endbr32 
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80208c:	68 43 2c 80 00       	push   $0x802c43
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	e8 16 e8 ff ff       	call   8008af <strcpy>
	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <devcons_write>:
{
  8020a0:	f3 0f 1e fb          	endbr32 
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	57                   	push   %edi
  8020a8:	56                   	push   %esi
  8020a9:	53                   	push   %ebx
  8020aa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020b0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020b5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020be:	73 31                	jae    8020f1 <devcons_write+0x51>
		m = n - tot;
  8020c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020c3:	29 f3                	sub    %esi,%ebx
  8020c5:	83 fb 7f             	cmp    $0x7f,%ebx
  8020c8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020cd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	53                   	push   %ebx
  8020d4:	89 f0                	mov    %esi,%eax
  8020d6:	03 45 0c             	add    0xc(%ebp),%eax
  8020d9:	50                   	push   %eax
  8020da:	57                   	push   %edi
  8020db:	e8 87 e9 ff ff       	call   800a67 <memmove>
		sys_cputs(buf, m);
  8020e0:	83 c4 08             	add    $0x8,%esp
  8020e3:	53                   	push   %ebx
  8020e4:	57                   	push   %edi
  8020e5:	e8 82 eb ff ff       	call   800c6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ea:	01 de                	add    %ebx,%esi
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	eb ca                	jmp    8020bb <devcons_write+0x1b>
}
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f6:	5b                   	pop    %ebx
  8020f7:	5e                   	pop    %esi
  8020f8:	5f                   	pop    %edi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <devcons_read>:
{
  8020fb:	f3 0f 1e fb          	endbr32 
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80210a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210e:	74 21                	je     802131 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802110:	e8 81 eb ff ff       	call   800c96 <sys_cgetc>
  802115:	85 c0                	test   %eax,%eax
  802117:	75 07                	jne    802120 <devcons_read+0x25>
		sys_yield();
  802119:	e8 ee eb ff ff       	call   800d0c <sys_yield>
  80211e:	eb f0                	jmp    802110 <devcons_read+0x15>
	if (c < 0)
  802120:	78 0f                	js     802131 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802122:	83 f8 04             	cmp    $0x4,%eax
  802125:	74 0c                	je     802133 <devcons_read+0x38>
	*(char*)vbuf = c;
  802127:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212a:	88 02                	mov    %al,(%edx)
	return 1;
  80212c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    
		return 0;
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	eb f7                	jmp    802131 <devcons_read+0x36>

0080213a <cputchar>:
{
  80213a:	f3 0f 1e fb          	endbr32 
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80214a:	6a 01                	push   $0x1
  80214c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80214f:	50                   	push   %eax
  802150:	e8 17 eb ff ff       	call   800c6c <sys_cputs>
}
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <getchar>:
{
  80215a:	f3 0f 1e fb          	endbr32 
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802164:	6a 01                	push   $0x1
  802166:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802169:	50                   	push   %eax
  80216a:	6a 00                	push   $0x0
  80216c:	e8 e0 f5 ff ff       	call   801751 <read>
	if (r < 0)
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	78 06                	js     80217e <getchar+0x24>
	if (r < 1)
  802178:	74 06                	je     802180 <getchar+0x26>
	return c;
  80217a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    
		return -E_EOF;
  802180:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802185:	eb f7                	jmp    80217e <getchar+0x24>

00802187 <iscons>:
{
  802187:	f3 0f 1e fb          	endbr32 
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802191:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802194:	50                   	push   %eax
  802195:	ff 75 08             	pushl  0x8(%ebp)
  802198:	e8 31 f3 ff ff       	call   8014ce <fd_lookup>
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	78 11                	js     8021b5 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ad:	39 10                	cmp    %edx,(%eax)
  8021af:	0f 94 c0             	sete   %al
  8021b2:	0f b6 c0             	movzbl %al,%eax
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <opencons>:
{
  8021b7:	f3 0f 1e fb          	endbr32 
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c4:	50                   	push   %eax
  8021c5:	e8 ae f2 ff ff       	call   801478 <fd_alloc>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 3a                	js     80220b <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 07 04 00 00       	push   $0x407
  8021d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021dc:	6a 00                	push   $0x0
  8021de:	e8 54 eb ff ff       	call   800d37 <sys_page_alloc>
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 21                	js     80220b <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021f3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	50                   	push   %eax
  802203:	e8 3d f2 ff ff       	call   801445 <fd2num>
  802208:	83 c4 10             	add    $0x10,%esp
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80220d:	f3 0f 1e fb          	endbr32 
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802217:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80221e:	74 0a                	je     80222a <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  80222a:	a1 04 40 80 00       	mov    0x804004,%eax
  80222f:	8b 40 48             	mov    0x48(%eax),%eax
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	6a 07                	push   $0x7
  802237:	68 00 f0 bf ee       	push   $0xeebff000
  80223c:	50                   	push   %eax
  80223d:	e8 f5 ea ff ff       	call   800d37 <sys_page_alloc>
		if (r!= 0)
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	85 c0                	test   %eax,%eax
  802247:	75 2f                	jne    802278 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802249:	a1 04 40 80 00       	mov    0x804004,%eax
  80224e:	8b 40 48             	mov    0x48(%eax),%eax
  802251:	83 ec 08             	sub    $0x8,%esp
  802254:	68 8a 22 80 00       	push   $0x80228a
  802259:	50                   	push   %eax
  80225a:	e8 9f eb ff ff       	call   800dfe <sys_env_set_pgfault_upcall>
		if (r!= 0)
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	74 ba                	je     802220 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802266:	50                   	push   %eax
  802267:	68 4f 2c 80 00       	push   $0x802c4f
  80226c:	6a 26                	push   $0x26
  80226e:	68 67 2c 80 00       	push   $0x802c67
  802273:	e8 e6 df ff ff       	call   80025e <_panic>
			panic("set_pgfault_handler: %e", r);
  802278:	50                   	push   %eax
  802279:	68 4f 2c 80 00       	push   $0x802c4f
  80227e:	6a 22                	push   $0x22
  802280:	68 67 2c 80 00       	push   $0x802c67
  802285:	e8 d4 df ff ff       	call   80025e <_panic>

0080228a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80228a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80228b:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802290:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802292:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802295:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  802299:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80229c:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  8022a0:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  8022a4:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8022a6:	83 c4 08             	add    $0x8,%esp
	popal
  8022a9:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8022aa:	83 c4 04             	add    $0x4,%esp
	popfl
  8022ad:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8022ae:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022af:	c3                   	ret    

008022b0 <__udivdi3>:
  8022b0:	f3 0f 1e fb          	endbr32 
  8022b4:	55                   	push   %ebp
  8022b5:	57                   	push   %edi
  8022b6:	56                   	push   %esi
  8022b7:	53                   	push   %ebx
  8022b8:	83 ec 1c             	sub    $0x1c,%esp
  8022bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022cb:	85 d2                	test   %edx,%edx
  8022cd:	75 19                	jne    8022e8 <__udivdi3+0x38>
  8022cf:	39 f3                	cmp    %esi,%ebx
  8022d1:	76 4d                	jbe    802320 <__udivdi3+0x70>
  8022d3:	31 ff                	xor    %edi,%edi
  8022d5:	89 e8                	mov    %ebp,%eax
  8022d7:	89 f2                	mov    %esi,%edx
  8022d9:	f7 f3                	div    %ebx
  8022db:	89 fa                	mov    %edi,%edx
  8022dd:	83 c4 1c             	add    $0x1c,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
  8022e5:	8d 76 00             	lea    0x0(%esi),%esi
  8022e8:	39 f2                	cmp    %esi,%edx
  8022ea:	76 14                	jbe    802300 <__udivdi3+0x50>
  8022ec:	31 ff                	xor    %edi,%edi
  8022ee:	31 c0                	xor    %eax,%eax
  8022f0:	89 fa                	mov    %edi,%edx
  8022f2:	83 c4 1c             	add    $0x1c,%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5f                   	pop    %edi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    
  8022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802300:	0f bd fa             	bsr    %edx,%edi
  802303:	83 f7 1f             	xor    $0x1f,%edi
  802306:	75 48                	jne    802350 <__udivdi3+0xa0>
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	72 06                	jb     802312 <__udivdi3+0x62>
  80230c:	31 c0                	xor    %eax,%eax
  80230e:	39 eb                	cmp    %ebp,%ebx
  802310:	77 de                	ja     8022f0 <__udivdi3+0x40>
  802312:	b8 01 00 00 00       	mov    $0x1,%eax
  802317:	eb d7                	jmp    8022f0 <__udivdi3+0x40>
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	89 d9                	mov    %ebx,%ecx
  802322:	85 db                	test   %ebx,%ebx
  802324:	75 0b                	jne    802331 <__udivdi3+0x81>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f3                	div    %ebx
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	31 d2                	xor    %edx,%edx
  802333:	89 f0                	mov    %esi,%eax
  802335:	f7 f1                	div    %ecx
  802337:	89 c6                	mov    %eax,%esi
  802339:	89 e8                	mov    %ebp,%eax
  80233b:	89 f7                	mov    %esi,%edi
  80233d:	f7 f1                	div    %ecx
  80233f:	89 fa                	mov    %edi,%edx
  802341:	83 c4 1c             	add    $0x1c,%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
  802349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802350:	89 f9                	mov    %edi,%ecx
  802352:	b8 20 00 00 00       	mov    $0x20,%eax
  802357:	29 f8                	sub    %edi,%eax
  802359:	d3 e2                	shl    %cl,%edx
  80235b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	89 da                	mov    %ebx,%edx
  802363:	d3 ea                	shr    %cl,%edx
  802365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802369:	09 d1                	or     %edx,%ecx
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e3                	shl    %cl,%ebx
  802375:	89 c1                	mov    %eax,%ecx
  802377:	d3 ea                	shr    %cl,%edx
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80237f:	89 eb                	mov    %ebp,%ebx
  802381:	d3 e6                	shl    %cl,%esi
  802383:	89 c1                	mov    %eax,%ecx
  802385:	d3 eb                	shr    %cl,%ebx
  802387:	09 de                	or     %ebx,%esi
  802389:	89 f0                	mov    %esi,%eax
  80238b:	f7 74 24 08          	divl   0x8(%esp)
  80238f:	89 d6                	mov    %edx,%esi
  802391:	89 c3                	mov    %eax,%ebx
  802393:	f7 64 24 0c          	mull   0xc(%esp)
  802397:	39 d6                	cmp    %edx,%esi
  802399:	72 15                	jb     8023b0 <__udivdi3+0x100>
  80239b:	89 f9                	mov    %edi,%ecx
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	39 c5                	cmp    %eax,%ebp
  8023a1:	73 04                	jae    8023a7 <__udivdi3+0xf7>
  8023a3:	39 d6                	cmp    %edx,%esi
  8023a5:	74 09                	je     8023b0 <__udivdi3+0x100>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	31 ff                	xor    %edi,%edi
  8023ab:	e9 40 ff ff ff       	jmp    8022f0 <__udivdi3+0x40>
  8023b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 36 ff ff ff       	jmp    8022f0 <__udivdi3+0x40>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__umoddi3>:
  8023c0:	f3 0f 1e fb          	endbr32 
  8023c4:	55                   	push   %ebp
  8023c5:	57                   	push   %edi
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 1c             	sub    $0x1c,%esp
  8023cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	75 19                	jne    8023f8 <__umoddi3+0x38>
  8023df:	39 df                	cmp    %ebx,%edi
  8023e1:	76 5d                	jbe    802440 <__umoddi3+0x80>
  8023e3:	89 f0                	mov    %esi,%eax
  8023e5:	89 da                	mov    %ebx,%edx
  8023e7:	f7 f7                	div    %edi
  8023e9:	89 d0                	mov    %edx,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	83 c4 1c             	add    $0x1c,%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5f                   	pop    %edi
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	89 f2                	mov    %esi,%edx
  8023fa:	39 d8                	cmp    %ebx,%eax
  8023fc:	76 12                	jbe    802410 <__umoddi3+0x50>
  8023fe:	89 f0                	mov    %esi,%eax
  802400:	89 da                	mov    %ebx,%edx
  802402:	83 c4 1c             	add    $0x1c,%esp
  802405:	5b                   	pop    %ebx
  802406:	5e                   	pop    %esi
  802407:	5f                   	pop    %edi
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    
  80240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802410:	0f bd e8             	bsr    %eax,%ebp
  802413:	83 f5 1f             	xor    $0x1f,%ebp
  802416:	75 50                	jne    802468 <__umoddi3+0xa8>
  802418:	39 d8                	cmp    %ebx,%eax
  80241a:	0f 82 e0 00 00 00    	jb     802500 <__umoddi3+0x140>
  802420:	89 d9                	mov    %ebx,%ecx
  802422:	39 f7                	cmp    %esi,%edi
  802424:	0f 86 d6 00 00 00    	jbe    802500 <__umoddi3+0x140>
  80242a:	89 d0                	mov    %edx,%eax
  80242c:	89 ca                	mov    %ecx,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	89 fd                	mov    %edi,%ebp
  802442:	85 ff                	test   %edi,%edi
  802444:	75 0b                	jne    802451 <__umoddi3+0x91>
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f7                	div    %edi
  80244f:	89 c5                	mov    %eax,%ebp
  802451:	89 d8                	mov    %ebx,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f5                	div    %ebp
  802457:	89 f0                	mov    %esi,%eax
  802459:	f7 f5                	div    %ebp
  80245b:	89 d0                	mov    %edx,%eax
  80245d:	31 d2                	xor    %edx,%edx
  80245f:	eb 8c                	jmp    8023ed <__umoddi3+0x2d>
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0x10b>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x117>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x117>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	29 fe                	sub    %edi,%esi
  802502:	19 c3                	sbb    %eax,%ebx
  802504:	89 f2                	mov    %esi,%edx
  802506:	89 d9                	mov    %ebx,%ecx
  802508:	e9 1d ff ff ff       	jmp    80242a <__umoddi3+0x6a>
