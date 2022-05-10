
obj/user/yield.debug:     formato del fichero elf32-i386


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
  80002c:	e8 72 00 00 00       	call   8000a3 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	int i;

	cprintf("Hello, I am environment %08x, cpu %d.\n", thisenv->env_id, thisenv->env_cpunum);
  80003e:	a1 04 40 80 00       	mov    0x804004,%eax
  800043:	8b 50 5c             	mov    0x5c(%eax),%edx
  800046:	8b 40 48             	mov    0x48(%eax),%eax
  800049:	52                   	push   %edx
  80004a:	50                   	push   %eax
  80004b:	68 60 1e 80 00       	push   $0x801e60
  800050:	e8 57 01 00 00       	call   8001ac <cprintf>
  800055:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800058:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  80005d:	e8 11 0b 00 00       	call   800b73 <sys_yield>
		cprintf("Back in environment %08x, iteration %d, cpu %d\n",
			thisenv->env_id, i, thisenv->env_cpunum);
  800062:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("Back in environment %08x, iteration %d, cpu %d\n",
  800067:	8b 50 5c             	mov    0x5c(%eax),%edx
  80006a:	8b 40 48             	mov    0x48(%eax),%eax
  80006d:	52                   	push   %edx
  80006e:	53                   	push   %ebx
  80006f:	50                   	push   %eax
  800070:	68 88 1e 80 00       	push   $0x801e88
  800075:	e8 32 01 00 00       	call   8001ac <cprintf>
	for (i = 0; i < 5; i++) {
  80007a:	83 c3 01             	add    $0x1,%ebx
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	83 fb 05             	cmp    $0x5,%ebx
  800083:	75 d8                	jne    80005d <umain+0x2a>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800085:	a1 04 40 80 00       	mov    0x804004,%eax
  80008a:	8b 40 48             	mov    0x48(%eax),%eax
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	50                   	push   %eax
  800091:	68 b8 1e 80 00       	push   $0x801eb8
  800096:	e8 11 01 00 00       	call   8001ac <cprintf>

}
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000a1:	c9                   	leave  
  8000a2:	c3                   	ret    

008000a3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a3:	f3 0f 1e fb          	endbr32 
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000af:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000b2:	e8 94 0a 00 00       	call   800b4b <sys_getenvid>
	if (id >= 0)
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	78 12                	js     8000cd <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c8:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cd:	85 db                	test   %ebx,%ebx
  8000cf:	7e 07                	jle    8000d8 <libmain+0x35>
		binaryname = argv[0];
  8000d1:	8b 06                	mov    (%esi),%eax
  8000d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	e8 51 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e2:	e8 0a 00 00 00       	call   8000f1 <exit>
}
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f1:	f3 0f 1e fb          	endbr32 
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000fb:	e8 ce 0d 00 00       	call   800ece <close_all>
	sys_env_destroy(0);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	6a 00                	push   $0x0
  800105:	e8 1b 0a 00 00       	call   800b25 <sys_env_destroy>
}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	c9                   	leave  
  80010e:	c3                   	ret    

0080010f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010f:	f3 0f 1e fb          	endbr32 
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	53                   	push   %ebx
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011d:	8b 13                	mov    (%ebx),%edx
  80011f:	8d 42 01             	lea    0x1(%edx),%eax
  800122:	89 03                	mov    %eax,(%ebx)
  800124:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800127:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800130:	74 09                	je     80013b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800132:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800139:	c9                   	leave  
  80013a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	68 ff 00 00 00       	push   $0xff
  800143:	8d 43 08             	lea    0x8(%ebx),%eax
  800146:	50                   	push   %eax
  800147:	e8 87 09 00 00       	call   800ad3 <sys_cputs>
		b->idx = 0;
  80014c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb db                	jmp    800132 <putch+0x23>

00800157 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800164:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016b:	00 00 00 
	b.cnt = 0;
  80016e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800175:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	68 0f 01 80 00       	push   $0x80010f
  80018a:	e8 80 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800198:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 2f 09 00 00       	call   800ad3 <sys_cputs>

	return b.cnt;
}
  8001a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ac:	f3 0f 1e fb          	endbr32 
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b9:	50                   	push   %eax
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 95 ff ff ff       	call   800157 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 1c             	sub    $0x1c,%esp
  8001cd:	89 c7                	mov    %eax,%edi
  8001cf:	89 d6                	mov    %edx,%esi
  8001d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	89 d1                	mov    %edx,%ecx
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001de:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001f1:	39 c2                	cmp    %eax,%edx
  8001f3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f6:	72 3e                	jb     800236 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	ff 75 18             	pushl  0x18(%ebp)
  8001fe:	83 eb 01             	sub    $0x1,%ebx
  800201:	53                   	push   %ebx
  800202:	50                   	push   %eax
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	ff 75 e4             	pushl  -0x1c(%ebp)
  800209:	ff 75 e0             	pushl  -0x20(%ebp)
  80020c:	ff 75 dc             	pushl  -0x24(%ebp)
  80020f:	ff 75 d8             	pushl  -0x28(%ebp)
  800212:	e8 d9 19 00 00       	call   801bf0 <__udivdi3>
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	52                   	push   %edx
  80021b:	50                   	push   %eax
  80021c:	89 f2                	mov    %esi,%edx
  80021e:	89 f8                	mov    %edi,%eax
  800220:	e8 9f ff ff ff       	call   8001c4 <printnum>
  800225:	83 c4 20             	add    $0x20,%esp
  800228:	eb 13                	jmp    80023d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	56                   	push   %esi
  80022e:	ff 75 18             	pushl  0x18(%ebp)
  800231:	ff d7                	call   *%edi
  800233:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800236:	83 eb 01             	sub    $0x1,%ebx
  800239:	85 db                	test   %ebx,%ebx
  80023b:	7f ed                	jg     80022a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023d:	83 ec 08             	sub    $0x8,%esp
  800240:	56                   	push   %esi
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	ff 75 e4             	pushl  -0x1c(%ebp)
  800247:	ff 75 e0             	pushl  -0x20(%ebp)
  80024a:	ff 75 dc             	pushl  -0x24(%ebp)
  80024d:	ff 75 d8             	pushl  -0x28(%ebp)
  800250:	e8 ab 1a 00 00       	call   801d00 <__umoddi3>
  800255:	83 c4 14             	add    $0x14,%esp
  800258:	0f be 80 e1 1e 80 00 	movsbl 0x801ee1(%eax),%eax
  80025f:	50                   	push   %eax
  800260:	ff d7                	call   *%edi
}
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    

0080026d <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80026d:	83 fa 01             	cmp    $0x1,%edx
  800270:	7f 13                	jg     800285 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800272:	85 d2                	test   %edx,%edx
  800274:	74 1c                	je     800292 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800276:	8b 10                	mov    (%eax),%edx
  800278:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027b:	89 08                	mov    %ecx,(%eax)
  80027d:	8b 02                	mov    (%edx),%eax
  80027f:	ba 00 00 00 00       	mov    $0x0,%edx
  800284:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800285:	8b 10                	mov    (%eax),%edx
  800287:	8d 4a 08             	lea    0x8(%edx),%ecx
  80028a:	89 08                	mov    %ecx,(%eax)
  80028c:	8b 02                	mov    (%edx),%eax
  80028e:	8b 52 04             	mov    0x4(%edx),%edx
  800291:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8d 4a 04             	lea    0x4(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 02                	mov    (%edx),%eax
  80029b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a0:	c3                   	ret    

008002a1 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002a1:	83 fa 01             	cmp    $0x1,%edx
  8002a4:	7f 0f                	jg     8002b5 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8002a6:	85 d2                	test   %edx,%edx
  8002a8:	74 18                	je     8002c2 <getint+0x21>
		return va_arg(*ap, long);
  8002aa:	8b 10                	mov    (%eax),%edx
  8002ac:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002af:	89 08                	mov    %ecx,(%eax)
  8002b1:	8b 02                	mov    (%edx),%eax
  8002b3:	99                   	cltd   
  8002b4:	c3                   	ret    
		return va_arg(*ap, long long);
  8002b5:	8b 10                	mov    (%eax),%edx
  8002b7:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ba:	89 08                	mov    %ecx,(%eax)
  8002bc:	8b 02                	mov    (%edx),%eax
  8002be:	8b 52 04             	mov    0x4(%edx),%edx
  8002c1:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002c2:	8b 10                	mov    (%eax),%edx
  8002c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 02                	mov    (%edx),%eax
  8002cb:	99                   	cltd   
}
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 2c             	sub    $0x2c,%esp
  80031c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80031f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	e9 86 02 00 00       	jmp    8005b0 <vprintfmt+0x2a1>
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 df 02 00 00    	ja     80063b <vprintfmt+0x32c>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	3e ff 24 85 20 20 80 	notrack jmp *0x802020(,%eax,4)
  800366:	00 
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d8                	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb cf                	jmp    800348 <vprintfmt+0x39>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 52                	ja     8003eb <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 50 04             	lea    0x4(%eax),%edx
  8003a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b3:	79 93                	jns    800348 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c2:	eb 84                	jmp    800348 <vprintfmt+0x39>
  8003c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c7:	85 c0                	test   %eax,%eax
  8003c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ce:	0f 49 d0             	cmovns %eax,%edx
  8003d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d7:	e9 6c ff ff ff       	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003df:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e6:	e9 5d ff ff ff       	jmp    800348 <vprintfmt+0x39>
  8003eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	eb bc                	jmp    8003af <vprintfmt+0xa0>
			lflag++;
  8003f3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f9:	e9 4a ff ff ff       	jmp    800348 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 50 04             	lea    0x4(%eax),%edx
  800404:	89 55 14             	mov    %edx,0x14(%ebp)
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	56                   	push   %esi
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d3                	call   *%ebx
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
  800412:	e9 96 01 00 00       	jmp    8005ad <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	89 55 14             	mov    %edx,0x14(%ebp)
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 20                	jg     80044c <vprintfmt+0x13d>
  80042c:	8b 14 85 80 21 80 00 	mov    0x802180(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 15                	je     80044c <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 d7 22 80 00       	push   $0x8022d7
  80043d:	56                   	push   %esi
  80043e:	53                   	push   %ebx
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	e9 61 01 00 00       	jmp    8005ad <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80044c:	50                   	push   %eax
  80044d:	68 f9 1e 80 00       	push   $0x801ef9
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	e8 95 fe ff ff       	call   8002ee <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	e9 4c 01 00 00       	jmp    8005ad <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800461:	8b 45 14             	mov    0x14(%ebp),%eax
  800464:	8d 50 04             	lea    0x4(%eax),%edx
  800467:	89 55 14             	mov    %edx,0x14(%ebp)
  80046a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80046c:	85 c9                	test   %ecx,%ecx
  80046e:	b8 f2 1e 80 00       	mov    $0x801ef2,%eax
  800473:	0f 45 c1             	cmovne %ecx,%eax
  800476:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800479:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047d:	7e 06                	jle    800485 <vprintfmt+0x176>
  80047f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800483:	75 0d                	jne    800492 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800485:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800488:	89 c7                	mov    %eax,%edi
  80048a:	03 45 e0             	add    -0x20(%ebp),%eax
  80048d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800490:	eb 57                	jmp    8004e9 <vprintfmt+0x1da>
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	ff 75 d8             	pushl  -0x28(%ebp)
  800498:	ff 75 cc             	pushl  -0x34(%ebp)
  80049b:	e8 4f 02 00 00       	call   8006ef <strnlen>
  8004a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a3:	29 c2                	sub    %eax,%edx
  8004a5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ab:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8004af:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8004b2:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	7e 10                	jle    8004c8 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	56                   	push   %esi
  8004bc:	57                   	push   %edi
  8004bd:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	83 eb 01             	sub    $0x1,%ebx
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	eb ec                	jmp    8004b4 <vprintfmt+0x1a5>
  8004c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ce:	85 d2                	test   %edx,%edx
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 49 c2             	cmovns %edx,%eax
  8004d8:	29 c2                	sub    %eax,%edx
  8004da:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004dd:	eb a6                	jmp    800485 <vprintfmt+0x176>
					putch(ch, putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	56                   	push   %esi
  8004e3:	52                   	push   %edx
  8004e4:	ff d3                	call   *%ebx
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ec:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ee:	83 c7 01             	add    $0x1,%edi
  8004f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f5:	0f be d0             	movsbl %al,%edx
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	74 42                	je     80053e <vprintfmt+0x22f>
  8004fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800500:	78 06                	js     800508 <vprintfmt+0x1f9>
  800502:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800506:	78 1e                	js     800526 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800508:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80050c:	74 d1                	je     8004df <vprintfmt+0x1d0>
  80050e:	0f be c0             	movsbl %al,%eax
  800511:	83 e8 20             	sub    $0x20,%eax
  800514:	83 f8 5e             	cmp    $0x5e,%eax
  800517:	76 c6                	jbe    8004df <vprintfmt+0x1d0>
					putch('?', putdat);
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	56                   	push   %esi
  80051d:	6a 3f                	push   $0x3f
  80051f:	ff d3                	call   *%ebx
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	eb c3                	jmp    8004e9 <vprintfmt+0x1da>
  800526:	89 cf                	mov    %ecx,%edi
  800528:	eb 0e                	jmp    800538 <vprintfmt+0x229>
				putch(' ', putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	56                   	push   %esi
  80052e:	6a 20                	push   $0x20
  800530:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800532:	83 ef 01             	sub    $0x1,%edi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	85 ff                	test   %edi,%edi
  80053a:	7f ee                	jg     80052a <vprintfmt+0x21b>
  80053c:	eb 6f                	jmp    8005ad <vprintfmt+0x29e>
  80053e:	89 cf                	mov    %ecx,%edi
  800540:	eb f6                	jmp    800538 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800542:	89 ca                	mov    %ecx,%edx
  800544:	8d 45 14             	lea    0x14(%ebp),%eax
  800547:	e8 55 fd ff ff       	call   8002a1 <getint>
  80054c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800552:	85 d2                	test   %edx,%edx
  800554:	78 0b                	js     800561 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800556:	89 d1                	mov    %edx,%ecx
  800558:	89 c2                	mov    %eax,%edx
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055f:	eb 32                	jmp    800593 <vprintfmt+0x284>
				putch('-', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	56                   	push   %esi
  800565:	6a 2d                	push   $0x2d
  800567:	ff d3                	call   *%ebx
				num = -(long long) num;
  800569:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056f:	f7 da                	neg    %edx
  800571:	83 d1 00             	adc    $0x0,%ecx
  800574:	f7 d9                	neg    %ecx
  800576:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800579:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057e:	eb 13                	jmp    800593 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800580:	89 ca                	mov    %ecx,%edx
  800582:	8d 45 14             	lea    0x14(%ebp),%eax
  800585:	e8 e3 fc ff ff       	call   80026d <getuint>
  80058a:	89 d1                	mov    %edx,%ecx
  80058c:	89 c2                	mov    %eax,%edx
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80059a:	57                   	push   %edi
  80059b:	ff 75 e0             	pushl  -0x20(%ebp)
  80059e:	50                   	push   %eax
  80059f:	51                   	push   %ecx
  8005a0:	52                   	push   %edx
  8005a1:	89 f2                	mov    %esi,%edx
  8005a3:	89 d8                	mov    %ebx,%eax
  8005a5:	e8 1a fc ff ff       	call   8001c4 <printnum>
			break;
  8005aa:	83 c4 20             	add    $0x20,%esp
{
  8005ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b0:	83 c7 01             	add    $0x1,%edi
  8005b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b7:	83 f8 25             	cmp    $0x25,%eax
  8005ba:	0f 84 6a fd ff ff    	je     80032a <vprintfmt+0x1b>
			if (ch == '\0')
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	0f 84 93 00 00 00    	je     80065b <vprintfmt+0x34c>
			putch(ch, putdat);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	56                   	push   %esi
  8005cc:	50                   	push   %eax
  8005cd:	ff d3                	call   *%ebx
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	eb dc                	jmp    8005b0 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005d4:	89 ca                	mov    %ecx,%edx
  8005d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d9:	e8 8f fc ff ff       	call   80026d <getuint>
  8005de:	89 d1                	mov    %edx,%ecx
  8005e0:	89 c2                	mov    %eax,%edx
			base = 8;
  8005e2:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005e7:	eb aa                	jmp    800593 <vprintfmt+0x284>
			putch('0', putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	56                   	push   %esi
  8005ed:	6a 30                	push   $0x30
  8005ef:	ff d3                	call   *%ebx
			putch('x', putdat);
  8005f1:	83 c4 08             	add    $0x8,%esp
  8005f4:	56                   	push   %esi
  8005f5:	6a 78                	push   $0x78
  8005f7:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 50 04             	lea    0x4(%eax),%edx
  8005ff:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800602:	8b 10                	mov    (%eax),%edx
  800604:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800609:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80060c:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800611:	eb 80                	jmp    800593 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800613:	89 ca                	mov    %ecx,%edx
  800615:	8d 45 14             	lea    0x14(%ebp),%eax
  800618:	e8 50 fc ff ff       	call   80026d <getuint>
  80061d:	89 d1                	mov    %edx,%ecx
  80061f:	89 c2                	mov    %eax,%edx
			base = 16;
  800621:	b8 10 00 00 00       	mov    $0x10,%eax
  800626:	e9 68 ff ff ff       	jmp    800593 <vprintfmt+0x284>
			putch(ch, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	56                   	push   %esi
  80062f:	6a 25                	push   $0x25
  800631:	ff d3                	call   *%ebx
			break;
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	e9 72 ff ff ff       	jmp    8005ad <vprintfmt+0x29e>
			putch('%', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	56                   	push   %esi
  80063f:	6a 25                	push   $0x25
  800641:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 f8                	mov    %edi,%eax
  800648:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80064c:	74 05                	je     800653 <vprintfmt+0x344>
  80064e:	83 e8 01             	sub    $0x1,%eax
  800651:	eb f5                	jmp    800648 <vprintfmt+0x339>
  800653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800656:	e9 52 ff ff ff       	jmp    8005ad <vprintfmt+0x29e>
}
  80065b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065e:	5b                   	pop    %ebx
  80065f:	5e                   	pop    %esi
  800660:	5f                   	pop    %edi
  800661:	5d                   	pop    %ebp
  800662:	c3                   	ret    

00800663 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800663:	f3 0f 1e fb          	endbr32 
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	83 ec 18             	sub    $0x18,%esp
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800673:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800676:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80067a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80067d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800684:	85 c0                	test   %eax,%eax
  800686:	74 26                	je     8006ae <vsnprintf+0x4b>
  800688:	85 d2                	test   %edx,%edx
  80068a:	7e 22                	jle    8006ae <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80068c:	ff 75 14             	pushl  0x14(%ebp)
  80068f:	ff 75 10             	pushl  0x10(%ebp)
  800692:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	68 cd 02 80 00       	push   $0x8002cd
  80069b:	e8 6f fc ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    
		return -E_INVAL;
  8006ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b3:	eb f7                	jmp    8006ac <vsnprintf+0x49>

008006b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006b5:	f3 0f 1e fb          	endbr32 
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006c2:	50                   	push   %eax
  8006c3:	ff 75 10             	pushl  0x10(%ebp)
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	ff 75 08             	pushl  0x8(%ebp)
  8006cc:	e8 92 ff ff ff       	call   800663 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006d3:	f3 0f 1e fb          	endbr32 
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006e6:	74 05                	je     8006ed <strlen+0x1a>
		n++;
  8006e8:	83 c0 01             	add    $0x1,%eax
  8006eb:	eb f5                	jmp    8006e2 <strlen+0xf>
	return n;
}
  8006ed:	5d                   	pop    %ebp
  8006ee:	c3                   	ret    

008006ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006ef:	f3 0f 1e fb          	endbr32 
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800701:	39 d0                	cmp    %edx,%eax
  800703:	74 0d                	je     800712 <strnlen+0x23>
  800705:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800709:	74 05                	je     800710 <strnlen+0x21>
		n++;
  80070b:	83 c0 01             	add    $0x1,%eax
  80070e:	eb f1                	jmp    800701 <strnlen+0x12>
  800710:	89 c2                	mov    %eax,%edx
	return n;
}
  800712:	89 d0                	mov    %edx,%eax
  800714:	5d                   	pop    %ebp
  800715:	c3                   	ret    

00800716 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800716:	f3 0f 1e fb          	endbr32 
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	53                   	push   %ebx
  80071e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800721:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800724:	b8 00 00 00 00       	mov    $0x0,%eax
  800729:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80072d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800730:	83 c0 01             	add    $0x1,%eax
  800733:	84 d2                	test   %dl,%dl
  800735:	75 f2                	jne    800729 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800737:	89 c8                	mov    %ecx,%eax
  800739:	5b                   	pop    %ebx
  80073a:	5d                   	pop    %ebp
  80073b:	c3                   	ret    

0080073c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80073c:	f3 0f 1e fb          	endbr32 
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	53                   	push   %ebx
  800744:	83 ec 10             	sub    $0x10,%esp
  800747:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80074a:	53                   	push   %ebx
  80074b:	e8 83 ff ff ff       	call   8006d3 <strlen>
  800750:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	01 d8                	add    %ebx,%eax
  800758:	50                   	push   %eax
  800759:	e8 b8 ff ff ff       	call   800716 <strcpy>
	return dst;
}
  80075e:	89 d8                	mov    %ebx,%eax
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800765:	f3 0f 1e fb          	endbr32 
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	56                   	push   %esi
  80076d:	53                   	push   %ebx
  80076e:	8b 75 08             	mov    0x8(%ebp),%esi
  800771:	8b 55 0c             	mov    0xc(%ebp),%edx
  800774:	89 f3                	mov    %esi,%ebx
  800776:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800779:	89 f0                	mov    %esi,%eax
  80077b:	39 d8                	cmp    %ebx,%eax
  80077d:	74 11                	je     800790 <strncpy+0x2b>
		*dst++ = *src;
  80077f:	83 c0 01             	add    $0x1,%eax
  800782:	0f b6 0a             	movzbl (%edx),%ecx
  800785:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800788:	80 f9 01             	cmp    $0x1,%cl
  80078b:	83 da ff             	sbb    $0xffffffff,%edx
  80078e:	eb eb                	jmp    80077b <strncpy+0x16>
	}
	return ret;
}
  800790:	89 f0                	mov    %esi,%eax
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800796:	f3 0f 1e fb          	endbr32 
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	56                   	push   %esi
  80079e:	53                   	push   %ebx
  80079f:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8007a8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007aa:	85 d2                	test   %edx,%edx
  8007ac:	74 21                	je     8007cf <strlcpy+0x39>
  8007ae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007b2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 14                	je     8007cc <strlcpy+0x36>
  8007b8:	0f b6 19             	movzbl (%ecx),%ebx
  8007bb:	84 db                	test   %bl,%bl
  8007bd:	74 0b                	je     8007ca <strlcpy+0x34>
			*dst++ = *src++;
  8007bf:	83 c1 01             	add    $0x1,%ecx
  8007c2:	83 c2 01             	add    $0x1,%edx
  8007c5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c8:	eb ea                	jmp    8007b4 <strlcpy+0x1e>
  8007ca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007cf:	29 f0                	sub    %esi,%eax
}
  8007d1:	5b                   	pop    %ebx
  8007d2:	5e                   	pop    %esi
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007d5:	f3 0f 1e fb          	endbr32 
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007e2:	0f b6 01             	movzbl (%ecx),%eax
  8007e5:	84 c0                	test   %al,%al
  8007e7:	74 0c                	je     8007f5 <strcmp+0x20>
  8007e9:	3a 02                	cmp    (%edx),%al
  8007eb:	75 08                	jne    8007f5 <strcmp+0x20>
		p++, q++;
  8007ed:	83 c1 01             	add    $0x1,%ecx
  8007f0:	83 c2 01             	add    $0x1,%edx
  8007f3:	eb ed                	jmp    8007e2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007f5:	0f b6 c0             	movzbl %al,%eax
  8007f8:	0f b6 12             	movzbl (%edx),%edx
  8007fb:	29 d0                	sub    %edx,%eax
}
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007ff:	f3 0f 1e fb          	endbr32 
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	89 c3                	mov    %eax,%ebx
  80080f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800812:	eb 06                	jmp    80081a <strncmp+0x1b>
		n--, p++, q++;
  800814:	83 c0 01             	add    $0x1,%eax
  800817:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80081a:	39 d8                	cmp    %ebx,%eax
  80081c:	74 16                	je     800834 <strncmp+0x35>
  80081e:	0f b6 08             	movzbl (%eax),%ecx
  800821:	84 c9                	test   %cl,%cl
  800823:	74 04                	je     800829 <strncmp+0x2a>
  800825:	3a 0a                	cmp    (%edx),%cl
  800827:	74 eb                	je     800814 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800829:	0f b6 00             	movzbl (%eax),%eax
  80082c:	0f b6 12             	movzbl (%edx),%edx
  80082f:	29 d0                	sub    %edx,%eax
}
  800831:	5b                   	pop    %ebx
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    
		return 0;
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
  800839:	eb f6                	jmp    800831 <strncmp+0x32>

0080083b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80083b:	f3 0f 1e fb          	endbr32 
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800849:	0f b6 10             	movzbl (%eax),%edx
  80084c:	84 d2                	test   %dl,%dl
  80084e:	74 09                	je     800859 <strchr+0x1e>
		if (*s == c)
  800850:	38 ca                	cmp    %cl,%dl
  800852:	74 0a                	je     80085e <strchr+0x23>
	for (; *s; s++)
  800854:	83 c0 01             	add    $0x1,%eax
  800857:	eb f0                	jmp    800849 <strchr+0xe>
			return (char *) s;
	return 0;
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800860:	f3 0f 1e fb          	endbr32 
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80086e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800871:	38 ca                	cmp    %cl,%dl
  800873:	74 09                	je     80087e <strfind+0x1e>
  800875:	84 d2                	test   %dl,%dl
  800877:	74 05                	je     80087e <strfind+0x1e>
	for (; *s; s++)
  800879:	83 c0 01             	add    $0x1,%eax
  80087c:	eb f0                	jmp    80086e <strfind+0xe>
			break;
	return (char *) s;
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	57                   	push   %edi
  800888:	56                   	push   %esi
  800889:	53                   	push   %ebx
  80088a:	8b 55 08             	mov    0x8(%ebp),%edx
  80088d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800890:	85 c9                	test   %ecx,%ecx
  800892:	74 33                	je     8008c7 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800894:	89 d0                	mov    %edx,%eax
  800896:	09 c8                	or     %ecx,%eax
  800898:	a8 03                	test   $0x3,%al
  80089a:	75 23                	jne    8008bf <memset+0x3f>
		c &= 0xFF;
  80089c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008a0:	89 d8                	mov    %ebx,%eax
  8008a2:	c1 e0 08             	shl    $0x8,%eax
  8008a5:	89 df                	mov    %ebx,%edi
  8008a7:	c1 e7 18             	shl    $0x18,%edi
  8008aa:	89 de                	mov    %ebx,%esi
  8008ac:	c1 e6 10             	shl    $0x10,%esi
  8008af:	09 f7                	or     %esi,%edi
  8008b1:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008b3:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008b6:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8008b8:	89 d7                	mov    %edx,%edi
  8008ba:	fc                   	cld    
  8008bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8008bd:	eb 08                	jmp    8008c7 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008bf:	89 d7                	mov    %edx,%edi
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	fc                   	cld    
  8008c5:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008c7:	89 d0                	mov    %edx,%eax
  8008c9:	5b                   	pop    %ebx
  8008ca:	5e                   	pop    %esi
  8008cb:	5f                   	pop    %edi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ce:	f3 0f 1e fb          	endbr32 
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	57                   	push   %edi
  8008d6:	56                   	push   %esi
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008e0:	39 c6                	cmp    %eax,%esi
  8008e2:	73 32                	jae    800916 <memmove+0x48>
  8008e4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	76 2b                	jbe    800916 <memmove+0x48>
		s += n;
		d += n;
  8008eb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ee:	89 fe                	mov    %edi,%esi
  8008f0:	09 ce                	or     %ecx,%esi
  8008f2:	09 d6                	or     %edx,%esi
  8008f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008fa:	75 0e                	jne    80090a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008fc:	83 ef 04             	sub    $0x4,%edi
  8008ff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800902:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800905:	fd                   	std    
  800906:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800908:	eb 09                	jmp    800913 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80090a:	83 ef 01             	sub    $0x1,%edi
  80090d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800910:	fd                   	std    
  800911:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800913:	fc                   	cld    
  800914:	eb 1a                	jmp    800930 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800916:	89 c2                	mov    %eax,%edx
  800918:	09 ca                	or     %ecx,%edx
  80091a:	09 f2                	or     %esi,%edx
  80091c:	f6 c2 03             	test   $0x3,%dl
  80091f:	75 0a                	jne    80092b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800921:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800924:	89 c7                	mov    %eax,%edi
  800926:	fc                   	cld    
  800927:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800929:	eb 05                	jmp    800930 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80092b:	89 c7                	mov    %eax,%edi
  80092d:	fc                   	cld    
  80092e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800930:	5e                   	pop    %esi
  800931:	5f                   	pop    %edi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800934:	f3 0f 1e fb          	endbr32 
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80093e:	ff 75 10             	pushl  0x10(%ebp)
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	e8 82 ff ff ff       	call   8008ce <memmove>
}
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80094e:	f3 0f 1e fb          	endbr32 
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095d:	89 c6                	mov    %eax,%esi
  80095f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800962:	39 f0                	cmp    %esi,%eax
  800964:	74 1c                	je     800982 <memcmp+0x34>
		if (*s1 != *s2)
  800966:	0f b6 08             	movzbl (%eax),%ecx
  800969:	0f b6 1a             	movzbl (%edx),%ebx
  80096c:	38 d9                	cmp    %bl,%cl
  80096e:	75 08                	jne    800978 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800970:	83 c0 01             	add    $0x1,%eax
  800973:	83 c2 01             	add    $0x1,%edx
  800976:	eb ea                	jmp    800962 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800978:	0f b6 c1             	movzbl %cl,%eax
  80097b:	0f b6 db             	movzbl %bl,%ebx
  80097e:	29 d8                	sub    %ebx,%eax
  800980:	eb 05                	jmp    800987 <memcmp+0x39>
	}

	return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800987:	5b                   	pop    %ebx
  800988:	5e                   	pop    %esi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80098b:	f3 0f 1e fb          	endbr32 
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800998:	89 c2                	mov    %eax,%edx
  80099a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80099d:	39 d0                	cmp    %edx,%eax
  80099f:	73 09                	jae    8009aa <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a1:	38 08                	cmp    %cl,(%eax)
  8009a3:	74 05                	je     8009aa <memfind+0x1f>
	for (; s < ends; s++)
  8009a5:	83 c0 01             	add    $0x1,%eax
  8009a8:	eb f3                	jmp    80099d <memfind+0x12>
			break;
	return (void *) s;
}
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ac:	f3 0f 1e fb          	endbr32 
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	57                   	push   %edi
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009bc:	eb 03                	jmp    8009c1 <strtol+0x15>
		s++;
  8009be:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009c1:	0f b6 01             	movzbl (%ecx),%eax
  8009c4:	3c 20                	cmp    $0x20,%al
  8009c6:	74 f6                	je     8009be <strtol+0x12>
  8009c8:	3c 09                	cmp    $0x9,%al
  8009ca:	74 f2                	je     8009be <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009cc:	3c 2b                	cmp    $0x2b,%al
  8009ce:	74 2a                	je     8009fa <strtol+0x4e>
	int neg = 0;
  8009d0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009d5:	3c 2d                	cmp    $0x2d,%al
  8009d7:	74 2b                	je     800a04 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009df:	75 0f                	jne    8009f0 <strtol+0x44>
  8009e1:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e4:	74 28                	je     800a0e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ed:	0f 44 d8             	cmove  %eax,%ebx
  8009f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f8:	eb 46                	jmp    800a40 <strtol+0x94>
		s++;
  8009fa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800a02:	eb d5                	jmp    8009d9 <strtol+0x2d>
		s++, neg = 1;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0c:	eb cb                	jmp    8009d9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a12:	74 0e                	je     800a22 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a14:	85 db                	test   %ebx,%ebx
  800a16:	75 d8                	jne    8009f0 <strtol+0x44>
		s++, base = 8;
  800a18:	83 c1 01             	add    $0x1,%ecx
  800a1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a20:	eb ce                	jmp    8009f0 <strtol+0x44>
		s += 2, base = 16;
  800a22:	83 c1 02             	add    $0x2,%ecx
  800a25:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a2a:	eb c4                	jmp    8009f0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a2c:	0f be d2             	movsbl %dl,%edx
  800a2f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a32:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a35:	7d 3a                	jge    800a71 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a3e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a40:	0f b6 11             	movzbl (%ecx),%edx
  800a43:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a46:	89 f3                	mov    %esi,%ebx
  800a48:	80 fb 09             	cmp    $0x9,%bl
  800a4b:	76 df                	jbe    800a2c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a4d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a50:	89 f3                	mov    %esi,%ebx
  800a52:	80 fb 19             	cmp    $0x19,%bl
  800a55:	77 08                	ja     800a5f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a57:	0f be d2             	movsbl %dl,%edx
  800a5a:	83 ea 57             	sub    $0x57,%edx
  800a5d:	eb d3                	jmp    800a32 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a5f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a62:	89 f3                	mov    %esi,%ebx
  800a64:	80 fb 19             	cmp    $0x19,%bl
  800a67:	77 08                	ja     800a71 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a69:	0f be d2             	movsbl %dl,%edx
  800a6c:	83 ea 37             	sub    $0x37,%edx
  800a6f:	eb c1                	jmp    800a32 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a75:	74 05                	je     800a7c <strtol+0xd0>
		*endptr = (char *) s;
  800a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a7c:	89 c2                	mov    %eax,%edx
  800a7e:	f7 da                	neg    %edx
  800a80:	85 ff                	test   %edi,%edi
  800a82:	0f 45 c2             	cmovne %edx,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5f                   	pop    %edi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	57                   	push   %edi
  800a8e:	56                   	push   %esi
  800a8f:	53                   	push   %ebx
  800a90:	83 ec 1c             	sub    $0x1c,%esp
  800a93:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a96:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a99:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aa1:	8b 7d 10             	mov    0x10(%ebp),%edi
  800aa4:	8b 75 14             	mov    0x14(%ebp),%esi
  800aa7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aad:	74 04                	je     800ab3 <syscall+0x29>
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	7f 08                	jg     800abb <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5f                   	pop    %edi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800abb:	83 ec 0c             	sub    $0xc,%esp
  800abe:	50                   	push   %eax
  800abf:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac2:	68 df 21 80 00       	push   $0x8021df
  800ac7:	6a 23                	push   $0x23
  800ac9:	68 fc 21 80 00       	push   $0x8021fc
  800ace:	e8 90 0f 00 00       	call   801a63 <_panic>

00800ad3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800add:	6a 00                	push   $0x0
  800adf:	6a 00                	push   $0x0
  800ae1:	6a 00                	push   $0x0
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	e8 92 ff ff ff       	call   800a8a <syscall>
}
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sys_cgetc>:

int
sys_cgetc(void)
{
  800afd:	f3 0f 1e fb          	endbr32 
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b07:	6a 00                	push   $0x0
  800b09:	6a 00                	push   $0x0
  800b0b:	6a 00                	push   $0x0
  800b0d:	6a 00                	push   $0x0
  800b0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b14:	ba 00 00 00 00       	mov    $0x0,%edx
  800b19:	b8 01 00 00 00       	mov    $0x1,%eax
  800b1e:	e8 67 ff ff ff       	call   800a8a <syscall>
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b25:	f3 0f 1e fb          	endbr32 
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b2f:	6a 00                	push   $0x0
  800b31:	6a 00                	push   $0x0
  800b33:	6a 00                	push   $0x0
  800b35:	6a 00                	push   $0x0
  800b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3a:	ba 01 00 00 00       	mov    $0x1,%edx
  800b3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b44:	e8 41 ff ff ff       	call   800a8a <syscall>
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b55:	6a 00                	push   $0x0
  800b57:	6a 00                	push   $0x0
  800b59:	6a 00                	push   $0x0
  800b5b:	6a 00                	push   $0x0
  800b5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 02 00 00 00       	mov    $0x2,%eax
  800b6c:	e8 19 ff ff ff       	call   800a8a <syscall>
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <sys_yield>:

void
sys_yield(void)
{
  800b73:	f3 0f 1e fb          	endbr32 
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b7d:	6a 00                	push   $0x0
  800b7f:	6a 00                	push   $0x0
  800b81:	6a 00                	push   $0x0
  800b83:	6a 00                	push   $0x0
  800b85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b94:	e8 f1 fe ff ff       	call   800a8a <syscall>
}
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9e:	f3 0f 1e fb          	endbr32 
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800ba8:	6a 00                	push   $0x0
  800baa:	6a 00                	push   $0x0
  800bac:	ff 75 10             	pushl  0x10(%ebp)
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb5:	ba 01 00 00 00       	mov    $0x1,%edx
  800bba:	b8 04 00 00 00       	mov    $0x4,%eax
  800bbf:	e8 c6 fe ff ff       	call   800a8a <syscall>
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc6:	f3 0f 1e fb          	endbr32 
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bd0:	ff 75 18             	pushl  0x18(%ebp)
  800bd3:	ff 75 14             	pushl  0x14(%ebp)
  800bd6:	ff 75 10             	pushl  0x10(%ebp)
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdf:	ba 01 00 00 00       	mov    $0x1,%edx
  800be4:	b8 05 00 00 00       	mov    $0x5,%eax
  800be9:	e8 9c fe ff ff       	call   800a8a <syscall>
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bfa:	6a 00                	push   $0x0
  800bfc:	6a 00                	push   $0x0
  800bfe:	6a 00                	push   $0x0
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c06:	ba 01 00 00 00       	mov    $0x1,%edx
  800c0b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c10:	e8 75 fe ff ff       	call   800a8a <syscall>
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c17:	f3 0f 1e fb          	endbr32 
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c21:	6a 00                	push   $0x0
  800c23:	6a 00                	push   $0x0
  800c25:	6a 00                	push   $0x0
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c32:	b8 08 00 00 00       	mov    $0x8,%eax
  800c37:	e8 4e fe ff ff       	call   800a8a <syscall>
}
  800c3c:	c9                   	leave  
  800c3d:	c3                   	ret    

00800c3e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c3e:	f3 0f 1e fb          	endbr32 
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c48:	6a 00                	push   $0x0
  800c4a:	6a 00                	push   $0x0
  800c4c:	6a 00                	push   $0x0
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c54:	ba 01 00 00 00       	mov    $0x1,%edx
  800c59:	b8 09 00 00 00       	mov    $0x9,%eax
  800c5e:	e8 27 fe ff ff       	call   800a8a <syscall>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c6f:	6a 00                	push   $0x0
  800c71:	6a 00                	push   $0x0
  800c73:	6a 00                	push   $0x0
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c85:	e8 00 fe ff ff       	call   800a8a <syscall>
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c8c:	f3 0f 1e fb          	endbr32 
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c96:	6a 00                	push   $0x0
  800c98:	ff 75 14             	pushl  0x14(%ebp)
  800c9b:	ff 75 10             	pushl  0x10(%ebp)
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cae:	e8 d7 fd ff ff       	call   800a8a <syscall>
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cb5:	f3 0f 1e fb          	endbr32 
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cbf:	6a 00                	push   $0x0
  800cc1:	6a 00                	push   $0x0
  800cc3:	6a 00                	push   $0x0
  800cc5:	6a 00                	push   $0x0
  800cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cca:	ba 01 00 00 00       	mov    $0x1,%edx
  800ccf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cd4:	e8 b1 fd ff ff       	call   800a8a <syscall>
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	05 00 00 00 30       	add    $0x30000000,%eax
  800cea:	c1 e8 0c             	shr    $0xc,%eax
}
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800cef:	f3 0f 1e fb          	endbr32 
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 da ff ff ff       	call   800cdb <fd2num>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	c1 e0 0c             	shl    $0xc,%eax
  800d07:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d0e:	f3 0f 1e fb          	endbr32 
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d1a:	89 c2                	mov    %eax,%edx
  800d1c:	c1 ea 16             	shr    $0x16,%edx
  800d1f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d26:	f6 c2 01             	test   $0x1,%dl
  800d29:	74 2d                	je     800d58 <fd_alloc+0x4a>
  800d2b:	89 c2                	mov    %eax,%edx
  800d2d:	c1 ea 0c             	shr    $0xc,%edx
  800d30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d37:	f6 c2 01             	test   $0x1,%dl
  800d3a:	74 1c                	je     800d58 <fd_alloc+0x4a>
  800d3c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d41:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d46:	75 d2                	jne    800d1a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d51:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d56:	eb 0a                	jmp    800d62 <fd_alloc+0x54>
			*fd_store = fd;
  800d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d64:	f3 0f 1e fb          	endbr32 
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d6e:	83 f8 1f             	cmp    $0x1f,%eax
  800d71:	77 30                	ja     800da3 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d73:	c1 e0 0c             	shl    $0xc,%eax
  800d76:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d7b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800d81:	f6 c2 01             	test   $0x1,%dl
  800d84:	74 24                	je     800daa <fd_lookup+0x46>
  800d86:	89 c2                	mov    %eax,%edx
  800d88:	c1 ea 0c             	shr    $0xc,%edx
  800d8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d92:	f6 c2 01             	test   $0x1,%dl
  800d95:	74 1a                	je     800db1 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	89 02                	mov    %eax,(%edx)
	return 0;
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		return -E_INVAL;
  800da3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da8:	eb f7                	jmp    800da1 <fd_lookup+0x3d>
		return -E_INVAL;
  800daa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800daf:	eb f0                	jmp    800da1 <fd_lookup+0x3d>
  800db1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800db6:	eb e9                	jmp    800da1 <fd_lookup+0x3d>

00800db8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800db8:	f3 0f 1e fb          	endbr32 
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 08             	sub    $0x8,%esp
  800dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc5:	ba 88 22 80 00       	mov    $0x802288,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800dca:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800dcf:	39 08                	cmp    %ecx,(%eax)
  800dd1:	74 33                	je     800e06 <dev_lookup+0x4e>
  800dd3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800dd6:	8b 02                	mov    (%edx),%eax
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	75 f3                	jne    800dcf <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ddc:	a1 04 40 80 00       	mov    0x804004,%eax
  800de1:	8b 40 48             	mov    0x48(%eax),%eax
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	51                   	push   %ecx
  800de8:	50                   	push   %eax
  800de9:	68 0c 22 80 00       	push   $0x80220c
  800dee:	e8 b9 f3 ff ff       	call   8001ac <cprintf>
	*dev = 0;
  800df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    
			*dev = devtab[i];
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e10:	eb f2                	jmp    800e04 <dev_lookup+0x4c>

00800e12 <fd_close>:
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 28             	sub    $0x28,%esp
  800e1f:	8b 75 08             	mov    0x8(%ebp),%esi
  800e22:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e25:	56                   	push   %esi
  800e26:	e8 b0 fe ff ff       	call   800cdb <fd2num>
  800e2b:	83 c4 08             	add    $0x8,%esp
  800e2e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800e31:	52                   	push   %edx
  800e32:	50                   	push   %eax
  800e33:	e8 2c ff ff ff       	call   800d64 <fd_lookup>
  800e38:	89 c3                	mov    %eax,%ebx
  800e3a:	83 c4 10             	add    $0x10,%esp
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	78 05                	js     800e46 <fd_close+0x34>
	    || fd != fd2)
  800e41:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e44:	74 16                	je     800e5c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800e46:	89 f8                	mov    %edi,%eax
  800e48:	84 c0                	test   %al,%al
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4f:	0f 44 d8             	cmove  %eax,%ebx
}
  800e52:	89 d8                	mov    %ebx,%eax
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e62:	50                   	push   %eax
  800e63:	ff 36                	pushl  (%esi)
  800e65:	e8 4e ff ff ff       	call   800db8 <dev_lookup>
  800e6a:	89 c3                	mov    %eax,%ebx
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	78 1a                	js     800e8d <fd_close+0x7b>
		if (dev->dev_close)
  800e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e76:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	74 0b                	je     800e8d <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	56                   	push   %esi
  800e86:	ff d0                	call   *%eax
  800e88:	89 c3                	mov    %eax,%ebx
  800e8a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	56                   	push   %esi
  800e91:	6a 00                	push   $0x0
  800e93:	e8 58 fd ff ff       	call   800bf0 <sys_page_unmap>
	return r;
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	eb b5                	jmp    800e52 <fd_close+0x40>

00800e9d <close>:

int
close(int fdnum)
{
  800e9d:	f3 0f 1e fb          	endbr32 
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ea7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	ff 75 08             	pushl  0x8(%ebp)
  800eae:	e8 b1 fe ff ff       	call   800d64 <fd_lookup>
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	79 02                	jns    800ebc <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    
		return fd_close(fd, 1);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	6a 01                	push   $0x1
  800ec1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ec4:	e8 49 ff ff ff       	call   800e12 <fd_close>
  800ec9:	83 c4 10             	add    $0x10,%esp
  800ecc:	eb ec                	jmp    800eba <close+0x1d>

00800ece <close_all>:

void
close_all(void)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	53                   	push   %ebx
  800ee2:	e8 b6 ff ff ff       	call   800e9d <close>
	for (i = 0; i < MAXFD; i++)
  800ee7:	83 c3 01             	add    $0x1,%ebx
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	83 fb 20             	cmp    $0x20,%ebx
  800ef0:	75 ec                	jne    800ede <close_all+0x10>
}
  800ef2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ef7:	f3 0f 1e fb          	endbr32 
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f07:	50                   	push   %eax
  800f08:	ff 75 08             	pushl  0x8(%ebp)
  800f0b:	e8 54 fe ff ff       	call   800d64 <fd_lookup>
  800f10:	89 c3                	mov    %eax,%ebx
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	85 c0                	test   %eax,%eax
  800f17:	0f 88 81 00 00 00    	js     800f9e <dup+0xa7>
		return r;
	close(newfdnum);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	e8 75 ff ff ff       	call   800e9d <close>

	newfd = INDEX2FD(newfdnum);
  800f28:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f2b:	c1 e6 0c             	shl    $0xc,%esi
  800f2e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f34:	83 c4 04             	add    $0x4,%esp
  800f37:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3a:	e8 b0 fd ff ff       	call   800cef <fd2data>
  800f3f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f41:	89 34 24             	mov    %esi,(%esp)
  800f44:	e8 a6 fd ff ff       	call   800cef <fd2data>
  800f49:	83 c4 10             	add    $0x10,%esp
  800f4c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f4e:	89 d8                	mov    %ebx,%eax
  800f50:	c1 e8 16             	shr    $0x16,%eax
  800f53:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f5a:	a8 01                	test   $0x1,%al
  800f5c:	74 11                	je     800f6f <dup+0x78>
  800f5e:	89 d8                	mov    %ebx,%eax
  800f60:	c1 e8 0c             	shr    $0xc,%eax
  800f63:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f6a:	f6 c2 01             	test   $0x1,%dl
  800f6d:	75 39                	jne    800fa8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f72:	89 d0                	mov    %edx,%eax
  800f74:	c1 e8 0c             	shr    $0xc,%eax
  800f77:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	25 07 0e 00 00       	and    $0xe07,%eax
  800f86:	50                   	push   %eax
  800f87:	56                   	push   %esi
  800f88:	6a 00                	push   $0x0
  800f8a:	52                   	push   %edx
  800f8b:	6a 00                	push   $0x0
  800f8d:	e8 34 fc ff ff       	call   800bc6 <sys_page_map>
  800f92:	89 c3                	mov    %eax,%ebx
  800f94:	83 c4 20             	add    $0x20,%esp
  800f97:	85 c0                	test   %eax,%eax
  800f99:	78 31                	js     800fcc <dup+0xd5>
		goto err;

	return newfdnum;
  800f9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800f9e:	89 d8                	mov    %ebx,%eax
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fa8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	25 07 0e 00 00       	and    $0xe07,%eax
  800fb7:	50                   	push   %eax
  800fb8:	57                   	push   %edi
  800fb9:	6a 00                	push   $0x0
  800fbb:	53                   	push   %ebx
  800fbc:	6a 00                	push   $0x0
  800fbe:	e8 03 fc ff ff       	call   800bc6 <sys_page_map>
  800fc3:	89 c3                	mov    %eax,%ebx
  800fc5:	83 c4 20             	add    $0x20,%esp
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	79 a3                	jns    800f6f <dup+0x78>
	sys_page_unmap(0, newfd);
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	56                   	push   %esi
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 19 fc ff ff       	call   800bf0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fd7:	83 c4 08             	add    $0x8,%esp
  800fda:	57                   	push   %edi
  800fdb:	6a 00                	push   $0x0
  800fdd:	e8 0e fc ff ff       	call   800bf0 <sys_page_unmap>
	return r;
  800fe2:	83 c4 10             	add    $0x10,%esp
  800fe5:	eb b7                	jmp    800f9e <dup+0xa7>

00800fe7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800fe7:	f3 0f 1e fb          	endbr32 
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	53                   	push   %ebx
  800fef:	83 ec 1c             	sub    $0x1c,%esp
  800ff2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ff5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ff8:	50                   	push   %eax
  800ff9:	53                   	push   %ebx
  800ffa:	e8 65 fd ff ff       	call   800d64 <fd_lookup>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	78 3f                	js     801045 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80100c:	50                   	push   %eax
  80100d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801010:	ff 30                	pushl  (%eax)
  801012:	e8 a1 fd ff ff       	call   800db8 <dev_lookup>
  801017:	83 c4 10             	add    $0x10,%esp
  80101a:	85 c0                	test   %eax,%eax
  80101c:	78 27                	js     801045 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80101e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801021:	8b 42 08             	mov    0x8(%edx),%eax
  801024:	83 e0 03             	and    $0x3,%eax
  801027:	83 f8 01             	cmp    $0x1,%eax
  80102a:	74 1e                	je     80104a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80102c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102f:	8b 40 08             	mov    0x8(%eax),%eax
  801032:	85 c0                	test   %eax,%eax
  801034:	74 35                	je     80106b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801036:	83 ec 04             	sub    $0x4,%esp
  801039:	ff 75 10             	pushl  0x10(%ebp)
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	52                   	push   %edx
  801040:	ff d0                	call   *%eax
  801042:	83 c4 10             	add    $0x10,%esp
}
  801045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801048:	c9                   	leave  
  801049:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80104a:	a1 04 40 80 00       	mov    0x804004,%eax
  80104f:	8b 40 48             	mov    0x48(%eax),%eax
  801052:	83 ec 04             	sub    $0x4,%esp
  801055:	53                   	push   %ebx
  801056:	50                   	push   %eax
  801057:	68 4d 22 80 00       	push   $0x80224d
  80105c:	e8 4b f1 ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801069:	eb da                	jmp    801045 <read+0x5e>
		return -E_NOT_SUPP;
  80106b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801070:	eb d3                	jmp    801045 <read+0x5e>

00801072 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801082:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108a:	eb 02                	jmp    80108e <readn+0x1c>
  80108c:	01 c3                	add    %eax,%ebx
  80108e:	39 f3                	cmp    %esi,%ebx
  801090:	73 21                	jae    8010b3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	89 f0                	mov    %esi,%eax
  801097:	29 d8                	sub    %ebx,%eax
  801099:	50                   	push   %eax
  80109a:	89 d8                	mov    %ebx,%eax
  80109c:	03 45 0c             	add    0xc(%ebp),%eax
  80109f:	50                   	push   %eax
  8010a0:	57                   	push   %edi
  8010a1:	e8 41 ff ff ff       	call   800fe7 <read>
		if (m < 0)
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 04                	js     8010b1 <readn+0x3f>
			return m;
		if (m == 0)
  8010ad:	75 dd                	jne    80108c <readn+0x1a>
  8010af:	eb 02                	jmp    8010b3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010b1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010b3:	89 d8                	mov    %ebx,%eax
  8010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    

008010bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010bd:	f3 0f 1e fb          	endbr32 
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 1c             	sub    $0x1c,%esp
  8010c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	53                   	push   %ebx
  8010d0:	e8 8f fc ff ff       	call   800d64 <fd_lookup>
  8010d5:	83 c4 10             	add    $0x10,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 3a                	js     801116 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010dc:	83 ec 08             	sub    $0x8,%esp
  8010df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e6:	ff 30                	pushl  (%eax)
  8010e8:	e8 cb fc ff ff       	call   800db8 <dev_lookup>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	78 22                	js     801116 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010fb:	74 1e                	je     80111b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8010fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801100:	8b 52 0c             	mov    0xc(%edx),%edx
  801103:	85 d2                	test   %edx,%edx
  801105:	74 35                	je     80113c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801107:	83 ec 04             	sub    $0x4,%esp
  80110a:	ff 75 10             	pushl  0x10(%ebp)
  80110d:	ff 75 0c             	pushl  0xc(%ebp)
  801110:	50                   	push   %eax
  801111:	ff d2                	call   *%edx
  801113:	83 c4 10             	add    $0x10,%esp
}
  801116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801119:	c9                   	leave  
  80111a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80111b:	a1 04 40 80 00       	mov    0x804004,%eax
  801120:	8b 40 48             	mov    0x48(%eax),%eax
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	53                   	push   %ebx
  801127:	50                   	push   %eax
  801128:	68 69 22 80 00       	push   $0x802269
  80112d:	e8 7a f0 ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113a:	eb da                	jmp    801116 <write+0x59>
		return -E_NOT_SUPP;
  80113c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801141:	eb d3                	jmp    801116 <write+0x59>

00801143 <seek>:

int
seek(int fdnum, off_t offset)
{
  801143:	f3 0f 1e fb          	endbr32 
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80114d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801150:	50                   	push   %eax
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 0b fc ff ff       	call   800d64 <fd_lookup>
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	85 c0                	test   %eax,%eax
  80115e:	78 0e                	js     80116e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801166:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	53                   	push   %ebx
  801178:	83 ec 1c             	sub    $0x1c,%esp
  80117b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80117e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801181:	50                   	push   %eax
  801182:	53                   	push   %ebx
  801183:	e8 dc fb ff ff       	call   800d64 <fd_lookup>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	85 c0                	test   %eax,%eax
  80118d:	78 37                	js     8011c6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801195:	50                   	push   %eax
  801196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801199:	ff 30                	pushl  (%eax)
  80119b:	e8 18 fc ff ff       	call   800db8 <dev_lookup>
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	78 1f                	js     8011c6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011ae:	74 1b                	je     8011cb <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 52 18             	mov    0x18(%edx),%edx
  8011b6:	85 d2                	test   %edx,%edx
  8011b8:	74 32                	je     8011ec <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	50                   	push   %eax
  8011c1:	ff d2                	call   *%edx
  8011c3:	83 c4 10             	add    $0x10,%esp
}
  8011c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011cb:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011d0:	8b 40 48             	mov    0x48(%eax),%eax
  8011d3:	83 ec 04             	sub    $0x4,%esp
  8011d6:	53                   	push   %ebx
  8011d7:	50                   	push   %eax
  8011d8:	68 2c 22 80 00       	push   $0x80222c
  8011dd:	e8 ca ef ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ea:	eb da                	jmp    8011c6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8011ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011f1:	eb d3                	jmp    8011c6 <ftruncate+0x56>

008011f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011f3:	f3 0f 1e fb          	endbr32 
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 1c             	sub    $0x1c,%esp
  8011fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801201:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801204:	50                   	push   %eax
  801205:	ff 75 08             	pushl  0x8(%ebp)
  801208:	e8 57 fb ff ff       	call   800d64 <fd_lookup>
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	85 c0                	test   %eax,%eax
  801212:	78 4b                	js     80125f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121a:	50                   	push   %eax
  80121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121e:	ff 30                	pushl  (%eax)
  801220:	e8 93 fb ff ff       	call   800db8 <dev_lookup>
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 33                	js     80125f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801233:	74 2f                	je     801264 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801235:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801238:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80123f:	00 00 00 
	stat->st_isdir = 0;
  801242:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801249:	00 00 00 
	stat->st_dev = dev;
  80124c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801252:	83 ec 08             	sub    $0x8,%esp
  801255:	53                   	push   %ebx
  801256:	ff 75 f0             	pushl  -0x10(%ebp)
  801259:	ff 50 14             	call   *0x14(%eax)
  80125c:	83 c4 10             	add    $0x10,%esp
}
  80125f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801262:	c9                   	leave  
  801263:	c3                   	ret    
		return -E_NOT_SUPP;
  801264:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801269:	eb f4                	jmp    80125f <fstat+0x6c>

0080126b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	6a 00                	push   $0x0
  801279:	ff 75 08             	pushl  0x8(%ebp)
  80127c:	e8 3a 02 00 00       	call   8014bb <open>
  801281:	89 c3                	mov    %eax,%ebx
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	78 1b                	js     8012a5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	50                   	push   %eax
  801291:	e8 5d ff ff ff       	call   8011f3 <fstat>
  801296:	89 c6                	mov    %eax,%esi
	close(fd);
  801298:	89 1c 24             	mov    %ebx,(%esp)
  80129b:	e8 fd fb ff ff       	call   800e9d <close>
	return r;
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	89 f3                	mov    %esi,%ebx
}
  8012a5:	89 d8                	mov    %ebx,%eax
  8012a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	56                   	push   %esi
  8012b2:	53                   	push   %ebx
  8012b3:	89 c6                	mov    %eax,%esi
  8012b5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012b7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012be:	74 27                	je     8012e7 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012c0:	6a 07                	push   $0x7
  8012c2:	68 00 50 80 00       	push   $0x805000
  8012c7:	56                   	push   %esi
  8012c8:	ff 35 00 40 80 00    	pushl  0x804000
  8012ce:	e8 47 08 00 00       	call   801b1a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012d3:	83 c4 0c             	add    $0xc,%esp
  8012d6:	6a 00                	push   $0x0
  8012d8:	53                   	push   %ebx
  8012d9:	6a 00                	push   $0x0
  8012db:	e8 cd 07 00 00       	call   801aad <ipc_recv>
}
  8012e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	6a 01                	push   $0x1
  8012ec:	e8 81 08 00 00       	call   801b72 <ipc_find_env>
  8012f1:	a3 00 40 80 00       	mov    %eax,0x804000
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	eb c5                	jmp    8012c0 <fsipc+0x12>

008012fb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012fb:	f3 0f 1e fb          	endbr32 
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8b 40 0c             	mov    0xc(%eax),%eax
  80130b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801318:	ba 00 00 00 00       	mov    $0x0,%edx
  80131d:	b8 02 00 00 00       	mov    $0x2,%eax
  801322:	e8 87 ff ff ff       	call   8012ae <fsipc>
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <devfile_flush>:
{
  801329:	f3 0f 1e fb          	endbr32 
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8b 40 0c             	mov    0xc(%eax),%eax
  801339:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80133e:	ba 00 00 00 00       	mov    $0x0,%edx
  801343:	b8 06 00 00 00       	mov    $0x6,%eax
  801348:	e8 61 ff ff ff       	call   8012ae <fsipc>
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <devfile_stat>:
{
  80134f:	f3 0f 1e fb          	endbr32 
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	53                   	push   %ebx
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8b 40 0c             	mov    0xc(%eax),%eax
  801363:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801368:	ba 00 00 00 00       	mov    $0x0,%edx
  80136d:	b8 05 00 00 00       	mov    $0x5,%eax
  801372:	e8 37 ff ff ff       	call   8012ae <fsipc>
  801377:	85 c0                	test   %eax,%eax
  801379:	78 2c                	js     8013a7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	68 00 50 80 00       	push   $0x805000
  801383:	53                   	push   %ebx
  801384:	e8 8d f3 ff ff       	call   800716 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801389:	a1 80 50 80 00       	mov    0x805080,%eax
  80138e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801394:	a1 84 50 80 00       	mov    0x805084,%eax
  801399:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <devfile_write>:
{
  8013ac:	f3 0f 1e fb          	endbr32 
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8013c5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8013cb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8013d1:	77 30                	ja     801403 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	53                   	push   %ebx
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	68 08 50 80 00       	push   $0x805008
  8013df:	e8 ea f4 ff ff       	call   8008ce <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8013ee:	e8 bb fe ff ff       	call   8012ae <fsipc>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 04                	js     8013fe <devfile_write+0x52>
	assert(r <= n);
  8013fa:	39 d8                	cmp    %ebx,%eax
  8013fc:	77 1e                	ja     80141c <devfile_write+0x70>
}
  8013fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801401:	c9                   	leave  
  801402:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801403:	68 98 22 80 00       	push   $0x802298
  801408:	68 c5 22 80 00       	push   $0x8022c5
  80140d:	68 94 00 00 00       	push   $0x94
  801412:	68 da 22 80 00       	push   $0x8022da
  801417:	e8 47 06 00 00       	call   801a63 <_panic>
	assert(r <= n);
  80141c:	68 e5 22 80 00       	push   $0x8022e5
  801421:	68 c5 22 80 00       	push   $0x8022c5
  801426:	68 98 00 00 00       	push   $0x98
  80142b:	68 da 22 80 00       	push   $0x8022da
  801430:	e8 2e 06 00 00       	call   801a63 <_panic>

00801435 <devfile_read>:
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8b 40 0c             	mov    0xc(%eax),%eax
  801447:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80144c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801452:	ba 00 00 00 00       	mov    $0x0,%edx
  801457:	b8 03 00 00 00       	mov    $0x3,%eax
  80145c:	e8 4d fe ff ff       	call   8012ae <fsipc>
  801461:	89 c3                	mov    %eax,%ebx
  801463:	85 c0                	test   %eax,%eax
  801465:	78 1f                	js     801486 <devfile_read+0x51>
	assert(r <= n);
  801467:	39 f0                	cmp    %esi,%eax
  801469:	77 24                	ja     80148f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80146b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801470:	7f 33                	jg     8014a5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	50                   	push   %eax
  801476:	68 00 50 80 00       	push   $0x805000
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	e8 4b f4 ff ff       	call   8008ce <memmove>
	return r;
  801483:	83 c4 10             	add    $0x10,%esp
}
  801486:	89 d8                	mov    %ebx,%eax
  801488:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148b:	5b                   	pop    %ebx
  80148c:	5e                   	pop    %esi
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    
	assert(r <= n);
  80148f:	68 e5 22 80 00       	push   $0x8022e5
  801494:	68 c5 22 80 00       	push   $0x8022c5
  801499:	6a 7c                	push   $0x7c
  80149b:	68 da 22 80 00       	push   $0x8022da
  8014a0:	e8 be 05 00 00       	call   801a63 <_panic>
	assert(r <= PGSIZE);
  8014a5:	68 ec 22 80 00       	push   $0x8022ec
  8014aa:	68 c5 22 80 00       	push   $0x8022c5
  8014af:	6a 7d                	push   $0x7d
  8014b1:	68 da 22 80 00       	push   $0x8022da
  8014b6:	e8 a8 05 00 00       	call   801a63 <_panic>

008014bb <open>:
{
  8014bb:	f3 0f 1e fb          	endbr32 
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 1c             	sub    $0x1c,%esp
  8014c7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014ca:	56                   	push   %esi
  8014cb:	e8 03 f2 ff ff       	call   8006d3 <strlen>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014d8:	7f 6c                	jg     801546 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8014da:	83 ec 0c             	sub    $0xc,%esp
  8014dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 28 f8 ff ff       	call   800d0e <fd_alloc>
  8014e6:	89 c3                	mov    %eax,%ebx
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 3c                	js     80152b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	56                   	push   %esi
  8014f3:	68 00 50 80 00       	push   $0x805000
  8014f8:	e8 19 f2 ff ff       	call   800716 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801508:	b8 01 00 00 00       	mov    $0x1,%eax
  80150d:	e8 9c fd ff ff       	call   8012ae <fsipc>
  801512:	89 c3                	mov    %eax,%ebx
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 19                	js     801534 <open+0x79>
	return fd2num(fd);
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	ff 75 f4             	pushl  -0xc(%ebp)
  801521:	e8 b5 f7 ff ff       	call   800cdb <fd2num>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
}
  80152b:	89 d8                	mov    %ebx,%eax
  80152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    
		fd_close(fd, 0);
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	6a 00                	push   $0x0
  801539:	ff 75 f4             	pushl  -0xc(%ebp)
  80153c:	e8 d1 f8 ff ff       	call   800e12 <fd_close>
		return r;
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	eb e5                	jmp    80152b <open+0x70>
		return -E_BAD_PATH;
  801546:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80154b:	eb de                	jmp    80152b <open+0x70>

0080154d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80154d:	f3 0f 1e fb          	endbr32 
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	b8 08 00 00 00       	mov    $0x8,%eax
  801561:	e8 48 fd ff ff       	call   8012ae <fsipc>
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801568:	f3 0f 1e fb          	endbr32 
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	e8 70 f7 ff ff       	call   800cef <fd2data>
  80157f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801581:	83 c4 08             	add    $0x8,%esp
  801584:	68 f8 22 80 00       	push   $0x8022f8
  801589:	53                   	push   %ebx
  80158a:	e8 87 f1 ff ff       	call   800716 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80158f:	8b 46 04             	mov    0x4(%esi),%eax
  801592:	2b 06                	sub    (%esi),%eax
  801594:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80159a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a1:	00 00 00 
	stat->st_dev = &devpipe;
  8015a4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015ab:	30 80 00 
	return 0;
}
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015ba:	f3 0f 1e fb          	endbr32 
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015c8:	53                   	push   %ebx
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 20 f6 ff ff       	call   800bf0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015d0:	89 1c 24             	mov    %ebx,(%esp)
  8015d3:	e8 17 f7 ff ff       	call   800cef <fd2data>
  8015d8:	83 c4 08             	add    $0x8,%esp
  8015db:	50                   	push   %eax
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 0d f6 ff ff       	call   800bf0 <sys_page_unmap>
}
  8015e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <_pipeisclosed>:
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	57                   	push   %edi
  8015ec:	56                   	push   %esi
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 1c             	sub    $0x1c,%esp
  8015f1:	89 c7                	mov    %eax,%edi
  8015f3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015fa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	57                   	push   %edi
  801601:	e8 a9 05 00 00       	call   801baf <pageref>
  801606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801609:	89 34 24             	mov    %esi,(%esp)
  80160c:	e8 9e 05 00 00       	call   801baf <pageref>
		nn = thisenv->env_runs;
  801611:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801617:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	39 cb                	cmp    %ecx,%ebx
  80161f:	74 1b                	je     80163c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801621:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801624:	75 cf                	jne    8015f5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801626:	8b 42 58             	mov    0x58(%edx),%eax
  801629:	6a 01                	push   $0x1
  80162b:	50                   	push   %eax
  80162c:	53                   	push   %ebx
  80162d:	68 ff 22 80 00       	push   $0x8022ff
  801632:	e8 75 eb ff ff       	call   8001ac <cprintf>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	eb b9                	jmp    8015f5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80163c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80163f:	0f 94 c0             	sete   %al
  801642:	0f b6 c0             	movzbl %al,%eax
}
  801645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801648:	5b                   	pop    %ebx
  801649:	5e                   	pop    %esi
  80164a:	5f                   	pop    %edi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <devpipe_write>:
{
  80164d:	f3 0f 1e fb          	endbr32 
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	57                   	push   %edi
  801655:	56                   	push   %esi
  801656:	53                   	push   %ebx
  801657:	83 ec 28             	sub    $0x28,%esp
  80165a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80165d:	56                   	push   %esi
  80165e:	e8 8c f6 ff ff       	call   800cef <fd2data>
  801663:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	bf 00 00 00 00       	mov    $0x0,%edi
  80166d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801670:	74 4f                	je     8016c1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801672:	8b 43 04             	mov    0x4(%ebx),%eax
  801675:	8b 0b                	mov    (%ebx),%ecx
  801677:	8d 51 20             	lea    0x20(%ecx),%edx
  80167a:	39 d0                	cmp    %edx,%eax
  80167c:	72 14                	jb     801692 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80167e:	89 da                	mov    %ebx,%edx
  801680:	89 f0                	mov    %esi,%eax
  801682:	e8 61 ff ff ff       	call   8015e8 <_pipeisclosed>
  801687:	85 c0                	test   %eax,%eax
  801689:	75 3b                	jne    8016c6 <devpipe_write+0x79>
			sys_yield();
  80168b:	e8 e3 f4 ff ff       	call   800b73 <sys_yield>
  801690:	eb e0                	jmp    801672 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801692:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801695:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801699:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	c1 fa 1f             	sar    $0x1f,%edx
  8016a1:	89 d1                	mov    %edx,%ecx
  8016a3:	c1 e9 1b             	shr    $0x1b,%ecx
  8016a6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016a9:	83 e2 1f             	and    $0x1f,%edx
  8016ac:	29 ca                	sub    %ecx,%edx
  8016ae:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016b6:	83 c0 01             	add    $0x1,%eax
  8016b9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8016bc:	83 c7 01             	add    $0x1,%edi
  8016bf:	eb ac                	jmp    80166d <devpipe_write+0x20>
	return i;
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	eb 05                	jmp    8016cb <devpipe_write+0x7e>
				return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5f                   	pop    %edi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <devpipe_read>:
{
  8016d3:	f3 0f 1e fb          	endbr32 
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	57                   	push   %edi
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 18             	sub    $0x18,%esp
  8016e0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016e3:	57                   	push   %edi
  8016e4:	e8 06 f6 ff ff       	call   800cef <fd2data>
  8016e9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	be 00 00 00 00       	mov    $0x0,%esi
  8016f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016f6:	75 14                	jne    80170c <devpipe_read+0x39>
	return i;
  8016f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fb:	eb 02                	jmp    8016ff <devpipe_read+0x2c>
				return i;
  8016fd:	89 f0                	mov    %esi,%eax
}
  8016ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
			sys_yield();
  801707:	e8 67 f4 ff ff       	call   800b73 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80170c:	8b 03                	mov    (%ebx),%eax
  80170e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801711:	75 18                	jne    80172b <devpipe_read+0x58>
			if (i > 0)
  801713:	85 f6                	test   %esi,%esi
  801715:	75 e6                	jne    8016fd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801717:	89 da                	mov    %ebx,%edx
  801719:	89 f8                	mov    %edi,%eax
  80171b:	e8 c8 fe ff ff       	call   8015e8 <_pipeisclosed>
  801720:	85 c0                	test   %eax,%eax
  801722:	74 e3                	je     801707 <devpipe_read+0x34>
				return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
  801729:	eb d4                	jmp    8016ff <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80172b:	99                   	cltd   
  80172c:	c1 ea 1b             	shr    $0x1b,%edx
  80172f:	01 d0                	add    %edx,%eax
  801731:	83 e0 1f             	and    $0x1f,%eax
  801734:	29 d0                	sub    %edx,%eax
  801736:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80173b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801741:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801744:	83 c6 01             	add    $0x1,%esi
  801747:	eb aa                	jmp    8016f3 <devpipe_read+0x20>

00801749 <pipe>:
{
  801749:	f3 0f 1e fb          	endbr32 
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	e8 b0 f5 ff ff       	call   800d0e <fd_alloc>
  80175e:	89 c3                	mov    %eax,%ebx
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	0f 88 23 01 00 00    	js     80188e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	68 07 04 00 00       	push   $0x407
  801773:	ff 75 f4             	pushl  -0xc(%ebp)
  801776:	6a 00                	push   $0x0
  801778:	e8 21 f4 ff ff       	call   800b9e <sys_page_alloc>
  80177d:	89 c3                	mov    %eax,%ebx
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	0f 88 04 01 00 00    	js     80188e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801790:	50                   	push   %eax
  801791:	e8 78 f5 ff ff       	call   800d0e <fd_alloc>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	0f 88 db 00 00 00    	js     80187e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 07 04 00 00       	push   $0x407
  8017ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ae:	6a 00                	push   $0x0
  8017b0:	e8 e9 f3 ff ff       	call   800b9e <sys_page_alloc>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	0f 88 bc 00 00 00    	js     80187e <pipe+0x135>
	va = fd2data(fd0);
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c8:	e8 22 f5 ff ff       	call   800cef <fd2data>
  8017cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017cf:	83 c4 0c             	add    $0xc,%esp
  8017d2:	68 07 04 00 00       	push   $0x407
  8017d7:	50                   	push   %eax
  8017d8:	6a 00                	push   $0x0
  8017da:	e8 bf f3 ff ff       	call   800b9e <sys_page_alloc>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	0f 88 82 00 00 00    	js     80186e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f2:	e8 f8 f4 ff ff       	call   800cef <fd2data>
  8017f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017fe:	50                   	push   %eax
  8017ff:	6a 00                	push   $0x0
  801801:	56                   	push   %esi
  801802:	6a 00                	push   $0x0
  801804:	e8 bd f3 ff ff       	call   800bc6 <sys_page_map>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 20             	add    $0x20,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 4e                	js     801860 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801812:	a1 20 30 80 00       	mov    0x803020,%eax
  801817:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80181c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801829:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff 75 f4             	pushl  -0xc(%ebp)
  80183b:	e8 9b f4 ff ff       	call   800cdb <fd2num>
  801840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801843:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801845:	83 c4 04             	add    $0x4,%esp
  801848:	ff 75 f0             	pushl  -0x10(%ebp)
  80184b:	e8 8b f4 ff ff       	call   800cdb <fd2num>
  801850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801853:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185e:	eb 2e                	jmp    80188e <pipe+0x145>
	sys_page_unmap(0, va);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	56                   	push   %esi
  801864:	6a 00                	push   $0x0
  801866:	e8 85 f3 ff ff       	call   800bf0 <sys_page_unmap>
  80186b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 f0             	pushl  -0x10(%ebp)
  801874:	6a 00                	push   $0x0
  801876:	e8 75 f3 ff ff       	call   800bf0 <sys_page_unmap>
  80187b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	ff 75 f4             	pushl  -0xc(%ebp)
  801884:	6a 00                	push   $0x0
  801886:	e8 65 f3 ff ff       	call   800bf0 <sys_page_unmap>
  80188b:	83 c4 10             	add    $0x10,%esp
}
  80188e:	89 d8                	mov    %ebx,%eax
  801890:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <pipeisclosed>:
{
  801897:	f3 0f 1e fb          	endbr32 
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a4:	50                   	push   %eax
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	e8 b7 f4 ff ff       	call   800d64 <fd_lookup>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 18                	js     8018cc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ba:	e8 30 f4 ff ff       	call   800cef <fd2data>
  8018bf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8018c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c4:	e8 1f fd ff ff       	call   8015e8 <_pipeisclosed>
  8018c9:	83 c4 10             	add    $0x10,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018ce:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	c3                   	ret    

008018d8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018e2:	68 17 23 80 00       	push   $0x802317
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 27 ee ff ff       	call   800716 <strcpy>
	return 0;
}
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <devcons_write>:
{
  8018f6:	f3 0f 1e fb          	endbr32 
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	57                   	push   %edi
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
  801900:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801906:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80190b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801911:	3b 75 10             	cmp    0x10(%ebp),%esi
  801914:	73 31                	jae    801947 <devcons_write+0x51>
		m = n - tot;
  801916:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801919:	29 f3                	sub    %esi,%ebx
  80191b:	83 fb 7f             	cmp    $0x7f,%ebx
  80191e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801923:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	53                   	push   %ebx
  80192a:	89 f0                	mov    %esi,%eax
  80192c:	03 45 0c             	add    0xc(%ebp),%eax
  80192f:	50                   	push   %eax
  801930:	57                   	push   %edi
  801931:	e8 98 ef ff ff       	call   8008ce <memmove>
		sys_cputs(buf, m);
  801936:	83 c4 08             	add    $0x8,%esp
  801939:	53                   	push   %ebx
  80193a:	57                   	push   %edi
  80193b:	e8 93 f1 ff ff       	call   800ad3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801940:	01 de                	add    %ebx,%esi
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	eb ca                	jmp    801911 <devcons_write+0x1b>
}
  801947:	89 f0                	mov    %esi,%eax
  801949:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194c:	5b                   	pop    %ebx
  80194d:	5e                   	pop    %esi
  80194e:	5f                   	pop    %edi
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    

00801951 <devcons_read>:
{
  801951:	f3 0f 1e fb          	endbr32 
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801960:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801964:	74 21                	je     801987 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801966:	e8 92 f1 ff ff       	call   800afd <sys_cgetc>
  80196b:	85 c0                	test   %eax,%eax
  80196d:	75 07                	jne    801976 <devcons_read+0x25>
		sys_yield();
  80196f:	e8 ff f1 ff ff       	call   800b73 <sys_yield>
  801974:	eb f0                	jmp    801966 <devcons_read+0x15>
	if (c < 0)
  801976:	78 0f                	js     801987 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801978:	83 f8 04             	cmp    $0x4,%eax
  80197b:	74 0c                	je     801989 <devcons_read+0x38>
	*(char*)vbuf = c;
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	88 02                	mov    %al,(%edx)
	return 1;
  801982:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    
		return 0;
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	eb f7                	jmp    801987 <devcons_read+0x36>

00801990 <cputchar>:
{
  801990:	f3 0f 1e fb          	endbr32 
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019a0:	6a 01                	push   $0x1
  8019a2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019a5:	50                   	push   %eax
  8019a6:	e8 28 f1 ff ff       	call   800ad3 <sys_cputs>
}
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <getchar>:
{
  8019b0:	f3 0f 1e fb          	endbr32 
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8019ba:	6a 01                	push   $0x1
  8019bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019bf:	50                   	push   %eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 20 f6 ff ff       	call   800fe7 <read>
	if (r < 0)
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 06                	js     8019d4 <getchar+0x24>
	if (r < 1)
  8019ce:	74 06                	je     8019d6 <getchar+0x26>
	return c;
  8019d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    
		return -E_EOF;
  8019d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8019db:	eb f7                	jmp    8019d4 <getchar+0x24>

008019dd <iscons>:
{
  8019dd:	f3 0f 1e fb          	endbr32 
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ea:	50                   	push   %eax
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	e8 71 f3 ff ff       	call   800d64 <fd_lookup>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 11                	js     801a0b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a03:	39 10                	cmp    %edx,(%eax)
  801a05:	0f 94 c0             	sete   %al
  801a08:	0f b6 c0             	movzbl %al,%eax
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <opencons>:
{
  801a0d:	f3 0f 1e fb          	endbr32 
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1a:	50                   	push   %eax
  801a1b:	e8 ee f2 ff ff       	call   800d0e <fd_alloc>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 3a                	js     801a61 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	68 07 04 00 00       	push   $0x407
  801a2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a32:	6a 00                	push   $0x0
  801a34:	e8 65 f1 ff ff       	call   800b9e <sys_page_alloc>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 21                	js     801a61 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a43:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a49:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	50                   	push   %eax
  801a59:	e8 7d f2 ff ff       	call   800cdb <fd2num>
  801a5e:	83 c4 10             	add    $0x10,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a63:	f3 0f 1e fb          	endbr32 
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a6c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a6f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a75:	e8 d1 f0 ff ff       	call   800b4b <sys_getenvid>
  801a7a:	83 ec 0c             	sub    $0xc,%esp
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	ff 75 08             	pushl  0x8(%ebp)
  801a83:	56                   	push   %esi
  801a84:	50                   	push   %eax
  801a85:	68 24 23 80 00       	push   $0x802324
  801a8a:	e8 1d e7 ff ff       	call   8001ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a8f:	83 c4 18             	add    $0x18,%esp
  801a92:	53                   	push   %ebx
  801a93:	ff 75 10             	pushl  0x10(%ebp)
  801a96:	e8 bc e6 ff ff       	call   800157 <vcprintf>
	cprintf("\n");
  801a9b:	c7 04 24 62 23 80 00 	movl   $0x802362,(%esp)
  801aa2:	e8 05 e7 ff ff       	call   8001ac <cprintf>
  801aa7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801aaa:	cc                   	int3   
  801aab:	eb fd                	jmp    801aaa <_panic+0x47>

00801aad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801aad:	f3 0f 1e fb          	endbr32 
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ac6:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 e3 f1 ff ff       	call   800cb5 <sys_ipc_recv>
	if (r < 0) {
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 2b                	js     801b04 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801ad9:	85 f6                	test   %esi,%esi
  801adb:	74 0a                	je     801ae7 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801add:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae2:	8b 40 74             	mov    0x74(%eax),%eax
  801ae5:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801ae7:	85 db                	test   %ebx,%ebx
  801ae9:	74 0a                	je     801af5 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801aeb:	a1 04 40 80 00       	mov    0x804004,%eax
  801af0:	8b 40 78             	mov    0x78(%eax),%eax
  801af3:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801af5:	a1 04 40 80 00       	mov    0x804004,%eax
  801afa:	8b 40 70             	mov    0x70(%eax),%eax
}
  801afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
		if (from_env_store) {
  801b04:	85 f6                	test   %esi,%esi
  801b06:	74 06                	je     801b0e <ipc_recv+0x61>
			*from_env_store = 0;
  801b08:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b0e:	85 db                	test   %ebx,%ebx
  801b10:	74 eb                	je     801afd <ipc_recv+0x50>
			*perm_store = 0;
  801b12:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b18:	eb e3                	jmp    801afd <ipc_recv+0x50>

00801b1a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b1a:	f3 0f 1e fb          	endbr32 
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b30:	85 db                	test   %ebx,%ebx
  801b32:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b37:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b3a:	ff 75 14             	pushl  0x14(%ebp)
  801b3d:	53                   	push   %ebx
  801b3e:	56                   	push   %esi
  801b3f:	57                   	push   %edi
  801b40:	e8 47 f1 ff ff       	call   800c8c <sys_ipc_try_send>
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b4b:	75 07                	jne    801b54 <ipc_send+0x3a>
		sys_yield();
  801b4d:	e8 21 f0 ff ff       	call   800b73 <sys_yield>
  801b52:	eb e6                	jmp    801b3a <ipc_send+0x20>
	}

	if (ret < 0) {
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 08                	js     801b60 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b60:	50                   	push   %eax
  801b61:	68 47 23 80 00       	push   $0x802347
  801b66:	6a 48                	push   $0x48
  801b68:	68 64 23 80 00       	push   $0x802364
  801b6d:	e8 f1 fe ff ff       	call   801a63 <_panic>

00801b72 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b72:	f3 0f 1e fb          	endbr32 
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b81:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b84:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b8a:	8b 52 50             	mov    0x50(%edx),%edx
  801b8d:	39 ca                	cmp    %ecx,%edx
  801b8f:	74 11                	je     801ba2 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b91:	83 c0 01             	add    $0x1,%eax
  801b94:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b99:	75 e6                	jne    801b81 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	eb 0b                	jmp    801bad <ipc_find_env+0x3b>
			return envs[i].env_id;
  801ba2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ba5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801baa:	8b 40 48             	mov    0x48(%eax),%eax
}
  801bad:	5d                   	pop    %ebp
  801bae:	c3                   	ret    

00801baf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801baf:	f3 0f 1e fb          	endbr32 
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bb9:	89 c2                	mov    %eax,%edx
  801bbb:	c1 ea 16             	shr    $0x16,%edx
  801bbe:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801bc5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801bca:	f6 c1 01             	test   $0x1,%cl
  801bcd:	74 1c                	je     801beb <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801bcf:	c1 e8 0c             	shr    $0xc,%eax
  801bd2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801bd9:	a8 01                	test   $0x1,%al
  801bdb:	74 0e                	je     801beb <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801bdd:	c1 e8 0c             	shr    $0xc,%eax
  801be0:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801be7:	ef 
  801be8:	0f b7 d2             	movzwl %dx,%edx
}
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
  801bef:	90                   	nop

00801bf0 <__udivdi3>:
  801bf0:	f3 0f 1e fb          	endbr32 
  801bf4:	55                   	push   %ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 1c             	sub    $0x1c,%esp
  801bfb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	75 19                	jne    801c28 <__udivdi3+0x38>
  801c0f:	39 f3                	cmp    %esi,%ebx
  801c11:	76 4d                	jbe    801c60 <__udivdi3+0x70>
  801c13:	31 ff                	xor    %edi,%edi
  801c15:	89 e8                	mov    %ebp,%eax
  801c17:	89 f2                	mov    %esi,%edx
  801c19:	f7 f3                	div    %ebx
  801c1b:	89 fa                	mov    %edi,%edx
  801c1d:	83 c4 1c             	add    $0x1c,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
  801c25:	8d 76 00             	lea    0x0(%esi),%esi
  801c28:	39 f2                	cmp    %esi,%edx
  801c2a:	76 14                	jbe    801c40 <__udivdi3+0x50>
  801c2c:	31 ff                	xor    %edi,%edi
  801c2e:	31 c0                	xor    %eax,%eax
  801c30:	89 fa                	mov    %edi,%edx
  801c32:	83 c4 1c             	add    $0x1c,%esp
  801c35:	5b                   	pop    %ebx
  801c36:	5e                   	pop    %esi
  801c37:	5f                   	pop    %edi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    
  801c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c40:	0f bd fa             	bsr    %edx,%edi
  801c43:	83 f7 1f             	xor    $0x1f,%edi
  801c46:	75 48                	jne    801c90 <__udivdi3+0xa0>
  801c48:	39 f2                	cmp    %esi,%edx
  801c4a:	72 06                	jb     801c52 <__udivdi3+0x62>
  801c4c:	31 c0                	xor    %eax,%eax
  801c4e:	39 eb                	cmp    %ebp,%ebx
  801c50:	77 de                	ja     801c30 <__udivdi3+0x40>
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	eb d7                	jmp    801c30 <__udivdi3+0x40>
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	89 d9                	mov    %ebx,%ecx
  801c62:	85 db                	test   %ebx,%ebx
  801c64:	75 0b                	jne    801c71 <__udivdi3+0x81>
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	31 d2                	xor    %edx,%edx
  801c6d:	f7 f3                	div    %ebx
  801c6f:	89 c1                	mov    %eax,%ecx
  801c71:	31 d2                	xor    %edx,%edx
  801c73:	89 f0                	mov    %esi,%eax
  801c75:	f7 f1                	div    %ecx
  801c77:	89 c6                	mov    %eax,%esi
  801c79:	89 e8                	mov    %ebp,%eax
  801c7b:	89 f7                	mov    %esi,%edi
  801c7d:	f7 f1                	div    %ecx
  801c7f:	89 fa                	mov    %edi,%edx
  801c81:	83 c4 1c             	add    $0x1c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c90:	89 f9                	mov    %edi,%ecx
  801c92:	b8 20 00 00 00       	mov    $0x20,%eax
  801c97:	29 f8                	sub    %edi,%eax
  801c99:	d3 e2                	shl    %cl,%edx
  801c9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c9f:	89 c1                	mov    %eax,%ecx
  801ca1:	89 da                	mov    %ebx,%edx
  801ca3:	d3 ea                	shr    %cl,%edx
  801ca5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ca9:	09 d1                	or     %edx,%ecx
  801cab:	89 f2                	mov    %esi,%edx
  801cad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	d3 e3                	shl    %cl,%ebx
  801cb5:	89 c1                	mov    %eax,%ecx
  801cb7:	d3 ea                	shr    %cl,%edx
  801cb9:	89 f9                	mov    %edi,%ecx
  801cbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801cbf:	89 eb                	mov    %ebp,%ebx
  801cc1:	d3 e6                	shl    %cl,%esi
  801cc3:	89 c1                	mov    %eax,%ecx
  801cc5:	d3 eb                	shr    %cl,%ebx
  801cc7:	09 de                	or     %ebx,%esi
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	f7 74 24 08          	divl   0x8(%esp)
  801ccf:	89 d6                	mov    %edx,%esi
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	f7 64 24 0c          	mull   0xc(%esp)
  801cd7:	39 d6                	cmp    %edx,%esi
  801cd9:	72 15                	jb     801cf0 <__udivdi3+0x100>
  801cdb:	89 f9                	mov    %edi,%ecx
  801cdd:	d3 e5                	shl    %cl,%ebp
  801cdf:	39 c5                	cmp    %eax,%ebp
  801ce1:	73 04                	jae    801ce7 <__udivdi3+0xf7>
  801ce3:	39 d6                	cmp    %edx,%esi
  801ce5:	74 09                	je     801cf0 <__udivdi3+0x100>
  801ce7:	89 d8                	mov    %ebx,%eax
  801ce9:	31 ff                	xor    %edi,%edi
  801ceb:	e9 40 ff ff ff       	jmp    801c30 <__udivdi3+0x40>
  801cf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cf3:	31 ff                	xor    %edi,%edi
  801cf5:	e9 36 ff ff ff       	jmp    801c30 <__udivdi3+0x40>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	66 90                	xchg   %ax,%ax
  801cfe:	66 90                	xchg   %ax,%ax

00801d00 <__umoddi3>:
  801d00:	f3 0f 1e fb          	endbr32 
  801d04:	55                   	push   %ebp
  801d05:	57                   	push   %edi
  801d06:	56                   	push   %esi
  801d07:	53                   	push   %ebx
  801d08:	83 ec 1c             	sub    $0x1c,%esp
  801d0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d13:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	75 19                	jne    801d38 <__umoddi3+0x38>
  801d1f:	39 df                	cmp    %ebx,%edi
  801d21:	76 5d                	jbe    801d80 <__umoddi3+0x80>
  801d23:	89 f0                	mov    %esi,%eax
  801d25:	89 da                	mov    %ebx,%edx
  801d27:	f7 f7                	div    %edi
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	83 c4 1c             	add    $0x1c,%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5f                   	pop    %edi
  801d33:	5d                   	pop    %ebp
  801d34:	c3                   	ret    
  801d35:	8d 76 00             	lea    0x0(%esi),%esi
  801d38:	89 f2                	mov    %esi,%edx
  801d3a:	39 d8                	cmp    %ebx,%eax
  801d3c:	76 12                	jbe    801d50 <__umoddi3+0x50>
  801d3e:	89 f0                	mov    %esi,%eax
  801d40:	89 da                	mov    %ebx,%edx
  801d42:	83 c4 1c             	add    $0x1c,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    
  801d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d50:	0f bd e8             	bsr    %eax,%ebp
  801d53:	83 f5 1f             	xor    $0x1f,%ebp
  801d56:	75 50                	jne    801da8 <__umoddi3+0xa8>
  801d58:	39 d8                	cmp    %ebx,%eax
  801d5a:	0f 82 e0 00 00 00    	jb     801e40 <__umoddi3+0x140>
  801d60:	89 d9                	mov    %ebx,%ecx
  801d62:	39 f7                	cmp    %esi,%edi
  801d64:	0f 86 d6 00 00 00    	jbe    801e40 <__umoddi3+0x140>
  801d6a:	89 d0                	mov    %edx,%eax
  801d6c:	89 ca                	mov    %ecx,%edx
  801d6e:	83 c4 1c             	add    $0x1c,%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    
  801d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	89 fd                	mov    %edi,%ebp
  801d82:	85 ff                	test   %edi,%edi
  801d84:	75 0b                	jne    801d91 <__umoddi3+0x91>
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	31 d2                	xor    %edx,%edx
  801d8d:	f7 f7                	div    %edi
  801d8f:	89 c5                	mov    %eax,%ebp
  801d91:	89 d8                	mov    %ebx,%eax
  801d93:	31 d2                	xor    %edx,%edx
  801d95:	f7 f5                	div    %ebp
  801d97:	89 f0                	mov    %esi,%eax
  801d99:	f7 f5                	div    %ebp
  801d9b:	89 d0                	mov    %edx,%eax
  801d9d:	31 d2                	xor    %edx,%edx
  801d9f:	eb 8c                	jmp    801d2d <__umoddi3+0x2d>
  801da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801da8:	89 e9                	mov    %ebp,%ecx
  801daa:	ba 20 00 00 00       	mov    $0x20,%edx
  801daf:	29 ea                	sub    %ebp,%edx
  801db1:	d3 e0                	shl    %cl,%eax
  801db3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db7:	89 d1                	mov    %edx,%ecx
  801db9:	89 f8                	mov    %edi,%eax
  801dbb:	d3 e8                	shr    %cl,%eax
  801dbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801dc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dc5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dc9:	09 c1                	or     %eax,%ecx
  801dcb:	89 d8                	mov    %ebx,%eax
  801dcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd1:	89 e9                	mov    %ebp,%ecx
  801dd3:	d3 e7                	shl    %cl,%edi
  801dd5:	89 d1                	mov    %edx,%ecx
  801dd7:	d3 e8                	shr    %cl,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ddf:	d3 e3                	shl    %cl,%ebx
  801de1:	89 c7                	mov    %eax,%edi
  801de3:	89 d1                	mov    %edx,%ecx
  801de5:	89 f0                	mov    %esi,%eax
  801de7:	d3 e8                	shr    %cl,%eax
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	89 fa                	mov    %edi,%edx
  801ded:	d3 e6                	shl    %cl,%esi
  801def:	09 d8                	or     %ebx,%eax
  801df1:	f7 74 24 08          	divl   0x8(%esp)
  801df5:	89 d1                	mov    %edx,%ecx
  801df7:	89 f3                	mov    %esi,%ebx
  801df9:	f7 64 24 0c          	mull   0xc(%esp)
  801dfd:	89 c6                	mov    %eax,%esi
  801dff:	89 d7                	mov    %edx,%edi
  801e01:	39 d1                	cmp    %edx,%ecx
  801e03:	72 06                	jb     801e0b <__umoddi3+0x10b>
  801e05:	75 10                	jne    801e17 <__umoddi3+0x117>
  801e07:	39 c3                	cmp    %eax,%ebx
  801e09:	73 0c                	jae    801e17 <__umoddi3+0x117>
  801e0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e13:	89 d7                	mov    %edx,%edi
  801e15:	89 c6                	mov    %eax,%esi
  801e17:	89 ca                	mov    %ecx,%edx
  801e19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e1e:	29 f3                	sub    %esi,%ebx
  801e20:	19 fa                	sbb    %edi,%edx
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	d3 e0                	shl    %cl,%eax
  801e26:	89 e9                	mov    %ebp,%ecx
  801e28:	d3 eb                	shr    %cl,%ebx
  801e2a:	d3 ea                	shr    %cl,%edx
  801e2c:	09 d8                	or     %ebx,%eax
  801e2e:	83 c4 1c             	add    $0x1c,%esp
  801e31:	5b                   	pop    %ebx
  801e32:	5e                   	pop    %esi
  801e33:	5f                   	pop    %edi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    
  801e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e3d:	8d 76 00             	lea    0x0(%esi),%esi
  801e40:	29 fe                	sub    %edi,%esi
  801e42:	19 c3                	sbb    %eax,%ebx
  801e44:	89 f2                	mov    %esi,%edx
  801e46:	89 d9                	mov    %ebx,%ecx
  801e48:	e9 1d ff ff ff       	jmp    801d6a <__umoddi3+0x6a>
