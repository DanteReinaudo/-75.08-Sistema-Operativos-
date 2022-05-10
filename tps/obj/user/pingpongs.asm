
obj/user/pingpongs.debug:     formato del fichero elf32-i386


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
  80002c:	e8 d6 00 00 00       	call   800107 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  800040:	e8 ab 11 00 00       	call   8011f0 <sfork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 74                	jne    8000c0 <umain+0x8d>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 00                	push   $0x0
  800051:	6a 00                	push   $0x0
  800053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 b2 11 00 00       	call   80120e <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 04 40 80 00       	mov    0x804004,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 3a 0b 00 00       	call   800baf <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 70 24 80 00       	push   $0x802470
  800084:	e8 87 01 00 00       	call   800210 <cprintf>
		if (val == 10)
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 cf 11 00 00       	call   80127b <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  8000b6:	75 94                	jne    80004c <umain+0x19>
			return;
	}

}
  8000b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000c0:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c6:	e8 e4 0a 00 00       	call   800baf <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 40 24 80 00       	push   $0x802440
  8000d5:	e8 36 01 00 00       	call   800210 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 cd 0a 00 00       	call   800baf <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 5a 24 80 00       	push   $0x80245a
  8000ec:	e8 1f 01 00 00       	call   800210 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 7c 11 00 00       	call   80127b <ipc_send>
  8000ff:	83 c4 20             	add    $0x20,%esp
  800102:	e9 45 ff ff ff       	jmp    80004c <umain+0x19>

00800107 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	56                   	push   %esi
  80010f:	53                   	push   %ebx
  800110:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800113:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800116:	e8 94 0a 00 00       	call   800baf <sys_getenvid>
	if (id >= 0)
  80011b:	85 c0                	test   %eax,%eax
  80011d:	78 12                	js     800131 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80011f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800124:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800127:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	85 db                	test   %ebx,%ebx
  800133:	7e 07                	jle    80013c <libmain+0x35>
		binaryname = argv[0];
  800135:	8b 06                	mov    (%esi),%eax
  800137:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
  800141:	e8 ed fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800146:	e8 0a 00 00 00       	call   800155 <exit>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015f:	e8 9f 13 00 00       	call   801503 <close_all>
	sys_env_destroy(0);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	6a 00                	push   $0x0
  800169:	e8 1b 0a 00 00       	call   800b89 <sys_env_destroy>
}
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800173:	f3 0f 1e fb          	endbr32 
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	53                   	push   %ebx
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800181:	8b 13                	mov    (%ebx),%edx
  800183:	8d 42 01             	lea    0x1(%edx),%eax
  800186:	89 03                	mov    %eax,(%ebx)
  800188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80018b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800194:	74 09                	je     80019f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800196:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	68 ff 00 00 00       	push   $0xff
  8001a7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 87 09 00 00       	call   800b37 <sys_cputs>
		b->idx = 0;
  8001b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	eb db                	jmp    800196 <putch+0x23>

008001bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001bb:	f3 0f 1e fb          	endbr32 
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cf:	00 00 00 
	b.cnt = 0;
  8001d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e8:	50                   	push   %eax
  8001e9:	68 73 01 80 00       	push   $0x800173
  8001ee:	e8 80 01 00 00       	call   800373 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f3:	83 c4 08             	add    $0x8,%esp
  8001f6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800202:	50                   	push   %eax
  800203:	e8 2f 09 00 00       	call   800b37 <sys_cputs>

	return b.cnt;
}
  800208:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021d:	50                   	push   %eax
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	e8 95 ff ff ff       	call   8001bb <vcprintf>
	va_end(ap);

	return cnt;
}
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 1c             	sub    $0x1c,%esp
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 d6                	mov    %edx,%esi
  800235:	8b 45 08             	mov    0x8(%ebp),%eax
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	89 d1                	mov    %edx,%ecx
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800242:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800245:	8b 45 10             	mov    0x10(%ebp),%eax
  800248:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800255:	39 c2                	cmp    %eax,%edx
  800257:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80025a:	72 3e                	jb     80029a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	ff 75 18             	pushl  0x18(%ebp)
  800262:	83 eb 01             	sub    $0x1,%ebx
  800265:	53                   	push   %ebx
  800266:	50                   	push   %eax
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026d:	ff 75 e0             	pushl  -0x20(%ebp)
  800270:	ff 75 dc             	pushl  -0x24(%ebp)
  800273:	ff 75 d8             	pushl  -0x28(%ebp)
  800276:	e8 55 1f 00 00       	call   8021d0 <__udivdi3>
  80027b:	83 c4 18             	add    $0x18,%esp
  80027e:	52                   	push   %edx
  80027f:	50                   	push   %eax
  800280:	89 f2                	mov    %esi,%edx
  800282:	89 f8                	mov    %edi,%eax
  800284:	e8 9f ff ff ff       	call   800228 <printnum>
  800289:	83 c4 20             	add    $0x20,%esp
  80028c:	eb 13                	jmp    8002a1 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	56                   	push   %esi
  800292:	ff 75 18             	pushl  0x18(%ebp)
  800295:	ff d7                	call   *%edi
  800297:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029a:	83 eb 01             	sub    $0x1,%ebx
  80029d:	85 db                	test   %ebx,%ebx
  80029f:	7f ed                	jg     80028e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	56                   	push   %esi
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b4:	e8 27 20 00 00       	call   8022e0 <__umoddi3>
  8002b9:	83 c4 14             	add    $0x14,%esp
  8002bc:	0f be 80 a0 24 80 00 	movsbl 0x8024a0(%eax),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff d7                	call   *%edi
}
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    

008002d1 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002d1:	83 fa 01             	cmp    $0x1,%edx
  8002d4:	7f 13                	jg     8002e9 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002d6:	85 d2                	test   %edx,%edx
  8002d8:	74 1c                	je     8002f6 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002da:	8b 10                	mov    (%eax),%edx
  8002dc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002df:	89 08                	mov    %ecx,(%eax)
  8002e1:	8b 02                	mov    (%edx),%eax
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 02                	mov    (%edx),%eax
  8002f2:	8b 52 04             	mov    0x4(%edx),%edx
  8002f5:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 02                	mov    (%edx),%eax
  8002ff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800304:	c3                   	ret    

00800305 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800305:	83 fa 01             	cmp    $0x1,%edx
  800308:	7f 0f                	jg     800319 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80030a:	85 d2                	test   %edx,%edx
  80030c:	74 18                	je     800326 <getint+0x21>
		return va_arg(*ap, long);
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8d 4a 04             	lea    0x4(%edx),%ecx
  800313:	89 08                	mov    %ecx,(%eax)
  800315:	8b 02                	mov    (%edx),%eax
  800317:	99                   	cltd   
  800318:	c3                   	ret    
		return va_arg(*ap, long long);
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	8d 4a 08             	lea    0x8(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 02                	mov    (%edx),%eax
  800322:	8b 52 04             	mov    0x4(%edx),%edx
  800325:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800326:	8b 10                	mov    (%eax),%edx
  800328:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032b:	89 08                	mov    %ecx,(%eax)
  80032d:	8b 02                	mov    (%edx),%eax
  80032f:	99                   	cltd   
}
  800330:	c3                   	ret    

00800331 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800331:	f3 0f 1e fb          	endbr32 
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033f:	8b 10                	mov    (%eax),%edx
  800341:	3b 50 04             	cmp    0x4(%eax),%edx
  800344:	73 0a                	jae    800350 <sprintputch+0x1f>
		*b->buf++ = ch;
  800346:	8d 4a 01             	lea    0x1(%edx),%ecx
  800349:	89 08                	mov    %ecx,(%eax)
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	88 02                	mov    %al,(%edx)
}
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <printfmt>:
{
  800352:	f3 0f 1e fb          	endbr32 
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80035c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035f:	50                   	push   %eax
  800360:	ff 75 10             	pushl  0x10(%ebp)
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	e8 05 00 00 00       	call   800373 <vprintfmt>
}
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <vprintfmt>:
{
  800373:	f3 0f 1e fb          	endbr32 
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	57                   	push   %edi
  80037b:	56                   	push   %esi
  80037c:	53                   	push   %ebx
  80037d:	83 ec 2c             	sub    $0x2c,%esp
  800380:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800383:	8b 75 0c             	mov    0xc(%ebp),%esi
  800386:	8b 7d 10             	mov    0x10(%ebp),%edi
  800389:	e9 86 02 00 00       	jmp    800614 <vprintfmt+0x2a1>
		padc = ' ';
  80038e:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800392:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800399:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003a0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8d 47 01             	lea    0x1(%edi),%eax
  8003af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b2:	0f b6 17             	movzbl (%edi),%edx
  8003b5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b8:	3c 55                	cmp    $0x55,%al
  8003ba:	0f 87 df 02 00 00    	ja     80069f <vprintfmt+0x32c>
  8003c0:	0f b6 c0             	movzbl %al,%eax
  8003c3:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  8003ca:	00 
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003d2:	eb d8                	jmp    8003ac <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d7:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003db:	eb cf                	jmp    8003ac <vprintfmt+0x39>
  8003dd:	0f b6 d2             	movzbl %dl,%edx
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003f8:	83 f9 09             	cmp    $0x9,%ecx
  8003fb:	77 52                	ja     80044f <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8003fd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800400:	eb e9                	jmp    8003eb <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 50 04             	lea    0x4(%eax),%edx
  800408:	89 55 14             	mov    %edx,0x14(%ebp)
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800413:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800417:	79 93                	jns    8003ac <vprintfmt+0x39>
				width = precision, precision = -1;
  800419:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800426:	eb 84                	jmp    8003ac <vprintfmt+0x39>
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	85 c0                	test   %eax,%eax
  80042d:	ba 00 00 00 00       	mov    $0x0,%edx
  800432:	0f 49 d0             	cmovns %eax,%edx
  800435:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043b:	e9 6c ff ff ff       	jmp    8003ac <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800443:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80044a:	e9 5d ff ff ff       	jmp    8003ac <vprintfmt+0x39>
  80044f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800452:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800455:	eb bc                	jmp    800413 <vprintfmt+0xa0>
			lflag++;
  800457:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045d:	e9 4a ff ff ff       	jmp    8003ac <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800462:	8b 45 14             	mov    0x14(%ebp),%eax
  800465:	8d 50 04             	lea    0x4(%eax),%edx
  800468:	89 55 14             	mov    %edx,0x14(%ebp)
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	56                   	push   %esi
  80046f:	ff 30                	pushl  (%eax)
  800471:	ff d3                	call   *%ebx
			break;
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	e9 96 01 00 00       	jmp    800611 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	8d 50 04             	lea    0x4(%eax),%edx
  800481:	89 55 14             	mov    %edx,0x14(%ebp)
  800484:	8b 00                	mov    (%eax),%eax
  800486:	99                   	cltd   
  800487:	31 d0                	xor    %edx,%eax
  800489:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048b:	83 f8 0f             	cmp    $0xf,%eax
  80048e:	7f 20                	jg     8004b0 <vprintfmt+0x13d>
  800490:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	74 15                	je     8004b0 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  80049b:	52                   	push   %edx
  80049c:	68 63 2a 80 00       	push   $0x802a63
  8004a1:	56                   	push   %esi
  8004a2:	53                   	push   %ebx
  8004a3:	e8 aa fe ff ff       	call   800352 <printfmt>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	e9 61 01 00 00       	jmp    800611 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004b0:	50                   	push   %eax
  8004b1:	68 b8 24 80 00       	push   $0x8024b8
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	e8 95 fe ff ff       	call   800352 <printfmt>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	e9 4c 01 00 00       	jmp    800611 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8d 50 04             	lea    0x4(%eax),%edx
  8004cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ce:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	b8 b1 24 80 00       	mov    $0x8024b1,%eax
  8004d7:	0f 45 c1             	cmovne %ecx,%eax
  8004da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e1:	7e 06                	jle    8004e9 <vprintfmt+0x176>
  8004e3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004e7:	75 0d                	jne    8004f6 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ec:	89 c7                	mov    %eax,%edi
  8004ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	eb 57                	jmp    80054d <vprintfmt+0x1da>
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8004ff:	e8 4f 02 00 00       	call   800753 <strnlen>
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800513:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800516:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	85 db                	test   %ebx,%ebx
  80051a:	7e 10                	jle    80052c <vprintfmt+0x1b9>
					putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	56                   	push   %esi
  800520:	57                   	push   %edi
  800521:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	83 eb 01             	sub    $0x1,%ebx
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	eb ec                	jmp    800518 <vprintfmt+0x1a5>
  80052c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80052f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800532:	85 d2                	test   %edx,%edx
  800534:	b8 00 00 00 00       	mov    $0x0,%eax
  800539:	0f 49 c2             	cmovns %edx,%eax
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800541:	eb a6                	jmp    8004e9 <vprintfmt+0x176>
					putch(ch, putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	56                   	push   %esi
  800547:	52                   	push   %edx
  800548:	ff d3                	call   *%ebx
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800550:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800552:	83 c7 01             	add    $0x1,%edi
  800555:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800559:	0f be d0             	movsbl %al,%edx
  80055c:	85 d2                	test   %edx,%edx
  80055e:	74 42                	je     8005a2 <vprintfmt+0x22f>
  800560:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800564:	78 06                	js     80056c <vprintfmt+0x1f9>
  800566:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056a:	78 1e                	js     80058a <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80056c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800570:	74 d1                	je     800543 <vprintfmt+0x1d0>
  800572:	0f be c0             	movsbl %al,%eax
  800575:	83 e8 20             	sub    $0x20,%eax
  800578:	83 f8 5e             	cmp    $0x5e,%eax
  80057b:	76 c6                	jbe    800543 <vprintfmt+0x1d0>
					putch('?', putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	56                   	push   %esi
  800581:	6a 3f                	push   $0x3f
  800583:	ff d3                	call   *%ebx
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	eb c3                	jmp    80054d <vprintfmt+0x1da>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb 0e                	jmp    80059c <vprintfmt+0x229>
				putch(' ', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	56                   	push   %esi
  800592:	6a 20                	push   $0x20
  800594:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7f ee                	jg     80058e <vprintfmt+0x21b>
  8005a0:	eb 6f                	jmp    800611 <vprintfmt+0x29e>
  8005a2:	89 cf                	mov    %ecx,%edi
  8005a4:	eb f6                	jmp    80059c <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005a6:	89 ca                	mov    %ecx,%edx
  8005a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ab:	e8 55 fd ff ff       	call   800305 <getint>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005b6:	85 d2                	test   %edx,%edx
  8005b8:	78 0b                	js     8005c5 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005ba:	89 d1                	mov    %edx,%ecx
  8005bc:	89 c2                	mov    %eax,%edx
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c3:	eb 32                	jmp    8005f7 <vprintfmt+0x284>
				putch('-', putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	56                   	push   %esi
  8005c9:	6a 2d                	push   $0x2d
  8005cb:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d3:	f7 da                	neg    %edx
  8005d5:	83 d1 00             	adc    $0x0,%ecx
  8005d8:	f7 d9                	neg    %ecx
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	eb 13                	jmp    8005f7 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005e4:	89 ca                	mov    %ecx,%edx
  8005e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e9:	e8 e3 fc ff ff       	call   8002d1 <getuint>
  8005ee:	89 d1                	mov    %edx,%ecx
  8005f0:	89 c2                	mov    %eax,%edx
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f7:	83 ec 0c             	sub    $0xc,%esp
  8005fa:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005fe:	57                   	push   %edi
  8005ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800602:	50                   	push   %eax
  800603:	51                   	push   %ecx
  800604:	52                   	push   %edx
  800605:	89 f2                	mov    %esi,%edx
  800607:	89 d8                	mov    %ebx,%eax
  800609:	e8 1a fc ff ff       	call   800228 <printnum>
			break;
  80060e:	83 c4 20             	add    $0x20,%esp
{
  800611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800614:	83 c7 01             	add    $0x1,%edi
  800617:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061b:	83 f8 25             	cmp    $0x25,%eax
  80061e:	0f 84 6a fd ff ff    	je     80038e <vprintfmt+0x1b>
			if (ch == '\0')
  800624:	85 c0                	test   %eax,%eax
  800626:	0f 84 93 00 00 00    	je     8006bf <vprintfmt+0x34c>
			putch(ch, putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	56                   	push   %esi
  800630:	50                   	push   %eax
  800631:	ff d3                	call   *%ebx
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	eb dc                	jmp    800614 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800638:	89 ca                	mov    %ecx,%edx
  80063a:	8d 45 14             	lea    0x14(%ebp),%eax
  80063d:	e8 8f fc ff ff       	call   8002d1 <getuint>
  800642:	89 d1                	mov    %edx,%ecx
  800644:	89 c2                	mov    %eax,%edx
			base = 8;
  800646:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  80064b:	eb aa                	jmp    8005f7 <vprintfmt+0x284>
			putch('0', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	56                   	push   %esi
  800651:	6a 30                	push   $0x30
  800653:	ff d3                	call   *%ebx
			putch('x', putdat);
  800655:	83 c4 08             	add    $0x8,%esp
  800658:	56                   	push   %esi
  800659:	6a 78                	push   $0x78
  80065b:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8d 50 04             	lea    0x4(%eax),%edx
  800663:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800666:	8b 10                	mov    (%eax),%edx
  800668:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800670:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800675:	eb 80                	jmp    8005f7 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800677:	89 ca                	mov    %ecx,%edx
  800679:	8d 45 14             	lea    0x14(%ebp),%eax
  80067c:	e8 50 fc ff ff       	call   8002d1 <getuint>
  800681:	89 d1                	mov    %edx,%ecx
  800683:	89 c2                	mov    %eax,%edx
			base = 16;
  800685:	b8 10 00 00 00       	mov    $0x10,%eax
  80068a:	e9 68 ff ff ff       	jmp    8005f7 <vprintfmt+0x284>
			putch(ch, putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	56                   	push   %esi
  800693:	6a 25                	push   $0x25
  800695:	ff d3                	call   *%ebx
			break;
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	e9 72 ff ff ff       	jmp    800611 <vprintfmt+0x29e>
			putch('%', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	56                   	push   %esi
  8006a3:	6a 25                	push   $0x25
  8006a5:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	89 f8                	mov    %edi,%eax
  8006ac:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006b0:	74 05                	je     8006b7 <vprintfmt+0x344>
  8006b2:	83 e8 01             	sub    $0x1,%eax
  8006b5:	eb f5                	jmp    8006ac <vprintfmt+0x339>
  8006b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ba:	e9 52 ff ff ff       	jmp    800611 <vprintfmt+0x29e>
}
  8006bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c2:	5b                   	pop    %ebx
  8006c3:	5e                   	pop    %esi
  8006c4:	5f                   	pop    %edi
  8006c5:	5d                   	pop    %ebp
  8006c6:	c3                   	ret    

008006c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c7:	f3 0f 1e fb          	endbr32 
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 18             	sub    $0x18,%esp
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006da:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006de:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	74 26                	je     800712 <vsnprintf+0x4b>
  8006ec:	85 d2                	test   %edx,%edx
  8006ee:	7e 22                	jle    800712 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f0:	ff 75 14             	pushl  0x14(%ebp)
  8006f3:	ff 75 10             	pushl  0x10(%ebp)
  8006f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	68 31 03 80 00       	push   $0x800331
  8006ff:	e8 6f fc ff ff       	call   800373 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800707:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070d:	83 c4 10             	add    $0x10,%esp
}
  800710:	c9                   	leave  
  800711:	c3                   	ret    
		return -E_INVAL;
  800712:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800717:	eb f7                	jmp    800710 <vsnprintf+0x49>

00800719 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800719:	f3 0f 1e fb          	endbr32 
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800726:	50                   	push   %eax
  800727:	ff 75 10             	pushl  0x10(%ebp)
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	e8 92 ff ff ff       	call   8006c7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800737:	f3 0f 1e fb          	endbr32 
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800741:	b8 00 00 00 00       	mov    $0x0,%eax
  800746:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80074a:	74 05                	je     800751 <strlen+0x1a>
		n++;
  80074c:	83 c0 01             	add    $0x1,%eax
  80074f:	eb f5                	jmp    800746 <strlen+0xf>
	return n;
}
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800760:	b8 00 00 00 00       	mov    $0x0,%eax
  800765:	39 d0                	cmp    %edx,%eax
  800767:	74 0d                	je     800776 <strnlen+0x23>
  800769:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80076d:	74 05                	je     800774 <strnlen+0x21>
		n++;
  80076f:	83 c0 01             	add    $0x1,%eax
  800772:	eb f1                	jmp    800765 <strnlen+0x12>
  800774:	89 c2                	mov    %eax,%edx
	return n;
}
  800776:	89 d0                	mov    %edx,%eax
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80077a:	f3 0f 1e fb          	endbr32 
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	53                   	push   %ebx
  800782:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800785:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800788:	b8 00 00 00 00       	mov    $0x0,%eax
  80078d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800791:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800794:	83 c0 01             	add    $0x1,%eax
  800797:	84 d2                	test   %dl,%dl
  800799:	75 f2                	jne    80078d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80079b:	89 c8                	mov    %ecx,%eax
  80079d:	5b                   	pop    %ebx
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a0:	f3 0f 1e fb          	endbr32 
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 10             	sub    $0x10,%esp
  8007ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007ae:	53                   	push   %ebx
  8007af:	e8 83 ff ff ff       	call   800737 <strlen>
  8007b4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	01 d8                	add    %ebx,%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 b8 ff ff ff       	call   80077a <strcpy>
	return dst;
}
  8007c2:	89 d8                	mov    %ebx,%eax
  8007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c9:	f3 0f 1e fb          	endbr32 
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d8:	89 f3                	mov    %esi,%ebx
  8007da:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007dd:	89 f0                	mov    %esi,%eax
  8007df:	39 d8                	cmp    %ebx,%eax
  8007e1:	74 11                	je     8007f4 <strncpy+0x2b>
		*dst++ = *src;
  8007e3:	83 c0 01             	add    $0x1,%eax
  8007e6:	0f b6 0a             	movzbl (%edx),%ecx
  8007e9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ec:	80 f9 01             	cmp    $0x1,%cl
  8007ef:	83 da ff             	sbb    $0xffffffff,%edx
  8007f2:	eb eb                	jmp    8007df <strncpy+0x16>
	}
	return ret;
}
  8007f4:	89 f0                	mov    %esi,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5e                   	pop    %esi
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007fa:	f3 0f 1e fb          	endbr32 
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	56                   	push   %esi
  800802:	53                   	push   %ebx
  800803:	8b 75 08             	mov    0x8(%ebp),%esi
  800806:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800809:	8b 55 10             	mov    0x10(%ebp),%edx
  80080c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080e:	85 d2                	test   %edx,%edx
  800810:	74 21                	je     800833 <strlcpy+0x39>
  800812:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800816:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800818:	39 c2                	cmp    %eax,%edx
  80081a:	74 14                	je     800830 <strlcpy+0x36>
  80081c:	0f b6 19             	movzbl (%ecx),%ebx
  80081f:	84 db                	test   %bl,%bl
  800821:	74 0b                	je     80082e <strlcpy+0x34>
			*dst++ = *src++;
  800823:	83 c1 01             	add    $0x1,%ecx
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082c:	eb ea                	jmp    800818 <strlcpy+0x1e>
  80082e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800830:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800833:	29 f0                	sub    %esi,%eax
}
  800835:	5b                   	pop    %ebx
  800836:	5e                   	pop    %esi
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800839:	f3 0f 1e fb          	endbr32 
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800846:	0f b6 01             	movzbl (%ecx),%eax
  800849:	84 c0                	test   %al,%al
  80084b:	74 0c                	je     800859 <strcmp+0x20>
  80084d:	3a 02                	cmp    (%edx),%al
  80084f:	75 08                	jne    800859 <strcmp+0x20>
		p++, q++;
  800851:	83 c1 01             	add    $0x1,%ecx
  800854:	83 c2 01             	add    $0x1,%edx
  800857:	eb ed                	jmp    800846 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800859:	0f b6 c0             	movzbl %al,%eax
  80085c:	0f b6 12             	movzbl (%edx),%edx
  80085f:	29 d0                	sub    %edx,%eax
}
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800863:	f3 0f 1e fb          	endbr32 
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	89 c3                	mov    %eax,%ebx
  800873:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800876:	eb 06                	jmp    80087e <strncmp+0x1b>
		n--, p++, q++;
  800878:	83 c0 01             	add    $0x1,%eax
  80087b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80087e:	39 d8                	cmp    %ebx,%eax
  800880:	74 16                	je     800898 <strncmp+0x35>
  800882:	0f b6 08             	movzbl (%eax),%ecx
  800885:	84 c9                	test   %cl,%cl
  800887:	74 04                	je     80088d <strncmp+0x2a>
  800889:	3a 0a                	cmp    (%edx),%cl
  80088b:	74 eb                	je     800878 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80088d:	0f b6 00             	movzbl (%eax),%eax
  800890:	0f b6 12             	movzbl (%edx),%edx
  800893:	29 d0                	sub    %edx,%eax
}
  800895:	5b                   	pop    %ebx
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    
		return 0;
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
  80089d:	eb f6                	jmp    800895 <strncmp+0x32>

0080089f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ad:	0f b6 10             	movzbl (%eax),%edx
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	74 09                	je     8008bd <strchr+0x1e>
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 0a                	je     8008c2 <strchr+0x23>
	for (; *s; s++)
  8008b8:	83 c0 01             	add    $0x1,%eax
  8008bb:	eb f0                	jmp    8008ad <strchr+0xe>
			return (char *) s;
	return 0;
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c4:	f3 0f 1e fb          	endbr32 
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d5:	38 ca                	cmp    %cl,%dl
  8008d7:	74 09                	je     8008e2 <strfind+0x1e>
  8008d9:	84 d2                	test   %dl,%dl
  8008db:	74 05                	je     8008e2 <strfind+0x1e>
	for (; *s; s++)
  8008dd:	83 c0 01             	add    $0x1,%eax
  8008e0:	eb f0                	jmp    8008d2 <strfind+0xe>
			break;
	return (char *) s;
}
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	57                   	push   %edi
  8008ec:	56                   	push   %esi
  8008ed:	53                   	push   %ebx
  8008ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008f4:	85 c9                	test   %ecx,%ecx
  8008f6:	74 33                	je     80092b <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	09 c8                	or     %ecx,%eax
  8008fc:	a8 03                	test   $0x3,%al
  8008fe:	75 23                	jne    800923 <memset+0x3f>
		c &= 0xFF;
  800900:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800904:	89 d8                	mov    %ebx,%eax
  800906:	c1 e0 08             	shl    $0x8,%eax
  800909:	89 df                	mov    %ebx,%edi
  80090b:	c1 e7 18             	shl    $0x18,%edi
  80090e:	89 de                	mov    %ebx,%esi
  800910:	c1 e6 10             	shl    $0x10,%esi
  800913:	09 f7                	or     %esi,%edi
  800915:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800917:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80091a:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80091c:	89 d7                	mov    %edx,%edi
  80091e:	fc                   	cld    
  80091f:	f3 ab                	rep stos %eax,%es:(%edi)
  800921:	eb 08                	jmp    80092b <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800923:	89 d7                	mov    %edx,%edi
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	fc                   	cld    
  800929:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	5b                   	pop    %ebx
  80092e:	5e                   	pop    %esi
  80092f:	5f                   	pop    %edi
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	57                   	push   %edi
  80093a:	56                   	push   %esi
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800941:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800944:	39 c6                	cmp    %eax,%esi
  800946:	73 32                	jae    80097a <memmove+0x48>
  800948:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094b:	39 c2                	cmp    %eax,%edx
  80094d:	76 2b                	jbe    80097a <memmove+0x48>
		s += n;
		d += n;
  80094f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800952:	89 fe                	mov    %edi,%esi
  800954:	09 ce                	or     %ecx,%esi
  800956:	09 d6                	or     %edx,%esi
  800958:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095e:	75 0e                	jne    80096e <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800960:	83 ef 04             	sub    $0x4,%edi
  800963:	8d 72 fc             	lea    -0x4(%edx),%esi
  800966:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800969:	fd                   	std    
  80096a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096c:	eb 09                	jmp    800977 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096e:	83 ef 01             	sub    $0x1,%edi
  800971:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800974:	fd                   	std    
  800975:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800977:	fc                   	cld    
  800978:	eb 1a                	jmp    800994 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	09 ca                	or     %ecx,%edx
  80097e:	09 f2                	or     %esi,%edx
  800980:	f6 c2 03             	test   $0x3,%dl
  800983:	75 0a                	jne    80098f <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800985:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800988:	89 c7                	mov    %eax,%edi
  80098a:	fc                   	cld    
  80098b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098d:	eb 05                	jmp    800994 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80098f:	89 c7                	mov    %eax,%edi
  800991:	fc                   	cld    
  800992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800994:	5e                   	pop    %esi
  800995:	5f                   	pop    %edi
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800998:	f3 0f 1e fb          	endbr32 
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a2:	ff 75 10             	pushl  0x10(%ebp)
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	ff 75 08             	pushl  0x8(%ebp)
  8009ab:	e8 82 ff ff ff       	call   800932 <memmove>
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b2:	f3 0f 1e fb          	endbr32 
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 c6                	mov    %eax,%esi
  8009c3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c6:	39 f0                	cmp    %esi,%eax
  8009c8:	74 1c                	je     8009e6 <memcmp+0x34>
		if (*s1 != *s2)
  8009ca:	0f b6 08             	movzbl (%eax),%ecx
  8009cd:	0f b6 1a             	movzbl (%edx),%ebx
  8009d0:	38 d9                	cmp    %bl,%cl
  8009d2:	75 08                	jne    8009dc <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	eb ea                	jmp    8009c6 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009dc:	0f b6 c1             	movzbl %cl,%eax
  8009df:	0f b6 db             	movzbl %bl,%ebx
  8009e2:	29 d8                	sub    %ebx,%eax
  8009e4:	eb 05                	jmp    8009eb <memcmp+0x39>
	}

	return 0;
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a01:	39 d0                	cmp    %edx,%eax
  800a03:	73 09                	jae    800a0e <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a05:	38 08                	cmp    %cl,(%eax)
  800a07:	74 05                	je     800a0e <memfind+0x1f>
	for (; s < ends; s++)
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	eb f3                	jmp    800a01 <memfind+0x12>
			break;
	return (void *) s;
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a20:	eb 03                	jmp    800a25 <strtol+0x15>
		s++;
  800a22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	3c 20                	cmp    $0x20,%al
  800a2a:	74 f6                	je     800a22 <strtol+0x12>
  800a2c:	3c 09                	cmp    $0x9,%al
  800a2e:	74 f2                	je     800a22 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a30:	3c 2b                	cmp    $0x2b,%al
  800a32:	74 2a                	je     800a5e <strtol+0x4e>
	int neg = 0;
  800a34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a39:	3c 2d                	cmp    $0x2d,%al
  800a3b:	74 2b                	je     800a68 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a43:	75 0f                	jne    800a54 <strtol+0x44>
  800a45:	80 39 30             	cmpb   $0x30,(%ecx)
  800a48:	74 28                	je     800a72 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a51:	0f 44 d8             	cmove  %eax,%ebx
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a5c:	eb 46                	jmp    800aa4 <strtol+0x94>
		s++;
  800a5e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a61:	bf 00 00 00 00       	mov    $0x0,%edi
  800a66:	eb d5                	jmp    800a3d <strtol+0x2d>
		s++, neg = 1;
  800a68:	83 c1 01             	add    $0x1,%ecx
  800a6b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a70:	eb cb                	jmp    800a3d <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a72:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a76:	74 0e                	je     800a86 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a78:	85 db                	test   %ebx,%ebx
  800a7a:	75 d8                	jne    800a54 <strtol+0x44>
		s++, base = 8;
  800a7c:	83 c1 01             	add    $0x1,%ecx
  800a7f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a84:	eb ce                	jmp    800a54 <strtol+0x44>
		s += 2, base = 16;
  800a86:	83 c1 02             	add    $0x2,%ecx
  800a89:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a8e:	eb c4                	jmp    800a54 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a90:	0f be d2             	movsbl %dl,%edx
  800a93:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a96:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a99:	7d 3a                	jge    800ad5 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a9b:	83 c1 01             	add    $0x1,%ecx
  800a9e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aa4:	0f b6 11             	movzbl (%ecx),%edx
  800aa7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aaa:	89 f3                	mov    %esi,%ebx
  800aac:	80 fb 09             	cmp    $0x9,%bl
  800aaf:	76 df                	jbe    800a90 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ab1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab4:	89 f3                	mov    %esi,%ebx
  800ab6:	80 fb 19             	cmp    $0x19,%bl
  800ab9:	77 08                	ja     800ac3 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800abb:	0f be d2             	movsbl %dl,%edx
  800abe:	83 ea 57             	sub    $0x57,%edx
  800ac1:	eb d3                	jmp    800a96 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ac3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac6:	89 f3                	mov    %esi,%ebx
  800ac8:	80 fb 19             	cmp    $0x19,%bl
  800acb:	77 08                	ja     800ad5 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800acd:	0f be d2             	movsbl %dl,%edx
  800ad0:	83 ea 37             	sub    $0x37,%edx
  800ad3:	eb c1                	jmp    800a96 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad9:	74 05                	je     800ae0 <strtol+0xd0>
		*endptr = (char *) s;
  800adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ade:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	f7 da                	neg    %edx
  800ae4:	85 ff                	test   %edi,%edi
  800ae6:	0f 45 c2             	cmovne %edx,%eax
}
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 1c             	sub    $0x1c,%esp
  800af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800afa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800afd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b05:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b08:	8b 75 14             	mov    0x14(%ebp),%esi
  800b0b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b11:	74 04                	je     800b17 <syscall+0x29>
  800b13:	85 c0                	test   %eax,%eax
  800b15:	7f 08                	jg     800b1f <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	50                   	push   %eax
  800b23:	ff 75 e0             	pushl  -0x20(%ebp)
  800b26:	68 9f 27 80 00       	push   $0x80279f
  800b2b:	6a 23                	push   $0x23
  800b2d:	68 bc 27 80 00       	push   $0x8027bc
  800b32:	e8 61 15 00 00       	call   802098 <_panic>

00800b37 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b37:	f3 0f 1e fb          	endbr32 
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b41:	6a 00                	push   $0x0
  800b43:	6a 00                	push   $0x0
  800b45:	6a 00                	push   $0x0
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	e8 92 ff ff ff       	call   800aee <syscall>
}
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b61:	f3 0f 1e fb          	endbr32 
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b6b:	6a 00                	push   $0x0
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	6a 00                	push   $0x0
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b82:	e8 67 ff ff ff       	call   800aee <syscall>
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b93:	6a 00                	push   $0x0
  800b95:	6a 00                	push   $0x0
  800b97:	6a 00                	push   $0x0
  800b99:	6a 00                	push   $0x0
  800b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9e:	ba 01 00 00 00       	mov    $0x1,%edx
  800ba3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba8:	e8 41 ff ff ff       	call   800aee <syscall>
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bb9:	6a 00                	push   $0x0
  800bbb:	6a 00                	push   $0x0
  800bbd:	6a 00                	push   $0x0
  800bbf:	6a 00                	push   $0x0
  800bc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd0:	e8 19 ff ff ff       	call   800aee <syscall>
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sys_yield>:

void
sys_yield(void)
{
  800bd7:	f3 0f 1e fb          	endbr32 
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800be1:	6a 00                	push   $0x0
  800be3:	6a 00                	push   $0x0
  800be5:	6a 00                	push   $0x0
  800be7:	6a 00                	push   $0x0
  800be9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bee:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf8:	e8 f1 fe ff ff       	call   800aee <syscall>
}
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c0c:	6a 00                	push   $0x0
  800c0e:	6a 00                	push   $0x0
  800c10:	ff 75 10             	pushl  0x10(%ebp)
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c23:	e8 c6 fe ff ff       	call   800aee <syscall>
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2a:	f3 0f 1e fb          	endbr32 
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c34:	ff 75 18             	pushl  0x18(%ebp)
  800c37:	ff 75 14             	pushl  0x14(%ebp)
  800c3a:	ff 75 10             	pushl  0x10(%ebp)
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c43:	ba 01 00 00 00       	mov    $0x1,%edx
  800c48:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4d:	e8 9c fe ff ff       	call   800aee <syscall>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c5e:	6a 00                	push   $0x0
  800c60:	6a 00                	push   $0x0
  800c62:	6a 00                	push   $0x0
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c74:	e8 75 fe ff ff       	call   800aee <syscall>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c85:	6a 00                	push   $0x0
  800c87:	6a 00                	push   $0x0
  800c89:	6a 00                	push   $0x0
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	ba 01 00 00 00       	mov    $0x1,%edx
  800c96:	b8 08 00 00 00       	mov    $0x8,%eax
  800c9b:	e8 4e fe ff ff       	call   800aee <syscall>
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cac:	6a 00                	push   $0x0
  800cae:	6a 00                	push   $0x0
  800cb0:	6a 00                	push   $0x0
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb8:	ba 01 00 00 00       	mov    $0x1,%edx
  800cbd:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc2:	e8 27 fe ff ff       	call   800aee <syscall>
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800cd3:	6a 00                	push   $0x0
  800cd5:	6a 00                	push   $0x0
  800cd7:	6a 00                	push   $0x0
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdf:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce9:	e8 00 fe ff ff       	call   800aee <syscall>
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cfa:	6a 00                	push   $0x0
  800cfc:	ff 75 14             	pushl  0x14(%ebp)
  800cff:	ff 75 10             	pushl  0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d12:	e8 d7 fd ff ff       	call   800aee <syscall>
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d19:	f3 0f 1e fb          	endbr32 
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d23:	6a 00                	push   $0x0
  800d25:	6a 00                	push   $0x0
  800d27:	6a 00                	push   $0x0
  800d29:	6a 00                	push   $0x0
  800d2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d33:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d38:	e8 b1 fd ff ff       	call   800aee <syscall>
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	53                   	push   %ebx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800d48:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800d4f:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800d52:	f6 c6 04             	test   $0x4,%dh
  800d55:	75 51                	jne    800da8 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800d57:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800d5d:	0f 84 84 00 00 00    	je     800de7 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	68 05 08 00 00       	push   $0x805
  800d6b:	53                   	push   %ebx
  800d6c:	50                   	push   %eax
  800d6d:	53                   	push   %ebx
  800d6e:	6a 00                	push   $0x0
  800d70:	e8 b5 fe ff ff       	call   800c2a <sys_page_map>
		if (r)
  800d75:	83 c4 20             	add    $0x20,%esp
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	75 59                	jne    800dd5 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	68 05 08 00 00       	push   $0x805
  800d84:	53                   	push   %ebx
  800d85:	6a 00                	push   $0x0
  800d87:	53                   	push   %ebx
  800d88:	6a 00                	push   $0x0
  800d8a:	e8 9b fe ff ff       	call   800c2a <sys_page_map>
		if (r)
  800d8f:	83 c4 20             	add    $0x20,%esp
  800d92:	85 c0                	test   %eax,%eax
  800d94:	74 67                	je     800dfd <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800d96:	50                   	push   %eax
  800d97:	68 ca 27 80 00       	push   $0x8027ca
  800d9c:	6a 5f                	push   $0x5f
  800d9e:	68 e5 27 80 00       	push   $0x8027e5
  800da3:	e8 f0 12 00 00       	call   802098 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800db1:	52                   	push   %edx
  800db2:	53                   	push   %ebx
  800db3:	50                   	push   %eax
  800db4:	53                   	push   %ebx
  800db5:	6a 00                	push   $0x0
  800db7:	e8 6e fe ff ff       	call   800c2a <sys_page_map>
		if (r)
  800dbc:	83 c4 20             	add    $0x20,%esp
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	74 3a                	je     800dfd <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800dc3:	50                   	push   %eax
  800dc4:	68 ca 27 80 00       	push   $0x8027ca
  800dc9:	6a 57                	push   $0x57
  800dcb:	68 e5 27 80 00       	push   $0x8027e5
  800dd0:	e8 c3 12 00 00       	call   802098 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800dd5:	50                   	push   %eax
  800dd6:	68 ca 27 80 00       	push   $0x8027ca
  800ddb:	6a 5b                	push   $0x5b
  800ddd:	68 e5 27 80 00       	push   $0x8027e5
  800de2:	e8 b1 12 00 00       	call   802098 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800de7:	83 ec 0c             	sub    $0xc,%esp
  800dea:	6a 05                	push   $0x5
  800dec:	53                   	push   %ebx
  800ded:	50                   	push   %eax
  800dee:	53                   	push   %ebx
  800def:	6a 00                	push   $0x0
  800df1:	e8 34 fe ff ff       	call   800c2a <sys_page_map>
		if (r)
  800df6:	83 c4 20             	add    $0x20,%esp
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 0a                	jne    800e07 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800e07:	50                   	push   %eax
  800e08:	68 ca 27 80 00       	push   $0x8027ca
  800e0d:	6a 63                	push   $0x63
  800e0f:	68 e5 27 80 00       	push   $0x8027e5
  800e14:	e8 7f 12 00 00       	call   802098 <_panic>

00800e19 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	89 c7                	mov    %eax,%edi
  800e24:	89 d6                	mov    %edx,%esi
  800e26:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800e28:	f6 c1 02             	test   $0x2,%cl
  800e2b:	75 2f                	jne    800e5c <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	51                   	push   %ecx
  800e31:	52                   	push   %edx
  800e32:	50                   	push   %eax
  800e33:	52                   	push   %edx
  800e34:	6a 00                	push   $0x0
  800e36:	e8 ef fd ff ff       	call   800c2a <sys_page_map>
  800e3b:	83 c4 20             	add    $0x20,%esp
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	78 08                	js     800e4a <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800e4a:	50                   	push   %eax
  800e4b:	68 d4 27 80 00       	push   $0x8027d4
  800e50:	6a 6f                	push   $0x6f
  800e52:	68 e5 27 80 00       	push   $0x8027e5
  800e57:	e8 3c 12 00 00       	call   802098 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800e5c:	83 ec 04             	sub    $0x4,%esp
  800e5f:	51                   	push   %ecx
  800e60:	52                   	push   %edx
  800e61:	50                   	push   %eax
  800e62:	e8 9b fd ff ff       	call   800c02 <sys_page_alloc>
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	78 54                	js     800ec2 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	53                   	push   %ebx
  800e72:	68 00 00 40 00       	push   $0x400000
  800e77:	6a 00                	push   $0x0
  800e79:	56                   	push   %esi
  800e7a:	57                   	push   %edi
  800e7b:	e8 aa fd ff ff       	call   800c2a <sys_page_map>
  800e80:	83 c4 20             	add    $0x20,%esp
  800e83:	85 c0                	test   %eax,%eax
  800e85:	78 4d                	js     800ed4 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800e87:	83 ec 04             	sub    $0x4,%esp
  800e8a:	68 00 10 00 00       	push   $0x1000
  800e8f:	56                   	push   %esi
  800e90:	68 00 00 40 00       	push   $0x400000
  800e95:	e8 98 fa ff ff       	call   800932 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800e9a:	83 c4 08             	add    $0x8,%esp
  800e9d:	68 00 00 40 00       	push   $0x400000
  800ea2:	6a 00                	push   $0x0
  800ea4:	e8 ab fd ff ff       	call   800c54 <sys_page_unmap>
  800ea9:	83 c4 10             	add    $0x10,%esp
  800eac:	85 c0                	test   %eax,%eax
  800eae:	79 92                	jns    800e42 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800eb0:	50                   	push   %eax
  800eb1:	68 03 28 80 00       	push   $0x802803
  800eb6:	6a 78                	push   $0x78
  800eb8:	68 e5 27 80 00       	push   $0x8027e5
  800ebd:	e8 d6 11 00 00       	call   802098 <_panic>
		panic("sys_page_alloc: %e", r);
  800ec2:	50                   	push   %eax
  800ec3:	68 f0 27 80 00       	push   $0x8027f0
  800ec8:	6a 73                	push   $0x73
  800eca:	68 e5 27 80 00       	push   $0x8027e5
  800ecf:	e8 c4 11 00 00       	call   802098 <_panic>
		panic("sys_page_map: %e", r);
  800ed4:	50                   	push   %eax
  800ed5:	68 d4 27 80 00       	push   $0x8027d4
  800eda:	6a 75                	push   $0x75
  800edc:	68 e5 27 80 00       	push   $0x8027e5
  800ee1:	e8 b2 11 00 00       	call   802098 <_panic>

00800ee6 <pgfault>:
{
  800ee6:	f3 0f 1e fb          	endbr32 
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	53                   	push   %ebx
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ef4:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800ef6:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800ef9:	89 da                	mov    %ebx,%edx
  800efb:	c1 ea 0c             	shr    $0xc,%edx
  800efe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800f05:	a8 01                	test   $0x1,%al
  800f07:	74 7e                	je     800f87 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800f09:	a8 02                	test   $0x2,%al
  800f0b:	0f 84 8a 00 00 00    	je     800f9b <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800f11:	f6 c6 08             	test   $0x8,%dh
  800f14:	0f 84 95 00 00 00    	je     800faf <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	6a 07                	push   $0x7
  800f1f:	68 00 f0 7f 00       	push   $0x7ff000
  800f24:	6a 00                	push   $0x0
  800f26:	e8 d7 fc ff ff       	call   800c02 <sys_page_alloc>
	if (r)
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	0f 85 8d 00 00 00    	jne    800fc3 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	68 00 10 00 00       	push   $0x1000
  800f44:	53                   	push   %ebx
  800f45:	68 00 f0 7f 00       	push   $0x7ff000
  800f4a:	e8 49 fa ff ff       	call   800998 <memcpy>
	r = sys_page_map(
  800f4f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f56:	53                   	push   %ebx
  800f57:	6a 00                	push   $0x0
  800f59:	68 00 f0 7f 00       	push   $0x7ff000
  800f5e:	6a 00                	push   $0x0
  800f60:	e8 c5 fc ff ff       	call   800c2a <sys_page_map>
	if (r)
  800f65:	83 c4 20             	add    $0x20,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 69                	jne    800fd5 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	68 00 f0 7f 00       	push   $0x7ff000
  800f74:	6a 00                	push   $0x0
  800f76:	e8 d9 fc ff ff       	call   800c54 <sys_page_unmap>
	if (r)
  800f7b:	83 c4 10             	add    $0x10,%esp
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	75 65                	jne    800fe7 <pgfault+0x101>
}
  800f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  800f87:	83 ec 04             	sub    $0x4,%esp
  800f8a:	68 84 28 80 00       	push   $0x802884
  800f8f:	6a 20                	push   $0x20
  800f91:	68 e5 27 80 00       	push   $0x8027e5
  800f96:	e8 fd 10 00 00       	call   802098 <_panic>
		panic("[pgfault] pgfault por lectura");
  800f9b:	83 ec 04             	sub    $0x4,%esp
  800f9e:	68 16 28 80 00       	push   $0x802816
  800fa3:	6a 23                	push   $0x23
  800fa5:	68 e5 27 80 00       	push   $0x8027e5
  800faa:	e8 e9 10 00 00       	call   802098 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  800faf:	83 ec 04             	sub    $0x4,%esp
  800fb2:	68 b0 28 80 00       	push   $0x8028b0
  800fb7:	6a 27                	push   $0x27
  800fb9:	68 e5 27 80 00       	push   $0x8027e5
  800fbe:	e8 d5 10 00 00       	call   802098 <_panic>
		panic("pgfault: %e", r);
  800fc3:	50                   	push   %eax
  800fc4:	68 34 28 80 00       	push   $0x802834
  800fc9:	6a 32                	push   $0x32
  800fcb:	68 e5 27 80 00       	push   $0x8027e5
  800fd0:	e8 c3 10 00 00       	call   802098 <_panic>
		panic("pgfault: %e", r);
  800fd5:	50                   	push   %eax
  800fd6:	68 34 28 80 00       	push   $0x802834
  800fdb:	6a 39                	push   $0x39
  800fdd:	68 e5 27 80 00       	push   $0x8027e5
  800fe2:	e8 b1 10 00 00       	call   802098 <_panic>
		panic("pgfault: %e", r);
  800fe7:	50                   	push   %eax
  800fe8:	68 34 28 80 00       	push   $0x802834
  800fed:	6a 3d                	push   $0x3d
  800fef:	68 e5 27 80 00       	push   $0x8027e5
  800ff4:	e8 9f 10 00 00       	call   802098 <_panic>

00800ff9 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  800ff9:	f3 0f 1e fb          	endbr32 
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
  801003:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801006:	b8 07 00 00 00       	mov    $0x7,%eax
  80100b:	cd 30                	int    $0x30
  80100d:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  80100f:	85 c0                	test   %eax,%eax
  801011:	78 22                	js     801035 <fork_v0+0x3c>
  801013:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80101a:	75 52                	jne    80106e <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  80101c:	e8 8e fb ff ff       	call   800baf <sys_getenvid>
  801021:	25 ff 03 00 00       	and    $0x3ff,%eax
  801026:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801029:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80102e:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801033:	eb 6e                	jmp    8010a3 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  801035:	50                   	push   %eax
  801036:	68 d8 28 80 00       	push   $0x8028d8
  80103b:	68 8a 00 00 00       	push   $0x8a
  801040:	68 e5 27 80 00       	push   $0x8027e5
  801045:	e8 4e 10 00 00       	call   802098 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  80104a:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801051:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801057:	89 da                	mov    %ebx,%edx
  801059:	89 f0                	mov    %esi,%eax
  80105b:	e8 b9 fd ff ff       	call   800e19 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801060:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801066:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80106c:	74 23                	je     801091 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80106e:	89 d8                	mov    %ebx,%eax
  801070:	c1 e8 16             	shr    $0x16,%eax
  801073:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107a:	a8 01                	test   $0x1,%al
  80107c:	74 e2                	je     801060 <fork_v0+0x67>
  80107e:	89 d8                	mov    %ebx,%eax
  801080:	c1 e8 0c             	shr    $0xc,%eax
  801083:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80108a:	f6 c2 01             	test   $0x1,%dl
  80108d:	74 d1                	je     801060 <fork_v0+0x67>
  80108f:	eb b9                	jmp    80104a <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	6a 02                	push   $0x2
  801096:	57                   	push   %edi
  801097:	e8 df fb ff ff       	call   800c7b <sys_env_set_status>
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	78 0a                	js     8010ad <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8010a3:	89 f8                	mov    %edi,%eax
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8010ad:	50                   	push   %eax
  8010ae:	68 fc 28 80 00       	push   $0x8028fc
  8010b3:	68 98 00 00 00       	push   $0x98
  8010b8:	68 e5 27 80 00       	push   $0x8027e5
  8010bd:	e8 d6 0f 00 00       	call   802098 <_panic>

008010c2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010c2:	f3 0f 1e fb          	endbr32 
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
  8010cc:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8010cf:	68 e6 0e 80 00       	push   $0x800ee6
  8010d4:	e8 09 10 00 00       	call   8020e2 <set_pgfault_handler>
  8010d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8010de:	cd 30                	int    $0x30
  8010e0:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 37                	js     801120 <fork+0x5e>
  8010e9:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8010eb:	74 48                	je     801135 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	6a 07                	push   $0x7
  8010f2:	68 00 f0 bf ee       	push   $0xeebff000
  8010f7:	50                   	push   %eax
  8010f8:	e8 05 fb ff ff       	call   800c02 <sys_page_alloc>
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 4d                	js     801151 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	68 5f 21 80 00       	push   $0x80215f
  80110c:	56                   	push   %esi
  80110d:	e8 b7 fb ff ff       	call   800cc9 <sys_env_set_pgfault_upcall>
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	78 4d                	js     801166 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801119:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111e:	eb 70                	jmp    801190 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801120:	50                   	push   %eax
  801121:	68 40 28 80 00       	push   $0x802840
  801126:	68 b7 00 00 00       	push   $0xb7
  80112b:	68 e5 27 80 00       	push   $0x8027e5
  801130:	e8 63 0f 00 00       	call   802098 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801135:	e8 75 fa ff ff       	call   800baf <sys_getenvid>
  80113a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80113f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801142:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801147:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80114c:	e9 80 00 00 00       	jmp    8011d1 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801151:	50                   	push   %eax
  801152:	68 50 28 80 00       	push   $0x802850
  801157:	68 c0 00 00 00       	push   $0xc0
  80115c:	68 e5 27 80 00       	push   $0x8027e5
  801161:	e8 32 0f 00 00       	call   802098 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801166:	50                   	push   %eax
  801167:	68 20 29 80 00       	push   $0x802920
  80116c:	68 c3 00 00 00       	push   $0xc3
  801171:	68 e5 27 80 00       	push   $0x8027e5
  801176:	e8 1d 0f 00 00       	call   802098 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  80117b:	89 f8                	mov    %edi,%eax
  80117d:	e8 bd fb ff ff       	call   800d3f <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801182:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801188:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80118e:	74 2f                	je     8011bf <fork+0xfd>
  801190:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  801192:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801198:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80119d:	76 e3                	jbe    801182 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80119f:	89 d8                	mov    %ebx,%eax
  8011a1:	c1 e8 16             	shr    $0x16,%eax
  8011a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ab:	a8 01                	test   $0x1,%al
  8011ad:	74 d3                	je     801182 <fork+0xc0>
  8011af:	c1 ea 0c             	shr    $0xc,%edx
  8011b2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011b9:	a8 01                	test   $0x1,%al
  8011bb:	74 c5                	je     801182 <fork+0xc0>
  8011bd:	eb bc                	jmp    80117b <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	6a 02                	push   $0x2
  8011c4:	56                   	push   %esi
  8011c5:	e8 b1 fa ff ff       	call   800c7b <sys_env_set_status>
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 0a                	js     8011db <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8011d1:	89 f0                	mov    %esi,%eax
  8011d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8011db:	50                   	push   %eax
  8011dc:	68 4c 29 80 00       	push   $0x80294c
  8011e1:	68 ce 00 00 00       	push   $0xce
  8011e6:	68 e5 27 80 00       	push   $0x8027e5
  8011eb:	e8 a8 0e 00 00       	call   802098 <_panic>

008011f0 <sfork>:

// Challenge!
int
sfork(void)
{
  8011f0:	f3 0f 1e fb          	endbr32 
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011fa:	68 6e 28 80 00       	push   $0x80286e
  8011ff:	68 d7 00 00 00       	push   $0xd7
  801204:	68 e5 27 80 00       	push   $0x8027e5
  801209:	e8 8a 0e 00 00       	call   802098 <_panic>

0080120e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80120e:	f3 0f 1e fb          	endbr32 
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	8b 75 08             	mov    0x8(%ebp),%esi
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801220:	85 c0                	test   %eax,%eax
  801222:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801227:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  80122a:	83 ec 0c             	sub    $0xc,%esp
  80122d:	50                   	push   %eax
  80122e:	e8 e6 fa ff ff       	call   800d19 <sys_ipc_recv>
	if (r < 0) {
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	78 2b                	js     801265 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  80123a:	85 f6                	test   %esi,%esi
  80123c:	74 0a                	je     801248 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  80123e:	a1 08 40 80 00       	mov    0x804008,%eax
  801243:	8b 40 74             	mov    0x74(%eax),%eax
  801246:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801248:	85 db                	test   %ebx,%ebx
  80124a:	74 0a                	je     801256 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  80124c:	a1 08 40 80 00       	mov    0x804008,%eax
  801251:	8b 40 78             	mov    0x78(%eax),%eax
  801254:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801256:	a1 08 40 80 00       	mov    0x804008,%eax
  80125b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80125e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5d                   	pop    %ebp
  801264:	c3                   	ret    
		if (from_env_store) {
  801265:	85 f6                	test   %esi,%esi
  801267:	74 06                	je     80126f <ipc_recv+0x61>
			*from_env_store = 0;
  801269:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  80126f:	85 db                	test   %ebx,%ebx
  801271:	74 eb                	je     80125e <ipc_recv+0x50>
			*perm_store = 0;
  801273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801279:	eb e3                	jmp    80125e <ipc_recv+0x50>

0080127b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80127b:	f3 0f 1e fb          	endbr32 
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	8b 7d 08             	mov    0x8(%ebp),%edi
  80128b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801291:	85 db                	test   %ebx,%ebx
  801293:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801298:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80129b:	ff 75 14             	pushl  0x14(%ebp)
  80129e:	53                   	push   %ebx
  80129f:	56                   	push   %esi
  8012a0:	57                   	push   %edi
  8012a1:	e8 4a fa ff ff       	call   800cf0 <sys_ipc_try_send>
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012ac:	75 07                	jne    8012b5 <ipc_send+0x3a>
		sys_yield();
  8012ae:	e8 24 f9 ff ff       	call   800bd7 <sys_yield>
  8012b3:	eb e6                	jmp    80129b <ipc_send+0x20>
	}

	if (ret < 0) {
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 08                	js     8012c1 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8012b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bc:	5b                   	pop    %ebx
  8012bd:	5e                   	pop    %esi
  8012be:	5f                   	pop    %edi
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  8012c1:	50                   	push   %eax
  8012c2:	68 6e 29 80 00       	push   $0x80296e
  8012c7:	6a 48                	push   $0x48
  8012c9:	68 8b 29 80 00       	push   $0x80298b
  8012ce:	e8 c5 0d 00 00       	call   802098 <_panic>

008012d3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012e2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012eb:	8b 52 50             	mov    0x50(%edx),%edx
  8012ee:	39 ca                	cmp    %ecx,%edx
  8012f0:	74 11                	je     801303 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012f2:	83 c0 01             	add    $0x1,%eax
  8012f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012fa:	75 e6                	jne    8012e2 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801301:	eb 0b                	jmp    80130e <ipc_find_env+0x3b>
			return envs[i].env_id;
  801303:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801306:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801310:	f3 0f 1e fb          	endbr32 
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	05 00 00 00 30       	add    $0x30000000,%eax
  80131f:	c1 e8 0c             	shr    $0xc,%eax
}
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801324:	f3 0f 1e fb          	endbr32 
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80132e:	ff 75 08             	pushl  0x8(%ebp)
  801331:	e8 da ff ff ff       	call   801310 <fd2num>
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	c1 e0 0c             	shl    $0xc,%eax
  80133c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801343:	f3 0f 1e fb          	endbr32 
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80134f:	89 c2                	mov    %eax,%edx
  801351:	c1 ea 16             	shr    $0x16,%edx
  801354:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135b:	f6 c2 01             	test   $0x1,%dl
  80135e:	74 2d                	je     80138d <fd_alloc+0x4a>
  801360:	89 c2                	mov    %eax,%edx
  801362:	c1 ea 0c             	shr    $0xc,%edx
  801365:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136c:	f6 c2 01             	test   $0x1,%dl
  80136f:	74 1c                	je     80138d <fd_alloc+0x4a>
  801371:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801376:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80137b:	75 d2                	jne    80134f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801386:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80138b:	eb 0a                	jmp    801397 <fd_alloc+0x54>
			*fd_store = fd;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	89 01                	mov    %eax,(%ecx)
			return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801399:	f3 0f 1e fb          	endbr32 
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a3:	83 f8 1f             	cmp    $0x1f,%eax
  8013a6:	77 30                	ja     8013d8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a8:	c1 e0 0c             	shl    $0xc,%eax
  8013ab:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013b0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013b6:	f6 c2 01             	test   $0x1,%dl
  8013b9:	74 24                	je     8013df <fd_lookup+0x46>
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	c1 ea 0c             	shr    $0xc,%edx
  8013c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	74 1a                	je     8013e6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	89 02                	mov    %eax,(%edx)
	return 0;
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    
		return -E_INVAL;
  8013d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013dd:	eb f7                	jmp    8013d6 <fd_lookup+0x3d>
		return -E_INVAL;
  8013df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e4:	eb f0                	jmp    8013d6 <fd_lookup+0x3d>
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb e9                	jmp    8013d6 <fd_lookup+0x3d>

008013ed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ed:	f3 0f 1e fb          	endbr32 
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 08             	sub    $0x8,%esp
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	ba 14 2a 80 00       	mov    $0x802a14,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801404:	39 08                	cmp    %ecx,(%eax)
  801406:	74 33                	je     80143b <dev_lookup+0x4e>
  801408:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80140b:	8b 02                	mov    (%edx),%eax
  80140d:	85 c0                	test   %eax,%eax
  80140f:	75 f3                	jne    801404 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801411:	a1 08 40 80 00       	mov    0x804008,%eax
  801416:	8b 40 48             	mov    0x48(%eax),%eax
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	51                   	push   %ecx
  80141d:	50                   	push   %eax
  80141e:	68 98 29 80 00       	push   $0x802998
  801423:	e8 e8 ed ff ff       	call   800210 <cprintf>
	*dev = 0;
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    
			*dev = devtab[i];
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb f2                	jmp    801439 <dev_lookup+0x4c>

00801447 <fd_close>:
{
  801447:	f3 0f 1e fb          	endbr32 
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	57                   	push   %edi
  80144f:	56                   	push   %esi
  801450:	53                   	push   %ebx
  801451:	83 ec 28             	sub    $0x28,%esp
  801454:	8b 75 08             	mov    0x8(%ebp),%esi
  801457:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80145a:	56                   	push   %esi
  80145b:	e8 b0 fe ff ff       	call   801310 <fd2num>
  801460:	83 c4 08             	add    $0x8,%esp
  801463:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801466:	52                   	push   %edx
  801467:	50                   	push   %eax
  801468:	e8 2c ff ff ff       	call   801399 <fd_lookup>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	78 05                	js     80147b <fd_close+0x34>
	    || fd != fd2)
  801476:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801479:	74 16                	je     801491 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80147b:	89 f8                	mov    %edi,%eax
  80147d:	84 c0                	test   %al,%al
  80147f:	b8 00 00 00 00       	mov    $0x0,%eax
  801484:	0f 44 d8             	cmove  %eax,%ebx
}
  801487:	89 d8                	mov    %ebx,%eax
  801489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801497:	50                   	push   %eax
  801498:	ff 36                	pushl  (%esi)
  80149a:	e8 4e ff ff ff       	call   8013ed <dev_lookup>
  80149f:	89 c3                	mov    %eax,%ebx
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 1a                	js     8014c2 <fd_close+0x7b>
		if (dev->dev_close)
  8014a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	74 0b                	je     8014c2 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	56                   	push   %esi
  8014bb:	ff d0                	call   *%eax
  8014bd:	89 c3                	mov    %eax,%ebx
  8014bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014c2:	83 ec 08             	sub    $0x8,%esp
  8014c5:	56                   	push   %esi
  8014c6:	6a 00                	push   $0x0
  8014c8:	e8 87 f7 ff ff       	call   800c54 <sys_page_unmap>
	return r;
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	eb b5                	jmp    801487 <fd_close+0x40>

008014d2 <close>:

int
close(int fdnum)
{
  8014d2:	f3 0f 1e fb          	endbr32 
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014df:	50                   	push   %eax
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	e8 b1 fe ff ff       	call   801399 <fd_lookup>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	79 02                	jns    8014f1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    
		return fd_close(fd, 1);
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	6a 01                	push   $0x1
  8014f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f9:	e8 49 ff ff ff       	call   801447 <fd_close>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	eb ec                	jmp    8014ef <close+0x1d>

00801503 <close_all>:

void
close_all(void)
{
  801503:	f3 0f 1e fb          	endbr32 
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80150e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	53                   	push   %ebx
  801517:	e8 b6 ff ff ff       	call   8014d2 <close>
	for (i = 0; i < MAXFD; i++)
  80151c:	83 c3 01             	add    $0x1,%ebx
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	83 fb 20             	cmp    $0x20,%ebx
  801525:	75 ec                	jne    801513 <close_all+0x10>
}
  801527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152c:	f3 0f 1e fb          	endbr32 
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	57                   	push   %edi
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
  801536:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801539:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153c:	50                   	push   %eax
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	e8 54 fe ff ff       	call   801399 <fd_lookup>
  801545:	89 c3                	mov    %eax,%ebx
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	85 c0                	test   %eax,%eax
  80154c:	0f 88 81 00 00 00    	js     8015d3 <dup+0xa7>
		return r;
	close(newfdnum);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 75 ff ff ff       	call   8014d2 <close>

	newfd = INDEX2FD(newfdnum);
  80155d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801560:	c1 e6 0c             	shl    $0xc,%esi
  801563:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801569:	83 c4 04             	add    $0x4,%esp
  80156c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156f:	e8 b0 fd ff ff       	call   801324 <fd2data>
  801574:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801576:	89 34 24             	mov    %esi,(%esp)
  801579:	e8 a6 fd ff ff       	call   801324 <fd2data>
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801583:	89 d8                	mov    %ebx,%eax
  801585:	c1 e8 16             	shr    $0x16,%eax
  801588:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80158f:	a8 01                	test   $0x1,%al
  801591:	74 11                	je     8015a4 <dup+0x78>
  801593:	89 d8                	mov    %ebx,%eax
  801595:	c1 e8 0c             	shr    $0xc,%eax
  801598:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	75 39                	jne    8015dd <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a7:	89 d0                	mov    %edx,%eax
  8015a9:	c1 e8 0c             	shr    $0xc,%eax
  8015ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b3:	83 ec 0c             	sub    $0xc,%esp
  8015b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8015bb:	50                   	push   %eax
  8015bc:	56                   	push   %esi
  8015bd:	6a 00                	push   $0x0
  8015bf:	52                   	push   %edx
  8015c0:	6a 00                	push   $0x0
  8015c2:	e8 63 f6 ff ff       	call   800c2a <sys_page_map>
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	83 c4 20             	add    $0x20,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 31                	js     801601 <dup+0xd5>
		goto err;

	return newfdnum;
  8015d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5f                   	pop    %edi
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ec:	50                   	push   %eax
  8015ed:	57                   	push   %edi
  8015ee:	6a 00                	push   $0x0
  8015f0:	53                   	push   %ebx
  8015f1:	6a 00                	push   $0x0
  8015f3:	e8 32 f6 ff ff       	call   800c2a <sys_page_map>
  8015f8:	89 c3                	mov    %eax,%ebx
  8015fa:	83 c4 20             	add    $0x20,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	79 a3                	jns    8015a4 <dup+0x78>
	sys_page_unmap(0, newfd);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	56                   	push   %esi
  801605:	6a 00                	push   $0x0
  801607:	e8 48 f6 ff ff       	call   800c54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80160c:	83 c4 08             	add    $0x8,%esp
  80160f:	57                   	push   %edi
  801610:	6a 00                	push   $0x0
  801612:	e8 3d f6 ff ff       	call   800c54 <sys_page_unmap>
	return r;
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	eb b7                	jmp    8015d3 <dup+0xa7>

0080161c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80161c:	f3 0f 1e fb          	endbr32 
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 1c             	sub    $0x1c,%esp
  801627:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	53                   	push   %ebx
  80162f:	e8 65 fd ff ff       	call   801399 <fd_lookup>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 3f                	js     80167a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801641:	50                   	push   %eax
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	ff 30                	pushl  (%eax)
  801647:	e8 a1 fd ff ff       	call   8013ed <dev_lookup>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 27                	js     80167a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801653:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801656:	8b 42 08             	mov    0x8(%edx),%eax
  801659:	83 e0 03             	and    $0x3,%eax
  80165c:	83 f8 01             	cmp    $0x1,%eax
  80165f:	74 1e                	je     80167f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801664:	8b 40 08             	mov    0x8(%eax),%eax
  801667:	85 c0                	test   %eax,%eax
  801669:	74 35                	je     8016a0 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	ff 75 10             	pushl  0x10(%ebp)
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	52                   	push   %edx
  801675:	ff d0                	call   *%eax
  801677:	83 c4 10             	add    $0x10,%esp
}
  80167a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80167f:	a1 08 40 80 00       	mov    0x804008,%eax
  801684:	8b 40 48             	mov    0x48(%eax),%eax
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	53                   	push   %ebx
  80168b:	50                   	push   %eax
  80168c:	68 d9 29 80 00       	push   $0x8029d9
  801691:	e8 7a eb ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169e:	eb da                	jmp    80167a <read+0x5e>
		return -E_NOT_SUPP;
  8016a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a5:	eb d3                	jmp    80167a <read+0x5e>

008016a7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a7:	f3 0f 1e fb          	endbr32 
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016bf:	eb 02                	jmp    8016c3 <readn+0x1c>
  8016c1:	01 c3                	add    %eax,%ebx
  8016c3:	39 f3                	cmp    %esi,%ebx
  8016c5:	73 21                	jae    8016e8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	89 f0                	mov    %esi,%eax
  8016cc:	29 d8                	sub    %ebx,%eax
  8016ce:	50                   	push   %eax
  8016cf:	89 d8                	mov    %ebx,%eax
  8016d1:	03 45 0c             	add    0xc(%ebp),%eax
  8016d4:	50                   	push   %eax
  8016d5:	57                   	push   %edi
  8016d6:	e8 41 ff ff ff       	call   80161c <read>
		if (m < 0)
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	78 04                	js     8016e6 <readn+0x3f>
			return m;
		if (m == 0)
  8016e2:	75 dd                	jne    8016c1 <readn+0x1a>
  8016e4:	eb 02                	jmp    8016e8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5e                   	pop    %esi
  8016ef:	5f                   	pop    %edi
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    

008016f2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f2:	f3 0f 1e fb          	endbr32 
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	53                   	push   %ebx
  8016fa:	83 ec 1c             	sub    $0x1c,%esp
  8016fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801700:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	53                   	push   %ebx
  801705:	e8 8f fc ff ff       	call   801399 <fd_lookup>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 3a                	js     80174b <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801717:	50                   	push   %eax
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	ff 30                	pushl  (%eax)
  80171d:	e8 cb fc ff ff       	call   8013ed <dev_lookup>
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 22                	js     80174b <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801730:	74 1e                	je     801750 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801735:	8b 52 0c             	mov    0xc(%edx),%edx
  801738:	85 d2                	test   %edx,%edx
  80173a:	74 35                	je     801771 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	ff 75 10             	pushl  0x10(%ebp)
  801742:	ff 75 0c             	pushl  0xc(%ebp)
  801745:	50                   	push   %eax
  801746:	ff d2                	call   *%edx
  801748:	83 c4 10             	add    $0x10,%esp
}
  80174b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801750:	a1 08 40 80 00       	mov    0x804008,%eax
  801755:	8b 40 48             	mov    0x48(%eax),%eax
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	53                   	push   %ebx
  80175c:	50                   	push   %eax
  80175d:	68 f5 29 80 00       	push   $0x8029f5
  801762:	e8 a9 ea ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176f:	eb da                	jmp    80174b <write+0x59>
		return -E_NOT_SUPP;
  801771:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801776:	eb d3                	jmp    80174b <write+0x59>

00801778 <seek>:

int
seek(int fdnum, off_t offset)
{
  801778:	f3 0f 1e fb          	endbr32 
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801782:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	e8 0b fc ff ff       	call   801399 <fd_lookup>
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	85 c0                	test   %eax,%eax
  801793:	78 0e                	js     8017a3 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801795:	8b 55 0c             	mov    0xc(%ebp),%edx
  801798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a5:	f3 0f 1e fb          	endbr32 
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 1c             	sub    $0x1c,%esp
  8017b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b6:	50                   	push   %eax
  8017b7:	53                   	push   %ebx
  8017b8:	e8 dc fb ff ff       	call   801399 <fd_lookup>
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	78 37                	js     8017fb <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c4:	83 ec 08             	sub    $0x8,%esp
  8017c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ca:	50                   	push   %eax
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ce:	ff 30                	pushl  (%eax)
  8017d0:	e8 18 fc ff ff       	call   8013ed <dev_lookup>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	78 1f                	js     8017fb <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e3:	74 1b                	je     801800 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e8:	8b 52 18             	mov    0x18(%edx),%edx
  8017eb:	85 d2                	test   %edx,%edx
  8017ed:	74 32                	je     801821 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	50                   	push   %eax
  8017f6:	ff d2                	call   *%edx
  8017f8:	83 c4 10             	add    $0x10,%esp
}
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    
			thisenv->env_id, fdnum);
  801800:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801805:	8b 40 48             	mov    0x48(%eax),%eax
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	53                   	push   %ebx
  80180c:	50                   	push   %eax
  80180d:	68 b8 29 80 00       	push   $0x8029b8
  801812:	e8 f9 e9 ff ff       	call   800210 <cprintf>
		return -E_INVAL;
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181f:	eb da                	jmp    8017fb <ftruncate+0x56>
		return -E_NOT_SUPP;
  801821:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801826:	eb d3                	jmp    8017fb <ftruncate+0x56>

00801828 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801828:	f3 0f 1e fb          	endbr32 
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	83 ec 1c             	sub    $0x1c,%esp
  801833:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801836:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801839:	50                   	push   %eax
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 57 fb ff ff       	call   801399 <fd_lookup>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	78 4b                	js     801894 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184f:	50                   	push   %eax
  801850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801853:	ff 30                	pushl  (%eax)
  801855:	e8 93 fb ff ff       	call   8013ed <dev_lookup>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 33                	js     801894 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801864:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801868:	74 2f                	je     801899 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80186a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80186d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801874:	00 00 00 
	stat->st_isdir = 0;
  801877:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80187e:	00 00 00 
	stat->st_dev = dev;
  801881:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	53                   	push   %ebx
  80188b:	ff 75 f0             	pushl  -0x10(%ebp)
  80188e:	ff 50 14             	call   *0x14(%eax)
  801891:	83 c4 10             	add    $0x10,%esp
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    
		return -E_NOT_SUPP;
  801899:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189e:	eb f4                	jmp    801894 <fstat+0x6c>

008018a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a0:	f3 0f 1e fb          	endbr32 
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 3a 02 00 00       	call   801af0 <open>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 1b                	js     8018da <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	50                   	push   %eax
  8018c6:	e8 5d ff ff ff       	call   801828 <fstat>
  8018cb:	89 c6                	mov    %eax,%esi
	close(fd);
  8018cd:	89 1c 24             	mov    %ebx,(%esp)
  8018d0:	e8 fd fb ff ff       	call   8014d2 <close>
	return r;
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	89 f3                	mov    %esi,%ebx
}
  8018da:	89 d8                	mov    %ebx,%eax
  8018dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	89 c6                	mov    %eax,%esi
  8018ea:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ec:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018f3:	74 27                	je     80191c <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f5:	6a 07                	push   $0x7
  8018f7:	68 00 50 80 00       	push   $0x805000
  8018fc:	56                   	push   %esi
  8018fd:	ff 35 00 40 80 00    	pushl  0x804000
  801903:	e8 73 f9 ff ff       	call   80127b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801908:	83 c4 0c             	add    $0xc,%esp
  80190b:	6a 00                	push   $0x0
  80190d:	53                   	push   %ebx
  80190e:	6a 00                	push   $0x0
  801910:	e8 f9 f8 ff ff       	call   80120e <ipc_recv>
}
  801915:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801918:	5b                   	pop    %ebx
  801919:	5e                   	pop    %esi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	6a 01                	push   $0x1
  801921:	e8 ad f9 ff ff       	call   8012d3 <ipc_find_env>
  801926:	a3 00 40 80 00       	mov    %eax,0x804000
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	eb c5                	jmp    8018f5 <fsipc+0x12>

00801930 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801930:	f3 0f 1e fb          	endbr32 
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	8b 40 0c             	mov    0xc(%eax),%eax
  801940:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80194d:	ba 00 00 00 00       	mov    $0x0,%edx
  801952:	b8 02 00 00 00       	mov    $0x2,%eax
  801957:	e8 87 ff ff ff       	call   8018e3 <fsipc>
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <devfile_flush>:
{
  80195e:	f3 0f 1e fb          	endbr32 
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8b 40 0c             	mov    0xc(%eax),%eax
  80196e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
  801978:	b8 06 00 00 00       	mov    $0x6,%eax
  80197d:	e8 61 ff ff ff       	call   8018e3 <fsipc>
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <devfile_stat>:
{
  801984:	f3 0f 1e fb          	endbr32 
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	53                   	push   %ebx
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8b 40 0c             	mov    0xc(%eax),%eax
  801998:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80199d:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a7:	e8 37 ff ff ff       	call   8018e3 <fsipc>
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 2c                	js     8019dc <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	68 00 50 80 00       	push   $0x805000
  8019b8:	53                   	push   %ebx
  8019b9:	e8 bc ed ff ff       	call   80077a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019be:	a1 80 50 80 00       	mov    0x805080,%eax
  8019c3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019c9:	a1 84 50 80 00       	mov    0x805084,%eax
  8019ce:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <devfile_write>:
{
  8019e1:	f3 0f 1e fb          	endbr32 
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019fa:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a00:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a06:	77 30                	ja     801a38 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	53                   	push   %ebx
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	68 08 50 80 00       	push   $0x805008
  801a14:	e8 19 ef ff ff       	call   800932 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801a23:	e8 bb fe ff ff       	call   8018e3 <fsipc>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 04                	js     801a33 <devfile_write+0x52>
	assert(r <= n);
  801a2f:	39 d8                	cmp    %ebx,%eax
  801a31:	77 1e                	ja     801a51 <devfile_write+0x70>
}
  801a33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a38:	68 24 2a 80 00       	push   $0x802a24
  801a3d:	68 51 2a 80 00       	push   $0x802a51
  801a42:	68 94 00 00 00       	push   $0x94
  801a47:	68 66 2a 80 00       	push   $0x802a66
  801a4c:	e8 47 06 00 00       	call   802098 <_panic>
	assert(r <= n);
  801a51:	68 71 2a 80 00       	push   $0x802a71
  801a56:	68 51 2a 80 00       	push   $0x802a51
  801a5b:	68 98 00 00 00       	push   $0x98
  801a60:	68 66 2a 80 00       	push   $0x802a66
  801a65:	e8 2e 06 00 00       	call   802098 <_panic>

00801a6a <devfile_read>:
{
  801a6a:	f3 0f 1e fb          	endbr32 
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	56                   	push   %esi
  801a72:	53                   	push   %ebx
  801a73:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a81:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801a91:	e8 4d fe ff ff       	call   8018e3 <fsipc>
  801a96:	89 c3                	mov    %eax,%ebx
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 1f                	js     801abb <devfile_read+0x51>
	assert(r <= n);
  801a9c:	39 f0                	cmp    %esi,%eax
  801a9e:	77 24                	ja     801ac4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801aa0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa5:	7f 33                	jg     801ada <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	50                   	push   %eax
  801aab:	68 00 50 80 00       	push   $0x805000
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	e8 7a ee ff ff       	call   800932 <memmove>
	return r;
  801ab8:	83 c4 10             	add    $0x10,%esp
}
  801abb:	89 d8                	mov    %ebx,%eax
  801abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
	assert(r <= n);
  801ac4:	68 71 2a 80 00       	push   $0x802a71
  801ac9:	68 51 2a 80 00       	push   $0x802a51
  801ace:	6a 7c                	push   $0x7c
  801ad0:	68 66 2a 80 00       	push   $0x802a66
  801ad5:	e8 be 05 00 00       	call   802098 <_panic>
	assert(r <= PGSIZE);
  801ada:	68 78 2a 80 00       	push   $0x802a78
  801adf:	68 51 2a 80 00       	push   $0x802a51
  801ae4:	6a 7d                	push   $0x7d
  801ae6:	68 66 2a 80 00       	push   $0x802a66
  801aeb:	e8 a8 05 00 00       	call   802098 <_panic>

00801af0 <open>:
{
  801af0:	f3 0f 1e fb          	endbr32 
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	83 ec 1c             	sub    $0x1c,%esp
  801afc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801aff:	56                   	push   %esi
  801b00:	e8 32 ec ff ff       	call   800737 <strlen>
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b0d:	7f 6c                	jg     801b7b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b15:	50                   	push   %eax
  801b16:	e8 28 f8 ff ff       	call   801343 <fd_alloc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	78 3c                	js     801b60 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b24:	83 ec 08             	sub    $0x8,%esp
  801b27:	56                   	push   %esi
  801b28:	68 00 50 80 00       	push   $0x805000
  801b2d:	e8 48 ec ff ff       	call   80077a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b35:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b42:	e8 9c fd ff ff       	call   8018e3 <fsipc>
  801b47:	89 c3                	mov    %eax,%ebx
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 19                	js     801b69 <open+0x79>
	return fd2num(fd);
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	ff 75 f4             	pushl  -0xc(%ebp)
  801b56:	e8 b5 f7 ff ff       	call   801310 <fd2num>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	83 c4 10             	add    $0x10,%esp
}
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
		fd_close(fd, 0);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b71:	e8 d1 f8 ff ff       	call   801447 <fd_close>
		return r;
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	eb e5                	jmp    801b60 <open+0x70>
		return -E_BAD_PATH;
  801b7b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b80:	eb de                	jmp    801b60 <open+0x70>

00801b82 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b82:	f3 0f 1e fb          	endbr32 
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b91:	b8 08 00 00 00       	mov    $0x8,%eax
  801b96:	e8 48 fd ff ff       	call   8018e3 <fsipc>
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b9d:	f3 0f 1e fb          	endbr32 
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ba9:	83 ec 0c             	sub    $0xc,%esp
  801bac:	ff 75 08             	pushl  0x8(%ebp)
  801baf:	e8 70 f7 ff ff       	call   801324 <fd2data>
  801bb4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bb6:	83 c4 08             	add    $0x8,%esp
  801bb9:	68 84 2a 80 00       	push   $0x802a84
  801bbe:	53                   	push   %ebx
  801bbf:	e8 b6 eb ff ff       	call   80077a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bc4:	8b 46 04             	mov    0x4(%esi),%eax
  801bc7:	2b 06                	sub    (%esi),%eax
  801bc9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bcf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd6:	00 00 00 
	stat->st_dev = &devpipe;
  801bd9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801be0:	30 80 00 
	return 0;
}
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	53                   	push   %ebx
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bfd:	53                   	push   %ebx
  801bfe:	6a 00                	push   $0x0
  801c00:	e8 4f f0 ff ff       	call   800c54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c05:	89 1c 24             	mov    %ebx,(%esp)
  801c08:	e8 17 f7 ff ff       	call   801324 <fd2data>
  801c0d:	83 c4 08             	add    $0x8,%esp
  801c10:	50                   	push   %eax
  801c11:	6a 00                	push   $0x0
  801c13:	e8 3c f0 ff ff       	call   800c54 <sys_page_unmap>
}
  801c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <_pipeisclosed>:
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	57                   	push   %edi
  801c21:	56                   	push   %esi
  801c22:	53                   	push   %ebx
  801c23:	83 ec 1c             	sub    $0x1c,%esp
  801c26:	89 c7                	mov    %eax,%edi
  801c28:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c2a:	a1 08 40 80 00       	mov    0x804008,%eax
  801c2f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	57                   	push   %edi
  801c36:	e8 4a 05 00 00       	call   802185 <pageref>
  801c3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c3e:	89 34 24             	mov    %esi,(%esp)
  801c41:	e8 3f 05 00 00       	call   802185 <pageref>
		nn = thisenv->env_runs;
  801c46:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c4c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	39 cb                	cmp    %ecx,%ebx
  801c54:	74 1b                	je     801c71 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c56:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c59:	75 cf                	jne    801c2a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c5b:	8b 42 58             	mov    0x58(%edx),%eax
  801c5e:	6a 01                	push   $0x1
  801c60:	50                   	push   %eax
  801c61:	53                   	push   %ebx
  801c62:	68 8b 2a 80 00       	push   $0x802a8b
  801c67:	e8 a4 e5 ff ff       	call   800210 <cprintf>
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	eb b9                	jmp    801c2a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c71:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c74:	0f 94 c0             	sete   %al
  801c77:	0f b6 c0             	movzbl %al,%eax
}
  801c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5f                   	pop    %edi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <devpipe_write>:
{
  801c82:	f3 0f 1e fb          	endbr32 
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	57                   	push   %edi
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 28             	sub    $0x28,%esp
  801c8f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c92:	56                   	push   %esi
  801c93:	e8 8c f6 ff ff       	call   801324 <fd2data>
  801c98:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ca5:	74 4f                	je     801cf6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ca7:	8b 43 04             	mov    0x4(%ebx),%eax
  801caa:	8b 0b                	mov    (%ebx),%ecx
  801cac:	8d 51 20             	lea    0x20(%ecx),%edx
  801caf:	39 d0                	cmp    %edx,%eax
  801cb1:	72 14                	jb     801cc7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801cb3:	89 da                	mov    %ebx,%edx
  801cb5:	89 f0                	mov    %esi,%eax
  801cb7:	e8 61 ff ff ff       	call   801c1d <_pipeisclosed>
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	75 3b                	jne    801cfb <devpipe_write+0x79>
			sys_yield();
  801cc0:	e8 12 ef ff ff       	call   800bd7 <sys_yield>
  801cc5:	eb e0                	jmp    801ca7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cd1:	89 c2                	mov    %eax,%edx
  801cd3:	c1 fa 1f             	sar    $0x1f,%edx
  801cd6:	89 d1                	mov    %edx,%ecx
  801cd8:	c1 e9 1b             	shr    $0x1b,%ecx
  801cdb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cde:	83 e2 1f             	and    $0x1f,%edx
  801ce1:	29 ca                	sub    %ecx,%edx
  801ce3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ce7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ceb:	83 c0 01             	add    $0x1,%eax
  801cee:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cf1:	83 c7 01             	add    $0x1,%edi
  801cf4:	eb ac                	jmp    801ca2 <devpipe_write+0x20>
	return i;
  801cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf9:	eb 05                	jmp    801d00 <devpipe_write+0x7e>
				return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <devpipe_read>:
{
  801d08:	f3 0f 1e fb          	endbr32 
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	57                   	push   %edi
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	83 ec 18             	sub    $0x18,%esp
  801d15:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d18:	57                   	push   %edi
  801d19:	e8 06 f6 ff ff       	call   801324 <fd2data>
  801d1e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	be 00 00 00 00       	mov    $0x0,%esi
  801d28:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d2b:	75 14                	jne    801d41 <devpipe_read+0x39>
	return i;
  801d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d30:	eb 02                	jmp    801d34 <devpipe_read+0x2c>
				return i;
  801d32:	89 f0                	mov    %esi,%eax
}
  801d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
			sys_yield();
  801d3c:	e8 96 ee ff ff       	call   800bd7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d41:	8b 03                	mov    (%ebx),%eax
  801d43:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d46:	75 18                	jne    801d60 <devpipe_read+0x58>
			if (i > 0)
  801d48:	85 f6                	test   %esi,%esi
  801d4a:	75 e6                	jne    801d32 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d4c:	89 da                	mov    %ebx,%edx
  801d4e:	89 f8                	mov    %edi,%eax
  801d50:	e8 c8 fe ff ff       	call   801c1d <_pipeisclosed>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	74 e3                	je     801d3c <devpipe_read+0x34>
				return 0;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	eb d4                	jmp    801d34 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d60:	99                   	cltd   
  801d61:	c1 ea 1b             	shr    $0x1b,%edx
  801d64:	01 d0                	add    %edx,%eax
  801d66:	83 e0 1f             	and    $0x1f,%eax
  801d69:	29 d0                	sub    %edx,%eax
  801d6b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d73:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d76:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d79:	83 c6 01             	add    $0x1,%esi
  801d7c:	eb aa                	jmp    801d28 <devpipe_read+0x20>

00801d7e <pipe>:
{
  801d7e:	f3 0f 1e fb          	endbr32 
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8d:	50                   	push   %eax
  801d8e:	e8 b0 f5 ff ff       	call   801343 <fd_alloc>
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	0f 88 23 01 00 00    	js     801ec3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	68 07 04 00 00       	push   $0x407
  801da8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dab:	6a 00                	push   $0x0
  801dad:	e8 50 ee ff ff       	call   800c02 <sys_page_alloc>
  801db2:	89 c3                	mov    %eax,%ebx
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	85 c0                	test   %eax,%eax
  801db9:	0f 88 04 01 00 00    	js     801ec3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	e8 78 f5 ff ff       	call   801343 <fd_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 db 00 00 00    	js     801eb3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	68 07 04 00 00       	push   $0x407
  801de0:	ff 75 f0             	pushl  -0x10(%ebp)
  801de3:	6a 00                	push   $0x0
  801de5:	e8 18 ee ff ff       	call   800c02 <sys_page_alloc>
  801dea:	89 c3                	mov    %eax,%ebx
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	85 c0                	test   %eax,%eax
  801df1:	0f 88 bc 00 00 00    	js     801eb3 <pipe+0x135>
	va = fd2data(fd0);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 22 f5 ff ff       	call   801324 <fd2data>
  801e02:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e04:	83 c4 0c             	add    $0xc,%esp
  801e07:	68 07 04 00 00       	push   $0x407
  801e0c:	50                   	push   %eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	e8 ee ed ff ff       	call   800c02 <sys_page_alloc>
  801e14:	89 c3                	mov    %eax,%ebx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	0f 88 82 00 00 00    	js     801ea3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	ff 75 f0             	pushl  -0x10(%ebp)
  801e27:	e8 f8 f4 ff ff       	call   801324 <fd2data>
  801e2c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e33:	50                   	push   %eax
  801e34:	6a 00                	push   $0x0
  801e36:	56                   	push   %esi
  801e37:	6a 00                	push   $0x0
  801e39:	e8 ec ed ff ff       	call   800c2a <sys_page_map>
  801e3e:	89 c3                	mov    %eax,%ebx
  801e40:	83 c4 20             	add    $0x20,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 4e                	js     801e95 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e47:	a1 20 30 80 00       	mov    0x803020,%eax
  801e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e54:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e63:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e6a:	83 ec 0c             	sub    $0xc,%esp
  801e6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e70:	e8 9b f4 ff ff       	call   801310 <fd2num>
  801e75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e78:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e7a:	83 c4 04             	add    $0x4,%esp
  801e7d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e80:	e8 8b f4 ff ff       	call   801310 <fd2num>
  801e85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e88:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e93:	eb 2e                	jmp    801ec3 <pipe+0x145>
	sys_page_unmap(0, va);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	56                   	push   %esi
  801e99:	6a 00                	push   $0x0
  801e9b:	e8 b4 ed ff ff       	call   800c54 <sys_page_unmap>
  801ea0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ea3:	83 ec 08             	sub    $0x8,%esp
  801ea6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea9:	6a 00                	push   $0x0
  801eab:	e8 a4 ed ff ff       	call   800c54 <sys_page_unmap>
  801eb0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb9:	6a 00                	push   $0x0
  801ebb:	e8 94 ed ff ff       	call   800c54 <sys_page_unmap>
  801ec0:	83 c4 10             	add    $0x10,%esp
}
  801ec3:	89 d8                	mov    %ebx,%eax
  801ec5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <pipeisclosed>:
{
  801ecc:	f3 0f 1e fb          	endbr32 
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed9:	50                   	push   %eax
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	e8 b7 f4 ff ff       	call   801399 <fd_lookup>
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 18                	js     801f01 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	ff 75 f4             	pushl  -0xc(%ebp)
  801eef:	e8 30 f4 ff ff       	call   801324 <fd2data>
  801ef4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	e8 1f fd ff ff       	call   801c1d <_pipeisclosed>
  801efe:	83 c4 10             	add    $0x10,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f03:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	c3                   	ret    

00801f0d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f0d:	f3 0f 1e fb          	endbr32 
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f17:	68 a3 2a 80 00       	push   $0x802aa3
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	e8 56 e8 ff ff       	call   80077a <strcpy>
	return 0;
}
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <devcons_write>:
{
  801f2b:	f3 0f 1e fb          	endbr32 
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	57                   	push   %edi
  801f33:	56                   	push   %esi
  801f34:	53                   	push   %ebx
  801f35:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f3b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f40:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f49:	73 31                	jae    801f7c <devcons_write+0x51>
		m = n - tot;
  801f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f4e:	29 f3                	sub    %esi,%ebx
  801f50:	83 fb 7f             	cmp    $0x7f,%ebx
  801f53:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f58:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	53                   	push   %ebx
  801f5f:	89 f0                	mov    %esi,%eax
  801f61:	03 45 0c             	add    0xc(%ebp),%eax
  801f64:	50                   	push   %eax
  801f65:	57                   	push   %edi
  801f66:	e8 c7 e9 ff ff       	call   800932 <memmove>
		sys_cputs(buf, m);
  801f6b:	83 c4 08             	add    $0x8,%esp
  801f6e:	53                   	push   %ebx
  801f6f:	57                   	push   %edi
  801f70:	e8 c2 eb ff ff       	call   800b37 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f75:	01 de                	add    %ebx,%esi
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	eb ca                	jmp    801f46 <devcons_write+0x1b>
}
  801f7c:	89 f0                	mov    %esi,%eax
  801f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    

00801f86 <devcons_read>:
{
  801f86:	f3 0f 1e fb          	endbr32 
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f99:	74 21                	je     801fbc <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f9b:	e8 c1 eb ff ff       	call   800b61 <sys_cgetc>
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	75 07                	jne    801fab <devcons_read+0x25>
		sys_yield();
  801fa4:	e8 2e ec ff ff       	call   800bd7 <sys_yield>
  801fa9:	eb f0                	jmp    801f9b <devcons_read+0x15>
	if (c < 0)
  801fab:	78 0f                	js     801fbc <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fad:	83 f8 04             	cmp    $0x4,%eax
  801fb0:	74 0c                	je     801fbe <devcons_read+0x38>
	*(char*)vbuf = c;
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	88 02                	mov    %al,(%edx)
	return 1;
  801fb7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    
		return 0;
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc3:	eb f7                	jmp    801fbc <devcons_read+0x36>

00801fc5 <cputchar>:
{
  801fc5:	f3 0f 1e fb          	endbr32 
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fd5:	6a 01                	push   $0x1
  801fd7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fda:	50                   	push   %eax
  801fdb:	e8 57 eb ff ff       	call   800b37 <sys_cputs>
}
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <getchar>:
{
  801fe5:	f3 0f 1e fb          	endbr32 
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fef:	6a 01                	push   $0x1
  801ff1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	6a 00                	push   $0x0
  801ff7:	e8 20 f6 ff ff       	call   80161c <read>
	if (r < 0)
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 06                	js     802009 <getchar+0x24>
	if (r < 1)
  802003:	74 06                	je     80200b <getchar+0x26>
	return c;
  802005:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    
		return -E_EOF;
  80200b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802010:	eb f7                	jmp    802009 <getchar+0x24>

00802012 <iscons>:
{
  802012:	f3 0f 1e fb          	endbr32 
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201f:	50                   	push   %eax
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	e8 71 f3 ff ff       	call   801399 <fd_lookup>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 11                	js     802040 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802038:	39 10                	cmp    %edx,(%eax)
  80203a:	0f 94 c0             	sete   %al
  80203d:	0f b6 c0             	movzbl %al,%eax
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <opencons>:
{
  802042:	f3 0f 1e fb          	endbr32 
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80204c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204f:	50                   	push   %eax
  802050:	e8 ee f2 ff ff       	call   801343 <fd_alloc>
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 3a                	js     802096 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	68 07 04 00 00       	push   $0x407
  802064:	ff 75 f4             	pushl  -0xc(%ebp)
  802067:	6a 00                	push   $0x0
  802069:	e8 94 eb ff ff       	call   800c02 <sys_page_alloc>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 c0                	test   %eax,%eax
  802073:	78 21                	js     802096 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80207e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	50                   	push   %eax
  80208e:	e8 7d f2 ff ff       	call   801310 <fd2num>
  802093:	83 c4 10             	add    $0x10,%esp
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802098:	f3 0f 1e fb          	endbr32 
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8020a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020a4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8020aa:	e8 00 eb ff ff       	call   800baf <sys_getenvid>
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	ff 75 0c             	pushl  0xc(%ebp)
  8020b5:	ff 75 08             	pushl  0x8(%ebp)
  8020b8:	56                   	push   %esi
  8020b9:	50                   	push   %eax
  8020ba:	68 b0 2a 80 00       	push   $0x802ab0
  8020bf:	e8 4c e1 ff ff       	call   800210 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020c4:	83 c4 18             	add    $0x18,%esp
  8020c7:	53                   	push   %ebx
  8020c8:	ff 75 10             	pushl  0x10(%ebp)
  8020cb:	e8 eb e0 ff ff       	call   8001bb <vcprintf>
	cprintf("\n");
  8020d0:	c7 04 24 89 29 80 00 	movl   $0x802989,(%esp)
  8020d7:	e8 34 e1 ff ff       	call   800210 <cprintf>
  8020dc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020df:	cc                   	int3   
  8020e0:	eb fd                	jmp    8020df <_panic+0x47>

008020e2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020e2:	f3 0f 1e fb          	endbr32 
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020ec:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020f3:	74 0a                	je     8020ff <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  8020ff:	a1 08 40 80 00       	mov    0x804008,%eax
  802104:	8b 40 48             	mov    0x48(%eax),%eax
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	6a 07                	push   $0x7
  80210c:	68 00 f0 bf ee       	push   $0xeebff000
  802111:	50                   	push   %eax
  802112:	e8 eb ea ff ff       	call   800c02 <sys_page_alloc>
		if (r!= 0)
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	75 2f                	jne    80214d <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80211e:	a1 08 40 80 00       	mov    0x804008,%eax
  802123:	8b 40 48             	mov    0x48(%eax),%eax
  802126:	83 ec 08             	sub    $0x8,%esp
  802129:	68 5f 21 80 00       	push   $0x80215f
  80212e:	50                   	push   %eax
  80212f:	e8 95 eb ff ff       	call   800cc9 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	85 c0                	test   %eax,%eax
  802139:	74 ba                	je     8020f5 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  80213b:	50                   	push   %eax
  80213c:	68 d3 2a 80 00       	push   $0x802ad3
  802141:	6a 26                	push   $0x26
  802143:	68 eb 2a 80 00       	push   $0x802aeb
  802148:	e8 4b ff ff ff       	call   802098 <_panic>
			panic("set_pgfault_handler: %e", r);
  80214d:	50                   	push   %eax
  80214e:	68 d3 2a 80 00       	push   $0x802ad3
  802153:	6a 22                	push   $0x22
  802155:	68 eb 2a 80 00       	push   $0x802aeb
  80215a:	e8 39 ff ff ff       	call   802098 <_panic>

0080215f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80215f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802160:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802165:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802167:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  80216a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80216e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802171:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802175:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802179:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80217b:	83 c4 08             	add    $0x8,%esp
	popal
  80217e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80217f:	83 c4 04             	add    $0x4,%esp
	popfl
  802182:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802183:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802184:	c3                   	ret    

00802185 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802185:	f3 0f 1e fb          	endbr32 
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80218f:	89 c2                	mov    %eax,%edx
  802191:	c1 ea 16             	shr    $0x16,%edx
  802194:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80219b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021a0:	f6 c1 01             	test   $0x1,%cl
  8021a3:	74 1c                	je     8021c1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021a5:	c1 e8 0c             	shr    $0xc,%eax
  8021a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021af:	a8 01                	test   $0x1,%al
  8021b1:	74 0e                	je     8021c1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021b3:	c1 e8 0c             	shr    $0xc,%eax
  8021b6:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021bd:	ef 
  8021be:	0f b7 d2             	movzwl %dx,%edx
}
  8021c1:	89 d0                	mov    %edx,%eax
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	66 90                	xchg   %ax,%ax
  8021c7:	66 90                	xchg   %ax,%ax
  8021c9:	66 90                	xchg   %ax,%ax
  8021cb:	66 90                	xchg   %ax,%ax
  8021cd:	66 90                	xchg   %ax,%ax
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021eb:	85 d2                	test   %edx,%edx
  8021ed:	75 19                	jne    802208 <__udivdi3+0x38>
  8021ef:	39 f3                	cmp    %esi,%ebx
  8021f1:	76 4d                	jbe    802240 <__udivdi3+0x70>
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	89 e8                	mov    %ebp,%eax
  8021f7:	89 f2                	mov    %esi,%edx
  8021f9:	f7 f3                	div    %ebx
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	76 14                	jbe    802220 <__udivdi3+0x50>
  80220c:	31 ff                	xor    %edi,%edi
  80220e:	31 c0                	xor    %eax,%eax
  802210:	89 fa                	mov    %edi,%edx
  802212:	83 c4 1c             	add    $0x1c,%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    
  80221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802220:	0f bd fa             	bsr    %edx,%edi
  802223:	83 f7 1f             	xor    $0x1f,%edi
  802226:	75 48                	jne    802270 <__udivdi3+0xa0>
  802228:	39 f2                	cmp    %esi,%edx
  80222a:	72 06                	jb     802232 <__udivdi3+0x62>
  80222c:	31 c0                	xor    %eax,%eax
  80222e:	39 eb                	cmp    %ebp,%ebx
  802230:	77 de                	ja     802210 <__udivdi3+0x40>
  802232:	b8 01 00 00 00       	mov    $0x1,%eax
  802237:	eb d7                	jmp    802210 <__udivdi3+0x40>
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	89 d9                	mov    %ebx,%ecx
  802242:	85 db                	test   %ebx,%ebx
  802244:	75 0b                	jne    802251 <__udivdi3+0x81>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f3                	div    %ebx
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	31 d2                	xor    %edx,%edx
  802253:	89 f0                	mov    %esi,%eax
  802255:	f7 f1                	div    %ecx
  802257:	89 c6                	mov    %eax,%esi
  802259:	89 e8                	mov    %ebp,%eax
  80225b:	89 f7                	mov    %esi,%edi
  80225d:	f7 f1                	div    %ecx
  80225f:	89 fa                	mov    %edi,%edx
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 f9                	mov    %edi,%ecx
  802272:	b8 20 00 00 00       	mov    $0x20,%eax
  802277:	29 f8                	sub    %edi,%eax
  802279:	d3 e2                	shl    %cl,%edx
  80227b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	89 da                	mov    %ebx,%edx
  802283:	d3 ea                	shr    %cl,%edx
  802285:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802289:	09 d1                	or     %edx,%ecx
  80228b:	89 f2                	mov    %esi,%edx
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 f9                	mov    %edi,%ecx
  802293:	d3 e3                	shl    %cl,%ebx
  802295:	89 c1                	mov    %eax,%ecx
  802297:	d3 ea                	shr    %cl,%edx
  802299:	89 f9                	mov    %edi,%ecx
  80229b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80229f:	89 eb                	mov    %ebp,%ebx
  8022a1:	d3 e6                	shl    %cl,%esi
  8022a3:	89 c1                	mov    %eax,%ecx
  8022a5:	d3 eb                	shr    %cl,%ebx
  8022a7:	09 de                	or     %ebx,%esi
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	f7 74 24 08          	divl   0x8(%esp)
  8022af:	89 d6                	mov    %edx,%esi
  8022b1:	89 c3                	mov    %eax,%ebx
  8022b3:	f7 64 24 0c          	mull   0xc(%esp)
  8022b7:	39 d6                	cmp    %edx,%esi
  8022b9:	72 15                	jb     8022d0 <__udivdi3+0x100>
  8022bb:	89 f9                	mov    %edi,%ecx
  8022bd:	d3 e5                	shl    %cl,%ebp
  8022bf:	39 c5                	cmp    %eax,%ebp
  8022c1:	73 04                	jae    8022c7 <__udivdi3+0xf7>
  8022c3:	39 d6                	cmp    %edx,%esi
  8022c5:	74 09                	je     8022d0 <__udivdi3+0x100>
  8022c7:	89 d8                	mov    %ebx,%eax
  8022c9:	31 ff                	xor    %edi,%edi
  8022cb:	e9 40 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022d3:	31 ff                	xor    %edi,%edi
  8022d5:	e9 36 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__umoddi3>:
  8022e0:	f3 0f 1e fb          	endbr32 
  8022e4:	55                   	push   %ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 19                	jne    802318 <__umoddi3+0x38>
  8022ff:	39 df                	cmp    %ebx,%edi
  802301:	76 5d                	jbe    802360 <__umoddi3+0x80>
  802303:	89 f0                	mov    %esi,%eax
  802305:	89 da                	mov    %ebx,%edx
  802307:	f7 f7                	div    %edi
  802309:	89 d0                	mov    %edx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	89 f2                	mov    %esi,%edx
  80231a:	39 d8                	cmp    %ebx,%eax
  80231c:	76 12                	jbe    802330 <__umoddi3+0x50>
  80231e:	89 f0                	mov    %esi,%eax
  802320:	89 da                	mov    %ebx,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	75 50                	jne    802388 <__umoddi3+0xa8>
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	0f 82 e0 00 00 00    	jb     802420 <__umoddi3+0x140>
  802340:	89 d9                	mov    %ebx,%ecx
  802342:	39 f7                	cmp    %esi,%edi
  802344:	0f 86 d6 00 00 00    	jbe    802420 <__umoddi3+0x140>
  80234a:	89 d0                	mov    %edx,%eax
  80234c:	89 ca                	mov    %ecx,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 fd                	mov    %edi,%ebp
  802362:	85 ff                	test   %edi,%edi
  802364:	75 0b                	jne    802371 <__umoddi3+0x91>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f7                	div    %edi
  80236f:	89 c5                	mov    %eax,%ebp
  802371:	89 d8                	mov    %ebx,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f5                	div    %ebp
  802377:	89 f0                	mov    %esi,%eax
  802379:	f7 f5                	div    %ebp
  80237b:	89 d0                	mov    %edx,%eax
  80237d:	31 d2                	xor    %edx,%edx
  80237f:	eb 8c                	jmp    80230d <__umoddi3+0x2d>
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 e9                	mov    %ebp,%ecx
  80238a:	ba 20 00 00 00       	mov    $0x20,%edx
  80238f:	29 ea                	sub    %ebp,%edx
  802391:	d3 e0                	shl    %cl,%eax
  802393:	89 44 24 08          	mov    %eax,0x8(%esp)
  802397:	89 d1                	mov    %edx,%ecx
  802399:	89 f8                	mov    %edi,%eax
  80239b:	d3 e8                	shr    %cl,%eax
  80239d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023a9:	09 c1                	or     %eax,%ecx
  8023ab:	89 d8                	mov    %ebx,%eax
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 e9                	mov    %ebp,%ecx
  8023b3:	d3 e7                	shl    %cl,%edi
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023bf:	d3 e3                	shl    %cl,%ebx
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	89 d1                	mov    %edx,%ecx
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	d3 e8                	shr    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	89 fa                	mov    %edi,%edx
  8023cd:	d3 e6                	shl    %cl,%esi
  8023cf:	09 d8                	or     %ebx,%eax
  8023d1:	f7 74 24 08          	divl   0x8(%esp)
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	89 f3                	mov    %esi,%ebx
  8023d9:	f7 64 24 0c          	mull   0xc(%esp)
  8023dd:	89 c6                	mov    %eax,%esi
  8023df:	89 d7                	mov    %edx,%edi
  8023e1:	39 d1                	cmp    %edx,%ecx
  8023e3:	72 06                	jb     8023eb <__umoddi3+0x10b>
  8023e5:	75 10                	jne    8023f7 <__umoddi3+0x117>
  8023e7:	39 c3                	cmp    %eax,%ebx
  8023e9:	73 0c                	jae    8023f7 <__umoddi3+0x117>
  8023eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023f3:	89 d7                	mov    %edx,%edi
  8023f5:	89 c6                	mov    %eax,%esi
  8023f7:	89 ca                	mov    %ecx,%edx
  8023f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023fe:	29 f3                	sub    %esi,%ebx
  802400:	19 fa                	sbb    %edi,%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	d3 e0                	shl    %cl,%eax
  802406:	89 e9                	mov    %ebp,%ecx
  802408:	d3 eb                	shr    %cl,%ebx
  80240a:	d3 ea                	shr    %cl,%edx
  80240c:	09 d8                	or     %ebx,%eax
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	29 fe                	sub    %edi,%esi
  802422:	19 c3                	sbb    %eax,%ebx
  802424:	89 f2                	mov    %esi,%edx
  802426:	89 d9                	mov    %ebx,%ecx
  802428:	e9 1d ff ff ff       	jmp    80234a <__umoddi3+0x6a>
