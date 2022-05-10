
obj/user/faultio.debug:     formato del fichero elf32-i386


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
  80002c:	e8 54 00 00 00       	call   800085 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
  800033:	89 c1                	mov    %eax,%ecx
  800035:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800037:	89 ca                	mov    %ecx,%edx
  800039:	ee                   	out    %al,(%dx)
}
  80003a:	c3                   	ret    

0080003b <read_eflags>:

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  80003b:	9c                   	pushf  
  80003c:	58                   	pop    %eax
	return eflags;
}
  80003d:	c3                   	ret    

0080003e <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  80003e:	f3 0f 1e fb          	endbr32 
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	83 ec 08             	sub    $0x8,%esp
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  800048:	e8 ee ff ff ff       	call   80003b <read_eflags>
  80004d:	f6 c4 30             	test   $0x30,%ah
  800050:	75 21                	jne    800073 <umain+0x35>
		cprintf("eflags wrong\n");

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));
  800052:	ba f0 00 00 00       	mov    $0xf0,%edx
  800057:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  80005c:	e8 d2 ff ff ff       	call   800033 <outb>

        cprintf("%s: made it here --- bug\n");
  800061:	83 ec 0c             	sub    $0xc,%esp
  800064:	68 4e 1e 80 00       	push   $0x801e4e
  800069:	e8 20 01 00 00       	call   80018e <cprintf>
}
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	c9                   	leave  
  800072:	c3                   	ret    
		cprintf("eflags wrong\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 40 1e 80 00       	push   $0x801e40
  80007b:	e8 0e 01 00 00       	call   80018e <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	eb cd                	jmp    800052 <umain+0x14>

00800085 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800085:	f3 0f 1e fb          	endbr32 
  800089:	55                   	push   %ebp
  80008a:	89 e5                	mov    %esp,%ebp
  80008c:	56                   	push   %esi
  80008d:	53                   	push   %ebx
  80008e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800091:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800094:	e8 94 0a 00 00       	call   800b2d <sys_getenvid>
	if (id >= 0)
  800099:	85 c0                	test   %eax,%eax
  80009b:	78 12                	js     8000af <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80009d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000aa:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000af:	85 db                	test   %ebx,%ebx
  8000b1:	7e 07                	jle    8000ba <libmain+0x35>
		binaryname = argv[0];
  8000b3:	8b 06                	mov    (%esi),%eax
  8000b5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	56                   	push   %esi
  8000be:	53                   	push   %ebx
  8000bf:	e8 7a ff ff ff       	call   80003e <umain>

	// exit gracefully
	exit();
  8000c4:	e8 0a 00 00 00       	call   8000d3 <exit>
}
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d3:	f3 0f 1e fb          	endbr32 
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000dd:	e8 ce 0d 00 00       	call   800eb0 <close_all>
	sys_env_destroy(0);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	6a 00                	push   $0x0
  8000e7:	e8 1b 0a 00 00       	call   800b07 <sys_env_destroy>
}
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f1:	f3 0f 1e fb          	endbr32 
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ff:	8b 13                	mov    (%ebx),%edx
  800101:	8d 42 01             	lea    0x1(%edx),%eax
  800104:	89 03                	mov    %eax,(%ebx)
  800106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800109:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800112:	74 09                	je     80011d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800114:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ff 00 00 00       	push   $0xff
  800125:	8d 43 08             	lea    0x8(%ebx),%eax
  800128:	50                   	push   %eax
  800129:	e8 87 09 00 00       	call   800ab5 <sys_cputs>
		b->idx = 0;
  80012e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	eb db                	jmp    800114 <putch+0x23>

00800139 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800139:	f3 0f 1e fb          	endbr32 
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800146:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014d:	00 00 00 
	b.cnt = 0;
  800150:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800157:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015a:	ff 75 0c             	pushl  0xc(%ebp)
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	68 f1 00 80 00       	push   $0x8000f1
  80016c:	e8 80 01 00 00       	call   8002f1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800171:	83 c4 08             	add    $0x8,%esp
  800174:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800180:	50                   	push   %eax
  800181:	e8 2f 09 00 00       	call   800ab5 <sys_cputs>

	return b.cnt;
}
  800186:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018e:	f3 0f 1e fb          	endbr32 
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800198:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019b:	50                   	push   %eax
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	e8 95 ff ff ff       	call   800139 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 1c             	sub    $0x1c,%esp
  8001af:	89 c7                	mov    %eax,%edi
  8001b1:	89 d6                	mov    %edx,%esi
  8001b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	89 d1                	mov    %edx,%ecx
  8001bb:	89 c2                	mov    %eax,%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001d8:	72 3e                	jb     800218 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	83 eb 01             	sub    $0x1,%ebx
  8001e3:	53                   	push   %ebx
  8001e4:	50                   	push   %eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f4:	e8 e7 19 00 00       	call   801be0 <__udivdi3>
  8001f9:	83 c4 18             	add    $0x18,%esp
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	89 f2                	mov    %esi,%edx
  800200:	89 f8                	mov    %edi,%eax
  800202:	e8 9f ff ff ff       	call   8001a6 <printnum>
  800207:	83 c4 20             	add    $0x20,%esp
  80020a:	eb 13                	jmp    80021f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	56                   	push   %esi
  800210:	ff 75 18             	pushl  0x18(%ebp)
  800213:	ff d7                	call   *%edi
  800215:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800218:	83 eb 01             	sub    $0x1,%ebx
  80021b:	85 db                	test   %ebx,%ebx
  80021d:	7f ed                	jg     80020c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	56                   	push   %esi
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	ff 75 e4             	pushl  -0x1c(%ebp)
  800229:	ff 75 e0             	pushl  -0x20(%ebp)
  80022c:	ff 75 dc             	pushl  -0x24(%ebp)
  80022f:	ff 75 d8             	pushl  -0x28(%ebp)
  800232:	e8 b9 1a 00 00       	call   801cf0 <__umoddi3>
  800237:	83 c4 14             	add    $0x14,%esp
  80023a:	0f be 80 72 1e 80 00 	movsbl 0x801e72(%eax),%eax
  800241:	50                   	push   %eax
  800242:	ff d7                	call   *%edi
}
  800244:	83 c4 10             	add    $0x10,%esp
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    

0080024f <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80024f:	83 fa 01             	cmp    $0x1,%edx
  800252:	7f 13                	jg     800267 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800254:	85 d2                	test   %edx,%edx
  800256:	74 1c                	je     800274 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800258:	8b 10                	mov    (%eax),%edx
  80025a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80025d:	89 08                	mov    %ecx,(%eax)
  80025f:	8b 02                	mov    (%edx),%eax
  800261:	ba 00 00 00 00       	mov    $0x0,%edx
  800266:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800267:	8b 10                	mov    (%eax),%edx
  800269:	8d 4a 08             	lea    0x8(%edx),%ecx
  80026c:	89 08                	mov    %ecx,(%eax)
  80026e:	8b 02                	mov    (%edx),%eax
  800270:	8b 52 04             	mov    0x4(%edx),%edx
  800273:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800274:	8b 10                	mov    (%eax),%edx
  800276:	8d 4a 04             	lea    0x4(%edx),%ecx
  800279:	89 08                	mov    %ecx,(%eax)
  80027b:	8b 02                	mov    (%edx),%eax
  80027d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800282:	c3                   	ret    

00800283 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800283:	83 fa 01             	cmp    $0x1,%edx
  800286:	7f 0f                	jg     800297 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800288:	85 d2                	test   %edx,%edx
  80028a:	74 18                	je     8002a4 <getint+0x21>
		return va_arg(*ap, long);
  80028c:	8b 10                	mov    (%eax),%edx
  80028e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800291:	89 08                	mov    %ecx,(%eax)
  800293:	8b 02                	mov    (%edx),%eax
  800295:	99                   	cltd   
  800296:	c3                   	ret    
		return va_arg(*ap, long long);
  800297:	8b 10                	mov    (%eax),%edx
  800299:	8d 4a 08             	lea    0x8(%edx),%ecx
  80029c:	89 08                	mov    %ecx,(%eax)
  80029e:	8b 02                	mov    (%edx),%eax
  8002a0:	8b 52 04             	mov    0x4(%edx),%edx
  8002a3:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8002a4:	8b 10                	mov    (%eax),%edx
  8002a6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a9:	89 08                	mov    %ecx,(%eax)
  8002ab:	8b 02                	mov    (%edx),%eax
  8002ad:	99                   	cltd   
}
  8002ae:	c3                   	ret    

008002af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002af:	f3 0f 1e fb          	endbr32 
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1f>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	f3 0f 1e fb          	endbr32 
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002da:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002dd:	50                   	push   %eax
  8002de:	ff 75 10             	pushl  0x10(%ebp)
  8002e1:	ff 75 0c             	pushl  0xc(%ebp)
  8002e4:	ff 75 08             	pushl  0x8(%ebp)
  8002e7:	e8 05 00 00 00       	call   8002f1 <vprintfmt>
}
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <vprintfmt>:
{
  8002f1:	f3 0f 1e fb          	endbr32 
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 2c             	sub    $0x2c,%esp
  8002fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800301:	8b 75 0c             	mov    0xc(%ebp),%esi
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	e9 86 02 00 00       	jmp    800592 <vprintfmt+0x2a1>
		padc = ' ';
  80030c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800310:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800317:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80031e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8d 47 01             	lea    0x1(%edi),%eax
  80032d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800330:	0f b6 17             	movzbl (%edi),%edx
  800333:	8d 42 dd             	lea    -0x23(%edx),%eax
  800336:	3c 55                	cmp    $0x55,%al
  800338:	0f 87 df 02 00 00    	ja     80061d <vprintfmt+0x32c>
  80033e:	0f b6 c0             	movzbl %al,%eax
  800341:	3e ff 24 85 c0 1f 80 	notrack jmp *0x801fc0(,%eax,4)
  800348:	00 
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800350:	eb d8                	jmp    80032a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800355:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800359:	eb cf                	jmp    80032a <vprintfmt+0x39>
  80035b:	0f b6 d2             	movzbl %dl,%edx
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800369:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800370:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800373:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800376:	83 f9 09             	cmp    $0x9,%ecx
  800379:	77 52                	ja     8003cd <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80037b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037e:	eb e9                	jmp    800369 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 50 04             	lea    0x4(%eax),%edx
  800386:	89 55 14             	mov    %edx,0x14(%ebp)
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800395:	79 93                	jns    80032a <vprintfmt+0x39>
				width = precision, precision = -1;
  800397:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a4:	eb 84                	jmp    80032a <vprintfmt+0x39>
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	0f 49 d0             	cmovns %eax,%edx
  8003b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 6c ff ff ff       	jmp    80032a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003c8:	e9 5d ff ff ff       	jmp    80032a <vprintfmt+0x39>
  8003cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d3:	eb bc                	jmp    800391 <vprintfmt+0xa0>
			lflag++;
  8003d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003db:	e9 4a ff ff ff       	jmp    80032a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	8d 50 04             	lea    0x4(%eax),%edx
  8003e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	56                   	push   %esi
  8003ed:	ff 30                	pushl  (%eax)
  8003ef:	ff d3                	call   *%ebx
			break;
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	e9 96 01 00 00       	jmp    80058f <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 50 04             	lea    0x4(%eax),%edx
  8003ff:	89 55 14             	mov    %edx,0x14(%ebp)
  800402:	8b 00                	mov    (%eax),%eax
  800404:	99                   	cltd   
  800405:	31 d0                	xor    %edx,%eax
  800407:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800409:	83 f8 0f             	cmp    $0xf,%eax
  80040c:	7f 20                	jg     80042e <vprintfmt+0x13d>
  80040e:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  800415:	85 d2                	test   %edx,%edx
  800417:	74 15                	je     80042e <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800419:	52                   	push   %edx
  80041a:	68 77 22 80 00       	push   $0x802277
  80041f:	56                   	push   %esi
  800420:	53                   	push   %ebx
  800421:	e8 aa fe ff ff       	call   8002d0 <printfmt>
  800426:	83 c4 10             	add    $0x10,%esp
  800429:	e9 61 01 00 00       	jmp    80058f <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80042e:	50                   	push   %eax
  80042f:	68 8a 1e 80 00       	push   $0x801e8a
  800434:	56                   	push   %esi
  800435:	53                   	push   %ebx
  800436:	e8 95 fe ff ff       	call   8002d0 <printfmt>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	e9 4c 01 00 00       	jmp    80058f <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	89 55 14             	mov    %edx,0x14(%ebp)
  80044c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80044e:	85 c9                	test   %ecx,%ecx
  800450:	b8 83 1e 80 00       	mov    $0x801e83,%eax
  800455:	0f 45 c1             	cmovne %ecx,%eax
  800458:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80045b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045f:	7e 06                	jle    800467 <vprintfmt+0x176>
  800461:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800465:	75 0d                	jne    800474 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800467:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80046a:	89 c7                	mov    %eax,%edi
  80046c:	03 45 e0             	add    -0x20(%ebp),%eax
  80046f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800472:	eb 57                	jmp    8004cb <vprintfmt+0x1da>
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 d8             	pushl  -0x28(%ebp)
  80047a:	ff 75 cc             	pushl  -0x34(%ebp)
  80047d:	e8 4f 02 00 00       	call   8006d1 <strnlen>
  800482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800485:	29 c2                	sub    %eax,%edx
  800487:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800491:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800494:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800496:	85 db                	test   %ebx,%ebx
  800498:	7e 10                	jle    8004aa <vprintfmt+0x1b9>
					putch(padc, putdat);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	56                   	push   %esi
  80049e:	57                   	push   %edi
  80049f:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	83 eb 01             	sub    $0x1,%ebx
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	eb ec                	jmp    800496 <vprintfmt+0x1a5>
  8004aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	0f 49 c2             	cmovns %edx,%eax
  8004ba:	29 c2                	sub    %eax,%edx
  8004bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004bf:	eb a6                	jmp    800467 <vprintfmt+0x176>
					putch(ch, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	56                   	push   %esi
  8004c5:	52                   	push   %edx
  8004c6:	ff d3                	call   *%ebx
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ce:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d0:	83 c7 01             	add    $0x1,%edi
  8004d3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d7:	0f be d0             	movsbl %al,%edx
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	74 42                	je     800520 <vprintfmt+0x22f>
  8004de:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e2:	78 06                	js     8004ea <vprintfmt+0x1f9>
  8004e4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e8:	78 1e                	js     800508 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004ee:	74 d1                	je     8004c1 <vprintfmt+0x1d0>
  8004f0:	0f be c0             	movsbl %al,%eax
  8004f3:	83 e8 20             	sub    $0x20,%eax
  8004f6:	83 f8 5e             	cmp    $0x5e,%eax
  8004f9:	76 c6                	jbe    8004c1 <vprintfmt+0x1d0>
					putch('?', putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	56                   	push   %esi
  8004ff:	6a 3f                	push   $0x3f
  800501:	ff d3                	call   *%ebx
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb c3                	jmp    8004cb <vprintfmt+0x1da>
  800508:	89 cf                	mov    %ecx,%edi
  80050a:	eb 0e                	jmp    80051a <vprintfmt+0x229>
				putch(' ', putdat);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	56                   	push   %esi
  800510:	6a 20                	push   $0x20
  800512:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800514:	83 ef 01             	sub    $0x1,%edi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	85 ff                	test   %edi,%edi
  80051c:	7f ee                	jg     80050c <vprintfmt+0x21b>
  80051e:	eb 6f                	jmp    80058f <vprintfmt+0x29e>
  800520:	89 cf                	mov    %ecx,%edi
  800522:	eb f6                	jmp    80051a <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800524:	89 ca                	mov    %ecx,%edx
  800526:	8d 45 14             	lea    0x14(%ebp),%eax
  800529:	e8 55 fd ff ff       	call   800283 <getint>
  80052e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800531:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800534:	85 d2                	test   %edx,%edx
  800536:	78 0b                	js     800543 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800538:	89 d1                	mov    %edx,%ecx
  80053a:	89 c2                	mov    %eax,%edx
			base = 10;
  80053c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800541:	eb 32                	jmp    800575 <vprintfmt+0x284>
				putch('-', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	56                   	push   %esi
  800547:	6a 2d                	push   $0x2d
  800549:	ff d3                	call   *%ebx
				num = -(long long) num;
  80054b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800551:	f7 da                	neg    %edx
  800553:	83 d1 00             	adc    $0x0,%ecx
  800556:	f7 d9                	neg    %ecx
  800558:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800560:	eb 13                	jmp    800575 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800562:	89 ca                	mov    %ecx,%edx
  800564:	8d 45 14             	lea    0x14(%ebp),%eax
  800567:	e8 e3 fc ff ff       	call   80024f <getuint>
  80056c:	89 d1                	mov    %edx,%ecx
  80056e:	89 c2                	mov    %eax,%edx
			base = 10;
  800570:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800575:	83 ec 0c             	sub    $0xc,%esp
  800578:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80057c:	57                   	push   %edi
  80057d:	ff 75 e0             	pushl  -0x20(%ebp)
  800580:	50                   	push   %eax
  800581:	51                   	push   %ecx
  800582:	52                   	push   %edx
  800583:	89 f2                	mov    %esi,%edx
  800585:	89 d8                	mov    %ebx,%eax
  800587:	e8 1a fc ff ff       	call   8001a6 <printnum>
			break;
  80058c:	83 c4 20             	add    $0x20,%esp
{
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800592:	83 c7 01             	add    $0x1,%edi
  800595:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800599:	83 f8 25             	cmp    $0x25,%eax
  80059c:	0f 84 6a fd ff ff    	je     80030c <vprintfmt+0x1b>
			if (ch == '\0')
  8005a2:	85 c0                	test   %eax,%eax
  8005a4:	0f 84 93 00 00 00    	je     80063d <vprintfmt+0x34c>
			putch(ch, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	56                   	push   %esi
  8005ae:	50                   	push   %eax
  8005af:	ff d3                	call   *%ebx
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	eb dc                	jmp    800592 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8005b6:	89 ca                	mov    %ecx,%edx
  8005b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8005bb:	e8 8f fc ff ff       	call   80024f <getuint>
  8005c0:	89 d1                	mov    %edx,%ecx
  8005c2:	89 c2                	mov    %eax,%edx
			base = 8;
  8005c4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8005c9:	eb aa                	jmp    800575 <vprintfmt+0x284>
			putch('0', putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	56                   	push   %esi
  8005cf:	6a 30                	push   $0x30
  8005d1:	ff d3                	call   *%ebx
			putch('x', putdat);
  8005d3:	83 c4 08             	add    $0x8,%esp
  8005d6:	56                   	push   %esi
  8005d7:	6a 78                	push   $0x78
  8005d9:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 50 04             	lea    0x4(%eax),%edx
  8005e1:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8005e4:	8b 10                	mov    (%eax),%edx
  8005e6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005eb:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8005ee:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8005f3:	eb 80                	jmp    800575 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005f5:	89 ca                	mov    %ecx,%edx
  8005f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fa:	e8 50 fc ff ff       	call   80024f <getuint>
  8005ff:	89 d1                	mov    %edx,%ecx
  800601:	89 c2                	mov    %eax,%edx
			base = 16;
  800603:	b8 10 00 00 00       	mov    $0x10,%eax
  800608:	e9 68 ff ff ff       	jmp    800575 <vprintfmt+0x284>
			putch(ch, putdat);
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	56                   	push   %esi
  800611:	6a 25                	push   $0x25
  800613:	ff d3                	call   *%ebx
			break;
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	e9 72 ff ff ff       	jmp    80058f <vprintfmt+0x29e>
			putch('%', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	56                   	push   %esi
  800621:	6a 25                	push   $0x25
  800623:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	89 f8                	mov    %edi,%eax
  80062a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80062e:	74 05                	je     800635 <vprintfmt+0x344>
  800630:	83 e8 01             	sub    $0x1,%eax
  800633:	eb f5                	jmp    80062a <vprintfmt+0x339>
  800635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800638:	e9 52 ff ff ff       	jmp    80058f <vprintfmt+0x29e>
}
  80063d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800640:	5b                   	pop    %ebx
  800641:	5e                   	pop    %esi
  800642:	5f                   	pop    %edi
  800643:	5d                   	pop    %ebp
  800644:	c3                   	ret    

00800645 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800645:	f3 0f 1e fb          	endbr32 
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	83 ec 18             	sub    $0x18,%esp
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800655:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800658:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80065c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80065f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800666:	85 c0                	test   %eax,%eax
  800668:	74 26                	je     800690 <vsnprintf+0x4b>
  80066a:	85 d2                	test   %edx,%edx
  80066c:	7e 22                	jle    800690 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80066e:	ff 75 14             	pushl  0x14(%ebp)
  800671:	ff 75 10             	pushl  0x10(%ebp)
  800674:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800677:	50                   	push   %eax
  800678:	68 af 02 80 00       	push   $0x8002af
  80067d:	e8 6f fc ff ff       	call   8002f1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800685:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068b:	83 c4 10             	add    $0x10,%esp
}
  80068e:	c9                   	leave  
  80068f:	c3                   	ret    
		return -E_INVAL;
  800690:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800695:	eb f7                	jmp    80068e <vsnprintf+0x49>

00800697 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800697:	f3 0f 1e fb          	endbr32 
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006a1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 10             	pushl  0x10(%ebp)
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	ff 75 08             	pushl  0x8(%ebp)
  8006ae:	e8 92 ff ff ff       	call   800645 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006b3:	c9                   	leave  
  8006b4:	c3                   	ret    

008006b5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006b5:	f3 0f 1e fb          	endbr32 
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006c8:	74 05                	je     8006cf <strlen+0x1a>
		n++;
  8006ca:	83 c0 01             	add    $0x1,%eax
  8006cd:	eb f5                	jmp    8006c4 <strlen+0xf>
	return n;
}
  8006cf:	5d                   	pop    %ebp
  8006d0:	c3                   	ret    

008006d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006d1:	f3 0f 1e fb          	endbr32 
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006db:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	39 d0                	cmp    %edx,%eax
  8006e5:	74 0d                	je     8006f4 <strnlen+0x23>
  8006e7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8006eb:	74 05                	je     8006f2 <strnlen+0x21>
		n++;
  8006ed:	83 c0 01             	add    $0x1,%eax
  8006f0:	eb f1                	jmp    8006e3 <strnlen+0x12>
  8006f2:	89 c2                	mov    %eax,%edx
	return n;
}
  8006f4:	89 d0                	mov    %edx,%eax
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006f8:	f3 0f 1e fb          	endbr32 
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	53                   	push   %ebx
  800700:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800703:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800706:	b8 00 00 00 00       	mov    $0x0,%eax
  80070b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80070f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800712:	83 c0 01             	add    $0x1,%eax
  800715:	84 d2                	test   %dl,%dl
  800717:	75 f2                	jne    80070b <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800719:	89 c8                	mov    %ecx,%eax
  80071b:	5b                   	pop    %ebx
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80071e:	f3 0f 1e fb          	endbr32 
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	53                   	push   %ebx
  800726:	83 ec 10             	sub    $0x10,%esp
  800729:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80072c:	53                   	push   %ebx
  80072d:	e8 83 ff ff ff       	call   8006b5 <strlen>
  800732:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	01 d8                	add    %ebx,%eax
  80073a:	50                   	push   %eax
  80073b:	e8 b8 ff ff ff       	call   8006f8 <strcpy>
	return dst;
}
  800740:	89 d8                	mov    %ebx,%eax
  800742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800747:	f3 0f 1e fb          	endbr32 
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	8b 75 08             	mov    0x8(%ebp),%esi
  800753:	8b 55 0c             	mov    0xc(%ebp),%edx
  800756:	89 f3                	mov    %esi,%ebx
  800758:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80075b:	89 f0                	mov    %esi,%eax
  80075d:	39 d8                	cmp    %ebx,%eax
  80075f:	74 11                	je     800772 <strncpy+0x2b>
		*dst++ = *src;
  800761:	83 c0 01             	add    $0x1,%eax
  800764:	0f b6 0a             	movzbl (%edx),%ecx
  800767:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80076a:	80 f9 01             	cmp    $0x1,%cl
  80076d:	83 da ff             	sbb    $0xffffffff,%edx
  800770:	eb eb                	jmp    80075d <strncpy+0x16>
	}
	return ret;
}
  800772:	89 f0                	mov    %esi,%eax
  800774:	5b                   	pop    %ebx
  800775:	5e                   	pop    %esi
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800778:	f3 0f 1e fb          	endbr32 
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	56                   	push   %esi
  800780:	53                   	push   %ebx
  800781:	8b 75 08             	mov    0x8(%ebp),%esi
  800784:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800787:	8b 55 10             	mov    0x10(%ebp),%edx
  80078a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80078c:	85 d2                	test   %edx,%edx
  80078e:	74 21                	je     8007b1 <strlcpy+0x39>
  800790:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800794:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800796:	39 c2                	cmp    %eax,%edx
  800798:	74 14                	je     8007ae <strlcpy+0x36>
  80079a:	0f b6 19             	movzbl (%ecx),%ebx
  80079d:	84 db                	test   %bl,%bl
  80079f:	74 0b                	je     8007ac <strlcpy+0x34>
			*dst++ = *src++;
  8007a1:	83 c1 01             	add    $0x1,%ecx
  8007a4:	83 c2 01             	add    $0x1,%edx
  8007a7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007aa:	eb ea                	jmp    800796 <strlcpy+0x1e>
  8007ac:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8007ae:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007b1:	29 f0                	sub    %esi,%eax
}
  8007b3:	5b                   	pop    %ebx
  8007b4:	5e                   	pop    %esi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007b7:	f3 0f 1e fb          	endbr32 
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007c4:	0f b6 01             	movzbl (%ecx),%eax
  8007c7:	84 c0                	test   %al,%al
  8007c9:	74 0c                	je     8007d7 <strcmp+0x20>
  8007cb:	3a 02                	cmp    (%edx),%al
  8007cd:	75 08                	jne    8007d7 <strcmp+0x20>
		p++, q++;
  8007cf:	83 c1 01             	add    $0x1,%ecx
  8007d2:	83 c2 01             	add    $0x1,%edx
  8007d5:	eb ed                	jmp    8007c4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007d7:	0f b6 c0             	movzbl %al,%eax
  8007da:	0f b6 12             	movzbl (%edx),%edx
  8007dd:	29 d0                	sub    %edx,%eax
}
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007e1:	f3 0f 1e fb          	endbr32 
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ef:	89 c3                	mov    %eax,%ebx
  8007f1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007f4:	eb 06                	jmp    8007fc <strncmp+0x1b>
		n--, p++, q++;
  8007f6:	83 c0 01             	add    $0x1,%eax
  8007f9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8007fc:	39 d8                	cmp    %ebx,%eax
  8007fe:	74 16                	je     800816 <strncmp+0x35>
  800800:	0f b6 08             	movzbl (%eax),%ecx
  800803:	84 c9                	test   %cl,%cl
  800805:	74 04                	je     80080b <strncmp+0x2a>
  800807:	3a 0a                	cmp    (%edx),%cl
  800809:	74 eb                	je     8007f6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80080b:	0f b6 00             	movzbl (%eax),%eax
  80080e:	0f b6 12             	movzbl (%edx),%edx
  800811:	29 d0                	sub    %edx,%eax
}
  800813:	5b                   	pop    %ebx
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    
		return 0;
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	eb f6                	jmp    800813 <strncmp+0x32>

0080081d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80081d:	f3 0f 1e fb          	endbr32 
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80082b:	0f b6 10             	movzbl (%eax),%edx
  80082e:	84 d2                	test   %dl,%dl
  800830:	74 09                	je     80083b <strchr+0x1e>
		if (*s == c)
  800832:	38 ca                	cmp    %cl,%dl
  800834:	74 0a                	je     800840 <strchr+0x23>
	for (; *s; s++)
  800836:	83 c0 01             	add    $0x1,%eax
  800839:	eb f0                	jmp    80082b <strchr+0xe>
			return (char *) s;
	return 0;
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800842:	f3 0f 1e fb          	endbr32 
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800850:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800853:	38 ca                	cmp    %cl,%dl
  800855:	74 09                	je     800860 <strfind+0x1e>
  800857:	84 d2                	test   %dl,%dl
  800859:	74 05                	je     800860 <strfind+0x1e>
	for (; *s; s++)
  80085b:	83 c0 01             	add    $0x1,%eax
  80085e:	eb f0                	jmp    800850 <strfind+0xe>
			break;
	return (char *) s;
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800862:	f3 0f 1e fb          	endbr32 
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	57                   	push   %edi
  80086a:	56                   	push   %esi
  80086b:	53                   	push   %ebx
  80086c:	8b 55 08             	mov    0x8(%ebp),%edx
  80086f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800872:	85 c9                	test   %ecx,%ecx
  800874:	74 33                	je     8008a9 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800876:	89 d0                	mov    %edx,%eax
  800878:	09 c8                	or     %ecx,%eax
  80087a:	a8 03                	test   $0x3,%al
  80087c:	75 23                	jne    8008a1 <memset+0x3f>
		c &= 0xFF;
  80087e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800882:	89 d8                	mov    %ebx,%eax
  800884:	c1 e0 08             	shl    $0x8,%eax
  800887:	89 df                	mov    %ebx,%edi
  800889:	c1 e7 18             	shl    $0x18,%edi
  80088c:	89 de                	mov    %ebx,%esi
  80088e:	c1 e6 10             	shl    $0x10,%esi
  800891:	09 f7                	or     %esi,%edi
  800893:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800895:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800898:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80089a:	89 d7                	mov    %edx,%edi
  80089c:	fc                   	cld    
  80089d:	f3 ab                	rep stos %eax,%es:(%edi)
  80089f:	eb 08                	jmp    8008a9 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a1:	89 d7                	mov    %edx,%edi
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	fc                   	cld    
  8008a7:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008a9:	89 d0                	mov    %edx,%eax
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008b0:	f3 0f 1e fb          	endbr32 
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	57                   	push   %edi
  8008b8:	56                   	push   %esi
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008c2:	39 c6                	cmp    %eax,%esi
  8008c4:	73 32                	jae    8008f8 <memmove+0x48>
  8008c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	76 2b                	jbe    8008f8 <memmove+0x48>
		s += n;
		d += n;
  8008cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d0:	89 fe                	mov    %edi,%esi
  8008d2:	09 ce                	or     %ecx,%esi
  8008d4:	09 d6                	or     %edx,%esi
  8008d6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008dc:	75 0e                	jne    8008ec <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008de:	83 ef 04             	sub    $0x4,%edi
  8008e1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008e4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008e7:	fd                   	std    
  8008e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008ea:	eb 09                	jmp    8008f5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008ec:	83 ef 01             	sub    $0x1,%edi
  8008ef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008f2:	fd                   	std    
  8008f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008f5:	fc                   	cld    
  8008f6:	eb 1a                	jmp    800912 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f8:	89 c2                	mov    %eax,%edx
  8008fa:	09 ca                	or     %ecx,%edx
  8008fc:	09 f2                	or     %esi,%edx
  8008fe:	f6 c2 03             	test   $0x3,%dl
  800901:	75 0a                	jne    80090d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800903:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800906:	89 c7                	mov    %eax,%edi
  800908:	fc                   	cld    
  800909:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090b:	eb 05                	jmp    800912 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80090d:	89 c7                	mov    %eax,%edi
  80090f:	fc                   	cld    
  800910:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800912:	5e                   	pop    %esi
  800913:	5f                   	pop    %edi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800920:	ff 75 10             	pushl  0x10(%ebp)
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 82 ff ff ff       	call   8008b0 <memmove>
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800930:	f3 0f 1e fb          	endbr32 
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	56                   	push   %esi
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093f:	89 c6                	mov    %eax,%esi
  800941:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800944:	39 f0                	cmp    %esi,%eax
  800946:	74 1c                	je     800964 <memcmp+0x34>
		if (*s1 != *s2)
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	0f b6 1a             	movzbl (%edx),%ebx
  80094e:	38 d9                	cmp    %bl,%cl
  800950:	75 08                	jne    80095a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	83 c2 01             	add    $0x1,%edx
  800958:	eb ea                	jmp    800944 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80095a:	0f b6 c1             	movzbl %cl,%eax
  80095d:	0f b6 db             	movzbl %bl,%ebx
  800960:	29 d8                	sub    %ebx,%eax
  800962:	eb 05                	jmp    800969 <memcmp+0x39>
	}

	return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800969:	5b                   	pop    %ebx
  80096a:	5e                   	pop    %esi
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80096d:	f3 0f 1e fb          	endbr32 
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80097f:	39 d0                	cmp    %edx,%eax
  800981:	73 09                	jae    80098c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800983:	38 08                	cmp    %cl,(%eax)
  800985:	74 05                	je     80098c <memfind+0x1f>
	for (; s < ends; s++)
  800987:	83 c0 01             	add    $0x1,%eax
  80098a:	eb f3                	jmp    80097f <memfind+0x12>
			break;
	return (void *) s;
}
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80098e:	f3 0f 1e fb          	endbr32 
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	57                   	push   %edi
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80099e:	eb 03                	jmp    8009a3 <strtol+0x15>
		s++;
  8009a0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009a3:	0f b6 01             	movzbl (%ecx),%eax
  8009a6:	3c 20                	cmp    $0x20,%al
  8009a8:	74 f6                	je     8009a0 <strtol+0x12>
  8009aa:	3c 09                	cmp    $0x9,%al
  8009ac:	74 f2                	je     8009a0 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8009ae:	3c 2b                	cmp    $0x2b,%al
  8009b0:	74 2a                	je     8009dc <strtol+0x4e>
	int neg = 0;
  8009b2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009b7:	3c 2d                	cmp    $0x2d,%al
  8009b9:	74 2b                	je     8009e6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009bb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009c1:	75 0f                	jne    8009d2 <strtol+0x44>
  8009c3:	80 39 30             	cmpb   $0x30,(%ecx)
  8009c6:	74 28                	je     8009f0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009c8:	85 db                	test   %ebx,%ebx
  8009ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009cf:	0f 44 d8             	cmove  %eax,%ebx
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009da:	eb 46                	jmp    800a22 <strtol+0x94>
		s++;
  8009dc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009df:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e4:	eb d5                	jmp    8009bb <strtol+0x2d>
		s++, neg = 1;
  8009e6:	83 c1 01             	add    $0x1,%ecx
  8009e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ee:	eb cb                	jmp    8009bb <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009f4:	74 0e                	je     800a04 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8009f6:	85 db                	test   %ebx,%ebx
  8009f8:	75 d8                	jne    8009d2 <strtol+0x44>
		s++, base = 8;
  8009fa:	83 c1 01             	add    $0x1,%ecx
  8009fd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a02:	eb ce                	jmp    8009d2 <strtol+0x44>
		s += 2, base = 16;
  800a04:	83 c1 02             	add    $0x2,%ecx
  800a07:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a0c:	eb c4                	jmp    8009d2 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a0e:	0f be d2             	movsbl %dl,%edx
  800a11:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a17:	7d 3a                	jge    800a53 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a22:	0f b6 11             	movzbl (%ecx),%edx
  800a25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a28:	89 f3                	mov    %esi,%ebx
  800a2a:	80 fb 09             	cmp    $0x9,%bl
  800a2d:	76 df                	jbe    800a0e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a2f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a32:	89 f3                	mov    %esi,%ebx
  800a34:	80 fb 19             	cmp    $0x19,%bl
  800a37:	77 08                	ja     800a41 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a39:	0f be d2             	movsbl %dl,%edx
  800a3c:	83 ea 57             	sub    $0x57,%edx
  800a3f:	eb d3                	jmp    800a14 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800a41:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a44:	89 f3                	mov    %esi,%ebx
  800a46:	80 fb 19             	cmp    $0x19,%bl
  800a49:	77 08                	ja     800a53 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a4b:	0f be d2             	movsbl %dl,%edx
  800a4e:	83 ea 37             	sub    $0x37,%edx
  800a51:	eb c1                	jmp    800a14 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a57:	74 05                	je     800a5e <strtol+0xd0>
		*endptr = (char *) s;
  800a59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a5e:	89 c2                	mov    %eax,%edx
  800a60:	f7 da                	neg    %edx
  800a62:	85 ff                	test   %edi,%edi
  800a64:	0f 45 c2             	cmovne %edx,%eax
}
  800a67:	5b                   	pop    %ebx
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	83 ec 1c             	sub    $0x1c,%esp
  800a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a78:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7b:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a83:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a86:	8b 75 14             	mov    0x14(%ebp),%esi
  800a89:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8f:	74 04                	je     800a95 <syscall+0x29>
  800a91:	85 c0                	test   %eax,%eax
  800a93:	7f 08                	jg     800a9d <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5f                   	pop    %edi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800a9d:	83 ec 0c             	sub    $0xc,%esp
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 e0             	pushl  -0x20(%ebp)
  800aa4:	68 7f 21 80 00       	push   $0x80217f
  800aa9:	6a 23                	push   $0x23
  800aab:	68 9c 21 80 00       	push   $0x80219c
  800ab0:	e8 90 0f 00 00       	call   801a45 <_panic>

00800ab5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ab5:	f3 0f 1e fb          	endbr32 
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800abf:	6a 00                	push   $0x0
  800ac1:	6a 00                	push   $0x0
  800ac3:	6a 00                	push   $0x0
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad5:	e8 92 ff ff ff       	call   800a6c <syscall>
}
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <sys_cgetc>:

int
sys_cgetc(void)
{
  800adf:	f3 0f 1e fb          	endbr32 
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ae9:	6a 00                	push   $0x0
  800aeb:	6a 00                	push   $0x0
  800aed:	6a 00                	push   $0x0
  800aef:	6a 00                	push   $0x0
  800af1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af6:	ba 00 00 00 00       	mov    $0x0,%edx
  800afb:	b8 01 00 00 00       	mov    $0x1,%eax
  800b00:	e8 67 ff ff ff       	call   800a6c <syscall>
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b07:	f3 0f 1e fb          	endbr32 
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b11:	6a 00                	push   $0x0
  800b13:	6a 00                	push   $0x0
  800b15:	6a 00                	push   $0x0
  800b17:	6a 00                	push   $0x0
  800b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800b21:	b8 03 00 00 00       	mov    $0x3,%eax
  800b26:	e8 41 ff ff ff       	call   800a6c <syscall>
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b2d:	f3 0f 1e fb          	endbr32 
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b37:	6a 00                	push   $0x0
  800b39:	6a 00                	push   $0x0
  800b3b:	6a 00                	push   $0x0
  800b3d:	6a 00                	push   $0x0
  800b3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 02 00 00 00       	mov    $0x2,%eax
  800b4e:	e8 19 ff ff ff       	call   800a6c <syscall>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <sys_yield>:

void
sys_yield(void)
{
  800b55:	f3 0f 1e fb          	endbr32 
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b5f:	6a 00                	push   $0x0
  800b61:	6a 00                	push   $0x0
  800b63:	6a 00                	push   $0x0
  800b65:	6a 00                	push   $0x0
  800b67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b76:	e8 f1 fe ff ff       	call   800a6c <syscall>
}
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b80:	f3 0f 1e fb          	endbr32 
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b8a:	6a 00                	push   $0x0
  800b8c:	6a 00                	push   $0x0
  800b8e:	ff 75 10             	pushl  0x10(%ebp)
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b97:	ba 01 00 00 00       	mov    $0x1,%edx
  800b9c:	b8 04 00 00 00       	mov    $0x4,%eax
  800ba1:	e8 c6 fe ff ff       	call   800a6c <syscall>
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ba8:	f3 0f 1e fb          	endbr32 
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bb2:	ff 75 18             	pushl  0x18(%ebp)
  800bb5:	ff 75 14             	pushl  0x14(%ebp)
  800bb8:	ff 75 10             	pushl  0x10(%ebp)
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc1:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc6:	b8 05 00 00 00       	mov    $0x5,%eax
  800bcb:	e8 9c fe ff ff       	call   800a6c <syscall>
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bd2:	f3 0f 1e fb          	endbr32 
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bdc:	6a 00                	push   $0x0
  800bde:	6a 00                	push   $0x0
  800be0:	6a 00                	push   $0x0
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be8:	ba 01 00 00 00       	mov    $0x1,%edx
  800bed:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf2:	e8 75 fe ff ff       	call   800a6c <syscall>
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bf9:	f3 0f 1e fb          	endbr32 
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c03:	6a 00                	push   $0x0
  800c05:	6a 00                	push   $0x0
  800c07:	6a 00                	push   $0x0
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c14:	b8 08 00 00 00       	mov    $0x8,%eax
  800c19:	e8 4e fe ff ff       	call   800a6c <syscall>
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c2a:	6a 00                	push   $0x0
  800c2c:	6a 00                	push   $0x0
  800c2e:	6a 00                	push   $0x0
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c36:	ba 01 00 00 00       	mov    $0x1,%edx
  800c3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800c40:	e8 27 fe ff ff       	call   800a6c <syscall>
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c47:	f3 0f 1e fb          	endbr32 
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c51:	6a 00                	push   $0x0
  800c53:	6a 00                	push   $0x0
  800c55:	6a 00                	push   $0x0
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c67:	e8 00 fe ff ff       	call   800a6c <syscall>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c78:	6a 00                	push   $0x0
  800c7a:	ff 75 14             	pushl  0x14(%ebp)
  800c7d:	ff 75 10             	pushl  0x10(%ebp)
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c86:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c90:	e8 d7 fd ff ff       	call   800a6c <syscall>
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ca1:	6a 00                	push   $0x0
  800ca3:	6a 00                	push   $0x0
  800ca5:	6a 00                	push   $0x0
  800ca7:	6a 00                	push   $0x0
  800ca9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cac:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cb6:	e8 b1 fd ff ff       	call   800a6c <syscall>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800cbd:	f3 0f 1e fb          	endbr32 
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	05 00 00 00 30       	add    $0x30000000,%eax
  800ccc:	c1 e8 0c             	shr    $0xc,%eax
}
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800cd1:	f3 0f 1e fb          	endbr32 
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	e8 da ff ff ff       	call   800cbd <fd2num>
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	c1 e0 0c             	shl    $0xc,%eax
  800ce9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800cfc:	89 c2                	mov    %eax,%edx
  800cfe:	c1 ea 16             	shr    $0x16,%edx
  800d01:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d08:	f6 c2 01             	test   $0x1,%dl
  800d0b:	74 2d                	je     800d3a <fd_alloc+0x4a>
  800d0d:	89 c2                	mov    %eax,%edx
  800d0f:	c1 ea 0c             	shr    $0xc,%edx
  800d12:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d19:	f6 c2 01             	test   $0x1,%dl
  800d1c:	74 1c                	je     800d3a <fd_alloc+0x4a>
  800d1e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d23:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d28:	75 d2                	jne    800cfc <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800d33:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d38:	eb 0a                	jmp    800d44 <fd_alloc+0x54>
			*fd_store = fd;
  800d3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d3d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d50:	83 f8 1f             	cmp    $0x1f,%eax
  800d53:	77 30                	ja     800d85 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d55:	c1 e0 0c             	shl    $0xc,%eax
  800d58:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d5d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800d63:	f6 c2 01             	test   $0x1,%dl
  800d66:	74 24                	je     800d8c <fd_lookup+0x46>
  800d68:	89 c2                	mov    %eax,%edx
  800d6a:	c1 ea 0c             	shr    $0xc,%edx
  800d6d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d74:	f6 c2 01             	test   $0x1,%dl
  800d77:	74 1a                	je     800d93 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	89 02                	mov    %eax,(%edx)
	return 0;
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    
		return -E_INVAL;
  800d85:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d8a:	eb f7                	jmp    800d83 <fd_lookup+0x3d>
		return -E_INVAL;
  800d8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d91:	eb f0                	jmp    800d83 <fd_lookup+0x3d>
  800d93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d98:	eb e9                	jmp    800d83 <fd_lookup+0x3d>

00800d9a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d9a:	f3 0f 1e fb          	endbr32 
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da7:	ba 28 22 80 00       	mov    $0x802228,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800dac:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800db1:	39 08                	cmp    %ecx,(%eax)
  800db3:	74 33                	je     800de8 <dev_lookup+0x4e>
  800db5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800db8:	8b 02                	mov    (%edx),%eax
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	75 f3                	jne    800db1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800dbe:	a1 04 40 80 00       	mov    0x804004,%eax
  800dc3:	8b 40 48             	mov    0x48(%eax),%eax
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	51                   	push   %ecx
  800dca:	50                   	push   %eax
  800dcb:	68 ac 21 80 00       	push   $0x8021ac
  800dd0:	e8 b9 f3 ff ff       	call   80018e <cprintf>
	*dev = 0;
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    
			*dev = devtab[i];
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ded:	b8 00 00 00 00       	mov    $0x0,%eax
  800df2:	eb f2                	jmp    800de6 <dev_lookup+0x4c>

00800df4 <fd_close>:
{
  800df4:	f3 0f 1e fb          	endbr32 
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 28             	sub    $0x28,%esp
  800e01:	8b 75 08             	mov    0x8(%ebp),%esi
  800e04:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e07:	56                   	push   %esi
  800e08:	e8 b0 fe ff ff       	call   800cbd <fd2num>
  800e0d:	83 c4 08             	add    $0x8,%esp
  800e10:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800e13:	52                   	push   %edx
  800e14:	50                   	push   %eax
  800e15:	e8 2c ff ff ff       	call   800d46 <fd_lookup>
  800e1a:	89 c3                	mov    %eax,%ebx
  800e1c:	83 c4 10             	add    $0x10,%esp
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	78 05                	js     800e28 <fd_close+0x34>
	    || fd != fd2)
  800e23:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e26:	74 16                	je     800e3e <fd_close+0x4a>
		return (must_exist ? r : 0);
  800e28:	89 f8                	mov    %edi,%eax
  800e2a:	84 c0                	test   %al,%al
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	0f 44 d8             	cmove  %eax,%ebx
}
  800e34:	89 d8                	mov    %ebx,%eax
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e3e:	83 ec 08             	sub    $0x8,%esp
  800e41:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e44:	50                   	push   %eax
  800e45:	ff 36                	pushl  (%esi)
  800e47:	e8 4e ff ff ff       	call   800d9a <dev_lookup>
  800e4c:	89 c3                	mov    %eax,%ebx
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	85 c0                	test   %eax,%eax
  800e53:	78 1a                	js     800e6f <fd_close+0x7b>
		if (dev->dev_close)
  800e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e58:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	74 0b                	je     800e6f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	56                   	push   %esi
  800e68:	ff d0                	call   *%eax
  800e6a:	89 c3                	mov    %eax,%ebx
  800e6c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	56                   	push   %esi
  800e73:	6a 00                	push   $0x0
  800e75:	e8 58 fd ff ff       	call   800bd2 <sys_page_unmap>
	return r;
  800e7a:	83 c4 10             	add    $0x10,%esp
  800e7d:	eb b5                	jmp    800e34 <fd_close+0x40>

00800e7f <close>:

int
close(int fdnum)
{
  800e7f:	f3 0f 1e fb          	endbr32 
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e8c:	50                   	push   %eax
  800e8d:	ff 75 08             	pushl  0x8(%ebp)
  800e90:	e8 b1 fe ff ff       	call   800d46 <fd_lookup>
  800e95:	83 c4 10             	add    $0x10,%esp
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	79 02                	jns    800e9e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    
		return fd_close(fd, 1);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	6a 01                	push   $0x1
  800ea3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea6:	e8 49 ff ff ff       	call   800df4 <fd_close>
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	eb ec                	jmp    800e9c <close+0x1d>

00800eb0 <close_all>:

void
close_all(void)
{
  800eb0:	f3 0f 1e fb          	endbr32 
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ebb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	53                   	push   %ebx
  800ec4:	e8 b6 ff ff ff       	call   800e7f <close>
	for (i = 0; i < MAXFD; i++)
  800ec9:	83 c3 01             	add    $0x1,%ebx
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	83 fb 20             	cmp    $0x20,%ebx
  800ed2:	75 ec                	jne    800ec0 <close_all+0x10>
}
  800ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ed9:	f3 0f 1e fb          	endbr32 
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ee6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ee9:	50                   	push   %eax
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 54 fe ff ff       	call   800d46 <fd_lookup>
  800ef2:	89 c3                	mov    %eax,%ebx
  800ef4:	83 c4 10             	add    $0x10,%esp
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	0f 88 81 00 00 00    	js     800f80 <dup+0xa7>
		return r;
	close(newfdnum);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff 75 0c             	pushl  0xc(%ebp)
  800f05:	e8 75 ff ff ff       	call   800e7f <close>

	newfd = INDEX2FD(newfdnum);
  800f0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f0d:	c1 e6 0c             	shl    $0xc,%esi
  800f10:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f16:	83 c4 04             	add    $0x4,%esp
  800f19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1c:	e8 b0 fd ff ff       	call   800cd1 <fd2data>
  800f21:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f23:	89 34 24             	mov    %esi,(%esp)
  800f26:	e8 a6 fd ff ff       	call   800cd1 <fd2data>
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f30:	89 d8                	mov    %ebx,%eax
  800f32:	c1 e8 16             	shr    $0x16,%eax
  800f35:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f3c:	a8 01                	test   $0x1,%al
  800f3e:	74 11                	je     800f51 <dup+0x78>
  800f40:	89 d8                	mov    %ebx,%eax
  800f42:	c1 e8 0c             	shr    $0xc,%eax
  800f45:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f4c:	f6 c2 01             	test   $0x1,%dl
  800f4f:	75 39                	jne    800f8a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f54:	89 d0                	mov    %edx,%eax
  800f56:	c1 e8 0c             	shr    $0xc,%eax
  800f59:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f60:	83 ec 0c             	sub    $0xc,%esp
  800f63:	25 07 0e 00 00       	and    $0xe07,%eax
  800f68:	50                   	push   %eax
  800f69:	56                   	push   %esi
  800f6a:	6a 00                	push   $0x0
  800f6c:	52                   	push   %edx
  800f6d:	6a 00                	push   $0x0
  800f6f:	e8 34 fc ff ff       	call   800ba8 <sys_page_map>
  800f74:	89 c3                	mov    %eax,%ebx
  800f76:	83 c4 20             	add    $0x20,%esp
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	78 31                	js     800fae <dup+0xd5>
		goto err;

	return newfdnum;
  800f7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800f80:	89 d8                	mov    %ebx,%eax
  800f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800f8a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	25 07 0e 00 00       	and    $0xe07,%eax
  800f99:	50                   	push   %eax
  800f9a:	57                   	push   %edi
  800f9b:	6a 00                	push   $0x0
  800f9d:	53                   	push   %ebx
  800f9e:	6a 00                	push   $0x0
  800fa0:	e8 03 fc ff ff       	call   800ba8 <sys_page_map>
  800fa5:	89 c3                	mov    %eax,%ebx
  800fa7:	83 c4 20             	add    $0x20,%esp
  800faa:	85 c0                	test   %eax,%eax
  800fac:	79 a3                	jns    800f51 <dup+0x78>
	sys_page_unmap(0, newfd);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	56                   	push   %esi
  800fb2:	6a 00                	push   $0x0
  800fb4:	e8 19 fc ff ff       	call   800bd2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fb9:	83 c4 08             	add    $0x8,%esp
  800fbc:	57                   	push   %edi
  800fbd:	6a 00                	push   $0x0
  800fbf:	e8 0e fc ff ff       	call   800bd2 <sys_page_unmap>
	return r;
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	eb b7                	jmp    800f80 <dup+0xa7>

00800fc9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800fc9:	f3 0f 1e fb          	endbr32 
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 1c             	sub    $0x1c,%esp
  800fd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fda:	50                   	push   %eax
  800fdb:	53                   	push   %ebx
  800fdc:	e8 65 fd ff ff       	call   800d46 <fd_lookup>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	78 3f                	js     801027 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	ff 30                	pushl  (%eax)
  800ff4:	e8 a1 fd ff ff       	call   800d9a <dev_lookup>
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	78 27                	js     801027 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801000:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801003:	8b 42 08             	mov    0x8(%edx),%eax
  801006:	83 e0 03             	and    $0x3,%eax
  801009:	83 f8 01             	cmp    $0x1,%eax
  80100c:	74 1e                	je     80102c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801011:	8b 40 08             	mov    0x8(%eax),%eax
  801014:	85 c0                	test   %eax,%eax
  801016:	74 35                	je     80104d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	ff 75 10             	pushl  0x10(%ebp)
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	52                   	push   %edx
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
}
  801027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80102c:	a1 04 40 80 00       	mov    0x804004,%eax
  801031:	8b 40 48             	mov    0x48(%eax),%eax
  801034:	83 ec 04             	sub    $0x4,%esp
  801037:	53                   	push   %ebx
  801038:	50                   	push   %eax
  801039:	68 ed 21 80 00       	push   $0x8021ed
  80103e:	e8 4b f1 ff ff       	call   80018e <cprintf>
		return -E_INVAL;
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104b:	eb da                	jmp    801027 <read+0x5e>
		return -E_NOT_SUPP;
  80104d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801052:	eb d3                	jmp    801027 <read+0x5e>

00801054 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801054:	f3 0f 1e fb          	endbr32 
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	57                   	push   %edi
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	8b 7d 08             	mov    0x8(%ebp),%edi
  801064:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801067:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106c:	eb 02                	jmp    801070 <readn+0x1c>
  80106e:	01 c3                	add    %eax,%ebx
  801070:	39 f3                	cmp    %esi,%ebx
  801072:	73 21                	jae    801095 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801074:	83 ec 04             	sub    $0x4,%esp
  801077:	89 f0                	mov    %esi,%eax
  801079:	29 d8                	sub    %ebx,%eax
  80107b:	50                   	push   %eax
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	03 45 0c             	add    0xc(%ebp),%eax
  801081:	50                   	push   %eax
  801082:	57                   	push   %edi
  801083:	e8 41 ff ff ff       	call   800fc9 <read>
		if (m < 0)
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	78 04                	js     801093 <readn+0x3f>
			return m;
		if (m == 0)
  80108f:	75 dd                	jne    80106e <readn+0x1a>
  801091:	eb 02                	jmp    801095 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801093:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801095:	89 d8                	mov    %ebx,%eax
  801097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80109f:	f3 0f 1e fb          	endbr32 
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 1c             	sub    $0x1c,%esp
  8010aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010b0:	50                   	push   %eax
  8010b1:	53                   	push   %ebx
  8010b2:	e8 8f fc ff ff       	call   800d46 <fd_lookup>
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	78 3a                	js     8010f8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c8:	ff 30                	pushl  (%eax)
  8010ca:	e8 cb fc ff ff       	call   800d9a <dev_lookup>
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	78 22                	js     8010f8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010dd:	74 1e                	je     8010fd <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8010df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8010e5:	85 d2                	test   %edx,%edx
  8010e7:	74 35                	je     80111e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	ff 75 10             	pushl  0x10(%ebp)
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff d2                	call   *%edx
  8010f5:	83 c4 10             	add    $0x10,%esp
}
  8010f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8010fd:	a1 04 40 80 00       	mov    0x804004,%eax
  801102:	8b 40 48             	mov    0x48(%eax),%eax
  801105:	83 ec 04             	sub    $0x4,%esp
  801108:	53                   	push   %ebx
  801109:	50                   	push   %eax
  80110a:	68 09 22 80 00       	push   $0x802209
  80110f:	e8 7a f0 ff ff       	call   80018e <cprintf>
		return -E_INVAL;
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111c:	eb da                	jmp    8010f8 <write+0x59>
		return -E_NOT_SUPP;
  80111e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801123:	eb d3                	jmp    8010f8 <write+0x59>

00801125 <seek>:

int
seek(int fdnum, off_t offset)
{
  801125:	f3 0f 1e fb          	endbr32 
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80112f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801132:	50                   	push   %eax
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	e8 0b fc ff ff       	call   800d46 <fd_lookup>
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 0e                	js     801150 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801142:	8b 55 0c             	mov    0xc(%ebp),%edx
  801145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801148:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80114b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801152:	f3 0f 1e fb          	endbr32 
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	53                   	push   %ebx
  80115a:	83 ec 1c             	sub    $0x1c,%esp
  80115d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801160:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	53                   	push   %ebx
  801165:	e8 dc fb ff ff       	call   800d46 <fd_lookup>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	78 37                	js     8011a8 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801177:	50                   	push   %eax
  801178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117b:	ff 30                	pushl  (%eax)
  80117d:	e8 18 fc ff ff       	call   800d9a <dev_lookup>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	78 1f                	js     8011a8 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801190:	74 1b                	je     8011ad <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801195:	8b 52 18             	mov    0x18(%edx),%edx
  801198:	85 d2                	test   %edx,%edx
  80119a:	74 32                	je     8011ce <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	50                   	push   %eax
  8011a3:	ff d2                	call   *%edx
  8011a5:	83 c4 10             	add    $0x10,%esp
}
  8011a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011ad:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011b2:	8b 40 48             	mov    0x48(%eax),%eax
  8011b5:	83 ec 04             	sub    $0x4,%esp
  8011b8:	53                   	push   %ebx
  8011b9:	50                   	push   %eax
  8011ba:	68 cc 21 80 00       	push   $0x8021cc
  8011bf:	e8 ca ef ff ff       	call   80018e <cprintf>
		return -E_INVAL;
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb da                	jmp    8011a8 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8011ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011d3:	eb d3                	jmp    8011a8 <ftruncate+0x56>

008011d5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011d5:	f3 0f 1e fb          	endbr32 
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	53                   	push   %ebx
  8011dd:	83 ec 1c             	sub    $0x1c,%esp
  8011e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e6:	50                   	push   %eax
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	e8 57 fb ff ff       	call   800d46 <fd_lookup>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 4b                	js     801241 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801200:	ff 30                	pushl  (%eax)
  801202:	e8 93 fb ff ff       	call   800d9a <dev_lookup>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 33                	js     801241 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80120e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801211:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801215:	74 2f                	je     801246 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801217:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80121a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801221:	00 00 00 
	stat->st_isdir = 0;
  801224:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80122b:	00 00 00 
	stat->st_dev = dev;
  80122e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	53                   	push   %ebx
  801238:	ff 75 f0             	pushl  -0x10(%ebp)
  80123b:	ff 50 14             	call   *0x14(%eax)
  80123e:	83 c4 10             	add    $0x10,%esp
}
  801241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801244:	c9                   	leave  
  801245:	c3                   	ret    
		return -E_NOT_SUPP;
  801246:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80124b:	eb f4                	jmp    801241 <fstat+0x6c>

0080124d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80124d:	f3 0f 1e fb          	endbr32 
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801256:	83 ec 08             	sub    $0x8,%esp
  801259:	6a 00                	push   $0x0
  80125b:	ff 75 08             	pushl  0x8(%ebp)
  80125e:	e8 3a 02 00 00       	call   80149d <open>
  801263:	89 c3                	mov    %eax,%ebx
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	78 1b                	js     801287 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	50                   	push   %eax
  801273:	e8 5d ff ff ff       	call   8011d5 <fstat>
  801278:	89 c6                	mov    %eax,%esi
	close(fd);
  80127a:	89 1c 24             	mov    %ebx,(%esp)
  80127d:	e8 fd fb ff ff       	call   800e7f <close>
	return r;
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	89 f3                	mov    %esi,%ebx
}
  801287:	89 d8                	mov    %ebx,%eax
  801289:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
  801295:	89 c6                	mov    %eax,%esi
  801297:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801299:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012a0:	74 27                	je     8012c9 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012a2:	6a 07                	push   $0x7
  8012a4:	68 00 50 80 00       	push   $0x805000
  8012a9:	56                   	push   %esi
  8012aa:	ff 35 00 40 80 00    	pushl  0x804000
  8012b0:	e8 47 08 00 00       	call   801afc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012b5:	83 c4 0c             	add    $0xc,%esp
  8012b8:	6a 00                	push   $0x0
  8012ba:	53                   	push   %ebx
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 cd 07 00 00       	call   801a8f <ipc_recv>
}
  8012c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	6a 01                	push   $0x1
  8012ce:	e8 81 08 00 00       	call   801b54 <ipc_find_env>
  8012d3:	a3 00 40 80 00       	mov    %eax,0x804000
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	eb c5                	jmp    8012a2 <fsipc+0x12>

008012dd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012dd:	f3 0f 1e fb          	endbr32 
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8012ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801304:	e8 87 ff ff ff       	call   801290 <fsipc>
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <devfile_flush>:
{
  80130b:	f3 0f 1e fb          	endbr32 
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8b 40 0c             	mov    0xc(%eax),%eax
  80131b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801320:	ba 00 00 00 00       	mov    $0x0,%edx
  801325:	b8 06 00 00 00       	mov    $0x6,%eax
  80132a:	e8 61 ff ff ff       	call   801290 <fsipc>
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <devfile_stat>:
{
  801331:	f3 0f 1e fb          	endbr32 
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8b 40 0c             	mov    0xc(%eax),%eax
  801345:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80134a:	ba 00 00 00 00       	mov    $0x0,%edx
  80134f:	b8 05 00 00 00       	mov    $0x5,%eax
  801354:	e8 37 ff ff ff       	call   801290 <fsipc>
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 2c                	js     801389 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	68 00 50 80 00       	push   $0x805000
  801365:	53                   	push   %ebx
  801366:	e8 8d f3 ff ff       	call   8006f8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80136b:	a1 80 50 80 00       	mov    0x805080,%eax
  801370:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801376:	a1 84 50 80 00       	mov    0x805084,%eax
  80137b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801389:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <devfile_write>:
{
  80138e:	f3 0f 1e fb          	endbr32 
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	53                   	push   %ebx
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8013a7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8013ad:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8013b3:	77 30                	ja     8013e5 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	53                   	push   %ebx
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	68 08 50 80 00       	push   $0x805008
  8013c1:	e8 ea f4 ff ff       	call   8008b0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8013d0:	e8 bb fe ff ff       	call   801290 <fsipc>
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	78 04                	js     8013e0 <devfile_write+0x52>
	assert(r <= n);
  8013dc:	39 d8                	cmp    %ebx,%eax
  8013de:	77 1e                	ja     8013fe <devfile_write+0x70>
}
  8013e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8013e5:	68 38 22 80 00       	push   $0x802238
  8013ea:	68 65 22 80 00       	push   $0x802265
  8013ef:	68 94 00 00 00       	push   $0x94
  8013f4:	68 7a 22 80 00       	push   $0x80227a
  8013f9:	e8 47 06 00 00       	call   801a45 <_panic>
	assert(r <= n);
  8013fe:	68 85 22 80 00       	push   $0x802285
  801403:	68 65 22 80 00       	push   $0x802265
  801408:	68 98 00 00 00       	push   $0x98
  80140d:	68 7a 22 80 00       	push   $0x80227a
  801412:	e8 2e 06 00 00       	call   801a45 <_panic>

00801417 <devfile_read>:
{
  801417:	f3 0f 1e fb          	endbr32 
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	56                   	push   %esi
  80141f:	53                   	push   %ebx
  801420:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8b 40 0c             	mov    0xc(%eax),%eax
  801429:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80142e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801434:	ba 00 00 00 00       	mov    $0x0,%edx
  801439:	b8 03 00 00 00       	mov    $0x3,%eax
  80143e:	e8 4d fe ff ff       	call   801290 <fsipc>
  801443:	89 c3                	mov    %eax,%ebx
  801445:	85 c0                	test   %eax,%eax
  801447:	78 1f                	js     801468 <devfile_read+0x51>
	assert(r <= n);
  801449:	39 f0                	cmp    %esi,%eax
  80144b:	77 24                	ja     801471 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80144d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801452:	7f 33                	jg     801487 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	50                   	push   %eax
  801458:	68 00 50 80 00       	push   $0x805000
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	e8 4b f4 ff ff       	call   8008b0 <memmove>
	return r;
  801465:	83 c4 10             	add    $0x10,%esp
}
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    
	assert(r <= n);
  801471:	68 85 22 80 00       	push   $0x802285
  801476:	68 65 22 80 00       	push   $0x802265
  80147b:	6a 7c                	push   $0x7c
  80147d:	68 7a 22 80 00       	push   $0x80227a
  801482:	e8 be 05 00 00       	call   801a45 <_panic>
	assert(r <= PGSIZE);
  801487:	68 8c 22 80 00       	push   $0x80228c
  80148c:	68 65 22 80 00       	push   $0x802265
  801491:	6a 7d                	push   $0x7d
  801493:	68 7a 22 80 00       	push   $0x80227a
  801498:	e8 a8 05 00 00       	call   801a45 <_panic>

0080149d <open>:
{
  80149d:	f3 0f 1e fb          	endbr32 
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	56                   	push   %esi
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 1c             	sub    $0x1c,%esp
  8014a9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014ac:	56                   	push   %esi
  8014ad:	e8 03 f2 ff ff       	call   8006b5 <strlen>
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ba:	7f 6c                	jg     801528 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	e8 28 f8 ff ff       	call   800cf0 <fd_alloc>
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 3c                	js     80150d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	56                   	push   %esi
  8014d5:	68 00 50 80 00       	push   $0x805000
  8014da:	e8 19 f2 ff ff       	call   8006f8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ef:	e8 9c fd ff ff       	call   801290 <fsipc>
  8014f4:	89 c3                	mov    %eax,%ebx
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 19                	js     801516 <open+0x79>
	return fd2num(fd);
  8014fd:	83 ec 0c             	sub    $0xc,%esp
  801500:	ff 75 f4             	pushl  -0xc(%ebp)
  801503:	e8 b5 f7 ff ff       	call   800cbd <fd2num>
  801508:	89 c3                	mov    %eax,%ebx
  80150a:	83 c4 10             	add    $0x10,%esp
}
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    
		fd_close(fd, 0);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	6a 00                	push   $0x0
  80151b:	ff 75 f4             	pushl  -0xc(%ebp)
  80151e:	e8 d1 f8 ff ff       	call   800df4 <fd_close>
		return r;
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	eb e5                	jmp    80150d <open+0x70>
		return -E_BAD_PATH;
  801528:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80152d:	eb de                	jmp    80150d <open+0x70>

0080152f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80152f:	f3 0f 1e fb          	endbr32 
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801539:	ba 00 00 00 00       	mov    $0x0,%edx
  80153e:	b8 08 00 00 00       	mov    $0x8,%eax
  801543:	e8 48 fd ff ff       	call   801290 <fsipc>
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80154a:	f3 0f 1e fb          	endbr32 
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	56                   	push   %esi
  801552:	53                   	push   %ebx
  801553:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 70 f7 ff ff       	call   800cd1 <fd2data>
  801561:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801563:	83 c4 08             	add    $0x8,%esp
  801566:	68 98 22 80 00       	push   $0x802298
  80156b:	53                   	push   %ebx
  80156c:	e8 87 f1 ff ff       	call   8006f8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801571:	8b 46 04             	mov    0x4(%esi),%eax
  801574:	2b 06                	sub    (%esi),%eax
  801576:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80157c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801583:	00 00 00 
	stat->st_dev = &devpipe;
  801586:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80158d:	30 80 00 
	return 0;
}
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80159c:	f3 0f 1e fb          	endbr32 
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	53                   	push   %ebx
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015aa:	53                   	push   %ebx
  8015ab:	6a 00                	push   $0x0
  8015ad:	e8 20 f6 ff ff       	call   800bd2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 17 f7 ff ff       	call   800cd1 <fd2data>
  8015ba:	83 c4 08             	add    $0x8,%esp
  8015bd:	50                   	push   %eax
  8015be:	6a 00                	push   $0x0
  8015c0:	e8 0d f6 ff ff       	call   800bd2 <sys_page_unmap>
}
  8015c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <_pipeisclosed>:
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	57                   	push   %edi
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 1c             	sub    $0x1c,%esp
  8015d3:	89 c7                	mov    %eax,%edi
  8015d5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8015dc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	57                   	push   %edi
  8015e3:	e8 a9 05 00 00       	call   801b91 <pageref>
  8015e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015eb:	89 34 24             	mov    %esi,(%esp)
  8015ee:	e8 9e 05 00 00       	call   801b91 <pageref>
		nn = thisenv->env_runs;
  8015f3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015f9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	39 cb                	cmp    %ecx,%ebx
  801601:	74 1b                	je     80161e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801603:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801606:	75 cf                	jne    8015d7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801608:	8b 42 58             	mov    0x58(%edx),%eax
  80160b:	6a 01                	push   $0x1
  80160d:	50                   	push   %eax
  80160e:	53                   	push   %ebx
  80160f:	68 9f 22 80 00       	push   $0x80229f
  801614:	e8 75 eb ff ff       	call   80018e <cprintf>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	eb b9                	jmp    8015d7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80161e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801621:	0f 94 c0             	sete   %al
  801624:	0f b6 c0             	movzbl %al,%eax
}
  801627:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5f                   	pop    %edi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    

0080162f <devpipe_write>:
{
  80162f:	f3 0f 1e fb          	endbr32 
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	57                   	push   %edi
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	83 ec 28             	sub    $0x28,%esp
  80163c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80163f:	56                   	push   %esi
  801640:	e8 8c f6 ff ff       	call   800cd1 <fd2data>
  801645:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	bf 00 00 00 00       	mov    $0x0,%edi
  80164f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801652:	74 4f                	je     8016a3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801654:	8b 43 04             	mov    0x4(%ebx),%eax
  801657:	8b 0b                	mov    (%ebx),%ecx
  801659:	8d 51 20             	lea    0x20(%ecx),%edx
  80165c:	39 d0                	cmp    %edx,%eax
  80165e:	72 14                	jb     801674 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801660:	89 da                	mov    %ebx,%edx
  801662:	89 f0                	mov    %esi,%eax
  801664:	e8 61 ff ff ff       	call   8015ca <_pipeisclosed>
  801669:	85 c0                	test   %eax,%eax
  80166b:	75 3b                	jne    8016a8 <devpipe_write+0x79>
			sys_yield();
  80166d:	e8 e3 f4 ff ff       	call   800b55 <sys_yield>
  801672:	eb e0                	jmp    801654 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801674:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801677:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80167b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80167e:	89 c2                	mov    %eax,%edx
  801680:	c1 fa 1f             	sar    $0x1f,%edx
  801683:	89 d1                	mov    %edx,%ecx
  801685:	c1 e9 1b             	shr    $0x1b,%ecx
  801688:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80168b:	83 e2 1f             	and    $0x1f,%edx
  80168e:	29 ca                	sub    %ecx,%edx
  801690:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801694:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801698:	83 c0 01             	add    $0x1,%eax
  80169b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80169e:	83 c7 01             	add    $0x1,%edi
  8016a1:	eb ac                	jmp    80164f <devpipe_write+0x20>
	return i;
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	eb 05                	jmp    8016ad <devpipe_write+0x7e>
				return 0;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5f                   	pop    %edi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <devpipe_read>:
{
  8016b5:	f3 0f 1e fb          	endbr32 
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	57                   	push   %edi
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
  8016bf:	83 ec 18             	sub    $0x18,%esp
  8016c2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016c5:	57                   	push   %edi
  8016c6:	e8 06 f6 ff ff       	call   800cd1 <fd2data>
  8016cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	be 00 00 00 00       	mov    $0x0,%esi
  8016d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016d8:	75 14                	jne    8016ee <devpipe_read+0x39>
	return i;
  8016da:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dd:	eb 02                	jmp    8016e1 <devpipe_read+0x2c>
				return i;
  8016df:	89 f0                	mov    %esi,%eax
}
  8016e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5f                   	pop    %edi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    
			sys_yield();
  8016e9:	e8 67 f4 ff ff       	call   800b55 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8016ee:	8b 03                	mov    (%ebx),%eax
  8016f0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016f3:	75 18                	jne    80170d <devpipe_read+0x58>
			if (i > 0)
  8016f5:	85 f6                	test   %esi,%esi
  8016f7:	75 e6                	jne    8016df <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8016f9:	89 da                	mov    %ebx,%edx
  8016fb:	89 f8                	mov    %edi,%eax
  8016fd:	e8 c8 fe ff ff       	call   8015ca <_pipeisclosed>
  801702:	85 c0                	test   %eax,%eax
  801704:	74 e3                	je     8016e9 <devpipe_read+0x34>
				return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	eb d4                	jmp    8016e1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80170d:	99                   	cltd   
  80170e:	c1 ea 1b             	shr    $0x1b,%edx
  801711:	01 d0                	add    %edx,%eax
  801713:	83 e0 1f             	and    $0x1f,%eax
  801716:	29 d0                	sub    %edx,%eax
  801718:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801723:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801726:	83 c6 01             	add    $0x1,%esi
  801729:	eb aa                	jmp    8016d5 <devpipe_read+0x20>

0080172b <pipe>:
{
  80172b:	f3 0f 1e fb          	endbr32 
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
  801734:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	e8 b0 f5 ff ff       	call   800cf0 <fd_alloc>
  801740:	89 c3                	mov    %eax,%ebx
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	0f 88 23 01 00 00    	js     801870 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 07 04 00 00       	push   $0x407
  801755:	ff 75 f4             	pushl  -0xc(%ebp)
  801758:	6a 00                	push   $0x0
  80175a:	e8 21 f4 ff ff       	call   800b80 <sys_page_alloc>
  80175f:	89 c3                	mov    %eax,%ebx
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	0f 88 04 01 00 00    	js     801870 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801772:	50                   	push   %eax
  801773:	e8 78 f5 ff ff       	call   800cf0 <fd_alloc>
  801778:	89 c3                	mov    %eax,%ebx
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	0f 88 db 00 00 00    	js     801860 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 07 04 00 00       	push   $0x407
  80178d:	ff 75 f0             	pushl  -0x10(%ebp)
  801790:	6a 00                	push   $0x0
  801792:	e8 e9 f3 ff ff       	call   800b80 <sys_page_alloc>
  801797:	89 c3                	mov    %eax,%ebx
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	0f 88 bc 00 00 00    	js     801860 <pipe+0x135>
	va = fd2data(fd0);
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	e8 22 f5 ff ff       	call   800cd1 <fd2data>
  8017af:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017b1:	83 c4 0c             	add    $0xc,%esp
  8017b4:	68 07 04 00 00       	push   $0x407
  8017b9:	50                   	push   %eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	e8 bf f3 ff ff       	call   800b80 <sys_page_alloc>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	0f 88 82 00 00 00    	js     801850 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d4:	e8 f8 f4 ff ff       	call   800cd1 <fd2data>
  8017d9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017e0:	50                   	push   %eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	56                   	push   %esi
  8017e4:	6a 00                	push   $0x0
  8017e6:	e8 bd f3 ff ff       	call   800ba8 <sys_page_map>
  8017eb:	89 c3                	mov    %eax,%ebx
  8017ed:	83 c4 20             	add    $0x20,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 4e                	js     801842 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8017f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8017f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8017fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801801:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801808:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80180b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	ff 75 f4             	pushl  -0xc(%ebp)
  80181d:	e8 9b f4 ff ff       	call   800cbd <fd2num>
  801822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801825:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801827:	83 c4 04             	add    $0x4,%esp
  80182a:	ff 75 f0             	pushl  -0x10(%ebp)
  80182d:	e8 8b f4 ff ff       	call   800cbd <fd2num>
  801832:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801835:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801840:	eb 2e                	jmp    801870 <pipe+0x145>
	sys_page_unmap(0, va);
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	56                   	push   %esi
  801846:	6a 00                	push   $0x0
  801848:	e8 85 f3 ff ff       	call   800bd2 <sys_page_unmap>
  80184d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801850:	83 ec 08             	sub    $0x8,%esp
  801853:	ff 75 f0             	pushl  -0x10(%ebp)
  801856:	6a 00                	push   $0x0
  801858:	e8 75 f3 ff ff       	call   800bd2 <sys_page_unmap>
  80185d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	ff 75 f4             	pushl  -0xc(%ebp)
  801866:	6a 00                	push   $0x0
  801868:	e8 65 f3 ff ff       	call   800bd2 <sys_page_unmap>
  80186d:	83 c4 10             	add    $0x10,%esp
}
  801870:	89 d8                	mov    %ebx,%eax
  801872:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801875:	5b                   	pop    %ebx
  801876:	5e                   	pop    %esi
  801877:	5d                   	pop    %ebp
  801878:	c3                   	ret    

00801879 <pipeisclosed>:
{
  801879:	f3 0f 1e fb          	endbr32 
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801883:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801886:	50                   	push   %eax
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	e8 b7 f4 ff ff       	call   800d46 <fd_lookup>
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	85 c0                	test   %eax,%eax
  801894:	78 18                	js     8018ae <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	ff 75 f4             	pushl  -0xc(%ebp)
  80189c:	e8 30 f4 ff ff       	call   800cd1 <fd2data>
  8018a1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a6:	e8 1f fd ff ff       	call   8015ca <_pipeisclosed>
  8018ab:	83 c4 10             	add    $0x10,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018b0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	c3                   	ret    

008018ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018c4:	68 b7 22 80 00       	push   $0x8022b7
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	e8 27 ee ff ff       	call   8006f8 <strcpy>
	return 0;
}
  8018d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <devcons_write>:
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8018e8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8018ed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018f6:	73 31                	jae    801929 <devcons_write+0x51>
		m = n - tot;
  8018f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018fb:	29 f3                	sub    %esi,%ebx
  8018fd:	83 fb 7f             	cmp    $0x7f,%ebx
  801900:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801905:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	53                   	push   %ebx
  80190c:	89 f0                	mov    %esi,%eax
  80190e:	03 45 0c             	add    0xc(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	57                   	push   %edi
  801913:	e8 98 ef ff ff       	call   8008b0 <memmove>
		sys_cputs(buf, m);
  801918:	83 c4 08             	add    $0x8,%esp
  80191b:	53                   	push   %ebx
  80191c:	57                   	push   %edi
  80191d:	e8 93 f1 ff ff       	call   800ab5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801922:	01 de                	add    %ebx,%esi
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	eb ca                	jmp    8018f3 <devcons_write+0x1b>
}
  801929:	89 f0                	mov    %esi,%eax
  80192b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5f                   	pop    %edi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <devcons_read>:
{
  801933:	f3 0f 1e fb          	endbr32 
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801942:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801946:	74 21                	je     801969 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801948:	e8 92 f1 ff ff       	call   800adf <sys_cgetc>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	75 07                	jne    801958 <devcons_read+0x25>
		sys_yield();
  801951:	e8 ff f1 ff ff       	call   800b55 <sys_yield>
  801956:	eb f0                	jmp    801948 <devcons_read+0x15>
	if (c < 0)
  801958:	78 0f                	js     801969 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80195a:	83 f8 04             	cmp    $0x4,%eax
  80195d:	74 0c                	je     80196b <devcons_read+0x38>
	*(char*)vbuf = c;
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	88 02                	mov    %al,(%edx)
	return 1;
  801964:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    
		return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	eb f7                	jmp    801969 <devcons_read+0x36>

00801972 <cputchar>:
{
  801972:	f3 0f 1e fb          	endbr32 
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801982:	6a 01                	push   $0x1
  801984:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801987:	50                   	push   %eax
  801988:	e8 28 f1 ff ff       	call   800ab5 <sys_cputs>
}
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <getchar>:
{
  801992:	f3 0f 1e fb          	endbr32 
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80199c:	6a 01                	push   $0x1
  80199e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019a1:	50                   	push   %eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	e8 20 f6 ff ff       	call   800fc9 <read>
	if (r < 0)
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 06                	js     8019b6 <getchar+0x24>
	if (r < 1)
  8019b0:	74 06                	je     8019b8 <getchar+0x26>
	return c;
  8019b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    
		return -E_EOF;
  8019b8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8019bd:	eb f7                	jmp    8019b6 <getchar+0x24>

008019bf <iscons>:
{
  8019bf:	f3 0f 1e fb          	endbr32 
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cc:	50                   	push   %eax
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	e8 71 f3 ff ff       	call   800d46 <fd_lookup>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 11                	js     8019ed <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019e5:	39 10                	cmp    %edx,(%eax)
  8019e7:	0f 94 c0             	sete   %al
  8019ea:	0f b6 c0             	movzbl %al,%eax
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <opencons>:
{
  8019ef:	f3 0f 1e fb          	endbr32 
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8019f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fc:	50                   	push   %eax
  8019fd:	e8 ee f2 ff ff       	call   800cf0 <fd_alloc>
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 3a                	js     801a43 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	68 07 04 00 00       	push   $0x407
  801a11:	ff 75 f4             	pushl  -0xc(%ebp)
  801a14:	6a 00                	push   $0x0
  801a16:	e8 65 f1 ff ff       	call   800b80 <sys_page_alloc>
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 21                	js     801a43 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a25:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a2b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	50                   	push   %eax
  801a3b:	e8 7d f2 ff ff       	call   800cbd <fd2num>
  801a40:	83 c4 10             	add    $0x10,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a45:	f3 0f 1e fb          	endbr32 
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a4e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a51:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a57:	e8 d1 f0 ff ff       	call   800b2d <sys_getenvid>
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	56                   	push   %esi
  801a66:	50                   	push   %eax
  801a67:	68 c4 22 80 00       	push   $0x8022c4
  801a6c:	e8 1d e7 ff ff       	call   80018e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a71:	83 c4 18             	add    $0x18,%esp
  801a74:	53                   	push   %ebx
  801a75:	ff 75 10             	pushl  0x10(%ebp)
  801a78:	e8 bc e6 ff ff       	call   800139 <vcprintf>
	cprintf("\n");
  801a7d:	c7 04 24 02 23 80 00 	movl   $0x802302,(%esp)
  801a84:	e8 05 e7 ff ff       	call   80018e <cprintf>
  801a89:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a8c:	cc                   	int3   
  801a8d:	eb fd                	jmp    801a8c <_panic+0x47>

00801a8f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a8f:	f3 0f 1e fb          	endbr32 
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
  801a98:	8b 75 08             	mov    0x8(%ebp),%esi
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801aa8:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801aab:	83 ec 0c             	sub    $0xc,%esp
  801aae:	50                   	push   %eax
  801aaf:	e8 e3 f1 ff ff       	call   800c97 <sys_ipc_recv>
	if (r < 0) {
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 2b                	js     801ae6 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801abb:	85 f6                	test   %esi,%esi
  801abd:	74 0a                	je     801ac9 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801abf:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac4:	8b 40 74             	mov    0x74(%eax),%eax
  801ac7:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801ac9:	85 db                	test   %ebx,%ebx
  801acb:	74 0a                	je     801ad7 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801acd:	a1 04 40 80 00       	mov    0x804004,%eax
  801ad2:	8b 40 78             	mov    0x78(%eax),%eax
  801ad5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801ad7:	a1 04 40 80 00       	mov    0x804004,%eax
  801adc:	8b 40 70             	mov    0x70(%eax),%eax
}
  801adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    
		if (from_env_store) {
  801ae6:	85 f6                	test   %esi,%esi
  801ae8:	74 06                	je     801af0 <ipc_recv+0x61>
			*from_env_store = 0;
  801aea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801af0:	85 db                	test   %ebx,%ebx
  801af2:	74 eb                	je     801adf <ipc_recv+0x50>
			*perm_store = 0;
  801af4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801afa:	eb e3                	jmp    801adf <ipc_recv+0x50>

00801afc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801afc:	f3 0f 1e fb          	endbr32 
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	57                   	push   %edi
  801b04:	56                   	push   %esi
  801b05:	53                   	push   %ebx
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b12:	85 db                	test   %ebx,%ebx
  801b14:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b19:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b1c:	ff 75 14             	pushl  0x14(%ebp)
  801b1f:	53                   	push   %ebx
  801b20:	56                   	push   %esi
  801b21:	57                   	push   %edi
  801b22:	e8 47 f1 ff ff       	call   800c6e <sys_ipc_try_send>
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b2d:	75 07                	jne    801b36 <ipc_send+0x3a>
		sys_yield();
  801b2f:	e8 21 f0 ff ff       	call   800b55 <sys_yield>
  801b34:	eb e6                	jmp    801b1c <ipc_send+0x20>
	}

	if (ret < 0) {
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 08                	js     801b42 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5f                   	pop    %edi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b42:	50                   	push   %eax
  801b43:	68 e7 22 80 00       	push   $0x8022e7
  801b48:	6a 48                	push   $0x48
  801b4a:	68 04 23 80 00       	push   $0x802304
  801b4f:	e8 f1 fe ff ff       	call   801a45 <_panic>

00801b54 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b54:	f3 0f 1e fb          	endbr32 
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b63:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b66:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b6c:	8b 52 50             	mov    0x50(%edx),%edx
  801b6f:	39 ca                	cmp    %ecx,%edx
  801b71:	74 11                	je     801b84 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b73:	83 c0 01             	add    $0x1,%eax
  801b76:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b7b:	75 e6                	jne    801b63 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b82:	eb 0b                	jmp    801b8f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b84:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b87:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b8c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    

00801b91 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b91:	f3 0f 1e fb          	endbr32 
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b9b:	89 c2                	mov    %eax,%edx
  801b9d:	c1 ea 16             	shr    $0x16,%edx
  801ba0:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801ba7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801bac:	f6 c1 01             	test   $0x1,%cl
  801baf:	74 1c                	je     801bcd <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801bb1:	c1 e8 0c             	shr    $0xc,%eax
  801bb4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801bbb:	a8 01                	test   $0x1,%al
  801bbd:	74 0e                	je     801bcd <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801bbf:	c1 e8 0c             	shr    $0xc,%eax
  801bc2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801bc9:	ef 
  801bca:	0f b7 d2             	movzwl %dx,%edx
}
  801bcd:	89 d0                	mov    %edx,%eax
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
  801bd1:	66 90                	xchg   %ax,%ax
  801bd3:	66 90                	xchg   %ax,%ax
  801bd5:	66 90                	xchg   %ax,%ax
  801bd7:	66 90                	xchg   %ax,%ax
  801bd9:	66 90                	xchg   %ax,%ax
  801bdb:	66 90                	xchg   %ax,%ax
  801bdd:	66 90                	xchg   %ax,%ax
  801bdf:	90                   	nop

00801be0 <__udivdi3>:
  801be0:	f3 0f 1e fb          	endbr32 
  801be4:	55                   	push   %ebp
  801be5:	57                   	push   %edi
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 1c             	sub    $0x1c,%esp
  801beb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bf7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bfb:	85 d2                	test   %edx,%edx
  801bfd:	75 19                	jne    801c18 <__udivdi3+0x38>
  801bff:	39 f3                	cmp    %esi,%ebx
  801c01:	76 4d                	jbe    801c50 <__udivdi3+0x70>
  801c03:	31 ff                	xor    %edi,%edi
  801c05:	89 e8                	mov    %ebp,%eax
  801c07:	89 f2                	mov    %esi,%edx
  801c09:	f7 f3                	div    %ebx
  801c0b:	89 fa                	mov    %edi,%edx
  801c0d:	83 c4 1c             	add    $0x1c,%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    
  801c15:	8d 76 00             	lea    0x0(%esi),%esi
  801c18:	39 f2                	cmp    %esi,%edx
  801c1a:	76 14                	jbe    801c30 <__udivdi3+0x50>
  801c1c:	31 ff                	xor    %edi,%edi
  801c1e:	31 c0                	xor    %eax,%eax
  801c20:	89 fa                	mov    %edi,%edx
  801c22:	83 c4 1c             	add    $0x1c,%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5e                   	pop    %esi
  801c27:	5f                   	pop    %edi
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    
  801c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c30:	0f bd fa             	bsr    %edx,%edi
  801c33:	83 f7 1f             	xor    $0x1f,%edi
  801c36:	75 48                	jne    801c80 <__udivdi3+0xa0>
  801c38:	39 f2                	cmp    %esi,%edx
  801c3a:	72 06                	jb     801c42 <__udivdi3+0x62>
  801c3c:	31 c0                	xor    %eax,%eax
  801c3e:	39 eb                	cmp    %ebp,%ebx
  801c40:	77 de                	ja     801c20 <__udivdi3+0x40>
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	eb d7                	jmp    801c20 <__udivdi3+0x40>
  801c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c50:	89 d9                	mov    %ebx,%ecx
  801c52:	85 db                	test   %ebx,%ebx
  801c54:	75 0b                	jne    801c61 <__udivdi3+0x81>
  801c56:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f3                	div    %ebx
  801c5f:	89 c1                	mov    %eax,%ecx
  801c61:	31 d2                	xor    %edx,%edx
  801c63:	89 f0                	mov    %esi,%eax
  801c65:	f7 f1                	div    %ecx
  801c67:	89 c6                	mov    %eax,%esi
  801c69:	89 e8                	mov    %ebp,%eax
  801c6b:	89 f7                	mov    %esi,%edi
  801c6d:	f7 f1                	div    %ecx
  801c6f:	89 fa                	mov    %edi,%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c80:	89 f9                	mov    %edi,%ecx
  801c82:	b8 20 00 00 00       	mov    $0x20,%eax
  801c87:	29 f8                	sub    %edi,%eax
  801c89:	d3 e2                	shl    %cl,%edx
  801c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c8f:	89 c1                	mov    %eax,%ecx
  801c91:	89 da                	mov    %ebx,%edx
  801c93:	d3 ea                	shr    %cl,%edx
  801c95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c99:	09 d1                	or     %edx,%ecx
  801c9b:	89 f2                	mov    %esi,%edx
  801c9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca1:	89 f9                	mov    %edi,%ecx
  801ca3:	d3 e3                	shl    %cl,%ebx
  801ca5:	89 c1                	mov    %eax,%ecx
  801ca7:	d3 ea                	shr    %cl,%edx
  801ca9:	89 f9                	mov    %edi,%ecx
  801cab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801caf:	89 eb                	mov    %ebp,%ebx
  801cb1:	d3 e6                	shl    %cl,%esi
  801cb3:	89 c1                	mov    %eax,%ecx
  801cb5:	d3 eb                	shr    %cl,%ebx
  801cb7:	09 de                	or     %ebx,%esi
  801cb9:	89 f0                	mov    %esi,%eax
  801cbb:	f7 74 24 08          	divl   0x8(%esp)
  801cbf:	89 d6                	mov    %edx,%esi
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	f7 64 24 0c          	mull   0xc(%esp)
  801cc7:	39 d6                	cmp    %edx,%esi
  801cc9:	72 15                	jb     801ce0 <__udivdi3+0x100>
  801ccb:	89 f9                	mov    %edi,%ecx
  801ccd:	d3 e5                	shl    %cl,%ebp
  801ccf:	39 c5                	cmp    %eax,%ebp
  801cd1:	73 04                	jae    801cd7 <__udivdi3+0xf7>
  801cd3:	39 d6                	cmp    %edx,%esi
  801cd5:	74 09                	je     801ce0 <__udivdi3+0x100>
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	31 ff                	xor    %edi,%edi
  801cdb:	e9 40 ff ff ff       	jmp    801c20 <__udivdi3+0x40>
  801ce0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ce3:	31 ff                	xor    %edi,%edi
  801ce5:	e9 36 ff ff ff       	jmp    801c20 <__udivdi3+0x40>
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	66 90                	xchg   %ax,%ax
  801cee:	66 90                	xchg   %ax,%ax

00801cf0 <__umoddi3>:
  801cf0:	f3 0f 1e fb          	endbr32 
  801cf4:	55                   	push   %ebp
  801cf5:	57                   	push   %edi
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d03:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	75 19                	jne    801d28 <__umoddi3+0x38>
  801d0f:	39 df                	cmp    %ebx,%edi
  801d11:	76 5d                	jbe    801d70 <__umoddi3+0x80>
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	89 da                	mov    %ebx,%edx
  801d17:	f7 f7                	div    %edi
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	89 f2                	mov    %esi,%edx
  801d2a:	39 d8                	cmp    %ebx,%eax
  801d2c:	76 12                	jbe    801d40 <__umoddi3+0x50>
  801d2e:	89 f0                	mov    %esi,%eax
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	83 c4 1c             	add    $0x1c,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
  801d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d40:	0f bd e8             	bsr    %eax,%ebp
  801d43:	83 f5 1f             	xor    $0x1f,%ebp
  801d46:	75 50                	jne    801d98 <__umoddi3+0xa8>
  801d48:	39 d8                	cmp    %ebx,%eax
  801d4a:	0f 82 e0 00 00 00    	jb     801e30 <__umoddi3+0x140>
  801d50:	89 d9                	mov    %ebx,%ecx
  801d52:	39 f7                	cmp    %esi,%edi
  801d54:	0f 86 d6 00 00 00    	jbe    801e30 <__umoddi3+0x140>
  801d5a:	89 d0                	mov    %edx,%eax
  801d5c:	89 ca                	mov    %ecx,%edx
  801d5e:	83 c4 1c             	add    $0x1c,%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    
  801d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d6d:	8d 76 00             	lea    0x0(%esi),%esi
  801d70:	89 fd                	mov    %edi,%ebp
  801d72:	85 ff                	test   %edi,%edi
  801d74:	75 0b                	jne    801d81 <__umoddi3+0x91>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 d8                	mov    %ebx,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 f0                	mov    %esi,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	31 d2                	xor    %edx,%edx
  801d8f:	eb 8c                	jmp    801d1d <__umoddi3+0x2d>
  801d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d98:	89 e9                	mov    %ebp,%ecx
  801d9a:	ba 20 00 00 00       	mov    $0x20,%edx
  801d9f:	29 ea                	sub    %ebp,%edx
  801da1:	d3 e0                	shl    %cl,%eax
  801da3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801da7:	89 d1                	mov    %edx,%ecx
  801da9:	89 f8                	mov    %edi,%eax
  801dab:	d3 e8                	shr    %cl,%eax
  801dad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801db1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801db5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801db9:	09 c1                	or     %eax,%ecx
  801dbb:	89 d8                	mov    %ebx,%eax
  801dbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dc1:	89 e9                	mov    %ebp,%ecx
  801dc3:	d3 e7                	shl    %cl,%edi
  801dc5:	89 d1                	mov    %edx,%ecx
  801dc7:	d3 e8                	shr    %cl,%eax
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dcf:	d3 e3                	shl    %cl,%ebx
  801dd1:	89 c7                	mov    %eax,%edi
  801dd3:	89 d1                	mov    %edx,%ecx
  801dd5:	89 f0                	mov    %esi,%eax
  801dd7:	d3 e8                	shr    %cl,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	89 fa                	mov    %edi,%edx
  801ddd:	d3 e6                	shl    %cl,%esi
  801ddf:	09 d8                	or     %ebx,%eax
  801de1:	f7 74 24 08          	divl   0x8(%esp)
  801de5:	89 d1                	mov    %edx,%ecx
  801de7:	89 f3                	mov    %esi,%ebx
  801de9:	f7 64 24 0c          	mull   0xc(%esp)
  801ded:	89 c6                	mov    %eax,%esi
  801def:	89 d7                	mov    %edx,%edi
  801df1:	39 d1                	cmp    %edx,%ecx
  801df3:	72 06                	jb     801dfb <__umoddi3+0x10b>
  801df5:	75 10                	jne    801e07 <__umoddi3+0x117>
  801df7:	39 c3                	cmp    %eax,%ebx
  801df9:	73 0c                	jae    801e07 <__umoddi3+0x117>
  801dfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801dff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e03:	89 d7                	mov    %edx,%edi
  801e05:	89 c6                	mov    %eax,%esi
  801e07:	89 ca                	mov    %ecx,%edx
  801e09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e0e:	29 f3                	sub    %esi,%ebx
  801e10:	19 fa                	sbb    %edi,%edx
  801e12:	89 d0                	mov    %edx,%eax
  801e14:	d3 e0                	shl    %cl,%eax
  801e16:	89 e9                	mov    %ebp,%ecx
  801e18:	d3 eb                	shr    %cl,%ebx
  801e1a:	d3 ea                	shr    %cl,%edx
  801e1c:	09 d8                	or     %ebx,%eax
  801e1e:	83 c4 1c             	add    $0x1c,%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    
  801e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e2d:	8d 76 00             	lea    0x0(%esi),%esi
  801e30:	29 fe                	sub    %edi,%esi
  801e32:	19 c3                	sbb    %eax,%ebx
  801e34:	89 f2                	mov    %esi,%edx
  801e36:	89 d9                	mov    %ebx,%ecx
  801e38:	e9 1d ff ff ff       	jmp    801d5a <__umoddi3+0x6a>
