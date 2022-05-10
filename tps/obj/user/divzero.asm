
obj/user/divzero.debug:     formato del fichero elf32-i386


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
  80002c:	e8 33 00 00 00       	call   800064 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  80003d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800044:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800047:	b8 01 00 00 00       	mov    $0x1,%eax
  80004c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800051:	99                   	cltd   
  800052:	f7 f9                	idiv   %ecx
  800054:	50                   	push   %eax
  800055:	68 20 1e 80 00       	push   $0x801e20
  80005a:	e8 0e 01 00 00       	call   80016d <cprintf>
}
  80005f:	83 c4 10             	add    $0x10,%esp
  800062:	c9                   	leave  
  800063:	c3                   	ret    

00800064 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800070:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800073:	e8 94 0a 00 00       	call   800b0c <sys_getenvid>
	if (id >= 0)
  800078:	85 c0                	test   %eax,%eax
  80007a:	78 12                	js     80008e <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80007c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800081:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800084:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800089:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008e:	85 db                	test   %ebx,%ebx
  800090:	7e 07                	jle    800099 <libmain+0x35>
		binaryname = argv[0];
  800092:	8b 06                	mov    (%esi),%eax
  800094:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	56                   	push   %esi
  80009d:	53                   	push   %ebx
  80009e:	e8 90 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a3:	e8 0a 00 00 00       	call   8000b2 <exit>
}
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ae:	5b                   	pop    %ebx
  8000af:	5e                   	pop    %esi
  8000b0:	5d                   	pop    %ebp
  8000b1:	c3                   	ret    

008000b2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b2:	f3 0f 1e fb          	endbr32 
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bc:	e8 ce 0d 00 00       	call   800e8f <close_all>
	sys_env_destroy(0);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	6a 00                	push   $0x0
  8000c6:	e8 1b 0a 00 00       	call   800ae6 <sys_env_destroy>
}
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	c9                   	leave  
  8000cf:	c3                   	ret    

008000d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000d0:	f3 0f 1e fb          	endbr32 
  8000d4:	55                   	push   %ebp
  8000d5:	89 e5                	mov    %esp,%ebp
  8000d7:	53                   	push   %ebx
  8000d8:	83 ec 04             	sub    $0x4,%esp
  8000db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000de:	8b 13                	mov    (%ebx),%edx
  8000e0:	8d 42 01             	lea    0x1(%edx),%eax
  8000e3:	89 03                	mov    %eax,(%ebx)
  8000e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000f1:	74 09                	je     8000fc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000f3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	68 ff 00 00 00       	push   $0xff
  800104:	8d 43 08             	lea    0x8(%ebx),%eax
  800107:	50                   	push   %eax
  800108:	e8 87 09 00 00       	call   800a94 <sys_cputs>
		b->idx = 0;
  80010d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	eb db                	jmp    8000f3 <putch+0x23>

00800118 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800118:	f3 0f 1e fb          	endbr32 
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800125:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80012c:	00 00 00 
	b.cnt = 0;
  80012f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800136:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	68 d0 00 80 00       	push   $0x8000d0
  80014b:	e8 80 01 00 00       	call   8002d0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800150:	83 c4 08             	add    $0x8,%esp
  800153:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800159:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	e8 2f 09 00 00       	call   800a94 <sys_cputs>

	return b.cnt;
}
  800165:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80016d:	f3 0f 1e fb          	endbr32 
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800177:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017a:	50                   	push   %eax
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	e8 95 ff ff ff       	call   800118 <vcprintf>
	va_end(ap);

	return cnt;
}
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	57                   	push   %edi
  800189:	56                   	push   %esi
  80018a:	53                   	push   %ebx
  80018b:	83 ec 1c             	sub    $0x1c,%esp
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 d6                	mov    %edx,%esi
  800192:	8b 45 08             	mov    0x8(%ebp),%eax
  800195:	8b 55 0c             	mov    0xc(%ebp),%edx
  800198:	89 d1                	mov    %edx,%ecx
  80019a:	89 c2                	mov    %eax,%edx
  80019c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001b2:	39 c2                	cmp    %eax,%edx
  8001b4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b7:	72 3e                	jb     8001f7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 18             	pushl  0x18(%ebp)
  8001bf:	83 eb 01             	sub    $0x1,%ebx
  8001c2:	53                   	push   %ebx
  8001c3:	50                   	push   %eax
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d3:	e8 d8 19 00 00       	call   801bb0 <__udivdi3>
  8001d8:	83 c4 18             	add    $0x18,%esp
  8001db:	52                   	push   %edx
  8001dc:	50                   	push   %eax
  8001dd:	89 f2                	mov    %esi,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	e8 9f ff ff ff       	call   800185 <printnum>
  8001e6:	83 c4 20             	add    $0x20,%esp
  8001e9:	eb 13                	jmp    8001fe <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	56                   	push   %esi
  8001ef:	ff 75 18             	pushl  0x18(%ebp)
  8001f2:	ff d7                	call   *%edi
  8001f4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f7:	83 eb 01             	sub    $0x1,%ebx
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7f ed                	jg     8001eb <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	56                   	push   %esi
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	ff 75 e4             	pushl  -0x1c(%ebp)
  800208:	ff 75 e0             	pushl  -0x20(%ebp)
  80020b:	ff 75 dc             	pushl  -0x24(%ebp)
  80020e:	ff 75 d8             	pushl  -0x28(%ebp)
  800211:	e8 aa 1a 00 00       	call   801cc0 <__umoddi3>
  800216:	83 c4 14             	add    $0x14,%esp
  800219:	0f be 80 38 1e 80 00 	movsbl 0x801e38(%eax),%eax
  800220:	50                   	push   %eax
  800221:	ff d7                	call   *%edi
}
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800229:	5b                   	pop    %ebx
  80022a:	5e                   	pop    %esi
  80022b:	5f                   	pop    %edi
  80022c:	5d                   	pop    %ebp
  80022d:	c3                   	ret    

0080022e <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80022e:	83 fa 01             	cmp    $0x1,%edx
  800231:	7f 13                	jg     800246 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800233:	85 d2                	test   %edx,%edx
  800235:	74 1c                	je     800253 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800237:	8b 10                	mov    (%eax),%edx
  800239:	8d 4a 04             	lea    0x4(%edx),%ecx
  80023c:	89 08                	mov    %ecx,(%eax)
  80023e:	8b 02                	mov    (%edx),%eax
  800240:	ba 00 00 00 00       	mov    $0x0,%edx
  800245:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800246:	8b 10                	mov    (%eax),%edx
  800248:	8d 4a 08             	lea    0x8(%edx),%ecx
  80024b:	89 08                	mov    %ecx,(%eax)
  80024d:	8b 02                	mov    (%edx),%eax
  80024f:	8b 52 04             	mov    0x4(%edx),%edx
  800252:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800253:	8b 10                	mov    (%eax),%edx
  800255:	8d 4a 04             	lea    0x4(%edx),%ecx
  800258:	89 08                	mov    %ecx,(%eax)
  80025a:	8b 02                	mov    (%edx),%eax
  80025c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800261:	c3                   	ret    

00800262 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800262:	83 fa 01             	cmp    $0x1,%edx
  800265:	7f 0f                	jg     800276 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800267:	85 d2                	test   %edx,%edx
  800269:	74 18                	je     800283 <getint+0x21>
		return va_arg(*ap, long);
  80026b:	8b 10                	mov    (%eax),%edx
  80026d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800270:	89 08                	mov    %ecx,(%eax)
  800272:	8b 02                	mov    (%edx),%eax
  800274:	99                   	cltd   
  800275:	c3                   	ret    
		return va_arg(*ap, long long);
  800276:	8b 10                	mov    (%eax),%edx
  800278:	8d 4a 08             	lea    0x8(%edx),%ecx
  80027b:	89 08                	mov    %ecx,(%eax)
  80027d:	8b 02                	mov    (%edx),%eax
  80027f:	8b 52 04             	mov    0x4(%edx),%edx
  800282:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800283:	8b 10                	mov    (%eax),%edx
  800285:	8d 4a 04             	lea    0x4(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 02                	mov    (%edx),%eax
  80028c:	99                   	cltd   
}
  80028d:	c3                   	ret    

0080028e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028e:	f3 0f 1e fb          	endbr32 
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800298:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029c:	8b 10                	mov    (%eax),%edx
  80029e:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a1:	73 0a                	jae    8002ad <sprintputch+0x1f>
		*b->buf++ = ch;
  8002a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a6:	89 08                	mov    %ecx,(%eax)
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	88 02                	mov    %al,(%edx)
}
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <printfmt>:
{
  8002af:	f3 0f 1e fb          	endbr32 
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bc:	50                   	push   %eax
  8002bd:	ff 75 10             	pushl  0x10(%ebp)
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	e8 05 00 00 00       	call   8002d0 <vprintfmt>
}
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <vprintfmt>:
{
  8002d0:	f3 0f 1e fb          	endbr32 
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	57                   	push   %edi
  8002d8:	56                   	push   %esi
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 2c             	sub    $0x2c,%esp
  8002dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e6:	e9 86 02 00 00       	jmp    800571 <vprintfmt+0x2a1>
		padc = ' ';
  8002eb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002ef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800304:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800309:	8d 47 01             	lea    0x1(%edi),%eax
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030f:	0f b6 17             	movzbl (%edi),%edx
  800312:	8d 42 dd             	lea    -0x23(%edx),%eax
  800315:	3c 55                	cmp    $0x55,%al
  800317:	0f 87 df 02 00 00    	ja     8005fc <vprintfmt+0x32c>
  80031d:	0f b6 c0             	movzbl %al,%eax
  800320:	3e ff 24 85 80 1f 80 	notrack jmp *0x801f80(,%eax,4)
  800327:	00 
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032f:	eb d8                	jmp    800309 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800334:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800338:	eb cf                	jmp    800309 <vprintfmt+0x39>
  80033a:	0f b6 d2             	movzbl %dl,%edx
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800348:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800352:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800355:	83 f9 09             	cmp    $0x9,%ecx
  800358:	77 52                	ja     8003ac <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80035a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035d:	eb e9                	jmp    800348 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 50 04             	lea    0x4(%eax),%edx
  800365:	89 55 14             	mov    %edx,0x14(%ebp)
  800368:	8b 00                	mov    (%eax),%eax
  80036a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800370:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800374:	79 93                	jns    800309 <vprintfmt+0x39>
				width = precision, precision = -1;
  800376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800379:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800383:	eb 84                	jmp    800309 <vprintfmt+0x39>
  800385:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800388:	85 c0                	test   %eax,%eax
  80038a:	ba 00 00 00 00       	mov    $0x0,%edx
  80038f:	0f 49 d0             	cmovns %eax,%edx
  800392:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800398:	e9 6c ff ff ff       	jmp    800309 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a7:	e9 5d ff ff ff       	jmp    800309 <vprintfmt+0x39>
  8003ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b2:	eb bc                	jmp    800370 <vprintfmt+0xa0>
			lflag++;
  8003b4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ba:	e9 4a ff ff ff       	jmp    800309 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8d 50 04             	lea    0x4(%eax),%edx
  8003c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	56                   	push   %esi
  8003cc:	ff 30                	pushl  (%eax)
  8003ce:	ff d3                	call   *%ebx
			break;
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	e9 96 01 00 00       	jmp    80056e <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 50 04             	lea    0x4(%eax),%edx
  8003de:	89 55 14             	mov    %edx,0x14(%ebp)
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	99                   	cltd   
  8003e4:	31 d0                	xor    %edx,%eax
  8003e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 0f             	cmp    $0xf,%eax
  8003eb:	7f 20                	jg     80040d <vprintfmt+0x13d>
  8003ed:	8b 14 85 e0 20 80 00 	mov    0x8020e0(,%eax,4),%edx
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 15                	je     80040d <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8003f8:	52                   	push   %edx
  8003f9:	68 37 22 80 00       	push   $0x802237
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	e8 aa fe ff ff       	call   8002af <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	e9 61 01 00 00       	jmp    80056e <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80040d:	50                   	push   %eax
  80040e:	68 50 1e 80 00       	push   $0x801e50
  800413:	56                   	push   %esi
  800414:	53                   	push   %ebx
  800415:	e8 95 fe ff ff       	call   8002af <printfmt>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	e9 4c 01 00 00       	jmp    80056e <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8d 50 04             	lea    0x4(%eax),%edx
  800428:	89 55 14             	mov    %edx,0x14(%ebp)
  80042b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80042d:	85 c9                	test   %ecx,%ecx
  80042f:	b8 49 1e 80 00       	mov    $0x801e49,%eax
  800434:	0f 45 c1             	cmovne %ecx,%eax
  800437:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043e:	7e 06                	jle    800446 <vprintfmt+0x176>
  800440:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800444:	75 0d                	jne    800453 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800446:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800449:	89 c7                	mov    %eax,%edi
  80044b:	03 45 e0             	add    -0x20(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800451:	eb 57                	jmp    8004aa <vprintfmt+0x1da>
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	ff 75 d8             	pushl  -0x28(%ebp)
  800459:	ff 75 cc             	pushl  -0x34(%ebp)
  80045c:	e8 4f 02 00 00       	call   8006b0 <strnlen>
  800461:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800464:	29 c2                	sub    %eax,%edx
  800466:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800469:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80046c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800470:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800473:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800475:	85 db                	test   %ebx,%ebx
  800477:	7e 10                	jle    800489 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	56                   	push   %esi
  80047d:	57                   	push   %edi
  80047e:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	83 eb 01             	sub    $0x1,%ebx
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	eb ec                	jmp    800475 <vprintfmt+0x1a5>
  800489:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80048c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048f:	85 d2                	test   %edx,%edx
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	0f 49 c2             	cmovns %edx,%eax
  800499:	29 c2                	sub    %eax,%edx
  80049b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80049e:	eb a6                	jmp    800446 <vprintfmt+0x176>
					putch(ch, putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	56                   	push   %esi
  8004a4:	52                   	push   %edx
  8004a5:	ff d3                	call   *%ebx
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ad:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004af:	83 c7 01             	add    $0x1,%edi
  8004b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b6:	0f be d0             	movsbl %al,%edx
  8004b9:	85 d2                	test   %edx,%edx
  8004bb:	74 42                	je     8004ff <vprintfmt+0x22f>
  8004bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c1:	78 06                	js     8004c9 <vprintfmt+0x1f9>
  8004c3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c7:	78 1e                	js     8004e7 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004cd:	74 d1                	je     8004a0 <vprintfmt+0x1d0>
  8004cf:	0f be c0             	movsbl %al,%eax
  8004d2:	83 e8 20             	sub    $0x20,%eax
  8004d5:	83 f8 5e             	cmp    $0x5e,%eax
  8004d8:	76 c6                	jbe    8004a0 <vprintfmt+0x1d0>
					putch('?', putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	56                   	push   %esi
  8004de:	6a 3f                	push   $0x3f
  8004e0:	ff d3                	call   *%ebx
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	eb c3                	jmp    8004aa <vprintfmt+0x1da>
  8004e7:	89 cf                	mov    %ecx,%edi
  8004e9:	eb 0e                	jmp    8004f9 <vprintfmt+0x229>
				putch(' ', putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	56                   	push   %esi
  8004ef:	6a 20                	push   $0x20
  8004f1:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8004f3:	83 ef 01             	sub    $0x1,%edi
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	85 ff                	test   %edi,%edi
  8004fb:	7f ee                	jg     8004eb <vprintfmt+0x21b>
  8004fd:	eb 6f                	jmp    80056e <vprintfmt+0x29e>
  8004ff:	89 cf                	mov    %ecx,%edi
  800501:	eb f6                	jmp    8004f9 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800503:	89 ca                	mov    %ecx,%edx
  800505:	8d 45 14             	lea    0x14(%ebp),%eax
  800508:	e8 55 fd ff ff       	call   800262 <getint>
  80050d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800510:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800513:	85 d2                	test   %edx,%edx
  800515:	78 0b                	js     800522 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800517:	89 d1                	mov    %edx,%ecx
  800519:	89 c2                	mov    %eax,%edx
			base = 10;
  80051b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800520:	eb 32                	jmp    800554 <vprintfmt+0x284>
				putch('-', putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	56                   	push   %esi
  800526:	6a 2d                	push   $0x2d
  800528:	ff d3                	call   *%ebx
				num = -(long long) num;
  80052a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800530:	f7 da                	neg    %edx
  800532:	83 d1 00             	adc    $0x0,%ecx
  800535:	f7 d9                	neg    %ecx
  800537:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80053a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053f:	eb 13                	jmp    800554 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800541:	89 ca                	mov    %ecx,%edx
  800543:	8d 45 14             	lea    0x14(%ebp),%eax
  800546:	e8 e3 fc ff ff       	call   80022e <getuint>
  80054b:	89 d1                	mov    %edx,%ecx
  80054d:	89 c2                	mov    %eax,%edx
			base = 10;
  80054f:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80055b:	57                   	push   %edi
  80055c:	ff 75 e0             	pushl  -0x20(%ebp)
  80055f:	50                   	push   %eax
  800560:	51                   	push   %ecx
  800561:	52                   	push   %edx
  800562:	89 f2                	mov    %esi,%edx
  800564:	89 d8                	mov    %ebx,%eax
  800566:	e8 1a fc ff ff       	call   800185 <printnum>
			break;
  80056b:	83 c4 20             	add    $0x20,%esp
{
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800571:	83 c7 01             	add    $0x1,%edi
  800574:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800578:	83 f8 25             	cmp    $0x25,%eax
  80057b:	0f 84 6a fd ff ff    	je     8002eb <vprintfmt+0x1b>
			if (ch == '\0')
  800581:	85 c0                	test   %eax,%eax
  800583:	0f 84 93 00 00 00    	je     80061c <vprintfmt+0x34c>
			putch(ch, putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	56                   	push   %esi
  80058d:	50                   	push   %eax
  80058e:	ff d3                	call   *%ebx
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	eb dc                	jmp    800571 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800595:	89 ca                	mov    %ecx,%edx
  800597:	8d 45 14             	lea    0x14(%ebp),%eax
  80059a:	e8 8f fc ff ff       	call   80022e <getuint>
  80059f:	89 d1                	mov    %edx,%ecx
  8005a1:	89 c2                	mov    %eax,%edx
			base = 8;
  8005a3:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005a8:	eb aa                	jmp    800554 <vprintfmt+0x284>
			putch('0', putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	56                   	push   %esi
  8005ae:	6a 30                	push   $0x30
  8005b0:	ff d3                	call   *%ebx
			putch('x', putdat);
  8005b2:	83 c4 08             	add    $0x8,%esp
  8005b5:	56                   	push   %esi
  8005b6:	6a 78                	push   $0x78
  8005b8:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 50 04             	lea    0x4(%eax),%edx
  8005c0:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ca:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8005cd:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8005d2:	eb 80                	jmp    800554 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005d4:	89 ca                	mov    %ecx,%edx
  8005d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d9:	e8 50 fc ff ff       	call   80022e <getuint>
  8005de:	89 d1                	mov    %edx,%ecx
  8005e0:	89 c2                	mov    %eax,%edx
			base = 16;
  8005e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8005e7:	e9 68 ff ff ff       	jmp    800554 <vprintfmt+0x284>
			putch(ch, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	56                   	push   %esi
  8005f0:	6a 25                	push   $0x25
  8005f2:	ff d3                	call   *%ebx
			break;
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	e9 72 ff ff ff       	jmp    80056e <vprintfmt+0x29e>
			putch('%', putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	56                   	push   %esi
  800600:	6a 25                	push   $0x25
  800602:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	89 f8                	mov    %edi,%eax
  800609:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80060d:	74 05                	je     800614 <vprintfmt+0x344>
  80060f:	83 e8 01             	sub    $0x1,%eax
  800612:	eb f5                	jmp    800609 <vprintfmt+0x339>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800617:	e9 52 ff ff ff       	jmp    80056e <vprintfmt+0x29e>
}
  80061c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5f                   	pop    %edi
  800622:	5d                   	pop    %ebp
  800623:	c3                   	ret    

00800624 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800624:	f3 0f 1e fb          	endbr32 
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800634:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800637:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80063b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80063e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800645:	85 c0                	test   %eax,%eax
  800647:	74 26                	je     80066f <vsnprintf+0x4b>
  800649:	85 d2                	test   %edx,%edx
  80064b:	7e 22                	jle    80066f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80064d:	ff 75 14             	pushl  0x14(%ebp)
  800650:	ff 75 10             	pushl  0x10(%ebp)
  800653:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800656:	50                   	push   %eax
  800657:	68 8e 02 80 00       	push   $0x80028e
  80065c:	e8 6f fc ff ff       	call   8002d0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800664:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066a:	83 c4 10             	add    $0x10,%esp
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    
		return -E_INVAL;
  80066f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800674:	eb f7                	jmp    80066d <vsnprintf+0x49>

00800676 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800676:	f3 0f 1e fb          	endbr32 
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800680:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800683:	50                   	push   %eax
  800684:	ff 75 10             	pushl  0x10(%ebp)
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	ff 75 08             	pushl  0x8(%ebp)
  80068d:	e8 92 ff ff ff       	call   800624 <vsnprintf>
	va_end(ap);

	return rc;
}
  800692:	c9                   	leave  
  800693:	c3                   	ret    

00800694 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800694:	f3 0f 1e fb          	endbr32 
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80069e:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006a7:	74 05                	je     8006ae <strlen+0x1a>
		n++;
  8006a9:	83 c0 01             	add    $0x1,%eax
  8006ac:	eb f5                	jmp    8006a3 <strlen+0xf>
	return n;
}
  8006ae:	5d                   	pop    %ebp
  8006af:	c3                   	ret    

008006b0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006b0:	f3 0f 1e fb          	endbr32 
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	39 d0                	cmp    %edx,%eax
  8006c4:	74 0d                	je     8006d3 <strnlen+0x23>
  8006c6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8006ca:	74 05                	je     8006d1 <strnlen+0x21>
		n++;
  8006cc:	83 c0 01             	add    $0x1,%eax
  8006cf:	eb f1                	jmp    8006c2 <strnlen+0x12>
  8006d1:	89 c2                	mov    %eax,%edx
	return n;
}
  8006d3:	89 d0                	mov    %edx,%eax
  8006d5:	5d                   	pop    %ebp
  8006d6:	c3                   	ret    

008006d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006d7:	f3 0f 1e fb          	endbr32 
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	53                   	push   %ebx
  8006df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8006ee:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8006f1:	83 c0 01             	add    $0x1,%eax
  8006f4:	84 d2                	test   %dl,%dl
  8006f6:	75 f2                	jne    8006ea <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8006f8:	89 c8                	mov    %ecx,%eax
  8006fa:	5b                   	pop    %ebx
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8006fd:	f3 0f 1e fb          	endbr32 
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	53                   	push   %ebx
  800705:	83 ec 10             	sub    $0x10,%esp
  800708:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80070b:	53                   	push   %ebx
  80070c:	e8 83 ff ff ff       	call   800694 <strlen>
  800711:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	01 d8                	add    %ebx,%eax
  800719:	50                   	push   %eax
  80071a:	e8 b8 ff ff ff       	call   8006d7 <strcpy>
	return dst;
}
  80071f:	89 d8                	mov    %ebx,%eax
  800721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800726:	f3 0f 1e fb          	endbr32 
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	56                   	push   %esi
  80072e:	53                   	push   %ebx
  80072f:	8b 75 08             	mov    0x8(%ebp),%esi
  800732:	8b 55 0c             	mov    0xc(%ebp),%edx
  800735:	89 f3                	mov    %esi,%ebx
  800737:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80073a:	89 f0                	mov    %esi,%eax
  80073c:	39 d8                	cmp    %ebx,%eax
  80073e:	74 11                	je     800751 <strncpy+0x2b>
		*dst++ = *src;
  800740:	83 c0 01             	add    $0x1,%eax
  800743:	0f b6 0a             	movzbl (%edx),%ecx
  800746:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800749:	80 f9 01             	cmp    $0x1,%cl
  80074c:	83 da ff             	sbb    $0xffffffff,%edx
  80074f:	eb eb                	jmp    80073c <strncpy+0x16>
	}
	return ret;
}
  800751:	89 f0                	mov    %esi,%eax
  800753:	5b                   	pop    %ebx
  800754:	5e                   	pop    %esi
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800757:	f3 0f 1e fb          	endbr32 
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	56                   	push   %esi
  80075f:	53                   	push   %ebx
  800760:	8b 75 08             	mov    0x8(%ebp),%esi
  800763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800766:	8b 55 10             	mov    0x10(%ebp),%edx
  800769:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80076b:	85 d2                	test   %edx,%edx
  80076d:	74 21                	je     800790 <strlcpy+0x39>
  80076f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800773:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800775:	39 c2                	cmp    %eax,%edx
  800777:	74 14                	je     80078d <strlcpy+0x36>
  800779:	0f b6 19             	movzbl (%ecx),%ebx
  80077c:	84 db                	test   %bl,%bl
  80077e:	74 0b                	je     80078b <strlcpy+0x34>
			*dst++ = *src++;
  800780:	83 c1 01             	add    $0x1,%ecx
  800783:	83 c2 01             	add    $0x1,%edx
  800786:	88 5a ff             	mov    %bl,-0x1(%edx)
  800789:	eb ea                	jmp    800775 <strlcpy+0x1e>
  80078b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80078d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800790:	29 f0                	sub    %esi,%eax
}
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800796:	f3 0f 1e fb          	endbr32 
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007a3:	0f b6 01             	movzbl (%ecx),%eax
  8007a6:	84 c0                	test   %al,%al
  8007a8:	74 0c                	je     8007b6 <strcmp+0x20>
  8007aa:	3a 02                	cmp    (%edx),%al
  8007ac:	75 08                	jne    8007b6 <strcmp+0x20>
		p++, q++;
  8007ae:	83 c1 01             	add    $0x1,%ecx
  8007b1:	83 c2 01             	add    $0x1,%edx
  8007b4:	eb ed                	jmp    8007a3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007b6:	0f b6 c0             	movzbl %al,%eax
  8007b9:	0f b6 12             	movzbl (%edx),%edx
  8007bc:	29 d0                	sub    %edx,%eax
}
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007c0:	f3 0f 1e fb          	endbr32 
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ce:	89 c3                	mov    %eax,%ebx
  8007d0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007d3:	eb 06                	jmp    8007db <strncmp+0x1b>
		n--, p++, q++;
  8007d5:	83 c0 01             	add    $0x1,%eax
  8007d8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8007db:	39 d8                	cmp    %ebx,%eax
  8007dd:	74 16                	je     8007f5 <strncmp+0x35>
  8007df:	0f b6 08             	movzbl (%eax),%ecx
  8007e2:	84 c9                	test   %cl,%cl
  8007e4:	74 04                	je     8007ea <strncmp+0x2a>
  8007e6:	3a 0a                	cmp    (%edx),%cl
  8007e8:	74 eb                	je     8007d5 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ea:	0f b6 00             	movzbl (%eax),%eax
  8007ed:	0f b6 12             	movzbl (%edx),%edx
  8007f0:	29 d0                	sub    %edx,%eax
}
  8007f2:	5b                   	pop    %ebx
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    
		return 0;
  8007f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fa:	eb f6                	jmp    8007f2 <strncmp+0x32>

008007fc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80080a:	0f b6 10             	movzbl (%eax),%edx
  80080d:	84 d2                	test   %dl,%dl
  80080f:	74 09                	je     80081a <strchr+0x1e>
		if (*s == c)
  800811:	38 ca                	cmp    %cl,%dl
  800813:	74 0a                	je     80081f <strchr+0x23>
	for (; *s; s++)
  800815:	83 c0 01             	add    $0x1,%eax
  800818:	eb f0                	jmp    80080a <strchr+0xe>
			return (char *) s;
	return 0;
  80081a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800821:	f3 0f 1e fb          	endbr32 
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80082f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800832:	38 ca                	cmp    %cl,%dl
  800834:	74 09                	je     80083f <strfind+0x1e>
  800836:	84 d2                	test   %dl,%dl
  800838:	74 05                	je     80083f <strfind+0x1e>
	for (; *s; s++)
  80083a:	83 c0 01             	add    $0x1,%eax
  80083d:	eb f0                	jmp    80082f <strfind+0xe>
			break;
	return (char *) s;
}
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    

00800841 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800841:	f3 0f 1e fb          	endbr32 
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	57                   	push   %edi
  800849:	56                   	push   %esi
  80084a:	53                   	push   %ebx
  80084b:	8b 55 08             	mov    0x8(%ebp),%edx
  80084e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800851:	85 c9                	test   %ecx,%ecx
  800853:	74 33                	je     800888 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800855:	89 d0                	mov    %edx,%eax
  800857:	09 c8                	or     %ecx,%eax
  800859:	a8 03                	test   $0x3,%al
  80085b:	75 23                	jne    800880 <memset+0x3f>
		c &= 0xFF;
  80085d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800861:	89 d8                	mov    %ebx,%eax
  800863:	c1 e0 08             	shl    $0x8,%eax
  800866:	89 df                	mov    %ebx,%edi
  800868:	c1 e7 18             	shl    $0x18,%edi
  80086b:	89 de                	mov    %ebx,%esi
  80086d:	c1 e6 10             	shl    $0x10,%esi
  800870:	09 f7                	or     %esi,%edi
  800872:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800874:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800877:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800879:	89 d7                	mov    %edx,%edi
  80087b:	fc                   	cld    
  80087c:	f3 ab                	rep stos %eax,%es:(%edi)
  80087e:	eb 08                	jmp    800888 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800880:	89 d7                	mov    %edx,%edi
  800882:	8b 45 0c             	mov    0xc(%ebp),%eax
  800885:	fc                   	cld    
  800886:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800888:	89 d0                	mov    %edx,%eax
  80088a:	5b                   	pop    %ebx
  80088b:	5e                   	pop    %esi
  80088c:	5f                   	pop    %edi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	57                   	push   %edi
  800897:	56                   	push   %esi
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80089e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008a1:	39 c6                	cmp    %eax,%esi
  8008a3:	73 32                	jae    8008d7 <memmove+0x48>
  8008a5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	76 2b                	jbe    8008d7 <memmove+0x48>
		s += n;
		d += n;
  8008ac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008af:	89 fe                	mov    %edi,%esi
  8008b1:	09 ce                	or     %ecx,%esi
  8008b3:	09 d6                	or     %edx,%esi
  8008b5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008bb:	75 0e                	jne    8008cb <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008bd:	83 ef 04             	sub    $0x4,%edi
  8008c0:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008c3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008c6:	fd                   	std    
  8008c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008c9:	eb 09                	jmp    8008d4 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008cb:	83 ef 01             	sub    $0x1,%edi
  8008ce:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008d1:	fd                   	std    
  8008d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008d4:	fc                   	cld    
  8008d5:	eb 1a                	jmp    8008f1 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d7:	89 c2                	mov    %eax,%edx
  8008d9:	09 ca                	or     %ecx,%edx
  8008db:	09 f2                	or     %esi,%edx
  8008dd:	f6 c2 03             	test   $0x3,%dl
  8008e0:	75 0a                	jne    8008ec <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8008e2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8008e5:	89 c7                	mov    %eax,%edi
  8008e7:	fc                   	cld    
  8008e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008ea:	eb 05                	jmp    8008f1 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8008ec:	89 c7                	mov    %eax,%edi
  8008ee:	fc                   	cld    
  8008ef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008f1:	5e                   	pop    %esi
  8008f2:	5f                   	pop    %edi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8008ff:	ff 75 10             	pushl  0x10(%ebp)
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 82 ff ff ff       	call   80088f <memmove>
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80090f:	f3 0f 1e fb          	endbr32 
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	56                   	push   %esi
  800917:	53                   	push   %ebx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091e:	89 c6                	mov    %eax,%esi
  800920:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800923:	39 f0                	cmp    %esi,%eax
  800925:	74 1c                	je     800943 <memcmp+0x34>
		if (*s1 != *s2)
  800927:	0f b6 08             	movzbl (%eax),%ecx
  80092a:	0f b6 1a             	movzbl (%edx),%ebx
  80092d:	38 d9                	cmp    %bl,%cl
  80092f:	75 08                	jne    800939 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800931:	83 c0 01             	add    $0x1,%eax
  800934:	83 c2 01             	add    $0x1,%edx
  800937:	eb ea                	jmp    800923 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800939:	0f b6 c1             	movzbl %cl,%eax
  80093c:	0f b6 db             	movzbl %bl,%ebx
  80093f:	29 d8                	sub    %ebx,%eax
  800941:	eb 05                	jmp    800948 <memcmp+0x39>
	}

	return 0;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80094c:	f3 0f 1e fb          	endbr32 
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800959:	89 c2                	mov    %eax,%edx
  80095b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80095e:	39 d0                	cmp    %edx,%eax
  800960:	73 09                	jae    80096b <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800962:	38 08                	cmp    %cl,(%eax)
  800964:	74 05                	je     80096b <memfind+0x1f>
	for (; s < ends; s++)
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	eb f3                	jmp    80095e <memfind+0x12>
			break;
	return (void *) s;
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80096d:	f3 0f 1e fb          	endbr32 
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	57                   	push   %edi
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80097d:	eb 03                	jmp    800982 <strtol+0x15>
		s++;
  80097f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800982:	0f b6 01             	movzbl (%ecx),%eax
  800985:	3c 20                	cmp    $0x20,%al
  800987:	74 f6                	je     80097f <strtol+0x12>
  800989:	3c 09                	cmp    $0x9,%al
  80098b:	74 f2                	je     80097f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80098d:	3c 2b                	cmp    $0x2b,%al
  80098f:	74 2a                	je     8009bb <strtol+0x4e>
	int neg = 0;
  800991:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800996:	3c 2d                	cmp    $0x2d,%al
  800998:	74 2b                	je     8009c5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80099a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009a0:	75 0f                	jne    8009b1 <strtol+0x44>
  8009a2:	80 39 30             	cmpb   $0x30,(%ecx)
  8009a5:	74 28                	je     8009cf <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009a7:	85 db                	test   %ebx,%ebx
  8009a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ae:	0f 44 d8             	cmove  %eax,%ebx
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009b9:	eb 46                	jmp    800a01 <strtol+0x94>
		s++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009be:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c3:	eb d5                	jmp    80099a <strtol+0x2d>
		s++, neg = 1;
  8009c5:	83 c1 01             	add    $0x1,%ecx
  8009c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8009cd:	eb cb                	jmp    80099a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009cf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009d3:	74 0e                	je     8009e3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8009d5:	85 db                	test   %ebx,%ebx
  8009d7:	75 d8                	jne    8009b1 <strtol+0x44>
		s++, base = 8;
  8009d9:	83 c1 01             	add    $0x1,%ecx
  8009dc:	bb 08 00 00 00       	mov    $0x8,%ebx
  8009e1:	eb ce                	jmp    8009b1 <strtol+0x44>
		s += 2, base = 16;
  8009e3:	83 c1 02             	add    $0x2,%ecx
  8009e6:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009eb:	eb c4                	jmp    8009b1 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8009ed:	0f be d2             	movsbl %dl,%edx
  8009f0:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8009f3:	3b 55 10             	cmp    0x10(%ebp),%edx
  8009f6:	7d 3a                	jge    800a32 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8009ff:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a01:	0f b6 11             	movzbl (%ecx),%edx
  800a04:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a07:	89 f3                	mov    %esi,%ebx
  800a09:	80 fb 09             	cmp    $0x9,%bl
  800a0c:	76 df                	jbe    8009ed <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a0e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a11:	89 f3                	mov    %esi,%ebx
  800a13:	80 fb 19             	cmp    $0x19,%bl
  800a16:	77 08                	ja     800a20 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a18:	0f be d2             	movsbl %dl,%edx
  800a1b:	83 ea 57             	sub    $0x57,%edx
  800a1e:	eb d3                	jmp    8009f3 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a20:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a23:	89 f3                	mov    %esi,%ebx
  800a25:	80 fb 19             	cmp    $0x19,%bl
  800a28:	77 08                	ja     800a32 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a2a:	0f be d2             	movsbl %dl,%edx
  800a2d:	83 ea 37             	sub    $0x37,%edx
  800a30:	eb c1                	jmp    8009f3 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a36:	74 05                	je     800a3d <strtol+0xd0>
		*endptr = (char *) s;
  800a38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	f7 da                	neg    %edx
  800a41:	85 ff                	test   %edi,%edi
  800a43:	0f 45 c2             	cmovne %edx,%eax
}
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5f                   	pop    %edi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	53                   	push   %ebx
  800a51:	83 ec 1c             	sub    $0x1c,%esp
  800a54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a57:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a5a:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a62:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a65:	8b 75 14             	mov    0x14(%ebp),%esi
  800a68:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	74 04                	je     800a74 <syscall+0x29>
  800a70:	85 c0                	test   %eax,%eax
  800a72:	7f 08                	jg     800a7c <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a77:	5b                   	pop    %ebx
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800a7c:	83 ec 0c             	sub    $0xc,%esp
  800a7f:	50                   	push   %eax
  800a80:	ff 75 e0             	pushl  -0x20(%ebp)
  800a83:	68 3f 21 80 00       	push   $0x80213f
  800a88:	6a 23                	push   $0x23
  800a8a:	68 5c 21 80 00       	push   $0x80215c
  800a8f:	e8 90 0f 00 00       	call   801a24 <_panic>

00800a94 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a94:	f3 0f 1e fb          	endbr32 
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a9e:	6a 00                	push   $0x0
  800aa0:	6a 00                	push   $0x0
  800aa2:	6a 00                	push   $0x0
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	e8 92 ff ff ff       	call   800a4b <syscall>
}
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <sys_cgetc>:

int
sys_cgetc(void)
{
  800abe:	f3 0f 1e fb          	endbr32 
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ac8:	6a 00                	push   $0x0
  800aca:	6a 00                	push   $0x0
  800acc:	6a 00                	push   $0x0
  800ace:	6a 00                	push   $0x0
  800ad0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	b8 01 00 00 00       	mov    $0x1,%eax
  800adf:	e8 67 ff ff ff       	call   800a4b <syscall>
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae6:	f3 0f 1e fb          	endbr32 
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800af0:	6a 00                	push   $0x0
  800af2:	6a 00                	push   $0x0
  800af4:	6a 00                	push   $0x0
  800af6:	6a 00                	push   $0x0
  800af8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afb:	ba 01 00 00 00       	mov    $0x1,%edx
  800b00:	b8 03 00 00 00       	mov    $0x3,%eax
  800b05:	e8 41 ff ff ff       	call   800a4b <syscall>
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b0c:	f3 0f 1e fb          	endbr32 
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b16:	6a 00                	push   $0x0
  800b18:	6a 00                	push   $0x0
  800b1a:	6a 00                	push   $0x0
  800b1c:	6a 00                	push   $0x0
  800b1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b23:	ba 00 00 00 00       	mov    $0x0,%edx
  800b28:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2d:	e8 19 ff ff ff       	call   800a4b <syscall>
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sys_yield>:

void
sys_yield(void)
{
  800b34:	f3 0f 1e fb          	endbr32 
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b3e:	6a 00                	push   $0x0
  800b40:	6a 00                	push   $0x0
  800b42:	6a 00                	push   $0x0
  800b44:	6a 00                	push   $0x0
  800b46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b55:	e8 f1 fe ff ff       	call   800a4b <syscall>
}
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b5f:	f3 0f 1e fb          	endbr32 
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b69:	6a 00                	push   $0x0
  800b6b:	6a 00                	push   $0x0
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b76:	ba 01 00 00 00       	mov    $0x1,%edx
  800b7b:	b8 04 00 00 00       	mov    $0x4,%eax
  800b80:	e8 c6 fe ff ff       	call   800a4b <syscall>
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b87:	f3 0f 1e fb          	endbr32 
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b91:	ff 75 18             	pushl  0x18(%ebp)
  800b94:	ff 75 14             	pushl  0x14(%ebp)
  800b97:	ff 75 10             	pushl  0x10(%ebp)
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ba5:	b8 05 00 00 00       	mov    $0x5,%eax
  800baa:	e8 9c fe ff ff       	call   800a4b <syscall>
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bb1:	f3 0f 1e fb          	endbr32 
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bbb:	6a 00                	push   $0x0
  800bbd:	6a 00                	push   $0x0
  800bbf:	6a 00                	push   $0x0
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc7:	ba 01 00 00 00       	mov    $0x1,%edx
  800bcc:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd1:	e8 75 fe ff ff       	call   800a4b <syscall>
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800be2:	6a 00                	push   $0x0
  800be4:	6a 00                	push   $0x0
  800be6:	6a 00                	push   $0x0
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bee:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf3:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf8:	e8 4e fe ff ff       	call   800a4b <syscall>
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800bff:	f3 0f 1e fb          	endbr32 
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c09:	6a 00                	push   $0x0
  800c0b:	6a 00                	push   $0x0
  800c0d:	6a 00                	push   $0x0
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c15:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c1f:	e8 27 fe ff ff       	call   800a4b <syscall>
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c26:	f3 0f 1e fb          	endbr32 
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c30:	6a 00                	push   $0x0
  800c32:	6a 00                	push   $0x0
  800c34:	6a 00                	push   $0x0
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c46:	e8 00 fe ff ff       	call   800a4b <syscall>
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c4d:	f3 0f 1e fb          	endbr32 
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c57:	6a 00                	push   $0x0
  800c59:	ff 75 14             	pushl  0x14(%ebp)
  800c5c:	ff 75 10             	pushl  0x10(%ebp)
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c65:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c6f:	e8 d7 fd ff ff       	call   800a4b <syscall>
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c80:	6a 00                	push   $0x0
  800c82:	6a 00                	push   $0x0
  800c84:	6a 00                	push   $0x0
  800c86:	6a 00                	push   $0x0
  800c88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c90:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c95:	e8 b1 fd ff ff       	call   800a4b <syscall>
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c9c:	f3 0f 1e fb          	endbr32 
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	05 00 00 00 30       	add    $0x30000000,%eax
  800cab:	c1 e8 0c             	shr    $0xc,%eax
}
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800cba:	ff 75 08             	pushl  0x8(%ebp)
  800cbd:	e8 da ff ff ff       	call   800c9c <fd2num>
  800cc2:	83 c4 10             	add    $0x10,%esp
  800cc5:	c1 e0 0c             	shl    $0xc,%eax
  800cc8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800cdb:	89 c2                	mov    %eax,%edx
  800cdd:	c1 ea 16             	shr    $0x16,%edx
  800ce0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ce7:	f6 c2 01             	test   $0x1,%dl
  800cea:	74 2d                	je     800d19 <fd_alloc+0x4a>
  800cec:	89 c2                	mov    %eax,%edx
  800cee:	c1 ea 0c             	shr    $0xc,%edx
  800cf1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cf8:	f6 c2 01             	test   $0x1,%dl
  800cfb:	74 1c                	je     800d19 <fd_alloc+0x4a>
  800cfd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d02:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d07:	75 d2                	jne    800cdb <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d12:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d17:	eb 0a                	jmp    800d23 <fd_alloc+0x54>
			*fd_store = fd;
  800d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d25:	f3 0f 1e fb          	endbr32 
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d2f:	83 f8 1f             	cmp    $0x1f,%eax
  800d32:	77 30                	ja     800d64 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d34:	c1 e0 0c             	shl    $0xc,%eax
  800d37:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d3c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800d42:	f6 c2 01             	test   $0x1,%dl
  800d45:	74 24                	je     800d6b <fd_lookup+0x46>
  800d47:	89 c2                	mov    %eax,%edx
  800d49:	c1 ea 0c             	shr    $0xc,%edx
  800d4c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d53:	f6 c2 01             	test   $0x1,%dl
  800d56:	74 1a                	je     800d72 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5b:	89 02                	mov    %eax,(%edx)
	return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    
		return -E_INVAL;
  800d64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d69:	eb f7                	jmp    800d62 <fd_lookup+0x3d>
		return -E_INVAL;
  800d6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d70:	eb f0                	jmp    800d62 <fd_lookup+0x3d>
  800d72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d77:	eb e9                	jmp    800d62 <fd_lookup+0x3d>

00800d79 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 08             	sub    $0x8,%esp
  800d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d86:	ba e8 21 80 00       	mov    $0x8021e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d8b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800d90:	39 08                	cmp    %ecx,(%eax)
  800d92:	74 33                	je     800dc7 <dev_lookup+0x4e>
  800d94:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800d97:	8b 02                	mov    (%edx),%eax
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	75 f3                	jne    800d90 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d9d:	a1 08 40 80 00       	mov    0x804008,%eax
  800da2:	8b 40 48             	mov    0x48(%eax),%eax
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	51                   	push   %ecx
  800da9:	50                   	push   %eax
  800daa:	68 6c 21 80 00       	push   $0x80216c
  800daf:	e8 b9 f3 ff ff       	call   80016d <cprintf>
	*dev = 0;
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    
			*dev = devtab[i];
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd1:	eb f2                	jmp    800dc5 <dev_lookup+0x4c>

00800dd3 <fd_close>:
{
  800dd3:	f3 0f 1e fb          	endbr32 
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 28             	sub    $0x28,%esp
  800de0:	8b 75 08             	mov    0x8(%ebp),%esi
  800de3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800de6:	56                   	push   %esi
  800de7:	e8 b0 fe ff ff       	call   800c9c <fd2num>
  800dec:	83 c4 08             	add    $0x8,%esp
  800def:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800df2:	52                   	push   %edx
  800df3:	50                   	push   %eax
  800df4:	e8 2c ff ff ff       	call   800d25 <fd_lookup>
  800df9:	89 c3                	mov    %eax,%ebx
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	78 05                	js     800e07 <fd_close+0x34>
	    || fd != fd2)
  800e02:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e05:	74 16                	je     800e1d <fd_close+0x4a>
		return (must_exist ? r : 0);
  800e07:	89 f8                	mov    %edi,%eax
  800e09:	84 c0                	test   %al,%al
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e10:	0f 44 d8             	cmove  %eax,%ebx
}
  800e13:	89 d8                	mov    %ebx,%eax
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e23:	50                   	push   %eax
  800e24:	ff 36                	pushl  (%esi)
  800e26:	e8 4e ff ff ff       	call   800d79 <dev_lookup>
  800e2b:	89 c3                	mov    %eax,%ebx
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 1a                	js     800e4e <fd_close+0x7b>
		if (dev->dev_close)
  800e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e37:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	74 0b                	je     800e4e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800e43:	83 ec 0c             	sub    $0xc,%esp
  800e46:	56                   	push   %esi
  800e47:	ff d0                	call   *%eax
  800e49:	89 c3                	mov    %eax,%ebx
  800e4b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	56                   	push   %esi
  800e52:	6a 00                	push   $0x0
  800e54:	e8 58 fd ff ff       	call   800bb1 <sys_page_unmap>
	return r;
  800e59:	83 c4 10             	add    $0x10,%esp
  800e5c:	eb b5                	jmp    800e13 <fd_close+0x40>

00800e5e <close>:

int
close(int fdnum)
{
  800e5e:	f3 0f 1e fb          	endbr32 
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e6b:	50                   	push   %eax
  800e6c:	ff 75 08             	pushl  0x8(%ebp)
  800e6f:	e8 b1 fe ff ff       	call   800d25 <fd_lookup>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	79 02                	jns    800e7d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    
		return fd_close(fd, 1);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	6a 01                	push   $0x1
  800e82:	ff 75 f4             	pushl  -0xc(%ebp)
  800e85:	e8 49 ff ff ff       	call   800dd3 <fd_close>
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	eb ec                	jmp    800e7b <close+0x1d>

00800e8f <close_all>:

void
close_all(void)
{
  800e8f:	f3 0f 1e fb          	endbr32 
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	53                   	push   %ebx
  800e97:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	53                   	push   %ebx
  800ea3:	e8 b6 ff ff ff       	call   800e5e <close>
	for (i = 0; i < MAXFD; i++)
  800ea8:	83 c3 01             	add    $0x1,%ebx
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	83 fb 20             	cmp    $0x20,%ebx
  800eb1:	75 ec                	jne    800e9f <close_all+0x10>
}
  800eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800eb8:	f3 0f 1e fb          	endbr32 
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ec5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ec8:	50                   	push   %eax
  800ec9:	ff 75 08             	pushl  0x8(%ebp)
  800ecc:	e8 54 fe ff ff       	call   800d25 <fd_lookup>
  800ed1:	89 c3                	mov    %eax,%ebx
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	0f 88 81 00 00 00    	js     800f5f <dup+0xa7>
		return r;
	close(newfdnum);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	e8 75 ff ff ff       	call   800e5e <close>

	newfd = INDEX2FD(newfdnum);
  800ee9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eec:	c1 e6 0c             	shl    $0xc,%esi
  800eef:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800ef5:	83 c4 04             	add    $0x4,%esp
  800ef8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800efb:	e8 b0 fd ff ff       	call   800cb0 <fd2data>
  800f00:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f02:	89 34 24             	mov    %esi,(%esp)
  800f05:	e8 a6 fd ff ff       	call   800cb0 <fd2data>
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f0f:	89 d8                	mov    %ebx,%eax
  800f11:	c1 e8 16             	shr    $0x16,%eax
  800f14:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f1b:	a8 01                	test   $0x1,%al
  800f1d:	74 11                	je     800f30 <dup+0x78>
  800f1f:	89 d8                	mov    %ebx,%eax
  800f21:	c1 e8 0c             	shr    $0xc,%eax
  800f24:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f2b:	f6 c2 01             	test   $0x1,%dl
  800f2e:	75 39                	jne    800f69 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f33:	89 d0                	mov    %edx,%eax
  800f35:	c1 e8 0c             	shr    $0xc,%eax
  800f38:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	25 07 0e 00 00       	and    $0xe07,%eax
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	6a 00                	push   $0x0
  800f4b:	52                   	push   %edx
  800f4c:	6a 00                	push   $0x0
  800f4e:	e8 34 fc ff ff       	call   800b87 <sys_page_map>
  800f53:	89 c3                	mov    %eax,%ebx
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 31                	js     800f8d <dup+0xd5>
		goto err;

	return newfdnum;
  800f5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800f5f:	89 d8                	mov    %ebx,%eax
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800f69:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	25 07 0e 00 00       	and    $0xe07,%eax
  800f78:	50                   	push   %eax
  800f79:	57                   	push   %edi
  800f7a:	6a 00                	push   $0x0
  800f7c:	53                   	push   %ebx
  800f7d:	6a 00                	push   $0x0
  800f7f:	e8 03 fc ff ff       	call   800b87 <sys_page_map>
  800f84:	89 c3                	mov    %eax,%ebx
  800f86:	83 c4 20             	add    $0x20,%esp
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	79 a3                	jns    800f30 <dup+0x78>
	sys_page_unmap(0, newfd);
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	56                   	push   %esi
  800f91:	6a 00                	push   $0x0
  800f93:	e8 19 fc ff ff       	call   800bb1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800f98:	83 c4 08             	add    $0x8,%esp
  800f9b:	57                   	push   %edi
  800f9c:	6a 00                	push   $0x0
  800f9e:	e8 0e fc ff ff       	call   800bb1 <sys_page_unmap>
	return r;
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	eb b7                	jmp    800f5f <dup+0xa7>

00800fa8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800fa8:	f3 0f 1e fb          	endbr32 
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	53                   	push   %ebx
  800fb0:	83 ec 1c             	sub    $0x1c,%esp
  800fb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fb9:	50                   	push   %eax
  800fba:	53                   	push   %ebx
  800fbb:	e8 65 fd ff ff       	call   800d25 <fd_lookup>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	78 3f                	js     801006 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fcd:	50                   	push   %eax
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	ff 30                	pushl  (%eax)
  800fd3:	e8 a1 fd ff ff       	call   800d79 <dev_lookup>
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	78 27                	js     801006 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800fdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fe2:	8b 42 08             	mov    0x8(%edx),%eax
  800fe5:	83 e0 03             	and    $0x3,%eax
  800fe8:	83 f8 01             	cmp    $0x1,%eax
  800feb:	74 1e                	je     80100b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff0:	8b 40 08             	mov    0x8(%eax),%eax
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	74 35                	je     80102c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	ff 75 10             	pushl  0x10(%ebp)
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	52                   	push   %edx
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801009:	c9                   	leave  
  80100a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80100b:	a1 08 40 80 00       	mov    0x804008,%eax
  801010:	8b 40 48             	mov    0x48(%eax),%eax
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	53                   	push   %ebx
  801017:	50                   	push   %eax
  801018:	68 ad 21 80 00       	push   $0x8021ad
  80101d:	e8 4b f1 ff ff       	call   80016d <cprintf>
		return -E_INVAL;
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102a:	eb da                	jmp    801006 <read+0x5e>
		return -E_NOT_SUPP;
  80102c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801031:	eb d3                	jmp    801006 <read+0x5e>

00801033 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801033:	f3 0f 1e fb          	endbr32 
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	53                   	push   %ebx
  80103d:	83 ec 0c             	sub    $0xc,%esp
  801040:	8b 7d 08             	mov    0x8(%ebp),%edi
  801043:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	eb 02                	jmp    80104f <readn+0x1c>
  80104d:	01 c3                	add    %eax,%ebx
  80104f:	39 f3                	cmp    %esi,%ebx
  801051:	73 21                	jae    801074 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	89 f0                	mov    %esi,%eax
  801058:	29 d8                	sub    %ebx,%eax
  80105a:	50                   	push   %eax
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	03 45 0c             	add    0xc(%ebp),%eax
  801060:	50                   	push   %eax
  801061:	57                   	push   %edi
  801062:	e8 41 ff ff ff       	call   800fa8 <read>
		if (m < 0)
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	78 04                	js     801072 <readn+0x3f>
			return m;
		if (m == 0)
  80106e:	75 dd                	jne    80104d <readn+0x1a>
  801070:	eb 02                	jmp    801074 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801072:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801074:	89 d8                	mov    %ebx,%eax
  801076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80107e:	f3 0f 1e fb          	endbr32 
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	53                   	push   %ebx
  801086:	83 ec 1c             	sub    $0x1c,%esp
  801089:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80108c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	53                   	push   %ebx
  801091:	e8 8f fc ff ff       	call   800d25 <fd_lookup>
  801096:	83 c4 10             	add    $0x10,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	78 3a                	js     8010d7 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a7:	ff 30                	pushl  (%eax)
  8010a9:	e8 cb fc ff ff       	call   800d79 <dev_lookup>
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 22                	js     8010d7 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010bc:	74 1e                	je     8010dc <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8010be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	74 35                	je     8010fd <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	ff 75 10             	pushl  0x10(%ebp)
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	50                   	push   %eax
  8010d2:	ff d2                	call   *%edx
  8010d4:	83 c4 10             	add    $0x10,%esp
}
  8010d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8010dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8010e1:	8b 40 48             	mov    0x48(%eax),%eax
  8010e4:	83 ec 04             	sub    $0x4,%esp
  8010e7:	53                   	push   %ebx
  8010e8:	50                   	push   %eax
  8010e9:	68 c9 21 80 00       	push   $0x8021c9
  8010ee:	e8 7a f0 ff ff       	call   80016d <cprintf>
		return -E_INVAL;
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fb:	eb da                	jmp    8010d7 <write+0x59>
		return -E_NOT_SUPP;
  8010fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801102:	eb d3                	jmp    8010d7 <write+0x59>

00801104 <seek>:

int
seek(int fdnum, off_t offset)
{
  801104:	f3 0f 1e fb          	endbr32 
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801111:	50                   	push   %eax
  801112:	ff 75 08             	pushl  0x8(%ebp)
  801115:	e8 0b fc ff ff       	call   800d25 <fd_lookup>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	78 0e                	js     80112f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801121:	8b 55 0c             	mov    0xc(%ebp),%edx
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80112a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801131:	f3 0f 1e fb          	endbr32 
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	53                   	push   %ebx
  801139:	83 ec 1c             	sub    $0x1c,%esp
  80113c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80113f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801142:	50                   	push   %eax
  801143:	53                   	push   %ebx
  801144:	e8 dc fb ff ff       	call   800d25 <fd_lookup>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 37                	js     801187 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115a:	ff 30                	pushl  (%eax)
  80115c:	e8 18 fc ff ff       	call   800d79 <dev_lookup>
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	78 1f                	js     801187 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80116f:	74 1b                	je     80118c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	8b 52 18             	mov    0x18(%edx),%edx
  801177:	85 d2                	test   %edx,%edx
  801179:	74 32                	je     8011ad <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	50                   	push   %eax
  801182:	ff d2                	call   *%edx
  801184:	83 c4 10             	add    $0x10,%esp
}
  801187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80118c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801191:	8b 40 48             	mov    0x48(%eax),%eax
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	53                   	push   %ebx
  801198:	50                   	push   %eax
  801199:	68 8c 21 80 00       	push   $0x80218c
  80119e:	e8 ca ef ff ff       	call   80016d <cprintf>
		return -E_INVAL;
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ab:	eb da                	jmp    801187 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8011ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b2:	eb d3                	jmp    801187 <ftruncate+0x56>

008011b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011b4:	f3 0f 1e fb          	endbr32 
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	53                   	push   %ebx
  8011bc:	83 ec 1c             	sub    $0x1c,%esp
  8011bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c5:	50                   	push   %eax
  8011c6:	ff 75 08             	pushl  0x8(%ebp)
  8011c9:	e8 57 fb ff ff       	call   800d25 <fd_lookup>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	78 4b                	js     801220 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011df:	ff 30                	pushl  (%eax)
  8011e1:	e8 93 fb ff ff       	call   800d79 <dev_lookup>
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 33                	js     801220 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8011ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8011f4:	74 2f                	je     801225 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8011f6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8011f9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801200:	00 00 00 
	stat->st_isdir = 0;
  801203:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80120a:	00 00 00 
	stat->st_dev = dev;
  80120d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	53                   	push   %ebx
  801217:	ff 75 f0             	pushl  -0x10(%ebp)
  80121a:	ff 50 14             	call   *0x14(%eax)
  80121d:	83 c4 10             	add    $0x10,%esp
}
  801220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801223:	c9                   	leave  
  801224:	c3                   	ret    
		return -E_NOT_SUPP;
  801225:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80122a:	eb f4                	jmp    801220 <fstat+0x6c>

0080122c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80122c:	f3 0f 1e fb          	endbr32 
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	6a 00                	push   $0x0
  80123a:	ff 75 08             	pushl  0x8(%ebp)
  80123d:	e8 3a 02 00 00       	call   80147c <open>
  801242:	89 c3                	mov    %eax,%ebx
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	78 1b                	js     801266 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	50                   	push   %eax
  801252:	e8 5d ff ff ff       	call   8011b4 <fstat>
  801257:	89 c6                	mov    %eax,%esi
	close(fd);
  801259:	89 1c 24             	mov    %ebx,(%esp)
  80125c:	e8 fd fb ff ff       	call   800e5e <close>
	return r;
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	89 f3                	mov    %esi,%ebx
}
  801266:	89 d8                	mov    %ebx,%eax
  801268:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5e                   	pop    %esi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	89 c6                	mov    %eax,%esi
  801276:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801278:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80127f:	74 27                	je     8012a8 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801281:	6a 07                	push   $0x7
  801283:	68 00 50 80 00       	push   $0x805000
  801288:	56                   	push   %esi
  801289:	ff 35 00 40 80 00    	pushl  0x804000
  80128f:	e8 47 08 00 00       	call   801adb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801294:	83 c4 0c             	add    $0xc,%esp
  801297:	6a 00                	push   $0x0
  801299:	53                   	push   %ebx
  80129a:	6a 00                	push   $0x0
  80129c:	e8 cd 07 00 00       	call   801a6e <ipc_recv>
}
  8012a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	6a 01                	push   $0x1
  8012ad:	e8 81 08 00 00       	call   801b33 <ipc_find_env>
  8012b2:	a3 00 40 80 00       	mov    %eax,0x804000
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	eb c5                	jmp    801281 <fsipc+0x12>

008012bc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8012cc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012de:	b8 02 00 00 00       	mov    $0x2,%eax
  8012e3:	e8 87 ff ff ff       	call   80126f <fsipc>
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <devfile_flush>:
{
  8012ea:	f3 0f 1e fb          	endbr32 
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8012fa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8012ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801304:	b8 06 00 00 00       	mov    $0x6,%eax
  801309:	e8 61 ff ff ff       	call   80126f <fsipc>
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <devfile_stat>:
{
  801310:	f3 0f 1e fb          	endbr32 
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	53                   	push   %ebx
  801318:	83 ec 04             	sub    $0x4,%esp
  80131b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8b 40 0c             	mov    0xc(%eax),%eax
  801324:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801329:	ba 00 00 00 00       	mov    $0x0,%edx
  80132e:	b8 05 00 00 00       	mov    $0x5,%eax
  801333:	e8 37 ff ff ff       	call   80126f <fsipc>
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 2c                	js     801368 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	68 00 50 80 00       	push   $0x805000
  801344:	53                   	push   %ebx
  801345:	e8 8d f3 ff ff       	call   8006d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80134a:	a1 80 50 80 00       	mov    0x805080,%eax
  80134f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801355:	a1 84 50 80 00       	mov    0x805084,%eax
  80135a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <devfile_write>:
{
  80136d:	f3 0f 1e fb          	endbr32 
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	53                   	push   %ebx
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8b 40 0c             	mov    0xc(%eax),%eax
  801381:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801386:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80138c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801392:	77 30                	ja     8013c4 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	53                   	push   %ebx
  801398:	ff 75 0c             	pushl  0xc(%ebp)
  80139b:	68 08 50 80 00       	push   $0x805008
  8013a0:	e8 ea f4 ff ff       	call   80088f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013aa:	b8 04 00 00 00       	mov    $0x4,%eax
  8013af:	e8 bb fe ff ff       	call   80126f <fsipc>
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 04                	js     8013bf <devfile_write+0x52>
	assert(r <= n);
  8013bb:	39 d8                	cmp    %ebx,%eax
  8013bd:	77 1e                	ja     8013dd <devfile_write+0x70>
}
  8013bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8013c4:	68 f8 21 80 00       	push   $0x8021f8
  8013c9:	68 25 22 80 00       	push   $0x802225
  8013ce:	68 94 00 00 00       	push   $0x94
  8013d3:	68 3a 22 80 00       	push   $0x80223a
  8013d8:	e8 47 06 00 00       	call   801a24 <_panic>
	assert(r <= n);
  8013dd:	68 45 22 80 00       	push   $0x802245
  8013e2:	68 25 22 80 00       	push   $0x802225
  8013e7:	68 98 00 00 00       	push   $0x98
  8013ec:	68 3a 22 80 00       	push   $0x80223a
  8013f1:	e8 2e 06 00 00       	call   801a24 <_panic>

008013f6 <devfile_read>:
{
  8013f6:	f3 0f 1e fb          	endbr32 
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8b 40 0c             	mov    0xc(%eax),%eax
  801408:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80140d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
  801418:	b8 03 00 00 00       	mov    $0x3,%eax
  80141d:	e8 4d fe ff ff       	call   80126f <fsipc>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	85 c0                	test   %eax,%eax
  801426:	78 1f                	js     801447 <devfile_read+0x51>
	assert(r <= n);
  801428:	39 f0                	cmp    %esi,%eax
  80142a:	77 24                	ja     801450 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80142c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801431:	7f 33                	jg     801466 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	50                   	push   %eax
  801437:	68 00 50 80 00       	push   $0x805000
  80143c:	ff 75 0c             	pushl  0xc(%ebp)
  80143f:	e8 4b f4 ff ff       	call   80088f <memmove>
	return r;
  801444:	83 c4 10             	add    $0x10,%esp
}
  801447:	89 d8                	mov    %ebx,%eax
  801449:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    
	assert(r <= n);
  801450:	68 45 22 80 00       	push   $0x802245
  801455:	68 25 22 80 00       	push   $0x802225
  80145a:	6a 7c                	push   $0x7c
  80145c:	68 3a 22 80 00       	push   $0x80223a
  801461:	e8 be 05 00 00       	call   801a24 <_panic>
	assert(r <= PGSIZE);
  801466:	68 4c 22 80 00       	push   $0x80224c
  80146b:	68 25 22 80 00       	push   $0x802225
  801470:	6a 7d                	push   $0x7d
  801472:	68 3a 22 80 00       	push   $0x80223a
  801477:	e8 a8 05 00 00       	call   801a24 <_panic>

0080147c <open>:
{
  80147c:	f3 0f 1e fb          	endbr32 
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	83 ec 1c             	sub    $0x1c,%esp
  801488:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80148b:	56                   	push   %esi
  80148c:	e8 03 f2 ff ff       	call   800694 <strlen>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801499:	7f 6c                	jg     801507 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	e8 28 f8 ff ff       	call   800ccf <fd_alloc>
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 3c                	js     8014ec <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	56                   	push   %esi
  8014b4:	68 00 50 80 00       	push   $0x805000
  8014b9:	e8 19 f2 ff ff       	call   8006d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ce:	e8 9c fd ff ff       	call   80126f <fsipc>
  8014d3:	89 c3                	mov    %eax,%ebx
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 19                	js     8014f5 <open+0x79>
	return fd2num(fd);
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e2:	e8 b5 f7 ff ff       	call   800c9c <fd2num>
  8014e7:	89 c3                	mov    %eax,%ebx
  8014e9:	83 c4 10             	add    $0x10,%esp
}
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    
		fd_close(fd, 0);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	6a 00                	push   $0x0
  8014fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fd:	e8 d1 f8 ff ff       	call   800dd3 <fd_close>
		return r;
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	eb e5                	jmp    8014ec <open+0x70>
		return -E_BAD_PATH;
  801507:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80150c:	eb de                	jmp    8014ec <open+0x70>

0080150e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80150e:	f3 0f 1e fb          	endbr32 
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801518:	ba 00 00 00 00       	mov    $0x0,%edx
  80151d:	b8 08 00 00 00       	mov    $0x8,%eax
  801522:	e8 48 fd ff ff       	call   80126f <fsipc>
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801529:	f3 0f 1e fb          	endbr32 
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	56                   	push   %esi
  801531:	53                   	push   %ebx
  801532:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 70 f7 ff ff       	call   800cb0 <fd2data>
  801540:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801542:	83 c4 08             	add    $0x8,%esp
  801545:	68 58 22 80 00       	push   $0x802258
  80154a:	53                   	push   %ebx
  80154b:	e8 87 f1 ff ff       	call   8006d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801550:	8b 46 04             	mov    0x4(%esi),%eax
  801553:	2b 06                	sub    (%esi),%eax
  801555:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80155b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801562:	00 00 00 
	stat->st_dev = &devpipe;
  801565:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80156c:	30 80 00 
	return 0;
}
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801577:	5b                   	pop    %ebx
  801578:	5e                   	pop    %esi
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    

0080157b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80157b:	f3 0f 1e fb          	endbr32 
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801589:	53                   	push   %ebx
  80158a:	6a 00                	push   $0x0
  80158c:	e8 20 f6 ff ff       	call   800bb1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801591:	89 1c 24             	mov    %ebx,(%esp)
  801594:	e8 17 f7 ff ff       	call   800cb0 <fd2data>
  801599:	83 c4 08             	add    $0x8,%esp
  80159c:	50                   	push   %eax
  80159d:	6a 00                	push   $0x0
  80159f:	e8 0d f6 ff ff       	call   800bb1 <sys_page_unmap>
}
  8015a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <_pipeisclosed>:
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	57                   	push   %edi
  8015ad:	56                   	push   %esi
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 1c             	sub    $0x1c,%esp
  8015b2:	89 c7                	mov    %eax,%edi
  8015b4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8015bb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	57                   	push   %edi
  8015c2:	e8 a9 05 00 00       	call   801b70 <pageref>
  8015c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015ca:	89 34 24             	mov    %esi,(%esp)
  8015cd:	e8 9e 05 00 00       	call   801b70 <pageref>
		nn = thisenv->env_runs;
  8015d2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8015d8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	39 cb                	cmp    %ecx,%ebx
  8015e0:	74 1b                	je     8015fd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015e2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015e5:	75 cf                	jne    8015b6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015e7:	8b 42 58             	mov    0x58(%edx),%eax
  8015ea:	6a 01                	push   $0x1
  8015ec:	50                   	push   %eax
  8015ed:	53                   	push   %ebx
  8015ee:	68 5f 22 80 00       	push   $0x80225f
  8015f3:	e8 75 eb ff ff       	call   80016d <cprintf>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb b9                	jmp    8015b6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015fd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801600:	0f 94 c0             	sete   %al
  801603:	0f b6 c0             	movzbl %al,%eax
}
  801606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5f                   	pop    %edi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <devpipe_write>:
{
  80160e:	f3 0f 1e fb          	endbr32 
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 28             	sub    $0x28,%esp
  80161b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80161e:	56                   	push   %esi
  80161f:	e8 8c f6 ff ff       	call   800cb0 <fd2data>
  801624:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	bf 00 00 00 00       	mov    $0x0,%edi
  80162e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801631:	74 4f                	je     801682 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801633:	8b 43 04             	mov    0x4(%ebx),%eax
  801636:	8b 0b                	mov    (%ebx),%ecx
  801638:	8d 51 20             	lea    0x20(%ecx),%edx
  80163b:	39 d0                	cmp    %edx,%eax
  80163d:	72 14                	jb     801653 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80163f:	89 da                	mov    %ebx,%edx
  801641:	89 f0                	mov    %esi,%eax
  801643:	e8 61 ff ff ff       	call   8015a9 <_pipeisclosed>
  801648:	85 c0                	test   %eax,%eax
  80164a:	75 3b                	jne    801687 <devpipe_write+0x79>
			sys_yield();
  80164c:	e8 e3 f4 ff ff       	call   800b34 <sys_yield>
  801651:	eb e0                	jmp    801633 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801656:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80165a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80165d:	89 c2                	mov    %eax,%edx
  80165f:	c1 fa 1f             	sar    $0x1f,%edx
  801662:	89 d1                	mov    %edx,%ecx
  801664:	c1 e9 1b             	shr    $0x1b,%ecx
  801667:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80166a:	83 e2 1f             	and    $0x1f,%edx
  80166d:	29 ca                	sub    %ecx,%edx
  80166f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801673:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801677:	83 c0 01             	add    $0x1,%eax
  80167a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80167d:	83 c7 01             	add    $0x1,%edi
  801680:	eb ac                	jmp    80162e <devpipe_write+0x20>
	return i;
  801682:	8b 45 10             	mov    0x10(%ebp),%eax
  801685:	eb 05                	jmp    80168c <devpipe_write+0x7e>
				return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5f                   	pop    %edi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    

00801694 <devpipe_read>:
{
  801694:	f3 0f 1e fb          	endbr32 
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	57                   	push   %edi
  80169c:	56                   	push   %esi
  80169d:	53                   	push   %ebx
  80169e:	83 ec 18             	sub    $0x18,%esp
  8016a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016a4:	57                   	push   %edi
  8016a5:	e8 06 f6 ff ff       	call   800cb0 <fd2data>
  8016aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	be 00 00 00 00       	mov    $0x0,%esi
  8016b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016b7:	75 14                	jne    8016cd <devpipe_read+0x39>
	return i;
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	eb 02                	jmp    8016c0 <devpipe_read+0x2c>
				return i;
  8016be:	89 f0                	mov    %esi,%eax
}
  8016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5f                   	pop    %edi
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    
			sys_yield();
  8016c8:	e8 67 f4 ff ff       	call   800b34 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8016cd:	8b 03                	mov    (%ebx),%eax
  8016cf:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016d2:	75 18                	jne    8016ec <devpipe_read+0x58>
			if (i > 0)
  8016d4:	85 f6                	test   %esi,%esi
  8016d6:	75 e6                	jne    8016be <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8016d8:	89 da                	mov    %ebx,%edx
  8016da:	89 f8                	mov    %edi,%eax
  8016dc:	e8 c8 fe ff ff       	call   8015a9 <_pipeisclosed>
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	74 e3                	je     8016c8 <devpipe_read+0x34>
				return 0;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb d4                	jmp    8016c0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016ec:	99                   	cltd   
  8016ed:	c1 ea 1b             	shr    $0x1b,%edx
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	83 e0 1f             	and    $0x1f,%eax
  8016f5:	29 d0                	sub    %edx,%eax
  8016f7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801702:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801705:	83 c6 01             	add    $0x1,%esi
  801708:	eb aa                	jmp    8016b4 <devpipe_read+0x20>

0080170a <pipe>:
{
  80170a:	f3 0f 1e fb          	endbr32 
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	56                   	push   %esi
  801712:	53                   	push   %ebx
  801713:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801716:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801719:	50                   	push   %eax
  80171a:	e8 b0 f5 ff ff       	call   800ccf <fd_alloc>
  80171f:	89 c3                	mov    %eax,%ebx
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	0f 88 23 01 00 00    	js     80184f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	68 07 04 00 00       	push   $0x407
  801734:	ff 75 f4             	pushl  -0xc(%ebp)
  801737:	6a 00                	push   $0x0
  801739:	e8 21 f4 ff ff       	call   800b5f <sys_page_alloc>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	0f 88 04 01 00 00    	js     80184f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	e8 78 f5 ff ff       	call   800ccf <fd_alloc>
  801757:	89 c3                	mov    %eax,%ebx
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	0f 88 db 00 00 00    	js     80183f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 07 04 00 00       	push   $0x407
  80176c:	ff 75 f0             	pushl  -0x10(%ebp)
  80176f:	6a 00                	push   $0x0
  801771:	e8 e9 f3 ff ff       	call   800b5f <sys_page_alloc>
  801776:	89 c3                	mov    %eax,%ebx
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	0f 88 bc 00 00 00    	js     80183f <pipe+0x135>
	va = fd2data(fd0);
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	ff 75 f4             	pushl  -0xc(%ebp)
  801789:	e8 22 f5 ff ff       	call   800cb0 <fd2data>
  80178e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801790:	83 c4 0c             	add    $0xc,%esp
  801793:	68 07 04 00 00       	push   $0x407
  801798:	50                   	push   %eax
  801799:	6a 00                	push   $0x0
  80179b:	e8 bf f3 ff ff       	call   800b5f <sys_page_alloc>
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	0f 88 82 00 00 00    	js     80182f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b3:	e8 f8 f4 ff ff       	call   800cb0 <fd2data>
  8017b8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017bf:	50                   	push   %eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	56                   	push   %esi
  8017c3:	6a 00                	push   $0x0
  8017c5:	e8 bd f3 ff ff       	call   800b87 <sys_page_map>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 20             	add    $0x20,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 4e                	js     801821 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8017d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017db:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8017dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8017e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ea:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fc:	e8 9b f4 ff ff       	call   800c9c <fd2num>
  801801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801804:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801806:	83 c4 04             	add    $0x4,%esp
  801809:	ff 75 f0             	pushl  -0x10(%ebp)
  80180c:	e8 8b f4 ff ff       	call   800c9c <fd2num>
  801811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801814:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181f:	eb 2e                	jmp    80184f <pipe+0x145>
	sys_page_unmap(0, va);
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	56                   	push   %esi
  801825:	6a 00                	push   $0x0
  801827:	e8 85 f3 ff ff       	call   800bb1 <sys_page_unmap>
  80182c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 f0             	pushl  -0x10(%ebp)
  801835:	6a 00                	push   $0x0
  801837:	e8 75 f3 ff ff       	call   800bb1 <sys_page_unmap>
  80183c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80183f:	83 ec 08             	sub    $0x8,%esp
  801842:	ff 75 f4             	pushl  -0xc(%ebp)
  801845:	6a 00                	push   $0x0
  801847:	e8 65 f3 ff ff       	call   800bb1 <sys_page_unmap>
  80184c:	83 c4 10             	add    $0x10,%esp
}
  80184f:	89 d8                	mov    %ebx,%eax
  801851:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <pipeisclosed>:
{
  801858:	f3 0f 1e fb          	endbr32 
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801865:	50                   	push   %eax
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	e8 b7 f4 ff ff       	call   800d25 <fd_lookup>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	78 18                	js     80188d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	ff 75 f4             	pushl  -0xc(%ebp)
  80187b:	e8 30 f4 ff ff       	call   800cb0 <fd2data>
  801880:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801885:	e8 1f fd ff ff       	call   8015a9 <_pipeisclosed>
  80188a:	83 c4 10             	add    $0x10,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80188f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	c3                   	ret    

00801899 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801899:	f3 0f 1e fb          	endbr32 
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018a3:	68 77 22 80 00       	push   $0x802277
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	e8 27 ee ff ff       	call   8006d7 <strcpy>
	return 0;
}
  8018b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <devcons_write>:
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	57                   	push   %edi
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8018c7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8018cc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018d2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018d5:	73 31                	jae    801908 <devcons_write+0x51>
		m = n - tot;
  8018d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018da:	29 f3                	sub    %esi,%ebx
  8018dc:	83 fb 7f             	cmp    $0x7f,%ebx
  8018df:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018e4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	53                   	push   %ebx
  8018eb:	89 f0                	mov    %esi,%eax
  8018ed:	03 45 0c             	add    0xc(%ebp),%eax
  8018f0:	50                   	push   %eax
  8018f1:	57                   	push   %edi
  8018f2:	e8 98 ef ff ff       	call   80088f <memmove>
		sys_cputs(buf, m);
  8018f7:	83 c4 08             	add    $0x8,%esp
  8018fa:	53                   	push   %ebx
  8018fb:	57                   	push   %edi
  8018fc:	e8 93 f1 ff ff       	call   800a94 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801901:	01 de                	add    %ebx,%esi
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	eb ca                	jmp    8018d2 <devcons_write+0x1b>
}
  801908:	89 f0                	mov    %esi,%eax
  80190a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5f                   	pop    %edi
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    

00801912 <devcons_read>:
{
  801912:	f3 0f 1e fb          	endbr32 
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801921:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801925:	74 21                	je     801948 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801927:	e8 92 f1 ff ff       	call   800abe <sys_cgetc>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	75 07                	jne    801937 <devcons_read+0x25>
		sys_yield();
  801930:	e8 ff f1 ff ff       	call   800b34 <sys_yield>
  801935:	eb f0                	jmp    801927 <devcons_read+0x15>
	if (c < 0)
  801937:	78 0f                	js     801948 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801939:	83 f8 04             	cmp    $0x4,%eax
  80193c:	74 0c                	je     80194a <devcons_read+0x38>
	*(char*)vbuf = c;
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	88 02                	mov    %al,(%edx)
	return 1;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    
		return 0;
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
  80194f:	eb f7                	jmp    801948 <devcons_read+0x36>

00801951 <cputchar>:
{
  801951:	f3 0f 1e fb          	endbr32 
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801961:	6a 01                	push   $0x1
  801963:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801966:	50                   	push   %eax
  801967:	e8 28 f1 ff ff       	call   800a94 <sys_cputs>
}
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <getchar>:
{
  801971:	f3 0f 1e fb          	endbr32 
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80197b:	6a 01                	push   $0x1
  80197d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	6a 00                	push   $0x0
  801983:	e8 20 f6 ff ff       	call   800fa8 <read>
	if (r < 0)
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 06                	js     801995 <getchar+0x24>
	if (r < 1)
  80198f:	74 06                	je     801997 <getchar+0x26>
	return c;
  801991:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    
		return -E_EOF;
  801997:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80199c:	eb f7                	jmp    801995 <getchar+0x24>

0080199e <iscons>:
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ab:	50                   	push   %eax
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	e8 71 f3 ff ff       	call   800d25 <fd_lookup>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 11                	js     8019cc <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019c4:	39 10                	cmp    %edx,(%eax)
  8019c6:	0f 94 c0             	sete   %al
  8019c9:	0f b6 c0             	movzbl %al,%eax
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <opencons>:
{
  8019ce:	f3 0f 1e fb          	endbr32 
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8019d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019db:	50                   	push   %eax
  8019dc:	e8 ee f2 ff ff       	call   800ccf <fd_alloc>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 3a                	js     801a22 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 07 04 00 00       	push   $0x407
  8019f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f3:	6a 00                	push   $0x0
  8019f5:	e8 65 f1 ff ff       	call   800b5f <sys_page_alloc>
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 21                	js     801a22 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a0a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	50                   	push   %eax
  801a1a:	e8 7d f2 ff ff       	call   800c9c <fd2num>
  801a1f:	83 c4 10             	add    $0x10,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a24:	f3 0f 1e fb          	endbr32 
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	56                   	push   %esi
  801a2c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a2d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a30:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a36:	e8 d1 f0 ff ff       	call   800b0c <sys_getenvid>
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	56                   	push   %esi
  801a45:	50                   	push   %eax
  801a46:	68 84 22 80 00       	push   $0x802284
  801a4b:	e8 1d e7 ff ff       	call   80016d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a50:	83 c4 18             	add    $0x18,%esp
  801a53:	53                   	push   %ebx
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	e8 bc e6 ff ff       	call   800118 <vcprintf>
	cprintf("\n");
  801a5c:	c7 04 24 c2 22 80 00 	movl   $0x8022c2,(%esp)
  801a63:	e8 05 e7 ff ff       	call   80016d <cprintf>
  801a68:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a6b:	cc                   	int3   
  801a6c:	eb fd                	jmp    801a6b <_panic+0x47>

00801a6e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	56                   	push   %esi
  801a76:	53                   	push   %ebx
  801a77:	8b 75 08             	mov    0x8(%ebp),%esi
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a80:	85 c0                	test   %eax,%eax
  801a82:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a87:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	50                   	push   %eax
  801a8e:	e8 e3 f1 ff ff       	call   800c76 <sys_ipc_recv>
	if (r < 0) {
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 2b                	js     801ac5 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a9a:	85 f6                	test   %esi,%esi
  801a9c:	74 0a                	je     801aa8 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a9e:	a1 08 40 80 00       	mov    0x804008,%eax
  801aa3:	8b 40 74             	mov    0x74(%eax),%eax
  801aa6:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801aa8:	85 db                	test   %ebx,%ebx
  801aaa:	74 0a                	je     801ab6 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801aac:	a1 08 40 80 00       	mov    0x804008,%eax
  801ab1:	8b 40 78             	mov    0x78(%eax),%eax
  801ab4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801ab6:	a1 08 40 80 00       	mov    0x804008,%eax
  801abb:	8b 40 70             	mov    0x70(%eax),%eax
}
  801abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
		if (from_env_store) {
  801ac5:	85 f6                	test   %esi,%esi
  801ac7:	74 06                	je     801acf <ipc_recv+0x61>
			*from_env_store = 0;
  801ac9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801acf:	85 db                	test   %ebx,%ebx
  801ad1:	74 eb                	je     801abe <ipc_recv+0x50>
			*perm_store = 0;
  801ad3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ad9:	eb e3                	jmp    801abe <ipc_recv+0x50>

00801adb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801adb:	f3 0f 1e fb          	endbr32 
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	57                   	push   %edi
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 0c             	sub    $0xc,%esp
  801ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801aee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801af1:	85 db                	test   %ebx,%ebx
  801af3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801af8:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801afb:	ff 75 14             	pushl  0x14(%ebp)
  801afe:	53                   	push   %ebx
  801aff:	56                   	push   %esi
  801b00:	57                   	push   %edi
  801b01:	e8 47 f1 ff ff       	call   800c4d <sys_ipc_try_send>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b0c:	75 07                	jne    801b15 <ipc_send+0x3a>
		sys_yield();
  801b0e:	e8 21 f0 ff ff       	call   800b34 <sys_yield>
  801b13:	eb e6                	jmp    801afb <ipc_send+0x20>
	}

	if (ret < 0) {
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 08                	js     801b21 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5f                   	pop    %edi
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b21:	50                   	push   %eax
  801b22:	68 a7 22 80 00       	push   $0x8022a7
  801b27:	6a 48                	push   $0x48
  801b29:	68 c4 22 80 00       	push   $0x8022c4
  801b2e:	e8 f1 fe ff ff       	call   801a24 <_panic>

00801b33 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b33:	f3 0f 1e fb          	endbr32 
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b3d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b42:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b45:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b4b:	8b 52 50             	mov    0x50(%edx),%edx
  801b4e:	39 ca                	cmp    %ecx,%edx
  801b50:	74 11                	je     801b63 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b52:	83 c0 01             	add    $0x1,%eax
  801b55:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b5a:	75 e6                	jne    801b42 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b61:	eb 0b                	jmp    801b6e <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b63:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b66:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b6b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b70:	f3 0f 1e fb          	endbr32 
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b7a:	89 c2                	mov    %eax,%edx
  801b7c:	c1 ea 16             	shr    $0x16,%edx
  801b7f:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b8b:	f6 c1 01             	test   $0x1,%cl
  801b8e:	74 1c                	je     801bac <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b90:	c1 e8 0c             	shr    $0xc,%eax
  801b93:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b9a:	a8 01                	test   $0x1,%al
  801b9c:	74 0e                	je     801bac <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b9e:	c1 e8 0c             	shr    $0xc,%eax
  801ba1:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ba8:	ef 
  801ba9:	0f b7 d2             	movzwl %dx,%edx
}
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <__udivdi3>:
  801bb0:	f3 0f 1e fb          	endbr32 
  801bb4:	55                   	push   %ebp
  801bb5:	57                   	push   %edi
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 1c             	sub    $0x1c,%esp
  801bbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bcb:	85 d2                	test   %edx,%edx
  801bcd:	75 19                	jne    801be8 <__udivdi3+0x38>
  801bcf:	39 f3                	cmp    %esi,%ebx
  801bd1:	76 4d                	jbe    801c20 <__udivdi3+0x70>
  801bd3:	31 ff                	xor    %edi,%edi
  801bd5:	89 e8                	mov    %ebp,%eax
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	f7 f3                	div    %ebx
  801bdb:	89 fa                	mov    %edi,%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	39 f2                	cmp    %esi,%edx
  801bea:	76 14                	jbe    801c00 <__udivdi3+0x50>
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	31 c0                	xor    %eax,%eax
  801bf0:	89 fa                	mov    %edi,%edx
  801bf2:	83 c4 1c             	add    $0x1c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
  801bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c00:	0f bd fa             	bsr    %edx,%edi
  801c03:	83 f7 1f             	xor    $0x1f,%edi
  801c06:	75 48                	jne    801c50 <__udivdi3+0xa0>
  801c08:	39 f2                	cmp    %esi,%edx
  801c0a:	72 06                	jb     801c12 <__udivdi3+0x62>
  801c0c:	31 c0                	xor    %eax,%eax
  801c0e:	39 eb                	cmp    %ebp,%ebx
  801c10:	77 de                	ja     801bf0 <__udivdi3+0x40>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	eb d7                	jmp    801bf0 <__udivdi3+0x40>
  801c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c20:	89 d9                	mov    %ebx,%ecx
  801c22:	85 db                	test   %ebx,%ebx
  801c24:	75 0b                	jne    801c31 <__udivdi3+0x81>
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	31 d2                	xor    %edx,%edx
  801c2d:	f7 f3                	div    %ebx
  801c2f:	89 c1                	mov    %eax,%ecx
  801c31:	31 d2                	xor    %edx,%edx
  801c33:	89 f0                	mov    %esi,%eax
  801c35:	f7 f1                	div    %ecx
  801c37:	89 c6                	mov    %eax,%esi
  801c39:	89 e8                	mov    %ebp,%eax
  801c3b:	89 f7                	mov    %esi,%edi
  801c3d:	f7 f1                	div    %ecx
  801c3f:	89 fa                	mov    %edi,%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c50:	89 f9                	mov    %edi,%ecx
  801c52:	b8 20 00 00 00       	mov    $0x20,%eax
  801c57:	29 f8                	sub    %edi,%eax
  801c59:	d3 e2                	shl    %cl,%edx
  801c5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c5f:	89 c1                	mov    %eax,%ecx
  801c61:	89 da                	mov    %ebx,%edx
  801c63:	d3 ea                	shr    %cl,%edx
  801c65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c69:	09 d1                	or     %edx,%ecx
  801c6b:	89 f2                	mov    %esi,%edx
  801c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c71:	89 f9                	mov    %edi,%ecx
  801c73:	d3 e3                	shl    %cl,%ebx
  801c75:	89 c1                	mov    %eax,%ecx
  801c77:	d3 ea                	shr    %cl,%edx
  801c79:	89 f9                	mov    %edi,%ecx
  801c7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c7f:	89 eb                	mov    %ebp,%ebx
  801c81:	d3 e6                	shl    %cl,%esi
  801c83:	89 c1                	mov    %eax,%ecx
  801c85:	d3 eb                	shr    %cl,%ebx
  801c87:	09 de                	or     %ebx,%esi
  801c89:	89 f0                	mov    %esi,%eax
  801c8b:	f7 74 24 08          	divl   0x8(%esp)
  801c8f:	89 d6                	mov    %edx,%esi
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	f7 64 24 0c          	mull   0xc(%esp)
  801c97:	39 d6                	cmp    %edx,%esi
  801c99:	72 15                	jb     801cb0 <__udivdi3+0x100>
  801c9b:	89 f9                	mov    %edi,%ecx
  801c9d:	d3 e5                	shl    %cl,%ebp
  801c9f:	39 c5                	cmp    %eax,%ebp
  801ca1:	73 04                	jae    801ca7 <__udivdi3+0xf7>
  801ca3:	39 d6                	cmp    %edx,%esi
  801ca5:	74 09                	je     801cb0 <__udivdi3+0x100>
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	31 ff                	xor    %edi,%edi
  801cab:	e9 40 ff ff ff       	jmp    801bf0 <__udivdi3+0x40>
  801cb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cb3:	31 ff                	xor    %edi,%edi
  801cb5:	e9 36 ff ff ff       	jmp    801bf0 <__udivdi3+0x40>
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	66 90                	xchg   %ax,%ax
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__umoddi3>:
  801cc0:	f3 0f 1e fb          	endbr32 
  801cc4:	55                   	push   %ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801cd3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801cd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	75 19                	jne    801cf8 <__umoddi3+0x38>
  801cdf:	39 df                	cmp    %ebx,%edi
  801ce1:	76 5d                	jbe    801d40 <__umoddi3+0x80>
  801ce3:	89 f0                	mov    %esi,%eax
  801ce5:	89 da                	mov    %ebx,%edx
  801ce7:	f7 f7                	div    %edi
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	83 c4 1c             	add    $0x1c,%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    
  801cf5:	8d 76 00             	lea    0x0(%esi),%esi
  801cf8:	89 f2                	mov    %esi,%edx
  801cfa:	39 d8                	cmp    %ebx,%eax
  801cfc:	76 12                	jbe    801d10 <__umoddi3+0x50>
  801cfe:	89 f0                	mov    %esi,%eax
  801d00:	89 da                	mov    %ebx,%edx
  801d02:	83 c4 1c             	add    $0x1c,%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5f                   	pop    %edi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
  801d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d10:	0f bd e8             	bsr    %eax,%ebp
  801d13:	83 f5 1f             	xor    $0x1f,%ebp
  801d16:	75 50                	jne    801d68 <__umoddi3+0xa8>
  801d18:	39 d8                	cmp    %ebx,%eax
  801d1a:	0f 82 e0 00 00 00    	jb     801e00 <__umoddi3+0x140>
  801d20:	89 d9                	mov    %ebx,%ecx
  801d22:	39 f7                	cmp    %esi,%edi
  801d24:	0f 86 d6 00 00 00    	jbe    801e00 <__umoddi3+0x140>
  801d2a:	89 d0                	mov    %edx,%eax
  801d2c:	89 ca                	mov    %ecx,%edx
  801d2e:	83 c4 1c             	add    $0x1c,%esp
  801d31:	5b                   	pop    %ebx
  801d32:	5e                   	pop    %esi
  801d33:	5f                   	pop    %edi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    
  801d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d3d:	8d 76 00             	lea    0x0(%esi),%esi
  801d40:	89 fd                	mov    %edi,%ebp
  801d42:	85 ff                	test   %edi,%edi
  801d44:	75 0b                	jne    801d51 <__umoddi3+0x91>
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	31 d2                	xor    %edx,%edx
  801d4d:	f7 f7                	div    %edi
  801d4f:	89 c5                	mov    %eax,%ebp
  801d51:	89 d8                	mov    %ebx,%eax
  801d53:	31 d2                	xor    %edx,%edx
  801d55:	f7 f5                	div    %ebp
  801d57:	89 f0                	mov    %esi,%eax
  801d59:	f7 f5                	div    %ebp
  801d5b:	89 d0                	mov    %edx,%eax
  801d5d:	31 d2                	xor    %edx,%edx
  801d5f:	eb 8c                	jmp    801ced <__umoddi3+0x2d>
  801d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d68:	89 e9                	mov    %ebp,%ecx
  801d6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801d6f:	29 ea                	sub    %ebp,%edx
  801d71:	d3 e0                	shl    %cl,%eax
  801d73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d77:	89 d1                	mov    %edx,%ecx
  801d79:	89 f8                	mov    %edi,%eax
  801d7b:	d3 e8                	shr    %cl,%eax
  801d7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d89:	09 c1                	or     %eax,%ecx
  801d8b:	89 d8                	mov    %ebx,%eax
  801d8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e7                	shl    %cl,%edi
  801d95:	89 d1                	mov    %edx,%ecx
  801d97:	d3 e8                	shr    %cl,%eax
  801d99:	89 e9                	mov    %ebp,%ecx
  801d9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d9f:	d3 e3                	shl    %cl,%ebx
  801da1:	89 c7                	mov    %eax,%edi
  801da3:	89 d1                	mov    %edx,%ecx
  801da5:	89 f0                	mov    %esi,%eax
  801da7:	d3 e8                	shr    %cl,%eax
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	89 fa                	mov    %edi,%edx
  801dad:	d3 e6                	shl    %cl,%esi
  801daf:	09 d8                	or     %ebx,%eax
  801db1:	f7 74 24 08          	divl   0x8(%esp)
  801db5:	89 d1                	mov    %edx,%ecx
  801db7:	89 f3                	mov    %esi,%ebx
  801db9:	f7 64 24 0c          	mull   0xc(%esp)
  801dbd:	89 c6                	mov    %eax,%esi
  801dbf:	89 d7                	mov    %edx,%edi
  801dc1:	39 d1                	cmp    %edx,%ecx
  801dc3:	72 06                	jb     801dcb <__umoddi3+0x10b>
  801dc5:	75 10                	jne    801dd7 <__umoddi3+0x117>
  801dc7:	39 c3                	cmp    %eax,%ebx
  801dc9:	73 0c                	jae    801dd7 <__umoddi3+0x117>
  801dcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801dcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801dd3:	89 d7                	mov    %edx,%edi
  801dd5:	89 c6                	mov    %eax,%esi
  801dd7:	89 ca                	mov    %ecx,%edx
  801dd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801dde:	29 f3                	sub    %esi,%ebx
  801de0:	19 fa                	sbb    %edi,%edx
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	d3 e0                	shl    %cl,%eax
  801de6:	89 e9                	mov    %ebp,%ecx
  801de8:	d3 eb                	shr    %cl,%ebx
  801dea:	d3 ea                	shr    %cl,%edx
  801dec:	09 d8                	or     %ebx,%eax
  801dee:	83 c4 1c             	add    $0x1c,%esp
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5f                   	pop    %edi
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    
  801df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dfd:	8d 76 00             	lea    0x0(%esi),%esi
  801e00:	29 fe                	sub    %edi,%esi
  801e02:	19 c3                	sbb    %eax,%ebx
  801e04:	89 f2                	mov    %esi,%edx
  801e06:	89 d9                	mov    %ebx,%ecx
  801e08:	e9 1d ff ff ff       	jmp    801d2a <__umoddi3+0x6a>
