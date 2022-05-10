
obj/user/primes.debug:     formato del fichero elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  800040:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 00                	push   $0x0
  800048:	6a 00                	push   $0x0
  80004a:	56                   	push   %esi
  80004b:	e8 ff 11 00 00       	call   80124f <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 04 40 80 00       	mov    0x804004,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 20 24 80 00       	push   $0x802420
  800064:	e8 e8 01 00 00       	call   800251 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 95 10 00 00       	call   801103 <fork>
  80006e:	89 c7                	mov    %eax,%edi
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 07                	js     80007e <primeproc+0x4b>
		panic("fork: %e", id);
	if (id == 0)
  800077:	74 ca                	je     800043 <primeproc+0x10>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800079:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007c:	eb 20                	jmp    80009e <primeproc+0x6b>
		panic("fork: %e", id);
  80007e:	50                   	push   %eax
  80007f:	68 07 28 80 00       	push   $0x802807
  800084:	6a 1a                	push   $0x1a
  800086:	68 2c 24 80 00       	push   $0x80242c
  80008b:	e8 da 00 00 00       	call   80016a <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 21 12 00 00       	call   8012bc <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 a4 11 00 00       	call   80124f <ipc_recv>
  8000ab:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000ad:	99                   	cltd   
  8000ae:	f7 fb                	idiv   %ebx
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	85 d2                	test   %edx,%edx
  8000b5:	74 e7                	je     80009e <primeproc+0x6b>
  8000b7:	eb d7                	jmp    800090 <primeproc+0x5d>

008000b9 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000c2:	e8 3c 10 00 00       	call   801103 <fork>
  8000c7:	89 c6                	mov    %eax,%esi
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	78 1a                	js     8000e7 <umain+0x2e>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000cd:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000d2:	74 25                	je     8000f9 <umain+0x40>
		ipc_send(id, i, 0, 0);
  8000d4:	6a 00                	push   $0x0
  8000d6:	6a 00                	push   $0x0
  8000d8:	53                   	push   %ebx
  8000d9:	56                   	push   %esi
  8000da:	e8 dd 11 00 00       	call   8012bc <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 07 28 80 00       	push   $0x802807
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 2c 24 80 00       	push   $0x80242c
  8000f4:	e8 71 00 00 00       	call   80016a <_panic>
		primeproc();
  8000f9:	e8 35 ff ff ff       	call   800033 <primeproc>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	f3 0f 1e fb          	endbr32 
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80010d:	e8 de 0a 00 00       	call   800bf0 <sys_getenvid>
	if (id >= 0)
  800112:	85 c0                	test   %eax,%eax
  800114:	78 12                	js     800128 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800116:	25 ff 03 00 00       	and    $0x3ff,%eax
  80011b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	85 db                	test   %ebx,%ebx
  80012a:	7e 07                	jle    800133 <libmain+0x35>
		binaryname = argv[0];
  80012c:	8b 06                	mov    (%esi),%eax
  80012e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	e8 7c ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  80013d:	e8 0a 00 00 00       	call   80014c <exit>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	f3 0f 1e fb          	endbr32 
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800156:	e8 e9 13 00 00       	call   801544 <close_all>
	sys_env_destroy(0);
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	6a 00                	push   $0x0
  800160:	e8 65 0a 00 00       	call   800bca <sys_env_destroy>
}
  800165:	83 c4 10             	add    $0x10,%esp
  800168:	c9                   	leave  
  800169:	c3                   	ret    

0080016a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80016a:	f3 0f 1e fb          	endbr32 
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	56                   	push   %esi
  800172:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800173:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800176:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80017c:	e8 6f 0a 00 00       	call   800bf0 <sys_getenvid>
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	56                   	push   %esi
  80018b:	50                   	push   %eax
  80018c:	68 44 24 80 00       	push   $0x802444
  800191:	e8 bb 00 00 00       	call   800251 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800196:	83 c4 18             	add    $0x18,%esp
  800199:	53                   	push   %ebx
  80019a:	ff 75 10             	pushl  0x10(%ebp)
  80019d:	e8 5a 00 00 00       	call   8001fc <vcprintf>
	cprintf("\n");
  8001a2:	c7 04 24 49 29 80 00 	movl   $0x802949,(%esp)
  8001a9:	e8 a3 00 00 00       	call   800251 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b1:	cc                   	int3   
  8001b2:	eb fd                	jmp    8001b1 <_panic+0x47>

008001b4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b4:	f3 0f 1e fb          	endbr32 
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 04             	sub    $0x4,%esp
  8001bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c2:	8b 13                	mov    (%ebx),%edx
  8001c4:	8d 42 01             	lea    0x1(%edx),%eax
  8001c7:	89 03                	mov    %eax,(%ebx)
  8001c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001cc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d5:	74 09                	je     8001e0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	68 ff 00 00 00       	push   $0xff
  8001e8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001eb:	50                   	push   %eax
  8001ec:	e8 87 09 00 00       	call   800b78 <sys_cputs>
		b->idx = 0;
  8001f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	eb db                	jmp    8001d7 <putch+0x23>

008001fc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fc:	f3 0f 1e fb          	endbr32 
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800209:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800210:	00 00 00 
	b.cnt = 0;
  800213:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80021a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80021d:	ff 75 0c             	pushl  0xc(%ebp)
  800220:	ff 75 08             	pushl  0x8(%ebp)
  800223:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800229:	50                   	push   %eax
  80022a:	68 b4 01 80 00       	push   $0x8001b4
  80022f:	e8 80 01 00 00       	call   8003b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800234:	83 c4 08             	add    $0x8,%esp
  800237:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80023d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800243:	50                   	push   %eax
  800244:	e8 2f 09 00 00       	call   800b78 <sys_cputs>

	return b.cnt;
}
  800249:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800251:	f3 0f 1e fb          	endbr32 
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80025e:	50                   	push   %eax
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 95 ff ff ff       	call   8001fc <vcprintf>
	va_end(ap);

	return cnt;
}
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	57                   	push   %edi
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	83 ec 1c             	sub    $0x1c,%esp
  800272:	89 c7                	mov    %eax,%edi
  800274:	89 d6                	mov    %edx,%esi
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027c:	89 d1                	mov    %edx,%ecx
  80027e:	89 c2                	mov    %eax,%edx
  800280:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800283:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800286:	8b 45 10             	mov    0x10(%ebp),%eax
  800289:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80028c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800296:	39 c2                	cmp    %eax,%edx
  800298:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80029b:	72 3e                	jb     8002db <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	ff 75 18             	pushl  0x18(%ebp)
  8002a3:	83 eb 01             	sub    $0x1,%ebx
  8002a6:	53                   	push   %ebx
  8002a7:	50                   	push   %eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b7:	e8 04 1f 00 00       	call   8021c0 <__udivdi3>
  8002bc:	83 c4 18             	add    $0x18,%esp
  8002bf:	52                   	push   %edx
  8002c0:	50                   	push   %eax
  8002c1:	89 f2                	mov    %esi,%edx
  8002c3:	89 f8                	mov    %edi,%eax
  8002c5:	e8 9f ff ff ff       	call   800269 <printnum>
  8002ca:	83 c4 20             	add    $0x20,%esp
  8002cd:	eb 13                	jmp    8002e2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	56                   	push   %esi
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	ff d7                	call   *%edi
  8002d8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002db:	83 eb 01             	sub    $0x1,%ebx
  8002de:	85 db                	test   %ebx,%ebx
  8002e0:	7f ed                	jg     8002cf <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	56                   	push   %esi
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f5:	e8 d6 1f 00 00       	call   8022d0 <__umoddi3>
  8002fa:	83 c4 14             	add    $0x14,%esp
  8002fd:	0f be 80 67 24 80 00 	movsbl 0x802467(%eax),%eax
  800304:	50                   	push   %eax
  800305:	ff d7                	call   *%edi
}
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030d:	5b                   	pop    %ebx
  80030e:	5e                   	pop    %esi
  80030f:	5f                   	pop    %edi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800312:	83 fa 01             	cmp    $0x1,%edx
  800315:	7f 13                	jg     80032a <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800317:	85 d2                	test   %edx,%edx
  800319:	74 1c                	je     800337 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80031b:	8b 10                	mov    (%eax),%edx
  80031d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800320:	89 08                	mov    %ecx,(%eax)
  800322:	8b 02                	mov    (%edx),%eax
  800324:	ba 00 00 00 00       	mov    $0x0,%edx
  800329:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80032a:	8b 10                	mov    (%eax),%edx
  80032c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80032f:	89 08                	mov    %ecx,(%eax)
  800331:	8b 02                	mov    (%edx),%eax
  800333:	8b 52 04             	mov    0x4(%edx),%edx
  800336:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800337:	8b 10                	mov    (%eax),%edx
  800339:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033c:	89 08                	mov    %ecx,(%eax)
  80033e:	8b 02                	mov    (%edx),%eax
  800340:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800345:	c3                   	ret    

00800346 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800346:	83 fa 01             	cmp    $0x1,%edx
  800349:	7f 0f                	jg     80035a <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80034b:	85 d2                	test   %edx,%edx
  80034d:	74 18                	je     800367 <getint+0x21>
		return va_arg(*ap, long);
  80034f:	8b 10                	mov    (%eax),%edx
  800351:	8d 4a 04             	lea    0x4(%edx),%ecx
  800354:	89 08                	mov    %ecx,(%eax)
  800356:	8b 02                	mov    (%edx),%eax
  800358:	99                   	cltd   
  800359:	c3                   	ret    
		return va_arg(*ap, long long);
  80035a:	8b 10                	mov    (%eax),%edx
  80035c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80035f:	89 08                	mov    %ecx,(%eax)
  800361:	8b 02                	mov    (%edx),%eax
  800363:	8b 52 04             	mov    0x4(%edx),%edx
  800366:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 02                	mov    (%edx),%eax
  800370:	99                   	cltd   
}
  800371:	c3                   	ret    

00800372 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800372:	f3 0f 1e fb          	endbr32 
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800380:	8b 10                	mov    (%eax),%edx
  800382:	3b 50 04             	cmp    0x4(%eax),%edx
  800385:	73 0a                	jae    800391 <sprintputch+0x1f>
		*b->buf++ = ch;
  800387:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038a:	89 08                	mov    %ecx,(%eax)
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	88 02                	mov    %al,(%edx)
}
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <printfmt>:
{
  800393:	f3 0f 1e fb          	endbr32 
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a0:	50                   	push   %eax
  8003a1:	ff 75 10             	pushl  0x10(%ebp)
  8003a4:	ff 75 0c             	pushl  0xc(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 05 00 00 00       	call   8003b4 <vprintfmt>
}
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    

008003b4 <vprintfmt>:
{
  8003b4:	f3 0f 1e fb          	endbr32 
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	57                   	push   %edi
  8003bc:	56                   	push   %esi
  8003bd:	53                   	push   %ebx
  8003be:	83 ec 2c             	sub    $0x2c,%esp
  8003c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003c7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ca:	e9 86 02 00 00       	jmp    800655 <vprintfmt+0x2a1>
		padc = ' ';
  8003cf:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003d3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8d 47 01             	lea    0x1(%edi),%eax
  8003f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f3:	0f b6 17             	movzbl (%edi),%edx
  8003f6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f9:	3c 55                	cmp    $0x55,%al
  8003fb:	0f 87 df 02 00 00    	ja     8006e0 <vprintfmt+0x32c>
  800401:	0f b6 c0             	movzbl %al,%eax
  800404:	3e ff 24 85 a0 25 80 	notrack jmp *0x8025a0(,%eax,4)
  80040b:	00 
  80040c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800413:	eb d8                	jmp    8003ed <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800418:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80041c:	eb cf                	jmp    8003ed <vprintfmt+0x39>
  80041e:	0f b6 d2             	movzbl %dl,%edx
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80042c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800433:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800436:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800439:	83 f9 09             	cmp    $0x9,%ecx
  80043c:	77 52                	ja     800490 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80043e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800441:	eb e9                	jmp    80042c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	89 55 14             	mov    %edx,0x14(%ebp)
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800458:	79 93                	jns    8003ed <vprintfmt+0x39>
				width = precision, precision = -1;
  80045a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800467:	eb 84                	jmp    8003ed <vprintfmt+0x39>
  800469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046c:	85 c0                	test   %eax,%eax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
  800473:	0f 49 d0             	cmovns %eax,%edx
  800476:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800479:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047c:	e9 6c ff ff ff       	jmp    8003ed <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800484:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80048b:	e9 5d ff ff ff       	jmp    8003ed <vprintfmt+0x39>
  800490:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800493:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800496:	eb bc                	jmp    800454 <vprintfmt+0xa0>
			lflag++;
  800498:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049e:	e9 4a ff ff ff       	jmp    8003ed <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	8d 50 04             	lea    0x4(%eax),%edx
  8004a9:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	56                   	push   %esi
  8004b0:	ff 30                	pushl  (%eax)
  8004b2:	ff d3                	call   *%ebx
			break;
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	e9 96 01 00 00       	jmp    800652 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	99                   	cltd   
  8004c8:	31 d0                	xor    %edx,%eax
  8004ca:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cc:	83 f8 0f             	cmp    $0xf,%eax
  8004cf:	7f 20                	jg     8004f1 <vprintfmt+0x13d>
  8004d1:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  8004d8:	85 d2                	test   %edx,%edx
  8004da:	74 15                	je     8004f1 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8004dc:	52                   	push   %edx
  8004dd:	68 23 2a 80 00       	push   $0x802a23
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	e8 aa fe ff ff       	call   800393 <printfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	e9 61 01 00 00       	jmp    800652 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004f1:	50                   	push   %eax
  8004f2:	68 7f 24 80 00       	push   $0x80247f
  8004f7:	56                   	push   %esi
  8004f8:	53                   	push   %ebx
  8004f9:	e8 95 fe ff ff       	call   800393 <printfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	e9 4c 01 00 00       	jmp    800652 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 50 04             	lea    0x4(%eax),%edx
  80050c:	89 55 14             	mov    %edx,0x14(%ebp)
  80050f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800511:	85 c9                	test   %ecx,%ecx
  800513:	b8 78 24 80 00       	mov    $0x802478,%eax
  800518:	0f 45 c1             	cmovne %ecx,%eax
  80051b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80051e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800522:	7e 06                	jle    80052a <vprintfmt+0x176>
  800524:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800528:	75 0d                	jne    800537 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052d:	89 c7                	mov    %eax,%edi
  80052f:	03 45 e0             	add    -0x20(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800535:	eb 57                	jmp    80058e <vprintfmt+0x1da>
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 d8             	pushl  -0x28(%ebp)
  80053d:	ff 75 cc             	pushl  -0x34(%ebp)
  800540:	e8 4f 02 00 00       	call   800794 <strnlen>
  800545:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800548:	29 c2                	sub    %eax,%edx
  80054a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800550:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800554:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800557:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800559:	85 db                	test   %ebx,%ebx
  80055b:	7e 10                	jle    80056d <vprintfmt+0x1b9>
					putch(padc, putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	56                   	push   %esi
  800561:	57                   	push   %edi
  800562:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800565:	83 eb 01             	sub    $0x1,%ebx
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	eb ec                	jmp    800559 <vprintfmt+0x1a5>
  80056d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800570:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800573:	85 d2                	test   %edx,%edx
  800575:	b8 00 00 00 00       	mov    $0x0,%eax
  80057a:	0f 49 c2             	cmovns %edx,%eax
  80057d:	29 c2                	sub    %eax,%edx
  80057f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800582:	eb a6                	jmp    80052a <vprintfmt+0x176>
					putch(ch, putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	56                   	push   %esi
  800588:	52                   	push   %edx
  800589:	ff d3                	call   *%ebx
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800591:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800593:	83 c7 01             	add    $0x1,%edi
  800596:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059a:	0f be d0             	movsbl %al,%edx
  80059d:	85 d2                	test   %edx,%edx
  80059f:	74 42                	je     8005e3 <vprintfmt+0x22f>
  8005a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a5:	78 06                	js     8005ad <vprintfmt+0x1f9>
  8005a7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ab:	78 1e                	js     8005cb <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b1:	74 d1                	je     800584 <vprintfmt+0x1d0>
  8005b3:	0f be c0             	movsbl %al,%eax
  8005b6:	83 e8 20             	sub    $0x20,%eax
  8005b9:	83 f8 5e             	cmp    $0x5e,%eax
  8005bc:	76 c6                	jbe    800584 <vprintfmt+0x1d0>
					putch('?', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	56                   	push   %esi
  8005c2:	6a 3f                	push   $0x3f
  8005c4:	ff d3                	call   *%ebx
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb c3                	jmp    80058e <vprintfmt+0x1da>
  8005cb:	89 cf                	mov    %ecx,%edi
  8005cd:	eb 0e                	jmp    8005dd <vprintfmt+0x229>
				putch(' ', putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	56                   	push   %esi
  8005d3:	6a 20                	push   $0x20
  8005d5:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8005d7:	83 ef 01             	sub    $0x1,%edi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 ff                	test   %edi,%edi
  8005df:	7f ee                	jg     8005cf <vprintfmt+0x21b>
  8005e1:	eb 6f                	jmp    800652 <vprintfmt+0x29e>
  8005e3:	89 cf                	mov    %ecx,%edi
  8005e5:	eb f6                	jmp    8005dd <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005e7:	89 ca                	mov    %ecx,%edx
  8005e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ec:	e8 55 fd ff ff       	call   800346 <getint>
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005f7:	85 d2                	test   %edx,%edx
  8005f9:	78 0b                	js     800606 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005fb:	89 d1                	mov    %edx,%ecx
  8005fd:	89 c2                	mov    %eax,%edx
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800604:	eb 32                	jmp    800638 <vprintfmt+0x284>
				putch('-', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	56                   	push   %esi
  80060a:	6a 2d                	push   $0x2d
  80060c:	ff d3                	call   *%ebx
				num = -(long long) num;
  80060e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800611:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800614:	f7 da                	neg    %edx
  800616:	83 d1 00             	adc    $0x0,%ecx
  800619:	f7 d9                	neg    %ecx
  80061b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800623:	eb 13                	jmp    800638 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800625:	89 ca                	mov    %ecx,%edx
  800627:	8d 45 14             	lea    0x14(%ebp),%eax
  80062a:	e8 e3 fc ff ff       	call   800312 <getuint>
  80062f:	89 d1                	mov    %edx,%ecx
  800631:	89 c2                	mov    %eax,%edx
			base = 10;
  800633:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800638:	83 ec 0c             	sub    $0xc,%esp
  80063b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80063f:	57                   	push   %edi
  800640:	ff 75 e0             	pushl  -0x20(%ebp)
  800643:	50                   	push   %eax
  800644:	51                   	push   %ecx
  800645:	52                   	push   %edx
  800646:	89 f2                	mov    %esi,%edx
  800648:	89 d8                	mov    %ebx,%eax
  80064a:	e8 1a fc ff ff       	call   800269 <printnum>
			break;
  80064f:	83 c4 20             	add    $0x20,%esp
{
  800652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	83 c7 01             	add    $0x1,%edi
  800658:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065c:	83 f8 25             	cmp    $0x25,%eax
  80065f:	0f 84 6a fd ff ff    	je     8003cf <vprintfmt+0x1b>
			if (ch == '\0')
  800665:	85 c0                	test   %eax,%eax
  800667:	0f 84 93 00 00 00    	je     800700 <vprintfmt+0x34c>
			putch(ch, putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	56                   	push   %esi
  800671:	50                   	push   %eax
  800672:	ff d3                	call   *%ebx
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	eb dc                	jmp    800655 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800679:	89 ca                	mov    %ecx,%edx
  80067b:	8d 45 14             	lea    0x14(%ebp),%eax
  80067e:	e8 8f fc ff ff       	call   800312 <getuint>
  800683:	89 d1                	mov    %edx,%ecx
  800685:	89 c2                	mov    %eax,%edx
			base = 8;
  800687:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  80068c:	eb aa                	jmp    800638 <vprintfmt+0x284>
			putch('0', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	56                   	push   %esi
  800692:	6a 30                	push   $0x30
  800694:	ff d3                	call   *%ebx
			putch('x', putdat);
  800696:	83 c4 08             	add    $0x8,%esp
  800699:	56                   	push   %esi
  80069a:	6a 78                	push   $0x78
  80069c:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8006a7:	8b 10                	mov    (%eax),%edx
  8006a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006ae:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8006b1:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006b6:	eb 80                	jmp    800638 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006b8:	89 ca                	mov    %ecx,%edx
  8006ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bd:	e8 50 fc ff ff       	call   800312 <getuint>
  8006c2:	89 d1                	mov    %edx,%ecx
  8006c4:	89 c2                	mov    %eax,%edx
			base = 16;
  8006c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cb:	e9 68 ff ff ff       	jmp    800638 <vprintfmt+0x284>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	56                   	push   %esi
  8006d4:	6a 25                	push   $0x25
  8006d6:	ff d3                	call   *%ebx
			break;
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	e9 72 ff ff ff       	jmp    800652 <vprintfmt+0x29e>
			putch('%', putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	56                   	push   %esi
  8006e4:	6a 25                	push   $0x25
  8006e6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	89 f8                	mov    %edi,%eax
  8006ed:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006f1:	74 05                	je     8006f8 <vprintfmt+0x344>
  8006f3:	83 e8 01             	sub    $0x1,%eax
  8006f6:	eb f5                	jmp    8006ed <vprintfmt+0x339>
  8006f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fb:	e9 52 ff ff ff       	jmp    800652 <vprintfmt+0x29e>
}
  800700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800703:	5b                   	pop    %ebx
  800704:	5e                   	pop    %esi
  800705:	5f                   	pop    %edi
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800708:	f3 0f 1e fb          	endbr32 
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800718:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80071b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80071f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 26                	je     800753 <vsnprintf+0x4b>
  80072d:	85 d2                	test   %edx,%edx
  80072f:	7e 22                	jle    800753 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800731:	ff 75 14             	pushl  0x14(%ebp)
  800734:	ff 75 10             	pushl  0x10(%ebp)
  800737:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073a:	50                   	push   %eax
  80073b:	68 72 03 80 00       	push   $0x800372
  800740:	e8 6f fc ff ff       	call   8003b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800748:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80074e:	83 c4 10             	add    $0x10,%esp
}
  800751:	c9                   	leave  
  800752:	c3                   	ret    
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800758:	eb f7                	jmp    800751 <vsnprintf+0x49>

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	f3 0f 1e fb          	endbr32 
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800767:	50                   	push   %eax
  800768:	ff 75 10             	pushl  0x10(%ebp)
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	ff 75 08             	pushl  0x8(%ebp)
  800771:	e8 92 ff ff ff       	call   800708 <vsnprintf>
	va_end(ap);

	return rc;
}
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800778:	f3 0f 1e fb          	endbr32 
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800782:	b8 00 00 00 00       	mov    $0x0,%eax
  800787:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80078b:	74 05                	je     800792 <strlen+0x1a>
		n++;
  80078d:	83 c0 01             	add    $0x1,%eax
  800790:	eb f5                	jmp    800787 <strlen+0xf>
	return n;
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800794:	f3 0f 1e fb          	endbr32 
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80079e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	39 d0                	cmp    %edx,%eax
  8007a8:	74 0d                	je     8007b7 <strnlen+0x23>
  8007aa:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ae:	74 05                	je     8007b5 <strnlen+0x21>
		n++;
  8007b0:	83 c0 01             	add    $0x1,%eax
  8007b3:	eb f1                	jmp    8007a6 <strnlen+0x12>
  8007b5:	89 c2                	mov    %eax,%edx
	return n;
}
  8007b7:	89 d0                	mov    %edx,%eax
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	53                   	push   %ebx
  8007c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ce:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007d2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007d5:	83 c0 01             	add    $0x1,%eax
  8007d8:	84 d2                	test   %dl,%dl
  8007da:	75 f2                	jne    8007ce <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007dc:	89 c8                	mov    %ecx,%eax
  8007de:	5b                   	pop    %ebx
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e1:	f3 0f 1e fb          	endbr32 
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 10             	sub    $0x10,%esp
  8007ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007ef:	53                   	push   %ebx
  8007f0:	e8 83 ff ff ff       	call   800778 <strlen>
  8007f5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007f8:	ff 75 0c             	pushl  0xc(%ebp)
  8007fb:	01 d8                	add    %ebx,%eax
  8007fd:	50                   	push   %eax
  8007fe:	e8 b8 ff ff ff       	call   8007bb <strcpy>
	return dst;
}
  800803:	89 d8                	mov    %ebx,%eax
  800805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080a:	f3 0f 1e fb          	endbr32 
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	56                   	push   %esi
  800812:	53                   	push   %ebx
  800813:	8b 75 08             	mov    0x8(%ebp),%esi
  800816:	8b 55 0c             	mov    0xc(%ebp),%edx
  800819:	89 f3                	mov    %esi,%ebx
  80081b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081e:	89 f0                	mov    %esi,%eax
  800820:	39 d8                	cmp    %ebx,%eax
  800822:	74 11                	je     800835 <strncpy+0x2b>
		*dst++ = *src;
  800824:	83 c0 01             	add    $0x1,%eax
  800827:	0f b6 0a             	movzbl (%edx),%ecx
  80082a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082d:	80 f9 01             	cmp    $0x1,%cl
  800830:	83 da ff             	sbb    $0xffffffff,%edx
  800833:	eb eb                	jmp    800820 <strncpy+0x16>
	}
	return ret;
}
  800835:	89 f0                	mov    %esi,%eax
  800837:	5b                   	pop    %ebx
  800838:	5e                   	pop    %esi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083b:	f3 0f 1e fb          	endbr32 
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
  800847:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084a:	8b 55 10             	mov    0x10(%ebp),%edx
  80084d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084f:	85 d2                	test   %edx,%edx
  800851:	74 21                	je     800874 <strlcpy+0x39>
  800853:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800857:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800859:	39 c2                	cmp    %eax,%edx
  80085b:	74 14                	je     800871 <strlcpy+0x36>
  80085d:	0f b6 19             	movzbl (%ecx),%ebx
  800860:	84 db                	test   %bl,%bl
  800862:	74 0b                	je     80086f <strlcpy+0x34>
			*dst++ = *src++;
  800864:	83 c1 01             	add    $0x1,%ecx
  800867:	83 c2 01             	add    $0x1,%edx
  80086a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086d:	eb ea                	jmp    800859 <strlcpy+0x1e>
  80086f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800871:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800874:	29 f0                	sub    %esi,%eax
}
  800876:	5b                   	pop    %ebx
  800877:	5e                   	pop    %esi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800884:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800887:	0f b6 01             	movzbl (%ecx),%eax
  80088a:	84 c0                	test   %al,%al
  80088c:	74 0c                	je     80089a <strcmp+0x20>
  80088e:	3a 02                	cmp    (%edx),%al
  800890:	75 08                	jne    80089a <strcmp+0x20>
		p++, q++;
  800892:	83 c1 01             	add    $0x1,%ecx
  800895:	83 c2 01             	add    $0x1,%edx
  800898:	eb ed                	jmp    800887 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089a:	0f b6 c0             	movzbl %al,%eax
  80089d:	0f b6 12             	movzbl (%edx),%edx
  8008a0:	29 d0                	sub    %edx,%eax
}
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a4:	f3 0f 1e fb          	endbr32 
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	53                   	push   %ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b2:	89 c3                	mov    %eax,%ebx
  8008b4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b7:	eb 06                	jmp    8008bf <strncmp+0x1b>
		n--, p++, q++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008bf:	39 d8                	cmp    %ebx,%eax
  8008c1:	74 16                	je     8008d9 <strncmp+0x35>
  8008c3:	0f b6 08             	movzbl (%eax),%ecx
  8008c6:	84 c9                	test   %cl,%cl
  8008c8:	74 04                	je     8008ce <strncmp+0x2a>
  8008ca:	3a 0a                	cmp    (%edx),%cl
  8008cc:	74 eb                	je     8008b9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ce:	0f b6 00             	movzbl (%eax),%eax
  8008d1:	0f b6 12             	movzbl (%edx),%edx
  8008d4:	29 d0                	sub    %edx,%eax
}
  8008d6:	5b                   	pop    %ebx
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    
		return 0;
  8008d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008de:	eb f6                	jmp    8008d6 <strncmp+0x32>

008008e0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ee:	0f b6 10             	movzbl (%eax),%edx
  8008f1:	84 d2                	test   %dl,%dl
  8008f3:	74 09                	je     8008fe <strchr+0x1e>
		if (*s == c)
  8008f5:	38 ca                	cmp    %cl,%dl
  8008f7:	74 0a                	je     800903 <strchr+0x23>
	for (; *s; s++)
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	eb f0                	jmp    8008ee <strchr+0xe>
			return (char *) s;
	return 0;
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800905:	f3 0f 1e fb          	endbr32 
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800913:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800916:	38 ca                	cmp    %cl,%dl
  800918:	74 09                	je     800923 <strfind+0x1e>
  80091a:	84 d2                	test   %dl,%dl
  80091c:	74 05                	je     800923 <strfind+0x1e>
	for (; *s; s++)
  80091e:	83 c0 01             	add    $0x1,%eax
  800921:	eb f0                	jmp    800913 <strfind+0xe>
			break;
	return (char *) s;
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800925:	f3 0f 1e fb          	endbr32 
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	57                   	push   %edi
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	8b 55 08             	mov    0x8(%ebp),%edx
  800932:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	74 33                	je     80096c <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800939:	89 d0                	mov    %edx,%eax
  80093b:	09 c8                	or     %ecx,%eax
  80093d:	a8 03                	test   $0x3,%al
  80093f:	75 23                	jne    800964 <memset+0x3f>
		c &= 0xFF;
  800941:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800945:	89 d8                	mov    %ebx,%eax
  800947:	c1 e0 08             	shl    $0x8,%eax
  80094a:	89 df                	mov    %ebx,%edi
  80094c:	c1 e7 18             	shl    $0x18,%edi
  80094f:	89 de                	mov    %ebx,%esi
  800951:	c1 e6 10             	shl    $0x10,%esi
  800954:	09 f7                	or     %esi,%edi
  800956:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800958:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095b:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80095d:	89 d7                	mov    %edx,%edi
  80095f:	fc                   	cld    
  800960:	f3 ab                	rep stos %eax,%es:(%edi)
  800962:	eb 08                	jmp    80096c <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800964:	89 d7                	mov    %edx,%edi
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	fc                   	cld    
  80096a:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80096c:	89 d0                	mov    %edx,%eax
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5f                   	pop    %edi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800973:	f3 0f 1e fb          	endbr32 
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800982:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800985:	39 c6                	cmp    %eax,%esi
  800987:	73 32                	jae    8009bb <memmove+0x48>
  800989:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098c:	39 c2                	cmp    %eax,%edx
  80098e:	76 2b                	jbe    8009bb <memmove+0x48>
		s += n;
		d += n;
  800990:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800993:	89 fe                	mov    %edi,%esi
  800995:	09 ce                	or     %ecx,%esi
  800997:	09 d6                	or     %edx,%esi
  800999:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099f:	75 0e                	jne    8009af <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a1:	83 ef 04             	sub    $0x4,%edi
  8009a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009aa:	fd                   	std    
  8009ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ad:	eb 09                	jmp    8009b8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009af:	83 ef 01             	sub    $0x1,%edi
  8009b2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b8:	fc                   	cld    
  8009b9:	eb 1a                	jmp    8009d5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bb:	89 c2                	mov    %eax,%edx
  8009bd:	09 ca                	or     %ecx,%edx
  8009bf:	09 f2                	or     %esi,%edx
  8009c1:	f6 c2 03             	test   $0x3,%dl
  8009c4:	75 0a                	jne    8009d0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c9:	89 c7                	mov    %eax,%edi
  8009cb:	fc                   	cld    
  8009cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ce:	eb 05                	jmp    8009d5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009d0:	89 c7                	mov    %eax,%edi
  8009d2:	fc                   	cld    
  8009d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d5:	5e                   	pop    %esi
  8009d6:	5f                   	pop    %edi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d9:	f3 0f 1e fb          	endbr32 
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e3:	ff 75 10             	pushl  0x10(%ebp)
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 82 ff ff ff       	call   800973 <memmove>
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f3:	f3 0f 1e fb          	endbr32 
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	56                   	push   %esi
  8009fb:	53                   	push   %ebx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	89 c6                	mov    %eax,%esi
  800a04:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a07:	39 f0                	cmp    %esi,%eax
  800a09:	74 1c                	je     800a27 <memcmp+0x34>
		if (*s1 != *s2)
  800a0b:	0f b6 08             	movzbl (%eax),%ecx
  800a0e:	0f b6 1a             	movzbl (%edx),%ebx
  800a11:	38 d9                	cmp    %bl,%cl
  800a13:	75 08                	jne    800a1d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	83 c2 01             	add    $0x1,%edx
  800a1b:	eb ea                	jmp    800a07 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a1d:	0f b6 c1             	movzbl %cl,%eax
  800a20:	0f b6 db             	movzbl %bl,%ebx
  800a23:	29 d8                	sub    %ebx,%eax
  800a25:	eb 05                	jmp    800a2c <memcmp+0x39>
	}

	return 0;
  800a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2c:	5b                   	pop    %ebx
  800a2d:	5e                   	pop    %esi
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a30:	f3 0f 1e fb          	endbr32 
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a42:	39 d0                	cmp    %edx,%eax
  800a44:	73 09                	jae    800a4f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a46:	38 08                	cmp    %cl,(%eax)
  800a48:	74 05                	je     800a4f <memfind+0x1f>
	for (; s < ends; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	eb f3                	jmp    800a42 <memfind+0x12>
			break;
	return (void *) s;
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a51:	f3 0f 1e fb          	endbr32 
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	57                   	push   %edi
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
  800a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a61:	eb 03                	jmp    800a66 <strtol+0x15>
		s++;
  800a63:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a66:	0f b6 01             	movzbl (%ecx),%eax
  800a69:	3c 20                	cmp    $0x20,%al
  800a6b:	74 f6                	je     800a63 <strtol+0x12>
  800a6d:	3c 09                	cmp    $0x9,%al
  800a6f:	74 f2                	je     800a63 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a71:	3c 2b                	cmp    $0x2b,%al
  800a73:	74 2a                	je     800a9f <strtol+0x4e>
	int neg = 0;
  800a75:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a7a:	3c 2d                	cmp    $0x2d,%al
  800a7c:	74 2b                	je     800aa9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a84:	75 0f                	jne    800a95 <strtol+0x44>
  800a86:	80 39 30             	cmpb   $0x30,(%ecx)
  800a89:	74 28                	je     800ab3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a8b:	85 db                	test   %ebx,%ebx
  800a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a92:	0f 44 d8             	cmove  %eax,%ebx
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9d:	eb 46                	jmp    800ae5 <strtol+0x94>
		s++;
  800a9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa7:	eb d5                	jmp    800a7e <strtol+0x2d>
		s++, neg = 1;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	bf 01 00 00 00       	mov    $0x1,%edi
  800ab1:	eb cb                	jmp    800a7e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab7:	74 0e                	je     800ac7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	75 d8                	jne    800a95 <strtol+0x44>
		s++, base = 8;
  800abd:	83 c1 01             	add    $0x1,%ecx
  800ac0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac5:	eb ce                	jmp    800a95 <strtol+0x44>
		s += 2, base = 16;
  800ac7:	83 c1 02             	add    $0x2,%ecx
  800aca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acf:	eb c4                	jmp    800a95 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ad1:	0f be d2             	movsbl %dl,%edx
  800ad4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ad7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ada:	7d 3a                	jge    800b16 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ae5:	0f b6 11             	movzbl (%ecx),%edx
  800ae8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aeb:	89 f3                	mov    %esi,%ebx
  800aed:	80 fb 09             	cmp    $0x9,%bl
  800af0:	76 df                	jbe    800ad1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800af2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af5:	89 f3                	mov    %esi,%ebx
  800af7:	80 fb 19             	cmp    $0x19,%bl
  800afa:	77 08                	ja     800b04 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800afc:	0f be d2             	movsbl %dl,%edx
  800aff:	83 ea 57             	sub    $0x57,%edx
  800b02:	eb d3                	jmp    800ad7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b07:	89 f3                	mov    %esi,%ebx
  800b09:	80 fb 19             	cmp    $0x19,%bl
  800b0c:	77 08                	ja     800b16 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0e:	0f be d2             	movsbl %dl,%edx
  800b11:	83 ea 37             	sub    $0x37,%edx
  800b14:	eb c1                	jmp    800ad7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1a:	74 05                	je     800b21 <strtol+0xd0>
		*endptr = (char *) s;
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b21:	89 c2                	mov    %eax,%edx
  800b23:	f7 da                	neg    %edx
  800b25:	85 ff                	test   %edi,%edi
  800b27:	0f 45 c2             	cmovne %edx,%eax
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	83 ec 1c             	sub    $0x1c,%esp
  800b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b3e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b46:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b49:	8b 75 14             	mov    0x14(%ebp),%esi
  800b4c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b52:	74 04                	je     800b58 <syscall+0x29>
  800b54:	85 c0                	test   %eax,%eax
  800b56:	7f 08                	jg     800b60 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5f                   	pop    %edi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b60:	83 ec 0c             	sub    $0xc,%esp
  800b63:	50                   	push   %eax
  800b64:	ff 75 e0             	pushl  -0x20(%ebp)
  800b67:	68 5f 27 80 00       	push   $0x80275f
  800b6c:	6a 23                	push   $0x23
  800b6e:	68 7c 27 80 00       	push   $0x80277c
  800b73:	e8 f2 f5 ff ff       	call   80016a <_panic>

00800b78 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b78:	f3 0f 1e fb          	endbr32 
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b82:	6a 00                	push   $0x0
  800b84:	6a 00                	push   $0x0
  800b86:	6a 00                	push   $0x0
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
  800b98:	e8 92 ff ff ff       	call   800b2f <syscall>
}
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba2:	f3 0f 1e fb          	endbr32 
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800bac:	6a 00                	push   $0x0
  800bae:	6a 00                	push   $0x0
  800bb0:	6a 00                	push   $0x0
  800bb2:	6a 00                	push   $0x0
  800bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc3:	e8 67 ff ff ff       	call   800b2f <syscall>
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bca:	f3 0f 1e fb          	endbr32 
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bd4:	6a 00                	push   $0x0
  800bd6:	6a 00                	push   $0x0
  800bd8:	6a 00                	push   $0x0
  800bda:	6a 00                	push   $0x0
  800bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdf:	ba 01 00 00 00       	mov    $0x1,%edx
  800be4:	b8 03 00 00 00       	mov    $0x3,%eax
  800be9:	e8 41 ff ff ff       	call   800b2f <syscall>
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bfa:	6a 00                	push   $0x0
  800bfc:	6a 00                	push   $0x0
  800bfe:	6a 00                	push   $0x0
  800c00:	6a 00                	push   $0x0
  800c02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c07:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c11:	e8 19 ff ff ff       	call   800b2f <syscall>
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <sys_yield>:

void
sys_yield(void)
{
  800c18:	f3 0f 1e fb          	endbr32 
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c22:	6a 00                	push   $0x0
  800c24:	6a 00                	push   $0x0
  800c26:	6a 00                	push   $0x0
  800c28:	6a 00                	push   $0x0
  800c2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c39:	e8 f1 fe ff ff       	call   800b2f <syscall>
}
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c43:	f3 0f 1e fb          	endbr32 
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c4d:	6a 00                	push   $0x0
  800c4f:	6a 00                	push   $0x0
  800c51:	ff 75 10             	pushl  0x10(%ebp)
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c5f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c64:	e8 c6 fe ff ff       	call   800b2f <syscall>
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c6b:	f3 0f 1e fb          	endbr32 
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c75:	ff 75 18             	pushl  0x18(%ebp)
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c84:	ba 01 00 00 00       	mov    $0x1,%edx
  800c89:	b8 05 00 00 00       	mov    $0x5,%eax
  800c8e:	e8 9c fe ff ff       	call   800b2f <syscall>
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c95:	f3 0f 1e fb          	endbr32 
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c9f:	6a 00                	push   $0x0
  800ca1:	6a 00                	push   $0x0
  800ca3:	6a 00                	push   $0x0
  800ca5:	ff 75 0c             	pushl  0xc(%ebp)
  800ca8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cab:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb0:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb5:	e8 75 fe ff ff       	call   800b2f <syscall>
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cbc:	f3 0f 1e fb          	endbr32 
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800cc6:	6a 00                	push   $0x0
  800cc8:	6a 00                	push   $0x0
  800cca:	6a 00                	push   $0x0
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd2:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800cdc:	e8 4e fe ff ff       	call   800b2f <syscall>
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce3:	f3 0f 1e fb          	endbr32 
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ced:	6a 00                	push   $0x0
  800cef:	6a 00                	push   $0x0
  800cf1:	6a 00                	push   $0x0
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf9:	ba 01 00 00 00       	mov    $0x1,%edx
  800cfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800d03:	e8 27 fe ff ff       	call   800b2f <syscall>
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d0a:	f3 0f 1e fb          	endbr32 
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d14:	6a 00                	push   $0x0
  800d16:	6a 00                	push   $0x0
  800d18:	6a 00                	push   $0x0
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d20:	ba 01 00 00 00       	mov    $0x1,%edx
  800d25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2a:	e8 00 fe ff ff       	call   800b2f <syscall>
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d31:	f3 0f 1e fb          	endbr32 
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d3b:	6a 00                	push   $0x0
  800d3d:	ff 75 14             	pushl  0x14(%ebp)
  800d40:	ff 75 10             	pushl  0x10(%ebp)
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d49:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d53:	e8 d7 fd ff ff       	call   800b2f <syscall>
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d5a:	f3 0f 1e fb          	endbr32 
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d64:	6a 00                	push   $0x0
  800d66:	6a 00                	push   $0x0
  800d68:	6a 00                	push   $0x0
  800d6a:	6a 00                	push   $0x0
  800d6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d79:	e8 b1 fd ff ff       	call   800b2f <syscall>
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	53                   	push   %ebx
  800d84:	83 ec 04             	sub    $0x4,%esp
  800d87:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800d89:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d90:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d93:	f6 c6 04             	test   $0x4,%dh
  800d96:	75 51                	jne    800de9 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d98:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d9e:	0f 84 84 00 00 00    	je     800e28 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	68 05 08 00 00       	push   $0x805
  800dac:	53                   	push   %ebx
  800dad:	50                   	push   %eax
  800dae:	53                   	push   %ebx
  800daf:	6a 00                	push   $0x0
  800db1:	e8 b5 fe ff ff       	call   800c6b <sys_page_map>
		if (r)
  800db6:	83 c4 20             	add    $0x20,%esp
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	75 59                	jne    800e16 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	68 05 08 00 00       	push   $0x805
  800dc5:	53                   	push   %ebx
  800dc6:	6a 00                	push   $0x0
  800dc8:	53                   	push   %ebx
  800dc9:	6a 00                	push   $0x0
  800dcb:	e8 9b fe ff ff       	call   800c6b <sys_page_map>
		if (r)
  800dd0:	83 c4 20             	add    $0x20,%esp
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	74 67                	je     800e3e <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800dd7:	50                   	push   %eax
  800dd8:	68 8a 27 80 00       	push   $0x80278a
  800ddd:	6a 5f                	push   $0x5f
  800ddf:	68 a5 27 80 00       	push   $0x8027a5
  800de4:	e8 81 f3 ff ff       	call   80016a <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800df2:	52                   	push   %edx
  800df3:	53                   	push   %ebx
  800df4:	50                   	push   %eax
  800df5:	53                   	push   %ebx
  800df6:	6a 00                	push   $0x0
  800df8:	e8 6e fe ff ff       	call   800c6b <sys_page_map>
		if (r)
  800dfd:	83 c4 20             	add    $0x20,%esp
  800e00:	85 c0                	test   %eax,%eax
  800e02:	74 3a                	je     800e3e <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800e04:	50                   	push   %eax
  800e05:	68 8a 27 80 00       	push   $0x80278a
  800e0a:	6a 57                	push   $0x57
  800e0c:	68 a5 27 80 00       	push   $0x8027a5
  800e11:	e8 54 f3 ff ff       	call   80016a <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800e16:	50                   	push   %eax
  800e17:	68 8a 27 80 00       	push   $0x80278a
  800e1c:	6a 5b                	push   $0x5b
  800e1e:	68 a5 27 80 00       	push   $0x8027a5
  800e23:	e8 42 f3 ff ff       	call   80016a <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	6a 05                	push   $0x5
  800e2d:	53                   	push   %ebx
  800e2e:	50                   	push   %eax
  800e2f:	53                   	push   %ebx
  800e30:	6a 00                	push   $0x0
  800e32:	e8 34 fe ff ff       	call   800c6b <sys_page_map>
		if (r)
  800e37:	83 c4 20             	add    $0x20,%esp
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	75 0a                	jne    800e48 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800e48:	50                   	push   %eax
  800e49:	68 8a 27 80 00       	push   $0x80278a
  800e4e:	6a 63                	push   $0x63
  800e50:	68 a5 27 80 00       	push   $0x8027a5
  800e55:	e8 10 f3 ff ff       	call   80016a <_panic>

00800e5a <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	89 c7                	mov    %eax,%edi
  800e65:	89 d6                	mov    %edx,%esi
  800e67:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800e69:	f6 c1 02             	test   $0x2,%cl
  800e6c:	75 2f                	jne    800e9d <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	51                   	push   %ecx
  800e72:	52                   	push   %edx
  800e73:	50                   	push   %eax
  800e74:	52                   	push   %edx
  800e75:	6a 00                	push   $0x0
  800e77:	e8 ef fd ff ff       	call   800c6b <sys_page_map>
  800e7c:	83 c4 20             	add    $0x20,%esp
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	78 08                	js     800e8b <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800e8b:	50                   	push   %eax
  800e8c:	68 94 27 80 00       	push   $0x802794
  800e91:	6a 6f                	push   $0x6f
  800e93:	68 a5 27 80 00       	push   $0x8027a5
  800e98:	e8 cd f2 ff ff       	call   80016a <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e9d:	83 ec 04             	sub    $0x4,%esp
  800ea0:	51                   	push   %ecx
  800ea1:	52                   	push   %edx
  800ea2:	50                   	push   %eax
  800ea3:	e8 9b fd ff ff       	call   800c43 <sys_page_alloc>
  800ea8:	83 c4 10             	add    $0x10,%esp
  800eab:	85 c0                	test   %eax,%eax
  800ead:	78 54                	js     800f03 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	53                   	push   %ebx
  800eb3:	68 00 00 40 00       	push   $0x400000
  800eb8:	6a 00                	push   $0x0
  800eba:	56                   	push   %esi
  800ebb:	57                   	push   %edi
  800ebc:	e8 aa fd ff ff       	call   800c6b <sys_page_map>
  800ec1:	83 c4 20             	add    $0x20,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 4d                	js     800f15 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	68 00 10 00 00       	push   $0x1000
  800ed0:	56                   	push   %esi
  800ed1:	68 00 00 40 00       	push   $0x400000
  800ed6:	e8 98 fa ff ff       	call   800973 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800edb:	83 c4 08             	add    $0x8,%esp
  800ede:	68 00 00 40 00       	push   $0x400000
  800ee3:	6a 00                	push   $0x0
  800ee5:	e8 ab fd ff ff       	call   800c95 <sys_page_unmap>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	85 c0                	test   %eax,%eax
  800eef:	79 92                	jns    800e83 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800ef1:	50                   	push   %eax
  800ef2:	68 c3 27 80 00       	push   $0x8027c3
  800ef7:	6a 78                	push   $0x78
  800ef9:	68 a5 27 80 00       	push   $0x8027a5
  800efe:	e8 67 f2 ff ff       	call   80016a <_panic>
		panic("sys_page_alloc: %e", r);
  800f03:	50                   	push   %eax
  800f04:	68 b0 27 80 00       	push   $0x8027b0
  800f09:	6a 73                	push   $0x73
  800f0b:	68 a5 27 80 00       	push   $0x8027a5
  800f10:	e8 55 f2 ff ff       	call   80016a <_panic>
		panic("sys_page_map: %e", r);
  800f15:	50                   	push   %eax
  800f16:	68 94 27 80 00       	push   $0x802794
  800f1b:	6a 75                	push   $0x75
  800f1d:	68 a5 27 80 00       	push   $0x8027a5
  800f22:	e8 43 f2 ff ff       	call   80016a <_panic>

00800f27 <pgfault>:
{
  800f27:	f3 0f 1e fb          	endbr32 
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 04             	sub    $0x4,%esp
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f35:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800f37:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800f3a:	89 da                	mov    %ebx,%edx
  800f3c:	c1 ea 0c             	shr    $0xc,%edx
  800f3f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800f46:	a8 01                	test   $0x1,%al
  800f48:	74 7e                	je     800fc8 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800f4a:	a8 02                	test   $0x2,%al
  800f4c:	0f 84 8a 00 00 00    	je     800fdc <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800f52:	f6 c6 08             	test   $0x8,%dh
  800f55:	0f 84 95 00 00 00    	je     800ff0 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	6a 07                	push   $0x7
  800f60:	68 00 f0 7f 00       	push   $0x7ff000
  800f65:	6a 00                	push   $0x0
  800f67:	e8 d7 fc ff ff       	call   800c43 <sys_page_alloc>
	if (r)
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	0f 85 8d 00 00 00    	jne    801004 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f77:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	68 00 10 00 00       	push   $0x1000
  800f85:	53                   	push   %ebx
  800f86:	68 00 f0 7f 00       	push   $0x7ff000
  800f8b:	e8 49 fa ff ff       	call   8009d9 <memcpy>
	r = sys_page_map(
  800f90:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f97:	53                   	push   %ebx
  800f98:	6a 00                	push   $0x0
  800f9a:	68 00 f0 7f 00       	push   $0x7ff000
  800f9f:	6a 00                	push   $0x0
  800fa1:	e8 c5 fc ff ff       	call   800c6b <sys_page_map>
	if (r)
  800fa6:	83 c4 20             	add    $0x20,%esp
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	75 69                	jne    801016 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	68 00 f0 7f 00       	push   $0x7ff000
  800fb5:	6a 00                	push   $0x0
  800fb7:	e8 d9 fc ff ff       	call   800c95 <sys_page_unmap>
	if (r)
  800fbc:	83 c4 10             	add    $0x10,%esp
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	75 65                	jne    801028 <pgfault+0x101>
}
  800fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800fc8:	83 ec 04             	sub    $0x4,%esp
  800fcb:	68 44 28 80 00       	push   $0x802844
  800fd0:	6a 20                	push   $0x20
  800fd2:	68 a5 27 80 00       	push   $0x8027a5
  800fd7:	e8 8e f1 ff ff       	call   80016a <_panic>
		panic("[pgfault] pgfault por lectura");
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 d6 27 80 00       	push   $0x8027d6
  800fe4:	6a 23                	push   $0x23
  800fe6:	68 a5 27 80 00       	push   $0x8027a5
  800feb:	e8 7a f1 ff ff       	call   80016a <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	68 70 28 80 00       	push   $0x802870
  800ff8:	6a 27                	push   $0x27
  800ffa:	68 a5 27 80 00       	push   $0x8027a5
  800fff:	e8 66 f1 ff ff       	call   80016a <_panic>
		panic("pgfault: %e", r);
  801004:	50                   	push   %eax
  801005:	68 f4 27 80 00       	push   $0x8027f4
  80100a:	6a 32                	push   $0x32
  80100c:	68 a5 27 80 00       	push   $0x8027a5
  801011:	e8 54 f1 ff ff       	call   80016a <_panic>
		panic("pgfault: %e", r);
  801016:	50                   	push   %eax
  801017:	68 f4 27 80 00       	push   $0x8027f4
  80101c:	6a 39                	push   $0x39
  80101e:	68 a5 27 80 00       	push   $0x8027a5
  801023:	e8 42 f1 ff ff       	call   80016a <_panic>
		panic("pgfault: %e", r);
  801028:	50                   	push   %eax
  801029:	68 f4 27 80 00       	push   $0x8027f4
  80102e:	6a 3d                	push   $0x3d
  801030:	68 a5 27 80 00       	push   $0x8027a5
  801035:	e8 30 f1 ff ff       	call   80016a <_panic>

0080103a <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  80103a:	f3 0f 1e fb          	endbr32 
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801047:	b8 07 00 00 00       	mov    $0x7,%eax
  80104c:	cd 30                	int    $0x30
  80104e:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801050:	85 c0                	test   %eax,%eax
  801052:	78 22                	js     801076 <fork_v0+0x3c>
  801054:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80105b:	75 52                	jne    8010af <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105d:	e8 8e fb ff ff       	call   800bf0 <sys_getenvid>
  801062:	25 ff 03 00 00       	and    $0x3ff,%eax
  801067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80106a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801074:	eb 6e                	jmp    8010e4 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  801076:	50                   	push   %eax
  801077:	68 98 28 80 00       	push   $0x802898
  80107c:	68 8a 00 00 00       	push   $0x8a
  801081:	68 a5 27 80 00       	push   $0x8027a5
  801086:	e8 df f0 ff ff       	call   80016a <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  80108b:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801092:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801098:	89 da                	mov    %ebx,%edx
  80109a:	89 f0                	mov    %esi,%eax
  80109c:	e8 b9 fd ff ff       	call   800e5a <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8010a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010a7:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8010ad:	74 23                	je     8010d2 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8010af:	89 d8                	mov    %ebx,%eax
  8010b1:	c1 e8 16             	shr    $0x16,%eax
  8010b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010bb:	a8 01                	test   $0x1,%al
  8010bd:	74 e2                	je     8010a1 <fork_v0+0x67>
  8010bf:	89 d8                	mov    %ebx,%eax
  8010c1:	c1 e8 0c             	shr    $0xc,%eax
  8010c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010cb:	f6 c2 01             	test   $0x1,%dl
  8010ce:	74 d1                	je     8010a1 <fork_v0+0x67>
  8010d0:	eb b9                	jmp    80108b <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010d2:	83 ec 08             	sub    $0x8,%esp
  8010d5:	6a 02                	push   $0x2
  8010d7:	57                   	push   %edi
  8010d8:	e8 df fb ff ff       	call   800cbc <sys_env_set_status>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	78 0a                	js     8010ee <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8010e4:	89 f8                	mov    %edi,%eax
  8010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e9:	5b                   	pop    %ebx
  8010ea:	5e                   	pop    %esi
  8010eb:	5f                   	pop    %edi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8010ee:	50                   	push   %eax
  8010ef:	68 bc 28 80 00       	push   $0x8028bc
  8010f4:	68 98 00 00 00       	push   $0x98
  8010f9:	68 a5 27 80 00       	push   $0x8027a5
  8010fe:	e8 67 f0 ff ff       	call   80016a <_panic>

00801103 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801103:	f3 0f 1e fb          	endbr32 
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  801110:	68 27 0f 80 00       	push   $0x800f27
  801115:	e8 bf 0f 00 00       	call   8020d9 <set_pgfault_handler>
  80111a:	b8 07 00 00 00       	mov    $0x7,%eax
  80111f:	cd 30                	int    $0x30
  801121:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	78 37                	js     801161 <fork+0x5e>
  80112a:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  80112c:	74 48                	je     801176 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	6a 07                	push   $0x7
  801133:	68 00 f0 bf ee       	push   $0xeebff000
  801138:	50                   	push   %eax
  801139:	e8 05 fb ff ff       	call   800c43 <sys_page_alloc>
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	78 4d                	js     801192 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 56 21 80 00       	push   $0x802156
  80114d:	56                   	push   %esi
  80114e:	e8 b7 fb ff ff       	call   800d0a <sys_env_set_pgfault_upcall>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 4d                	js     8011a7 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115f:	eb 70                	jmp    8011d1 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801161:	50                   	push   %eax
  801162:	68 00 28 80 00       	push   $0x802800
  801167:	68 b7 00 00 00       	push   $0xb7
  80116c:	68 a5 27 80 00       	push   $0x8027a5
  801171:	e8 f4 ef ff ff       	call   80016a <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801176:	e8 75 fa ff ff       	call   800bf0 <sys_getenvid>
  80117b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801180:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801183:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801188:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80118d:	e9 80 00 00 00       	jmp    801212 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801192:	50                   	push   %eax
  801193:	68 10 28 80 00       	push   $0x802810
  801198:	68 c0 00 00 00       	push   $0xc0
  80119d:	68 a5 27 80 00       	push   $0x8027a5
  8011a2:	e8 c3 ef ff ff       	call   80016a <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  8011a7:	50                   	push   %eax
  8011a8:	68 e0 28 80 00       	push   $0x8028e0
  8011ad:	68 c3 00 00 00       	push   $0xc3
  8011b2:	68 a5 27 80 00       	push   $0x8027a5
  8011b7:	e8 ae ef ff ff       	call   80016a <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  8011bc:	89 f8                	mov    %edi,%eax
  8011be:	e8 bd fb ff ff       	call   800d80 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8011c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011c9:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011cf:	74 2f                	je     801200 <fork+0xfd>
  8011d1:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  8011d3:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  8011d9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8011de:	76 e3                	jbe    8011c3 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8011e0:	89 d8                	mov    %ebx,%eax
  8011e2:	c1 e8 16             	shr    $0x16,%eax
  8011e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ec:	a8 01                	test   $0x1,%al
  8011ee:	74 d3                	je     8011c3 <fork+0xc0>
  8011f0:	c1 ea 0c             	shr    $0xc,%edx
  8011f3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011fa:	a8 01                	test   $0x1,%al
  8011fc:	74 c5                	je     8011c3 <fork+0xc0>
  8011fe:	eb bc                	jmp    8011bc <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	6a 02                	push   $0x2
  801205:	56                   	push   %esi
  801206:	e8 b1 fa ff ff       	call   800cbc <sys_env_set_status>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 0a                	js     80121c <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  801212:	89 f0                	mov    %esi,%eax
  801214:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  80121c:	50                   	push   %eax
  80121d:	68 0c 29 80 00       	push   $0x80290c
  801222:	68 ce 00 00 00       	push   $0xce
  801227:	68 a5 27 80 00       	push   $0x8027a5
  80122c:	e8 39 ef ff ff       	call   80016a <_panic>

00801231 <sfork>:

// Challenge!
int
sfork(void)
{
  801231:	f3 0f 1e fb          	endbr32 
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80123b:	68 2e 28 80 00       	push   $0x80282e
  801240:	68 d7 00 00 00       	push   $0xd7
  801245:	68 a5 27 80 00       	push   $0x8027a5
  80124a:	e8 1b ef ff ff       	call   80016a <_panic>

0080124f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80124f:	f3 0f 1e fb          	endbr32 
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	56                   	push   %esi
  801257:	53                   	push   %ebx
  801258:	8b 75 08             	mov    0x8(%ebp),%esi
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801261:	85 c0                	test   %eax,%eax
  801263:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801268:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  80126b:	83 ec 0c             	sub    $0xc,%esp
  80126e:	50                   	push   %eax
  80126f:	e8 e6 fa ff ff       	call   800d5a <sys_ipc_recv>
	if (r < 0) {
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	78 2b                	js     8012a6 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  80127b:	85 f6                	test   %esi,%esi
  80127d:	74 0a                	je     801289 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  80127f:	a1 04 40 80 00       	mov    0x804004,%eax
  801284:	8b 40 74             	mov    0x74(%eax),%eax
  801287:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801289:	85 db                	test   %ebx,%ebx
  80128b:	74 0a                	je     801297 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  80128d:	a1 04 40 80 00       	mov    0x804004,%eax
  801292:	8b 40 78             	mov    0x78(%eax),%eax
  801295:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801297:	a1 04 40 80 00       	mov    0x804004,%eax
  80129c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80129f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a2:	5b                   	pop    %ebx
  8012a3:	5e                   	pop    %esi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    
		if (from_env_store) {
  8012a6:	85 f6                	test   %esi,%esi
  8012a8:	74 06                	je     8012b0 <ipc_recv+0x61>
			*from_env_store = 0;
  8012aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8012b0:	85 db                	test   %ebx,%ebx
  8012b2:	74 eb                	je     80129f <ipc_recv+0x50>
			*perm_store = 0;
  8012b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012ba:	eb e3                	jmp    80129f <ipc_recv+0x50>

008012bc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 0c             	sub    $0xc,%esp
  8012c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8012d2:	85 db                	test   %ebx,%ebx
  8012d4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012d9:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8012dc:	ff 75 14             	pushl  0x14(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	56                   	push   %esi
  8012e1:	57                   	push   %edi
  8012e2:	e8 4a fa ff ff       	call   800d31 <sys_ipc_try_send>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012ed:	75 07                	jne    8012f6 <ipc_send+0x3a>
		sys_yield();
  8012ef:	e8 24 f9 ff ff       	call   800c18 <sys_yield>
  8012f4:	eb e6                	jmp    8012dc <ipc_send+0x20>
	}

	if (ret < 0) {
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	78 08                	js     801302 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5e                   	pop    %esi
  8012ff:	5f                   	pop    %edi
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801302:	50                   	push   %eax
  801303:	68 2e 29 80 00       	push   $0x80292e
  801308:	6a 48                	push   $0x48
  80130a:	68 4b 29 80 00       	push   $0x80294b
  80130f:	e8 56 ee ff ff       	call   80016a <_panic>

00801314 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801323:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801326:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80132c:	8b 52 50             	mov    0x50(%edx),%edx
  80132f:	39 ca                	cmp    %ecx,%edx
  801331:	74 11                	je     801344 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801333:	83 c0 01             	add    $0x1,%eax
  801336:	3d 00 04 00 00       	cmp    $0x400,%eax
  80133b:	75 e6                	jne    801323 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 0b                	jmp    80134f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801344:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801347:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80134c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    

00801351 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801351:	f3 0f 1e fb          	endbr32 
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	05 00 00 00 30       	add    $0x30000000,%eax
  801360:	c1 e8 0c             	shr    $0xc,%eax
}
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801365:	f3 0f 1e fb          	endbr32 
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 da ff ff ff       	call   801351 <fd2num>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	c1 e0 0c             	shl    $0xc,%eax
  80137d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801384:	f3 0f 1e fb          	endbr32 
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801390:	89 c2                	mov    %eax,%edx
  801392:	c1 ea 16             	shr    $0x16,%edx
  801395:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80139c:	f6 c2 01             	test   $0x1,%dl
  80139f:	74 2d                	je     8013ce <fd_alloc+0x4a>
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	c1 ea 0c             	shr    $0xc,%edx
  8013a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ad:	f6 c2 01             	test   $0x1,%dl
  8013b0:	74 1c                	je     8013ce <fd_alloc+0x4a>
  8013b2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013b7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013bc:	75 d2                	jne    801390 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013cc:	eb 0a                	jmp    8013d8 <fd_alloc+0x54>
			*fd_store = fd;
  8013ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013da:	f3 0f 1e fb          	endbr32 
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013e4:	83 f8 1f             	cmp    $0x1f,%eax
  8013e7:	77 30                	ja     801419 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013e9:	c1 e0 0c             	shl    $0xc,%eax
  8013ec:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013f1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013f7:	f6 c2 01             	test   $0x1,%dl
  8013fa:	74 24                	je     801420 <fd_lookup+0x46>
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	c1 ea 0c             	shr    $0xc,%edx
  801401:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801408:	f6 c2 01             	test   $0x1,%dl
  80140b:	74 1a                	je     801427 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	89 02                	mov    %eax,(%edx)
	return 0;
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    
		return -E_INVAL;
  801419:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141e:	eb f7                	jmp    801417 <fd_lookup+0x3d>
		return -E_INVAL;
  801420:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801425:	eb f0                	jmp    801417 <fd_lookup+0x3d>
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142c:	eb e9                	jmp    801417 <fd_lookup+0x3d>

0080142e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80142e:	f3 0f 1e fb          	endbr32 
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143b:	ba d4 29 80 00       	mov    $0x8029d4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801440:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801445:	39 08                	cmp    %ecx,(%eax)
  801447:	74 33                	je     80147c <dev_lookup+0x4e>
  801449:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80144c:	8b 02                	mov    (%edx),%eax
  80144e:	85 c0                	test   %eax,%eax
  801450:	75 f3                	jne    801445 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801452:	a1 04 40 80 00       	mov    0x804004,%eax
  801457:	8b 40 48             	mov    0x48(%eax),%eax
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	51                   	push   %ecx
  80145e:	50                   	push   %eax
  80145f:	68 58 29 80 00       	push   $0x802958
  801464:	e8 e8 ed ff ff       	call   800251 <cprintf>
	*dev = 0;
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    
			*dev = devtab[i];
  80147c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
  801486:	eb f2                	jmp    80147a <dev_lookup+0x4c>

00801488 <fd_close>:
{
  801488:	f3 0f 1e fb          	endbr32 
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 28             	sub    $0x28,%esp
  801495:	8b 75 08             	mov    0x8(%ebp),%esi
  801498:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80149b:	56                   	push   %esi
  80149c:	e8 b0 fe ff ff       	call   801351 <fd2num>
  8014a1:	83 c4 08             	add    $0x8,%esp
  8014a4:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8014a7:	52                   	push   %edx
  8014a8:	50                   	push   %eax
  8014a9:	e8 2c ff ff ff       	call   8013da <fd_lookup>
  8014ae:	89 c3                	mov    %eax,%ebx
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 05                	js     8014bc <fd_close+0x34>
	    || fd != fd2)
  8014b7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014ba:	74 16                	je     8014d2 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014bc:	89 f8                	mov    %edi,%eax
  8014be:	84 c0                	test   %al,%al
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	0f 44 d8             	cmove  %eax,%ebx
}
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5f                   	pop    %edi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	ff 36                	pushl  (%esi)
  8014db:	e8 4e ff ff ff       	call   80142e <dev_lookup>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 1a                	js     801503 <fd_close+0x7b>
		if (dev->dev_close)
  8014e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ec:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	74 0b                	je     801503 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	56                   	push   %esi
  8014fc:	ff d0                	call   *%eax
  8014fe:	89 c3                	mov    %eax,%ebx
  801500:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	56                   	push   %esi
  801507:	6a 00                	push   $0x0
  801509:	e8 87 f7 ff ff       	call   800c95 <sys_page_unmap>
	return r;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	eb b5                	jmp    8014c8 <fd_close+0x40>

00801513 <close>:

int
close(int fdnum)
{
  801513:	f3 0f 1e fb          	endbr32 
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	e8 b1 fe ff ff       	call   8013da <fd_lookup>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	79 02                	jns    801532 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    
		return fd_close(fd, 1);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	6a 01                	push   $0x1
  801537:	ff 75 f4             	pushl  -0xc(%ebp)
  80153a:	e8 49 ff ff ff       	call   801488 <fd_close>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	eb ec                	jmp    801530 <close+0x1d>

00801544 <close_all>:

void
close_all(void)
{
  801544:	f3 0f 1e fb          	endbr32 
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
  80154c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80154f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	53                   	push   %ebx
  801558:	e8 b6 ff ff ff       	call   801513 <close>
	for (i = 0; i < MAXFD; i++)
  80155d:	83 c3 01             	add    $0x1,%ebx
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	83 fb 20             	cmp    $0x20,%ebx
  801566:	75 ec                	jne    801554 <close_all+0x10>
}
  801568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80156d:	f3 0f 1e fb          	endbr32 
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	57                   	push   %edi
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
  801577:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80157a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80157d:	50                   	push   %eax
  80157e:	ff 75 08             	pushl  0x8(%ebp)
  801581:	e8 54 fe ff ff       	call   8013da <fd_lookup>
  801586:	89 c3                	mov    %eax,%ebx
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	0f 88 81 00 00 00    	js     801614 <dup+0xa7>
		return r;
	close(newfdnum);
  801593:	83 ec 0c             	sub    $0xc,%esp
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	e8 75 ff ff ff       	call   801513 <close>

	newfd = INDEX2FD(newfdnum);
  80159e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015a1:	c1 e6 0c             	shl    $0xc,%esi
  8015a4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015aa:	83 c4 04             	add    $0x4,%esp
  8015ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015b0:	e8 b0 fd ff ff       	call   801365 <fd2data>
  8015b5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015b7:	89 34 24             	mov    %esi,(%esp)
  8015ba:	e8 a6 fd ff ff       	call   801365 <fd2data>
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015c4:	89 d8                	mov    %ebx,%eax
  8015c6:	c1 e8 16             	shr    $0x16,%eax
  8015c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015d0:	a8 01                	test   $0x1,%al
  8015d2:	74 11                	je     8015e5 <dup+0x78>
  8015d4:	89 d8                	mov    %ebx,%eax
  8015d6:	c1 e8 0c             	shr    $0xc,%eax
  8015d9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015e0:	f6 c2 01             	test   $0x1,%dl
  8015e3:	75 39                	jne    80161e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e8:	89 d0                	mov    %edx,%eax
  8015ea:	c1 e8 0c             	shr    $0xc,%eax
  8015ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015fc:	50                   	push   %eax
  8015fd:	56                   	push   %esi
  8015fe:	6a 00                	push   $0x0
  801600:	52                   	push   %edx
  801601:	6a 00                	push   $0x0
  801603:	e8 63 f6 ff ff       	call   800c6b <sys_page_map>
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	83 c4 20             	add    $0x20,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 31                	js     801642 <dup+0xd5>
		goto err;

	return newfdnum;
  801611:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801614:	89 d8                	mov    %ebx,%eax
  801616:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80161e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	25 07 0e 00 00       	and    $0xe07,%eax
  80162d:	50                   	push   %eax
  80162e:	57                   	push   %edi
  80162f:	6a 00                	push   $0x0
  801631:	53                   	push   %ebx
  801632:	6a 00                	push   $0x0
  801634:	e8 32 f6 ff ff       	call   800c6b <sys_page_map>
  801639:	89 c3                	mov    %eax,%ebx
  80163b:	83 c4 20             	add    $0x20,%esp
  80163e:	85 c0                	test   %eax,%eax
  801640:	79 a3                	jns    8015e5 <dup+0x78>
	sys_page_unmap(0, newfd);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	56                   	push   %esi
  801646:	6a 00                	push   $0x0
  801648:	e8 48 f6 ff ff       	call   800c95 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80164d:	83 c4 08             	add    $0x8,%esp
  801650:	57                   	push   %edi
  801651:	6a 00                	push   $0x0
  801653:	e8 3d f6 ff ff       	call   800c95 <sys_page_unmap>
	return r;
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	eb b7                	jmp    801614 <dup+0xa7>

0080165d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80165d:	f3 0f 1e fb          	endbr32 
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	53                   	push   %ebx
  801665:	83 ec 1c             	sub    $0x1c,%esp
  801668:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166e:	50                   	push   %eax
  80166f:	53                   	push   %ebx
  801670:	e8 65 fd ff ff       	call   8013da <fd_lookup>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 3f                	js     8016bb <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801682:	50                   	push   %eax
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	ff 30                	pushl  (%eax)
  801688:	e8 a1 fd ff ff       	call   80142e <dev_lookup>
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	78 27                	js     8016bb <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801697:	8b 42 08             	mov    0x8(%edx),%eax
  80169a:	83 e0 03             	and    $0x3,%eax
  80169d:	83 f8 01             	cmp    $0x1,%eax
  8016a0:	74 1e                	je     8016c0 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	8b 40 08             	mov    0x8(%eax),%eax
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	74 35                	je     8016e1 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	ff 75 10             	pushl  0x10(%ebp)
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	52                   	push   %edx
  8016b6:	ff d0                	call   *%eax
  8016b8:	83 c4 10             	add    $0x10,%esp
}
  8016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8016c5:	8b 40 48             	mov    0x48(%eax),%eax
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	53                   	push   %ebx
  8016cc:	50                   	push   %eax
  8016cd:	68 99 29 80 00       	push   $0x802999
  8016d2:	e8 7a eb ff ff       	call   800251 <cprintf>
		return -E_INVAL;
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016df:	eb da                	jmp    8016bb <read+0x5e>
		return -E_NOT_SUPP;
  8016e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e6:	eb d3                	jmp    8016bb <read+0x5e>

008016e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016e8:	f3 0f 1e fb          	endbr32 
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	57                   	push   %edi
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801700:	eb 02                	jmp    801704 <readn+0x1c>
  801702:	01 c3                	add    %eax,%ebx
  801704:	39 f3                	cmp    %esi,%ebx
  801706:	73 21                	jae    801729 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	89 f0                	mov    %esi,%eax
  80170d:	29 d8                	sub    %ebx,%eax
  80170f:	50                   	push   %eax
  801710:	89 d8                	mov    %ebx,%eax
  801712:	03 45 0c             	add    0xc(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	57                   	push   %edi
  801717:	e8 41 ff ff ff       	call   80165d <read>
		if (m < 0)
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 04                	js     801727 <readn+0x3f>
			return m;
		if (m == 0)
  801723:	75 dd                	jne    801702 <readn+0x1a>
  801725:	eb 02                	jmp    801729 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801727:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172e:	5b                   	pop    %ebx
  80172f:	5e                   	pop    %esi
  801730:	5f                   	pop    %edi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801733:	f3 0f 1e fb          	endbr32 
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 1c             	sub    $0x1c,%esp
  80173e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801744:	50                   	push   %eax
  801745:	53                   	push   %ebx
  801746:	e8 8f fc ff ff       	call   8013da <fd_lookup>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 3a                	js     80178c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	ff 30                	pushl  (%eax)
  80175e:	e8 cb fc ff ff       	call   80142e <dev_lookup>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	78 22                	js     80178c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801771:	74 1e                	je     801791 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	8b 52 0c             	mov    0xc(%edx),%edx
  801779:	85 d2                	test   %edx,%edx
  80177b:	74 35                	je     8017b2 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	ff 75 10             	pushl  0x10(%ebp)
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	50                   	push   %eax
  801787:	ff d2                	call   *%edx
  801789:	83 c4 10             	add    $0x10,%esp
}
  80178c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178f:	c9                   	leave  
  801790:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801791:	a1 04 40 80 00       	mov    0x804004,%eax
  801796:	8b 40 48             	mov    0x48(%eax),%eax
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	53                   	push   %ebx
  80179d:	50                   	push   %eax
  80179e:	68 b5 29 80 00       	push   $0x8029b5
  8017a3:	e8 a9 ea ff ff       	call   800251 <cprintf>
		return -E_INVAL;
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b0:	eb da                	jmp    80178c <write+0x59>
		return -E_NOT_SUPP;
  8017b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b7:	eb d3                	jmp    80178c <write+0x59>

008017b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017b9:	f3 0f 1e fb          	endbr32 
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 0b fc ff ff       	call   8013da <fd_lookup>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 0e                	js     8017e4 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017e6:	f3 0f 1e fb          	endbr32 
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f7:	50                   	push   %eax
  8017f8:	53                   	push   %ebx
  8017f9:	e8 dc fb ff ff       	call   8013da <fd_lookup>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	85 c0                	test   %eax,%eax
  801803:	78 37                	js     80183c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180b:	50                   	push   %eax
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180f:	ff 30                	pushl  (%eax)
  801811:	e8 18 fc ff ff       	call   80142e <dev_lookup>
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 1f                	js     80183c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801820:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801824:	74 1b                	je     801841 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801829:	8b 52 18             	mov    0x18(%edx),%edx
  80182c:	85 d2                	test   %edx,%edx
  80182e:	74 32                	je     801862 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	50                   	push   %eax
  801837:	ff d2                	call   *%edx
  801839:	83 c4 10             	add    $0x10,%esp
}
  80183c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183f:	c9                   	leave  
  801840:	c3                   	ret    
			thisenv->env_id, fdnum);
  801841:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801846:	8b 40 48             	mov    0x48(%eax),%eax
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	53                   	push   %ebx
  80184d:	50                   	push   %eax
  80184e:	68 78 29 80 00       	push   $0x802978
  801853:	e8 f9 e9 ff ff       	call   800251 <cprintf>
		return -E_INVAL;
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801860:	eb da                	jmp    80183c <ftruncate+0x56>
		return -E_NOT_SUPP;
  801862:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801867:	eb d3                	jmp    80183c <ftruncate+0x56>

00801869 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801869:	f3 0f 1e fb          	endbr32 
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	53                   	push   %ebx
  801871:	83 ec 1c             	sub    $0x1c,%esp
  801874:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801877:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187a:	50                   	push   %eax
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	e8 57 fb ff ff       	call   8013da <fd_lookup>
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	85 c0                	test   %eax,%eax
  801888:	78 4b                	js     8018d5 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801890:	50                   	push   %eax
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	ff 30                	pushl  (%eax)
  801896:	e8 93 fb ff ff       	call   80142e <dev_lookup>
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 33                	js     8018d5 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018a9:	74 2f                	je     8018da <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018ab:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ae:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018b5:	00 00 00 
	stat->st_isdir = 0;
  8018b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018bf:	00 00 00 
	stat->st_dev = dev;
  8018c2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	53                   	push   %ebx
  8018cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cf:	ff 50 14             	call   *0x14(%eax)
  8018d2:	83 c4 10             	add    $0x10,%esp
}
  8018d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    
		return -E_NOT_SUPP;
  8018da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018df:	eb f4                	jmp    8018d5 <fstat+0x6c>

008018e1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018e1:	f3 0f 1e fb          	endbr32 
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 08             	pushl  0x8(%ebp)
  8018f2:	e8 3a 02 00 00       	call   801b31 <open>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 1b                	js     80191b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	50                   	push   %eax
  801907:	e8 5d ff ff ff       	call   801869 <fstat>
  80190c:	89 c6                	mov    %eax,%esi
	close(fd);
  80190e:	89 1c 24             	mov    %ebx,(%esp)
  801911:	e8 fd fb ff ff       	call   801513 <close>
	return r;
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	89 f3                	mov    %esi,%ebx
}
  80191b:	89 d8                	mov    %ebx,%eax
  80191d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5d                   	pop    %ebp
  801923:	c3                   	ret    

00801924 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	89 c6                	mov    %eax,%esi
  80192b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80192d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801934:	74 27                	je     80195d <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801936:	6a 07                	push   $0x7
  801938:	68 00 50 80 00       	push   $0x805000
  80193d:	56                   	push   %esi
  80193e:	ff 35 00 40 80 00    	pushl  0x804000
  801944:	e8 73 f9 ff ff       	call   8012bc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801949:	83 c4 0c             	add    $0xc,%esp
  80194c:	6a 00                	push   $0x0
  80194e:	53                   	push   %ebx
  80194f:	6a 00                	push   $0x0
  801951:	e8 f9 f8 ff ff       	call   80124f <ipc_recv>
}
  801956:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	6a 01                	push   $0x1
  801962:	e8 ad f9 ff ff       	call   801314 <ipc_find_env>
  801967:	a3 00 40 80 00       	mov    %eax,0x804000
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	eb c5                	jmp    801936 <fsipc+0x12>

00801971 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801971:	f3 0f 1e fb          	endbr32 
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8b 40 0c             	mov    0xc(%eax),%eax
  801981:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	b8 02 00 00 00       	mov    $0x2,%eax
  801998:	e8 87 ff ff ff       	call   801924 <fsipc>
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <devfile_flush>:
{
  80199f:	f3 0f 1e fb          	endbr32 
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8019af:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019be:	e8 61 ff ff ff       	call   801924 <fsipc>
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <devfile_stat>:
{
  8019c5:	f3 0f 1e fb          	endbr32 
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 05 00 00 00       	mov    $0x5,%eax
  8019e8:	e8 37 ff ff ff       	call   801924 <fsipc>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 2c                	js     801a1d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	68 00 50 80 00       	push   $0x805000
  8019f9:	53                   	push   %ebx
  8019fa:	e8 bc ed ff ff       	call   8007bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019ff:	a1 80 50 80 00       	mov    0x805080,%eax
  801a04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a0a:	a1 84 50 80 00       	mov    0x805084,%eax
  801a0f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <devfile_write>:
{
  801a22:	f3 0f 1e fb          	endbr32 
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	53                   	push   %ebx
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 40 0c             	mov    0xc(%eax),%eax
  801a36:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a3b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a41:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a47:	77 30                	ja     801a79 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	53                   	push   %ebx
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	68 08 50 80 00       	push   $0x805008
  801a55:	e8 19 ef ff ff       	call   800973 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	b8 04 00 00 00       	mov    $0x4,%eax
  801a64:	e8 bb fe ff ff       	call   801924 <fsipc>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 04                	js     801a74 <devfile_write+0x52>
	assert(r <= n);
  801a70:	39 d8                	cmp    %ebx,%eax
  801a72:	77 1e                	ja     801a92 <devfile_write+0x70>
}
  801a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a79:	68 e4 29 80 00       	push   $0x8029e4
  801a7e:	68 11 2a 80 00       	push   $0x802a11
  801a83:	68 94 00 00 00       	push   $0x94
  801a88:	68 26 2a 80 00       	push   $0x802a26
  801a8d:	e8 d8 e6 ff ff       	call   80016a <_panic>
	assert(r <= n);
  801a92:	68 31 2a 80 00       	push   $0x802a31
  801a97:	68 11 2a 80 00       	push   $0x802a11
  801a9c:	68 98 00 00 00       	push   $0x98
  801aa1:	68 26 2a 80 00       	push   $0x802a26
  801aa6:	e8 bf e6 ff ff       	call   80016a <_panic>

00801aab <devfile_read>:
{
  801aab:	f3 0f 1e fb          	endbr32 
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8b 40 0c             	mov    0xc(%eax),%eax
  801abd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ac2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  801acd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad2:	e8 4d fe ff ff       	call   801924 <fsipc>
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 1f                	js     801afc <devfile_read+0x51>
	assert(r <= n);
  801add:	39 f0                	cmp    %esi,%eax
  801adf:	77 24                	ja     801b05 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801ae1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae6:	7f 33                	jg     801b1b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	50                   	push   %eax
  801aec:	68 00 50 80 00       	push   $0x805000
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	e8 7a ee ff ff       	call   800973 <memmove>
	return r;
  801af9:	83 c4 10             	add    $0x10,%esp
}
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
	assert(r <= n);
  801b05:	68 31 2a 80 00       	push   $0x802a31
  801b0a:	68 11 2a 80 00       	push   $0x802a11
  801b0f:	6a 7c                	push   $0x7c
  801b11:	68 26 2a 80 00       	push   $0x802a26
  801b16:	e8 4f e6 ff ff       	call   80016a <_panic>
	assert(r <= PGSIZE);
  801b1b:	68 38 2a 80 00       	push   $0x802a38
  801b20:	68 11 2a 80 00       	push   $0x802a11
  801b25:	6a 7d                	push   $0x7d
  801b27:	68 26 2a 80 00       	push   $0x802a26
  801b2c:	e8 39 e6 ff ff       	call   80016a <_panic>

00801b31 <open>:
{
  801b31:	f3 0f 1e fb          	endbr32 
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 1c             	sub    $0x1c,%esp
  801b3d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b40:	56                   	push   %esi
  801b41:	e8 32 ec ff ff       	call   800778 <strlen>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4e:	7f 6c                	jg     801bbc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	e8 28 f8 ff ff       	call   801384 <fd_alloc>
  801b5c:	89 c3                	mov    %eax,%ebx
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 3c                	js     801ba1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	56                   	push   %esi
  801b69:	68 00 50 80 00       	push   $0x805000
  801b6e:	e8 48 ec ff ff       	call   8007bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	e8 9c fd ff ff       	call   801924 <fsipc>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 19                	js     801baa <open+0x79>
	return fd2num(fd);
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	e8 b5 f7 ff ff       	call   801351 <fd2num>
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	83 c4 10             	add    $0x10,%esp
}
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
		fd_close(fd, 0);
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb2:	e8 d1 f8 ff ff       	call   801488 <fd_close>
		return r;
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb e5                	jmp    801ba1 <open+0x70>
		return -E_BAD_PATH;
  801bbc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bc1:	eb de                	jmp    801ba1 <open+0x70>

00801bc3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bc3:	f3 0f 1e fb          	endbr32 
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd7:	e8 48 fd ff ff       	call   801924 <fsipc>
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bde:	f3 0f 1e fb          	endbr32 
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
  801be7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	e8 70 f7 ff ff       	call   801365 <fd2data>
  801bf5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bf7:	83 c4 08             	add    $0x8,%esp
  801bfa:	68 44 2a 80 00       	push   $0x802a44
  801bff:	53                   	push   %ebx
  801c00:	e8 b6 eb ff ff       	call   8007bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c05:	8b 46 04             	mov    0x4(%esi),%eax
  801c08:	2b 06                	sub    (%esi),%eax
  801c0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c17:	00 00 00 
	stat->st_dev = &devpipe;
  801c1a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c21:	30 80 00 
	return 0;
}
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c3e:	53                   	push   %ebx
  801c3f:	6a 00                	push   $0x0
  801c41:	e8 4f f0 ff ff       	call   800c95 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c46:	89 1c 24             	mov    %ebx,(%esp)
  801c49:	e8 17 f7 ff ff       	call   801365 <fd2data>
  801c4e:	83 c4 08             	add    $0x8,%esp
  801c51:	50                   	push   %eax
  801c52:	6a 00                	push   $0x0
  801c54:	e8 3c f0 ff ff       	call   800c95 <sys_page_unmap>
}
  801c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <_pipeisclosed>:
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	57                   	push   %edi
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
  801c64:	83 ec 1c             	sub    $0x1c,%esp
  801c67:	89 c7                	mov    %eax,%edi
  801c69:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c6b:	a1 04 40 80 00       	mov    0x804004,%eax
  801c70:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	57                   	push   %edi
  801c77:	e8 00 05 00 00       	call   80217c <pageref>
  801c7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c7f:	89 34 24             	mov    %esi,(%esp)
  801c82:	e8 f5 04 00 00       	call   80217c <pageref>
		nn = thisenv->env_runs;
  801c87:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c8d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c90:	83 c4 10             	add    $0x10,%esp
  801c93:	39 cb                	cmp    %ecx,%ebx
  801c95:	74 1b                	je     801cb2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c9a:	75 cf                	jne    801c6b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c9c:	8b 42 58             	mov    0x58(%edx),%eax
  801c9f:	6a 01                	push   $0x1
  801ca1:	50                   	push   %eax
  801ca2:	53                   	push   %ebx
  801ca3:	68 4b 2a 80 00       	push   $0x802a4b
  801ca8:	e8 a4 e5 ff ff       	call   800251 <cprintf>
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	eb b9                	jmp    801c6b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cb2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cb5:	0f 94 c0             	sete   %al
  801cb8:	0f b6 c0             	movzbl %al,%eax
}
  801cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cbe:	5b                   	pop    %ebx
  801cbf:	5e                   	pop    %esi
  801cc0:	5f                   	pop    %edi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <devpipe_write>:
{
  801cc3:	f3 0f 1e fb          	endbr32 
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	57                   	push   %edi
  801ccb:	56                   	push   %esi
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 28             	sub    $0x28,%esp
  801cd0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cd3:	56                   	push   %esi
  801cd4:	e8 8c f6 ff ff       	call   801365 <fd2data>
  801cd9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ce6:	74 4f                	je     801d37 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ce8:	8b 43 04             	mov    0x4(%ebx),%eax
  801ceb:	8b 0b                	mov    (%ebx),%ecx
  801ced:	8d 51 20             	lea    0x20(%ecx),%edx
  801cf0:	39 d0                	cmp    %edx,%eax
  801cf2:	72 14                	jb     801d08 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801cf4:	89 da                	mov    %ebx,%edx
  801cf6:	89 f0                	mov    %esi,%eax
  801cf8:	e8 61 ff ff ff       	call   801c5e <_pipeisclosed>
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	75 3b                	jne    801d3c <devpipe_write+0x79>
			sys_yield();
  801d01:	e8 12 ef ff ff       	call   800c18 <sys_yield>
  801d06:	eb e0                	jmp    801ce8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d0b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d0f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d12:	89 c2                	mov    %eax,%edx
  801d14:	c1 fa 1f             	sar    $0x1f,%edx
  801d17:	89 d1                	mov    %edx,%ecx
  801d19:	c1 e9 1b             	shr    $0x1b,%ecx
  801d1c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d1f:	83 e2 1f             	and    $0x1f,%edx
  801d22:	29 ca                	sub    %ecx,%edx
  801d24:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d28:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d2c:	83 c0 01             	add    $0x1,%eax
  801d2f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d32:	83 c7 01             	add    $0x1,%edi
  801d35:	eb ac                	jmp    801ce3 <devpipe_write+0x20>
	return i;
  801d37:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3a:	eb 05                	jmp    801d41 <devpipe_write+0x7e>
				return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    

00801d49 <devpipe_read>:
{
  801d49:	f3 0f 1e fb          	endbr32 
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	57                   	push   %edi
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	83 ec 18             	sub    $0x18,%esp
  801d56:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d59:	57                   	push   %edi
  801d5a:	e8 06 f6 ff ff       	call   801365 <fd2data>
  801d5f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	be 00 00 00 00       	mov    $0x0,%esi
  801d69:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d6c:	75 14                	jne    801d82 <devpipe_read+0x39>
	return i;
  801d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d71:	eb 02                	jmp    801d75 <devpipe_read+0x2c>
				return i;
  801d73:	89 f0                	mov    %esi,%eax
}
  801d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
			sys_yield();
  801d7d:	e8 96 ee ff ff       	call   800c18 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d82:	8b 03                	mov    (%ebx),%eax
  801d84:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d87:	75 18                	jne    801da1 <devpipe_read+0x58>
			if (i > 0)
  801d89:	85 f6                	test   %esi,%esi
  801d8b:	75 e6                	jne    801d73 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d8d:	89 da                	mov    %ebx,%edx
  801d8f:	89 f8                	mov    %edi,%eax
  801d91:	e8 c8 fe ff ff       	call   801c5e <_pipeisclosed>
  801d96:	85 c0                	test   %eax,%eax
  801d98:	74 e3                	je     801d7d <devpipe_read+0x34>
				return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9f:	eb d4                	jmp    801d75 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801da1:	99                   	cltd   
  801da2:	c1 ea 1b             	shr    $0x1b,%edx
  801da5:	01 d0                	add    %edx,%eax
  801da7:	83 e0 1f             	and    $0x1f,%eax
  801daa:	29 d0                	sub    %edx,%eax
  801dac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801db7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dba:	83 c6 01             	add    $0x1,%esi
  801dbd:	eb aa                	jmp    801d69 <devpipe_read+0x20>

00801dbf <pipe>:
{
  801dbf:	f3 0f 1e fb          	endbr32 
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dce:	50                   	push   %eax
  801dcf:	e8 b0 f5 ff ff       	call   801384 <fd_alloc>
  801dd4:	89 c3                	mov    %eax,%ebx
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	0f 88 23 01 00 00    	js     801f04 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	68 07 04 00 00       	push   $0x407
  801de9:	ff 75 f4             	pushl  -0xc(%ebp)
  801dec:	6a 00                	push   $0x0
  801dee:	e8 50 ee ff ff       	call   800c43 <sys_page_alloc>
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 88 04 01 00 00    	js     801f04 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e06:	50                   	push   %eax
  801e07:	e8 78 f5 ff ff       	call   801384 <fd_alloc>
  801e0c:	89 c3                	mov    %eax,%ebx
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	85 c0                	test   %eax,%eax
  801e13:	0f 88 db 00 00 00    	js     801ef4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	68 07 04 00 00       	push   $0x407
  801e21:	ff 75 f0             	pushl  -0x10(%ebp)
  801e24:	6a 00                	push   $0x0
  801e26:	e8 18 ee ff ff       	call   800c43 <sys_page_alloc>
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	0f 88 bc 00 00 00    	js     801ef4 <pipe+0x135>
	va = fd2data(fd0);
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3e:	e8 22 f5 ff ff       	call   801365 <fd2data>
  801e43:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e45:	83 c4 0c             	add    $0xc,%esp
  801e48:	68 07 04 00 00       	push   $0x407
  801e4d:	50                   	push   %eax
  801e4e:	6a 00                	push   $0x0
  801e50:	e8 ee ed ff ff       	call   800c43 <sys_page_alloc>
  801e55:	89 c3                	mov    %eax,%ebx
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 88 82 00 00 00    	js     801ee4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 f0             	pushl  -0x10(%ebp)
  801e68:	e8 f8 f4 ff ff       	call   801365 <fd2data>
  801e6d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e74:	50                   	push   %eax
  801e75:	6a 00                	push   $0x0
  801e77:	56                   	push   %esi
  801e78:	6a 00                	push   $0x0
  801e7a:	e8 ec ed ff ff       	call   800c6b <sys_page_map>
  801e7f:	89 c3                	mov    %eax,%ebx
  801e81:	83 c4 20             	add    $0x20,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	78 4e                	js     801ed6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e88:	a1 20 30 80 00       	mov    0x803020,%eax
  801e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e90:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e9f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb1:	e8 9b f4 ff ff       	call   801351 <fd2num>
  801eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ebb:	83 c4 04             	add    $0x4,%esp
  801ebe:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec1:	e8 8b f4 ff ff       	call   801351 <fd2num>
  801ec6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ec9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ed4:	eb 2e                	jmp    801f04 <pipe+0x145>
	sys_page_unmap(0, va);
  801ed6:	83 ec 08             	sub    $0x8,%esp
  801ed9:	56                   	push   %esi
  801eda:	6a 00                	push   $0x0
  801edc:	e8 b4 ed ff ff       	call   800c95 <sys_page_unmap>
  801ee1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eea:	6a 00                	push   $0x0
  801eec:	e8 a4 ed ff ff       	call   800c95 <sys_page_unmap>
  801ef1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ef4:	83 ec 08             	sub    $0x8,%esp
  801ef7:	ff 75 f4             	pushl  -0xc(%ebp)
  801efa:	6a 00                	push   $0x0
  801efc:	e8 94 ed ff ff       	call   800c95 <sys_page_unmap>
  801f01:	83 c4 10             	add    $0x10,%esp
}
  801f04:	89 d8                	mov    %ebx,%eax
  801f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f09:	5b                   	pop    %ebx
  801f0a:	5e                   	pop    %esi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    

00801f0d <pipeisclosed>:
{
  801f0d:	f3 0f 1e fb          	endbr32 
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1a:	50                   	push   %eax
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 b7 f4 ff ff       	call   8013da <fd_lookup>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 18                	js     801f42 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	e8 30 f4 ff ff       	call   801365 <fd2data>
  801f35:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	e8 1f fd ff ff       	call   801c5e <_pipeisclosed>
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f44:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4d:	c3                   	ret    

00801f4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f4e:	f3 0f 1e fb          	endbr32 
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f58:	68 63 2a 80 00       	push   $0x802a63
  801f5d:	ff 75 0c             	pushl  0xc(%ebp)
  801f60:	e8 56 e8 ff ff       	call   8007bb <strcpy>
	return 0;
}
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <devcons_write>:
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	57                   	push   %edi
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f7c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f81:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f87:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f8a:	73 31                	jae    801fbd <devcons_write+0x51>
		m = n - tot;
  801f8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f8f:	29 f3                	sub    %esi,%ebx
  801f91:	83 fb 7f             	cmp    $0x7f,%ebx
  801f94:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f99:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	53                   	push   %ebx
  801fa0:	89 f0                	mov    %esi,%eax
  801fa2:	03 45 0c             	add    0xc(%ebp),%eax
  801fa5:	50                   	push   %eax
  801fa6:	57                   	push   %edi
  801fa7:	e8 c7 e9 ff ff       	call   800973 <memmove>
		sys_cputs(buf, m);
  801fac:	83 c4 08             	add    $0x8,%esp
  801faf:	53                   	push   %ebx
  801fb0:	57                   	push   %edi
  801fb1:	e8 c2 eb ff ff       	call   800b78 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fb6:	01 de                	add    %ebx,%esi
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	eb ca                	jmp    801f87 <devcons_write+0x1b>
}
  801fbd:	89 f0                	mov    %esi,%eax
  801fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5f                   	pop    %edi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <devcons_read>:
{
  801fc7:	f3 0f 1e fb          	endbr32 
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fda:	74 21                	je     801ffd <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801fdc:	e8 c1 eb ff ff       	call   800ba2 <sys_cgetc>
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	75 07                	jne    801fec <devcons_read+0x25>
		sys_yield();
  801fe5:	e8 2e ec ff ff       	call   800c18 <sys_yield>
  801fea:	eb f0                	jmp    801fdc <devcons_read+0x15>
	if (c < 0)
  801fec:	78 0f                	js     801ffd <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fee:	83 f8 04             	cmp    $0x4,%eax
  801ff1:	74 0c                	je     801fff <devcons_read+0x38>
	*(char*)vbuf = c;
  801ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff6:	88 02                	mov    %al,(%edx)
	return 1;
  801ff8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	eb f7                	jmp    801ffd <devcons_read+0x36>

00802006 <cputchar>:
{
  802006:	f3 0f 1e fb          	endbr32 
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802016:	6a 01                	push   $0x1
  802018:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80201b:	50                   	push   %eax
  80201c:	e8 57 eb ff ff       	call   800b78 <sys_cputs>
}
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <getchar>:
{
  802026:	f3 0f 1e fb          	endbr32 
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802030:	6a 01                	push   $0x1
  802032:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802035:	50                   	push   %eax
  802036:	6a 00                	push   $0x0
  802038:	e8 20 f6 ff ff       	call   80165d <read>
	if (r < 0)
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	78 06                	js     80204a <getchar+0x24>
	if (r < 1)
  802044:	74 06                	je     80204c <getchar+0x26>
	return c;
  802046:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    
		return -E_EOF;
  80204c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802051:	eb f7                	jmp    80204a <getchar+0x24>

00802053 <iscons>:
{
  802053:	f3 0f 1e fb          	endbr32 
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	e8 71 f3 ff ff       	call   8013da <fd_lookup>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	85 c0                	test   %eax,%eax
  80206e:	78 11                	js     802081 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802079:	39 10                	cmp    %edx,(%eax)
  80207b:	0f 94 c0             	sete   %al
  80207e:	0f b6 c0             	movzbl %al,%eax
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <opencons>:
{
  802083:	f3 0f 1e fb          	endbr32 
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80208d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802090:	50                   	push   %eax
  802091:	e8 ee f2 ff ff       	call   801384 <fd_alloc>
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 3a                	js     8020d7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 07 04 00 00       	push   $0x407
  8020a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a8:	6a 00                	push   $0x0
  8020aa:	e8 94 eb ff ff       	call   800c43 <sys_page_alloc>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 21                	js     8020d7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020bf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	50                   	push   %eax
  8020cf:	e8 7d f2 ff ff       	call   801351 <fd2num>
  8020d4:	83 c4 10             	add    $0x10,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020d9:	f3 0f 1e fb          	endbr32 
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020e3:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020ea:	74 0a                	je     8020f6 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  8020f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8020fb:	8b 40 48             	mov    0x48(%eax),%eax
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	6a 07                	push   $0x7
  802103:	68 00 f0 bf ee       	push   $0xeebff000
  802108:	50                   	push   %eax
  802109:	e8 35 eb ff ff       	call   800c43 <sys_page_alloc>
		if (r!= 0)
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	75 2f                	jne    802144 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802115:	a1 04 40 80 00       	mov    0x804004,%eax
  80211a:	8b 40 48             	mov    0x48(%eax),%eax
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	68 56 21 80 00       	push   $0x802156
  802125:	50                   	push   %eax
  802126:	e8 df eb ff ff       	call   800d0a <sys_env_set_pgfault_upcall>
		if (r!= 0)
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 ba                	je     8020ec <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802132:	50                   	push   %eax
  802133:	68 6f 2a 80 00       	push   $0x802a6f
  802138:	6a 26                	push   $0x26
  80213a:	68 87 2a 80 00       	push   $0x802a87
  80213f:	e8 26 e0 ff ff       	call   80016a <_panic>
			panic("set_pgfault_handler: %e", r);
  802144:	50                   	push   %eax
  802145:	68 6f 2a 80 00       	push   $0x802a6f
  80214a:	6a 22                	push   $0x22
  80214c:	68 87 2a 80 00       	push   $0x802a87
  802151:	e8 14 e0 ff ff       	call   80016a <_panic>

00802156 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802156:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802157:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80215c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80215e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802161:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  802165:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802168:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  80216c:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802170:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802172:	83 c4 08             	add    $0x8,%esp
	popal
  802175:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802176:	83 c4 04             	add    $0x4,%esp
	popfl
  802179:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80217a:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80217b:	c3                   	ret    

0080217c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80217c:	f3 0f 1e fb          	endbr32 
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802186:	89 c2                	mov    %eax,%edx
  802188:	c1 ea 16             	shr    $0x16,%edx
  80218b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802192:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802197:	f6 c1 01             	test   $0x1,%cl
  80219a:	74 1c                	je     8021b8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80219c:	c1 e8 0c             	shr    $0xc,%eax
  80219f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021a6:	a8 01                	test   $0x1,%al
  8021a8:	74 0e                	je     8021b8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021aa:	c1 e8 0c             	shr    $0xc,%eax
  8021ad:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021b4:	ef 
  8021b5:	0f b7 d2             	movzwl %dx,%edx
}
  8021b8:	89 d0                	mov    %edx,%eax
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__udivdi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021db:	85 d2                	test   %edx,%edx
  8021dd:	75 19                	jne    8021f8 <__udivdi3+0x38>
  8021df:	39 f3                	cmp    %esi,%ebx
  8021e1:	76 4d                	jbe    802230 <__udivdi3+0x70>
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	89 e8                	mov    %ebp,%eax
  8021e7:	89 f2                	mov    %esi,%edx
  8021e9:	f7 f3                	div    %ebx
  8021eb:	89 fa                	mov    %edi,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	76 14                	jbe    802210 <__udivdi3+0x50>
  8021fc:	31 ff                	xor    %edi,%edi
  8021fe:	31 c0                	xor    %eax,%eax
  802200:	89 fa                	mov    %edi,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd fa             	bsr    %edx,%edi
  802213:	83 f7 1f             	xor    $0x1f,%edi
  802216:	75 48                	jne    802260 <__udivdi3+0xa0>
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	72 06                	jb     802222 <__udivdi3+0x62>
  80221c:	31 c0                	xor    %eax,%eax
  80221e:	39 eb                	cmp    %ebp,%ebx
  802220:	77 de                	ja     802200 <__udivdi3+0x40>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	eb d7                	jmp    802200 <__udivdi3+0x40>
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 d9                	mov    %ebx,%ecx
  802232:	85 db                	test   %ebx,%ebx
  802234:	75 0b                	jne    802241 <__udivdi3+0x81>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f3                	div    %ebx
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	31 d2                	xor    %edx,%edx
  802243:	89 f0                	mov    %esi,%eax
  802245:	f7 f1                	div    %ecx
  802247:	89 c6                	mov    %eax,%esi
  802249:	89 e8                	mov    %ebp,%eax
  80224b:	89 f7                	mov    %esi,%edi
  80224d:	f7 f1                	div    %ecx
  80224f:	89 fa                	mov    %edi,%edx
  802251:	83 c4 1c             	add    $0x1c,%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5f                   	pop    %edi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 f9                	mov    %edi,%ecx
  802262:	b8 20 00 00 00       	mov    $0x20,%eax
  802267:	29 f8                	sub    %edi,%eax
  802269:	d3 e2                	shl    %cl,%edx
  80226b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 da                	mov    %ebx,%edx
  802273:	d3 ea                	shr    %cl,%edx
  802275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802279:	09 d1                	or     %edx,%ecx
  80227b:	89 f2                	mov    %esi,%edx
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 f9                	mov    %edi,%ecx
  802283:	d3 e3                	shl    %cl,%ebx
  802285:	89 c1                	mov    %eax,%ecx
  802287:	d3 ea                	shr    %cl,%edx
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80228f:	89 eb                	mov    %ebp,%ebx
  802291:	d3 e6                	shl    %cl,%esi
  802293:	89 c1                	mov    %eax,%ecx
  802295:	d3 eb                	shr    %cl,%ebx
  802297:	09 de                	or     %ebx,%esi
  802299:	89 f0                	mov    %esi,%eax
  80229b:	f7 74 24 08          	divl   0x8(%esp)
  80229f:	89 d6                	mov    %edx,%esi
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	f7 64 24 0c          	mull   0xc(%esp)
  8022a7:	39 d6                	cmp    %edx,%esi
  8022a9:	72 15                	jb     8022c0 <__udivdi3+0x100>
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e5                	shl    %cl,%ebp
  8022af:	39 c5                	cmp    %eax,%ebp
  8022b1:	73 04                	jae    8022b7 <__udivdi3+0xf7>
  8022b3:	39 d6                	cmp    %edx,%esi
  8022b5:	74 09                	je     8022c0 <__udivdi3+0x100>
  8022b7:	89 d8                	mov    %ebx,%eax
  8022b9:	31 ff                	xor    %edi,%edi
  8022bb:	e9 40 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	e9 36 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	66 90                	xchg   %ax,%ax
  8022ce:	66 90                	xchg   %ax,%ax

008022d0 <__umoddi3>:
  8022d0:	f3 0f 1e fb          	endbr32 
  8022d4:	55                   	push   %ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 19                	jne    802308 <__umoddi3+0x38>
  8022ef:	39 df                	cmp    %ebx,%edi
  8022f1:	76 5d                	jbe    802350 <__umoddi3+0x80>
  8022f3:	89 f0                	mov    %esi,%eax
  8022f5:	89 da                	mov    %ebx,%edx
  8022f7:	f7 f7                	div    %edi
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	83 c4 1c             	add    $0x1c,%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	89 f2                	mov    %esi,%edx
  80230a:	39 d8                	cmp    %ebx,%eax
  80230c:	76 12                	jbe    802320 <__umoddi3+0x50>
  80230e:	89 f0                	mov    %esi,%eax
  802310:	89 da                	mov    %ebx,%edx
  802312:	83 c4 1c             	add    $0x1c,%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802320:	0f bd e8             	bsr    %eax,%ebp
  802323:	83 f5 1f             	xor    $0x1f,%ebp
  802326:	75 50                	jne    802378 <__umoddi3+0xa8>
  802328:	39 d8                	cmp    %ebx,%eax
  80232a:	0f 82 e0 00 00 00    	jb     802410 <__umoddi3+0x140>
  802330:	89 d9                	mov    %ebx,%ecx
  802332:	39 f7                	cmp    %esi,%edi
  802334:	0f 86 d6 00 00 00    	jbe    802410 <__umoddi3+0x140>
  80233a:	89 d0                	mov    %edx,%eax
  80233c:	89 ca                	mov    %ecx,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 fd                	mov    %edi,%ebp
  802352:	85 ff                	test   %edi,%edi
  802354:	75 0b                	jne    802361 <__umoddi3+0x91>
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f7                	div    %edi
  80235f:	89 c5                	mov    %eax,%ebp
  802361:	89 d8                	mov    %ebx,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f5                	div    %ebp
  802367:	89 f0                	mov    %esi,%eax
  802369:	f7 f5                	div    %ebp
  80236b:	89 d0                	mov    %edx,%eax
  80236d:	31 d2                	xor    %edx,%edx
  80236f:	eb 8c                	jmp    8022fd <__umoddi3+0x2d>
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 e9                	mov    %ebp,%ecx
  80237a:	ba 20 00 00 00       	mov    $0x20,%edx
  80237f:	29 ea                	sub    %ebp,%edx
  802381:	d3 e0                	shl    %cl,%eax
  802383:	89 44 24 08          	mov    %eax,0x8(%esp)
  802387:	89 d1                	mov    %edx,%ecx
  802389:	89 f8                	mov    %edi,%eax
  80238b:	d3 e8                	shr    %cl,%eax
  80238d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802391:	89 54 24 04          	mov    %edx,0x4(%esp)
  802395:	8b 54 24 04          	mov    0x4(%esp),%edx
  802399:	09 c1                	or     %eax,%ecx
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a1:	89 e9                	mov    %ebp,%ecx
  8023a3:	d3 e7                	shl    %cl,%edi
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023af:	d3 e3                	shl    %cl,%ebx
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	89 d1                	mov    %edx,%ecx
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 fa                	mov    %edi,%edx
  8023bd:	d3 e6                	shl    %cl,%esi
  8023bf:	09 d8                	or     %ebx,%eax
  8023c1:	f7 74 24 08          	divl   0x8(%esp)
  8023c5:	89 d1                	mov    %edx,%ecx
  8023c7:	89 f3                	mov    %esi,%ebx
  8023c9:	f7 64 24 0c          	mull   0xc(%esp)
  8023cd:	89 c6                	mov    %eax,%esi
  8023cf:	89 d7                	mov    %edx,%edi
  8023d1:	39 d1                	cmp    %edx,%ecx
  8023d3:	72 06                	jb     8023db <__umoddi3+0x10b>
  8023d5:	75 10                	jne    8023e7 <__umoddi3+0x117>
  8023d7:	39 c3                	cmp    %eax,%ebx
  8023d9:	73 0c                	jae    8023e7 <__umoddi3+0x117>
  8023db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023e3:	89 d7                	mov    %edx,%edi
  8023e5:	89 c6                	mov    %eax,%esi
  8023e7:	89 ca                	mov    %ecx,%edx
  8023e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ee:	29 f3                	sub    %esi,%ebx
  8023f0:	19 fa                	sbb    %edi,%edx
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	d3 e0                	shl    %cl,%eax
  8023f6:	89 e9                	mov    %ebp,%ecx
  8023f8:	d3 eb                	shr    %cl,%ebx
  8023fa:	d3 ea                	shr    %cl,%edx
  8023fc:	09 d8                	or     %ebx,%eax
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	29 fe                	sub    %edi,%esi
  802412:	19 c3                	sbb    %eax,%ebx
  802414:	89 f2                	mov    %esi,%edx
  802416:	89 d9                	mov    %ebx,%ecx
  802418:	e9 1d ff ff ff       	jmp    80233a <__umoddi3+0x6a>
