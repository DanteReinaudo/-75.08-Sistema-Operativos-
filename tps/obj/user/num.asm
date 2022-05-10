
obj/user/num.debug:     formato del fichero elf32-i386


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
  80002c:	e8 58 01 00 00       	call   800189 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 10             	sub    $0x10,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800042:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800045:	eb 43                	jmp    80008a <num+0x57>
		if (bol) {
			printf("%5d ", ++line);
  800047:	a1 00 40 80 00       	mov    0x804000,%eax
  80004c:	83 c0 01             	add    $0x1,%eax
  80004f:	a3 00 40 80 00       	mov    %eax,0x804000
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	50                   	push   %eax
  800058:	68 60 20 80 00       	push   $0x802060
  80005d:	e8 40 17 00 00       	call   8017a2 <printf>
			bol = 0;
  800062:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800069:	00 00 00 
  80006c:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 01                	push   $0x1
  800074:	53                   	push   %ebx
  800075:	6a 01                	push   $0x1
  800077:	e8 71 11 00 00       	call   8011ed <write>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	83 f8 01             	cmp    $0x1,%eax
  800082:	75 24                	jne    8000a8 <num+0x75>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800084:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800088:	74 36                	je     8000c0 <num+0x8d>
	while ((n = read(f, &c, 1)) > 0) {
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 01                	push   $0x1
  80008f:	53                   	push   %ebx
  800090:	56                   	push   %esi
  800091:	e8 81 10 00 00       	call   801117 <read>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	85 c0                	test   %eax,%eax
  80009b:	7e 2f                	jle    8000cc <num+0x99>
		if (bol) {
  80009d:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a4:	74 c9                	je     80006f <num+0x3c>
  8000a6:	eb 9f                	jmp    800047 <num+0x14>
			panic("write error copying %s: %e", s, r);
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	ff 75 0c             	pushl  0xc(%ebp)
  8000af:	68 65 20 80 00       	push   $0x802065
  8000b4:	6a 13                	push   $0x13
  8000b6:	68 80 20 80 00       	push   $0x802080
  8000bb:	e8 35 01 00 00       	call   8001f5 <_panic>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
  8000ca:	eb be                	jmp    80008a <num+0x57>
	}
	if (n < 0)
  8000cc:	78 07                	js     8000d5 <num+0xa2>
		panic("error reading %s: %e", s, n);
}
  8000ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	ff 75 0c             	pushl  0xc(%ebp)
  8000dc:	68 8b 20 80 00       	push   $0x80208b
  8000e1:	6a 18                	push   $0x18
  8000e3:	68 80 20 80 00       	push   $0x802080
  8000e8:	e8 08 01 00 00       	call   8001f5 <_panic>

008000ed <umain>:

void
umain(int argc, char **argv)
{
  8000ed:	f3 0f 1e fb          	endbr32 
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000fa:	c7 05 04 30 80 00 a0 	movl   $0x8020a0,0x803004
  800101:	20 80 00 
	if (argc == 1)
  800104:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800108:	74 46                	je     800150 <umain+0x63>
  80010a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010d:	8d 70 04             	lea    0x4(%eax),%esi
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800110:	bf 01 00 00 00       	mov    $0x1,%edi
  800115:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800118:	7d 48                	jge    800162 <umain+0x75>
			f = open(argv[i], O_RDONLY);
  80011a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	6a 00                	push   $0x0
  800122:	ff 36                	pushl  (%esi)
  800124:	e8 c2 14 00 00       	call   8015eb <open>
  800129:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	85 c0                	test   %eax,%eax
  800130:	78 3d                	js     80016f <umain+0x82>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	ff 36                	pushl  (%esi)
  800137:	50                   	push   %eax
  800138:	e8 f6 fe ff ff       	call   800033 <num>
				close(f);
  80013d:	89 1c 24             	mov    %ebx,(%esp)
  800140:	e8 88 0e 00 00       	call   800fcd <close>
		for (i = 1; i < argc; i++) {
  800145:	83 c7 01             	add    $0x1,%edi
  800148:	83 c6 04             	add    $0x4,%esi
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	eb c5                	jmp    800115 <umain+0x28>
		num(0, "<stdin>");
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	68 a4 20 80 00       	push   $0x8020a4
  800158:	6a 00                	push   $0x0
  80015a:	e8 d4 fe ff ff       	call   800033 <num>
  80015f:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  800162:	e8 70 00 00 00       	call   8001d7 <exit>
}
  800167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016a:	5b                   	pop    %ebx
  80016b:	5e                   	pop    %esi
  80016c:	5f                   	pop    %edi
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	50                   	push   %eax
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	ff 30                	pushl  (%eax)
  800178:	68 ac 20 80 00       	push   $0x8020ac
  80017d:	6a 27                	push   $0x27
  80017f:	68 80 20 80 00       	push   $0x802080
  800184:	e8 6c 00 00 00       	call   8001f5 <_panic>

00800189 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800189:	f3 0f 1e fb          	endbr32 
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800195:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800198:	e8 de 0a 00 00       	call   800c7b <sys_getenvid>
	if (id >= 0)
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 12                	js     8001b3 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8001a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b3:	85 db                	test   %ebx,%ebx
  8001b5:	7e 07                	jle    8001be <libmain+0x35>
		binaryname = argv[0];
  8001b7:	8b 06                	mov    (%esi),%eax
  8001b9:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	56                   	push   %esi
  8001c2:	53                   	push   %ebx
  8001c3:	e8 25 ff ff ff       	call   8000ed <umain>

	// exit gracefully
	exit();
  8001c8:	e8 0a 00 00 00       	call   8001d7 <exit>
}
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d3:	5b                   	pop    %ebx
  8001d4:	5e                   	pop    %esi
  8001d5:	5d                   	pop    %ebp
  8001d6:	c3                   	ret    

008001d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d7:	f3 0f 1e fb          	endbr32 
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001e1:	e8 18 0e 00 00       	call   800ffe <close_all>
	sys_env_destroy(0);
  8001e6:	83 ec 0c             	sub    $0xc,%esp
  8001e9:	6a 00                	push   $0x0
  8001eb:	e8 65 0a 00 00       	call   800c55 <sys_env_destroy>
}
  8001f0:	83 c4 10             	add    $0x10,%esp
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f5:	f3 0f 1e fb          	endbr32 
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	56                   	push   %esi
  8001fd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800201:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800207:	e8 6f 0a 00 00       	call   800c7b <sys_getenvid>
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	56                   	push   %esi
  800216:	50                   	push   %eax
  800217:	68 c8 20 80 00       	push   $0x8020c8
  80021c:	e8 bb 00 00 00       	call   8002dc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800221:	83 c4 18             	add    $0x18,%esp
  800224:	53                   	push   %ebx
  800225:	ff 75 10             	pushl  0x10(%ebp)
  800228:	e8 5a 00 00 00       	call   800287 <vcprintf>
	cprintf("\n");
  80022d:	c7 04 24 3e 25 80 00 	movl   $0x80253e,(%esp)
  800234:	e8 a3 00 00 00       	call   8002dc <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80023c:	cc                   	int3   
  80023d:	eb fd                	jmp    80023c <_panic+0x47>

0080023f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023f:	f3 0f 1e fb          	endbr32 
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	53                   	push   %ebx
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80024d:	8b 13                	mov    (%ebx),%edx
  80024f:	8d 42 01             	lea    0x1(%edx),%eax
  800252:	89 03                	mov    %eax,(%ebx)
  800254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800257:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80025b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800260:	74 09                	je     80026b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800262:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800269:	c9                   	leave  
  80026a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	68 ff 00 00 00       	push   $0xff
  800273:	8d 43 08             	lea    0x8(%ebx),%eax
  800276:	50                   	push   %eax
  800277:	e8 87 09 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  80027c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800282:	83 c4 10             	add    $0x10,%esp
  800285:	eb db                	jmp    800262 <putch+0x23>

00800287 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800294:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029b:	00 00 00 
	b.cnt = 0;
  80029e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a8:	ff 75 0c             	pushl  0xc(%ebp)
  8002ab:	ff 75 08             	pushl  0x8(%ebp)
  8002ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b4:	50                   	push   %eax
  8002b5:	68 3f 02 80 00       	push   $0x80023f
  8002ba:	e8 80 01 00 00       	call   80043f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002bf:	83 c4 08             	add    $0x8,%esp
  8002c2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002c8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ce:	50                   	push   %eax
  8002cf:	e8 2f 09 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  8002d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002dc:	f3 0f 1e fb          	endbr32 
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002e9:	50                   	push   %eax
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 95 ff ff ff       	call   800287 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
  8002fd:	89 c7                	mov    %eax,%edi
  8002ff:	89 d6                	mov    %edx,%esi
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	89 d1                	mov    %edx,%ecx
  800309:	89 c2                	mov    %eax,%edx
  80030b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800311:	8b 45 10             	mov    0x10(%ebp),%eax
  800314:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800321:	39 c2                	cmp    %eax,%edx
  800323:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800326:	72 3e                	jb     800366 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	ff 75 18             	pushl  0x18(%ebp)
  80032e:	83 eb 01             	sub    $0x1,%ebx
  800331:	53                   	push   %ebx
  800332:	50                   	push   %eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 e4             	pushl  -0x1c(%ebp)
  800339:	ff 75 e0             	pushl  -0x20(%ebp)
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	ff 75 d8             	pushl  -0x28(%ebp)
  800342:	e8 b9 1a 00 00       	call   801e00 <__udivdi3>
  800347:	83 c4 18             	add    $0x18,%esp
  80034a:	52                   	push   %edx
  80034b:	50                   	push   %eax
  80034c:	89 f2                	mov    %esi,%edx
  80034e:	89 f8                	mov    %edi,%eax
  800350:	e8 9f ff ff ff       	call   8002f4 <printnum>
  800355:	83 c4 20             	add    $0x20,%esp
  800358:	eb 13                	jmp    80036d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	56                   	push   %esi
  80035e:	ff 75 18             	pushl  0x18(%ebp)
  800361:	ff d7                	call   *%edi
  800363:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800366:	83 eb 01             	sub    $0x1,%ebx
  800369:	85 db                	test   %ebx,%ebx
  80036b:	7f ed                	jg     80035a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036d:	83 ec 08             	sub    $0x8,%esp
  800370:	56                   	push   %esi
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	ff 75 e4             	pushl  -0x1c(%ebp)
  800377:	ff 75 e0             	pushl  -0x20(%ebp)
  80037a:	ff 75 dc             	pushl  -0x24(%ebp)
  80037d:	ff 75 d8             	pushl  -0x28(%ebp)
  800380:	e8 8b 1b 00 00       	call   801f10 <__umoddi3>
  800385:	83 c4 14             	add    $0x14,%esp
  800388:	0f be 80 eb 20 80 00 	movsbl 0x8020eb(%eax),%eax
  80038f:	50                   	push   %eax
  800390:	ff d7                	call   *%edi
}
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800398:	5b                   	pop    %ebx
  800399:	5e                   	pop    %esi
  80039a:	5f                   	pop    %edi
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80039d:	83 fa 01             	cmp    $0x1,%edx
  8003a0:	7f 13                	jg     8003b5 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8003a2:	85 d2                	test   %edx,%edx
  8003a4:	74 1c                	je     8003c2 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ab:	89 08                	mov    %ecx,(%eax)
  8003ad:	8b 02                	mov    (%edx),%eax
  8003af:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b4:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003ba:	89 08                	mov    %ecx,(%eax)
  8003bc:	8b 02                	mov    (%edx),%eax
  8003be:	8b 52 04             	mov    0x4(%edx),%edx
  8003c1:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8003c2:	8b 10                	mov    (%eax),%edx
  8003c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c7:	89 08                	mov    %ecx,(%eax)
  8003c9:	8b 02                	mov    (%edx),%eax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003d0:	c3                   	ret    

008003d1 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8003d1:	83 fa 01             	cmp    $0x1,%edx
  8003d4:	7f 0f                	jg     8003e5 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8003d6:	85 d2                	test   %edx,%edx
  8003d8:	74 18                	je     8003f2 <getint+0x21>
		return va_arg(*ap, long);
  8003da:	8b 10                	mov    (%eax),%edx
  8003dc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003df:	89 08                	mov    %ecx,(%eax)
  8003e1:	8b 02                	mov    (%edx),%eax
  8003e3:	99                   	cltd   
  8003e4:	c3                   	ret    
		return va_arg(*ap, long long);
  8003e5:	8b 10                	mov    (%eax),%edx
  8003e7:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003ea:	89 08                	mov    %ecx,(%eax)
  8003ec:	8b 02                	mov    (%edx),%eax
  8003ee:	8b 52 04             	mov    0x4(%edx),%edx
  8003f1:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f7:	89 08                	mov    %ecx,(%eax)
  8003f9:	8b 02                	mov    (%edx),%eax
  8003fb:	99                   	cltd   
}
  8003fc:	c3                   	ret    

008003fd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fd:	f3 0f 1e fb          	endbr32 
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800407:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80040b:	8b 10                	mov    (%eax),%edx
  80040d:	3b 50 04             	cmp    0x4(%eax),%edx
  800410:	73 0a                	jae    80041c <sprintputch+0x1f>
		*b->buf++ = ch;
  800412:	8d 4a 01             	lea    0x1(%edx),%ecx
  800415:	89 08                	mov    %ecx,(%eax)
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	88 02                	mov    %al,(%edx)
}
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    

0080041e <printfmt>:
{
  80041e:	f3 0f 1e fb          	endbr32 
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800428:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042b:	50                   	push   %eax
  80042c:	ff 75 10             	pushl  0x10(%ebp)
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	e8 05 00 00 00       	call   80043f <vprintfmt>
}
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    

0080043f <vprintfmt>:
{
  80043f:	f3 0f 1e fb          	endbr32 
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	57                   	push   %edi
  800447:	56                   	push   %esi
  800448:	53                   	push   %ebx
  800449:	83 ec 2c             	sub    $0x2c,%esp
  80044c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80044f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800452:	8b 7d 10             	mov    0x10(%ebp),%edi
  800455:	e9 86 02 00 00       	jmp    8006e0 <vprintfmt+0x2a1>
		padc = ' ';
  80045a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80045e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800465:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80046c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800473:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8d 47 01             	lea    0x1(%edi),%eax
  80047b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047e:	0f b6 17             	movzbl (%edi),%edx
  800481:	8d 42 dd             	lea    -0x23(%edx),%eax
  800484:	3c 55                	cmp    $0x55,%al
  800486:	0f 87 df 02 00 00    	ja     80076b <vprintfmt+0x32c>
  80048c:	0f b6 c0             	movzbl %al,%eax
  80048f:	3e ff 24 85 20 22 80 	notrack jmp *0x802220(,%eax,4)
  800496:	00 
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80049e:	eb d8                	jmp    800478 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a3:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004a7:	eb cf                	jmp    800478 <vprintfmt+0x39>
  8004a9:	0f b6 d2             	movzbl %dl,%edx
  8004ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004b7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ba:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004be:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c4:	83 f9 09             	cmp    $0x9,%ecx
  8004c7:	77 52                	ja     80051b <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8004c9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004cc:	eb e9                	jmp    8004b7 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8d 50 04             	lea    0x4(%eax),%edx
  8004d4:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e3:	79 93                	jns    800478 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004f2:	eb 84                	jmp    800478 <vprintfmt+0x39>
  8004f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f7:	85 c0                	test   %eax,%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	0f 49 d0             	cmovns %eax,%edx
  800501:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800507:	e9 6c ff ff ff       	jmp    800478 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80050f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800516:	e9 5d ff ff ff       	jmp    800478 <vprintfmt+0x39>
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800521:	eb bc                	jmp    8004df <vprintfmt+0xa0>
			lflag++;
  800523:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800529:	e9 4a ff ff ff       	jmp    800478 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 50 04             	lea    0x4(%eax),%edx
  800534:	89 55 14             	mov    %edx,0x14(%ebp)
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	56                   	push   %esi
  80053b:	ff 30                	pushl  (%eax)
  80053d:	ff d3                	call   *%ebx
			break;
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	e9 96 01 00 00       	jmp    8006dd <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 50 04             	lea    0x4(%eax),%edx
  80054d:	89 55 14             	mov    %edx,0x14(%ebp)
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
  800553:	31 d0                	xor    %edx,%eax
  800555:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800557:	83 f8 0f             	cmp    $0xf,%eax
  80055a:	7f 20                	jg     80057c <vprintfmt+0x13d>
  80055c:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  800563:	85 d2                	test   %edx,%edx
  800565:	74 15                	je     80057c <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800567:	52                   	push   %edx
  800568:	68 d7 24 80 00       	push   $0x8024d7
  80056d:	56                   	push   %esi
  80056e:	53                   	push   %ebx
  80056f:	e8 aa fe ff ff       	call   80041e <printfmt>
  800574:	83 c4 10             	add    $0x10,%esp
  800577:	e9 61 01 00 00       	jmp    8006dd <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80057c:	50                   	push   %eax
  80057d:	68 03 21 80 00       	push   $0x802103
  800582:	56                   	push   %esi
  800583:	53                   	push   %ebx
  800584:	e8 95 fe ff ff       	call   80041e <printfmt>
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	e9 4c 01 00 00       	jmp    8006dd <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 50 04             	lea    0x4(%eax),%edx
  800597:	89 55 14             	mov    %edx,0x14(%ebp)
  80059a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80059c:	85 c9                	test   %ecx,%ecx
  80059e:	b8 fc 20 80 00       	mov    $0x8020fc,%eax
  8005a3:	0f 45 c1             	cmovne %ecx,%eax
  8005a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ad:	7e 06                	jle    8005b5 <vprintfmt+0x176>
  8005af:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005b3:	75 0d                	jne    8005c2 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b8:	89 c7                	mov    %eax,%edi
  8005ba:	03 45 e0             	add    -0x20(%ebp),%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c0:	eb 57                	jmp    800619 <vprintfmt+0x1da>
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c8:	ff 75 cc             	pushl  -0x34(%ebp)
  8005cb:	e8 4f 02 00 00       	call   80081f <strnlen>
  8005d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d3:	29 c2                	sub    %eax,%edx
  8005d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005d8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005db:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005df:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8005e2:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e4:	85 db                	test   %ebx,%ebx
  8005e6:	7e 10                	jle    8005f8 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	56                   	push   %esi
  8005ec:	57                   	push   %edi
  8005ed:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	83 eb 01             	sub    $0x1,%ebx
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	eb ec                	jmp    8005e4 <vprintfmt+0x1a5>
  8005f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	85 d2                	test   %edx,%edx
  800600:	b8 00 00 00 00       	mov    $0x0,%eax
  800605:	0f 49 c2             	cmovns %edx,%eax
  800608:	29 c2                	sub    %eax,%edx
  80060a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80060d:	eb a6                	jmp    8005b5 <vprintfmt+0x176>
					putch(ch, putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	56                   	push   %esi
  800613:	52                   	push   %edx
  800614:	ff d3                	call   *%ebx
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	83 c7 01             	add    $0x1,%edi
  800621:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800625:	0f be d0             	movsbl %al,%edx
  800628:	85 d2                	test   %edx,%edx
  80062a:	74 42                	je     80066e <vprintfmt+0x22f>
  80062c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800630:	78 06                	js     800638 <vprintfmt+0x1f9>
  800632:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800636:	78 1e                	js     800656 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800638:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80063c:	74 d1                	je     80060f <vprintfmt+0x1d0>
  80063e:	0f be c0             	movsbl %al,%eax
  800641:	83 e8 20             	sub    $0x20,%eax
  800644:	83 f8 5e             	cmp    $0x5e,%eax
  800647:	76 c6                	jbe    80060f <vprintfmt+0x1d0>
					putch('?', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	56                   	push   %esi
  80064d:	6a 3f                	push   $0x3f
  80064f:	ff d3                	call   *%ebx
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	eb c3                	jmp    800619 <vprintfmt+0x1da>
  800656:	89 cf                	mov    %ecx,%edi
  800658:	eb 0e                	jmp    800668 <vprintfmt+0x229>
				putch(' ', putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	56                   	push   %esi
  80065e:	6a 20                	push   $0x20
  800660:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800662:	83 ef 01             	sub    $0x1,%edi
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	85 ff                	test   %edi,%edi
  80066a:	7f ee                	jg     80065a <vprintfmt+0x21b>
  80066c:	eb 6f                	jmp    8006dd <vprintfmt+0x29e>
  80066e:	89 cf                	mov    %ecx,%edi
  800670:	eb f6                	jmp    800668 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800672:	89 ca                	mov    %ecx,%edx
  800674:	8d 45 14             	lea    0x14(%ebp),%eax
  800677:	e8 55 fd ff ff       	call   8003d1 <getint>
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800682:	85 d2                	test   %edx,%edx
  800684:	78 0b                	js     800691 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800686:	89 d1                	mov    %edx,%ecx
  800688:	89 c2                	mov    %eax,%edx
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	eb 32                	jmp    8006c3 <vprintfmt+0x284>
				putch('-', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	56                   	push   %esi
  800695:	6a 2d                	push   $0x2d
  800697:	ff d3                	call   *%ebx
				num = -(long long) num;
  800699:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069f:	f7 da                	neg    %edx
  8006a1:	83 d1 00             	adc    $0x0,%ecx
  8006a4:	f7 d9                	neg    %ecx
  8006a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ae:	eb 13                	jmp    8006c3 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8006b0:	89 ca                	mov    %ecx,%edx
  8006b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b5:	e8 e3 fc ff ff       	call   80039d <getuint>
  8006ba:	89 d1                	mov    %edx,%ecx
  8006bc:	89 c2                	mov    %eax,%edx
			base = 10;
  8006be:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006ca:	57                   	push   %edi
  8006cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	51                   	push   %ecx
  8006d0:	52                   	push   %edx
  8006d1:	89 f2                	mov    %esi,%edx
  8006d3:	89 d8                	mov    %ebx,%eax
  8006d5:	e8 1a fc ff ff       	call   8002f4 <printnum>
			break;
  8006da:	83 c4 20             	add    $0x20,%esp
{
  8006dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e0:	83 c7 01             	add    $0x1,%edi
  8006e3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e7:	83 f8 25             	cmp    $0x25,%eax
  8006ea:	0f 84 6a fd ff ff    	je     80045a <vprintfmt+0x1b>
			if (ch == '\0')
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	0f 84 93 00 00 00    	je     80078b <vprintfmt+0x34c>
			putch(ch, putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	56                   	push   %esi
  8006fc:	50                   	push   %eax
  8006fd:	ff d3                	call   *%ebx
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	eb dc                	jmp    8006e0 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800704:	89 ca                	mov    %ecx,%edx
  800706:	8d 45 14             	lea    0x14(%ebp),%eax
  800709:	e8 8f fc ff ff       	call   80039d <getuint>
  80070e:	89 d1                	mov    %edx,%ecx
  800710:	89 c2                	mov    %eax,%edx
			base = 8;
  800712:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800717:	eb aa                	jmp    8006c3 <vprintfmt+0x284>
			putch('0', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	56                   	push   %esi
  80071d:	6a 30                	push   $0x30
  80071f:	ff d3                	call   *%ebx
			putch('x', putdat);
  800721:	83 c4 08             	add    $0x8,%esp
  800724:	56                   	push   %esi
  800725:	6a 78                	push   $0x78
  800727:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 50 04             	lea    0x4(%eax),%edx
  80072f:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800732:	8b 10                	mov    (%eax),%edx
  800734:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800739:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800741:	eb 80                	jmp    8006c3 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800743:	89 ca                	mov    %ecx,%edx
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
  800748:	e8 50 fc ff ff       	call   80039d <getuint>
  80074d:	89 d1                	mov    %edx,%ecx
  80074f:	89 c2                	mov    %eax,%edx
			base = 16;
  800751:	b8 10 00 00 00       	mov    $0x10,%eax
  800756:	e9 68 ff ff ff       	jmp    8006c3 <vprintfmt+0x284>
			putch(ch, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	56                   	push   %esi
  80075f:	6a 25                	push   $0x25
  800761:	ff d3                	call   *%ebx
			break;
  800763:	83 c4 10             	add    $0x10,%esp
  800766:	e9 72 ff ff ff       	jmp    8006dd <vprintfmt+0x29e>
			putch('%', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	56                   	push   %esi
  80076f:	6a 25                	push   $0x25
  800771:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	89 f8                	mov    %edi,%eax
  800778:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80077c:	74 05                	je     800783 <vprintfmt+0x344>
  80077e:	83 e8 01             	sub    $0x1,%eax
  800781:	eb f5                	jmp    800778 <vprintfmt+0x339>
  800783:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800786:	e9 52 ff ff ff       	jmp    8006dd <vprintfmt+0x29e>
}
  80078b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078e:	5b                   	pop    %ebx
  80078f:	5e                   	pop    %esi
  800790:	5f                   	pop    %edi
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800793:	f3 0f 1e fb          	endbr32 
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 18             	sub    $0x18,%esp
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	74 26                	je     8007de <vsnprintf+0x4b>
  8007b8:	85 d2                	test   %edx,%edx
  8007ba:	7e 22                	jle    8007de <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007bc:	ff 75 14             	pushl  0x14(%ebp)
  8007bf:	ff 75 10             	pushl  0x10(%ebp)
  8007c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c5:	50                   	push   %eax
  8007c6:	68 fd 03 80 00       	push   $0x8003fd
  8007cb:	e8 6f fc ff ff       	call   80043f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d9:	83 c4 10             	add    $0x10,%esp
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    
		return -E_INVAL;
  8007de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e3:	eb f7                	jmp    8007dc <vsnprintf+0x49>

008007e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e5:	f3 0f 1e fb          	endbr32 
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f2:	50                   	push   %eax
  8007f3:	ff 75 10             	pushl  0x10(%ebp)
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	ff 75 08             	pushl  0x8(%ebp)
  8007fc:	e8 92 ff ff ff       	call   800793 <vsnprintf>
	va_end(ap);

	return rc;
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
  800812:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800816:	74 05                	je     80081d <strlen+0x1a>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	eb f5                	jmp    800812 <strlen+0xf>
	return n;
}
  80081d:	5d                   	pop    %ebp
  80081e:	c3                   	ret    

0080081f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80081f:	f3 0f 1e fb          	endbr32 
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	39 d0                	cmp    %edx,%eax
  800833:	74 0d                	je     800842 <strnlen+0x23>
  800835:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800839:	74 05                	je     800840 <strnlen+0x21>
		n++;
  80083b:	83 c0 01             	add    $0x1,%eax
  80083e:	eb f1                	jmp    800831 <strnlen+0x12>
  800840:	89 c2                	mov    %eax,%edx
	return n;
}
  800842:	89 d0                	mov    %edx,%eax
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800846:	f3 0f 1e fb          	endbr32 
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	53                   	push   %ebx
  80084e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800851:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80085d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	84 d2                	test   %dl,%dl
  800865:	75 f2                	jne    800859 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800867:	89 c8                	mov    %ecx,%eax
  800869:	5b                   	pop    %ebx
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086c:	f3 0f 1e fb          	endbr32 
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 10             	sub    $0x10,%esp
  800877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80087a:	53                   	push   %ebx
  80087b:	e8 83 ff ff ff       	call   800803 <strlen>
  800880:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	01 d8                	add    %ebx,%eax
  800888:	50                   	push   %eax
  800889:	e8 b8 ff ff ff       	call   800846 <strcpy>
	return dst;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	56                   	push   %esi
  80089d:	53                   	push   %ebx
  80089e:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 f3                	mov    %esi,%ebx
  8008a6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	39 d8                	cmp    %ebx,%eax
  8008ad:	74 11                	je     8008c0 <strncpy+0x2b>
		*dst++ = *src;
  8008af:	83 c0 01             	add    $0x1,%eax
  8008b2:	0f b6 0a             	movzbl (%edx),%ecx
  8008b5:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b8:	80 f9 01             	cmp    $0x1,%cl
  8008bb:	83 da ff             	sbb    $0xffffffff,%edx
  8008be:	eb eb                	jmp    8008ab <strncpy+0x16>
	}
	return ret;
}
  8008c0:	89 f0                	mov    %esi,%eax
  8008c2:	5b                   	pop    %ebx
  8008c3:	5e                   	pop    %esi
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c6:	f3 0f 1e fb          	endbr32 
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008da:	85 d2                	test   %edx,%edx
  8008dc:	74 21                	je     8008ff <strlcpy+0x39>
  8008de:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008e2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008e4:	39 c2                	cmp    %eax,%edx
  8008e6:	74 14                	je     8008fc <strlcpy+0x36>
  8008e8:	0f b6 19             	movzbl (%ecx),%ebx
  8008eb:	84 db                	test   %bl,%bl
  8008ed:	74 0b                	je     8008fa <strlcpy+0x34>
			*dst++ = *src++;
  8008ef:	83 c1 01             	add    $0x1,%ecx
  8008f2:	83 c2 01             	add    $0x1,%edx
  8008f5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f8:	eb ea                	jmp    8008e4 <strlcpy+0x1e>
  8008fa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008fc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ff:	29 f0                	sub    %esi,%eax
}
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800905:	f3 0f 1e fb          	endbr32 
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800912:	0f b6 01             	movzbl (%ecx),%eax
  800915:	84 c0                	test   %al,%al
  800917:	74 0c                	je     800925 <strcmp+0x20>
  800919:	3a 02                	cmp    (%edx),%al
  80091b:	75 08                	jne    800925 <strcmp+0x20>
		p++, q++;
  80091d:	83 c1 01             	add    $0x1,%ecx
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	eb ed                	jmp    800912 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800925:	0f b6 c0             	movzbl %al,%eax
  800928:	0f b6 12             	movzbl (%edx),%edx
  80092b:	29 d0                	sub    %edx,%eax
}
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80092f:	f3 0f 1e fb          	endbr32 
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	53                   	push   %ebx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093d:	89 c3                	mov    %eax,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800942:	eb 06                	jmp    80094a <strncmp+0x1b>
		n--, p++, q++;
  800944:	83 c0 01             	add    $0x1,%eax
  800947:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80094a:	39 d8                	cmp    %ebx,%eax
  80094c:	74 16                	je     800964 <strncmp+0x35>
  80094e:	0f b6 08             	movzbl (%eax),%ecx
  800951:	84 c9                	test   %cl,%cl
  800953:	74 04                	je     800959 <strncmp+0x2a>
  800955:	3a 0a                	cmp    (%edx),%cl
  800957:	74 eb                	je     800944 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800959:	0f b6 00             	movzbl (%eax),%eax
  80095c:	0f b6 12             	movzbl (%edx),%edx
  80095f:	29 d0                	sub    %edx,%eax
}
  800961:	5b                   	pop    %ebx
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    
		return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
  800969:	eb f6                	jmp    800961 <strncmp+0x32>

0080096b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800979:	0f b6 10             	movzbl (%eax),%edx
  80097c:	84 d2                	test   %dl,%dl
  80097e:	74 09                	je     800989 <strchr+0x1e>
		if (*s == c)
  800980:	38 ca                	cmp    %cl,%dl
  800982:	74 0a                	je     80098e <strchr+0x23>
	for (; *s; s++)
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	eb f0                	jmp    800979 <strchr+0xe>
			return (char *) s;
	return 0;
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800990:	f3 0f 1e fb          	endbr32 
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009a1:	38 ca                	cmp    %cl,%dl
  8009a3:	74 09                	je     8009ae <strfind+0x1e>
  8009a5:	84 d2                	test   %dl,%dl
  8009a7:	74 05                	je     8009ae <strfind+0x1e>
	for (; *s; s++)
  8009a9:	83 c0 01             	add    $0x1,%eax
  8009ac:	eb f0                	jmp    80099e <strfind+0xe>
			break;
	return (char *) s;
}
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b0:	f3 0f 1e fb          	endbr32 
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8009bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009c0:	85 c9                	test   %ecx,%ecx
  8009c2:	74 33                	je     8009f7 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c4:	89 d0                	mov    %edx,%eax
  8009c6:	09 c8                	or     %ecx,%eax
  8009c8:	a8 03                	test   $0x3,%al
  8009ca:	75 23                	jne    8009ef <memset+0x3f>
		c &= 0xFF;
  8009cc:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d0:	89 d8                	mov    %ebx,%eax
  8009d2:	c1 e0 08             	shl    $0x8,%eax
  8009d5:	89 df                	mov    %ebx,%edi
  8009d7:	c1 e7 18             	shl    $0x18,%edi
  8009da:	89 de                	mov    %ebx,%esi
  8009dc:	c1 e6 10             	shl    $0x10,%esi
  8009df:	09 f7                	or     %esi,%edi
  8009e1:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009e3:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e6:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8009e8:	89 d7                	mov    %edx,%edi
  8009ea:	fc                   	cld    
  8009eb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ed:	eb 08                	jmp    8009f7 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ef:	89 d7                	mov    %edx,%edi
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	fc                   	cld    
  8009f5:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5f                   	pop    %edi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	57                   	push   %edi
  800a06:	56                   	push   %esi
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a10:	39 c6                	cmp    %eax,%esi
  800a12:	73 32                	jae    800a46 <memmove+0x48>
  800a14:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a17:	39 c2                	cmp    %eax,%edx
  800a19:	76 2b                	jbe    800a46 <memmove+0x48>
		s += n;
		d += n;
  800a1b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1e:	89 fe                	mov    %edi,%esi
  800a20:	09 ce                	or     %ecx,%esi
  800a22:	09 d6                	or     %edx,%esi
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 0e                	jne    800a3a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a2c:	83 ef 04             	sub    $0x4,%edi
  800a2f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a35:	fd                   	std    
  800a36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a38:	eb 09                	jmp    800a43 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3a:	83 ef 01             	sub    $0x1,%edi
  800a3d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a40:	fd                   	std    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a43:	fc                   	cld    
  800a44:	eb 1a                	jmp    800a60 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a46:	89 c2                	mov    %eax,%edx
  800a48:	09 ca                	or     %ecx,%edx
  800a4a:	09 f2                	or     %esi,%edx
  800a4c:	f6 c2 03             	test   $0x3,%dl
  800a4f:	75 0a                	jne    800a5b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a51:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a54:	89 c7                	mov    %eax,%edi
  800a56:	fc                   	cld    
  800a57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a59:	eb 05                	jmp    800a60 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	fc                   	cld    
  800a5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a6e:	ff 75 10             	pushl  0x10(%ebp)
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	ff 75 08             	pushl  0x8(%ebp)
  800a77:	e8 82 ff ff ff       	call   8009fe <memmove>
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7e:	f3 0f 1e fb          	endbr32 
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	89 c6                	mov    %eax,%esi
  800a8f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a92:	39 f0                	cmp    %esi,%eax
  800a94:	74 1c                	je     800ab2 <memcmp+0x34>
		if (*s1 != *s2)
  800a96:	0f b6 08             	movzbl (%eax),%ecx
  800a99:	0f b6 1a             	movzbl (%edx),%ebx
  800a9c:	38 d9                	cmp    %bl,%cl
  800a9e:	75 08                	jne    800aa8 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	eb ea                	jmp    800a92 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aa8:	0f b6 c1             	movzbl %cl,%eax
  800aab:	0f b6 db             	movzbl %bl,%ebx
  800aae:	29 d8                	sub    %ebx,%eax
  800ab0:	eb 05                	jmp    800ab7 <memcmp+0x39>
	}

	return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5e                   	pop    %esi
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800abb:	f3 0f 1e fb          	endbr32 
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800acd:	39 d0                	cmp    %edx,%eax
  800acf:	73 09                	jae    800ada <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad1:	38 08                	cmp    %cl,(%eax)
  800ad3:	74 05                	je     800ada <memfind+0x1f>
	for (; s < ends; s++)
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	eb f3                	jmp    800acd <memfind+0x12>
			break;
	return (void *) s;
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aec:	eb 03                	jmp    800af1 <strtol+0x15>
		s++;
  800aee:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af1:	0f b6 01             	movzbl (%ecx),%eax
  800af4:	3c 20                	cmp    $0x20,%al
  800af6:	74 f6                	je     800aee <strtol+0x12>
  800af8:	3c 09                	cmp    $0x9,%al
  800afa:	74 f2                	je     800aee <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800afc:	3c 2b                	cmp    $0x2b,%al
  800afe:	74 2a                	je     800b2a <strtol+0x4e>
	int neg = 0;
  800b00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b05:	3c 2d                	cmp    $0x2d,%al
  800b07:	74 2b                	je     800b34 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b0f:	75 0f                	jne    800b20 <strtol+0x44>
  800b11:	80 39 30             	cmpb   $0x30,(%ecx)
  800b14:	74 28                	je     800b3e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b16:	85 db                	test   %ebx,%ebx
  800b18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b1d:	0f 44 d8             	cmove  %eax,%ebx
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
  800b25:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b28:	eb 46                	jmp    800b70 <strtol+0x94>
		s++;
  800b2a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b32:	eb d5                	jmp    800b09 <strtol+0x2d>
		s++, neg = 1;
  800b34:	83 c1 01             	add    $0x1,%ecx
  800b37:	bf 01 00 00 00       	mov    $0x1,%edi
  800b3c:	eb cb                	jmp    800b09 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b42:	74 0e                	je     800b52 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b44:	85 db                	test   %ebx,%ebx
  800b46:	75 d8                	jne    800b20 <strtol+0x44>
		s++, base = 8;
  800b48:	83 c1 01             	add    $0x1,%ecx
  800b4b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b50:	eb ce                	jmp    800b20 <strtol+0x44>
		s += 2, base = 16;
  800b52:	83 c1 02             	add    $0x2,%ecx
  800b55:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b5a:	eb c4                	jmp    800b20 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b5c:	0f be d2             	movsbl %dl,%edx
  800b5f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b62:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b65:	7d 3a                	jge    800ba1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b67:	83 c1 01             	add    $0x1,%ecx
  800b6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b6e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b70:	0f b6 11             	movzbl (%ecx),%edx
  800b73:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b76:	89 f3                	mov    %esi,%ebx
  800b78:	80 fb 09             	cmp    $0x9,%bl
  800b7b:	76 df                	jbe    800b5c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b7d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b80:	89 f3                	mov    %esi,%ebx
  800b82:	80 fb 19             	cmp    $0x19,%bl
  800b85:	77 08                	ja     800b8f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b87:	0f be d2             	movsbl %dl,%edx
  800b8a:	83 ea 57             	sub    $0x57,%edx
  800b8d:	eb d3                	jmp    800b62 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b8f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b92:	89 f3                	mov    %esi,%ebx
  800b94:	80 fb 19             	cmp    $0x19,%bl
  800b97:	77 08                	ja     800ba1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b99:	0f be d2             	movsbl %dl,%edx
  800b9c:	83 ea 37             	sub    $0x37,%edx
  800b9f:	eb c1                	jmp    800b62 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba5:	74 05                	je     800bac <strtol+0xd0>
		*endptr = (char *) s;
  800ba7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800baa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	f7 da                	neg    %edx
  800bb0:	85 ff                	test   %edi,%edi
  800bb2:	0f 45 c2             	cmovne %edx,%eax
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
  800bc0:	83 ec 1c             	sub    $0x1c,%esp
  800bc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bc6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bc9:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd1:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bd4:	8b 75 14             	mov    0x14(%ebp),%esi
  800bd7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdd:	74 04                	je     800be3 <syscall+0x29>
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	7f 08                	jg     800beb <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800beb:	83 ec 0c             	sub    $0xc,%esp
  800bee:	50                   	push   %eax
  800bef:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf2:	68 df 23 80 00       	push   $0x8023df
  800bf7:	6a 23                	push   $0x23
  800bf9:	68 fc 23 80 00       	push   $0x8023fc
  800bfe:	e8 f2 f5 ff ff       	call   8001f5 <_panic>

00800c03 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c03:	f3 0f 1e fb          	endbr32 
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c0d:	6a 00                	push   $0x0
  800c0f:	6a 00                	push   $0x0
  800c11:	6a 00                	push   $0x0
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	e8 92 ff ff ff       	call   800bba <syscall>
}
  800c28:	83 c4 10             	add    $0x10,%esp
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	6a 00                	push   $0x0
  800c3d:	6a 00                	push   $0x0
  800c3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4e:	e8 67 ff ff ff       	call   800bba <syscall>
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c55:	f3 0f 1e fb          	endbr32 
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c5f:	6a 00                	push   $0x0
  800c61:	6a 00                	push   $0x0
  800c63:	6a 00                	push   $0x0
  800c65:	6a 00                	push   $0x0
  800c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c74:	e8 41 ff ff ff       	call   800bba <syscall>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c85:	6a 00                	push   $0x0
  800c87:	6a 00                	push   $0x0
  800c89:	6a 00                	push   $0x0
  800c8b:	6a 00                	push   $0x0
  800c8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9c:	e8 19 ff ff ff       	call   800bba <syscall>
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <sys_yield>:

void
sys_yield(void)
{
  800ca3:	f3 0f 1e fb          	endbr32 
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cad:	6a 00                	push   $0x0
  800caf:	6a 00                	push   $0x0
  800cb1:	6a 00                	push   $0x0
  800cb3:	6a 00                	push   $0x0
  800cb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	e8 f1 fe ff ff       	call   800bba <syscall>
}
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cd8:	6a 00                	push   $0x0
  800cda:	6a 00                	push   $0x0
  800cdc:	ff 75 10             	pushl  0x10(%ebp)
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce5:	ba 01 00 00 00       	mov    $0x1,%edx
  800cea:	b8 04 00 00 00       	mov    $0x4,%eax
  800cef:	e8 c6 fe ff ff       	call   800bba <syscall>
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf6:	f3 0f 1e fb          	endbr32 
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d00:	ff 75 18             	pushl  0x18(%ebp)
  800d03:	ff 75 14             	pushl  0x14(%ebp)
  800d06:	ff 75 10             	pushl  0x10(%ebp)
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d14:	b8 05 00 00 00       	mov    $0x5,%eax
  800d19:	e8 9c fe ff ff       	call   800bba <syscall>
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d20:	f3 0f 1e fb          	endbr32 
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d2a:	6a 00                	push   $0x0
  800d2c:	6a 00                	push   $0x0
  800d2e:	6a 00                	push   $0x0
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d36:	ba 01 00 00 00       	mov    $0x1,%edx
  800d3b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d40:	e8 75 fe ff ff       	call   800bba <syscall>
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d47:	f3 0f 1e fb          	endbr32 
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d51:	6a 00                	push   $0x0
  800d53:	6a 00                	push   $0x0
  800d55:	6a 00                	push   $0x0
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5d:	ba 01 00 00 00       	mov    $0x1,%edx
  800d62:	b8 08 00 00 00       	mov    $0x8,%eax
  800d67:	e8 4e fe ff ff       	call   800bba <syscall>
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d6e:	f3 0f 1e fb          	endbr32 
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d78:	6a 00                	push   $0x0
  800d7a:	6a 00                	push   $0x0
  800d7c:	6a 00                	push   $0x0
  800d7e:	ff 75 0c             	pushl  0xc(%ebp)
  800d81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d84:	ba 01 00 00 00       	mov    $0x1,%edx
  800d89:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8e:	e8 27 fe ff ff       	call   800bba <syscall>
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d95:	f3 0f 1e fb          	endbr32 
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d9f:	6a 00                	push   $0x0
  800da1:	6a 00                	push   $0x0
  800da3:	6a 00                	push   $0x0
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dab:	ba 01 00 00 00       	mov    $0x1,%edx
  800db0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db5:	e8 00 fe ff ff       	call   800bba <syscall>
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbc:	f3 0f 1e fb          	endbr32 
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800dc6:	6a 00                	push   $0x0
  800dc8:	ff 75 14             	pushl  0x14(%ebp)
  800dcb:	ff 75 10             	pushl  0x10(%ebp)
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dde:	e8 d7 fd ff ff       	call   800bba <syscall>
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de5:	f3 0f 1e fb          	endbr32 
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800def:	6a 00                	push   $0x0
  800df1:	6a 00                	push   $0x0
  800df3:	6a 00                	push   $0x0
  800df5:	6a 00                	push   $0x0
  800df7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfa:	ba 01 00 00 00       	mov    $0x1,%edx
  800dff:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e04:	e8 b1 fd ff ff       	call   800bba <syscall>
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e0b:	f3 0f 1e fb          	endbr32 
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	05 00 00 00 30       	add    $0x30000000,%eax
  800e1a:	c1 e8 0c             	shr    $0xc,%eax
}
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e1f:	f3 0f 1e fb          	endbr32 
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	e8 da ff ff ff       	call   800e0b <fd2num>
  800e31:	83 c4 10             	add    $0x10,%esp
  800e34:	c1 e0 0c             	shl    $0xc,%eax
  800e37:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e4a:	89 c2                	mov    %eax,%edx
  800e4c:	c1 ea 16             	shr    $0x16,%edx
  800e4f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e56:	f6 c2 01             	test   $0x1,%dl
  800e59:	74 2d                	je     800e88 <fd_alloc+0x4a>
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	c1 ea 0c             	shr    $0xc,%edx
  800e60:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e67:	f6 c2 01             	test   $0x1,%dl
  800e6a:	74 1c                	je     800e88 <fd_alloc+0x4a>
  800e6c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e71:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e76:	75 d2                	jne    800e4a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e81:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e86:	eb 0a                	jmp    800e92 <fd_alloc+0x54>
			*fd_store = fd;
  800e88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e94:	f3 0f 1e fb          	endbr32 
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e9e:	83 f8 1f             	cmp    $0x1f,%eax
  800ea1:	77 30                	ja     800ed3 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ea3:	c1 e0 0c             	shl    $0xc,%eax
  800ea6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eab:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800eb1:	f6 c2 01             	test   $0x1,%dl
  800eb4:	74 24                	je     800eda <fd_lookup+0x46>
  800eb6:	89 c2                	mov    %eax,%edx
  800eb8:	c1 ea 0c             	shr    $0xc,%edx
  800ebb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ec2:	f6 c2 01             	test   $0x1,%dl
  800ec5:	74 1a                	je     800ee1 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eca:	89 02                	mov    %eax,(%edx)
	return 0;
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
		return -E_INVAL;
  800ed3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed8:	eb f7                	jmp    800ed1 <fd_lookup+0x3d>
		return -E_INVAL;
  800eda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800edf:	eb f0                	jmp    800ed1 <fd_lookup+0x3d>
  800ee1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee6:	eb e9                	jmp    800ed1 <fd_lookup+0x3d>

00800ee8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ee8:	f3 0f 1e fb          	endbr32 
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 08             	sub    $0x8,%esp
  800ef2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef5:	ba 88 24 80 00       	mov    $0x802488,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800efa:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eff:	39 08                	cmp    %ecx,(%eax)
  800f01:	74 33                	je     800f36 <dev_lookup+0x4e>
  800f03:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f06:	8b 02                	mov    (%edx),%eax
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 f3                	jne    800eff <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f0c:	a1 08 40 80 00       	mov    0x804008,%eax
  800f11:	8b 40 48             	mov    0x48(%eax),%eax
  800f14:	83 ec 04             	sub    $0x4,%esp
  800f17:	51                   	push   %ecx
  800f18:	50                   	push   %eax
  800f19:	68 0c 24 80 00       	push   $0x80240c
  800f1e:	e8 b9 f3 ff ff       	call   8002dc <cprintf>
	*dev = 0;
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f2c:	83 c4 10             	add    $0x10,%esp
  800f2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    
			*dev = devtab[i];
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f40:	eb f2                	jmp    800f34 <dev_lookup+0x4c>

00800f42 <fd_close>:
{
  800f42:	f3 0f 1e fb          	endbr32 
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 28             	sub    $0x28,%esp
  800f4f:	8b 75 08             	mov    0x8(%ebp),%esi
  800f52:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f55:	56                   	push   %esi
  800f56:	e8 b0 fe ff ff       	call   800e0b <fd2num>
  800f5b:	83 c4 08             	add    $0x8,%esp
  800f5e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800f61:	52                   	push   %edx
  800f62:	50                   	push   %eax
  800f63:	e8 2c ff ff ff       	call   800e94 <fd_lookup>
  800f68:	89 c3                	mov    %eax,%ebx
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	78 05                	js     800f76 <fd_close+0x34>
	    || fd != fd2)
  800f71:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f74:	74 16                	je     800f8c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f76:	89 f8                	mov    %edi,%eax
  800f78:	84 c0                	test   %al,%al
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	0f 44 d8             	cmove  %eax,%ebx
}
  800f82:	89 d8                	mov    %ebx,%eax
  800f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f92:	50                   	push   %eax
  800f93:	ff 36                	pushl  (%esi)
  800f95:	e8 4e ff ff ff       	call   800ee8 <dev_lookup>
  800f9a:	89 c3                	mov    %eax,%ebx
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	78 1a                	js     800fbd <fd_close+0x7b>
		if (dev->dev_close)
  800fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fa9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	74 0b                	je     800fbd <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	56                   	push   %esi
  800fb6:	ff d0                	call   *%eax
  800fb8:	89 c3                	mov    %eax,%ebx
  800fba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	56                   	push   %esi
  800fc1:	6a 00                	push   $0x0
  800fc3:	e8 58 fd ff ff       	call   800d20 <sys_page_unmap>
	return r;
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	eb b5                	jmp    800f82 <fd_close+0x40>

00800fcd <close>:

int
close(int fdnum)
{
  800fcd:	f3 0f 1e fb          	endbr32 
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fda:	50                   	push   %eax
  800fdb:	ff 75 08             	pushl  0x8(%ebp)
  800fde:	e8 b1 fe ff ff       	call   800e94 <fd_lookup>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	79 02                	jns    800fec <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    
		return fd_close(fd, 1);
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	6a 01                	push   $0x1
  800ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff4:	e8 49 ff ff ff       	call   800f42 <fd_close>
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	eb ec                	jmp    800fea <close+0x1d>

00800ffe <close_all>:

void
close_all(void)
{
  800ffe:	f3 0f 1e fb          	endbr32 
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	53                   	push   %ebx
  801006:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801009:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80100e:	83 ec 0c             	sub    $0xc,%esp
  801011:	53                   	push   %ebx
  801012:	e8 b6 ff ff ff       	call   800fcd <close>
	for (i = 0; i < MAXFD; i++)
  801017:	83 c3 01             	add    $0x1,%ebx
  80101a:	83 c4 10             	add    $0x10,%esp
  80101d:	83 fb 20             	cmp    $0x20,%ebx
  801020:	75 ec                	jne    80100e <close_all+0x10>
}
  801022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801027:	f3 0f 1e fb          	endbr32 
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
  801031:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801034:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	ff 75 08             	pushl  0x8(%ebp)
  80103b:	e8 54 fe ff ff       	call   800e94 <fd_lookup>
  801040:	89 c3                	mov    %eax,%ebx
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	0f 88 81 00 00 00    	js     8010ce <dup+0xa7>
		return r;
	close(newfdnum);
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	e8 75 ff ff ff       	call   800fcd <close>

	newfd = INDEX2FD(newfdnum);
  801058:	8b 75 0c             	mov    0xc(%ebp),%esi
  80105b:	c1 e6 0c             	shl    $0xc,%esi
  80105e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801064:	83 c4 04             	add    $0x4,%esp
  801067:	ff 75 e4             	pushl  -0x1c(%ebp)
  80106a:	e8 b0 fd ff ff       	call   800e1f <fd2data>
  80106f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801071:	89 34 24             	mov    %esi,(%esp)
  801074:	e8 a6 fd ff ff       	call   800e1f <fd2data>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80107e:	89 d8                	mov    %ebx,%eax
  801080:	c1 e8 16             	shr    $0x16,%eax
  801083:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80108a:	a8 01                	test   $0x1,%al
  80108c:	74 11                	je     80109f <dup+0x78>
  80108e:	89 d8                	mov    %ebx,%eax
  801090:	c1 e8 0c             	shr    $0xc,%eax
  801093:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80109a:	f6 c2 01             	test   $0x1,%dl
  80109d:	75 39                	jne    8010d8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80109f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	c1 e8 0c             	shr    $0xc,%eax
  8010a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b6:	50                   	push   %eax
  8010b7:	56                   	push   %esi
  8010b8:	6a 00                	push   $0x0
  8010ba:	52                   	push   %edx
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 34 fc ff ff       	call   800cf6 <sys_page_map>
  8010c2:	89 c3                	mov    %eax,%ebx
  8010c4:	83 c4 20             	add    $0x20,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 31                	js     8010fc <dup+0xd5>
		goto err;

	return newfdnum;
  8010cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e7:	50                   	push   %eax
  8010e8:	57                   	push   %edi
  8010e9:	6a 00                	push   $0x0
  8010eb:	53                   	push   %ebx
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 03 fc ff ff       	call   800cf6 <sys_page_map>
  8010f3:	89 c3                	mov    %eax,%ebx
  8010f5:	83 c4 20             	add    $0x20,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	79 a3                	jns    80109f <dup+0x78>
	sys_page_unmap(0, newfd);
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	56                   	push   %esi
  801100:	6a 00                	push   $0x0
  801102:	e8 19 fc ff ff       	call   800d20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801107:	83 c4 08             	add    $0x8,%esp
  80110a:	57                   	push   %edi
  80110b:	6a 00                	push   $0x0
  80110d:	e8 0e fc ff ff       	call   800d20 <sys_page_unmap>
	return r;
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	eb b7                	jmp    8010ce <dup+0xa7>

00801117 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801117:	f3 0f 1e fb          	endbr32 
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	53                   	push   %ebx
  80111f:	83 ec 1c             	sub    $0x1c,%esp
  801122:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801125:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801128:	50                   	push   %eax
  801129:	53                   	push   %ebx
  80112a:	e8 65 fd ff ff       	call   800e94 <fd_lookup>
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 3f                	js     801175 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801136:	83 ec 08             	sub    $0x8,%esp
  801139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80113c:	50                   	push   %eax
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	ff 30                	pushl  (%eax)
  801142:	e8 a1 fd ff ff       	call   800ee8 <dev_lookup>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	78 27                	js     801175 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80114e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801151:	8b 42 08             	mov    0x8(%edx),%eax
  801154:	83 e0 03             	and    $0x3,%eax
  801157:	83 f8 01             	cmp    $0x1,%eax
  80115a:	74 1e                	je     80117a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115f:	8b 40 08             	mov    0x8(%eax),%eax
  801162:	85 c0                	test   %eax,%eax
  801164:	74 35                	je     80119b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	ff 75 10             	pushl  0x10(%ebp)
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	52                   	push   %edx
  801170:	ff d0                	call   *%eax
  801172:	83 c4 10             	add    $0x10,%esp
}
  801175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801178:	c9                   	leave  
  801179:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80117a:	a1 08 40 80 00       	mov    0x804008,%eax
  80117f:	8b 40 48             	mov    0x48(%eax),%eax
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	53                   	push   %ebx
  801186:	50                   	push   %eax
  801187:	68 4d 24 80 00       	push   $0x80244d
  80118c:	e8 4b f1 ff ff       	call   8002dc <cprintf>
		return -E_INVAL;
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801199:	eb da                	jmp    801175 <read+0x5e>
		return -E_NOT_SUPP;
  80119b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011a0:	eb d3                	jmp    801175 <read+0x5e>

008011a2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011a2:	f3 0f 1e fb          	endbr32 
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ba:	eb 02                	jmp    8011be <readn+0x1c>
  8011bc:	01 c3                	add    %eax,%ebx
  8011be:	39 f3                	cmp    %esi,%ebx
  8011c0:	73 21                	jae    8011e3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011c2:	83 ec 04             	sub    $0x4,%esp
  8011c5:	89 f0                	mov    %esi,%eax
  8011c7:	29 d8                	sub    %ebx,%eax
  8011c9:	50                   	push   %eax
  8011ca:	89 d8                	mov    %ebx,%eax
  8011cc:	03 45 0c             	add    0xc(%ebp),%eax
  8011cf:	50                   	push   %eax
  8011d0:	57                   	push   %edi
  8011d1:	e8 41 ff ff ff       	call   801117 <read>
		if (m < 0)
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 04                	js     8011e1 <readn+0x3f>
			return m;
		if (m == 0)
  8011dd:	75 dd                	jne    8011bc <readn+0x1a>
  8011df:	eb 02                	jmp    8011e3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011e3:	89 d8                	mov    %ebx,%eax
  8011e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011ed:	f3 0f 1e fb          	endbr32 
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 1c             	sub    $0x1c,%esp
  8011f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	53                   	push   %ebx
  801200:	e8 8f fc ff ff       	call   800e94 <fd_lookup>
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 3a                	js     801246 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801216:	ff 30                	pushl  (%eax)
  801218:	e8 cb fc ff ff       	call   800ee8 <dev_lookup>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	78 22                	js     801246 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801227:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80122b:	74 1e                	je     80124b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80122d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801230:	8b 52 0c             	mov    0xc(%edx),%edx
  801233:	85 d2                	test   %edx,%edx
  801235:	74 35                	je     80126c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	ff 75 10             	pushl  0x10(%ebp)
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	50                   	push   %eax
  801241:	ff d2                	call   *%edx
  801243:	83 c4 10             	add    $0x10,%esp
}
  801246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801249:	c9                   	leave  
  80124a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80124b:	a1 08 40 80 00       	mov    0x804008,%eax
  801250:	8b 40 48             	mov    0x48(%eax),%eax
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	53                   	push   %ebx
  801257:	50                   	push   %eax
  801258:	68 69 24 80 00       	push   $0x802469
  80125d:	e8 7a f0 ff ff       	call   8002dc <cprintf>
		return -E_INVAL;
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126a:	eb da                	jmp    801246 <write+0x59>
		return -E_NOT_SUPP;
  80126c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801271:	eb d3                	jmp    801246 <write+0x59>

00801273 <seek>:

int
seek(int fdnum, off_t offset)
{
  801273:	f3 0f 1e fb          	endbr32 
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 0b fc ff ff       	call   800e94 <fd_lookup>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 0e                	js     80129e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801290:	8b 55 0c             	mov    0xc(%ebp),%edx
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 1c             	sub    $0x1c,%esp
  8012ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	53                   	push   %ebx
  8012b3:	e8 dc fb ff ff       	call   800e94 <fd_lookup>
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	78 37                	js     8012f6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c5:	50                   	push   %eax
  8012c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c9:	ff 30                	pushl  (%eax)
  8012cb:	e8 18 fc ff ff       	call   800ee8 <dev_lookup>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 1f                	js     8012f6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012de:	74 1b                	je     8012fb <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e3:	8b 52 18             	mov    0x18(%edx),%edx
  8012e6:	85 d2                	test   %edx,%edx
  8012e8:	74 32                	je     80131c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012ea:	83 ec 08             	sub    $0x8,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	50                   	push   %eax
  8012f1:	ff d2                	call   *%edx
  8012f3:	83 c4 10             	add    $0x10,%esp
}
  8012f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012fb:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801300:	8b 40 48             	mov    0x48(%eax),%eax
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	53                   	push   %ebx
  801307:	50                   	push   %eax
  801308:	68 2c 24 80 00       	push   $0x80242c
  80130d:	e8 ca ef ff ff       	call   8002dc <cprintf>
		return -E_INVAL;
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131a:	eb da                	jmp    8012f6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80131c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801321:	eb d3                	jmp    8012f6 <ftruncate+0x56>

00801323 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801323:	f3 0f 1e fb          	endbr32 
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	53                   	push   %ebx
  80132b:	83 ec 1c             	sub    $0x1c,%esp
  80132e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801331:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801334:	50                   	push   %eax
  801335:	ff 75 08             	pushl  0x8(%ebp)
  801338:	e8 57 fb ff ff       	call   800e94 <fd_lookup>
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	78 4b                	js     80138f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801344:	83 ec 08             	sub    $0x8,%esp
  801347:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134a:	50                   	push   %eax
  80134b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134e:	ff 30                	pushl  (%eax)
  801350:	e8 93 fb ff ff       	call   800ee8 <dev_lookup>
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 33                	js     80138f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80135c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801363:	74 2f                	je     801394 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801365:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801368:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80136f:	00 00 00 
	stat->st_isdir = 0;
  801372:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801379:	00 00 00 
	stat->st_dev = dev;
  80137c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	53                   	push   %ebx
  801386:	ff 75 f0             	pushl  -0x10(%ebp)
  801389:	ff 50 14             	call   *0x14(%eax)
  80138c:	83 c4 10             	add    $0x10,%esp
}
  80138f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801392:	c9                   	leave  
  801393:	c3                   	ret    
		return -E_NOT_SUPP;
  801394:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801399:	eb f4                	jmp    80138f <fstat+0x6c>

0080139b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80139b:	f3 0f 1e fb          	endbr32 
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	6a 00                	push   $0x0
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	e8 3a 02 00 00       	call   8015eb <open>
  8013b1:	89 c3                	mov    %eax,%ebx
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 1b                	js     8013d5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	50                   	push   %eax
  8013c1:	e8 5d ff ff ff       	call   801323 <fstat>
  8013c6:	89 c6                	mov    %eax,%esi
	close(fd);
  8013c8:	89 1c 24             	mov    %ebx,(%esp)
  8013cb:	e8 fd fb ff ff       	call   800fcd <close>
	return r;
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 f3                	mov    %esi,%ebx
}
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	89 c6                	mov    %eax,%esi
  8013e5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013e7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8013ee:	74 27                	je     801417 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013f0:	6a 07                	push   $0x7
  8013f2:	68 00 50 80 00       	push   $0x805000
  8013f7:	56                   	push   %esi
  8013f8:	ff 35 04 40 80 00    	pushl  0x804004
  8013fe:	e8 21 09 00 00       	call   801d24 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801403:	83 c4 0c             	add    $0xc,%esp
  801406:	6a 00                	push   $0x0
  801408:	53                   	push   %ebx
  801409:	6a 00                	push   $0x0
  80140b:	e8 a7 08 00 00       	call   801cb7 <ipc_recv>
}
  801410:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801413:	5b                   	pop    %ebx
  801414:	5e                   	pop    %esi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	6a 01                	push   $0x1
  80141c:	e8 5b 09 00 00       	call   801d7c <ipc_find_env>
  801421:	a3 04 40 80 00       	mov    %eax,0x804004
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb c5                	jmp    8013f0 <fsipc+0x12>

0080142b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8b 40 0c             	mov    0xc(%eax),%eax
  80143b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801448:	ba 00 00 00 00       	mov    $0x0,%edx
  80144d:	b8 02 00 00 00       	mov    $0x2,%eax
  801452:	e8 87 ff ff ff       	call   8013de <fsipc>
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <devfile_flush>:
{
  801459:	f3 0f 1e fb          	endbr32 
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8b 40 0c             	mov    0xc(%eax),%eax
  801469:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80146e:	ba 00 00 00 00       	mov    $0x0,%edx
  801473:	b8 06 00 00 00       	mov    $0x6,%eax
  801478:	e8 61 ff ff ff       	call   8013de <fsipc>
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <devfile_stat>:
{
  80147f:	f3 0f 1e fb          	endbr32 
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	53                   	push   %ebx
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8b 40 0c             	mov    0xc(%eax),%eax
  801493:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801498:	ba 00 00 00 00       	mov    $0x0,%edx
  80149d:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a2:	e8 37 ff ff ff       	call   8013de <fsipc>
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 2c                	js     8014d7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	68 00 50 80 00       	push   $0x805000
  8014b3:	53                   	push   %ebx
  8014b4:	e8 8d f3 ff ff       	call   800846 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014b9:	a1 80 50 80 00       	mov    0x805080,%eax
  8014be:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014c4:	a1 84 50 80 00       	mov    0x805084,%eax
  8014c9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <devfile_write>:
{
  8014dc:	f3 0f 1e fb          	endbr32 
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014f5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014fb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801501:	77 30                	ja     801533 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	53                   	push   %ebx
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	68 08 50 80 00       	push   $0x805008
  80150f:	e8 ea f4 ff ff       	call   8009fe <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801514:	ba 00 00 00 00       	mov    $0x0,%edx
  801519:	b8 04 00 00 00       	mov    $0x4,%eax
  80151e:	e8 bb fe ff ff       	call   8013de <fsipc>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 04                	js     80152e <devfile_write+0x52>
	assert(r <= n);
  80152a:	39 d8                	cmp    %ebx,%eax
  80152c:	77 1e                	ja     80154c <devfile_write+0x70>
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801533:	68 98 24 80 00       	push   $0x802498
  801538:	68 c5 24 80 00       	push   $0x8024c5
  80153d:	68 94 00 00 00       	push   $0x94
  801542:	68 da 24 80 00       	push   $0x8024da
  801547:	e8 a9 ec ff ff       	call   8001f5 <_panic>
	assert(r <= n);
  80154c:	68 e5 24 80 00       	push   $0x8024e5
  801551:	68 c5 24 80 00       	push   $0x8024c5
  801556:	68 98 00 00 00       	push   $0x98
  80155b:	68 da 24 80 00       	push   $0x8024da
  801560:	e8 90 ec ff ff       	call   8001f5 <_panic>

00801565 <devfile_read>:
{
  801565:	f3 0f 1e fb          	endbr32 
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8b 40 0c             	mov    0xc(%eax),%eax
  801577:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80157c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801582:	ba 00 00 00 00       	mov    $0x0,%edx
  801587:	b8 03 00 00 00       	mov    $0x3,%eax
  80158c:	e8 4d fe ff ff       	call   8013de <fsipc>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	85 c0                	test   %eax,%eax
  801595:	78 1f                	js     8015b6 <devfile_read+0x51>
	assert(r <= n);
  801597:	39 f0                	cmp    %esi,%eax
  801599:	77 24                	ja     8015bf <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80159b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015a0:	7f 33                	jg     8015d5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	50                   	push   %eax
  8015a6:	68 00 50 80 00       	push   $0x805000
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 4b f4 ff ff       	call   8009fe <memmove>
	return r;
  8015b3:	83 c4 10             	add    $0x10,%esp
}
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    
	assert(r <= n);
  8015bf:	68 e5 24 80 00       	push   $0x8024e5
  8015c4:	68 c5 24 80 00       	push   $0x8024c5
  8015c9:	6a 7c                	push   $0x7c
  8015cb:	68 da 24 80 00       	push   $0x8024da
  8015d0:	e8 20 ec ff ff       	call   8001f5 <_panic>
	assert(r <= PGSIZE);
  8015d5:	68 ec 24 80 00       	push   $0x8024ec
  8015da:	68 c5 24 80 00       	push   $0x8024c5
  8015df:	6a 7d                	push   $0x7d
  8015e1:	68 da 24 80 00       	push   $0x8024da
  8015e6:	e8 0a ec ff ff       	call   8001f5 <_panic>

008015eb <open>:
{
  8015eb:	f3 0f 1e fb          	endbr32 
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	56                   	push   %esi
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 1c             	sub    $0x1c,%esp
  8015f7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015fa:	56                   	push   %esi
  8015fb:	e8 03 f2 ff ff       	call   800803 <strlen>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801608:	7f 6c                	jg     801676 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	e8 28 f8 ff ff       	call   800e3e <fd_alloc>
  801616:	89 c3                	mov    %eax,%ebx
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 3c                	js     80165b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	56                   	push   %esi
  801623:	68 00 50 80 00       	push   $0x805000
  801628:	e8 19 f2 ff ff       	call   800846 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801638:	b8 01 00 00 00       	mov    $0x1,%eax
  80163d:	e8 9c fd ff ff       	call   8013de <fsipc>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 19                	js     801664 <open+0x79>
	return fd2num(fd);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 f4             	pushl  -0xc(%ebp)
  801651:	e8 b5 f7 ff ff       	call   800e0b <fd2num>
  801656:	89 c3                	mov    %eax,%ebx
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	89 d8                	mov    %ebx,%eax
  80165d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801660:	5b                   	pop    %ebx
  801661:	5e                   	pop    %esi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    
		fd_close(fd, 0);
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	6a 00                	push   $0x0
  801669:	ff 75 f4             	pushl  -0xc(%ebp)
  80166c:	e8 d1 f8 ff ff       	call   800f42 <fd_close>
		return r;
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	eb e5                	jmp    80165b <open+0x70>
		return -E_BAD_PATH;
  801676:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80167b:	eb de                	jmp    80165b <open+0x70>

0080167d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80167d:	f3 0f 1e fb          	endbr32 
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	b8 08 00 00 00       	mov    $0x8,%eax
  801691:	e8 48 fd ff ff       	call   8013de <fsipc>
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801698:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80169c:	7f 01                	jg     80169f <writebuf+0x7>
  80169e:	c3                   	ret    
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8016a8:	ff 70 04             	pushl  0x4(%eax)
  8016ab:	8d 40 10             	lea    0x10(%eax),%eax
  8016ae:	50                   	push   %eax
  8016af:	ff 33                	pushl  (%ebx)
  8016b1:	e8 37 fb ff ff       	call   8011ed <write>
		if (result > 0)
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	7e 03                	jle    8016c0 <writebuf+0x28>
			b->result += result;
  8016bd:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016c0:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016c3:	74 0d                	je     8016d2 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	0f 4f c2             	cmovg  %edx,%eax
  8016cf:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <putch>:

static void
putch(int ch, void *thunk)
{
  8016d7:	f3 0f 1e fb          	endbr32 
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	53                   	push   %ebx
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016e5:	8b 53 04             	mov    0x4(%ebx),%edx
  8016e8:	8d 42 01             	lea    0x1(%edx),%eax
  8016eb:	89 43 04             	mov    %eax,0x4(%ebx)
  8016ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f1:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016f5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8016fa:	74 06                	je     801702 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8016fc:	83 c4 04             	add    $0x4,%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		writebuf(b);
  801702:	89 d8                	mov    %ebx,%eax
  801704:	e8 8f ff ff ff       	call   801698 <writebuf>
		b->idx = 0;
  801709:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801710:	eb ea                	jmp    8016fc <putch+0x25>

00801712 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801712:	f3 0f 1e fb          	endbr32 
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801728:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80172f:	00 00 00 
	b.result = 0;
  801732:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801739:	00 00 00 
	b.error = 1;
  80173c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801743:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801746:	ff 75 10             	pushl  0x10(%ebp)
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	68 d7 16 80 00       	push   $0x8016d7
  801758:	e8 e2 ec ff ff       	call   80043f <vprintfmt>
	if (b.idx > 0)
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801767:	7f 11                	jg     80177a <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801769:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80176f:	85 c0                	test   %eax,%eax
  801771:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    
		writebuf(&b);
  80177a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801780:	e8 13 ff ff ff       	call   801698 <writebuf>
  801785:	eb e2                	jmp    801769 <vfprintf+0x57>

00801787 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801787:	f3 0f 1e fb          	endbr32 
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801791:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801794:	50                   	push   %eax
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 72 ff ff ff       	call   801712 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <printf>:

int
printf(const char *fmt, ...)
{
  8017a2:	f3 0f 1e fb          	endbr32 
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8017af:	50                   	push   %eax
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	6a 01                	push   $0x1
  8017b5:	e8 58 ff ff ff       	call   801712 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017bc:	f3 0f 1e fb          	endbr32 
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
  8017c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	e8 4c f6 ff ff       	call   800e1f <fd2data>
  8017d3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017d5:	83 c4 08             	add    $0x8,%esp
  8017d8:	68 f8 24 80 00       	push   $0x8024f8
  8017dd:	53                   	push   %ebx
  8017de:	e8 63 f0 ff ff       	call   800846 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017e3:	8b 46 04             	mov    0x4(%esi),%eax
  8017e6:	2b 06                	sub    (%esi),%eax
  8017e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017f5:	00 00 00 
	stat->st_dev = &devpipe;
  8017f8:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8017ff:	30 80 00 
	return 0;
}
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80180e:	f3 0f 1e fb          	endbr32 
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	53                   	push   %ebx
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80181c:	53                   	push   %ebx
  80181d:	6a 00                	push   $0x0
  80181f:	e8 fc f4 ff ff       	call   800d20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801824:	89 1c 24             	mov    %ebx,(%esp)
  801827:	e8 f3 f5 ff ff       	call   800e1f <fd2data>
  80182c:	83 c4 08             	add    $0x8,%esp
  80182f:	50                   	push   %eax
  801830:	6a 00                	push   $0x0
  801832:	e8 e9 f4 ff ff       	call   800d20 <sys_page_unmap>
}
  801837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <_pipeisclosed>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	57                   	push   %edi
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	83 ec 1c             	sub    $0x1c,%esp
  801845:	89 c7                	mov    %eax,%edi
  801847:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801849:	a1 08 40 80 00       	mov    0x804008,%eax
  80184e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	57                   	push   %edi
  801855:	e8 5f 05 00 00       	call   801db9 <pageref>
  80185a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80185d:	89 34 24             	mov    %esi,(%esp)
  801860:	e8 54 05 00 00       	call   801db9 <pageref>
		nn = thisenv->env_runs;
  801865:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80186b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	39 cb                	cmp    %ecx,%ebx
  801873:	74 1b                	je     801890 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801875:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801878:	75 cf                	jne    801849 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80187a:	8b 42 58             	mov    0x58(%edx),%eax
  80187d:	6a 01                	push   $0x1
  80187f:	50                   	push   %eax
  801880:	53                   	push   %ebx
  801881:	68 ff 24 80 00       	push   $0x8024ff
  801886:	e8 51 ea ff ff       	call   8002dc <cprintf>
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	eb b9                	jmp    801849 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801890:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801893:	0f 94 c0             	sete   %al
  801896:	0f b6 c0             	movzbl %al,%eax
}
  801899:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5f                   	pop    %edi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <devpipe_write>:
{
  8018a1:	f3 0f 1e fb          	endbr32 
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	57                   	push   %edi
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
  8018ab:	83 ec 28             	sub    $0x28,%esp
  8018ae:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018b1:	56                   	push   %esi
  8018b2:	e8 68 f5 ff ff       	call   800e1f <fd2data>
  8018b7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018c4:	74 4f                	je     801915 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018c6:	8b 43 04             	mov    0x4(%ebx),%eax
  8018c9:	8b 0b                	mov    (%ebx),%ecx
  8018cb:	8d 51 20             	lea    0x20(%ecx),%edx
  8018ce:	39 d0                	cmp    %edx,%eax
  8018d0:	72 14                	jb     8018e6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8018d2:	89 da                	mov    %ebx,%edx
  8018d4:	89 f0                	mov    %esi,%eax
  8018d6:	e8 61 ff ff ff       	call   80183c <_pipeisclosed>
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	75 3b                	jne    80191a <devpipe_write+0x79>
			sys_yield();
  8018df:	e8 bf f3 ff ff       	call   800ca3 <sys_yield>
  8018e4:	eb e0                	jmp    8018c6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018ed:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018f0:	89 c2                	mov    %eax,%edx
  8018f2:	c1 fa 1f             	sar    $0x1f,%edx
  8018f5:	89 d1                	mov    %edx,%ecx
  8018f7:	c1 e9 1b             	shr    $0x1b,%ecx
  8018fa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018fd:	83 e2 1f             	and    $0x1f,%edx
  801900:	29 ca                	sub    %ecx,%edx
  801902:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801906:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80190a:	83 c0 01             	add    $0x1,%eax
  80190d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801910:	83 c7 01             	add    $0x1,%edi
  801913:	eb ac                	jmp    8018c1 <devpipe_write+0x20>
	return i;
  801915:	8b 45 10             	mov    0x10(%ebp),%eax
  801918:	eb 05                	jmp    80191f <devpipe_write+0x7e>
				return 0;
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801922:	5b                   	pop    %ebx
  801923:	5e                   	pop    %esi
  801924:	5f                   	pop    %edi
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    

00801927 <devpipe_read>:
{
  801927:	f3 0f 1e fb          	endbr32 
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	57                   	push   %edi
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	83 ec 18             	sub    $0x18,%esp
  801934:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801937:	57                   	push   %edi
  801938:	e8 e2 f4 ff ff       	call   800e1f <fd2data>
  80193d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	be 00 00 00 00       	mov    $0x0,%esi
  801947:	3b 75 10             	cmp    0x10(%ebp),%esi
  80194a:	75 14                	jne    801960 <devpipe_read+0x39>
	return i;
  80194c:	8b 45 10             	mov    0x10(%ebp),%eax
  80194f:	eb 02                	jmp    801953 <devpipe_read+0x2c>
				return i;
  801951:	89 f0                	mov    %esi,%eax
}
  801953:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    
			sys_yield();
  80195b:	e8 43 f3 ff ff       	call   800ca3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801960:	8b 03                	mov    (%ebx),%eax
  801962:	3b 43 04             	cmp    0x4(%ebx),%eax
  801965:	75 18                	jne    80197f <devpipe_read+0x58>
			if (i > 0)
  801967:	85 f6                	test   %esi,%esi
  801969:	75 e6                	jne    801951 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80196b:	89 da                	mov    %ebx,%edx
  80196d:	89 f8                	mov    %edi,%eax
  80196f:	e8 c8 fe ff ff       	call   80183c <_pipeisclosed>
  801974:	85 c0                	test   %eax,%eax
  801976:	74 e3                	je     80195b <devpipe_read+0x34>
				return 0;
  801978:	b8 00 00 00 00       	mov    $0x0,%eax
  80197d:	eb d4                	jmp    801953 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80197f:	99                   	cltd   
  801980:	c1 ea 1b             	shr    $0x1b,%edx
  801983:	01 d0                	add    %edx,%eax
  801985:	83 e0 1f             	and    $0x1f,%eax
  801988:	29 d0                	sub    %edx,%eax
  80198a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80198f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801992:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801995:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801998:	83 c6 01             	add    $0x1,%esi
  80199b:	eb aa                	jmp    801947 <devpipe_read+0x20>

0080199d <pipe>:
{
  80199d:	f3 0f 1e fb          	endbr32 
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ac:	50                   	push   %eax
  8019ad:	e8 8c f4 ff ff       	call   800e3e <fd_alloc>
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	0f 88 23 01 00 00    	js     801ae2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	68 07 04 00 00       	push   $0x407
  8019c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ca:	6a 00                	push   $0x0
  8019cc:	e8 fd f2 ff ff       	call   800cce <sys_page_alloc>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	0f 88 04 01 00 00    	js     801ae2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e4:	50                   	push   %eax
  8019e5:	e8 54 f4 ff ff       	call   800e3e <fd_alloc>
  8019ea:	89 c3                	mov    %eax,%ebx
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	0f 88 db 00 00 00    	js     801ad2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	68 07 04 00 00       	push   $0x407
  8019ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801a02:	6a 00                	push   $0x0
  801a04:	e8 c5 f2 ff ff       	call   800cce <sys_page_alloc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	0f 88 bc 00 00 00    	js     801ad2 <pipe+0x135>
	va = fd2data(fd0);
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1c:	e8 fe f3 ff ff       	call   800e1f <fd2data>
  801a21:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a23:	83 c4 0c             	add    $0xc,%esp
  801a26:	68 07 04 00 00       	push   $0x407
  801a2b:	50                   	push   %eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	e8 9b f2 ff ff       	call   800cce <sys_page_alloc>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	0f 88 82 00 00 00    	js     801ac2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a40:	83 ec 0c             	sub    $0xc,%esp
  801a43:	ff 75 f0             	pushl  -0x10(%ebp)
  801a46:	e8 d4 f3 ff ff       	call   800e1f <fd2data>
  801a4b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a52:	50                   	push   %eax
  801a53:	6a 00                	push   $0x0
  801a55:	56                   	push   %esi
  801a56:	6a 00                	push   $0x0
  801a58:	e8 99 f2 ff ff       	call   800cf6 <sys_page_map>
  801a5d:	89 c3                	mov    %eax,%ebx
  801a5f:	83 c4 20             	add    $0x20,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 4e                	js     801ab4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801a66:	a1 24 30 80 00       	mov    0x803024,%eax
  801a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a73:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a82:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8f:	e8 77 f3 ff ff       	call   800e0b <fd2num>
  801a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a97:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a99:	83 c4 04             	add    $0x4,%esp
  801a9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801a9f:	e8 67 f3 ff ff       	call   800e0b <fd2num>
  801aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab2:	eb 2e                	jmp    801ae2 <pipe+0x145>
	sys_page_unmap(0, va);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	56                   	push   %esi
  801ab8:	6a 00                	push   $0x0
  801aba:	e8 61 f2 ff ff       	call   800d20 <sys_page_unmap>
  801abf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 51 f2 ff ff       	call   800d20 <sys_page_unmap>
  801acf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad8:	6a 00                	push   $0x0
  801ada:	e8 41 f2 ff ff       	call   800d20 <sys_page_unmap>
  801adf:	83 c4 10             	add    $0x10,%esp
}
  801ae2:	89 d8                	mov    %ebx,%eax
  801ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <pipeisclosed>:
{
  801aeb:	f3 0f 1e fb          	endbr32 
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af8:	50                   	push   %eax
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	e8 93 f3 ff ff       	call   800e94 <fd_lookup>
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	85 c0                	test   %eax,%eax
  801b06:	78 18                	js     801b20 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801b08:	83 ec 0c             	sub    $0xc,%esp
  801b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0e:	e8 0c f3 ff ff       	call   800e1f <fd2data>
  801b13:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b18:	e8 1f fd ff ff       	call   80183c <_pipeisclosed>
  801b1d:	83 c4 10             	add    $0x10,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b22:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2b:	c3                   	ret    

00801b2c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b2c:	f3 0f 1e fb          	endbr32 
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b36:	68 17 25 80 00       	push   $0x802517
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	e8 03 ed ff ff       	call   800846 <strcpy>
	return 0;
}
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <devcons_write>:
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b5a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b5f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b65:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b68:	73 31                	jae    801b9b <devcons_write+0x51>
		m = n - tot;
  801b6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b6d:	29 f3                	sub    %esi,%ebx
  801b6f:	83 fb 7f             	cmp    $0x7f,%ebx
  801b72:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b77:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	53                   	push   %ebx
  801b7e:	89 f0                	mov    %esi,%eax
  801b80:	03 45 0c             	add    0xc(%ebp),%eax
  801b83:	50                   	push   %eax
  801b84:	57                   	push   %edi
  801b85:	e8 74 ee ff ff       	call   8009fe <memmove>
		sys_cputs(buf, m);
  801b8a:	83 c4 08             	add    $0x8,%esp
  801b8d:	53                   	push   %ebx
  801b8e:	57                   	push   %edi
  801b8f:	e8 6f f0 ff ff       	call   800c03 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b94:	01 de                	add    %ebx,%esi
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	eb ca                	jmp    801b65 <devcons_write+0x1b>
}
  801b9b:	89 f0                	mov    %esi,%eax
  801b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    

00801ba5 <devcons_read>:
{
  801ba5:	f3 0f 1e fb          	endbr32 
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801bb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bb8:	74 21                	je     801bdb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801bba:	e8 6e f0 ff ff       	call   800c2d <sys_cgetc>
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	75 07                	jne    801bca <devcons_read+0x25>
		sys_yield();
  801bc3:	e8 db f0 ff ff       	call   800ca3 <sys_yield>
  801bc8:	eb f0                	jmp    801bba <devcons_read+0x15>
	if (c < 0)
  801bca:	78 0f                	js     801bdb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801bcc:	83 f8 04             	cmp    $0x4,%eax
  801bcf:	74 0c                	je     801bdd <devcons_read+0x38>
	*(char*)vbuf = c;
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	88 02                	mov    %al,(%edx)
	return 1;
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    
		return 0;
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	eb f7                	jmp    801bdb <devcons_read+0x36>

00801be4 <cputchar>:
{
  801be4:	f3 0f 1e fb          	endbr32 
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801bf4:	6a 01                	push   $0x1
  801bf6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bf9:	50                   	push   %eax
  801bfa:	e8 04 f0 ff ff       	call   800c03 <sys_cputs>
}
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <getchar>:
{
  801c04:	f3 0f 1e fb          	endbr32 
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c0e:	6a 01                	push   $0x1
  801c10:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c13:	50                   	push   %eax
  801c14:	6a 00                	push   $0x0
  801c16:	e8 fc f4 ff ff       	call   801117 <read>
	if (r < 0)
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 06                	js     801c28 <getchar+0x24>
	if (r < 1)
  801c22:	74 06                	je     801c2a <getchar+0x26>
	return c;
  801c24:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    
		return -E_EOF;
  801c2a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c2f:	eb f7                	jmp    801c28 <getchar+0x24>

00801c31 <iscons>:
{
  801c31:	f3 0f 1e fb          	endbr32 
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3e:	50                   	push   %eax
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	e8 4d f2 ff ff       	call   800e94 <fd_lookup>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 11                	js     801c5f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c57:	39 10                	cmp    %edx,(%eax)
  801c59:	0f 94 c0             	sete   %al
  801c5c:	0f b6 c0             	movzbl %al,%eax
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <opencons>:
{
  801c61:	f3 0f 1e fb          	endbr32 
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6e:	50                   	push   %eax
  801c6f:	e8 ca f1 ff ff       	call   800e3e <fd_alloc>
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	85 c0                	test   %eax,%eax
  801c79:	78 3a                	js     801cb5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	68 07 04 00 00       	push   $0x407
  801c83:	ff 75 f4             	pushl  -0xc(%ebp)
  801c86:	6a 00                	push   $0x0
  801c88:	e8 41 f0 ff ff       	call   800cce <sys_page_alloc>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 21                	js     801cb5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c97:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c9d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	50                   	push   %eax
  801cad:	e8 59 f1 ff ff       	call   800e0b <fd2num>
  801cb2:	83 c4 10             	add    $0x10,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cb7:	f3 0f 1e fb          	endbr32 
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801cd0:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	50                   	push   %eax
  801cd7:	e8 09 f1 ff ff       	call   800de5 <sys_ipc_recv>
	if (r < 0) {
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 2b                	js     801d0e <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801ce3:	85 f6                	test   %esi,%esi
  801ce5:	74 0a                	je     801cf1 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801ce7:	a1 08 40 80 00       	mov    0x804008,%eax
  801cec:	8b 40 74             	mov    0x74(%eax),%eax
  801cef:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801cf1:	85 db                	test   %ebx,%ebx
  801cf3:	74 0a                	je     801cff <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801cf5:	a1 08 40 80 00       	mov    0x804008,%eax
  801cfa:	8b 40 78             	mov    0x78(%eax),%eax
  801cfd:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801cff:	a1 08 40 80 00       	mov    0x804008,%eax
  801d04:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0a:	5b                   	pop    %ebx
  801d0b:	5e                   	pop    %esi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    
		if (from_env_store) {
  801d0e:	85 f6                	test   %esi,%esi
  801d10:	74 06                	je     801d18 <ipc_recv+0x61>
			*from_env_store = 0;
  801d12:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801d18:	85 db                	test   %ebx,%ebx
  801d1a:	74 eb                	je     801d07 <ipc_recv+0x50>
			*perm_store = 0;
  801d1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d22:	eb e3                	jmp    801d07 <ipc_recv+0x50>

00801d24 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d24:	f3 0f 1e fb          	endbr32 
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d34:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801d3a:	85 db                	test   %ebx,%ebx
  801d3c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d41:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801d44:	ff 75 14             	pushl  0x14(%ebp)
  801d47:	53                   	push   %ebx
  801d48:	56                   	push   %esi
  801d49:	57                   	push   %edi
  801d4a:	e8 6d f0 ff ff       	call   800dbc <sys_ipc_try_send>
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d55:	75 07                	jne    801d5e <ipc_send+0x3a>
		sys_yield();
  801d57:	e8 47 ef ff ff       	call   800ca3 <sys_yield>
  801d5c:	eb e6                	jmp    801d44 <ipc_send+0x20>
	}

	if (ret < 0) {
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 08                	js     801d6a <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801d6a:	50                   	push   %eax
  801d6b:	68 23 25 80 00       	push   $0x802523
  801d70:	6a 48                	push   $0x48
  801d72:	68 40 25 80 00       	push   $0x802540
  801d77:	e8 79 e4 ff ff       	call   8001f5 <_panic>

00801d7c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d8b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d8e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d94:	8b 52 50             	mov    0x50(%edx),%edx
  801d97:	39 ca                	cmp    %ecx,%edx
  801d99:	74 11                	je     801dac <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801d9b:	83 c0 01             	add    $0x1,%eax
  801d9e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801da3:	75 e6                	jne    801d8b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
  801daa:	eb 0b                	jmp    801db7 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801dac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801daf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801db4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801db9:	f3 0f 1e fb          	endbr32 
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	c1 ea 16             	shr    $0x16,%edx
  801dc8:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801dcf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801dd4:	f6 c1 01             	test   $0x1,%cl
  801dd7:	74 1c                	je     801df5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801dd9:	c1 e8 0c             	shr    $0xc,%eax
  801ddc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801de3:	a8 01                	test   $0x1,%al
  801de5:	74 0e                	je     801df5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801de7:	c1 e8 0c             	shr    $0xc,%eax
  801dea:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801df1:	ef 
  801df2:	0f b7 d2             	movzwl %dx,%edx
}
  801df5:	89 d0                	mov    %edx,%eax
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
  801df9:	66 90                	xchg   %ax,%ax
  801dfb:	66 90                	xchg   %ax,%ax
  801dfd:	66 90                	xchg   %ax,%ax
  801dff:	90                   	nop

00801e00 <__udivdi3>:
  801e00:	f3 0f 1e fb          	endbr32 
  801e04:	55                   	push   %ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
  801e0b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e0f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e17:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e1b:	85 d2                	test   %edx,%edx
  801e1d:	75 19                	jne    801e38 <__udivdi3+0x38>
  801e1f:	39 f3                	cmp    %esi,%ebx
  801e21:	76 4d                	jbe    801e70 <__udivdi3+0x70>
  801e23:	31 ff                	xor    %edi,%edi
  801e25:	89 e8                	mov    %ebp,%eax
  801e27:	89 f2                	mov    %esi,%edx
  801e29:	f7 f3                	div    %ebx
  801e2b:	89 fa                	mov    %edi,%edx
  801e2d:	83 c4 1c             	add    $0x1c,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    
  801e35:	8d 76 00             	lea    0x0(%esi),%esi
  801e38:	39 f2                	cmp    %esi,%edx
  801e3a:	76 14                	jbe    801e50 <__udivdi3+0x50>
  801e3c:	31 ff                	xor    %edi,%edi
  801e3e:	31 c0                	xor    %eax,%eax
  801e40:	89 fa                	mov    %edi,%edx
  801e42:	83 c4 1c             	add    $0x1c,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
  801e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e50:	0f bd fa             	bsr    %edx,%edi
  801e53:	83 f7 1f             	xor    $0x1f,%edi
  801e56:	75 48                	jne    801ea0 <__udivdi3+0xa0>
  801e58:	39 f2                	cmp    %esi,%edx
  801e5a:	72 06                	jb     801e62 <__udivdi3+0x62>
  801e5c:	31 c0                	xor    %eax,%eax
  801e5e:	39 eb                	cmp    %ebp,%ebx
  801e60:	77 de                	ja     801e40 <__udivdi3+0x40>
  801e62:	b8 01 00 00 00       	mov    $0x1,%eax
  801e67:	eb d7                	jmp    801e40 <__udivdi3+0x40>
  801e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e70:	89 d9                	mov    %ebx,%ecx
  801e72:	85 db                	test   %ebx,%ebx
  801e74:	75 0b                	jne    801e81 <__udivdi3+0x81>
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	f7 f3                	div    %ebx
  801e7f:	89 c1                	mov    %eax,%ecx
  801e81:	31 d2                	xor    %edx,%edx
  801e83:	89 f0                	mov    %esi,%eax
  801e85:	f7 f1                	div    %ecx
  801e87:	89 c6                	mov    %eax,%esi
  801e89:	89 e8                	mov    %ebp,%eax
  801e8b:	89 f7                	mov    %esi,%edi
  801e8d:	f7 f1                	div    %ecx
  801e8f:	89 fa                	mov    %edi,%edx
  801e91:	83 c4 1c             	add    $0x1c,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
  801e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	89 f9                	mov    %edi,%ecx
  801ea2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ea7:	29 f8                	sub    %edi,%eax
  801ea9:	d3 e2                	shl    %cl,%edx
  801eab:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eaf:	89 c1                	mov    %eax,%ecx
  801eb1:	89 da                	mov    %ebx,%edx
  801eb3:	d3 ea                	shr    %cl,%edx
  801eb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801eb9:	09 d1                	or     %edx,%ecx
  801ebb:	89 f2                	mov    %esi,%edx
  801ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec1:	89 f9                	mov    %edi,%ecx
  801ec3:	d3 e3                	shl    %cl,%ebx
  801ec5:	89 c1                	mov    %eax,%ecx
  801ec7:	d3 ea                	shr    %cl,%edx
  801ec9:	89 f9                	mov    %edi,%ecx
  801ecb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ecf:	89 eb                	mov    %ebp,%ebx
  801ed1:	d3 e6                	shl    %cl,%esi
  801ed3:	89 c1                	mov    %eax,%ecx
  801ed5:	d3 eb                	shr    %cl,%ebx
  801ed7:	09 de                	or     %ebx,%esi
  801ed9:	89 f0                	mov    %esi,%eax
  801edb:	f7 74 24 08          	divl   0x8(%esp)
  801edf:	89 d6                	mov    %edx,%esi
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	f7 64 24 0c          	mull   0xc(%esp)
  801ee7:	39 d6                	cmp    %edx,%esi
  801ee9:	72 15                	jb     801f00 <__udivdi3+0x100>
  801eeb:	89 f9                	mov    %edi,%ecx
  801eed:	d3 e5                	shl    %cl,%ebp
  801eef:	39 c5                	cmp    %eax,%ebp
  801ef1:	73 04                	jae    801ef7 <__udivdi3+0xf7>
  801ef3:	39 d6                	cmp    %edx,%esi
  801ef5:	74 09                	je     801f00 <__udivdi3+0x100>
  801ef7:	89 d8                	mov    %ebx,%eax
  801ef9:	31 ff                	xor    %edi,%edi
  801efb:	e9 40 ff ff ff       	jmp    801e40 <__udivdi3+0x40>
  801f00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f03:	31 ff                	xor    %edi,%edi
  801f05:	e9 36 ff ff ff       	jmp    801e40 <__udivdi3+0x40>
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	66 90                	xchg   %ax,%ax
  801f0e:	66 90                	xchg   %ax,%ax

00801f10 <__umoddi3>:
  801f10:	f3 0f 1e fb          	endbr32 
  801f14:	55                   	push   %ebp
  801f15:	57                   	push   %edi
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 1c             	sub    $0x1c,%esp
  801f1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f23:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	75 19                	jne    801f48 <__umoddi3+0x38>
  801f2f:	39 df                	cmp    %ebx,%edi
  801f31:	76 5d                	jbe    801f90 <__umoddi3+0x80>
  801f33:	89 f0                	mov    %esi,%eax
  801f35:	89 da                	mov    %ebx,%edx
  801f37:	f7 f7                	div    %edi
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	83 c4 1c             	add    $0x1c,%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    
  801f45:	8d 76 00             	lea    0x0(%esi),%esi
  801f48:	89 f2                	mov    %esi,%edx
  801f4a:	39 d8                	cmp    %ebx,%eax
  801f4c:	76 12                	jbe    801f60 <__umoddi3+0x50>
  801f4e:	89 f0                	mov    %esi,%eax
  801f50:	89 da                	mov    %ebx,%edx
  801f52:	83 c4 1c             	add    $0x1c,%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5f                   	pop    %edi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    
  801f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f60:	0f bd e8             	bsr    %eax,%ebp
  801f63:	83 f5 1f             	xor    $0x1f,%ebp
  801f66:	75 50                	jne    801fb8 <__umoddi3+0xa8>
  801f68:	39 d8                	cmp    %ebx,%eax
  801f6a:	0f 82 e0 00 00 00    	jb     802050 <__umoddi3+0x140>
  801f70:	89 d9                	mov    %ebx,%ecx
  801f72:	39 f7                	cmp    %esi,%edi
  801f74:	0f 86 d6 00 00 00    	jbe    802050 <__umoddi3+0x140>
  801f7a:	89 d0                	mov    %edx,%eax
  801f7c:	89 ca                	mov    %ecx,%edx
  801f7e:	83 c4 1c             	add    $0x1c,%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    
  801f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	89 fd                	mov    %edi,%ebp
  801f92:	85 ff                	test   %edi,%edi
  801f94:	75 0b                	jne    801fa1 <__umoddi3+0x91>
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	f7 f7                	div    %edi
  801f9f:	89 c5                	mov    %eax,%ebp
  801fa1:	89 d8                	mov    %ebx,%eax
  801fa3:	31 d2                	xor    %edx,%edx
  801fa5:	f7 f5                	div    %ebp
  801fa7:	89 f0                	mov    %esi,%eax
  801fa9:	f7 f5                	div    %ebp
  801fab:	89 d0                	mov    %edx,%eax
  801fad:	31 d2                	xor    %edx,%edx
  801faf:	eb 8c                	jmp    801f3d <__umoddi3+0x2d>
  801fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fb8:	89 e9                	mov    %ebp,%ecx
  801fba:	ba 20 00 00 00       	mov    $0x20,%edx
  801fbf:	29 ea                	sub    %ebp,%edx
  801fc1:	d3 e0                	shl    %cl,%eax
  801fc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc7:	89 d1                	mov    %edx,%ecx
  801fc9:	89 f8                	mov    %edi,%eax
  801fcb:	d3 e8                	shr    %cl,%eax
  801fcd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fd9:	09 c1                	or     %eax,%ecx
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe1:	89 e9                	mov    %ebp,%ecx
  801fe3:	d3 e7                	shl    %cl,%edi
  801fe5:	89 d1                	mov    %edx,%ecx
  801fe7:	d3 e8                	shr    %cl,%eax
  801fe9:	89 e9                	mov    %ebp,%ecx
  801feb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fef:	d3 e3                	shl    %cl,%ebx
  801ff1:	89 c7                	mov    %eax,%edi
  801ff3:	89 d1                	mov    %edx,%ecx
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	d3 e8                	shr    %cl,%eax
  801ff9:	89 e9                	mov    %ebp,%ecx
  801ffb:	89 fa                	mov    %edi,%edx
  801ffd:	d3 e6                	shl    %cl,%esi
  801fff:	09 d8                	or     %ebx,%eax
  802001:	f7 74 24 08          	divl   0x8(%esp)
  802005:	89 d1                	mov    %edx,%ecx
  802007:	89 f3                	mov    %esi,%ebx
  802009:	f7 64 24 0c          	mull   0xc(%esp)
  80200d:	89 c6                	mov    %eax,%esi
  80200f:	89 d7                	mov    %edx,%edi
  802011:	39 d1                	cmp    %edx,%ecx
  802013:	72 06                	jb     80201b <__umoddi3+0x10b>
  802015:	75 10                	jne    802027 <__umoddi3+0x117>
  802017:	39 c3                	cmp    %eax,%ebx
  802019:	73 0c                	jae    802027 <__umoddi3+0x117>
  80201b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80201f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802023:	89 d7                	mov    %edx,%edi
  802025:	89 c6                	mov    %eax,%esi
  802027:	89 ca                	mov    %ecx,%edx
  802029:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80202e:	29 f3                	sub    %esi,%ebx
  802030:	19 fa                	sbb    %edi,%edx
  802032:	89 d0                	mov    %edx,%eax
  802034:	d3 e0                	shl    %cl,%eax
  802036:	89 e9                	mov    %ebp,%ecx
  802038:	d3 eb                	shr    %cl,%ebx
  80203a:	d3 ea                	shr    %cl,%edx
  80203c:	09 d8                	or     %ebx,%eax
  80203e:	83 c4 1c             	add    $0x1c,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    
  802046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80204d:	8d 76 00             	lea    0x0(%esi),%esi
  802050:	29 fe                	sub    %edi,%esi
  802052:	19 c3                	sbb    %eax,%ebx
  802054:	89 f2                	mov    %esi,%edx
  802056:	89 d9                	mov    %ebx,%ecx
  802058:	e9 1d ff ff ff       	jmp    801f7a <__umoddi3+0x6a>
