
obj/user/stresssched.debug:     formato del fichero elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  80003c:	e8 98 0b 00 00       	call   800bd9 <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  800043:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800048:	e8 9f 10 00 00       	call   8010ec <fork>
  80004d:	85 c0                	test   %eax,%eax
  80004f:	74 0f                	je     800060 <umain+0x2d>
	for (i = 0; i < 20; i++)
  800051:	83 c3 01             	add    $0x1,%ebx
  800054:	83 fb 14             	cmp    $0x14,%ebx
  800057:	75 ef                	jne    800048 <umain+0x15>
			break;
	if (i == 20) {
		sys_yield();
  800059:	e8 a3 0b 00 00       	call   800c01 <sys_yield>
		return;
  80005e:	eb 69                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800060:	89 f0                	mov    %esi,%eax
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 50 54             	mov    0x54(%eax),%edx
  800076:	85 d2                	test   %edx,%edx
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 7d 0b 00 00       	call   800c01 <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 04 40 80 00       	mov    %eax,0x804004
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 5b 24 80 00       	push   $0x80245b
  8000c1:	e8 74 01 00 00       	call   80023a <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 20 24 80 00       	push   $0x802420
  8000db:	6a 21                	push   $0x21
  8000dd:	68 48 24 80 00       	push   $0x802448
  8000e2:	e8 6c 00 00 00       	call   800153 <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000f6:	e8 de 0a 00 00       	call   800bd9 <sys_getenvid>
	if (id >= 0)
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	78 12                	js     800111 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  800104:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800107:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800111:	85 db                	test   %ebx,%ebx
  800113:	7e 07                	jle    80011c <libmain+0x35>
		binaryname = argv[0];
  800115:	8b 06                	mov    (%esi),%eax
  800117:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	56                   	push   %esi
  800120:	53                   	push   %ebx
  800121:	e8 0d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800126:	e8 0a 00 00 00       	call   800135 <exit>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    

00800135 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800135:	f3 0f 1e fb          	endbr32 
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013f:	e8 e7 12 00 00       	call   80142b <close_all>
	sys_env_destroy(0);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	6a 00                	push   $0x0
  800149:	e8 65 0a 00 00       	call   800bb3 <sys_env_destroy>
}
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800153:	f3 0f 1e fb          	endbr32 
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80015c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800165:	e8 6f 0a 00 00       	call   800bd9 <sys_getenvid>
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 0c             	pushl  0xc(%ebp)
  800170:	ff 75 08             	pushl  0x8(%ebp)
  800173:	56                   	push   %esi
  800174:	50                   	push   %eax
  800175:	68 84 24 80 00       	push   $0x802484
  80017a:	e8 bb 00 00 00       	call   80023a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017f:	83 c4 18             	add    $0x18,%esp
  800182:	53                   	push   %ebx
  800183:	ff 75 10             	pushl  0x10(%ebp)
  800186:	e8 5a 00 00 00       	call   8001e5 <vcprintf>
	cprintf("\n");
  80018b:	c7 04 24 c8 2a 80 00 	movl   $0x802ac8,(%esp)
  800192:	e8 a3 00 00 00       	call   80023a <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019a:	cc                   	int3   
  80019b:	eb fd                	jmp    80019a <_panic+0x47>

0080019d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019d:	f3 0f 1e fb          	endbr32 
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	53                   	push   %ebx
  8001a5:	83 ec 04             	sub    $0x4,%esp
  8001a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ab:	8b 13                	mov    (%ebx),%edx
  8001ad:	8d 42 01             	lea    0x1(%edx),%eax
  8001b0:	89 03                	mov    %eax,(%ebx)
  8001b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001be:	74 09                	je     8001c9 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	68 ff 00 00 00       	push   $0xff
  8001d1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 87 09 00 00       	call   800b61 <sys_cputs>
		b->idx = 0;
  8001da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	eb db                	jmp    8001c0 <putch+0x23>

008001e5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e5:	f3 0f 1e fb          	endbr32 
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f9:	00 00 00 
	b.cnt = 0;
  8001fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800203:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800206:	ff 75 0c             	pushl  0xc(%ebp)
  800209:	ff 75 08             	pushl  0x8(%ebp)
  80020c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	68 9d 01 80 00       	push   $0x80019d
  800218:	e8 80 01 00 00       	call   80039d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021d:	83 c4 08             	add    $0x8,%esp
  800220:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800226:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022c:	50                   	push   %eax
  80022d:	e8 2f 09 00 00       	call   800b61 <sys_cputs>

	return b.cnt;
}
  800232:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023a:	f3 0f 1e fb          	endbr32 
  80023e:	55                   	push   %ebp
  80023f:	89 e5                	mov    %esp,%ebp
  800241:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800244:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800247:	50                   	push   %eax
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	e8 95 ff ff ff       	call   8001e5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 1c             	sub    $0x1c,%esp
  80025b:	89 c7                	mov    %eax,%edi
  80025d:	89 d6                	mov    %edx,%esi
  80025f:	8b 45 08             	mov    0x8(%ebp),%eax
  800262:	8b 55 0c             	mov    0xc(%ebp),%edx
  800265:	89 d1                	mov    %edx,%ecx
  800267:	89 c2                	mov    %eax,%edx
  800269:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80026c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80026f:	8b 45 10             	mov    0x10(%ebp),%eax
  800272:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800275:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800278:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80027f:	39 c2                	cmp    %eax,%edx
  800281:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800284:	72 3e                	jb     8002c4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 75 18             	pushl  0x18(%ebp)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	53                   	push   %ebx
  800290:	50                   	push   %eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	ff 75 e0             	pushl  -0x20(%ebp)
  80029a:	ff 75 dc             	pushl  -0x24(%ebp)
  80029d:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a0:	e8 0b 1f 00 00       	call   8021b0 <__udivdi3>
  8002a5:	83 c4 18             	add    $0x18,%esp
  8002a8:	52                   	push   %edx
  8002a9:	50                   	push   %eax
  8002aa:	89 f2                	mov    %esi,%edx
  8002ac:	89 f8                	mov    %edi,%eax
  8002ae:	e8 9f ff ff ff       	call   800252 <printnum>
  8002b3:	83 c4 20             	add    $0x20,%esp
  8002b6:	eb 13                	jmp    8002cb <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	56                   	push   %esi
  8002bc:	ff 75 18             	pushl  0x18(%ebp)
  8002bf:	ff d7                	call   *%edi
  8002c1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002c4:	83 eb 01             	sub    $0x1,%ebx
  8002c7:	85 db                	test   %ebx,%ebx
  8002c9:	7f ed                	jg     8002b8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	56                   	push   %esi
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002db:	ff 75 d8             	pushl  -0x28(%ebp)
  8002de:	e8 dd 1f 00 00       	call   8022c0 <__umoddi3>
  8002e3:	83 c4 14             	add    $0x14,%esp
  8002e6:	0f be 80 a7 24 80 00 	movsbl 0x8024a7(%eax),%eax
  8002ed:	50                   	push   %eax
  8002ee:	ff d7                	call   *%edi
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f6:	5b                   	pop    %ebx
  8002f7:	5e                   	pop    %esi
  8002f8:	5f                   	pop    %edi
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002fb:	83 fa 01             	cmp    $0x1,%edx
  8002fe:	7f 13                	jg     800313 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800300:	85 d2                	test   %edx,%edx
  800302:	74 1c                	je     800320 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800304:	8b 10                	mov    (%eax),%edx
  800306:	8d 4a 04             	lea    0x4(%edx),%ecx
  800309:	89 08                	mov    %ecx,(%eax)
  80030b:	8b 02                	mov    (%edx),%eax
  80030d:	ba 00 00 00 00       	mov    $0x0,%edx
  800312:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800313:	8b 10                	mov    (%eax),%edx
  800315:	8d 4a 08             	lea    0x8(%edx),%ecx
  800318:	89 08                	mov    %ecx,(%eax)
  80031a:	8b 02                	mov    (%edx),%eax
  80031c:	8b 52 04             	mov    0x4(%edx),%edx
  80031f:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800320:	8b 10                	mov    (%eax),%edx
  800322:	8d 4a 04             	lea    0x4(%edx),%ecx
  800325:	89 08                	mov    %ecx,(%eax)
  800327:	8b 02                	mov    (%edx),%eax
  800329:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80032e:	c3                   	ret    

0080032f <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80032f:	83 fa 01             	cmp    $0x1,%edx
  800332:	7f 0f                	jg     800343 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800334:	85 d2                	test   %edx,%edx
  800336:	74 18                	je     800350 <getint+0x21>
		return va_arg(*ap, long);
  800338:	8b 10                	mov    (%eax),%edx
  80033a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033d:	89 08                	mov    %ecx,(%eax)
  80033f:	8b 02                	mov    (%edx),%eax
  800341:	99                   	cltd   
  800342:	c3                   	ret    
		return va_arg(*ap, long long);
  800343:	8b 10                	mov    (%eax),%edx
  800345:	8d 4a 08             	lea    0x8(%edx),%ecx
  800348:	89 08                	mov    %ecx,(%eax)
  80034a:	8b 02                	mov    (%edx),%eax
  80034c:	8b 52 04             	mov    0x4(%edx),%edx
  80034f:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800350:	8b 10                	mov    (%eax),%edx
  800352:	8d 4a 04             	lea    0x4(%edx),%ecx
  800355:	89 08                	mov    %ecx,(%eax)
  800357:	8b 02                	mov    (%edx),%eax
  800359:	99                   	cltd   
}
  80035a:	c3                   	ret    

0080035b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035b:	f3 0f 1e fb          	endbr32 
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800365:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	3b 50 04             	cmp    0x4(%eax),%edx
  80036e:	73 0a                	jae    80037a <sprintputch+0x1f>
		*b->buf++ = ch;
  800370:	8d 4a 01             	lea    0x1(%edx),%ecx
  800373:	89 08                	mov    %ecx,(%eax)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	88 02                	mov    %al,(%edx)
}
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    

0080037c <printfmt>:
{
  80037c:	f3 0f 1e fb          	endbr32 
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800386:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800389:	50                   	push   %eax
  80038a:	ff 75 10             	pushl  0x10(%ebp)
  80038d:	ff 75 0c             	pushl  0xc(%ebp)
  800390:	ff 75 08             	pushl  0x8(%ebp)
  800393:	e8 05 00 00 00       	call   80039d <vprintfmt>
}
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <vprintfmt>:
{
  80039d:	f3 0f 1e fb          	endbr32 
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	57                   	push   %edi
  8003a5:	56                   	push   %esi
  8003a6:	53                   	push   %ebx
  8003a7:	83 ec 2c             	sub    $0x2c,%esp
  8003aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003b0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b3:	e9 86 02 00 00       	jmp    80063e <vprintfmt+0x2a1>
		padc = ' ';
  8003b8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003d1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8d 47 01             	lea    0x1(%edi),%eax
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dc:	0f b6 17             	movzbl (%edi),%edx
  8003df:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e2:	3c 55                	cmp    $0x55,%al
  8003e4:	0f 87 df 02 00 00    	ja     8006c9 <vprintfmt+0x32c>
  8003ea:	0f b6 c0             	movzbl %al,%eax
  8003ed:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  8003f4:	00 
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003fc:	eb d8                	jmp    8003d6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800401:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800405:	eb cf                	jmp    8003d6 <vprintfmt+0x39>
  800407:	0f b6 d2             	movzbl %dl,%edx
  80040a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040d:	b8 00 00 00 00       	mov    $0x0,%eax
  800412:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800415:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800418:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80041c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800422:	83 f9 09             	cmp    $0x9,%ecx
  800425:	77 52                	ja     800479 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800427:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042a:	eb e9                	jmp    800415 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 50 04             	lea    0x4(%eax),%edx
  800432:	89 55 14             	mov    %edx,0x14(%ebp)
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80043d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800441:	79 93                	jns    8003d6 <vprintfmt+0x39>
				width = precision, precision = -1;
  800443:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800446:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800449:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800450:	eb 84                	jmp    8003d6 <vprintfmt+0x39>
  800452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800455:	85 c0                	test   %eax,%eax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	0f 49 d0             	cmovns %eax,%edx
  80045f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800462:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800465:	e9 6c ff ff ff       	jmp    8003d6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80046d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800474:	e9 5d ff ff ff       	jmp    8003d6 <vprintfmt+0x39>
  800479:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80047f:	eb bc                	jmp    80043d <vprintfmt+0xa0>
			lflag++;
  800481:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800487:	e9 4a ff ff ff       	jmp    8003d6 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8d 50 04             	lea    0x4(%eax),%edx
  800492:	89 55 14             	mov    %edx,0x14(%ebp)
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	56                   	push   %esi
  800499:	ff 30                	pushl  (%eax)
  80049b:	ff d3                	call   *%ebx
			break;
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	e9 96 01 00 00       	jmp    80063b <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8004a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a8:	8d 50 04             	lea    0x4(%eax),%edx
  8004ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	99                   	cltd   
  8004b1:	31 d0                	xor    %edx,%eax
  8004b3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b5:	83 f8 0f             	cmp    $0xf,%eax
  8004b8:	7f 20                	jg     8004da <vprintfmt+0x13d>
  8004ba:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  8004c1:	85 d2                	test   %edx,%edx
  8004c3:	74 15                	je     8004da <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8004c5:	52                   	push   %edx
  8004c6:	68 3b 2a 80 00       	push   $0x802a3b
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	e8 aa fe ff ff       	call   80037c <printfmt>
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	e9 61 01 00 00       	jmp    80063b <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004da:	50                   	push   %eax
  8004db:	68 bf 24 80 00       	push   $0x8024bf
  8004e0:	56                   	push   %esi
  8004e1:	53                   	push   %ebx
  8004e2:	e8 95 fe ff ff       	call   80037c <printfmt>
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	e9 4c 01 00 00       	jmp    80063b <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8d 50 04             	lea    0x4(%eax),%edx
  8004f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004fa:	85 c9                	test   %ecx,%ecx
  8004fc:	b8 b8 24 80 00       	mov    $0x8024b8,%eax
  800501:	0f 45 c1             	cmovne %ecx,%eax
  800504:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800507:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050b:	7e 06                	jle    800513 <vprintfmt+0x176>
  80050d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800511:	75 0d                	jne    800520 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800516:	89 c7                	mov    %eax,%edi
  800518:	03 45 e0             	add    -0x20(%ebp),%eax
  80051b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051e:	eb 57                	jmp    800577 <vprintfmt+0x1da>
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 d8             	pushl  -0x28(%ebp)
  800526:	ff 75 cc             	pushl  -0x34(%ebp)
  800529:	e8 4f 02 00 00       	call   80077d <strnlen>
  80052e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800531:	29 c2                	sub    %eax,%edx
  800533:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800536:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800539:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80053d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800540:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800542:	85 db                	test   %ebx,%ebx
  800544:	7e 10                	jle    800556 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	56                   	push   %esi
  80054a:	57                   	push   %edi
  80054b:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80054e:	83 eb 01             	sub    $0x1,%ebx
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	eb ec                	jmp    800542 <vprintfmt+0x1a5>
  800556:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800559:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055c:	85 d2                	test   %edx,%edx
  80055e:	b8 00 00 00 00       	mov    $0x0,%eax
  800563:	0f 49 c2             	cmovns %edx,%eax
  800566:	29 c2                	sub    %eax,%edx
  800568:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80056b:	eb a6                	jmp    800513 <vprintfmt+0x176>
					putch(ch, putdat);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	56                   	push   %esi
  800571:	52                   	push   %edx
  800572:	ff d3                	call   *%ebx
  800574:	83 c4 10             	add    $0x10,%esp
  800577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057c:	83 c7 01             	add    $0x1,%edi
  80057f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800583:	0f be d0             	movsbl %al,%edx
  800586:	85 d2                	test   %edx,%edx
  800588:	74 42                	je     8005cc <vprintfmt+0x22f>
  80058a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058e:	78 06                	js     800596 <vprintfmt+0x1f9>
  800590:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800594:	78 1e                	js     8005b4 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800596:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80059a:	74 d1                	je     80056d <vprintfmt+0x1d0>
  80059c:	0f be c0             	movsbl %al,%eax
  80059f:	83 e8 20             	sub    $0x20,%eax
  8005a2:	83 f8 5e             	cmp    $0x5e,%eax
  8005a5:	76 c6                	jbe    80056d <vprintfmt+0x1d0>
					putch('?', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	56                   	push   %esi
  8005ab:	6a 3f                	push   $0x3f
  8005ad:	ff d3                	call   *%ebx
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	eb c3                	jmp    800577 <vprintfmt+0x1da>
  8005b4:	89 cf                	mov    %ecx,%edi
  8005b6:	eb 0e                	jmp    8005c6 <vprintfmt+0x229>
				putch(' ', putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	56                   	push   %esi
  8005bc:	6a 20                	push   $0x20
  8005be:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8005c0:	83 ef 01             	sub    $0x1,%edi
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	85 ff                	test   %edi,%edi
  8005c8:	7f ee                	jg     8005b8 <vprintfmt+0x21b>
  8005ca:	eb 6f                	jmp    80063b <vprintfmt+0x29e>
  8005cc:	89 cf                	mov    %ecx,%edi
  8005ce:	eb f6                	jmp    8005c6 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005d0:	89 ca                	mov    %ecx,%edx
  8005d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d5:	e8 55 fd ff ff       	call   80032f <getint>
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005e0:	85 d2                	test   %edx,%edx
  8005e2:	78 0b                	js     8005ef <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005e4:	89 d1                	mov    %edx,%ecx
  8005e6:	89 c2                	mov    %eax,%edx
			base = 10;
  8005e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ed:	eb 32                	jmp    800621 <vprintfmt+0x284>
				putch('-', putdat);
  8005ef:	83 ec 08             	sub    $0x8,%esp
  8005f2:	56                   	push   %esi
  8005f3:	6a 2d                	push   $0x2d
  8005f5:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fd:	f7 da                	neg    %edx
  8005ff:	83 d1 00             	adc    $0x0,%ecx
  800602:	f7 d9                	neg    %ecx
  800604:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800607:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060c:	eb 13                	jmp    800621 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80060e:	89 ca                	mov    %ecx,%edx
  800610:	8d 45 14             	lea    0x14(%ebp),%eax
  800613:	e8 e3 fc ff ff       	call   8002fb <getuint>
  800618:	89 d1                	mov    %edx,%ecx
  80061a:	89 c2                	mov    %eax,%edx
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800628:	57                   	push   %edi
  800629:	ff 75 e0             	pushl  -0x20(%ebp)
  80062c:	50                   	push   %eax
  80062d:	51                   	push   %ecx
  80062e:	52                   	push   %edx
  80062f:	89 f2                	mov    %esi,%edx
  800631:	89 d8                	mov    %ebx,%eax
  800633:	e8 1a fc ff ff       	call   800252 <printnum>
			break;
  800638:	83 c4 20             	add    $0x20,%esp
{
  80063b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063e:	83 c7 01             	add    $0x1,%edi
  800641:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800645:	83 f8 25             	cmp    $0x25,%eax
  800648:	0f 84 6a fd ff ff    	je     8003b8 <vprintfmt+0x1b>
			if (ch == '\0')
  80064e:	85 c0                	test   %eax,%eax
  800650:	0f 84 93 00 00 00    	je     8006e9 <vprintfmt+0x34c>
			putch(ch, putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	56                   	push   %esi
  80065a:	50                   	push   %eax
  80065b:	ff d3                	call   *%ebx
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	eb dc                	jmp    80063e <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800662:	89 ca                	mov    %ecx,%edx
  800664:	8d 45 14             	lea    0x14(%ebp),%eax
  800667:	e8 8f fc ff ff       	call   8002fb <getuint>
  80066c:	89 d1                	mov    %edx,%ecx
  80066e:	89 c2                	mov    %eax,%edx
			base = 8;
  800670:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800675:	eb aa                	jmp    800621 <vprintfmt+0x284>
			putch('0', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	56                   	push   %esi
  80067b:	6a 30                	push   $0x30
  80067d:	ff d3                	call   *%ebx
			putch('x', putdat);
  80067f:	83 c4 08             	add    $0x8,%esp
  800682:	56                   	push   %esi
  800683:	6a 78                	push   $0x78
  800685:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 50 04             	lea    0x4(%eax),%edx
  80068d:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800690:	8b 10                	mov    (%eax),%edx
  800692:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800697:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80069a:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80069f:	eb 80                	jmp    800621 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006a1:	89 ca                	mov    %ecx,%edx
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a6:	e8 50 fc ff ff       	call   8002fb <getuint>
  8006ab:	89 d1                	mov    %edx,%ecx
  8006ad:	89 c2                	mov    %eax,%edx
			base = 16;
  8006af:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b4:	e9 68 ff ff ff       	jmp    800621 <vprintfmt+0x284>
			putch(ch, putdat);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	56                   	push   %esi
  8006bd:	6a 25                	push   $0x25
  8006bf:	ff d3                	call   *%ebx
			break;
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	e9 72 ff ff ff       	jmp    80063b <vprintfmt+0x29e>
			putch('%', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	56                   	push   %esi
  8006cd:	6a 25                	push   $0x25
  8006cf:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	89 f8                	mov    %edi,%eax
  8006d6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006da:	74 05                	je     8006e1 <vprintfmt+0x344>
  8006dc:	83 e8 01             	sub    $0x1,%eax
  8006df:	eb f5                	jmp    8006d6 <vprintfmt+0x339>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e4:	e9 52 ff ff ff       	jmp    80063b <vprintfmt+0x29e>
}
  8006e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ec:	5b                   	pop    %ebx
  8006ed:	5e                   	pop    %esi
  8006ee:	5f                   	pop    %edi
  8006ef:	5d                   	pop    %ebp
  8006f0:	c3                   	ret    

008006f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f1:	f3 0f 1e fb          	endbr32 
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800704:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800708:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800712:	85 c0                	test   %eax,%eax
  800714:	74 26                	je     80073c <vsnprintf+0x4b>
  800716:	85 d2                	test   %edx,%edx
  800718:	7e 22                	jle    80073c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071a:	ff 75 14             	pushl  0x14(%ebp)
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	68 5b 03 80 00       	push   $0x80035b
  800729:	e8 6f fc ff ff       	call   80039d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800731:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    
		return -E_INVAL;
  80073c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800741:	eb f7                	jmp    80073a <vsnprintf+0x49>

00800743 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800743:	f3 0f 1e fb          	endbr32 
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80074d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800750:	50                   	push   %eax
  800751:	ff 75 10             	pushl  0x10(%ebp)
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	ff 75 08             	pushl  0x8(%ebp)
  80075a:	e8 92 ff ff ff       	call   8006f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800761:	f3 0f 1e fb          	endbr32 
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076b:	b8 00 00 00 00       	mov    $0x0,%eax
  800770:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800774:	74 05                	je     80077b <strlen+0x1a>
		n++;
  800776:	83 c0 01             	add    $0x1,%eax
  800779:	eb f5                	jmp    800770 <strlen+0xf>
	return n;
}
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077d:	f3 0f 1e fb          	endbr32 
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078a:	b8 00 00 00 00       	mov    $0x0,%eax
  80078f:	39 d0                	cmp    %edx,%eax
  800791:	74 0d                	je     8007a0 <strnlen+0x23>
  800793:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800797:	74 05                	je     80079e <strnlen+0x21>
		n++;
  800799:	83 c0 01             	add    $0x1,%eax
  80079c:	eb f1                	jmp    80078f <strnlen+0x12>
  80079e:	89 c2                	mov    %eax,%edx
	return n;
}
  8007a0:	89 d0                	mov    %edx,%eax
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	53                   	push   %ebx
  8007ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007bb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007be:	83 c0 01             	add    $0x1,%eax
  8007c1:	84 d2                	test   %dl,%dl
  8007c3:	75 f2                	jne    8007b7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007c5:	89 c8                	mov    %ecx,%eax
  8007c7:	5b                   	pop    %ebx
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ca:	f3 0f 1e fb          	endbr32 
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 10             	sub    $0x10,%esp
  8007d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d8:	53                   	push   %ebx
  8007d9:	e8 83 ff ff ff       	call   800761 <strlen>
  8007de:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	01 d8                	add    %ebx,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 b8 ff ff ff       	call   8007a4 <strcpy>
	return dst;
}
  8007ec:	89 d8                	mov    %ebx,%eax
  8007ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f1:	c9                   	leave  
  8007f2:	c3                   	ret    

008007f3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f3:	f3 0f 1e fb          	endbr32 
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	56                   	push   %esi
  8007fb:	53                   	push   %ebx
  8007fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800802:	89 f3                	mov    %esi,%ebx
  800804:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800807:	89 f0                	mov    %esi,%eax
  800809:	39 d8                	cmp    %ebx,%eax
  80080b:	74 11                	je     80081e <strncpy+0x2b>
		*dst++ = *src;
  80080d:	83 c0 01             	add    $0x1,%eax
  800810:	0f b6 0a             	movzbl (%edx),%ecx
  800813:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800816:	80 f9 01             	cmp    $0x1,%cl
  800819:	83 da ff             	sbb    $0xffffffff,%edx
  80081c:	eb eb                	jmp    800809 <strncpy+0x16>
	}
	return ret;
}
  80081e:	89 f0                	mov    %esi,%eax
  800820:	5b                   	pop    %ebx
  800821:	5e                   	pop    %esi
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800824:	f3 0f 1e fb          	endbr32 
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	56                   	push   %esi
  80082c:	53                   	push   %ebx
  80082d:	8b 75 08             	mov    0x8(%ebp),%esi
  800830:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800833:	8b 55 10             	mov    0x10(%ebp),%edx
  800836:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800838:	85 d2                	test   %edx,%edx
  80083a:	74 21                	je     80085d <strlcpy+0x39>
  80083c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800840:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800842:	39 c2                	cmp    %eax,%edx
  800844:	74 14                	je     80085a <strlcpy+0x36>
  800846:	0f b6 19             	movzbl (%ecx),%ebx
  800849:	84 db                	test   %bl,%bl
  80084b:	74 0b                	je     800858 <strlcpy+0x34>
			*dst++ = *src++;
  80084d:	83 c1 01             	add    $0x1,%ecx
  800850:	83 c2 01             	add    $0x1,%edx
  800853:	88 5a ff             	mov    %bl,-0x1(%edx)
  800856:	eb ea                	jmp    800842 <strlcpy+0x1e>
  800858:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80085a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80085d:	29 f0                	sub    %esi,%eax
}
  80085f:	5b                   	pop    %ebx
  800860:	5e                   	pop    %esi
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800863:	f3 0f 1e fb          	endbr32 
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800870:	0f b6 01             	movzbl (%ecx),%eax
  800873:	84 c0                	test   %al,%al
  800875:	74 0c                	je     800883 <strcmp+0x20>
  800877:	3a 02                	cmp    (%edx),%al
  800879:	75 08                	jne    800883 <strcmp+0x20>
		p++, q++;
  80087b:	83 c1 01             	add    $0x1,%ecx
  80087e:	83 c2 01             	add    $0x1,%edx
  800881:	eb ed                	jmp    800870 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800883:	0f b6 c0             	movzbl %al,%eax
  800886:	0f b6 12             	movzbl (%edx),%edx
  800889:	29 d0                	sub    %edx,%eax
}
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80088d:	f3 0f 1e fb          	endbr32 
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	53                   	push   %ebx
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089b:	89 c3                	mov    %eax,%ebx
  80089d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a0:	eb 06                	jmp    8008a8 <strncmp+0x1b>
		n--, p++, q++;
  8008a2:	83 c0 01             	add    $0x1,%eax
  8008a5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008a8:	39 d8                	cmp    %ebx,%eax
  8008aa:	74 16                	je     8008c2 <strncmp+0x35>
  8008ac:	0f b6 08             	movzbl (%eax),%ecx
  8008af:	84 c9                	test   %cl,%cl
  8008b1:	74 04                	je     8008b7 <strncmp+0x2a>
  8008b3:	3a 0a                	cmp    (%edx),%cl
  8008b5:	74 eb                	je     8008a2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b7:	0f b6 00             	movzbl (%eax),%eax
  8008ba:	0f b6 12             	movzbl (%edx),%edx
  8008bd:	29 d0                	sub    %edx,%eax
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    
		return 0;
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c7:	eb f6                	jmp    8008bf <strncmp+0x32>

008008c9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c9:	f3 0f 1e fb          	endbr32 
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d7:	0f b6 10             	movzbl (%eax),%edx
  8008da:	84 d2                	test   %dl,%dl
  8008dc:	74 09                	je     8008e7 <strchr+0x1e>
		if (*s == c)
  8008de:	38 ca                	cmp    %cl,%dl
  8008e0:	74 0a                	je     8008ec <strchr+0x23>
	for (; *s; s++)
  8008e2:	83 c0 01             	add    $0x1,%eax
  8008e5:	eb f0                	jmp    8008d7 <strchr+0xe>
			return (char *) s;
	return 0;
  8008e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ee:	f3 0f 1e fb          	endbr32 
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ff:	38 ca                	cmp    %cl,%dl
  800901:	74 09                	je     80090c <strfind+0x1e>
  800903:	84 d2                	test   %dl,%dl
  800905:	74 05                	je     80090c <strfind+0x1e>
	for (; *s; s++)
  800907:	83 c0 01             	add    $0x1,%eax
  80090a:	eb f0                	jmp    8008fc <strfind+0xe>
			break;
	return (char *) s;
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090e:	f3 0f 1e fb          	endbr32 
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	57                   	push   %edi
  800916:	56                   	push   %esi
  800917:	53                   	push   %ebx
  800918:	8b 55 08             	mov    0x8(%ebp),%edx
  80091b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80091e:	85 c9                	test   %ecx,%ecx
  800920:	74 33                	je     800955 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800922:	89 d0                	mov    %edx,%eax
  800924:	09 c8                	or     %ecx,%eax
  800926:	a8 03                	test   $0x3,%al
  800928:	75 23                	jne    80094d <memset+0x3f>
		c &= 0xFF;
  80092a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092e:	89 d8                	mov    %ebx,%eax
  800930:	c1 e0 08             	shl    $0x8,%eax
  800933:	89 df                	mov    %ebx,%edi
  800935:	c1 e7 18             	shl    $0x18,%edi
  800938:	89 de                	mov    %ebx,%esi
  80093a:	c1 e6 10             	shl    $0x10,%esi
  80093d:	09 f7                	or     %esi,%edi
  80093f:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800941:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800944:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800946:	89 d7                	mov    %edx,%edi
  800948:	fc                   	cld    
  800949:	f3 ab                	rep stos %eax,%es:(%edi)
  80094b:	eb 08                	jmp    800955 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094d:	89 d7                	mov    %edx,%edi
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	fc                   	cld    
  800953:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800955:	89 d0                	mov    %edx,%eax
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095c:	f3 0f 1e fb          	endbr32 
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	57                   	push   %edi
  800964:	56                   	push   %esi
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80096e:	39 c6                	cmp    %eax,%esi
  800970:	73 32                	jae    8009a4 <memmove+0x48>
  800972:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800975:	39 c2                	cmp    %eax,%edx
  800977:	76 2b                	jbe    8009a4 <memmove+0x48>
		s += n;
		d += n;
  800979:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097c:	89 fe                	mov    %edi,%esi
  80097e:	09 ce                	or     %ecx,%esi
  800980:	09 d6                	or     %edx,%esi
  800982:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800988:	75 0e                	jne    800998 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80098a:	83 ef 04             	sub    $0x4,%edi
  80098d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800990:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800993:	fd                   	std    
  800994:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800996:	eb 09                	jmp    8009a1 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800998:	83 ef 01             	sub    $0x1,%edi
  80099b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80099e:	fd                   	std    
  80099f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a1:	fc                   	cld    
  8009a2:	eb 1a                	jmp    8009be <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a4:	89 c2                	mov    %eax,%edx
  8009a6:	09 ca                	or     %ecx,%edx
  8009a8:	09 f2                	or     %esi,%edx
  8009aa:	f6 c2 03             	test   $0x3,%dl
  8009ad:	75 0a                	jne    8009b9 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009af:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b2:	89 c7                	mov    %eax,%edi
  8009b4:	fc                   	cld    
  8009b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b7:	eb 05                	jmp    8009be <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	fc                   	cld    
  8009bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009be:	5e                   	pop    %esi
  8009bf:	5f                   	pop    %edi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c2:	f3 0f 1e fb          	endbr32 
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009cc:	ff 75 10             	pushl  0x10(%ebp)
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 82 ff ff ff       	call   80095c <memmove>
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	56                   	push   %esi
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	89 c6                	mov    %eax,%esi
  8009ed:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f0:	39 f0                	cmp    %esi,%eax
  8009f2:	74 1c                	je     800a10 <memcmp+0x34>
		if (*s1 != *s2)
  8009f4:	0f b6 08             	movzbl (%eax),%ecx
  8009f7:	0f b6 1a             	movzbl (%edx),%ebx
  8009fa:	38 d9                	cmp    %bl,%cl
  8009fc:	75 08                	jne    800a06 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	83 c2 01             	add    $0x1,%edx
  800a04:	eb ea                	jmp    8009f0 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a06:	0f b6 c1             	movzbl %cl,%eax
  800a09:	0f b6 db             	movzbl %bl,%ebx
  800a0c:	29 d8                	sub    %ebx,%eax
  800a0e:	eb 05                	jmp    800a15 <memcmp+0x39>
	}

	return 0;
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a19:	f3 0f 1e fb          	endbr32 
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2b:	39 d0                	cmp    %edx,%eax
  800a2d:	73 09                	jae    800a38 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a2f:	38 08                	cmp    %cl,(%eax)
  800a31:	74 05                	je     800a38 <memfind+0x1f>
	for (; s < ends; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f3                	jmp    800a2b <memfind+0x12>
			break;
	return (void *) s;
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3a:	f3 0f 1e fb          	endbr32 
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	57                   	push   %edi
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4a:	eb 03                	jmp    800a4f <strtol+0x15>
		s++;
  800a4c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4f:	0f b6 01             	movzbl (%ecx),%eax
  800a52:	3c 20                	cmp    $0x20,%al
  800a54:	74 f6                	je     800a4c <strtol+0x12>
  800a56:	3c 09                	cmp    $0x9,%al
  800a58:	74 f2                	je     800a4c <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a5a:	3c 2b                	cmp    $0x2b,%al
  800a5c:	74 2a                	je     800a88 <strtol+0x4e>
	int neg = 0;
  800a5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a63:	3c 2d                	cmp    $0x2d,%al
  800a65:	74 2b                	je     800a92 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a67:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6d:	75 0f                	jne    800a7e <strtol+0x44>
  800a6f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a72:	74 28                	je     800a9c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a74:	85 db                	test   %ebx,%ebx
  800a76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7b:	0f 44 d8             	cmove  %eax,%ebx
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a86:	eb 46                	jmp    800ace <strtol+0x94>
		s++;
  800a88:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a90:	eb d5                	jmp    800a67 <strtol+0x2d>
		s++, neg = 1;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9a:	eb cb                	jmp    800a67 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa0:	74 0e                	je     800ab0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	75 d8                	jne    800a7e <strtol+0x44>
		s++, base = 8;
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aae:	eb ce                	jmp    800a7e <strtol+0x44>
		s += 2, base = 16;
  800ab0:	83 c1 02             	add    $0x2,%ecx
  800ab3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab8:	eb c4                	jmp    800a7e <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aba:	0f be d2             	movsbl %dl,%edx
  800abd:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac3:	7d 3a                	jge    800aff <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac5:	83 c1 01             	add    $0x1,%ecx
  800ac8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800acc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ace:	0f b6 11             	movzbl (%ecx),%edx
  800ad1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad4:	89 f3                	mov    %esi,%ebx
  800ad6:	80 fb 09             	cmp    $0x9,%bl
  800ad9:	76 df                	jbe    800aba <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800adb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ade:	89 f3                	mov    %esi,%ebx
  800ae0:	80 fb 19             	cmp    $0x19,%bl
  800ae3:	77 08                	ja     800aed <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ae5:	0f be d2             	movsbl %dl,%edx
  800ae8:	83 ea 57             	sub    $0x57,%edx
  800aeb:	eb d3                	jmp    800ac0 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aed:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af0:	89 f3                	mov    %esi,%ebx
  800af2:	80 fb 19             	cmp    $0x19,%bl
  800af5:	77 08                	ja     800aff <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af7:	0f be d2             	movsbl %dl,%edx
  800afa:	83 ea 37             	sub    $0x37,%edx
  800afd:	eb c1                	jmp    800ac0 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xd0>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	f7 da                	neg    %edx
  800b0e:	85 ff                	test   %edi,%edi
  800b10:	0f 45 c2             	cmovne %edx,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	83 ec 1c             	sub    $0x1c,%esp
  800b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b27:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b32:	8b 75 14             	mov    0x14(%ebp),%esi
  800b35:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3b:	74 04                	je     800b41 <syscall+0x29>
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	7f 08                	jg     800b49 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b44:	5b                   	pop    %ebx
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b49:	83 ec 0c             	sub    $0xc,%esp
  800b4c:	50                   	push   %eax
  800b4d:	ff 75 e0             	pushl  -0x20(%ebp)
  800b50:	68 9f 27 80 00       	push   $0x80279f
  800b55:	6a 23                	push   $0x23
  800b57:	68 bc 27 80 00       	push   $0x8027bc
  800b5c:	e8 f2 f5 ff ff       	call   800153 <_panic>

00800b61 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b61:	f3 0f 1e fb          	endbr32 
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b6b:	6a 00                	push   $0x0
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b77:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	e8 92 ff ff ff       	call   800b18 <syscall>
}
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8b:	f3 0f 1e fb          	endbr32 
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b95:	6a 00                	push   $0x0
  800b97:	6a 00                	push   $0x0
  800b99:	6a 00                	push   $0x0
  800b9b:	6a 00                	push   $0x0
  800b9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bac:	e8 67 ff ff ff       	call   800b18 <syscall>
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb3:	f3 0f 1e fb          	endbr32 
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bbd:	6a 00                	push   $0x0
  800bbf:	6a 00                	push   $0x0
  800bc1:	6a 00                	push   $0x0
  800bc3:	6a 00                	push   $0x0
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	ba 01 00 00 00       	mov    $0x1,%edx
  800bcd:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd2:	e8 41 ff ff ff       	call   800b18 <syscall>
}
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800be3:	6a 00                	push   $0x0
  800be5:	6a 00                	push   $0x0
  800be7:	6a 00                	push   $0x0
  800be9:	6a 00                	push   $0x0
  800beb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf5:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfa:	e8 19 ff ff ff       	call   800b18 <syscall>
}
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <sys_yield>:

void
sys_yield(void)
{
  800c01:	f3 0f 1e fb          	endbr32 
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c0b:	6a 00                	push   $0x0
  800c0d:	6a 00                	push   $0x0
  800c0f:	6a 00                	push   $0x0
  800c11:	6a 00                	push   $0x0
  800c13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c22:	e8 f1 fe ff ff       	call   800b18 <syscall>
}
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2c:	f3 0f 1e fb          	endbr32 
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c36:	6a 00                	push   $0x0
  800c38:	6a 00                	push   $0x0
  800c3a:	ff 75 10             	pushl  0x10(%ebp)
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c43:	ba 01 00 00 00       	mov    $0x1,%edx
  800c48:	b8 04 00 00 00       	mov    $0x4,%eax
  800c4d:	e8 c6 fe ff ff       	call   800b18 <syscall>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c5e:	ff 75 18             	pushl  0x18(%ebp)
  800c61:	ff 75 14             	pushl  0x14(%ebp)
  800c64:	ff 75 10             	pushl  0x10(%ebp)
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c72:	b8 05 00 00 00       	mov    $0x5,%eax
  800c77:	e8 9c fe ff ff       	call   800b18 <syscall>
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7e:	f3 0f 1e fb          	endbr32 
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c88:	6a 00                	push   $0x0
  800c8a:	6a 00                	push   $0x0
  800c8c:	6a 00                	push   $0x0
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c94:	ba 01 00 00 00       	mov    $0x1,%edx
  800c99:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9e:	e8 75 fe ff ff       	call   800b18 <syscall>
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca5:	f3 0f 1e fb          	endbr32 
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800caf:	6a 00                	push   $0x0
  800cb1:	6a 00                	push   $0x0
  800cb3:	6a 00                	push   $0x0
  800cb5:	ff 75 0c             	pushl  0xc(%ebp)
  800cb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbb:	ba 01 00 00 00       	mov    $0x1,%edx
  800cc0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc5:	e8 4e fe ff ff       	call   800b18 <syscall>
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccc:	f3 0f 1e fb          	endbr32 
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cd6:	6a 00                	push   $0x0
  800cd8:	6a 00                	push   $0x0
  800cda:	6a 00                	push   $0x0
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce2:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce7:	b8 09 00 00 00       	mov    $0x9,%eax
  800cec:	e8 27 fe ff ff       	call   800b18 <syscall>
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf3:	f3 0f 1e fb          	endbr32 
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800cfd:	6a 00                	push   $0x0
  800cff:	6a 00                	push   $0x0
  800d01:	6a 00                	push   $0x0
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d09:	ba 01 00 00 00       	mov    $0x1,%edx
  800d0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d13:	e8 00 fe ff ff       	call   800b18 <syscall>
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d1a:	f3 0f 1e fb          	endbr32 
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d24:	6a 00                	push   $0x0
  800d26:	ff 75 14             	pushl  0x14(%ebp)
  800d29:	ff 75 10             	pushl  0x10(%ebp)
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d32:	ba 00 00 00 00       	mov    $0x0,%edx
  800d37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d3c:	e8 d7 fd ff ff       	call   800b18 <syscall>
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d43:	f3 0f 1e fb          	endbr32 
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d4d:	6a 00                	push   $0x0
  800d4f:	6a 00                	push   $0x0
  800d51:	6a 00                	push   $0x0
  800d53:	6a 00                	push   $0x0
  800d55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d58:	ba 01 00 00 00       	mov    $0x1,%edx
  800d5d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d62:	e8 b1 fd ff ff       	call   800b18 <syscall>
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800d72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d79:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d7c:	f6 c6 04             	test   $0x4,%dh
  800d7f:	75 51                	jne    800dd2 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d81:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d87:	0f 84 84 00 00 00    	je     800e11 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	68 05 08 00 00       	push   $0x805
  800d95:	53                   	push   %ebx
  800d96:	50                   	push   %eax
  800d97:	53                   	push   %ebx
  800d98:	6a 00                	push   $0x0
  800d9a:	e8 b5 fe ff ff       	call   800c54 <sys_page_map>
		if (r)
  800d9f:	83 c4 20             	add    $0x20,%esp
  800da2:	85 c0                	test   %eax,%eax
  800da4:	75 59                	jne    800dff <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	68 05 08 00 00       	push   $0x805
  800dae:	53                   	push   %ebx
  800daf:	6a 00                	push   $0x0
  800db1:	53                   	push   %ebx
  800db2:	6a 00                	push   $0x0
  800db4:	e8 9b fe ff ff       	call   800c54 <sys_page_map>
		if (r)
  800db9:	83 c4 20             	add    $0x20,%esp
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	74 67                	je     800e27 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800dc0:	50                   	push   %eax
  800dc1:	68 ca 27 80 00       	push   $0x8027ca
  800dc6:	6a 5f                	push   $0x5f
  800dc8:	68 e5 27 80 00       	push   $0x8027e5
  800dcd:	e8 81 f3 ff ff       	call   800153 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800ddb:	52                   	push   %edx
  800ddc:	53                   	push   %ebx
  800ddd:	50                   	push   %eax
  800dde:	53                   	push   %ebx
  800ddf:	6a 00                	push   $0x0
  800de1:	e8 6e fe ff ff       	call   800c54 <sys_page_map>
		if (r)
  800de6:	83 c4 20             	add    $0x20,%esp
  800de9:	85 c0                	test   %eax,%eax
  800deb:	74 3a                	je     800e27 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800ded:	50                   	push   %eax
  800dee:	68 ca 27 80 00       	push   $0x8027ca
  800df3:	6a 57                	push   $0x57
  800df5:	68 e5 27 80 00       	push   $0x8027e5
  800dfa:	e8 54 f3 ff ff       	call   800153 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800dff:	50                   	push   %eax
  800e00:	68 ca 27 80 00       	push   $0x8027ca
  800e05:	6a 5b                	push   $0x5b
  800e07:	68 e5 27 80 00       	push   $0x8027e5
  800e0c:	e8 42 f3 ff ff       	call   800153 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800e11:	83 ec 0c             	sub    $0xc,%esp
  800e14:	6a 05                	push   $0x5
  800e16:	53                   	push   %ebx
  800e17:	50                   	push   %eax
  800e18:	53                   	push   %ebx
  800e19:	6a 00                	push   $0x0
  800e1b:	e8 34 fe ff ff       	call   800c54 <sys_page_map>
		if (r)
  800e20:	83 c4 20             	add    $0x20,%esp
  800e23:	85 c0                	test   %eax,%eax
  800e25:	75 0a                	jne    800e31 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800e27:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800e31:	50                   	push   %eax
  800e32:	68 ca 27 80 00       	push   $0x8027ca
  800e37:	6a 63                	push   $0x63
  800e39:	68 e5 27 80 00       	push   $0x8027e5
  800e3e:	e8 10 f3 ff ff       	call   800153 <_panic>

00800e43 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	89 c7                	mov    %eax,%edi
  800e4e:	89 d6                	mov    %edx,%esi
  800e50:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800e52:	f6 c1 02             	test   $0x2,%cl
  800e55:	75 2f                	jne    800e86 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	51                   	push   %ecx
  800e5b:	52                   	push   %edx
  800e5c:	50                   	push   %eax
  800e5d:	52                   	push   %edx
  800e5e:	6a 00                	push   $0x0
  800e60:	e8 ef fd ff ff       	call   800c54 <sys_page_map>
  800e65:	83 c4 20             	add    $0x20,%esp
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	78 08                	js     800e74 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800e74:	50                   	push   %eax
  800e75:	68 d4 27 80 00       	push   $0x8027d4
  800e7a:	6a 6f                	push   $0x6f
  800e7c:	68 e5 27 80 00       	push   $0x8027e5
  800e81:	e8 cd f2 ff ff       	call   800153 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	51                   	push   %ecx
  800e8a:	52                   	push   %edx
  800e8b:	50                   	push   %eax
  800e8c:	e8 9b fd ff ff       	call   800c2c <sys_page_alloc>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	85 c0                	test   %eax,%eax
  800e96:	78 54                	js     800eec <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	53                   	push   %ebx
  800e9c:	68 00 00 40 00       	push   $0x400000
  800ea1:	6a 00                	push   $0x0
  800ea3:	56                   	push   %esi
  800ea4:	57                   	push   %edi
  800ea5:	e8 aa fd ff ff       	call   800c54 <sys_page_map>
  800eaa:	83 c4 20             	add    $0x20,%esp
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	78 4d                	js     800efe <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	68 00 10 00 00       	push   $0x1000
  800eb9:	56                   	push   %esi
  800eba:	68 00 00 40 00       	push   $0x400000
  800ebf:	e8 98 fa ff ff       	call   80095c <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800ec4:	83 c4 08             	add    $0x8,%esp
  800ec7:	68 00 00 40 00       	push   $0x400000
  800ecc:	6a 00                	push   $0x0
  800ece:	e8 ab fd ff ff       	call   800c7e <sys_page_unmap>
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	79 92                	jns    800e6c <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800eda:	50                   	push   %eax
  800edb:	68 03 28 80 00       	push   $0x802803
  800ee0:	6a 78                	push   $0x78
  800ee2:	68 e5 27 80 00       	push   $0x8027e5
  800ee7:	e8 67 f2 ff ff       	call   800153 <_panic>
		panic("sys_page_alloc: %e", r);
  800eec:	50                   	push   %eax
  800eed:	68 f0 27 80 00       	push   $0x8027f0
  800ef2:	6a 73                	push   $0x73
  800ef4:	68 e5 27 80 00       	push   $0x8027e5
  800ef9:	e8 55 f2 ff ff       	call   800153 <_panic>
		panic("sys_page_map: %e", r);
  800efe:	50                   	push   %eax
  800eff:	68 d4 27 80 00       	push   $0x8027d4
  800f04:	6a 75                	push   $0x75
  800f06:	68 e5 27 80 00       	push   $0x8027e5
  800f0b:	e8 43 f2 ff ff       	call   800153 <_panic>

00800f10 <pgfault>:
{
  800f10:	f3 0f 1e fb          	endbr32 
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	53                   	push   %ebx
  800f18:	83 ec 04             	sub    $0x4,%esp
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f1e:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800f20:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800f23:	89 da                	mov    %ebx,%edx
  800f25:	c1 ea 0c             	shr    $0xc,%edx
  800f28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800f2f:	a8 01                	test   $0x1,%al
  800f31:	74 7e                	je     800fb1 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800f33:	a8 02                	test   $0x2,%al
  800f35:	0f 84 8a 00 00 00    	je     800fc5 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800f3b:	f6 c6 08             	test   $0x8,%dh
  800f3e:	0f 84 95 00 00 00    	je     800fd9 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	6a 07                	push   $0x7
  800f49:	68 00 f0 7f 00       	push   $0x7ff000
  800f4e:	6a 00                	push   $0x0
  800f50:	e8 d7 fc ff ff       	call   800c2c <sys_page_alloc>
	if (r)
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	0f 85 8d 00 00 00    	jne    800fed <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f60:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	68 00 10 00 00       	push   $0x1000
  800f6e:	53                   	push   %ebx
  800f6f:	68 00 f0 7f 00       	push   $0x7ff000
  800f74:	e8 49 fa ff ff       	call   8009c2 <memcpy>
	r = sys_page_map(
  800f79:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f80:	53                   	push   %ebx
  800f81:	6a 00                	push   $0x0
  800f83:	68 00 f0 7f 00       	push   $0x7ff000
  800f88:	6a 00                	push   $0x0
  800f8a:	e8 c5 fc ff ff       	call   800c54 <sys_page_map>
	if (r)
  800f8f:	83 c4 20             	add    $0x20,%esp
  800f92:	85 c0                	test   %eax,%eax
  800f94:	75 69                	jne    800fff <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	68 00 f0 7f 00       	push   $0x7ff000
  800f9e:	6a 00                	push   $0x0
  800fa0:	e8 d9 fc ff ff       	call   800c7e <sys_page_unmap>
	if (r)
  800fa5:	83 c4 10             	add    $0x10,%esp
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	75 65                	jne    801011 <pgfault+0x101>
}
  800fac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800fb1:	83 ec 04             	sub    $0x4,%esp
  800fb4:	68 84 28 80 00       	push   $0x802884
  800fb9:	6a 20                	push   $0x20
  800fbb:	68 e5 27 80 00       	push   $0x8027e5
  800fc0:	e8 8e f1 ff ff       	call   800153 <_panic>
		panic("[pgfault] pgfault por lectura");
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	68 16 28 80 00       	push   $0x802816
  800fcd:	6a 23                	push   $0x23
  800fcf:	68 e5 27 80 00       	push   $0x8027e5
  800fd4:	e8 7a f1 ff ff       	call   800153 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	68 b0 28 80 00       	push   $0x8028b0
  800fe1:	6a 27                	push   $0x27
  800fe3:	68 e5 27 80 00       	push   $0x8027e5
  800fe8:	e8 66 f1 ff ff       	call   800153 <_panic>
		panic("pgfault: %e", r);
  800fed:	50                   	push   %eax
  800fee:	68 34 28 80 00       	push   $0x802834
  800ff3:	6a 32                	push   $0x32
  800ff5:	68 e5 27 80 00       	push   $0x8027e5
  800ffa:	e8 54 f1 ff ff       	call   800153 <_panic>
		panic("pgfault: %e", r);
  800fff:	50                   	push   %eax
  801000:	68 34 28 80 00       	push   $0x802834
  801005:	6a 39                	push   $0x39
  801007:	68 e5 27 80 00       	push   $0x8027e5
  80100c:	e8 42 f1 ff ff       	call   800153 <_panic>
		panic("pgfault: %e", r);
  801011:	50                   	push   %eax
  801012:	68 34 28 80 00       	push   $0x802834
  801017:	6a 3d                	push   $0x3d
  801019:	68 e5 27 80 00       	push   $0x8027e5
  80101e:	e8 30 f1 ff ff       	call   800153 <_panic>

00801023 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  801023:	f3 0f 1e fb          	endbr32 
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801030:	b8 07 00 00 00       	mov    $0x7,%eax
  801035:	cd 30                	int    $0x30
  801037:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 22                	js     80105f <fork_v0+0x3c>
  80103d:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80103f:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801044:	75 52                	jne    801098 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801046:	e8 8e fb ff ff       	call   800bd9 <sys_getenvid>
  80104b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801050:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801053:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801058:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80105d:	eb 6e                	jmp    8010cd <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80105f:	50                   	push   %eax
  801060:	68 d8 28 80 00       	push   $0x8028d8
  801065:	68 8a 00 00 00       	push   $0x8a
  80106a:	68 e5 27 80 00       	push   $0x8027e5
  80106f:	e8 df f0 ff ff       	call   800153 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801074:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  80107b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801081:	89 da                	mov    %ebx,%edx
  801083:	89 f0                	mov    %esi,%eax
  801085:	e8 b9 fd ff ff       	call   800e43 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80108a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801090:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801096:	74 23                	je     8010bb <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801098:	89 d8                	mov    %ebx,%eax
  80109a:	c1 e8 16             	shr    $0x16,%eax
  80109d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a4:	a8 01                	test   $0x1,%al
  8010a6:	74 e2                	je     80108a <fork_v0+0x67>
  8010a8:	89 d8                	mov    %ebx,%eax
  8010aa:	c1 e8 0c             	shr    $0xc,%eax
  8010ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b4:	f6 c2 01             	test   $0x1,%dl
  8010b7:	74 d1                	je     80108a <fork_v0+0x67>
  8010b9:	eb b9                	jmp    801074 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	6a 02                	push   $0x2
  8010c0:	57                   	push   %edi
  8010c1:	e8 df fb ff ff       	call   800ca5 <sys_env_set_status>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	78 0a                	js     8010d7 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8010cd:	89 f8                	mov    %edi,%eax
  8010cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8010d7:	50                   	push   %eax
  8010d8:	68 fc 28 80 00       	push   $0x8028fc
  8010dd:	68 98 00 00 00       	push   $0x98
  8010e2:	68 e5 27 80 00       	push   $0x8027e5
  8010e7:	e8 67 f0 ff ff       	call   800153 <_panic>

008010ec <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010ec:	f3 0f 1e fb          	endbr32 
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8010f9:	68 10 0f 80 00       	push   $0x800f10
  8010fe:	e8 bd 0e 00 00       	call   801fc0 <set_pgfault_handler>
  801103:	b8 07 00 00 00       	mov    $0x7,%eax
  801108:	cd 30                	int    $0x30
  80110a:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 37                	js     80114a <fork+0x5e>
  801113:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801115:	74 48                	je     80115f <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	6a 07                	push   $0x7
  80111c:	68 00 f0 bf ee       	push   $0xeebff000
  801121:	50                   	push   %eax
  801122:	e8 05 fb ff ff       	call   800c2c <sys_page_alloc>
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	78 4d                	js     80117b <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	68 3d 20 80 00       	push   $0x80203d
  801136:	56                   	push   %esi
  801137:	e8 b7 fb ff ff       	call   800cf3 <sys_env_set_pgfault_upcall>
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	78 4d                	js     801190 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801143:	bb 00 00 00 00       	mov    $0x0,%ebx
  801148:	eb 70                	jmp    8011ba <fork+0xce>
		panic("sys_exofork: %e", envid);
  80114a:	50                   	push   %eax
  80114b:	68 40 28 80 00       	push   $0x802840
  801150:	68 b7 00 00 00       	push   $0xb7
  801155:	68 e5 27 80 00       	push   $0x8027e5
  80115a:	e8 f4 ef ff ff       	call   800153 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80115f:	e8 75 fa ff ff       	call   800bd9 <sys_getenvid>
  801164:	25 ff 03 00 00       	and    $0x3ff,%eax
  801169:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80116c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801171:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801176:	e9 80 00 00 00       	jmp    8011fb <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  80117b:	50                   	push   %eax
  80117c:	68 50 28 80 00       	push   $0x802850
  801181:	68 c0 00 00 00       	push   $0xc0
  801186:	68 e5 27 80 00       	push   $0x8027e5
  80118b:	e8 c3 ef ff ff       	call   800153 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801190:	50                   	push   %eax
  801191:	68 20 29 80 00       	push   $0x802920
  801196:	68 c3 00 00 00       	push   $0xc3
  80119b:	68 e5 27 80 00       	push   $0x8027e5
  8011a0:	e8 ae ef ff ff       	call   800153 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  8011a5:	89 f8                	mov    %edi,%eax
  8011a7:	e8 bd fb ff ff       	call   800d69 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8011ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011b2:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011b8:	74 2f                	je     8011e9 <fork+0xfd>
  8011ba:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  8011bc:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  8011c2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8011c7:	76 e3                	jbe    8011ac <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8011c9:	89 d8                	mov    %ebx,%eax
  8011cb:	c1 e8 16             	shr    $0x16,%eax
  8011ce:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011d5:	a8 01                	test   $0x1,%al
  8011d7:	74 d3                	je     8011ac <fork+0xc0>
  8011d9:	c1 ea 0c             	shr    $0xc,%edx
  8011dc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011e3:	a8 01                	test   $0x1,%al
  8011e5:	74 c5                	je     8011ac <fork+0xc0>
  8011e7:	eb bc                	jmp    8011a5 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	6a 02                	push   $0x2
  8011ee:	56                   	push   %esi
  8011ef:	e8 b1 fa ff ff       	call   800ca5 <sys_env_set_status>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	78 0a                	js     801205 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8011fb:	89 f0                	mov    %esi,%eax
  8011fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801200:	5b                   	pop    %ebx
  801201:	5e                   	pop    %esi
  801202:	5f                   	pop    %edi
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801205:	50                   	push   %eax
  801206:	68 4c 29 80 00       	push   $0x80294c
  80120b:	68 ce 00 00 00       	push   $0xce
  801210:	68 e5 27 80 00       	push   $0x8027e5
  801215:	e8 39 ef ff ff       	call   800153 <_panic>

0080121a <sfork>:

// Challenge!
int
sfork(void)
{
  80121a:	f3 0f 1e fb          	endbr32 
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801224:	68 6e 28 80 00       	push   $0x80286e
  801229:	68 d7 00 00 00       	push   $0xd7
  80122e:	68 e5 27 80 00       	push   $0x8027e5
  801233:	e8 1b ef ff ff       	call   800153 <_panic>

00801238 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801238:	f3 0f 1e fb          	endbr32 
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	05 00 00 00 30       	add    $0x30000000,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124c:	f3 0f 1e fb          	endbr32 
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801256:	ff 75 08             	pushl  0x8(%ebp)
  801259:	e8 da ff ff ff       	call   801238 <fd2num>
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	c1 e0 0c             	shl    $0xc,%eax
  801264:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801277:	89 c2                	mov    %eax,%edx
  801279:	c1 ea 16             	shr    $0x16,%edx
  80127c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801283:	f6 c2 01             	test   $0x1,%dl
  801286:	74 2d                	je     8012b5 <fd_alloc+0x4a>
  801288:	89 c2                	mov    %eax,%edx
  80128a:	c1 ea 0c             	shr    $0xc,%edx
  80128d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801294:	f6 c2 01             	test   $0x1,%dl
  801297:	74 1c                	je     8012b5 <fd_alloc+0x4a>
  801299:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80129e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a3:	75 d2                	jne    801277 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ae:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b3:	eb 0a                	jmp    8012bf <fd_alloc+0x54>
			*fd_store = fd;
  8012b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c1:	f3 0f 1e fb          	endbr32 
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012cb:	83 f8 1f             	cmp    $0x1f,%eax
  8012ce:	77 30                	ja     801300 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d0:	c1 e0 0c             	shl    $0xc,%eax
  8012d3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	74 24                	je     801307 <fd_lookup+0x46>
  8012e3:	89 c2                	mov    %eax,%edx
  8012e5:	c1 ea 0c             	shr    $0xc,%edx
  8012e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ef:	f6 c2 01             	test   $0x1,%dl
  8012f2:	74 1a                	je     80130e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f7:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    
		return -E_INVAL;
  801300:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801305:	eb f7                	jmp    8012fe <fd_lookup+0x3d>
		return -E_INVAL;
  801307:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130c:	eb f0                	jmp    8012fe <fd_lookup+0x3d>
  80130e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801313:	eb e9                	jmp    8012fe <fd_lookup+0x3d>

00801315 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801315:	f3 0f 1e fb          	endbr32 
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801322:	ba ec 29 80 00       	mov    $0x8029ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801327:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132c:	39 08                	cmp    %ecx,(%eax)
  80132e:	74 33                	je     801363 <dev_lookup+0x4e>
  801330:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801333:	8b 02                	mov    (%edx),%eax
  801335:	85 c0                	test   %eax,%eax
  801337:	75 f3                	jne    80132c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801339:	a1 08 40 80 00       	mov    0x804008,%eax
  80133e:	8b 40 48             	mov    0x48(%eax),%eax
  801341:	83 ec 04             	sub    $0x4,%esp
  801344:	51                   	push   %ecx
  801345:	50                   	push   %eax
  801346:	68 70 29 80 00       	push   $0x802970
  80134b:	e8 ea ee ff ff       	call   80023a <cprintf>
	*dev = 0;
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    
			*dev = devtab[i];
  801363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801366:	89 01                	mov    %eax,(%ecx)
			return 0;
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	eb f2                	jmp    801361 <dev_lookup+0x4c>

0080136f <fd_close>:
{
  80136f:	f3 0f 1e fb          	endbr32 
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	57                   	push   %edi
  801377:	56                   	push   %esi
  801378:	53                   	push   %ebx
  801379:	83 ec 28             	sub    $0x28,%esp
  80137c:	8b 75 08             	mov    0x8(%ebp),%esi
  80137f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801382:	56                   	push   %esi
  801383:	e8 b0 fe ff ff       	call   801238 <fd2num>
  801388:	83 c4 08             	add    $0x8,%esp
  80138b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80138e:	52                   	push   %edx
  80138f:	50                   	push   %eax
  801390:	e8 2c ff ff ff       	call   8012c1 <fd_lookup>
  801395:	89 c3                	mov    %eax,%ebx
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 05                	js     8013a3 <fd_close+0x34>
	    || fd != fd2)
  80139e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013a1:	74 16                	je     8013b9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013a3:	89 f8                	mov    %edi,%eax
  8013a5:	84 c0                	test   %al,%al
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ac:	0f 44 d8             	cmove  %eax,%ebx
}
  8013af:	89 d8                	mov    %ebx,%eax
  8013b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b4:	5b                   	pop    %ebx
  8013b5:	5e                   	pop    %esi
  8013b6:	5f                   	pop    %edi
  8013b7:	5d                   	pop    %ebp
  8013b8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 36                	pushl  (%esi)
  8013c2:	e8 4e ff ff ff       	call   801315 <dev_lookup>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 1a                	js     8013ea <fd_close+0x7b>
		if (dev->dev_close)
  8013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	74 0b                	je     8013ea <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	56                   	push   %esi
  8013e3:	ff d0                	call   *%eax
  8013e5:	89 c3                	mov    %eax,%ebx
  8013e7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	56                   	push   %esi
  8013ee:	6a 00                	push   $0x0
  8013f0:	e8 89 f8 ff ff       	call   800c7e <sys_page_unmap>
	return r;
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	eb b5                	jmp    8013af <fd_close+0x40>

008013fa <close>:

int
close(int fdnum)
{
  8013fa:	f3 0f 1e fb          	endbr32 
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801404:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801407:	50                   	push   %eax
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	e8 b1 fe ff ff       	call   8012c1 <fd_lookup>
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	79 02                	jns    801419 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    
		return fd_close(fd, 1);
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	6a 01                	push   $0x1
  80141e:	ff 75 f4             	pushl  -0xc(%ebp)
  801421:	e8 49 ff ff ff       	call   80136f <fd_close>
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb ec                	jmp    801417 <close+0x1d>

0080142b <close_all>:

void
close_all(void)
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	53                   	push   %ebx
  801433:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801436:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80143b:	83 ec 0c             	sub    $0xc,%esp
  80143e:	53                   	push   %ebx
  80143f:	e8 b6 ff ff ff       	call   8013fa <close>
	for (i = 0; i < MAXFD; i++)
  801444:	83 c3 01             	add    $0x1,%ebx
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	83 fb 20             	cmp    $0x20,%ebx
  80144d:	75 ec                	jne    80143b <close_all+0x10>
}
  80144f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801454:	f3 0f 1e fb          	endbr32 
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801461:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 54 fe ff ff       	call   8012c1 <fd_lookup>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	0f 88 81 00 00 00    	js     8014fb <dup+0xa7>
		return r;
	close(newfdnum);
  80147a:	83 ec 0c             	sub    $0xc,%esp
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	e8 75 ff ff ff       	call   8013fa <close>

	newfd = INDEX2FD(newfdnum);
  801485:	8b 75 0c             	mov    0xc(%ebp),%esi
  801488:	c1 e6 0c             	shl    $0xc,%esi
  80148b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	ff 75 e4             	pushl  -0x1c(%ebp)
  801497:	e8 b0 fd ff ff       	call   80124c <fd2data>
  80149c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80149e:	89 34 24             	mov    %esi,(%esp)
  8014a1:	e8 a6 fd ff ff       	call   80124c <fd2data>
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014ab:	89 d8                	mov    %ebx,%eax
  8014ad:	c1 e8 16             	shr    $0x16,%eax
  8014b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b7:	a8 01                	test   $0x1,%al
  8014b9:	74 11                	je     8014cc <dup+0x78>
  8014bb:	89 d8                	mov    %ebx,%eax
  8014bd:	c1 e8 0c             	shr    $0xc,%eax
  8014c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014c7:	f6 c2 01             	test   $0x1,%dl
  8014ca:	75 39                	jne    801505 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014cf:	89 d0                	mov    %edx,%eax
  8014d1:	c1 e8 0c             	shr    $0xc,%eax
  8014d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e3:	50                   	push   %eax
  8014e4:	56                   	push   %esi
  8014e5:	6a 00                	push   $0x0
  8014e7:	52                   	push   %edx
  8014e8:	6a 00                	push   $0x0
  8014ea:	e8 65 f7 ff ff       	call   800c54 <sys_page_map>
  8014ef:	89 c3                	mov    %eax,%ebx
  8014f1:	83 c4 20             	add    $0x20,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 31                	js     801529 <dup+0xd5>
		goto err;

	return newfdnum;
  8014f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014fb:	89 d8                	mov    %ebx,%eax
  8014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801505:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	25 07 0e 00 00       	and    $0xe07,%eax
  801514:	50                   	push   %eax
  801515:	57                   	push   %edi
  801516:	6a 00                	push   $0x0
  801518:	53                   	push   %ebx
  801519:	6a 00                	push   $0x0
  80151b:	e8 34 f7 ff ff       	call   800c54 <sys_page_map>
  801520:	89 c3                	mov    %eax,%ebx
  801522:	83 c4 20             	add    $0x20,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	79 a3                	jns    8014cc <dup+0x78>
	sys_page_unmap(0, newfd);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	56                   	push   %esi
  80152d:	6a 00                	push   $0x0
  80152f:	e8 4a f7 ff ff       	call   800c7e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801534:	83 c4 08             	add    $0x8,%esp
  801537:	57                   	push   %edi
  801538:	6a 00                	push   $0x0
  80153a:	e8 3f f7 ff ff       	call   800c7e <sys_page_unmap>
	return r;
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	eb b7                	jmp    8014fb <dup+0xa7>

00801544 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801544:	f3 0f 1e fb          	endbr32 
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
  80154c:	83 ec 1c             	sub    $0x1c,%esp
  80154f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801552:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	53                   	push   %ebx
  801557:	e8 65 fd ff ff       	call   8012c1 <fd_lookup>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 3f                	js     8015a2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156d:	ff 30                	pushl  (%eax)
  80156f:	e8 a1 fd ff ff       	call   801315 <dev_lookup>
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	85 c0                	test   %eax,%eax
  801579:	78 27                	js     8015a2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80157b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157e:	8b 42 08             	mov    0x8(%edx),%eax
  801581:	83 e0 03             	and    $0x3,%eax
  801584:	83 f8 01             	cmp    $0x1,%eax
  801587:	74 1e                	je     8015a7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158c:	8b 40 08             	mov    0x8(%eax),%eax
  80158f:	85 c0                	test   %eax,%eax
  801591:	74 35                	je     8015c8 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	ff 75 10             	pushl  0x10(%ebp)
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	52                   	push   %edx
  80159d:	ff d0                	call   *%eax
  80159f:	83 c4 10             	add    $0x10,%esp
}
  8015a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8015ac:	8b 40 48             	mov    0x48(%eax),%eax
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	53                   	push   %ebx
  8015b3:	50                   	push   %eax
  8015b4:	68 b1 29 80 00       	push   $0x8029b1
  8015b9:	e8 7c ec ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c6:	eb da                	jmp    8015a2 <read+0x5e>
		return -E_NOT_SUPP;
  8015c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015cd:	eb d3                	jmp    8015a2 <read+0x5e>

008015cf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015cf:	f3 0f 1e fb          	endbr32 
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	57                   	push   %edi
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015df:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e7:	eb 02                	jmp    8015eb <readn+0x1c>
  8015e9:	01 c3                	add    %eax,%ebx
  8015eb:	39 f3                	cmp    %esi,%ebx
  8015ed:	73 21                	jae    801610 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	89 f0                	mov    %esi,%eax
  8015f4:	29 d8                	sub    %ebx,%eax
  8015f6:	50                   	push   %eax
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	03 45 0c             	add    0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	57                   	push   %edi
  8015fe:	e8 41 ff ff ff       	call   801544 <read>
		if (m < 0)
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 04                	js     80160e <readn+0x3f>
			return m;
		if (m == 0)
  80160a:	75 dd                	jne    8015e9 <readn+0x1a>
  80160c:	eb 02                	jmp    801610 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801610:	89 d8                	mov    %ebx,%eax
  801612:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5f                   	pop    %edi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80161a:	f3 0f 1e fb          	endbr32 
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	53                   	push   %ebx
  801622:	83 ec 1c             	sub    $0x1c,%esp
  801625:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801628:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	53                   	push   %ebx
  80162d:	e8 8f fc ff ff       	call   8012c1 <fd_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 3a                	js     801673 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163f:	50                   	push   %eax
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	ff 30                	pushl  (%eax)
  801645:	e8 cb fc ff ff       	call   801315 <dev_lookup>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	78 22                	js     801673 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801654:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801658:	74 1e                	je     801678 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165d:	8b 52 0c             	mov    0xc(%edx),%edx
  801660:	85 d2                	test   %edx,%edx
  801662:	74 35                	je     801699 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	ff 75 10             	pushl  0x10(%ebp)
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	50                   	push   %eax
  80166e:	ff d2                	call   *%edx
  801670:	83 c4 10             	add    $0x10,%esp
}
  801673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801676:	c9                   	leave  
  801677:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801678:	a1 08 40 80 00       	mov    0x804008,%eax
  80167d:	8b 40 48             	mov    0x48(%eax),%eax
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	53                   	push   %ebx
  801684:	50                   	push   %eax
  801685:	68 cd 29 80 00       	push   $0x8029cd
  80168a:	e8 ab eb ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801697:	eb da                	jmp    801673 <write+0x59>
		return -E_NOT_SUPP;
  801699:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169e:	eb d3                	jmp    801673 <write+0x59>

008016a0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016a0:	f3 0f 1e fb          	endbr32 
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 0b fc ff ff       	call   8012c1 <fd_lookup>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 0e                	js     8016cb <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016cd:	f3 0f 1e fb          	endbr32 
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 1c             	sub    $0x1c,%esp
  8016d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016de:	50                   	push   %eax
  8016df:	53                   	push   %ebx
  8016e0:	e8 dc fb ff ff       	call   8012c1 <fd_lookup>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	78 37                	js     801723 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f2:	50                   	push   %eax
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	ff 30                	pushl  (%eax)
  8016f8:	e8 18 fc ff ff       	call   801315 <dev_lookup>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	78 1f                	js     801723 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80170b:	74 1b                	je     801728 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80170d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801710:	8b 52 18             	mov    0x18(%edx),%edx
  801713:	85 d2                	test   %edx,%edx
  801715:	74 32                	je     801749 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	50                   	push   %eax
  80171e:	ff d2                	call   *%edx
  801720:	83 c4 10             	add    $0x10,%esp
}
  801723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801726:	c9                   	leave  
  801727:	c3                   	ret    
			thisenv->env_id, fdnum);
  801728:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80172d:	8b 40 48             	mov    0x48(%eax),%eax
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	53                   	push   %ebx
  801734:	50                   	push   %eax
  801735:	68 90 29 80 00       	push   $0x802990
  80173a:	e8 fb ea ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801747:	eb da                	jmp    801723 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801749:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174e:	eb d3                	jmp    801723 <ftruncate+0x56>

00801750 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801750:	f3 0f 1e fb          	endbr32 
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	53                   	push   %ebx
  801758:	83 ec 1c             	sub    $0x1c,%esp
  80175b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	e8 57 fb ff ff       	call   8012c1 <fd_lookup>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 4b                	js     8017bc <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801777:	50                   	push   %eax
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	ff 30                	pushl  (%eax)
  80177d:	e8 93 fb ff ff       	call   801315 <dev_lookup>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 33                	js     8017bc <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801790:	74 2f                	je     8017c1 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801792:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801795:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80179c:	00 00 00 
	stat->st_isdir = 0;
  80179f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a6:	00 00 00 
	stat->st_dev = dev;
  8017a9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	53                   	push   %ebx
  8017b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b6:	ff 50 14             	call   *0x14(%eax)
  8017b9:	83 c4 10             	add    $0x10,%esp
}
  8017bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    
		return -E_NOT_SUPP;
  8017c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c6:	eb f4                	jmp    8017bc <fstat+0x6c>

008017c8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017c8:	f3 0f 1e fb          	endbr32 
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 3a 02 00 00       	call   801a18 <open>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 1b                	js     801802 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	50                   	push   %eax
  8017ee:	e8 5d ff ff ff       	call   801750 <fstat>
  8017f3:	89 c6                	mov    %eax,%esi
	close(fd);
  8017f5:	89 1c 24             	mov    %ebx,(%esp)
  8017f8:	e8 fd fb ff ff       	call   8013fa <close>
	return r;
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	89 f3                	mov    %esi,%ebx
}
  801802:	89 d8                	mov    %ebx,%eax
  801804:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801807:	5b                   	pop    %ebx
  801808:	5e                   	pop    %esi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	89 c6                	mov    %eax,%esi
  801812:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801814:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80181b:	74 27                	je     801844 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80181d:	6a 07                	push   $0x7
  80181f:	68 00 50 80 00       	push   $0x805000
  801824:	56                   	push   %esi
  801825:	ff 35 00 40 80 00    	pushl  0x804000
  80182b:	e8 a0 08 00 00       	call   8020d0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801830:	83 c4 0c             	add    $0xc,%esp
  801833:	6a 00                	push   $0x0
  801835:	53                   	push   %ebx
  801836:	6a 00                	push   $0x0
  801838:	e8 26 08 00 00       	call   802063 <ipc_recv>
}
  80183d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801844:	83 ec 0c             	sub    $0xc,%esp
  801847:	6a 01                	push   $0x1
  801849:	e8 da 08 00 00       	call   802128 <ipc_find_env>
  80184e:	a3 00 40 80 00       	mov    %eax,0x804000
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	eb c5                	jmp    80181d <fsipc+0x12>

00801858 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801858:	f3 0f 1e fb          	endbr32 
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8b 40 0c             	mov    0xc(%eax),%eax
  801868:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80186d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801870:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801875:	ba 00 00 00 00       	mov    $0x0,%edx
  80187a:	b8 02 00 00 00       	mov    $0x2,%eax
  80187f:	e8 87 ff ff ff       	call   80180b <fsipc>
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <devfile_flush>:
{
  801886:	f3 0f 1e fb          	endbr32 
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 40 0c             	mov    0xc(%eax),%eax
  801896:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	b8 06 00 00 00       	mov    $0x6,%eax
  8018a5:	e8 61 ff ff ff       	call   80180b <fsipc>
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <devfile_stat>:
{
  8018ac:	f3 0f 1e fb          	endbr32 
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ca:	b8 05 00 00 00       	mov    $0x5,%eax
  8018cf:	e8 37 ff ff ff       	call   80180b <fsipc>
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 2c                	js     801904 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	68 00 50 80 00       	push   $0x805000
  8018e0:	53                   	push   %ebx
  8018e1:	e8 be ee ff ff       	call   8007a4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018e6:	a1 80 50 80 00       	mov    0x805080,%eax
  8018eb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018f1:	a1 84 50 80 00       	mov    0x805084,%eax
  8018f6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <devfile_write>:
{
  801909:	f3 0f 1e fb          	endbr32 
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	53                   	push   %ebx
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	8b 40 0c             	mov    0xc(%eax),%eax
  80191d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801922:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801928:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80192e:	77 30                	ja     801960 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	53                   	push   %ebx
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	68 08 50 80 00       	push   $0x805008
  80193c:	e8 1b f0 ff ff       	call   80095c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	b8 04 00 00 00       	mov    $0x4,%eax
  80194b:	e8 bb fe ff ff       	call   80180b <fsipc>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	85 c0                	test   %eax,%eax
  801955:	78 04                	js     80195b <devfile_write+0x52>
	assert(r <= n);
  801957:	39 d8                	cmp    %ebx,%eax
  801959:	77 1e                	ja     801979 <devfile_write+0x70>
}
  80195b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801960:	68 fc 29 80 00       	push   $0x8029fc
  801965:	68 29 2a 80 00       	push   $0x802a29
  80196a:	68 94 00 00 00       	push   $0x94
  80196f:	68 3e 2a 80 00       	push   $0x802a3e
  801974:	e8 da e7 ff ff       	call   800153 <_panic>
	assert(r <= n);
  801979:	68 49 2a 80 00       	push   $0x802a49
  80197e:	68 29 2a 80 00       	push   $0x802a29
  801983:	68 98 00 00 00       	push   $0x98
  801988:	68 3e 2a 80 00       	push   $0x802a3e
  80198d:	e8 c1 e7 ff ff       	call   800153 <_panic>

00801992 <devfile_read>:
{
  801992:	f3 0f 1e fb          	endbr32 
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019a9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8019b9:	e8 4d fe ff ff       	call   80180b <fsipc>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 1f                	js     8019e3 <devfile_read+0x51>
	assert(r <= n);
  8019c4:	39 f0                	cmp    %esi,%eax
  8019c6:	77 24                	ja     8019ec <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019c8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019cd:	7f 33                	jg     801a02 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	50                   	push   %eax
  8019d3:	68 00 50 80 00       	push   $0x805000
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	e8 7c ef ff ff       	call   80095c <memmove>
	return r;
  8019e0:	83 c4 10             	add    $0x10,%esp
}
  8019e3:	89 d8                	mov    %ebx,%eax
  8019e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5e                   	pop    %esi
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    
	assert(r <= n);
  8019ec:	68 49 2a 80 00       	push   $0x802a49
  8019f1:	68 29 2a 80 00       	push   $0x802a29
  8019f6:	6a 7c                	push   $0x7c
  8019f8:	68 3e 2a 80 00       	push   $0x802a3e
  8019fd:	e8 51 e7 ff ff       	call   800153 <_panic>
	assert(r <= PGSIZE);
  801a02:	68 50 2a 80 00       	push   $0x802a50
  801a07:	68 29 2a 80 00       	push   $0x802a29
  801a0c:	6a 7d                	push   $0x7d
  801a0e:	68 3e 2a 80 00       	push   $0x802a3e
  801a13:	e8 3b e7 ff ff       	call   800153 <_panic>

00801a18 <open>:
{
  801a18:	f3 0f 1e fb          	endbr32 
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	56                   	push   %esi
  801a20:	53                   	push   %ebx
  801a21:	83 ec 1c             	sub    $0x1c,%esp
  801a24:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a27:	56                   	push   %esi
  801a28:	e8 34 ed ff ff       	call   800761 <strlen>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a35:	7f 6c                	jg     801aa3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3d:	50                   	push   %eax
  801a3e:	e8 28 f8 ff ff       	call   80126b <fd_alloc>
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 3c                	js     801a88 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a4c:	83 ec 08             	sub    $0x8,%esp
  801a4f:	56                   	push   %esi
  801a50:	68 00 50 80 00       	push   $0x805000
  801a55:	e8 4a ed ff ff       	call   8007a4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	e8 9c fd ff ff       	call   80180b <fsipc>
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 19                	js     801a91 <open+0x79>
	return fd2num(fd);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7e:	e8 b5 f7 ff ff       	call   801238 <fd2num>
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	83 c4 10             	add    $0x10,%esp
}
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    
		fd_close(fd, 0);
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 f4             	pushl  -0xc(%ebp)
  801a99:	e8 d1 f8 ff ff       	call   80136f <fd_close>
		return r;
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	eb e5                	jmp    801a88 <open+0x70>
		return -E_BAD_PATH;
  801aa3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aa8:	eb de                	jmp    801a88 <open+0x70>

00801aaa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aaa:	f3 0f 1e fb          	endbr32 
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	b8 08 00 00 00       	mov    $0x8,%eax
  801abe:	e8 48 fd ff ff       	call   80180b <fsipc>
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac5:	f3 0f 1e fb          	endbr32 
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
  801ace:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad1:	83 ec 0c             	sub    $0xc,%esp
  801ad4:	ff 75 08             	pushl  0x8(%ebp)
  801ad7:	e8 70 f7 ff ff       	call   80124c <fd2data>
  801adc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ade:	83 c4 08             	add    $0x8,%esp
  801ae1:	68 5c 2a 80 00       	push   $0x802a5c
  801ae6:	53                   	push   %ebx
  801ae7:	e8 b8 ec ff ff       	call   8007a4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aec:	8b 46 04             	mov    0x4(%esi),%eax
  801aef:	2b 06                	sub    (%esi),%eax
  801af1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801af7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801afe:	00 00 00 
	stat->st_dev = &devpipe;
  801b01:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b08:	30 80 00 
	return 0;
}
  801b0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5d                   	pop    %ebp
  801b16:	c3                   	ret    

00801b17 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b17:	f3 0f 1e fb          	endbr32 
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b25:	53                   	push   %ebx
  801b26:	6a 00                	push   $0x0
  801b28:	e8 51 f1 ff ff       	call   800c7e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b2d:	89 1c 24             	mov    %ebx,(%esp)
  801b30:	e8 17 f7 ff ff       	call   80124c <fd2data>
  801b35:	83 c4 08             	add    $0x8,%esp
  801b38:	50                   	push   %eax
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 3e f1 ff ff       	call   800c7e <sys_page_unmap>
}
  801b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <_pipeisclosed>:
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	57                   	push   %edi
  801b49:	56                   	push   %esi
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 1c             	sub    $0x1c,%esp
  801b4e:	89 c7                	mov    %eax,%edi
  801b50:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b52:	a1 08 40 80 00       	mov    0x804008,%eax
  801b57:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	57                   	push   %edi
  801b5e:	e8 02 06 00 00       	call   802165 <pageref>
  801b63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b66:	89 34 24             	mov    %esi,(%esp)
  801b69:	e8 f7 05 00 00       	call   802165 <pageref>
		nn = thisenv->env_runs;
  801b6e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b74:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	39 cb                	cmp    %ecx,%ebx
  801b7c:	74 1b                	je     801b99 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b81:	75 cf                	jne    801b52 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b83:	8b 42 58             	mov    0x58(%edx),%eax
  801b86:	6a 01                	push   $0x1
  801b88:	50                   	push   %eax
  801b89:	53                   	push   %ebx
  801b8a:	68 63 2a 80 00       	push   $0x802a63
  801b8f:	e8 a6 e6 ff ff       	call   80023a <cprintf>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	eb b9                	jmp    801b52 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b99:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9c:	0f 94 c0             	sete   %al
  801b9f:	0f b6 c0             	movzbl %al,%eax
}
  801ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5f                   	pop    %edi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <devpipe_write>:
{
  801baa:	f3 0f 1e fb          	endbr32 
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	57                   	push   %edi
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 28             	sub    $0x28,%esp
  801bb7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bba:	56                   	push   %esi
  801bbb:	e8 8c f6 ff ff       	call   80124c <fd2data>
  801bc0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bca:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bcd:	74 4f                	je     801c1e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bcf:	8b 43 04             	mov    0x4(%ebx),%eax
  801bd2:	8b 0b                	mov    (%ebx),%ecx
  801bd4:	8d 51 20             	lea    0x20(%ecx),%edx
  801bd7:	39 d0                	cmp    %edx,%eax
  801bd9:	72 14                	jb     801bef <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bdb:	89 da                	mov    %ebx,%edx
  801bdd:	89 f0                	mov    %esi,%eax
  801bdf:	e8 61 ff ff ff       	call   801b45 <_pipeisclosed>
  801be4:	85 c0                	test   %eax,%eax
  801be6:	75 3b                	jne    801c23 <devpipe_write+0x79>
			sys_yield();
  801be8:	e8 14 f0 ff ff       	call   800c01 <sys_yield>
  801bed:	eb e0                	jmp    801bcf <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bf6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bf9:	89 c2                	mov    %eax,%edx
  801bfb:	c1 fa 1f             	sar    $0x1f,%edx
  801bfe:	89 d1                	mov    %edx,%ecx
  801c00:	c1 e9 1b             	shr    $0x1b,%ecx
  801c03:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c06:	83 e2 1f             	and    $0x1f,%edx
  801c09:	29 ca                	sub    %ecx,%edx
  801c0b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c0f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c13:	83 c0 01             	add    $0x1,%eax
  801c16:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c19:	83 c7 01             	add    $0x1,%edi
  801c1c:	eb ac                	jmp    801bca <devpipe_write+0x20>
	return i;
  801c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c21:	eb 05                	jmp    801c28 <devpipe_write+0x7e>
				return 0;
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <devpipe_read>:
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	57                   	push   %edi
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 18             	sub    $0x18,%esp
  801c3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c40:	57                   	push   %edi
  801c41:	e8 06 f6 ff ff       	call   80124c <fd2data>
  801c46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	be 00 00 00 00       	mov    $0x0,%esi
  801c50:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c53:	75 14                	jne    801c69 <devpipe_read+0x39>
	return i;
  801c55:	8b 45 10             	mov    0x10(%ebp),%eax
  801c58:	eb 02                	jmp    801c5c <devpipe_read+0x2c>
				return i;
  801c5a:	89 f0                	mov    %esi,%eax
}
  801c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
			sys_yield();
  801c64:	e8 98 ef ff ff       	call   800c01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c69:	8b 03                	mov    (%ebx),%eax
  801c6b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c6e:	75 18                	jne    801c88 <devpipe_read+0x58>
			if (i > 0)
  801c70:	85 f6                	test   %esi,%esi
  801c72:	75 e6                	jne    801c5a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c74:	89 da                	mov    %ebx,%edx
  801c76:	89 f8                	mov    %edi,%eax
  801c78:	e8 c8 fe ff ff       	call   801b45 <_pipeisclosed>
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	74 e3                	je     801c64 <devpipe_read+0x34>
				return 0;
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	eb d4                	jmp    801c5c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c88:	99                   	cltd   
  801c89:	c1 ea 1b             	shr    $0x1b,%edx
  801c8c:	01 d0                	add    %edx,%eax
  801c8e:	83 e0 1f             	and    $0x1f,%eax
  801c91:	29 d0                	sub    %edx,%eax
  801c93:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c9e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ca1:	83 c6 01             	add    $0x1,%esi
  801ca4:	eb aa                	jmp    801c50 <devpipe_read+0x20>

00801ca6 <pipe>:
{
  801ca6:	f3 0f 1e fb          	endbr32 
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	56                   	push   %esi
  801cae:	53                   	push   %ebx
  801caf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb5:	50                   	push   %eax
  801cb6:	e8 b0 f5 ff ff       	call   80126b <fd_alloc>
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	0f 88 23 01 00 00    	js     801deb <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 07 04 00 00       	push   $0x407
  801cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd3:	6a 00                	push   $0x0
  801cd5:	e8 52 ef ff ff       	call   800c2c <sys_page_alloc>
  801cda:	89 c3                	mov    %eax,%ebx
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	0f 88 04 01 00 00    	js     801deb <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ce7:	83 ec 0c             	sub    $0xc,%esp
  801cea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ced:	50                   	push   %eax
  801cee:	e8 78 f5 ff ff       	call   80126b <fd_alloc>
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	0f 88 db 00 00 00    	js     801ddb <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	68 07 04 00 00       	push   $0x407
  801d08:	ff 75 f0             	pushl  -0x10(%ebp)
  801d0b:	6a 00                	push   $0x0
  801d0d:	e8 1a ef ff ff       	call   800c2c <sys_page_alloc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	0f 88 bc 00 00 00    	js     801ddb <pipe+0x135>
	va = fd2data(fd0);
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	ff 75 f4             	pushl  -0xc(%ebp)
  801d25:	e8 22 f5 ff ff       	call   80124c <fd2data>
  801d2a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2c:	83 c4 0c             	add    $0xc,%esp
  801d2f:	68 07 04 00 00       	push   $0x407
  801d34:	50                   	push   %eax
  801d35:	6a 00                	push   $0x0
  801d37:	e8 f0 ee ff ff       	call   800c2c <sys_page_alloc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	0f 88 82 00 00 00    	js     801dcb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4f:	e8 f8 f4 ff ff       	call   80124c <fd2data>
  801d54:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d5b:	50                   	push   %eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	56                   	push   %esi
  801d5f:	6a 00                	push   $0x0
  801d61:	e8 ee ee ff ff       	call   800c54 <sys_page_map>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	83 c4 20             	add    $0x20,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 4e                	js     801dbd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d6f:	a1 20 30 80 00       	mov    0x803020,%eax
  801d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d77:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d86:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	ff 75 f4             	pushl  -0xc(%ebp)
  801d98:	e8 9b f4 ff ff       	call   801238 <fd2num>
  801d9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801da2:	83 c4 04             	add    $0x4,%esp
  801da5:	ff 75 f0             	pushl  -0x10(%ebp)
  801da8:	e8 8b f4 ff ff       	call   801238 <fd2num>
  801dad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dbb:	eb 2e                	jmp    801deb <pipe+0x145>
	sys_page_unmap(0, va);
  801dbd:	83 ec 08             	sub    $0x8,%esp
  801dc0:	56                   	push   %esi
  801dc1:	6a 00                	push   $0x0
  801dc3:	e8 b6 ee ff ff       	call   800c7e <sys_page_unmap>
  801dc8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dcb:	83 ec 08             	sub    $0x8,%esp
  801dce:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd1:	6a 00                	push   $0x0
  801dd3:	e8 a6 ee ff ff       	call   800c7e <sys_page_unmap>
  801dd8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 f4             	pushl  -0xc(%ebp)
  801de1:	6a 00                	push   $0x0
  801de3:	e8 96 ee ff ff       	call   800c7e <sys_page_unmap>
  801de8:	83 c4 10             	add    $0x10,%esp
}
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <pipeisclosed>:
{
  801df4:	f3 0f 1e fb          	endbr32 
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	e8 b7 f4 ff ff       	call   8012c1 <fd_lookup>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 18                	js     801e29 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 f4             	pushl  -0xc(%ebp)
  801e17:	e8 30 f4 ff ff       	call   80124c <fd2data>
  801e1c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	e8 1f fd ff ff       	call   801b45 <_pipeisclosed>
  801e26:	83 c4 10             	add    $0x10,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e2b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	c3                   	ret    

00801e35 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e35:	f3 0f 1e fb          	endbr32 
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e3f:	68 7b 2a 80 00       	push   $0x802a7b
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	e8 58 e9 ff ff       	call   8007a4 <strcpy>
	return 0;
}
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <devcons_write>:
{
  801e53:	f3 0f 1e fb          	endbr32 
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	57                   	push   %edi
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e68:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e71:	73 31                	jae    801ea4 <devcons_write+0x51>
		m = n - tot;
  801e73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e76:	29 f3                	sub    %esi,%ebx
  801e78:	83 fb 7f             	cmp    $0x7f,%ebx
  801e7b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e80:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	53                   	push   %ebx
  801e87:	89 f0                	mov    %esi,%eax
  801e89:	03 45 0c             	add    0xc(%ebp),%eax
  801e8c:	50                   	push   %eax
  801e8d:	57                   	push   %edi
  801e8e:	e8 c9 ea ff ff       	call   80095c <memmove>
		sys_cputs(buf, m);
  801e93:	83 c4 08             	add    $0x8,%esp
  801e96:	53                   	push   %ebx
  801e97:	57                   	push   %edi
  801e98:	e8 c4 ec ff ff       	call   800b61 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e9d:	01 de                	add    %ebx,%esi
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	eb ca                	jmp    801e6e <devcons_write+0x1b>
}
  801ea4:	89 f0                	mov    %esi,%eax
  801ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea9:	5b                   	pop    %ebx
  801eaa:	5e                   	pop    %esi
  801eab:	5f                   	pop    %edi
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <devcons_read>:
{
  801eae:	f3 0f 1e fb          	endbr32 
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec1:	74 21                	je     801ee4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ec3:	e8 c3 ec ff ff       	call   800b8b <sys_cgetc>
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	75 07                	jne    801ed3 <devcons_read+0x25>
		sys_yield();
  801ecc:	e8 30 ed ff ff       	call   800c01 <sys_yield>
  801ed1:	eb f0                	jmp    801ec3 <devcons_read+0x15>
	if (c < 0)
  801ed3:	78 0f                	js     801ee4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ed5:	83 f8 04             	cmp    $0x4,%eax
  801ed8:	74 0c                	je     801ee6 <devcons_read+0x38>
	*(char*)vbuf = c;
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	88 02                	mov    %al,(%edx)
	return 1;
  801edf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    
		return 0;
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	eb f7                	jmp    801ee4 <devcons_read+0x36>

00801eed <cputchar>:
{
  801eed:	f3 0f 1e fb          	endbr32 
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801efd:	6a 01                	push   $0x1
  801eff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f02:	50                   	push   %eax
  801f03:	e8 59 ec ff ff       	call   800b61 <sys_cputs>
}
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <getchar>:
{
  801f0d:	f3 0f 1e fb          	endbr32 
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f17:	6a 01                	push   $0x1
  801f19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1c:	50                   	push   %eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	e8 20 f6 ff ff       	call   801544 <read>
	if (r < 0)
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 06                	js     801f31 <getchar+0x24>
	if (r < 1)
  801f2b:	74 06                	je     801f33 <getchar+0x26>
	return c;
  801f2d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    
		return -E_EOF;
  801f33:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f38:	eb f7                	jmp    801f31 <getchar+0x24>

00801f3a <iscons>:
{
  801f3a:	f3 0f 1e fb          	endbr32 
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f47:	50                   	push   %eax
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	e8 71 f3 ff ff       	call   8012c1 <fd_lookup>
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	85 c0                	test   %eax,%eax
  801f55:	78 11                	js     801f68 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f60:	39 10                	cmp    %edx,(%eax)
  801f62:	0f 94 c0             	sete   %al
  801f65:	0f b6 c0             	movzbl %al,%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <opencons>:
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f77:	50                   	push   %eax
  801f78:	e8 ee f2 ff ff       	call   80126b <fd_alloc>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 3a                	js     801fbe <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	68 07 04 00 00       	push   $0x407
  801f8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 96 ec ff ff       	call   800c2c <sys_page_alloc>
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 21                	js     801fbe <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fa6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb2:	83 ec 0c             	sub    $0xc,%esp
  801fb5:	50                   	push   %eax
  801fb6:	e8 7d f2 ff ff       	call   801238 <fd2num>
  801fbb:	83 c4 10             	add    $0x10,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fc0:	f3 0f 1e fb          	endbr32 
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fca:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fd1:	74 0a                	je     801fdd <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  801fdd:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe2:	8b 40 48             	mov    0x48(%eax),%eax
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	6a 07                	push   $0x7
  801fea:	68 00 f0 bf ee       	push   $0xeebff000
  801fef:	50                   	push   %eax
  801ff0:	e8 37 ec ff ff       	call   800c2c <sys_page_alloc>
		if (r!= 0)
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	75 2f                	jne    80202b <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801ffc:	a1 08 40 80 00       	mov    0x804008,%eax
  802001:	8b 40 48             	mov    0x48(%eax),%eax
  802004:	83 ec 08             	sub    $0x8,%esp
  802007:	68 3d 20 80 00       	push   $0x80203d
  80200c:	50                   	push   %eax
  80200d:	e8 e1 ec ff ff       	call   800cf3 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 c0                	test   %eax,%eax
  802017:	74 ba                	je     801fd3 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802019:	50                   	push   %eax
  80201a:	68 87 2a 80 00       	push   $0x802a87
  80201f:	6a 26                	push   $0x26
  802021:	68 9f 2a 80 00       	push   $0x802a9f
  802026:	e8 28 e1 ff ff       	call   800153 <_panic>
			panic("set_pgfault_handler: %e", r);
  80202b:	50                   	push   %eax
  80202c:	68 87 2a 80 00       	push   $0x802a87
  802031:	6a 22                	push   $0x22
  802033:	68 9f 2a 80 00       	push   $0x802a9f
  802038:	e8 16 e1 ff ff       	call   800153 <_panic>

0080203d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80203d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80203e:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802043:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802045:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802048:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80204c:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80204f:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802053:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802057:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802059:	83 c4 08             	add    $0x8,%esp
	popal
  80205c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80205d:	83 c4 04             	add    $0x4,%esp
	popfl
  802060:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802061:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802062:	c3                   	ret    

00802063 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802063:	f3 0f 1e fb          	endbr32 
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	56                   	push   %esi
  80206b:	53                   	push   %ebx
  80206c:	8b 75 08             	mov    0x8(%ebp),%esi
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  802075:	85 c0                	test   %eax,%eax
  802077:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80207c:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  80207f:	83 ec 0c             	sub    $0xc,%esp
  802082:	50                   	push   %eax
  802083:	e8 bb ec ff ff       	call   800d43 <sys_ipc_recv>
	if (r < 0) {
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 2b                	js     8020ba <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  80208f:	85 f6                	test   %esi,%esi
  802091:	74 0a                	je     80209d <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  802093:	a1 08 40 80 00       	mov    0x804008,%eax
  802098:	8b 40 74             	mov    0x74(%eax),%eax
  80209b:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  80209d:	85 db                	test   %ebx,%ebx
  80209f:	74 0a                	je     8020ab <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8020a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8020a6:	8b 40 78             	mov    0x78(%eax),%eax
  8020a9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8020b0:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b6:	5b                   	pop    %ebx
  8020b7:	5e                   	pop    %esi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    
		if (from_env_store) {
  8020ba:	85 f6                	test   %esi,%esi
  8020bc:	74 06                	je     8020c4 <ipc_recv+0x61>
			*from_env_store = 0;
  8020be:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8020c4:	85 db                	test   %ebx,%ebx
  8020c6:	74 eb                	je     8020b3 <ipc_recv+0x50>
			*perm_store = 0;
  8020c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020ce:	eb e3                	jmp    8020b3 <ipc_recv+0x50>

008020d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020d0:	f3 0f 1e fb          	endbr32 
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	57                   	push   %edi
  8020d8:	56                   	push   %esi
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8020e6:	85 db                	test   %ebx,%ebx
  8020e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020ed:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8020f0:	ff 75 14             	pushl  0x14(%ebp)
  8020f3:	53                   	push   %ebx
  8020f4:	56                   	push   %esi
  8020f5:	57                   	push   %edi
  8020f6:	e8 1f ec ff ff       	call   800d1a <sys_ipc_try_send>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802101:	75 07                	jne    80210a <ipc_send+0x3a>
		sys_yield();
  802103:	e8 f9 ea ff ff       	call   800c01 <sys_yield>
  802108:	eb e6                	jmp    8020f0 <ipc_send+0x20>
	}

	if (ret < 0) {
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 08                	js     802116 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  80210e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802111:	5b                   	pop    %ebx
  802112:	5e                   	pop    %esi
  802113:	5f                   	pop    %edi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802116:	50                   	push   %eax
  802117:	68 ad 2a 80 00       	push   $0x802aad
  80211c:	6a 48                	push   $0x48
  80211e:	68 ca 2a 80 00       	push   $0x802aca
  802123:	e8 2b e0 ff ff       	call   800153 <_panic>

00802128 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802128:	f3 0f 1e fb          	endbr32 
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802137:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80213a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802140:	8b 52 50             	mov    0x50(%edx),%edx
  802143:	39 ca                	cmp    %ecx,%edx
  802145:	74 11                	je     802158 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802147:	83 c0 01             	add    $0x1,%eax
  80214a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80214f:	75 e6                	jne    802137 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	eb 0b                	jmp    802163 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802158:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80215b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802160:	8b 40 48             	mov    0x48(%eax),%eax
}
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    

00802165 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802165:	f3 0f 1e fb          	endbr32 
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80216f:	89 c2                	mov    %eax,%edx
  802171:	c1 ea 16             	shr    $0x16,%edx
  802174:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80217b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802180:	f6 c1 01             	test   $0x1,%cl
  802183:	74 1c                	je     8021a1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802185:	c1 e8 0c             	shr    $0xc,%eax
  802188:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80218f:	a8 01                	test   $0x1,%al
  802191:	74 0e                	je     8021a1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802193:	c1 e8 0c             	shr    $0xc,%eax
  802196:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80219d:	ef 
  80219e:	0f b7 d2             	movzwl %dx,%edx
}
  8021a1:	89 d0                	mov    %edx,%eax
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
  8021a5:	66 90                	xchg   %ax,%ax
  8021a7:	66 90                	xchg   %ax,%ax
  8021a9:	66 90                	xchg   %ax,%ax
  8021ab:	66 90                	xchg   %ax,%ax
  8021ad:	66 90                	xchg   %ax,%ax
  8021af:	90                   	nop

008021b0 <__udivdi3>:
  8021b0:	f3 0f 1e fb          	endbr32 
  8021b4:	55                   	push   %ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021cb:	85 d2                	test   %edx,%edx
  8021cd:	75 19                	jne    8021e8 <__udivdi3+0x38>
  8021cf:	39 f3                	cmp    %esi,%ebx
  8021d1:	76 4d                	jbe    802220 <__udivdi3+0x70>
  8021d3:	31 ff                	xor    %edi,%edi
  8021d5:	89 e8                	mov    %ebp,%eax
  8021d7:	89 f2                	mov    %esi,%edx
  8021d9:	f7 f3                	div    %ebx
  8021db:	89 fa                	mov    %edi,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	76 14                	jbe    802200 <__udivdi3+0x50>
  8021ec:	31 ff                	xor    %edi,%edi
  8021ee:	31 c0                	xor    %eax,%eax
  8021f0:	89 fa                	mov    %edi,%edx
  8021f2:	83 c4 1c             	add    $0x1c,%esp
  8021f5:	5b                   	pop    %ebx
  8021f6:	5e                   	pop    %esi
  8021f7:	5f                   	pop    %edi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
  8021fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802200:	0f bd fa             	bsr    %edx,%edi
  802203:	83 f7 1f             	xor    $0x1f,%edi
  802206:	75 48                	jne    802250 <__udivdi3+0xa0>
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	72 06                	jb     802212 <__udivdi3+0x62>
  80220c:	31 c0                	xor    %eax,%eax
  80220e:	39 eb                	cmp    %ebp,%ebx
  802210:	77 de                	ja     8021f0 <__udivdi3+0x40>
  802212:	b8 01 00 00 00       	mov    $0x1,%eax
  802217:	eb d7                	jmp    8021f0 <__udivdi3+0x40>
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 d9                	mov    %ebx,%ecx
  802222:	85 db                	test   %ebx,%ebx
  802224:	75 0b                	jne    802231 <__udivdi3+0x81>
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f3                	div    %ebx
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	31 d2                	xor    %edx,%edx
  802233:	89 f0                	mov    %esi,%eax
  802235:	f7 f1                	div    %ecx
  802237:	89 c6                	mov    %eax,%esi
  802239:	89 e8                	mov    %ebp,%eax
  80223b:	89 f7                	mov    %esi,%edi
  80223d:	f7 f1                	div    %ecx
  80223f:	89 fa                	mov    %edi,%edx
  802241:	83 c4 1c             	add    $0x1c,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    
  802249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802250:	89 f9                	mov    %edi,%ecx
  802252:	b8 20 00 00 00       	mov    $0x20,%eax
  802257:	29 f8                	sub    %edi,%eax
  802259:	d3 e2                	shl    %cl,%edx
  80225b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	89 da                	mov    %ebx,%edx
  802263:	d3 ea                	shr    %cl,%edx
  802265:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802269:	09 d1                	or     %edx,%ecx
  80226b:	89 f2                	mov    %esi,%edx
  80226d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802271:	89 f9                	mov    %edi,%ecx
  802273:	d3 e3                	shl    %cl,%ebx
  802275:	89 c1                	mov    %eax,%ecx
  802277:	d3 ea                	shr    %cl,%edx
  802279:	89 f9                	mov    %edi,%ecx
  80227b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80227f:	89 eb                	mov    %ebp,%ebx
  802281:	d3 e6                	shl    %cl,%esi
  802283:	89 c1                	mov    %eax,%ecx
  802285:	d3 eb                	shr    %cl,%ebx
  802287:	09 de                	or     %ebx,%esi
  802289:	89 f0                	mov    %esi,%eax
  80228b:	f7 74 24 08          	divl   0x8(%esp)
  80228f:	89 d6                	mov    %edx,%esi
  802291:	89 c3                	mov    %eax,%ebx
  802293:	f7 64 24 0c          	mull   0xc(%esp)
  802297:	39 d6                	cmp    %edx,%esi
  802299:	72 15                	jb     8022b0 <__udivdi3+0x100>
  80229b:	89 f9                	mov    %edi,%ecx
  80229d:	d3 e5                	shl    %cl,%ebp
  80229f:	39 c5                	cmp    %eax,%ebp
  8022a1:	73 04                	jae    8022a7 <__udivdi3+0xf7>
  8022a3:	39 d6                	cmp    %edx,%esi
  8022a5:	74 09                	je     8022b0 <__udivdi3+0x100>
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	31 ff                	xor    %edi,%edi
  8022ab:	e9 40 ff ff ff       	jmp    8021f0 <__udivdi3+0x40>
  8022b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 36 ff ff ff       	jmp    8021f0 <__udivdi3+0x40>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	f3 0f 1e fb          	endbr32 
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	75 19                	jne    8022f8 <__umoddi3+0x38>
  8022df:	39 df                	cmp    %ebx,%edi
  8022e1:	76 5d                	jbe    802340 <__umoddi3+0x80>
  8022e3:	89 f0                	mov    %esi,%eax
  8022e5:	89 da                	mov    %ebx,%edx
  8022e7:	f7 f7                	div    %edi
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	89 f2                	mov    %esi,%edx
  8022fa:	39 d8                	cmp    %ebx,%eax
  8022fc:	76 12                	jbe    802310 <__umoddi3+0x50>
  8022fe:	89 f0                	mov    %esi,%eax
  802300:	89 da                	mov    %ebx,%edx
  802302:	83 c4 1c             	add    $0x1c,%esp
  802305:	5b                   	pop    %ebx
  802306:	5e                   	pop    %esi
  802307:	5f                   	pop    %edi
  802308:	5d                   	pop    %ebp
  802309:	c3                   	ret    
  80230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802310:	0f bd e8             	bsr    %eax,%ebp
  802313:	83 f5 1f             	xor    $0x1f,%ebp
  802316:	75 50                	jne    802368 <__umoddi3+0xa8>
  802318:	39 d8                	cmp    %ebx,%eax
  80231a:	0f 82 e0 00 00 00    	jb     802400 <__umoddi3+0x140>
  802320:	89 d9                	mov    %ebx,%ecx
  802322:	39 f7                	cmp    %esi,%edi
  802324:	0f 86 d6 00 00 00    	jbe    802400 <__umoddi3+0x140>
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	89 ca                	mov    %ecx,%edx
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	89 fd                	mov    %edi,%ebp
  802342:	85 ff                	test   %edi,%edi
  802344:	75 0b                	jne    802351 <__umoddi3+0x91>
  802346:	b8 01 00 00 00       	mov    $0x1,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	f7 f7                	div    %edi
  80234f:	89 c5                	mov    %eax,%ebp
  802351:	89 d8                	mov    %ebx,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f5                	div    %ebp
  802357:	89 f0                	mov    %esi,%eax
  802359:	f7 f5                	div    %ebp
  80235b:	89 d0                	mov    %edx,%eax
  80235d:	31 d2                	xor    %edx,%edx
  80235f:	eb 8c                	jmp    8022ed <__umoddi3+0x2d>
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 e9                	mov    %ebp,%ecx
  80236a:	ba 20 00 00 00       	mov    $0x20,%edx
  80236f:	29 ea                	sub    %ebp,%edx
  802371:	d3 e0                	shl    %cl,%eax
  802373:	89 44 24 08          	mov    %eax,0x8(%esp)
  802377:	89 d1                	mov    %edx,%ecx
  802379:	89 f8                	mov    %edi,%eax
  80237b:	d3 e8                	shr    %cl,%eax
  80237d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802381:	89 54 24 04          	mov    %edx,0x4(%esp)
  802385:	8b 54 24 04          	mov    0x4(%esp),%edx
  802389:	09 c1                	or     %eax,%ecx
  80238b:	89 d8                	mov    %ebx,%eax
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 e9                	mov    %ebp,%ecx
  802393:	d3 e7                	shl    %cl,%edi
  802395:	89 d1                	mov    %edx,%ecx
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80239f:	d3 e3                	shl    %cl,%ebx
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	89 d1                	mov    %edx,%ecx
  8023a5:	89 f0                	mov    %esi,%eax
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	89 fa                	mov    %edi,%edx
  8023ad:	d3 e6                	shl    %cl,%esi
  8023af:	09 d8                	or     %ebx,%eax
  8023b1:	f7 74 24 08          	divl   0x8(%esp)
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	89 f3                	mov    %esi,%ebx
  8023b9:	f7 64 24 0c          	mull   0xc(%esp)
  8023bd:	89 c6                	mov    %eax,%esi
  8023bf:	89 d7                	mov    %edx,%edi
  8023c1:	39 d1                	cmp    %edx,%ecx
  8023c3:	72 06                	jb     8023cb <__umoddi3+0x10b>
  8023c5:	75 10                	jne    8023d7 <__umoddi3+0x117>
  8023c7:	39 c3                	cmp    %eax,%ebx
  8023c9:	73 0c                	jae    8023d7 <__umoddi3+0x117>
  8023cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023d3:	89 d7                	mov    %edx,%edi
  8023d5:	89 c6                	mov    %eax,%esi
  8023d7:	89 ca                	mov    %ecx,%edx
  8023d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023de:	29 f3                	sub    %esi,%ebx
  8023e0:	19 fa                	sbb    %edi,%edx
  8023e2:	89 d0                	mov    %edx,%eax
  8023e4:	d3 e0                	shl    %cl,%eax
  8023e6:	89 e9                	mov    %ebp,%ecx
  8023e8:	d3 eb                	shr    %cl,%ebx
  8023ea:	d3 ea                	shr    %cl,%edx
  8023ec:	09 d8                	or     %ebx,%eax
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	29 fe                	sub    %edi,%esi
  802402:	19 c3                	sbb    %eax,%ebx
  802404:	89 f2                	mov    %esi,%edx
  802406:	89 d9                	mov    %ebx,%ecx
  802408:	e9 1d ff ff ff       	jmp    80232a <__umoddi3+0x6a>
