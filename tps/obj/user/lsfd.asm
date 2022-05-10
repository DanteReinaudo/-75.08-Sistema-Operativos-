
obj/user/lsfd.debug:     formato del fichero elf32-i386


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
  80002c:	e8 e8 00 00 00       	call   800119 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  80003d:	68 60 21 80 00       	push   $0x802160
  800042:	e8 db 01 00 00       	call   800222 <cprintf>
	exit();
  800047:	e8 1b 01 00 00       	call   800167 <exit>
}
  80004c:	83 c4 10             	add    $0x10,%esp
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <umain>:

void
umain(int argc, char **argv)
{
  800051:	f3 0f 1e fb          	endbr32 
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	57                   	push   %edi
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800061:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	ff 75 0c             	pushl  0xc(%ebp)
  80006b:	8d 45 08             	lea    0x8(%ebp),%eax
  80006e:	50                   	push   %eax
  80006f:	e8 dd 0c 00 00       	call   800d51 <argstart>
	while ((i = argnext(&args)) >= 0)
  800074:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  800077:	be 00 00 00 00       	mov    $0x0,%esi
	while ((i = argnext(&args)) >= 0)
  80007c:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((i = argnext(&args)) >= 0)
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	53                   	push   %ebx
  80008b:	e8 f5 0c 00 00       	call   800d85 <argnext>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	85 c0                	test   %eax,%eax
  800095:	78 10                	js     8000a7 <umain+0x56>
		if (i == '1')
  800097:	83 f8 31             	cmp    $0x31,%eax
  80009a:	75 04                	jne    8000a0 <umain+0x4f>
			usefprint = 1;
  80009c:	89 fe                	mov    %edi,%esi
  80009e:	eb e7                	jmp    800087 <umain+0x36>
		else
			usage();
  8000a0:	e8 8e ff ff ff       	call   800033 <usage>
  8000a5:	eb e0                	jmp    800087 <umain+0x36>

	for (i = 0; i < 32; i++)
  8000a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000ac:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000b2:	eb 26                	jmp    8000da <umain+0x89>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ba:	ff 70 04             	pushl  0x4(%eax)
  8000bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	57                   	push   %edi
  8000c4:	53                   	push   %ebx
  8000c5:	68 74 21 80 00       	push   $0x802174
  8000ca:	e8 53 01 00 00       	call   800222 <cprintf>
  8000cf:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000d2:	83 c3 01             	add    $0x1,%ebx
  8000d5:	83 fb 20             	cmp    $0x20,%ebx
  8000d8:	74 37                	je     800111 <umain+0xc0>
		if (fstat(i, &st) >= 0) {
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	57                   	push   %edi
  8000de:	53                   	push   %ebx
  8000df:	e8 e4 12 00 00       	call   8013c8 <fstat>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	78 e7                	js     8000d2 <umain+0x81>
			if (usefprint)
  8000eb:	85 f6                	test   %esi,%esi
  8000ed:	74 c5                	je     8000b4 <umain+0x63>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	ff 70 04             	pushl  0x4(%eax)
  8000f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8000fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fe:	57                   	push   %edi
  8000ff:	53                   	push   %ebx
  800100:	68 74 21 80 00       	push   $0x802174
  800105:	6a 01                	push   $0x1
  800107:	e8 20 17 00 00       	call   80182c <fprintf>
  80010c:	83 c4 20             	add    $0x20,%esp
  80010f:	eb c1                	jmp    8000d2 <umain+0x81>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800119:	f3 0f 1e fb          	endbr32 
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800125:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800128:	e8 94 0a 00 00       	call   800bc1 <sys_getenvid>
	if (id >= 0)
  80012d:	85 c0                	test   %eax,%eax
  80012f:	78 12                	js     800143 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800131:	25 ff 03 00 00       	and    $0x3ff,%eax
  800136:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800139:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80013e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800143:	85 db                	test   %ebx,%ebx
  800145:	7e 07                	jle    80014e <libmain+0x35>
		binaryname = argv[0];
  800147:	8b 06                	mov    (%esi),%eax
  800149:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	e8 f9 fe ff ff       	call   800051 <umain>

	// exit gracefully
	exit();
  800158:	e8 0a 00 00 00       	call   800167 <exit>
}
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    

00800167 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800171:	e8 2d 0f 00 00       	call   8010a3 <close_all>
	sys_env_destroy(0);
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	6a 00                	push   $0x0
  80017b:	e8 1b 0a 00 00       	call   800b9b <sys_env_destroy>
}
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800185:	f3 0f 1e fb          	endbr32 
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	53                   	push   %ebx
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800193:	8b 13                	mov    (%ebx),%edx
  800195:	8d 42 01             	lea    0x1(%edx),%eax
  800198:	89 03                	mov    %eax,(%ebx)
  80019a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a6:	74 09                	je     8001b1 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	68 ff 00 00 00       	push   $0xff
  8001b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bc:	50                   	push   %eax
  8001bd:	e8 87 09 00 00       	call   800b49 <sys_cputs>
		b->idx = 0;
  8001c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c8:	83 c4 10             	add    $0x10,%esp
  8001cb:	eb db                	jmp    8001a8 <putch+0x23>

008001cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cd:	f3 0f 1e fb          	endbr32 
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e1:	00 00 00 
	b.cnt = 0;
  8001e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001eb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ee:	ff 75 0c             	pushl  0xc(%ebp)
  8001f1:	ff 75 08             	pushl  0x8(%ebp)
  8001f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fa:	50                   	push   %eax
  8001fb:	68 85 01 80 00       	push   $0x800185
  800200:	e8 80 01 00 00       	call   800385 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800205:	83 c4 08             	add    $0x8,%esp
  800208:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800214:	50                   	push   %eax
  800215:	e8 2f 09 00 00       	call   800b49 <sys_cputs>

	return b.cnt;
}
  80021a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800222:	f3 0f 1e fb          	endbr32 
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022f:	50                   	push   %eax
  800230:	ff 75 08             	pushl  0x8(%ebp)
  800233:	e8 95 ff ff ff       	call   8001cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	57                   	push   %edi
  80023e:	56                   	push   %esi
  80023f:	53                   	push   %ebx
  800240:	83 ec 1c             	sub    $0x1c,%esp
  800243:	89 c7                	mov    %eax,%edi
  800245:	89 d6                	mov    %edx,%esi
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	89 c2                	mov    %eax,%edx
  800251:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800254:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800257:	8b 45 10             	mov    0x10(%ebp),%eax
  80025a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800260:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800267:	39 c2                	cmp    %eax,%edx
  800269:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026c:	72 3e                	jb     8002ac <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	ff 75 18             	pushl  0x18(%ebp)
  800274:	83 eb 01             	sub    $0x1,%ebx
  800277:	53                   	push   %ebx
  800278:	50                   	push   %eax
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 e0             	pushl  -0x20(%ebp)
  800282:	ff 75 dc             	pushl  -0x24(%ebp)
  800285:	ff 75 d8             	pushl  -0x28(%ebp)
  800288:	e8 63 1c 00 00       	call   801ef0 <__udivdi3>
  80028d:	83 c4 18             	add    $0x18,%esp
  800290:	52                   	push   %edx
  800291:	50                   	push   %eax
  800292:	89 f2                	mov    %esi,%edx
  800294:	89 f8                	mov    %edi,%eax
  800296:	e8 9f ff ff ff       	call   80023a <printnum>
  80029b:	83 c4 20             	add    $0x20,%esp
  80029e:	eb 13                	jmp    8002b3 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	56                   	push   %esi
  8002a4:	ff 75 18             	pushl  0x18(%ebp)
  8002a7:	ff d7                	call   *%edi
  8002a9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ac:	83 eb 01             	sub    $0x1,%ebx
  8002af:	85 db                	test   %ebx,%ebx
  8002b1:	7f ed                	jg     8002a0 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	56                   	push   %esi
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c6:	e8 35 1d 00 00       	call   802000 <__umoddi3>
  8002cb:	83 c4 14             	add    $0x14,%esp
  8002ce:	0f be 80 a6 21 80 00 	movsbl 0x8021a6(%eax),%eax
  8002d5:	50                   	push   %eax
  8002d6:	ff d7                	call   *%edi
}
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002de:	5b                   	pop    %ebx
  8002df:	5e                   	pop    %esi
  8002e0:	5f                   	pop    %edi
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002e3:	83 fa 01             	cmp    $0x1,%edx
  8002e6:	7f 13                	jg     8002fb <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002e8:	85 d2                	test   %edx,%edx
  8002ea:	74 1c                	je     800308 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002ec:	8b 10                	mov    (%eax),%edx
  8002ee:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f1:	89 08                	mov    %ecx,(%eax)
  8002f3:	8b 02                	mov    (%edx),%eax
  8002f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fa:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002fb:	8b 10                	mov    (%eax),%edx
  8002fd:	8d 4a 08             	lea    0x8(%edx),%ecx
  800300:	89 08                	mov    %ecx,(%eax)
  800302:	8b 02                	mov    (%edx),%eax
  800304:	8b 52 04             	mov    0x4(%edx),%edx
  800307:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800308:	8b 10                	mov    (%eax),%edx
  80030a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030d:	89 08                	mov    %ecx,(%eax)
  80030f:	8b 02                	mov    (%edx),%eax
  800311:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800316:	c3                   	ret    

00800317 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800317:	83 fa 01             	cmp    $0x1,%edx
  80031a:	7f 0f                	jg     80032b <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80031c:	85 d2                	test   %edx,%edx
  80031e:	74 18                	je     800338 <getint+0x21>
		return va_arg(*ap, long);
  800320:	8b 10                	mov    (%eax),%edx
  800322:	8d 4a 04             	lea    0x4(%edx),%ecx
  800325:	89 08                	mov    %ecx,(%eax)
  800327:	8b 02                	mov    (%edx),%eax
  800329:	99                   	cltd   
  80032a:	c3                   	ret    
		return va_arg(*ap, long long);
  80032b:	8b 10                	mov    (%eax),%edx
  80032d:	8d 4a 08             	lea    0x8(%edx),%ecx
  800330:	89 08                	mov    %ecx,(%eax)
  800332:	8b 02                	mov    (%edx),%eax
  800334:	8b 52 04             	mov    0x4(%edx),%edx
  800337:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800338:	8b 10                	mov    (%eax),%edx
  80033a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033d:	89 08                	mov    %ecx,(%eax)
  80033f:	8b 02                	mov    (%edx),%eax
  800341:	99                   	cltd   
}
  800342:	c3                   	ret    

00800343 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800343:	f3 0f 1e fb          	endbr32 
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800351:	8b 10                	mov    (%eax),%edx
  800353:	3b 50 04             	cmp    0x4(%eax),%edx
  800356:	73 0a                	jae    800362 <sprintputch+0x1f>
		*b->buf++ = ch;
  800358:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035b:	89 08                	mov    %ecx,(%eax)
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	88 02                	mov    %al,(%edx)
}
  800362:	5d                   	pop    %ebp
  800363:	c3                   	ret    

00800364 <printfmt>:
{
  800364:	f3 0f 1e fb          	endbr32 
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800371:	50                   	push   %eax
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	ff 75 0c             	pushl  0xc(%ebp)
  800378:	ff 75 08             	pushl  0x8(%ebp)
  80037b:	e8 05 00 00 00       	call   800385 <vprintfmt>
}
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <vprintfmt>:
{
  800385:	f3 0f 1e fb          	endbr32 
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	57                   	push   %edi
  80038d:	56                   	push   %esi
  80038e:	53                   	push   %ebx
  80038f:	83 ec 2c             	sub    $0x2c,%esp
  800392:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800395:	8b 75 0c             	mov    0xc(%ebp),%esi
  800398:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039b:	e9 86 02 00 00       	jmp    800626 <vprintfmt+0x2a1>
		padc = ' ';
  8003a0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ab:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8d 47 01             	lea    0x1(%edi),%eax
  8003c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c4:	0f b6 17             	movzbl (%edi),%edx
  8003c7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ca:	3c 55                	cmp    $0x55,%al
  8003cc:	0f 87 df 02 00 00    	ja     8006b1 <vprintfmt+0x32c>
  8003d2:	0f b6 c0             	movzbl %al,%eax
  8003d5:	3e ff 24 85 e0 22 80 	notrack jmp *0x8022e0(,%eax,4)
  8003dc:	00 
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e4:	eb d8                	jmp    8003be <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e9:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003ed:	eb cf                	jmp    8003be <vprintfmt+0x39>
  8003ef:	0f b6 d2             	movzbl %dl,%edx
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800400:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800404:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800407:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040a:	83 f9 09             	cmp    $0x9,%ecx
  80040d:	77 52                	ja     800461 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80040f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800412:	eb e9                	jmp    8003fd <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8d 50 04             	lea    0x4(%eax),%edx
  80041a:	89 55 14             	mov    %edx,0x14(%ebp)
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800429:	79 93                	jns    8003be <vprintfmt+0x39>
				width = precision, precision = -1;
  80042b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800431:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800438:	eb 84                	jmp    8003be <vprintfmt+0x39>
  80043a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	0f 49 d0             	cmovns %eax,%edx
  800447:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044d:	e9 6c ff ff ff       	jmp    8003be <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800455:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80045c:	e9 5d ff ff ff       	jmp    8003be <vprintfmt+0x39>
  800461:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800467:	eb bc                	jmp    800425 <vprintfmt+0xa0>
			lflag++;
  800469:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80046f:	e9 4a ff ff ff       	jmp    8003be <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 50 04             	lea    0x4(%eax),%edx
  80047a:	89 55 14             	mov    %edx,0x14(%ebp)
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	56                   	push   %esi
  800481:	ff 30                	pushl  (%eax)
  800483:	ff d3                	call   *%ebx
			break;
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	e9 96 01 00 00       	jmp    800623 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8d 50 04             	lea    0x4(%eax),%edx
  800493:	89 55 14             	mov    %edx,0x14(%ebp)
  800496:	8b 00                	mov    (%eax),%eax
  800498:	99                   	cltd   
  800499:	31 d0                	xor    %edx,%eax
  80049b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049d:	83 f8 0f             	cmp    $0xf,%eax
  8004a0:	7f 20                	jg     8004c2 <vprintfmt+0x13d>
  8004a2:	8b 14 85 40 24 80 00 	mov    0x802440(,%eax,4),%edx
  8004a9:	85 d2                	test   %edx,%edx
  8004ab:	74 15                	je     8004c2 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8004ad:	52                   	push   %edx
  8004ae:	68 97 25 80 00       	push   $0x802597
  8004b3:	56                   	push   %esi
  8004b4:	53                   	push   %ebx
  8004b5:	e8 aa fe ff ff       	call   800364 <printfmt>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	e9 61 01 00 00       	jmp    800623 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004c2:	50                   	push   %eax
  8004c3:	68 be 21 80 00       	push   $0x8021be
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	e8 95 fe ff ff       	call   800364 <printfmt>
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	e9 4c 01 00 00       	jmp    800623 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004e2:	85 c9                	test   %ecx,%ecx
  8004e4:	b8 b7 21 80 00       	mov    $0x8021b7,%eax
  8004e9:	0f 45 c1             	cmovne %ecx,%eax
  8004ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f3:	7e 06                	jle    8004fb <vprintfmt+0x176>
  8004f5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004f9:	75 0d                	jne    800508 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004fe:	89 c7                	mov    %eax,%edi
  800500:	03 45 e0             	add    -0x20(%ebp),%eax
  800503:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800506:	eb 57                	jmp    80055f <vprintfmt+0x1da>
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	ff 75 d8             	pushl  -0x28(%ebp)
  80050e:	ff 75 cc             	pushl  -0x34(%ebp)
  800511:	e8 4f 02 00 00       	call   800765 <strnlen>
  800516:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800519:	29 c2                	sub    %eax,%edx
  80051b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80051e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800521:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800525:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800528:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	85 db                	test   %ebx,%ebx
  80052c:	7e 10                	jle    80053e <vprintfmt+0x1b9>
					putch(padc, putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	56                   	push   %esi
  800532:	57                   	push   %edi
  800533:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800536:	83 eb 01             	sub    $0x1,%ebx
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	eb ec                	jmp    80052a <vprintfmt+0x1a5>
  80053e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	b8 00 00 00 00       	mov    $0x0,%eax
  80054b:	0f 49 c2             	cmovns %edx,%eax
  80054e:	29 c2                	sub    %eax,%edx
  800550:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800553:	eb a6                	jmp    8004fb <vprintfmt+0x176>
					putch(ch, putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	56                   	push   %esi
  800559:	52                   	push   %edx
  80055a:	ff d3                	call   *%ebx
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800562:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800564:	83 c7 01             	add    $0x1,%edi
  800567:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056b:	0f be d0             	movsbl %al,%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	74 42                	je     8005b4 <vprintfmt+0x22f>
  800572:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800576:	78 06                	js     80057e <vprintfmt+0x1f9>
  800578:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80057c:	78 1e                	js     80059c <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  80057e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800582:	74 d1                	je     800555 <vprintfmt+0x1d0>
  800584:	0f be c0             	movsbl %al,%eax
  800587:	83 e8 20             	sub    $0x20,%eax
  80058a:	83 f8 5e             	cmp    $0x5e,%eax
  80058d:	76 c6                	jbe    800555 <vprintfmt+0x1d0>
					putch('?', putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	56                   	push   %esi
  800593:	6a 3f                	push   $0x3f
  800595:	ff d3                	call   *%ebx
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	eb c3                	jmp    80055f <vprintfmt+0x1da>
  80059c:	89 cf                	mov    %ecx,%edi
  80059e:	eb 0e                	jmp    8005ae <vprintfmt+0x229>
				putch(' ', putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	6a 20                	push   $0x20
  8005a6:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8005a8:	83 ef 01             	sub    $0x1,%edi
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	85 ff                	test   %edi,%edi
  8005b0:	7f ee                	jg     8005a0 <vprintfmt+0x21b>
  8005b2:	eb 6f                	jmp    800623 <vprintfmt+0x29e>
  8005b4:	89 cf                	mov    %ecx,%edi
  8005b6:	eb f6                	jmp    8005ae <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005b8:	89 ca                	mov    %ecx,%edx
  8005ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8005bd:	e8 55 fd ff ff       	call   800317 <getint>
  8005c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c8:	85 d2                	test   %edx,%edx
  8005ca:	78 0b                	js     8005d7 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005cc:	89 d1                	mov    %edx,%ecx
  8005ce:	89 c2                	mov    %eax,%edx
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d5:	eb 32                	jmp    800609 <vprintfmt+0x284>
				putch('-', putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	56                   	push   %esi
  8005db:	6a 2d                	push   $0x2d
  8005dd:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e5:	f7 da                	neg    %edx
  8005e7:	83 d1 00             	adc    $0x0,%ecx
  8005ea:	f7 d9                	neg    %ecx
  8005ec:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f4:	eb 13                	jmp    800609 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005f6:	89 ca                	mov    %ecx,%edx
  8005f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fb:	e8 e3 fc ff ff       	call   8002e3 <getuint>
  800600:	89 d1                	mov    %edx,%ecx
  800602:	89 c2                	mov    %eax,%edx
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800610:	57                   	push   %edi
  800611:	ff 75 e0             	pushl  -0x20(%ebp)
  800614:	50                   	push   %eax
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	89 f2                	mov    %esi,%edx
  800619:	89 d8                	mov    %ebx,%eax
  80061b:	e8 1a fc ff ff       	call   80023a <printnum>
			break;
  800620:	83 c4 20             	add    $0x20,%esp
{
  800623:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800626:	83 c7 01             	add    $0x1,%edi
  800629:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062d:	83 f8 25             	cmp    $0x25,%eax
  800630:	0f 84 6a fd ff ff    	je     8003a0 <vprintfmt+0x1b>
			if (ch == '\0')
  800636:	85 c0                	test   %eax,%eax
  800638:	0f 84 93 00 00 00    	je     8006d1 <vprintfmt+0x34c>
			putch(ch, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	56                   	push   %esi
  800642:	50                   	push   %eax
  800643:	ff d3                	call   *%ebx
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb dc                	jmp    800626 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80064a:	89 ca                	mov    %ecx,%edx
  80064c:	8d 45 14             	lea    0x14(%ebp),%eax
  80064f:	e8 8f fc ff ff       	call   8002e3 <getuint>
  800654:	89 d1                	mov    %edx,%ecx
  800656:	89 c2                	mov    %eax,%edx
			base = 8;
  800658:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  80065d:	eb aa                	jmp    800609 <vprintfmt+0x284>
			putch('0', putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	56                   	push   %esi
  800663:	6a 30                	push   $0x30
  800665:	ff d3                	call   *%ebx
			putch('x', putdat);
  800667:	83 c4 08             	add    $0x8,%esp
  80066a:	56                   	push   %esi
  80066b:	6a 78                	push   $0x78
  80066d:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 50 04             	lea    0x4(%eax),%edx
  800675:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800678:	8b 10                	mov    (%eax),%edx
  80067a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80067f:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800682:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800687:	eb 80                	jmp    800609 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800689:	89 ca                	mov    %ecx,%edx
  80068b:	8d 45 14             	lea    0x14(%ebp),%eax
  80068e:	e8 50 fc ff ff       	call   8002e3 <getuint>
  800693:	89 d1                	mov    %edx,%ecx
  800695:	89 c2                	mov    %eax,%edx
			base = 16;
  800697:	b8 10 00 00 00       	mov    $0x10,%eax
  80069c:	e9 68 ff ff ff       	jmp    800609 <vprintfmt+0x284>
			putch(ch, putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	56                   	push   %esi
  8006a5:	6a 25                	push   $0x25
  8006a7:	ff d3                	call   *%ebx
			break;
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	e9 72 ff ff ff       	jmp    800623 <vprintfmt+0x29e>
			putch('%', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	56                   	push   %esi
  8006b5:	6a 25                	push   $0x25
  8006b7:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	89 f8                	mov    %edi,%eax
  8006be:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c2:	74 05                	je     8006c9 <vprintfmt+0x344>
  8006c4:	83 e8 01             	sub    $0x1,%eax
  8006c7:	eb f5                	jmp    8006be <vprintfmt+0x339>
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cc:	e9 52 ff ff ff       	jmp    800623 <vprintfmt+0x29e>
}
  8006d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d4:	5b                   	pop    %ebx
  8006d5:	5e                   	pop    %esi
  8006d6:	5f                   	pop    %edi
  8006d7:	5d                   	pop    %ebp
  8006d8:	c3                   	ret    

008006d9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d9:	f3 0f 1e fb          	endbr32 
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	74 26                	je     800724 <vsnprintf+0x4b>
  8006fe:	85 d2                	test   %edx,%edx
  800700:	7e 22                	jle    800724 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800702:	ff 75 14             	pushl  0x14(%ebp)
  800705:	ff 75 10             	pushl  0x10(%ebp)
  800708:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 43 03 80 00       	push   $0x800343
  800711:	e8 6f fc ff ff       	call   800385 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800719:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071f:	83 c4 10             	add    $0x10,%esp
}
  800722:	c9                   	leave  
  800723:	c3                   	ret    
		return -E_INVAL;
  800724:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800729:	eb f7                	jmp    800722 <vsnprintf+0x49>

0080072b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072b:	f3 0f 1e fb          	endbr32 
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800738:	50                   	push   %eax
  800739:	ff 75 10             	pushl  0x10(%ebp)
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	e8 92 ff ff ff       	call   8006d9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800749:	f3 0f 1e fb          	endbr32 
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80075c:	74 05                	je     800763 <strlen+0x1a>
		n++;
  80075e:	83 c0 01             	add    $0x1,%eax
  800761:	eb f5                	jmp    800758 <strlen+0xf>
	return n;
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800765:	f3 0f 1e fb          	endbr32 
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800772:	b8 00 00 00 00       	mov    $0x0,%eax
  800777:	39 d0                	cmp    %edx,%eax
  800779:	74 0d                	je     800788 <strnlen+0x23>
  80077b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80077f:	74 05                	je     800786 <strnlen+0x21>
		n++;
  800781:	83 c0 01             	add    $0x1,%eax
  800784:	eb f1                	jmp    800777 <strnlen+0x12>
  800786:	89 c2                	mov    %eax,%edx
	return n;
}
  800788:	89 d0                	mov    %edx,%eax
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80078c:	f3 0f 1e fb          	endbr32 
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	53                   	push   %ebx
  800794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800797:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007a3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007a6:	83 c0 01             	add    $0x1,%eax
  8007a9:	84 d2                	test   %dl,%dl
  8007ab:	75 f2                	jne    80079f <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007ad:	89 c8                	mov    %ecx,%eax
  8007af:	5b                   	pop    %ebx
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b2:	f3 0f 1e fb          	endbr32 
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	53                   	push   %ebx
  8007ba:	83 ec 10             	sub    $0x10,%esp
  8007bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c0:	53                   	push   %ebx
  8007c1:	e8 83 ff ff ff       	call   800749 <strlen>
  8007c6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	01 d8                	add    %ebx,%eax
  8007ce:	50                   	push   %eax
  8007cf:	e8 b8 ff ff ff       	call   80078c <strcpy>
	return dst;
}
  8007d4:	89 d8                	mov    %ebx,%eax
  8007d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    

008007db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007db:	f3 0f 1e fb          	endbr32 
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	56                   	push   %esi
  8007e3:	53                   	push   %ebx
  8007e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ea:	89 f3                	mov    %esi,%ebx
  8007ec:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ef:	89 f0                	mov    %esi,%eax
  8007f1:	39 d8                	cmp    %ebx,%eax
  8007f3:	74 11                	je     800806 <strncpy+0x2b>
		*dst++ = *src;
  8007f5:	83 c0 01             	add    $0x1,%eax
  8007f8:	0f b6 0a             	movzbl (%edx),%ecx
  8007fb:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007fe:	80 f9 01             	cmp    $0x1,%cl
  800801:	83 da ff             	sbb    $0xffffffff,%edx
  800804:	eb eb                	jmp    8007f1 <strncpy+0x16>
	}
	return ret;
}
  800806:	89 f0                	mov    %esi,%eax
  800808:	5b                   	pop    %ebx
  800809:	5e                   	pop    %esi
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080c:	f3 0f 1e fb          	endbr32 
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	56                   	push   %esi
  800814:	53                   	push   %ebx
  800815:	8b 75 08             	mov    0x8(%ebp),%esi
  800818:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081b:	8b 55 10             	mov    0x10(%ebp),%edx
  80081e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800820:	85 d2                	test   %edx,%edx
  800822:	74 21                	je     800845 <strlcpy+0x39>
  800824:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800828:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80082a:	39 c2                	cmp    %eax,%edx
  80082c:	74 14                	je     800842 <strlcpy+0x36>
  80082e:	0f b6 19             	movzbl (%ecx),%ebx
  800831:	84 db                	test   %bl,%bl
  800833:	74 0b                	je     800840 <strlcpy+0x34>
			*dst++ = *src++;
  800835:	83 c1 01             	add    $0x1,%ecx
  800838:	83 c2 01             	add    $0x1,%edx
  80083b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80083e:	eb ea                	jmp    80082a <strlcpy+0x1e>
  800840:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800842:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800845:	29 f0                	sub    %esi,%eax
}
  800847:	5b                   	pop    %ebx
  800848:	5e                   	pop    %esi
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084b:	f3 0f 1e fb          	endbr32 
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800858:	0f b6 01             	movzbl (%ecx),%eax
  80085b:	84 c0                	test   %al,%al
  80085d:	74 0c                	je     80086b <strcmp+0x20>
  80085f:	3a 02                	cmp    (%edx),%al
  800861:	75 08                	jne    80086b <strcmp+0x20>
		p++, q++;
  800863:	83 c1 01             	add    $0x1,%ecx
  800866:	83 c2 01             	add    $0x1,%edx
  800869:	eb ed                	jmp    800858 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086b:	0f b6 c0             	movzbl %al,%eax
  80086e:	0f b6 12             	movzbl (%edx),%edx
  800871:	29 d0                	sub    %edx,%eax
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800875:	f3 0f 1e fb          	endbr32 
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 55 0c             	mov    0xc(%ebp),%edx
  800883:	89 c3                	mov    %eax,%ebx
  800885:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800888:	eb 06                	jmp    800890 <strncmp+0x1b>
		n--, p++, q++;
  80088a:	83 c0 01             	add    $0x1,%eax
  80088d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800890:	39 d8                	cmp    %ebx,%eax
  800892:	74 16                	je     8008aa <strncmp+0x35>
  800894:	0f b6 08             	movzbl (%eax),%ecx
  800897:	84 c9                	test   %cl,%cl
  800899:	74 04                	je     80089f <strncmp+0x2a>
  80089b:	3a 0a                	cmp    (%edx),%cl
  80089d:	74 eb                	je     80088a <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80089f:	0f b6 00             	movzbl (%eax),%eax
  8008a2:	0f b6 12             	movzbl (%edx),%edx
  8008a5:	29 d0                	sub    %edx,%eax
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    
		return 0;
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008af:	eb f6                	jmp    8008a7 <strncmp+0x32>

008008b1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b1:	f3 0f 1e fb          	endbr32 
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008bf:	0f b6 10             	movzbl (%eax),%edx
  8008c2:	84 d2                	test   %dl,%dl
  8008c4:	74 09                	je     8008cf <strchr+0x1e>
		if (*s == c)
  8008c6:	38 ca                	cmp    %cl,%dl
  8008c8:	74 0a                	je     8008d4 <strchr+0x23>
	for (; *s; s++)
  8008ca:	83 c0 01             	add    $0x1,%eax
  8008cd:	eb f0                	jmp    8008bf <strchr+0xe>
			return (char *) s;
	return 0;
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d6:	f3 0f 1e fb          	endbr32 
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e7:	38 ca                	cmp    %cl,%dl
  8008e9:	74 09                	je     8008f4 <strfind+0x1e>
  8008eb:	84 d2                	test   %dl,%dl
  8008ed:	74 05                	je     8008f4 <strfind+0x1e>
	for (; *s; s++)
  8008ef:	83 c0 01             	add    $0x1,%eax
  8008f2:	eb f0                	jmp    8008e4 <strfind+0xe>
			break;
	return (char *) s;
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f6:	f3 0f 1e fb          	endbr32 
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	57                   	push   %edi
  8008fe:	56                   	push   %esi
  8008ff:	53                   	push   %ebx
  800900:	8b 55 08             	mov    0x8(%ebp),%edx
  800903:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800906:	85 c9                	test   %ecx,%ecx
  800908:	74 33                	je     80093d <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80090a:	89 d0                	mov    %edx,%eax
  80090c:	09 c8                	or     %ecx,%eax
  80090e:	a8 03                	test   $0x3,%al
  800910:	75 23                	jne    800935 <memset+0x3f>
		c &= 0xFF;
  800912:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800916:	89 d8                	mov    %ebx,%eax
  800918:	c1 e0 08             	shl    $0x8,%eax
  80091b:	89 df                	mov    %ebx,%edi
  80091d:	c1 e7 18             	shl    $0x18,%edi
  800920:	89 de                	mov    %ebx,%esi
  800922:	c1 e6 10             	shl    $0x10,%esi
  800925:	09 f7                	or     %esi,%edi
  800927:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800929:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092c:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80092e:	89 d7                	mov    %edx,%edi
  800930:	fc                   	cld    
  800931:	f3 ab                	rep stos %eax,%es:(%edi)
  800933:	eb 08                	jmp    80093d <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800935:	89 d7                	mov    %edx,%edi
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	fc                   	cld    
  80093b:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80093d:	89 d0                	mov    %edx,%eax
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5f                   	pop    %edi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	57                   	push   %edi
  80094c:	56                   	push   %esi
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 75 0c             	mov    0xc(%ebp),%esi
  800953:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800956:	39 c6                	cmp    %eax,%esi
  800958:	73 32                	jae    80098c <memmove+0x48>
  80095a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	76 2b                	jbe    80098c <memmove+0x48>
		s += n;
		d += n;
  800961:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800964:	89 fe                	mov    %edi,%esi
  800966:	09 ce                	or     %ecx,%esi
  800968:	09 d6                	or     %edx,%esi
  80096a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800970:	75 0e                	jne    800980 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800972:	83 ef 04             	sub    $0x4,%edi
  800975:	8d 72 fc             	lea    -0x4(%edx),%esi
  800978:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80097b:	fd                   	std    
  80097c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097e:	eb 09                	jmp    800989 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800980:	83 ef 01             	sub    $0x1,%edi
  800983:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800986:	fd                   	std    
  800987:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800989:	fc                   	cld    
  80098a:	eb 1a                	jmp    8009a6 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098c:	89 c2                	mov    %eax,%edx
  80098e:	09 ca                	or     %ecx,%edx
  800990:	09 f2                	or     %esi,%edx
  800992:	f6 c2 03             	test   $0x3,%dl
  800995:	75 0a                	jne    8009a1 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800997:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80099a:	89 c7                	mov    %eax,%edi
  80099c:	fc                   	cld    
  80099d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099f:	eb 05                	jmp    8009a6 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009a1:	89 c7                	mov    %eax,%edi
  8009a3:	fc                   	cld    
  8009a4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a6:	5e                   	pop    %esi
  8009a7:	5f                   	pop    %edi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009aa:	f3 0f 1e fb          	endbr32 
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009b4:	ff 75 10             	pushl  0x10(%ebp)
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 82 ff ff ff       	call   800944 <memmove>
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009c4:	f3 0f 1e fb          	endbr32 
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d3:	89 c6                	mov    %eax,%esi
  8009d5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d8:	39 f0                	cmp    %esi,%eax
  8009da:	74 1c                	je     8009f8 <memcmp+0x34>
		if (*s1 != *s2)
  8009dc:	0f b6 08             	movzbl (%eax),%ecx
  8009df:	0f b6 1a             	movzbl (%edx),%ebx
  8009e2:	38 d9                	cmp    %bl,%cl
  8009e4:	75 08                	jne    8009ee <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	eb ea                	jmp    8009d8 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009ee:	0f b6 c1             	movzbl %cl,%eax
  8009f1:	0f b6 db             	movzbl %bl,%ebx
  8009f4:	29 d8                	sub    %ebx,%eax
  8009f6:	eb 05                	jmp    8009fd <memcmp+0x39>
	}

	return 0;
  8009f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a0e:	89 c2                	mov    %eax,%edx
  800a10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a13:	39 d0                	cmp    %edx,%eax
  800a15:	73 09                	jae    800a20 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a17:	38 08                	cmp    %cl,(%eax)
  800a19:	74 05                	je     800a20 <memfind+0x1f>
	for (; s < ends; s++)
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	eb f3                	jmp    800a13 <memfind+0x12>
			break;
	return (void *) s;
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a22:	f3 0f 1e fb          	endbr32 
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	53                   	push   %ebx
  800a2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a32:	eb 03                	jmp    800a37 <strtol+0x15>
		s++;
  800a34:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a37:	0f b6 01             	movzbl (%ecx),%eax
  800a3a:	3c 20                	cmp    $0x20,%al
  800a3c:	74 f6                	je     800a34 <strtol+0x12>
  800a3e:	3c 09                	cmp    $0x9,%al
  800a40:	74 f2                	je     800a34 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a42:	3c 2b                	cmp    $0x2b,%al
  800a44:	74 2a                	je     800a70 <strtol+0x4e>
	int neg = 0;
  800a46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4b:	3c 2d                	cmp    $0x2d,%al
  800a4d:	74 2b                	je     800a7a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a55:	75 0f                	jne    800a66 <strtol+0x44>
  800a57:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5a:	74 28                	je     800a84 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a5c:	85 db                	test   %ebx,%ebx
  800a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a63:	0f 44 d8             	cmove  %eax,%ebx
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a6e:	eb 46                	jmp    800ab6 <strtol+0x94>
		s++;
  800a70:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a73:	bf 00 00 00 00       	mov    $0x0,%edi
  800a78:	eb d5                	jmp    800a4f <strtol+0x2d>
		s++, neg = 1;
  800a7a:	83 c1 01             	add    $0x1,%ecx
  800a7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a82:	eb cb                	jmp    800a4f <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a84:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a88:	74 0e                	je     800a98 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a8a:	85 db                	test   %ebx,%ebx
  800a8c:	75 d8                	jne    800a66 <strtol+0x44>
		s++, base = 8;
  800a8e:	83 c1 01             	add    $0x1,%ecx
  800a91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a96:	eb ce                	jmp    800a66 <strtol+0x44>
		s += 2, base = 16;
  800a98:	83 c1 02             	add    $0x2,%ecx
  800a9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa0:	eb c4                	jmp    800a66 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aa2:	0f be d2             	movsbl %dl,%edx
  800aa5:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aa8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aab:	7d 3a                	jge    800ae7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aad:	83 c1 01             	add    $0x1,%ecx
  800ab0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab6:	0f b6 11             	movzbl (%ecx),%edx
  800ab9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800abc:	89 f3                	mov    %esi,%ebx
  800abe:	80 fb 09             	cmp    $0x9,%bl
  800ac1:	76 df                	jbe    800aa2 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ac3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac6:	89 f3                	mov    %esi,%ebx
  800ac8:	80 fb 19             	cmp    $0x19,%bl
  800acb:	77 08                	ja     800ad5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800acd:	0f be d2             	movsbl %dl,%edx
  800ad0:	83 ea 57             	sub    $0x57,%edx
  800ad3:	eb d3                	jmp    800aa8 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ad5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ad8:	89 f3                	mov    %esi,%ebx
  800ada:	80 fb 19             	cmp    $0x19,%bl
  800add:	77 08                	ja     800ae7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800adf:	0f be d2             	movsbl %dl,%edx
  800ae2:	83 ea 37             	sub    $0x37,%edx
  800ae5:	eb c1                	jmp    800aa8 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ae7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aeb:	74 05                	je     800af2 <strtol+0xd0>
		*endptr = (char *) s;
  800aed:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	f7 da                	neg    %edx
  800af6:	85 ff                	test   %edi,%edi
  800af8:	0f 45 c2             	cmovne %edx,%eax
}
  800afb:	5b                   	pop    %ebx
  800afc:	5e                   	pop    %esi
  800afd:	5f                   	pop    %edi
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	57                   	push   %edi
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	83 ec 1c             	sub    $0x1c,%esp
  800b09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b0f:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b17:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b1a:	8b 75 14             	mov    0x14(%ebp),%esi
  800b1d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b23:	74 04                	je     800b29 <syscall+0x29>
  800b25:	85 c0                	test   %eax,%eax
  800b27:	7f 08                	jg     800b31 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b2c:	5b                   	pop    %ebx
  800b2d:	5e                   	pop    %esi
  800b2e:	5f                   	pop    %edi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b31:	83 ec 0c             	sub    $0xc,%esp
  800b34:	50                   	push   %eax
  800b35:	ff 75 e0             	pushl  -0x20(%ebp)
  800b38:	68 9f 24 80 00       	push   $0x80249f
  800b3d:	6a 23                	push   $0x23
  800b3f:	68 bc 24 80 00       	push   $0x8024bc
  800b44:	e8 13 12 00 00       	call   801d5c <_panic>

00800b49 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b53:	6a 00                	push   $0x0
  800b55:	6a 00                	push   $0x0
  800b57:	6a 00                	push   $0x0
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	b8 00 00 00 00       	mov    $0x0,%eax
  800b69:	e8 92 ff ff ff       	call   800b00 <syscall>
}
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b73:	f3 0f 1e fb          	endbr32 
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b7d:	6a 00                	push   $0x0
  800b7f:	6a 00                	push   $0x0
  800b81:	6a 00                	push   $0x0
  800b83:	6a 00                	push   $0x0
  800b85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b94:	e8 67 ff ff ff       	call   800b00 <syscall>
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b9b:	f3 0f 1e fb          	endbr32 
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	6a 00                	push   $0x0
  800bab:	6a 00                	push   $0x0
  800bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb0:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bba:	e8 41 ff ff ff       	call   800b00 <syscall>
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc1:	f3 0f 1e fb          	endbr32 
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bcb:	6a 00                	push   $0x0
  800bcd:	6a 00                	push   $0x0
  800bcf:	6a 00                	push   $0x0
  800bd1:	6a 00                	push   $0x0
  800bd3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	b8 02 00 00 00       	mov    $0x2,%eax
  800be2:	e8 19 ff ff ff       	call   800b00 <syscall>
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <sys_yield>:

void
sys_yield(void)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 00                	push   $0x0
  800bf7:	6a 00                	push   $0x0
  800bf9:	6a 00                	push   $0x0
  800bfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c00:	ba 00 00 00 00       	mov    $0x0,%edx
  800c05:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0a:	e8 f1 fe ff ff       	call   800b00 <syscall>
}
  800c0f:	83 c4 10             	add    $0x10,%esp
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c14:	f3 0f 1e fb          	endbr32 
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c1e:	6a 00                	push   $0x0
  800c20:	6a 00                	push   $0x0
  800c22:	ff 75 10             	pushl  0x10(%ebp)
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c30:	b8 04 00 00 00       	mov    $0x4,%eax
  800c35:	e8 c6 fe ff ff       	call   800b00 <syscall>
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c46:	ff 75 18             	pushl  0x18(%ebp)
  800c49:	ff 75 14             	pushl  0x14(%ebp)
  800c4c:	ff 75 10             	pushl  0x10(%ebp)
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c55:	ba 01 00 00 00       	mov    $0x1,%edx
  800c5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5f:	e8 9c fe ff ff       	call   800b00 <syscall>
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c70:	6a 00                	push   $0x0
  800c72:	6a 00                	push   $0x0
  800c74:	6a 00                	push   $0x0
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c81:	b8 06 00 00 00       	mov    $0x6,%eax
  800c86:	e8 75 fe ff ff       	call   800b00 <syscall>
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c8d:	f3 0f 1e fb          	endbr32 
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c97:	6a 00                	push   $0x0
  800c99:	6a 00                	push   $0x0
  800c9b:	6a 00                	push   $0x0
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca3:	ba 01 00 00 00       	mov    $0x1,%edx
  800ca8:	b8 08 00 00 00       	mov    $0x8,%eax
  800cad:	e8 4e fe ff ff       	call   800b00 <syscall>
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb4:	f3 0f 1e fb          	endbr32 
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cbe:	6a 00                	push   $0x0
  800cc0:	6a 00                	push   $0x0
  800cc2:	6a 00                	push   $0x0
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cca:	ba 01 00 00 00       	mov    $0x1,%edx
  800ccf:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd4:	e8 27 fe ff ff       	call   800b00 <syscall>
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ce5:	6a 00                	push   $0x0
  800ce7:	6a 00                	push   $0x0
  800ce9:	6a 00                	push   $0x0
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf1:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfb:	e8 00 fe ff ff       	call   800b00 <syscall>
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d0c:	6a 00                	push   $0x0
  800d0e:	ff 75 14             	pushl  0x14(%ebp)
  800d11:	ff 75 10             	pushl  0x10(%ebp)
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d24:	e8 d7 fd ff ff       	call   800b00 <syscall>
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d35:	6a 00                	push   $0x0
  800d37:	6a 00                	push   $0x0
  800d39:	6a 00                	push   $0x0
  800d3b:	6a 00                	push   $0x0
  800d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d40:	ba 01 00 00 00       	mov    $0x1,%edx
  800d45:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d4a:	e8 b1 fd ff ff       	call   800b00 <syscall>
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800d51:	f3 0f 1e fb          	endbr32 
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800d61:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800d63:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800d66:	83 3a 01             	cmpl   $0x1,(%edx)
  800d69:	7e 09                	jle    800d74 <argstart+0x23>
  800d6b:	ba 23 26 80 00       	mov    $0x802623,%edx
  800d70:	85 c9                	test   %ecx,%ecx
  800d72:	75 05                	jne    800d79 <argstart+0x28>
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800d7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <argnext>:

int
argnext(struct Argstate *args)
{
  800d85:	f3 0f 1e fb          	endbr32 
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800d93:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800d9a:	8b 43 08             	mov    0x8(%ebx),%eax
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	74 74                	je     800e15 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  800da1:	80 38 00             	cmpb   $0x0,(%eax)
  800da4:	75 48                	jne    800dee <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800da6:	8b 0b                	mov    (%ebx),%ecx
  800da8:	83 39 01             	cmpl   $0x1,(%ecx)
  800dab:	74 5a                	je     800e07 <argnext+0x82>
		    || args->argv[1][0] != '-'
  800dad:	8b 53 04             	mov    0x4(%ebx),%edx
  800db0:	8b 42 04             	mov    0x4(%edx),%eax
  800db3:	80 38 2d             	cmpb   $0x2d,(%eax)
  800db6:	75 4f                	jne    800e07 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  800db8:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800dbc:	74 49                	je     800e07 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800dbe:	83 c0 01             	add    $0x1,%eax
  800dc1:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800dc4:	83 ec 04             	sub    $0x4,%esp
  800dc7:	8b 01                	mov    (%ecx),%eax
  800dc9:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800dd0:	50                   	push   %eax
  800dd1:	8d 42 08             	lea    0x8(%edx),%eax
  800dd4:	50                   	push   %eax
  800dd5:	83 c2 04             	add    $0x4,%edx
  800dd8:	52                   	push   %edx
  800dd9:	e8 66 fb ff ff       	call   800944 <memmove>
		(*args->argc)--;
  800dde:	8b 03                	mov    (%ebx),%eax
  800de0:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800de3:	8b 43 08             	mov    0x8(%ebx),%eax
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	80 38 2d             	cmpb   $0x2d,(%eax)
  800dec:	74 13                	je     800e01 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800dee:	8b 43 08             	mov    0x8(%ebx),%eax
  800df1:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800df4:	83 c0 01             	add    $0x1,%eax
  800df7:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800dfa:	89 d0                	mov    %edx,%eax
  800dfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e01:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e05:	75 e7                	jne    800dee <argnext+0x69>
	args->curarg = 0;
  800e07:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800e0e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800e13:	eb e5                	jmp    800dfa <argnext+0x75>
		return -1;
  800e15:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800e1a:	eb de                	jmp    800dfa <argnext+0x75>

00800e1c <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800e1c:	f3 0f 1e fb          	endbr32 
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	53                   	push   %ebx
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800e2a:	8b 43 08             	mov    0x8(%ebx),%eax
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	74 12                	je     800e43 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  800e31:	80 38 00             	cmpb   $0x0,(%eax)
  800e34:	74 12                	je     800e48 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  800e36:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800e39:	c7 43 08 23 26 80 00 	movl   $0x802623,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800e40:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    
	} else if (*args->argc > 1) {
  800e48:	8b 13                	mov    (%ebx),%edx
  800e4a:	83 3a 01             	cmpl   $0x1,(%edx)
  800e4d:	7f 10                	jg     800e5f <argnextvalue+0x43>
		args->argvalue = 0;
  800e4f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800e56:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800e5d:	eb e1                	jmp    800e40 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  800e5f:	8b 43 04             	mov    0x4(%ebx),%eax
  800e62:	8b 48 04             	mov    0x4(%eax),%ecx
  800e65:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 12                	mov    (%edx),%edx
  800e6d:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800e74:	52                   	push   %edx
  800e75:	8d 50 08             	lea    0x8(%eax),%edx
  800e78:	52                   	push   %edx
  800e79:	83 c0 04             	add    $0x4,%eax
  800e7c:	50                   	push   %eax
  800e7d:	e8 c2 fa ff ff       	call   800944 <memmove>
		(*args->argc)--;
  800e82:	8b 03                	mov    (%ebx),%eax
  800e84:	83 28 01             	subl   $0x1,(%eax)
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	eb b4                	jmp    800e40 <argnextvalue+0x24>

00800e8c <argvalue>:
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800e99:	8b 42 0c             	mov    0xc(%edx),%eax
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	74 02                	je     800ea2 <argvalue+0x16>
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	52                   	push   %edx
  800ea6:	e8 71 ff ff ff       	call   800e1c <argnextvalue>
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	eb f0                	jmp    800ea0 <argvalue+0x14>

00800eb0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eb0:	f3 0f 1e fb          	endbr32 
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	05 00 00 00 30       	add    $0x30000000,%eax
  800ebf:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec4:	f3 0f 1e fb          	endbr32 
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800ece:	ff 75 08             	pushl  0x8(%ebp)
  800ed1:	e8 da ff ff ff       	call   800eb0 <fd2num>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	c1 e0 0c             	shl    $0xc,%eax
  800edc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee3:	f3 0f 1e fb          	endbr32 
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	c1 ea 16             	shr    $0x16,%edx
  800ef4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800efb:	f6 c2 01             	test   $0x1,%dl
  800efe:	74 2d                	je     800f2d <fd_alloc+0x4a>
  800f00:	89 c2                	mov    %eax,%edx
  800f02:	c1 ea 0c             	shr    $0xc,%edx
  800f05:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0c:	f6 c2 01             	test   $0x1,%dl
  800f0f:	74 1c                	je     800f2d <fd_alloc+0x4a>
  800f11:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f16:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f1b:	75 d2                	jne    800eef <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f26:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f2b:	eb 0a                	jmp    800f37 <fd_alloc+0x54>
			*fd_store = fd;
  800f2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f30:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f39:	f3 0f 1e fb          	endbr32 
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f43:	83 f8 1f             	cmp    $0x1f,%eax
  800f46:	77 30                	ja     800f78 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f48:	c1 e0 0c             	shl    $0xc,%eax
  800f4b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f50:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f56:	f6 c2 01             	test   $0x1,%dl
  800f59:	74 24                	je     800f7f <fd_lookup+0x46>
  800f5b:	89 c2                	mov    %eax,%edx
  800f5d:	c1 ea 0c             	shr    $0xc,%edx
  800f60:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f67:	f6 c2 01             	test   $0x1,%dl
  800f6a:	74 1a                	je     800f86 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6f:	89 02                	mov    %eax,(%edx)
	return 0;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
		return -E_INVAL;
  800f78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7d:	eb f7                	jmp    800f76 <fd_lookup+0x3d>
		return -E_INVAL;
  800f7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f84:	eb f0                	jmp    800f76 <fd_lookup+0x3d>
  800f86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f8b:	eb e9                	jmp    800f76 <fd_lookup+0x3d>

00800f8d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f8d:	f3 0f 1e fb          	endbr32 
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f9a:	ba 48 25 80 00       	mov    $0x802548,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f9f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fa4:	39 08                	cmp    %ecx,(%eax)
  800fa6:	74 33                	je     800fdb <dev_lookup+0x4e>
  800fa8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fab:	8b 02                	mov    (%edx),%eax
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 f3                	jne    800fa4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fb1:	a1 04 40 80 00       	mov    0x804004,%eax
  800fb6:	8b 40 48             	mov    0x48(%eax),%eax
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	51                   	push   %ecx
  800fbd:	50                   	push   %eax
  800fbe:	68 cc 24 80 00       	push   $0x8024cc
  800fc3:	e8 5a f2 ff ff       	call   800222 <cprintf>
	*dev = 0;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    
			*dev = devtab[i];
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb f2                	jmp    800fd9 <dev_lookup+0x4c>

00800fe7 <fd_close>:
{
  800fe7:	f3 0f 1e fb          	endbr32 
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 28             	sub    $0x28,%esp
  800ff4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffa:	56                   	push   %esi
  800ffb:	e8 b0 fe ff ff       	call   800eb0 <fd2num>
  801000:	83 c4 08             	add    $0x8,%esp
  801003:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801006:	52                   	push   %edx
  801007:	50                   	push   %eax
  801008:	e8 2c ff ff ff       	call   800f39 <fd_lookup>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 05                	js     80101b <fd_close+0x34>
	    || fd != fd2)
  801016:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801019:	74 16                	je     801031 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80101b:	89 f8                	mov    %edi,%eax
  80101d:	84 c0                	test   %al,%al
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	0f 44 d8             	cmove  %eax,%ebx
}
  801027:	89 d8                	mov    %ebx,%eax
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	ff 36                	pushl  (%esi)
  80103a:	e8 4e ff ff ff       	call   800f8d <dev_lookup>
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	78 1a                	js     801062 <fd_close+0x7b>
		if (dev->dev_close)
  801048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801053:	85 c0                	test   %eax,%eax
  801055:	74 0b                	je     801062 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801057:	83 ec 0c             	sub    $0xc,%esp
  80105a:	56                   	push   %esi
  80105b:	ff d0                	call   *%eax
  80105d:	89 c3                	mov    %eax,%ebx
  80105f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	e8 f9 fb ff ff       	call   800c66 <sys_page_unmap>
	return r;
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	eb b5                	jmp    801027 <fd_close+0x40>

00801072 <close>:

int
close(int fdnum)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80107c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 b1 fe ff ff       	call   800f39 <fd_lookup>
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	79 02                	jns    801091 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    
		return fd_close(fd, 1);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	6a 01                	push   $0x1
  801096:	ff 75 f4             	pushl  -0xc(%ebp)
  801099:	e8 49 ff ff ff       	call   800fe7 <fd_close>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	eb ec                	jmp    80108f <close+0x1d>

008010a3 <close_all>:

void
close_all(void)
{
  8010a3:	f3 0f 1e fb          	endbr32 
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	53                   	push   %ebx
  8010b7:	e8 b6 ff ff ff       	call   801072 <close>
	for (i = 0; i < MAXFD; i++)
  8010bc:	83 c3 01             	add    $0x1,%ebx
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	83 fb 20             	cmp    $0x20,%ebx
  8010c5:	75 ec                	jne    8010b3 <close_all+0x10>
}
  8010c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010cc:	f3 0f 1e fb          	endbr32 
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	e8 54 fe ff ff       	call   800f39 <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	0f 88 81 00 00 00    	js     801173 <dup+0xa7>
		return r;
	close(newfdnum);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	e8 75 ff ff ff       	call   801072 <close>

	newfd = INDEX2FD(newfdnum);
  8010fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  801100:	c1 e6 0c             	shl    $0xc,%esi
  801103:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801109:	83 c4 04             	add    $0x4,%esp
  80110c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110f:	e8 b0 fd ff ff       	call   800ec4 <fd2data>
  801114:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801116:	89 34 24             	mov    %esi,(%esp)
  801119:	e8 a6 fd ff ff       	call   800ec4 <fd2data>
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801123:	89 d8                	mov    %ebx,%eax
  801125:	c1 e8 16             	shr    $0x16,%eax
  801128:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112f:	a8 01                	test   $0x1,%al
  801131:	74 11                	je     801144 <dup+0x78>
  801133:	89 d8                	mov    %ebx,%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80113f:	f6 c2 01             	test   $0x1,%dl
  801142:	75 39                	jne    80117d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801147:	89 d0                	mov    %edx,%eax
  801149:	c1 e8 0c             	shr    $0xc,%eax
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	25 07 0e 00 00       	and    $0xe07,%eax
  80115b:	50                   	push   %eax
  80115c:	56                   	push   %esi
  80115d:	6a 00                	push   $0x0
  80115f:	52                   	push   %edx
  801160:	6a 00                	push   $0x0
  801162:	e8 d5 fa ff ff       	call   800c3c <sys_page_map>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 31                	js     8011a1 <dup+0xd5>
		goto err;

	return newfdnum;
  801170:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80117d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	25 07 0e 00 00       	and    $0xe07,%eax
  80118c:	50                   	push   %eax
  80118d:	57                   	push   %edi
  80118e:	6a 00                	push   $0x0
  801190:	53                   	push   %ebx
  801191:	6a 00                	push   $0x0
  801193:	e8 a4 fa ff ff       	call   800c3c <sys_page_map>
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	79 a3                	jns    801144 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 ba fa ff ff       	call   800c66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	57                   	push   %edi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 af fa ff ff       	call   800c66 <sys_page_unmap>
	return r;
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	eb b7                	jmp    801173 <dup+0xa7>

008011bc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011bc:	f3 0f 1e fb          	endbr32 
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 1c             	sub    $0x1c,%esp
  8011c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cd:	50                   	push   %eax
  8011ce:	53                   	push   %ebx
  8011cf:	e8 65 fd ff ff       	call   800f39 <fd_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 3f                	js     80121a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e5:	ff 30                	pushl  (%eax)
  8011e7:	e8 a1 fd ff ff       	call   800f8d <dev_lookup>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 27                	js     80121a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f6:	8b 42 08             	mov    0x8(%edx),%eax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	83 f8 01             	cmp    $0x1,%eax
  8011ff:	74 1e                	je     80121f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	8b 40 08             	mov    0x8(%eax),%eax
  801207:	85 c0                	test   %eax,%eax
  801209:	74 35                	je     801240 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	ff 75 10             	pushl  0x10(%ebp)
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	52                   	push   %edx
  801215:	ff d0                	call   *%eax
  801217:	83 c4 10             	add    $0x10,%esp
}
  80121a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80121f:	a1 04 40 80 00       	mov    0x804004,%eax
  801224:	8b 40 48             	mov    0x48(%eax),%eax
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	53                   	push   %ebx
  80122b:	50                   	push   %eax
  80122c:	68 0d 25 80 00       	push   $0x80250d
  801231:	e8 ec ef ff ff       	call   800222 <cprintf>
		return -E_INVAL;
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123e:	eb da                	jmp    80121a <read+0x5e>
		return -E_NOT_SUPP;
  801240:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801245:	eb d3                	jmp    80121a <read+0x5e>

00801247 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	8b 7d 08             	mov    0x8(%ebp),%edi
  801257:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80125a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125f:	eb 02                	jmp    801263 <readn+0x1c>
  801261:	01 c3                	add    %eax,%ebx
  801263:	39 f3                	cmp    %esi,%ebx
  801265:	73 21                	jae    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	89 f0                	mov    %esi,%eax
  80126c:	29 d8                	sub    %ebx,%eax
  80126e:	50                   	push   %eax
  80126f:	89 d8                	mov    %ebx,%eax
  801271:	03 45 0c             	add    0xc(%ebp),%eax
  801274:	50                   	push   %eax
  801275:	57                   	push   %edi
  801276:	e8 41 ff ff ff       	call   8011bc <read>
		if (m < 0)
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 04                	js     801286 <readn+0x3f>
			return m;
		if (m == 0)
  801282:	75 dd                	jne    801261 <readn+0x1a>
  801284:	eb 02                	jmp    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801286:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5f                   	pop    %edi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 1c             	sub    $0x1c,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	53                   	push   %ebx
  8012a5:	e8 8f fc ff ff       	call   800f39 <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 3a                	js     8012eb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	ff 30                	pushl  (%eax)
  8012bd:	e8 cb fc ff ff       	call   800f8d <dev_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 22                	js     8012eb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d0:	74 1e                	je     8012f0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8012d8:	85 d2                	test   %edx,%edx
  8012da:	74 35                	je     801311 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012dc:	83 ec 04             	sub    $0x4,%esp
  8012df:	ff 75 10             	pushl  0x10(%ebp)
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	ff d2                	call   *%edx
  8012e8:	83 c4 10             	add    $0x10,%esp
}
  8012eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8012f5:	8b 40 48             	mov    0x48(%eax),%eax
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	50                   	push   %eax
  8012fd:	68 29 25 80 00       	push   $0x802529
  801302:	e8 1b ef ff ff       	call   800222 <cprintf>
		return -E_INVAL;
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb da                	jmp    8012eb <write+0x59>
		return -E_NOT_SUPP;
  801311:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801316:	eb d3                	jmp    8012eb <write+0x59>

00801318 <seek>:

int
seek(int fdnum, off_t offset)
{
  801318:	f3 0f 1e fb          	endbr32 
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	e8 0b fc ff ff       	call   800f39 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 0e                	js     801343 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801345:	f3 0f 1e fb          	endbr32 
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	53                   	push   %ebx
  80134d:	83 ec 1c             	sub    $0x1c,%esp
  801350:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801353:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	53                   	push   %ebx
  801358:	e8 dc fb ff ff       	call   800f39 <fd_lookup>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 37                	js     80139b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136e:	ff 30                	pushl  (%eax)
  801370:	e8 18 fc ff ff       	call   800f8d <dev_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 1f                	js     80139b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801383:	74 1b                	je     8013a0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 52 18             	mov    0x18(%edx),%edx
  80138b:	85 d2                	test   %edx,%edx
  80138d:	74 32                	je     8013c1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	ff d2                	call   *%edx
  801398:	83 c4 10             	add    $0x10,%esp
}
  80139b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013a0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a5:	8b 40 48             	mov    0x48(%eax),%eax
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	53                   	push   %ebx
  8013ac:	50                   	push   %eax
  8013ad:	68 ec 24 80 00       	push   $0x8024ec
  8013b2:	e8 6b ee ff ff       	call   800222 <cprintf>
		return -E_INVAL;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bf:	eb da                	jmp    80139b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c6:	eb d3                	jmp    80139b <ftruncate+0x56>

008013c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013c8:	f3 0f 1e fb          	endbr32 
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 1c             	sub    $0x1c,%esp
  8013d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 57 fb ff ff       	call   800f39 <fd_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 4b                	js     801434 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e9:	83 ec 08             	sub    $0x8,%esp
  8013ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	ff 30                	pushl  (%eax)
  8013f5:	e8 93 fb ff ff       	call   800f8d <dev_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 33                	js     801434 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801404:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801408:	74 2f                	je     801439 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80140a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80140d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801414:	00 00 00 
	stat->st_isdir = 0;
  801417:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80141e:	00 00 00 
	stat->st_dev = dev;
  801421:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	53                   	push   %ebx
  80142b:	ff 75 f0             	pushl  -0x10(%ebp)
  80142e:	ff 50 14             	call   *0x14(%eax)
  801431:	83 c4 10             	add    $0x10,%esp
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    
		return -E_NOT_SUPP;
  801439:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143e:	eb f4                	jmp    801434 <fstat+0x6c>

00801440 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801440:	f3 0f 1e fb          	endbr32 
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	6a 00                	push   $0x0
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 3a 02 00 00       	call   801690 <open>
  801456:	89 c3                	mov    %eax,%ebx
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 1b                	js     80147a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	e8 5d ff ff ff       	call   8013c8 <fstat>
  80146b:	89 c6                	mov    %eax,%esi
	close(fd);
  80146d:	89 1c 24             	mov    %ebx,(%esp)
  801470:	e8 fd fb ff ff       	call   801072 <close>
	return r;
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	89 f3                	mov    %esi,%ebx
}
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	89 c6                	mov    %eax,%esi
  80148a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80148c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801493:	74 27                	je     8014bc <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801495:	6a 07                	push   $0x7
  801497:	68 00 50 80 00       	push   $0x805000
  80149c:	56                   	push   %esi
  80149d:	ff 35 00 40 80 00    	pushl  0x804000
  8014a3:	e8 6b 09 00 00       	call   801e13 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014a8:	83 c4 0c             	add    $0xc,%esp
  8014ab:	6a 00                	push   $0x0
  8014ad:	53                   	push   %ebx
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 f1 08 00 00       	call   801da6 <ipc_recv>
}
  8014b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a 01                	push   $0x1
  8014c1:	e8 a5 09 00 00       	call   801e6b <ipc_find_env>
  8014c6:	a3 00 40 80 00       	mov    %eax,0x804000
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb c5                	jmp    801495 <fsipc+0x12>

008014d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014d0:	f3 0f 1e fb          	endbr32 
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8014f7:	e8 87 ff ff ff       	call   801483 <fsipc>
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <devfile_flush>:
{
  8014fe:	f3 0f 1e fb          	endbr32 
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 40 0c             	mov    0xc(%eax),%eax
  80150e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 06 00 00 00       	mov    $0x6,%eax
  80151d:	e8 61 ff ff ff       	call   801483 <fsipc>
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <devfile_stat>:
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	53                   	push   %ebx
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8b 40 0c             	mov    0xc(%eax),%eax
  801538:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	b8 05 00 00 00       	mov    $0x5,%eax
  801547:	e8 37 ff ff ff       	call   801483 <fsipc>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 2c                	js     80157c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	68 00 50 80 00       	push   $0x805000
  801558:	53                   	push   %ebx
  801559:	e8 2e f2 ff ff       	call   80078c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80155e:	a1 80 50 80 00       	mov    0x805080,%eax
  801563:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801569:	a1 84 50 80 00       	mov    0x805084,%eax
  80156e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <devfile_write>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8b 40 0c             	mov    0xc(%eax),%eax
  801595:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80159a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015a0:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015a6:	77 30                	ja     8015d8 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	53                   	push   %ebx
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	68 08 50 80 00       	push   $0x805008
  8015b4:	e8 8b f3 ff ff       	call   800944 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b8 04 00 00 00       	mov    $0x4,%eax
  8015c3:	e8 bb fe ff ff       	call   801483 <fsipc>
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 04                	js     8015d3 <devfile_write+0x52>
	assert(r <= n);
  8015cf:	39 d8                	cmp    %ebx,%eax
  8015d1:	77 1e                	ja     8015f1 <devfile_write+0x70>
}
  8015d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8015d8:	68 58 25 80 00       	push   $0x802558
  8015dd:	68 85 25 80 00       	push   $0x802585
  8015e2:	68 94 00 00 00       	push   $0x94
  8015e7:	68 9a 25 80 00       	push   $0x80259a
  8015ec:	e8 6b 07 00 00       	call   801d5c <_panic>
	assert(r <= n);
  8015f1:	68 a5 25 80 00       	push   $0x8025a5
  8015f6:	68 85 25 80 00       	push   $0x802585
  8015fb:	68 98 00 00 00       	push   $0x98
  801600:	68 9a 25 80 00       	push   $0x80259a
  801605:	e8 52 07 00 00       	call   801d5c <_panic>

0080160a <devfile_read>:
{
  80160a:	f3 0f 1e fb          	endbr32 
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	56                   	push   %esi
  801612:	53                   	push   %ebx
  801613:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8b 40 0c             	mov    0xc(%eax),%eax
  80161c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801621:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 03 00 00 00       	mov    $0x3,%eax
  801631:	e8 4d fe ff ff       	call   801483 <fsipc>
  801636:	89 c3                	mov    %eax,%ebx
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 1f                	js     80165b <devfile_read+0x51>
	assert(r <= n);
  80163c:	39 f0                	cmp    %esi,%eax
  80163e:	77 24                	ja     801664 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801640:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801645:	7f 33                	jg     80167a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	50                   	push   %eax
  80164b:	68 00 50 80 00       	push   $0x805000
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	e8 ec f2 ff ff       	call   800944 <memmove>
	return r;
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	89 d8                	mov    %ebx,%eax
  80165d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801660:	5b                   	pop    %ebx
  801661:	5e                   	pop    %esi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    
	assert(r <= n);
  801664:	68 a5 25 80 00       	push   $0x8025a5
  801669:	68 85 25 80 00       	push   $0x802585
  80166e:	6a 7c                	push   $0x7c
  801670:	68 9a 25 80 00       	push   $0x80259a
  801675:	e8 e2 06 00 00       	call   801d5c <_panic>
	assert(r <= PGSIZE);
  80167a:	68 ac 25 80 00       	push   $0x8025ac
  80167f:	68 85 25 80 00       	push   $0x802585
  801684:	6a 7d                	push   $0x7d
  801686:	68 9a 25 80 00       	push   $0x80259a
  80168b:	e8 cc 06 00 00       	call   801d5c <_panic>

00801690 <open>:
{
  801690:	f3 0f 1e fb          	endbr32 
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	83 ec 1c             	sub    $0x1c,%esp
  80169c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80169f:	56                   	push   %esi
  8016a0:	e8 a4 f0 ff ff       	call   800749 <strlen>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016ad:	7f 6c                	jg     80171b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	e8 28 f8 ff ff       	call   800ee3 <fd_alloc>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 3c                	js     801700 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	56                   	push   %esi
  8016c8:	68 00 50 80 00       	push   $0x805000
  8016cd:	e8 ba f0 ff ff       	call   80078c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e2:	e8 9c fd ff ff       	call   801483 <fsipc>
  8016e7:	89 c3                	mov    %eax,%ebx
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 19                	js     801709 <open+0x79>
	return fd2num(fd);
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f6:	e8 b5 f7 ff ff       	call   800eb0 <fd2num>
  8016fb:	89 c3                	mov    %eax,%ebx
  8016fd:	83 c4 10             	add    $0x10,%esp
}
  801700:	89 d8                	mov    %ebx,%eax
  801702:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    
		fd_close(fd, 0);
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	6a 00                	push   $0x0
  80170e:	ff 75 f4             	pushl  -0xc(%ebp)
  801711:	e8 d1 f8 ff ff       	call   800fe7 <fd_close>
		return r;
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	eb e5                	jmp    801700 <open+0x70>
		return -E_BAD_PATH;
  80171b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801720:	eb de                	jmp    801700 <open+0x70>

00801722 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801722:	f3 0f 1e fb          	endbr32 
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80172c:	ba 00 00 00 00       	mov    $0x0,%edx
  801731:	b8 08 00 00 00       	mov    $0x8,%eax
  801736:	e8 48 fd ff ff       	call   801483 <fsipc>
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80173d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801741:	7f 01                	jg     801744 <writebuf+0x7>
  801743:	c3                   	ret    
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	53                   	push   %ebx
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80174d:	ff 70 04             	pushl  0x4(%eax)
  801750:	8d 40 10             	lea    0x10(%eax),%eax
  801753:	50                   	push   %eax
  801754:	ff 33                	pushl  (%ebx)
  801756:	e8 37 fb ff ff       	call   801292 <write>
		if (result > 0)
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	7e 03                	jle    801765 <writebuf+0x28>
			b->result += result;
  801762:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801765:	39 43 04             	cmp    %eax,0x4(%ebx)
  801768:	74 0d                	je     801777 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80176a:	85 c0                	test   %eax,%eax
  80176c:	ba 00 00 00 00       	mov    $0x0,%edx
  801771:	0f 4f c2             	cmovg  %edx,%eax
  801774:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <putch>:

static void
putch(int ch, void *thunk)
{
  80177c:	f3 0f 1e fb          	endbr32 
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	53                   	push   %ebx
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80178a:	8b 53 04             	mov    0x4(%ebx),%edx
  80178d:	8d 42 01             	lea    0x1(%edx),%eax
  801790:	89 43 04             	mov    %eax,0x4(%ebx)
  801793:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801796:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80179a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80179f:	74 06                	je     8017a7 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8017a1:	83 c4 04             	add    $0x4,%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    
		writebuf(b);
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	e8 8f ff ff ff       	call   80173d <writebuf>
		b->idx = 0;
  8017ae:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017b5:	eb ea                	jmp    8017a1 <putch+0x25>

008017b7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017b7:	f3 0f 1e fb          	endbr32 
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017cd:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017d4:	00 00 00 
	b.result = 0;
  8017d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017de:	00 00 00 
	b.error = 1;
  8017e1:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017e8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017eb:	ff 75 10             	pushl  0x10(%ebp)
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017f7:	50                   	push   %eax
  8017f8:	68 7c 17 80 00       	push   $0x80177c
  8017fd:	e8 83 eb ff ff       	call   800385 <vprintfmt>
	if (b.idx > 0)
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80180c:	7f 11                	jg     80181f <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80180e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801814:	85 c0                	test   %eax,%eax
  801816:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    
		writebuf(&b);
  80181f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801825:	e8 13 ff ff ff       	call   80173d <writebuf>
  80182a:	eb e2                	jmp    80180e <vfprintf+0x57>

0080182c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80182c:	f3 0f 1e fb          	endbr32 
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801836:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801839:	50                   	push   %eax
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	ff 75 08             	pushl  0x8(%ebp)
  801840:	e8 72 ff ff ff       	call   8017b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <printf>:

int
printf(const char *fmt, ...)
{
  801847:	f3 0f 1e fb          	endbr32 
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801851:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801854:	50                   	push   %eax
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 01                	push   $0x1
  80185a:	e8 58 ff ff ff       	call   8017b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801861:	f3 0f 1e fb          	endbr32 
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80186d:	83 ec 0c             	sub    $0xc,%esp
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 4c f6 ff ff       	call   800ec4 <fd2data>
  801878:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80187a:	83 c4 08             	add    $0x8,%esp
  80187d:	68 b8 25 80 00       	push   $0x8025b8
  801882:	53                   	push   %ebx
  801883:	e8 04 ef ff ff       	call   80078c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801888:	8b 46 04             	mov    0x4(%esi),%eax
  80188b:	2b 06                	sub    (%esi),%eax
  80188d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801893:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80189a:	00 00 00 
	stat->st_dev = &devpipe;
  80189d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018a4:	30 80 00 
	return 0;
}
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018b3:	f3 0f 1e fb          	endbr32 
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018c1:	53                   	push   %ebx
  8018c2:	6a 00                	push   $0x0
  8018c4:	e8 9d f3 ff ff       	call   800c66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018c9:	89 1c 24             	mov    %ebx,(%esp)
  8018cc:	e8 f3 f5 ff ff       	call   800ec4 <fd2data>
  8018d1:	83 c4 08             	add    $0x8,%esp
  8018d4:	50                   	push   %eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	e8 8a f3 ff ff       	call   800c66 <sys_page_unmap>
}
  8018dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <_pipeisclosed>:
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	57                   	push   %edi
  8018e5:	56                   	push   %esi
  8018e6:	53                   	push   %ebx
  8018e7:	83 ec 1c             	sub    $0x1c,%esp
  8018ea:	89 c7                	mov    %eax,%edi
  8018ec:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8018f3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	57                   	push   %edi
  8018fa:	e8 a9 05 00 00       	call   801ea8 <pageref>
  8018ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801902:	89 34 24             	mov    %esi,(%esp)
  801905:	e8 9e 05 00 00       	call   801ea8 <pageref>
		nn = thisenv->env_runs;
  80190a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801910:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	39 cb                	cmp    %ecx,%ebx
  801918:	74 1b                	je     801935 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80191a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80191d:	75 cf                	jne    8018ee <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80191f:	8b 42 58             	mov    0x58(%edx),%eax
  801922:	6a 01                	push   $0x1
  801924:	50                   	push   %eax
  801925:	53                   	push   %ebx
  801926:	68 bf 25 80 00       	push   $0x8025bf
  80192b:	e8 f2 e8 ff ff       	call   800222 <cprintf>
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	eb b9                	jmp    8018ee <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801935:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801938:	0f 94 c0             	sete   %al
  80193b:	0f b6 c0             	movzbl %al,%eax
}
  80193e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5f                   	pop    %edi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <devpipe_write>:
{
  801946:	f3 0f 1e fb          	endbr32 
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	57                   	push   %edi
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 28             	sub    $0x28,%esp
  801953:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801956:	56                   	push   %esi
  801957:	e8 68 f5 ff ff       	call   800ec4 <fd2data>
  80195c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	bf 00 00 00 00       	mov    $0x0,%edi
  801966:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801969:	74 4f                	je     8019ba <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80196b:	8b 43 04             	mov    0x4(%ebx),%eax
  80196e:	8b 0b                	mov    (%ebx),%ecx
  801970:	8d 51 20             	lea    0x20(%ecx),%edx
  801973:	39 d0                	cmp    %edx,%eax
  801975:	72 14                	jb     80198b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801977:	89 da                	mov    %ebx,%edx
  801979:	89 f0                	mov    %esi,%eax
  80197b:	e8 61 ff ff ff       	call   8018e1 <_pipeisclosed>
  801980:	85 c0                	test   %eax,%eax
  801982:	75 3b                	jne    8019bf <devpipe_write+0x79>
			sys_yield();
  801984:	e8 60 f2 ff ff       	call   800be9 <sys_yield>
  801989:	eb e0                	jmp    80196b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80198b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80198e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801992:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801995:	89 c2                	mov    %eax,%edx
  801997:	c1 fa 1f             	sar    $0x1f,%edx
  80199a:	89 d1                	mov    %edx,%ecx
  80199c:	c1 e9 1b             	shr    $0x1b,%ecx
  80199f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019a2:	83 e2 1f             	and    $0x1f,%edx
  8019a5:	29 ca                	sub    %ecx,%edx
  8019a7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019af:	83 c0 01             	add    $0x1,%eax
  8019b2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019b5:	83 c7 01             	add    $0x1,%edi
  8019b8:	eb ac                	jmp    801966 <devpipe_write+0x20>
	return i;
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	eb 05                	jmp    8019c4 <devpipe_write+0x7e>
				return 0;
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5f                   	pop    %edi
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    

008019cc <devpipe_read>:
{
  8019cc:	f3 0f 1e fb          	endbr32 
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	57                   	push   %edi
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 18             	sub    $0x18,%esp
  8019d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019dc:	57                   	push   %edi
  8019dd:	e8 e2 f4 ff ff       	call   800ec4 <fd2data>
  8019e2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	be 00 00 00 00       	mov    $0x0,%esi
  8019ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019ef:	75 14                	jne    801a05 <devpipe_read+0x39>
	return i;
  8019f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f4:	eb 02                	jmp    8019f8 <devpipe_read+0x2c>
				return i;
  8019f6:	89 f0                	mov    %esi,%eax
}
  8019f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
			sys_yield();
  801a00:	e8 e4 f1 ff ff       	call   800be9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801a05:	8b 03                	mov    (%ebx),%eax
  801a07:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a0a:	75 18                	jne    801a24 <devpipe_read+0x58>
			if (i > 0)
  801a0c:	85 f6                	test   %esi,%esi
  801a0e:	75 e6                	jne    8019f6 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801a10:	89 da                	mov    %ebx,%edx
  801a12:	89 f8                	mov    %edi,%eax
  801a14:	e8 c8 fe ff ff       	call   8018e1 <_pipeisclosed>
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	74 e3                	je     801a00 <devpipe_read+0x34>
				return 0;
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a22:	eb d4                	jmp    8019f8 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a24:	99                   	cltd   
  801a25:	c1 ea 1b             	shr    $0x1b,%edx
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	83 e0 1f             	and    $0x1f,%eax
  801a2d:	29 d0                	sub    %edx,%eax
  801a2f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a37:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a3a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a3d:	83 c6 01             	add    $0x1,%esi
  801a40:	eb aa                	jmp    8019ec <devpipe_read+0x20>

00801a42 <pipe>:
{
  801a42:	f3 0f 1e fb          	endbr32 
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a51:	50                   	push   %eax
  801a52:	e8 8c f4 ff ff       	call   800ee3 <fd_alloc>
  801a57:	89 c3                	mov    %eax,%ebx
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	0f 88 23 01 00 00    	js     801b87 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	68 07 04 00 00       	push   $0x407
  801a6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6f:	6a 00                	push   $0x0
  801a71:	e8 9e f1 ff ff       	call   800c14 <sys_page_alloc>
  801a76:	89 c3                	mov    %eax,%ebx
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	0f 88 04 01 00 00    	js     801b87 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a89:	50                   	push   %eax
  801a8a:	e8 54 f4 ff ff       	call   800ee3 <fd_alloc>
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	0f 88 db 00 00 00    	js     801b77 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	68 07 04 00 00       	push   $0x407
  801aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa7:	6a 00                	push   $0x0
  801aa9:	e8 66 f1 ff ff       	call   800c14 <sys_page_alloc>
  801aae:	89 c3                	mov    %eax,%ebx
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	0f 88 bc 00 00 00    	js     801b77 <pipe+0x135>
	va = fd2data(fd0);
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac1:	e8 fe f3 ff ff       	call   800ec4 <fd2data>
  801ac6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac8:	83 c4 0c             	add    $0xc,%esp
  801acb:	68 07 04 00 00       	push   $0x407
  801ad0:	50                   	push   %eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	e8 3c f1 ff ff       	call   800c14 <sys_page_alloc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	0f 88 82 00 00 00    	js     801b67 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae5:	83 ec 0c             	sub    $0xc,%esp
  801ae8:	ff 75 f0             	pushl  -0x10(%ebp)
  801aeb:	e8 d4 f3 ff ff       	call   800ec4 <fd2data>
  801af0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801af7:	50                   	push   %eax
  801af8:	6a 00                	push   $0x0
  801afa:	56                   	push   %esi
  801afb:	6a 00                	push   $0x0
  801afd:	e8 3a f1 ff ff       	call   800c3c <sys_page_map>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	83 c4 20             	add    $0x20,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 4e                	js     801b59 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801b0b:	a1 20 30 80 00       	mov    0x803020,%eax
  801b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b13:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b18:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b22:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b2e:	83 ec 0c             	sub    $0xc,%esp
  801b31:	ff 75 f4             	pushl  -0xc(%ebp)
  801b34:	e8 77 f3 ff ff       	call   800eb0 <fd2num>
  801b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b3e:	83 c4 04             	add    $0x4,%esp
  801b41:	ff 75 f0             	pushl  -0x10(%ebp)
  801b44:	e8 67 f3 ff ff       	call   800eb0 <fd2num>
  801b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b57:	eb 2e                	jmp    801b87 <pipe+0x145>
	sys_page_unmap(0, va);
  801b59:	83 ec 08             	sub    $0x8,%esp
  801b5c:	56                   	push   %esi
  801b5d:	6a 00                	push   $0x0
  801b5f:	e8 02 f1 ff ff       	call   800c66 <sys_page_unmap>
  801b64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 f2 f0 ff ff       	call   800c66 <sys_page_unmap>
  801b74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7d:	6a 00                	push   $0x0
  801b7f:	e8 e2 f0 ff ff       	call   800c66 <sys_page_unmap>
  801b84:	83 c4 10             	add    $0x10,%esp
}
  801b87:	89 d8                	mov    %ebx,%eax
  801b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8c:	5b                   	pop    %ebx
  801b8d:	5e                   	pop    %esi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <pipeisclosed>:
{
  801b90:	f3 0f 1e fb          	endbr32 
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9d:	50                   	push   %eax
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	e8 93 f3 ff ff       	call   800f39 <fd_lookup>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 18                	js     801bc5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb3:	e8 0c f3 ff ff       	call   800ec4 <fd2data>
  801bb8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbd:	e8 1f fd ff ff       	call   8018e1 <_pipeisclosed>
  801bc2:	83 c4 10             	add    $0x10,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801bc7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd0:	c3                   	ret    

00801bd1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bdb:	68 d7 25 80 00       	push   $0x8025d7
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	e8 a4 eb ff ff       	call   80078c <strcpy>
	return 0;
}
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <devcons_write>:
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	57                   	push   %edi
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bff:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c04:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c0a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c0d:	73 31                	jae    801c40 <devcons_write+0x51>
		m = n - tot;
  801c0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c12:	29 f3                	sub    %esi,%ebx
  801c14:	83 fb 7f             	cmp    $0x7f,%ebx
  801c17:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c1c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	53                   	push   %ebx
  801c23:	89 f0                	mov    %esi,%eax
  801c25:	03 45 0c             	add    0xc(%ebp),%eax
  801c28:	50                   	push   %eax
  801c29:	57                   	push   %edi
  801c2a:	e8 15 ed ff ff       	call   800944 <memmove>
		sys_cputs(buf, m);
  801c2f:	83 c4 08             	add    $0x8,%esp
  801c32:	53                   	push   %ebx
  801c33:	57                   	push   %edi
  801c34:	e8 10 ef ff ff       	call   800b49 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c39:	01 de                	add    %ebx,%esi
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	eb ca                	jmp    801c0a <devcons_write+0x1b>
}
  801c40:	89 f0                	mov    %esi,%eax
  801c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5f                   	pop    %edi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <devcons_read>:
{
  801c4a:	f3 0f 1e fb          	endbr32 
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c5d:	74 21                	je     801c80 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801c5f:	e8 0f ef ff ff       	call   800b73 <sys_cgetc>
  801c64:	85 c0                	test   %eax,%eax
  801c66:	75 07                	jne    801c6f <devcons_read+0x25>
		sys_yield();
  801c68:	e8 7c ef ff ff       	call   800be9 <sys_yield>
  801c6d:	eb f0                	jmp    801c5f <devcons_read+0x15>
	if (c < 0)
  801c6f:	78 0f                	js     801c80 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801c71:	83 f8 04             	cmp    $0x4,%eax
  801c74:	74 0c                	je     801c82 <devcons_read+0x38>
	*(char*)vbuf = c;
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	88 02                	mov    %al,(%edx)
	return 1;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    
		return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	eb f7                	jmp    801c80 <devcons_read+0x36>

00801c89 <cputchar>:
{
  801c89:	f3 0f 1e fb          	endbr32 
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c99:	6a 01                	push   $0x1
  801c9b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c9e:	50                   	push   %eax
  801c9f:	e8 a5 ee ff ff       	call   800b49 <sys_cputs>
}
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <getchar>:
{
  801ca9:	f3 0f 1e fb          	endbr32 
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cb3:	6a 01                	push   $0x1
  801cb5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cb8:	50                   	push   %eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	e8 fc f4 ff ff       	call   8011bc <read>
	if (r < 0)
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 06                	js     801ccd <getchar+0x24>
	if (r < 1)
  801cc7:	74 06                	je     801ccf <getchar+0x26>
	return c;
  801cc9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    
		return -E_EOF;
  801ccf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801cd4:	eb f7                	jmp    801ccd <getchar+0x24>

00801cd6 <iscons>:
{
  801cd6:	f3 0f 1e fb          	endbr32 
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce3:	50                   	push   %eax
  801ce4:	ff 75 08             	pushl  0x8(%ebp)
  801ce7:	e8 4d f2 ff ff       	call   800f39 <fd_lookup>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 11                	js     801d04 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cfc:	39 10                	cmp    %edx,(%eax)
  801cfe:	0f 94 c0             	sete   %al
  801d01:	0f b6 c0             	movzbl %al,%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <opencons>:
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d13:	50                   	push   %eax
  801d14:	e8 ca f1 ff ff       	call   800ee3 <fd_alloc>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 3a                	js     801d5a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	68 07 04 00 00       	push   $0x407
  801d28:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2b:	6a 00                	push   $0x0
  801d2d:	e8 e2 ee ff ff       	call   800c14 <sys_page_alloc>
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	85 c0                	test   %eax,%eax
  801d37:	78 21                	js     801d5a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d42:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	50                   	push   %eax
  801d52:	e8 59 f1 ff ff       	call   800eb0 <fd2num>
  801d57:	83 c4 10             	add    $0x10,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d5c:	f3 0f 1e fb          	endbr32 
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	56                   	push   %esi
  801d64:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801d65:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d68:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d6e:	e8 4e ee ff ff       	call   800bc1 <sys_getenvid>
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	56                   	push   %esi
  801d7d:	50                   	push   %eax
  801d7e:	68 e4 25 80 00       	push   $0x8025e4
  801d83:	e8 9a e4 ff ff       	call   800222 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d88:	83 c4 18             	add    $0x18,%esp
  801d8b:	53                   	push   %ebx
  801d8c:	ff 75 10             	pushl  0x10(%ebp)
  801d8f:	e8 39 e4 ff ff       	call   8001cd <vcprintf>
	cprintf("\n");
  801d94:	c7 04 24 22 26 80 00 	movl   $0x802622,(%esp)
  801d9b:	e8 82 e4 ff ff       	call   800222 <cprintf>
  801da0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801da3:	cc                   	int3   
  801da4:	eb fd                	jmp    801da3 <_panic+0x47>

00801da6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801da6:	f3 0f 1e fb          	endbr32 
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	56                   	push   %esi
  801dae:	53                   	push   %ebx
  801daf:	8b 75 08             	mov    0x8(%ebp),%esi
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801db8:	85 c0                	test   %eax,%eax
  801dba:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dbf:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	50                   	push   %eax
  801dc6:	e8 60 ef ff ff       	call   800d2b <sys_ipc_recv>
	if (r < 0) {
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 2b                	js     801dfd <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801dd2:	85 f6                	test   %esi,%esi
  801dd4:	74 0a                	je     801de0 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801dd6:	a1 04 40 80 00       	mov    0x804004,%eax
  801ddb:	8b 40 74             	mov    0x74(%eax),%eax
  801dde:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801de0:	85 db                	test   %ebx,%ebx
  801de2:	74 0a                	je     801dee <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801de4:	a1 04 40 80 00       	mov    0x804004,%eax
  801de9:	8b 40 78             	mov    0x78(%eax),%eax
  801dec:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801dee:	a1 04 40 80 00       	mov    0x804004,%eax
  801df3:	8b 40 70             	mov    0x70(%eax),%eax
}
  801df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df9:	5b                   	pop    %ebx
  801dfa:	5e                   	pop    %esi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
		if (from_env_store) {
  801dfd:	85 f6                	test   %esi,%esi
  801dff:	74 06                	je     801e07 <ipc_recv+0x61>
			*from_env_store = 0;
  801e01:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801e07:	85 db                	test   %ebx,%ebx
  801e09:	74 eb                	je     801df6 <ipc_recv+0x50>
			*perm_store = 0;
  801e0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e11:	eb e3                	jmp    801df6 <ipc_recv+0x50>

00801e13 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e13:	f3 0f 1e fb          	endbr32 
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	57                   	push   %edi
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	83 ec 0c             	sub    $0xc,%esp
  801e20:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e23:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801e29:	85 db                	test   %ebx,%ebx
  801e2b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e30:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801e33:	ff 75 14             	pushl  0x14(%ebp)
  801e36:	53                   	push   %ebx
  801e37:	56                   	push   %esi
  801e38:	57                   	push   %edi
  801e39:	e8 c4 ee ff ff       	call   800d02 <sys_ipc_try_send>
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e44:	75 07                	jne    801e4d <ipc_send+0x3a>
		sys_yield();
  801e46:	e8 9e ed ff ff       	call   800be9 <sys_yield>
  801e4b:	eb e6                	jmp    801e33 <ipc_send+0x20>
	}

	if (ret < 0) {
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 08                	js     801e59 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801e59:	50                   	push   %eax
  801e5a:	68 07 26 80 00       	push   $0x802607
  801e5f:	6a 48                	push   $0x48
  801e61:	68 24 26 80 00       	push   $0x802624
  801e66:	e8 f1 fe ff ff       	call   801d5c <_panic>

00801e6b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e6b:	f3 0f 1e fb          	endbr32 
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e7a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e7d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e83:	8b 52 50             	mov    0x50(%edx),%edx
  801e86:	39 ca                	cmp    %ecx,%edx
  801e88:	74 11                	je     801e9b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801e8a:	83 c0 01             	add    $0x1,%eax
  801e8d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e92:	75 e6                	jne    801e7a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	eb 0b                	jmp    801ea6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801e9b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e9e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ea3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    

00801ea8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ea8:	f3 0f 1e fb          	endbr32 
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eb2:	89 c2                	mov    %eax,%edx
  801eb4:	c1 ea 16             	shr    $0x16,%edx
  801eb7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801ebe:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801ec3:	f6 c1 01             	test   $0x1,%cl
  801ec6:	74 1c                	je     801ee4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801ec8:	c1 e8 0c             	shr    $0xc,%eax
  801ecb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ed2:	a8 01                	test   $0x1,%al
  801ed4:	74 0e                	je     801ee4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ed6:	c1 e8 0c             	shr    $0xc,%eax
  801ed9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801ee0:	ef 
  801ee1:	0f b7 d2             	movzwl %dx,%edx
}
  801ee4:	89 d0                	mov    %edx,%eax
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    
  801ee8:	66 90                	xchg   %ax,%ax
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	66 90                	xchg   %ax,%ax
  801eee:	66 90                	xchg   %ax,%ax

00801ef0 <__udivdi3>:
  801ef0:	f3 0f 1e fb          	endbr32 
  801ef4:	55                   	push   %ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 1c             	sub    $0x1c,%esp
  801efb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801eff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f07:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f0b:	85 d2                	test   %edx,%edx
  801f0d:	75 19                	jne    801f28 <__udivdi3+0x38>
  801f0f:	39 f3                	cmp    %esi,%ebx
  801f11:	76 4d                	jbe    801f60 <__udivdi3+0x70>
  801f13:	31 ff                	xor    %edi,%edi
  801f15:	89 e8                	mov    %ebp,%eax
  801f17:	89 f2                	mov    %esi,%edx
  801f19:	f7 f3                	div    %ebx
  801f1b:	89 fa                	mov    %edi,%edx
  801f1d:	83 c4 1c             	add    $0x1c,%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5f                   	pop    %edi
  801f23:	5d                   	pop    %ebp
  801f24:	c3                   	ret    
  801f25:	8d 76 00             	lea    0x0(%esi),%esi
  801f28:	39 f2                	cmp    %esi,%edx
  801f2a:	76 14                	jbe    801f40 <__udivdi3+0x50>
  801f2c:	31 ff                	xor    %edi,%edi
  801f2e:	31 c0                	xor    %eax,%eax
  801f30:	89 fa                	mov    %edi,%edx
  801f32:	83 c4 1c             	add    $0x1c,%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5f                   	pop    %edi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    
  801f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f40:	0f bd fa             	bsr    %edx,%edi
  801f43:	83 f7 1f             	xor    $0x1f,%edi
  801f46:	75 48                	jne    801f90 <__udivdi3+0xa0>
  801f48:	39 f2                	cmp    %esi,%edx
  801f4a:	72 06                	jb     801f52 <__udivdi3+0x62>
  801f4c:	31 c0                	xor    %eax,%eax
  801f4e:	39 eb                	cmp    %ebp,%ebx
  801f50:	77 de                	ja     801f30 <__udivdi3+0x40>
  801f52:	b8 01 00 00 00       	mov    $0x1,%eax
  801f57:	eb d7                	jmp    801f30 <__udivdi3+0x40>
  801f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f60:	89 d9                	mov    %ebx,%ecx
  801f62:	85 db                	test   %ebx,%ebx
  801f64:	75 0b                	jne    801f71 <__udivdi3+0x81>
  801f66:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	f7 f3                	div    %ebx
  801f6f:	89 c1                	mov    %eax,%ecx
  801f71:	31 d2                	xor    %edx,%edx
  801f73:	89 f0                	mov    %esi,%eax
  801f75:	f7 f1                	div    %ecx
  801f77:	89 c6                	mov    %eax,%esi
  801f79:	89 e8                	mov    %ebp,%eax
  801f7b:	89 f7                	mov    %esi,%edi
  801f7d:	f7 f1                	div    %ecx
  801f7f:	89 fa                	mov    %edi,%edx
  801f81:	83 c4 1c             	add    $0x1c,%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5f                   	pop    %edi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
  801f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f90:	89 f9                	mov    %edi,%ecx
  801f92:	b8 20 00 00 00       	mov    $0x20,%eax
  801f97:	29 f8                	sub    %edi,%eax
  801f99:	d3 e2                	shl    %cl,%edx
  801f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f9f:	89 c1                	mov    %eax,%ecx
  801fa1:	89 da                	mov    %ebx,%edx
  801fa3:	d3 ea                	shr    %cl,%edx
  801fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fa9:	09 d1                	or     %edx,%ecx
  801fab:	89 f2                	mov    %esi,%edx
  801fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fb1:	89 f9                	mov    %edi,%ecx
  801fb3:	d3 e3                	shl    %cl,%ebx
  801fb5:	89 c1                	mov    %eax,%ecx
  801fb7:	d3 ea                	shr    %cl,%edx
  801fb9:	89 f9                	mov    %edi,%ecx
  801fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fbf:	89 eb                	mov    %ebp,%ebx
  801fc1:	d3 e6                	shl    %cl,%esi
  801fc3:	89 c1                	mov    %eax,%ecx
  801fc5:	d3 eb                	shr    %cl,%ebx
  801fc7:	09 de                	or     %ebx,%esi
  801fc9:	89 f0                	mov    %esi,%eax
  801fcb:	f7 74 24 08          	divl   0x8(%esp)
  801fcf:	89 d6                	mov    %edx,%esi
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	f7 64 24 0c          	mull   0xc(%esp)
  801fd7:	39 d6                	cmp    %edx,%esi
  801fd9:	72 15                	jb     801ff0 <__udivdi3+0x100>
  801fdb:	89 f9                	mov    %edi,%ecx
  801fdd:	d3 e5                	shl    %cl,%ebp
  801fdf:	39 c5                	cmp    %eax,%ebp
  801fe1:	73 04                	jae    801fe7 <__udivdi3+0xf7>
  801fe3:	39 d6                	cmp    %edx,%esi
  801fe5:	74 09                	je     801ff0 <__udivdi3+0x100>
  801fe7:	89 d8                	mov    %ebx,%eax
  801fe9:	31 ff                	xor    %edi,%edi
  801feb:	e9 40 ff ff ff       	jmp    801f30 <__udivdi3+0x40>
  801ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ff3:	31 ff                	xor    %edi,%edi
  801ff5:	e9 36 ff ff ff       	jmp    801f30 <__udivdi3+0x40>
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <__umoddi3>:
  802000:	f3 0f 1e fb          	endbr32 
  802004:	55                   	push   %ebp
  802005:	57                   	push   %edi
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	83 ec 1c             	sub    $0x1c,%esp
  80200b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80200f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802013:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 19                	jne    802038 <__umoddi3+0x38>
  80201f:	39 df                	cmp    %ebx,%edi
  802021:	76 5d                	jbe    802080 <__umoddi3+0x80>
  802023:	89 f0                	mov    %esi,%eax
  802025:	89 da                	mov    %ebx,%edx
  802027:	f7 f7                	div    %edi
  802029:	89 d0                	mov    %edx,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	83 c4 1c             	add    $0x1c,%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5f                   	pop    %edi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
  802035:	8d 76 00             	lea    0x0(%esi),%esi
  802038:	89 f2                	mov    %esi,%edx
  80203a:	39 d8                	cmp    %ebx,%eax
  80203c:	76 12                	jbe    802050 <__umoddi3+0x50>
  80203e:	89 f0                	mov    %esi,%eax
  802040:	89 da                	mov    %ebx,%edx
  802042:	83 c4 1c             	add    $0x1c,%esp
  802045:	5b                   	pop    %ebx
  802046:	5e                   	pop    %esi
  802047:	5f                   	pop    %edi
  802048:	5d                   	pop    %ebp
  802049:	c3                   	ret    
  80204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802050:	0f bd e8             	bsr    %eax,%ebp
  802053:	83 f5 1f             	xor    $0x1f,%ebp
  802056:	75 50                	jne    8020a8 <__umoddi3+0xa8>
  802058:	39 d8                	cmp    %ebx,%eax
  80205a:	0f 82 e0 00 00 00    	jb     802140 <__umoddi3+0x140>
  802060:	89 d9                	mov    %ebx,%ecx
  802062:	39 f7                	cmp    %esi,%edi
  802064:	0f 86 d6 00 00 00    	jbe    802140 <__umoddi3+0x140>
  80206a:	89 d0                	mov    %edx,%eax
  80206c:	89 ca                	mov    %ecx,%edx
  80206e:	83 c4 1c             	add    $0x1c,%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    
  802076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80207d:	8d 76 00             	lea    0x0(%esi),%esi
  802080:	89 fd                	mov    %edi,%ebp
  802082:	85 ff                	test   %edi,%edi
  802084:	75 0b                	jne    802091 <__umoddi3+0x91>
  802086:	b8 01 00 00 00       	mov    $0x1,%eax
  80208b:	31 d2                	xor    %edx,%edx
  80208d:	f7 f7                	div    %edi
  80208f:	89 c5                	mov    %eax,%ebp
  802091:	89 d8                	mov    %ebx,%eax
  802093:	31 d2                	xor    %edx,%edx
  802095:	f7 f5                	div    %ebp
  802097:	89 f0                	mov    %esi,%eax
  802099:	f7 f5                	div    %ebp
  80209b:	89 d0                	mov    %edx,%eax
  80209d:	31 d2                	xor    %edx,%edx
  80209f:	eb 8c                	jmp    80202d <__umoddi3+0x2d>
  8020a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020a8:	89 e9                	mov    %ebp,%ecx
  8020aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8020af:	29 ea                	sub    %ebp,%edx
  8020b1:	d3 e0                	shl    %cl,%eax
  8020b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b7:	89 d1                	mov    %edx,%ecx
  8020b9:	89 f8                	mov    %edi,%eax
  8020bb:	d3 e8                	shr    %cl,%eax
  8020bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020c9:	09 c1                	or     %eax,%ecx
  8020cb:	89 d8                	mov    %ebx,%eax
  8020cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d1:	89 e9                	mov    %ebp,%ecx
  8020d3:	d3 e7                	shl    %cl,%edi
  8020d5:	89 d1                	mov    %edx,%ecx
  8020d7:	d3 e8                	shr    %cl,%eax
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020df:	d3 e3                	shl    %cl,%ebx
  8020e1:	89 c7                	mov    %eax,%edi
  8020e3:	89 d1                	mov    %edx,%ecx
  8020e5:	89 f0                	mov    %esi,%eax
  8020e7:	d3 e8                	shr    %cl,%eax
  8020e9:	89 e9                	mov    %ebp,%ecx
  8020eb:	89 fa                	mov    %edi,%edx
  8020ed:	d3 e6                	shl    %cl,%esi
  8020ef:	09 d8                	or     %ebx,%eax
  8020f1:	f7 74 24 08          	divl   0x8(%esp)
  8020f5:	89 d1                	mov    %edx,%ecx
  8020f7:	89 f3                	mov    %esi,%ebx
  8020f9:	f7 64 24 0c          	mull   0xc(%esp)
  8020fd:	89 c6                	mov    %eax,%esi
  8020ff:	89 d7                	mov    %edx,%edi
  802101:	39 d1                	cmp    %edx,%ecx
  802103:	72 06                	jb     80210b <__umoddi3+0x10b>
  802105:	75 10                	jne    802117 <__umoddi3+0x117>
  802107:	39 c3                	cmp    %eax,%ebx
  802109:	73 0c                	jae    802117 <__umoddi3+0x117>
  80210b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80210f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802113:	89 d7                	mov    %edx,%edi
  802115:	89 c6                	mov    %eax,%esi
  802117:	89 ca                	mov    %ecx,%edx
  802119:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80211e:	29 f3                	sub    %esi,%ebx
  802120:	19 fa                	sbb    %edi,%edx
  802122:	89 d0                	mov    %edx,%eax
  802124:	d3 e0                	shl    %cl,%eax
  802126:	89 e9                	mov    %ebp,%ecx
  802128:	d3 eb                	shr    %cl,%ebx
  80212a:	d3 ea                	shr    %cl,%edx
  80212c:	09 d8                	or     %ebx,%eax
  80212e:	83 c4 1c             	add    $0x1c,%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5f                   	pop    %edi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    
  802136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80213d:	8d 76 00             	lea    0x0(%esi),%esi
  802140:	29 fe                	sub    %edi,%esi
  802142:	19 c3                	sbb    %eax,%ebx
  802144:	89 f2                	mov    %esi,%edx
  802146:	89 d9                	mov    %ebx,%ecx
  802148:	e9 1d ff ff ff       	jmp    80206a <__umoddi3+0x6a>
