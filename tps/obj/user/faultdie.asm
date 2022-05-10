
obj/user/faultdie.debug:     formato del fichero elf32-i386


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
  80002c:	e8 57 00 00 00       	call   800088 <libmain>
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
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800040:	8b 42 04             	mov    0x4(%edx),%eax
  800043:	83 e0 07             	and    $0x7,%eax
  800046:	50                   	push   %eax
  800047:	ff 32                	pushl  (%edx)
  800049:	68 e0 1e 80 00       	push   $0x801ee0
  80004e:	e8 3e 01 00 00       	call   800191 <cprintf>
	sys_env_destroy(sys_getenvid());
  800053:	e8 d8 0a 00 00       	call   800b30 <sys_getenvid>
  800058:	89 04 24             	mov    %eax,(%esp)
  80005b:	e8 aa 0a 00 00       	call   800b0a <sys_env_destroy>
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <umain>:

void
umain(int argc, char **argv)
{
  800065:	f3 0f 1e fb          	endbr32 
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80006f:	68 33 00 80 00       	push   $0x800033
  800074:	e8 47 0c 00 00       	call   800cc0 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800079:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800080:	00 00 00 
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	c9                   	leave  
  800087:	c3                   	ret    

00800088 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800094:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800097:	e8 94 0a 00 00       	call   800b30 <sys_getenvid>
	if (id >= 0)
  80009c:	85 c0                	test   %eax,%eax
  80009e:	78 12                	js     8000b2 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ad:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	85 db                	test   %ebx,%ebx
  8000b4:	7e 07                	jle    8000bd <libmain+0x35>
		binaryname = argv[0];
  8000b6:	8b 06                	mov    (%esi),%eax
  8000b8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
  8000c2:	e8 9e ff ff ff       	call   800065 <umain>

	// exit gracefully
	exit();
  8000c7:	e8 0a 00 00 00       	call   8000d6 <exit>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d6:	f3 0f 1e fb          	endbr32 
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e0:	e8 71 0e 00 00       	call   800f56 <close_all>
	sys_env_destroy(0);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	6a 00                	push   $0x0
  8000ea:	e8 1b 0a 00 00       	call   800b0a <sys_env_destroy>
}
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f4:	f3 0f 1e fb          	endbr32 
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800102:	8b 13                	mov    (%ebx),%edx
  800104:	8d 42 01             	lea    0x1(%edx),%eax
  800107:	89 03                	mov    %eax,(%ebx)
  800109:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800110:	3d ff 00 00 00       	cmp    $0xff,%eax
  800115:	74 09                	je     800120 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800117:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	68 ff 00 00 00       	push   $0xff
  800128:	8d 43 08             	lea    0x8(%ebx),%eax
  80012b:	50                   	push   %eax
  80012c:	e8 87 09 00 00       	call   800ab8 <sys_cputs>
		b->idx = 0;
  800131:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	eb db                	jmp    800117 <putch+0x23>

0080013c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013c:	f3 0f 1e fb          	endbr32 
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800149:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800150:	00 00 00 
	b.cnt = 0;
  800153:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015d:	ff 75 0c             	pushl  0xc(%ebp)
  800160:	ff 75 08             	pushl  0x8(%ebp)
  800163:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	68 f4 00 80 00       	push   $0x8000f4
  80016f:	e8 80 01 00 00       	call   8002f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800174:	83 c4 08             	add    $0x8,%esp
  800177:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	e8 2f 09 00 00       	call   800ab8 <sys_cputs>

	return b.cnt;
}
  800189:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800191:	f3 0f 1e fb          	endbr32 
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019e:	50                   	push   %eax
  80019f:	ff 75 08             	pushl  0x8(%ebp)
  8001a2:	e8 95 ff ff ff       	call   80013c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 1c             	sub    $0x1c,%esp
  8001b2:	89 c7                	mov    %eax,%edi
  8001b4:	89 d6                	mov    %edx,%esi
  8001b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bc:	89 d1                	mov    %edx,%ecx
  8001be:	89 c2                	mov    %eax,%edx
  8001c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d6:	39 c2                	cmp    %eax,%edx
  8001d8:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001db:	72 3e                	jb     80021b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 18             	pushl  0x18(%ebp)
  8001e3:	83 eb 01             	sub    $0x1,%ebx
  8001e6:	53                   	push   %ebx
  8001e7:	50                   	push   %eax
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f7:	e8 84 1a 00 00       	call   801c80 <__udivdi3>
  8001fc:	83 c4 18             	add    $0x18,%esp
  8001ff:	52                   	push   %edx
  800200:	50                   	push   %eax
  800201:	89 f2                	mov    %esi,%edx
  800203:	89 f8                	mov    %edi,%eax
  800205:	e8 9f ff ff ff       	call   8001a9 <printnum>
  80020a:	83 c4 20             	add    $0x20,%esp
  80020d:	eb 13                	jmp    800222 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	56                   	push   %esi
  800213:	ff 75 18             	pushl  0x18(%ebp)
  800216:	ff d7                	call   *%edi
  800218:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	85 db                	test   %ebx,%ebx
  800220:	7f ed                	jg     80020f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	56                   	push   %esi
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022c:	ff 75 e0             	pushl  -0x20(%ebp)
  80022f:	ff 75 dc             	pushl  -0x24(%ebp)
  800232:	ff 75 d8             	pushl  -0x28(%ebp)
  800235:	e8 56 1b 00 00       	call   801d90 <__umoddi3>
  80023a:	83 c4 14             	add    $0x14,%esp
  80023d:	0f be 80 06 1f 80 00 	movsbl 0x801f06(%eax),%eax
  800244:	50                   	push   %eax
  800245:	ff d7                	call   *%edi
}
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024d:	5b                   	pop    %ebx
  80024e:	5e                   	pop    %esi
  80024f:	5f                   	pop    %edi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    

00800252 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800252:	83 fa 01             	cmp    $0x1,%edx
  800255:	7f 13                	jg     80026a <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800257:	85 d2                	test   %edx,%edx
  800259:	74 1c                	je     800277 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80025b:	8b 10                	mov    (%eax),%edx
  80025d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800260:	89 08                	mov    %ecx,(%eax)
  800262:	8b 02                	mov    (%edx),%eax
  800264:	ba 00 00 00 00       	mov    $0x0,%edx
  800269:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80026a:	8b 10                	mov    (%eax),%edx
  80026c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80026f:	89 08                	mov    %ecx,(%eax)
  800271:	8b 02                	mov    (%edx),%eax
  800273:	8b 52 04             	mov    0x4(%edx),%edx
  800276:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800277:	8b 10                	mov    (%eax),%edx
  800279:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 02                	mov    (%edx),%eax
  800280:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800285:	c3                   	ret    

00800286 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800286:	83 fa 01             	cmp    $0x1,%edx
  800289:	7f 0f                	jg     80029a <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80028b:	85 d2                	test   %edx,%edx
  80028d:	74 18                	je     8002a7 <getint+0x21>
		return va_arg(*ap, long);
  80028f:	8b 10                	mov    (%eax),%edx
  800291:	8d 4a 04             	lea    0x4(%edx),%ecx
  800294:	89 08                	mov    %ecx,(%eax)
  800296:	8b 02                	mov    (%edx),%eax
  800298:	99                   	cltd   
  800299:	c3                   	ret    
		return va_arg(*ap, long long);
  80029a:	8b 10                	mov    (%eax),%edx
  80029c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80029f:	89 08                	mov    %ecx,(%eax)
  8002a1:	8b 02                	mov    (%edx),%eax
  8002a3:	8b 52 04             	mov    0x4(%edx),%edx
  8002a6:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002a7:	8b 10                	mov    (%eax),%edx
  8002a9:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ac:	89 08                	mov    %ecx,(%eax)
  8002ae:	8b 02                	mov    (%edx),%eax
  8002b0:	99                   	cltd   
}
  8002b1:	c3                   	ret    

008002b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b2:	f3 0f 1e fb          	endbr32 
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c0:	8b 10                	mov    (%eax),%edx
  8002c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c5:	73 0a                	jae    8002d1 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ca:	89 08                	mov    %ecx,(%eax)
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	88 02                	mov    %al,(%edx)
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <printfmt>:
{
  8002d3:	f3 0f 1e fb          	endbr32 
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e0:	50                   	push   %eax
  8002e1:	ff 75 10             	pushl  0x10(%ebp)
  8002e4:	ff 75 0c             	pushl  0xc(%ebp)
  8002e7:	ff 75 08             	pushl  0x8(%ebp)
  8002ea:	e8 05 00 00 00       	call   8002f4 <vprintfmt>
}
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <vprintfmt>:
{
  8002f4:	f3 0f 1e fb          	endbr32 
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
  8002fe:	83 ec 2c             	sub    $0x2c,%esp
  800301:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800304:	8b 75 0c             	mov    0xc(%ebp),%esi
  800307:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030a:	e9 86 02 00 00       	jmp    800595 <vprintfmt+0x2a1>
		padc = ' ';
  80030f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800313:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80031a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800321:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800328:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8d 47 01             	lea    0x1(%edi),%eax
  800330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800333:	0f b6 17             	movzbl (%edi),%edx
  800336:	8d 42 dd             	lea    -0x23(%edx),%eax
  800339:	3c 55                	cmp    $0x55,%al
  80033b:	0f 87 df 02 00 00    	ja     800620 <vprintfmt+0x32c>
  800341:	0f b6 c0             	movzbl %al,%eax
  800344:	3e ff 24 85 40 20 80 	notrack jmp *0x802040(,%eax,4)
  80034b:	00 
  80034c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800353:	eb d8                	jmp    80032d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800358:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80035c:	eb cf                	jmp    80032d <vprintfmt+0x39>
  80035e:	0f b6 d2             	movzbl %dl,%edx
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800373:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	83 f9 09             	cmp    $0x9,%ecx
  80037c:	77 52                	ja     8003d0 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80037e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800381:	eb e9                	jmp    80036c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800383:	8b 45 14             	mov    0x14(%ebp),%eax
  800386:	8d 50 04             	lea    0x4(%eax),%edx
  800389:	89 55 14             	mov    %edx,0x14(%ebp)
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800394:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800398:	79 93                	jns    80032d <vprintfmt+0x39>
				width = precision, precision = -1;
  80039a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a7:	eb 84                	jmp    80032d <vprintfmt+0x39>
  8003a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ac:	85 c0                	test   %eax,%eax
  8003ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b3:	0f 49 d0             	cmovns %eax,%edx
  8003b6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bc:	e9 6c ff ff ff       	jmp    80032d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003cb:	e9 5d ff ff ff       	jmp    80032d <vprintfmt+0x39>
  8003d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d6:	eb bc                	jmp    800394 <vprintfmt+0xa0>
			lflag++;
  8003d8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003de:	e9 4a ff ff ff       	jmp    80032d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e6:	8d 50 04             	lea    0x4(%eax),%edx
  8003e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	56                   	push   %esi
  8003f0:	ff 30                	pushl  (%eax)
  8003f2:	ff d3                	call   *%ebx
			break;
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	e9 96 01 00 00       	jmp    800592 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	8d 50 04             	lea    0x4(%eax),%edx
  800402:	89 55 14             	mov    %edx,0x14(%ebp)
  800405:	8b 00                	mov    (%eax),%eax
  800407:	99                   	cltd   
  800408:	31 d0                	xor    %edx,%eax
  80040a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040c:	83 f8 0f             	cmp    $0xf,%eax
  80040f:	7f 20                	jg     800431 <vprintfmt+0x13d>
  800411:	8b 14 85 a0 21 80 00 	mov    0x8021a0(,%eax,4),%edx
  800418:	85 d2                	test   %edx,%edx
  80041a:	74 15                	je     800431 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80041c:	52                   	push   %edx
  80041d:	68 1b 23 80 00       	push   $0x80231b
  800422:	56                   	push   %esi
  800423:	53                   	push   %ebx
  800424:	e8 aa fe ff ff       	call   8002d3 <printfmt>
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	e9 61 01 00 00       	jmp    800592 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800431:	50                   	push   %eax
  800432:	68 1e 1f 80 00       	push   $0x801f1e
  800437:	56                   	push   %esi
  800438:	53                   	push   %ebx
  800439:	e8 95 fe ff ff       	call   8002d3 <printfmt>
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	e9 4c 01 00 00       	jmp    800592 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8d 50 04             	lea    0x4(%eax),%edx
  80044c:	89 55 14             	mov    %edx,0x14(%ebp)
  80044f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800451:	85 c9                	test   %ecx,%ecx
  800453:	b8 17 1f 80 00       	mov    $0x801f17,%eax
  800458:	0f 45 c1             	cmovne %ecx,%eax
  80045b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80045e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800462:	7e 06                	jle    80046a <vprintfmt+0x176>
  800464:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800468:	75 0d                	jne    800477 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80046d:	89 c7                	mov    %eax,%edi
  80046f:	03 45 e0             	add    -0x20(%ebp),%eax
  800472:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800475:	eb 57                	jmp    8004ce <vprintfmt+0x1da>
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	ff 75 d8             	pushl  -0x28(%ebp)
  80047d:	ff 75 cc             	pushl  -0x34(%ebp)
  800480:	e8 4f 02 00 00       	call   8006d4 <strnlen>
  800485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800488:	29 c2                	sub    %eax,%edx
  80048a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80048d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800490:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800494:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800497:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	85 db                	test   %ebx,%ebx
  80049b:	7e 10                	jle    8004ad <vprintfmt+0x1b9>
					putch(padc, putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	56                   	push   %esi
  8004a1:	57                   	push   %edi
  8004a2:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	eb ec                	jmp    800499 <vprintfmt+0x1a5>
  8004ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b3:	85 d2                	test   %edx,%edx
  8004b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ba:	0f 49 c2             	cmovns %edx,%eax
  8004bd:	29 c2                	sub    %eax,%edx
  8004bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c2:	eb a6                	jmp    80046a <vprintfmt+0x176>
					putch(ch, putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	56                   	push   %esi
  8004c8:	52                   	push   %edx
  8004c9:	ff d3                	call   *%ebx
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d3:	83 c7 01             	add    $0x1,%edi
  8004d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004da:	0f be d0             	movsbl %al,%edx
  8004dd:	85 d2                	test   %edx,%edx
  8004df:	74 42                	je     800523 <vprintfmt+0x22f>
  8004e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e5:	78 06                	js     8004ed <vprintfmt+0x1f9>
  8004e7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004eb:	78 1e                	js     80050b <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f1:	74 d1                	je     8004c4 <vprintfmt+0x1d0>
  8004f3:	0f be c0             	movsbl %al,%eax
  8004f6:	83 e8 20             	sub    $0x20,%eax
  8004f9:	83 f8 5e             	cmp    $0x5e,%eax
  8004fc:	76 c6                	jbe    8004c4 <vprintfmt+0x1d0>
					putch('?', putdat);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	56                   	push   %esi
  800502:	6a 3f                	push   $0x3f
  800504:	ff d3                	call   *%ebx
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	eb c3                	jmp    8004ce <vprintfmt+0x1da>
  80050b:	89 cf                	mov    %ecx,%edi
  80050d:	eb 0e                	jmp    80051d <vprintfmt+0x229>
				putch(' ', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	56                   	push   %esi
  800513:	6a 20                	push   $0x20
  800515:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800517:	83 ef 01             	sub    $0x1,%edi
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	85 ff                	test   %edi,%edi
  80051f:	7f ee                	jg     80050f <vprintfmt+0x21b>
  800521:	eb 6f                	jmp    800592 <vprintfmt+0x29e>
  800523:	89 cf                	mov    %ecx,%edi
  800525:	eb f6                	jmp    80051d <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800527:	89 ca                	mov    %ecx,%edx
  800529:	8d 45 14             	lea    0x14(%ebp),%eax
  80052c:	e8 55 fd ff ff       	call   800286 <getint>
  800531:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800534:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800537:	85 d2                	test   %edx,%edx
  800539:	78 0b                	js     800546 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80053b:	89 d1                	mov    %edx,%ecx
  80053d:	89 c2                	mov    %eax,%edx
			base = 10;
  80053f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800544:	eb 32                	jmp    800578 <vprintfmt+0x284>
				putch('-', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	56                   	push   %esi
  80054a:	6a 2d                	push   $0x2d
  80054c:	ff d3                	call   *%ebx
				num = -(long long) num;
  80054e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800551:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800554:	f7 da                	neg    %edx
  800556:	83 d1 00             	adc    $0x0,%ecx
  800559:	f7 d9                	neg    %ecx
  80055b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800563:	eb 13                	jmp    800578 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800565:	89 ca                	mov    %ecx,%edx
  800567:	8d 45 14             	lea    0x14(%ebp),%eax
  80056a:	e8 e3 fc ff ff       	call   800252 <getuint>
  80056f:	89 d1                	mov    %edx,%ecx
  800571:	89 c2                	mov    %eax,%edx
			base = 10;
  800573:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800578:	83 ec 0c             	sub    $0xc,%esp
  80057b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80057f:	57                   	push   %edi
  800580:	ff 75 e0             	pushl  -0x20(%ebp)
  800583:	50                   	push   %eax
  800584:	51                   	push   %ecx
  800585:	52                   	push   %edx
  800586:	89 f2                	mov    %esi,%edx
  800588:	89 d8                	mov    %ebx,%eax
  80058a:	e8 1a fc ff ff       	call   8001a9 <printnum>
			break;
  80058f:	83 c4 20             	add    $0x20,%esp
{
  800592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800595:	83 c7 01             	add    $0x1,%edi
  800598:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059c:	83 f8 25             	cmp    $0x25,%eax
  80059f:	0f 84 6a fd ff ff    	je     80030f <vprintfmt+0x1b>
			if (ch == '\0')
  8005a5:	85 c0                	test   %eax,%eax
  8005a7:	0f 84 93 00 00 00    	je     800640 <vprintfmt+0x34c>
			putch(ch, putdat);
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	56                   	push   %esi
  8005b1:	50                   	push   %eax
  8005b2:	ff d3                	call   *%ebx
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	eb dc                	jmp    800595 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005b9:	89 ca                	mov    %ecx,%edx
  8005bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8005be:	e8 8f fc ff ff       	call   800252 <getuint>
  8005c3:	89 d1                	mov    %edx,%ecx
  8005c5:	89 c2                	mov    %eax,%edx
			base = 8;
  8005c7:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005cc:	eb aa                	jmp    800578 <vprintfmt+0x284>
			putch('0', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	56                   	push   %esi
  8005d2:	6a 30                	push   $0x30
  8005d4:	ff d3                	call   *%ebx
			putch('x', putdat);
  8005d6:	83 c4 08             	add    $0x8,%esp
  8005d9:	56                   	push   %esi
  8005da:	6a 78                	push   $0x78
  8005dc:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 50 04             	lea    0x4(%eax),%edx
  8005e4:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8005e7:	8b 10                	mov    (%eax),%edx
  8005e9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ee:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8005f1:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8005f6:	eb 80                	jmp    800578 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005f8:	89 ca                	mov    %ecx,%edx
  8005fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fd:	e8 50 fc ff ff       	call   800252 <getuint>
  800602:	89 d1                	mov    %edx,%ecx
  800604:	89 c2                	mov    %eax,%edx
			base = 16;
  800606:	b8 10 00 00 00       	mov    $0x10,%eax
  80060b:	e9 68 ff ff ff       	jmp    800578 <vprintfmt+0x284>
			putch(ch, putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	56                   	push   %esi
  800614:	6a 25                	push   $0x25
  800616:	ff d3                	call   *%ebx
			break;
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	e9 72 ff ff ff       	jmp    800592 <vprintfmt+0x29e>
			putch('%', putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	56                   	push   %esi
  800624:	6a 25                	push   $0x25
  800626:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 f8                	mov    %edi,%eax
  80062d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800631:	74 05                	je     800638 <vprintfmt+0x344>
  800633:	83 e8 01             	sub    $0x1,%eax
  800636:	eb f5                	jmp    80062d <vprintfmt+0x339>
  800638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063b:	e9 52 ff ff ff       	jmp    800592 <vprintfmt+0x29e>
}
  800640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800643:	5b                   	pop    %ebx
  800644:	5e                   	pop    %esi
  800645:	5f                   	pop    %edi
  800646:	5d                   	pop    %ebp
  800647:	c3                   	ret    

00800648 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800648:	f3 0f 1e fb          	endbr32 
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	83 ec 18             	sub    $0x18,%esp
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800658:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80065b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80065f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800669:	85 c0                	test   %eax,%eax
  80066b:	74 26                	je     800693 <vsnprintf+0x4b>
  80066d:	85 d2                	test   %edx,%edx
  80066f:	7e 22                	jle    800693 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800671:	ff 75 14             	pushl  0x14(%ebp)
  800674:	ff 75 10             	pushl  0x10(%ebp)
  800677:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80067a:	50                   	push   %eax
  80067b:	68 b2 02 80 00       	push   $0x8002b2
  800680:	e8 6f fc ff ff       	call   8002f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800688:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80068b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068e:	83 c4 10             	add    $0x10,%esp
}
  800691:	c9                   	leave  
  800692:	c3                   	ret    
		return -E_INVAL;
  800693:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800698:	eb f7                	jmp    800691 <vsnprintf+0x49>

0080069a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80069a:	f3 0f 1e fb          	endbr32 
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006a7:	50                   	push   %eax
  8006a8:	ff 75 10             	pushl  0x10(%ebp)
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 08             	pushl  0x8(%ebp)
  8006b1:	e8 92 ff ff ff       	call   800648 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006b8:	f3 0f 1e fb          	endbr32 
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006cb:	74 05                	je     8006d2 <strlen+0x1a>
		n++;
  8006cd:	83 c0 01             	add    $0x1,%eax
  8006d0:	eb f5                	jmp    8006c7 <strlen+0xf>
	return n;
}
  8006d2:	5d                   	pop    %ebp
  8006d3:	c3                   	ret    

008006d4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006d4:	f3 0f 1e fb          	endbr32 
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e6:	39 d0                	cmp    %edx,%eax
  8006e8:	74 0d                	je     8006f7 <strnlen+0x23>
  8006ea:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8006ee:	74 05                	je     8006f5 <strnlen+0x21>
		n++;
  8006f0:	83 c0 01             	add    $0x1,%eax
  8006f3:	eb f1                	jmp    8006e6 <strnlen+0x12>
  8006f5:	89 c2                	mov    %eax,%edx
	return n;
}
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	5d                   	pop    %ebp
  8006fa:	c3                   	ret    

008006fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006fb:	f3 0f 1e fb          	endbr32 
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	53                   	push   %ebx
  800703:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800706:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800709:	b8 00 00 00 00       	mov    $0x0,%eax
  80070e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800712:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800715:	83 c0 01             	add    $0x1,%eax
  800718:	84 d2                	test   %dl,%dl
  80071a:	75 f2                	jne    80070e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80071c:	89 c8                	mov    %ecx,%eax
  80071e:	5b                   	pop    %ebx
  80071f:	5d                   	pop    %ebp
  800720:	c3                   	ret    

00800721 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800721:	f3 0f 1e fb          	endbr32 
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	53                   	push   %ebx
  800729:	83 ec 10             	sub    $0x10,%esp
  80072c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80072f:	53                   	push   %ebx
  800730:	e8 83 ff ff ff       	call   8006b8 <strlen>
  800735:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	01 d8                	add    %ebx,%eax
  80073d:	50                   	push   %eax
  80073e:	e8 b8 ff ff ff       	call   8006fb <strcpy>
	return dst;
}
  800743:	89 d8                	mov    %ebx,%eax
  800745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80074a:	f3 0f 1e fb          	endbr32 
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	56                   	push   %esi
  800752:	53                   	push   %ebx
  800753:	8b 75 08             	mov    0x8(%ebp),%esi
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
  800759:	89 f3                	mov    %esi,%ebx
  80075b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80075e:	89 f0                	mov    %esi,%eax
  800760:	39 d8                	cmp    %ebx,%eax
  800762:	74 11                	je     800775 <strncpy+0x2b>
		*dst++ = *src;
  800764:	83 c0 01             	add    $0x1,%eax
  800767:	0f b6 0a             	movzbl (%edx),%ecx
  80076a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80076d:	80 f9 01             	cmp    $0x1,%cl
  800770:	83 da ff             	sbb    $0xffffffff,%edx
  800773:	eb eb                	jmp    800760 <strncpy+0x16>
	}
	return ret;
}
  800775:	89 f0                	mov    %esi,%eax
  800777:	5b                   	pop    %ebx
  800778:	5e                   	pop    %esi
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    

0080077b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80077b:	f3 0f 1e fb          	endbr32 
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	8b 75 08             	mov    0x8(%ebp),%esi
  800787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078a:	8b 55 10             	mov    0x10(%ebp),%edx
  80078d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80078f:	85 d2                	test   %edx,%edx
  800791:	74 21                	je     8007b4 <strlcpy+0x39>
  800793:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800797:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800799:	39 c2                	cmp    %eax,%edx
  80079b:	74 14                	je     8007b1 <strlcpy+0x36>
  80079d:	0f b6 19             	movzbl (%ecx),%ebx
  8007a0:	84 db                	test   %bl,%bl
  8007a2:	74 0b                	je     8007af <strlcpy+0x34>
			*dst++ = *src++;
  8007a4:	83 c1 01             	add    $0x1,%ecx
  8007a7:	83 c2 01             	add    $0x1,%edx
  8007aa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ad:	eb ea                	jmp    800799 <strlcpy+0x1e>
  8007af:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007b4:	29 f0                	sub    %esi,%eax
}
  8007b6:	5b                   	pop    %ebx
  8007b7:	5e                   	pop    %esi
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007ba:	f3 0f 1e fb          	endbr32 
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007c7:	0f b6 01             	movzbl (%ecx),%eax
  8007ca:	84 c0                	test   %al,%al
  8007cc:	74 0c                	je     8007da <strcmp+0x20>
  8007ce:	3a 02                	cmp    (%edx),%al
  8007d0:	75 08                	jne    8007da <strcmp+0x20>
		p++, q++;
  8007d2:	83 c1 01             	add    $0x1,%ecx
  8007d5:	83 c2 01             	add    $0x1,%edx
  8007d8:	eb ed                	jmp    8007c7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007da:	0f b6 c0             	movzbl %al,%eax
  8007dd:	0f b6 12             	movzbl (%edx),%edx
  8007e0:	29 d0                	sub    %edx,%eax
}
  8007e2:	5d                   	pop    %ebp
  8007e3:	c3                   	ret    

008007e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007e4:	f3 0f 1e fb          	endbr32 
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	53                   	push   %ebx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f2:	89 c3                	mov    %eax,%ebx
  8007f4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007f7:	eb 06                	jmp    8007ff <strncmp+0x1b>
		n--, p++, q++;
  8007f9:	83 c0 01             	add    $0x1,%eax
  8007fc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8007ff:	39 d8                	cmp    %ebx,%eax
  800801:	74 16                	je     800819 <strncmp+0x35>
  800803:	0f b6 08             	movzbl (%eax),%ecx
  800806:	84 c9                	test   %cl,%cl
  800808:	74 04                	je     80080e <strncmp+0x2a>
  80080a:	3a 0a                	cmp    (%edx),%cl
  80080c:	74 eb                	je     8007f9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80080e:	0f b6 00             	movzbl (%eax),%eax
  800811:	0f b6 12             	movzbl (%edx),%edx
  800814:	29 d0                	sub    %edx,%eax
}
  800816:	5b                   	pop    %ebx
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    
		return 0;
  800819:	b8 00 00 00 00       	mov    $0x0,%eax
  80081e:	eb f6                	jmp    800816 <strncmp+0x32>

00800820 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80082e:	0f b6 10             	movzbl (%eax),%edx
  800831:	84 d2                	test   %dl,%dl
  800833:	74 09                	je     80083e <strchr+0x1e>
		if (*s == c)
  800835:	38 ca                	cmp    %cl,%dl
  800837:	74 0a                	je     800843 <strchr+0x23>
	for (; *s; s++)
  800839:	83 c0 01             	add    $0x1,%eax
  80083c:	eb f0                	jmp    80082e <strchr+0xe>
			return (char *) s;
	return 0;
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800845:	f3 0f 1e fb          	endbr32 
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800853:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800856:	38 ca                	cmp    %cl,%dl
  800858:	74 09                	je     800863 <strfind+0x1e>
  80085a:	84 d2                	test   %dl,%dl
  80085c:	74 05                	je     800863 <strfind+0x1e>
	for (; *s; s++)
  80085e:	83 c0 01             	add    $0x1,%eax
  800861:	eb f0                	jmp    800853 <strfind+0xe>
			break;
	return (char *) s;
}
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800865:	f3 0f 1e fb          	endbr32 
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	57                   	push   %edi
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 55 08             	mov    0x8(%ebp),%edx
  800872:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800875:	85 c9                	test   %ecx,%ecx
  800877:	74 33                	je     8008ac <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800879:	89 d0                	mov    %edx,%eax
  80087b:	09 c8                	or     %ecx,%eax
  80087d:	a8 03                	test   $0x3,%al
  80087f:	75 23                	jne    8008a4 <memset+0x3f>
		c &= 0xFF;
  800881:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800885:	89 d8                	mov    %ebx,%eax
  800887:	c1 e0 08             	shl    $0x8,%eax
  80088a:	89 df                	mov    %ebx,%edi
  80088c:	c1 e7 18             	shl    $0x18,%edi
  80088f:	89 de                	mov    %ebx,%esi
  800891:	c1 e6 10             	shl    $0x10,%esi
  800894:	09 f7                	or     %esi,%edi
  800896:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800898:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80089b:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80089d:	89 d7                	mov    %edx,%edi
  80089f:	fc                   	cld    
  8008a0:	f3 ab                	rep stos %eax,%es:(%edi)
  8008a2:	eb 08                	jmp    8008ac <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a4:	89 d7                	mov    %edx,%edi
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	fc                   	cld    
  8008aa:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008ac:	89 d0                	mov    %edx,%eax
  8008ae:	5b                   	pop    %ebx
  8008af:	5e                   	pop    %esi
  8008b0:	5f                   	pop    %edi
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008b3:	f3 0f 1e fb          	endbr32 
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	57                   	push   %edi
  8008bb:	56                   	push   %esi
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008c5:	39 c6                	cmp    %eax,%esi
  8008c7:	73 32                	jae    8008fb <memmove+0x48>
  8008c9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008cc:	39 c2                	cmp    %eax,%edx
  8008ce:	76 2b                	jbe    8008fb <memmove+0x48>
		s += n;
		d += n;
  8008d0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d3:	89 fe                	mov    %edi,%esi
  8008d5:	09 ce                	or     %ecx,%esi
  8008d7:	09 d6                	or     %edx,%esi
  8008d9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008df:	75 0e                	jne    8008ef <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008e1:	83 ef 04             	sub    $0x4,%edi
  8008e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008e7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008ea:	fd                   	std    
  8008eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008ed:	eb 09                	jmp    8008f8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008ef:	83 ef 01             	sub    $0x1,%edi
  8008f2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008f5:	fd                   	std    
  8008f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008f8:	fc                   	cld    
  8008f9:	eb 1a                	jmp    800915 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008fb:	89 c2                	mov    %eax,%edx
  8008fd:	09 ca                	or     %ecx,%edx
  8008ff:	09 f2                	or     %esi,%edx
  800901:	f6 c2 03             	test   $0x3,%dl
  800904:	75 0a                	jne    800910 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800906:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800909:	89 c7                	mov    %eax,%edi
  80090b:	fc                   	cld    
  80090c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090e:	eb 05                	jmp    800915 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800910:	89 c7                	mov    %eax,%edi
  800912:	fc                   	cld    
  800913:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800919:	f3 0f 1e fb          	endbr32 
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800923:	ff 75 10             	pushl  0x10(%ebp)
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	e8 82 ff ff ff       	call   8008b3 <memmove>
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800933:	f3 0f 1e fb          	endbr32 
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	56                   	push   %esi
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800942:	89 c6                	mov    %eax,%esi
  800944:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800947:	39 f0                	cmp    %esi,%eax
  800949:	74 1c                	je     800967 <memcmp+0x34>
		if (*s1 != *s2)
  80094b:	0f b6 08             	movzbl (%eax),%ecx
  80094e:	0f b6 1a             	movzbl (%edx),%ebx
  800951:	38 d9                	cmp    %bl,%cl
  800953:	75 08                	jne    80095d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	eb ea                	jmp    800947 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80095d:	0f b6 c1             	movzbl %cl,%eax
  800960:	0f b6 db             	movzbl %bl,%ebx
  800963:	29 d8                	sub    %ebx,%eax
  800965:	eb 05                	jmp    80096c <memcmp+0x39>
	}

	return 0;
  800967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096c:	5b                   	pop    %ebx
  80096d:	5e                   	pop    %esi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800970:	f3 0f 1e fb          	endbr32 
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800982:	39 d0                	cmp    %edx,%eax
  800984:	73 09                	jae    80098f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800986:	38 08                	cmp    %cl,(%eax)
  800988:	74 05                	je     80098f <memfind+0x1f>
	for (; s < ends; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	eb f3                	jmp    800982 <memfind+0x12>
			break;
	return (void *) s;
}
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800991:	f3 0f 1e fb          	endbr32 
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	57                   	push   %edi
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a1:	eb 03                	jmp    8009a6 <strtol+0x15>
		s++;
  8009a3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009a6:	0f b6 01             	movzbl (%ecx),%eax
  8009a9:	3c 20                	cmp    $0x20,%al
  8009ab:	74 f6                	je     8009a3 <strtol+0x12>
  8009ad:	3c 09                	cmp    $0x9,%al
  8009af:	74 f2                	je     8009a3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009b1:	3c 2b                	cmp    $0x2b,%al
  8009b3:	74 2a                	je     8009df <strtol+0x4e>
	int neg = 0;
  8009b5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009ba:	3c 2d                	cmp    $0x2d,%al
  8009bc:	74 2b                	je     8009e9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009be:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009c4:	75 0f                	jne    8009d5 <strtol+0x44>
  8009c6:	80 39 30             	cmpb   $0x30,(%ecx)
  8009c9:	74 28                	je     8009f3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009cb:	85 db                	test   %ebx,%ebx
  8009cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d2:	0f 44 d8             	cmove  %eax,%ebx
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009dd:	eb 46                	jmp    800a25 <strtol+0x94>
		s++;
  8009df:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e7:	eb d5                	jmp    8009be <strtol+0x2d>
		s++, neg = 1;
  8009e9:	83 c1 01             	add    $0x1,%ecx
  8009ec:	bf 01 00 00 00       	mov    $0x1,%edi
  8009f1:	eb cb                	jmp    8009be <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009f7:	74 0e                	je     800a07 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8009f9:	85 db                	test   %ebx,%ebx
  8009fb:	75 d8                	jne    8009d5 <strtol+0x44>
		s++, base = 8;
  8009fd:	83 c1 01             	add    $0x1,%ecx
  800a00:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a05:	eb ce                	jmp    8009d5 <strtol+0x44>
		s += 2, base = 16;
  800a07:	83 c1 02             	add    $0x2,%ecx
  800a0a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a0f:	eb c4                	jmp    8009d5 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a11:	0f be d2             	movsbl %dl,%edx
  800a14:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a17:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a1a:	7d 3a                	jge    800a56 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a1c:	83 c1 01             	add    $0x1,%ecx
  800a1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a25:	0f b6 11             	movzbl (%ecx),%edx
  800a28:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a2b:	89 f3                	mov    %esi,%ebx
  800a2d:	80 fb 09             	cmp    $0x9,%bl
  800a30:	76 df                	jbe    800a11 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a32:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a35:	89 f3                	mov    %esi,%ebx
  800a37:	80 fb 19             	cmp    $0x19,%bl
  800a3a:	77 08                	ja     800a44 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a3c:	0f be d2             	movsbl %dl,%edx
  800a3f:	83 ea 57             	sub    $0x57,%edx
  800a42:	eb d3                	jmp    800a17 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a44:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a47:	89 f3                	mov    %esi,%ebx
  800a49:	80 fb 19             	cmp    $0x19,%bl
  800a4c:	77 08                	ja     800a56 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a4e:	0f be d2             	movsbl %dl,%edx
  800a51:	83 ea 37             	sub    $0x37,%edx
  800a54:	eb c1                	jmp    800a17 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5a:	74 05                	je     800a61 <strtol+0xd0>
		*endptr = (char *) s;
  800a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	f7 da                	neg    %edx
  800a65:	85 ff                	test   %edi,%edi
  800a67:	0f 45 c2             	cmovne %edx,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5f                   	pop    %edi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	83 ec 1c             	sub    $0x1c,%esp
  800a78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a86:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a89:	8b 75 14             	mov    0x14(%ebp),%esi
  800a8c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a92:	74 04                	je     800a98 <syscall+0x29>
  800a94:	85 c0                	test   %eax,%eax
  800a96:	7f 08                	jg     800aa0 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800aa0:	83 ec 0c             	sub    $0xc,%esp
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 e0             	pushl  -0x20(%ebp)
  800aa7:	68 ff 21 80 00       	push   $0x8021ff
  800aac:	6a 23                	push   $0x23
  800aae:	68 1c 22 80 00       	push   $0x80221c
  800ab3:	e8 33 10 00 00       	call   801aeb <_panic>

00800ab8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ac2:	6a 00                	push   $0x0
  800ac4:	6a 00                	push   $0x0
  800ac6:	6a 00                	push   $0x0
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ace:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad8:	e8 92 ff ff ff       	call   800a6f <syscall>
}
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae2:	f3 0f 1e fb          	endbr32 
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aec:	6a 00                	push   $0x0
  800aee:	6a 00                	push   $0x0
  800af0:	6a 00                	push   $0x0
  800af2:	6a 00                	push   $0x0
  800af4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
  800afe:	b8 01 00 00 00       	mov    $0x1,%eax
  800b03:	e8 67 ff ff ff       	call   800a6f <syscall>
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b0a:	f3 0f 1e fb          	endbr32 
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b14:	6a 00                	push   $0x0
  800b16:	6a 00                	push   $0x0
  800b18:	6a 00                	push   $0x0
  800b1a:	6a 00                	push   $0x0
  800b1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1f:	ba 01 00 00 00       	mov    $0x1,%edx
  800b24:	b8 03 00 00 00       	mov    $0x3,%eax
  800b29:	e8 41 ff ff ff       	call   800a6f <syscall>
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b30:	f3 0f 1e fb          	endbr32 
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b3a:	6a 00                	push   $0x0
  800b3c:	6a 00                	push   $0x0
  800b3e:	6a 00                	push   $0x0
  800b40:	6a 00                	push   $0x0
  800b42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b47:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b51:	e8 19 ff ff ff       	call   800a6f <syscall>
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <sys_yield>:

void
sys_yield(void)
{
  800b58:	f3 0f 1e fb          	endbr32 
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b62:	6a 00                	push   $0x0
  800b64:	6a 00                	push   $0x0
  800b66:	6a 00                	push   $0x0
  800b68:	6a 00                	push   $0x0
  800b6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b79:	e8 f1 fe ff ff       	call   800a6f <syscall>
}
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b83:	f3 0f 1e fb          	endbr32 
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b8d:	6a 00                	push   $0x0
  800b8f:	6a 00                	push   $0x0
  800b91:	ff 75 10             	pushl  0x10(%ebp)
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9a:	ba 01 00 00 00       	mov    $0x1,%edx
  800b9f:	b8 04 00 00 00       	mov    $0x4,%eax
  800ba4:	e8 c6 fe ff ff       	call   800a6f <syscall>
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bab:	f3 0f 1e fb          	endbr32 
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bb5:	ff 75 18             	pushl  0x18(%ebp)
  800bb8:	ff 75 14             	pushl  0x14(%ebp)
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc4:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800bce:	e8 9c fe ff ff       	call   800a6f <syscall>
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bd5:	f3 0f 1e fb          	endbr32 
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bdf:	6a 00                	push   $0x0
  800be1:	6a 00                	push   $0x0
  800be3:	6a 00                	push   $0x0
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800beb:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf0:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf5:	e8 75 fe ff ff       	call   800a6f <syscall>
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bfc:	f3 0f 1e fb          	endbr32 
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c06:	6a 00                	push   $0x0
  800c08:	6a 00                	push   $0x0
  800c0a:	6a 00                	push   $0x0
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	ba 01 00 00 00       	mov    $0x1,%edx
  800c17:	b8 08 00 00 00       	mov    $0x8,%eax
  800c1c:	e8 4e fe ff ff       	call   800a6f <syscall>
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c23:	f3 0f 1e fb          	endbr32 
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c2d:	6a 00                	push   $0x0
  800c2f:	6a 00                	push   $0x0
  800c31:	6a 00                	push   $0x0
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c39:	ba 01 00 00 00       	mov    $0x1,%edx
  800c3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800c43:	e8 27 fe ff ff       	call   800a6f <syscall>
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c54:	6a 00                	push   $0x0
  800c56:	6a 00                	push   $0x0
  800c58:	6a 00                	push   $0x0
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c60:	ba 01 00 00 00       	mov    $0x1,%edx
  800c65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6a:	e8 00 fe ff ff       	call   800a6f <syscall>
}
  800c6f:	c9                   	leave  
  800c70:	c3                   	ret    

00800c71 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c71:	f3 0f 1e fb          	endbr32 
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c7b:	6a 00                	push   $0x0
  800c7d:	ff 75 14             	pushl  0x14(%ebp)
  800c80:	ff 75 10             	pushl  0x10(%ebp)
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c93:	e8 d7 fd ff ff       	call   800a6f <syscall>
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c9a:	f3 0f 1e fb          	endbr32 
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ca4:	6a 00                	push   $0x0
  800ca6:	6a 00                	push   $0x0
  800ca8:	6a 00                	push   $0x0
  800caa:	6a 00                	push   $0x0
  800cac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caf:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cb9:	e8 b1 fd ff ff       	call   800a6f <syscall>
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800cc0:	f3 0f 1e fb          	endbr32 
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800cca:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800cd1:	74 0a                	je     800cdd <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  800cdd:	a1 04 40 80 00       	mov    0x804004,%eax
  800ce2:	8b 40 48             	mov    0x48(%eax),%eax
  800ce5:	83 ec 04             	sub    $0x4,%esp
  800ce8:	6a 07                	push   $0x7
  800cea:	68 00 f0 bf ee       	push   $0xeebff000
  800cef:	50                   	push   %eax
  800cf0:	e8 8e fe ff ff       	call   800b83 <sys_page_alloc>
		if (r!= 0)
  800cf5:	83 c4 10             	add    $0x10,%esp
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	75 2f                	jne    800d2b <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800cfc:	a1 04 40 80 00       	mov    0x804004,%eax
  800d01:	8b 40 48             	mov    0x48(%eax),%eax
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	68 3d 0d 80 00       	push   $0x800d3d
  800d0c:	50                   	push   %eax
  800d0d:	e8 38 ff ff ff       	call   800c4a <sys_env_set_pgfault_upcall>
		if (r!= 0)
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	85 c0                	test   %eax,%eax
  800d17:	74 ba                	je     800cd3 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  800d19:	50                   	push   %eax
  800d1a:	68 2a 22 80 00       	push   $0x80222a
  800d1f:	6a 26                	push   $0x26
  800d21:	68 42 22 80 00       	push   $0x802242
  800d26:	e8 c0 0d 00 00       	call   801aeb <_panic>
			panic("set_pgfault_handler: %e", r);
  800d2b:	50                   	push   %eax
  800d2c:	68 2a 22 80 00       	push   $0x80222a
  800d31:	6a 22                	push   $0x22
  800d33:	68 42 22 80 00       	push   $0x802242
  800d38:	e8 ae 0d 00 00       	call   801aeb <_panic>

00800d3d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800d3d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800d3e:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800d43:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800d45:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  800d48:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  800d4c:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  800d4f:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  800d53:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  800d57:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800d59:	83 c4 08             	add    $0x8,%esp
	popal
  800d5c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800d5d:	83 c4 04             	add    $0x4,%esp
	popfl
  800d60:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800d61:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800d62:	c3                   	ret    

00800d63 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d63:	f3 0f 1e fb          	endbr32 
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	05 00 00 00 30       	add    $0x30000000,%eax
  800d72:	c1 e8 0c             	shr    $0xc,%eax
}
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d77:	f3 0f 1e fb          	endbr32 
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800d81:	ff 75 08             	pushl  0x8(%ebp)
  800d84:	e8 da ff ff ff       	call   800d63 <fd2num>
  800d89:	83 c4 10             	add    $0x10,%esp
  800d8c:	c1 e0 0c             	shl    $0xc,%eax
  800d8f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d96:	f3 0f 1e fb          	endbr32 
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800da2:	89 c2                	mov    %eax,%edx
  800da4:	c1 ea 16             	shr    $0x16,%edx
  800da7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dae:	f6 c2 01             	test   $0x1,%dl
  800db1:	74 2d                	je     800de0 <fd_alloc+0x4a>
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	c1 ea 0c             	shr    $0xc,%edx
  800db8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dbf:	f6 c2 01             	test   $0x1,%dl
  800dc2:	74 1c                	je     800de0 <fd_alloc+0x4a>
  800dc4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dc9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dce:	75 d2                	jne    800da2 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800dd9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dde:	eb 0a                	jmp    800dea <fd_alloc+0x54>
			*fd_store = fd;
  800de0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800df6:	83 f8 1f             	cmp    $0x1f,%eax
  800df9:	77 30                	ja     800e2b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dfb:	c1 e0 0c             	shl    $0xc,%eax
  800dfe:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e03:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e09:	f6 c2 01             	test   $0x1,%dl
  800e0c:	74 24                	je     800e32 <fd_lookup+0x46>
  800e0e:	89 c2                	mov    %eax,%edx
  800e10:	c1 ea 0c             	shr    $0xc,%edx
  800e13:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1a:	f6 c2 01             	test   $0x1,%dl
  800e1d:	74 1a                	je     800e39 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e22:	89 02                	mov    %eax,(%edx)
	return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    
		return -E_INVAL;
  800e2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e30:	eb f7                	jmp    800e29 <fd_lookup+0x3d>
		return -E_INVAL;
  800e32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e37:	eb f0                	jmp    800e29 <fd_lookup+0x3d>
  800e39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3e:	eb e9                	jmp    800e29 <fd_lookup+0x3d>

00800e40 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e40:	f3 0f 1e fb          	endbr32 
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4d:	ba cc 22 80 00       	mov    $0x8022cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e52:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e57:	39 08                	cmp    %ecx,(%eax)
  800e59:	74 33                	je     800e8e <dev_lookup+0x4e>
  800e5b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e5e:	8b 02                	mov    (%edx),%eax
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 f3                	jne    800e57 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e64:	a1 04 40 80 00       	mov    0x804004,%eax
  800e69:	8b 40 48             	mov    0x48(%eax),%eax
  800e6c:	83 ec 04             	sub    $0x4,%esp
  800e6f:	51                   	push   %ecx
  800e70:	50                   	push   %eax
  800e71:	68 50 22 80 00       	push   $0x802250
  800e76:	e8 16 f3 ff ff       	call   800191 <cprintf>
	*dev = 0;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    
			*dev = devtab[i];
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e93:	b8 00 00 00 00       	mov    $0x0,%eax
  800e98:	eb f2                	jmp    800e8c <dev_lookup+0x4c>

00800e9a <fd_close>:
{
  800e9a:	f3 0f 1e fb          	endbr32 
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 28             	sub    $0x28,%esp
  800ea7:	8b 75 08             	mov    0x8(%ebp),%esi
  800eaa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ead:	56                   	push   %esi
  800eae:	e8 b0 fe ff ff       	call   800d63 <fd2num>
  800eb3:	83 c4 08             	add    $0x8,%esp
  800eb6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800eb9:	52                   	push   %edx
  800eba:	50                   	push   %eax
  800ebb:	e8 2c ff ff ff       	call   800dec <fd_lookup>
  800ec0:	89 c3                	mov    %eax,%ebx
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	78 05                	js     800ece <fd_close+0x34>
	    || fd != fd2)
  800ec9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ecc:	74 16                	je     800ee4 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800ece:	89 f8                	mov    %edi,%eax
  800ed0:	84 c0                	test   %al,%al
  800ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed7:	0f 44 d8             	cmove  %eax,%ebx
}
  800eda:	89 d8                	mov    %ebx,%eax
  800edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800eea:	50                   	push   %eax
  800eeb:	ff 36                	pushl  (%esi)
  800eed:	e8 4e ff ff ff       	call   800e40 <dev_lookup>
  800ef2:	89 c3                	mov    %eax,%ebx
  800ef4:	83 c4 10             	add    $0x10,%esp
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	78 1a                	js     800f15 <fd_close+0x7b>
		if (dev->dev_close)
  800efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efe:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	74 0b                	je     800f15 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	56                   	push   %esi
  800f0e:	ff d0                	call   *%eax
  800f10:	89 c3                	mov    %eax,%ebx
  800f12:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	56                   	push   %esi
  800f19:	6a 00                	push   $0x0
  800f1b:	e8 b5 fc ff ff       	call   800bd5 <sys_page_unmap>
	return r;
  800f20:	83 c4 10             	add    $0x10,%esp
  800f23:	eb b5                	jmp    800eda <fd_close+0x40>

00800f25 <close>:

int
close(int fdnum)
{
  800f25:	f3 0f 1e fb          	endbr32 
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f32:	50                   	push   %eax
  800f33:	ff 75 08             	pushl  0x8(%ebp)
  800f36:	e8 b1 fe ff ff       	call   800dec <fd_lookup>
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	79 02                	jns    800f44 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    
		return fd_close(fd, 1);
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	6a 01                	push   $0x1
  800f49:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4c:	e8 49 ff ff ff       	call   800e9a <fd_close>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	eb ec                	jmp    800f42 <close+0x1d>

00800f56 <close_all>:

void
close_all(void)
{
  800f56:	f3 0f 1e fb          	endbr32 
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	53                   	push   %ebx
  800f6a:	e8 b6 ff ff ff       	call   800f25 <close>
	for (i = 0; i < MAXFD; i++)
  800f6f:	83 c3 01             	add    $0x1,%ebx
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	83 fb 20             	cmp    $0x20,%ebx
  800f78:	75 ec                	jne    800f66 <close_all+0x10>
}
  800f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f7f:	f3 0f 1e fb          	endbr32 
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	57                   	push   %edi
  800f87:	56                   	push   %esi
  800f88:	53                   	push   %ebx
  800f89:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f8c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f8f:	50                   	push   %eax
  800f90:	ff 75 08             	pushl  0x8(%ebp)
  800f93:	e8 54 fe ff ff       	call   800dec <fd_lookup>
  800f98:	89 c3                	mov    %eax,%ebx
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	0f 88 81 00 00 00    	js     801026 <dup+0xa7>
		return r;
	close(newfdnum);
  800fa5:	83 ec 0c             	sub    $0xc,%esp
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	e8 75 ff ff ff       	call   800f25 <close>

	newfd = INDEX2FD(newfdnum);
  800fb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb3:	c1 e6 0c             	shl    $0xc,%esi
  800fb6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fbc:	83 c4 04             	add    $0x4,%esp
  800fbf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc2:	e8 b0 fd ff ff       	call   800d77 <fd2data>
  800fc7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fc9:	89 34 24             	mov    %esi,(%esp)
  800fcc:	e8 a6 fd ff ff       	call   800d77 <fd2data>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fd6:	89 d8                	mov    %ebx,%eax
  800fd8:	c1 e8 16             	shr    $0x16,%eax
  800fdb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe2:	a8 01                	test   $0x1,%al
  800fe4:	74 11                	je     800ff7 <dup+0x78>
  800fe6:	89 d8                	mov    %ebx,%eax
  800fe8:	c1 e8 0c             	shr    $0xc,%eax
  800feb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff2:	f6 c2 01             	test   $0x1,%dl
  800ff5:	75 39                	jne    801030 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ff7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ffa:	89 d0                	mov    %edx,%eax
  800ffc:	c1 e8 0c             	shr    $0xc,%eax
  800fff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	25 07 0e 00 00       	and    $0xe07,%eax
  80100e:	50                   	push   %eax
  80100f:	56                   	push   %esi
  801010:	6a 00                	push   $0x0
  801012:	52                   	push   %edx
  801013:	6a 00                	push   $0x0
  801015:	e8 91 fb ff ff       	call   800bab <sys_page_map>
  80101a:	89 c3                	mov    %eax,%ebx
  80101c:	83 c4 20             	add    $0x20,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 31                	js     801054 <dup+0xd5>
		goto err;

	return newfdnum;
  801023:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801026:	89 d8                	mov    %ebx,%eax
  801028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801030:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	25 07 0e 00 00       	and    $0xe07,%eax
  80103f:	50                   	push   %eax
  801040:	57                   	push   %edi
  801041:	6a 00                	push   $0x0
  801043:	53                   	push   %ebx
  801044:	6a 00                	push   $0x0
  801046:	e8 60 fb ff ff       	call   800bab <sys_page_map>
  80104b:	89 c3                	mov    %eax,%ebx
  80104d:	83 c4 20             	add    $0x20,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	79 a3                	jns    800ff7 <dup+0x78>
	sys_page_unmap(0, newfd);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	56                   	push   %esi
  801058:	6a 00                	push   $0x0
  80105a:	e8 76 fb ff ff       	call   800bd5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80105f:	83 c4 08             	add    $0x8,%esp
  801062:	57                   	push   %edi
  801063:	6a 00                	push   $0x0
  801065:	e8 6b fb ff ff       	call   800bd5 <sys_page_unmap>
	return r;
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	eb b7                	jmp    801026 <dup+0xa7>

0080106f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80106f:	f3 0f 1e fb          	endbr32 
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	53                   	push   %ebx
  801077:	83 ec 1c             	sub    $0x1c,%esp
  80107a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80107d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801080:	50                   	push   %eax
  801081:	53                   	push   %ebx
  801082:	e8 65 fd ff ff       	call   800dec <fd_lookup>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 3f                	js     8010cd <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801094:	50                   	push   %eax
  801095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801098:	ff 30                	pushl  (%eax)
  80109a:	e8 a1 fd ff ff       	call   800e40 <dev_lookup>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 27                	js     8010cd <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a9:	8b 42 08             	mov    0x8(%edx),%eax
  8010ac:	83 e0 03             	and    $0x3,%eax
  8010af:	83 f8 01             	cmp    $0x1,%eax
  8010b2:	74 1e                	je     8010d2 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b7:	8b 40 08             	mov    0x8(%eax),%eax
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	74 35                	je     8010f3 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	ff 75 10             	pushl  0x10(%ebp)
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	52                   	push   %edx
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
}
  8010cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010d2:	a1 04 40 80 00       	mov    0x804004,%eax
  8010d7:	8b 40 48             	mov    0x48(%eax),%eax
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	53                   	push   %ebx
  8010de:	50                   	push   %eax
  8010df:	68 91 22 80 00       	push   $0x802291
  8010e4:	e8 a8 f0 ff ff       	call   800191 <cprintf>
		return -E_INVAL;
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb da                	jmp    8010cd <read+0x5e>
		return -E_NOT_SUPP;
  8010f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010f8:	eb d3                	jmp    8010cd <read+0x5e>

008010fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010fa:	f3 0f 1e fb          	endbr32 
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	8b 7d 08             	mov    0x8(%ebp),%edi
  80110a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80110d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801112:	eb 02                	jmp    801116 <readn+0x1c>
  801114:	01 c3                	add    %eax,%ebx
  801116:	39 f3                	cmp    %esi,%ebx
  801118:	73 21                	jae    80113b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	89 f0                	mov    %esi,%eax
  80111f:	29 d8                	sub    %ebx,%eax
  801121:	50                   	push   %eax
  801122:	89 d8                	mov    %ebx,%eax
  801124:	03 45 0c             	add    0xc(%ebp),%eax
  801127:	50                   	push   %eax
  801128:	57                   	push   %edi
  801129:	e8 41 ff ff ff       	call   80106f <read>
		if (m < 0)
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	85 c0                	test   %eax,%eax
  801133:	78 04                	js     801139 <readn+0x3f>
			return m;
		if (m == 0)
  801135:	75 dd                	jne    801114 <readn+0x1a>
  801137:	eb 02                	jmp    80113b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801139:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5f                   	pop    %edi
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801145:	f3 0f 1e fb          	endbr32 
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	53                   	push   %ebx
  80114d:	83 ec 1c             	sub    $0x1c,%esp
  801150:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801153:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	53                   	push   %ebx
  801158:	e8 8f fc ff ff       	call   800dec <fd_lookup>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 3a                	js     80119e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116a:	50                   	push   %eax
  80116b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116e:	ff 30                	pushl  (%eax)
  801170:	e8 cb fc ff ff       	call   800e40 <dev_lookup>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 22                	js     80119e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80117c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801183:	74 1e                	je     8011a3 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801188:	8b 52 0c             	mov    0xc(%edx),%edx
  80118b:	85 d2                	test   %edx,%edx
  80118d:	74 35                	je     8011c4 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80118f:	83 ec 04             	sub    $0x4,%esp
  801192:	ff 75 10             	pushl  0x10(%ebp)
  801195:	ff 75 0c             	pushl  0xc(%ebp)
  801198:	50                   	push   %eax
  801199:	ff d2                	call   *%edx
  80119b:	83 c4 10             	add    $0x10,%esp
}
  80119e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8011a8:	8b 40 48             	mov    0x48(%eax),%eax
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	53                   	push   %ebx
  8011af:	50                   	push   %eax
  8011b0:	68 ad 22 80 00       	push   $0x8022ad
  8011b5:	e8 d7 ef ff ff       	call   800191 <cprintf>
		return -E_INVAL;
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c2:	eb da                	jmp    80119e <write+0x59>
		return -E_NOT_SUPP;
  8011c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c9:	eb d3                	jmp    80119e <write+0x59>

008011cb <seek>:

int
seek(int fdnum, off_t offset)
{
  8011cb:	f3 0f 1e fb          	endbr32 
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	e8 0b fc ff ff       	call   800dec <fd_lookup>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 0e                	js     8011f6 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8011e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ee:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011f8:	f3 0f 1e fb          	endbr32 
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	53                   	push   %ebx
  801200:	83 ec 1c             	sub    $0x1c,%esp
  801203:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801206:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	53                   	push   %ebx
  80120b:	e8 dc fb ff ff       	call   800dec <fd_lookup>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	78 37                	js     80124e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121d:	50                   	push   %eax
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	ff 30                	pushl  (%eax)
  801223:	e8 18 fc ff ff       	call   800e40 <dev_lookup>
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 1f                	js     80124e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80122f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801232:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801236:	74 1b                	je     801253 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123b:	8b 52 18             	mov    0x18(%edx),%edx
  80123e:	85 d2                	test   %edx,%edx
  801240:	74 32                	je     801274 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801242:	83 ec 08             	sub    $0x8,%esp
  801245:	ff 75 0c             	pushl  0xc(%ebp)
  801248:	50                   	push   %eax
  801249:	ff d2                	call   *%edx
  80124b:	83 c4 10             	add    $0x10,%esp
}
  80124e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801251:	c9                   	leave  
  801252:	c3                   	ret    
			thisenv->env_id, fdnum);
  801253:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801258:	8b 40 48             	mov    0x48(%eax),%eax
  80125b:	83 ec 04             	sub    $0x4,%esp
  80125e:	53                   	push   %ebx
  80125f:	50                   	push   %eax
  801260:	68 70 22 80 00       	push   $0x802270
  801265:	e8 27 ef ff ff       	call   800191 <cprintf>
		return -E_INVAL;
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801272:	eb da                	jmp    80124e <ftruncate+0x56>
		return -E_NOT_SUPP;
  801274:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801279:	eb d3                	jmp    80124e <ftruncate+0x56>

0080127b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80127b:	f3 0f 1e fb          	endbr32 
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	53                   	push   %ebx
  801283:	83 ec 1c             	sub    $0x1c,%esp
  801286:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801289:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 08             	pushl  0x8(%ebp)
  801290:	e8 57 fb ff ff       	call   800dec <fd_lookup>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 4b                	js     8012e7 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a6:	ff 30                	pushl  (%eax)
  8012a8:	e8 93 fb ff ff       	call   800e40 <dev_lookup>
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	78 33                	js     8012e7 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012bb:	74 2f                	je     8012ec <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012bd:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012c0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012c7:	00 00 00 
	stat->st_isdir = 0;
  8012ca:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012d1:	00 00 00 
	stat->st_dev = dev;
  8012d4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	53                   	push   %ebx
  8012de:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e1:	ff 50 14             	call   *0x14(%eax)
  8012e4:	83 c4 10             	add    $0x10,%esp
}
  8012e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    
		return -E_NOT_SUPP;
  8012ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f1:	eb f4                	jmp    8012e7 <fstat+0x6c>

008012f3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012f3:	f3 0f 1e fb          	endbr32 
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	ff 75 08             	pushl  0x8(%ebp)
  801304:	e8 3a 02 00 00       	call   801543 <open>
  801309:	89 c3                	mov    %eax,%ebx
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 1b                	js     80132d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	50                   	push   %eax
  801319:	e8 5d ff ff ff       	call   80127b <fstat>
  80131e:	89 c6                	mov    %eax,%esi
	close(fd);
  801320:	89 1c 24             	mov    %ebx,(%esp)
  801323:	e8 fd fb ff ff       	call   800f25 <close>
	return r;
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	89 f3                	mov    %esi,%ebx
}
  80132d:	89 d8                	mov    %ebx,%eax
  80132f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    

00801336 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	89 c6                	mov    %eax,%esi
  80133d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80133f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801346:	74 27                	je     80136f <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801348:	6a 07                	push   $0x7
  80134a:	68 00 50 80 00       	push   $0x805000
  80134f:	56                   	push   %esi
  801350:	ff 35 00 40 80 00    	pushl  0x804000
  801356:	e8 47 08 00 00       	call   801ba2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80135b:	83 c4 0c             	add    $0xc,%esp
  80135e:	6a 00                	push   $0x0
  801360:	53                   	push   %ebx
  801361:	6a 00                	push   $0x0
  801363:	e8 cd 07 00 00       	call   801b35 <ipc_recv>
}
  801368:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136b:	5b                   	pop    %ebx
  80136c:	5e                   	pop    %esi
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	6a 01                	push   $0x1
  801374:	e8 81 08 00 00       	call   801bfa <ipc_find_env>
  801379:	a3 00 40 80 00       	mov    %eax,0x804000
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	eb c5                	jmp    801348 <fsipc+0x12>

00801383 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801383:	f3 0f 1e fb          	endbr32 
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8b 40 0c             	mov    0xc(%eax),%eax
  801393:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a5:	b8 02 00 00 00       	mov    $0x2,%eax
  8013aa:	e8 87 ff ff ff       	call   801336 <fsipc>
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <devfile_flush>:
{
  8013b1:	f3 0f 1e fb          	endbr32 
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8013d0:	e8 61 ff ff ff       	call   801336 <fsipc>
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <devfile_stat>:
{
  8013d7:	f3 0f 1e fb          	endbr32 
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	53                   	push   %ebx
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013eb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f5:	b8 05 00 00 00       	mov    $0x5,%eax
  8013fa:	e8 37 ff ff ff       	call   801336 <fsipc>
  8013ff:	85 c0                	test   %eax,%eax
  801401:	78 2c                	js     80142f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	68 00 50 80 00       	push   $0x805000
  80140b:	53                   	push   %ebx
  80140c:	e8 ea f2 ff ff       	call   8006fb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801411:	a1 80 50 80 00       	mov    0x805080,%eax
  801416:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80141c:	a1 84 50 80 00       	mov    0x805084,%eax
  801421:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <devfile_write>:
{
  801434:	f3 0f 1e fb          	endbr32 
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	53                   	push   %ebx
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8b 40 0c             	mov    0xc(%eax),%eax
  801448:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80144d:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801453:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801459:	77 30                	ja     80148b <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	53                   	push   %ebx
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	68 08 50 80 00       	push   $0x805008
  801467:	e8 47 f4 ff ff       	call   8008b3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80146c:	ba 00 00 00 00       	mov    $0x0,%edx
  801471:	b8 04 00 00 00       	mov    $0x4,%eax
  801476:	e8 bb fe ff ff       	call   801336 <fsipc>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 04                	js     801486 <devfile_write+0x52>
	assert(r <= n);
  801482:	39 d8                	cmp    %ebx,%eax
  801484:	77 1e                	ja     8014a4 <devfile_write+0x70>
}
  801486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801489:	c9                   	leave  
  80148a:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80148b:	68 dc 22 80 00       	push   $0x8022dc
  801490:	68 09 23 80 00       	push   $0x802309
  801495:	68 94 00 00 00       	push   $0x94
  80149a:	68 1e 23 80 00       	push   $0x80231e
  80149f:	e8 47 06 00 00       	call   801aeb <_panic>
	assert(r <= n);
  8014a4:	68 29 23 80 00       	push   $0x802329
  8014a9:	68 09 23 80 00       	push   $0x802309
  8014ae:	68 98 00 00 00       	push   $0x98
  8014b3:	68 1e 23 80 00       	push   $0x80231e
  8014b8:	e8 2e 06 00 00       	call   801aeb <_panic>

008014bd <devfile_read>:
{
  8014bd:	f3 0f 1e fb          	endbr32 
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8014cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014d4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014da:	ba 00 00 00 00       	mov    $0x0,%edx
  8014df:	b8 03 00 00 00       	mov    $0x3,%eax
  8014e4:	e8 4d fe ff ff       	call   801336 <fsipc>
  8014e9:	89 c3                	mov    %eax,%ebx
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 1f                	js     80150e <devfile_read+0x51>
	assert(r <= n);
  8014ef:	39 f0                	cmp    %esi,%eax
  8014f1:	77 24                	ja     801517 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8014f3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014f8:	7f 33                	jg     80152d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	50                   	push   %eax
  8014fe:	68 00 50 80 00       	push   $0x805000
  801503:	ff 75 0c             	pushl  0xc(%ebp)
  801506:	e8 a8 f3 ff ff       	call   8008b3 <memmove>
	return r;
  80150b:	83 c4 10             	add    $0x10,%esp
}
  80150e:	89 d8                	mov    %ebx,%eax
  801510:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801513:	5b                   	pop    %ebx
  801514:	5e                   	pop    %esi
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    
	assert(r <= n);
  801517:	68 29 23 80 00       	push   $0x802329
  80151c:	68 09 23 80 00       	push   $0x802309
  801521:	6a 7c                	push   $0x7c
  801523:	68 1e 23 80 00       	push   $0x80231e
  801528:	e8 be 05 00 00       	call   801aeb <_panic>
	assert(r <= PGSIZE);
  80152d:	68 30 23 80 00       	push   $0x802330
  801532:	68 09 23 80 00       	push   $0x802309
  801537:	6a 7d                	push   $0x7d
  801539:	68 1e 23 80 00       	push   $0x80231e
  80153e:	e8 a8 05 00 00       	call   801aeb <_panic>

00801543 <open>:
{
  801543:	f3 0f 1e fb          	endbr32 
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	56                   	push   %esi
  80154b:	53                   	push   %ebx
  80154c:	83 ec 1c             	sub    $0x1c,%esp
  80154f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801552:	56                   	push   %esi
  801553:	e8 60 f1 ff ff       	call   8006b8 <strlen>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801560:	7f 6c                	jg     8015ce <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801568:	50                   	push   %eax
  801569:	e8 28 f8 ff ff       	call   800d96 <fd_alloc>
  80156e:	89 c3                	mov    %eax,%ebx
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	85 c0                	test   %eax,%eax
  801575:	78 3c                	js     8015b3 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	56                   	push   %esi
  80157b:	68 00 50 80 00       	push   $0x805000
  801580:	e8 76 f1 ff ff       	call   8006fb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80158d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801590:	b8 01 00 00 00       	mov    $0x1,%eax
  801595:	e8 9c fd ff ff       	call   801336 <fsipc>
  80159a:	89 c3                	mov    %eax,%ebx
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 19                	js     8015bc <open+0x79>
	return fd2num(fd);
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a9:	e8 b5 f7 ff ff       	call   800d63 <fd2num>
  8015ae:	89 c3                	mov    %eax,%ebx
  8015b0:	83 c4 10             	add    $0x10,%esp
}
  8015b3:	89 d8                	mov    %ebx,%eax
  8015b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b8:	5b                   	pop    %ebx
  8015b9:	5e                   	pop    %esi
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    
		fd_close(fd, 0);
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	6a 00                	push   $0x0
  8015c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c4:	e8 d1 f8 ff ff       	call   800e9a <fd_close>
		return r;
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	eb e5                	jmp    8015b3 <open+0x70>
		return -E_BAD_PATH;
  8015ce:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015d3:	eb de                	jmp    8015b3 <open+0x70>

008015d5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015d5:	f3 0f 1e fb          	endbr32 
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015df:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8015e9:	e8 48 fd ff ff       	call   801336 <fsipc>
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015f0:	f3 0f 1e fb          	endbr32 
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	e8 70 f7 ff ff       	call   800d77 <fd2data>
  801607:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801609:	83 c4 08             	add    $0x8,%esp
  80160c:	68 3c 23 80 00       	push   $0x80233c
  801611:	53                   	push   %ebx
  801612:	e8 e4 f0 ff ff       	call   8006fb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801617:	8b 46 04             	mov    0x4(%esi),%eax
  80161a:	2b 06                	sub    (%esi),%eax
  80161c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801622:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801629:	00 00 00 
	stat->st_dev = &devpipe;
  80162c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801633:	30 80 00 
	return 0;
}
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
  80163b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163e:	5b                   	pop    %ebx
  80163f:	5e                   	pop    %esi
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    

00801642 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801642:	f3 0f 1e fb          	endbr32 
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	53                   	push   %ebx
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801650:	53                   	push   %ebx
  801651:	6a 00                	push   $0x0
  801653:	e8 7d f5 ff ff       	call   800bd5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801658:	89 1c 24             	mov    %ebx,(%esp)
  80165b:	e8 17 f7 ff ff       	call   800d77 <fd2data>
  801660:	83 c4 08             	add    $0x8,%esp
  801663:	50                   	push   %eax
  801664:	6a 00                	push   $0x0
  801666:	e8 6a f5 ff ff       	call   800bd5 <sys_page_unmap>
}
  80166b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <_pipeisclosed>:
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	57                   	push   %edi
  801674:	56                   	push   %esi
  801675:	53                   	push   %ebx
  801676:	83 ec 1c             	sub    $0x1c,%esp
  801679:	89 c7                	mov    %eax,%edi
  80167b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80167d:	a1 04 40 80 00       	mov    0x804004,%eax
  801682:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	57                   	push   %edi
  801689:	e8 a9 05 00 00       	call   801c37 <pageref>
  80168e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801691:	89 34 24             	mov    %esi,(%esp)
  801694:	e8 9e 05 00 00       	call   801c37 <pageref>
		nn = thisenv->env_runs;
  801699:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80169f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	39 cb                	cmp    %ecx,%ebx
  8016a7:	74 1b                	je     8016c4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ac:	75 cf                	jne    80167d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016ae:	8b 42 58             	mov    0x58(%edx),%eax
  8016b1:	6a 01                	push   $0x1
  8016b3:	50                   	push   %eax
  8016b4:	53                   	push   %ebx
  8016b5:	68 43 23 80 00       	push   $0x802343
  8016ba:	e8 d2 ea ff ff       	call   800191 <cprintf>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	eb b9                	jmp    80167d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016c4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016c7:	0f 94 c0             	sete   %al
  8016ca:	0f b6 c0             	movzbl %al,%eax
}
  8016cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5e                   	pop    %esi
  8016d2:	5f                   	pop    %edi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <devpipe_write>:
{
  8016d5:	f3 0f 1e fb          	endbr32 
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	57                   	push   %edi
  8016dd:	56                   	push   %esi
  8016de:	53                   	push   %ebx
  8016df:	83 ec 28             	sub    $0x28,%esp
  8016e2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016e5:	56                   	push   %esi
  8016e6:	e8 8c f6 ff ff       	call   800d77 <fd2data>
  8016eb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016f8:	74 4f                	je     801749 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016fa:	8b 43 04             	mov    0x4(%ebx),%eax
  8016fd:	8b 0b                	mov    (%ebx),%ecx
  8016ff:	8d 51 20             	lea    0x20(%ecx),%edx
  801702:	39 d0                	cmp    %edx,%eax
  801704:	72 14                	jb     80171a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801706:	89 da                	mov    %ebx,%edx
  801708:	89 f0                	mov    %esi,%eax
  80170a:	e8 61 ff ff ff       	call   801670 <_pipeisclosed>
  80170f:	85 c0                	test   %eax,%eax
  801711:	75 3b                	jne    80174e <devpipe_write+0x79>
			sys_yield();
  801713:	e8 40 f4 ff ff       	call   800b58 <sys_yield>
  801718:	eb e0                	jmp    8016fa <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80171a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801721:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801724:	89 c2                	mov    %eax,%edx
  801726:	c1 fa 1f             	sar    $0x1f,%edx
  801729:	89 d1                	mov    %edx,%ecx
  80172b:	c1 e9 1b             	shr    $0x1b,%ecx
  80172e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801731:	83 e2 1f             	and    $0x1f,%edx
  801734:	29 ca                	sub    %ecx,%edx
  801736:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80173a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80173e:	83 c0 01             	add    $0x1,%eax
  801741:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801744:	83 c7 01             	add    $0x1,%edi
  801747:	eb ac                	jmp    8016f5 <devpipe_write+0x20>
	return i;
  801749:	8b 45 10             	mov    0x10(%ebp),%eax
  80174c:	eb 05                	jmp    801753 <devpipe_write+0x7e>
				return 0;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801753:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5f                   	pop    %edi
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <devpipe_read>:
{
  80175b:	f3 0f 1e fb          	endbr32 
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	57                   	push   %edi
  801763:	56                   	push   %esi
  801764:	53                   	push   %ebx
  801765:	83 ec 18             	sub    $0x18,%esp
  801768:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80176b:	57                   	push   %edi
  80176c:	e8 06 f6 ff ff       	call   800d77 <fd2data>
  801771:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	be 00 00 00 00       	mov    $0x0,%esi
  80177b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80177e:	75 14                	jne    801794 <devpipe_read+0x39>
	return i;
  801780:	8b 45 10             	mov    0x10(%ebp),%eax
  801783:	eb 02                	jmp    801787 <devpipe_read+0x2c>
				return i;
  801785:	89 f0                	mov    %esi,%eax
}
  801787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5f                   	pop    %edi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    
			sys_yield();
  80178f:	e8 c4 f3 ff ff       	call   800b58 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801794:	8b 03                	mov    (%ebx),%eax
  801796:	3b 43 04             	cmp    0x4(%ebx),%eax
  801799:	75 18                	jne    8017b3 <devpipe_read+0x58>
			if (i > 0)
  80179b:	85 f6                	test   %esi,%esi
  80179d:	75 e6                	jne    801785 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80179f:	89 da                	mov    %ebx,%edx
  8017a1:	89 f8                	mov    %edi,%eax
  8017a3:	e8 c8 fe ff ff       	call   801670 <_pipeisclosed>
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	74 e3                	je     80178f <devpipe_read+0x34>
				return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	eb d4                	jmp    801787 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017b3:	99                   	cltd   
  8017b4:	c1 ea 1b             	shr    $0x1b,%edx
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	83 e0 1f             	and    $0x1f,%eax
  8017bc:	29 d0                	sub    %edx,%eax
  8017be:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017c9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017cc:	83 c6 01             	add    $0x1,%esi
  8017cf:	eb aa                	jmp    80177b <devpipe_read+0x20>

008017d1 <pipe>:
{
  8017d1:	f3 0f 1e fb          	endbr32 
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
  8017da:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e0:	50                   	push   %eax
  8017e1:	e8 b0 f5 ff ff       	call   800d96 <fd_alloc>
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	0f 88 23 01 00 00    	js     801916 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	68 07 04 00 00       	push   $0x407
  8017fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fe:	6a 00                	push   $0x0
  801800:	e8 7e f3 ff ff       	call   800b83 <sys_page_alloc>
  801805:	89 c3                	mov    %eax,%ebx
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	85 c0                	test   %eax,%eax
  80180c:	0f 88 04 01 00 00    	js     801916 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801818:	50                   	push   %eax
  801819:	e8 78 f5 ff ff       	call   800d96 <fd_alloc>
  80181e:	89 c3                	mov    %eax,%ebx
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	0f 88 db 00 00 00    	js     801906 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 07 04 00 00       	push   $0x407
  801833:	ff 75 f0             	pushl  -0x10(%ebp)
  801836:	6a 00                	push   $0x0
  801838:	e8 46 f3 ff ff       	call   800b83 <sys_page_alloc>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	0f 88 bc 00 00 00    	js     801906 <pipe+0x135>
	va = fd2data(fd0);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	ff 75 f4             	pushl  -0xc(%ebp)
  801850:	e8 22 f5 ff ff       	call   800d77 <fd2data>
  801855:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801857:	83 c4 0c             	add    $0xc,%esp
  80185a:	68 07 04 00 00       	push   $0x407
  80185f:	50                   	push   %eax
  801860:	6a 00                	push   $0x0
  801862:	e8 1c f3 ff ff       	call   800b83 <sys_page_alloc>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	0f 88 82 00 00 00    	js     8018f6 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801874:	83 ec 0c             	sub    $0xc,%esp
  801877:	ff 75 f0             	pushl  -0x10(%ebp)
  80187a:	e8 f8 f4 ff ff       	call   800d77 <fd2data>
  80187f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801886:	50                   	push   %eax
  801887:	6a 00                	push   $0x0
  801889:	56                   	push   %esi
  80188a:	6a 00                	push   $0x0
  80188c:	e8 1a f3 ff ff       	call   800bab <sys_page_map>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	83 c4 20             	add    $0x20,%esp
  801896:	85 c0                	test   %eax,%eax
  801898:	78 4e                	js     8018e8 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80189a:	a1 20 30 80 00       	mov    0x803020,%eax
  80189f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8018a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8018ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018bd:	83 ec 0c             	sub    $0xc,%esp
  8018c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c3:	e8 9b f4 ff ff       	call   800d63 <fd2num>
  8018c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018cd:	83 c4 04             	add    $0x4,%esp
  8018d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d3:	e8 8b f4 ff ff       	call   800d63 <fd2num>
  8018d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018db:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e6:	eb 2e                	jmp    801916 <pipe+0x145>
	sys_page_unmap(0, va);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	56                   	push   %esi
  8018ec:	6a 00                	push   $0x0
  8018ee:	e8 e2 f2 ff ff       	call   800bd5 <sys_page_unmap>
  8018f3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fc:	6a 00                	push   $0x0
  8018fe:	e8 d2 f2 ff ff       	call   800bd5 <sys_page_unmap>
  801903:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	ff 75 f4             	pushl  -0xc(%ebp)
  80190c:	6a 00                	push   $0x0
  80190e:	e8 c2 f2 ff ff       	call   800bd5 <sys_page_unmap>
  801913:	83 c4 10             	add    $0x10,%esp
}
  801916:	89 d8                	mov    %ebx,%eax
  801918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5e                   	pop    %esi
  80191d:	5d                   	pop    %ebp
  80191e:	c3                   	ret    

0080191f <pipeisclosed>:
{
  80191f:	f3 0f 1e fb          	endbr32 
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801929:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192c:	50                   	push   %eax
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 b7 f4 ff ff       	call   800dec <fd_lookup>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 18                	js     801954 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 f4             	pushl  -0xc(%ebp)
  801942:	e8 30 f4 ff ff       	call   800d77 <fd2data>
  801947:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194c:	e8 1f fd ff ff       	call   801670 <_pipeisclosed>
  801951:	83 c4 10             	add    $0x10,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801956:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
  80195f:	c3                   	ret    

00801960 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801960:	f3 0f 1e fb          	endbr32 
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80196a:	68 5b 23 80 00       	push   $0x80235b
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	e8 84 ed ff ff       	call   8006fb <strcpy>
	return 0;
}
  801977:	b8 00 00 00 00       	mov    $0x0,%eax
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <devcons_write>:
{
  80197e:	f3 0f 1e fb          	endbr32 
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	57                   	push   %edi
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
  801988:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80198e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801993:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801999:	3b 75 10             	cmp    0x10(%ebp),%esi
  80199c:	73 31                	jae    8019cf <devcons_write+0x51>
		m = n - tot;
  80199e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019a1:	29 f3                	sub    %esi,%ebx
  8019a3:	83 fb 7f             	cmp    $0x7f,%ebx
  8019a6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019ab:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	53                   	push   %ebx
  8019b2:	89 f0                	mov    %esi,%eax
  8019b4:	03 45 0c             	add    0xc(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	57                   	push   %edi
  8019b9:	e8 f5 ee ff ff       	call   8008b3 <memmove>
		sys_cputs(buf, m);
  8019be:	83 c4 08             	add    $0x8,%esp
  8019c1:	53                   	push   %ebx
  8019c2:	57                   	push   %edi
  8019c3:	e8 f0 f0 ff ff       	call   800ab8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019c8:	01 de                	add    %ebx,%esi
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	eb ca                	jmp    801999 <devcons_write+0x1b>
}
  8019cf:	89 f0                	mov    %esi,%eax
  8019d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5f                   	pop    %edi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <devcons_read>:
{
  8019d9:	f3 0f 1e fb          	endbr32 
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 08             	sub    $0x8,%esp
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8019e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ec:	74 21                	je     801a0f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8019ee:	e8 ef f0 ff ff       	call   800ae2 <sys_cgetc>
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	75 07                	jne    8019fe <devcons_read+0x25>
		sys_yield();
  8019f7:	e8 5c f1 ff ff       	call   800b58 <sys_yield>
  8019fc:	eb f0                	jmp    8019ee <devcons_read+0x15>
	if (c < 0)
  8019fe:	78 0f                	js     801a0f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a00:	83 f8 04             	cmp    $0x4,%eax
  801a03:	74 0c                	je     801a11 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	88 02                	mov    %al,(%edx)
	return 1;
  801a0a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
		return 0;
  801a11:	b8 00 00 00 00       	mov    $0x0,%eax
  801a16:	eb f7                	jmp    801a0f <devcons_read+0x36>

00801a18 <cputchar>:
{
  801a18:	f3 0f 1e fb          	endbr32 
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a28:	6a 01                	push   $0x1
  801a2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a2d:	50                   	push   %eax
  801a2e:	e8 85 f0 ff ff       	call   800ab8 <sys_cputs>
}
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <getchar>:
{
  801a38:	f3 0f 1e fb          	endbr32 
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a42:	6a 01                	push   $0x1
  801a44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a47:	50                   	push   %eax
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 20 f6 ff ff       	call   80106f <read>
	if (r < 0)
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 06                	js     801a5c <getchar+0x24>
	if (r < 1)
  801a56:	74 06                	je     801a5e <getchar+0x26>
	return c;
  801a58:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    
		return -E_EOF;
  801a5e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a63:	eb f7                	jmp    801a5c <getchar+0x24>

00801a65 <iscons>:
{
  801a65:	f3 0f 1e fb          	endbr32 
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a72:	50                   	push   %eax
  801a73:	ff 75 08             	pushl  0x8(%ebp)
  801a76:	e8 71 f3 ff ff       	call   800dec <fd_lookup>
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 11                	js     801a93 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a8b:	39 10                	cmp    %edx,(%eax)
  801a8d:	0f 94 c0             	sete   %al
  801a90:	0f b6 c0             	movzbl %al,%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <opencons>:
{
  801a95:	f3 0f 1e fb          	endbr32 
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa2:	50                   	push   %eax
  801aa3:	e8 ee f2 ff ff       	call   800d96 <fd_alloc>
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 3a                	js     801ae9 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 07 04 00 00       	push   $0x407
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	6a 00                	push   $0x0
  801abc:	e8 c2 f0 ff ff       	call   800b83 <sys_page_alloc>
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	78 21                	js     801ae9 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ad1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	50                   	push   %eax
  801ae1:	e8 7d f2 ff ff       	call   800d63 <fd2num>
  801ae6:	83 c4 10             	add    $0x10,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801aeb:	f3 0f 1e fb          	endbr32 
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801af4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801af7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801afd:	e8 2e f0 ff ff       	call   800b30 <sys_getenvid>
  801b02:	83 ec 0c             	sub    $0xc,%esp
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	ff 75 08             	pushl  0x8(%ebp)
  801b0b:	56                   	push   %esi
  801b0c:	50                   	push   %eax
  801b0d:	68 68 23 80 00       	push   $0x802368
  801b12:	e8 7a e6 ff ff       	call   800191 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b17:	83 c4 18             	add    $0x18,%esp
  801b1a:	53                   	push   %ebx
  801b1b:	ff 75 10             	pushl  0x10(%ebp)
  801b1e:	e8 19 e6 ff ff       	call   80013c <vcprintf>
	cprintf("\n");
  801b23:	c7 04 24 a6 23 80 00 	movl   $0x8023a6,(%esp)
  801b2a:	e8 62 e6 ff ff       	call   800191 <cprintf>
  801b2f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b32:	cc                   	int3   
  801b33:	eb fd                	jmp    801b32 <_panic+0x47>

00801b35 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b35:	f3 0f 1e fb          	endbr32 
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	56                   	push   %esi
  801b3d:	53                   	push   %ebx
  801b3e:	8b 75 08             	mov    0x8(%ebp),%esi
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b47:	85 c0                	test   %eax,%eax
  801b49:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b4e:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b51:	83 ec 0c             	sub    $0xc,%esp
  801b54:	50                   	push   %eax
  801b55:	e8 40 f1 ff ff       	call   800c9a <sys_ipc_recv>
	if (r < 0) {
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 2b                	js     801b8c <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b61:	85 f6                	test   %esi,%esi
  801b63:	74 0a                	je     801b6f <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b65:	a1 04 40 80 00       	mov    0x804004,%eax
  801b6a:	8b 40 74             	mov    0x74(%eax),%eax
  801b6d:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801b6f:	85 db                	test   %ebx,%ebx
  801b71:	74 0a                	je     801b7d <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801b73:	a1 04 40 80 00       	mov    0x804004,%eax
  801b78:	8b 40 78             	mov    0x78(%eax),%eax
  801b7b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801b7d:	a1 04 40 80 00       	mov    0x804004,%eax
  801b82:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5e                   	pop    %esi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
		if (from_env_store) {
  801b8c:	85 f6                	test   %esi,%esi
  801b8e:	74 06                	je     801b96 <ipc_recv+0x61>
			*from_env_store = 0;
  801b90:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b96:	85 db                	test   %ebx,%ebx
  801b98:	74 eb                	je     801b85 <ipc_recv+0x50>
			*perm_store = 0;
  801b9a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ba0:	eb e3                	jmp    801b85 <ipc_recv+0x50>

00801ba2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ba2:	f3 0f 1e fb          	endbr32 
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bb2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801bb8:	85 db                	test   %ebx,%ebx
  801bba:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bbf:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801bc2:	ff 75 14             	pushl  0x14(%ebp)
  801bc5:	53                   	push   %ebx
  801bc6:	56                   	push   %esi
  801bc7:	57                   	push   %edi
  801bc8:	e8 a4 f0 ff ff       	call   800c71 <sys_ipc_try_send>
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bd3:	75 07                	jne    801bdc <ipc_send+0x3a>
		sys_yield();
  801bd5:	e8 7e ef ff ff       	call   800b58 <sys_yield>
  801bda:	eb e6                	jmp    801bc2 <ipc_send+0x20>
	}

	if (ret < 0) {
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 08                	js     801be8 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5f                   	pop    %edi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801be8:	50                   	push   %eax
  801be9:	68 8b 23 80 00       	push   $0x80238b
  801bee:	6a 48                	push   $0x48
  801bf0:	68 a8 23 80 00       	push   $0x8023a8
  801bf5:	e8 f1 fe ff ff       	call   801aeb <_panic>

00801bfa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bfa:	f3 0f 1e fb          	endbr32 
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c09:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c0c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c12:	8b 52 50             	mov    0x50(%edx),%edx
  801c15:	39 ca                	cmp    %ecx,%edx
  801c17:	74 11                	je     801c2a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c19:	83 c0 01             	add    $0x1,%eax
  801c1c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c21:	75 e6                	jne    801c09 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	eb 0b                	jmp    801c35 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c2a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c2d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c32:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    

00801c37 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c37:	f3 0f 1e fb          	endbr32 
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c41:	89 c2                	mov    %eax,%edx
  801c43:	c1 ea 16             	shr    $0x16,%edx
  801c46:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c4d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c52:	f6 c1 01             	test   $0x1,%cl
  801c55:	74 1c                	je     801c73 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c57:	c1 e8 0c             	shr    $0xc,%eax
  801c5a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c61:	a8 01                	test   $0x1,%al
  801c63:	74 0e                	je     801c73 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c65:	c1 e8 0c             	shr    $0xc,%eax
  801c68:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c6f:	ef 
  801c70:	0f b7 d2             	movzwl %dx,%edx
}
  801c73:	89 d0                	mov    %edx,%eax
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    
  801c77:	66 90                	xchg   %ax,%ax
  801c79:	66 90                	xchg   %ax,%ax
  801c7b:	66 90                	xchg   %ax,%ax
  801c7d:	66 90                	xchg   %ax,%ax
  801c7f:	90                   	nop

00801c80 <__udivdi3>:
  801c80:	f3 0f 1e fb          	endbr32 
  801c84:	55                   	push   %ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c8f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c97:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c9b:	85 d2                	test   %edx,%edx
  801c9d:	75 19                	jne    801cb8 <__udivdi3+0x38>
  801c9f:	39 f3                	cmp    %esi,%ebx
  801ca1:	76 4d                	jbe    801cf0 <__udivdi3+0x70>
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	89 e8                	mov    %ebp,%eax
  801ca7:	89 f2                	mov    %esi,%edx
  801ca9:	f7 f3                	div    %ebx
  801cab:	89 fa                	mov    %edi,%edx
  801cad:	83 c4 1c             	add    $0x1c,%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5f                   	pop    %edi
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    
  801cb5:	8d 76 00             	lea    0x0(%esi),%esi
  801cb8:	39 f2                	cmp    %esi,%edx
  801cba:	76 14                	jbe    801cd0 <__udivdi3+0x50>
  801cbc:	31 ff                	xor    %edi,%edi
  801cbe:	31 c0                	xor    %eax,%eax
  801cc0:	89 fa                	mov    %edi,%edx
  801cc2:	83 c4 1c             	add    $0x1c,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    
  801cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cd0:	0f bd fa             	bsr    %edx,%edi
  801cd3:	83 f7 1f             	xor    $0x1f,%edi
  801cd6:	75 48                	jne    801d20 <__udivdi3+0xa0>
  801cd8:	39 f2                	cmp    %esi,%edx
  801cda:	72 06                	jb     801ce2 <__udivdi3+0x62>
  801cdc:	31 c0                	xor    %eax,%eax
  801cde:	39 eb                	cmp    %ebp,%ebx
  801ce0:	77 de                	ja     801cc0 <__udivdi3+0x40>
  801ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce7:	eb d7                	jmp    801cc0 <__udivdi3+0x40>
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	89 d9                	mov    %ebx,%ecx
  801cf2:	85 db                	test   %ebx,%ebx
  801cf4:	75 0b                	jne    801d01 <__udivdi3+0x81>
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f3                	div    %ebx
  801cff:	89 c1                	mov    %eax,%ecx
  801d01:	31 d2                	xor    %edx,%edx
  801d03:	89 f0                	mov    %esi,%eax
  801d05:	f7 f1                	div    %ecx
  801d07:	89 c6                	mov    %eax,%esi
  801d09:	89 e8                	mov    %ebp,%eax
  801d0b:	89 f7                	mov    %esi,%edi
  801d0d:	f7 f1                	div    %ecx
  801d0f:	89 fa                	mov    %edi,%edx
  801d11:	83 c4 1c             	add    $0x1c,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
  801d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d20:	89 f9                	mov    %edi,%ecx
  801d22:	b8 20 00 00 00       	mov    $0x20,%eax
  801d27:	29 f8                	sub    %edi,%eax
  801d29:	d3 e2                	shl    %cl,%edx
  801d2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d2f:	89 c1                	mov    %eax,%ecx
  801d31:	89 da                	mov    %ebx,%edx
  801d33:	d3 ea                	shr    %cl,%edx
  801d35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d39:	09 d1                	or     %edx,%ecx
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d41:	89 f9                	mov    %edi,%ecx
  801d43:	d3 e3                	shl    %cl,%ebx
  801d45:	89 c1                	mov    %eax,%ecx
  801d47:	d3 ea                	shr    %cl,%edx
  801d49:	89 f9                	mov    %edi,%ecx
  801d4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d4f:	89 eb                	mov    %ebp,%ebx
  801d51:	d3 e6                	shl    %cl,%esi
  801d53:	89 c1                	mov    %eax,%ecx
  801d55:	d3 eb                	shr    %cl,%ebx
  801d57:	09 de                	or     %ebx,%esi
  801d59:	89 f0                	mov    %esi,%eax
  801d5b:	f7 74 24 08          	divl   0x8(%esp)
  801d5f:	89 d6                	mov    %edx,%esi
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	f7 64 24 0c          	mull   0xc(%esp)
  801d67:	39 d6                	cmp    %edx,%esi
  801d69:	72 15                	jb     801d80 <__udivdi3+0x100>
  801d6b:	89 f9                	mov    %edi,%ecx
  801d6d:	d3 e5                	shl    %cl,%ebp
  801d6f:	39 c5                	cmp    %eax,%ebp
  801d71:	73 04                	jae    801d77 <__udivdi3+0xf7>
  801d73:	39 d6                	cmp    %edx,%esi
  801d75:	74 09                	je     801d80 <__udivdi3+0x100>
  801d77:	89 d8                	mov    %ebx,%eax
  801d79:	31 ff                	xor    %edi,%edi
  801d7b:	e9 40 ff ff ff       	jmp    801cc0 <__udivdi3+0x40>
  801d80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d83:	31 ff                	xor    %edi,%edi
  801d85:	e9 36 ff ff ff       	jmp    801cc0 <__udivdi3+0x40>
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	66 90                	xchg   %ax,%ax
  801d8e:	66 90                	xchg   %ax,%ax

00801d90 <__umoddi3>:
  801d90:	f3 0f 1e fb          	endbr32 
  801d94:	55                   	push   %ebp
  801d95:	57                   	push   %edi
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
  801d98:	83 ec 1c             	sub    $0x1c,%esp
  801d9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801da3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 19                	jne    801dc8 <__umoddi3+0x38>
  801daf:	39 df                	cmp    %ebx,%edi
  801db1:	76 5d                	jbe    801e10 <__umoddi3+0x80>
  801db3:	89 f0                	mov    %esi,%eax
  801db5:	89 da                	mov    %ebx,%edx
  801db7:	f7 f7                	div    %edi
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	31 d2                	xor    %edx,%edx
  801dbd:	83 c4 1c             	add    $0x1c,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5f                   	pop    %edi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    
  801dc5:	8d 76 00             	lea    0x0(%esi),%esi
  801dc8:	89 f2                	mov    %esi,%edx
  801dca:	39 d8                	cmp    %ebx,%eax
  801dcc:	76 12                	jbe    801de0 <__umoddi3+0x50>
  801dce:	89 f0                	mov    %esi,%eax
  801dd0:	89 da                	mov    %ebx,%edx
  801dd2:	83 c4 1c             	add    $0x1c,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    
  801dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801de0:	0f bd e8             	bsr    %eax,%ebp
  801de3:	83 f5 1f             	xor    $0x1f,%ebp
  801de6:	75 50                	jne    801e38 <__umoddi3+0xa8>
  801de8:	39 d8                	cmp    %ebx,%eax
  801dea:	0f 82 e0 00 00 00    	jb     801ed0 <__umoddi3+0x140>
  801df0:	89 d9                	mov    %ebx,%ecx
  801df2:	39 f7                	cmp    %esi,%edi
  801df4:	0f 86 d6 00 00 00    	jbe    801ed0 <__umoddi3+0x140>
  801dfa:	89 d0                	mov    %edx,%eax
  801dfc:	89 ca                	mov    %ecx,%edx
  801dfe:	83 c4 1c             	add    $0x1c,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5f                   	pop    %edi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
  801e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	89 fd                	mov    %edi,%ebp
  801e12:	85 ff                	test   %edi,%edi
  801e14:	75 0b                	jne    801e21 <__umoddi3+0x91>
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	31 d2                	xor    %edx,%edx
  801e1d:	f7 f7                	div    %edi
  801e1f:	89 c5                	mov    %eax,%ebp
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f5                	div    %ebp
  801e27:	89 f0                	mov    %esi,%eax
  801e29:	f7 f5                	div    %ebp
  801e2b:	89 d0                	mov    %edx,%eax
  801e2d:	31 d2                	xor    %edx,%edx
  801e2f:	eb 8c                	jmp    801dbd <__umoddi3+0x2d>
  801e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e38:	89 e9                	mov    %ebp,%ecx
  801e3a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e3f:	29 ea                	sub    %ebp,%edx
  801e41:	d3 e0                	shl    %cl,%eax
  801e43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e47:	89 d1                	mov    %edx,%ecx
  801e49:	89 f8                	mov    %edi,%eax
  801e4b:	d3 e8                	shr    %cl,%eax
  801e4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e51:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e55:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e59:	09 c1                	or     %eax,%ecx
  801e5b:	89 d8                	mov    %ebx,%eax
  801e5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e61:	89 e9                	mov    %ebp,%ecx
  801e63:	d3 e7                	shl    %cl,%edi
  801e65:	89 d1                	mov    %edx,%ecx
  801e67:	d3 e8                	shr    %cl,%eax
  801e69:	89 e9                	mov    %ebp,%ecx
  801e6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e6f:	d3 e3                	shl    %cl,%ebx
  801e71:	89 c7                	mov    %eax,%edi
  801e73:	89 d1                	mov    %edx,%ecx
  801e75:	89 f0                	mov    %esi,%eax
  801e77:	d3 e8                	shr    %cl,%eax
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	89 fa                	mov    %edi,%edx
  801e7d:	d3 e6                	shl    %cl,%esi
  801e7f:	09 d8                	or     %ebx,%eax
  801e81:	f7 74 24 08          	divl   0x8(%esp)
  801e85:	89 d1                	mov    %edx,%ecx
  801e87:	89 f3                	mov    %esi,%ebx
  801e89:	f7 64 24 0c          	mull   0xc(%esp)
  801e8d:	89 c6                	mov    %eax,%esi
  801e8f:	89 d7                	mov    %edx,%edi
  801e91:	39 d1                	cmp    %edx,%ecx
  801e93:	72 06                	jb     801e9b <__umoddi3+0x10b>
  801e95:	75 10                	jne    801ea7 <__umoddi3+0x117>
  801e97:	39 c3                	cmp    %eax,%ebx
  801e99:	73 0c                	jae    801ea7 <__umoddi3+0x117>
  801e9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ea3:	89 d7                	mov    %edx,%edi
  801ea5:	89 c6                	mov    %eax,%esi
  801ea7:	89 ca                	mov    %ecx,%edx
  801ea9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801eae:	29 f3                	sub    %esi,%ebx
  801eb0:	19 fa                	sbb    %edi,%edx
  801eb2:	89 d0                	mov    %edx,%eax
  801eb4:	d3 e0                	shl    %cl,%eax
  801eb6:	89 e9                	mov    %ebp,%ecx
  801eb8:	d3 eb                	shr    %cl,%ebx
  801eba:	d3 ea                	shr    %cl,%edx
  801ebc:	09 d8                	or     %ebx,%eax
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
  801ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	29 fe                	sub    %edi,%esi
  801ed2:	19 c3                	sbb    %eax,%ebx
  801ed4:	89 f2                	mov    %esi,%edx
  801ed6:	89 d9                	mov    %ebx,%ecx
  801ed8:	e9 1d ff ff ff       	jmp    801dfa <__umoddi3+0x6a>
