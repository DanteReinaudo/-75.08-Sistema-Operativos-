
obj/user/testbss.debug:     formato del fichero elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  80003d:	68 a0 1e 80 00       	push   $0x801ea0
  800042:	e8 ec 01 00 00       	call   800233 <cprintf>
  800047:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004f:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800056:	00 
  800057:	75 63                	jne    8000bc <umain+0x89>
	for (i = 0; i < ARRAYSIZE; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800061:	75 ec                	jne    80004f <umain+0x1c>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  800063:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800068:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006f:	83 c0 01             	add    $0x1,%eax
  800072:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800077:	75 ef                	jne    800068 <umain+0x35>
	for (i = 0; i < ARRAYSIZE; i++)
  800079:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007e:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800085:	75 47                	jne    8000ce <umain+0x9b>
	for (i = 0; i < ARRAYSIZE; i++)
  800087:	83 c0 01             	add    $0x1,%eax
  80008a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008f:	75 ed                	jne    80007e <umain+0x4b>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 e8 1e 80 00       	push   $0x801ee8
  800099:	e8 95 01 00 00       	call   800233 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009e:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 47 1f 80 00       	push   $0x801f47
  8000b0:	6a 1a                	push   $0x1a
  8000b2:	68 38 1f 80 00       	push   $0x801f38
  8000b7:	e8 90 00 00 00       	call   80014c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000bc:	50                   	push   %eax
  8000bd:	68 1b 1f 80 00       	push   $0x801f1b
  8000c2:	6a 11                	push   $0x11
  8000c4:	68 38 1f 80 00       	push   $0x801f38
  8000c9:	e8 7e 00 00 00       	call   80014c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ce:	50                   	push   %eax
  8000cf:	68 c0 1e 80 00       	push   $0x801ec0
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 38 1f 80 00       	push   $0x801f38
  8000db:	e8 6c 00 00 00       	call   80014c <_panic>

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	f3 0f 1e fb          	endbr32 
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000ef:	e8 de 0a 00 00       	call   800bd2 <sys_getenvid>
	if (id >= 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	78 12                	js     80010a <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x35>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	f3 0f 1e fb          	endbr32 
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800138:	e8 18 0e 00 00       	call   800f55 <close_all>
	sys_env_destroy(0);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	6a 00                	push   $0x0
  800142:	e8 65 0a 00 00       	call   800bac <sys_env_destroy>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014c:	f3 0f 1e fb          	endbr32 
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800155:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800158:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80015e:	e8 6f 0a 00 00       	call   800bd2 <sys_getenvid>
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	56                   	push   %esi
  80016d:	50                   	push   %eax
  80016e:	68 68 1f 80 00       	push   $0x801f68
  800173:	e8 bb 00 00 00       	call   800233 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800178:	83 c4 18             	add    $0x18,%esp
  80017b:	53                   	push   %ebx
  80017c:	ff 75 10             	pushl  0x10(%ebp)
  80017f:	e8 5a 00 00 00       	call   8001de <vcprintf>
	cprintf("\n");
  800184:	c7 04 24 de 23 80 00 	movl   $0x8023de,(%esp)
  80018b:	e8 a3 00 00 00       	call   800233 <cprintf>
  800190:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800193:	cc                   	int3   
  800194:	eb fd                	jmp    800193 <_panic+0x47>

00800196 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800196:	f3 0f 1e fb          	endbr32 
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	53                   	push   %ebx
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a4:	8b 13                	mov    (%ebx),%edx
  8001a6:	8d 42 01             	lea    0x1(%edx),%eax
  8001a9:	89 03                	mov    %eax,(%ebx)
  8001ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b7:	74 09                	je     8001c2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 ff 00 00 00       	push   $0xff
  8001ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cd:	50                   	push   %eax
  8001ce:	e8 87 09 00 00       	call   800b5a <sys_cputs>
		b->idx = 0;
  8001d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	eb db                	jmp    8001b9 <putch+0x23>

008001de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001de:	f3 0f 1e fb          	endbr32 
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f2:	00 00 00 
	b.cnt = 0;
  8001f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ff:	ff 75 0c             	pushl  0xc(%ebp)
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	68 96 01 80 00       	push   $0x800196
  800211:	e8 80 01 00 00       	call   800396 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	83 c4 08             	add    $0x8,%esp
  800219:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	e8 2f 09 00 00       	call   800b5a <sys_cputs>

	return b.cnt;
}
  80022b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800233:	f3 0f 1e fb          	endbr32 
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800240:	50                   	push   %eax
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	e8 95 ff ff ff       	call   8001de <vcprintf>
	va_end(ap);

	return cnt;
}
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	57                   	push   %edi
  80024f:	56                   	push   %esi
  800250:	53                   	push   %ebx
  800251:	83 ec 1c             	sub    $0x1c,%esp
  800254:	89 c7                	mov    %eax,%edi
  800256:	89 d6                	mov    %edx,%esi
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025e:	89 d1                	mov    %edx,%ecx
  800260:	89 c2                	mov    %eax,%edx
  800262:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800265:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800268:	8b 45 10             	mov    0x10(%ebp),%eax
  80026b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800271:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800278:	39 c2                	cmp    %eax,%edx
  80027a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80027d:	72 3e                	jb     8002bd <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 18             	pushl  0x18(%ebp)
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	53                   	push   %ebx
  800289:	50                   	push   %eax
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800290:	ff 75 e0             	pushl  -0x20(%ebp)
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	e8 92 19 00 00       	call   801c30 <__udivdi3>
  80029e:	83 c4 18             	add    $0x18,%esp
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	89 f2                	mov    %esi,%edx
  8002a5:	89 f8                	mov    %edi,%eax
  8002a7:	e8 9f ff ff ff       	call   80024b <printnum>
  8002ac:	83 c4 20             	add    $0x20,%esp
  8002af:	eb 13                	jmp    8002c4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	56                   	push   %esi
  8002b5:	ff 75 18             	pushl  0x18(%ebp)
  8002b8:	ff d7                	call   *%edi
  8002ba:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002bd:	83 eb 01             	sub    $0x1,%ebx
  8002c0:	85 db                	test   %ebx,%ebx
  8002c2:	7f ed                	jg     8002b1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	56                   	push   %esi
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d7:	e8 64 1a 00 00       	call   801d40 <__umoddi3>
  8002dc:	83 c4 14             	add    $0x14,%esp
  8002df:	0f be 80 8b 1f 80 00 	movsbl 0x801f8b(%eax),%eax
  8002e6:	50                   	push   %eax
  8002e7:	ff d7                	call   *%edi
}
  8002e9:	83 c4 10             	add    $0x10,%esp
  8002ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ef:	5b                   	pop    %ebx
  8002f0:	5e                   	pop    %esi
  8002f1:	5f                   	pop    %edi
  8002f2:	5d                   	pop    %ebp
  8002f3:	c3                   	ret    

008002f4 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002f4:	83 fa 01             	cmp    $0x1,%edx
  8002f7:	7f 13                	jg     80030c <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002f9:	85 d2                	test   %edx,%edx
  8002fb:	74 1c                	je     800319 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002fd:	8b 10                	mov    (%eax),%edx
  8002ff:	8d 4a 04             	lea    0x4(%edx),%ecx
  800302:	89 08                	mov    %ecx,(%eax)
  800304:	8b 02                	mov    (%edx),%eax
  800306:	ba 00 00 00 00       	mov    $0x0,%edx
  80030b:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80030c:	8b 10                	mov    (%eax),%edx
  80030e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800311:	89 08                	mov    %ecx,(%eax)
  800313:	8b 02                	mov    (%edx),%eax
  800315:	8b 52 04             	mov    0x4(%edx),%edx
  800318:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 02                	mov    (%edx),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800327:	c3                   	ret    

00800328 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800328:	83 fa 01             	cmp    $0x1,%edx
  80032b:	7f 0f                	jg     80033c <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80032d:	85 d2                	test   %edx,%edx
  80032f:	74 18                	je     800349 <getint+0x21>
		return va_arg(*ap, long);
  800331:	8b 10                	mov    (%eax),%edx
  800333:	8d 4a 04             	lea    0x4(%edx),%ecx
  800336:	89 08                	mov    %ecx,(%eax)
  800338:	8b 02                	mov    (%edx),%eax
  80033a:	99                   	cltd   
  80033b:	c3                   	ret    
		return va_arg(*ap, long long);
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 02                	mov    (%edx),%eax
  800345:	8b 52 04             	mov    0x4(%edx),%edx
  800348:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80034e:	89 08                	mov    %ecx,(%eax)
  800350:	8b 02                	mov    (%edx),%eax
  800352:	99                   	cltd   
}
  800353:	c3                   	ret    

00800354 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800354:	f3 0f 1e fb          	endbr32 
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800362:	8b 10                	mov    (%eax),%edx
  800364:	3b 50 04             	cmp    0x4(%eax),%edx
  800367:	73 0a                	jae    800373 <sprintputch+0x1f>
		*b->buf++ = ch;
  800369:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	88 02                	mov    %al,(%edx)
}
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <printfmt>:
{
  800375:	f3 0f 1e fb          	endbr32 
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800382:	50                   	push   %eax
  800383:	ff 75 10             	pushl  0x10(%ebp)
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	ff 75 08             	pushl  0x8(%ebp)
  80038c:	e8 05 00 00 00       	call   800396 <vprintfmt>
}
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <vprintfmt>:
{
  800396:	f3 0f 1e fb          	endbr32 
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	57                   	push   %edi
  80039e:	56                   	push   %esi
  80039f:	53                   	push   %ebx
  8003a0:	83 ec 2c             	sub    $0x2c,%esp
  8003a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ac:	e9 86 02 00 00       	jmp    800637 <vprintfmt+0x2a1>
		padc = ' ';
  8003b1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8d 47 01             	lea    0x1(%edi),%eax
  8003d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d5:	0f b6 17             	movzbl (%edi),%edx
  8003d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003db:	3c 55                	cmp    $0x55,%al
  8003dd:	0f 87 df 02 00 00    	ja     8006c2 <vprintfmt+0x32c>
  8003e3:	0f b6 c0             	movzbl %al,%eax
  8003e6:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  8003ed:	00 
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003f5:	eb d8                	jmp    8003cf <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003fa:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003fe:	eb cf                	jmp    8003cf <vprintfmt+0x39>
  800400:	0f b6 d2             	movzbl %dl,%edx
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
  80040b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80040e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800411:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800415:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800418:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80041b:	83 f9 09             	cmp    $0x9,%ecx
  80041e:	77 52                	ja     800472 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800420:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800423:	eb e9                	jmp    80040e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800425:	8b 45 14             	mov    0x14(%ebp),%eax
  800428:	8d 50 04             	lea    0x4(%eax),%edx
  80042b:	89 55 14             	mov    %edx,0x14(%ebp)
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800436:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043a:	79 93                	jns    8003cf <vprintfmt+0x39>
				width = precision, precision = -1;
  80043c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80043f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800442:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800449:	eb 84                	jmp    8003cf <vprintfmt+0x39>
  80044b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
  800455:	0f 49 d0             	cmovns %eax,%edx
  800458:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045e:	e9 6c ff ff ff       	jmp    8003cf <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800466:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80046d:	e9 5d ff ff ff       	jmp    8003cf <vprintfmt+0x39>
  800472:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800475:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800478:	eb bc                	jmp    800436 <vprintfmt+0xa0>
			lflag++;
  80047a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800480:	e9 4a ff ff ff       	jmp    8003cf <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 50 04             	lea    0x4(%eax),%edx
  80048b:	89 55 14             	mov    %edx,0x14(%ebp)
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	56                   	push   %esi
  800492:	ff 30                	pushl  (%eax)
  800494:	ff d3                	call   *%ebx
			break;
  800496:	83 c4 10             	add    $0x10,%esp
  800499:	e9 96 01 00 00       	jmp    800634 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 50 04             	lea    0x4(%eax),%edx
  8004a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	99                   	cltd   
  8004aa:	31 d0                	xor    %edx,%eax
  8004ac:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ae:	83 f8 0f             	cmp    $0xf,%eax
  8004b1:	7f 20                	jg     8004d3 <vprintfmt+0x13d>
  8004b3:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8004ba:	85 d2                	test   %edx,%edx
  8004bc:	74 15                	je     8004d3 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8004be:	52                   	push   %edx
  8004bf:	68 77 23 80 00       	push   $0x802377
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	e8 aa fe ff ff       	call   800375 <printfmt>
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	e9 61 01 00 00       	jmp    800634 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004d3:	50                   	push   %eax
  8004d4:	68 a3 1f 80 00       	push   $0x801fa3
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	e8 95 fe ff ff       	call   800375 <printfmt>
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	e9 4c 01 00 00       	jmp    800634 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 50 04             	lea    0x4(%eax),%edx
  8004ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004f3:	85 c9                	test   %ecx,%ecx
  8004f5:	b8 9c 1f 80 00       	mov    $0x801f9c,%eax
  8004fa:	0f 45 c1             	cmovne %ecx,%eax
  8004fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800500:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800504:	7e 06                	jle    80050c <vprintfmt+0x176>
  800506:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80050a:	75 0d                	jne    800519 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050f:	89 c7                	mov    %eax,%edi
  800511:	03 45 e0             	add    -0x20(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	eb 57                	jmp    800570 <vprintfmt+0x1da>
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	ff 75 d8             	pushl  -0x28(%ebp)
  80051f:	ff 75 cc             	pushl  -0x34(%ebp)
  800522:	e8 4f 02 00 00       	call   800776 <strnlen>
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	29 c2                	sub    %eax,%edx
  80052c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80052f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800532:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800536:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800539:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80053b:	85 db                	test   %ebx,%ebx
  80053d:	7e 10                	jle    80054f <vprintfmt+0x1b9>
					putch(padc, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	56                   	push   %esi
  800543:	57                   	push   %edi
  800544:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800547:	83 eb 01             	sub    $0x1,%ebx
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb ec                	jmp    80053b <vprintfmt+0x1a5>
  80054f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	85 d2                	test   %edx,%edx
  800557:	b8 00 00 00 00       	mov    $0x0,%eax
  80055c:	0f 49 c2             	cmovns %edx,%eax
  80055f:	29 c2                	sub    %eax,%edx
  800561:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800564:	eb a6                	jmp    80050c <vprintfmt+0x176>
					putch(ch, putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	56                   	push   %esi
  80056a:	52                   	push   %edx
  80056b:	ff d3                	call   *%ebx
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800573:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800575:	83 c7 01             	add    $0x1,%edi
  800578:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80057c:	0f be d0             	movsbl %al,%edx
  80057f:	85 d2                	test   %edx,%edx
  800581:	74 42                	je     8005c5 <vprintfmt+0x22f>
  800583:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800587:	78 06                	js     80058f <vprintfmt+0x1f9>
  800589:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80058d:	78 1e                	js     8005ad <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80058f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800593:	74 d1                	je     800566 <vprintfmt+0x1d0>
  800595:	0f be c0             	movsbl %al,%eax
  800598:	83 e8 20             	sub    $0x20,%eax
  80059b:	83 f8 5e             	cmp    $0x5e,%eax
  80059e:	76 c6                	jbe    800566 <vprintfmt+0x1d0>
					putch('?', putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	6a 3f                	push   $0x3f
  8005a6:	ff d3                	call   *%ebx
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	eb c3                	jmp    800570 <vprintfmt+0x1da>
  8005ad:	89 cf                	mov    %ecx,%edi
  8005af:	eb 0e                	jmp    8005bf <vprintfmt+0x229>
				putch(' ', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	56                   	push   %esi
  8005b5:	6a 20                	push   $0x20
  8005b7:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8005b9:	83 ef 01             	sub    $0x1,%edi
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	85 ff                	test   %edi,%edi
  8005c1:	7f ee                	jg     8005b1 <vprintfmt+0x21b>
  8005c3:	eb 6f                	jmp    800634 <vprintfmt+0x29e>
  8005c5:	89 cf                	mov    %ecx,%edi
  8005c7:	eb f6                	jmp    8005bf <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005c9:	89 ca                	mov    %ecx,%edx
  8005cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ce:	e8 55 fd ff ff       	call   800328 <getint>
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d9:	85 d2                	test   %edx,%edx
  8005db:	78 0b                	js     8005e8 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005dd:	89 d1                	mov    %edx,%ecx
  8005df:	89 c2                	mov    %eax,%edx
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	eb 32                	jmp    80061a <vprintfmt+0x284>
				putch('-', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	56                   	push   %esi
  8005ec:	6a 2d                	push   $0x2d
  8005ee:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005f6:	f7 da                	neg    %edx
  8005f8:	83 d1 00             	adc    $0x0,%ecx
  8005fb:	f7 d9                	neg    %ecx
  8005fd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	eb 13                	jmp    80061a <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800607:	89 ca                	mov    %ecx,%edx
  800609:	8d 45 14             	lea    0x14(%ebp),%eax
  80060c:	e8 e3 fc ff ff       	call   8002f4 <getuint>
  800611:	89 d1                	mov    %edx,%ecx
  800613:	89 c2                	mov    %eax,%edx
			base = 10;
  800615:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800621:	57                   	push   %edi
  800622:	ff 75 e0             	pushl  -0x20(%ebp)
  800625:	50                   	push   %eax
  800626:	51                   	push   %ecx
  800627:	52                   	push   %edx
  800628:	89 f2                	mov    %esi,%edx
  80062a:	89 d8                	mov    %ebx,%eax
  80062c:	e8 1a fc ff ff       	call   80024b <printnum>
			break;
  800631:	83 c4 20             	add    $0x20,%esp
{
  800634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800637:	83 c7 01             	add    $0x1,%edi
  80063a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063e:	83 f8 25             	cmp    $0x25,%eax
  800641:	0f 84 6a fd ff ff    	je     8003b1 <vprintfmt+0x1b>
			if (ch == '\0')
  800647:	85 c0                	test   %eax,%eax
  800649:	0f 84 93 00 00 00    	je     8006e2 <vprintfmt+0x34c>
			putch(ch, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	56                   	push   %esi
  800653:	50                   	push   %eax
  800654:	ff d3                	call   *%ebx
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	eb dc                	jmp    800637 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80065b:	89 ca                	mov    %ecx,%edx
  80065d:	8d 45 14             	lea    0x14(%ebp),%eax
  800660:	e8 8f fc ff ff       	call   8002f4 <getuint>
  800665:	89 d1                	mov    %edx,%ecx
  800667:	89 c2                	mov    %eax,%edx
			base = 8;
  800669:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  80066e:	eb aa                	jmp    80061a <vprintfmt+0x284>
			putch('0', putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	56                   	push   %esi
  800674:	6a 30                	push   $0x30
  800676:	ff d3                	call   *%ebx
			putch('x', putdat);
  800678:	83 c4 08             	add    $0x8,%esp
  80067b:	56                   	push   %esi
  80067c:	6a 78                	push   $0x78
  80067e:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 50 04             	lea    0x4(%eax),%edx
  800686:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800690:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800698:	eb 80                	jmp    80061a <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80069a:	89 ca                	mov    %ecx,%edx
  80069c:	8d 45 14             	lea    0x14(%ebp),%eax
  80069f:	e8 50 fc ff ff       	call   8002f4 <getuint>
  8006a4:	89 d1                	mov    %edx,%ecx
  8006a6:	89 c2                	mov    %eax,%edx
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ad:	e9 68 ff ff ff       	jmp    80061a <vprintfmt+0x284>
			putch(ch, putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	6a 25                	push   $0x25
  8006b8:	ff d3                	call   *%ebx
			break;
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	e9 72 ff ff ff       	jmp    800634 <vprintfmt+0x29e>
			putch('%', putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	56                   	push   %esi
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 f8                	mov    %edi,%eax
  8006cf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006d3:	74 05                	je     8006da <vprintfmt+0x344>
  8006d5:	83 e8 01             	sub    $0x1,%eax
  8006d8:	eb f5                	jmp    8006cf <vprintfmt+0x339>
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006dd:	e9 52 ff ff ff       	jmp    800634 <vprintfmt+0x29e>
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    

008006ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ea:	f3 0f 1e fb          	endbr32 
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006fd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800701:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80070b:	85 c0                	test   %eax,%eax
  80070d:	74 26                	je     800735 <vsnprintf+0x4b>
  80070f:	85 d2                	test   %edx,%edx
  800711:	7e 22                	jle    800735 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800713:	ff 75 14             	pushl  0x14(%ebp)
  800716:	ff 75 10             	pushl  0x10(%ebp)
  800719:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80071c:	50                   	push   %eax
  80071d:	68 54 03 80 00       	push   $0x800354
  800722:	e8 6f fc ff ff       	call   800396 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80072a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	c9                   	leave  
  800734:	c3                   	ret    
		return -E_INVAL;
  800735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073a:	eb f7                	jmp    800733 <vsnprintf+0x49>

0080073c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073c:	f3 0f 1e fb          	endbr32 
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800746:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800749:	50                   	push   %eax
  80074a:	ff 75 10             	pushl  0x10(%ebp)
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	ff 75 08             	pushl  0x8(%ebp)
  800753:	e8 92 ff ff ff       	call   8006ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80075a:	f3 0f 1e fb          	endbr32 
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800764:	b8 00 00 00 00       	mov    $0x0,%eax
  800769:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80076d:	74 05                	je     800774 <strlen+0x1a>
		n++;
  80076f:	83 c0 01             	add    $0x1,%eax
  800772:	eb f5                	jmp    800769 <strlen+0xf>
	return n;
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800776:	f3 0f 1e fb          	endbr32 
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800783:	b8 00 00 00 00       	mov    $0x0,%eax
  800788:	39 d0                	cmp    %edx,%eax
  80078a:	74 0d                	je     800799 <strnlen+0x23>
  80078c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800790:	74 05                	je     800797 <strnlen+0x21>
		n++;
  800792:	83 c0 01             	add    $0x1,%eax
  800795:	eb f1                	jmp    800788 <strnlen+0x12>
  800797:	89 c2                	mov    %eax,%edx
	return n;
}
  800799:	89 d0                	mov    %edx,%eax
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	53                   	push   %ebx
  8007a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007b7:	83 c0 01             	add    $0x1,%eax
  8007ba:	84 d2                	test   %dl,%dl
  8007bc:	75 f2                	jne    8007b0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007be:	89 c8                	mov    %ecx,%eax
  8007c0:	5b                   	pop    %ebx
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007c3:	f3 0f 1e fb          	endbr32 
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	83 ec 10             	sub    $0x10,%esp
  8007ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d1:	53                   	push   %ebx
  8007d2:	e8 83 ff ff ff       	call   80075a <strlen>
  8007d7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	01 d8                	add    %ebx,%eax
  8007df:	50                   	push   %eax
  8007e0:	e8 b8 ff ff ff       	call   80079d <strcpy>
	return dst;
}
  8007e5:	89 d8                	mov    %ebx,%eax
  8007e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007ec:	f3 0f 1e fb          	endbr32 
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	56                   	push   %esi
  8007f4:	53                   	push   %ebx
  8007f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fb:	89 f3                	mov    %esi,%ebx
  8007fd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800800:	89 f0                	mov    %esi,%eax
  800802:	39 d8                	cmp    %ebx,%eax
  800804:	74 11                	je     800817 <strncpy+0x2b>
		*dst++ = *src;
  800806:	83 c0 01             	add    $0x1,%eax
  800809:	0f b6 0a             	movzbl (%edx),%ecx
  80080c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080f:	80 f9 01             	cmp    $0x1,%cl
  800812:	83 da ff             	sbb    $0xffffffff,%edx
  800815:	eb eb                	jmp    800802 <strncpy+0x16>
	}
	return ret;
}
  800817:	89 f0                	mov    %esi,%eax
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081d:	f3 0f 1e fb          	endbr32 
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	56                   	push   %esi
  800825:	53                   	push   %ebx
  800826:	8b 75 08             	mov    0x8(%ebp),%esi
  800829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082c:	8b 55 10             	mov    0x10(%ebp),%edx
  80082f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800831:	85 d2                	test   %edx,%edx
  800833:	74 21                	je     800856 <strlcpy+0x39>
  800835:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800839:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80083b:	39 c2                	cmp    %eax,%edx
  80083d:	74 14                	je     800853 <strlcpy+0x36>
  80083f:	0f b6 19             	movzbl (%ecx),%ebx
  800842:	84 db                	test   %bl,%bl
  800844:	74 0b                	je     800851 <strlcpy+0x34>
			*dst++ = *src++;
  800846:	83 c1 01             	add    $0x1,%ecx
  800849:	83 c2 01             	add    $0x1,%edx
  80084c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084f:	eb ea                	jmp    80083b <strlcpy+0x1e>
  800851:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800853:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800856:	29 f0                	sub    %esi,%eax
}
  800858:	5b                   	pop    %ebx
  800859:	5e                   	pop    %esi
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80085c:	f3 0f 1e fb          	endbr32 
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800866:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800869:	0f b6 01             	movzbl (%ecx),%eax
  80086c:	84 c0                	test   %al,%al
  80086e:	74 0c                	je     80087c <strcmp+0x20>
  800870:	3a 02                	cmp    (%edx),%al
  800872:	75 08                	jne    80087c <strcmp+0x20>
		p++, q++;
  800874:	83 c1 01             	add    $0x1,%ecx
  800877:	83 c2 01             	add    $0x1,%edx
  80087a:	eb ed                	jmp    800869 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80087c:	0f b6 c0             	movzbl %al,%eax
  80087f:	0f b6 12             	movzbl (%edx),%edx
  800882:	29 d0                	sub    %edx,%eax
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800886:	f3 0f 1e fb          	endbr32 
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
  800894:	89 c3                	mov    %eax,%ebx
  800896:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800899:	eb 06                	jmp    8008a1 <strncmp+0x1b>
		n--, p++, q++;
  80089b:	83 c0 01             	add    $0x1,%eax
  80089e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008a1:	39 d8                	cmp    %ebx,%eax
  8008a3:	74 16                	je     8008bb <strncmp+0x35>
  8008a5:	0f b6 08             	movzbl (%eax),%ecx
  8008a8:	84 c9                	test   %cl,%cl
  8008aa:	74 04                	je     8008b0 <strncmp+0x2a>
  8008ac:	3a 0a                	cmp    (%edx),%cl
  8008ae:	74 eb                	je     80089b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b0:	0f b6 00             	movzbl (%eax),%eax
  8008b3:	0f b6 12             	movzbl (%edx),%edx
  8008b6:	29 d0                	sub    %edx,%eax
}
  8008b8:	5b                   	pop    %ebx
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    
		return 0;
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	eb f6                	jmp    8008b8 <strncmp+0x32>

008008c2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c2:	f3 0f 1e fb          	endbr32 
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d0:	0f b6 10             	movzbl (%eax),%edx
  8008d3:	84 d2                	test   %dl,%dl
  8008d5:	74 09                	je     8008e0 <strchr+0x1e>
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 0a                	je     8008e5 <strchr+0x23>
	for (; *s; s++)
  8008db:	83 c0 01             	add    $0x1,%eax
  8008de:	eb f0                	jmp    8008d0 <strchr+0xe>
			return (char *) s;
	return 0;
  8008e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f8:	38 ca                	cmp    %cl,%dl
  8008fa:	74 09                	je     800905 <strfind+0x1e>
  8008fc:	84 d2                	test   %dl,%dl
  8008fe:	74 05                	je     800905 <strfind+0x1e>
	for (; *s; s++)
  800900:	83 c0 01             	add    $0x1,%eax
  800903:	eb f0                	jmp    8008f5 <strfind+0xe>
			break;
	return (char *) s;
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800907:	f3 0f 1e fb          	endbr32 
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	57                   	push   %edi
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800917:	85 c9                	test   %ecx,%ecx
  800919:	74 33                	je     80094e <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	09 c8                	or     %ecx,%eax
  80091f:	a8 03                	test   $0x3,%al
  800921:	75 23                	jne    800946 <memset+0x3f>
		c &= 0xFF;
  800923:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800927:	89 d8                	mov    %ebx,%eax
  800929:	c1 e0 08             	shl    $0x8,%eax
  80092c:	89 df                	mov    %ebx,%edi
  80092e:	c1 e7 18             	shl    $0x18,%edi
  800931:	89 de                	mov    %ebx,%esi
  800933:	c1 e6 10             	shl    $0x10,%esi
  800936:	09 f7                	or     %esi,%edi
  800938:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80093a:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80093f:	89 d7                	mov    %edx,%edi
  800941:	fc                   	cld    
  800942:	f3 ab                	rep stos %eax,%es:(%edi)
  800944:	eb 08                	jmp    80094e <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800946:	89 d7                	mov    %edx,%edi
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	fc                   	cld    
  80094c:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80094e:	89 d0                	mov    %edx,%eax
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800955:	f3 0f 1e fb          	endbr32 
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	57                   	push   %edi
  80095d:	56                   	push   %esi
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 75 0c             	mov    0xc(%ebp),%esi
  800964:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800967:	39 c6                	cmp    %eax,%esi
  800969:	73 32                	jae    80099d <memmove+0x48>
  80096b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096e:	39 c2                	cmp    %eax,%edx
  800970:	76 2b                	jbe    80099d <memmove+0x48>
		s += n;
		d += n;
  800972:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800975:	89 fe                	mov    %edi,%esi
  800977:	09 ce                	or     %ecx,%esi
  800979:	09 d6                	or     %edx,%esi
  80097b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800981:	75 0e                	jne    800991 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800983:	83 ef 04             	sub    $0x4,%edi
  800986:	8d 72 fc             	lea    -0x4(%edx),%esi
  800989:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80098c:	fd                   	std    
  80098d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098f:	eb 09                	jmp    80099a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800991:	83 ef 01             	sub    $0x1,%edi
  800994:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800997:	fd                   	std    
  800998:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099a:	fc                   	cld    
  80099b:	eb 1a                	jmp    8009b7 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099d:	89 c2                	mov    %eax,%edx
  80099f:	09 ca                	or     %ecx,%edx
  8009a1:	09 f2                	or     %esi,%edx
  8009a3:	f6 c2 03             	test   $0x3,%dl
  8009a6:	75 0a                	jne    8009b2 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ab:	89 c7                	mov    %eax,%edi
  8009ad:	fc                   	cld    
  8009ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b0:	eb 05                	jmp    8009b7 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009b2:	89 c7                	mov    %eax,%edi
  8009b4:	fc                   	cld    
  8009b5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b7:	5e                   	pop    %esi
  8009b8:	5f                   	pop    %edi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bb:	f3 0f 1e fb          	endbr32 
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009c5:	ff 75 10             	pushl  0x10(%ebp)
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	e8 82 ff ff ff       	call   800955 <memmove>
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d5:	f3 0f 1e fb          	endbr32 
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	56                   	push   %esi
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e4:	89 c6                	mov    %eax,%esi
  8009e6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e9:	39 f0                	cmp    %esi,%eax
  8009eb:	74 1c                	je     800a09 <memcmp+0x34>
		if (*s1 != *s2)
  8009ed:	0f b6 08             	movzbl (%eax),%ecx
  8009f0:	0f b6 1a             	movzbl (%edx),%ebx
  8009f3:	38 d9                	cmp    %bl,%cl
  8009f5:	75 08                	jne    8009ff <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f7:	83 c0 01             	add    $0x1,%eax
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	eb ea                	jmp    8009e9 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009ff:	0f b6 c1             	movzbl %cl,%eax
  800a02:	0f b6 db             	movzbl %bl,%ebx
  800a05:	29 d8                	sub    %ebx,%eax
  800a07:	eb 05                	jmp    800a0e <memcmp+0x39>
	}

	return 0;
  800a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a12:	f3 0f 1e fb          	endbr32 
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a1f:	89 c2                	mov    %eax,%edx
  800a21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a24:	39 d0                	cmp    %edx,%eax
  800a26:	73 09                	jae    800a31 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a28:	38 08                	cmp    %cl,(%eax)
  800a2a:	74 05                	je     800a31 <memfind+0x1f>
	for (; s < ends; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f3                	jmp    800a24 <memfind+0x12>
			break;
	return (void *) s;
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a43:	eb 03                	jmp    800a48 <strtol+0x15>
		s++;
  800a45:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a48:	0f b6 01             	movzbl (%ecx),%eax
  800a4b:	3c 20                	cmp    $0x20,%al
  800a4d:	74 f6                	je     800a45 <strtol+0x12>
  800a4f:	3c 09                	cmp    $0x9,%al
  800a51:	74 f2                	je     800a45 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a53:	3c 2b                	cmp    $0x2b,%al
  800a55:	74 2a                	je     800a81 <strtol+0x4e>
	int neg = 0;
  800a57:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a5c:	3c 2d                	cmp    $0x2d,%al
  800a5e:	74 2b                	je     800a8b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a60:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a66:	75 0f                	jne    800a77 <strtol+0x44>
  800a68:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6b:	74 28                	je     800a95 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6d:	85 db                	test   %ebx,%ebx
  800a6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a74:	0f 44 d8             	cmove  %eax,%ebx
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a7f:	eb 46                	jmp    800ac7 <strtol+0x94>
		s++;
  800a81:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a84:	bf 00 00 00 00       	mov    $0x0,%edi
  800a89:	eb d5                	jmp    800a60 <strtol+0x2d>
		s++, neg = 1;
  800a8b:	83 c1 01             	add    $0x1,%ecx
  800a8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a93:	eb cb                	jmp    800a60 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a99:	74 0e                	je     800aa9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	75 d8                	jne    800a77 <strtol+0x44>
		s++, base = 8;
  800a9f:	83 c1 01             	add    $0x1,%ecx
  800aa2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa7:	eb ce                	jmp    800a77 <strtol+0x44>
		s += 2, base = 16;
  800aa9:	83 c1 02             	add    $0x2,%ecx
  800aac:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab1:	eb c4                	jmp    800a77 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ab3:	0f be d2             	movsbl %dl,%edx
  800ab6:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abc:	7d 3a                	jge    800af8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac7:	0f b6 11             	movzbl (%ecx),%edx
  800aca:	8d 72 d0             	lea    -0x30(%edx),%esi
  800acd:	89 f3                	mov    %esi,%ebx
  800acf:	80 fb 09             	cmp    $0x9,%bl
  800ad2:	76 df                	jbe    800ab3 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ad4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad7:	89 f3                	mov    %esi,%ebx
  800ad9:	80 fb 19             	cmp    $0x19,%bl
  800adc:	77 08                	ja     800ae6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ade:	0f be d2             	movsbl %dl,%edx
  800ae1:	83 ea 57             	sub    $0x57,%edx
  800ae4:	eb d3                	jmp    800ab9 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ae6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae9:	89 f3                	mov    %esi,%ebx
  800aeb:	80 fb 19             	cmp    $0x19,%bl
  800aee:	77 08                	ja     800af8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af0:	0f be d2             	movsbl %dl,%edx
  800af3:	83 ea 37             	sub    $0x37,%edx
  800af6:	eb c1                	jmp    800ab9 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afc:	74 05                	je     800b03 <strtol+0xd0>
		*endptr = (char *) s;
  800afe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b01:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	f7 da                	neg    %edx
  800b07:	85 ff                	test   %edi,%edi
  800b09:	0f 45 c2             	cmovne %edx,%eax
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	57                   	push   %edi
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	83 ec 1c             	sub    $0x1c,%esp
  800b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b20:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b28:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b2b:	8b 75 14             	mov    0x14(%ebp),%esi
  800b2e:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	74 04                	je     800b3a <syscall+0x29>
  800b36:	85 c0                	test   %eax,%eax
  800b38:	7f 08                	jg     800b42 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3d:	5b                   	pop    %ebx
  800b3e:	5e                   	pop    %esi
  800b3f:	5f                   	pop    %edi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b42:	83 ec 0c             	sub    $0xc,%esp
  800b45:	50                   	push   %eax
  800b46:	ff 75 e0             	pushl  -0x20(%ebp)
  800b49:	68 7f 22 80 00       	push   $0x80227f
  800b4e:	6a 23                	push   $0x23
  800b50:	68 9c 22 80 00       	push   $0x80229c
  800b55:	e8 f2 f5 ff ff       	call   80014c <_panic>

00800b5a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b5a:	f3 0f 1e fb          	endbr32 
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b64:	6a 00                	push   $0x0
  800b66:	6a 00                	push   $0x0
  800b68:	6a 00                	push   $0x0
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b70:	ba 00 00 00 00       	mov    $0x0,%edx
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7a:	e8 92 ff ff ff       	call   800b11 <syscall>
}
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b84:	f3 0f 1e fb          	endbr32 
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b8e:	6a 00                	push   $0x0
  800b90:	6a 00                	push   $0x0
  800b92:	6a 00                	push   $0x0
  800b94:	6a 00                	push   $0x0
  800b96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba5:	e8 67 ff ff ff       	call   800b11 <syscall>
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bac:	f3 0f 1e fb          	endbr32 
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bb6:	6a 00                	push   $0x0
  800bb8:	6a 00                	push   $0x0
  800bba:	6a 00                	push   $0x0
  800bbc:	6a 00                	push   $0x0
  800bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc1:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcb:	e8 41 ff ff ff       	call   800b11 <syscall>
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd2:	f3 0f 1e fb          	endbr32 
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bdc:	6a 00                	push   $0x0
  800bde:	6a 00                	push   $0x0
  800be0:	6a 00                	push   $0x0
  800be2:	6a 00                	push   $0x0
  800be4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bee:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf3:	e8 19 ff ff ff       	call   800b11 <syscall>
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <sys_yield>:

void
sys_yield(void)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c04:	6a 00                	push   $0x0
  800c06:	6a 00                	push   $0x0
  800c08:	6a 00                	push   $0x0
  800c0a:	6a 00                	push   $0x0
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
  800c16:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c1b:	e8 f1 fe ff ff       	call   800b11 <syscall>
}
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c25:	f3 0f 1e fb          	endbr32 
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c2f:	6a 00                	push   $0x0
  800c31:	6a 00                	push   $0x0
  800c33:	ff 75 10             	pushl  0x10(%ebp)
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c41:	b8 04 00 00 00       	mov    $0x4,%eax
  800c46:	e8 c6 fe ff ff       	call   800b11 <syscall>
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4d:	f3 0f 1e fb          	endbr32 
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c57:	ff 75 18             	pushl  0x18(%ebp)
  800c5a:	ff 75 14             	pushl  0x14(%ebp)
  800c5d:	ff 75 10             	pushl  0x10(%ebp)
  800c60:	ff 75 0c             	pushl  0xc(%ebp)
  800c63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c66:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c70:	e8 9c fe ff ff       	call   800b11 <syscall>
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c77:	f3 0f 1e fb          	endbr32 
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c81:	6a 00                	push   $0x0
  800c83:	6a 00                	push   $0x0
  800c85:	6a 00                	push   $0x0
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c92:	b8 06 00 00 00       	mov    $0x6,%eax
  800c97:	e8 75 fe ff ff       	call   800b11 <syscall>
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9e:	f3 0f 1e fb          	endbr32 
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ca8:	6a 00                	push   $0x0
  800caa:	6a 00                	push   $0x0
  800cac:	6a 00                	push   $0x0
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb4:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cbe:	e8 4e fe ff ff       	call   800b11 <syscall>
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cc5:	f3 0f 1e fb          	endbr32 
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ccf:	6a 00                	push   $0x0
  800cd1:	6a 00                	push   $0x0
  800cd3:	6a 00                	push   $0x0
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdb:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce5:	e8 27 fe ff ff       	call   800b11 <syscall>
}
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cec:	f3 0f 1e fb          	endbr32 
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800cf6:	6a 00                	push   $0x0
  800cf8:	6a 00                	push   $0x0
  800cfa:	6a 00                	push   $0x0
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d02:	ba 01 00 00 00       	mov    $0x1,%edx
  800d07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0c:	e8 00 fe ff ff       	call   800b11 <syscall>
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d13:	f3 0f 1e fb          	endbr32 
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d1d:	6a 00                	push   $0x0
  800d1f:	ff 75 14             	pushl  0x14(%ebp)
  800d22:	ff 75 10             	pushl  0x10(%ebp)
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d35:	e8 d7 fd ff ff       	call   800b11 <syscall>
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d3c:	f3 0f 1e fb          	endbr32 
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d46:	6a 00                	push   $0x0
  800d48:	6a 00                	push   $0x0
  800d4a:	6a 00                	push   $0x0
  800d4c:	6a 00                	push   $0x0
  800d4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d51:	ba 01 00 00 00       	mov    $0x1,%edx
  800d56:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d5b:	e8 b1 fd ff ff       	call   800b11 <syscall>
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d62:	f3 0f 1e fb          	endbr32 
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	05 00 00 00 30       	add    $0x30000000,%eax
  800d71:	c1 e8 0c             	shr    $0xc,%eax
}
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d76:	f3 0f 1e fb          	endbr32 
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800d80:	ff 75 08             	pushl  0x8(%ebp)
  800d83:	e8 da ff ff ff       	call   800d62 <fd2num>
  800d88:	83 c4 10             	add    $0x10,%esp
  800d8b:	c1 e0 0c             	shl    $0xc,%eax
  800d8e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d95:	f3 0f 1e fb          	endbr32 
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800da1:	89 c2                	mov    %eax,%edx
  800da3:	c1 ea 16             	shr    $0x16,%edx
  800da6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dad:	f6 c2 01             	test   $0x1,%dl
  800db0:	74 2d                	je     800ddf <fd_alloc+0x4a>
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	c1 ea 0c             	shr    $0xc,%edx
  800db7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dbe:	f6 c2 01             	test   $0x1,%dl
  800dc1:	74 1c                	je     800ddf <fd_alloc+0x4a>
  800dc3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dc8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dcd:	75 d2                	jne    800da1 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800dd8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ddd:	eb 0a                	jmp    800de9 <fd_alloc+0x54>
			*fd_store = fd;
  800ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800deb:	f3 0f 1e fb          	endbr32 
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800df5:	83 f8 1f             	cmp    $0x1f,%eax
  800df8:	77 30                	ja     800e2a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dfa:	c1 e0 0c             	shl    $0xc,%eax
  800dfd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e02:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e08:	f6 c2 01             	test   $0x1,%dl
  800e0b:	74 24                	je     800e31 <fd_lookup+0x46>
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 0c             	shr    $0xc,%edx
  800e12:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e19:	f6 c2 01             	test   $0x1,%dl
  800e1c:	74 1a                	je     800e38 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e21:	89 02                	mov    %eax,(%edx)
	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    
		return -E_INVAL;
  800e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2f:	eb f7                	jmp    800e28 <fd_lookup+0x3d>
		return -E_INVAL;
  800e31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e36:	eb f0                	jmp    800e28 <fd_lookup+0x3d>
  800e38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3d:	eb e9                	jmp    800e28 <fd_lookup+0x3d>

00800e3f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e3f:	f3 0f 1e fb          	endbr32 
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4c:	ba 28 23 80 00       	mov    $0x802328,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e51:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e56:	39 08                	cmp    %ecx,(%eax)
  800e58:	74 33                	je     800e8d <dev_lookup+0x4e>
  800e5a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e5d:	8b 02                	mov    (%edx),%eax
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	75 f3                	jne    800e56 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e63:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800e68:	8b 40 48             	mov    0x48(%eax),%eax
  800e6b:	83 ec 04             	sub    $0x4,%esp
  800e6e:	51                   	push   %ecx
  800e6f:	50                   	push   %eax
  800e70:	68 ac 22 80 00       	push   $0x8022ac
  800e75:	e8 b9 f3 ff ff       	call   800233 <cprintf>
	*dev = 0;
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    
			*dev = devtab[i];
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e92:	b8 00 00 00 00       	mov    $0x0,%eax
  800e97:	eb f2                	jmp    800e8b <dev_lookup+0x4c>

00800e99 <fd_close>:
{
  800e99:	f3 0f 1e fb          	endbr32 
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 28             	sub    $0x28,%esp
  800ea6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ea9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eac:	56                   	push   %esi
  800ead:	e8 b0 fe ff ff       	call   800d62 <fd2num>
  800eb2:	83 c4 08             	add    $0x8,%esp
  800eb5:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800eb8:	52                   	push   %edx
  800eb9:	50                   	push   %eax
  800eba:	e8 2c ff ff ff       	call   800deb <fd_lookup>
  800ebf:	89 c3                	mov    %eax,%ebx
  800ec1:	83 c4 10             	add    $0x10,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 05                	js     800ecd <fd_close+0x34>
	    || fd != fd2)
  800ec8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ecb:	74 16                	je     800ee3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800ecd:	89 f8                	mov    %edi,%eax
  800ecf:	84 c0                	test   %al,%al
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	0f 44 d8             	cmove  %eax,%ebx
}
  800ed9:	89 d8                	mov    %ebx,%eax
  800edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ee9:	50                   	push   %eax
  800eea:	ff 36                	pushl  (%esi)
  800eec:	e8 4e ff ff ff       	call   800e3f <dev_lookup>
  800ef1:	89 c3                	mov    %eax,%ebx
  800ef3:	83 c4 10             	add    $0x10,%esp
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 1a                	js     800f14 <fd_close+0x7b>
		if (dev->dev_close)
  800efa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	74 0b                	je     800f14 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	56                   	push   %esi
  800f0d:	ff d0                	call   *%eax
  800f0f:	89 c3                	mov    %eax,%ebx
  800f11:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	56                   	push   %esi
  800f18:	6a 00                	push   $0x0
  800f1a:	e8 58 fd ff ff       	call   800c77 <sys_page_unmap>
	return r;
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	eb b5                	jmp    800ed9 <fd_close+0x40>

00800f24 <close>:

int
close(int fdnum)
{
  800f24:	f3 0f 1e fb          	endbr32 
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	ff 75 08             	pushl  0x8(%ebp)
  800f35:	e8 b1 fe ff ff       	call   800deb <fd_lookup>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	79 02                	jns    800f43 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    
		return fd_close(fd, 1);
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	6a 01                	push   $0x1
  800f48:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4b:	e8 49 ff ff ff       	call   800e99 <fd_close>
  800f50:	83 c4 10             	add    $0x10,%esp
  800f53:	eb ec                	jmp    800f41 <close+0x1d>

00800f55 <close_all>:

void
close_all(void)
{
  800f55:	f3 0f 1e fb          	endbr32 
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	53                   	push   %ebx
  800f5d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f60:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	53                   	push   %ebx
  800f69:	e8 b6 ff ff ff       	call   800f24 <close>
	for (i = 0; i < MAXFD; i++)
  800f6e:	83 c3 01             	add    $0x1,%ebx
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	83 fb 20             	cmp    $0x20,%ebx
  800f77:	75 ec                	jne    800f65 <close_all+0x10>
}
  800f79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f7e:	f3 0f 1e fb          	endbr32 
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
  800f88:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 08             	pushl  0x8(%ebp)
  800f92:	e8 54 fe ff ff       	call   800deb <fd_lookup>
  800f97:	89 c3                	mov    %eax,%ebx
  800f99:	83 c4 10             	add    $0x10,%esp
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	0f 88 81 00 00 00    	js     801025 <dup+0xa7>
		return r;
	close(newfdnum);
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	e8 75 ff ff ff       	call   800f24 <close>

	newfd = INDEX2FD(newfdnum);
  800faf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb2:	c1 e6 0c             	shl    $0xc,%esi
  800fb5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fbb:	83 c4 04             	add    $0x4,%esp
  800fbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc1:	e8 b0 fd ff ff       	call   800d76 <fd2data>
  800fc6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fc8:	89 34 24             	mov    %esi,(%esp)
  800fcb:	e8 a6 fd ff ff       	call   800d76 <fd2data>
  800fd0:	83 c4 10             	add    $0x10,%esp
  800fd3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fd5:	89 d8                	mov    %ebx,%eax
  800fd7:	c1 e8 16             	shr    $0x16,%eax
  800fda:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe1:	a8 01                	test   $0x1,%al
  800fe3:	74 11                	je     800ff6 <dup+0x78>
  800fe5:	89 d8                	mov    %ebx,%eax
  800fe7:	c1 e8 0c             	shr    $0xc,%eax
  800fea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff1:	f6 c2 01             	test   $0x1,%dl
  800ff4:	75 39                	jne    80102f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ff6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ff9:	89 d0                	mov    %edx,%eax
  800ffb:	c1 e8 0c             	shr    $0xc,%eax
  800ffe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	25 07 0e 00 00       	and    $0xe07,%eax
  80100d:	50                   	push   %eax
  80100e:	56                   	push   %esi
  80100f:	6a 00                	push   $0x0
  801011:	52                   	push   %edx
  801012:	6a 00                	push   $0x0
  801014:	e8 34 fc ff ff       	call   800c4d <sys_page_map>
  801019:	89 c3                	mov    %eax,%ebx
  80101b:	83 c4 20             	add    $0x20,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 31                	js     801053 <dup+0xd5>
		goto err;

	return newfdnum;
  801022:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801025:	89 d8                	mov    %ebx,%eax
  801027:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80102f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	25 07 0e 00 00       	and    $0xe07,%eax
  80103e:	50                   	push   %eax
  80103f:	57                   	push   %edi
  801040:	6a 00                	push   $0x0
  801042:	53                   	push   %ebx
  801043:	6a 00                	push   $0x0
  801045:	e8 03 fc ff ff       	call   800c4d <sys_page_map>
  80104a:	89 c3                	mov    %eax,%ebx
  80104c:	83 c4 20             	add    $0x20,%esp
  80104f:	85 c0                	test   %eax,%eax
  801051:	79 a3                	jns    800ff6 <dup+0x78>
	sys_page_unmap(0, newfd);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	56                   	push   %esi
  801057:	6a 00                	push   $0x0
  801059:	e8 19 fc ff ff       	call   800c77 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80105e:	83 c4 08             	add    $0x8,%esp
  801061:	57                   	push   %edi
  801062:	6a 00                	push   $0x0
  801064:	e8 0e fc ff ff       	call   800c77 <sys_page_unmap>
	return r;
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	eb b7                	jmp    801025 <dup+0xa7>

0080106e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80106e:	f3 0f 1e fb          	endbr32 
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	53                   	push   %ebx
  801076:	83 ec 1c             	sub    $0x1c,%esp
  801079:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80107c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	53                   	push   %ebx
  801081:	e8 65 fd ff ff       	call   800deb <fd_lookup>
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	85 c0                	test   %eax,%eax
  80108b:	78 3f                	js     8010cc <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801097:	ff 30                	pushl  (%eax)
  801099:	e8 a1 fd ff ff       	call   800e3f <dev_lookup>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 27                	js     8010cc <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a8:	8b 42 08             	mov    0x8(%edx),%eax
  8010ab:	83 e0 03             	and    $0x3,%eax
  8010ae:	83 f8 01             	cmp    $0x1,%eax
  8010b1:	74 1e                	je     8010d1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b6:	8b 40 08             	mov    0x8(%eax),%eax
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	74 35                	je     8010f2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	ff 75 10             	pushl  0x10(%ebp)
  8010c3:	ff 75 0c             	pushl  0xc(%ebp)
  8010c6:	52                   	push   %edx
  8010c7:	ff d0                	call   *%eax
  8010c9:	83 c4 10             	add    $0x10,%esp
}
  8010cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010d1:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8010d6:	8b 40 48             	mov    0x48(%eax),%eax
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	53                   	push   %ebx
  8010dd:	50                   	push   %eax
  8010de:	68 ed 22 80 00       	push   $0x8022ed
  8010e3:	e8 4b f1 ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f0:	eb da                	jmp    8010cc <read+0x5e>
		return -E_NOT_SUPP;
  8010f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010f7:	eb d3                	jmp    8010cc <read+0x5e>

008010f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010f9:	f3 0f 1e fb          	endbr32 
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	8b 7d 08             	mov    0x8(%ebp),%edi
  801109:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80110c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801111:	eb 02                	jmp    801115 <readn+0x1c>
  801113:	01 c3                	add    %eax,%ebx
  801115:	39 f3                	cmp    %esi,%ebx
  801117:	73 21                	jae    80113a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	89 f0                	mov    %esi,%eax
  80111e:	29 d8                	sub    %ebx,%eax
  801120:	50                   	push   %eax
  801121:	89 d8                	mov    %ebx,%eax
  801123:	03 45 0c             	add    0xc(%ebp),%eax
  801126:	50                   	push   %eax
  801127:	57                   	push   %edi
  801128:	e8 41 ff ff ff       	call   80106e <read>
		if (m < 0)
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 04                	js     801138 <readn+0x3f>
			return m;
		if (m == 0)
  801134:	75 dd                	jne    801113 <readn+0x1a>
  801136:	eb 02                	jmp    80113a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801138:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80113a:	89 d8                	mov    %ebx,%eax
  80113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113f:	5b                   	pop    %ebx
  801140:	5e                   	pop    %esi
  801141:	5f                   	pop    %edi
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    

00801144 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801144:	f3 0f 1e fb          	endbr32 
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	53                   	push   %ebx
  80114c:	83 ec 1c             	sub    $0x1c,%esp
  80114f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801152:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801155:	50                   	push   %eax
  801156:	53                   	push   %ebx
  801157:	e8 8f fc ff ff       	call   800deb <fd_lookup>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	78 3a                	js     80119d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801163:	83 ec 08             	sub    $0x8,%esp
  801166:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116d:	ff 30                	pushl  (%eax)
  80116f:	e8 cb fc ff ff       	call   800e3f <dev_lookup>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 22                	js     80119d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80117b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801182:	74 1e                	je     8011a2 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801187:	8b 52 0c             	mov    0xc(%edx),%edx
  80118a:	85 d2                	test   %edx,%edx
  80118c:	74 35                	je     8011c3 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	ff 75 10             	pushl  0x10(%ebp)
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	50                   	push   %eax
  801198:	ff d2                	call   *%edx
  80119a:	83 c4 10             	add    $0x10,%esp
}
  80119d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a2:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011a7:	8b 40 48             	mov    0x48(%eax),%eax
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	53                   	push   %ebx
  8011ae:	50                   	push   %eax
  8011af:	68 09 23 80 00       	push   $0x802309
  8011b4:	e8 7a f0 ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c1:	eb da                	jmp    80119d <write+0x59>
		return -E_NOT_SUPP;
  8011c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c8:	eb d3                	jmp    80119d <write+0x59>

008011ca <seek>:

int
seek(int fdnum, off_t offset)
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d7:	50                   	push   %eax
  8011d8:	ff 75 08             	pushl  0x8(%ebp)
  8011db:	e8 0b fc ff ff       	call   800deb <fd_lookup>
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	78 0e                	js     8011f5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 1c             	sub    $0x1c,%esp
  801202:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801205:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801208:	50                   	push   %eax
  801209:	53                   	push   %ebx
  80120a:	e8 dc fb ff ff       	call   800deb <fd_lookup>
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 37                	js     80124d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121c:	50                   	push   %eax
  80121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801220:	ff 30                	pushl  (%eax)
  801222:	e8 18 fc ff ff       	call   800e3f <dev_lookup>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 1f                	js     80124d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801235:	74 1b                	je     801252 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123a:	8b 52 18             	mov    0x18(%edx),%edx
  80123d:	85 d2                	test   %edx,%edx
  80123f:	74 32                	je     801273 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	50                   	push   %eax
  801248:	ff d2                	call   *%edx
  80124a:	83 c4 10             	add    $0x10,%esp
}
  80124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    
			thisenv->env_id, fdnum);
  801252:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801257:	8b 40 48             	mov    0x48(%eax),%eax
  80125a:	83 ec 04             	sub    $0x4,%esp
  80125d:	53                   	push   %ebx
  80125e:	50                   	push   %eax
  80125f:	68 cc 22 80 00       	push   $0x8022cc
  801264:	e8 ca ef ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801271:	eb da                	jmp    80124d <ftruncate+0x56>
		return -E_NOT_SUPP;
  801273:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801278:	eb d3                	jmp    80124d <ftruncate+0x56>

0080127a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80127a:	f3 0f 1e fb          	endbr32 
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	53                   	push   %ebx
  801282:	83 ec 1c             	sub    $0x1c,%esp
  801285:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801288:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80128b:	50                   	push   %eax
  80128c:	ff 75 08             	pushl  0x8(%ebp)
  80128f:	e8 57 fb ff ff       	call   800deb <fd_lookup>
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 4b                	js     8012e6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a1:	50                   	push   %eax
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	ff 30                	pushl  (%eax)
  8012a7:	e8 93 fb ff ff       	call   800e3f <dev_lookup>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	78 33                	js     8012e6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012ba:	74 2f                	je     8012eb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012bc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012c6:	00 00 00 
	stat->st_isdir = 0;
  8012c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012d0:	00 00 00 
	stat->st_dev = dev;
  8012d3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	53                   	push   %ebx
  8012dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e0:	ff 50 14             	call   *0x14(%eax)
  8012e3:	83 c4 10             	add    $0x10,%esp
}
  8012e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    
		return -E_NOT_SUPP;
  8012eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f0:	eb f4                	jmp    8012e6 <fstat+0x6c>

008012f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012f2:	f3 0f 1e fb          	endbr32 
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	56                   	push   %esi
  8012fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	6a 00                	push   $0x0
  801300:	ff 75 08             	pushl  0x8(%ebp)
  801303:	e8 3a 02 00 00       	call   801542 <open>
  801308:	89 c3                	mov    %eax,%ebx
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 1b                	js     80132c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	50                   	push   %eax
  801318:	e8 5d ff ff ff       	call   80127a <fstat>
  80131d:	89 c6                	mov    %eax,%esi
	close(fd);
  80131f:	89 1c 24             	mov    %ebx,(%esp)
  801322:	e8 fd fb ff ff       	call   800f24 <close>
	return r;
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	89 f3                	mov    %esi,%ebx
}
  80132c:	89 d8                	mov    %ebx,%eax
  80132e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	56                   	push   %esi
  801339:	53                   	push   %ebx
  80133a:	89 c6                	mov    %eax,%esi
  80133c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80133e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801345:	74 27                	je     80136e <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801347:	6a 07                	push   $0x7
  801349:	68 00 50 c0 00       	push   $0xc05000
  80134e:	56                   	push   %esi
  80134f:	ff 35 00 40 80 00    	pushl  0x804000
  801355:	e8 fd 07 00 00       	call   801b57 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80135a:	83 c4 0c             	add    $0xc,%esp
  80135d:	6a 00                	push   $0x0
  80135f:	53                   	push   %ebx
  801360:	6a 00                	push   $0x0
  801362:	e8 83 07 00 00       	call   801aea <ipc_recv>
}
  801367:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136a:	5b                   	pop    %ebx
  80136b:	5e                   	pop    %esi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80136e:	83 ec 0c             	sub    $0xc,%esp
  801371:	6a 01                	push   $0x1
  801373:	e8 37 08 00 00       	call   801baf <ipc_find_env>
  801378:	a3 00 40 80 00       	mov    %eax,0x804000
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	eb c5                	jmp    801347 <fsipc+0x12>

00801382 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801382:	f3 0f 1e fb          	endbr32 
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8b 40 0c             	mov    0xc(%eax),%eax
  801392:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8013a9:	e8 87 ff ff ff       	call   801335 <fsipc>
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <devfile_flush>:
{
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c0:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8013c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ca:	b8 06 00 00 00       	mov    $0x6,%eax
  8013cf:	e8 61 ff ff ff       	call   801335 <fsipc>
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <devfile_stat>:
{
  8013d6:	f3 0f 1e fb          	endbr32 
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ea:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8013f9:	e8 37 ff ff ff       	call   801335 <fsipc>
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 2c                	js     80142e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801402:	83 ec 08             	sub    $0x8,%esp
  801405:	68 00 50 c0 00       	push   $0xc05000
  80140a:	53                   	push   %ebx
  80140b:	e8 8d f3 ff ff       	call   80079d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801410:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801415:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80141b:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801420:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <devfile_write>:
{
  801433:	f3 0f 1e fb          	endbr32 
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 04             	sub    $0x4,%esp
  80143e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8b 40 0c             	mov    0xc(%eax),%eax
  801447:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  80144c:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801452:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801458:	77 30                	ja     80148a <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	53                   	push   %ebx
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	68 08 50 c0 00       	push   $0xc05008
  801466:	e8 ea f4 ff ff       	call   800955 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80146b:	ba 00 00 00 00       	mov    $0x0,%edx
  801470:	b8 04 00 00 00       	mov    $0x4,%eax
  801475:	e8 bb fe ff ff       	call   801335 <fsipc>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 04                	js     801485 <devfile_write+0x52>
	assert(r <= n);
  801481:	39 d8                	cmp    %ebx,%eax
  801483:	77 1e                	ja     8014a3 <devfile_write+0x70>
}
  801485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801488:	c9                   	leave  
  801489:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80148a:	68 38 23 80 00       	push   $0x802338
  80148f:	68 65 23 80 00       	push   $0x802365
  801494:	68 94 00 00 00       	push   $0x94
  801499:	68 7a 23 80 00       	push   $0x80237a
  80149e:	e8 a9 ec ff ff       	call   80014c <_panic>
	assert(r <= n);
  8014a3:	68 85 23 80 00       	push   $0x802385
  8014a8:	68 65 23 80 00       	push   $0x802365
  8014ad:	68 98 00 00 00       	push   $0x98
  8014b2:	68 7a 23 80 00       	push   $0x80237a
  8014b7:	e8 90 ec ff ff       	call   80014c <_panic>

008014bc <devfile_read>:
{
  8014bc:	f3 0f 1e fb          	endbr32 
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
  8014c5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ce:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8014d3:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	b8 03 00 00 00       	mov    $0x3,%eax
  8014e3:	e8 4d fe ff ff       	call   801335 <fsipc>
  8014e8:	89 c3                	mov    %eax,%ebx
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 1f                	js     80150d <devfile_read+0x51>
	assert(r <= n);
  8014ee:	39 f0                	cmp    %esi,%eax
  8014f0:	77 24                	ja     801516 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8014f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014f7:	7f 33                	jg     80152c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014f9:	83 ec 04             	sub    $0x4,%esp
  8014fc:	50                   	push   %eax
  8014fd:	68 00 50 c0 00       	push   $0xc05000
  801502:	ff 75 0c             	pushl  0xc(%ebp)
  801505:	e8 4b f4 ff ff       	call   800955 <memmove>
	return r;
  80150a:	83 c4 10             	add    $0x10,%esp
}
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    
	assert(r <= n);
  801516:	68 85 23 80 00       	push   $0x802385
  80151b:	68 65 23 80 00       	push   $0x802365
  801520:	6a 7c                	push   $0x7c
  801522:	68 7a 23 80 00       	push   $0x80237a
  801527:	e8 20 ec ff ff       	call   80014c <_panic>
	assert(r <= PGSIZE);
  80152c:	68 8c 23 80 00       	push   $0x80238c
  801531:	68 65 23 80 00       	push   $0x802365
  801536:	6a 7d                	push   $0x7d
  801538:	68 7a 23 80 00       	push   $0x80237a
  80153d:	e8 0a ec ff ff       	call   80014c <_panic>

00801542 <open>:
{
  801542:	f3 0f 1e fb          	endbr32 
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 1c             	sub    $0x1c,%esp
  80154e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801551:	56                   	push   %esi
  801552:	e8 03 f2 ff ff       	call   80075a <strlen>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80155f:	7f 6c                	jg     8015cd <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801567:	50                   	push   %eax
  801568:	e8 28 f8 ff ff       	call   800d95 <fd_alloc>
  80156d:	89 c3                	mov    %eax,%ebx
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 3c                	js     8015b2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	56                   	push   %esi
  80157a:	68 00 50 c0 00       	push   $0xc05000
  80157f:	e8 19 f2 ff ff       	call   80079d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801584:	8b 45 0c             	mov    0xc(%ebp),%eax
  801587:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158f:	b8 01 00 00 00       	mov    $0x1,%eax
  801594:	e8 9c fd ff ff       	call   801335 <fsipc>
  801599:	89 c3                	mov    %eax,%ebx
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 19                	js     8015bb <open+0x79>
	return fd2num(fd);
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a8:	e8 b5 f7 ff ff       	call   800d62 <fd2num>
  8015ad:	89 c3                	mov    %eax,%ebx
  8015af:	83 c4 10             	add    $0x10,%esp
}
  8015b2:	89 d8                	mov    %ebx,%eax
  8015b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    
		fd_close(fd, 0);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c3:	e8 d1 f8 ff ff       	call   800e99 <fd_close>
		return r;
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	eb e5                	jmp    8015b2 <open+0x70>
		return -E_BAD_PATH;
  8015cd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015d2:	eb de                	jmp    8015b2 <open+0x70>

008015d4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015d4:	f3 0f 1e fb          	endbr32 
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8015e8:	e8 48 fd ff ff       	call   801335 <fsipc>
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015ef:	f3 0f 1e fb          	endbr32 
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	e8 70 f7 ff ff       	call   800d76 <fd2data>
  801606:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801608:	83 c4 08             	add    $0x8,%esp
  80160b:	68 98 23 80 00       	push   $0x802398
  801610:	53                   	push   %ebx
  801611:	e8 87 f1 ff ff       	call   80079d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801616:	8b 46 04             	mov    0x4(%esi),%eax
  801619:	2b 06                	sub    (%esi),%eax
  80161b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801621:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801628:	00 00 00 
	stat->st_dev = &devpipe;
  80162b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801632:	30 80 00 
	return 0;
}
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801641:	f3 0f 1e fb          	endbr32 
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80164f:	53                   	push   %ebx
  801650:	6a 00                	push   $0x0
  801652:	e8 20 f6 ff ff       	call   800c77 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801657:	89 1c 24             	mov    %ebx,(%esp)
  80165a:	e8 17 f7 ff ff       	call   800d76 <fd2data>
  80165f:	83 c4 08             	add    $0x8,%esp
  801662:	50                   	push   %eax
  801663:	6a 00                	push   $0x0
  801665:	e8 0d f6 ff ff       	call   800c77 <sys_page_unmap>
}
  80166a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <_pipeisclosed>:
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 1c             	sub    $0x1c,%esp
  801678:	89 c7                	mov    %eax,%edi
  80167a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80167c:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801681:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801684:	83 ec 0c             	sub    $0xc,%esp
  801687:	57                   	push   %edi
  801688:	e8 5f 05 00 00       	call   801bec <pageref>
  80168d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801690:	89 34 24             	mov    %esi,(%esp)
  801693:	e8 54 05 00 00       	call   801bec <pageref>
		nn = thisenv->env_runs;
  801698:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  80169e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	39 cb                	cmp    %ecx,%ebx
  8016a6:	74 1b                	je     8016c3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ab:	75 cf                	jne    80167c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016ad:	8b 42 58             	mov    0x58(%edx),%eax
  8016b0:	6a 01                	push   $0x1
  8016b2:	50                   	push   %eax
  8016b3:	53                   	push   %ebx
  8016b4:	68 9f 23 80 00       	push   $0x80239f
  8016b9:	e8 75 eb ff ff       	call   800233 <cprintf>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	eb b9                	jmp    80167c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016c6:	0f 94 c0             	sete   %al
  8016c9:	0f b6 c0             	movzbl %al,%eax
}
  8016cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5f                   	pop    %edi
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    

008016d4 <devpipe_write>:
{
  8016d4:	f3 0f 1e fb          	endbr32 
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	57                   	push   %edi
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 28             	sub    $0x28,%esp
  8016e1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016e4:	56                   	push   %esi
  8016e5:	e8 8c f6 ff ff       	call   800d76 <fd2data>
  8016ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016f7:	74 4f                	je     801748 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8016fc:	8b 0b                	mov    (%ebx),%ecx
  8016fe:	8d 51 20             	lea    0x20(%ecx),%edx
  801701:	39 d0                	cmp    %edx,%eax
  801703:	72 14                	jb     801719 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801705:	89 da                	mov    %ebx,%edx
  801707:	89 f0                	mov    %esi,%eax
  801709:	e8 61 ff ff ff       	call   80166f <_pipeisclosed>
  80170e:	85 c0                	test   %eax,%eax
  801710:	75 3b                	jne    80174d <devpipe_write+0x79>
			sys_yield();
  801712:	e8 e3 f4 ff ff       	call   800bfa <sys_yield>
  801717:	eb e0                	jmp    8016f9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801719:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801720:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801723:	89 c2                	mov    %eax,%edx
  801725:	c1 fa 1f             	sar    $0x1f,%edx
  801728:	89 d1                	mov    %edx,%ecx
  80172a:	c1 e9 1b             	shr    $0x1b,%ecx
  80172d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801730:	83 e2 1f             	and    $0x1f,%edx
  801733:	29 ca                	sub    %ecx,%edx
  801735:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801739:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80173d:	83 c0 01             	add    $0x1,%eax
  801740:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801743:	83 c7 01             	add    $0x1,%edi
  801746:	eb ac                	jmp    8016f4 <devpipe_write+0x20>
	return i;
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	eb 05                	jmp    801752 <devpipe_write+0x7e>
				return 0;
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5f                   	pop    %edi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <devpipe_read>:
{
  80175a:	f3 0f 1e fb          	endbr32 
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	57                   	push   %edi
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 18             	sub    $0x18,%esp
  801767:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80176a:	57                   	push   %edi
  80176b:	e8 06 f6 ff ff       	call   800d76 <fd2data>
  801770:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	be 00 00 00 00       	mov    $0x0,%esi
  80177a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80177d:	75 14                	jne    801793 <devpipe_read+0x39>
	return i;
  80177f:	8b 45 10             	mov    0x10(%ebp),%eax
  801782:	eb 02                	jmp    801786 <devpipe_read+0x2c>
				return i;
  801784:	89 f0                	mov    %esi,%eax
}
  801786:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5f                   	pop    %edi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    
			sys_yield();
  80178e:	e8 67 f4 ff ff       	call   800bfa <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801793:	8b 03                	mov    (%ebx),%eax
  801795:	3b 43 04             	cmp    0x4(%ebx),%eax
  801798:	75 18                	jne    8017b2 <devpipe_read+0x58>
			if (i > 0)
  80179a:	85 f6                	test   %esi,%esi
  80179c:	75 e6                	jne    801784 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80179e:	89 da                	mov    %ebx,%edx
  8017a0:	89 f8                	mov    %edi,%eax
  8017a2:	e8 c8 fe ff ff       	call   80166f <_pipeisclosed>
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	74 e3                	je     80178e <devpipe_read+0x34>
				return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b0:	eb d4                	jmp    801786 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017b2:	99                   	cltd   
  8017b3:	c1 ea 1b             	shr    $0x1b,%edx
  8017b6:	01 d0                	add    %edx,%eax
  8017b8:	83 e0 1f             	and    $0x1f,%eax
  8017bb:	29 d0                	sub    %edx,%eax
  8017bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017c8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017cb:	83 c6 01             	add    $0x1,%esi
  8017ce:	eb aa                	jmp    80177a <devpipe_read+0x20>

008017d0 <pipe>:
{
  8017d0:	f3 0f 1e fb          	endbr32 
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017df:	50                   	push   %eax
  8017e0:	e8 b0 f5 ff ff       	call   800d95 <fd_alloc>
  8017e5:	89 c3                	mov    %eax,%ebx
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	0f 88 23 01 00 00    	js     801915 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 07 04 00 00       	push   $0x407
  8017fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fd:	6a 00                	push   $0x0
  8017ff:	e8 21 f4 ff ff       	call   800c25 <sys_page_alloc>
  801804:	89 c3                	mov    %eax,%ebx
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	85 c0                	test   %eax,%eax
  80180b:	0f 88 04 01 00 00    	js     801915 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801817:	50                   	push   %eax
  801818:	e8 78 f5 ff ff       	call   800d95 <fd_alloc>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	0f 88 db 00 00 00    	js     801905 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	68 07 04 00 00       	push   $0x407
  801832:	ff 75 f0             	pushl  -0x10(%ebp)
  801835:	6a 00                	push   $0x0
  801837:	e8 e9 f3 ff ff       	call   800c25 <sys_page_alloc>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	0f 88 bc 00 00 00    	js     801905 <pipe+0x135>
	va = fd2data(fd0);
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	ff 75 f4             	pushl  -0xc(%ebp)
  80184f:	e8 22 f5 ff ff       	call   800d76 <fd2data>
  801854:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801856:	83 c4 0c             	add    $0xc,%esp
  801859:	68 07 04 00 00       	push   $0x407
  80185e:	50                   	push   %eax
  80185f:	6a 00                	push   $0x0
  801861:	e8 bf f3 ff ff       	call   800c25 <sys_page_alloc>
  801866:	89 c3                	mov    %eax,%ebx
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	85 c0                	test   %eax,%eax
  80186d:	0f 88 82 00 00 00    	js     8018f5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	ff 75 f0             	pushl  -0x10(%ebp)
  801879:	e8 f8 f4 ff ff       	call   800d76 <fd2data>
  80187e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801885:	50                   	push   %eax
  801886:	6a 00                	push   $0x0
  801888:	56                   	push   %esi
  801889:	6a 00                	push   $0x0
  80188b:	e8 bd f3 ff ff       	call   800c4d <sys_page_map>
  801890:	89 c3                	mov    %eax,%ebx
  801892:	83 c4 20             	add    $0x20,%esp
  801895:	85 c0                	test   %eax,%eax
  801897:	78 4e                	js     8018e7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801899:	a1 20 30 80 00       	mov    0x803020,%eax
  80189e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018bc:	83 ec 0c             	sub    $0xc,%esp
  8018bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c2:	e8 9b f4 ff ff       	call   800d62 <fd2num>
  8018c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018cc:	83 c4 04             	add    $0x4,%esp
  8018cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d2:	e8 8b f4 ff ff       	call   800d62 <fd2num>
  8018d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e5:	eb 2e                	jmp    801915 <pipe+0x145>
	sys_page_unmap(0, va);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	56                   	push   %esi
  8018eb:	6a 00                	push   $0x0
  8018ed:	e8 85 f3 ff ff       	call   800c77 <sys_page_unmap>
  8018f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fb:	6a 00                	push   $0x0
  8018fd:	e8 75 f3 ff ff       	call   800c77 <sys_page_unmap>
  801902:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	ff 75 f4             	pushl  -0xc(%ebp)
  80190b:	6a 00                	push   $0x0
  80190d:	e8 65 f3 ff ff       	call   800c77 <sys_page_unmap>
  801912:	83 c4 10             	add    $0x10,%esp
}
  801915:	89 d8                	mov    %ebx,%eax
  801917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191a:	5b                   	pop    %ebx
  80191b:	5e                   	pop    %esi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <pipeisclosed>:
{
  80191e:	f3 0f 1e fb          	endbr32 
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 b7 f4 ff ff       	call   800deb <fd_lookup>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	85 c0                	test   %eax,%eax
  801939:	78 18                	js     801953 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	ff 75 f4             	pushl  -0xc(%ebp)
  801941:	e8 30 f4 ff ff       	call   800d76 <fd2data>
  801946:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	e8 1f fd ff ff       	call   80166f <_pipeisclosed>
  801950:	83 c4 10             	add    $0x10,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801955:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
  80195e:	c3                   	ret    

0080195f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80195f:	f3 0f 1e fb          	endbr32 
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801969:	68 b7 23 80 00       	push   $0x8023b7
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	e8 27 ee ff ff       	call   80079d <strcpy>
	return 0;
}
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <devcons_write>:
{
  80197d:	f3 0f 1e fb          	endbr32 
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	57                   	push   %edi
  801985:	56                   	push   %esi
  801986:	53                   	push   %ebx
  801987:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80198d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801992:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801998:	3b 75 10             	cmp    0x10(%ebp),%esi
  80199b:	73 31                	jae    8019ce <devcons_write+0x51>
		m = n - tot;
  80199d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019a0:	29 f3                	sub    %esi,%ebx
  8019a2:	83 fb 7f             	cmp    $0x7f,%ebx
  8019a5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019aa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	53                   	push   %ebx
  8019b1:	89 f0                	mov    %esi,%eax
  8019b3:	03 45 0c             	add    0xc(%ebp),%eax
  8019b6:	50                   	push   %eax
  8019b7:	57                   	push   %edi
  8019b8:	e8 98 ef ff ff       	call   800955 <memmove>
		sys_cputs(buf, m);
  8019bd:	83 c4 08             	add    $0x8,%esp
  8019c0:	53                   	push   %ebx
  8019c1:	57                   	push   %edi
  8019c2:	e8 93 f1 ff ff       	call   800b5a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019c7:	01 de                	add    %ebx,%esi
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	eb ca                	jmp    801998 <devcons_write+0x1b>
}
  8019ce:	89 f0                	mov    %esi,%eax
  8019d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5f                   	pop    %edi
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    

008019d8 <devcons_read>:
{
  8019d8:	f3 0f 1e fb          	endbr32 
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8019e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019eb:	74 21                	je     801a0e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8019ed:	e8 92 f1 ff ff       	call   800b84 <sys_cgetc>
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	75 07                	jne    8019fd <devcons_read+0x25>
		sys_yield();
  8019f6:	e8 ff f1 ff ff       	call   800bfa <sys_yield>
  8019fb:	eb f0                	jmp    8019ed <devcons_read+0x15>
	if (c < 0)
  8019fd:	78 0f                	js     801a0e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8019ff:	83 f8 04             	cmp    $0x4,%eax
  801a02:	74 0c                	je     801a10 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a07:	88 02                	mov    %al,(%edx)
	return 1;
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    
		return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
  801a15:	eb f7                	jmp    801a0e <devcons_read+0x36>

00801a17 <cputchar>:
{
  801a17:	f3 0f 1e fb          	endbr32 
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a27:	6a 01                	push   $0x1
  801a29:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a2c:	50                   	push   %eax
  801a2d:	e8 28 f1 ff ff       	call   800b5a <sys_cputs>
}
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <getchar>:
{
  801a37:	f3 0f 1e fb          	endbr32 
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a41:	6a 01                	push   $0x1
  801a43:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a46:	50                   	push   %eax
  801a47:	6a 00                	push   $0x0
  801a49:	e8 20 f6 ff ff       	call   80106e <read>
	if (r < 0)
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 06                	js     801a5b <getchar+0x24>
	if (r < 1)
  801a55:	74 06                	je     801a5d <getchar+0x26>
	return c;
  801a57:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
		return -E_EOF;
  801a5d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a62:	eb f7                	jmp    801a5b <getchar+0x24>

00801a64 <iscons>:
{
  801a64:	f3 0f 1e fb          	endbr32 
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a71:	50                   	push   %eax
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	e8 71 f3 ff ff       	call   800deb <fd_lookup>
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 11                	js     801a92 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a84:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a8a:	39 10                	cmp    %edx,(%eax)
  801a8c:	0f 94 c0             	sete   %al
  801a8f:	0f b6 c0             	movzbl %al,%eax
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <opencons>:
{
  801a94:	f3 0f 1e fb          	endbr32 
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	e8 ee f2 ff ff       	call   800d95 <fd_alloc>
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 3a                	js     801ae8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 07 04 00 00       	push   $0x407
  801ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab9:	6a 00                	push   $0x0
  801abb:	e8 65 f1 ff ff       	call   800c25 <sys_page_alloc>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 21                	js     801ae8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aca:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ad0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801adc:	83 ec 0c             	sub    $0xc,%esp
  801adf:	50                   	push   %eax
  801ae0:	e8 7d f2 ff ff       	call   800d62 <fd2num>
  801ae5:	83 c4 10             	add    $0x10,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801aea:	f3 0f 1e fb          	endbr32 
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	56                   	push   %esi
  801af2:	53                   	push   %ebx
  801af3:	8b 75 08             	mov    0x8(%ebp),%esi
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801afc:	85 c0                	test   %eax,%eax
  801afe:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b03:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	50                   	push   %eax
  801b0a:	e8 2d f2 ff ff       	call   800d3c <sys_ipc_recv>
	if (r < 0) {
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 2b                	js     801b41 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b16:	85 f6                	test   %esi,%esi
  801b18:	74 0a                	je     801b24 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b1a:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801b1f:	8b 40 74             	mov    0x74(%eax),%eax
  801b22:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801b24:	85 db                	test   %ebx,%ebx
  801b26:	74 0a                	je     801b32 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801b28:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801b2d:	8b 40 78             	mov    0x78(%eax),%eax
  801b30:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801b32:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801b37:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    
		if (from_env_store) {
  801b41:	85 f6                	test   %esi,%esi
  801b43:	74 06                	je     801b4b <ipc_recv+0x61>
			*from_env_store = 0;
  801b45:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b4b:	85 db                	test   %ebx,%ebx
  801b4d:	74 eb                	je     801b3a <ipc_recv+0x50>
			*perm_store = 0;
  801b4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b55:	eb e3                	jmp    801b3a <ipc_recv+0x50>

00801b57 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b57:	f3 0f 1e fb          	endbr32 
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b67:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b6d:	85 db                	test   %ebx,%ebx
  801b6f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b74:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b77:	ff 75 14             	pushl  0x14(%ebp)
  801b7a:	53                   	push   %ebx
  801b7b:	56                   	push   %esi
  801b7c:	57                   	push   %edi
  801b7d:	e8 91 f1 ff ff       	call   800d13 <sys_ipc_try_send>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b88:	75 07                	jne    801b91 <ipc_send+0x3a>
		sys_yield();
  801b8a:	e8 6b f0 ff ff       	call   800bfa <sys_yield>
  801b8f:	eb e6                	jmp    801b77 <ipc_send+0x20>
	}

	if (ret < 0) {
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 08                	js     801b9d <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5f                   	pop    %edi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b9d:	50                   	push   %eax
  801b9e:	68 c3 23 80 00       	push   $0x8023c3
  801ba3:	6a 48                	push   $0x48
  801ba5:	68 e0 23 80 00       	push   $0x8023e0
  801baa:	e8 9d e5 ff ff       	call   80014c <_panic>

00801baf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801baf:	f3 0f 1e fb          	endbr32 
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bbe:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bc1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801bc7:	8b 52 50             	mov    0x50(%edx),%edx
  801bca:	39 ca                	cmp    %ecx,%edx
  801bcc:	74 11                	je     801bdf <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801bce:	83 c0 01             	add    $0x1,%eax
  801bd1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801bd6:	75 e6                	jne    801bbe <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdd:	eb 0b                	jmp    801bea <ipc_find_env+0x3b>
			return envs[i].env_id;
  801bdf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801be2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801be7:	8b 40 48             	mov    0x48(%eax),%eax
}
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bf6:	89 c2                	mov    %eax,%edx
  801bf8:	c1 ea 16             	shr    $0x16,%edx
  801bfb:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c07:	f6 c1 01             	test   $0x1,%cl
  801c0a:	74 1c                	je     801c28 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c0c:	c1 e8 0c             	shr    $0xc,%eax
  801c0f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c16:	a8 01                	test   $0x1,%al
  801c18:	74 0e                	je     801c28 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c1a:	c1 e8 0c             	shr    $0xc,%eax
  801c1d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c24:	ef 
  801c25:	0f b7 d2             	movzwl %dx,%edx
}
  801c28:	89 d0                	mov    %edx,%eax
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
  801c2c:	66 90                	xchg   %ax,%ax
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <__udivdi3>:
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	57                   	push   %edi
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 1c             	sub    $0x1c,%esp
  801c3b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c4b:	85 d2                	test   %edx,%edx
  801c4d:	75 19                	jne    801c68 <__udivdi3+0x38>
  801c4f:	39 f3                	cmp    %esi,%ebx
  801c51:	76 4d                	jbe    801ca0 <__udivdi3+0x70>
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	89 e8                	mov    %ebp,%eax
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	f7 f3                	div    %ebx
  801c5b:	89 fa                	mov    %edi,%edx
  801c5d:	83 c4 1c             	add    $0x1c,%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5e                   	pop    %esi
  801c62:	5f                   	pop    %edi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    
  801c65:	8d 76 00             	lea    0x0(%esi),%esi
  801c68:	39 f2                	cmp    %esi,%edx
  801c6a:	76 14                	jbe    801c80 <__udivdi3+0x50>
  801c6c:	31 ff                	xor    %edi,%edi
  801c6e:	31 c0                	xor    %eax,%eax
  801c70:	89 fa                	mov    %edi,%edx
  801c72:	83 c4 1c             	add    $0x1c,%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    
  801c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c80:	0f bd fa             	bsr    %edx,%edi
  801c83:	83 f7 1f             	xor    $0x1f,%edi
  801c86:	75 48                	jne    801cd0 <__udivdi3+0xa0>
  801c88:	39 f2                	cmp    %esi,%edx
  801c8a:	72 06                	jb     801c92 <__udivdi3+0x62>
  801c8c:	31 c0                	xor    %eax,%eax
  801c8e:	39 eb                	cmp    %ebp,%ebx
  801c90:	77 de                	ja     801c70 <__udivdi3+0x40>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	eb d7                	jmp    801c70 <__udivdi3+0x40>
  801c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	89 d9                	mov    %ebx,%ecx
  801ca2:	85 db                	test   %ebx,%ebx
  801ca4:	75 0b                	jne    801cb1 <__udivdi3+0x81>
  801ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cab:	31 d2                	xor    %edx,%edx
  801cad:	f7 f3                	div    %ebx
  801caf:	89 c1                	mov    %eax,%ecx
  801cb1:	31 d2                	xor    %edx,%edx
  801cb3:	89 f0                	mov    %esi,%eax
  801cb5:	f7 f1                	div    %ecx
  801cb7:	89 c6                	mov    %eax,%esi
  801cb9:	89 e8                	mov    %ebp,%eax
  801cbb:	89 f7                	mov    %esi,%edi
  801cbd:	f7 f1                	div    %ecx
  801cbf:	89 fa                	mov    %edi,%edx
  801cc1:	83 c4 1c             	add    $0x1c,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
  801cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cd0:	89 f9                	mov    %edi,%ecx
  801cd2:	b8 20 00 00 00       	mov    $0x20,%eax
  801cd7:	29 f8                	sub    %edi,%eax
  801cd9:	d3 e2                	shl    %cl,%edx
  801cdb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cdf:	89 c1                	mov    %eax,%ecx
  801ce1:	89 da                	mov    %ebx,%edx
  801ce3:	d3 ea                	shr    %cl,%edx
  801ce5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ce9:	09 d1                	or     %edx,%ecx
  801ceb:	89 f2                	mov    %esi,%edx
  801ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf1:	89 f9                	mov    %edi,%ecx
  801cf3:	d3 e3                	shl    %cl,%ebx
  801cf5:	89 c1                	mov    %eax,%ecx
  801cf7:	d3 ea                	shr    %cl,%edx
  801cf9:	89 f9                	mov    %edi,%ecx
  801cfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801cff:	89 eb                	mov    %ebp,%ebx
  801d01:	d3 e6                	shl    %cl,%esi
  801d03:	89 c1                	mov    %eax,%ecx
  801d05:	d3 eb                	shr    %cl,%ebx
  801d07:	09 de                	or     %ebx,%esi
  801d09:	89 f0                	mov    %esi,%eax
  801d0b:	f7 74 24 08          	divl   0x8(%esp)
  801d0f:	89 d6                	mov    %edx,%esi
  801d11:	89 c3                	mov    %eax,%ebx
  801d13:	f7 64 24 0c          	mull   0xc(%esp)
  801d17:	39 d6                	cmp    %edx,%esi
  801d19:	72 15                	jb     801d30 <__udivdi3+0x100>
  801d1b:	89 f9                	mov    %edi,%ecx
  801d1d:	d3 e5                	shl    %cl,%ebp
  801d1f:	39 c5                	cmp    %eax,%ebp
  801d21:	73 04                	jae    801d27 <__udivdi3+0xf7>
  801d23:	39 d6                	cmp    %edx,%esi
  801d25:	74 09                	je     801d30 <__udivdi3+0x100>
  801d27:	89 d8                	mov    %ebx,%eax
  801d29:	31 ff                	xor    %edi,%edi
  801d2b:	e9 40 ff ff ff       	jmp    801c70 <__udivdi3+0x40>
  801d30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d33:	31 ff                	xor    %edi,%edi
  801d35:	e9 36 ff ff ff       	jmp    801c70 <__udivdi3+0x40>
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	66 90                	xchg   %ax,%ax
  801d3e:	66 90                	xchg   %ax,%ax

00801d40 <__umoddi3>:
  801d40:	f3 0f 1e fb          	endbr32 
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d53:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	75 19                	jne    801d78 <__umoddi3+0x38>
  801d5f:	39 df                	cmp    %ebx,%edi
  801d61:	76 5d                	jbe    801dc0 <__umoddi3+0x80>
  801d63:	89 f0                	mov    %esi,%eax
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	f7 f7                	div    %edi
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	83 c4 1c             	add    $0x1c,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    
  801d75:	8d 76 00             	lea    0x0(%esi),%esi
  801d78:	89 f2                	mov    %esi,%edx
  801d7a:	39 d8                	cmp    %ebx,%eax
  801d7c:	76 12                	jbe    801d90 <__umoddi3+0x50>
  801d7e:	89 f0                	mov    %esi,%eax
  801d80:	89 da                	mov    %ebx,%edx
  801d82:	83 c4 1c             	add    $0x1c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d90:	0f bd e8             	bsr    %eax,%ebp
  801d93:	83 f5 1f             	xor    $0x1f,%ebp
  801d96:	75 50                	jne    801de8 <__umoddi3+0xa8>
  801d98:	39 d8                	cmp    %ebx,%eax
  801d9a:	0f 82 e0 00 00 00    	jb     801e80 <__umoddi3+0x140>
  801da0:	89 d9                	mov    %ebx,%ecx
  801da2:	39 f7                	cmp    %esi,%edi
  801da4:	0f 86 d6 00 00 00    	jbe    801e80 <__umoddi3+0x140>
  801daa:	89 d0                	mov    %edx,%eax
  801dac:	89 ca                	mov    %ecx,%edx
  801dae:	83 c4 1c             	add    $0x1c,%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
  801db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	89 fd                	mov    %edi,%ebp
  801dc2:	85 ff                	test   %edi,%edi
  801dc4:	75 0b                	jne    801dd1 <__umoddi3+0x91>
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	f7 f7                	div    %edi
  801dcf:	89 c5                	mov    %eax,%ebp
  801dd1:	89 d8                	mov    %ebx,%eax
  801dd3:	31 d2                	xor    %edx,%edx
  801dd5:	f7 f5                	div    %ebp
  801dd7:	89 f0                	mov    %esi,%eax
  801dd9:	f7 f5                	div    %ebp
  801ddb:	89 d0                	mov    %edx,%eax
  801ddd:	31 d2                	xor    %edx,%edx
  801ddf:	eb 8c                	jmp    801d6d <__umoddi3+0x2d>
  801de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de8:	89 e9                	mov    %ebp,%ecx
  801dea:	ba 20 00 00 00       	mov    $0x20,%edx
  801def:	29 ea                	sub    %ebp,%edx
  801df1:	d3 e0                	shl    %cl,%eax
  801df3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df7:	89 d1                	mov    %edx,%ecx
  801df9:	89 f8                	mov    %edi,%eax
  801dfb:	d3 e8                	shr    %cl,%eax
  801dfd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e05:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e09:	09 c1                	or     %eax,%ecx
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e11:	89 e9                	mov    %ebp,%ecx
  801e13:	d3 e7                	shl    %cl,%edi
  801e15:	89 d1                	mov    %edx,%ecx
  801e17:	d3 e8                	shr    %cl,%eax
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e1f:	d3 e3                	shl    %cl,%ebx
  801e21:	89 c7                	mov    %eax,%edi
  801e23:	89 d1                	mov    %edx,%ecx
  801e25:	89 f0                	mov    %esi,%eax
  801e27:	d3 e8                	shr    %cl,%eax
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	89 fa                	mov    %edi,%edx
  801e2d:	d3 e6                	shl    %cl,%esi
  801e2f:	09 d8                	or     %ebx,%eax
  801e31:	f7 74 24 08          	divl   0x8(%esp)
  801e35:	89 d1                	mov    %edx,%ecx
  801e37:	89 f3                	mov    %esi,%ebx
  801e39:	f7 64 24 0c          	mull   0xc(%esp)
  801e3d:	89 c6                	mov    %eax,%esi
  801e3f:	89 d7                	mov    %edx,%edi
  801e41:	39 d1                	cmp    %edx,%ecx
  801e43:	72 06                	jb     801e4b <__umoddi3+0x10b>
  801e45:	75 10                	jne    801e57 <__umoddi3+0x117>
  801e47:	39 c3                	cmp    %eax,%ebx
  801e49:	73 0c                	jae    801e57 <__umoddi3+0x117>
  801e4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e53:	89 d7                	mov    %edx,%edi
  801e55:	89 c6                	mov    %eax,%esi
  801e57:	89 ca                	mov    %ecx,%edx
  801e59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e5e:	29 f3                	sub    %esi,%ebx
  801e60:	19 fa                	sbb    %edi,%edx
  801e62:	89 d0                	mov    %edx,%eax
  801e64:	d3 e0                	shl    %cl,%eax
  801e66:	89 e9                	mov    %ebp,%ecx
  801e68:	d3 eb                	shr    %cl,%ebx
  801e6a:	d3 ea                	shr    %cl,%edx
  801e6c:	09 d8                	or     %ebx,%eax
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
  801e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e7d:	8d 76 00             	lea    0x0(%esi),%esi
  801e80:	29 fe                	sub    %edi,%esi
  801e82:	19 c3                	sbb    %eax,%ebx
  801e84:	89 f2                	mov    %esi,%edx
  801e86:	89 d9                	mov    %ebx,%ecx
  801e88:	e9 1d ff ff ff       	jmp    801daa <__umoddi3+0x6a>
