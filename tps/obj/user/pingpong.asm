
obj/user/pingpong.debug:     formato del fichero elf32-i386


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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
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
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  800040:	e8 3a 10 00 00       	call   80107f <fork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 4f                	jne    80009b <umain+0x68>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	6a 00                	push   $0x0
  800054:	6a 00                	push   $0x0
  800056:	56                   	push   %esi
  800057:	e8 6f 11 00 00       	call   8011cb <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 06 0b 00 00       	call   800b6c <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 16 24 80 00       	push   $0x802416
  80006e:	e8 5a 01 00 00       	call   8001cd <cprintf>
		if (i == 10)
  800073:	83 c4 20             	add    $0x20,%esp
  800076:	83 fb 0a             	cmp    $0xa,%ebx
  800079:	74 18                	je     800093 <umain+0x60>
			return;
		i++;
  80007b:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007e:	6a 00                	push   $0x0
  800080:	6a 00                	push   $0x0
  800082:	53                   	push   %ebx
  800083:	ff 75 e4             	pushl  -0x1c(%ebp)
  800086:	e8 ad 11 00 00       	call   801238 <ipc_send>
		if (i == 10)
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 fb 0a             	cmp    $0xa,%ebx
  800091:	75 bc                	jne    80004f <umain+0x1c>
			return;
	}

}
  800093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5f                   	pop    %edi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
  80009b:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80009d:	e8 ca 0a 00 00       	call   800b6c <sys_getenvid>
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	50                   	push   %eax
  8000a7:	68 00 24 80 00       	push   $0x802400
  8000ac:	e8 1c 01 00 00       	call   8001cd <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 79 11 00 00       	call   801238 <ipc_send>
  8000bf:	83 c4 20             	add    $0x20,%esp
  8000c2:	eb 88                	jmp    80004c <umain+0x19>

008000c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000d3:	e8 94 0a 00 00       	call   800b6c <sys_getenvid>
	if (id >= 0)
  8000d8:	85 c0                	test   %eax,%eax
  8000da:	78 12                	js     8000ee <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ee:	85 db                	test   %ebx,%ebx
  8000f0:	7e 07                	jle    8000f9 <libmain+0x35>
		binaryname = argv[0];
  8000f2:	8b 06                	mov    (%esi),%eax
  8000f4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	e8 30 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800103:	e8 0a 00 00 00       	call   800112 <exit>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5d                   	pop    %ebp
  800111:	c3                   	ret    

00800112 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800112:	f3 0f 1e fb          	endbr32 
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80011c:	e8 9f 13 00 00       	call   8014c0 <close_all>
	sys_env_destroy(0);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	6a 00                	push   $0x0
  800126:	e8 1b 0a 00 00       	call   800b46 <sys_env_destroy>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800130:	f3 0f 1e fb          	endbr32 
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	53                   	push   %ebx
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013e:	8b 13                	mov    (%ebx),%edx
  800140:	8d 42 01             	lea    0x1(%edx),%eax
  800143:	89 03                	mov    %eax,(%ebx)
  800145:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800148:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80014c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800151:	74 09                	je     80015c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800153:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	68 ff 00 00 00       	push   $0xff
  800164:	8d 43 08             	lea    0x8(%ebx),%eax
  800167:	50                   	push   %eax
  800168:	e8 87 09 00 00       	call   800af4 <sys_cputs>
		b->idx = 0;
  80016d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	eb db                	jmp    800153 <putch+0x23>

00800178 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800185:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018c:	00 00 00 
	b.cnt = 0;
  80018f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800196:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800199:	ff 75 0c             	pushl  0xc(%ebp)
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a5:	50                   	push   %eax
  8001a6:	68 30 01 80 00       	push   $0x800130
  8001ab:	e8 80 01 00 00       	call   800330 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b0:	83 c4 08             	add    $0x8,%esp
  8001b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bf:	50                   	push   %eax
  8001c0:	e8 2f 09 00 00       	call   800af4 <sys_cputs>

	return b.cnt;
}
  8001c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001cd:	f3 0f 1e fb          	endbr32 
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001da:	50                   	push   %eax
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	e8 95 ff ff ff       	call   800178 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	57                   	push   %edi
  8001e9:	56                   	push   %esi
  8001ea:	53                   	push   %ebx
  8001eb:	83 ec 1c             	sub    $0x1c,%esp
  8001ee:	89 c7                	mov    %eax,%edi
  8001f0:	89 d6                	mov    %edx,%esi
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f8:	89 d1                	mov    %edx,%ecx
  8001fa:	89 c2                	mov    %eax,%edx
  8001fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800202:	8b 45 10             	mov    0x10(%ebp),%eax
  800205:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800208:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800212:	39 c2                	cmp    %eax,%edx
  800214:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800217:	72 3e                	jb     800257 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 18             	pushl  0x18(%ebp)
  80021f:	83 eb 01             	sub    $0x1,%ebx
  800222:	53                   	push   %ebx
  800223:	50                   	push   %eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022a:	ff 75 e0             	pushl  -0x20(%ebp)
  80022d:	ff 75 dc             	pushl  -0x24(%ebp)
  800230:	ff 75 d8             	pushl  -0x28(%ebp)
  800233:	e8 58 1f 00 00       	call   802190 <__udivdi3>
  800238:	83 c4 18             	add    $0x18,%esp
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	89 f2                	mov    %esi,%edx
  80023f:	89 f8                	mov    %edi,%eax
  800241:	e8 9f ff ff ff       	call   8001e5 <printnum>
  800246:	83 c4 20             	add    $0x20,%esp
  800249:	eb 13                	jmp    80025e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	56                   	push   %esi
  80024f:	ff 75 18             	pushl  0x18(%ebp)
  800252:	ff d7                	call   *%edi
  800254:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7f ed                	jg     80024b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	56                   	push   %esi
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 e4             	pushl  -0x1c(%ebp)
  800268:	ff 75 e0             	pushl  -0x20(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	ff 75 d8             	pushl  -0x28(%ebp)
  800271:	e8 2a 20 00 00       	call   8022a0 <__umoddi3>
  800276:	83 c4 14             	add    $0x14,%esp
  800279:	0f be 80 33 24 80 00 	movsbl 0x802433(%eax),%eax
  800280:	50                   	push   %eax
  800281:	ff d7                	call   *%edi
}
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80028e:	83 fa 01             	cmp    $0x1,%edx
  800291:	7f 13                	jg     8002a6 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800293:	85 d2                	test   %edx,%edx
  800295:	74 1c                	je     8002b3 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800297:	8b 10                	mov    (%eax),%edx
  800299:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029c:	89 08                	mov    %ecx,(%eax)
  80029e:	8b 02                	mov    (%edx),%eax
  8002a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a5:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002a6:	8b 10                	mov    (%eax),%edx
  8002a8:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ab:	89 08                	mov    %ecx,(%eax)
  8002ad:	8b 02                	mov    (%edx),%eax
  8002af:	8b 52 04             	mov    0x4(%edx),%edx
  8002b2:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 02                	mov    (%edx),%eax
  8002bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002c1:	c3                   	ret    

008002c2 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002c2:	83 fa 01             	cmp    $0x1,%edx
  8002c5:	7f 0f                	jg     8002d6 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8002c7:	85 d2                	test   %edx,%edx
  8002c9:	74 18                	je     8002e3 <getint+0x21>
		return va_arg(*ap, long);
  8002cb:	8b 10                	mov    (%eax),%edx
  8002cd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d0:	89 08                	mov    %ecx,(%eax)
  8002d2:	8b 02                	mov    (%edx),%eax
  8002d4:	99                   	cltd   
  8002d5:	c3                   	ret    
		return va_arg(*ap, long long);
  8002d6:	8b 10                	mov    (%eax),%edx
  8002d8:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002db:	89 08                	mov    %ecx,(%eax)
  8002dd:	8b 02                	mov    (%edx),%eax
  8002df:	8b 52 04             	mov    0x4(%edx),%edx
  8002e2:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002e3:	8b 10                	mov    (%eax),%edx
  8002e5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e8:	89 08                	mov    %ecx,(%eax)
  8002ea:	8b 02                	mov    (%edx),%eax
  8002ec:	99                   	cltd   
}
  8002ed:	c3                   	ret    

008002ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fc:	8b 10                	mov    (%eax),%edx
  8002fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800301:	73 0a                	jae    80030d <sprintputch+0x1f>
		*b->buf++ = ch;
  800303:	8d 4a 01             	lea    0x1(%edx),%ecx
  800306:	89 08                	mov    %ecx,(%eax)
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	88 02                	mov    %al,(%edx)
}
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <printfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800319:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 05 00 00 00       	call   800330 <vprintfmt>
}
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vprintfmt>:
{
  800330:	f3 0f 1e fb          	endbr32 
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	57                   	push   %edi
  800338:	56                   	push   %esi
  800339:	53                   	push   %ebx
  80033a:	83 ec 2c             	sub    $0x2c,%esp
  80033d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800340:	8b 75 0c             	mov    0xc(%ebp),%esi
  800343:	8b 7d 10             	mov    0x10(%ebp),%edi
  800346:	e9 86 02 00 00       	jmp    8005d1 <vprintfmt+0x2a1>
		padc = ' ';
  80034b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80034f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800356:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800364:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8d 47 01             	lea    0x1(%edi),%eax
  80036c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036f:	0f b6 17             	movzbl (%edi),%edx
  800372:	8d 42 dd             	lea    -0x23(%edx),%eax
  800375:	3c 55                	cmp    $0x55,%al
  800377:	0f 87 df 02 00 00    	ja     80065c <vprintfmt+0x32c>
  80037d:	0f b6 c0             	movzbl %al,%eax
  800380:	3e ff 24 85 80 25 80 	notrack jmp *0x802580(,%eax,4)
  800387:	00 
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80038f:	eb d8                	jmp    800369 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800394:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800398:	eb cf                	jmp    800369 <vprintfmt+0x39>
  80039a:	0f b6 d2             	movzbl %dl,%edx
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b5:	83 f9 09             	cmp    $0x9,%ecx
  8003b8:	77 52                	ja     80040c <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8003ba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bd:	eb e9                	jmp    8003a8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8d 50 04             	lea    0x4(%eax),%edx
  8003c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d4:	79 93                	jns    800369 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e3:	eb 84                	jmp    800369 <vprintfmt+0x39>
  8003e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ef:	0f 49 d0             	cmovns %eax,%edx
  8003f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f8:	e9 6c ff ff ff       	jmp    800369 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800400:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800407:	e9 5d ff ff ff       	jmp    800369 <vprintfmt+0x39>
  80040c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800412:	eb bc                	jmp    8003d0 <vprintfmt+0xa0>
			lflag++;
  800414:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041a:	e9 4a ff ff ff       	jmp    800369 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 50 04             	lea    0x4(%eax),%edx
  800425:	89 55 14             	mov    %edx,0x14(%ebp)
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	56                   	push   %esi
  80042c:	ff 30                	pushl  (%eax)
  80042e:	ff d3                	call   *%ebx
			break;
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	e9 96 01 00 00       	jmp    8005ce <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 50 04             	lea    0x4(%eax),%edx
  80043e:	89 55 14             	mov    %edx,0x14(%ebp)
  800441:	8b 00                	mov    (%eax),%eax
  800443:	99                   	cltd   
  800444:	31 d0                	xor    %edx,%eax
  800446:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800448:	83 f8 0f             	cmp    $0xf,%eax
  80044b:	7f 20                	jg     80046d <vprintfmt+0x13d>
  80044d:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  800454:	85 d2                	test   %edx,%edx
  800456:	74 15                	je     80046d <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800458:	52                   	push   %edx
  800459:	68 03 2a 80 00       	push   $0x802a03
  80045e:	56                   	push   %esi
  80045f:	53                   	push   %ebx
  800460:	e8 aa fe ff ff       	call   80030f <printfmt>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	e9 61 01 00 00       	jmp    8005ce <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80046d:	50                   	push   %eax
  80046e:	68 4b 24 80 00       	push   $0x80244b
  800473:	56                   	push   %esi
  800474:	53                   	push   %ebx
  800475:	e8 95 fe ff ff       	call   80030f <printfmt>
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	e9 4c 01 00 00       	jmp    8005ce <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8d 50 04             	lea    0x4(%eax),%edx
  800488:	89 55 14             	mov    %edx,0x14(%ebp)
  80048b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 44 24 80 00       	mov    $0x802444,%eax
  800494:	0f 45 c1             	cmovne %ecx,%eax
  800497:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80049a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049e:	7e 06                	jle    8004a6 <vprintfmt+0x176>
  8004a0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a4:	75 0d                	jne    8004b3 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a9:	89 c7                	mov    %eax,%edi
  8004ab:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b1:	eb 57                	jmp    80050a <vprintfmt+0x1da>
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b9:	ff 75 cc             	pushl  -0x34(%ebp)
  8004bc:	e8 4f 02 00 00       	call   800710 <strnlen>
  8004c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c4:	29 c2                	sub    %eax,%edx
  8004c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004c9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004cc:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8004d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8004d3:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	7e 10                	jle    8004e9 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	56                   	push   %esi
  8004dd:	57                   	push   %edi
  8004de:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	83 eb 01             	sub    $0x1,%ebx
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	eb ec                	jmp    8004d5 <vprintfmt+0x1a5>
  8004e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	0f 49 c2             	cmovns %edx,%eax
  8004f9:	29 c2                	sub    %eax,%edx
  8004fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004fe:	eb a6                	jmp    8004a6 <vprintfmt+0x176>
					putch(ch, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	56                   	push   %esi
  800504:	52                   	push   %edx
  800505:	ff d3                	call   *%ebx
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	83 c7 01             	add    $0x1,%edi
  800512:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800516:	0f be d0             	movsbl %al,%edx
  800519:	85 d2                	test   %edx,%edx
  80051b:	74 42                	je     80055f <vprintfmt+0x22f>
  80051d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800521:	78 06                	js     800529 <vprintfmt+0x1f9>
  800523:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800527:	78 1e                	js     800547 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800529:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80052d:	74 d1                	je     800500 <vprintfmt+0x1d0>
  80052f:	0f be c0             	movsbl %al,%eax
  800532:	83 e8 20             	sub    $0x20,%eax
  800535:	83 f8 5e             	cmp    $0x5e,%eax
  800538:	76 c6                	jbe    800500 <vprintfmt+0x1d0>
					putch('?', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	56                   	push   %esi
  80053e:	6a 3f                	push   $0x3f
  800540:	ff d3                	call   *%ebx
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb c3                	jmp    80050a <vprintfmt+0x1da>
  800547:	89 cf                	mov    %ecx,%edi
  800549:	eb 0e                	jmp    800559 <vprintfmt+0x229>
				putch(' ', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	56                   	push   %esi
  80054f:	6a 20                	push   $0x20
  800551:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800553:	83 ef 01             	sub    $0x1,%edi
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	85 ff                	test   %edi,%edi
  80055b:	7f ee                	jg     80054b <vprintfmt+0x21b>
  80055d:	eb 6f                	jmp    8005ce <vprintfmt+0x29e>
  80055f:	89 cf                	mov    %ecx,%edi
  800561:	eb f6                	jmp    800559 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800563:	89 ca                	mov    %ecx,%edx
  800565:	8d 45 14             	lea    0x14(%ebp),%eax
  800568:	e8 55 fd ff ff       	call   8002c2 <getint>
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800573:	85 d2                	test   %edx,%edx
  800575:	78 0b                	js     800582 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800577:	89 d1                	mov    %edx,%ecx
  800579:	89 c2                	mov    %eax,%edx
			base = 10;
  80057b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800580:	eb 32                	jmp    8005b4 <vprintfmt+0x284>
				putch('-', putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	56                   	push   %esi
  800586:	6a 2d                	push   $0x2d
  800588:	ff d3                	call   *%ebx
				num = -(long long) num;
  80058a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800590:	f7 da                	neg    %edx
  800592:	83 d1 00             	adc    $0x0,%ecx
  800595:	f7 d9                	neg    %ecx
  800597:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059f:	eb 13                	jmp    8005b4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005a1:	89 ca                	mov    %ecx,%edx
  8005a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a6:	e8 e3 fc ff ff       	call   80028e <getuint>
  8005ab:	89 d1                	mov    %edx,%ecx
  8005ad:	89 c2                	mov    %eax,%edx
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005bb:	57                   	push   %edi
  8005bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bf:	50                   	push   %eax
  8005c0:	51                   	push   %ecx
  8005c1:	52                   	push   %edx
  8005c2:	89 f2                	mov    %esi,%edx
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	e8 1a fc ff ff       	call   8001e5 <printnum>
			break;
  8005cb:	83 c4 20             	add    $0x20,%esp
{
  8005ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d1:	83 c7 01             	add    $0x1,%edi
  8005d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d8:	83 f8 25             	cmp    $0x25,%eax
  8005db:	0f 84 6a fd ff ff    	je     80034b <vprintfmt+0x1b>
			if (ch == '\0')
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	0f 84 93 00 00 00    	je     80067c <vprintfmt+0x34c>
			putch(ch, putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	56                   	push   %esi
  8005ed:	50                   	push   %eax
  8005ee:	ff d3                	call   *%ebx
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	eb dc                	jmp    8005d1 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005f5:	89 ca                	mov    %ecx,%edx
  8005f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fa:	e8 8f fc ff ff       	call   80028e <getuint>
  8005ff:	89 d1                	mov    %edx,%ecx
  800601:	89 c2                	mov    %eax,%edx
			base = 8;
  800603:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800608:	eb aa                	jmp    8005b4 <vprintfmt+0x284>
			putch('0', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	56                   	push   %esi
  80060e:	6a 30                	push   $0x30
  800610:	ff d3                	call   *%ebx
			putch('x', putdat);
  800612:	83 c4 08             	add    $0x8,%esp
  800615:	56                   	push   %esi
  800616:	6a 78                	push   $0x78
  800618:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 50 04             	lea    0x4(%eax),%edx
  800620:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800623:	8b 10                	mov    (%eax),%edx
  800625:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062a:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80062d:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800632:	eb 80                	jmp    8005b4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800634:	89 ca                	mov    %ecx,%edx
  800636:	8d 45 14             	lea    0x14(%ebp),%eax
  800639:	e8 50 fc ff ff       	call   80028e <getuint>
  80063e:	89 d1                	mov    %edx,%ecx
  800640:	89 c2                	mov    %eax,%edx
			base = 16;
  800642:	b8 10 00 00 00       	mov    $0x10,%eax
  800647:	e9 68 ff ff ff       	jmp    8005b4 <vprintfmt+0x284>
			putch(ch, putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	56                   	push   %esi
  800650:	6a 25                	push   $0x25
  800652:	ff d3                	call   *%ebx
			break;
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	e9 72 ff ff ff       	jmp    8005ce <vprintfmt+0x29e>
			putch('%', putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	56                   	push   %esi
  800660:	6a 25                	push   $0x25
  800662:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	89 f8                	mov    %edi,%eax
  800669:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80066d:	74 05                	je     800674 <vprintfmt+0x344>
  80066f:	83 e8 01             	sub    $0x1,%eax
  800672:	eb f5                	jmp    800669 <vprintfmt+0x339>
  800674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800677:	e9 52 ff ff ff       	jmp    8005ce <vprintfmt+0x29e>
}
  80067c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067f:	5b                   	pop    %ebx
  800680:	5e                   	pop    %esi
  800681:	5f                   	pop    %edi
  800682:	5d                   	pop    %ebp
  800683:	c3                   	ret    

00800684 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800684:	f3 0f 1e fb          	endbr32 
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 18             	sub    $0x18,%esp
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800694:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800697:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80069b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80069e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	74 26                	je     8006cf <vsnprintf+0x4b>
  8006a9:	85 d2                	test   %edx,%edx
  8006ab:	7e 22                	jle    8006cf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ad:	ff 75 14             	pushl  0x14(%ebp)
  8006b0:	ff 75 10             	pushl  0x10(%ebp)
  8006b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006b6:	50                   	push   %eax
  8006b7:	68 ee 02 80 00       	push   $0x8002ee
  8006bc:	e8 6f fc ff ff       	call   800330 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
}
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    
		return -E_INVAL;
  8006cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d4:	eb f7                	jmp    8006cd <vsnprintf+0x49>

008006d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006d6:	f3 0f 1e fb          	endbr32 
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006e3:	50                   	push   %eax
  8006e4:	ff 75 10             	pushl  0x10(%ebp)
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	ff 75 08             	pushl  0x8(%ebp)
  8006ed:	e8 92 ff ff ff       	call   800684 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006f4:	f3 0f 1e fb          	endbr32 
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800703:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800707:	74 05                	je     80070e <strlen+0x1a>
		n++;
  800709:	83 c0 01             	add    $0x1,%eax
  80070c:	eb f5                	jmp    800703 <strlen+0xf>
	return n;
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800710:	f3 0f 1e fb          	endbr32 
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80071a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80071d:	b8 00 00 00 00       	mov    $0x0,%eax
  800722:	39 d0                	cmp    %edx,%eax
  800724:	74 0d                	je     800733 <strnlen+0x23>
  800726:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80072a:	74 05                	je     800731 <strnlen+0x21>
		n++;
  80072c:	83 c0 01             	add    $0x1,%eax
  80072f:	eb f1                	jmp    800722 <strnlen+0x12>
  800731:	89 c2                	mov    %eax,%edx
	return n;
}
  800733:	89 d0                	mov    %edx,%eax
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800737:	f3 0f 1e fb          	endbr32 
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	53                   	push   %ebx
  80073f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800742:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800745:	b8 00 00 00 00       	mov    $0x0,%eax
  80074a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80074e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800751:	83 c0 01             	add    $0x1,%eax
  800754:	84 d2                	test   %dl,%dl
  800756:	75 f2                	jne    80074a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800758:	89 c8                	mov    %ecx,%eax
  80075a:	5b                   	pop    %ebx
  80075b:	5d                   	pop    %ebp
  80075c:	c3                   	ret    

0080075d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80075d:	f3 0f 1e fb          	endbr32 
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	53                   	push   %ebx
  800765:	83 ec 10             	sub    $0x10,%esp
  800768:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80076b:	53                   	push   %ebx
  80076c:	e8 83 ff ff ff       	call   8006f4 <strlen>
  800771:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	01 d8                	add    %ebx,%eax
  800779:	50                   	push   %eax
  80077a:	e8 b8 ff ff ff       	call   800737 <strcpy>
	return dst;
}
  80077f:	89 d8                	mov    %ebx,%eax
  800781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800786:	f3 0f 1e fb          	endbr32 
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	56                   	push   %esi
  80078e:	53                   	push   %ebx
  80078f:	8b 75 08             	mov    0x8(%ebp),%esi
  800792:	8b 55 0c             	mov    0xc(%ebp),%edx
  800795:	89 f3                	mov    %esi,%ebx
  800797:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80079a:	89 f0                	mov    %esi,%eax
  80079c:	39 d8                	cmp    %ebx,%eax
  80079e:	74 11                	je     8007b1 <strncpy+0x2b>
		*dst++ = *src;
  8007a0:	83 c0 01             	add    $0x1,%eax
  8007a3:	0f b6 0a             	movzbl (%edx),%ecx
  8007a6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007a9:	80 f9 01             	cmp    $0x1,%cl
  8007ac:	83 da ff             	sbb    $0xffffffff,%edx
  8007af:	eb eb                	jmp    80079c <strncpy+0x16>
	}
	return ret;
}
  8007b1:	89 f0                	mov    %esi,%eax
  8007b3:	5b                   	pop    %ebx
  8007b4:	5e                   	pop    %esi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007b7:	f3 0f 1e fb          	endbr32 
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	56                   	push   %esi
  8007bf:	53                   	push   %ebx
  8007c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8007c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007cb:	85 d2                	test   %edx,%edx
  8007cd:	74 21                	je     8007f0 <strlcpy+0x39>
  8007cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007d5:	39 c2                	cmp    %eax,%edx
  8007d7:	74 14                	je     8007ed <strlcpy+0x36>
  8007d9:	0f b6 19             	movzbl (%ecx),%ebx
  8007dc:	84 db                	test   %bl,%bl
  8007de:	74 0b                	je     8007eb <strlcpy+0x34>
			*dst++ = *src++;
  8007e0:	83 c1 01             	add    $0x1,%ecx
  8007e3:	83 c2 01             	add    $0x1,%edx
  8007e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e9:	eb ea                	jmp    8007d5 <strlcpy+0x1e>
  8007eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f0:	29 f0                	sub    %esi,%eax
}
  8007f2:	5b                   	pop    %ebx
  8007f3:	5e                   	pop    %esi
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800803:	0f b6 01             	movzbl (%ecx),%eax
  800806:	84 c0                	test   %al,%al
  800808:	74 0c                	je     800816 <strcmp+0x20>
  80080a:	3a 02                	cmp    (%edx),%al
  80080c:	75 08                	jne    800816 <strcmp+0x20>
		p++, q++;
  80080e:	83 c1 01             	add    $0x1,%ecx
  800811:	83 c2 01             	add    $0x1,%edx
  800814:	eb ed                	jmp    800803 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800816:	0f b6 c0             	movzbl %al,%eax
  800819:	0f b6 12             	movzbl (%edx),%edx
  80081c:	29 d0                	sub    %edx,%eax
}
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082e:	89 c3                	mov    %eax,%ebx
  800830:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800833:	eb 06                	jmp    80083b <strncmp+0x1b>
		n--, p++, q++;
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80083b:	39 d8                	cmp    %ebx,%eax
  80083d:	74 16                	je     800855 <strncmp+0x35>
  80083f:	0f b6 08             	movzbl (%eax),%ecx
  800842:	84 c9                	test   %cl,%cl
  800844:	74 04                	je     80084a <strncmp+0x2a>
  800846:	3a 0a                	cmp    (%edx),%cl
  800848:	74 eb                	je     800835 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80084a:	0f b6 00             	movzbl (%eax),%eax
  80084d:	0f b6 12             	movzbl (%edx),%edx
  800850:	29 d0                	sub    %edx,%eax
}
  800852:	5b                   	pop    %ebx
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    
		return 0;
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	eb f6                	jmp    800852 <strncmp+0x32>

0080085c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80085c:	f3 0f 1e fb          	endbr32 
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80086a:	0f b6 10             	movzbl (%eax),%edx
  80086d:	84 d2                	test   %dl,%dl
  80086f:	74 09                	je     80087a <strchr+0x1e>
		if (*s == c)
  800871:	38 ca                	cmp    %cl,%dl
  800873:	74 0a                	je     80087f <strchr+0x23>
	for (; *s; s++)
  800875:	83 c0 01             	add    $0x1,%eax
  800878:	eb f0                	jmp    80086a <strchr+0xe>
			return (char *) s;
	return 0;
  80087a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800881:	f3 0f 1e fb          	endbr32 
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800892:	38 ca                	cmp    %cl,%dl
  800894:	74 09                	je     80089f <strfind+0x1e>
  800896:	84 d2                	test   %dl,%dl
  800898:	74 05                	je     80089f <strfind+0x1e>
	for (; *s; s++)
  80089a:	83 c0 01             	add    $0x1,%eax
  80089d:	eb f0                	jmp    80088f <strfind+0xe>
			break;
	return (char *) s;
}
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008a1:	f3 0f 1e fb          	endbr32 
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	57                   	push   %edi
  8008a9:	56                   	push   %esi
  8008aa:	53                   	push   %ebx
  8008ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008b1:	85 c9                	test   %ecx,%ecx
  8008b3:	74 33                	je     8008e8 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008b5:	89 d0                	mov    %edx,%eax
  8008b7:	09 c8                	or     %ecx,%eax
  8008b9:	a8 03                	test   $0x3,%al
  8008bb:	75 23                	jne    8008e0 <memset+0x3f>
		c &= 0xFF;
  8008bd:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008c1:	89 d8                	mov    %ebx,%eax
  8008c3:	c1 e0 08             	shl    $0x8,%eax
  8008c6:	89 df                	mov    %ebx,%edi
  8008c8:	c1 e7 18             	shl    $0x18,%edi
  8008cb:	89 de                	mov    %ebx,%esi
  8008cd:	c1 e6 10             	shl    $0x10,%esi
  8008d0:	09 f7                	or     %esi,%edi
  8008d2:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008d4:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008d7:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8008d9:	89 d7                	mov    %edx,%edi
  8008db:	fc                   	cld    
  8008dc:	f3 ab                	rep stos %eax,%es:(%edi)
  8008de:	eb 08                	jmp    8008e8 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008e0:	89 d7                	mov    %edx,%edi
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	fc                   	cld    
  8008e6:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	5b                   	pop    %ebx
  8008eb:	5e                   	pop    %esi
  8008ec:	5f                   	pop    %edi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ef:	f3 0f 1e fb          	endbr32 
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	57                   	push   %edi
  8008f7:	56                   	push   %esi
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800901:	39 c6                	cmp    %eax,%esi
  800903:	73 32                	jae    800937 <memmove+0x48>
  800905:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	76 2b                	jbe    800937 <memmove+0x48>
		s += n;
		d += n;
  80090c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80090f:	89 fe                	mov    %edi,%esi
  800911:	09 ce                	or     %ecx,%esi
  800913:	09 d6                	or     %edx,%esi
  800915:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80091b:	75 0e                	jne    80092b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80091d:	83 ef 04             	sub    $0x4,%edi
  800920:	8d 72 fc             	lea    -0x4(%edx),%esi
  800923:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800926:	fd                   	std    
  800927:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800929:	eb 09                	jmp    800934 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80092b:	83 ef 01             	sub    $0x1,%edi
  80092e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800931:	fd                   	std    
  800932:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800934:	fc                   	cld    
  800935:	eb 1a                	jmp    800951 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800937:	89 c2                	mov    %eax,%edx
  800939:	09 ca                	or     %ecx,%edx
  80093b:	09 f2                	or     %esi,%edx
  80093d:	f6 c2 03             	test   $0x3,%dl
  800940:	75 0a                	jne    80094c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800942:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800945:	89 c7                	mov    %eax,%edi
  800947:	fc                   	cld    
  800948:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094a:	eb 05                	jmp    800951 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80094c:	89 c7                	mov    %eax,%edi
  80094e:	fc                   	cld    
  80094f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800955:	f3 0f 1e fb          	endbr32 
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80095f:	ff 75 10             	pushl  0x10(%ebp)
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	ff 75 08             	pushl  0x8(%ebp)
  800968:	e8 82 ff ff ff       	call   8008ef <memmove>
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80096f:	f3 0f 1e fb          	endbr32 
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	56                   	push   %esi
  800977:	53                   	push   %ebx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097e:	89 c6                	mov    %eax,%esi
  800980:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800983:	39 f0                	cmp    %esi,%eax
  800985:	74 1c                	je     8009a3 <memcmp+0x34>
		if (*s1 != *s2)
  800987:	0f b6 08             	movzbl (%eax),%ecx
  80098a:	0f b6 1a             	movzbl (%edx),%ebx
  80098d:	38 d9                	cmp    %bl,%cl
  80098f:	75 08                	jne    800999 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800991:	83 c0 01             	add    $0x1,%eax
  800994:	83 c2 01             	add    $0x1,%edx
  800997:	eb ea                	jmp    800983 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800999:	0f b6 c1             	movzbl %cl,%eax
  80099c:	0f b6 db             	movzbl %bl,%ebx
  80099f:	29 d8                	sub    %ebx,%eax
  8009a1:	eb 05                	jmp    8009a8 <memcmp+0x39>
	}

	return 0;
  8009a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ac:	f3 0f 1e fb          	endbr32 
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009b9:	89 c2                	mov    %eax,%edx
  8009bb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009be:	39 d0                	cmp    %edx,%eax
  8009c0:	73 09                	jae    8009cb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c2:	38 08                	cmp    %cl,(%eax)
  8009c4:	74 05                	je     8009cb <memfind+0x1f>
	for (; s < ends; s++)
  8009c6:	83 c0 01             	add    $0x1,%eax
  8009c9:	eb f3                	jmp    8009be <memfind+0x12>
			break;
	return (void *) s;
}
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009dd:	eb 03                	jmp    8009e2 <strtol+0x15>
		s++;
  8009df:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009e2:	0f b6 01             	movzbl (%ecx),%eax
  8009e5:	3c 20                	cmp    $0x20,%al
  8009e7:	74 f6                	je     8009df <strtol+0x12>
  8009e9:	3c 09                	cmp    $0x9,%al
  8009eb:	74 f2                	je     8009df <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009ed:	3c 2b                	cmp    $0x2b,%al
  8009ef:	74 2a                	je     800a1b <strtol+0x4e>
	int neg = 0;
  8009f1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009f6:	3c 2d                	cmp    $0x2d,%al
  8009f8:	74 2b                	je     800a25 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009fa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a00:	75 0f                	jne    800a11 <strtol+0x44>
  800a02:	80 39 30             	cmpb   $0x30,(%ecx)
  800a05:	74 28                	je     800a2f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a07:	85 db                	test   %ebx,%ebx
  800a09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a0e:	0f 44 d8             	cmove  %eax,%ebx
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
  800a16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a19:	eb 46                	jmp    800a61 <strtol+0x94>
		s++;
  800a1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a23:	eb d5                	jmp    8009fa <strtol+0x2d>
		s++, neg = 1;
  800a25:	83 c1 01             	add    $0x1,%ecx
  800a28:	bf 01 00 00 00       	mov    $0x1,%edi
  800a2d:	eb cb                	jmp    8009fa <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a33:	74 0e                	je     800a43 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	75 d8                	jne    800a11 <strtol+0x44>
		s++, base = 8;
  800a39:	83 c1 01             	add    $0x1,%ecx
  800a3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a41:	eb ce                	jmp    800a11 <strtol+0x44>
		s += 2, base = 16;
  800a43:	83 c1 02             	add    $0x2,%ecx
  800a46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a4b:	eb c4                	jmp    800a11 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a4d:	0f be d2             	movsbl %dl,%edx
  800a50:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a56:	7d 3a                	jge    800a92 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a58:	83 c1 01             	add    $0x1,%ecx
  800a5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a61:	0f b6 11             	movzbl (%ecx),%edx
  800a64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a67:	89 f3                	mov    %esi,%ebx
  800a69:	80 fb 09             	cmp    $0x9,%bl
  800a6c:	76 df                	jbe    800a4d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a71:	89 f3                	mov    %esi,%ebx
  800a73:	80 fb 19             	cmp    $0x19,%bl
  800a76:	77 08                	ja     800a80 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a78:	0f be d2             	movsbl %dl,%edx
  800a7b:	83 ea 57             	sub    $0x57,%edx
  800a7e:	eb d3                	jmp    800a53 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	80 fb 19             	cmp    $0x19,%bl
  800a88:	77 08                	ja     800a92 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a8a:	0f be d2             	movsbl %dl,%edx
  800a8d:	83 ea 37             	sub    $0x37,%edx
  800a90:	eb c1                	jmp    800a53 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a96:	74 05                	je     800a9d <strtol+0xd0>
		*endptr = (char *) s;
  800a98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	85 ff                	test   %edi,%edi
  800aa3:	0f 45 c2             	cmovne %edx,%eax
}
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	57                   	push   %edi
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	83 ec 1c             	sub    $0x1c,%esp
  800ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ab7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800aba:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac2:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ac5:	8b 75 14             	mov    0x14(%ebp),%esi
  800ac8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ace:	74 04                	je     800ad4 <syscall+0x29>
  800ad0:	85 c0                	test   %eax,%eax
  800ad2:	7f 08                	jg     800adc <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800adc:	83 ec 0c             	sub    $0xc,%esp
  800adf:	50                   	push   %eax
  800ae0:	ff 75 e0             	pushl  -0x20(%ebp)
  800ae3:	68 3f 27 80 00       	push   $0x80273f
  800ae8:	6a 23                	push   $0x23
  800aea:	68 5c 27 80 00       	push   $0x80275c
  800aef:	e8 61 15 00 00       	call   802055 <_panic>

00800af4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800af4:	f3 0f 1e fb          	endbr32 
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800afe:	6a 00                	push   $0x0
  800b00:	6a 00                	push   $0x0
  800b02:	6a 00                	push   $0x0
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b14:	e8 92 ff ff ff       	call   800aab <syscall>
}
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1e:	f3 0f 1e fb          	endbr32 
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b28:	6a 00                	push   $0x0
  800b2a:	6a 00                	push   $0x0
  800b2c:	6a 00                	push   $0x0
  800b2e:	6a 00                	push   $0x0
  800b30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	e8 67 ff ff ff       	call   800aab <syscall>
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b46:	f3 0f 1e fb          	endbr32 
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b50:	6a 00                	push   $0x0
  800b52:	6a 00                	push   $0x0
  800b54:	6a 00                	push   $0x0
  800b56:	6a 00                	push   $0x0
  800b58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5b:	ba 01 00 00 00       	mov    $0x1,%edx
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	e8 41 ff ff ff       	call   800aab <syscall>
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b6c:	f3 0f 1e fb          	endbr32 
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b76:	6a 00                	push   $0x0
  800b78:	6a 00                	push   $0x0
  800b7a:	6a 00                	push   $0x0
  800b7c:	6a 00                	push   $0x0
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	b8 02 00 00 00       	mov    $0x2,%eax
  800b8d:	e8 19 ff ff ff       	call   800aab <syscall>
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <sys_yield>:

void
sys_yield(void)
{
  800b94:	f3 0f 1e fb          	endbr32 
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 00                	push   $0x0
  800ba2:	6a 00                	push   $0x0
  800ba4:	6a 00                	push   $0x0
  800ba6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb5:	e8 f1 fe ff ff       	call   800aab <syscall>
}
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bbf:	f3 0f 1e fb          	endbr32 
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bc9:	6a 00                	push   $0x0
  800bcb:	6a 00                	push   $0x0
  800bcd:	ff 75 10             	pushl  0x10(%ebp)
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd6:	ba 01 00 00 00       	mov    $0x1,%edx
  800bdb:	b8 04 00 00 00       	mov    $0x4,%eax
  800be0:	e8 c6 fe ff ff       	call   800aab <syscall>
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bf1:	ff 75 18             	pushl  0x18(%ebp)
  800bf4:	ff 75 14             	pushl  0x14(%ebp)
  800bf7:	ff 75 10             	pushl  0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c00:	ba 01 00 00 00       	mov    $0x1,%edx
  800c05:	b8 05 00 00 00       	mov    $0x5,%eax
  800c0a:	e8 9c fe ff ff       	call   800aab <syscall>
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c11:	f3 0f 1e fb          	endbr32 
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c1b:	6a 00                	push   $0x0
  800c1d:	6a 00                	push   $0x0
  800c1f:	6a 00                	push   $0x0
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c27:	ba 01 00 00 00       	mov    $0x1,%edx
  800c2c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c31:	e8 75 fe ff ff       	call   800aab <syscall>
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c38:	f3 0f 1e fb          	endbr32 
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c42:	6a 00                	push   $0x0
  800c44:	6a 00                	push   $0x0
  800c46:	6a 00                	push   $0x0
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c53:	b8 08 00 00 00       	mov    $0x8,%eax
  800c58:	e8 4e fe ff ff       	call   800aab <syscall>
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c69:	6a 00                	push   $0x0
  800c6b:	6a 00                	push   $0x0
  800c6d:	6a 00                	push   $0x0
  800c6f:	ff 75 0c             	pushl  0xc(%ebp)
  800c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c75:	ba 01 00 00 00       	mov    $0x1,%edx
  800c7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c7f:	e8 27 fe ff ff       	call   800aab <syscall>
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c86:	f3 0f 1e fb          	endbr32 
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c90:	6a 00                	push   $0x0
  800c92:	6a 00                	push   $0x0
  800c94:	6a 00                	push   $0x0
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9c:	ba 01 00 00 00       	mov    $0x1,%edx
  800ca1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca6:	e8 00 fe ff ff       	call   800aab <syscall>
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cb7:	6a 00                	push   $0x0
  800cb9:	ff 75 14             	pushl  0x14(%ebp)
  800cbc:	ff 75 10             	pushl  0x10(%ebp)
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ccf:	e8 d7 fd ff ff       	call   800aab <syscall>
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cd6:	f3 0f 1e fb          	endbr32 
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ce0:	6a 00                	push   $0x0
  800ce2:	6a 00                	push   $0x0
  800ce4:	6a 00                	push   $0x0
  800ce6:	6a 00                	push   $0x0
  800ce8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ceb:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cf5:	e8 b1 fd ff ff       	call   800aab <syscall>
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	53                   	push   %ebx
  800d00:	83 ec 04             	sub    $0x4,%esp
  800d03:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800d05:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d0c:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d0f:	f6 c6 04             	test   $0x4,%dh
  800d12:	75 51                	jne    800d65 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d14:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d1a:	0f 84 84 00 00 00    	je     800da4 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	68 05 08 00 00       	push   $0x805
  800d28:	53                   	push   %ebx
  800d29:	50                   	push   %eax
  800d2a:	53                   	push   %ebx
  800d2b:	6a 00                	push   $0x0
  800d2d:	e8 b5 fe ff ff       	call   800be7 <sys_page_map>
		if (r)
  800d32:	83 c4 20             	add    $0x20,%esp
  800d35:	85 c0                	test   %eax,%eax
  800d37:	75 59                	jne    800d92 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	68 05 08 00 00       	push   $0x805
  800d41:	53                   	push   %ebx
  800d42:	6a 00                	push   $0x0
  800d44:	53                   	push   %ebx
  800d45:	6a 00                	push   $0x0
  800d47:	e8 9b fe ff ff       	call   800be7 <sys_page_map>
		if (r)
  800d4c:	83 c4 20             	add    $0x20,%esp
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	74 67                	je     800dba <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d53:	50                   	push   %eax
  800d54:	68 6a 27 80 00       	push   $0x80276a
  800d59:	6a 5f                	push   $0x5f
  800d5b:	68 85 27 80 00       	push   $0x802785
  800d60:	e8 f0 12 00 00       	call   802055 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800d65:	83 ec 0c             	sub    $0xc,%esp
  800d68:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d6e:	52                   	push   %edx
  800d6f:	53                   	push   %ebx
  800d70:	50                   	push   %eax
  800d71:	53                   	push   %ebx
  800d72:	6a 00                	push   $0x0
  800d74:	e8 6e fe ff ff       	call   800be7 <sys_page_map>
		if (r)
  800d79:	83 c4 20             	add    $0x20,%esp
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	74 3a                	je     800dba <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d80:	50                   	push   %eax
  800d81:	68 6a 27 80 00       	push   $0x80276a
  800d86:	6a 57                	push   $0x57
  800d88:	68 85 27 80 00       	push   $0x802785
  800d8d:	e8 c3 12 00 00       	call   802055 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800d92:	50                   	push   %eax
  800d93:	68 6a 27 80 00       	push   $0x80276a
  800d98:	6a 5b                	push   $0x5b
  800d9a:	68 85 27 80 00       	push   $0x802785
  800d9f:	e8 b1 12 00 00       	call   802055 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	6a 05                	push   $0x5
  800da9:	53                   	push   %ebx
  800daa:	50                   	push   %eax
  800dab:	53                   	push   %ebx
  800dac:	6a 00                	push   $0x0
  800dae:	e8 34 fe ff ff       	call   800be7 <sys_page_map>
		if (r)
  800db3:	83 c4 20             	add    $0x20,%esp
  800db6:	85 c0                	test   %eax,%eax
  800db8:	75 0a                	jne    800dc4 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800dba:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800dc4:	50                   	push   %eax
  800dc5:	68 6a 27 80 00       	push   $0x80276a
  800dca:	6a 63                	push   $0x63
  800dcc:	68 85 27 80 00       	push   $0x802785
  800dd1:	e8 7f 12 00 00       	call   802055 <_panic>

00800dd6 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	89 c7                	mov    %eax,%edi
  800de1:	89 d6                	mov    %edx,%esi
  800de3:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800de5:	f6 c1 02             	test   $0x2,%cl
  800de8:	75 2f                	jne    800e19 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	51                   	push   %ecx
  800dee:	52                   	push   %edx
  800def:	50                   	push   %eax
  800df0:	52                   	push   %edx
  800df1:	6a 00                	push   $0x0
  800df3:	e8 ef fd ff ff       	call   800be7 <sys_page_map>
  800df8:	83 c4 20             	add    $0x20,%esp
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	78 08                	js     800e07 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800e07:	50                   	push   %eax
  800e08:	68 74 27 80 00       	push   $0x802774
  800e0d:	6a 6f                	push   $0x6f
  800e0f:	68 85 27 80 00       	push   $0x802785
  800e14:	e8 3c 12 00 00       	call   802055 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e19:	83 ec 04             	sub    $0x4,%esp
  800e1c:	51                   	push   %ecx
  800e1d:	52                   	push   %edx
  800e1e:	50                   	push   %eax
  800e1f:	e8 9b fd ff ff       	call   800bbf <sys_page_alloc>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	85 c0                	test   %eax,%eax
  800e29:	78 54                	js     800e7f <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	53                   	push   %ebx
  800e2f:	68 00 00 40 00       	push   $0x400000
  800e34:	6a 00                	push   $0x0
  800e36:	56                   	push   %esi
  800e37:	57                   	push   %edi
  800e38:	e8 aa fd ff ff       	call   800be7 <sys_page_map>
  800e3d:	83 c4 20             	add    $0x20,%esp
  800e40:	85 c0                	test   %eax,%eax
  800e42:	78 4d                	js     800e91 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	68 00 10 00 00       	push   $0x1000
  800e4c:	56                   	push   %esi
  800e4d:	68 00 00 40 00       	push   $0x400000
  800e52:	e8 98 fa ff ff       	call   8008ef <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800e57:	83 c4 08             	add    $0x8,%esp
  800e5a:	68 00 00 40 00       	push   $0x400000
  800e5f:	6a 00                	push   $0x0
  800e61:	e8 ab fd ff ff       	call   800c11 <sys_page_unmap>
  800e66:	83 c4 10             	add    $0x10,%esp
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	79 92                	jns    800dff <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800e6d:	50                   	push   %eax
  800e6e:	68 a3 27 80 00       	push   $0x8027a3
  800e73:	6a 78                	push   $0x78
  800e75:	68 85 27 80 00       	push   $0x802785
  800e7a:	e8 d6 11 00 00       	call   802055 <_panic>
		panic("sys_page_alloc: %e", r);
  800e7f:	50                   	push   %eax
  800e80:	68 90 27 80 00       	push   $0x802790
  800e85:	6a 73                	push   $0x73
  800e87:	68 85 27 80 00       	push   $0x802785
  800e8c:	e8 c4 11 00 00       	call   802055 <_panic>
		panic("sys_page_map: %e", r);
  800e91:	50                   	push   %eax
  800e92:	68 74 27 80 00       	push   $0x802774
  800e97:	6a 75                	push   $0x75
  800e99:	68 85 27 80 00       	push   $0x802785
  800e9e:	e8 b2 11 00 00       	call   802055 <_panic>

00800ea3 <pgfault>:
{
  800ea3:	f3 0f 1e fb          	endbr32 
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eb1:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800eb3:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800eb6:	89 da                	mov    %ebx,%edx
  800eb8:	c1 ea 0c             	shr    $0xc,%edx
  800ebb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800ec2:	a8 01                	test   $0x1,%al
  800ec4:	74 7e                	je     800f44 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800ec6:	a8 02                	test   $0x2,%al
  800ec8:	0f 84 8a 00 00 00    	je     800f58 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800ece:	f6 c6 08             	test   $0x8,%dh
  800ed1:	0f 84 95 00 00 00    	je     800f6c <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800ed7:	83 ec 04             	sub    $0x4,%esp
  800eda:	6a 07                	push   $0x7
  800edc:	68 00 f0 7f 00       	push   $0x7ff000
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 d7 fc ff ff       	call   800bbf <sys_page_alloc>
	if (r)
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	0f 85 8d 00 00 00    	jne    800f80 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800ef3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	68 00 10 00 00       	push   $0x1000
  800f01:	53                   	push   %ebx
  800f02:	68 00 f0 7f 00       	push   $0x7ff000
  800f07:	e8 49 fa ff ff       	call   800955 <memcpy>
	r = sys_page_map(
  800f0c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f13:	53                   	push   %ebx
  800f14:	6a 00                	push   $0x0
  800f16:	68 00 f0 7f 00       	push   $0x7ff000
  800f1b:	6a 00                	push   $0x0
  800f1d:	e8 c5 fc ff ff       	call   800be7 <sys_page_map>
	if (r)
  800f22:	83 c4 20             	add    $0x20,%esp
  800f25:	85 c0                	test   %eax,%eax
  800f27:	75 69                	jne    800f92 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	68 00 f0 7f 00       	push   $0x7ff000
  800f31:	6a 00                	push   $0x0
  800f33:	e8 d9 fc ff ff       	call   800c11 <sys_page_unmap>
	if (r)
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	75 65                	jne    800fa4 <pgfault+0x101>
}
  800f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	68 24 28 80 00       	push   $0x802824
  800f4c:	6a 20                	push   $0x20
  800f4e:	68 85 27 80 00       	push   $0x802785
  800f53:	e8 fd 10 00 00       	call   802055 <_panic>
		panic("[pgfault] pgfault por lectura");
  800f58:	83 ec 04             	sub    $0x4,%esp
  800f5b:	68 b6 27 80 00       	push   $0x8027b6
  800f60:	6a 23                	push   $0x23
  800f62:	68 85 27 80 00       	push   $0x802785
  800f67:	e8 e9 10 00 00       	call   802055 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800f6c:	83 ec 04             	sub    $0x4,%esp
  800f6f:	68 50 28 80 00       	push   $0x802850
  800f74:	6a 27                	push   $0x27
  800f76:	68 85 27 80 00       	push   $0x802785
  800f7b:	e8 d5 10 00 00       	call   802055 <_panic>
		panic("pgfault: %e", r);
  800f80:	50                   	push   %eax
  800f81:	68 d4 27 80 00       	push   $0x8027d4
  800f86:	6a 32                	push   $0x32
  800f88:	68 85 27 80 00       	push   $0x802785
  800f8d:	e8 c3 10 00 00       	call   802055 <_panic>
		panic("pgfault: %e", r);
  800f92:	50                   	push   %eax
  800f93:	68 d4 27 80 00       	push   $0x8027d4
  800f98:	6a 39                	push   $0x39
  800f9a:	68 85 27 80 00       	push   $0x802785
  800f9f:	e8 b1 10 00 00       	call   802055 <_panic>
		panic("pgfault: %e", r);
  800fa4:	50                   	push   %eax
  800fa5:	68 d4 27 80 00       	push   $0x8027d4
  800faa:	6a 3d                	push   $0x3d
  800fac:	68 85 27 80 00       	push   $0x802785
  800fb1:	e8 9f 10 00 00       	call   802055 <_panic>

00800fb6 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  800fb6:	f3 0f 1e fb          	endbr32 
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fc3:	b8 07 00 00 00       	mov    $0x7,%eax
  800fc8:	cd 30                	int    $0x30
  800fca:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	78 22                	js     800ff2 <fork_v0+0x3c>
  800fd0:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fd7:	75 52                	jne    80102b <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fd9:	e8 8e fb ff ff       	call   800b6c <sys_getenvid>
  800fde:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fe3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fe6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800feb:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800ff0:	eb 6e                	jmp    801060 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  800ff2:	50                   	push   %eax
  800ff3:	68 78 28 80 00       	push   $0x802878
  800ff8:	68 8a 00 00 00       	push   $0x8a
  800ffd:	68 85 27 80 00       	push   $0x802785
  801002:	e8 4e 10 00 00       	call   802055 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801007:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  80100e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801014:	89 da                	mov    %ebx,%edx
  801016:	89 f0                	mov    %esi,%eax
  801018:	e8 b9 fd ff ff       	call   800dd6 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80101d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801023:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801029:	74 23                	je     80104e <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80102b:	89 d8                	mov    %ebx,%eax
  80102d:	c1 e8 16             	shr    $0x16,%eax
  801030:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801037:	a8 01                	test   $0x1,%al
  801039:	74 e2                	je     80101d <fork_v0+0x67>
  80103b:	89 d8                	mov    %ebx,%eax
  80103d:	c1 e8 0c             	shr    $0xc,%eax
  801040:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801047:	f6 c2 01             	test   $0x1,%dl
  80104a:	74 d1                	je     80101d <fork_v0+0x67>
  80104c:	eb b9                	jmp    801007 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80104e:	83 ec 08             	sub    $0x8,%esp
  801051:	6a 02                	push   $0x2
  801053:	57                   	push   %edi
  801054:	e8 df fb ff ff       	call   800c38 <sys_env_set_status>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 0a                	js     80106a <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  801060:	89 f8                	mov    %edi,%eax
  801062:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  80106a:	50                   	push   %eax
  80106b:	68 9c 28 80 00       	push   $0x80289c
  801070:	68 98 00 00 00       	push   $0x98
  801075:	68 85 27 80 00       	push   $0x802785
  80107a:	e8 d6 0f 00 00       	call   802055 <_panic>

0080107f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80107f:	f3 0f 1e fb          	endbr32 
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  80108c:	68 a3 0e 80 00       	push   $0x800ea3
  801091:	e8 09 10 00 00       	call   80209f <set_pgfault_handler>
  801096:	b8 07 00 00 00       	mov    $0x7,%eax
  80109b:	cd 30                	int    $0x30
  80109d:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 37                	js     8010dd <fork+0x5e>
  8010a6:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8010a8:	74 48                	je     8010f2 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	6a 07                	push   $0x7
  8010af:	68 00 f0 bf ee       	push   $0xeebff000
  8010b4:	50                   	push   %eax
  8010b5:	e8 05 fb ff ff       	call   800bbf <sys_page_alloc>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 4d                	js     80110e <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	68 1c 21 80 00       	push   $0x80211c
  8010c9:	56                   	push   %esi
  8010ca:	e8 b7 fb ff ff       	call   800c86 <sys_env_set_pgfault_upcall>
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	78 4d                	js     801123 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8010d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010db:	eb 70                	jmp    80114d <fork+0xce>
		panic("sys_exofork: %e", envid);
  8010dd:	50                   	push   %eax
  8010de:	68 e0 27 80 00       	push   $0x8027e0
  8010e3:	68 b7 00 00 00       	push   $0xb7
  8010e8:	68 85 27 80 00       	push   $0x802785
  8010ed:	e8 63 0f 00 00       	call   802055 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010f2:	e8 75 fa ff ff       	call   800b6c <sys_getenvid>
  8010f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010fc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801104:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801109:	e9 80 00 00 00       	jmp    80118e <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  80110e:	50                   	push   %eax
  80110f:	68 f0 27 80 00       	push   $0x8027f0
  801114:	68 c0 00 00 00       	push   $0xc0
  801119:	68 85 27 80 00       	push   $0x802785
  80111e:	e8 32 0f 00 00       	call   802055 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801123:	50                   	push   %eax
  801124:	68 c0 28 80 00       	push   $0x8028c0
  801129:	68 c3 00 00 00       	push   $0xc3
  80112e:	68 85 27 80 00       	push   $0x802785
  801133:	e8 1d 0f 00 00       	call   802055 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801138:	89 f8                	mov    %edi,%eax
  80113a:	e8 bd fb ff ff       	call   800cfc <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80113f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801145:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80114b:	74 2f                	je     80117c <fork+0xfd>
  80114d:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  80114f:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801155:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80115a:	76 e3                	jbe    80113f <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80115c:	89 d8                	mov    %ebx,%eax
  80115e:	c1 e8 16             	shr    $0x16,%eax
  801161:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801168:	a8 01                	test   $0x1,%al
  80116a:	74 d3                	je     80113f <fork+0xc0>
  80116c:	c1 ea 0c             	shr    $0xc,%edx
  80116f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801176:	a8 01                	test   $0x1,%al
  801178:	74 c5                	je     80113f <fork+0xc0>
  80117a:	eb bc                	jmp    801138 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	6a 02                	push   $0x2
  801181:	56                   	push   %esi
  801182:	e8 b1 fa ff ff       	call   800c38 <sys_env_set_status>
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	78 0a                	js     801198 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  80118e:	89 f0                	mov    %esi,%eax
  801190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801198:	50                   	push   %eax
  801199:	68 ec 28 80 00       	push   $0x8028ec
  80119e:	68 ce 00 00 00       	push   $0xce
  8011a3:	68 85 27 80 00       	push   $0x802785
  8011a8:	e8 a8 0e 00 00       	call   802055 <_panic>

008011ad <sfork>:

// Challenge!
int
sfork(void)
{
  8011ad:	f3 0f 1e fb          	endbr32 
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b7:	68 0e 28 80 00       	push   $0x80280e
  8011bc:	68 d7 00 00 00       	push   $0xd7
  8011c1:	68 85 27 80 00       	push   $0x802785
  8011c6:	e8 8a 0e 00 00       	call   802055 <_panic>

008011cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011cb:	f3 0f 1e fb          	endbr32 
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011e4:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8011e7:	83 ec 0c             	sub    $0xc,%esp
  8011ea:	50                   	push   %eax
  8011eb:	e8 e6 fa ff ff       	call   800cd6 <sys_ipc_recv>
	if (r < 0) {
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	78 2b                	js     801222 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8011f7:	85 f6                	test   %esi,%esi
  8011f9:	74 0a                	je     801205 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8011fb:	a1 04 40 80 00       	mov    0x804004,%eax
  801200:	8b 40 74             	mov    0x74(%eax),%eax
  801203:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801205:	85 db                	test   %ebx,%ebx
  801207:	74 0a                	je     801213 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801209:	a1 04 40 80 00       	mov    0x804004,%eax
  80120e:	8b 40 78             	mov    0x78(%eax),%eax
  801211:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801213:	a1 04 40 80 00       	mov    0x804004,%eax
  801218:	8b 40 70             	mov    0x70(%eax),%eax
}
  80121b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121e:	5b                   	pop    %ebx
  80121f:	5e                   	pop    %esi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    
		if (from_env_store) {
  801222:	85 f6                	test   %esi,%esi
  801224:	74 06                	je     80122c <ipc_recv+0x61>
			*from_env_store = 0;
  801226:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  80122c:	85 db                	test   %ebx,%ebx
  80122e:	74 eb                	je     80121b <ipc_recv+0x50>
			*perm_store = 0;
  801230:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801236:	eb e3                	jmp    80121b <ipc_recv+0x50>

00801238 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801238:	f3 0f 1e fb          	endbr32 
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 0c             	sub    $0xc,%esp
  801245:	8b 7d 08             	mov    0x8(%ebp),%edi
  801248:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  80124e:	85 db                	test   %ebx,%ebx
  801250:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801255:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801258:	ff 75 14             	pushl  0x14(%ebp)
  80125b:	53                   	push   %ebx
  80125c:	56                   	push   %esi
  80125d:	57                   	push   %edi
  80125e:	e8 4a fa ff ff       	call   800cad <sys_ipc_try_send>
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801269:	75 07                	jne    801272 <ipc_send+0x3a>
		sys_yield();
  80126b:	e8 24 f9 ff ff       	call   800b94 <sys_yield>
  801270:	eb e6                	jmp    801258 <ipc_send+0x20>
	}

	if (ret < 0) {
  801272:	85 c0                	test   %eax,%eax
  801274:	78 08                	js     80127e <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  80127e:	50                   	push   %eax
  80127f:	68 0e 29 80 00       	push   $0x80290e
  801284:	6a 48                	push   $0x48
  801286:	68 2b 29 80 00       	push   $0x80292b
  80128b:	e8 c5 0d 00 00       	call   802055 <_panic>

00801290 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801290:	f3 0f 1e fb          	endbr32 
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80129f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012a2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012a8:	8b 52 50             	mov    0x50(%edx),%edx
  8012ab:	39 ca                	cmp    %ecx,%edx
  8012ad:	74 11                	je     8012c0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012af:	83 c0 01             	add    $0x1,%eax
  8012b2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012b7:	75 e6                	jne    80129f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012be:	eb 0b                	jmp    8012cb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8012c0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012cd:	f3 0f 1e fb          	endbr32 
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	05 00 00 00 30       	add    $0x30000000,%eax
  8012dc:	c1 e8 0c             	shr    $0xc,%eax
}
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    

008012e1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8012eb:	ff 75 08             	pushl  0x8(%ebp)
  8012ee:	e8 da ff ff ff       	call   8012cd <fd2num>
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	c1 e0 0c             	shl    $0xc,%eax
  8012f9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801300:	f3 0f 1e fb          	endbr32 
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80130c:	89 c2                	mov    %eax,%edx
  80130e:	c1 ea 16             	shr    $0x16,%edx
  801311:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801318:	f6 c2 01             	test   $0x1,%dl
  80131b:	74 2d                	je     80134a <fd_alloc+0x4a>
  80131d:	89 c2                	mov    %eax,%edx
  80131f:	c1 ea 0c             	shr    $0xc,%edx
  801322:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801329:	f6 c2 01             	test   $0x1,%dl
  80132c:	74 1c                	je     80134a <fd_alloc+0x4a>
  80132e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801333:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801338:	75 d2                	jne    80130c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801343:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801348:	eb 0a                	jmp    801354 <fd_alloc+0x54>
			*fd_store = fd;
  80134a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801356:	f3 0f 1e fb          	endbr32 
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801360:	83 f8 1f             	cmp    $0x1f,%eax
  801363:	77 30                	ja     801395 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801365:	c1 e0 0c             	shl    $0xc,%eax
  801368:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80136d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801373:	f6 c2 01             	test   $0x1,%dl
  801376:	74 24                	je     80139c <fd_lookup+0x46>
  801378:	89 c2                	mov    %eax,%edx
  80137a:	c1 ea 0c             	shr    $0xc,%edx
  80137d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	74 1a                	je     8013a3 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	89 02                	mov    %eax,(%edx)
	return 0;
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    
		return -E_INVAL;
  801395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139a:	eb f7                	jmp    801393 <fd_lookup+0x3d>
		return -E_INVAL;
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a1:	eb f0                	jmp    801393 <fd_lookup+0x3d>
  8013a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a8:	eb e9                	jmp    801393 <fd_lookup+0x3d>

008013aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013aa:	f3 0f 1e fb          	endbr32 
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b7:	ba b4 29 80 00       	mov    $0x8029b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013bc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013c1:	39 08                	cmp    %ecx,(%eax)
  8013c3:	74 33                	je     8013f8 <dev_lookup+0x4e>
  8013c5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013c8:	8b 02                	mov    (%edx),%eax
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	75 f3                	jne    8013c1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d3:	8b 40 48             	mov    0x48(%eax),%eax
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	51                   	push   %ecx
  8013da:	50                   	push   %eax
  8013db:	68 38 29 80 00       	push   $0x802938
  8013e0:	e8 e8 ed ff ff       	call   8001cd <cprintf>
	*dev = 0;
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    
			*dev = devtab[i];
  8013f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013fb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb f2                	jmp    8013f6 <dev_lookup+0x4c>

00801404 <fd_close>:
{
  801404:	f3 0f 1e fb          	endbr32 
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	57                   	push   %edi
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	83 ec 28             	sub    $0x28,%esp
  801411:	8b 75 08             	mov    0x8(%ebp),%esi
  801414:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801417:	56                   	push   %esi
  801418:	e8 b0 fe ff ff       	call   8012cd <fd2num>
  80141d:	83 c4 08             	add    $0x8,%esp
  801420:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801423:	52                   	push   %edx
  801424:	50                   	push   %eax
  801425:	e8 2c ff ff ff       	call   801356 <fd_lookup>
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 05                	js     801438 <fd_close+0x34>
	    || fd != fd2)
  801433:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801436:	74 16                	je     80144e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801438:	89 f8                	mov    %edi,%eax
  80143a:	84 c0                	test   %al,%al
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
  801441:	0f 44 d8             	cmove  %eax,%ebx
}
  801444:	89 d8                	mov    %ebx,%eax
  801446:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	5f                   	pop    %edi
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801454:	50                   	push   %eax
  801455:	ff 36                	pushl  (%esi)
  801457:	e8 4e ff ff ff       	call   8013aa <dev_lookup>
  80145c:	89 c3                	mov    %eax,%ebx
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	85 c0                	test   %eax,%eax
  801463:	78 1a                	js     80147f <fd_close+0x7b>
		if (dev->dev_close)
  801465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801468:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801470:	85 c0                	test   %eax,%eax
  801472:	74 0b                	je     80147f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801474:	83 ec 0c             	sub    $0xc,%esp
  801477:	56                   	push   %esi
  801478:	ff d0                	call   *%eax
  80147a:	89 c3                	mov    %eax,%ebx
  80147c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	56                   	push   %esi
  801483:	6a 00                	push   $0x0
  801485:	e8 87 f7 ff ff       	call   800c11 <sys_page_unmap>
	return r;
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	eb b5                	jmp    801444 <fd_close+0x40>

0080148f <close>:

int
close(int fdnum)
{
  80148f:	f3 0f 1e fb          	endbr32 
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801499:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 08             	pushl  0x8(%ebp)
  8014a0:	e8 b1 fe ff ff       	call   801356 <fd_lookup>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	79 02                	jns    8014ae <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    
		return fd_close(fd, 1);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	6a 01                	push   $0x1
  8014b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b6:	e8 49 ff ff ff       	call   801404 <fd_close>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	eb ec                	jmp    8014ac <close+0x1d>

008014c0 <close_all>:

void
close_all(void)
{
  8014c0:	f3 0f 1e fb          	endbr32 
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014cb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	53                   	push   %ebx
  8014d4:	e8 b6 ff ff ff       	call   80148f <close>
	for (i = 0; i < MAXFD; i++)
  8014d9:	83 c3 01             	add    $0x1,%ebx
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	83 fb 20             	cmp    $0x20,%ebx
  8014e2:	75 ec                	jne    8014d0 <close_all+0x10>
}
  8014e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014e9:	f3 0f 1e fb          	endbr32 
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	ff 75 08             	pushl  0x8(%ebp)
  8014fd:	e8 54 fe ff ff       	call   801356 <fd_lookup>
  801502:	89 c3                	mov    %eax,%ebx
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	0f 88 81 00 00 00    	js     801590 <dup+0xa7>
		return r;
	close(newfdnum);
  80150f:	83 ec 0c             	sub    $0xc,%esp
  801512:	ff 75 0c             	pushl  0xc(%ebp)
  801515:	e8 75 ff ff ff       	call   80148f <close>

	newfd = INDEX2FD(newfdnum);
  80151a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80151d:	c1 e6 0c             	shl    $0xc,%esi
  801520:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801526:	83 c4 04             	add    $0x4,%esp
  801529:	ff 75 e4             	pushl  -0x1c(%ebp)
  80152c:	e8 b0 fd ff ff       	call   8012e1 <fd2data>
  801531:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801533:	89 34 24             	mov    %esi,(%esp)
  801536:	e8 a6 fd ff ff       	call   8012e1 <fd2data>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801540:	89 d8                	mov    %ebx,%eax
  801542:	c1 e8 16             	shr    $0x16,%eax
  801545:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80154c:	a8 01                	test   $0x1,%al
  80154e:	74 11                	je     801561 <dup+0x78>
  801550:	89 d8                	mov    %ebx,%eax
  801552:	c1 e8 0c             	shr    $0xc,%eax
  801555:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80155c:	f6 c2 01             	test   $0x1,%dl
  80155f:	75 39                	jne    80159a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801564:	89 d0                	mov    %edx,%eax
  801566:	c1 e8 0c             	shr    $0xc,%eax
  801569:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801570:	83 ec 0c             	sub    $0xc,%esp
  801573:	25 07 0e 00 00       	and    $0xe07,%eax
  801578:	50                   	push   %eax
  801579:	56                   	push   %esi
  80157a:	6a 00                	push   $0x0
  80157c:	52                   	push   %edx
  80157d:	6a 00                	push   $0x0
  80157f:	e8 63 f6 ff ff       	call   800be7 <sys_page_map>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 20             	add    $0x20,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 31                	js     8015be <dup+0xd5>
		goto err;

	return newfdnum;
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801590:	89 d8                	mov    %ebx,%eax
  801592:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5f                   	pop    %edi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80159a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a9:	50                   	push   %eax
  8015aa:	57                   	push   %edi
  8015ab:	6a 00                	push   $0x0
  8015ad:	53                   	push   %ebx
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 32 f6 ff ff       	call   800be7 <sys_page_map>
  8015b5:	89 c3                	mov    %eax,%ebx
  8015b7:	83 c4 20             	add    $0x20,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	79 a3                	jns    801561 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	56                   	push   %esi
  8015c2:	6a 00                	push   $0x0
  8015c4:	e8 48 f6 ff ff       	call   800c11 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c9:	83 c4 08             	add    $0x8,%esp
  8015cc:	57                   	push   %edi
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 3d f6 ff ff       	call   800c11 <sys_page_unmap>
	return r;
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	eb b7                	jmp    801590 <dup+0xa7>

008015d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015d9:	f3 0f 1e fb          	endbr32 
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	53                   	push   %ebx
  8015e1:	83 ec 1c             	sub    $0x1c,%esp
  8015e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	53                   	push   %ebx
  8015ec:	e8 65 fd ff ff       	call   801356 <fd_lookup>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 3f                	js     801637 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	50                   	push   %eax
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	ff 30                	pushl  (%eax)
  801604:	e8 a1 fd ff ff       	call   8013aa <dev_lookup>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 27                	js     801637 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801610:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801613:	8b 42 08             	mov    0x8(%edx),%eax
  801616:	83 e0 03             	and    $0x3,%eax
  801619:	83 f8 01             	cmp    $0x1,%eax
  80161c:	74 1e                	je     80163c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	8b 40 08             	mov    0x8(%eax),%eax
  801624:	85 c0                	test   %eax,%eax
  801626:	74 35                	je     80165d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	ff 75 10             	pushl  0x10(%ebp)
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	52                   	push   %edx
  801632:	ff d0                	call   *%eax
  801634:	83 c4 10             	add    $0x10,%esp
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80163c:	a1 04 40 80 00       	mov    0x804004,%eax
  801641:	8b 40 48             	mov    0x48(%eax),%eax
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	53                   	push   %ebx
  801648:	50                   	push   %eax
  801649:	68 79 29 80 00       	push   $0x802979
  80164e:	e8 7a eb ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165b:	eb da                	jmp    801637 <read+0x5e>
		return -E_NOT_SUPP;
  80165d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801662:	eb d3                	jmp    801637 <read+0x5e>

00801664 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801664:	f3 0f 1e fb          	endbr32 
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	57                   	push   %edi
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	8b 7d 08             	mov    0x8(%ebp),%edi
  801674:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801677:	bb 00 00 00 00       	mov    $0x0,%ebx
  80167c:	eb 02                	jmp    801680 <readn+0x1c>
  80167e:	01 c3                	add    %eax,%ebx
  801680:	39 f3                	cmp    %esi,%ebx
  801682:	73 21                	jae    8016a5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	89 f0                	mov    %esi,%eax
  801689:	29 d8                	sub    %ebx,%eax
  80168b:	50                   	push   %eax
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	03 45 0c             	add    0xc(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	57                   	push   %edi
  801693:	e8 41 ff ff ff       	call   8015d9 <read>
		if (m < 0)
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 04                	js     8016a3 <readn+0x3f>
			return m;
		if (m == 0)
  80169f:	75 dd                	jne    80167e <readn+0x1a>
  8016a1:	eb 02                	jmp    8016a5 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016a5:	89 d8                	mov    %ebx,%eax
  8016a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016af:	f3 0f 1e fb          	endbr32 
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 1c             	sub    $0x1c,%esp
  8016ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c0:	50                   	push   %eax
  8016c1:	53                   	push   %ebx
  8016c2:	e8 8f fc ff ff       	call   801356 <fd_lookup>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	78 3a                	js     801708 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ce:	83 ec 08             	sub    $0x8,%esp
  8016d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d4:	50                   	push   %eax
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	ff 30                	pushl  (%eax)
  8016da:	e8 cb fc ff ff       	call   8013aa <dev_lookup>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 22                	js     801708 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ed:	74 1e                	je     80170d <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8016f5:	85 d2                	test   %edx,%edx
  8016f7:	74 35                	je     80172e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	ff 75 10             	pushl  0x10(%ebp)
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	50                   	push   %eax
  801703:	ff d2                	call   *%edx
  801705:	83 c4 10             	add    $0x10,%esp
}
  801708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80170d:	a1 04 40 80 00       	mov    0x804004,%eax
  801712:	8b 40 48             	mov    0x48(%eax),%eax
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	53                   	push   %ebx
  801719:	50                   	push   %eax
  80171a:	68 95 29 80 00       	push   $0x802995
  80171f:	e8 a9 ea ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172c:	eb da                	jmp    801708 <write+0x59>
		return -E_NOT_SUPP;
  80172e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801733:	eb d3                	jmp    801708 <write+0x59>

00801735 <seek>:

int
seek(int fdnum, off_t offset)
{
  801735:	f3 0f 1e fb          	endbr32 
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801742:	50                   	push   %eax
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	e8 0b fc ff ff       	call   801356 <fd_lookup>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 0e                	js     801760 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801762:	f3 0f 1e fb          	endbr32 
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	53                   	push   %ebx
  80176a:	83 ec 1c             	sub    $0x1c,%esp
  80176d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801770:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801773:	50                   	push   %eax
  801774:	53                   	push   %ebx
  801775:	e8 dc fb ff ff       	call   801356 <fd_lookup>
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 37                	js     8017b8 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801787:	50                   	push   %eax
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	ff 30                	pushl  (%eax)
  80178d:	e8 18 fc ff ff       	call   8013aa <dev_lookup>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 1f                	js     8017b8 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017a0:	74 1b                	je     8017bd <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a5:	8b 52 18             	mov    0x18(%edx),%edx
  8017a8:	85 d2                	test   %edx,%edx
  8017aa:	74 32                	je     8017de <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	50                   	push   %eax
  8017b3:	ff d2                	call   *%edx
  8017b5:	83 c4 10             	add    $0x10,%esp
}
  8017b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017bd:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017c2:	8b 40 48             	mov    0x48(%eax),%eax
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	53                   	push   %ebx
  8017c9:	50                   	push   %eax
  8017ca:	68 58 29 80 00       	push   $0x802958
  8017cf:	e8 f9 e9 ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017dc:	eb da                	jmp    8017b8 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e3:	eb d3                	jmp    8017b8 <ftruncate+0x56>

008017e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017e5:	f3 0f 1e fb          	endbr32 
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 1c             	sub    $0x1c,%esp
  8017f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f6:	50                   	push   %eax
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	e8 57 fb ff ff       	call   801356 <fd_lookup>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	85 c0                	test   %eax,%eax
  801804:	78 4b                	js     801851 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	ff 30                	pushl  (%eax)
  801812:	e8 93 fb ff ff       	call   8013aa <dev_lookup>
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 33                	js     801851 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801825:	74 2f                	je     801856 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801827:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80182a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801831:	00 00 00 
	stat->st_isdir = 0;
  801834:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80183b:	00 00 00 
	stat->st_dev = dev;
  80183e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	53                   	push   %ebx
  801848:	ff 75 f0             	pushl  -0x10(%ebp)
  80184b:	ff 50 14             	call   *0x14(%eax)
  80184e:	83 c4 10             	add    $0x10,%esp
}
  801851:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801854:	c9                   	leave  
  801855:	c3                   	ret    
		return -E_NOT_SUPP;
  801856:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80185b:	eb f4                	jmp    801851 <fstat+0x6c>

0080185d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80185d:	f3 0f 1e fb          	endbr32 
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	6a 00                	push   $0x0
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	e8 3a 02 00 00       	call   801aad <open>
  801873:	89 c3                	mov    %eax,%ebx
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 1b                	js     801897 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	50                   	push   %eax
  801883:	e8 5d ff ff ff       	call   8017e5 <fstat>
  801888:	89 c6                	mov    %eax,%esi
	close(fd);
  80188a:	89 1c 24             	mov    %ebx,(%esp)
  80188d:	e8 fd fb ff ff       	call   80148f <close>
	return r;
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 f3                	mov    %esi,%ebx
}
  801897:	89 d8                	mov    %ebx,%eax
  801899:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	89 c6                	mov    %eax,%esi
  8018a7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018a9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018b0:	74 27                	je     8018d9 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018b2:	6a 07                	push   $0x7
  8018b4:	68 00 50 80 00       	push   $0x805000
  8018b9:	56                   	push   %esi
  8018ba:	ff 35 00 40 80 00    	pushl  0x804000
  8018c0:	e8 73 f9 ff ff       	call   801238 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018c5:	83 c4 0c             	add    $0xc,%esp
  8018c8:	6a 00                	push   $0x0
  8018ca:	53                   	push   %ebx
  8018cb:	6a 00                	push   $0x0
  8018cd:	e8 f9 f8 ff ff       	call   8011cb <ipc_recv>
}
  8018d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	6a 01                	push   $0x1
  8018de:	e8 ad f9 ff ff       	call   801290 <ipc_find_env>
  8018e3:	a3 00 40 80 00       	mov    %eax,0x804000
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb c5                	jmp    8018b2 <fsipc+0x12>

008018ed <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ed:	f3 0f 1e fb          	endbr32 
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80190a:	ba 00 00 00 00       	mov    $0x0,%edx
  80190f:	b8 02 00 00 00       	mov    $0x2,%eax
  801914:	e8 87 ff ff ff       	call   8018a0 <fsipc>
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <devfile_flush>:
{
  80191b:	f3 0f 1e fb          	endbr32 
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8b 40 0c             	mov    0xc(%eax),%eax
  80192b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	b8 06 00 00 00       	mov    $0x6,%eax
  80193a:	e8 61 ff ff ff       	call   8018a0 <fsipc>
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <devfile_stat>:
{
  801941:	f3 0f 1e fb          	endbr32 
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	53                   	push   %ebx
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
  801955:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	b8 05 00 00 00       	mov    $0x5,%eax
  801964:	e8 37 ff ff ff       	call   8018a0 <fsipc>
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 2c                	js     801999 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	68 00 50 80 00       	push   $0x805000
  801975:	53                   	push   %ebx
  801976:	e8 bc ed ff ff       	call   800737 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80197b:	a1 80 50 80 00       	mov    0x805080,%eax
  801980:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801986:	a1 84 50 80 00       	mov    0x805084,%eax
  80198b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devfile_write>:
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019b7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019bd:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019c3:	77 30                	ja     8019f5 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	53                   	push   %ebx
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	68 08 50 80 00       	push   $0x805008
  8019d1:	e8 19 ef ff ff       	call   8008ef <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019db:	b8 04 00 00 00       	mov    $0x4,%eax
  8019e0:	e8 bb fe ff ff       	call   8018a0 <fsipc>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 04                	js     8019f0 <devfile_write+0x52>
	assert(r <= n);
  8019ec:	39 d8                	cmp    %ebx,%eax
  8019ee:	77 1e                	ja     801a0e <devfile_write+0x70>
}
  8019f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019f5:	68 c4 29 80 00       	push   $0x8029c4
  8019fa:	68 f1 29 80 00       	push   $0x8029f1
  8019ff:	68 94 00 00 00       	push   $0x94
  801a04:	68 06 2a 80 00       	push   $0x802a06
  801a09:	e8 47 06 00 00       	call   802055 <_panic>
	assert(r <= n);
  801a0e:	68 11 2a 80 00       	push   $0x802a11
  801a13:	68 f1 29 80 00       	push   $0x8029f1
  801a18:	68 98 00 00 00       	push   $0x98
  801a1d:	68 06 2a 80 00       	push   $0x802a06
  801a22:	e8 2e 06 00 00       	call   802055 <_panic>

00801a27 <devfile_read>:
{
  801a27:	f3 0f 1e fb          	endbr32 
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8b 40 0c             	mov    0xc(%eax),%eax
  801a39:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a3e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a44:	ba 00 00 00 00       	mov    $0x0,%edx
  801a49:	b8 03 00 00 00       	mov    $0x3,%eax
  801a4e:	e8 4d fe ff ff       	call   8018a0 <fsipc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 1f                	js     801a78 <devfile_read+0x51>
	assert(r <= n);
  801a59:	39 f0                	cmp    %esi,%eax
  801a5b:	77 24                	ja     801a81 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a5d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a62:	7f 33                	jg     801a97 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	50                   	push   %eax
  801a68:	68 00 50 80 00       	push   $0x805000
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	e8 7a ee ff ff       	call   8008ef <memmove>
	return r;
  801a75:	83 c4 10             	add    $0x10,%esp
}
  801a78:	89 d8                	mov    %ebx,%eax
  801a7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5e                   	pop    %esi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    
	assert(r <= n);
  801a81:	68 11 2a 80 00       	push   $0x802a11
  801a86:	68 f1 29 80 00       	push   $0x8029f1
  801a8b:	6a 7c                	push   $0x7c
  801a8d:	68 06 2a 80 00       	push   $0x802a06
  801a92:	e8 be 05 00 00       	call   802055 <_panic>
	assert(r <= PGSIZE);
  801a97:	68 18 2a 80 00       	push   $0x802a18
  801a9c:	68 f1 29 80 00       	push   $0x8029f1
  801aa1:	6a 7d                	push   $0x7d
  801aa3:	68 06 2a 80 00       	push   $0x802a06
  801aa8:	e8 a8 05 00 00       	call   802055 <_panic>

00801aad <open>:
{
  801aad:	f3 0f 1e fb          	endbr32 
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 1c             	sub    $0x1c,%esp
  801ab9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801abc:	56                   	push   %esi
  801abd:	e8 32 ec ff ff       	call   8006f4 <strlen>
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aca:	7f 6c                	jg     801b38 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	50                   	push   %eax
  801ad3:	e8 28 f8 ff ff       	call   801300 <fd_alloc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 3c                	js     801b1d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	56                   	push   %esi
  801ae5:	68 00 50 80 00       	push   $0x805000
  801aea:	e8 48 ec ff ff       	call   800737 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801afa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aff:	e8 9c fd ff ff       	call   8018a0 <fsipc>
  801b04:	89 c3                	mov    %eax,%ebx
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 19                	js     801b26 <open+0x79>
	return fd2num(fd);
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 b5 f7 ff ff       	call   8012cd <fd2num>
  801b18:	89 c3                	mov    %eax,%ebx
  801b1a:	83 c4 10             	add    $0x10,%esp
}
  801b1d:	89 d8                	mov    %ebx,%eax
  801b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    
		fd_close(fd, 0);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2e:	e8 d1 f8 ff ff       	call   801404 <fd_close>
		return r;
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	eb e5                	jmp    801b1d <open+0x70>
		return -E_BAD_PATH;
  801b38:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b3d:	eb de                	jmp    801b1d <open+0x70>

00801b3f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b3f:	f3 0f 1e fb          	endbr32 
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b53:	e8 48 fd ff ff       	call   8018a0 <fsipc>
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b5a:	f3 0f 1e fb          	endbr32 
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	56                   	push   %esi
  801b62:	53                   	push   %ebx
  801b63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	ff 75 08             	pushl  0x8(%ebp)
  801b6c:	e8 70 f7 ff ff       	call   8012e1 <fd2data>
  801b71:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b73:	83 c4 08             	add    $0x8,%esp
  801b76:	68 24 2a 80 00       	push   $0x802a24
  801b7b:	53                   	push   %ebx
  801b7c:	e8 b6 eb ff ff       	call   800737 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b81:	8b 46 04             	mov    0x4(%esi),%eax
  801b84:	2b 06                	sub    (%esi),%eax
  801b86:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b8c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b93:	00 00 00 
	stat->st_dev = &devpipe;
  801b96:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b9d:	30 80 00 
	return 0;
}
  801ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bac:	f3 0f 1e fb          	endbr32 
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 0c             	sub    $0xc,%esp
  801bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bba:	53                   	push   %ebx
  801bbb:	6a 00                	push   $0x0
  801bbd:	e8 4f f0 ff ff       	call   800c11 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bc2:	89 1c 24             	mov    %ebx,(%esp)
  801bc5:	e8 17 f7 ff ff       	call   8012e1 <fd2data>
  801bca:	83 c4 08             	add    $0x8,%esp
  801bcd:	50                   	push   %eax
  801bce:	6a 00                	push   $0x0
  801bd0:	e8 3c f0 ff ff       	call   800c11 <sys_page_unmap>
}
  801bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <_pipeisclosed>:
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	57                   	push   %edi
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 1c             	sub    $0x1c,%esp
  801be3:	89 c7                	mov    %eax,%edi
  801be5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801be7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bec:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bef:	83 ec 0c             	sub    $0xc,%esp
  801bf2:	57                   	push   %edi
  801bf3:	e8 4a 05 00 00       	call   802142 <pageref>
  801bf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bfb:	89 34 24             	mov    %esi,(%esp)
  801bfe:	e8 3f 05 00 00       	call   802142 <pageref>
		nn = thisenv->env_runs;
  801c03:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c09:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	39 cb                	cmp    %ecx,%ebx
  801c11:	74 1b                	je     801c2e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c13:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c16:	75 cf                	jne    801be7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c18:	8b 42 58             	mov    0x58(%edx),%eax
  801c1b:	6a 01                	push   $0x1
  801c1d:	50                   	push   %eax
  801c1e:	53                   	push   %ebx
  801c1f:	68 2b 2a 80 00       	push   $0x802a2b
  801c24:	e8 a4 e5 ff ff       	call   8001cd <cprintf>
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	eb b9                	jmp    801be7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c2e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c31:	0f 94 c0             	sete   %al
  801c34:	0f b6 c0             	movzbl %al,%eax
}
  801c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5f                   	pop    %edi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    

00801c3f <devpipe_write>:
{
  801c3f:	f3 0f 1e fb          	endbr32 
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	57                   	push   %edi
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	83 ec 28             	sub    $0x28,%esp
  801c4c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c4f:	56                   	push   %esi
  801c50:	e8 8c f6 ff ff       	call   8012e1 <fd2data>
  801c55:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c62:	74 4f                	je     801cb3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c64:	8b 43 04             	mov    0x4(%ebx),%eax
  801c67:	8b 0b                	mov    (%ebx),%ecx
  801c69:	8d 51 20             	lea    0x20(%ecx),%edx
  801c6c:	39 d0                	cmp    %edx,%eax
  801c6e:	72 14                	jb     801c84 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c70:	89 da                	mov    %ebx,%edx
  801c72:	89 f0                	mov    %esi,%eax
  801c74:	e8 61 ff ff ff       	call   801bda <_pipeisclosed>
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	75 3b                	jne    801cb8 <devpipe_write+0x79>
			sys_yield();
  801c7d:	e8 12 ef ff ff       	call   800b94 <sys_yield>
  801c82:	eb e0                	jmp    801c64 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c87:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c8b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c8e:	89 c2                	mov    %eax,%edx
  801c90:	c1 fa 1f             	sar    $0x1f,%edx
  801c93:	89 d1                	mov    %edx,%ecx
  801c95:	c1 e9 1b             	shr    $0x1b,%ecx
  801c98:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c9b:	83 e2 1f             	and    $0x1f,%edx
  801c9e:	29 ca                	sub    %ecx,%edx
  801ca0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ca4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ca8:	83 c0 01             	add    $0x1,%eax
  801cab:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cae:	83 c7 01             	add    $0x1,%edi
  801cb1:	eb ac                	jmp    801c5f <devpipe_write+0x20>
	return i;
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	eb 05                	jmp    801cbd <devpipe_write+0x7e>
				return 0;
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    

00801cc5 <devpipe_read>:
{
  801cc5:	f3 0f 1e fb          	endbr32 
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 18             	sub    $0x18,%esp
  801cd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cd5:	57                   	push   %edi
  801cd6:	e8 06 f6 ff ff       	call   8012e1 <fd2data>
  801cdb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	be 00 00 00 00       	mov    $0x0,%esi
  801ce5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ce8:	75 14                	jne    801cfe <devpipe_read+0x39>
	return i;
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	eb 02                	jmp    801cf1 <devpipe_read+0x2c>
				return i;
  801cef:	89 f0                	mov    %esi,%eax
}
  801cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5f                   	pop    %edi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    
			sys_yield();
  801cf9:	e8 96 ee ff ff       	call   800b94 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cfe:	8b 03                	mov    (%ebx),%eax
  801d00:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d03:	75 18                	jne    801d1d <devpipe_read+0x58>
			if (i > 0)
  801d05:	85 f6                	test   %esi,%esi
  801d07:	75 e6                	jne    801cef <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d09:	89 da                	mov    %ebx,%edx
  801d0b:	89 f8                	mov    %edi,%eax
  801d0d:	e8 c8 fe ff ff       	call   801bda <_pipeisclosed>
  801d12:	85 c0                	test   %eax,%eax
  801d14:	74 e3                	je     801cf9 <devpipe_read+0x34>
				return 0;
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	eb d4                	jmp    801cf1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d1d:	99                   	cltd   
  801d1e:	c1 ea 1b             	shr    $0x1b,%edx
  801d21:	01 d0                	add    %edx,%eax
  801d23:	83 e0 1f             	and    $0x1f,%eax
  801d26:	29 d0                	sub    %edx,%eax
  801d28:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d30:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d33:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d36:	83 c6 01             	add    $0x1,%esi
  801d39:	eb aa                	jmp    801ce5 <devpipe_read+0x20>

00801d3b <pipe>:
{
  801d3b:	f3 0f 1e fb          	endbr32 
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4a:	50                   	push   %eax
  801d4b:	e8 b0 f5 ff ff       	call   801300 <fd_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	85 c0                	test   %eax,%eax
  801d57:	0f 88 23 01 00 00    	js     801e80 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 07 04 00 00       	push   $0x407
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 50 ee ff ff       	call   800bbf <sys_page_alloc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 88 04 01 00 00    	js     801e80 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d82:	50                   	push   %eax
  801d83:	e8 78 f5 ff ff       	call   801300 <fd_alloc>
  801d88:	89 c3                	mov    %eax,%ebx
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 88 db 00 00 00    	js     801e70 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	68 07 04 00 00       	push   $0x407
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	6a 00                	push   $0x0
  801da2:	e8 18 ee ff ff       	call   800bbf <sys_page_alloc>
  801da7:	89 c3                	mov    %eax,%ebx
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	85 c0                	test   %eax,%eax
  801dae:	0f 88 bc 00 00 00    	js     801e70 <pipe+0x135>
	va = fd2data(fd0);
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dba:	e8 22 f5 ff ff       	call   8012e1 <fd2data>
  801dbf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc1:	83 c4 0c             	add    $0xc,%esp
  801dc4:	68 07 04 00 00       	push   $0x407
  801dc9:	50                   	push   %eax
  801dca:	6a 00                	push   $0x0
  801dcc:	e8 ee ed ff ff       	call   800bbf <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	0f 88 82 00 00 00    	js     801e60 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	ff 75 f0             	pushl  -0x10(%ebp)
  801de4:	e8 f8 f4 ff ff       	call   8012e1 <fd2data>
  801de9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801df0:	50                   	push   %eax
  801df1:	6a 00                	push   $0x0
  801df3:	56                   	push   %esi
  801df4:	6a 00                	push   $0x0
  801df6:	e8 ec ed ff ff       	call   800be7 <sys_page_map>
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	83 c4 20             	add    $0x20,%esp
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 4e                	js     801e52 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e04:	a1 20 30 80 00       	mov    0x803020,%eax
  801e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e11:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e20:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2d:	e8 9b f4 ff ff       	call   8012cd <fd2num>
  801e32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e35:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e37:	83 c4 04             	add    $0x4,%esp
  801e3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3d:	e8 8b f4 ff ff       	call   8012cd <fd2num>
  801e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e45:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e50:	eb 2e                	jmp    801e80 <pipe+0x145>
	sys_page_unmap(0, va);
  801e52:	83 ec 08             	sub    $0x8,%esp
  801e55:	56                   	push   %esi
  801e56:	6a 00                	push   $0x0
  801e58:	e8 b4 ed ff ff       	call   800c11 <sys_page_unmap>
  801e5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e60:	83 ec 08             	sub    $0x8,%esp
  801e63:	ff 75 f0             	pushl  -0x10(%ebp)
  801e66:	6a 00                	push   $0x0
  801e68:	e8 a4 ed ff ff       	call   800c11 <sys_page_unmap>
  801e6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 f4             	pushl  -0xc(%ebp)
  801e76:	6a 00                	push   $0x0
  801e78:	e8 94 ed ff ff       	call   800c11 <sys_page_unmap>
  801e7d:	83 c4 10             	add    $0x10,%esp
}
  801e80:	89 d8                	mov    %ebx,%eax
  801e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <pipeisclosed>:
{
  801e89:	f3 0f 1e fb          	endbr32 
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e96:	50                   	push   %eax
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	e8 b7 f4 ff ff       	call   801356 <fd_lookup>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	78 18                	js     801ebe <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	ff 75 f4             	pushl  -0xc(%ebp)
  801eac:	e8 30 f4 ff ff       	call   8012e1 <fd2data>
  801eb1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	e8 1f fd ff ff       	call   801bda <_pipeisclosed>
  801ebb:	83 c4 10             	add    $0x10,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ec0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	c3                   	ret    

00801eca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eca:	f3 0f 1e fb          	endbr32 
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ed4:	68 43 2a 80 00       	push   $0x802a43
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	e8 56 e8 ff ff       	call   800737 <strcpy>
	return 0;
}
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <devcons_write>:
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	57                   	push   %edi
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ef8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801efd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f03:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f06:	73 31                	jae    801f39 <devcons_write+0x51>
		m = n - tot;
  801f08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f0b:	29 f3                	sub    %esi,%ebx
  801f0d:	83 fb 7f             	cmp    $0x7f,%ebx
  801f10:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f15:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	53                   	push   %ebx
  801f1c:	89 f0                	mov    %esi,%eax
  801f1e:	03 45 0c             	add    0xc(%ebp),%eax
  801f21:	50                   	push   %eax
  801f22:	57                   	push   %edi
  801f23:	e8 c7 e9 ff ff       	call   8008ef <memmove>
		sys_cputs(buf, m);
  801f28:	83 c4 08             	add    $0x8,%esp
  801f2b:	53                   	push   %ebx
  801f2c:	57                   	push   %edi
  801f2d:	e8 c2 eb ff ff       	call   800af4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f32:	01 de                	add    %ebx,%esi
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	eb ca                	jmp    801f03 <devcons_write+0x1b>
}
  801f39:	89 f0                	mov    %esi,%eax
  801f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5f                   	pop    %edi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <devcons_read>:
{
  801f43:	f3 0f 1e fb          	endbr32 
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 08             	sub    $0x8,%esp
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f56:	74 21                	je     801f79 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f58:	e8 c1 eb ff ff       	call   800b1e <sys_cgetc>
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	75 07                	jne    801f68 <devcons_read+0x25>
		sys_yield();
  801f61:	e8 2e ec ff ff       	call   800b94 <sys_yield>
  801f66:	eb f0                	jmp    801f58 <devcons_read+0x15>
	if (c < 0)
  801f68:	78 0f                	js     801f79 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f6a:	83 f8 04             	cmp    $0x4,%eax
  801f6d:	74 0c                	je     801f7b <devcons_read+0x38>
	*(char*)vbuf = c;
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	88 02                	mov    %al,(%edx)
	return 1;
  801f74:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    
		return 0;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb f7                	jmp    801f79 <devcons_read+0x36>

00801f82 <cputchar>:
{
  801f82:	f3 0f 1e fb          	endbr32 
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f92:	6a 01                	push   $0x1
  801f94:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f97:	50                   	push   %eax
  801f98:	e8 57 eb ff ff       	call   800af4 <sys_cputs>
}
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <getchar>:
{
  801fa2:	f3 0f 1e fb          	endbr32 
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fac:	6a 01                	push   $0x1
  801fae:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	e8 20 f6 ff ff       	call   8015d9 <read>
	if (r < 0)
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 06                	js     801fc6 <getchar+0x24>
	if (r < 1)
  801fc0:	74 06                	je     801fc8 <getchar+0x26>
	return c;
  801fc2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    
		return -E_EOF;
  801fc8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fcd:	eb f7                	jmp    801fc6 <getchar+0x24>

00801fcf <iscons>:
{
  801fcf:	f3 0f 1e fb          	endbr32 
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdc:	50                   	push   %eax
  801fdd:	ff 75 08             	pushl  0x8(%ebp)
  801fe0:	e8 71 f3 ff ff       	call   801356 <fd_lookup>
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 11                	js     801ffd <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff5:	39 10                	cmp    %edx,(%eax)
  801ff7:	0f 94 c0             	sete   %al
  801ffa:	0f b6 c0             	movzbl %al,%eax
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <opencons>:
{
  801fff:	f3 0f 1e fb          	endbr32 
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802009:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200c:	50                   	push   %eax
  80200d:	e8 ee f2 ff ff       	call   801300 <fd_alloc>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	85 c0                	test   %eax,%eax
  802017:	78 3a                	js     802053 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 07 04 00 00       	push   $0x407
  802021:	ff 75 f4             	pushl  -0xc(%ebp)
  802024:	6a 00                	push   $0x0
  802026:	e8 94 eb ff ff       	call   800bbf <sys_page_alloc>
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	85 c0                	test   %eax,%eax
  802030:	78 21                	js     802053 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	50                   	push   %eax
  80204b:	e8 7d f2 ff ff       	call   8012cd <fd2num>
  802050:	83 c4 10             	add    $0x10,%esp
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802055:	f3 0f 1e fb          	endbr32 
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	56                   	push   %esi
  80205d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80205e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802061:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802067:	e8 00 eb ff ff       	call   800b6c <sys_getenvid>
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	56                   	push   %esi
  802076:	50                   	push   %eax
  802077:	68 50 2a 80 00       	push   $0x802a50
  80207c:	e8 4c e1 ff ff       	call   8001cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802081:	83 c4 18             	add    $0x18,%esp
  802084:	53                   	push   %ebx
  802085:	ff 75 10             	pushl  0x10(%ebp)
  802088:	e8 eb e0 ff ff       	call   800178 <vcprintf>
	cprintf("\n");
  80208d:	c7 04 24 29 29 80 00 	movl   $0x802929,(%esp)
  802094:	e8 34 e1 ff ff       	call   8001cd <cprintf>
  802099:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80209c:	cc                   	int3   
  80209d:	eb fd                	jmp    80209c <_panic+0x47>

0080209f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80209f:	f3 0f 1e fb          	endbr32 
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020a9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020b0:	74 0a                	je     8020bc <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  8020bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8020c1:	8b 40 48             	mov    0x48(%eax),%eax
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	6a 07                	push   $0x7
  8020c9:	68 00 f0 bf ee       	push   $0xeebff000
  8020ce:	50                   	push   %eax
  8020cf:	e8 eb ea ff ff       	call   800bbf <sys_page_alloc>
		if (r!= 0)
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	75 2f                	jne    80210a <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8020db:	a1 04 40 80 00       	mov    0x804004,%eax
  8020e0:	8b 40 48             	mov    0x48(%eax),%eax
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	68 1c 21 80 00       	push   $0x80211c
  8020eb:	50                   	push   %eax
  8020ec:	e8 95 eb ff ff       	call   800c86 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 ba                	je     8020b2 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  8020f8:	50                   	push   %eax
  8020f9:	68 73 2a 80 00       	push   $0x802a73
  8020fe:	6a 26                	push   $0x26
  802100:	68 8b 2a 80 00       	push   $0x802a8b
  802105:	e8 4b ff ff ff       	call   802055 <_panic>
			panic("set_pgfault_handler: %e", r);
  80210a:	50                   	push   %eax
  80210b:	68 73 2a 80 00       	push   $0x802a73
  802110:	6a 22                	push   $0x22
  802112:	68 8b 2a 80 00       	push   $0x802a8b
  802117:	e8 39 ff ff ff       	call   802055 <_panic>

0080211c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80211c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80211d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802122:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802124:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802127:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80212b:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80212e:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802132:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802136:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802138:	83 c4 08             	add    $0x8,%esp
	popal
  80213b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80213c:	83 c4 04             	add    $0x4,%esp
	popfl
  80213f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802140:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802141:	c3                   	ret    

00802142 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802142:	f3 0f 1e fb          	endbr32 
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80214c:	89 c2                	mov    %eax,%edx
  80214e:	c1 ea 16             	shr    $0x16,%edx
  802151:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802158:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80215d:	f6 c1 01             	test   $0x1,%cl
  802160:	74 1c                	je     80217e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802162:	c1 e8 0c             	shr    $0xc,%eax
  802165:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80216c:	a8 01                	test   $0x1,%al
  80216e:	74 0e                	je     80217e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802170:	c1 e8 0c             	shr    $0xc,%eax
  802173:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80217a:	ef 
  80217b:	0f b7 d2             	movzwl %dx,%edx
}
  80217e:	89 d0                	mov    %edx,%eax
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    
  802182:	66 90                	xchg   %ax,%ax
  802184:	66 90                	xchg   %ax,%ax
  802186:	66 90                	xchg   %ax,%ax
  802188:	66 90                	xchg   %ax,%ax
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	66 90                	xchg   %ax,%ax
  80218e:	66 90                	xchg   %ax,%ax

00802190 <__udivdi3>:
  802190:	f3 0f 1e fb          	endbr32 
  802194:	55                   	push   %ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021ab:	85 d2                	test   %edx,%edx
  8021ad:	75 19                	jne    8021c8 <__udivdi3+0x38>
  8021af:	39 f3                	cmp    %esi,%ebx
  8021b1:	76 4d                	jbe    802200 <__udivdi3+0x70>
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	89 e8                	mov    %ebp,%eax
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	f7 f3                	div    %ebx
  8021bb:	89 fa                	mov    %edi,%edx
  8021bd:	83 c4 1c             	add    $0x1c,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	76 14                	jbe    8021e0 <__udivdi3+0x50>
  8021cc:	31 ff                	xor    %edi,%edi
  8021ce:	31 c0                	xor    %eax,%eax
  8021d0:	89 fa                	mov    %edi,%edx
  8021d2:	83 c4 1c             	add    $0x1c,%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5f                   	pop    %edi
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    
  8021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e0:	0f bd fa             	bsr    %edx,%edi
  8021e3:	83 f7 1f             	xor    $0x1f,%edi
  8021e6:	75 48                	jne    802230 <__udivdi3+0xa0>
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x62>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 de                	ja     8021d0 <__udivdi3+0x40>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb d7                	jmp    8021d0 <__udivdi3+0x40>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d9                	mov    %ebx,%ecx
  802202:	85 db                	test   %ebx,%ebx
  802204:	75 0b                	jne    802211 <__udivdi3+0x81>
  802206:	b8 01 00 00 00       	mov    $0x1,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f3                	div    %ebx
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	31 d2                	xor    %edx,%edx
  802213:	89 f0                	mov    %esi,%eax
  802215:	f7 f1                	div    %ecx
  802217:	89 c6                	mov    %eax,%esi
  802219:	89 e8                	mov    %ebp,%eax
  80221b:	89 f7                	mov    %esi,%edi
  80221d:	f7 f1                	div    %ecx
  80221f:	89 fa                	mov    %edi,%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	89 eb                	mov    %ebp,%ebx
  802261:	d3 e6                	shl    %cl,%esi
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 15                	jb     802290 <__udivdi3+0x100>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 04                	jae    802287 <__udivdi3+0xf7>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	74 09                	je     802290 <__udivdi3+0x100>
  802287:	89 d8                	mov    %ebx,%eax
  802289:	31 ff                	xor    %edi,%edi
  80228b:	e9 40 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  802290:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802293:	31 ff                	xor    %edi,%edi
  802295:	e9 36 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__umoddi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	75 19                	jne    8022d8 <__umoddi3+0x38>
  8022bf:	39 df                	cmp    %ebx,%edi
  8022c1:	76 5d                	jbe    802320 <__umoddi3+0x80>
  8022c3:	89 f0                	mov    %esi,%eax
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	f7 f7                	div    %edi
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	89 f2                	mov    %esi,%edx
  8022da:	39 d8                	cmp    %ebx,%eax
  8022dc:	76 12                	jbe    8022f0 <__umoddi3+0x50>
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	89 da                	mov    %ebx,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd e8             	bsr    %eax,%ebp
  8022f3:	83 f5 1f             	xor    $0x1f,%ebp
  8022f6:	75 50                	jne    802348 <__umoddi3+0xa8>
  8022f8:	39 d8                	cmp    %ebx,%eax
  8022fa:	0f 82 e0 00 00 00    	jb     8023e0 <__umoddi3+0x140>
  802300:	89 d9                	mov    %ebx,%ecx
  802302:	39 f7                	cmp    %esi,%edi
  802304:	0f 86 d6 00 00 00    	jbe    8023e0 <__umoddi3+0x140>
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	89 ca                	mov    %ecx,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 fd                	mov    %edi,%ebp
  802322:	85 ff                	test   %edi,%edi
  802324:	75 0b                	jne    802331 <__umoddi3+0x91>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f7                	div    %edi
  80232f:	89 c5                	mov    %eax,%ebp
  802331:	89 d8                	mov    %ebx,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f5                	div    %ebp
  802337:	89 f0                	mov    %esi,%eax
  802339:	f7 f5                	div    %ebp
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	31 d2                	xor    %edx,%edx
  80233f:	eb 8c                	jmp    8022cd <__umoddi3+0x2d>
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 e9                	mov    %ebp,%ecx
  80234a:	ba 20 00 00 00       	mov    $0x20,%edx
  80234f:	29 ea                	sub    %ebp,%edx
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 44 24 08          	mov    %eax,0x8(%esp)
  802357:	89 d1                	mov    %edx,%ecx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802361:	89 54 24 04          	mov    %edx,0x4(%esp)
  802365:	8b 54 24 04          	mov    0x4(%esp),%edx
  802369:	09 c1                	or     %eax,%ecx
  80236b:	89 d8                	mov    %ebx,%eax
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 e7                	shl    %cl,%edi
  802375:	89 d1                	mov    %edx,%ecx
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80237f:	d3 e3                	shl    %cl,%ebx
  802381:	89 c7                	mov    %eax,%edi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	89 f0                	mov    %esi,%eax
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 fa                	mov    %edi,%edx
  80238d:	d3 e6                	shl    %cl,%esi
  80238f:	09 d8                	or     %ebx,%eax
  802391:	f7 74 24 08          	divl   0x8(%esp)
  802395:	89 d1                	mov    %edx,%ecx
  802397:	89 f3                	mov    %esi,%ebx
  802399:	f7 64 24 0c          	mull   0xc(%esp)
  80239d:	89 c6                	mov    %eax,%esi
  80239f:	89 d7                	mov    %edx,%edi
  8023a1:	39 d1                	cmp    %edx,%ecx
  8023a3:	72 06                	jb     8023ab <__umoddi3+0x10b>
  8023a5:	75 10                	jne    8023b7 <__umoddi3+0x117>
  8023a7:	39 c3                	cmp    %eax,%ebx
  8023a9:	73 0c                	jae    8023b7 <__umoddi3+0x117>
  8023ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023b3:	89 d7                	mov    %edx,%edi
  8023b5:	89 c6                	mov    %eax,%esi
  8023b7:	89 ca                	mov    %ecx,%edx
  8023b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023be:	29 f3                	sub    %esi,%ebx
  8023c0:	19 fa                	sbb    %edi,%edx
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	d3 e0                	shl    %cl,%eax
  8023c6:	89 e9                	mov    %ebp,%ecx
  8023c8:	d3 eb                	shr    %cl,%ebx
  8023ca:	d3 ea                	shr    %cl,%edx
  8023cc:	09 d8                	or     %ebx,%eax
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	29 fe                	sub    %edi,%esi
  8023e2:	19 c3                	sbb    %eax,%ebx
  8023e4:	89 f2                	mov    %esi,%edx
  8023e6:	89 d9                	mov    %ebx,%ecx
  8023e8:	e9 1d ff ff ff       	jmp    80230a <__umoddi3+0x6a>
