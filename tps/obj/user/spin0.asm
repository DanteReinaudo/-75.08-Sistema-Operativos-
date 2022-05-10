
obj/user/spin0.debug:     formato del fichero elf32-i386


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
  80002c:	e8 76 00 00 00       	call   8000a7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#define TICK (1U << 15)

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 0c             	sub    $0xc,%esp
	envid_t me = sys_getenvid();
  800040:	e8 0a 0b 00 00       	call   800b4f <sys_getenvid>
  800045:	89 c7                	mov    %eax,%edi
	unsigned n = 0;
	bool yield = me & 1;
  800047:	89 c6                	mov    %eax,%esi
  800049:	83 e6 01             	and    $0x1,%esi
  80004c:	bb 01 00 00 00       	mov    $0x1,%ebx
  800051:	eb 15                	jmp    800068 <umain+0x35>
		if (yield) {
			cprintf("I am %08x and I like my interrupt #%u\n", me, n);
			sys_yield();
		}
		else {
			cprintf("I am %08x and my spin will go on #%u\n", me, n);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	53                   	push   %ebx
  800057:	57                   	push   %edi
  800058:	68 88 1e 80 00       	push   $0x801e88
  80005d:	e8 4e 01 00 00       	call   8001b0 <cprintf>
  800062:	83 c3 01             	add    $0x1,%ebx
  800065:	83 c4 10             	add    $0x10,%esp
	bool yield = me & 1;
  800068:	b8 01 80 00 00       	mov    $0x8001,%eax
		while (i--)
  80006d:	83 e8 01             	sub    $0x1,%eax
  800070:	75 fb                	jne    80006d <umain+0x3a>
		if (yield) {
  800072:	85 f6                	test   %esi,%esi
  800074:	74 dd                	je     800053 <umain+0x20>
			cprintf("I am %08x and I like my interrupt #%u\n", me, n);
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	53                   	push   %ebx
  80007a:	57                   	push   %edi
  80007b:	68 60 1e 80 00       	push   $0x801e60
  800080:	e8 2b 01 00 00       	call   8001b0 <cprintf>
			sys_yield();
  800085:	e8 ed 0a 00 00       	call   800b77 <sys_yield>
	while (n++ < 5 || !yield) {
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	83 fb 04             	cmp    $0x4,%ebx
  800090:	0f 96 c2             	setbe  %dl
  800093:	85 f6                	test   %esi,%esi
  800095:	0f 94 c0             	sete   %al
  800098:	83 c3 01             	add    $0x1,%ebx
  80009b:	08 c2                	or     %al,%dl
  80009d:	75 c9                	jne    800068 <umain+0x35>
		}
	}
}
  80009f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5f                   	pop    %edi
  8000a5:	5d                   	pop    %ebp
  8000a6:	c3                   	ret    

008000a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a7:	f3 0f 1e fb          	endbr32 
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000b3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000b6:	e8 94 0a 00 00       	call   800b4f <sys_getenvid>
	if (id >= 0)
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	78 12                	js     8000d1 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000bf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000cc:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d1:	85 db                	test   %ebx,%ebx
  8000d3:	7e 07                	jle    8000dc <libmain+0x35>
		binaryname = argv[0];
  8000d5:	8b 06                	mov    (%esi),%eax
  8000d7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000dc:	83 ec 08             	sub    $0x8,%esp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	e8 4d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e6:	e8 0a 00 00 00       	call   8000f5 <exit>
}
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f1:	5b                   	pop    %ebx
  8000f2:	5e                   	pop    %esi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    

008000f5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f5:	f3 0f 1e fb          	endbr32 
  8000f9:	55                   	push   %ebp
  8000fa:	89 e5                	mov    %esp,%ebp
  8000fc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ff:	e8 ce 0d 00 00       	call   800ed2 <close_all>
	sys_env_destroy(0);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	6a 00                	push   $0x0
  800109:	e8 1b 0a 00 00       	call   800b29 <sys_env_destroy>
}
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	c9                   	leave  
  800112:	c3                   	ret    

00800113 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800113:	f3 0f 1e fb          	endbr32 
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	53                   	push   %ebx
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800121:	8b 13                	mov    (%ebx),%edx
  800123:	8d 42 01             	lea    0x1(%edx),%eax
  800126:	89 03                	mov    %eax,(%ebx)
  800128:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800134:	74 09                	je     80013f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800136:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	68 ff 00 00 00       	push   $0xff
  800147:	8d 43 08             	lea    0x8(%ebx),%eax
  80014a:	50                   	push   %eax
  80014b:	e8 87 09 00 00       	call   800ad7 <sys_cputs>
		b->idx = 0;
  800150:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb db                	jmp    800136 <putch+0x23>

0080015b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015b:	f3 0f 1e fb          	endbr32 
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800168:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016f:	00 00 00 
	b.cnt = 0;
  800172:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800179:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017c:	ff 75 0c             	pushl  0xc(%ebp)
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	68 13 01 80 00       	push   $0x800113
  80018e:	e8 80 01 00 00       	call   800313 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800193:	83 c4 08             	add    $0x8,%esp
  800196:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 2f 09 00 00       	call   800ad7 <sys_cputs>

	return b.cnt;
}
  8001a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bd:	50                   	push   %eax
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	e8 95 ff ff ff       	call   80015b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	57                   	push   %edi
  8001cc:	56                   	push   %esi
  8001cd:	53                   	push   %ebx
  8001ce:	83 ec 1c             	sub    $0x1c,%esp
  8001d1:	89 c7                	mov    %eax,%edi
  8001d3:	89 d6                	mov    %edx,%esi
  8001d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	89 d1                	mov    %edx,%ecx
  8001dd:	89 c2                	mov    %eax,%edx
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001fa:	72 3e                	jb     80023a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff 75 18             	pushl  0x18(%ebp)
  800202:	83 eb 01             	sub    $0x1,%ebx
  800205:	53                   	push   %ebx
  800206:	50                   	push   %eax
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020d:	ff 75 e0             	pushl  -0x20(%ebp)
  800210:	ff 75 dc             	pushl  -0x24(%ebp)
  800213:	ff 75 d8             	pushl  -0x28(%ebp)
  800216:	e8 e5 19 00 00       	call   801c00 <__udivdi3>
  80021b:	83 c4 18             	add    $0x18,%esp
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	89 f2                	mov    %esi,%edx
  800222:	89 f8                	mov    %edi,%eax
  800224:	e8 9f ff ff ff       	call   8001c8 <printnum>
  800229:	83 c4 20             	add    $0x20,%esp
  80022c:	eb 13                	jmp    800241 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	56                   	push   %esi
  800232:	ff 75 18             	pushl  0x18(%ebp)
  800235:	ff d7                	call   *%edi
  800237:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023a:	83 eb 01             	sub    $0x1,%ebx
  80023d:	85 db                	test   %ebx,%ebx
  80023f:	7f ed                	jg     80022e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800241:	83 ec 08             	sub    $0x8,%esp
  800244:	56                   	push   %esi
  800245:	83 ec 04             	sub    $0x4,%esp
  800248:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024b:	ff 75 e0             	pushl  -0x20(%ebp)
  80024e:	ff 75 dc             	pushl  -0x24(%ebp)
  800251:	ff 75 d8             	pushl  -0x28(%ebp)
  800254:	e8 b7 1a 00 00       	call   801d10 <__umoddi3>
  800259:	83 c4 14             	add    $0x14,%esp
  80025c:	0f be 80 b8 1e 80 00 	movsbl 0x801eb8(%eax),%eax
  800263:	50                   	push   %eax
  800264:	ff d7                	call   *%edi
}
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    

00800271 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800271:	83 fa 01             	cmp    $0x1,%edx
  800274:	7f 13                	jg     800289 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800276:	85 d2                	test   %edx,%edx
  800278:	74 1c                	je     800296 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027f:	89 08                	mov    %ecx,(%eax)
  800281:	8b 02                	mov    (%edx),%eax
  800283:	ba 00 00 00 00       	mov    $0x0,%edx
  800288:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 08             	lea    0x8(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	8b 52 04             	mov    0x4(%edx),%edx
  800295:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800296:	8b 10                	mov    (%eax),%edx
  800298:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029b:	89 08                	mov    %ecx,(%eax)
  80029d:	8b 02                	mov    (%edx),%eax
  80029f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a4:	c3                   	ret    

008002a5 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002a5:	83 fa 01             	cmp    $0x1,%edx
  8002a8:	7f 0f                	jg     8002b9 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8002aa:	85 d2                	test   %edx,%edx
  8002ac:	74 18                	je     8002c6 <getint+0x21>
		return va_arg(*ap, long);
  8002ae:	8b 10                	mov    (%eax),%edx
  8002b0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b3:	89 08                	mov    %ecx,(%eax)
  8002b5:	8b 02                	mov    (%edx),%eax
  8002b7:	99                   	cltd   
  8002b8:	c3                   	ret    
		return va_arg(*ap, long long);
  8002b9:	8b 10                	mov    (%eax),%edx
  8002bb:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002be:	89 08                	mov    %ecx,(%eax)
  8002c0:	8b 02                	mov    (%edx),%eax
  8002c2:	8b 52 04             	mov    0x4(%edx),%edx
  8002c5:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002c6:	8b 10                	mov    (%eax),%edx
  8002c8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002cb:	89 08                	mov    %ecx,(%eax)
  8002cd:	8b 02                	mov    (%edx),%eax
  8002cf:	99                   	cltd   
}
  8002d0:	c3                   	ret    

008002d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002df:	8b 10                	mov    (%eax),%edx
  8002e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e4:	73 0a                	jae    8002f0 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e9:	89 08                	mov    %ecx,(%eax)
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	88 02                	mov    %al,(%edx)
}
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <printfmt>:
{
  8002f2:	f3 0f 1e fb          	endbr32 
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ff:	50                   	push   %eax
  800300:	ff 75 10             	pushl  0x10(%ebp)
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	e8 05 00 00 00       	call   800313 <vprintfmt>
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <vprintfmt>:
{
  800313:	f3 0f 1e fb          	endbr32 
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	57                   	push   %edi
  80031b:	56                   	push   %esi
  80031c:	53                   	push   %ebx
  80031d:	83 ec 2c             	sub    $0x2c,%esp
  800320:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800323:	8b 75 0c             	mov    0xc(%ebp),%esi
  800326:	8b 7d 10             	mov    0x10(%ebp),%edi
  800329:	e9 86 02 00 00       	jmp    8005b4 <vprintfmt+0x2a1>
		padc = ' ';
  80032e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800332:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800339:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800340:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800347:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8d 47 01             	lea    0x1(%edi),%eax
  80034f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800352:	0f b6 17             	movzbl (%edi),%edx
  800355:	8d 42 dd             	lea    -0x23(%edx),%eax
  800358:	3c 55                	cmp    $0x55,%al
  80035a:	0f 87 df 02 00 00    	ja     80063f <vprintfmt+0x32c>
  800360:	0f b6 c0             	movzbl %al,%eax
  800363:	3e ff 24 85 00 20 80 	notrack jmp *0x802000(,%eax,4)
  80036a:	00 
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800372:	eb d8                	jmp    80034c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800377:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80037b:	eb cf                	jmp    80034c <vprintfmt+0x39>
  80037d:	0f b6 d2             	movzbl %dl,%edx
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800383:	b8 00 00 00 00       	mov    $0x0,%eax
  800388:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80038b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800395:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800398:	83 f9 09             	cmp    $0x9,%ecx
  80039b:	77 52                	ja     8003ef <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80039d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a0:	eb e9                	jmp    80038b <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a5:	8d 50 04             	lea    0x4(%eax),%edx
  8003a8:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b7:	79 93                	jns    80034c <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c6:	eb 84                	jmp    80034c <vprintfmt+0x39>
  8003c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	0f 49 d0             	cmovns %eax,%edx
  8003d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003db:	e9 6c ff ff ff       	jmp    80034c <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003ea:	e9 5d ff ff ff       	jmp    80034c <vprintfmt+0x39>
  8003ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f5:	eb bc                	jmp    8003b3 <vprintfmt+0xa0>
			lflag++;
  8003f7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fd:	e9 4a ff ff ff       	jmp    80034c <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 50 04             	lea    0x4(%eax),%edx
  800408:	89 55 14             	mov    %edx,0x14(%ebp)
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	56                   	push   %esi
  80040f:	ff 30                	pushl  (%eax)
  800411:	ff d3                	call   *%ebx
			break;
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	e9 96 01 00 00       	jmp    8005b1 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8d 50 04             	lea    0x4(%eax),%edx
  800421:	89 55 14             	mov    %edx,0x14(%ebp)
  800424:	8b 00                	mov    (%eax),%eax
  800426:	99                   	cltd   
  800427:	31 d0                	xor    %edx,%eax
  800429:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042b:	83 f8 0f             	cmp    $0xf,%eax
  80042e:	7f 20                	jg     800450 <vprintfmt+0x13d>
  800430:	8b 14 85 60 21 80 00 	mov    0x802160(,%eax,4),%edx
  800437:	85 d2                	test   %edx,%edx
  800439:	74 15                	je     800450 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80043b:	52                   	push   %edx
  80043c:	68 b7 22 80 00       	push   $0x8022b7
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	e8 aa fe ff ff       	call   8002f2 <printfmt>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	e9 61 01 00 00       	jmp    8005b1 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800450:	50                   	push   %eax
  800451:	68 d0 1e 80 00       	push   $0x801ed0
  800456:	56                   	push   %esi
  800457:	53                   	push   %ebx
  800458:	e8 95 fe ff ff       	call   8002f2 <printfmt>
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	e9 4c 01 00 00       	jmp    8005b1 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8d 50 04             	lea    0x4(%eax),%edx
  80046b:	89 55 14             	mov    %edx,0x14(%ebp)
  80046e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800470:	85 c9                	test   %ecx,%ecx
  800472:	b8 c9 1e 80 00       	mov    $0x801ec9,%eax
  800477:	0f 45 c1             	cmovne %ecx,%eax
  80047a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80047d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800481:	7e 06                	jle    800489 <vprintfmt+0x176>
  800483:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800487:	75 0d                	jne    800496 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800489:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80048c:	89 c7                	mov    %eax,%edi
  80048e:	03 45 e0             	add    -0x20(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	eb 57                	jmp    8004ed <vprintfmt+0x1da>
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 d8             	pushl  -0x28(%ebp)
  80049c:	ff 75 cc             	pushl  -0x34(%ebp)
  80049f:	e8 4f 02 00 00       	call   8006f3 <strnlen>
  8004a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a7:	29 c2                	sub    %eax,%edx
  8004a9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ac:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004af:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8004b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8004b6:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	85 db                	test   %ebx,%ebx
  8004ba:	7e 10                	jle    8004cc <vprintfmt+0x1b9>
					putch(padc, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	56                   	push   %esi
  8004c0:	57                   	push   %edi
  8004c1:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	83 eb 01             	sub    $0x1,%ebx
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	eb ec                	jmp    8004b8 <vprintfmt+0x1a5>
  8004cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d2:	85 d2                	test   %edx,%edx
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d9:	0f 49 c2             	cmovns %edx,%eax
  8004dc:	29 c2                	sub    %eax,%edx
  8004de:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e1:	eb a6                	jmp    800489 <vprintfmt+0x176>
					putch(ch, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	56                   	push   %esi
  8004e7:	52                   	push   %edx
  8004e8:	ff d3                	call   *%ebx
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f2:	83 c7 01             	add    $0x1,%edi
  8004f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f9:	0f be d0             	movsbl %al,%edx
  8004fc:	85 d2                	test   %edx,%edx
  8004fe:	74 42                	je     800542 <vprintfmt+0x22f>
  800500:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800504:	78 06                	js     80050c <vprintfmt+0x1f9>
  800506:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050a:	78 1e                	js     80052a <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800510:	74 d1                	je     8004e3 <vprintfmt+0x1d0>
  800512:	0f be c0             	movsbl %al,%eax
  800515:	83 e8 20             	sub    $0x20,%eax
  800518:	83 f8 5e             	cmp    $0x5e,%eax
  80051b:	76 c6                	jbe    8004e3 <vprintfmt+0x1d0>
					putch('?', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	56                   	push   %esi
  800521:	6a 3f                	push   $0x3f
  800523:	ff d3                	call   *%ebx
  800525:	83 c4 10             	add    $0x10,%esp
  800528:	eb c3                	jmp    8004ed <vprintfmt+0x1da>
  80052a:	89 cf                	mov    %ecx,%edi
  80052c:	eb 0e                	jmp    80053c <vprintfmt+0x229>
				putch(' ', putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	56                   	push   %esi
  800532:	6a 20                	push   $0x20
  800534:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800536:	83 ef 01             	sub    $0x1,%edi
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	85 ff                	test   %edi,%edi
  80053e:	7f ee                	jg     80052e <vprintfmt+0x21b>
  800540:	eb 6f                	jmp    8005b1 <vprintfmt+0x29e>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb f6                	jmp    80053c <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800546:	89 ca                	mov    %ecx,%edx
  800548:	8d 45 14             	lea    0x14(%ebp),%eax
  80054b:	e8 55 fd ff ff       	call   8002a5 <getint>
  800550:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800553:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800556:	85 d2                	test   %edx,%edx
  800558:	78 0b                	js     800565 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80055a:	89 d1                	mov    %edx,%ecx
  80055c:	89 c2                	mov    %eax,%edx
			base = 10;
  80055e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800563:	eb 32                	jmp    800597 <vprintfmt+0x284>
				putch('-', putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	56                   	push   %esi
  800569:	6a 2d                	push   $0x2d
  80056b:	ff d3                	call   *%ebx
				num = -(long long) num;
  80056d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800570:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800573:	f7 da                	neg    %edx
  800575:	83 d1 00             	adc    $0x0,%ecx
  800578:	f7 d9                	neg    %ecx
  80057a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80057d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800582:	eb 13                	jmp    800597 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800584:	89 ca                	mov    %ecx,%edx
  800586:	8d 45 14             	lea    0x14(%ebp),%eax
  800589:	e8 e3 fc ff ff       	call   800271 <getuint>
  80058e:	89 d1                	mov    %edx,%ecx
  800590:	89 c2                	mov    %eax,%edx
			base = 10;
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800597:	83 ec 0c             	sub    $0xc,%esp
  80059a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80059e:	57                   	push   %edi
  80059f:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a2:	50                   	push   %eax
  8005a3:	51                   	push   %ecx
  8005a4:	52                   	push   %edx
  8005a5:	89 f2                	mov    %esi,%edx
  8005a7:	89 d8                	mov    %ebx,%eax
  8005a9:	e8 1a fc ff ff       	call   8001c8 <printnum>
			break;
  8005ae:	83 c4 20             	add    $0x20,%esp
{
  8005b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b4:	83 c7 01             	add    $0x1,%edi
  8005b7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005bb:	83 f8 25             	cmp    $0x25,%eax
  8005be:	0f 84 6a fd ff ff    	je     80032e <vprintfmt+0x1b>
			if (ch == '\0')
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	0f 84 93 00 00 00    	je     80065f <vprintfmt+0x34c>
			putch(ch, putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	56                   	push   %esi
  8005d0:	50                   	push   %eax
  8005d1:	ff d3                	call   *%ebx
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	eb dc                	jmp    8005b4 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005d8:	89 ca                	mov    %ecx,%edx
  8005da:	8d 45 14             	lea    0x14(%ebp),%eax
  8005dd:	e8 8f fc ff ff       	call   800271 <getuint>
  8005e2:	89 d1                	mov    %edx,%ecx
  8005e4:	89 c2                	mov    %eax,%edx
			base = 8;
  8005e6:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005eb:	eb aa                	jmp    800597 <vprintfmt+0x284>
			putch('0', putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	56                   	push   %esi
  8005f1:	6a 30                	push   $0x30
  8005f3:	ff d3                	call   *%ebx
			putch('x', putdat);
  8005f5:	83 c4 08             	add    $0x8,%esp
  8005f8:	56                   	push   %esi
  8005f9:	6a 78                	push   $0x78
  8005fb:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 50 04             	lea    0x4(%eax),%edx
  800603:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800606:	8b 10                	mov    (%eax),%edx
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060d:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800610:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800615:	eb 80                	jmp    800597 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800617:	89 ca                	mov    %ecx,%edx
  800619:	8d 45 14             	lea    0x14(%ebp),%eax
  80061c:	e8 50 fc ff ff       	call   800271 <getuint>
  800621:	89 d1                	mov    %edx,%ecx
  800623:	89 c2                	mov    %eax,%edx
			base = 16;
  800625:	b8 10 00 00 00       	mov    $0x10,%eax
  80062a:	e9 68 ff ff ff       	jmp    800597 <vprintfmt+0x284>
			putch(ch, putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	56                   	push   %esi
  800633:	6a 25                	push   $0x25
  800635:	ff d3                	call   *%ebx
			break;
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	e9 72 ff ff ff       	jmp    8005b1 <vprintfmt+0x29e>
			putch('%', putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	56                   	push   %esi
  800643:	6a 25                	push   $0x25
  800645:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	89 f8                	mov    %edi,%eax
  80064c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800650:	74 05                	je     800657 <vprintfmt+0x344>
  800652:	83 e8 01             	sub    $0x1,%eax
  800655:	eb f5                	jmp    80064c <vprintfmt+0x339>
  800657:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065a:	e9 52 ff ff ff       	jmp    8005b1 <vprintfmt+0x29e>
}
  80065f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800662:	5b                   	pop    %ebx
  800663:	5e                   	pop    %esi
  800664:	5f                   	pop    %edi
  800665:	5d                   	pop    %ebp
  800666:	c3                   	ret    

00800667 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800667:	f3 0f 1e fb          	endbr32 
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	83 ec 18             	sub    $0x18,%esp
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800677:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80067a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80067e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800688:	85 c0                	test   %eax,%eax
  80068a:	74 26                	je     8006b2 <vsnprintf+0x4b>
  80068c:	85 d2                	test   %edx,%edx
  80068e:	7e 22                	jle    8006b2 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800690:	ff 75 14             	pushl  0x14(%ebp)
  800693:	ff 75 10             	pushl  0x10(%ebp)
  800696:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	68 d1 02 80 00       	push   $0x8002d1
  80069f:	e8 6f fc ff ff       	call   800313 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ad:	83 c4 10             	add    $0x10,%esp
}
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    
		return -E_INVAL;
  8006b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b7:	eb f7                	jmp    8006b0 <vsnprintf+0x49>

008006b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006b9:	f3 0f 1e fb          	endbr32 
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006c3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006c6:	50                   	push   %eax
  8006c7:	ff 75 10             	pushl  0x10(%ebp)
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 92 ff ff ff       	call   800667 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006d7:	f3 0f 1e fb          	endbr32 
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006ea:	74 05                	je     8006f1 <strlen+0x1a>
		n++;
  8006ec:	83 c0 01             	add    $0x1,%eax
  8006ef:	eb f5                	jmp    8006e6 <strlen+0xf>
	return n;
}
  8006f1:	5d                   	pop    %ebp
  8006f2:	c3                   	ret    

008006f3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006f3:	f3 0f 1e fb          	endbr32 
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
  800705:	39 d0                	cmp    %edx,%eax
  800707:	74 0d                	je     800716 <strnlen+0x23>
  800709:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80070d:	74 05                	je     800714 <strnlen+0x21>
		n++;
  80070f:	83 c0 01             	add    $0x1,%eax
  800712:	eb f1                	jmp    800705 <strnlen+0x12>
  800714:	89 c2                	mov    %eax,%edx
	return n;
}
  800716:	89 d0                	mov    %edx,%eax
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80071a:	f3 0f 1e fb          	endbr32 
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	53                   	push   %ebx
  800722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800725:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800731:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800734:	83 c0 01             	add    $0x1,%eax
  800737:	84 d2                	test   %dl,%dl
  800739:	75 f2                	jne    80072d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80073b:	89 c8                	mov    %ecx,%eax
  80073d:	5b                   	pop    %ebx
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800740:	f3 0f 1e fb          	endbr32 
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	53                   	push   %ebx
  800748:	83 ec 10             	sub    $0x10,%esp
  80074b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80074e:	53                   	push   %ebx
  80074f:	e8 83 ff ff ff       	call   8006d7 <strlen>
  800754:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	01 d8                	add    %ebx,%eax
  80075c:	50                   	push   %eax
  80075d:	e8 b8 ff ff ff       	call   80071a <strcpy>
	return dst;
}
  800762:	89 d8                	mov    %ebx,%eax
  800764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800769:	f3 0f 1e fb          	endbr32 
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	56                   	push   %esi
  800771:	53                   	push   %ebx
  800772:	8b 75 08             	mov    0x8(%ebp),%esi
  800775:	8b 55 0c             	mov    0xc(%ebp),%edx
  800778:	89 f3                	mov    %esi,%ebx
  80077a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80077d:	89 f0                	mov    %esi,%eax
  80077f:	39 d8                	cmp    %ebx,%eax
  800781:	74 11                	je     800794 <strncpy+0x2b>
		*dst++ = *src;
  800783:	83 c0 01             	add    $0x1,%eax
  800786:	0f b6 0a             	movzbl (%edx),%ecx
  800789:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80078c:	80 f9 01             	cmp    $0x1,%cl
  80078f:	83 da ff             	sbb    $0xffffffff,%edx
  800792:	eb eb                	jmp    80077f <strncpy+0x16>
	}
	return ret;
}
  800794:	89 f0                	mov    %esi,%eax
  800796:	5b                   	pop    %ebx
  800797:	5e                   	pop    %esi
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80079a:	f3 0f 1e fb          	endbr32 
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	56                   	push   %esi
  8007a2:	53                   	push   %ebx
  8007a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a9:	8b 55 10             	mov    0x10(%ebp),%edx
  8007ac:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007ae:	85 d2                	test   %edx,%edx
  8007b0:	74 21                	je     8007d3 <strlcpy+0x39>
  8007b2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007b6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007b8:	39 c2                	cmp    %eax,%edx
  8007ba:	74 14                	je     8007d0 <strlcpy+0x36>
  8007bc:	0f b6 19             	movzbl (%ecx),%ebx
  8007bf:	84 db                	test   %bl,%bl
  8007c1:	74 0b                	je     8007ce <strlcpy+0x34>
			*dst++ = *src++;
  8007c3:	83 c1 01             	add    $0x1,%ecx
  8007c6:	83 c2 01             	add    $0x1,%edx
  8007c9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007cc:	eb ea                	jmp    8007b8 <strlcpy+0x1e>
  8007ce:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007d0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007d3:	29 f0                	sub    %esi,%eax
}
  8007d5:	5b                   	pop    %ebx
  8007d6:	5e                   	pop    %esi
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007d9:	f3 0f 1e fb          	endbr32 
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007e6:	0f b6 01             	movzbl (%ecx),%eax
  8007e9:	84 c0                	test   %al,%al
  8007eb:	74 0c                	je     8007f9 <strcmp+0x20>
  8007ed:	3a 02                	cmp    (%edx),%al
  8007ef:	75 08                	jne    8007f9 <strcmp+0x20>
		p++, q++;
  8007f1:	83 c1 01             	add    $0x1,%ecx
  8007f4:	83 c2 01             	add    $0x1,%edx
  8007f7:	eb ed                	jmp    8007e6 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007f9:	0f b6 c0             	movzbl %al,%eax
  8007fc:	0f b6 12             	movzbl (%edx),%edx
  8007ff:	29 d0                	sub    %edx,%eax
}
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800811:	89 c3                	mov    %eax,%ebx
  800813:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800816:	eb 06                	jmp    80081e <strncmp+0x1b>
		n--, p++, q++;
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80081e:	39 d8                	cmp    %ebx,%eax
  800820:	74 16                	je     800838 <strncmp+0x35>
  800822:	0f b6 08             	movzbl (%eax),%ecx
  800825:	84 c9                	test   %cl,%cl
  800827:	74 04                	je     80082d <strncmp+0x2a>
  800829:	3a 0a                	cmp    (%edx),%cl
  80082b:	74 eb                	je     800818 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80082d:	0f b6 00             	movzbl (%eax),%eax
  800830:	0f b6 12             	movzbl (%edx),%edx
  800833:	29 d0                	sub    %edx,%eax
}
  800835:	5b                   	pop    %ebx
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    
		return 0;
  800838:	b8 00 00 00 00       	mov    $0x0,%eax
  80083d:	eb f6                	jmp    800835 <strncmp+0x32>

0080083f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80083f:	f3 0f 1e fb          	endbr32 
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80084d:	0f b6 10             	movzbl (%eax),%edx
  800850:	84 d2                	test   %dl,%dl
  800852:	74 09                	je     80085d <strchr+0x1e>
		if (*s == c)
  800854:	38 ca                	cmp    %cl,%dl
  800856:	74 0a                	je     800862 <strchr+0x23>
	for (; *s; s++)
  800858:	83 c0 01             	add    $0x1,%eax
  80085b:	eb f0                	jmp    80084d <strchr+0xe>
			return (char *) s;
	return 0;
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800864:	f3 0f 1e fb          	endbr32 
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800872:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800875:	38 ca                	cmp    %cl,%dl
  800877:	74 09                	je     800882 <strfind+0x1e>
  800879:	84 d2                	test   %dl,%dl
  80087b:	74 05                	je     800882 <strfind+0x1e>
	for (; *s; s++)
  80087d:	83 c0 01             	add    $0x1,%eax
  800880:	eb f0                	jmp    800872 <strfind+0xe>
			break;
	return (char *) s;
}
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800884:	f3 0f 1e fb          	endbr32 
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	57                   	push   %edi
  80088c:	56                   	push   %esi
  80088d:	53                   	push   %ebx
  80088e:	8b 55 08             	mov    0x8(%ebp),%edx
  800891:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800894:	85 c9                	test   %ecx,%ecx
  800896:	74 33                	je     8008cb <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800898:	89 d0                	mov    %edx,%eax
  80089a:	09 c8                	or     %ecx,%eax
  80089c:	a8 03                	test   $0x3,%al
  80089e:	75 23                	jne    8008c3 <memset+0x3f>
		c &= 0xFF;
  8008a0:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008a4:	89 d8                	mov    %ebx,%eax
  8008a6:	c1 e0 08             	shl    $0x8,%eax
  8008a9:	89 df                	mov    %ebx,%edi
  8008ab:	c1 e7 18             	shl    $0x18,%edi
  8008ae:	89 de                	mov    %ebx,%esi
  8008b0:	c1 e6 10             	shl    $0x10,%esi
  8008b3:	09 f7                	or     %esi,%edi
  8008b5:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008b7:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ba:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8008bc:	89 d7                	mov    %edx,%edi
  8008be:	fc                   	cld    
  8008bf:	f3 ab                	rep stos %eax,%es:(%edi)
  8008c1:	eb 08                	jmp    8008cb <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008c3:	89 d7                	mov    %edx,%edi
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	fc                   	cld    
  8008c9:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008cb:	89 d0                	mov    %edx,%eax
  8008cd:	5b                   	pop    %ebx
  8008ce:	5e                   	pop    %esi
  8008cf:	5f                   	pop    %edi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	57                   	push   %edi
  8008da:	56                   	push   %esi
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008e4:	39 c6                	cmp    %eax,%esi
  8008e6:	73 32                	jae    80091a <memmove+0x48>
  8008e8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008eb:	39 c2                	cmp    %eax,%edx
  8008ed:	76 2b                	jbe    80091a <memmove+0x48>
		s += n;
		d += n;
  8008ef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f2:	89 fe                	mov    %edi,%esi
  8008f4:	09 ce                	or     %ecx,%esi
  8008f6:	09 d6                	or     %edx,%esi
  8008f8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008fe:	75 0e                	jne    80090e <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800900:	83 ef 04             	sub    $0x4,%edi
  800903:	8d 72 fc             	lea    -0x4(%edx),%esi
  800906:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800909:	fd                   	std    
  80090a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090c:	eb 09                	jmp    800917 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80090e:	83 ef 01             	sub    $0x1,%edi
  800911:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800914:	fd                   	std    
  800915:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800917:	fc                   	cld    
  800918:	eb 1a                	jmp    800934 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	09 ca                	or     %ecx,%edx
  80091e:	09 f2                	or     %esi,%edx
  800920:	f6 c2 03             	test   $0x3,%dl
  800923:	75 0a                	jne    80092f <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800925:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800928:	89 c7                	mov    %eax,%edi
  80092a:	fc                   	cld    
  80092b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80092d:	eb 05                	jmp    800934 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80092f:	89 c7                	mov    %eax,%edi
  800931:	fc                   	cld    
  800932:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800938:	f3 0f 1e fb          	endbr32 
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800942:	ff 75 10             	pushl  0x10(%ebp)
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	e8 82 ff ff ff       	call   8008d2 <memmove>
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800952:	f3 0f 1e fb          	endbr32 
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800961:	89 c6                	mov    %eax,%esi
  800963:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800966:	39 f0                	cmp    %esi,%eax
  800968:	74 1c                	je     800986 <memcmp+0x34>
		if (*s1 != *s2)
  80096a:	0f b6 08             	movzbl (%eax),%ecx
  80096d:	0f b6 1a             	movzbl (%edx),%ebx
  800970:	38 d9                	cmp    %bl,%cl
  800972:	75 08                	jne    80097c <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	83 c2 01             	add    $0x1,%edx
  80097a:	eb ea                	jmp    800966 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80097c:	0f b6 c1             	movzbl %cl,%eax
  80097f:	0f b6 db             	movzbl %bl,%ebx
  800982:	29 d8                	sub    %ebx,%eax
  800984:	eb 05                	jmp    80098b <memcmp+0x39>
	}

	return 0;
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80098f:	f3 0f 1e fb          	endbr32 
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80099c:	89 c2                	mov    %eax,%edx
  80099e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009a1:	39 d0                	cmp    %edx,%eax
  8009a3:	73 09                	jae    8009ae <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a5:	38 08                	cmp    %cl,(%eax)
  8009a7:	74 05                	je     8009ae <memfind+0x1f>
	for (; s < ends; s++)
  8009a9:	83 c0 01             	add    $0x1,%eax
  8009ac:	eb f3                	jmp    8009a1 <memfind+0x12>
			break;
	return (void *) s;
}
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009b0:	f3 0f 1e fb          	endbr32 
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009c0:	eb 03                	jmp    8009c5 <strtol+0x15>
		s++;
  8009c2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009c5:	0f b6 01             	movzbl (%ecx),%eax
  8009c8:	3c 20                	cmp    $0x20,%al
  8009ca:	74 f6                	je     8009c2 <strtol+0x12>
  8009cc:	3c 09                	cmp    $0x9,%al
  8009ce:	74 f2                	je     8009c2 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009d0:	3c 2b                	cmp    $0x2b,%al
  8009d2:	74 2a                	je     8009fe <strtol+0x4e>
	int neg = 0;
  8009d4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009d9:	3c 2d                	cmp    $0x2d,%al
  8009db:	74 2b                	je     800a08 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009dd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009e3:	75 0f                	jne    8009f4 <strtol+0x44>
  8009e5:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e8:	74 28                	je     800a12 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009ea:	85 db                	test   %ebx,%ebx
  8009ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f1:	0f 44 d8             	cmove  %eax,%ebx
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009fc:	eb 46                	jmp    800a44 <strtol+0x94>
		s++;
  8009fe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a01:	bf 00 00 00 00       	mov    $0x0,%edi
  800a06:	eb d5                	jmp    8009dd <strtol+0x2d>
		s++, neg = 1;
  800a08:	83 c1 01             	add    $0x1,%ecx
  800a0b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a10:	eb cb                	jmp    8009dd <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a12:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a16:	74 0e                	je     800a26 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	75 d8                	jne    8009f4 <strtol+0x44>
		s++, base = 8;
  800a1c:	83 c1 01             	add    $0x1,%ecx
  800a1f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a24:	eb ce                	jmp    8009f4 <strtol+0x44>
		s += 2, base = 16;
  800a26:	83 c1 02             	add    $0x2,%ecx
  800a29:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a2e:	eb c4                	jmp    8009f4 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a30:	0f be d2             	movsbl %dl,%edx
  800a33:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a36:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a39:	7d 3a                	jge    800a75 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a3b:	83 c1 01             	add    $0x1,%ecx
  800a3e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a42:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a44:	0f b6 11             	movzbl (%ecx),%edx
  800a47:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a4a:	89 f3                	mov    %esi,%ebx
  800a4c:	80 fb 09             	cmp    $0x9,%bl
  800a4f:	76 df                	jbe    800a30 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a51:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a54:	89 f3                	mov    %esi,%ebx
  800a56:	80 fb 19             	cmp    $0x19,%bl
  800a59:	77 08                	ja     800a63 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a5b:	0f be d2             	movsbl %dl,%edx
  800a5e:	83 ea 57             	sub    $0x57,%edx
  800a61:	eb d3                	jmp    800a36 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a63:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a66:	89 f3                	mov    %esi,%ebx
  800a68:	80 fb 19             	cmp    $0x19,%bl
  800a6b:	77 08                	ja     800a75 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a6d:	0f be d2             	movsbl %dl,%edx
  800a70:	83 ea 37             	sub    $0x37,%edx
  800a73:	eb c1                	jmp    800a36 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a79:	74 05                	je     800a80 <strtol+0xd0>
		*endptr = (char *) s;
  800a7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a80:	89 c2                	mov    %eax,%edx
  800a82:	f7 da                	neg    %edx
  800a84:	85 ff                	test   %edi,%edi
  800a86:	0f 45 c2             	cmovne %edx,%eax
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5e                   	pop    %esi
  800a8b:	5f                   	pop    %edi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	83 ec 1c             	sub    $0x1c,%esp
  800a97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a9d:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aa5:	8b 7d 10             	mov    0x10(%ebp),%edi
  800aa8:	8b 75 14             	mov    0x14(%ebp),%esi
  800aab:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800aad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab1:	74 04                	je     800ab7 <syscall+0x29>
  800ab3:	85 c0                	test   %eax,%eax
  800ab5:	7f 08                	jg     800abf <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5f                   	pop    %edi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800abf:	83 ec 0c             	sub    $0xc,%esp
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac6:	68 bf 21 80 00       	push   $0x8021bf
  800acb:	6a 23                	push   $0x23
  800acd:	68 dc 21 80 00       	push   $0x8021dc
  800ad2:	e8 90 0f 00 00       	call   801a67 <_panic>

00800ad7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ad7:	f3 0f 1e fb          	endbr32 
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ae1:	6a 00                	push   $0x0
  800ae3:	6a 00                	push   $0x0
  800ae5:	6a 00                	push   $0x0
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
  800af7:	e8 92 ff ff ff       	call   800a8e <syscall>
}
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b0b:	6a 00                	push   $0x0
  800b0d:	6a 00                	push   $0x0
  800b0f:	6a 00                	push   $0x0
  800b11:	6a 00                	push   $0x0
  800b13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b22:	e8 67 ff ff ff       	call   800a8e <syscall>
}
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b29:	f3 0f 1e fb          	endbr32 
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b33:	6a 00                	push   $0x0
  800b35:	6a 00                	push   $0x0
  800b37:	6a 00                	push   $0x0
  800b39:	6a 00                	push   $0x0
  800b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3e:	ba 01 00 00 00       	mov    $0x1,%edx
  800b43:	b8 03 00 00 00       	mov    $0x3,%eax
  800b48:	e8 41 ff ff ff       	call   800a8e <syscall>
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b4f:	f3 0f 1e fb          	endbr32 
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b59:	6a 00                	push   $0x0
  800b5b:	6a 00                	push   $0x0
  800b5d:	6a 00                	push   $0x0
  800b5f:	6a 00                	push   $0x0
  800b61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	b8 02 00 00 00       	mov    $0x2,%eax
  800b70:	e8 19 ff ff ff       	call   800a8e <syscall>
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <sys_yield>:

void
sys_yield(void)
{
  800b77:	f3 0f 1e fb          	endbr32 
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b81:	6a 00                	push   $0x0
  800b83:	6a 00                	push   $0x0
  800b85:	6a 00                	push   $0x0
  800b87:	6a 00                	push   $0x0
  800b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b98:	e8 f1 fe ff ff       	call   800a8e <syscall>
}
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba2:	f3 0f 1e fb          	endbr32 
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bac:	6a 00                	push   $0x0
  800bae:	6a 00                	push   $0x0
  800bb0:	ff 75 10             	pushl  0x10(%ebp)
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb9:	ba 01 00 00 00       	mov    $0x1,%edx
  800bbe:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc3:	e8 c6 fe ff ff       	call   800a8e <syscall>
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bca:	f3 0f 1e fb          	endbr32 
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bd4:	ff 75 18             	pushl  0x18(%ebp)
  800bd7:	ff 75 14             	pushl  0x14(%ebp)
  800bda:	ff 75 10             	pushl  0x10(%ebp)
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be3:	ba 01 00 00 00       	mov    $0x1,%edx
  800be8:	b8 05 00 00 00       	mov    $0x5,%eax
  800bed:	e8 9c fe ff ff       	call   800a8e <syscall>
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf4:	f3 0f 1e fb          	endbr32 
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bfe:	6a 00                	push   $0x0
  800c00:	6a 00                	push   $0x0
  800c02:	6a 00                	push   $0x0
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c0f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c14:	e8 75 fe ff ff       	call   800a8e <syscall>
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c1b:	f3 0f 1e fb          	endbr32 
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c25:	6a 00                	push   $0x0
  800c27:	6a 00                	push   $0x0
  800c29:	6a 00                	push   $0x0
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c31:	ba 01 00 00 00       	mov    $0x1,%edx
  800c36:	b8 08 00 00 00       	mov    $0x8,%eax
  800c3b:	e8 4e fe ff ff       	call   800a8e <syscall>
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c4c:	6a 00                	push   $0x0
  800c4e:	6a 00                	push   $0x0
  800c50:	6a 00                	push   $0x0
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c58:	ba 01 00 00 00       	mov    $0x1,%edx
  800c5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800c62:	e8 27 fe ff ff       	call   800a8e <syscall>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c73:	6a 00                	push   $0x0
  800c75:	6a 00                	push   $0x0
  800c77:	6a 00                	push   $0x0
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c89:	e8 00 fe ff ff       	call   800a8e <syscall>
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c90:	f3 0f 1e fb          	endbr32 
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c9a:	6a 00                	push   $0x0
  800c9c:	ff 75 14             	pushl  0x14(%ebp)
  800c9f:	ff 75 10             	pushl  0x10(%ebp)
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cad:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cb2:	e8 d7 fd ff ff       	call   800a8e <syscall>
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cb9:	f3 0f 1e fb          	endbr32 
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cc3:	6a 00                	push   $0x0
  800cc5:	6a 00                	push   $0x0
  800cc7:	6a 00                	push   $0x0
  800cc9:	6a 00                	push   $0x0
  800ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cce:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cd8:	e8 b1 fd ff ff       	call   800a8e <syscall>
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800cdf:	f3 0f 1e fb          	endbr32 
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	05 00 00 00 30       	add    $0x30000000,%eax
  800cee:	c1 e8 0c             	shr    $0xc,%eax
}
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800cf3:	f3 0f 1e fb          	endbr32 
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800cfd:	ff 75 08             	pushl  0x8(%ebp)
  800d00:	e8 da ff ff ff       	call   800cdf <fd2num>
  800d05:	83 c4 10             	add    $0x10,%esp
  800d08:	c1 e0 0c             	shl    $0xc,%eax
  800d0b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d12:	f3 0f 1e fb          	endbr32 
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d1e:	89 c2                	mov    %eax,%edx
  800d20:	c1 ea 16             	shr    $0x16,%edx
  800d23:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d2a:	f6 c2 01             	test   $0x1,%dl
  800d2d:	74 2d                	je     800d5c <fd_alloc+0x4a>
  800d2f:	89 c2                	mov    %eax,%edx
  800d31:	c1 ea 0c             	shr    $0xc,%edx
  800d34:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d3b:	f6 c2 01             	test   $0x1,%dl
  800d3e:	74 1c                	je     800d5c <fd_alloc+0x4a>
  800d40:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d45:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d4a:	75 d2                	jne    800d1e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d55:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d5a:	eb 0a                	jmp    800d66 <fd_alloc+0x54>
			*fd_store = fd;
  800d5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d68:	f3 0f 1e fb          	endbr32 
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d72:	83 f8 1f             	cmp    $0x1f,%eax
  800d75:	77 30                	ja     800da7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d77:	c1 e0 0c             	shl    $0xc,%eax
  800d7a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d7f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800d85:	f6 c2 01             	test   $0x1,%dl
  800d88:	74 24                	je     800dae <fd_lookup+0x46>
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	c1 ea 0c             	shr    $0xc,%edx
  800d8f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d96:	f6 c2 01             	test   $0x1,%dl
  800d99:	74 1a                	je     800db5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9e:	89 02                	mov    %eax,(%edx)
	return 0;
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    
		return -E_INVAL;
  800da7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dac:	eb f7                	jmp    800da5 <fd_lookup+0x3d>
		return -E_INVAL;
  800dae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800db3:	eb f0                	jmp    800da5 <fd_lookup+0x3d>
  800db5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dba:	eb e9                	jmp    800da5 <fd_lookup+0x3d>

00800dbc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800dbc:	f3 0f 1e fb          	endbr32 
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc9:	ba 68 22 80 00       	mov    $0x802268,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800dce:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800dd3:	39 08                	cmp    %ecx,(%eax)
  800dd5:	74 33                	je     800e0a <dev_lookup+0x4e>
  800dd7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800dda:	8b 02                	mov    (%edx),%eax
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	75 f3                	jne    800dd3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800de0:	a1 04 40 80 00       	mov    0x804004,%eax
  800de5:	8b 40 48             	mov    0x48(%eax),%eax
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	51                   	push   %ecx
  800dec:	50                   	push   %eax
  800ded:	68 ec 21 80 00       	push   $0x8021ec
  800df2:	e8 b9 f3 ff ff       	call   8001b0 <cprintf>
	*dev = 0;
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e00:	83 c4 10             	add    $0x10,%esp
  800e03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    
			*dev = devtab[i];
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	eb f2                	jmp    800e08 <dev_lookup+0x4c>

00800e16 <fd_close>:
{
  800e16:	f3 0f 1e fb          	endbr32 
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 28             	sub    $0x28,%esp
  800e23:	8b 75 08             	mov    0x8(%ebp),%esi
  800e26:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e29:	56                   	push   %esi
  800e2a:	e8 b0 fe ff ff       	call   800cdf <fd2num>
  800e2f:	83 c4 08             	add    $0x8,%esp
  800e32:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800e35:	52                   	push   %edx
  800e36:	50                   	push   %eax
  800e37:	e8 2c ff ff ff       	call   800d68 <fd_lookup>
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 05                	js     800e4a <fd_close+0x34>
	    || fd != fd2)
  800e45:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e48:	74 16                	je     800e60 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800e4a:	89 f8                	mov    %edi,%eax
  800e4c:	84 c0                	test   %al,%al
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e53:	0f 44 d8             	cmove  %eax,%ebx
}
  800e56:	89 d8                	mov    %ebx,%eax
  800e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e66:	50                   	push   %eax
  800e67:	ff 36                	pushl  (%esi)
  800e69:	e8 4e ff ff ff       	call   800dbc <dev_lookup>
  800e6e:	89 c3                	mov    %eax,%ebx
  800e70:	83 c4 10             	add    $0x10,%esp
  800e73:	85 c0                	test   %eax,%eax
  800e75:	78 1a                	js     800e91 <fd_close+0x7b>
		if (dev->dev_close)
  800e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e7a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	74 0b                	je     800e91 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	56                   	push   %esi
  800e8a:	ff d0                	call   *%eax
  800e8c:	89 c3                	mov    %eax,%ebx
  800e8e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	56                   	push   %esi
  800e95:	6a 00                	push   $0x0
  800e97:	e8 58 fd ff ff       	call   800bf4 <sys_page_unmap>
	return r;
  800e9c:	83 c4 10             	add    $0x10,%esp
  800e9f:	eb b5                	jmp    800e56 <fd_close+0x40>

00800ea1 <close>:

int
close(int fdnum)
{
  800ea1:	f3 0f 1e fb          	endbr32 
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eae:	50                   	push   %eax
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 b1 fe ff ff       	call   800d68 <fd_lookup>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	79 02                	jns    800ec0 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    
		return fd_close(fd, 1);
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	6a 01                	push   $0x1
  800ec5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec8:	e8 49 ff ff ff       	call   800e16 <fd_close>
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	eb ec                	jmp    800ebe <close+0x1d>

00800ed2 <close_all>:

void
close_all(void)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	53                   	push   %ebx
  800ee6:	e8 b6 ff ff ff       	call   800ea1 <close>
	for (i = 0; i < MAXFD; i++)
  800eeb:	83 c3 01             	add    $0x1,%ebx
  800eee:	83 c4 10             	add    $0x10,%esp
  800ef1:	83 fb 20             	cmp    $0x20,%ebx
  800ef4:	75 ec                	jne    800ee2 <close_all+0x10>
}
  800ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800efb:	f3 0f 1e fb          	endbr32 
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
  800f05:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f0b:	50                   	push   %eax
  800f0c:	ff 75 08             	pushl  0x8(%ebp)
  800f0f:	e8 54 fe ff ff       	call   800d68 <fd_lookup>
  800f14:	89 c3                	mov    %eax,%ebx
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	0f 88 81 00 00 00    	js     800fa2 <dup+0xa7>
		return r;
	close(newfdnum);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	e8 75 ff ff ff       	call   800ea1 <close>

	newfd = INDEX2FD(newfdnum);
  800f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f2f:	c1 e6 0c             	shl    $0xc,%esi
  800f32:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f38:	83 c4 04             	add    $0x4,%esp
  800f3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3e:	e8 b0 fd ff ff       	call   800cf3 <fd2data>
  800f43:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f45:	89 34 24             	mov    %esi,(%esp)
  800f48:	e8 a6 fd ff ff       	call   800cf3 <fd2data>
  800f4d:	83 c4 10             	add    $0x10,%esp
  800f50:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f52:	89 d8                	mov    %ebx,%eax
  800f54:	c1 e8 16             	shr    $0x16,%eax
  800f57:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f5e:	a8 01                	test   $0x1,%al
  800f60:	74 11                	je     800f73 <dup+0x78>
  800f62:	89 d8                	mov    %ebx,%eax
  800f64:	c1 e8 0c             	shr    $0xc,%eax
  800f67:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f6e:	f6 c2 01             	test   $0x1,%dl
  800f71:	75 39                	jne    800fac <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f76:	89 d0                	mov    %edx,%eax
  800f78:	c1 e8 0c             	shr    $0xc,%eax
  800f7b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	25 07 0e 00 00       	and    $0xe07,%eax
  800f8a:	50                   	push   %eax
  800f8b:	56                   	push   %esi
  800f8c:	6a 00                	push   $0x0
  800f8e:	52                   	push   %edx
  800f8f:	6a 00                	push   $0x0
  800f91:	e8 34 fc ff ff       	call   800bca <sys_page_map>
  800f96:	89 c3                	mov    %eax,%ebx
  800f98:	83 c4 20             	add    $0x20,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	78 31                	js     800fd0 <dup+0xd5>
		goto err;

	return newfdnum;
  800f9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fa2:	89 d8                	mov    %ebx,%eax
  800fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	25 07 0e 00 00       	and    $0xe07,%eax
  800fbb:	50                   	push   %eax
  800fbc:	57                   	push   %edi
  800fbd:	6a 00                	push   $0x0
  800fbf:	53                   	push   %ebx
  800fc0:	6a 00                	push   $0x0
  800fc2:	e8 03 fc ff ff       	call   800bca <sys_page_map>
  800fc7:	89 c3                	mov    %eax,%ebx
  800fc9:	83 c4 20             	add    $0x20,%esp
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	79 a3                	jns    800f73 <dup+0x78>
	sys_page_unmap(0, newfd);
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	56                   	push   %esi
  800fd4:	6a 00                	push   $0x0
  800fd6:	e8 19 fc ff ff       	call   800bf4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fdb:	83 c4 08             	add    $0x8,%esp
  800fde:	57                   	push   %edi
  800fdf:	6a 00                	push   $0x0
  800fe1:	e8 0e fc ff ff       	call   800bf4 <sys_page_unmap>
	return r;
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	eb b7                	jmp    800fa2 <dup+0xa7>

00800feb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800feb:	f3 0f 1e fb          	endbr32 
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 1c             	sub    $0x1c,%esp
  800ff6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ff9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ffc:	50                   	push   %eax
  800ffd:	53                   	push   %ebx
  800ffe:	e8 65 fd ff ff       	call   800d68 <fd_lookup>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	78 3f                	js     801049 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801010:	50                   	push   %eax
  801011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801014:	ff 30                	pushl  (%eax)
  801016:	e8 a1 fd ff ff       	call   800dbc <dev_lookup>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 27                	js     801049 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801022:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801025:	8b 42 08             	mov    0x8(%edx),%eax
  801028:	83 e0 03             	and    $0x3,%eax
  80102b:	83 f8 01             	cmp    $0x1,%eax
  80102e:	74 1e                	je     80104e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	8b 40 08             	mov    0x8(%eax),%eax
  801036:	85 c0                	test   %eax,%eax
  801038:	74 35                	je     80106f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	ff 75 10             	pushl  0x10(%ebp)
  801040:	ff 75 0c             	pushl  0xc(%ebp)
  801043:	52                   	push   %edx
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80104e:	a1 04 40 80 00       	mov    0x804004,%eax
  801053:	8b 40 48             	mov    0x48(%eax),%eax
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	53                   	push   %ebx
  80105a:	50                   	push   %eax
  80105b:	68 2d 22 80 00       	push   $0x80222d
  801060:	e8 4b f1 ff ff       	call   8001b0 <cprintf>
		return -E_INVAL;
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106d:	eb da                	jmp    801049 <read+0x5e>
		return -E_NOT_SUPP;
  80106f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801074:	eb d3                	jmp    801049 <read+0x5e>

00801076 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
  801080:	83 ec 0c             	sub    $0xc,%esp
  801083:	8b 7d 08             	mov    0x8(%ebp),%edi
  801086:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108e:	eb 02                	jmp    801092 <readn+0x1c>
  801090:	01 c3                	add    %eax,%ebx
  801092:	39 f3                	cmp    %esi,%ebx
  801094:	73 21                	jae    8010b7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	89 f0                	mov    %esi,%eax
  80109b:	29 d8                	sub    %ebx,%eax
  80109d:	50                   	push   %eax
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	03 45 0c             	add    0xc(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	57                   	push   %edi
  8010a5:	e8 41 ff ff ff       	call   800feb <read>
		if (m < 0)
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 04                	js     8010b5 <readn+0x3f>
			return m;
		if (m == 0)
  8010b1:	75 dd                	jne    801090 <readn+0x1a>
  8010b3:	eb 02                	jmp    8010b7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010b5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010b7:	89 d8                	mov    %ebx,%eax
  8010b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 1c             	sub    $0x1c,%esp
  8010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	53                   	push   %ebx
  8010d4:	e8 8f fc ff ff       	call   800d68 <fd_lookup>
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 3a                	js     80111a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010e0:	83 ec 08             	sub    $0x8,%esp
  8010e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ea:	ff 30                	pushl  (%eax)
  8010ec:	e8 cb fc ff ff       	call   800dbc <dev_lookup>
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	78 22                	js     80111a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010ff:	74 1e                	je     80111f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 52 0c             	mov    0xc(%edx),%edx
  801107:	85 d2                	test   %edx,%edx
  801109:	74 35                	je     801140 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	ff 75 10             	pushl  0x10(%ebp)
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	ff d2                	call   *%edx
  801117:	83 c4 10             	add    $0x10,%esp
}
  80111a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80111f:	a1 04 40 80 00       	mov    0x804004,%eax
  801124:	8b 40 48             	mov    0x48(%eax),%eax
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	53                   	push   %ebx
  80112b:	50                   	push   %eax
  80112c:	68 49 22 80 00       	push   $0x802249
  801131:	e8 7a f0 ff ff       	call   8001b0 <cprintf>
		return -E_INVAL;
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113e:	eb da                	jmp    80111a <write+0x59>
		return -E_NOT_SUPP;
  801140:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801145:	eb d3                	jmp    80111a <write+0x59>

00801147 <seek>:

int
seek(int fdnum, off_t offset)
{
  801147:	f3 0f 1e fb          	endbr32 
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801151:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801154:	50                   	push   %eax
  801155:	ff 75 08             	pushl  0x8(%ebp)
  801158:	e8 0b fc ff ff       	call   800d68 <fd_lookup>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 0e                	js     801172 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801164:	8b 55 0c             	mov    0xc(%ebp),%edx
  801167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801174:	f3 0f 1e fb          	endbr32 
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	53                   	push   %ebx
  80117c:	83 ec 1c             	sub    $0x1c,%esp
  80117f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801182:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	53                   	push   %ebx
  801187:	e8 dc fb ff ff       	call   800d68 <fd_lookup>
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	85 c0                	test   %eax,%eax
  801191:	78 37                	js     8011ca <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801199:	50                   	push   %eax
  80119a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119d:	ff 30                	pushl  (%eax)
  80119f:	e8 18 fc ff ff       	call   800dbc <dev_lookup>
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 1f                	js     8011ca <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011b2:	74 1b                	je     8011cf <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	8b 52 18             	mov    0x18(%edx),%edx
  8011ba:	85 d2                	test   %edx,%edx
  8011bc:	74 32                	je     8011f0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011be:	83 ec 08             	sub    $0x8,%esp
  8011c1:	ff 75 0c             	pushl  0xc(%ebp)
  8011c4:	50                   	push   %eax
  8011c5:	ff d2                	call   *%edx
  8011c7:	83 c4 10             	add    $0x10,%esp
}
  8011ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011cf:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011d4:	8b 40 48             	mov    0x48(%eax),%eax
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	53                   	push   %ebx
  8011db:	50                   	push   %eax
  8011dc:	68 0c 22 80 00       	push   $0x80220c
  8011e1:	e8 ca ef ff ff       	call   8001b0 <cprintf>
		return -E_INVAL;
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ee:	eb da                	jmp    8011ca <ftruncate+0x56>
		return -E_NOT_SUPP;
  8011f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011f5:	eb d3                	jmp    8011ca <ftruncate+0x56>

008011f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 1c             	sub    $0x1c,%esp
  801202:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801205:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801208:	50                   	push   %eax
  801209:	ff 75 08             	pushl  0x8(%ebp)
  80120c:	e8 57 fb ff ff       	call   800d68 <fd_lookup>
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	78 4b                	js     801263 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801218:	83 ec 08             	sub    $0x8,%esp
  80121b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121e:	50                   	push   %eax
  80121f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801222:	ff 30                	pushl  (%eax)
  801224:	e8 93 fb ff ff       	call   800dbc <dev_lookup>
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 33                	js     801263 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801233:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801237:	74 2f                	je     801268 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801239:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80123c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801243:	00 00 00 
	stat->st_isdir = 0;
  801246:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80124d:	00 00 00 
	stat->st_dev = dev;
  801250:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801256:	83 ec 08             	sub    $0x8,%esp
  801259:	53                   	push   %ebx
  80125a:	ff 75 f0             	pushl  -0x10(%ebp)
  80125d:	ff 50 14             	call   *0x14(%eax)
  801260:	83 c4 10             	add    $0x10,%esp
}
  801263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801266:	c9                   	leave  
  801267:	c3                   	ret    
		return -E_NOT_SUPP;
  801268:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80126d:	eb f4                	jmp    801263 <fstat+0x6c>

0080126f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80126f:	f3 0f 1e fb          	endbr32 
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801278:	83 ec 08             	sub    $0x8,%esp
  80127b:	6a 00                	push   $0x0
  80127d:	ff 75 08             	pushl  0x8(%ebp)
  801280:	e8 3a 02 00 00       	call   8014bf <open>
  801285:	89 c3                	mov    %eax,%ebx
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 1b                	js     8012a9 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	50                   	push   %eax
  801295:	e8 5d ff ff ff       	call   8011f7 <fstat>
  80129a:	89 c6                	mov    %eax,%esi
	close(fd);
  80129c:	89 1c 24             	mov    %ebx,(%esp)
  80129f:	e8 fd fb ff ff       	call   800ea1 <close>
	return r;
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	89 f3                	mov    %esi,%ebx
}
  8012a9:	89 d8                	mov    %ebx,%eax
  8012ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	56                   	push   %esi
  8012b6:	53                   	push   %ebx
  8012b7:	89 c6                	mov    %eax,%esi
  8012b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012c2:	74 27                	je     8012eb <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012c4:	6a 07                	push   $0x7
  8012c6:	68 00 50 80 00       	push   $0x805000
  8012cb:	56                   	push   %esi
  8012cc:	ff 35 00 40 80 00    	pushl  0x804000
  8012d2:	e8 47 08 00 00       	call   801b1e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012d7:	83 c4 0c             	add    $0xc,%esp
  8012da:	6a 00                	push   $0x0
  8012dc:	53                   	push   %ebx
  8012dd:	6a 00                	push   $0x0
  8012df:	e8 cd 07 00 00       	call   801ab1 <ipc_recv>
}
  8012e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	6a 01                	push   $0x1
  8012f0:	e8 81 08 00 00       	call   801b76 <ipc_find_env>
  8012f5:	a3 00 40 80 00       	mov    %eax,0x804000
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	eb c5                	jmp    8012c4 <fsipc+0x12>

008012ff <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012ff:	f3 0f 1e fb          	endbr32 
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8b 40 0c             	mov    0xc(%eax),%eax
  80130f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80131c:	ba 00 00 00 00       	mov    $0x0,%edx
  801321:	b8 02 00 00 00       	mov    $0x2,%eax
  801326:	e8 87 ff ff ff       	call   8012b2 <fsipc>
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <devfile_flush>:
{
  80132d:	f3 0f 1e fb          	endbr32 
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8b 40 0c             	mov    0xc(%eax),%eax
  80133d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801342:	ba 00 00 00 00       	mov    $0x0,%edx
  801347:	b8 06 00 00 00       	mov    $0x6,%eax
  80134c:	e8 61 ff ff ff       	call   8012b2 <fsipc>
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <devfile_stat>:
{
  801353:	f3 0f 1e fb          	endbr32 
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8b 40 0c             	mov    0xc(%eax),%eax
  801367:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80136c:	ba 00 00 00 00       	mov    $0x0,%edx
  801371:	b8 05 00 00 00       	mov    $0x5,%eax
  801376:	e8 37 ff ff ff       	call   8012b2 <fsipc>
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 2c                	js     8013ab <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	68 00 50 80 00       	push   $0x805000
  801387:	53                   	push   %ebx
  801388:	e8 8d f3 ff ff       	call   80071a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80138d:	a1 80 50 80 00       	mov    0x805080,%eax
  801392:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801398:	a1 84 50 80 00       	mov    0x805084,%eax
  80139d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <devfile_write>:
{
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8013c9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8013cf:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8013d5:	77 30                	ja     801407 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	53                   	push   %ebx
  8013db:	ff 75 0c             	pushl  0xc(%ebp)
  8013de:	68 08 50 80 00       	push   $0x805008
  8013e3:	e8 ea f4 ff ff       	call   8008d2 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8013f2:	e8 bb fe ff ff       	call   8012b2 <fsipc>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 04                	js     801402 <devfile_write+0x52>
	assert(r <= n);
  8013fe:	39 d8                	cmp    %ebx,%eax
  801400:	77 1e                	ja     801420 <devfile_write+0x70>
}
  801402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801405:	c9                   	leave  
  801406:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801407:	68 78 22 80 00       	push   $0x802278
  80140c:	68 a5 22 80 00       	push   $0x8022a5
  801411:	68 94 00 00 00       	push   $0x94
  801416:	68 ba 22 80 00       	push   $0x8022ba
  80141b:	e8 47 06 00 00       	call   801a67 <_panic>
	assert(r <= n);
  801420:	68 c5 22 80 00       	push   $0x8022c5
  801425:	68 a5 22 80 00       	push   $0x8022a5
  80142a:	68 98 00 00 00       	push   $0x98
  80142f:	68 ba 22 80 00       	push   $0x8022ba
  801434:	e8 2e 06 00 00       	call   801a67 <_panic>

00801439 <devfile_read>:
{
  801439:	f3 0f 1e fb          	endbr32 
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8b 40 0c             	mov    0xc(%eax),%eax
  80144b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801450:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801456:	ba 00 00 00 00       	mov    $0x0,%edx
  80145b:	b8 03 00 00 00       	mov    $0x3,%eax
  801460:	e8 4d fe ff ff       	call   8012b2 <fsipc>
  801465:	89 c3                	mov    %eax,%ebx
  801467:	85 c0                	test   %eax,%eax
  801469:	78 1f                	js     80148a <devfile_read+0x51>
	assert(r <= n);
  80146b:	39 f0                	cmp    %esi,%eax
  80146d:	77 24                	ja     801493 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80146f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801474:	7f 33                	jg     8014a9 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	50                   	push   %eax
  80147a:	68 00 50 80 00       	push   $0x805000
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	e8 4b f4 ff ff       	call   8008d2 <memmove>
	return r;
  801487:	83 c4 10             	add    $0x10,%esp
}
  80148a:	89 d8                	mov    %ebx,%eax
  80148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    
	assert(r <= n);
  801493:	68 c5 22 80 00       	push   $0x8022c5
  801498:	68 a5 22 80 00       	push   $0x8022a5
  80149d:	6a 7c                	push   $0x7c
  80149f:	68 ba 22 80 00       	push   $0x8022ba
  8014a4:	e8 be 05 00 00       	call   801a67 <_panic>
	assert(r <= PGSIZE);
  8014a9:	68 cc 22 80 00       	push   $0x8022cc
  8014ae:	68 a5 22 80 00       	push   $0x8022a5
  8014b3:	6a 7d                	push   $0x7d
  8014b5:	68 ba 22 80 00       	push   $0x8022ba
  8014ba:	e8 a8 05 00 00       	call   801a67 <_panic>

008014bf <open>:
{
  8014bf:	f3 0f 1e fb          	endbr32 
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	56                   	push   %esi
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 1c             	sub    $0x1c,%esp
  8014cb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014ce:	56                   	push   %esi
  8014cf:	e8 03 f2 ff ff       	call   8006d7 <strlen>
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014dc:	7f 6c                	jg     80154a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	e8 28 f8 ff ff       	call   800d12 <fd_alloc>
  8014ea:	89 c3                	mov    %eax,%ebx
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 3c                	js     80152f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	56                   	push   %esi
  8014f7:	68 00 50 80 00       	push   $0x805000
  8014fc:	e8 19 f2 ff ff       	call   80071a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150c:	b8 01 00 00 00       	mov    $0x1,%eax
  801511:	e8 9c fd ff ff       	call   8012b2 <fsipc>
  801516:	89 c3                	mov    %eax,%ebx
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 19                	js     801538 <open+0x79>
	return fd2num(fd);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	ff 75 f4             	pushl  -0xc(%ebp)
  801525:	e8 b5 f7 ff ff       	call   800cdf <fd2num>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 10             	add    $0x10,%esp
}
  80152f:	89 d8                	mov    %ebx,%eax
  801531:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    
		fd_close(fd, 0);
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	6a 00                	push   $0x0
  80153d:	ff 75 f4             	pushl  -0xc(%ebp)
  801540:	e8 d1 f8 ff ff       	call   800e16 <fd_close>
		return r;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	eb e5                	jmp    80152f <open+0x70>
		return -E_BAD_PATH;
  80154a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80154f:	eb de                	jmp    80152f <open+0x70>

00801551 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	b8 08 00 00 00       	mov    $0x8,%eax
  801565:	e8 48 fd ff ff       	call   8012b2 <fsipc>
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80156c:	f3 0f 1e fb          	endbr32 
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
  801575:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 70 f7 ff ff       	call   800cf3 <fd2data>
  801583:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	68 d8 22 80 00       	push   $0x8022d8
  80158d:	53                   	push   %ebx
  80158e:	e8 87 f1 ff ff       	call   80071a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801593:	8b 46 04             	mov    0x4(%esi),%eax
  801596:	2b 06                	sub    (%esi),%eax
  801598:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80159e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a5:	00 00 00 
	stat->st_dev = &devpipe;
  8015a8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015af:	30 80 00 
	return 0;
}
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ba:	5b                   	pop    %ebx
  8015bb:	5e                   	pop    %esi
  8015bc:	5d                   	pop    %ebp
  8015bd:	c3                   	ret    

008015be <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015be:	f3 0f 1e fb          	endbr32 
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	53                   	push   %ebx
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015cc:	53                   	push   %ebx
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 20 f6 ff ff       	call   800bf4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015d4:	89 1c 24             	mov    %ebx,(%esp)
  8015d7:	e8 17 f7 ff ff       	call   800cf3 <fd2data>
  8015dc:	83 c4 08             	add    $0x8,%esp
  8015df:	50                   	push   %eax
  8015e0:	6a 00                	push   $0x0
  8015e2:	e8 0d f6 ff ff       	call   800bf4 <sys_page_unmap>
}
  8015e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <_pipeisclosed>:
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 1c             	sub    $0x1c,%esp
  8015f5:	89 c7                	mov    %eax,%edi
  8015f7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8015fe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	57                   	push   %edi
  801605:	e8 a9 05 00 00       	call   801bb3 <pageref>
  80160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80160d:	89 34 24             	mov    %esi,(%esp)
  801610:	e8 9e 05 00 00       	call   801bb3 <pageref>
		nn = thisenv->env_runs;
  801615:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80161b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	39 cb                	cmp    %ecx,%ebx
  801623:	74 1b                	je     801640 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801625:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801628:	75 cf                	jne    8015f9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80162a:	8b 42 58             	mov    0x58(%edx),%eax
  80162d:	6a 01                	push   $0x1
  80162f:	50                   	push   %eax
  801630:	53                   	push   %ebx
  801631:	68 df 22 80 00       	push   $0x8022df
  801636:	e8 75 eb ff ff       	call   8001b0 <cprintf>
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	eb b9                	jmp    8015f9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801640:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801643:	0f 94 c0             	sete   %al
  801646:	0f b6 c0             	movzbl %al,%eax
}
  801649:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <devpipe_write>:
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	57                   	push   %edi
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	83 ec 28             	sub    $0x28,%esp
  80165e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801661:	56                   	push   %esi
  801662:	e8 8c f6 ff ff       	call   800cf3 <fd2data>
  801667:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	bf 00 00 00 00       	mov    $0x0,%edi
  801671:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801674:	74 4f                	je     8016c5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801676:	8b 43 04             	mov    0x4(%ebx),%eax
  801679:	8b 0b                	mov    (%ebx),%ecx
  80167b:	8d 51 20             	lea    0x20(%ecx),%edx
  80167e:	39 d0                	cmp    %edx,%eax
  801680:	72 14                	jb     801696 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801682:	89 da                	mov    %ebx,%edx
  801684:	89 f0                	mov    %esi,%eax
  801686:	e8 61 ff ff ff       	call   8015ec <_pipeisclosed>
  80168b:	85 c0                	test   %eax,%eax
  80168d:	75 3b                	jne    8016ca <devpipe_write+0x79>
			sys_yield();
  80168f:	e8 e3 f4 ff ff       	call   800b77 <sys_yield>
  801694:	eb e0                	jmp    801676 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801696:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801699:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80169d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	c1 fa 1f             	sar    $0x1f,%edx
  8016a5:	89 d1                	mov    %edx,%ecx
  8016a7:	c1 e9 1b             	shr    $0x1b,%ecx
  8016aa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016ad:	83 e2 1f             	and    $0x1f,%edx
  8016b0:	29 ca                	sub    %ecx,%edx
  8016b2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016b6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016ba:	83 c0 01             	add    $0x1,%eax
  8016bd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016c0:	83 c7 01             	add    $0x1,%edi
  8016c3:	eb ac                	jmp    801671 <devpipe_write+0x20>
	return i;
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	eb 05                	jmp    8016cf <devpipe_write+0x7e>
				return 0;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <devpipe_read>:
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	57                   	push   %edi
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 18             	sub    $0x18,%esp
  8016e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016e7:	57                   	push   %edi
  8016e8:	e8 06 f6 ff ff       	call   800cf3 <fd2data>
  8016ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	be 00 00 00 00       	mov    $0x0,%esi
  8016f7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016fa:	75 14                	jne    801710 <devpipe_read+0x39>
	return i;
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	eb 02                	jmp    801703 <devpipe_read+0x2c>
				return i;
  801701:	89 f0                	mov    %esi,%eax
}
  801703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5f                   	pop    %edi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    
			sys_yield();
  80170b:	e8 67 f4 ff ff       	call   800b77 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801710:	8b 03                	mov    (%ebx),%eax
  801712:	3b 43 04             	cmp    0x4(%ebx),%eax
  801715:	75 18                	jne    80172f <devpipe_read+0x58>
			if (i > 0)
  801717:	85 f6                	test   %esi,%esi
  801719:	75 e6                	jne    801701 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80171b:	89 da                	mov    %ebx,%edx
  80171d:	89 f8                	mov    %edi,%eax
  80171f:	e8 c8 fe ff ff       	call   8015ec <_pipeisclosed>
  801724:	85 c0                	test   %eax,%eax
  801726:	74 e3                	je     80170b <devpipe_read+0x34>
				return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb d4                	jmp    801703 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80172f:	99                   	cltd   
  801730:	c1 ea 1b             	shr    $0x1b,%edx
  801733:	01 d0                	add    %edx,%eax
  801735:	83 e0 1f             	and    $0x1f,%eax
  801738:	29 d0                	sub    %edx,%eax
  80173a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80173f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801742:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801745:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801748:	83 c6 01             	add    $0x1,%esi
  80174b:	eb aa                	jmp    8016f7 <devpipe_read+0x20>

0080174d <pipe>:
{
  80174d:	f3 0f 1e fb          	endbr32 
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
  801756:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801759:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175c:	50                   	push   %eax
  80175d:	e8 b0 f5 ff ff       	call   800d12 <fd_alloc>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	85 c0                	test   %eax,%eax
  801769:	0f 88 23 01 00 00    	js     801892 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 07 04 00 00       	push   $0x407
  801777:	ff 75 f4             	pushl  -0xc(%ebp)
  80177a:	6a 00                	push   $0x0
  80177c:	e8 21 f4 ff ff       	call   800ba2 <sys_page_alloc>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	0f 88 04 01 00 00    	js     801892 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80178e:	83 ec 0c             	sub    $0xc,%esp
  801791:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801794:	50                   	push   %eax
  801795:	e8 78 f5 ff ff       	call   800d12 <fd_alloc>
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	0f 88 db 00 00 00    	js     801882 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 07 04 00 00       	push   $0x407
  8017af:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b2:	6a 00                	push   $0x0
  8017b4:	e8 e9 f3 ff ff       	call   800ba2 <sys_page_alloc>
  8017b9:	89 c3                	mov    %eax,%ebx
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	0f 88 bc 00 00 00    	js     801882 <pipe+0x135>
	va = fd2data(fd0);
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cc:	e8 22 f5 ff ff       	call   800cf3 <fd2data>
  8017d1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017d3:	83 c4 0c             	add    $0xc,%esp
  8017d6:	68 07 04 00 00       	push   $0x407
  8017db:	50                   	push   %eax
  8017dc:	6a 00                	push   $0x0
  8017de:	e8 bf f3 ff ff       	call   800ba2 <sys_page_alloc>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	0f 88 82 00 00 00    	js     801872 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f0:	83 ec 0c             	sub    $0xc,%esp
  8017f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f6:	e8 f8 f4 ff ff       	call   800cf3 <fd2data>
  8017fb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801802:	50                   	push   %eax
  801803:	6a 00                	push   $0x0
  801805:	56                   	push   %esi
  801806:	6a 00                	push   $0x0
  801808:	e8 bd f3 ff ff       	call   800bca <sys_page_map>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	83 c4 20             	add    $0x20,%esp
  801812:	85 c0                	test   %eax,%eax
  801814:	78 4e                	js     801864 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801816:	a1 20 30 80 00       	mov    0x803020,%eax
  80181b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801823:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80182a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801832:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	ff 75 f4             	pushl  -0xc(%ebp)
  80183f:	e8 9b f4 ff ff       	call   800cdf <fd2num>
  801844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801847:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801849:	83 c4 04             	add    $0x4,%esp
  80184c:	ff 75 f0             	pushl  -0x10(%ebp)
  80184f:	e8 8b f4 ff ff       	call   800cdf <fd2num>
  801854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801857:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801862:	eb 2e                	jmp    801892 <pipe+0x145>
	sys_page_unmap(0, va);
  801864:	83 ec 08             	sub    $0x8,%esp
  801867:	56                   	push   %esi
  801868:	6a 00                	push   $0x0
  80186a:	e8 85 f3 ff ff       	call   800bf4 <sys_page_unmap>
  80186f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	ff 75 f0             	pushl  -0x10(%ebp)
  801878:	6a 00                	push   $0x0
  80187a:	e8 75 f3 ff ff       	call   800bf4 <sys_page_unmap>
  80187f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	ff 75 f4             	pushl  -0xc(%ebp)
  801888:	6a 00                	push   $0x0
  80188a:	e8 65 f3 ff ff       	call   800bf4 <sys_page_unmap>
  80188f:	83 c4 10             	add    $0x10,%esp
}
  801892:	89 d8                	mov    %ebx,%eax
  801894:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5d                   	pop    %ebp
  80189a:	c3                   	ret    

0080189b <pipeisclosed>:
{
  80189b:	f3 0f 1e fb          	endbr32 
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a8:	50                   	push   %eax
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	e8 b7 f4 ff ff       	call   800d68 <fd_lookup>
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 18                	js     8018d0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8018b8:	83 ec 0c             	sub    $0xc,%esp
  8018bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018be:	e8 30 f4 ff ff       	call   800cf3 <fd2data>
  8018c3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8018c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c8:	e8 1f fd ff ff       	call   8015ec <_pipeisclosed>
  8018cd:	83 c4 10             	add    $0x10,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018d2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018db:	c3                   	ret    

008018dc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018dc:	f3 0f 1e fb          	endbr32 
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018e6:	68 f7 22 80 00       	push   $0x8022f7
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	e8 27 ee ff ff       	call   80071a <strcpy>
	return 0;
}
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devcons_write>:
{
  8018fa:	f3 0f 1e fb          	endbr32 
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80190a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80190f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801915:	3b 75 10             	cmp    0x10(%ebp),%esi
  801918:	73 31                	jae    80194b <devcons_write+0x51>
		m = n - tot;
  80191a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80191d:	29 f3                	sub    %esi,%ebx
  80191f:	83 fb 7f             	cmp    $0x7f,%ebx
  801922:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801927:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	53                   	push   %ebx
  80192e:	89 f0                	mov    %esi,%eax
  801930:	03 45 0c             	add    0xc(%ebp),%eax
  801933:	50                   	push   %eax
  801934:	57                   	push   %edi
  801935:	e8 98 ef ff ff       	call   8008d2 <memmove>
		sys_cputs(buf, m);
  80193a:	83 c4 08             	add    $0x8,%esp
  80193d:	53                   	push   %ebx
  80193e:	57                   	push   %edi
  80193f:	e8 93 f1 ff ff       	call   800ad7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801944:	01 de                	add    %ebx,%esi
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	eb ca                	jmp    801915 <devcons_write+0x1b>
}
  80194b:	89 f0                	mov    %esi,%eax
  80194d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5f                   	pop    %edi
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    

00801955 <devcons_read>:
{
  801955:	f3 0f 1e fb          	endbr32 
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801964:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801968:	74 21                	je     80198b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80196a:	e8 92 f1 ff ff       	call   800b01 <sys_cgetc>
  80196f:	85 c0                	test   %eax,%eax
  801971:	75 07                	jne    80197a <devcons_read+0x25>
		sys_yield();
  801973:	e8 ff f1 ff ff       	call   800b77 <sys_yield>
  801978:	eb f0                	jmp    80196a <devcons_read+0x15>
	if (c < 0)
  80197a:	78 0f                	js     80198b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80197c:	83 f8 04             	cmp    $0x4,%eax
  80197f:	74 0c                	je     80198d <devcons_read+0x38>
	*(char*)vbuf = c;
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	88 02                	mov    %al,(%edx)
	return 1;
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    
		return 0;
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
  801992:	eb f7                	jmp    80198b <devcons_read+0x36>

00801994 <cputchar>:
{
  801994:	f3 0f 1e fb          	endbr32 
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019a4:	6a 01                	push   $0x1
  8019a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	e8 28 f1 ff ff       	call   800ad7 <sys_cputs>
}
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <getchar>:
{
  8019b4:	f3 0f 1e fb          	endbr32 
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8019be:	6a 01                	push   $0x1
  8019c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	e8 20 f6 ff ff       	call   800feb <read>
	if (r < 0)
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 06                	js     8019d8 <getchar+0x24>
	if (r < 1)
  8019d2:	74 06                	je     8019da <getchar+0x26>
	return c;
  8019d4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    
		return -E_EOF;
  8019da:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8019df:	eb f7                	jmp    8019d8 <getchar+0x24>

008019e1 <iscons>:
{
  8019e1:	f3 0f 1e fb          	endbr32 
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ee:	50                   	push   %eax
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	e8 71 f3 ff ff       	call   800d68 <fd_lookup>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 11                	js     801a0f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a07:	39 10                	cmp    %edx,(%eax)
  801a09:	0f 94 c0             	sete   %al
  801a0c:	0f b6 c0             	movzbl %al,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <opencons>:
{
  801a11:	f3 0f 1e fb          	endbr32 
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1e:	50                   	push   %eax
  801a1f:	e8 ee f2 ff ff       	call   800d12 <fd_alloc>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 3a                	js     801a65 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	68 07 04 00 00       	push   $0x407
  801a33:	ff 75 f4             	pushl  -0xc(%ebp)
  801a36:	6a 00                	push   $0x0
  801a38:	e8 65 f1 ff ff       	call   800ba2 <sys_page_alloc>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 21                	js     801a65 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a4d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	50                   	push   %eax
  801a5d:	e8 7d f2 ff ff       	call   800cdf <fd2num>
  801a62:	83 c4 10             	add    $0x10,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a67:	f3 0f 1e fb          	endbr32 
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a70:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a73:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a79:	e8 d1 f0 ff ff       	call   800b4f <sys_getenvid>
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	56                   	push   %esi
  801a88:	50                   	push   %eax
  801a89:	68 04 23 80 00       	push   $0x802304
  801a8e:	e8 1d e7 ff ff       	call   8001b0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a93:	83 c4 18             	add    $0x18,%esp
  801a96:	53                   	push   %ebx
  801a97:	ff 75 10             	pushl  0x10(%ebp)
  801a9a:	e8 bc e6 ff ff       	call   80015b <vcprintf>
	cprintf("\n");
  801a9f:	c7 04 24 42 23 80 00 	movl   $0x802342,(%esp)
  801aa6:	e8 05 e7 ff ff       	call   8001b0 <cprintf>
  801aab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801aae:	cc                   	int3   
  801aaf:	eb fd                	jmp    801aae <_panic+0x47>

00801ab1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ab1:	f3 0f 1e fb          	endbr32 
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	56                   	push   %esi
  801ab9:	53                   	push   %ebx
  801aba:	8b 75 08             	mov    0x8(%ebp),%esi
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801aca:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801acd:	83 ec 0c             	sub    $0xc,%esp
  801ad0:	50                   	push   %eax
  801ad1:	e8 e3 f1 ff ff       	call   800cb9 <sys_ipc_recv>
	if (r < 0) {
  801ad6:	83 c4 10             	add    $0x10,%esp
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 2b                	js     801b08 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801add:	85 f6                	test   %esi,%esi
  801adf:	74 0a                	je     801aeb <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801ae1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae6:	8b 40 74             	mov    0x74(%eax),%eax
  801ae9:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801aeb:	85 db                	test   %ebx,%ebx
  801aed:	74 0a                	je     801af9 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801aef:	a1 04 40 80 00       	mov    0x804004,%eax
  801af4:	8b 40 78             	mov    0x78(%eax),%eax
  801af7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801af9:	a1 04 40 80 00       	mov    0x804004,%eax
  801afe:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
		if (from_env_store) {
  801b08:	85 f6                	test   %esi,%esi
  801b0a:	74 06                	je     801b12 <ipc_recv+0x61>
			*from_env_store = 0;
  801b0c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b12:	85 db                	test   %ebx,%ebx
  801b14:	74 eb                	je     801b01 <ipc_recv+0x50>
			*perm_store = 0;
  801b16:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b1c:	eb e3                	jmp    801b01 <ipc_recv+0x50>

00801b1e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b1e:	f3 0f 1e fb          	endbr32 
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	57                   	push   %edi
  801b26:	56                   	push   %esi
  801b27:	53                   	push   %ebx
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b34:	85 db                	test   %ebx,%ebx
  801b36:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b3b:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b3e:	ff 75 14             	pushl  0x14(%ebp)
  801b41:	53                   	push   %ebx
  801b42:	56                   	push   %esi
  801b43:	57                   	push   %edi
  801b44:	e8 47 f1 ff ff       	call   800c90 <sys_ipc_try_send>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b4f:	75 07                	jne    801b58 <ipc_send+0x3a>
		sys_yield();
  801b51:	e8 21 f0 ff ff       	call   800b77 <sys_yield>
  801b56:	eb e6                	jmp    801b3e <ipc_send+0x20>
	}

	if (ret < 0) {
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	78 08                	js     801b64 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b64:	50                   	push   %eax
  801b65:	68 27 23 80 00       	push   $0x802327
  801b6a:	6a 48                	push   $0x48
  801b6c:	68 44 23 80 00       	push   $0x802344
  801b71:	e8 f1 fe ff ff       	call   801a67 <_panic>

00801b76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b76:	f3 0f 1e fb          	endbr32 
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b85:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b88:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b8e:	8b 52 50             	mov    0x50(%edx),%edx
  801b91:	39 ca                	cmp    %ecx,%edx
  801b93:	74 11                	je     801ba6 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b95:	83 c0 01             	add    $0x1,%eax
  801b98:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b9d:	75 e6                	jne    801b85 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	eb 0b                	jmp    801bb1 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801ba6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ba9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bae:	8b 40 48             	mov    0x48(%eax),%eax
}
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bbd:	89 c2                	mov    %eax,%edx
  801bbf:	c1 ea 16             	shr    $0x16,%edx
  801bc2:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801bc9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801bce:	f6 c1 01             	test   $0x1,%cl
  801bd1:	74 1c                	je     801bef <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801bd3:	c1 e8 0c             	shr    $0xc,%eax
  801bd6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801bdd:	a8 01                	test   $0x1,%al
  801bdf:	74 0e                	je     801bef <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801be1:	c1 e8 0c             	shr    $0xc,%eax
  801be4:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801beb:	ef 
  801bec:	0f b7 d2             	movzwl %dx,%edx
}
  801bef:	89 d0                	mov    %edx,%eax
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    
  801bf3:	66 90                	xchg   %ax,%ax
  801bf5:	66 90                	xchg   %ax,%ax
  801bf7:	66 90                	xchg   %ax,%ax
  801bf9:	66 90                	xchg   %ax,%ax
  801bfb:	66 90                	xchg   %ax,%ax
  801bfd:	66 90                	xchg   %ax,%ax
  801bff:	90                   	nop

00801c00 <__udivdi3>:
  801c00:	f3 0f 1e fb          	endbr32 
  801c04:	55                   	push   %ebp
  801c05:	57                   	push   %edi
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 1c             	sub    $0x1c,%esp
  801c0b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c1b:	85 d2                	test   %edx,%edx
  801c1d:	75 19                	jne    801c38 <__udivdi3+0x38>
  801c1f:	39 f3                	cmp    %esi,%ebx
  801c21:	76 4d                	jbe    801c70 <__udivdi3+0x70>
  801c23:	31 ff                	xor    %edi,%edi
  801c25:	89 e8                	mov    %ebp,%eax
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	f7 f3                	div    %ebx
  801c2b:	89 fa                	mov    %edi,%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	39 f2                	cmp    %esi,%edx
  801c3a:	76 14                	jbe    801c50 <__udivdi3+0x50>
  801c3c:	31 ff                	xor    %edi,%edi
  801c3e:	31 c0                	xor    %eax,%eax
  801c40:	89 fa                	mov    %edi,%edx
  801c42:	83 c4 1c             	add    $0x1c,%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5f                   	pop    %edi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    
  801c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c50:	0f bd fa             	bsr    %edx,%edi
  801c53:	83 f7 1f             	xor    $0x1f,%edi
  801c56:	75 48                	jne    801ca0 <__udivdi3+0xa0>
  801c58:	39 f2                	cmp    %esi,%edx
  801c5a:	72 06                	jb     801c62 <__udivdi3+0x62>
  801c5c:	31 c0                	xor    %eax,%eax
  801c5e:	39 eb                	cmp    %ebp,%ebx
  801c60:	77 de                	ja     801c40 <__udivdi3+0x40>
  801c62:	b8 01 00 00 00       	mov    $0x1,%eax
  801c67:	eb d7                	jmp    801c40 <__udivdi3+0x40>
  801c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c70:	89 d9                	mov    %ebx,%ecx
  801c72:	85 db                	test   %ebx,%ebx
  801c74:	75 0b                	jne    801c81 <__udivdi3+0x81>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f3                	div    %ebx
  801c7f:	89 c1                	mov    %eax,%ecx
  801c81:	31 d2                	xor    %edx,%edx
  801c83:	89 f0                	mov    %esi,%eax
  801c85:	f7 f1                	div    %ecx
  801c87:	89 c6                	mov    %eax,%esi
  801c89:	89 e8                	mov    %ebp,%eax
  801c8b:	89 f7                	mov    %esi,%edi
  801c8d:	f7 f1                	div    %ecx
  801c8f:	89 fa                	mov    %edi,%edx
  801c91:	83 c4 1c             	add    $0x1c,%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5f                   	pop    %edi
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    
  801c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	89 f9                	mov    %edi,%ecx
  801ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ca7:	29 f8                	sub    %edi,%eax
  801ca9:	d3 e2                	shl    %cl,%edx
  801cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  801caf:	89 c1                	mov    %eax,%ecx
  801cb1:	89 da                	mov    %ebx,%edx
  801cb3:	d3 ea                	shr    %cl,%edx
  801cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801cb9:	09 d1                	or     %edx,%ecx
  801cbb:	89 f2                	mov    %esi,%edx
  801cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc1:	89 f9                	mov    %edi,%ecx
  801cc3:	d3 e3                	shl    %cl,%ebx
  801cc5:	89 c1                	mov    %eax,%ecx
  801cc7:	d3 ea                	shr    %cl,%edx
  801cc9:	89 f9                	mov    %edi,%ecx
  801ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ccf:	89 eb                	mov    %ebp,%ebx
  801cd1:	d3 e6                	shl    %cl,%esi
  801cd3:	89 c1                	mov    %eax,%ecx
  801cd5:	d3 eb                	shr    %cl,%ebx
  801cd7:	09 de                	or     %ebx,%esi
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	f7 74 24 08          	divl   0x8(%esp)
  801cdf:	89 d6                	mov    %edx,%esi
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	f7 64 24 0c          	mull   0xc(%esp)
  801ce7:	39 d6                	cmp    %edx,%esi
  801ce9:	72 15                	jb     801d00 <__udivdi3+0x100>
  801ceb:	89 f9                	mov    %edi,%ecx
  801ced:	d3 e5                	shl    %cl,%ebp
  801cef:	39 c5                	cmp    %eax,%ebp
  801cf1:	73 04                	jae    801cf7 <__udivdi3+0xf7>
  801cf3:	39 d6                	cmp    %edx,%esi
  801cf5:	74 09                	je     801d00 <__udivdi3+0x100>
  801cf7:	89 d8                	mov    %ebx,%eax
  801cf9:	31 ff                	xor    %edi,%edi
  801cfb:	e9 40 ff ff ff       	jmp    801c40 <__udivdi3+0x40>
  801d00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d03:	31 ff                	xor    %edi,%edi
  801d05:	e9 36 ff ff ff       	jmp    801c40 <__udivdi3+0x40>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	66 90                	xchg   %ax,%ax
  801d0e:	66 90                	xchg   %ax,%ax

00801d10 <__umoddi3>:
  801d10:	f3 0f 1e fb          	endbr32 
  801d14:	55                   	push   %ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
  801d1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d23:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	75 19                	jne    801d48 <__umoddi3+0x38>
  801d2f:	39 df                	cmp    %ebx,%edi
  801d31:	76 5d                	jbe    801d90 <__umoddi3+0x80>
  801d33:	89 f0                	mov    %esi,%eax
  801d35:	89 da                	mov    %ebx,%edx
  801d37:	f7 f7                	div    %edi
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	83 c4 1c             	add    $0x1c,%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
  801d45:	8d 76 00             	lea    0x0(%esi),%esi
  801d48:	89 f2                	mov    %esi,%edx
  801d4a:	39 d8                	cmp    %ebx,%eax
  801d4c:	76 12                	jbe    801d60 <__umoddi3+0x50>
  801d4e:	89 f0                	mov    %esi,%eax
  801d50:	89 da                	mov    %ebx,%edx
  801d52:	83 c4 1c             	add    $0x1c,%esp
  801d55:	5b                   	pop    %ebx
  801d56:	5e                   	pop    %esi
  801d57:	5f                   	pop    %edi
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    
  801d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d60:	0f bd e8             	bsr    %eax,%ebp
  801d63:	83 f5 1f             	xor    $0x1f,%ebp
  801d66:	75 50                	jne    801db8 <__umoddi3+0xa8>
  801d68:	39 d8                	cmp    %ebx,%eax
  801d6a:	0f 82 e0 00 00 00    	jb     801e50 <__umoddi3+0x140>
  801d70:	89 d9                	mov    %ebx,%ecx
  801d72:	39 f7                	cmp    %esi,%edi
  801d74:	0f 86 d6 00 00 00    	jbe    801e50 <__umoddi3+0x140>
  801d7a:	89 d0                	mov    %edx,%eax
  801d7c:	89 ca                	mov    %ecx,%edx
  801d7e:	83 c4 1c             	add    $0x1c,%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5f                   	pop    %edi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    
  801d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d8d:	8d 76 00             	lea    0x0(%esi),%esi
  801d90:	89 fd                	mov    %edi,%ebp
  801d92:	85 ff                	test   %edi,%edi
  801d94:	75 0b                	jne    801da1 <__umoddi3+0x91>
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f7                	div    %edi
  801d9f:	89 c5                	mov    %eax,%ebp
  801da1:	89 d8                	mov    %ebx,%eax
  801da3:	31 d2                	xor    %edx,%edx
  801da5:	f7 f5                	div    %ebp
  801da7:	89 f0                	mov    %esi,%eax
  801da9:	f7 f5                	div    %ebp
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	31 d2                	xor    %edx,%edx
  801daf:	eb 8c                	jmp    801d3d <__umoddi3+0x2d>
  801db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801db8:	89 e9                	mov    %ebp,%ecx
  801dba:	ba 20 00 00 00       	mov    $0x20,%edx
  801dbf:	29 ea                	sub    %ebp,%edx
  801dc1:	d3 e0                	shl    %cl,%eax
  801dc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc7:	89 d1                	mov    %edx,%ecx
  801dc9:	89 f8                	mov    %edi,%eax
  801dcb:	d3 e8                	shr    %cl,%eax
  801dcd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801dd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd9:	09 c1                	or     %eax,%ecx
  801ddb:	89 d8                	mov    %ebx,%eax
  801ddd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e7                	shl    %cl,%edi
  801de5:	89 d1                	mov    %edx,%ecx
  801de7:	d3 e8                	shr    %cl,%eax
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801def:	d3 e3                	shl    %cl,%ebx
  801df1:	89 c7                	mov    %eax,%edi
  801df3:	89 d1                	mov    %edx,%ecx
  801df5:	89 f0                	mov    %esi,%eax
  801df7:	d3 e8                	shr    %cl,%eax
  801df9:	89 e9                	mov    %ebp,%ecx
  801dfb:	89 fa                	mov    %edi,%edx
  801dfd:	d3 e6                	shl    %cl,%esi
  801dff:	09 d8                	or     %ebx,%eax
  801e01:	f7 74 24 08          	divl   0x8(%esp)
  801e05:	89 d1                	mov    %edx,%ecx
  801e07:	89 f3                	mov    %esi,%ebx
  801e09:	f7 64 24 0c          	mull   0xc(%esp)
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	89 d7                	mov    %edx,%edi
  801e11:	39 d1                	cmp    %edx,%ecx
  801e13:	72 06                	jb     801e1b <__umoddi3+0x10b>
  801e15:	75 10                	jne    801e27 <__umoddi3+0x117>
  801e17:	39 c3                	cmp    %eax,%ebx
  801e19:	73 0c                	jae    801e27 <__umoddi3+0x117>
  801e1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e23:	89 d7                	mov    %edx,%edi
  801e25:	89 c6                	mov    %eax,%esi
  801e27:	89 ca                	mov    %ecx,%edx
  801e29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e2e:	29 f3                	sub    %esi,%ebx
  801e30:	19 fa                	sbb    %edi,%edx
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	d3 e0                	shl    %cl,%eax
  801e36:	89 e9                	mov    %ebp,%ecx
  801e38:	d3 eb                	shr    %cl,%ebx
  801e3a:	d3 ea                	shr    %cl,%edx
  801e3c:	09 d8                	or     %ebx,%eax
  801e3e:	83 c4 1c             	add    $0x1c,%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    
  801e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	29 fe                	sub    %edi,%esi
  801e52:	19 c3                	sbb    %eax,%ebx
  801e54:	89 f2                	mov    %esi,%edx
  801e56:	89 d9                	mov    %ebx,%ecx
  801e58:	e9 1d ff ff ff       	jmp    801d7a <__umoddi3+0x6a>
