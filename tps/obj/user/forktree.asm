
obj/user/forktree.debug:     formato del fichero elf32-i386


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
  80002c:	e8 be 00 00 00       	call   8000ef <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800041:	e8 51 0b 00 00       	call   800b97 <sys_getenvid>
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	53                   	push   %ebx
  80004a:	50                   	push   %eax
  80004b:	68 20 24 80 00       	push   $0x802420
  800050:	e8 a3 01 00 00       	call   8001f8 <cprintf>

	forkchild(cur, '0');
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	6a 30                	push   $0x30
  80005a:	53                   	push   %ebx
  80005b:	e8 13 00 00 00       	call   800073 <forkchild>
	forkchild(cur, '1');
  800060:	83 c4 08             	add    $0x8,%esp
  800063:	6a 31                	push   $0x31
  800065:	53                   	push   %ebx
  800066:	e8 08 00 00 00       	call   800073 <forkchild>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800071:	c9                   	leave  
  800072:	c3                   	ret    

00800073 <forkchild>:
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	83 ec 1c             	sub    $0x1c,%esp
  80007f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800082:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  800085:	53                   	push   %ebx
  800086:	e8 94 06 00 00       	call   80071f <strlen>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 f8 02             	cmp    $0x2,%eax
  800091:	7e 07                	jle    80009a <forkchild+0x27>
}
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	89 f0                	mov    %esi,%eax
  80009f:	0f be f0             	movsbl %al,%esi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	68 31 24 80 00       	push   $0x802431
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 4d 06 00 00       	call   800701 <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 ee 0f 00 00       	call   8010aa <fork>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	75 d3                	jne    800093 <forkchild+0x20>
		forktree(nxt);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 67 ff ff ff       	call   800033 <forktree>
		exit();
  8000cc:	e8 6c 00 00 00       	call   80013d <exit>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	eb bd                	jmp    800093 <forkchild+0x20>

008000d6 <umain>:

void
umain(int argc, char **argv)
{
  8000d6:	f3 0f 1e fb          	endbr32 
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000e0:	68 8d 2a 80 00       	push   $0x802a8d
  8000e5:	e8 49 ff ff ff       	call   800033 <forktree>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    

008000ef <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000fe:	e8 94 0a 00 00       	call   800b97 <sys_getenvid>
	if (id >= 0)
  800103:	85 c0                	test   %eax,%eax
  800105:	78 12                	js     800119 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 db                	test   %ebx,%ebx
  80011b:	7e 07                	jle    800124 <libmain+0x35>
		binaryname = argv[0];
  80011d:	8b 06                	mov    (%esi),%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	56                   	push   %esi
  800128:	53                   	push   %ebx
  800129:	e8 a8 ff ff ff       	call   8000d6 <umain>

	// exit gracefully
	exit();
  80012e:	e8 0a 00 00 00       	call   80013d <exit>
}
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800139:	5b                   	pop    %ebx
  80013a:	5e                   	pop    %esi
  80013b:	5d                   	pop    %ebp
  80013c:	c3                   	ret    

0080013d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013d:	f3 0f 1e fb          	endbr32 
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800147:	e8 9d 12 00 00       	call   8013e9 <close_all>
	sys_env_destroy(0);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	6a 00                	push   $0x0
  800151:	e8 1b 0a 00 00       	call   800b71 <sys_env_destroy>
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	f3 0f 1e fb          	endbr32 
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	53                   	push   %ebx
  800163:	83 ec 04             	sub    $0x4,%esp
  800166:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800169:	8b 13                	mov    (%ebx),%edx
  80016b:	8d 42 01             	lea    0x1(%edx),%eax
  80016e:	89 03                	mov    %eax,(%ebx)
  800170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800173:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800177:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017c:	74 09                	je     800187 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800185:	c9                   	leave  
  800186:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	68 ff 00 00 00       	push   $0xff
  80018f:	8d 43 08             	lea    0x8(%ebx),%eax
  800192:	50                   	push   %eax
  800193:	e8 87 09 00 00       	call   800b1f <sys_cputs>
		b->idx = 0;
  800198:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	eb db                	jmp    80017e <putch+0x23>

008001a3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a3:	f3 0f 1e fb          	endbr32 
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 5b 01 80 00       	push   $0x80015b
  8001d6:	e8 80 01 00 00       	call   80035b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 2f 09 00 00       	call   800b1f <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800202:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800205:	50                   	push   %eax
  800206:	ff 75 08             	pushl  0x8(%ebp)
  800209:	e8 95 ff ff ff       	call   8001a3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 1c             	sub    $0x1c,%esp
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 d6                	mov    %edx,%esi
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	89 d1                	mov    %edx,%ecx
  800225:	89 c2                	mov    %eax,%edx
  800227:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800236:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80023d:	39 c2                	cmp    %eax,%edx
  80023f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800242:	72 3e                	jb     800282 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	83 eb 01             	sub    $0x1,%ebx
  80024d:	53                   	push   %ebx
  80024e:	50                   	push   %eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	ff 75 dc             	pushl  -0x24(%ebp)
  80025b:	ff 75 d8             	pushl  -0x28(%ebp)
  80025e:	e8 4d 1f 00 00       	call   8021b0 <__udivdi3>
  800263:	83 c4 18             	add    $0x18,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	89 f2                	mov    %esi,%edx
  80026a:	89 f8                	mov    %edi,%eax
  80026c:	e8 9f ff ff ff       	call   800210 <printnum>
  800271:	83 c4 20             	add    $0x20,%esp
  800274:	eb 13                	jmp    800289 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	56                   	push   %esi
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	ff d7                	call   *%edi
  80027f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800282:	83 eb 01             	sub    $0x1,%ebx
  800285:	85 db                	test   %ebx,%ebx
  800287:	7f ed                	jg     800276 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	56                   	push   %esi
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	ff 75 dc             	pushl  -0x24(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	e8 1f 20 00 00       	call   8022c0 <__umoddi3>
  8002a1:	83 c4 14             	add    $0x14,%esp
  8002a4:	0f be 80 40 24 80 00 	movsbl 0x802440(%eax),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff d7                	call   *%edi
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002b9:	83 fa 01             	cmp    $0x1,%edx
  8002bc:	7f 13                	jg     8002d1 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002be:	85 d2                	test   %edx,%edx
  8002c0:	74 1c                	je     8002de <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002c2:	8b 10                	mov    (%eax),%edx
  8002c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 02                	mov    (%edx),%eax
  8002cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d0:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002d1:	8b 10                	mov    (%eax),%edx
  8002d3:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d6:	89 08                	mov    %ecx,(%eax)
  8002d8:	8b 02                	mov    (%edx),%eax
  8002da:	8b 52 04             	mov    0x4(%edx),%edx
  8002dd:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8002de:	8b 10                	mov    (%eax),%edx
  8002e0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e3:	89 08                	mov    %ecx,(%eax)
  8002e5:	8b 02                	mov    (%edx),%eax
  8002e7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ec:	c3                   	ret    

008002ed <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002ed:	83 fa 01             	cmp    $0x1,%edx
  8002f0:	7f 0f                	jg     800301 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8002f2:	85 d2                	test   %edx,%edx
  8002f4:	74 18                	je     80030e <getint+0x21>
		return va_arg(*ap, long);
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 02                	mov    (%edx),%eax
  8002ff:	99                   	cltd   
  800300:	c3                   	ret    
		return va_arg(*ap, long long);
  800301:	8b 10                	mov    (%eax),%edx
  800303:	8d 4a 08             	lea    0x8(%edx),%ecx
  800306:	89 08                	mov    %ecx,(%eax)
  800308:	8b 02                	mov    (%edx),%eax
  80030a:	8b 52 04             	mov    0x4(%edx),%edx
  80030d:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8d 4a 04             	lea    0x4(%edx),%ecx
  800313:	89 08                	mov    %ecx,(%eax)
  800315:	8b 02                	mov    (%edx),%eax
  800317:	99                   	cltd   
}
  800318:	c3                   	ret    

00800319 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800319:	f3 0f 1e fb          	endbr32 
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800323:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800327:	8b 10                	mov    (%eax),%edx
  800329:	3b 50 04             	cmp    0x4(%eax),%edx
  80032c:	73 0a                	jae    800338 <sprintputch+0x1f>
		*b->buf++ = ch;
  80032e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800331:	89 08                	mov    %ecx,(%eax)
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	88 02                	mov    %al,(%edx)
}
  800338:	5d                   	pop    %ebp
  800339:	c3                   	ret    

0080033a <printfmt>:
{
  80033a:	f3 0f 1e fb          	endbr32 
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800344:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800347:	50                   	push   %eax
  800348:	ff 75 10             	pushl  0x10(%ebp)
  80034b:	ff 75 0c             	pushl  0xc(%ebp)
  80034e:	ff 75 08             	pushl  0x8(%ebp)
  800351:	e8 05 00 00 00       	call   80035b <vprintfmt>
}
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	c9                   	leave  
  80035a:	c3                   	ret    

0080035b <vprintfmt>:
{
  80035b:	f3 0f 1e fb          	endbr32 
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	57                   	push   %edi
  800363:	56                   	push   %esi
  800364:	53                   	push   %ebx
  800365:	83 ec 2c             	sub    $0x2c,%esp
  800368:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80036b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80036e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800371:	e9 86 02 00 00       	jmp    8005fc <vprintfmt+0x2a1>
		padc = ' ';
  800376:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80037a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800381:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800388:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80038f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8d 47 01             	lea    0x1(%edi),%eax
  800397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039a:	0f b6 17             	movzbl (%edi),%edx
  80039d:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a0:	3c 55                	cmp    $0x55,%al
  8003a2:	0f 87 df 02 00 00    	ja     800687 <vprintfmt+0x32c>
  8003a8:	0f b6 c0             	movzbl %al,%eax
  8003ab:	3e ff 24 85 80 25 80 	notrack jmp *0x802580(,%eax,4)
  8003b2:	00 
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003ba:	eb d8                	jmp    800394 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bf:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003c3:	eb cf                	jmp    800394 <vprintfmt+0x39>
  8003c5:	0f b6 d2             	movzbl %dl,%edx
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003d3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003da:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003dd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e0:	83 f9 09             	cmp    $0x9,%ecx
  8003e3:	77 52                	ja     800437 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8003e5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e8:	eb e9                	jmp    8003d3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ed:	8d 50 04             	lea    0x4(%eax),%edx
  8003f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ff:	79 93                	jns    800394 <vprintfmt+0x39>
				width = precision, precision = -1;
  800401:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800404:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800407:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80040e:	eb 84                	jmp    800394 <vprintfmt+0x39>
  800410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800413:	85 c0                	test   %eax,%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	0f 49 d0             	cmovns %eax,%edx
  80041d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800423:	e9 6c ff ff ff       	jmp    800394 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80042b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800432:	e9 5d ff ff ff       	jmp    800394 <vprintfmt+0x39>
  800437:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80043d:	eb bc                	jmp    8003fb <vprintfmt+0xa0>
			lflag++;
  80043f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800445:	e9 4a ff ff ff       	jmp    800394 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80044a:	8b 45 14             	mov    0x14(%ebp),%eax
  80044d:	8d 50 04             	lea    0x4(%eax),%edx
  800450:	89 55 14             	mov    %edx,0x14(%ebp)
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	56                   	push   %esi
  800457:	ff 30                	pushl  (%eax)
  800459:	ff d3                	call   *%ebx
			break;
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	e9 96 01 00 00       	jmp    8005f9 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 50 04             	lea    0x4(%eax),%edx
  800469:	89 55 14             	mov    %edx,0x14(%ebp)
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	99                   	cltd   
  80046f:	31 d0                	xor    %edx,%eax
  800471:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800473:	83 f8 0f             	cmp    $0xf,%eax
  800476:	7f 20                	jg     800498 <vprintfmt+0x13d>
  800478:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	74 15                	je     800498 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800483:	52                   	push   %edx
  800484:	68 db 29 80 00       	push   $0x8029db
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	e8 aa fe ff ff       	call   80033a <printfmt>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	e9 61 01 00 00       	jmp    8005f9 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800498:	50                   	push   %eax
  800499:	68 58 24 80 00       	push   $0x802458
  80049e:	56                   	push   %esi
  80049f:	53                   	push   %ebx
  8004a0:	e8 95 fe ff ff       	call   80033a <printfmt>
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	e9 4c 01 00 00       	jmp    8005f9 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8d 50 04             	lea    0x4(%eax),%edx
  8004b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004b8:	85 c9                	test   %ecx,%ecx
  8004ba:	b8 51 24 80 00       	mov    $0x802451,%eax
  8004bf:	0f 45 c1             	cmovne %ecx,%eax
  8004c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c9:	7e 06                	jle    8004d1 <vprintfmt+0x176>
  8004cb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cf:	75 0d                	jne    8004de <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d4:	89 c7                	mov    %eax,%edi
  8004d6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004dc:	eb 57                	jmp    800535 <vprintfmt+0x1da>
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e4:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e7:	e8 4f 02 00 00       	call   80073b <strnlen>
  8004ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ef:	29 c2                	sub    %eax,%edx
  8004f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004f7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8004fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8004fe:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800500:	85 db                	test   %ebx,%ebx
  800502:	7e 10                	jle    800514 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	56                   	push   %esi
  800508:	57                   	push   %edi
  800509:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80050c:	83 eb 01             	sub    $0x1,%ebx
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	eb ec                	jmp    800500 <vprintfmt+0x1a5>
  800514:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800517:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051a:	85 d2                	test   %edx,%edx
  80051c:	b8 00 00 00 00       	mov    $0x0,%eax
  800521:	0f 49 c2             	cmovns %edx,%eax
  800524:	29 c2                	sub    %eax,%edx
  800526:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800529:	eb a6                	jmp    8004d1 <vprintfmt+0x176>
					putch(ch, putdat);
  80052b:	83 ec 08             	sub    $0x8,%esp
  80052e:	56                   	push   %esi
  80052f:	52                   	push   %edx
  800530:	ff d3                	call   *%ebx
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800538:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053a:	83 c7 01             	add    $0x1,%edi
  80053d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800541:	0f be d0             	movsbl %al,%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 42                	je     80058a <vprintfmt+0x22f>
  800548:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054c:	78 06                	js     800554 <vprintfmt+0x1f9>
  80054e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800552:	78 1e                	js     800572 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800554:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800558:	74 d1                	je     80052b <vprintfmt+0x1d0>
  80055a:	0f be c0             	movsbl %al,%eax
  80055d:	83 e8 20             	sub    $0x20,%eax
  800560:	83 f8 5e             	cmp    $0x5e,%eax
  800563:	76 c6                	jbe    80052b <vprintfmt+0x1d0>
					putch('?', putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	56                   	push   %esi
  800569:	6a 3f                	push   $0x3f
  80056b:	ff d3                	call   *%ebx
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	eb c3                	jmp    800535 <vprintfmt+0x1da>
  800572:	89 cf                	mov    %ecx,%edi
  800574:	eb 0e                	jmp    800584 <vprintfmt+0x229>
				putch(' ', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	56                   	push   %esi
  80057a:	6a 20                	push   $0x20
  80057c:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  80057e:	83 ef 01             	sub    $0x1,%edi
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	85 ff                	test   %edi,%edi
  800586:	7f ee                	jg     800576 <vprintfmt+0x21b>
  800588:	eb 6f                	jmp    8005f9 <vprintfmt+0x29e>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb f6                	jmp    800584 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  80058e:	89 ca                	mov    %ecx,%edx
  800590:	8d 45 14             	lea    0x14(%ebp),%eax
  800593:	e8 55 fd ff ff       	call   8002ed <getint>
  800598:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80059e:	85 d2                	test   %edx,%edx
  8005a0:	78 0b                	js     8005ad <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005a2:	89 d1                	mov    %edx,%ecx
  8005a4:	89 c2                	mov    %eax,%edx
			base = 10;
  8005a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ab:	eb 32                	jmp    8005df <vprintfmt+0x284>
				putch('-', putdat);
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	56                   	push   %esi
  8005b1:	6a 2d                	push   $0x2d
  8005b3:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bb:	f7 da                	neg    %edx
  8005bd:	83 d1 00             	adc    $0x0,%ecx
  8005c0:	f7 d9                	neg    %ecx
  8005c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ca:	eb 13                	jmp    8005df <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005cc:	89 ca                	mov    %ecx,%edx
  8005ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d1:	e8 e3 fc ff ff       	call   8002b9 <getuint>
  8005d6:	89 d1                	mov    %edx,%ecx
  8005d8:	89 c2                	mov    %eax,%edx
			base = 10;
  8005da:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005e6:	57                   	push   %edi
  8005e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ea:	50                   	push   %eax
  8005eb:	51                   	push   %ecx
  8005ec:	52                   	push   %edx
  8005ed:	89 f2                	mov    %esi,%edx
  8005ef:	89 d8                	mov    %ebx,%eax
  8005f1:	e8 1a fc ff ff       	call   800210 <printnum>
			break;
  8005f6:	83 c4 20             	add    $0x20,%esp
{
  8005f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005fc:	83 c7 01             	add    $0x1,%edi
  8005ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800603:	83 f8 25             	cmp    $0x25,%eax
  800606:	0f 84 6a fd ff ff    	je     800376 <vprintfmt+0x1b>
			if (ch == '\0')
  80060c:	85 c0                	test   %eax,%eax
  80060e:	0f 84 93 00 00 00    	je     8006a7 <vprintfmt+0x34c>
			putch(ch, putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	56                   	push   %esi
  800618:	50                   	push   %eax
  800619:	ff d3                	call   *%ebx
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	eb dc                	jmp    8005fc <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800620:	89 ca                	mov    %ecx,%edx
  800622:	8d 45 14             	lea    0x14(%ebp),%eax
  800625:	e8 8f fc ff ff       	call   8002b9 <getuint>
  80062a:	89 d1                	mov    %edx,%ecx
  80062c:	89 c2                	mov    %eax,%edx
			base = 8;
  80062e:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800633:	eb aa                	jmp    8005df <vprintfmt+0x284>
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	56                   	push   %esi
  800639:	6a 30                	push   $0x30
  80063b:	ff d3                	call   *%ebx
			putch('x', putdat);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	56                   	push   %esi
  800641:	6a 78                	push   $0x78
  800643:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 50 04             	lea    0x4(%eax),%edx
  80064b:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80064e:	8b 10                	mov    (%eax),%edx
  800650:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800655:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800658:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80065d:	eb 80                	jmp    8005df <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80065f:	89 ca                	mov    %ecx,%edx
  800661:	8d 45 14             	lea    0x14(%ebp),%eax
  800664:	e8 50 fc ff ff       	call   8002b9 <getuint>
  800669:	89 d1                	mov    %edx,%ecx
  80066b:	89 c2                	mov    %eax,%edx
			base = 16;
  80066d:	b8 10 00 00 00       	mov    $0x10,%eax
  800672:	e9 68 ff ff ff       	jmp    8005df <vprintfmt+0x284>
			putch(ch, putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	56                   	push   %esi
  80067b:	6a 25                	push   $0x25
  80067d:	ff d3                	call   *%ebx
			break;
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	e9 72 ff ff ff       	jmp    8005f9 <vprintfmt+0x29e>
			putch('%', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	56                   	push   %esi
  80068b:	6a 25                	push   $0x25
  80068d:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	89 f8                	mov    %edi,%eax
  800694:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800698:	74 05                	je     80069f <vprintfmt+0x344>
  80069a:	83 e8 01             	sub    $0x1,%eax
  80069d:	eb f5                	jmp    800694 <vprintfmt+0x339>
  80069f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a2:	e9 52 ff ff ff       	jmp    8005f9 <vprintfmt+0x29e>
}
  8006a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006aa:	5b                   	pop    %ebx
  8006ab:	5e                   	pop    %esi
  8006ac:	5f                   	pop    %edi
  8006ad:	5d                   	pop    %ebp
  8006ae:	c3                   	ret    

008006af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006af:	f3 0f 1e fb          	endbr32 
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006d0:	85 c0                	test   %eax,%eax
  8006d2:	74 26                	je     8006fa <vsnprintf+0x4b>
  8006d4:	85 d2                	test   %edx,%edx
  8006d6:	7e 22                	jle    8006fa <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d8:	ff 75 14             	pushl  0x14(%ebp)
  8006db:	ff 75 10             	pushl  0x10(%ebp)
  8006de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	68 19 03 80 00       	push   $0x800319
  8006e7:	e8 6f fc ff ff       	call   80035b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f5:	83 c4 10             	add    $0x10,%esp
}
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    
		return -E_INVAL;
  8006fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ff:	eb f7                	jmp    8006f8 <vsnprintf+0x49>

00800701 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800701:	f3 0f 1e fb          	endbr32 
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80070b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80070e:	50                   	push   %eax
  80070f:	ff 75 10             	pushl  0x10(%ebp)
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	ff 75 08             	pushl  0x8(%ebp)
  800718:	e8 92 ff ff ff       	call   8006af <vsnprintf>
	va_end(ap);

	return rc;
}
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80071f:	f3 0f 1e fb          	endbr32 
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800729:	b8 00 00 00 00       	mov    $0x0,%eax
  80072e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800732:	74 05                	je     800739 <strlen+0x1a>
		n++;
  800734:	83 c0 01             	add    $0x1,%eax
  800737:	eb f5                	jmp    80072e <strlen+0xf>
	return n;
}
  800739:	5d                   	pop    %ebp
  80073a:	c3                   	ret    

0080073b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80073b:	f3 0f 1e fb          	endbr32 
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	39 d0                	cmp    %edx,%eax
  80074f:	74 0d                	je     80075e <strnlen+0x23>
  800751:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800755:	74 05                	je     80075c <strnlen+0x21>
		n++;
  800757:	83 c0 01             	add    $0x1,%eax
  80075a:	eb f1                	jmp    80074d <strnlen+0x12>
  80075c:	89 c2                	mov    %eax,%edx
	return n;
}
  80075e:	89 d0                	mov    %edx,%eax
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800762:	f3 0f 1e fb          	endbr32 
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	53                   	push   %ebx
  80076a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800779:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80077c:	83 c0 01             	add    $0x1,%eax
  80077f:	84 d2                	test   %dl,%dl
  800781:	75 f2                	jne    800775 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800783:	89 c8                	mov    %ecx,%eax
  800785:	5b                   	pop    %ebx
  800786:	5d                   	pop    %ebp
  800787:	c3                   	ret    

00800788 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800788:	f3 0f 1e fb          	endbr32 
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	53                   	push   %ebx
  800790:	83 ec 10             	sub    $0x10,%esp
  800793:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800796:	53                   	push   %ebx
  800797:	e8 83 ff ff ff       	call   80071f <strlen>
  80079c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	01 d8                	add    %ebx,%eax
  8007a4:	50                   	push   %eax
  8007a5:	e8 b8 ff ff ff       	call   800762 <strcpy>
	return dst;
}
  8007aa:	89 d8                	mov    %ebx,%eax
  8007ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b1:	f3 0f 1e fb          	endbr32 
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	56                   	push   %esi
  8007b9:	53                   	push   %ebx
  8007ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8007bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c0:	89 f3                	mov    %esi,%ebx
  8007c2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c5:	89 f0                	mov    %esi,%eax
  8007c7:	39 d8                	cmp    %ebx,%eax
  8007c9:	74 11                	je     8007dc <strncpy+0x2b>
		*dst++ = *src;
  8007cb:	83 c0 01             	add    $0x1,%eax
  8007ce:	0f b6 0a             	movzbl (%edx),%ecx
  8007d1:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d4:	80 f9 01             	cmp    $0x1,%cl
  8007d7:	83 da ff             	sbb    $0xffffffff,%edx
  8007da:	eb eb                	jmp    8007c7 <strncpy+0x16>
	}
	return ret;
}
  8007dc:	89 f0                	mov    %esi,%eax
  8007de:	5b                   	pop    %ebx
  8007df:	5e                   	pop    %esi
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e2:	f3 0f 1e fb          	endbr32 
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	56                   	push   %esi
  8007ea:	53                   	push   %ebx
  8007eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f1:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f6:	85 d2                	test   %edx,%edx
  8007f8:	74 21                	je     80081b <strlcpy+0x39>
  8007fa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007fe:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800800:	39 c2                	cmp    %eax,%edx
  800802:	74 14                	je     800818 <strlcpy+0x36>
  800804:	0f b6 19             	movzbl (%ecx),%ebx
  800807:	84 db                	test   %bl,%bl
  800809:	74 0b                	je     800816 <strlcpy+0x34>
			*dst++ = *src++;
  80080b:	83 c1 01             	add    $0x1,%ecx
  80080e:	83 c2 01             	add    $0x1,%edx
  800811:	88 5a ff             	mov    %bl,-0x1(%edx)
  800814:	eb ea                	jmp    800800 <strlcpy+0x1e>
  800816:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800818:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081b:	29 f0                	sub    %esi,%eax
}
  80081d:	5b                   	pop    %ebx
  80081e:	5e                   	pop    %esi
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800821:	f3 0f 1e fb          	endbr32 
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082e:	0f b6 01             	movzbl (%ecx),%eax
  800831:	84 c0                	test   %al,%al
  800833:	74 0c                	je     800841 <strcmp+0x20>
  800835:	3a 02                	cmp    (%edx),%al
  800837:	75 08                	jne    800841 <strcmp+0x20>
		p++, q++;
  800839:	83 c1 01             	add    $0x1,%ecx
  80083c:	83 c2 01             	add    $0x1,%edx
  80083f:	eb ed                	jmp    80082e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800841:	0f b6 c0             	movzbl %al,%eax
  800844:	0f b6 12             	movzbl (%edx),%edx
  800847:	29 d0                	sub    %edx,%eax
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084b:	f3 0f 1e fb          	endbr32 
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 55 0c             	mov    0xc(%ebp),%edx
  800859:	89 c3                	mov    %eax,%ebx
  80085b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80085e:	eb 06                	jmp    800866 <strncmp+0x1b>
		n--, p++, q++;
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800866:	39 d8                	cmp    %ebx,%eax
  800868:	74 16                	je     800880 <strncmp+0x35>
  80086a:	0f b6 08             	movzbl (%eax),%ecx
  80086d:	84 c9                	test   %cl,%cl
  80086f:	74 04                	je     800875 <strncmp+0x2a>
  800871:	3a 0a                	cmp    (%edx),%cl
  800873:	74 eb                	je     800860 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800875:	0f b6 00             	movzbl (%eax),%eax
  800878:	0f b6 12             	movzbl (%edx),%edx
  80087b:	29 d0                	sub    %edx,%eax
}
  80087d:	5b                   	pop    %ebx
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    
		return 0;
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
  800885:	eb f6                	jmp    80087d <strncmp+0x32>

00800887 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800895:	0f b6 10             	movzbl (%eax),%edx
  800898:	84 d2                	test   %dl,%dl
  80089a:	74 09                	je     8008a5 <strchr+0x1e>
		if (*s == c)
  80089c:	38 ca                	cmp    %cl,%dl
  80089e:	74 0a                	je     8008aa <strchr+0x23>
	for (; *s; s++)
  8008a0:	83 c0 01             	add    $0x1,%eax
  8008a3:	eb f0                	jmp    800895 <strchr+0xe>
			return (char *) s;
	return 0;
  8008a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ac:	f3 0f 1e fb          	endbr32 
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ba:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008bd:	38 ca                	cmp    %cl,%dl
  8008bf:	74 09                	je     8008ca <strfind+0x1e>
  8008c1:	84 d2                	test   %dl,%dl
  8008c3:	74 05                	je     8008ca <strfind+0x1e>
	for (; *s; s++)
  8008c5:	83 c0 01             	add    $0x1,%eax
  8008c8:	eb f0                	jmp    8008ba <strfind+0xe>
			break;
	return (char *) s;
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	57                   	push   %edi
  8008d4:	56                   	push   %esi
  8008d5:	53                   	push   %ebx
  8008d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	74 33                	je     800913 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e0:	89 d0                	mov    %edx,%eax
  8008e2:	09 c8                	or     %ecx,%eax
  8008e4:	a8 03                	test   $0x3,%al
  8008e6:	75 23                	jne    80090b <memset+0x3f>
		c &= 0xFF;
  8008e8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ec:	89 d8                	mov    %ebx,%eax
  8008ee:	c1 e0 08             	shl    $0x8,%eax
  8008f1:	89 df                	mov    %ebx,%edi
  8008f3:	c1 e7 18             	shl    $0x18,%edi
  8008f6:	89 de                	mov    %ebx,%esi
  8008f8:	c1 e6 10             	shl    $0x10,%esi
  8008fb:	09 f7                	or     %esi,%edi
  8008fd:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008ff:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800902:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800904:	89 d7                	mov    %edx,%edi
  800906:	fc                   	cld    
  800907:	f3 ab                	rep stos %eax,%es:(%edi)
  800909:	eb 08                	jmp    800913 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090b:	89 d7                	mov    %edx,%edi
  80090d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800910:	fc                   	cld    
  800911:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800913:	89 d0                	mov    %edx,%eax
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5f                   	pop    %edi
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80091a:	f3 0f 1e fb          	endbr32 
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	57                   	push   %edi
  800922:	56                   	push   %esi
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 75 0c             	mov    0xc(%ebp),%esi
  800929:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80092c:	39 c6                	cmp    %eax,%esi
  80092e:	73 32                	jae    800962 <memmove+0x48>
  800930:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800933:	39 c2                	cmp    %eax,%edx
  800935:	76 2b                	jbe    800962 <memmove+0x48>
		s += n;
		d += n;
  800937:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093a:	89 fe                	mov    %edi,%esi
  80093c:	09 ce                	or     %ecx,%esi
  80093e:	09 d6                	or     %edx,%esi
  800940:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800946:	75 0e                	jne    800956 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800948:	83 ef 04             	sub    $0x4,%edi
  80094b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80094e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800951:	fd                   	std    
  800952:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800954:	eb 09                	jmp    80095f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800956:	83 ef 01             	sub    $0x1,%edi
  800959:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80095c:	fd                   	std    
  80095d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095f:	fc                   	cld    
  800960:	eb 1a                	jmp    80097c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800962:	89 c2                	mov    %eax,%edx
  800964:	09 ca                	or     %ecx,%edx
  800966:	09 f2                	or     %esi,%edx
  800968:	f6 c2 03             	test   $0x3,%dl
  80096b:	75 0a                	jne    800977 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800970:	89 c7                	mov    %eax,%edi
  800972:	fc                   	cld    
  800973:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800975:	eb 05                	jmp    80097c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800977:	89 c7                	mov    %eax,%edi
  800979:	fc                   	cld    
  80097a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80097c:	5e                   	pop    %esi
  80097d:	5f                   	pop    %edi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80098a:	ff 75 10             	pushl  0x10(%ebp)
  80098d:	ff 75 0c             	pushl  0xc(%ebp)
  800990:	ff 75 08             	pushl  0x8(%ebp)
  800993:	e8 82 ff ff ff       	call   80091a <memmove>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80099a:	f3 0f 1e fb          	endbr32 
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	89 c6                	mov    %eax,%esi
  8009ab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ae:	39 f0                	cmp    %esi,%eax
  8009b0:	74 1c                	je     8009ce <memcmp+0x34>
		if (*s1 != *s2)
  8009b2:	0f b6 08             	movzbl (%eax),%ecx
  8009b5:	0f b6 1a             	movzbl (%edx),%ebx
  8009b8:	38 d9                	cmp    %bl,%cl
  8009ba:	75 08                	jne    8009c4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009bc:	83 c0 01             	add    $0x1,%eax
  8009bf:	83 c2 01             	add    $0x1,%edx
  8009c2:	eb ea                	jmp    8009ae <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009c4:	0f b6 c1             	movzbl %cl,%eax
  8009c7:	0f b6 db             	movzbl %bl,%ebx
  8009ca:	29 d8                	sub    %ebx,%eax
  8009cc:	eb 05                	jmp    8009d3 <memcmp+0x39>
	}

	return 0;
  8009ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d7:	f3 0f 1e fb          	endbr32 
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e9:	39 d0                	cmp    %edx,%eax
  8009eb:	73 09                	jae    8009f6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ed:	38 08                	cmp    %cl,(%eax)
  8009ef:	74 05                	je     8009f6 <memfind+0x1f>
	for (; s < ends; s++)
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	eb f3                	jmp    8009e9 <memfind+0x12>
			break;
	return (void *) s;
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f8:	f3 0f 1e fb          	endbr32 
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a08:	eb 03                	jmp    800a0d <strtol+0x15>
		s++;
  800a0a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a0d:	0f b6 01             	movzbl (%ecx),%eax
  800a10:	3c 20                	cmp    $0x20,%al
  800a12:	74 f6                	je     800a0a <strtol+0x12>
  800a14:	3c 09                	cmp    $0x9,%al
  800a16:	74 f2                	je     800a0a <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a18:	3c 2b                	cmp    $0x2b,%al
  800a1a:	74 2a                	je     800a46 <strtol+0x4e>
	int neg = 0;
  800a1c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a21:	3c 2d                	cmp    $0x2d,%al
  800a23:	74 2b                	je     800a50 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a25:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a2b:	75 0f                	jne    800a3c <strtol+0x44>
  800a2d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a30:	74 28                	je     800a5a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a39:	0f 44 d8             	cmove  %eax,%ebx
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a44:	eb 46                	jmp    800a8c <strtol+0x94>
		s++;
  800a46:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a49:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4e:	eb d5                	jmp    800a25 <strtol+0x2d>
		s++, neg = 1;
  800a50:	83 c1 01             	add    $0x1,%ecx
  800a53:	bf 01 00 00 00       	mov    $0x1,%edi
  800a58:	eb cb                	jmp    800a25 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a5e:	74 0e                	je     800a6e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a60:	85 db                	test   %ebx,%ebx
  800a62:	75 d8                	jne    800a3c <strtol+0x44>
		s++, base = 8;
  800a64:	83 c1 01             	add    $0x1,%ecx
  800a67:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a6c:	eb ce                	jmp    800a3c <strtol+0x44>
		s += 2, base = 16;
  800a6e:	83 c1 02             	add    $0x2,%ecx
  800a71:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a76:	eb c4                	jmp    800a3c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a78:	0f be d2             	movsbl %dl,%edx
  800a7b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a7e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a81:	7d 3a                	jge    800abd <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a8c:	0f b6 11             	movzbl (%ecx),%edx
  800a8f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a92:	89 f3                	mov    %esi,%ebx
  800a94:	80 fb 09             	cmp    $0x9,%bl
  800a97:	76 df                	jbe    800a78 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a99:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a9c:	89 f3                	mov    %esi,%ebx
  800a9e:	80 fb 19             	cmp    $0x19,%bl
  800aa1:	77 08                	ja     800aab <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aa3:	0f be d2             	movsbl %dl,%edx
  800aa6:	83 ea 57             	sub    $0x57,%edx
  800aa9:	eb d3                	jmp    800a7e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aab:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aae:	89 f3                	mov    %esi,%ebx
  800ab0:	80 fb 19             	cmp    $0x19,%bl
  800ab3:	77 08                	ja     800abd <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab5:	0f be d2             	movsbl %dl,%edx
  800ab8:	83 ea 37             	sub    $0x37,%edx
  800abb:	eb c1                	jmp    800a7e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800abd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac1:	74 05                	je     800ac8 <strtol+0xd0>
		*endptr = (char *) s;
  800ac3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	f7 da                	neg    %edx
  800acc:	85 ff                	test   %edi,%edi
  800ace:	0f 45 c2             	cmovne %edx,%eax
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	83 ec 1c             	sub    $0x1c,%esp
  800adf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ae2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ae5:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aed:	8b 7d 10             	mov    0x10(%ebp),%edi
  800af0:	8b 75 14             	mov    0x14(%ebp),%esi
  800af3:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	74 04                	je     800aff <syscall+0x29>
  800afb:	85 c0                	test   %eax,%eax
  800afd:	7f 08                	jg     800b07 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b07:	83 ec 0c             	sub    $0xc,%esp
  800b0a:	50                   	push   %eax
  800b0b:	ff 75 e0             	pushl  -0x20(%ebp)
  800b0e:	68 3f 27 80 00       	push   $0x80273f
  800b13:	6a 23                	push   $0x23
  800b15:	68 5c 27 80 00       	push   $0x80275c
  800b1a:	e8 5f 14 00 00       	call   801f7e <_panic>

00800b1f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b1f:	f3 0f 1e fb          	endbr32 
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b29:	6a 00                	push   $0x0
  800b2b:	6a 00                	push   $0x0
  800b2d:	6a 00                	push   $0x0
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3f:	e8 92 ff ff ff       	call   800ad6 <syscall>
}
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b53:	6a 00                	push   $0x0
  800b55:	6a 00                	push   $0x0
  800b57:	6a 00                	push   $0x0
  800b59:	6a 00                	push   $0x0
  800b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6a:	e8 67 ff ff ff       	call   800ad6 <syscall>
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b71:	f3 0f 1e fb          	endbr32 
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b7b:	6a 00                	push   $0x0
  800b7d:	6a 00                	push   $0x0
  800b7f:	6a 00                	push   $0x0
  800b81:	6a 00                	push   $0x0
  800b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b86:	ba 01 00 00 00       	mov    $0x1,%edx
  800b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b90:	e8 41 ff ff ff       	call   800ad6 <syscall>
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b97:	f3 0f 1e fb          	endbr32 
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ba1:	6a 00                	push   $0x0
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb8:	e8 19 ff ff ff       	call   800ad6 <syscall>
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <sys_yield>:

void
sys_yield(void)
{
  800bbf:	f3 0f 1e fb          	endbr32 
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bc9:	6a 00                	push   $0x0
  800bcb:	6a 00                	push   $0x0
  800bcd:	6a 00                	push   $0x0
  800bcf:	6a 00                	push   $0x0
  800bd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be0:	e8 f1 fe ff ff       	call   800ad6 <syscall>
}
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bea:	f3 0f 1e fb          	endbr32 
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bf4:	6a 00                	push   $0x0
  800bf6:	6a 00                	push   $0x0
  800bf8:	ff 75 10             	pushl  0x10(%ebp)
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c01:	ba 01 00 00 00       	mov    $0x1,%edx
  800c06:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0b:	e8 c6 fe ff ff       	call   800ad6 <syscall>
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c1c:	ff 75 18             	pushl  0x18(%ebp)
  800c1f:	ff 75 14             	pushl  0x14(%ebp)
  800c22:	ff 75 10             	pushl  0x10(%ebp)
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c30:	b8 05 00 00 00       	mov    $0x5,%eax
  800c35:	e8 9c fe ff ff       	call   800ad6 <syscall>
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c46:	6a 00                	push   $0x0
  800c48:	6a 00                	push   $0x0
  800c4a:	6a 00                	push   $0x0
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c52:	ba 01 00 00 00       	mov    $0x1,%edx
  800c57:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5c:	e8 75 fe ff ff       	call   800ad6 <syscall>
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c6d:	6a 00                	push   $0x0
  800c6f:	6a 00                	push   $0x0
  800c71:	6a 00                	push   $0x0
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c79:	ba 01 00 00 00       	mov    $0x1,%edx
  800c7e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c83:	e8 4e fe ff ff       	call   800ad6 <syscall>
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c8a:	f3 0f 1e fb          	endbr32 
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c94:	6a 00                	push   $0x0
  800c96:	6a 00                	push   $0x0
  800c98:	6a 00                	push   $0x0
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ca5:	b8 09 00 00 00       	mov    $0x9,%eax
  800caa:	e8 27 fe ff ff       	call   800ad6 <syscall>
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800cbb:	6a 00                	push   $0x0
  800cbd:	6a 00                	push   $0x0
  800cbf:	6a 00                	push   $0x0
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc7:	ba 01 00 00 00       	mov    $0x1,%edx
  800ccc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd1:	e8 00 fe ff ff       	call   800ad6 <syscall>
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cd8:	f3 0f 1e fb          	endbr32 
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800ce2:	6a 00                	push   $0x0
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	ff 75 0c             	pushl  0xc(%ebp)
  800ced:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cfa:	e8 d7 fd ff ff       	call   800ad6 <syscall>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d0b:	6a 00                	push   $0x0
  800d0d:	6a 00                	push   $0x0
  800d0f:	6a 00                	push   $0x0
  800d11:	6a 00                	push   $0x0
  800d13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d16:	ba 01 00 00 00       	mov    $0x1,%edx
  800d1b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d20:	e8 b1 fd ff ff       	call   800ad6 <syscall>
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 04             	sub    $0x4,%esp
  800d2e:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800d30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d37:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d3a:	f6 c6 04             	test   $0x4,%dh
  800d3d:	75 51                	jne    800d90 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d3f:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d45:	0f 84 84 00 00 00    	je     800dcf <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	68 05 08 00 00       	push   $0x805
  800d53:	53                   	push   %ebx
  800d54:	50                   	push   %eax
  800d55:	53                   	push   %ebx
  800d56:	6a 00                	push   $0x0
  800d58:	e8 b5 fe ff ff       	call   800c12 <sys_page_map>
		if (r)
  800d5d:	83 c4 20             	add    $0x20,%esp
  800d60:	85 c0                	test   %eax,%eax
  800d62:	75 59                	jne    800dbd <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	68 05 08 00 00       	push   $0x805
  800d6c:	53                   	push   %ebx
  800d6d:	6a 00                	push   $0x0
  800d6f:	53                   	push   %ebx
  800d70:	6a 00                	push   $0x0
  800d72:	e8 9b fe ff ff       	call   800c12 <sys_page_map>
		if (r)
  800d77:	83 c4 20             	add    $0x20,%esp
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	74 67                	je     800de5 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d7e:	50                   	push   %eax
  800d7f:	68 6a 27 80 00       	push   $0x80276a
  800d84:	6a 5f                	push   $0x5f
  800d86:	68 85 27 80 00       	push   $0x802785
  800d8b:	e8 ee 11 00 00       	call   801f7e <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800d90:	83 ec 0c             	sub    $0xc,%esp
  800d93:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d99:	52                   	push   %edx
  800d9a:	53                   	push   %ebx
  800d9b:	50                   	push   %eax
  800d9c:	53                   	push   %ebx
  800d9d:	6a 00                	push   $0x0
  800d9f:	e8 6e fe ff ff       	call   800c12 <sys_page_map>
		if (r)
  800da4:	83 c4 20             	add    $0x20,%esp
  800da7:	85 c0                	test   %eax,%eax
  800da9:	74 3a                	je     800de5 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800dab:	50                   	push   %eax
  800dac:	68 6a 27 80 00       	push   $0x80276a
  800db1:	6a 57                	push   $0x57
  800db3:	68 85 27 80 00       	push   $0x802785
  800db8:	e8 c1 11 00 00       	call   801f7e <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800dbd:	50                   	push   %eax
  800dbe:	68 6a 27 80 00       	push   $0x80276a
  800dc3:	6a 5b                	push   $0x5b
  800dc5:	68 85 27 80 00       	push   $0x802785
  800dca:	e8 af 11 00 00       	call   801f7e <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	6a 05                	push   $0x5
  800dd4:	53                   	push   %ebx
  800dd5:	50                   	push   %eax
  800dd6:	53                   	push   %ebx
  800dd7:	6a 00                	push   $0x0
  800dd9:	e8 34 fe ff ff       	call   800c12 <sys_page_map>
		if (r)
  800dde:	83 c4 20             	add    $0x20,%esp
  800de1:	85 c0                	test   %eax,%eax
  800de3:	75 0a                	jne    800def <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800de5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800def:	50                   	push   %eax
  800df0:	68 6a 27 80 00       	push   $0x80276a
  800df5:	6a 63                	push   $0x63
  800df7:	68 85 27 80 00       	push   $0x802785
  800dfc:	e8 7d 11 00 00       	call   801f7e <_panic>

00800e01 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	89 d6                	mov    %edx,%esi
  800e0e:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800e10:	f6 c1 02             	test   $0x2,%cl
  800e13:	75 2f                	jne    800e44 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	51                   	push   %ecx
  800e19:	52                   	push   %edx
  800e1a:	50                   	push   %eax
  800e1b:	52                   	push   %edx
  800e1c:	6a 00                	push   $0x0
  800e1e:	e8 ef fd ff ff       	call   800c12 <sys_page_map>
  800e23:	83 c4 20             	add    $0x20,%esp
  800e26:	85 c0                	test   %eax,%eax
  800e28:	78 08                	js     800e32 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800e32:	50                   	push   %eax
  800e33:	68 74 27 80 00       	push   $0x802774
  800e38:	6a 6f                	push   $0x6f
  800e3a:	68 85 27 80 00       	push   $0x802785
  800e3f:	e8 3a 11 00 00       	call   801f7e <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	51                   	push   %ecx
  800e48:	52                   	push   %edx
  800e49:	50                   	push   %eax
  800e4a:	e8 9b fd ff ff       	call   800bea <sys_page_alloc>
  800e4f:	83 c4 10             	add    $0x10,%esp
  800e52:	85 c0                	test   %eax,%eax
  800e54:	78 54                	js     800eaa <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	53                   	push   %ebx
  800e5a:	68 00 00 40 00       	push   $0x400000
  800e5f:	6a 00                	push   $0x0
  800e61:	56                   	push   %esi
  800e62:	57                   	push   %edi
  800e63:	e8 aa fd ff ff       	call   800c12 <sys_page_map>
  800e68:	83 c4 20             	add    $0x20,%esp
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	78 4d                	js     800ebc <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800e6f:	83 ec 04             	sub    $0x4,%esp
  800e72:	68 00 10 00 00       	push   $0x1000
  800e77:	56                   	push   %esi
  800e78:	68 00 00 40 00       	push   $0x400000
  800e7d:	e8 98 fa ff ff       	call   80091a <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800e82:	83 c4 08             	add    $0x8,%esp
  800e85:	68 00 00 40 00       	push   $0x400000
  800e8a:	6a 00                	push   $0x0
  800e8c:	e8 ab fd ff ff       	call   800c3c <sys_page_unmap>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	85 c0                	test   %eax,%eax
  800e96:	79 92                	jns    800e2a <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800e98:	50                   	push   %eax
  800e99:	68 a3 27 80 00       	push   $0x8027a3
  800e9e:	6a 78                	push   $0x78
  800ea0:	68 85 27 80 00       	push   $0x802785
  800ea5:	e8 d4 10 00 00       	call   801f7e <_panic>
		panic("sys_page_alloc: %e", r);
  800eaa:	50                   	push   %eax
  800eab:	68 90 27 80 00       	push   $0x802790
  800eb0:	6a 73                	push   $0x73
  800eb2:	68 85 27 80 00       	push   $0x802785
  800eb7:	e8 c2 10 00 00       	call   801f7e <_panic>
		panic("sys_page_map: %e", r);
  800ebc:	50                   	push   %eax
  800ebd:	68 74 27 80 00       	push   $0x802774
  800ec2:	6a 75                	push   $0x75
  800ec4:	68 85 27 80 00       	push   $0x802785
  800ec9:	e8 b0 10 00 00       	call   801f7e <_panic>

00800ece <pgfault>:
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800edc:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ede:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800ee1:	89 da                	mov    %ebx,%edx
  800ee3:	c1 ea 0c             	shr    $0xc,%edx
  800ee6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800eed:	a8 01                	test   $0x1,%al
  800eef:	74 7e                	je     800f6f <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800ef1:	a8 02                	test   $0x2,%al
  800ef3:	0f 84 8a 00 00 00    	je     800f83 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800ef9:	f6 c6 08             	test   $0x8,%dh
  800efc:	0f 84 95 00 00 00    	je     800f97 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800f02:	83 ec 04             	sub    $0x4,%esp
  800f05:	6a 07                	push   $0x7
  800f07:	68 00 f0 7f 00       	push   $0x7ff000
  800f0c:	6a 00                	push   $0x0
  800f0e:	e8 d7 fc ff ff       	call   800bea <sys_page_alloc>
	if (r)
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	85 c0                	test   %eax,%eax
  800f18:	0f 85 8d 00 00 00    	jne    800fab <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f24:	83 ec 04             	sub    $0x4,%esp
  800f27:	68 00 10 00 00       	push   $0x1000
  800f2c:	53                   	push   %ebx
  800f2d:	68 00 f0 7f 00       	push   $0x7ff000
  800f32:	e8 49 fa ff ff       	call   800980 <memcpy>
	r = sys_page_map(
  800f37:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f3e:	53                   	push   %ebx
  800f3f:	6a 00                	push   $0x0
  800f41:	68 00 f0 7f 00       	push   $0x7ff000
  800f46:	6a 00                	push   $0x0
  800f48:	e8 c5 fc ff ff       	call   800c12 <sys_page_map>
	if (r)
  800f4d:	83 c4 20             	add    $0x20,%esp
  800f50:	85 c0                	test   %eax,%eax
  800f52:	75 69                	jne    800fbd <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	68 00 f0 7f 00       	push   $0x7ff000
  800f5c:	6a 00                	push   $0x0
  800f5e:	e8 d9 fc ff ff       	call   800c3c <sys_page_unmap>
	if (r)
  800f63:	83 c4 10             	add    $0x10,%esp
  800f66:	85 c0                	test   %eax,%eax
  800f68:	75 65                	jne    800fcf <pgfault+0x101>
}
  800f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800f6f:	83 ec 04             	sub    $0x4,%esp
  800f72:	68 24 28 80 00       	push   $0x802824
  800f77:	6a 20                	push   $0x20
  800f79:	68 85 27 80 00       	push   $0x802785
  800f7e:	e8 fb 0f 00 00       	call   801f7e <_panic>
		panic("[pgfault] pgfault por lectura");
  800f83:	83 ec 04             	sub    $0x4,%esp
  800f86:	68 b6 27 80 00       	push   $0x8027b6
  800f8b:	6a 23                	push   $0x23
  800f8d:	68 85 27 80 00       	push   $0x802785
  800f92:	e8 e7 0f 00 00       	call   801f7e <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	68 50 28 80 00       	push   $0x802850
  800f9f:	6a 27                	push   $0x27
  800fa1:	68 85 27 80 00       	push   $0x802785
  800fa6:	e8 d3 0f 00 00       	call   801f7e <_panic>
		panic("pgfault: %e", r);
  800fab:	50                   	push   %eax
  800fac:	68 d4 27 80 00       	push   $0x8027d4
  800fb1:	6a 32                	push   $0x32
  800fb3:	68 85 27 80 00       	push   $0x802785
  800fb8:	e8 c1 0f 00 00       	call   801f7e <_panic>
		panic("pgfault: %e", r);
  800fbd:	50                   	push   %eax
  800fbe:	68 d4 27 80 00       	push   $0x8027d4
  800fc3:	6a 39                	push   $0x39
  800fc5:	68 85 27 80 00       	push   $0x802785
  800fca:	e8 af 0f 00 00       	call   801f7e <_panic>
		panic("pgfault: %e", r);
  800fcf:	50                   	push   %eax
  800fd0:	68 d4 27 80 00       	push   $0x8027d4
  800fd5:	6a 3d                	push   $0x3d
  800fd7:	68 85 27 80 00       	push   $0x802785
  800fdc:	e8 9d 0f 00 00       	call   801f7e <_panic>

00800fe1 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  800fe1:	f3 0f 1e fb          	endbr32 
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fee:	b8 07 00 00 00       	mov    $0x7,%eax
  800ff3:	cd 30                	int    $0x30
  800ff5:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 22                	js     80101d <fork_v0+0x3c>
  800ffb:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801002:	75 52                	jne    801056 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801004:	e8 8e fb ff ff       	call   800b97 <sys_getenvid>
  801009:	25 ff 03 00 00       	and    $0x3ff,%eax
  80100e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801011:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801016:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80101b:	eb 6e                	jmp    80108b <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80101d:	50                   	push   %eax
  80101e:	68 78 28 80 00       	push   $0x802878
  801023:	68 8a 00 00 00       	push   $0x8a
  801028:	68 85 27 80 00       	push   $0x802785
  80102d:	e8 4c 0f 00 00       	call   801f7e <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801032:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801039:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80103f:	89 da                	mov    %ebx,%edx
  801041:	89 f0                	mov    %esi,%eax
  801043:	e8 b9 fd ff ff       	call   800e01 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801048:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80104e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801054:	74 23                	je     801079 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801056:	89 d8                	mov    %ebx,%eax
  801058:	c1 e8 16             	shr    $0x16,%eax
  80105b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801062:	a8 01                	test   $0x1,%al
  801064:	74 e2                	je     801048 <fork_v0+0x67>
  801066:	89 d8                	mov    %ebx,%eax
  801068:	c1 e8 0c             	shr    $0xc,%eax
  80106b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801072:	f6 c2 01             	test   $0x1,%dl
  801075:	74 d1                	je     801048 <fork_v0+0x67>
  801077:	eb b9                	jmp    801032 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	6a 02                	push   $0x2
  80107e:	57                   	push   %edi
  80107f:	e8 df fb ff ff       	call   800c63 <sys_env_set_status>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 0a                	js     801095 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  80108b:	89 f8                	mov    %edi,%eax
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  801095:	50                   	push   %eax
  801096:	68 9c 28 80 00       	push   $0x80289c
  80109b:	68 98 00 00 00       	push   $0x98
  8010a0:	68 85 27 80 00       	push   $0x802785
  8010a5:	e8 d4 0e 00 00       	call   801f7e <_panic>

008010aa <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010aa:	f3 0f 1e fb          	endbr32 
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
  8010b4:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8010b7:	68 ce 0e 80 00       	push   $0x800ece
  8010bc:	e8 07 0f 00 00       	call   801fc8 <set_pgfault_handler>
  8010c1:	b8 07 00 00 00       	mov    $0x7,%eax
  8010c6:	cd 30                	int    $0x30
  8010c8:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	78 37                	js     801108 <fork+0x5e>
  8010d1:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8010d3:	74 48                	je     80111d <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	6a 07                	push   $0x7
  8010da:	68 00 f0 bf ee       	push   $0xeebff000
  8010df:	50                   	push   %eax
  8010e0:	e8 05 fb ff ff       	call   800bea <sys_page_alloc>
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	78 4d                	js     801139 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	68 45 20 80 00       	push   $0x802045
  8010f4:	56                   	push   %esi
  8010f5:	e8 b7 fb ff ff       	call   800cb1 <sys_env_set_pgfault_upcall>
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 4d                	js     80114e <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801101:	bb 00 00 00 00       	mov    $0x0,%ebx
  801106:	eb 70                	jmp    801178 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801108:	50                   	push   %eax
  801109:	68 e0 27 80 00       	push   $0x8027e0
  80110e:	68 b7 00 00 00       	push   $0xb7
  801113:	68 85 27 80 00       	push   $0x802785
  801118:	e8 61 0e 00 00       	call   801f7e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80111d:	e8 75 fa ff ff       	call   800b97 <sys_getenvid>
  801122:	25 ff 03 00 00       	and    $0x3ff,%eax
  801127:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80112a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80112f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801134:	e9 80 00 00 00       	jmp    8011b9 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801139:	50                   	push   %eax
  80113a:	68 f0 27 80 00       	push   $0x8027f0
  80113f:	68 c0 00 00 00       	push   $0xc0
  801144:	68 85 27 80 00       	push   $0x802785
  801149:	e8 30 0e 00 00       	call   801f7e <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80114e:	50                   	push   %eax
  80114f:	68 c0 28 80 00       	push   $0x8028c0
  801154:	68 c3 00 00 00       	push   $0xc3
  801159:	68 85 27 80 00       	push   $0x802785
  80115e:	e8 1b 0e 00 00       	call   801f7e <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801163:	89 f8                	mov    %edi,%eax
  801165:	e8 bd fb ff ff       	call   800d27 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80116a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801170:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801176:	74 2f                	je     8011a7 <fork+0xfd>
  801178:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  80117a:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801180:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  801185:	76 e3                	jbe    80116a <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801187:	89 d8                	mov    %ebx,%eax
  801189:	c1 e8 16             	shr    $0x16,%eax
  80118c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801193:	a8 01                	test   $0x1,%al
  801195:	74 d3                	je     80116a <fork+0xc0>
  801197:	c1 ea 0c             	shr    $0xc,%edx
  80119a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011a1:	a8 01                	test   $0x1,%al
  8011a3:	74 c5                	je     80116a <fork+0xc0>
  8011a5:	eb bc                	jmp    801163 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011a7:	83 ec 08             	sub    $0x8,%esp
  8011aa:	6a 02                	push   $0x2
  8011ac:	56                   	push   %esi
  8011ad:	e8 b1 fa ff ff       	call   800c63 <sys_env_set_status>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 0a                	js     8011c3 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8011b9:	89 f0                	mov    %esi,%eax
  8011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5f                   	pop    %edi
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8011c3:	50                   	push   %eax
  8011c4:	68 ec 28 80 00       	push   $0x8028ec
  8011c9:	68 ce 00 00 00       	push   $0xce
  8011ce:	68 85 27 80 00       	push   $0x802785
  8011d3:	e8 a6 0d 00 00       	call   801f7e <_panic>

008011d8 <sfork>:

// Challenge!
int
sfork(void)
{
  8011d8:	f3 0f 1e fb          	endbr32 
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011e2:	68 0e 28 80 00       	push   $0x80280e
  8011e7:	68 d7 00 00 00       	push   $0xd7
  8011ec:	68 85 27 80 00       	push   $0x802785
  8011f1:	e8 88 0d 00 00       	call   801f7e <_panic>

008011f6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f6:	f3 0f 1e fb          	endbr32 
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	05 00 00 00 30       	add    $0x30000000,%eax
  801205:	c1 e8 0c             	shr    $0xc,%eax
}
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80120a:	f3 0f 1e fb          	endbr32 
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	e8 da ff ff ff       	call   8011f6 <fd2num>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	c1 e0 0c             	shl    $0xc,%eax
  801222:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801229:	f3 0f 1e fb          	endbr32 
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801235:	89 c2                	mov    %eax,%edx
  801237:	c1 ea 16             	shr    $0x16,%edx
  80123a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801241:	f6 c2 01             	test   $0x1,%dl
  801244:	74 2d                	je     801273 <fd_alloc+0x4a>
  801246:	89 c2                	mov    %eax,%edx
  801248:	c1 ea 0c             	shr    $0xc,%edx
  80124b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801252:	f6 c2 01             	test   $0x1,%dl
  801255:	74 1c                	je     801273 <fd_alloc+0x4a>
  801257:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80125c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801261:	75 d2                	jne    801235 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80126c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801271:	eb 0a                	jmp    80127d <fd_alloc+0x54>
			*fd_store = fd;
  801273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801276:	89 01                	mov    %eax,(%ecx)
			return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80127f:	f3 0f 1e fb          	endbr32 
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801289:	83 f8 1f             	cmp    $0x1f,%eax
  80128c:	77 30                	ja     8012be <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80128e:	c1 e0 0c             	shl    $0xc,%eax
  801291:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801296:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80129c:	f6 c2 01             	test   $0x1,%dl
  80129f:	74 24                	je     8012c5 <fd_lookup+0x46>
  8012a1:	89 c2                	mov    %eax,%edx
  8012a3:	c1 ea 0c             	shr    $0xc,%edx
  8012a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ad:	f6 c2 01             	test   $0x1,%dl
  8012b0:	74 1a                	je     8012cc <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b5:	89 02                	mov    %eax,(%edx)
	return 0;
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    
		return -E_INVAL;
  8012be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c3:	eb f7                	jmp    8012bc <fd_lookup+0x3d>
		return -E_INVAL;
  8012c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ca:	eb f0                	jmp    8012bc <fd_lookup+0x3d>
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb e9                	jmp    8012bc <fd_lookup+0x3d>

008012d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e0:	ba 8c 29 80 00       	mov    $0x80298c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012e5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012ea:	39 08                	cmp    %ecx,(%eax)
  8012ec:	74 33                	je     801321 <dev_lookup+0x4e>
  8012ee:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012f1:	8b 02                	mov    (%edx),%eax
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	75 f3                	jne    8012ea <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012f7:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fc:	8b 40 48             	mov    0x48(%eax),%eax
  8012ff:	83 ec 04             	sub    $0x4,%esp
  801302:	51                   	push   %ecx
  801303:	50                   	push   %eax
  801304:	68 10 29 80 00       	push   $0x802910
  801309:	e8 ea ee ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    
			*dev = devtab[i];
  801321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801324:	89 01                	mov    %eax,(%ecx)
			return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	eb f2                	jmp    80131f <dev_lookup+0x4c>

0080132d <fd_close>:
{
  80132d:	f3 0f 1e fb          	endbr32 
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	57                   	push   %edi
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	83 ec 28             	sub    $0x28,%esp
  80133a:	8b 75 08             	mov    0x8(%ebp),%esi
  80133d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801340:	56                   	push   %esi
  801341:	e8 b0 fe ff ff       	call   8011f6 <fd2num>
  801346:	83 c4 08             	add    $0x8,%esp
  801349:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80134c:	52                   	push   %edx
  80134d:	50                   	push   %eax
  80134e:	e8 2c ff ff ff       	call   80127f <fd_lookup>
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 05                	js     801361 <fd_close+0x34>
	    || fd != fd2)
  80135c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80135f:	74 16                	je     801377 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801361:	89 f8                	mov    %edi,%eax
  801363:	84 c0                	test   %al,%al
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	0f 44 d8             	cmove  %eax,%ebx
}
  80136d:	89 d8                	mov    %ebx,%eax
  80136f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801377:	83 ec 08             	sub    $0x8,%esp
  80137a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80137d:	50                   	push   %eax
  80137e:	ff 36                	pushl  (%esi)
  801380:	e8 4e ff ff ff       	call   8012d3 <dev_lookup>
  801385:	89 c3                	mov    %eax,%ebx
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 1a                	js     8013a8 <fd_close+0x7b>
		if (dev->dev_close)
  80138e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801391:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801394:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801399:	85 c0                	test   %eax,%eax
  80139b:	74 0b                	je     8013a8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	56                   	push   %esi
  8013a1:	ff d0                	call   *%eax
  8013a3:	89 c3                	mov    %eax,%ebx
  8013a5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	56                   	push   %esi
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 89 f8 ff ff       	call   800c3c <sys_page_unmap>
	return r;
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	eb b5                	jmp    80136d <fd_close+0x40>

008013b8 <close>:

int
close(int fdnum)
{
  8013b8:	f3 0f 1e fb          	endbr32 
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	ff 75 08             	pushl  0x8(%ebp)
  8013c9:	e8 b1 fe ff ff       	call   80127f <fd_lookup>
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	79 02                	jns    8013d7 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    
		return fd_close(fd, 1);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	6a 01                	push   $0x1
  8013dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8013df:	e8 49 ff ff ff       	call   80132d <fd_close>
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	eb ec                	jmp    8013d5 <close+0x1d>

008013e9 <close_all>:

void
close_all(void)
{
  8013e9:	f3 0f 1e fb          	endbr32 
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	53                   	push   %ebx
  8013fd:	e8 b6 ff ff ff       	call   8013b8 <close>
	for (i = 0; i < MAXFD; i++)
  801402:	83 c3 01             	add    $0x1,%ebx
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	83 fb 20             	cmp    $0x20,%ebx
  80140b:	75 ec                	jne    8013f9 <close_all+0x10>
}
  80140d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801412:	f3 0f 1e fb          	endbr32 
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	57                   	push   %edi
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80141f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	ff 75 08             	pushl  0x8(%ebp)
  801426:	e8 54 fe ff ff       	call   80127f <fd_lookup>
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	0f 88 81 00 00 00    	js     8014b9 <dup+0xa7>
		return r;
	close(newfdnum);
  801438:	83 ec 0c             	sub    $0xc,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	e8 75 ff ff ff       	call   8013b8 <close>

	newfd = INDEX2FD(newfdnum);
  801443:	8b 75 0c             	mov    0xc(%ebp),%esi
  801446:	c1 e6 0c             	shl    $0xc,%esi
  801449:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80144f:	83 c4 04             	add    $0x4,%esp
  801452:	ff 75 e4             	pushl  -0x1c(%ebp)
  801455:	e8 b0 fd ff ff       	call   80120a <fd2data>
  80145a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80145c:	89 34 24             	mov    %esi,(%esp)
  80145f:	e8 a6 fd ff ff       	call   80120a <fd2data>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801469:	89 d8                	mov    %ebx,%eax
  80146b:	c1 e8 16             	shr    $0x16,%eax
  80146e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801475:	a8 01                	test   $0x1,%al
  801477:	74 11                	je     80148a <dup+0x78>
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	c1 e8 0c             	shr    $0xc,%eax
  80147e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801485:	f6 c2 01             	test   $0x1,%dl
  801488:	75 39                	jne    8014c3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148d:	89 d0                	mov    %edx,%eax
  80148f:	c1 e8 0c             	shr    $0xc,%eax
  801492:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a1:	50                   	push   %eax
  8014a2:	56                   	push   %esi
  8014a3:	6a 00                	push   $0x0
  8014a5:	52                   	push   %edx
  8014a6:	6a 00                	push   $0x0
  8014a8:	e8 65 f7 ff ff       	call   800c12 <sys_page_map>
  8014ad:	89 c3                	mov    %eax,%ebx
  8014af:	83 c4 20             	add    $0x20,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 31                	js     8014e7 <dup+0xd5>
		goto err;

	return newfdnum;
  8014b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d2:	50                   	push   %eax
  8014d3:	57                   	push   %edi
  8014d4:	6a 00                	push   $0x0
  8014d6:	53                   	push   %ebx
  8014d7:	6a 00                	push   $0x0
  8014d9:	e8 34 f7 ff ff       	call   800c12 <sys_page_map>
  8014de:	89 c3                	mov    %eax,%ebx
  8014e0:	83 c4 20             	add    $0x20,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	79 a3                	jns    80148a <dup+0x78>
	sys_page_unmap(0, newfd);
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	56                   	push   %esi
  8014eb:	6a 00                	push   $0x0
  8014ed:	e8 4a f7 ff ff       	call   800c3c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f2:	83 c4 08             	add    $0x8,%esp
  8014f5:	57                   	push   %edi
  8014f6:	6a 00                	push   $0x0
  8014f8:	e8 3f f7 ff ff       	call   800c3c <sys_page_unmap>
	return r;
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	eb b7                	jmp    8014b9 <dup+0xa7>

00801502 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801502:	f3 0f 1e fb          	endbr32 
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 1c             	sub    $0x1c,%esp
  80150d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801510:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801513:	50                   	push   %eax
  801514:	53                   	push   %ebx
  801515:	e8 65 fd ff ff       	call   80127f <fd_lookup>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 3f                	js     801560 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152b:	ff 30                	pushl  (%eax)
  80152d:	e8 a1 fd ff ff       	call   8012d3 <dev_lookup>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 27                	js     801560 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801539:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153c:	8b 42 08             	mov    0x8(%edx),%eax
  80153f:	83 e0 03             	and    $0x3,%eax
  801542:	83 f8 01             	cmp    $0x1,%eax
  801545:	74 1e                	je     801565 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154a:	8b 40 08             	mov    0x8(%eax),%eax
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 35                	je     801586 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	ff 75 10             	pushl  0x10(%ebp)
  801557:	ff 75 0c             	pushl  0xc(%ebp)
  80155a:	52                   	push   %edx
  80155b:	ff d0                	call   *%eax
  80155d:	83 c4 10             	add    $0x10,%esp
}
  801560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801563:	c9                   	leave  
  801564:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801565:	a1 04 40 80 00       	mov    0x804004,%eax
  80156a:	8b 40 48             	mov    0x48(%eax),%eax
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	53                   	push   %ebx
  801571:	50                   	push   %eax
  801572:	68 51 29 80 00       	push   $0x802951
  801577:	e8 7c ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801584:	eb da                	jmp    801560 <read+0x5e>
		return -E_NOT_SUPP;
  801586:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158b:	eb d3                	jmp    801560 <read+0x5e>

0080158d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80158d:	f3 0f 1e fb          	endbr32 
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	57                   	push   %edi
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
  801597:	83 ec 0c             	sub    $0xc,%esp
  80159a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80159d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a5:	eb 02                	jmp    8015a9 <readn+0x1c>
  8015a7:	01 c3                	add    %eax,%ebx
  8015a9:	39 f3                	cmp    %esi,%ebx
  8015ab:	73 21                	jae    8015ce <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	89 f0                	mov    %esi,%eax
  8015b2:	29 d8                	sub    %ebx,%eax
  8015b4:	50                   	push   %eax
  8015b5:	89 d8                	mov    %ebx,%eax
  8015b7:	03 45 0c             	add    0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	57                   	push   %edi
  8015bc:	e8 41 ff ff ff       	call   801502 <read>
		if (m < 0)
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 04                	js     8015cc <readn+0x3f>
			return m;
		if (m == 0)
  8015c8:	75 dd                	jne    8015a7 <readn+0x1a>
  8015ca:	eb 02                	jmp    8015ce <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015cc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015ce:	89 d8                	mov    %ebx,%eax
  8015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015d8:	f3 0f 1e fb          	endbr32 
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 1c             	sub    $0x1c,%esp
  8015e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e9:	50                   	push   %eax
  8015ea:	53                   	push   %ebx
  8015eb:	e8 8f fc ff ff       	call   80127f <fd_lookup>
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 3a                	js     801631 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fd:	50                   	push   %eax
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	ff 30                	pushl  (%eax)
  801603:	e8 cb fc ff ff       	call   8012d3 <dev_lookup>
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 22                	js     801631 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801616:	74 1e                	je     801636 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	8b 52 0c             	mov    0xc(%edx),%edx
  80161e:	85 d2                	test   %edx,%edx
  801620:	74 35                	je     801657 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	ff 75 10             	pushl  0x10(%ebp)
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	50                   	push   %eax
  80162c:	ff d2                	call   *%edx
  80162e:	83 c4 10             	add    $0x10,%esp
}
  801631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801634:	c9                   	leave  
  801635:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801636:	a1 04 40 80 00       	mov    0x804004,%eax
  80163b:	8b 40 48             	mov    0x48(%eax),%eax
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	53                   	push   %ebx
  801642:	50                   	push   %eax
  801643:	68 6d 29 80 00       	push   $0x80296d
  801648:	e8 ab eb ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801655:	eb da                	jmp    801631 <write+0x59>
		return -E_NOT_SUPP;
  801657:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165c:	eb d3                	jmp    801631 <write+0x59>

0080165e <seek>:

int
seek(int fdnum, off_t offset)
{
  80165e:	f3 0f 1e fb          	endbr32 
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 0b fc ff ff       	call   80127f <fd_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 0e                	js     801689 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801681:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80168b:	f3 0f 1e fb          	endbr32 
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	53                   	push   %ebx
  801693:	83 ec 1c             	sub    $0x1c,%esp
  801696:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801699:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169c:	50                   	push   %eax
  80169d:	53                   	push   %ebx
  80169e:	e8 dc fb ff ff       	call   80127f <fd_lookup>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 37                	js     8016e1 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b0:	50                   	push   %eax
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	ff 30                	pushl  (%eax)
  8016b6:	e8 18 fc ff ff       	call   8012d3 <dev_lookup>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 1f                	js     8016e1 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c9:	74 1b                	je     8016e6 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	8b 52 18             	mov    0x18(%edx),%edx
  8016d1:	85 d2                	test   %edx,%edx
  8016d3:	74 32                	je     801707 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	50                   	push   %eax
  8016dc:	ff d2                	call   *%edx
  8016de:	83 c4 10             	add    $0x10,%esp
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016e6:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016eb:	8b 40 48             	mov    0x48(%eax),%eax
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	53                   	push   %ebx
  8016f2:	50                   	push   %eax
  8016f3:	68 30 29 80 00       	push   $0x802930
  8016f8:	e8 fb ea ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801705:	eb da                	jmp    8016e1 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801707:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170c:	eb d3                	jmp    8016e1 <ftruncate+0x56>

0080170e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 1c             	sub    $0x1c,%esp
  801719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 57 fb ff ff       	call   80127f <fd_lookup>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 4b                	js     80177a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	ff 30                	pushl  (%eax)
  80173b:	e8 93 fb ff ff       	call   8012d3 <dev_lookup>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 33                	js     80177a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80174e:	74 2f                	je     80177f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801750:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801753:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175a:	00 00 00 
	stat->st_isdir = 0;
  80175d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801764:	00 00 00 
	stat->st_dev = dev;
  801767:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	53                   	push   %ebx
  801771:	ff 75 f0             	pushl  -0x10(%ebp)
  801774:	ff 50 14             	call   *0x14(%eax)
  801777:	83 c4 10             	add    $0x10,%esp
}
  80177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    
		return -E_NOT_SUPP;
  80177f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801784:	eb f4                	jmp    80177a <fstat+0x6c>

00801786 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801786:	f3 0f 1e fb          	endbr32 
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	6a 00                	push   $0x0
  801794:	ff 75 08             	pushl  0x8(%ebp)
  801797:	e8 3a 02 00 00       	call   8019d6 <open>
  80179c:	89 c3                	mov    %eax,%ebx
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 1b                	js     8017c0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	50                   	push   %eax
  8017ac:	e8 5d ff ff ff       	call   80170e <fstat>
  8017b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b3:	89 1c 24             	mov    %ebx,(%esp)
  8017b6:	e8 fd fb ff ff       	call   8013b8 <close>
	return r;
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 f3                	mov    %esi,%ebx
}
  8017c0:	89 d8                	mov    %ebx,%eax
  8017c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c5:	5b                   	pop    %ebx
  8017c6:	5e                   	pop    %esi
  8017c7:	5d                   	pop    %ebp
  8017c8:	c3                   	ret    

008017c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	89 c6                	mov    %eax,%esi
  8017d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017d9:	74 27                	je     801802 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017db:	6a 07                	push   $0x7
  8017dd:	68 00 50 80 00       	push   $0x805000
  8017e2:	56                   	push   %esi
  8017e3:	ff 35 00 40 80 00    	pushl  0x804000
  8017e9:	e8 ea 08 00 00       	call   8020d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ee:	83 c4 0c             	add    $0xc,%esp
  8017f1:	6a 00                	push   $0x0
  8017f3:	53                   	push   %ebx
  8017f4:	6a 00                	push   $0x0
  8017f6:	e8 70 08 00 00       	call   80206b <ipc_recv>
}
  8017fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	6a 01                	push   $0x1
  801807:	e8 24 09 00 00       	call   802130 <ipc_find_env>
  80180c:	a3 00 40 80 00       	mov    %eax,0x804000
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	eb c5                	jmp    8017db <fsipc+0x12>

00801816 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801816:	f3 0f 1e fb          	endbr32 
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 40 0c             	mov    0xc(%eax),%eax
  801826:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	b8 02 00 00 00       	mov    $0x2,%eax
  80183d:	e8 87 ff ff ff       	call   8017c9 <fsipc>
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <devfile_flush>:
{
  801844:	f3 0f 1e fb          	endbr32 
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8b 40 0c             	mov    0xc(%eax),%eax
  801854:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801859:	ba 00 00 00 00       	mov    $0x0,%edx
  80185e:	b8 06 00 00 00       	mov    $0x6,%eax
  801863:	e8 61 ff ff ff       	call   8017c9 <fsipc>
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <devfile_stat>:
{
  80186a:	f3 0f 1e fb          	endbr32 
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8b 40 0c             	mov    0xc(%eax),%eax
  80187e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801883:	ba 00 00 00 00       	mov    $0x0,%edx
  801888:	b8 05 00 00 00       	mov    $0x5,%eax
  80188d:	e8 37 ff ff ff       	call   8017c9 <fsipc>
  801892:	85 c0                	test   %eax,%eax
  801894:	78 2c                	js     8018c2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801896:	83 ec 08             	sub    $0x8,%esp
  801899:	68 00 50 80 00       	push   $0x805000
  80189e:	53                   	push   %ebx
  80189f:	e8 be ee ff ff       	call   800762 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a4:	a1 80 50 80 00       	mov    0x805080,%eax
  8018a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018af:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <devfile_write>:
{
  8018c7:	f3 0f 1e fb          	endbr32 
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018e0:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018e6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8018ec:	77 30                	ja     80191e <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	53                   	push   %ebx
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	68 08 50 80 00       	push   $0x805008
  8018fa:	e8 1b f0 ff ff       	call   80091a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801904:	b8 04 00 00 00       	mov    $0x4,%eax
  801909:	e8 bb fe ff ff       	call   8017c9 <fsipc>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 04                	js     801919 <devfile_write+0x52>
	assert(r <= n);
  801915:	39 d8                	cmp    %ebx,%eax
  801917:	77 1e                	ja     801937 <devfile_write+0x70>
}
  801919:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80191e:	68 9c 29 80 00       	push   $0x80299c
  801923:	68 c9 29 80 00       	push   $0x8029c9
  801928:	68 94 00 00 00       	push   $0x94
  80192d:	68 de 29 80 00       	push   $0x8029de
  801932:	e8 47 06 00 00       	call   801f7e <_panic>
	assert(r <= n);
  801937:	68 e9 29 80 00       	push   $0x8029e9
  80193c:	68 c9 29 80 00       	push   $0x8029c9
  801941:	68 98 00 00 00       	push   $0x98
  801946:	68 de 29 80 00       	push   $0x8029de
  80194b:	e8 2e 06 00 00       	call   801f7e <_panic>

00801950 <devfile_read>:
{
  801950:	f3 0f 1e fb          	endbr32 
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	56                   	push   %esi
  801958:	53                   	push   %ebx
  801959:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8b 40 0c             	mov    0xc(%eax),%eax
  801962:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801967:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80196d:	ba 00 00 00 00       	mov    $0x0,%edx
  801972:	b8 03 00 00 00       	mov    $0x3,%eax
  801977:	e8 4d fe ff ff       	call   8017c9 <fsipc>
  80197c:	89 c3                	mov    %eax,%ebx
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 1f                	js     8019a1 <devfile_read+0x51>
	assert(r <= n);
  801982:	39 f0                	cmp    %esi,%eax
  801984:	77 24                	ja     8019aa <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801986:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80198b:	7f 33                	jg     8019c0 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	50                   	push   %eax
  801991:	68 00 50 80 00       	push   $0x805000
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	e8 7c ef ff ff       	call   80091a <memmove>
	return r;
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
	assert(r <= n);
  8019aa:	68 e9 29 80 00       	push   $0x8029e9
  8019af:	68 c9 29 80 00       	push   $0x8029c9
  8019b4:	6a 7c                	push   $0x7c
  8019b6:	68 de 29 80 00       	push   $0x8029de
  8019bb:	e8 be 05 00 00       	call   801f7e <_panic>
	assert(r <= PGSIZE);
  8019c0:	68 f0 29 80 00       	push   $0x8029f0
  8019c5:	68 c9 29 80 00       	push   $0x8029c9
  8019ca:	6a 7d                	push   $0x7d
  8019cc:	68 de 29 80 00       	push   $0x8029de
  8019d1:	e8 a8 05 00 00       	call   801f7e <_panic>

008019d6 <open>:
{
  8019d6:	f3 0f 1e fb          	endbr32 
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	83 ec 1c             	sub    $0x1c,%esp
  8019e2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019e5:	56                   	push   %esi
  8019e6:	e8 34 ed ff ff       	call   80071f <strlen>
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019f3:	7f 6c                	jg     801a61 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fb:	50                   	push   %eax
  8019fc:	e8 28 f8 ff ff       	call   801229 <fd_alloc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 3c                	js     801a46 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	56                   	push   %esi
  801a0e:	68 00 50 80 00       	push   $0x805000
  801a13:	e8 4a ed ff ff       	call   800762 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a23:	b8 01 00 00 00       	mov    $0x1,%eax
  801a28:	e8 9c fd ff ff       	call   8017c9 <fsipc>
  801a2d:	89 c3                	mov    %eax,%ebx
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 19                	js     801a4f <open+0x79>
	return fd2num(fd);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3c:	e8 b5 f7 ff ff       	call   8011f6 <fd2num>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	89 d8                	mov    %ebx,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
		fd_close(fd, 0);
  801a4f:	83 ec 08             	sub    $0x8,%esp
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 f4             	pushl  -0xc(%ebp)
  801a57:	e8 d1 f8 ff ff       	call   80132d <fd_close>
		return r;
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	eb e5                	jmp    801a46 <open+0x70>
		return -E_BAD_PATH;
  801a61:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a66:	eb de                	jmp    801a46 <open+0x70>

00801a68 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a68:	f3 0f 1e fb          	endbr32 
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	b8 08 00 00 00       	mov    $0x8,%eax
  801a7c:	e8 48 fd ff ff       	call   8017c9 <fsipc>
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a83:	f3 0f 1e fb          	endbr32 
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	e8 70 f7 ff ff       	call   80120a <fd2data>
  801a9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a9c:	83 c4 08             	add    $0x8,%esp
  801a9f:	68 fc 29 80 00       	push   $0x8029fc
  801aa4:	53                   	push   %ebx
  801aa5:	e8 b8 ec ff ff       	call   800762 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aaa:	8b 46 04             	mov    0x4(%esi),%eax
  801aad:	2b 06                	sub    (%esi),%eax
  801aaf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ab5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abc:	00 00 00 
	stat->st_dev = &devpipe;
  801abf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ac6:	30 80 00 
	return 0;
}
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ae3:	53                   	push   %ebx
  801ae4:	6a 00                	push   $0x0
  801ae6:	e8 51 f1 ff ff       	call   800c3c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801aeb:	89 1c 24             	mov    %ebx,(%esp)
  801aee:	e8 17 f7 ff ff       	call   80120a <fd2data>
  801af3:	83 c4 08             	add    $0x8,%esp
  801af6:	50                   	push   %eax
  801af7:	6a 00                	push   $0x0
  801af9:	e8 3e f1 ff ff       	call   800c3c <sys_page_unmap>
}
  801afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <_pipeisclosed>:
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	57                   	push   %edi
  801b07:	56                   	push   %esi
  801b08:	53                   	push   %ebx
  801b09:	83 ec 1c             	sub    $0x1c,%esp
  801b0c:	89 c7                	mov    %eax,%edi
  801b0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b10:	a1 04 40 80 00       	mov    0x804004,%eax
  801b15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	57                   	push   %edi
  801b1c:	e8 4c 06 00 00       	call   80216d <pageref>
  801b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b24:	89 34 24             	mov    %esi,(%esp)
  801b27:	e8 41 06 00 00       	call   80216d <pageref>
		nn = thisenv->env_runs;
  801b2c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	39 cb                	cmp    %ecx,%ebx
  801b3a:	74 1b                	je     801b57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b3f:	75 cf                	jne    801b10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b41:	8b 42 58             	mov    0x58(%edx),%eax
  801b44:	6a 01                	push   $0x1
  801b46:	50                   	push   %eax
  801b47:	53                   	push   %ebx
  801b48:	68 03 2a 80 00       	push   $0x802a03
  801b4d:	e8 a6 e6 ff ff       	call   8001f8 <cprintf>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	eb b9                	jmp    801b10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b5a:	0f 94 c0             	sete   %al
  801b5d:	0f b6 c0             	movzbl %al,%eax
}
  801b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    

00801b68 <devpipe_write>:
{
  801b68:	f3 0f 1e fb          	endbr32 
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	57                   	push   %edi
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	83 ec 28             	sub    $0x28,%esp
  801b75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b78:	56                   	push   %esi
  801b79:	e8 8c f6 ff ff       	call   80120a <fd2data>
  801b7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	bf 00 00 00 00       	mov    $0x0,%edi
  801b88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b8b:	74 4f                	je     801bdc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801b90:	8b 0b                	mov    (%ebx),%ecx
  801b92:	8d 51 20             	lea    0x20(%ecx),%edx
  801b95:	39 d0                	cmp    %edx,%eax
  801b97:	72 14                	jb     801bad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801b99:	89 da                	mov    %ebx,%edx
  801b9b:	89 f0                	mov    %esi,%eax
  801b9d:	e8 61 ff ff ff       	call   801b03 <_pipeisclosed>
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	75 3b                	jne    801be1 <devpipe_write+0x79>
			sys_yield();
  801ba6:	e8 14 f0 ff ff       	call   800bbf <sys_yield>
  801bab:	eb e0                	jmp    801b8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bb4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bb7:	89 c2                	mov    %eax,%edx
  801bb9:	c1 fa 1f             	sar    $0x1f,%edx
  801bbc:	89 d1                	mov    %edx,%ecx
  801bbe:	c1 e9 1b             	shr    $0x1b,%ecx
  801bc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bc4:	83 e2 1f             	and    $0x1f,%edx
  801bc7:	29 ca                	sub    %ecx,%edx
  801bc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bcd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bd1:	83 c0 01             	add    $0x1,%eax
  801bd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bd7:	83 c7 01             	add    $0x1,%edi
  801bda:	eb ac                	jmp    801b88 <devpipe_write+0x20>
	return i;
  801bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdf:	eb 05                	jmp    801be6 <devpipe_write+0x7e>
				return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <devpipe_read>:
{
  801bee:	f3 0f 1e fb          	endbr32 
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 18             	sub    $0x18,%esp
  801bfb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bfe:	57                   	push   %edi
  801bff:	e8 06 f6 ff ff       	call   80120a <fd2data>
  801c04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	be 00 00 00 00       	mov    $0x0,%esi
  801c0e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c11:	75 14                	jne    801c27 <devpipe_read+0x39>
	return i;
  801c13:	8b 45 10             	mov    0x10(%ebp),%eax
  801c16:	eb 02                	jmp    801c1a <devpipe_read+0x2c>
				return i;
  801c18:	89 f0                	mov    %esi,%eax
}
  801c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
			sys_yield();
  801c22:	e8 98 ef ff ff       	call   800bbf <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c27:	8b 03                	mov    (%ebx),%eax
  801c29:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c2c:	75 18                	jne    801c46 <devpipe_read+0x58>
			if (i > 0)
  801c2e:	85 f6                	test   %esi,%esi
  801c30:	75 e6                	jne    801c18 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c32:	89 da                	mov    %ebx,%edx
  801c34:	89 f8                	mov    %edi,%eax
  801c36:	e8 c8 fe ff ff       	call   801b03 <_pipeisclosed>
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 e3                	je     801c22 <devpipe_read+0x34>
				return 0;
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c44:	eb d4                	jmp    801c1a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c46:	99                   	cltd   
  801c47:	c1 ea 1b             	shr    $0x1b,%edx
  801c4a:	01 d0                	add    %edx,%eax
  801c4c:	83 e0 1f             	and    $0x1f,%eax
  801c4f:	29 d0                	sub    %edx,%eax
  801c51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c5f:	83 c6 01             	add    $0x1,%esi
  801c62:	eb aa                	jmp    801c0e <devpipe_read+0x20>

00801c64 <pipe>:
{
  801c64:	f3 0f 1e fb          	endbr32 
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	56                   	push   %esi
  801c6c:	53                   	push   %ebx
  801c6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c73:	50                   	push   %eax
  801c74:	e8 b0 f5 ff ff       	call   801229 <fd_alloc>
  801c79:	89 c3                	mov    %eax,%ebx
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	0f 88 23 01 00 00    	js     801da9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	68 07 04 00 00       	push   $0x407
  801c8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c91:	6a 00                	push   $0x0
  801c93:	e8 52 ef ff ff       	call   800bea <sys_page_alloc>
  801c98:	89 c3                	mov    %eax,%ebx
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	0f 88 04 01 00 00    	js     801da9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cab:	50                   	push   %eax
  801cac:	e8 78 f5 ff ff       	call   801229 <fd_alloc>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	0f 88 db 00 00 00    	js     801d99 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	68 07 04 00 00       	push   $0x407
  801cc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc9:	6a 00                	push   $0x0
  801ccb:	e8 1a ef ff ff       	call   800bea <sys_page_alloc>
  801cd0:	89 c3                	mov    %eax,%ebx
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	0f 88 bc 00 00 00    	js     801d99 <pipe+0x135>
	va = fd2data(fd0);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce3:	e8 22 f5 ff ff       	call   80120a <fd2data>
  801ce8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cea:	83 c4 0c             	add    $0xc,%esp
  801ced:	68 07 04 00 00       	push   $0x407
  801cf2:	50                   	push   %eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	e8 f0 ee ff ff       	call   800bea <sys_page_alloc>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	85 c0                	test   %eax,%eax
  801d01:	0f 88 82 00 00 00    	js     801d89 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d0d:	e8 f8 f4 ff ff       	call   80120a <fd2data>
  801d12:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d19:	50                   	push   %eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	56                   	push   %esi
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 ee ee ff ff       	call   800c12 <sys_page_map>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 20             	add    $0x20,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 4e                	js     801d7b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d2d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d35:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d44:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	ff 75 f4             	pushl  -0xc(%ebp)
  801d56:	e8 9b f4 ff ff       	call   8011f6 <fd2num>
  801d5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d60:	83 c4 04             	add    $0x4,%esp
  801d63:	ff 75 f0             	pushl  -0x10(%ebp)
  801d66:	e8 8b f4 ff ff       	call   8011f6 <fd2num>
  801d6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d79:	eb 2e                	jmp    801da9 <pipe+0x145>
	sys_page_unmap(0, va);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	56                   	push   %esi
  801d7f:	6a 00                	push   $0x0
  801d81:	e8 b6 ee ff ff       	call   800c3c <sys_page_unmap>
  801d86:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8f:	6a 00                	push   $0x0
  801d91:	e8 a6 ee ff ff       	call   800c3c <sys_page_unmap>
  801d96:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9f:	6a 00                	push   $0x0
  801da1:	e8 96 ee ff ff       	call   800c3c <sys_page_unmap>
  801da6:	83 c4 10             	add    $0x10,%esp
}
  801da9:	89 d8                	mov    %ebx,%eax
  801dab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <pipeisclosed>:
{
  801db2:	f3 0f 1e fb          	endbr32 
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbf:	50                   	push   %eax
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	e8 b7 f4 ff ff       	call   80127f <fd_lookup>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 18                	js     801de7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd5:	e8 30 f4 ff ff       	call   80120a <fd2data>
  801dda:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	e8 1f fd ff ff       	call   801b03 <_pipeisclosed>
  801de4:	83 c4 10             	add    $0x10,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801de9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	c3                   	ret    

00801df3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801df3:	f3 0f 1e fb          	endbr32 
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dfd:	68 1b 2a 80 00       	push   $0x802a1b
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	e8 58 e9 ff ff       	call   800762 <strcpy>
	return 0;
}
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <devcons_write>:
{
  801e11:	f3 0f 1e fb          	endbr32 
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	57                   	push   %edi
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e21:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e2c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e2f:	73 31                	jae    801e62 <devcons_write+0x51>
		m = n - tot;
  801e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e34:	29 f3                	sub    %esi,%ebx
  801e36:	83 fb 7f             	cmp    $0x7f,%ebx
  801e39:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e3e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	53                   	push   %ebx
  801e45:	89 f0                	mov    %esi,%eax
  801e47:	03 45 0c             	add    0xc(%ebp),%eax
  801e4a:	50                   	push   %eax
  801e4b:	57                   	push   %edi
  801e4c:	e8 c9 ea ff ff       	call   80091a <memmove>
		sys_cputs(buf, m);
  801e51:	83 c4 08             	add    $0x8,%esp
  801e54:	53                   	push   %ebx
  801e55:	57                   	push   %edi
  801e56:	e8 c4 ec ff ff       	call   800b1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e5b:	01 de                	add    %ebx,%esi
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	eb ca                	jmp    801e2c <devcons_write+0x1b>
}
  801e62:	89 f0                	mov    %esi,%eax
  801e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <devcons_read>:
{
  801e6c:	f3 0f 1e fb          	endbr32 
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7f:	74 21                	je     801ea2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801e81:	e8 c3 ec ff ff       	call   800b49 <sys_cgetc>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 07                	jne    801e91 <devcons_read+0x25>
		sys_yield();
  801e8a:	e8 30 ed ff ff       	call   800bbf <sys_yield>
  801e8f:	eb f0                	jmp    801e81 <devcons_read+0x15>
	if (c < 0)
  801e91:	78 0f                	js     801ea2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801e93:	83 f8 04             	cmp    $0x4,%eax
  801e96:	74 0c                	je     801ea4 <devcons_read+0x38>
	*(char*)vbuf = c;
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	88 02                	mov    %al,(%edx)
	return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	eb f7                	jmp    801ea2 <devcons_read+0x36>

00801eab <cputchar>:
{
  801eab:	f3 0f 1e fb          	endbr32 
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ebb:	6a 01                	push   $0x1
  801ebd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	e8 59 ec ff ff       	call   800b1f <sys_cputs>
}
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <getchar>:
{
  801ecb:	f3 0f 1e fb          	endbr32 
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ed5:	6a 01                	push   $0x1
  801ed7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eda:	50                   	push   %eax
  801edb:	6a 00                	push   $0x0
  801edd:	e8 20 f6 ff ff       	call   801502 <read>
	if (r < 0)
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 06                	js     801eef <getchar+0x24>
	if (r < 1)
  801ee9:	74 06                	je     801ef1 <getchar+0x26>
	return c;
  801eeb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    
		return -E_EOF;
  801ef1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef6:	eb f7                	jmp    801eef <getchar+0x24>

00801ef8 <iscons>:
{
  801ef8:	f3 0f 1e fb          	endbr32 
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f05:	50                   	push   %eax
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	e8 71 f3 ff ff       	call   80127f <fd_lookup>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	85 c0                	test   %eax,%eax
  801f13:	78 11                	js     801f26 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f1e:	39 10                	cmp    %edx,(%eax)
  801f20:	0f 94 c0             	sete   %al
  801f23:	0f b6 c0             	movzbl %al,%eax
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <opencons>:
{
  801f28:	f3 0f 1e fb          	endbr32 
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	e8 ee f2 ff ff       	call   801229 <fd_alloc>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 3a                	js     801f7c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	68 07 04 00 00       	push   $0x407
  801f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 96 ec ff ff       	call   800bea <sys_page_alloc>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 21                	js     801f7c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f64:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	50                   	push   %eax
  801f74:	e8 7d f2 ff ff       	call   8011f6 <fd2num>
  801f79:	83 c4 10             	add    $0x10,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f7e:	f3 0f 1e fb          	endbr32 
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f87:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f8a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f90:	e8 02 ec ff ff       	call   800b97 <sys_getenvid>
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	56                   	push   %esi
  801f9f:	50                   	push   %eax
  801fa0:	68 28 2a 80 00       	push   $0x802a28
  801fa5:	e8 4e e2 ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801faa:	83 c4 18             	add    $0x18,%esp
  801fad:	53                   	push   %ebx
  801fae:	ff 75 10             	pushl  0x10(%ebp)
  801fb1:	e8 ed e1 ff ff       	call   8001a3 <vcprintf>
	cprintf("\n");
  801fb6:	c7 04 24 8c 2a 80 00 	movl   $0x802a8c,(%esp)
  801fbd:	e8 36 e2 ff ff       	call   8001f8 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fc5:	cc                   	int3   
  801fc6:	eb fd                	jmp    801fc5 <_panic+0x47>

00801fc8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fc8:	f3 0f 1e fb          	endbr32 
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fd2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fd9:	74 0a                	je     801fe5 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  801fe5:	a1 04 40 80 00       	mov    0x804004,%eax
  801fea:	8b 40 48             	mov    0x48(%eax),%eax
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	6a 07                	push   $0x7
  801ff2:	68 00 f0 bf ee       	push   $0xeebff000
  801ff7:	50                   	push   %eax
  801ff8:	e8 ed eb ff ff       	call   800bea <sys_page_alloc>
		if (r!= 0)
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	85 c0                	test   %eax,%eax
  802002:	75 2f                	jne    802033 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802004:	a1 04 40 80 00       	mov    0x804004,%eax
  802009:	8b 40 48             	mov    0x48(%eax),%eax
  80200c:	83 ec 08             	sub    $0x8,%esp
  80200f:	68 45 20 80 00       	push   $0x802045
  802014:	50                   	push   %eax
  802015:	e8 97 ec ff ff       	call   800cb1 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	85 c0                	test   %eax,%eax
  80201f:	74 ba                	je     801fdb <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  802021:	50                   	push   %eax
  802022:	68 4b 2a 80 00       	push   $0x802a4b
  802027:	6a 26                	push   $0x26
  802029:	68 63 2a 80 00       	push   $0x802a63
  80202e:	e8 4b ff ff ff       	call   801f7e <_panic>
			panic("set_pgfault_handler: %e", r);
  802033:	50                   	push   %eax
  802034:	68 4b 2a 80 00       	push   $0x802a4b
  802039:	6a 22                	push   $0x22
  80203b:	68 63 2a 80 00       	push   $0x802a63
  802040:	e8 39 ff ff ff       	call   801f7e <_panic>

00802045 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802045:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802046:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80204b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80204d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802050:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  802054:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802057:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  80205b:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  80205f:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802061:	83 c4 08             	add    $0x8,%esp
	popal
  802064:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802065:	83 c4 04             	add    $0x4,%esp
	popfl
  802068:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802069:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80206a:	c3                   	ret    

0080206b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80206b:	f3 0f 1e fb          	endbr32 
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	56                   	push   %esi
  802073:	53                   	push   %ebx
  802074:	8b 75 08             	mov    0x8(%ebp),%esi
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  80207d:	85 c0                	test   %eax,%eax
  80207f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802084:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	50                   	push   %eax
  80208b:	e8 71 ec ff ff       	call   800d01 <sys_ipc_recv>
	if (r < 0) {
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 2b                	js     8020c2 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  802097:	85 f6                	test   %esi,%esi
  802099:	74 0a                	je     8020a5 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  80209b:	a1 04 40 80 00       	mov    0x804004,%eax
  8020a0:	8b 40 74             	mov    0x74(%eax),%eax
  8020a3:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8020a5:	85 db                	test   %ebx,%ebx
  8020a7:	74 0a                	je     8020b3 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8020a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8020ae:	8b 40 78             	mov    0x78(%eax),%eax
  8020b1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020b3:	a1 04 40 80 00       	mov    0x804004,%eax
  8020b8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
		if (from_env_store) {
  8020c2:	85 f6                	test   %esi,%esi
  8020c4:	74 06                	je     8020cc <ipc_recv+0x61>
			*from_env_store = 0;
  8020c6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8020cc:	85 db                	test   %ebx,%ebx
  8020ce:	74 eb                	je     8020bb <ipc_recv+0x50>
			*perm_store = 0;
  8020d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020d6:	eb e3                	jmp    8020bb <ipc_recv+0x50>

008020d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020d8:	f3 0f 1e fb          	endbr32 
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	57                   	push   %edi
  8020e0:	56                   	push   %esi
  8020e1:	53                   	push   %ebx
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8020ee:	85 db                	test   %ebx,%ebx
  8020f0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020f5:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8020f8:	ff 75 14             	pushl  0x14(%ebp)
  8020fb:	53                   	push   %ebx
  8020fc:	56                   	push   %esi
  8020fd:	57                   	push   %edi
  8020fe:	e8 d5 eb ff ff       	call   800cd8 <sys_ipc_try_send>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802109:	75 07                	jne    802112 <ipc_send+0x3a>
		sys_yield();
  80210b:	e8 af ea ff ff       	call   800bbf <sys_yield>
  802110:	eb e6                	jmp    8020f8 <ipc_send+0x20>
	}

	if (ret < 0) {
  802112:	85 c0                	test   %eax,%eax
  802114:	78 08                	js     80211e <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5f                   	pop    %edi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  80211e:	50                   	push   %eax
  80211f:	68 71 2a 80 00       	push   $0x802a71
  802124:	6a 48                	push   $0x48
  802126:	68 8e 2a 80 00       	push   $0x802a8e
  80212b:	e8 4e fe ff ff       	call   801f7e <_panic>

00802130 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80213f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802142:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802148:	8b 52 50             	mov    0x50(%edx),%edx
  80214b:	39 ca                	cmp    %ecx,%edx
  80214d:	74 11                	je     802160 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80214f:	83 c0 01             	add    $0x1,%eax
  802152:	3d 00 04 00 00       	cmp    $0x400,%eax
  802157:	75 e6                	jne    80213f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	eb 0b                	jmp    80216b <ipc_find_env+0x3b>
			return envs[i].env_id;
  802160:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802168:	8b 40 48             	mov    0x48(%eax),%eax
}
  80216b:	5d                   	pop    %ebp
  80216c:	c3                   	ret    

0080216d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80216d:	f3 0f 1e fb          	endbr32 
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802177:	89 c2                	mov    %eax,%edx
  802179:	c1 ea 16             	shr    $0x16,%edx
  80217c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802183:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802188:	f6 c1 01             	test   $0x1,%cl
  80218b:	74 1c                	je     8021a9 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80218d:	c1 e8 0c             	shr    $0xc,%eax
  802190:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802197:	a8 01                	test   $0x1,%al
  802199:	74 0e                	je     8021a9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80219b:	c1 e8 0c             	shr    $0xc,%eax
  80219e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021a5:	ef 
  8021a6:	0f b7 d2             	movzwl %dx,%edx
}
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	5d                   	pop    %ebp
  8021ac:	c3                   	ret    
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
