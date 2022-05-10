
obj/user/spin.debug:     formato del fichero elf32-i386


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
  80002c:	e8 88 00 00 00       	call   8000b9 <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003e:	68 e0 23 80 00       	push   $0x8023e0
  800043:	e8 7a 01 00 00       	call   8001c2 <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 27 10 00 00       	call   801074 <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 58 24 80 00       	push   $0x802458
  80005c:	e8 61 01 00 00       	call   8001c2 <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 08 24 80 00       	push   $0x802408
  800070:	e8 4d 01 00 00       	call   8001c2 <cprintf>
	sys_yield();
  800075:	e8 0f 0b 00 00       	call   800b89 <sys_yield>
	sys_yield();
  80007a:	e8 0a 0b 00 00       	call   800b89 <sys_yield>
	sys_yield();
  80007f:	e8 05 0b 00 00       	call   800b89 <sys_yield>
	sys_yield();
  800084:	e8 00 0b 00 00       	call   800b89 <sys_yield>
	sys_yield();
  800089:	e8 fb 0a 00 00       	call   800b89 <sys_yield>
	sys_yield();
  80008e:	e8 f6 0a 00 00       	call   800b89 <sys_yield>
	sys_yield();
  800093:	e8 f1 0a 00 00       	call   800b89 <sys_yield>
	sys_yield();
  800098:	e8 ec 0a 00 00       	call   800b89 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  80009d:	c7 04 24 30 24 80 00 	movl   $0x802430,(%esp)
  8000a4:	e8 19 01 00 00       	call   8001c2 <cprintf>
	sys_env_destroy(env);
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 8a 0a 00 00       	call   800b3b <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
  8000c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000c8:	e8 94 0a 00 00       	call   800b61 <sys_getenvid>
	if (id >= 0)
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	78 12                	js     8000e3 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000de:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e3:	85 db                	test   %ebx,%ebx
  8000e5:	7e 07                	jle    8000ee <libmain+0x35>
		binaryname = argv[0];
  8000e7:	8b 06                	mov    (%esi),%eax
  8000e9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	e8 3b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f8:	e8 0a 00 00 00       	call   800107 <exit>
}
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800111:	e8 9d 12 00 00       	call   8013b3 <close_all>
	sys_env_destroy(0);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	6a 00                	push   $0x0
  80011b:	e8 1b 0a 00 00       	call   800b3b <sys_env_destroy>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800125:	f3 0f 1e fb          	endbr32 
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	53                   	push   %ebx
  80012d:	83 ec 04             	sub    $0x4,%esp
  800130:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800133:	8b 13                	mov    (%ebx),%edx
  800135:	8d 42 01             	lea    0x1(%edx),%eax
  800138:	89 03                	mov    %eax,(%ebx)
  80013a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800141:	3d ff 00 00 00       	cmp    $0xff,%eax
  800146:	74 09                	je     800151 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800148:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80014c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014f:	c9                   	leave  
  800150:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	68 ff 00 00 00       	push   $0xff
  800159:	8d 43 08             	lea    0x8(%ebx),%eax
  80015c:	50                   	push   %eax
  80015d:	e8 87 09 00 00       	call   800ae9 <sys_cputs>
		b->idx = 0;
  800162:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	eb db                	jmp    800148 <putch+0x23>

0080016d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80016d:	f3 0f 1e fb          	endbr32 
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80017a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800181:	00 00 00 
	b.cnt = 0;
  800184:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019a:	50                   	push   %eax
  80019b:	68 25 01 80 00       	push   $0x800125
  8001a0:	e8 80 01 00 00       	call   800325 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a5:	83 c4 08             	add    $0x8,%esp
  8001a8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ae:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	e8 2f 09 00 00       	call   800ae9 <sys_cputs>

	return b.cnt;
}
  8001ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c2:	f3 0f 1e fb          	endbr32 
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cf:	50                   	push   %eax
  8001d0:	ff 75 08             	pushl  0x8(%ebp)
  8001d3:	e8 95 ff ff ff       	call   80016d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    

008001da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 1c             	sub    $0x1c,%esp
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 d6                	mov    %edx,%esi
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ed:	89 d1                	mov    %edx,%ecx
  8001ef:	89 c2                	mov    %eax,%edx
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800200:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800207:	39 c2                	cmp    %eax,%edx
  800209:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80020c:	72 3e                	jb     80024c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	ff 75 18             	pushl  0x18(%ebp)
  800214:	83 eb 01             	sub    $0x1,%ebx
  800217:	53                   	push   %ebx
  800218:	50                   	push   %eax
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021f:	ff 75 e0             	pushl  -0x20(%ebp)
  800222:	ff 75 dc             	pushl  -0x24(%ebp)
  800225:	ff 75 d8             	pushl  -0x28(%ebp)
  800228:	e8 53 1f 00 00       	call   802180 <__udivdi3>
  80022d:	83 c4 18             	add    $0x18,%esp
  800230:	52                   	push   %edx
  800231:	50                   	push   %eax
  800232:	89 f2                	mov    %esi,%edx
  800234:	89 f8                	mov    %edi,%eax
  800236:	e8 9f ff ff ff       	call   8001da <printnum>
  80023b:	83 c4 20             	add    $0x20,%esp
  80023e:	eb 13                	jmp    800253 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	56                   	push   %esi
  800244:	ff 75 18             	pushl  0x18(%ebp)
  800247:	ff d7                	call   *%edi
  800249:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	85 db                	test   %ebx,%ebx
  800251:	7f ed                	jg     800240 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025d:	ff 75 e0             	pushl  -0x20(%ebp)
  800260:	ff 75 dc             	pushl  -0x24(%ebp)
  800263:	ff 75 d8             	pushl  -0x28(%ebp)
  800266:	e8 25 20 00 00       	call   802290 <__umoddi3>
  80026b:	83 c4 14             	add    $0x14,%esp
  80026e:	0f be 80 80 24 80 00 	movsbl 0x802480(%eax),%eax
  800275:	50                   	push   %eax
  800276:	ff d7                	call   *%edi
}
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5e                   	pop    %esi
  800280:	5f                   	pop    %edi
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800283:	83 fa 01             	cmp    $0x1,%edx
  800286:	7f 13                	jg     80029b <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800288:	85 d2                	test   %edx,%edx
  80028a:	74 1c                	je     8002a8 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80028c:	8b 10                	mov    (%eax),%edx
  80028e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800291:	89 08                	mov    %ecx,(%eax)
  800293:	8b 02                	mov    (%edx),%eax
  800295:	ba 00 00 00 00       	mov    $0x0,%edx
  80029a:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80029b:	8b 10                	mov    (%eax),%edx
  80029d:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a0:	89 08                	mov    %ecx,(%eax)
  8002a2:	8b 02                	mov    (%edx),%eax
  8002a4:	8b 52 04             	mov    0x4(%edx),%edx
  8002a7:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ad:	89 08                	mov    %ecx,(%eax)
  8002af:	8b 02                	mov    (%edx),%eax
  8002b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b6:	c3                   	ret    

008002b7 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002b7:	83 fa 01             	cmp    $0x1,%edx
  8002ba:	7f 0f                	jg     8002cb <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8002bc:	85 d2                	test   %edx,%edx
  8002be:	74 18                	je     8002d8 <getint+0x21>
		return va_arg(*ap, long);
  8002c0:	8b 10                	mov    (%eax),%edx
  8002c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c5:	89 08                	mov    %ecx,(%eax)
  8002c7:	8b 02                	mov    (%edx),%eax
  8002c9:	99                   	cltd   
  8002ca:	c3                   	ret    
		return va_arg(*ap, long long);
  8002cb:	8b 10                	mov    (%eax),%edx
  8002cd:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d0:	89 08                	mov    %ecx,(%eax)
  8002d2:	8b 02                	mov    (%edx),%eax
  8002d4:	8b 52 04             	mov    0x4(%edx),%edx
  8002d7:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002d8:	8b 10                	mov    (%eax),%edx
  8002da:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 02                	mov    (%edx),%eax
  8002e1:	99                   	cltd   
}
  8002e2:	c3                   	ret    

008002e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e3:	f3 0f 1e fb          	endbr32 
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ed:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f1:	8b 10                	mov    (%eax),%edx
  8002f3:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f6:	73 0a                	jae    800302 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	88 02                	mov    %al,(%edx)
}
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <printfmt>:
{
  800304:	f3 0f 1e fb          	endbr32 
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800311:	50                   	push   %eax
  800312:	ff 75 10             	pushl  0x10(%ebp)
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 05 00 00 00       	call   800325 <vprintfmt>
}
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <vprintfmt>:
{
  800325:	f3 0f 1e fb          	endbr32 
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	57                   	push   %edi
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
  80032f:	83 ec 2c             	sub    $0x2c,%esp
  800332:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800335:	8b 75 0c             	mov    0xc(%ebp),%esi
  800338:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033b:	e9 86 02 00 00       	jmp    8005c6 <vprintfmt+0x2a1>
		padc = ' ';
  800340:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800344:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80034b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800352:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800359:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8d 47 01             	lea    0x1(%edi),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800364:	0f b6 17             	movzbl (%edi),%edx
  800367:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036a:	3c 55                	cmp    $0x55,%al
  80036c:	0f 87 df 02 00 00    	ja     800651 <vprintfmt+0x32c>
  800372:	0f b6 c0             	movzbl %al,%eax
  800375:	3e ff 24 85 c0 25 80 	notrack jmp *0x8025c0(,%eax,4)
  80037c:	00 
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800380:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800384:	eb d8                	jmp    80035e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800389:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80038d:	eb cf                	jmp    80035e <vprintfmt+0x39>
  80038f:	0f b6 d2             	movzbl %dl,%edx
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800395:	b8 00 00 00 00       	mov    $0x0,%eax
  80039a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003aa:	83 f9 09             	cmp    $0x9,%ecx
  8003ad:	77 52                	ja     800401 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8003af:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b2:	eb e9                	jmp    80039d <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	8d 50 04             	lea    0x4(%eax),%edx
  8003ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c9:	79 93                	jns    80035e <vprintfmt+0x39>
				width = precision, precision = -1;
  8003cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d8:	eb 84                	jmp    80035e <vprintfmt+0x39>
  8003da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003dd:	85 c0                	test   %eax,%eax
  8003df:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e4:	0f 49 d0             	cmovns %eax,%edx
  8003e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ed:	e9 6c ff ff ff       	jmp    80035e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fc:	e9 5d ff ff ff       	jmp    80035e <vprintfmt+0x39>
  800401:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800404:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800407:	eb bc                	jmp    8003c5 <vprintfmt+0xa0>
			lflag++;
  800409:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040f:	e9 4a ff ff ff       	jmp    80035e <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8d 50 04             	lea    0x4(%eax),%edx
  80041a:	89 55 14             	mov    %edx,0x14(%ebp)
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	56                   	push   %esi
  800421:	ff 30                	pushl  (%eax)
  800423:	ff d3                	call   *%ebx
			break;
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	e9 96 01 00 00       	jmp    8005c3 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8d 50 04             	lea    0x4(%eax),%edx
  800433:	89 55 14             	mov    %edx,0x14(%ebp)
  800436:	8b 00                	mov    (%eax),%eax
  800438:	99                   	cltd   
  800439:	31 d0                	xor    %edx,%eax
  80043b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043d:	83 f8 0f             	cmp    $0xf,%eax
  800440:	7f 20                	jg     800462 <vprintfmt+0x13d>
  800442:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  800449:	85 d2                	test   %edx,%edx
  80044b:	74 15                	je     800462 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80044d:	52                   	push   %edx
  80044e:	68 1b 2a 80 00       	push   $0x802a1b
  800453:	56                   	push   %esi
  800454:	53                   	push   %ebx
  800455:	e8 aa fe ff ff       	call   800304 <printfmt>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	e9 61 01 00 00       	jmp    8005c3 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800462:	50                   	push   %eax
  800463:	68 98 24 80 00       	push   $0x802498
  800468:	56                   	push   %esi
  800469:	53                   	push   %ebx
  80046a:	e8 95 fe ff ff       	call   800304 <printfmt>
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	e9 4c 01 00 00       	jmp    8005c3 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 50 04             	lea    0x4(%eax),%edx
  80047d:	89 55 14             	mov    %edx,0x14(%ebp)
  800480:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800482:	85 c9                	test   %ecx,%ecx
  800484:	b8 91 24 80 00       	mov    $0x802491,%eax
  800489:	0f 45 c1             	cmovne %ecx,%eax
  80048c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80048f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800493:	7e 06                	jle    80049b <vprintfmt+0x176>
  800495:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800499:	75 0d                	jne    8004a8 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049e:	89 c7                	mov    %eax,%edi
  8004a0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a6:	eb 57                	jmp    8004ff <vprintfmt+0x1da>
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ae:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b1:	e8 4f 02 00 00       	call   800705 <strnlen>
  8004b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b9:	29 c2                	sub    %eax,%edx
  8004bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004be:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8004c5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8004c8:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	7e 10                	jle    8004de <vprintfmt+0x1b9>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	56                   	push   %esi
  8004d2:	57                   	push   %edi
  8004d3:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d6:	83 eb 01             	sub    $0x1,%ebx
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	eb ec                	jmp    8004ca <vprintfmt+0x1a5>
  8004de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e4:	85 d2                	test   %edx,%edx
  8004e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004eb:	0f 49 c2             	cmovns %edx,%eax
  8004ee:	29 c2                	sub    %eax,%edx
  8004f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f3:	eb a6                	jmp    80049b <vprintfmt+0x176>
					putch(ch, putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	56                   	push   %esi
  8004f9:	52                   	push   %edx
  8004fa:	ff d3                	call   *%ebx
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800502:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800504:	83 c7 01             	add    $0x1,%edi
  800507:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050b:	0f be d0             	movsbl %al,%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 42                	je     800554 <vprintfmt+0x22f>
  800512:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800516:	78 06                	js     80051e <vprintfmt+0x1f9>
  800518:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051c:	78 1e                	js     80053c <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80051e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800522:	74 d1                	je     8004f5 <vprintfmt+0x1d0>
  800524:	0f be c0             	movsbl %al,%eax
  800527:	83 e8 20             	sub    $0x20,%eax
  80052a:	83 f8 5e             	cmp    $0x5e,%eax
  80052d:	76 c6                	jbe    8004f5 <vprintfmt+0x1d0>
					putch('?', putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	56                   	push   %esi
  800533:	6a 3f                	push   $0x3f
  800535:	ff d3                	call   *%ebx
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	eb c3                	jmp    8004ff <vprintfmt+0x1da>
  80053c:	89 cf                	mov    %ecx,%edi
  80053e:	eb 0e                	jmp    80054e <vprintfmt+0x229>
				putch(' ', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	56                   	push   %esi
  800544:	6a 20                	push   $0x20
  800546:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	85 ff                	test   %edi,%edi
  800550:	7f ee                	jg     800540 <vprintfmt+0x21b>
  800552:	eb 6f                	jmp    8005c3 <vprintfmt+0x29e>
  800554:	89 cf                	mov    %ecx,%edi
  800556:	eb f6                	jmp    80054e <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800558:	89 ca                	mov    %ecx,%edx
  80055a:	8d 45 14             	lea    0x14(%ebp),%eax
  80055d:	e8 55 fd ff ff       	call   8002b7 <getint>
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800568:	85 d2                	test   %edx,%edx
  80056a:	78 0b                	js     800577 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80056c:	89 d1                	mov    %edx,%ecx
  80056e:	89 c2                	mov    %eax,%edx
			base = 10;
  800570:	b8 0a 00 00 00       	mov    $0xa,%eax
  800575:	eb 32                	jmp    8005a9 <vprintfmt+0x284>
				putch('-', putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	56                   	push   %esi
  80057b:	6a 2d                	push   $0x2d
  80057d:	ff d3                	call   *%ebx
				num = -(long long) num;
  80057f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800582:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800585:	f7 da                	neg    %edx
  800587:	83 d1 00             	adc    $0x0,%ecx
  80058a:	f7 d9                	neg    %ecx
  80058c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800594:	eb 13                	jmp    8005a9 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800596:	89 ca                	mov    %ecx,%edx
  800598:	8d 45 14             	lea    0x14(%ebp),%eax
  80059b:	e8 e3 fc ff ff       	call   800283 <getuint>
  8005a0:	89 d1                	mov    %edx,%ecx
  8005a2:	89 c2                	mov    %eax,%edx
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005a9:	83 ec 0c             	sub    $0xc,%esp
  8005ac:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005b0:	57                   	push   %edi
  8005b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b4:	50                   	push   %eax
  8005b5:	51                   	push   %ecx
  8005b6:	52                   	push   %edx
  8005b7:	89 f2                	mov    %esi,%edx
  8005b9:	89 d8                	mov    %ebx,%eax
  8005bb:	e8 1a fc ff ff       	call   8001da <printnum>
			break;
  8005c0:	83 c4 20             	add    $0x20,%esp
{
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c6:	83 c7 01             	add    $0x1,%edi
  8005c9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005cd:	83 f8 25             	cmp    $0x25,%eax
  8005d0:	0f 84 6a fd ff ff    	je     800340 <vprintfmt+0x1b>
			if (ch == '\0')
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	0f 84 93 00 00 00    	je     800671 <vprintfmt+0x34c>
			putch(ch, putdat);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	56                   	push   %esi
  8005e2:	50                   	push   %eax
  8005e3:	ff d3                	call   *%ebx
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	eb dc                	jmp    8005c6 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005ea:	89 ca                	mov    %ecx,%edx
  8005ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ef:	e8 8f fc ff ff       	call   800283 <getuint>
  8005f4:	89 d1                	mov    %edx,%ecx
  8005f6:	89 c2                	mov    %eax,%edx
			base = 8;
  8005f8:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005fd:	eb aa                	jmp    8005a9 <vprintfmt+0x284>
			putch('0', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	56                   	push   %esi
  800603:	6a 30                	push   $0x30
  800605:	ff d3                	call   *%ebx
			putch('x', putdat);
  800607:	83 c4 08             	add    $0x8,%esp
  80060a:	56                   	push   %esi
  80060b:	6a 78                	push   $0x78
  80060d:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 50 04             	lea    0x4(%eax),%edx
  800615:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80061f:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800622:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800627:	eb 80                	jmp    8005a9 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800629:	89 ca                	mov    %ecx,%edx
  80062b:	8d 45 14             	lea    0x14(%ebp),%eax
  80062e:	e8 50 fc ff ff       	call   800283 <getuint>
  800633:	89 d1                	mov    %edx,%ecx
  800635:	89 c2                	mov    %eax,%edx
			base = 16;
  800637:	b8 10 00 00 00       	mov    $0x10,%eax
  80063c:	e9 68 ff ff ff       	jmp    8005a9 <vprintfmt+0x284>
			putch(ch, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	56                   	push   %esi
  800645:	6a 25                	push   $0x25
  800647:	ff d3                	call   *%ebx
			break;
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	e9 72 ff ff ff       	jmp    8005c3 <vprintfmt+0x29e>
			putch('%', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	56                   	push   %esi
  800655:	6a 25                	push   $0x25
  800657:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	89 f8                	mov    %edi,%eax
  80065e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800662:	74 05                	je     800669 <vprintfmt+0x344>
  800664:	83 e8 01             	sub    $0x1,%eax
  800667:	eb f5                	jmp    80065e <vprintfmt+0x339>
  800669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066c:	e9 52 ff ff ff       	jmp    8005c3 <vprintfmt+0x29e>
}
  800671:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800674:	5b                   	pop    %ebx
  800675:	5e                   	pop    %esi
  800676:	5f                   	pop    %edi
  800677:	5d                   	pop    %ebp
  800678:	c3                   	ret    

00800679 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800679:	f3 0f 1e fb          	endbr32 
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 18             	sub    $0x18,%esp
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800689:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80068c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800690:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80069a:	85 c0                	test   %eax,%eax
  80069c:	74 26                	je     8006c4 <vsnprintf+0x4b>
  80069e:	85 d2                	test   %edx,%edx
  8006a0:	7e 22                	jle    8006c4 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006a2:	ff 75 14             	pushl  0x14(%ebp)
  8006a5:	ff 75 10             	pushl  0x10(%ebp)
  8006a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	68 e3 02 80 00       	push   $0x8002e3
  8006b1:	e8 6f fc ff ff       	call   800325 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
}
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    
		return -E_INVAL;
  8006c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c9:	eb f7                	jmp    8006c2 <vsnprintf+0x49>

008006cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006cb:	f3 0f 1e fb          	endbr32 
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006d5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006d8:	50                   	push   %eax
  8006d9:	ff 75 10             	pushl  0x10(%ebp)
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	ff 75 08             	pushl  0x8(%ebp)
  8006e2:	e8 92 ff ff ff       	call   800679 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006e9:	f3 0f 1e fb          	endbr32 
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006fc:	74 05                	je     800703 <strlen+0x1a>
		n++;
  8006fe:	83 c0 01             	add    $0x1,%eax
  800701:	eb f5                	jmp    8006f8 <strlen+0xf>
	return n;
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800705:	f3 0f 1e fb          	endbr32 
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80070f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800712:	b8 00 00 00 00       	mov    $0x0,%eax
  800717:	39 d0                	cmp    %edx,%eax
  800719:	74 0d                	je     800728 <strnlen+0x23>
  80071b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80071f:	74 05                	je     800726 <strnlen+0x21>
		n++;
  800721:	83 c0 01             	add    $0x1,%eax
  800724:	eb f1                	jmp    800717 <strnlen+0x12>
  800726:	89 c2                	mov    %eax,%edx
	return n;
}
  800728:	89 d0                	mov    %edx,%eax
  80072a:	5d                   	pop    %ebp
  80072b:	c3                   	ret    

0080072c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80072c:	f3 0f 1e fb          	endbr32 
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	53                   	push   %ebx
  800734:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800737:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800743:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800746:	83 c0 01             	add    $0x1,%eax
  800749:	84 d2                	test   %dl,%dl
  80074b:	75 f2                	jne    80073f <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80074d:	89 c8                	mov    %ecx,%eax
  80074f:	5b                   	pop    %ebx
  800750:	5d                   	pop    %ebp
  800751:	c3                   	ret    

00800752 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800752:	f3 0f 1e fb          	endbr32 
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	53                   	push   %ebx
  80075a:	83 ec 10             	sub    $0x10,%esp
  80075d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800760:	53                   	push   %ebx
  800761:	e8 83 ff ff ff       	call   8006e9 <strlen>
  800766:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	01 d8                	add    %ebx,%eax
  80076e:	50                   	push   %eax
  80076f:	e8 b8 ff ff ff       	call   80072c <strcpy>
	return dst;
}
  800774:	89 d8                	mov    %ebx,%eax
  800776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80077b:	f3 0f 1e fb          	endbr32 
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	8b 75 08             	mov    0x8(%ebp),%esi
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078a:	89 f3                	mov    %esi,%ebx
  80078c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80078f:	89 f0                	mov    %esi,%eax
  800791:	39 d8                	cmp    %ebx,%eax
  800793:	74 11                	je     8007a6 <strncpy+0x2b>
		*dst++ = *src;
  800795:	83 c0 01             	add    $0x1,%eax
  800798:	0f b6 0a             	movzbl (%edx),%ecx
  80079b:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80079e:	80 f9 01             	cmp    $0x1,%cl
  8007a1:	83 da ff             	sbb    $0xffffffff,%edx
  8007a4:	eb eb                	jmp    800791 <strncpy+0x16>
	}
	return ret;
}
  8007a6:	89 f0                	mov    %esi,%eax
  8007a8:	5b                   	pop    %ebx
  8007a9:	5e                   	pop    %esi
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	56                   	push   %esi
  8007b4:	53                   	push   %ebx
  8007b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007bb:	8b 55 10             	mov    0x10(%ebp),%edx
  8007be:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c0:	85 d2                	test   %edx,%edx
  8007c2:	74 21                	je     8007e5 <strlcpy+0x39>
  8007c4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007c8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007ca:	39 c2                	cmp    %eax,%edx
  8007cc:	74 14                	je     8007e2 <strlcpy+0x36>
  8007ce:	0f b6 19             	movzbl (%ecx),%ebx
  8007d1:	84 db                	test   %bl,%bl
  8007d3:	74 0b                	je     8007e0 <strlcpy+0x34>
			*dst++ = *src++;
  8007d5:	83 c1 01             	add    $0x1,%ecx
  8007d8:	83 c2 01             	add    $0x1,%edx
  8007db:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007de:	eb ea                	jmp    8007ca <strlcpy+0x1e>
  8007e0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007e2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007e5:	29 f0                	sub    %esi,%eax
}
  8007e7:	5b                   	pop    %ebx
  8007e8:	5e                   	pop    %esi
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007eb:	f3 0f 1e fb          	endbr32 
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007f8:	0f b6 01             	movzbl (%ecx),%eax
  8007fb:	84 c0                	test   %al,%al
  8007fd:	74 0c                	je     80080b <strcmp+0x20>
  8007ff:	3a 02                	cmp    (%edx),%al
  800801:	75 08                	jne    80080b <strcmp+0x20>
		p++, q++;
  800803:	83 c1 01             	add    $0x1,%ecx
  800806:	83 c2 01             	add    $0x1,%edx
  800809:	eb ed                	jmp    8007f8 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80080b:	0f b6 c0             	movzbl %al,%eax
  80080e:	0f b6 12             	movzbl (%edx),%edx
  800811:	29 d0                	sub    %edx,%eax
}
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800815:	f3 0f 1e fb          	endbr32 
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	53                   	push   %ebx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 55 0c             	mov    0xc(%ebp),%edx
  800823:	89 c3                	mov    %eax,%ebx
  800825:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800828:	eb 06                	jmp    800830 <strncmp+0x1b>
		n--, p++, q++;
  80082a:	83 c0 01             	add    $0x1,%eax
  80082d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800830:	39 d8                	cmp    %ebx,%eax
  800832:	74 16                	je     80084a <strncmp+0x35>
  800834:	0f b6 08             	movzbl (%eax),%ecx
  800837:	84 c9                	test   %cl,%cl
  800839:	74 04                	je     80083f <strncmp+0x2a>
  80083b:	3a 0a                	cmp    (%edx),%cl
  80083d:	74 eb                	je     80082a <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80083f:	0f b6 00             	movzbl (%eax),%eax
  800842:	0f b6 12             	movzbl (%edx),%edx
  800845:	29 d0                	sub    %edx,%eax
}
  800847:	5b                   	pop    %ebx
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    
		return 0;
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	eb f6                	jmp    800847 <strncmp+0x32>

00800851 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800851:	f3 0f 1e fb          	endbr32 
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085f:	0f b6 10             	movzbl (%eax),%edx
  800862:	84 d2                	test   %dl,%dl
  800864:	74 09                	je     80086f <strchr+0x1e>
		if (*s == c)
  800866:	38 ca                	cmp    %cl,%dl
  800868:	74 0a                	je     800874 <strchr+0x23>
	for (; *s; s++)
  80086a:	83 c0 01             	add    $0x1,%eax
  80086d:	eb f0                	jmp    80085f <strchr+0xe>
			return (char *) s;
	return 0;
  80086f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800876:	f3 0f 1e fb          	endbr32 
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800884:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800887:	38 ca                	cmp    %cl,%dl
  800889:	74 09                	je     800894 <strfind+0x1e>
  80088b:	84 d2                	test   %dl,%dl
  80088d:	74 05                	je     800894 <strfind+0x1e>
	for (; *s; s++)
  80088f:	83 c0 01             	add    $0x1,%eax
  800892:	eb f0                	jmp    800884 <strfind+0xe>
			break;
	return (char *) s;
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	57                   	push   %edi
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008a6:	85 c9                	test   %ecx,%ecx
  8008a8:	74 33                	je     8008dd <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008aa:	89 d0                	mov    %edx,%eax
  8008ac:	09 c8                	or     %ecx,%eax
  8008ae:	a8 03                	test   $0x3,%al
  8008b0:	75 23                	jne    8008d5 <memset+0x3f>
		c &= 0xFF;
  8008b2:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008b6:	89 d8                	mov    %ebx,%eax
  8008b8:	c1 e0 08             	shl    $0x8,%eax
  8008bb:	89 df                	mov    %ebx,%edi
  8008bd:	c1 e7 18             	shl    $0x18,%edi
  8008c0:	89 de                	mov    %ebx,%esi
  8008c2:	c1 e6 10             	shl    $0x10,%esi
  8008c5:	09 f7                	or     %esi,%edi
  8008c7:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008c9:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008cc:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8008ce:	89 d7                	mov    %edx,%edi
  8008d0:	fc                   	cld    
  8008d1:	f3 ab                	rep stos %eax,%es:(%edi)
  8008d3:	eb 08                	jmp    8008dd <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d5:	89 d7                	mov    %edx,%edi
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	fc                   	cld    
  8008db:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008dd:	89 d0                	mov    %edx,%eax
  8008df:	5b                   	pop    %ebx
  8008e0:	5e                   	pop    %esi
  8008e1:	5f                   	pop    %edi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	57                   	push   %edi
  8008ec:	56                   	push   %esi
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008f6:	39 c6                	cmp    %eax,%esi
  8008f8:	73 32                	jae    80092c <memmove+0x48>
  8008fa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008fd:	39 c2                	cmp    %eax,%edx
  8008ff:	76 2b                	jbe    80092c <memmove+0x48>
		s += n;
		d += n;
  800901:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800904:	89 fe                	mov    %edi,%esi
  800906:	09 ce                	or     %ecx,%esi
  800908:	09 d6                	or     %edx,%esi
  80090a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800910:	75 0e                	jne    800920 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800912:	83 ef 04             	sub    $0x4,%edi
  800915:	8d 72 fc             	lea    -0x4(%edx),%esi
  800918:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80091b:	fd                   	std    
  80091c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80091e:	eb 09                	jmp    800929 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800920:	83 ef 01             	sub    $0x1,%edi
  800923:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800926:	fd                   	std    
  800927:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800929:	fc                   	cld    
  80092a:	eb 1a                	jmp    800946 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	09 ca                	or     %ecx,%edx
  800930:	09 f2                	or     %esi,%edx
  800932:	f6 c2 03             	test   $0x3,%dl
  800935:	75 0a                	jne    800941 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800937:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80093a:	89 c7                	mov    %eax,%edi
  80093c:	fc                   	cld    
  80093d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80093f:	eb 05                	jmp    800946 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800941:	89 c7                	mov    %eax,%edi
  800943:	fc                   	cld    
  800944:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800946:	5e                   	pop    %esi
  800947:	5f                   	pop    %edi
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80094a:	f3 0f 1e fb          	endbr32 
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800954:	ff 75 10             	pushl  0x10(%ebp)
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 82 ff ff ff       	call   8008e4 <memmove>
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800964:	f3 0f 1e fb          	endbr32 
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	89 c6                	mov    %eax,%esi
  800975:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800978:	39 f0                	cmp    %esi,%eax
  80097a:	74 1c                	je     800998 <memcmp+0x34>
		if (*s1 != *s2)
  80097c:	0f b6 08             	movzbl (%eax),%ecx
  80097f:	0f b6 1a             	movzbl (%edx),%ebx
  800982:	38 d9                	cmp    %bl,%cl
  800984:	75 08                	jne    80098e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	eb ea                	jmp    800978 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80098e:	0f b6 c1             	movzbl %cl,%eax
  800991:	0f b6 db             	movzbl %bl,%ebx
  800994:	29 d8                	sub    %ebx,%eax
  800996:	eb 05                	jmp    80099d <memcmp+0x39>
	}

	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009b3:	39 d0                	cmp    %edx,%eax
  8009b5:	73 09                	jae    8009c0 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009b7:	38 08                	cmp    %cl,(%eax)
  8009b9:	74 05                	je     8009c0 <memfind+0x1f>
	for (; s < ends; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	eb f3                	jmp    8009b3 <memfind+0x12>
			break;
	return (void *) s;
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009c2:	f3 0f 1e fb          	endbr32 
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	57                   	push   %edi
  8009ca:	56                   	push   %esi
  8009cb:	53                   	push   %ebx
  8009cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009d2:	eb 03                	jmp    8009d7 <strtol+0x15>
		s++;
  8009d4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009d7:	0f b6 01             	movzbl (%ecx),%eax
  8009da:	3c 20                	cmp    $0x20,%al
  8009dc:	74 f6                	je     8009d4 <strtol+0x12>
  8009de:	3c 09                	cmp    $0x9,%al
  8009e0:	74 f2                	je     8009d4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009e2:	3c 2b                	cmp    $0x2b,%al
  8009e4:	74 2a                	je     800a10 <strtol+0x4e>
	int neg = 0;
  8009e6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009eb:	3c 2d                	cmp    $0x2d,%al
  8009ed:	74 2b                	je     800a1a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ef:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009f5:	75 0f                	jne    800a06 <strtol+0x44>
  8009f7:	80 39 30             	cmpb   $0x30,(%ecx)
  8009fa:	74 28                	je     800a24 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009fc:	85 db                	test   %ebx,%ebx
  8009fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a03:	0f 44 d8             	cmove  %eax,%ebx
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a0e:	eb 46                	jmp    800a56 <strtol+0x94>
		s++;
  800a10:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a13:	bf 00 00 00 00       	mov    $0x0,%edi
  800a18:	eb d5                	jmp    8009ef <strtol+0x2d>
		s++, neg = 1;
  800a1a:	83 c1 01             	add    $0x1,%ecx
  800a1d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a22:	eb cb                	jmp    8009ef <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a24:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a28:	74 0e                	je     800a38 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a2a:	85 db                	test   %ebx,%ebx
  800a2c:	75 d8                	jne    800a06 <strtol+0x44>
		s++, base = 8;
  800a2e:	83 c1 01             	add    $0x1,%ecx
  800a31:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a36:	eb ce                	jmp    800a06 <strtol+0x44>
		s += 2, base = 16;
  800a38:	83 c1 02             	add    $0x2,%ecx
  800a3b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a40:	eb c4                	jmp    800a06 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a42:	0f be d2             	movsbl %dl,%edx
  800a45:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a48:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a4b:	7d 3a                	jge    800a87 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a54:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a56:	0f b6 11             	movzbl (%ecx),%edx
  800a59:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a5c:	89 f3                	mov    %esi,%ebx
  800a5e:	80 fb 09             	cmp    $0x9,%bl
  800a61:	76 df                	jbe    800a42 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a63:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a66:	89 f3                	mov    %esi,%ebx
  800a68:	80 fb 19             	cmp    $0x19,%bl
  800a6b:	77 08                	ja     800a75 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a6d:	0f be d2             	movsbl %dl,%edx
  800a70:	83 ea 57             	sub    $0x57,%edx
  800a73:	eb d3                	jmp    800a48 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a75:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a78:	89 f3                	mov    %esi,%ebx
  800a7a:	80 fb 19             	cmp    $0x19,%bl
  800a7d:	77 08                	ja     800a87 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a7f:	0f be d2             	movsbl %dl,%edx
  800a82:	83 ea 37             	sub    $0x37,%edx
  800a85:	eb c1                	jmp    800a48 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8b:	74 05                	je     800a92 <strtol+0xd0>
		*endptr = (char *) s;
  800a8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a90:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a92:	89 c2                	mov    %eax,%edx
  800a94:	f7 da                	neg    %edx
  800a96:	85 ff                	test   %edi,%edi
  800a98:	0f 45 c2             	cmovne %edx,%eax
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	57                   	push   %edi
  800aa4:	56                   	push   %esi
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 1c             	sub    $0x1c,%esp
  800aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800aaf:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ab1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ab7:	8b 7d 10             	mov    0x10(%ebp),%edi
  800aba:	8b 75 14             	mov    0x14(%ebp),%esi
  800abd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac3:	74 04                	je     800ac9 <syscall+0x29>
  800ac5:	85 c0                	test   %eax,%eax
  800ac7:	7f 08                	jg     800ad1 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	50                   	push   %eax
  800ad5:	ff 75 e0             	pushl  -0x20(%ebp)
  800ad8:	68 7f 27 80 00       	push   $0x80277f
  800add:	6a 23                	push   $0x23
  800adf:	68 9c 27 80 00       	push   $0x80279c
  800ae4:	e8 5f 14 00 00       	call   801f48 <_panic>

00800ae9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ae9:	f3 0f 1e fb          	endbr32 
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800af3:	6a 00                	push   $0x0
  800af5:	6a 00                	push   $0x0
  800af7:	6a 00                	push   $0x0
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aff:	ba 00 00 00 00       	mov    $0x0,%edx
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
  800b09:	e8 92 ff ff ff       	call   800aa0 <syscall>
}
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b13:	f3 0f 1e fb          	endbr32 
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b1d:	6a 00                	push   $0x0
  800b1f:	6a 00                	push   $0x0
  800b21:	6a 00                	push   $0x0
  800b23:	6a 00                	push   $0x0
  800b25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b34:	e8 67 ff ff ff       	call   800aa0 <syscall>
}
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b3b:	f3 0f 1e fb          	endbr32 
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b45:	6a 00                	push   $0x0
  800b47:	6a 00                	push   $0x0
  800b49:	6a 00                	push   $0x0
  800b4b:	6a 00                	push   $0x0
  800b4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b50:	ba 01 00 00 00       	mov    $0x1,%edx
  800b55:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5a:	e8 41 ff ff ff       	call   800aa0 <syscall>
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b61:	f3 0f 1e fb          	endbr32 
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b6b:	6a 00                	push   $0x0
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	6a 00                	push   $0x0
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b82:	e8 19 ff ff ff       	call   800aa0 <syscall>
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <sys_yield>:

void
sys_yield(void)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b93:	6a 00                	push   $0x0
  800b95:	6a 00                	push   $0x0
  800b97:	6a 00                	push   $0x0
  800b99:	6a 00                	push   $0x0
  800b9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800baa:	e8 f1 fe ff ff       	call   800aa0 <syscall>
}
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb4:	f3 0f 1e fb          	endbr32 
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bbe:	6a 00                	push   $0x0
  800bc0:	6a 00                	push   $0x0
  800bc2:	ff 75 10             	pushl  0x10(%ebp)
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcb:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd0:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd5:	e8 c6 fe ff ff       	call   800aa0 <syscall>
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bdc:	f3 0f 1e fb          	endbr32 
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800be6:	ff 75 18             	pushl  0x18(%ebp)
  800be9:	ff 75 14             	pushl  0x14(%ebp)
  800bec:	ff 75 10             	pushl  0x10(%ebp)
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf5:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfa:	b8 05 00 00 00       	mov    $0x5,%eax
  800bff:	e8 9c fe ff ff       	call   800aa0 <syscall>
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c06:	f3 0f 1e fb          	endbr32 
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c10:	6a 00                	push   $0x0
  800c12:	6a 00                	push   $0x0
  800c14:	6a 00                	push   $0x0
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c21:	b8 06 00 00 00       	mov    $0x6,%eax
  800c26:	e8 75 fe ff ff       	call   800aa0 <syscall>
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	6a 00                	push   $0x0
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c43:	ba 01 00 00 00       	mov    $0x1,%edx
  800c48:	b8 08 00 00 00       	mov    $0x8,%eax
  800c4d:	e8 4e fe ff ff       	call   800aa0 <syscall>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c5e:	6a 00                	push   $0x0
  800c60:	6a 00                	push   $0x0
  800c62:	6a 00                	push   $0x0
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6f:	b8 09 00 00 00       	mov    $0x9,%eax
  800c74:	e8 27 fe ff ff       	call   800aa0 <syscall>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c85:	6a 00                	push   $0x0
  800c87:	6a 00                	push   $0x0
  800c89:	6a 00                	push   $0x0
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	ba 01 00 00 00       	mov    $0x1,%edx
  800c96:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9b:	e8 00 fe ff ff       	call   800aa0 <syscall>
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cac:	6a 00                	push   $0x0
  800cae:	ff 75 14             	pushl  0x14(%ebp)
  800cb1:	ff 75 10             	pushl  0x10(%ebp)
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc4:	e8 d7 fd ff ff       	call   800aa0 <syscall>
}
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ccb:	f3 0f 1e fb          	endbr32 
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cd5:	6a 00                	push   $0x0
  800cd7:	6a 00                	push   $0x0
  800cd9:	6a 00                	push   $0x0
  800cdb:	6a 00                	push   $0x0
  800cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cea:	e8 b1 fd ff ff       	call   800aa0 <syscall>
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	53                   	push   %ebx
  800cf5:	83 ec 04             	sub    $0x4,%esp
  800cf8:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800cfa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d01:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d04:	f6 c6 04             	test   $0x4,%dh
  800d07:	75 51                	jne    800d5a <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d09:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d0f:	0f 84 84 00 00 00    	je     800d99 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800d15:	83 ec 0c             	sub    $0xc,%esp
  800d18:	68 05 08 00 00       	push   $0x805
  800d1d:	53                   	push   %ebx
  800d1e:	50                   	push   %eax
  800d1f:	53                   	push   %ebx
  800d20:	6a 00                	push   $0x0
  800d22:	e8 b5 fe ff ff       	call   800bdc <sys_page_map>
		if (r)
  800d27:	83 c4 20             	add    $0x20,%esp
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	75 59                	jne    800d87 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	68 05 08 00 00       	push   $0x805
  800d36:	53                   	push   %ebx
  800d37:	6a 00                	push   $0x0
  800d39:	53                   	push   %ebx
  800d3a:	6a 00                	push   $0x0
  800d3c:	e8 9b fe ff ff       	call   800bdc <sys_page_map>
		if (r)
  800d41:	83 c4 20             	add    $0x20,%esp
  800d44:	85 c0                	test   %eax,%eax
  800d46:	74 67                	je     800daf <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d48:	50                   	push   %eax
  800d49:	68 aa 27 80 00       	push   $0x8027aa
  800d4e:	6a 5f                	push   $0x5f
  800d50:	68 c5 27 80 00       	push   $0x8027c5
  800d55:	e8 ee 11 00 00       	call   801f48 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d63:	52                   	push   %edx
  800d64:	53                   	push   %ebx
  800d65:	50                   	push   %eax
  800d66:	53                   	push   %ebx
  800d67:	6a 00                	push   $0x0
  800d69:	e8 6e fe ff ff       	call   800bdc <sys_page_map>
		if (r)
  800d6e:	83 c4 20             	add    $0x20,%esp
  800d71:	85 c0                	test   %eax,%eax
  800d73:	74 3a                	je     800daf <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d75:	50                   	push   %eax
  800d76:	68 aa 27 80 00       	push   $0x8027aa
  800d7b:	6a 57                	push   $0x57
  800d7d:	68 c5 27 80 00       	push   $0x8027c5
  800d82:	e8 c1 11 00 00       	call   801f48 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800d87:	50                   	push   %eax
  800d88:	68 aa 27 80 00       	push   $0x8027aa
  800d8d:	6a 5b                	push   $0x5b
  800d8f:	68 c5 27 80 00       	push   $0x8027c5
  800d94:	e8 af 11 00 00       	call   801f48 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	6a 05                	push   $0x5
  800d9e:	53                   	push   %ebx
  800d9f:	50                   	push   %eax
  800da0:	53                   	push   %ebx
  800da1:	6a 00                	push   $0x0
  800da3:	e8 34 fe ff ff       	call   800bdc <sys_page_map>
		if (r)
  800da8:	83 c4 20             	add    $0x20,%esp
  800dab:	85 c0                	test   %eax,%eax
  800dad:	75 0a                	jne    800db9 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
  800db4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800db9:	50                   	push   %eax
  800dba:	68 aa 27 80 00       	push   $0x8027aa
  800dbf:	6a 63                	push   $0x63
  800dc1:	68 c5 27 80 00       	push   $0x8027c5
  800dc6:	e8 7d 11 00 00       	call   801f48 <_panic>

00800dcb <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
  800dd4:	89 c7                	mov    %eax,%edi
  800dd6:	89 d6                	mov    %edx,%esi
  800dd8:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800dda:	f6 c1 02             	test   $0x2,%cl
  800ddd:	75 2f                	jne    800e0e <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	51                   	push   %ecx
  800de3:	52                   	push   %edx
  800de4:	50                   	push   %eax
  800de5:	52                   	push   %edx
  800de6:	6a 00                	push   $0x0
  800de8:	e8 ef fd ff ff       	call   800bdc <sys_page_map>
  800ded:	83 c4 20             	add    $0x20,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	78 08                	js     800dfc <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800dfc:	50                   	push   %eax
  800dfd:	68 b4 27 80 00       	push   $0x8027b4
  800e02:	6a 6f                	push   $0x6f
  800e04:	68 c5 27 80 00       	push   $0x8027c5
  800e09:	e8 3a 11 00 00       	call   801f48 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	51                   	push   %ecx
  800e12:	52                   	push   %edx
  800e13:	50                   	push   %eax
  800e14:	e8 9b fd ff ff       	call   800bb4 <sys_page_alloc>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	78 54                	js     800e74 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	53                   	push   %ebx
  800e24:	68 00 00 40 00       	push   $0x400000
  800e29:	6a 00                	push   $0x0
  800e2b:	56                   	push   %esi
  800e2c:	57                   	push   %edi
  800e2d:	e8 aa fd ff ff       	call   800bdc <sys_page_map>
  800e32:	83 c4 20             	add    $0x20,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	78 4d                	js     800e86 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	68 00 10 00 00       	push   $0x1000
  800e41:	56                   	push   %esi
  800e42:	68 00 00 40 00       	push   $0x400000
  800e47:	e8 98 fa ff ff       	call   8008e4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800e4c:	83 c4 08             	add    $0x8,%esp
  800e4f:	68 00 00 40 00       	push   $0x400000
  800e54:	6a 00                	push   $0x0
  800e56:	e8 ab fd ff ff       	call   800c06 <sys_page_unmap>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	79 92                	jns    800df4 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800e62:	50                   	push   %eax
  800e63:	68 e3 27 80 00       	push   $0x8027e3
  800e68:	6a 78                	push   $0x78
  800e6a:	68 c5 27 80 00       	push   $0x8027c5
  800e6f:	e8 d4 10 00 00       	call   801f48 <_panic>
		panic("sys_page_alloc: %e", r);
  800e74:	50                   	push   %eax
  800e75:	68 d0 27 80 00       	push   $0x8027d0
  800e7a:	6a 73                	push   $0x73
  800e7c:	68 c5 27 80 00       	push   $0x8027c5
  800e81:	e8 c2 10 00 00       	call   801f48 <_panic>
		panic("sys_page_map: %e", r);
  800e86:	50                   	push   %eax
  800e87:	68 b4 27 80 00       	push   $0x8027b4
  800e8c:	6a 75                	push   $0x75
  800e8e:	68 c5 27 80 00       	push   $0x8027c5
  800e93:	e8 b0 10 00 00       	call   801f48 <_panic>

00800e98 <pgfault>:
{
  800e98:	f3 0f 1e fb          	endbr32 
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ea6:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ea8:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800eab:	89 da                	mov    %ebx,%edx
  800ead:	c1 ea 0c             	shr    $0xc,%edx
  800eb0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800eb7:	a8 01                	test   $0x1,%al
  800eb9:	74 7e                	je     800f39 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800ebb:	a8 02                	test   $0x2,%al
  800ebd:	0f 84 8a 00 00 00    	je     800f4d <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800ec3:	f6 c6 08             	test   $0x8,%dh
  800ec6:	0f 84 95 00 00 00    	je     800f61 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	6a 07                	push   $0x7
  800ed1:	68 00 f0 7f 00       	push   $0x7ff000
  800ed6:	6a 00                	push   $0x0
  800ed8:	e8 d7 fc ff ff       	call   800bb4 <sys_page_alloc>
	if (r)
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	0f 85 8d 00 00 00    	jne    800f75 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ee8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	68 00 10 00 00       	push   $0x1000
  800ef6:	53                   	push   %ebx
  800ef7:	68 00 f0 7f 00       	push   $0x7ff000
  800efc:	e8 49 fa ff ff       	call   80094a <memcpy>
	r = sys_page_map(
  800f01:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f08:	53                   	push   %ebx
  800f09:	6a 00                	push   $0x0
  800f0b:	68 00 f0 7f 00       	push   $0x7ff000
  800f10:	6a 00                	push   $0x0
  800f12:	e8 c5 fc ff ff       	call   800bdc <sys_page_map>
	if (r)
  800f17:	83 c4 20             	add    $0x20,%esp
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	75 69                	jne    800f87 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	68 00 f0 7f 00       	push   $0x7ff000
  800f26:	6a 00                	push   $0x0
  800f28:	e8 d9 fc ff ff       	call   800c06 <sys_page_unmap>
	if (r)
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	85 c0                	test   %eax,%eax
  800f32:	75 65                	jne    800f99 <pgfault+0x101>
}
  800f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	68 64 28 80 00       	push   $0x802864
  800f41:	6a 20                	push   $0x20
  800f43:	68 c5 27 80 00       	push   $0x8027c5
  800f48:	e8 fb 0f 00 00       	call   801f48 <_panic>
		panic("[pgfault] pgfault por lectura");
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 f6 27 80 00       	push   $0x8027f6
  800f55:	6a 23                	push   $0x23
  800f57:	68 c5 27 80 00       	push   $0x8027c5
  800f5c:	e8 e7 0f 00 00       	call   801f48 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	68 90 28 80 00       	push   $0x802890
  800f69:	6a 27                	push   $0x27
  800f6b:	68 c5 27 80 00       	push   $0x8027c5
  800f70:	e8 d3 0f 00 00       	call   801f48 <_panic>
		panic("pgfault: %e", r);
  800f75:	50                   	push   %eax
  800f76:	68 14 28 80 00       	push   $0x802814
  800f7b:	6a 32                	push   $0x32
  800f7d:	68 c5 27 80 00       	push   $0x8027c5
  800f82:	e8 c1 0f 00 00       	call   801f48 <_panic>
		panic("pgfault: %e", r);
  800f87:	50                   	push   %eax
  800f88:	68 14 28 80 00       	push   $0x802814
  800f8d:	6a 39                	push   $0x39
  800f8f:	68 c5 27 80 00       	push   $0x8027c5
  800f94:	e8 af 0f 00 00       	call   801f48 <_panic>
		panic("pgfault: %e", r);
  800f99:	50                   	push   %eax
  800f9a:	68 14 28 80 00       	push   $0x802814
  800f9f:	6a 3d                	push   $0x3d
  800fa1:	68 c5 27 80 00       	push   $0x8027c5
  800fa6:	e8 9d 0f 00 00       	call   801f48 <_panic>

00800fab <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fb8:	b8 07 00 00 00       	mov    $0x7,%eax
  800fbd:	cd 30                	int    $0x30
  800fbf:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	78 22                	js     800fe7 <fork_v0+0x3c>
  800fc5:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  800fc7:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fcc:	75 52                	jne    801020 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fce:	e8 8e fb ff ff       	call   800b61 <sys_getenvid>
  800fd3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fd8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fdb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fe0:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fe5:	eb 6e                	jmp    801055 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  800fe7:	50                   	push   %eax
  800fe8:	68 b8 28 80 00       	push   $0x8028b8
  800fed:	68 8a 00 00 00       	push   $0x8a
  800ff2:	68 c5 27 80 00       	push   $0x8027c5
  800ff7:	e8 4c 0f 00 00       	call   801f48 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  800ffc:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801003:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801009:	89 da                	mov    %ebx,%edx
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	e8 b9 fd ff ff       	call   800dcb <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801012:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801018:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80101e:	74 23                	je     801043 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801020:	89 d8                	mov    %ebx,%eax
  801022:	c1 e8 16             	shr    $0x16,%eax
  801025:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80102c:	a8 01                	test   $0x1,%al
  80102e:	74 e2                	je     801012 <fork_v0+0x67>
  801030:	89 d8                	mov    %ebx,%eax
  801032:	c1 e8 0c             	shr    $0xc,%eax
  801035:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80103c:	f6 c2 01             	test   $0x1,%dl
  80103f:	74 d1                	je     801012 <fork_v0+0x67>
  801041:	eb b9                	jmp    800ffc <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	6a 02                	push   $0x2
  801048:	57                   	push   %edi
  801049:	e8 df fb ff ff       	call   800c2d <sys_env_set_status>
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	85 c0                	test   %eax,%eax
  801053:	78 0a                	js     80105f <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  801055:	89 f8                	mov    %edi,%eax
  801057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  80105f:	50                   	push   %eax
  801060:	68 dc 28 80 00       	push   $0x8028dc
  801065:	68 98 00 00 00       	push   $0x98
  80106a:	68 c5 27 80 00       	push   $0x8027c5
  80106f:	e8 d4 0e 00 00       	call   801f48 <_panic>

00801074 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801074:	f3 0f 1e fb          	endbr32 
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  801081:	68 98 0e 80 00       	push   $0x800e98
  801086:	e8 07 0f 00 00       	call   801f92 <set_pgfault_handler>
  80108b:	b8 07 00 00 00       	mov    $0x7,%eax
  801090:	cd 30                	int    $0x30
  801092:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  801094:	83 c4 10             	add    $0x10,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	78 37                	js     8010d2 <fork+0x5e>
  80109b:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  80109d:	74 48                	je     8010e7 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  80109f:	83 ec 04             	sub    $0x4,%esp
  8010a2:	6a 07                	push   $0x7
  8010a4:	68 00 f0 bf ee       	push   $0xeebff000
  8010a9:	50                   	push   %eax
  8010aa:	e8 05 fb ff ff       	call   800bb4 <sys_page_alloc>
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	78 4d                	js     801103 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	68 0f 20 80 00       	push   $0x80200f
  8010be:	56                   	push   %esi
  8010bf:	e8 b7 fb ff ff       	call   800c7b <sys_env_set_pgfault_upcall>
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 4d                	js     801118 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8010cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d0:	eb 70                	jmp    801142 <fork+0xce>
		panic("sys_exofork: %e", envid);
  8010d2:	50                   	push   %eax
  8010d3:	68 20 28 80 00       	push   $0x802820
  8010d8:	68 b7 00 00 00       	push   $0xb7
  8010dd:	68 c5 27 80 00       	push   $0x8027c5
  8010e2:	e8 61 0e 00 00       	call   801f48 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010e7:	e8 75 fa ff ff       	call   800b61 <sys_getenvid>
  8010ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010f9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010fe:	e9 80 00 00 00       	jmp    801183 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801103:	50                   	push   %eax
  801104:	68 30 28 80 00       	push   $0x802830
  801109:	68 c0 00 00 00       	push   $0xc0
  80110e:	68 c5 27 80 00       	push   $0x8027c5
  801113:	e8 30 0e 00 00       	call   801f48 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801118:	50                   	push   %eax
  801119:	68 00 29 80 00       	push   $0x802900
  80111e:	68 c3 00 00 00       	push   $0xc3
  801123:	68 c5 27 80 00       	push   $0x8027c5
  801128:	e8 1b 0e 00 00       	call   801f48 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  80112d:	89 f8                	mov    %edi,%eax
  80112f:	e8 bd fb ff ff       	call   800cf1 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801134:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80113a:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801140:	74 2f                	je     801171 <fork+0xfd>
  801142:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  801144:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  80114a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80114f:	76 e3                	jbe    801134 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801151:	89 d8                	mov    %ebx,%eax
  801153:	c1 e8 16             	shr    $0x16,%eax
  801156:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115d:	a8 01                	test   $0x1,%al
  80115f:	74 d3                	je     801134 <fork+0xc0>
  801161:	c1 ea 0c             	shr    $0xc,%edx
  801164:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80116b:	a8 01                	test   $0x1,%al
  80116d:	74 c5                	je     801134 <fork+0xc0>
  80116f:	eb bc                	jmp    80112d <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	6a 02                	push   $0x2
  801176:	56                   	push   %esi
  801177:	e8 b1 fa ff ff       	call   800c2d <sys_env_set_status>
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 0a                	js     80118d <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  801183:	89 f0                	mov    %esi,%eax
  801185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  80118d:	50                   	push   %eax
  80118e:	68 2c 29 80 00       	push   $0x80292c
  801193:	68 ce 00 00 00       	push   $0xce
  801198:	68 c5 27 80 00       	push   $0x8027c5
  80119d:	e8 a6 0d 00 00       	call   801f48 <_panic>

008011a2 <sfork>:

// Challenge!
int
sfork(void)
{
  8011a2:	f3 0f 1e fb          	endbr32 
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011ac:	68 4e 28 80 00       	push   $0x80284e
  8011b1:	68 d7 00 00 00       	push   $0xd7
  8011b6:	68 c5 27 80 00       	push   $0x8027c5
  8011bb:	e8 88 0d 00 00       	call   801f48 <_panic>

008011c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011c0:	f3 0f 1e fb          	endbr32 
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8011cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011d4:	f3 0f 1e fb          	endbr32 
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8011de:	ff 75 08             	pushl  0x8(%ebp)
  8011e1:	e8 da ff ff ff       	call   8011c0 <fd2num>
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	c1 e0 0c             	shl    $0xc,%eax
  8011ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f3:	f3 0f 1e fb          	endbr32 
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	c1 ea 16             	shr    $0x16,%edx
  801204:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80120b:	f6 c2 01             	test   $0x1,%dl
  80120e:	74 2d                	je     80123d <fd_alloc+0x4a>
  801210:	89 c2                	mov    %eax,%edx
  801212:	c1 ea 0c             	shr    $0xc,%edx
  801215:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121c:	f6 c2 01             	test   $0x1,%dl
  80121f:	74 1c                	je     80123d <fd_alloc+0x4a>
  801221:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801226:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80122b:	75 d2                	jne    8011ff <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801236:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80123b:	eb 0a                	jmp    801247 <fd_alloc+0x54>
			*fd_store = fd;
  80123d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801240:	89 01                	mov    %eax,(%ecx)
			return 0;
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801249:	f3 0f 1e fb          	endbr32 
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801253:	83 f8 1f             	cmp    $0x1f,%eax
  801256:	77 30                	ja     801288 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801258:	c1 e0 0c             	shl    $0xc,%eax
  80125b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801260:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801266:	f6 c2 01             	test   $0x1,%dl
  801269:	74 24                	je     80128f <fd_lookup+0x46>
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	c1 ea 0c             	shr    $0xc,%edx
  801270:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801277:	f6 c2 01             	test   $0x1,%dl
  80127a:	74 1a                	je     801296 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	89 02                	mov    %eax,(%edx)
	return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    
		return -E_INVAL;
  801288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128d:	eb f7                	jmp    801286 <fd_lookup+0x3d>
		return -E_INVAL;
  80128f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801294:	eb f0                	jmp    801286 <fd_lookup+0x3d>
  801296:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129b:	eb e9                	jmp    801286 <fd_lookup+0x3d>

0080129d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129d:	f3 0f 1e fb          	endbr32 
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012aa:	ba cc 29 80 00       	mov    $0x8029cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012af:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b4:	39 08                	cmp    %ecx,(%eax)
  8012b6:	74 33                	je     8012eb <dev_lookup+0x4e>
  8012b8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012bb:	8b 02                	mov    (%edx),%eax
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	75 f3                	jne    8012b4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c6:	8b 40 48             	mov    0x48(%eax),%eax
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	51                   	push   %ecx
  8012cd:	50                   	push   %eax
  8012ce:	68 50 29 80 00       	push   $0x802950
  8012d3:	e8 ea ee ff ff       	call   8001c2 <cprintf>
	*dev = 0;
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    
			*dev = devtab[i];
  8012eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ee:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f5:	eb f2                	jmp    8012e9 <dev_lookup+0x4c>

008012f7 <fd_close>:
{
  8012f7:	f3 0f 1e fb          	endbr32 
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
  801301:	83 ec 28             	sub    $0x28,%esp
  801304:	8b 75 08             	mov    0x8(%ebp),%esi
  801307:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130a:	56                   	push   %esi
  80130b:	e8 b0 fe ff ff       	call   8011c0 <fd2num>
  801310:	83 c4 08             	add    $0x8,%esp
  801313:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801316:	52                   	push   %edx
  801317:	50                   	push   %eax
  801318:	e8 2c ff ff ff       	call   801249 <fd_lookup>
  80131d:	89 c3                	mov    %eax,%ebx
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	78 05                	js     80132b <fd_close+0x34>
	    || fd != fd2)
  801326:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801329:	74 16                	je     801341 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80132b:	89 f8                	mov    %edi,%eax
  80132d:	84 c0                	test   %al,%al
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
  801334:	0f 44 d8             	cmove  %eax,%ebx
}
  801337:	89 d8                	mov    %ebx,%eax
  801339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801347:	50                   	push   %eax
  801348:	ff 36                	pushl  (%esi)
  80134a:	e8 4e ff ff ff       	call   80129d <dev_lookup>
  80134f:	89 c3                	mov    %eax,%ebx
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 1a                	js     801372 <fd_close+0x7b>
		if (dev->dev_close)
  801358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80135e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801363:	85 c0                	test   %eax,%eax
  801365:	74 0b                	je     801372 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	56                   	push   %esi
  80136b:	ff d0                	call   *%eax
  80136d:	89 c3                	mov    %eax,%ebx
  80136f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	56                   	push   %esi
  801376:	6a 00                	push   $0x0
  801378:	e8 89 f8 ff ff       	call   800c06 <sys_page_unmap>
	return r;
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	eb b5                	jmp    801337 <fd_close+0x40>

00801382 <close>:

int
close(int fdnum)
{
  801382:	f3 0f 1e fb          	endbr32 
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80138c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138f:	50                   	push   %eax
  801390:	ff 75 08             	pushl  0x8(%ebp)
  801393:	e8 b1 fe ff ff       	call   801249 <fd_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	79 02                	jns    8013a1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    
		return fd_close(fd, 1);
  8013a1:	83 ec 08             	sub    $0x8,%esp
  8013a4:	6a 01                	push   $0x1
  8013a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a9:	e8 49 ff ff ff       	call   8012f7 <fd_close>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	eb ec                	jmp    80139f <close+0x1d>

008013b3 <close_all>:

void
close_all(void)
{
  8013b3:	f3 0f 1e fb          	endbr32 
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013be:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	53                   	push   %ebx
  8013c7:	e8 b6 ff ff ff       	call   801382 <close>
	for (i = 0; i < MAXFD; i++)
  8013cc:	83 c3 01             	add    $0x1,%ebx
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	83 fb 20             	cmp    $0x20,%ebx
  8013d5:	75 ec                	jne    8013c3 <close_all+0x10>
}
  8013d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013dc:	f3 0f 1e fb          	endbr32 
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	e8 54 fe ff ff       	call   801249 <fd_lookup>
  8013f5:	89 c3                	mov    %eax,%ebx
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	0f 88 81 00 00 00    	js     801483 <dup+0xa7>
		return r;
	close(newfdnum);
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	e8 75 ff ff ff       	call   801382 <close>

	newfd = INDEX2FD(newfdnum);
  80140d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801410:	c1 e6 0c             	shl    $0xc,%esi
  801413:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80141f:	e8 b0 fd ff ff       	call   8011d4 <fd2data>
  801424:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801426:	89 34 24             	mov    %esi,(%esp)
  801429:	e8 a6 fd ff ff       	call   8011d4 <fd2data>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801433:	89 d8                	mov    %ebx,%eax
  801435:	c1 e8 16             	shr    $0x16,%eax
  801438:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80143f:	a8 01                	test   $0x1,%al
  801441:	74 11                	je     801454 <dup+0x78>
  801443:	89 d8                	mov    %ebx,%eax
  801445:	c1 e8 0c             	shr    $0xc,%eax
  801448:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	75 39                	jne    80148d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801457:	89 d0                	mov    %edx,%eax
  801459:	c1 e8 0c             	shr    $0xc,%eax
  80145c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801463:	83 ec 0c             	sub    $0xc,%esp
  801466:	25 07 0e 00 00       	and    $0xe07,%eax
  80146b:	50                   	push   %eax
  80146c:	56                   	push   %esi
  80146d:	6a 00                	push   $0x0
  80146f:	52                   	push   %edx
  801470:	6a 00                	push   $0x0
  801472:	e8 65 f7 ff ff       	call   800bdc <sys_page_map>
  801477:	89 c3                	mov    %eax,%ebx
  801479:	83 c4 20             	add    $0x20,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 31                	js     8014b1 <dup+0xd5>
		goto err;

	return newfdnum;
  801480:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801483:	89 d8                	mov    %ebx,%eax
  801485:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80148d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	25 07 0e 00 00       	and    $0xe07,%eax
  80149c:	50                   	push   %eax
  80149d:	57                   	push   %edi
  80149e:	6a 00                	push   $0x0
  8014a0:	53                   	push   %ebx
  8014a1:	6a 00                	push   $0x0
  8014a3:	e8 34 f7 ff ff       	call   800bdc <sys_page_map>
  8014a8:	89 c3                	mov    %eax,%ebx
  8014aa:	83 c4 20             	add    $0x20,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	79 a3                	jns    801454 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	56                   	push   %esi
  8014b5:	6a 00                	push   $0x0
  8014b7:	e8 4a f7 ff ff       	call   800c06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014bc:	83 c4 08             	add    $0x8,%esp
  8014bf:	57                   	push   %edi
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 3f f7 ff ff       	call   800c06 <sys_page_unmap>
	return r;
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	eb b7                	jmp    801483 <dup+0xa7>

008014cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014cc:	f3 0f 1e fb          	endbr32 
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 1c             	sub    $0x1c,%esp
  8014d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	53                   	push   %ebx
  8014df:	e8 65 fd ff ff       	call   801249 <fd_lookup>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 3f                	js     80152a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	ff 30                	pushl  (%eax)
  8014f7:	e8 a1 fd ff ff       	call   80129d <dev_lookup>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 27                	js     80152a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801506:	8b 42 08             	mov    0x8(%edx),%eax
  801509:	83 e0 03             	and    $0x3,%eax
  80150c:	83 f8 01             	cmp    $0x1,%eax
  80150f:	74 1e                	je     80152f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	8b 40 08             	mov    0x8(%eax),%eax
  801517:	85 c0                	test   %eax,%eax
  801519:	74 35                	je     801550 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	ff 75 10             	pushl  0x10(%ebp)
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	52                   	push   %edx
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
}
  80152a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80152f:	a1 04 40 80 00       	mov    0x804004,%eax
  801534:	8b 40 48             	mov    0x48(%eax),%eax
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	53                   	push   %ebx
  80153b:	50                   	push   %eax
  80153c:	68 91 29 80 00       	push   $0x802991
  801541:	e8 7c ec ff ff       	call   8001c2 <cprintf>
		return -E_INVAL;
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154e:	eb da                	jmp    80152a <read+0x5e>
		return -E_NOT_SUPP;
  801550:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801555:	eb d3                	jmp    80152a <read+0x5e>

00801557 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801557:	f3 0f 1e fb          	endbr32 
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	57                   	push   %edi
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	8b 7d 08             	mov    0x8(%ebp),%edi
  801567:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156f:	eb 02                	jmp    801573 <readn+0x1c>
  801571:	01 c3                	add    %eax,%ebx
  801573:	39 f3                	cmp    %esi,%ebx
  801575:	73 21                	jae    801598 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	89 f0                	mov    %esi,%eax
  80157c:	29 d8                	sub    %ebx,%eax
  80157e:	50                   	push   %eax
  80157f:	89 d8                	mov    %ebx,%eax
  801581:	03 45 0c             	add    0xc(%ebp),%eax
  801584:	50                   	push   %eax
  801585:	57                   	push   %edi
  801586:	e8 41 ff ff ff       	call   8014cc <read>
		if (m < 0)
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 04                	js     801596 <readn+0x3f>
			return m;
		if (m == 0)
  801592:	75 dd                	jne    801571 <readn+0x1a>
  801594:	eb 02                	jmp    801598 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801596:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801598:	89 d8                	mov    %ebx,%eax
  80159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a2:	f3 0f 1e fb          	endbr32 
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 1c             	sub    $0x1c,%esp
  8015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b3:	50                   	push   %eax
  8015b4:	53                   	push   %ebx
  8015b5:	e8 8f fc ff ff       	call   801249 <fd_lookup>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 3a                	js     8015fb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	ff 30                	pushl  (%eax)
  8015cd:	e8 cb fc ff ff       	call   80129d <dev_lookup>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 22                	js     8015fb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e0:	74 1e                	je     801600 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e8:	85 d2                	test   %edx,%edx
  8015ea:	74 35                	je     801621 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	ff 75 10             	pushl  0x10(%ebp)
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	50                   	push   %eax
  8015f6:	ff d2                	call   *%edx
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801600:	a1 04 40 80 00       	mov    0x804004,%eax
  801605:	8b 40 48             	mov    0x48(%eax),%eax
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	53                   	push   %ebx
  80160c:	50                   	push   %eax
  80160d:	68 ad 29 80 00       	push   $0x8029ad
  801612:	e8 ab eb ff ff       	call   8001c2 <cprintf>
		return -E_INVAL;
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161f:	eb da                	jmp    8015fb <write+0x59>
		return -E_NOT_SUPP;
  801621:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801626:	eb d3                	jmp    8015fb <write+0x59>

00801628 <seek>:

int
seek(int fdnum, off_t offset)
{
  801628:	f3 0f 1e fb          	endbr32 
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801635:	50                   	push   %eax
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 0b fc ff ff       	call   801249 <fd_lookup>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 0e                	js     801653 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80164e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801655:	f3 0f 1e fb          	endbr32 
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
  80165d:	83 ec 1c             	sub    $0x1c,%esp
  801660:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	53                   	push   %ebx
  801668:	e8 dc fb ff ff       	call   801249 <fd_lookup>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 37                	js     8016ab <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	ff 30                	pushl  (%eax)
  801680:	e8 18 fc ff ff       	call   80129d <dev_lookup>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	78 1f                	js     8016ab <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801693:	74 1b                	je     8016b0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801698:	8b 52 18             	mov    0x18(%edx),%edx
  80169b:	85 d2                	test   %edx,%edx
  80169d:	74 32                	je     8016d1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80169f:	83 ec 08             	sub    $0x8,%esp
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	50                   	push   %eax
  8016a6:	ff d2                	call   *%edx
  8016a8:	83 c4 10             	add    $0x10,%esp
}
  8016ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016b0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b5:	8b 40 48             	mov    0x48(%eax),%eax
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	53                   	push   %ebx
  8016bc:	50                   	push   %eax
  8016bd:	68 70 29 80 00       	push   $0x802970
  8016c2:	e8 fb ea ff ff       	call   8001c2 <cprintf>
		return -E_INVAL;
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cf:	eb da                	jmp    8016ab <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d6:	eb d3                	jmp    8016ab <ftruncate+0x56>

008016d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016d8:	f3 0f 1e fb          	endbr32 
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 1c             	sub    $0x1c,%esp
  8016e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 57 fb ff ff       	call   801249 <fd_lookup>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 4b                	js     801744 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ff:	50                   	push   %eax
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	ff 30                	pushl  (%eax)
  801705:	e8 93 fb ff ff       	call   80129d <dev_lookup>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 33                	js     801744 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801714:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801718:	74 2f                	je     801749 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80171a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80171d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801724:	00 00 00 
	stat->st_isdir = 0;
  801727:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80172e:	00 00 00 
	stat->st_dev = dev;
  801731:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	53                   	push   %ebx
  80173b:	ff 75 f0             	pushl  -0x10(%ebp)
  80173e:	ff 50 14             	call   *0x14(%eax)
  801741:	83 c4 10             	add    $0x10,%esp
}
  801744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801747:	c9                   	leave  
  801748:	c3                   	ret    
		return -E_NOT_SUPP;
  801749:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174e:	eb f4                	jmp    801744 <fstat+0x6c>

00801750 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801750:	f3 0f 1e fb          	endbr32 
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	6a 00                	push   $0x0
  80175e:	ff 75 08             	pushl  0x8(%ebp)
  801761:	e8 3a 02 00 00       	call   8019a0 <open>
  801766:	89 c3                	mov    %eax,%ebx
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 1b                	js     80178a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	50                   	push   %eax
  801776:	e8 5d ff ff ff       	call   8016d8 <fstat>
  80177b:	89 c6                	mov    %eax,%esi
	close(fd);
  80177d:	89 1c 24             	mov    %ebx,(%esp)
  801780:	e8 fd fb ff ff       	call   801382 <close>
	return r;
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	89 f3                	mov    %esi,%ebx
}
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	56                   	push   %esi
  801797:	53                   	push   %ebx
  801798:	89 c6                	mov    %eax,%esi
  80179a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80179c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017a3:	74 27                	je     8017cc <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017a5:	6a 07                	push   $0x7
  8017a7:	68 00 50 80 00       	push   $0x805000
  8017ac:	56                   	push   %esi
  8017ad:	ff 35 00 40 80 00    	pushl  0x804000
  8017b3:	e8 ea 08 00 00       	call   8020a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017b8:	83 c4 0c             	add    $0xc,%esp
  8017bb:	6a 00                	push   $0x0
  8017bd:	53                   	push   %ebx
  8017be:	6a 00                	push   $0x0
  8017c0:	e8 70 08 00 00       	call   802035 <ipc_recv>
}
  8017c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c8:	5b                   	pop    %ebx
  8017c9:	5e                   	pop    %esi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	6a 01                	push   $0x1
  8017d1:	e8 24 09 00 00       	call   8020fa <ipc_find_env>
  8017d6:	a3 00 40 80 00       	mov    %eax,0x804000
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	eb c5                	jmp    8017a5 <fsipc+0x12>

008017e0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017e0:	f3 0f 1e fb          	endbr32 
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801802:	b8 02 00 00 00       	mov    $0x2,%eax
  801807:	e8 87 ff ff ff       	call   801793 <fsipc>
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <devfile_flush>:
{
  80180e:	f3 0f 1e fb          	endbr32 
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8b 40 0c             	mov    0xc(%eax),%eax
  80181e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	b8 06 00 00 00       	mov    $0x6,%eax
  80182d:	e8 61 ff ff ff       	call   801793 <fsipc>
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <devfile_stat>:
{
  801834:	f3 0f 1e fb          	endbr32 
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	53                   	push   %ebx
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 40 0c             	mov    0xc(%eax),%eax
  801848:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 05 00 00 00       	mov    $0x5,%eax
  801857:	e8 37 ff ff ff       	call   801793 <fsipc>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 2c                	js     80188c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	68 00 50 80 00       	push   $0x805000
  801868:	53                   	push   %ebx
  801869:	e8 be ee ff ff       	call   80072c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80186e:	a1 80 50 80 00       	mov    0x805080,%eax
  801873:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801879:	a1 84 50 80 00       	mov    0x805084,%eax
  80187e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <devfile_write>:
{
  801891:	f3 0f 1e fb          	endbr32 
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	53                   	push   %ebx
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018aa:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018b0:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8018b6:	77 30                	ja     8018e8 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	53                   	push   %ebx
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	68 08 50 80 00       	push   $0x805008
  8018c4:	e8 1b f0 ff ff       	call   8008e4 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8018d3:	e8 bb fe ff ff       	call   801793 <fsipc>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 04                	js     8018e3 <devfile_write+0x52>
	assert(r <= n);
  8018df:	39 d8                	cmp    %ebx,%eax
  8018e1:	77 1e                	ja     801901 <devfile_write+0x70>
}
  8018e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018e8:	68 dc 29 80 00       	push   $0x8029dc
  8018ed:	68 09 2a 80 00       	push   $0x802a09
  8018f2:	68 94 00 00 00       	push   $0x94
  8018f7:	68 1e 2a 80 00       	push   $0x802a1e
  8018fc:	e8 47 06 00 00       	call   801f48 <_panic>
	assert(r <= n);
  801901:	68 29 2a 80 00       	push   $0x802a29
  801906:	68 09 2a 80 00       	push   $0x802a09
  80190b:	68 98 00 00 00       	push   $0x98
  801910:	68 1e 2a 80 00       	push   $0x802a1e
  801915:	e8 2e 06 00 00       	call   801f48 <_panic>

0080191a <devfile_read>:
{
  80191a:	f3 0f 1e fb          	endbr32 
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	56                   	push   %esi
  801922:	53                   	push   %ebx
  801923:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8b 40 0c             	mov    0xc(%eax),%eax
  80192c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801931:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	b8 03 00 00 00       	mov    $0x3,%eax
  801941:	e8 4d fe ff ff       	call   801793 <fsipc>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 1f                	js     80196b <devfile_read+0x51>
	assert(r <= n);
  80194c:	39 f0                	cmp    %esi,%eax
  80194e:	77 24                	ja     801974 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801950:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801955:	7f 33                	jg     80198a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	50                   	push   %eax
  80195b:	68 00 50 80 00       	push   $0x805000
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	e8 7c ef ff ff       	call   8008e4 <memmove>
	return r;
  801968:	83 c4 10             	add    $0x10,%esp
}
  80196b:	89 d8                	mov    %ebx,%eax
  80196d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    
	assert(r <= n);
  801974:	68 29 2a 80 00       	push   $0x802a29
  801979:	68 09 2a 80 00       	push   $0x802a09
  80197e:	6a 7c                	push   $0x7c
  801980:	68 1e 2a 80 00       	push   $0x802a1e
  801985:	e8 be 05 00 00       	call   801f48 <_panic>
	assert(r <= PGSIZE);
  80198a:	68 30 2a 80 00       	push   $0x802a30
  80198f:	68 09 2a 80 00       	push   $0x802a09
  801994:	6a 7d                	push   $0x7d
  801996:	68 1e 2a 80 00       	push   $0x802a1e
  80199b:	e8 a8 05 00 00       	call   801f48 <_panic>

008019a0 <open>:
{
  8019a0:	f3 0f 1e fb          	endbr32 
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	56                   	push   %esi
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 1c             	sub    $0x1c,%esp
  8019ac:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019af:	56                   	push   %esi
  8019b0:	e8 34 ed ff ff       	call   8006e9 <strlen>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019bd:	7f 6c                	jg     801a2b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019bf:	83 ec 0c             	sub    $0xc,%esp
  8019c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c5:	50                   	push   %eax
  8019c6:	e8 28 f8 ff ff       	call   8011f3 <fd_alloc>
  8019cb:	89 c3                	mov    %eax,%ebx
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 3c                	js     801a10 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	56                   	push   %esi
  8019d8:	68 00 50 80 00       	push   $0x805000
  8019dd:	e8 4a ed ff ff       	call   80072c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f2:	e8 9c fd ff ff       	call   801793 <fsipc>
  8019f7:	89 c3                	mov    %eax,%ebx
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 19                	js     801a19 <open+0x79>
	return fd2num(fd);
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	ff 75 f4             	pushl  -0xc(%ebp)
  801a06:	e8 b5 f7 ff ff       	call   8011c0 <fd2num>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	83 c4 10             	add    $0x10,%esp
}
  801a10:	89 d8                	mov    %ebx,%eax
  801a12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    
		fd_close(fd, 0);
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	6a 00                	push   $0x0
  801a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a21:	e8 d1 f8 ff ff       	call   8012f7 <fd_close>
		return r;
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	eb e5                	jmp    801a10 <open+0x70>
		return -E_BAD_PATH;
  801a2b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a30:	eb de                	jmp    801a10 <open+0x70>

00801a32 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a41:	b8 08 00 00 00       	mov    $0x8,%eax
  801a46:	e8 48 fd ff ff       	call   801793 <fsipc>
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a4d:	f3 0f 1e fb          	endbr32 
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	56                   	push   %esi
  801a55:	53                   	push   %ebx
  801a56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	e8 70 f7 ff ff       	call   8011d4 <fd2data>
  801a64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a66:	83 c4 08             	add    $0x8,%esp
  801a69:	68 3c 2a 80 00       	push   $0x802a3c
  801a6e:	53                   	push   %ebx
  801a6f:	e8 b8 ec ff ff       	call   80072c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a74:	8b 46 04             	mov    0x4(%esi),%eax
  801a77:	2b 06                	sub    (%esi),%eax
  801a79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a86:	00 00 00 
	stat->st_dev = &devpipe;
  801a89:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a90:	30 80 00 
	return 0;
}
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
  801a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    

00801a9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a9f:	f3 0f 1e fb          	endbr32 
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 0c             	sub    $0xc,%esp
  801aaa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aad:	53                   	push   %ebx
  801aae:	6a 00                	push   $0x0
  801ab0:	e8 51 f1 ff ff       	call   800c06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ab5:	89 1c 24             	mov    %ebx,(%esp)
  801ab8:	e8 17 f7 ff ff       	call   8011d4 <fd2data>
  801abd:	83 c4 08             	add    $0x8,%esp
  801ac0:	50                   	push   %eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	e8 3e f1 ff ff       	call   800c06 <sys_page_unmap>
}
  801ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <_pipeisclosed>:
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	57                   	push   %edi
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 1c             	sub    $0x1c,%esp
  801ad6:	89 c7                	mov    %eax,%edi
  801ad8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ada:	a1 04 40 80 00       	mov    0x804004,%eax
  801adf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ae2:	83 ec 0c             	sub    $0xc,%esp
  801ae5:	57                   	push   %edi
  801ae6:	e8 4c 06 00 00       	call   802137 <pageref>
  801aeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aee:	89 34 24             	mov    %esi,(%esp)
  801af1:	e8 41 06 00 00       	call   802137 <pageref>
		nn = thisenv->env_runs;
  801af6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801afc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	39 cb                	cmp    %ecx,%ebx
  801b04:	74 1b                	je     801b21 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b06:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b09:	75 cf                	jne    801ada <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b0b:	8b 42 58             	mov    0x58(%edx),%eax
  801b0e:	6a 01                	push   $0x1
  801b10:	50                   	push   %eax
  801b11:	53                   	push   %ebx
  801b12:	68 43 2a 80 00       	push   $0x802a43
  801b17:	e8 a6 e6 ff ff       	call   8001c2 <cprintf>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	eb b9                	jmp    801ada <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b21:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b24:	0f 94 c0             	sete   %al
  801b27:	0f b6 c0             	movzbl %al,%eax
}
  801b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5f                   	pop    %edi
  801b30:	5d                   	pop    %ebp
  801b31:	c3                   	ret    

00801b32 <devpipe_write>:
{
  801b32:	f3 0f 1e fb          	endbr32 
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	57                   	push   %edi
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 28             	sub    $0x28,%esp
  801b3f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b42:	56                   	push   %esi
  801b43:	e8 8c f6 ff ff       	call   8011d4 <fd2data>
  801b48:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801b52:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b55:	74 4f                	je     801ba6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b57:	8b 43 04             	mov    0x4(%ebx),%eax
  801b5a:	8b 0b                	mov    (%ebx),%ecx
  801b5c:	8d 51 20             	lea    0x20(%ecx),%edx
  801b5f:	39 d0                	cmp    %edx,%eax
  801b61:	72 14                	jb     801b77 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801b63:	89 da                	mov    %ebx,%edx
  801b65:	89 f0                	mov    %esi,%eax
  801b67:	e8 61 ff ff ff       	call   801acd <_pipeisclosed>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	75 3b                	jne    801bab <devpipe_write+0x79>
			sys_yield();
  801b70:	e8 14 f0 ff ff       	call   800b89 <sys_yield>
  801b75:	eb e0                	jmp    801b57 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b7a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b7e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b81:	89 c2                	mov    %eax,%edx
  801b83:	c1 fa 1f             	sar    $0x1f,%edx
  801b86:	89 d1                	mov    %edx,%ecx
  801b88:	c1 e9 1b             	shr    $0x1b,%ecx
  801b8b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b8e:	83 e2 1f             	and    $0x1f,%edx
  801b91:	29 ca                	sub    %ecx,%edx
  801b93:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b97:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b9b:	83 c0 01             	add    $0x1,%eax
  801b9e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ba1:	83 c7 01             	add    $0x1,%edi
  801ba4:	eb ac                	jmp    801b52 <devpipe_write+0x20>
	return i;
  801ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba9:	eb 05                	jmp    801bb0 <devpipe_write+0x7e>
				return 0;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    

00801bb8 <devpipe_read>:
{
  801bb8:	f3 0f 1e fb          	endbr32 
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	57                   	push   %edi
  801bc0:	56                   	push   %esi
  801bc1:	53                   	push   %ebx
  801bc2:	83 ec 18             	sub    $0x18,%esp
  801bc5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bc8:	57                   	push   %edi
  801bc9:	e8 06 f6 ff ff       	call   8011d4 <fd2data>
  801bce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	be 00 00 00 00       	mov    $0x0,%esi
  801bd8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bdb:	75 14                	jne    801bf1 <devpipe_read+0x39>
	return i;
  801bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801be0:	eb 02                	jmp    801be4 <devpipe_read+0x2c>
				return i;
  801be2:	89 f0                	mov    %esi,%eax
}
  801be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
			sys_yield();
  801bec:	e8 98 ef ff ff       	call   800b89 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801bf1:	8b 03                	mov    (%ebx),%eax
  801bf3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bf6:	75 18                	jne    801c10 <devpipe_read+0x58>
			if (i > 0)
  801bf8:	85 f6                	test   %esi,%esi
  801bfa:	75 e6                	jne    801be2 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801bfc:	89 da                	mov    %ebx,%edx
  801bfe:	89 f8                	mov    %edi,%eax
  801c00:	e8 c8 fe ff ff       	call   801acd <_pipeisclosed>
  801c05:	85 c0                	test   %eax,%eax
  801c07:	74 e3                	je     801bec <devpipe_read+0x34>
				return 0;
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	eb d4                	jmp    801be4 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c10:	99                   	cltd   
  801c11:	c1 ea 1b             	shr    $0x1b,%edx
  801c14:	01 d0                	add    %edx,%eax
  801c16:	83 e0 1f             	and    $0x1f,%eax
  801c19:	29 d0                	sub    %edx,%eax
  801c1b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c23:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c26:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c29:	83 c6 01             	add    $0x1,%esi
  801c2c:	eb aa                	jmp    801bd8 <devpipe_read+0x20>

00801c2e <pipe>:
{
  801c2e:	f3 0f 1e fb          	endbr32 
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	56                   	push   %esi
  801c36:	53                   	push   %ebx
  801c37:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3d:	50                   	push   %eax
  801c3e:	e8 b0 f5 ff ff       	call   8011f3 <fd_alloc>
  801c43:	89 c3                	mov    %eax,%ebx
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	0f 88 23 01 00 00    	js     801d73 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	68 07 04 00 00       	push   $0x407
  801c58:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5b:	6a 00                	push   $0x0
  801c5d:	e8 52 ef ff ff       	call   800bb4 <sys_page_alloc>
  801c62:	89 c3                	mov    %eax,%ebx
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	0f 88 04 01 00 00    	js     801d73 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c75:	50                   	push   %eax
  801c76:	e8 78 f5 ff ff       	call   8011f3 <fd_alloc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	0f 88 db 00 00 00    	js     801d63 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 07 04 00 00       	push   $0x407
  801c90:	ff 75 f0             	pushl  -0x10(%ebp)
  801c93:	6a 00                	push   $0x0
  801c95:	e8 1a ef ff ff       	call   800bb4 <sys_page_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	0f 88 bc 00 00 00    	js     801d63 <pipe+0x135>
	va = fd2data(fd0);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	ff 75 f4             	pushl  -0xc(%ebp)
  801cad:	e8 22 f5 ff ff       	call   8011d4 <fd2data>
  801cb2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb4:	83 c4 0c             	add    $0xc,%esp
  801cb7:	68 07 04 00 00       	push   $0x407
  801cbc:	50                   	push   %eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	e8 f0 ee ff ff       	call   800bb4 <sys_page_alloc>
  801cc4:	89 c3                	mov    %eax,%ebx
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	0f 88 82 00 00 00    	js     801d53 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd7:	e8 f8 f4 ff ff       	call   8011d4 <fd2data>
  801cdc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ce3:	50                   	push   %eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	56                   	push   %esi
  801ce7:	6a 00                	push   $0x0
  801ce9:	e8 ee ee ff ff       	call   800bdc <sys_page_map>
  801cee:	89 c3                	mov    %eax,%ebx
  801cf0:	83 c4 20             	add    $0x20,%esp
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 4e                	js     801d45 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801cf7:	a1 20 30 80 00       	mov    0x803020,%eax
  801cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d04:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d0e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d13:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d20:	e8 9b f4 ff ff       	call   8011c0 <fd2num>
  801d25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d28:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d2a:	83 c4 04             	add    $0x4,%esp
  801d2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d30:	e8 8b f4 ff ff       	call   8011c0 <fd2num>
  801d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d38:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d43:	eb 2e                	jmp    801d73 <pipe+0x145>
	sys_page_unmap(0, va);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	56                   	push   %esi
  801d49:	6a 00                	push   $0x0
  801d4b:	e8 b6 ee ff ff       	call   800c06 <sys_page_unmap>
  801d50:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	ff 75 f0             	pushl  -0x10(%ebp)
  801d59:	6a 00                	push   $0x0
  801d5b:	e8 a6 ee ff ff       	call   800c06 <sys_page_unmap>
  801d60:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 f4             	pushl  -0xc(%ebp)
  801d69:	6a 00                	push   $0x0
  801d6b:	e8 96 ee ff ff       	call   800c06 <sys_page_unmap>
  801d70:	83 c4 10             	add    $0x10,%esp
}
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    

00801d7c <pipeisclosed>:
{
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d89:	50                   	push   %eax
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	e8 b7 f4 ff ff       	call   801249 <fd_lookup>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 18                	js     801db1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801d99:	83 ec 0c             	sub    $0xc,%esp
  801d9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9f:	e8 30 f4 ff ff       	call   8011d4 <fd2data>
  801da4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	e8 1f fd ff ff       	call   801acd <_pipeisclosed>
  801dae:	83 c4 10             	add    $0x10,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801db3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	c3                   	ret    

00801dbd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dbd:	f3 0f 1e fb          	endbr32 
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dc7:	68 5b 2a 80 00       	push   $0x802a5b
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	e8 58 e9 ff ff       	call   80072c <strcpy>
	return 0;
}
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <devcons_write>:
{
  801ddb:	f3 0f 1e fb          	endbr32 
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	57                   	push   %edi
  801de3:	56                   	push   %esi
  801de4:	53                   	push   %ebx
  801de5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801deb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801df0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801df6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801df9:	73 31                	jae    801e2c <devcons_write+0x51>
		m = n - tot;
  801dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dfe:	29 f3                	sub    %esi,%ebx
  801e00:	83 fb 7f             	cmp    $0x7f,%ebx
  801e03:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e08:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	53                   	push   %ebx
  801e0f:	89 f0                	mov    %esi,%eax
  801e11:	03 45 0c             	add    0xc(%ebp),%eax
  801e14:	50                   	push   %eax
  801e15:	57                   	push   %edi
  801e16:	e8 c9 ea ff ff       	call   8008e4 <memmove>
		sys_cputs(buf, m);
  801e1b:	83 c4 08             	add    $0x8,%esp
  801e1e:	53                   	push   %ebx
  801e1f:	57                   	push   %edi
  801e20:	e8 c4 ec ff ff       	call   800ae9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e25:	01 de                	add    %ebx,%esi
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	eb ca                	jmp    801df6 <devcons_write+0x1b>
}
  801e2c:	89 f0                	mov    %esi,%eax
  801e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5f                   	pop    %edi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <devcons_read>:
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e49:	74 21                	je     801e6c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801e4b:	e8 c3 ec ff ff       	call   800b13 <sys_cgetc>
  801e50:	85 c0                	test   %eax,%eax
  801e52:	75 07                	jne    801e5b <devcons_read+0x25>
		sys_yield();
  801e54:	e8 30 ed ff ff       	call   800b89 <sys_yield>
  801e59:	eb f0                	jmp    801e4b <devcons_read+0x15>
	if (c < 0)
  801e5b:	78 0f                	js     801e6c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801e5d:	83 f8 04             	cmp    $0x4,%eax
  801e60:	74 0c                	je     801e6e <devcons_read+0x38>
	*(char*)vbuf = c;
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	88 02                	mov    %al,(%edx)
	return 1;
  801e67:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    
		return 0;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	eb f7                	jmp    801e6c <devcons_read+0x36>

00801e75 <cputchar>:
{
  801e75:	f3 0f 1e fb          	endbr32 
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e85:	6a 01                	push   $0x1
  801e87:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8a:	50                   	push   %eax
  801e8b:	e8 59 ec ff ff       	call   800ae9 <sys_cputs>
}
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <getchar>:
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e9f:	6a 01                	push   $0x1
  801ea1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	e8 20 f6 ff ff       	call   8014cc <read>
	if (r < 0)
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 06                	js     801eb9 <getchar+0x24>
	if (r < 1)
  801eb3:	74 06                	je     801ebb <getchar+0x26>
	return c;
  801eb5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    
		return -E_EOF;
  801ebb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ec0:	eb f7                	jmp    801eb9 <getchar+0x24>

00801ec2 <iscons>:
{
  801ec2:	f3 0f 1e fb          	endbr32 
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ecc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	e8 71 f3 ff ff       	call   801249 <fd_lookup>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 11                	js     801ef0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ee8:	39 10                	cmp    %edx,(%eax)
  801eea:	0f 94 c0             	sete   %al
  801eed:	0f b6 c0             	movzbl %al,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <opencons>:
{
  801ef2:	f3 0f 1e fb          	endbr32 
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	e8 ee f2 ff ff       	call   8011f3 <fd_alloc>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 3a                	js     801f46 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 07 04 00 00       	push   $0x407
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	6a 00                	push   $0x0
  801f19:	e8 96 ec ff ff       	call   800bb4 <sys_page_alloc>
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 21                	js     801f46 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 7d f2 ff ff       	call   8011c0 <fd2num>
  801f43:	83 c4 10             	add    $0x10,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f48:	f3 0f 1e fb          	endbr32 
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	56                   	push   %esi
  801f50:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f51:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f54:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f5a:	e8 02 ec ff ff       	call   800b61 <sys_getenvid>
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	56                   	push   %esi
  801f69:	50                   	push   %eax
  801f6a:	68 68 2a 80 00       	push   $0x802a68
  801f6f:	e8 4e e2 ff ff       	call   8001c2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f74:	83 c4 18             	add    $0x18,%esp
  801f77:	53                   	push   %ebx
  801f78:	ff 75 10             	pushl  0x10(%ebp)
  801f7b:	e8 ed e1 ff ff       	call   80016d <vcprintf>
	cprintf("\n");
  801f80:	c7 04 24 cc 2a 80 00 	movl   $0x802acc,(%esp)
  801f87:	e8 36 e2 ff ff       	call   8001c2 <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f8f:	cc                   	int3   
  801f90:	eb fd                	jmp    801f8f <_panic+0x47>

00801f92 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f92:	f3 0f 1e fb          	endbr32 
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f9c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fa3:	74 0a                	je     801faf <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  801faf:	a1 04 40 80 00       	mov    0x804004,%eax
  801fb4:	8b 40 48             	mov    0x48(%eax),%eax
  801fb7:	83 ec 04             	sub    $0x4,%esp
  801fba:	6a 07                	push   $0x7
  801fbc:	68 00 f0 bf ee       	push   $0xeebff000
  801fc1:	50                   	push   %eax
  801fc2:	e8 ed eb ff ff       	call   800bb4 <sys_page_alloc>
		if (r!= 0)
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	75 2f                	jne    801ffd <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801fce:	a1 04 40 80 00       	mov    0x804004,%eax
  801fd3:	8b 40 48             	mov    0x48(%eax),%eax
  801fd6:	83 ec 08             	sub    $0x8,%esp
  801fd9:	68 0f 20 80 00       	push   $0x80200f
  801fde:	50                   	push   %eax
  801fdf:	e8 97 ec ff ff       	call   800c7b <sys_env_set_pgfault_upcall>
		if (r!= 0)
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	74 ba                	je     801fa5 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  801feb:	50                   	push   %eax
  801fec:	68 8b 2a 80 00       	push   $0x802a8b
  801ff1:	6a 26                	push   $0x26
  801ff3:	68 a3 2a 80 00       	push   $0x802aa3
  801ff8:	e8 4b ff ff ff       	call   801f48 <_panic>
			panic("set_pgfault_handler: %e", r);
  801ffd:	50                   	push   %eax
  801ffe:	68 8b 2a 80 00       	push   $0x802a8b
  802003:	6a 22                	push   $0x22
  802005:	68 a3 2a 80 00       	push   $0x802aa3
  80200a:	e8 39 ff ff ff       	call   801f48 <_panic>

0080200f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80200f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802010:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802015:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802017:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  80201a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80201e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802021:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802025:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802029:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80202b:	83 c4 08             	add    $0x8,%esp
	popal
  80202e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80202f:	83 c4 04             	add    $0x4,%esp
	popfl
  802032:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802033:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802034:	c3                   	ret    

00802035 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802035:	f3 0f 1e fb          	endbr32 
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	56                   	push   %esi
  80203d:	53                   	push   %ebx
  80203e:	8b 75 08             	mov    0x8(%ebp),%esi
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  802047:	85 c0                	test   %eax,%eax
  802049:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80204e:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	50                   	push   %eax
  802055:	e8 71 ec ff ff       	call   800ccb <sys_ipc_recv>
	if (r < 0) {
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	85 c0                	test   %eax,%eax
  80205f:	78 2b                	js     80208c <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  802061:	85 f6                	test   %esi,%esi
  802063:	74 0a                	je     80206f <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  802065:	a1 04 40 80 00       	mov    0x804004,%eax
  80206a:	8b 40 74             	mov    0x74(%eax),%eax
  80206d:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  80206f:	85 db                	test   %ebx,%ebx
  802071:	74 0a                	je     80207d <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  802073:	a1 04 40 80 00       	mov    0x804004,%eax
  802078:	8b 40 78             	mov    0x78(%eax),%eax
  80207b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80207d:	a1 04 40 80 00       	mov    0x804004,%eax
  802082:	8b 40 70             	mov    0x70(%eax),%eax
}
  802085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802088:	5b                   	pop    %ebx
  802089:	5e                   	pop    %esi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    
		if (from_env_store) {
  80208c:	85 f6                	test   %esi,%esi
  80208e:	74 06                	je     802096 <ipc_recv+0x61>
			*from_env_store = 0;
  802090:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  802096:	85 db                	test   %ebx,%ebx
  802098:	74 eb                	je     802085 <ipc_recv+0x50>
			*perm_store = 0;
  80209a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020a0:	eb e3                	jmp    802085 <ipc_recv+0x50>

008020a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020a2:	f3 0f 1e fb          	endbr32 
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8020b8:	85 db                	test   %ebx,%ebx
  8020ba:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020bf:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8020c2:	ff 75 14             	pushl  0x14(%ebp)
  8020c5:	53                   	push   %ebx
  8020c6:	56                   	push   %esi
  8020c7:	57                   	push   %edi
  8020c8:	e8 d5 eb ff ff       	call   800ca2 <sys_ipc_try_send>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020d3:	75 07                	jne    8020dc <ipc_send+0x3a>
		sys_yield();
  8020d5:	e8 af ea ff ff       	call   800b89 <sys_yield>
  8020da:	eb e6                	jmp    8020c2 <ipc_send+0x20>
	}

	if (ret < 0) {
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 08                	js     8020e8 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8020e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  8020e8:	50                   	push   %eax
  8020e9:	68 b1 2a 80 00       	push   $0x802ab1
  8020ee:	6a 48                	push   $0x48
  8020f0:	68 ce 2a 80 00       	push   $0x802ace
  8020f5:	e8 4e fe ff ff       	call   801f48 <_panic>

008020fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020fa:	f3 0f 1e fb          	endbr32 
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802109:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80210c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802112:	8b 52 50             	mov    0x50(%edx),%edx
  802115:	39 ca                	cmp    %ecx,%edx
  802117:	74 11                	je     80212a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802119:	83 c0 01             	add    $0x1,%eax
  80211c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802121:	75 e6                	jne    802109 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	eb 0b                	jmp    802135 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80212a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80212d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802132:	8b 40 48             	mov    0x48(%eax),%eax
}
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802137:	f3 0f 1e fb          	endbr32 
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802141:	89 c2                	mov    %eax,%edx
  802143:	c1 ea 16             	shr    $0x16,%edx
  802146:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80214d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802152:	f6 c1 01             	test   $0x1,%cl
  802155:	74 1c                	je     802173 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802157:	c1 e8 0c             	shr    $0xc,%eax
  80215a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802161:	a8 01                	test   $0x1,%al
  802163:	74 0e                	je     802173 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802165:	c1 e8 0c             	shr    $0xc,%eax
  802168:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80216f:	ef 
  802170:	0f b7 d2             	movzwl %dx,%edx
}
  802173:	89 d0                	mov    %edx,%eax
  802175:	5d                   	pop    %ebp
  802176:	c3                   	ret    
  802177:	66 90                	xchg   %ax,%ax
  802179:	66 90                	xchg   %ax,%ax
  80217b:	66 90                	xchg   %ax,%ax
  80217d:	66 90                	xchg   %ax,%ax
  80217f:	90                   	nop

00802180 <__udivdi3>:
  802180:	f3 0f 1e fb          	endbr32 
  802184:	55                   	push   %ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 1c             	sub    $0x1c,%esp
  80218b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80218f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802193:	8b 74 24 34          	mov    0x34(%esp),%esi
  802197:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80219b:	85 d2                	test   %edx,%edx
  80219d:	75 19                	jne    8021b8 <__udivdi3+0x38>
  80219f:	39 f3                	cmp    %esi,%ebx
  8021a1:	76 4d                	jbe    8021f0 <__udivdi3+0x70>
  8021a3:	31 ff                	xor    %edi,%edi
  8021a5:	89 e8                	mov    %ebp,%eax
  8021a7:	89 f2                	mov    %esi,%edx
  8021a9:	f7 f3                	div    %ebx
  8021ab:	89 fa                	mov    %edi,%edx
  8021ad:	83 c4 1c             	add    $0x1c,%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5f                   	pop    %edi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	39 f2                	cmp    %esi,%edx
  8021ba:	76 14                	jbe    8021d0 <__udivdi3+0x50>
  8021bc:	31 ff                	xor    %edi,%edi
  8021be:	31 c0                	xor    %eax,%eax
  8021c0:	89 fa                	mov    %edi,%edx
  8021c2:	83 c4 1c             	add    $0x1c,%esp
  8021c5:	5b                   	pop    %ebx
  8021c6:	5e                   	pop    %esi
  8021c7:	5f                   	pop    %edi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    
  8021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d0:	0f bd fa             	bsr    %edx,%edi
  8021d3:	83 f7 1f             	xor    $0x1f,%edi
  8021d6:	75 48                	jne    802220 <__udivdi3+0xa0>
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	72 06                	jb     8021e2 <__udivdi3+0x62>
  8021dc:	31 c0                	xor    %eax,%eax
  8021de:	39 eb                	cmp    %ebp,%ebx
  8021e0:	77 de                	ja     8021c0 <__udivdi3+0x40>
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb d7                	jmp    8021c0 <__udivdi3+0x40>
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 d9                	mov    %ebx,%ecx
  8021f2:	85 db                	test   %ebx,%ebx
  8021f4:	75 0b                	jne    802201 <__udivdi3+0x81>
  8021f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	f7 f3                	div    %ebx
  8021ff:	89 c1                	mov    %eax,%ecx
  802201:	31 d2                	xor    %edx,%edx
  802203:	89 f0                	mov    %esi,%eax
  802205:	f7 f1                	div    %ecx
  802207:	89 c6                	mov    %eax,%esi
  802209:	89 e8                	mov    %ebp,%eax
  80220b:	89 f7                	mov    %esi,%edi
  80220d:	f7 f1                	div    %ecx
  80220f:	89 fa                	mov    %edi,%edx
  802211:	83 c4 1c             	add    $0x1c,%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 f9                	mov    %edi,%ecx
  802222:	b8 20 00 00 00       	mov    $0x20,%eax
  802227:	29 f8                	sub    %edi,%eax
  802229:	d3 e2                	shl    %cl,%edx
  80222b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	89 da                	mov    %ebx,%edx
  802233:	d3 ea                	shr    %cl,%edx
  802235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802239:	09 d1                	or     %edx,%ecx
  80223b:	89 f2                	mov    %esi,%edx
  80223d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802241:	89 f9                	mov    %edi,%ecx
  802243:	d3 e3                	shl    %cl,%ebx
  802245:	89 c1                	mov    %eax,%ecx
  802247:	d3 ea                	shr    %cl,%edx
  802249:	89 f9                	mov    %edi,%ecx
  80224b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80224f:	89 eb                	mov    %ebp,%ebx
  802251:	d3 e6                	shl    %cl,%esi
  802253:	89 c1                	mov    %eax,%ecx
  802255:	d3 eb                	shr    %cl,%ebx
  802257:	09 de                	or     %ebx,%esi
  802259:	89 f0                	mov    %esi,%eax
  80225b:	f7 74 24 08          	divl   0x8(%esp)
  80225f:	89 d6                	mov    %edx,%esi
  802261:	89 c3                	mov    %eax,%ebx
  802263:	f7 64 24 0c          	mull   0xc(%esp)
  802267:	39 d6                	cmp    %edx,%esi
  802269:	72 15                	jb     802280 <__udivdi3+0x100>
  80226b:	89 f9                	mov    %edi,%ecx
  80226d:	d3 e5                	shl    %cl,%ebp
  80226f:	39 c5                	cmp    %eax,%ebp
  802271:	73 04                	jae    802277 <__udivdi3+0xf7>
  802273:	39 d6                	cmp    %edx,%esi
  802275:	74 09                	je     802280 <__udivdi3+0x100>
  802277:	89 d8                	mov    %ebx,%eax
  802279:	31 ff                	xor    %edi,%edi
  80227b:	e9 40 ff ff ff       	jmp    8021c0 <__udivdi3+0x40>
  802280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802283:	31 ff                	xor    %edi,%edi
  802285:	e9 36 ff ff ff       	jmp    8021c0 <__udivdi3+0x40>
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <__umoddi3>:
  802290:	f3 0f 1e fb          	endbr32 
  802294:	55                   	push   %ebp
  802295:	57                   	push   %edi
  802296:	56                   	push   %esi
  802297:	53                   	push   %ebx
  802298:	83 ec 1c             	sub    $0x1c,%esp
  80229b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80229f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	75 19                	jne    8022c8 <__umoddi3+0x38>
  8022af:	39 df                	cmp    %ebx,%edi
  8022b1:	76 5d                	jbe    802310 <__umoddi3+0x80>
  8022b3:	89 f0                	mov    %esi,%eax
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	f7 f7                	div    %edi
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	83 c4 1c             	add    $0x1c,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	89 f2                	mov    %esi,%edx
  8022ca:	39 d8                	cmp    %ebx,%eax
  8022cc:	76 12                	jbe    8022e0 <__umoddi3+0x50>
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	89 da                	mov    %ebx,%edx
  8022d2:	83 c4 1c             	add    $0x1c,%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5f                   	pop    %edi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    
  8022da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022e0:	0f bd e8             	bsr    %eax,%ebp
  8022e3:	83 f5 1f             	xor    $0x1f,%ebp
  8022e6:	75 50                	jne    802338 <__umoddi3+0xa8>
  8022e8:	39 d8                	cmp    %ebx,%eax
  8022ea:	0f 82 e0 00 00 00    	jb     8023d0 <__umoddi3+0x140>
  8022f0:	89 d9                	mov    %ebx,%ecx
  8022f2:	39 f7                	cmp    %esi,%edi
  8022f4:	0f 86 d6 00 00 00    	jbe    8023d0 <__umoddi3+0x140>
  8022fa:	89 d0                	mov    %edx,%eax
  8022fc:	89 ca                	mov    %ecx,%edx
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	89 fd                	mov    %edi,%ebp
  802312:	85 ff                	test   %edi,%edi
  802314:	75 0b                	jne    802321 <__umoddi3+0x91>
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f7                	div    %edi
  80231f:	89 c5                	mov    %eax,%ebp
  802321:	89 d8                	mov    %ebx,%eax
  802323:	31 d2                	xor    %edx,%edx
  802325:	f7 f5                	div    %ebp
  802327:	89 f0                	mov    %esi,%eax
  802329:	f7 f5                	div    %ebp
  80232b:	89 d0                	mov    %edx,%eax
  80232d:	31 d2                	xor    %edx,%edx
  80232f:	eb 8c                	jmp    8022bd <__umoddi3+0x2d>
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	89 e9                	mov    %ebp,%ecx
  80233a:	ba 20 00 00 00       	mov    $0x20,%edx
  80233f:	29 ea                	sub    %ebp,%edx
  802341:	d3 e0                	shl    %cl,%eax
  802343:	89 44 24 08          	mov    %eax,0x8(%esp)
  802347:	89 d1                	mov    %edx,%ecx
  802349:	89 f8                	mov    %edi,%eax
  80234b:	d3 e8                	shr    %cl,%eax
  80234d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802351:	89 54 24 04          	mov    %edx,0x4(%esp)
  802355:	8b 54 24 04          	mov    0x4(%esp),%edx
  802359:	09 c1                	or     %eax,%ecx
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e7                	shl    %cl,%edi
  802365:	89 d1                	mov    %edx,%ecx
  802367:	d3 e8                	shr    %cl,%eax
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80236f:	d3 e3                	shl    %cl,%ebx
  802371:	89 c7                	mov    %eax,%edi
  802373:	89 d1                	mov    %edx,%ecx
  802375:	89 f0                	mov    %esi,%eax
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 fa                	mov    %edi,%edx
  80237d:	d3 e6                	shl    %cl,%esi
  80237f:	09 d8                	or     %ebx,%eax
  802381:	f7 74 24 08          	divl   0x8(%esp)
  802385:	89 d1                	mov    %edx,%ecx
  802387:	89 f3                	mov    %esi,%ebx
  802389:	f7 64 24 0c          	mull   0xc(%esp)
  80238d:	89 c6                	mov    %eax,%esi
  80238f:	89 d7                	mov    %edx,%edi
  802391:	39 d1                	cmp    %edx,%ecx
  802393:	72 06                	jb     80239b <__umoddi3+0x10b>
  802395:	75 10                	jne    8023a7 <__umoddi3+0x117>
  802397:	39 c3                	cmp    %eax,%ebx
  802399:	73 0c                	jae    8023a7 <__umoddi3+0x117>
  80239b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80239f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023a3:	89 d7                	mov    %edx,%edi
  8023a5:	89 c6                	mov    %eax,%esi
  8023a7:	89 ca                	mov    %ecx,%edx
  8023a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ae:	29 f3                	sub    %esi,%ebx
  8023b0:	19 fa                	sbb    %edi,%edx
  8023b2:	89 d0                	mov    %edx,%eax
  8023b4:	d3 e0                	shl    %cl,%eax
  8023b6:	89 e9                	mov    %ebp,%ecx
  8023b8:	d3 eb                	shr    %cl,%ebx
  8023ba:	d3 ea                	shr    %cl,%edx
  8023bc:	09 d8                	or     %ebx,%eax
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	29 fe                	sub    %edi,%esi
  8023d2:	19 c3                	sbb    %eax,%ebx
  8023d4:	89 f2                	mov    %esi,%edx
  8023d6:	89 d9                	mov    %ebx,%ecx
  8023d8:	e9 1d ff ff ff       	jmp    8022fa <__umoddi3+0x6a>
