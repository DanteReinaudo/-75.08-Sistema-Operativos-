
obj/user/faultalloc.debug:     formato del fichero elf32-i386


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
  80002c:	e8 a1 00 00 00       	call   8000d2 <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003e:	8b 45 08             	mov    0x8(%ebp),%eax
  800041:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800043:	53                   	push   %ebx
  800044:	68 40 1f 80 00       	push   $0x801f40
  800049:	e8 d7 01 00 00       	call   800225 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 b5 0b 00 00       	call   800c17 <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 8c 1f 80 00       	push   $0x801f8c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 b7 06 00 00       	call   80072e <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 60 1f 80 00       	push   $0x801f60
  800089:	6a 0e                	push   $0xe
  80008b:	68 4a 1f 80 00       	push   $0x801f4a
  800090:	e8 a9 00 00 00       	call   80013e <_panic>

00800095 <umain>:

void
umain(int argc, char **argv)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80009f:	68 33 00 80 00       	push   $0x800033
  8000a4:	e8 ab 0c 00 00       	call   800d54 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 5c 1f 80 00       	push   $0x801f5c
  8000b6:	e8 6a 01 00 00       	call   800225 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 5c 1f 80 00       	push   $0x801f5c
  8000c8:	e8 58 01 00 00       	call   800225 <cprintf>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	c9                   	leave  
  8000d1:	c3                   	ret    

008000d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000e1:	e8 de 0a 00 00       	call   800bc4 <sys_getenvid>
	if (id >= 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	78 12                	js     8000fc <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8000ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fc:	85 db                	test   %ebx,%ebx
  8000fe:	7e 07                	jle    800107 <libmain+0x35>
		binaryname = argv[0];
  800100:	8b 06                	mov    (%esi),%eax
  800102:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	56                   	push   %esi
  80010b:	53                   	push   %ebx
  80010c:	e8 84 ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  800111:	e8 0a 00 00 00       	call   800120 <exit>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011c:	5b                   	pop    %ebx
  80011d:	5e                   	pop    %esi
  80011e:	5d                   	pop    %ebp
  80011f:	c3                   	ret    

00800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	f3 0f 1e fb          	endbr32 
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012a:	e8 bb 0e 00 00       	call   800fea <close_all>
	sys_env_destroy(0);
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	6a 00                	push   $0x0
  800134:	e8 65 0a 00 00       	call   800b9e <sys_env_destroy>
}
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013e:	f3 0f 1e fb          	endbr32 
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	56                   	push   %esi
  800146:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800147:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800150:	e8 6f 0a 00 00       	call   800bc4 <sys_getenvid>
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	ff 75 0c             	pushl  0xc(%ebp)
  80015b:	ff 75 08             	pushl  0x8(%ebp)
  80015e:	56                   	push   %esi
  80015f:	50                   	push   %eax
  800160:	68 b8 1f 80 00       	push   $0x801fb8
  800165:	e8 bb 00 00 00       	call   800225 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80016a:	83 c4 18             	add    $0x18,%esp
  80016d:	53                   	push   %ebx
  80016e:	ff 75 10             	pushl  0x10(%ebp)
  800171:	e8 5a 00 00 00       	call   8001d0 <vcprintf>
	cprintf("\n");
  800176:	c7 04 24 62 24 80 00 	movl   $0x802462,(%esp)
  80017d:	e8 a3 00 00 00       	call   800225 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800185:	cc                   	int3   
  800186:	eb fd                	jmp    800185 <_panic+0x47>

00800188 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800188:	f3 0f 1e fb          	endbr32 
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	53                   	push   %ebx
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800196:	8b 13                	mov    (%ebx),%edx
  800198:	8d 42 01             	lea    0x1(%edx),%eax
  80019b:	89 03                	mov    %eax,(%ebx)
  80019d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a9:	74 09                	je     8001b4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	68 ff 00 00 00       	push   $0xff
  8001bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bf:	50                   	push   %eax
  8001c0:	e8 87 09 00 00       	call   800b4c <sys_cputs>
		b->idx = 0;
  8001c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	eb db                	jmp    8001ab <putch+0x23>

008001d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d0:	f3 0f 1e fb          	endbr32 
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e4:	00 00 00 
	b.cnt = 0;
  8001e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f1:	ff 75 0c             	pushl  0xc(%ebp)
  8001f4:	ff 75 08             	pushl  0x8(%ebp)
  8001f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fd:	50                   	push   %eax
  8001fe:	68 88 01 80 00       	push   $0x800188
  800203:	e8 80 01 00 00       	call   800388 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800208:	83 c4 08             	add    $0x8,%esp
  80020b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800211:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	e8 2f 09 00 00       	call   800b4c <sys_cputs>

	return b.cnt;
}
  80021d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800225:	f3 0f 1e fb          	endbr32 
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800232:	50                   	push   %eax
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 95 ff ff ff       	call   8001d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	57                   	push   %edi
  800241:	56                   	push   %esi
  800242:	53                   	push   %ebx
  800243:	83 ec 1c             	sub    $0x1c,%esp
  800246:	89 c7                	mov    %eax,%edi
  800248:	89 d6                	mov    %edx,%esi
  80024a:	8b 45 08             	mov    0x8(%ebp),%eax
  80024d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800250:	89 d1                	mov    %edx,%ecx
  800252:	89 c2                	mov    %eax,%edx
  800254:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800257:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80025a:	8b 45 10             	mov    0x10(%ebp),%eax
  80025d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800260:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800263:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026f:	72 3e                	jb     8002af <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 18             	pushl  0x18(%ebp)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	53                   	push   %ebx
  80027b:	50                   	push   %eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800282:	ff 75 e0             	pushl  -0x20(%ebp)
  800285:	ff 75 dc             	pushl  -0x24(%ebp)
  800288:	ff 75 d8             	pushl  -0x28(%ebp)
  80028b:	e8 40 1a 00 00       	call   801cd0 <__udivdi3>
  800290:	83 c4 18             	add    $0x18,%esp
  800293:	52                   	push   %edx
  800294:	50                   	push   %eax
  800295:	89 f2                	mov    %esi,%edx
  800297:	89 f8                	mov    %edi,%eax
  800299:	e8 9f ff ff ff       	call   80023d <printnum>
  80029e:	83 c4 20             	add    $0x20,%esp
  8002a1:	eb 13                	jmp    8002b6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	56                   	push   %esi
  8002a7:	ff 75 18             	pushl  0x18(%ebp)
  8002aa:	ff d7                	call   *%edi
  8002ac:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002af:	83 eb 01             	sub    $0x1,%ebx
  8002b2:	85 db                	test   %ebx,%ebx
  8002b4:	7f ed                	jg     8002a3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	56                   	push   %esi
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c9:	e8 12 1b 00 00       	call   801de0 <__umoddi3>
  8002ce:	83 c4 14             	add    $0x14,%esp
  8002d1:	0f be 80 db 1f 80 00 	movsbl 0x801fdb(%eax),%eax
  8002d8:	50                   	push   %eax
  8002d9:	ff d7                	call   *%edi
}
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8002e6:	83 fa 01             	cmp    $0x1,%edx
  8002e9:	7f 13                	jg     8002fe <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8002eb:	85 d2                	test   %edx,%edx
  8002ed:	74 1c                	je     80030b <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8002ef:	8b 10                	mov    (%eax),%edx
  8002f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f4:	89 08                	mov    %ecx,(%eax)
  8002f6:	8b 02                	mov    (%edx),%eax
  8002f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fd:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	8d 4a 08             	lea    0x8(%edx),%ecx
  800303:	89 08                	mov    %ecx,(%eax)
  800305:	8b 02                	mov    (%edx),%eax
  800307:	8b 52 04             	mov    0x4(%edx),%edx
  80030a:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80030b:	8b 10                	mov    (%eax),%edx
  80030d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800310:	89 08                	mov    %ecx,(%eax)
  800312:	8b 02                	mov    (%edx),%eax
  800314:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800319:	c3                   	ret    

0080031a <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80031a:	83 fa 01             	cmp    $0x1,%edx
  80031d:	7f 0f                	jg     80032e <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80031f:	85 d2                	test   %edx,%edx
  800321:	74 18                	je     80033b <getint+0x21>
		return va_arg(*ap, long);
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8d 4a 04             	lea    0x4(%edx),%ecx
  800328:	89 08                	mov    %ecx,(%eax)
  80032a:	8b 02                	mov    (%edx),%eax
  80032c:	99                   	cltd   
  80032d:	c3                   	ret    
		return va_arg(*ap, long long);
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	8d 4a 08             	lea    0x8(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 02                	mov    (%edx),%eax
  800337:	8b 52 04             	mov    0x4(%edx),%edx
  80033a:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80033b:	8b 10                	mov    (%eax),%edx
  80033d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800340:	89 08                	mov    %ecx,(%eax)
  800342:	8b 02                	mov    (%edx),%eax
  800344:	99                   	cltd   
}
  800345:	c3                   	ret    

00800346 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800350:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800354:	8b 10                	mov    (%eax),%edx
  800356:	3b 50 04             	cmp    0x4(%eax),%edx
  800359:	73 0a                	jae    800365 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035e:	89 08                	mov    %ecx,(%eax)
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	88 02                	mov    %al,(%edx)
}
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <printfmt>:
{
  800367:	f3 0f 1e fb          	endbr32 
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800371:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800374:	50                   	push   %eax
  800375:	ff 75 10             	pushl  0x10(%ebp)
  800378:	ff 75 0c             	pushl  0xc(%ebp)
  80037b:	ff 75 08             	pushl  0x8(%ebp)
  80037e:	e8 05 00 00 00       	call   800388 <vprintfmt>
}
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <vprintfmt>:
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 2c             	sub    $0x2c,%esp
  800395:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800398:	8b 75 0c             	mov    0xc(%ebp),%esi
  80039b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039e:	e9 86 02 00 00       	jmp    800629 <vprintfmt+0x2a1>
		padc = ' ';
  8003a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8d 47 01             	lea    0x1(%edi),%eax
  8003c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c7:	0f b6 17             	movzbl (%edi),%edx
  8003ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cd:	3c 55                	cmp    $0x55,%al
  8003cf:	0f 87 df 02 00 00    	ja     8006b4 <vprintfmt+0x32c>
  8003d5:	0f b6 c0             	movzbl %al,%eax
  8003d8:	3e ff 24 85 20 21 80 	notrack jmp *0x802120(,%eax,4)
  8003df:	00 
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e7:	eb d8                	jmp    8003c1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ec:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003f0:	eb cf                	jmp    8003c1 <vprintfmt+0x39>
  8003f2:	0f b6 d2             	movzbl %dl,%edx
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800400:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800403:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800407:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040d:	83 f9 09             	cmp    $0x9,%ecx
  800410:	77 52                	ja     800464 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800412:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800415:	eb e9                	jmp    800400 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	89 55 14             	mov    %edx,0x14(%ebp)
  800420:	8b 00                	mov    (%eax),%eax
  800422:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042c:	79 93                	jns    8003c1 <vprintfmt+0x39>
				width = precision, precision = -1;
  80042e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800431:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800434:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80043b:	eb 84                	jmp    8003c1 <vprintfmt+0x39>
  80043d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
  800447:	0f 49 d0             	cmovns %eax,%edx
  80044a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800450:	e9 6c ff ff ff       	jmp    8003c1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800455:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800458:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80045f:	e9 5d ff ff ff       	jmp    8003c1 <vprintfmt+0x39>
  800464:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800467:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046a:	eb bc                	jmp    800428 <vprintfmt+0xa0>
			lflag++;
  80046c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800472:	e9 4a ff ff ff       	jmp    8003c1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 50 04             	lea    0x4(%eax),%edx
  80047d:	89 55 14             	mov    %edx,0x14(%ebp)
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	56                   	push   %esi
  800484:	ff 30                	pushl  (%eax)
  800486:	ff d3                	call   *%ebx
			break;
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	e9 96 01 00 00       	jmp    800626 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	89 55 14             	mov    %edx,0x14(%ebp)
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	99                   	cltd   
  80049c:	31 d0                	xor    %edx,%eax
  80049e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a0:	83 f8 0f             	cmp    $0xf,%eax
  8004a3:	7f 20                	jg     8004c5 <vprintfmt+0x13d>
  8004a5:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  8004ac:	85 d2                	test   %edx,%edx
  8004ae:	74 15                	je     8004c5 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8004b0:	52                   	push   %edx
  8004b1:	68 fb 23 80 00       	push   $0x8023fb
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	e8 aa fe ff ff       	call   800367 <printfmt>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	e9 61 01 00 00       	jmp    800626 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8004c5:	50                   	push   %eax
  8004c6:	68 f3 1f 80 00       	push   $0x801ff3
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	e8 95 fe ff ff       	call   800367 <printfmt>
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	e9 4c 01 00 00       	jmp    800626 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004e5:	85 c9                	test   %ecx,%ecx
  8004e7:	b8 ec 1f 80 00       	mov    $0x801fec,%eax
  8004ec:	0f 45 c1             	cmovne %ecx,%eax
  8004ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f6:	7e 06                	jle    8004fe <vprintfmt+0x176>
  8004f8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004fc:	75 0d                	jne    80050b <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800501:	89 c7                	mov    %eax,%edi
  800503:	03 45 e0             	add    -0x20(%ebp),%eax
  800506:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800509:	eb 57                	jmp    800562 <vprintfmt+0x1da>
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 d8             	pushl  -0x28(%ebp)
  800511:	ff 75 cc             	pushl  -0x34(%ebp)
  800514:	e8 4f 02 00 00       	call   800768 <strnlen>
  800519:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051c:	29 c2                	sub    %eax,%edx
  80051e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800521:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800524:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800528:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80052b:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	85 db                	test   %ebx,%ebx
  80052f:	7e 10                	jle    800541 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	56                   	push   %esi
  800535:	57                   	push   %edi
  800536:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	83 eb 01             	sub    $0x1,%ebx
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	eb ec                	jmp    80052d <vprintfmt+0x1a5>
  800541:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800544:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800547:	85 d2                	test   %edx,%edx
  800549:	b8 00 00 00 00       	mov    $0x0,%eax
  80054e:	0f 49 c2             	cmovns %edx,%eax
  800551:	29 c2                	sub    %eax,%edx
  800553:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800556:	eb a6                	jmp    8004fe <vprintfmt+0x176>
					putch(ch, putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	56                   	push   %esi
  80055c:	52                   	push   %edx
  80055d:	ff d3                	call   *%ebx
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800565:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800567:	83 c7 01             	add    $0x1,%edi
  80056a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056e:	0f be d0             	movsbl %al,%edx
  800571:	85 d2                	test   %edx,%edx
  800573:	74 42                	je     8005b7 <vprintfmt+0x22f>
  800575:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800579:	78 06                	js     800581 <vprintfmt+0x1f9>
  80057b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80057f:	78 1e                	js     80059f <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800581:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800585:	74 d1                	je     800558 <vprintfmt+0x1d0>
  800587:	0f be c0             	movsbl %al,%eax
  80058a:	83 e8 20             	sub    $0x20,%eax
  80058d:	83 f8 5e             	cmp    $0x5e,%eax
  800590:	76 c6                	jbe    800558 <vprintfmt+0x1d0>
					putch('?', putdat);
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	56                   	push   %esi
  800596:	6a 3f                	push   $0x3f
  800598:	ff d3                	call   *%ebx
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	eb c3                	jmp    800562 <vprintfmt+0x1da>
  80059f:	89 cf                	mov    %ecx,%edi
  8005a1:	eb 0e                	jmp    8005b1 <vprintfmt+0x229>
				putch(' ', putdat);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	56                   	push   %esi
  8005a7:	6a 20                	push   $0x20
  8005a9:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8005ab:	83 ef 01             	sub    $0x1,%edi
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	85 ff                	test   %edi,%edi
  8005b3:	7f ee                	jg     8005a3 <vprintfmt+0x21b>
  8005b5:	eb 6f                	jmp    800626 <vprintfmt+0x29e>
  8005b7:	89 cf                	mov    %ecx,%edi
  8005b9:	eb f6                	jmp    8005b1 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8005bb:	89 ca                	mov    %ecx,%edx
  8005bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c0:	e8 55 fd ff ff       	call   80031a <getint>
  8005c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	78 0b                	js     8005da <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8005cf:	89 d1                	mov    %edx,%ecx
  8005d1:	89 c2                	mov    %eax,%edx
			base = 10;
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d8:	eb 32                	jmp    80060c <vprintfmt+0x284>
				putch('-', putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	56                   	push   %esi
  8005de:	6a 2d                	push   $0x2d
  8005e0:	ff d3                	call   *%ebx
				num = -(long long) num;
  8005e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e8:	f7 da                	neg    %edx
  8005ea:	83 d1 00             	adc    $0x0,%ecx
  8005ed:	f7 d9                	neg    %ecx
  8005ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f7:	eb 13                	jmp    80060c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8005f9:	89 ca                	mov    %ecx,%edx
  8005fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8005fe:	e8 e3 fc ff ff       	call   8002e6 <getuint>
  800603:	89 d1                	mov    %edx,%ecx
  800605:	89 c2                	mov    %eax,%edx
			base = 10;
  800607:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80060c:	83 ec 0c             	sub    $0xc,%esp
  80060f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800613:	57                   	push   %edi
  800614:	ff 75 e0             	pushl  -0x20(%ebp)
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	89 f2                	mov    %esi,%edx
  80061c:	89 d8                	mov    %ebx,%eax
  80061e:	e8 1a fc ff ff       	call   80023d <printnum>
			break;
  800623:	83 c4 20             	add    $0x20,%esp
{
  800626:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800629:	83 c7 01             	add    $0x1,%edi
  80062c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800630:	83 f8 25             	cmp    $0x25,%eax
  800633:	0f 84 6a fd ff ff    	je     8003a3 <vprintfmt+0x1b>
			if (ch == '\0')
  800639:	85 c0                	test   %eax,%eax
  80063b:	0f 84 93 00 00 00    	je     8006d4 <vprintfmt+0x34c>
			putch(ch, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	56                   	push   %esi
  800645:	50                   	push   %eax
  800646:	ff d3                	call   *%ebx
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	eb dc                	jmp    800629 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80064d:	89 ca                	mov    %ecx,%edx
  80064f:	8d 45 14             	lea    0x14(%ebp),%eax
  800652:	e8 8f fc ff ff       	call   8002e6 <getuint>
  800657:	89 d1                	mov    %edx,%ecx
  800659:	89 c2                	mov    %eax,%edx
			base = 8;
  80065b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800660:	eb aa                	jmp    80060c <vprintfmt+0x284>
			putch('0', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	56                   	push   %esi
  800666:	6a 30                	push   $0x30
  800668:	ff d3                	call   *%ebx
			putch('x', putdat);
  80066a:	83 c4 08             	add    $0x8,%esp
  80066d:	56                   	push   %esi
  80066e:	6a 78                	push   $0x78
  800670:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 50 04             	lea    0x4(%eax),%edx
  800678:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800682:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800685:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80068a:	eb 80                	jmp    80060c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80068c:	89 ca                	mov    %ecx,%edx
  80068e:	8d 45 14             	lea    0x14(%ebp),%eax
  800691:	e8 50 fc ff ff       	call   8002e6 <getuint>
  800696:	89 d1                	mov    %edx,%ecx
  800698:	89 c2                	mov    %eax,%edx
			base = 16;
  80069a:	b8 10 00 00 00       	mov    $0x10,%eax
  80069f:	e9 68 ff ff ff       	jmp    80060c <vprintfmt+0x284>
			putch(ch, putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	56                   	push   %esi
  8006a8:	6a 25                	push   $0x25
  8006aa:	ff d3                	call   *%ebx
			break;
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	e9 72 ff ff ff       	jmp    800626 <vprintfmt+0x29e>
			putch('%', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	56                   	push   %esi
  8006b8:	6a 25                	push   $0x25
  8006ba:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 f8                	mov    %edi,%eax
  8006c1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c5:	74 05                	je     8006cc <vprintfmt+0x344>
  8006c7:	83 e8 01             	sub    $0x1,%eax
  8006ca:	eb f5                	jmp    8006c1 <vprintfmt+0x339>
  8006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cf:	e9 52 ff ff ff       	jmp    800626 <vprintfmt+0x29e>
}
  8006d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d7:	5b                   	pop    %ebx
  8006d8:	5e                   	pop    %esi
  8006d9:	5f                   	pop    %edi
  8006da:	5d                   	pop    %ebp
  8006db:	c3                   	ret    

008006dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006dc:	f3 0f 1e fb          	endbr32 
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	74 26                	je     800727 <vsnprintf+0x4b>
  800701:	85 d2                	test   %edx,%edx
  800703:	7e 22                	jle    800727 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800705:	ff 75 14             	pushl  0x14(%ebp)
  800708:	ff 75 10             	pushl  0x10(%ebp)
  80070b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070e:	50                   	push   %eax
  80070f:	68 46 03 80 00       	push   $0x800346
  800714:	e8 6f fc ff ff       	call   800388 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800722:	83 c4 10             	add    $0x10,%esp
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    
		return -E_INVAL;
  800727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80072c:	eb f7                	jmp    800725 <vsnprintf+0x49>

0080072e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072e:	f3 0f 1e fb          	endbr32 
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80073b:	50                   	push   %eax
  80073c:	ff 75 10             	pushl  0x10(%ebp)
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	ff 75 08             	pushl  0x8(%ebp)
  800745:	e8 92 ff ff ff       	call   8006dc <vsnprintf>
	va_end(ap);

	return rc;
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80075f:	74 05                	je     800766 <strlen+0x1a>
		n++;
  800761:	83 c0 01             	add    $0x1,%eax
  800764:	eb f5                	jmp    80075b <strlen+0xf>
	return n;
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800768:	f3 0f 1e fb          	endbr32 
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800772:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800775:	b8 00 00 00 00       	mov    $0x0,%eax
  80077a:	39 d0                	cmp    %edx,%eax
  80077c:	74 0d                	je     80078b <strnlen+0x23>
  80077e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800782:	74 05                	je     800789 <strnlen+0x21>
		n++;
  800784:	83 c0 01             	add    $0x1,%eax
  800787:	eb f1                	jmp    80077a <strnlen+0x12>
  800789:	89 c2                	mov    %eax,%edx
	return n;
}
  80078b:	89 d0                	mov    %edx,%eax
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80078f:	f3 0f 1e fb          	endbr32 
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	53                   	push   %ebx
  800797:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80079a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079d:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007a6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007a9:	83 c0 01             	add    $0x1,%eax
  8007ac:	84 d2                	test   %dl,%dl
  8007ae:	75 f2                	jne    8007a2 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007b0:	89 c8                	mov    %ecx,%eax
  8007b2:	5b                   	pop    %ebx
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	83 ec 10             	sub    $0x10,%esp
  8007c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c3:	53                   	push   %ebx
  8007c4:	e8 83 ff ff ff       	call   80074c <strlen>
  8007c9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	01 d8                	add    %ebx,%eax
  8007d1:	50                   	push   %eax
  8007d2:	e8 b8 ff ff ff       	call   80078f <strcpy>
	return dst;
}
  8007d7:	89 d8                	mov    %ebx,%eax
  8007d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ed:	89 f3                	mov    %esi,%ebx
  8007ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f2:	89 f0                	mov    %esi,%eax
  8007f4:	39 d8                	cmp    %ebx,%eax
  8007f6:	74 11                	je     800809 <strncpy+0x2b>
		*dst++ = *src;
  8007f8:	83 c0 01             	add    $0x1,%eax
  8007fb:	0f b6 0a             	movzbl (%edx),%ecx
  8007fe:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800801:	80 f9 01             	cmp    $0x1,%cl
  800804:	83 da ff             	sbb    $0xffffffff,%edx
  800807:	eb eb                	jmp    8007f4 <strncpy+0x16>
	}
	return ret;
}
  800809:	89 f0                	mov    %esi,%eax
  80080b:	5b                   	pop    %ebx
  80080c:	5e                   	pop    %esi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080f:	f3 0f 1e fb          	endbr32 
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	56                   	push   %esi
  800817:	53                   	push   %ebx
  800818:	8b 75 08             	mov    0x8(%ebp),%esi
  80081b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081e:	8b 55 10             	mov    0x10(%ebp),%edx
  800821:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	85 d2                	test   %edx,%edx
  800825:	74 21                	je     800848 <strlcpy+0x39>
  800827:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80082b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80082d:	39 c2                	cmp    %eax,%edx
  80082f:	74 14                	je     800845 <strlcpy+0x36>
  800831:	0f b6 19             	movzbl (%ecx),%ebx
  800834:	84 db                	test   %bl,%bl
  800836:	74 0b                	je     800843 <strlcpy+0x34>
			*dst++ = *src++;
  800838:	83 c1 01             	add    $0x1,%ecx
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800841:	eb ea                	jmp    80082d <strlcpy+0x1e>
  800843:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800845:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800848:	29 f0                	sub    %esi,%eax
}
  80084a:	5b                   	pop    %ebx
  80084b:	5e                   	pop    %esi
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800858:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085b:	0f b6 01             	movzbl (%ecx),%eax
  80085e:	84 c0                	test   %al,%al
  800860:	74 0c                	je     80086e <strcmp+0x20>
  800862:	3a 02                	cmp    (%edx),%al
  800864:	75 08                	jne    80086e <strcmp+0x20>
		p++, q++;
  800866:	83 c1 01             	add    $0x1,%ecx
  800869:	83 c2 01             	add    $0x1,%edx
  80086c:	eb ed                	jmp    80085b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086e:	0f b6 c0             	movzbl %al,%eax
  800871:	0f b6 12             	movzbl (%edx),%edx
  800874:	29 d0                	sub    %edx,%eax
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800878:	f3 0f 1e fb          	endbr32 
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	53                   	push   %ebx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	89 c3                	mov    %eax,%ebx
  800888:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80088b:	eb 06                	jmp    800893 <strncmp+0x1b>
		n--, p++, q++;
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800893:	39 d8                	cmp    %ebx,%eax
  800895:	74 16                	je     8008ad <strncmp+0x35>
  800897:	0f b6 08             	movzbl (%eax),%ecx
  80089a:	84 c9                	test   %cl,%cl
  80089c:	74 04                	je     8008a2 <strncmp+0x2a>
  80089e:	3a 0a                	cmp    (%edx),%cl
  8008a0:	74 eb                	je     80088d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a2:	0f b6 00             	movzbl (%eax),%eax
  8008a5:	0f b6 12             	movzbl (%edx),%edx
  8008a8:	29 d0                	sub    %edx,%eax
}
  8008aa:	5b                   	pop    %ebx
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    
		return 0;
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b2:	eb f6                	jmp    8008aa <strncmp+0x32>

008008b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c2:	0f b6 10             	movzbl (%eax),%edx
  8008c5:	84 d2                	test   %dl,%dl
  8008c7:	74 09                	je     8008d2 <strchr+0x1e>
		if (*s == c)
  8008c9:	38 ca                	cmp    %cl,%dl
  8008cb:	74 0a                	je     8008d7 <strchr+0x23>
	for (; *s; s++)
  8008cd:	83 c0 01             	add    $0x1,%eax
  8008d0:	eb f0                	jmp    8008c2 <strchr+0xe>
			return (char *) s;
	return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ea:	38 ca                	cmp    %cl,%dl
  8008ec:	74 09                	je     8008f7 <strfind+0x1e>
  8008ee:	84 d2                	test   %dl,%dl
  8008f0:	74 05                	je     8008f7 <strfind+0x1e>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strfind+0xe>
			break;
	return (char *) s;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f9:	f3 0f 1e fb          	endbr32 
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	57                   	push   %edi
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
  800906:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800909:	85 c9                	test   %ecx,%ecx
  80090b:	74 33                	je     800940 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80090d:	89 d0                	mov    %edx,%eax
  80090f:	09 c8                	or     %ecx,%eax
  800911:	a8 03                	test   $0x3,%al
  800913:	75 23                	jne    800938 <memset+0x3f>
		c &= 0xFF;
  800915:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800919:	89 d8                	mov    %ebx,%eax
  80091b:	c1 e0 08             	shl    $0x8,%eax
  80091e:	89 df                	mov    %ebx,%edi
  800920:	c1 e7 18             	shl    $0x18,%edi
  800923:	89 de                	mov    %ebx,%esi
  800925:	c1 e6 10             	shl    $0x10,%esi
  800928:	09 f7                	or     %esi,%edi
  80092a:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80092c:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80092f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800931:	89 d7                	mov    %edx,%edi
  800933:	fc                   	cld    
  800934:	f3 ab                	rep stos %eax,%es:(%edi)
  800936:	eb 08                	jmp    800940 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800938:	89 d7                	mov    %edx,%edi
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	fc                   	cld    
  80093e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800940:	89 d0                	mov    %edx,%eax
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5f                   	pop    %edi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800947:	f3 0f 1e fb          	endbr32 
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	57                   	push   %edi
  80094f:	56                   	push   %esi
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 75 0c             	mov    0xc(%ebp),%esi
  800956:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800959:	39 c6                	cmp    %eax,%esi
  80095b:	73 32                	jae    80098f <memmove+0x48>
  80095d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800960:	39 c2                	cmp    %eax,%edx
  800962:	76 2b                	jbe    80098f <memmove+0x48>
		s += n;
		d += n;
  800964:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800967:	89 fe                	mov    %edi,%esi
  800969:	09 ce                	or     %ecx,%esi
  80096b:	09 d6                	or     %edx,%esi
  80096d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800973:	75 0e                	jne    800983 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800975:	83 ef 04             	sub    $0x4,%edi
  800978:	8d 72 fc             	lea    -0x4(%edx),%esi
  80097b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80097e:	fd                   	std    
  80097f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800981:	eb 09                	jmp    80098c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800983:	83 ef 01             	sub    $0x1,%edi
  800986:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800989:	fd                   	std    
  80098a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098c:	fc                   	cld    
  80098d:	eb 1a                	jmp    8009a9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098f:	89 c2                	mov    %eax,%edx
  800991:	09 ca                	or     %ecx,%edx
  800993:	09 f2                	or     %esi,%edx
  800995:	f6 c2 03             	test   $0x3,%dl
  800998:	75 0a                	jne    8009a4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80099a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80099d:	89 c7                	mov    %eax,%edi
  80099f:	fc                   	cld    
  8009a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a2:	eb 05                	jmp    8009a9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009a4:	89 c7                	mov    %eax,%edi
  8009a6:	fc                   	cld    
  8009a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a9:	5e                   	pop    %esi
  8009aa:	5f                   	pop    %edi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ad:	f3 0f 1e fb          	endbr32 
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009b7:	ff 75 10             	pushl  0x10(%ebp)
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	e8 82 ff ff ff       	call   800947 <memmove>
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009c7:	f3 0f 1e fb          	endbr32 
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	89 c6                	mov    %eax,%esi
  8009d8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009db:	39 f0                	cmp    %esi,%eax
  8009dd:	74 1c                	je     8009fb <memcmp+0x34>
		if (*s1 != *s2)
  8009df:	0f b6 08             	movzbl (%eax),%ecx
  8009e2:	0f b6 1a             	movzbl (%edx),%ebx
  8009e5:	38 d9                	cmp    %bl,%cl
  8009e7:	75 08                	jne    8009f1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	eb ea                	jmp    8009db <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009f1:	0f b6 c1             	movzbl %cl,%eax
  8009f4:	0f b6 db             	movzbl %bl,%ebx
  8009f7:	29 d8                	sub    %ebx,%eax
  8009f9:	eb 05                	jmp    800a00 <memcmp+0x39>
	}

	return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a04:	f3 0f 1e fb          	endbr32 
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a11:	89 c2                	mov    %eax,%edx
  800a13:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a16:	39 d0                	cmp    %edx,%eax
  800a18:	73 09                	jae    800a23 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a1a:	38 08                	cmp    %cl,(%eax)
  800a1c:	74 05                	je     800a23 <memfind+0x1f>
	for (; s < ends; s++)
  800a1e:	83 c0 01             	add    $0x1,%eax
  800a21:	eb f3                	jmp    800a16 <memfind+0x12>
			break;
	return (void *) s;
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a25:	f3 0f 1e fb          	endbr32 
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	57                   	push   %edi
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a35:	eb 03                	jmp    800a3a <strtol+0x15>
		s++;
  800a37:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a3a:	0f b6 01             	movzbl (%ecx),%eax
  800a3d:	3c 20                	cmp    $0x20,%al
  800a3f:	74 f6                	je     800a37 <strtol+0x12>
  800a41:	3c 09                	cmp    $0x9,%al
  800a43:	74 f2                	je     800a37 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a45:	3c 2b                	cmp    $0x2b,%al
  800a47:	74 2a                	je     800a73 <strtol+0x4e>
	int neg = 0;
  800a49:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4e:	3c 2d                	cmp    $0x2d,%al
  800a50:	74 2b                	je     800a7d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a52:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a58:	75 0f                	jne    800a69 <strtol+0x44>
  800a5a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5d:	74 28                	je     800a87 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a5f:	85 db                	test   %ebx,%ebx
  800a61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a66:	0f 44 d8             	cmove  %eax,%ebx
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a71:	eb 46                	jmp    800ab9 <strtol+0x94>
		s++;
  800a73:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a76:	bf 00 00 00 00       	mov    $0x0,%edi
  800a7b:	eb d5                	jmp    800a52 <strtol+0x2d>
		s++, neg = 1;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	bf 01 00 00 00       	mov    $0x1,%edi
  800a85:	eb cb                	jmp    800a52 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a87:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a8b:	74 0e                	je     800a9b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	75 d8                	jne    800a69 <strtol+0x44>
		s++, base = 8;
  800a91:	83 c1 01             	add    $0x1,%ecx
  800a94:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a99:	eb ce                	jmp    800a69 <strtol+0x44>
		s += 2, base = 16;
  800a9b:	83 c1 02             	add    $0x2,%ecx
  800a9e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa3:	eb c4                	jmp    800a69 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aa5:	0f be d2             	movsbl %dl,%edx
  800aa8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aab:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aae:	7d 3a                	jge    800aea <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ab0:	83 c1 01             	add    $0x1,%ecx
  800ab3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab9:	0f b6 11             	movzbl (%ecx),%edx
  800abc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800abf:	89 f3                	mov    %esi,%ebx
  800ac1:	80 fb 09             	cmp    $0x9,%bl
  800ac4:	76 df                	jbe    800aa5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ac6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac9:	89 f3                	mov    %esi,%ebx
  800acb:	80 fb 19             	cmp    $0x19,%bl
  800ace:	77 08                	ja     800ad8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad0:	0f be d2             	movsbl %dl,%edx
  800ad3:	83 ea 57             	sub    $0x57,%edx
  800ad6:	eb d3                	jmp    800aab <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ad8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800adb:	89 f3                	mov    %esi,%ebx
  800add:	80 fb 19             	cmp    $0x19,%bl
  800ae0:	77 08                	ja     800aea <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae2:	0f be d2             	movsbl %dl,%edx
  800ae5:	83 ea 37             	sub    $0x37,%edx
  800ae8:	eb c1                	jmp    800aab <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aee:	74 05                	je     800af5 <strtol+0xd0>
		*endptr = (char *) s;
  800af0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af5:	89 c2                	mov    %eax,%edx
  800af7:	f7 da                	neg    %edx
  800af9:	85 ff                	test   %edi,%edi
  800afb:	0f 45 c2             	cmovne %edx,%eax
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	83 ec 1c             	sub    $0x1c,%esp
  800b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b12:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b1a:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b1d:	8b 75 14             	mov    0x14(%ebp),%esi
  800b20:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b26:	74 04                	je     800b2c <syscall+0x29>
  800b28:	85 c0                	test   %eax,%eax
  800b2a:	7f 08                	jg     800b34 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b34:	83 ec 0c             	sub    $0xc,%esp
  800b37:	50                   	push   %eax
  800b38:	ff 75 e0             	pushl  -0x20(%ebp)
  800b3b:	68 df 22 80 00       	push   $0x8022df
  800b40:	6a 23                	push   $0x23
  800b42:	68 fc 22 80 00       	push   $0x8022fc
  800b47:	e8 f2 f5 ff ff       	call   80013e <_panic>

00800b4c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b4c:	f3 0f 1e fb          	endbr32 
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b56:	6a 00                	push   $0x0
  800b58:	6a 00                	push   $0x0
  800b5a:	6a 00                	push   $0x0
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6c:	e8 92 ff ff ff       	call   800b03 <syscall>
}
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b76:	f3 0f 1e fb          	endbr32 
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b80:	6a 00                	push   $0x0
  800b82:	6a 00                	push   $0x0
  800b84:	6a 00                	push   $0x0
  800b86:	6a 00                	push   $0x0
  800b88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 01 00 00 00       	mov    $0x1,%eax
  800b97:	e8 67 ff ff ff       	call   800b03 <syscall>
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b9e:	f3 0f 1e fb          	endbr32 
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ba8:	6a 00                	push   $0x0
  800baa:	6a 00                	push   $0x0
  800bac:	6a 00                	push   $0x0
  800bae:	6a 00                	push   $0x0
  800bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb3:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bbd:	e8 41 ff ff ff       	call   800b03 <syscall>
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bce:	6a 00                	push   $0x0
  800bd0:	6a 00                	push   $0x0
  800bd2:	6a 00                	push   $0x0
  800bd4:	6a 00                	push   $0x0
  800bd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	b8 02 00 00 00       	mov    $0x2,%eax
  800be5:	e8 19 ff ff ff       	call   800b03 <syscall>
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sys_yield>:

void
sys_yield(void)
{
  800bec:	f3 0f 1e fb          	endbr32 
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bf6:	6a 00                	push   $0x0
  800bf8:	6a 00                	push   $0x0
  800bfa:	6a 00                	push   $0x0
  800bfc:	6a 00                	push   $0x0
  800bfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c03:	ba 00 00 00 00       	mov    $0x0,%edx
  800c08:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0d:	e8 f1 fe ff ff       	call   800b03 <syscall>
}
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c17:	f3 0f 1e fb          	endbr32 
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c21:	6a 00                	push   $0x0
  800c23:	6a 00                	push   $0x0
  800c25:	ff 75 10             	pushl  0x10(%ebp)
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c33:	b8 04 00 00 00       	mov    $0x4,%eax
  800c38:	e8 c6 fe ff ff       	call   800b03 <syscall>
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3f:	f3 0f 1e fb          	endbr32 
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c49:	ff 75 18             	pushl  0x18(%ebp)
  800c4c:	ff 75 14             	pushl  0x14(%ebp)
  800c4f:	ff 75 10             	pushl  0x10(%ebp)
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c58:	ba 01 00 00 00       	mov    $0x1,%edx
  800c5d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c62:	e8 9c fe ff ff       	call   800b03 <syscall>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c73:	6a 00                	push   $0x0
  800c75:	6a 00                	push   $0x0
  800c77:	6a 00                	push   $0x0
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c84:	b8 06 00 00 00       	mov    $0x6,%eax
  800c89:	e8 75 fe ff ff       	call   800b03 <syscall>
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c90:	f3 0f 1e fb          	endbr32 
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c9a:	6a 00                	push   $0x0
  800c9c:	6a 00                	push   $0x0
  800c9e:	6a 00                	push   $0x0
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca6:	ba 01 00 00 00       	mov    $0x1,%edx
  800cab:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb0:	e8 4e fe ff ff       	call   800b03 <syscall>
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb7:	f3 0f 1e fb          	endbr32 
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cc1:	6a 00                	push   $0x0
  800cc3:	6a 00                	push   $0x0
  800cc5:	6a 00                	push   $0x0
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccd:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd2:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd7:	e8 27 fe ff ff       	call   800b03 <syscall>
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ce8:	6a 00                	push   $0x0
  800cea:	6a 00                	push   $0x0
  800cec:	6a 00                	push   $0x0
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf4:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfe:	e8 00 fe ff ff       	call   800b03 <syscall>
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d05:	f3 0f 1e fb          	endbr32 
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d0f:	6a 00                	push   $0x0
  800d11:	ff 75 14             	pushl  0x14(%ebp)
  800d14:	ff 75 10             	pushl  0x10(%ebp)
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d27:	e8 d7 fd ff ff       	call   800b03 <syscall>
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d2e:	f3 0f 1e fb          	endbr32 
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d38:	6a 00                	push   $0x0
  800d3a:	6a 00                	push   $0x0
  800d3c:	6a 00                	push   $0x0
  800d3e:	6a 00                	push   $0x0
  800d40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d43:	ba 01 00 00 00       	mov    $0x1,%edx
  800d48:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d4d:	e8 b1 fd ff ff       	call   800b03 <syscall>
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d54:	f3 0f 1e fb          	endbr32 
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d5e:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800d65:	74 0a                	je     800d71 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  800d71:	a1 04 40 80 00       	mov    0x804004,%eax
  800d76:	8b 40 48             	mov    0x48(%eax),%eax
  800d79:	83 ec 04             	sub    $0x4,%esp
  800d7c:	6a 07                	push   $0x7
  800d7e:	68 00 f0 bf ee       	push   $0xeebff000
  800d83:	50                   	push   %eax
  800d84:	e8 8e fe ff ff       	call   800c17 <sys_page_alloc>
		if (r!= 0)
  800d89:	83 c4 10             	add    $0x10,%esp
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	75 2f                	jne    800dbf <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800d90:	a1 04 40 80 00       	mov    0x804004,%eax
  800d95:	8b 40 48             	mov    0x48(%eax),%eax
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	68 d1 0d 80 00       	push   $0x800dd1
  800da0:	50                   	push   %eax
  800da1:	e8 38 ff ff ff       	call   800cde <sys_env_set_pgfault_upcall>
		if (r!= 0)
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	85 c0                	test   %eax,%eax
  800dab:	74 ba                	je     800d67 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  800dad:	50                   	push   %eax
  800dae:	68 0a 23 80 00       	push   $0x80230a
  800db3:	6a 26                	push   $0x26
  800db5:	68 22 23 80 00       	push   $0x802322
  800dba:	e8 7f f3 ff ff       	call   80013e <_panic>
			panic("set_pgfault_handler: %e", r);
  800dbf:	50                   	push   %eax
  800dc0:	68 0a 23 80 00       	push   $0x80230a
  800dc5:	6a 22                	push   $0x22
  800dc7:	68 22 23 80 00       	push   $0x802322
  800dcc:	e8 6d f3 ff ff       	call   80013e <_panic>

00800dd1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800dd1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800dd2:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800dd7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800dd9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  800ddc:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  800de0:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  800de3:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  800de7:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  800deb:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800ded:	83 c4 08             	add    $0x8,%esp
	popal
  800df0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800df1:	83 c4 04             	add    $0x4,%esp
	popfl
  800df4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800df5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800df6:	c3                   	ret    

00800df7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df7:	f3 0f 1e fb          	endbr32 
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	05 00 00 00 30       	add    $0x30000000,%eax
  800e06:	c1 e8 0c             	shr    $0xc,%eax
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e0b:	f3 0f 1e fb          	endbr32 
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 da ff ff ff       	call   800df7 <fd2num>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	c1 e0 0c             	shl    $0xc,%eax
  800e23:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e2a:	f3 0f 1e fb          	endbr32 
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	c1 ea 16             	shr    $0x16,%edx
  800e3b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e42:	f6 c2 01             	test   $0x1,%dl
  800e45:	74 2d                	je     800e74 <fd_alloc+0x4a>
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	c1 ea 0c             	shr    $0xc,%edx
  800e4c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e53:	f6 c2 01             	test   $0x1,%dl
  800e56:	74 1c                	je     800e74 <fd_alloc+0x4a>
  800e58:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e5d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e62:	75 d2                	jne    800e36 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e6d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e72:	eb 0a                	jmp    800e7e <fd_alloc+0x54>
			*fd_store = fd;
  800e74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e77:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e80:	f3 0f 1e fb          	endbr32 
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e8a:	83 f8 1f             	cmp    $0x1f,%eax
  800e8d:	77 30                	ja     800ebf <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e8f:	c1 e0 0c             	shl    $0xc,%eax
  800e92:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e97:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e9d:	f6 c2 01             	test   $0x1,%dl
  800ea0:	74 24                	je     800ec6 <fd_lookup+0x46>
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 ea 0c             	shr    $0xc,%edx
  800ea7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eae:	f6 c2 01             	test   $0x1,%dl
  800eb1:	74 1a                	je     800ecd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	89 02                	mov    %eax,(%edx)
	return 0;
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    
		return -E_INVAL;
  800ebf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec4:	eb f7                	jmp    800ebd <fd_lookup+0x3d>
		return -E_INVAL;
  800ec6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecb:	eb f0                	jmp    800ebd <fd_lookup+0x3d>
  800ecd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed2:	eb e9                	jmp    800ebd <fd_lookup+0x3d>

00800ed4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed4:	f3 0f 1e fb          	endbr32 
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee1:	ba ac 23 80 00       	mov    $0x8023ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ee6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eeb:	39 08                	cmp    %ecx,(%eax)
  800eed:	74 33                	je     800f22 <dev_lookup+0x4e>
  800eef:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ef2:	8b 02                	mov    (%edx),%eax
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 f3                	jne    800eeb <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ef8:	a1 04 40 80 00       	mov    0x804004,%eax
  800efd:	8b 40 48             	mov    0x48(%eax),%eax
  800f00:	83 ec 04             	sub    $0x4,%esp
  800f03:	51                   	push   %ecx
  800f04:	50                   	push   %eax
  800f05:	68 30 23 80 00       	push   $0x802330
  800f0a:	e8 16 f3 ff ff       	call   800225 <cprintf>
	*dev = 0;
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    
			*dev = devtab[i];
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f27:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2c:	eb f2                	jmp    800f20 <dev_lookup+0x4c>

00800f2e <fd_close>:
{
  800f2e:	f3 0f 1e fb          	endbr32 
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 28             	sub    $0x28,%esp
  800f3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f41:	56                   	push   %esi
  800f42:	e8 b0 fe ff ff       	call   800df7 <fd2num>
  800f47:	83 c4 08             	add    $0x8,%esp
  800f4a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800f4d:	52                   	push   %edx
  800f4e:	50                   	push   %eax
  800f4f:	e8 2c ff ff ff       	call   800e80 <fd_lookup>
  800f54:	89 c3                	mov    %eax,%ebx
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	78 05                	js     800f62 <fd_close+0x34>
	    || fd != fd2)
  800f5d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f60:	74 16                	je     800f78 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f62:	89 f8                	mov    %edi,%eax
  800f64:	84 c0                	test   %al,%al
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	0f 44 d8             	cmove  %eax,%ebx
}
  800f6e:	89 d8                	mov    %ebx,%eax
  800f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f7e:	50                   	push   %eax
  800f7f:	ff 36                	pushl  (%esi)
  800f81:	e8 4e ff ff ff       	call   800ed4 <dev_lookup>
  800f86:	89 c3                	mov    %eax,%ebx
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 1a                	js     800fa9 <fd_close+0x7b>
		if (dev->dev_close)
  800f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f92:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	74 0b                	je     800fa9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	56                   	push   %esi
  800fa2:	ff d0                	call   *%eax
  800fa4:	89 c3                	mov    %eax,%ebx
  800fa6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	56                   	push   %esi
  800fad:	6a 00                	push   $0x0
  800faf:	e8 b5 fc ff ff       	call   800c69 <sys_page_unmap>
	return r;
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	eb b5                	jmp    800f6e <fd_close+0x40>

00800fb9 <close>:

int
close(int fdnum)
{
  800fb9:	f3 0f 1e fb          	endbr32 
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc6:	50                   	push   %eax
  800fc7:	ff 75 08             	pushl  0x8(%ebp)
  800fca:	e8 b1 fe ff ff       	call   800e80 <fd_lookup>
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	79 02                	jns    800fd8 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    
		return fd_close(fd, 1);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	6a 01                	push   $0x1
  800fdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe0:	e8 49 ff ff ff       	call   800f2e <fd_close>
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	eb ec                	jmp    800fd6 <close+0x1d>

00800fea <close_all>:

void
close_all(void)
{
  800fea:	f3 0f 1e fb          	endbr32 
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	53                   	push   %ebx
  800ffe:	e8 b6 ff ff ff       	call   800fb9 <close>
	for (i = 0; i < MAXFD; i++)
  801003:	83 c3 01             	add    $0x1,%ebx
  801006:	83 c4 10             	add    $0x10,%esp
  801009:	83 fb 20             	cmp    $0x20,%ebx
  80100c:	75 ec                	jne    800ffa <close_all+0x10>
}
  80100e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801011:	c9                   	leave  
  801012:	c3                   	ret    

00801013 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801013:	f3 0f 1e fb          	endbr32 
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	57                   	push   %edi
  80101b:	56                   	push   %esi
  80101c:	53                   	push   %ebx
  80101d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801020:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801023:	50                   	push   %eax
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 54 fe ff ff       	call   800e80 <fd_lookup>
  80102c:	89 c3                	mov    %eax,%ebx
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	0f 88 81 00 00 00    	js     8010ba <dup+0xa7>
		return r;
	close(newfdnum);
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	e8 75 ff ff ff       	call   800fb9 <close>

	newfd = INDEX2FD(newfdnum);
  801044:	8b 75 0c             	mov    0xc(%ebp),%esi
  801047:	c1 e6 0c             	shl    $0xc,%esi
  80104a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801050:	83 c4 04             	add    $0x4,%esp
  801053:	ff 75 e4             	pushl  -0x1c(%ebp)
  801056:	e8 b0 fd ff ff       	call   800e0b <fd2data>
  80105b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80105d:	89 34 24             	mov    %esi,(%esp)
  801060:	e8 a6 fd ff ff       	call   800e0b <fd2data>
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80106a:	89 d8                	mov    %ebx,%eax
  80106c:	c1 e8 16             	shr    $0x16,%eax
  80106f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801076:	a8 01                	test   $0x1,%al
  801078:	74 11                	je     80108b <dup+0x78>
  80107a:	89 d8                	mov    %ebx,%eax
  80107c:	c1 e8 0c             	shr    $0xc,%eax
  80107f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	75 39                	jne    8010c4 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80108b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80108e:	89 d0                	mov    %edx,%eax
  801090:	c1 e8 0c             	shr    $0xc,%eax
  801093:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a2:	50                   	push   %eax
  8010a3:	56                   	push   %esi
  8010a4:	6a 00                	push   $0x0
  8010a6:	52                   	push   %edx
  8010a7:	6a 00                	push   $0x0
  8010a9:	e8 91 fb ff ff       	call   800c3f <sys_page_map>
  8010ae:	89 c3                	mov    %eax,%ebx
  8010b0:	83 c4 20             	add    $0x20,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	78 31                	js     8010e8 <dup+0xd5>
		goto err;

	return newfdnum;
  8010b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ba:	89 d8                	mov    %ebx,%eax
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d3:	50                   	push   %eax
  8010d4:	57                   	push   %edi
  8010d5:	6a 00                	push   $0x0
  8010d7:	53                   	push   %ebx
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 60 fb ff ff       	call   800c3f <sys_page_map>
  8010df:	89 c3                	mov    %eax,%ebx
  8010e1:	83 c4 20             	add    $0x20,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	79 a3                	jns    80108b <dup+0x78>
	sys_page_unmap(0, newfd);
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	56                   	push   %esi
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 76 fb ff ff       	call   800c69 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010f3:	83 c4 08             	add    $0x8,%esp
  8010f6:	57                   	push   %edi
  8010f7:	6a 00                	push   $0x0
  8010f9:	e8 6b fb ff ff       	call   800c69 <sys_page_unmap>
	return r;
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	eb b7                	jmp    8010ba <dup+0xa7>

00801103 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801103:	f3 0f 1e fb          	endbr32 
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	53                   	push   %ebx
  80110b:	83 ec 1c             	sub    $0x1c,%esp
  80110e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801111:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	53                   	push   %ebx
  801116:	e8 65 fd ff ff       	call   800e80 <fd_lookup>
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	85 c0                	test   %eax,%eax
  801120:	78 3f                	js     801161 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801128:	50                   	push   %eax
  801129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112c:	ff 30                	pushl  (%eax)
  80112e:	e8 a1 fd ff ff       	call   800ed4 <dev_lookup>
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	78 27                	js     801161 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80113a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113d:	8b 42 08             	mov    0x8(%edx),%eax
  801140:	83 e0 03             	and    $0x3,%eax
  801143:	83 f8 01             	cmp    $0x1,%eax
  801146:	74 1e                	je     801166 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114b:	8b 40 08             	mov    0x8(%eax),%eax
  80114e:	85 c0                	test   %eax,%eax
  801150:	74 35                	je     801187 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801152:	83 ec 04             	sub    $0x4,%esp
  801155:	ff 75 10             	pushl  0x10(%ebp)
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	52                   	push   %edx
  80115c:	ff d0                	call   *%eax
  80115e:	83 c4 10             	add    $0x10,%esp
}
  801161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801164:	c9                   	leave  
  801165:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801166:	a1 04 40 80 00       	mov    0x804004,%eax
  80116b:	8b 40 48             	mov    0x48(%eax),%eax
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	53                   	push   %ebx
  801172:	50                   	push   %eax
  801173:	68 71 23 80 00       	push   $0x802371
  801178:	e8 a8 f0 ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801185:	eb da                	jmp    801161 <read+0x5e>
		return -E_NOT_SUPP;
  801187:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80118c:	eb d3                	jmp    801161 <read+0x5e>

0080118e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80118e:	f3 0f 1e fb          	endbr32 
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80119e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a6:	eb 02                	jmp    8011aa <readn+0x1c>
  8011a8:	01 c3                	add    %eax,%ebx
  8011aa:	39 f3                	cmp    %esi,%ebx
  8011ac:	73 21                	jae    8011cf <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	29 d8                	sub    %ebx,%eax
  8011b5:	50                   	push   %eax
  8011b6:	89 d8                	mov    %ebx,%eax
  8011b8:	03 45 0c             	add    0xc(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	57                   	push   %edi
  8011bd:	e8 41 ff ff ff       	call   801103 <read>
		if (m < 0)
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 04                	js     8011cd <readn+0x3f>
			return m;
		if (m == 0)
  8011c9:	75 dd                	jne    8011a8 <readn+0x1a>
  8011cb:	eb 02                	jmp    8011cf <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011cd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011cf:	89 d8                	mov    %ebx,%eax
  8011d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d4:	5b                   	pop    %ebx
  8011d5:	5e                   	pop    %esi
  8011d6:	5f                   	pop    %edi
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011d9:	f3 0f 1e fb          	endbr32 
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 1c             	sub    $0x1c,%esp
  8011e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ea:	50                   	push   %eax
  8011eb:	53                   	push   %ebx
  8011ec:	e8 8f fc ff ff       	call   800e80 <fd_lookup>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 3a                	js     801232 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801202:	ff 30                	pushl  (%eax)
  801204:	e8 cb fc ff ff       	call   800ed4 <dev_lookup>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 22                	js     801232 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801213:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801217:	74 1e                	je     801237 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121c:	8b 52 0c             	mov    0xc(%edx),%edx
  80121f:	85 d2                	test   %edx,%edx
  801221:	74 35                	je     801258 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	ff 75 10             	pushl  0x10(%ebp)
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	50                   	push   %eax
  80122d:	ff d2                	call   *%edx
  80122f:	83 c4 10             	add    $0x10,%esp
}
  801232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801235:	c9                   	leave  
  801236:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801237:	a1 04 40 80 00       	mov    0x804004,%eax
  80123c:	8b 40 48             	mov    0x48(%eax),%eax
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	53                   	push   %ebx
  801243:	50                   	push   %eax
  801244:	68 8d 23 80 00       	push   $0x80238d
  801249:	e8 d7 ef ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801256:	eb da                	jmp    801232 <write+0x59>
		return -E_NOT_SUPP;
  801258:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80125d:	eb d3                	jmp    801232 <write+0x59>

0080125f <seek>:

int
seek(int fdnum, off_t offset)
{
  80125f:	f3 0f 1e fb          	endbr32 
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126c:	50                   	push   %eax
  80126d:	ff 75 08             	pushl  0x8(%ebp)
  801270:	e8 0b fc ff ff       	call   800e80 <fd_lookup>
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 0e                	js     80128a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801282:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80128c:	f3 0f 1e fb          	endbr32 
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	53                   	push   %ebx
  801294:	83 ec 1c             	sub    $0x1c,%esp
  801297:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	53                   	push   %ebx
  80129f:	e8 dc fb ff ff       	call   800e80 <fd_lookup>
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	78 37                	js     8012e2 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b5:	ff 30                	pushl  (%eax)
  8012b7:	e8 18 fc ff ff       	call   800ed4 <dev_lookup>
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	78 1f                	js     8012e2 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ca:	74 1b                	je     8012e7 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012cf:	8b 52 18             	mov    0x18(%edx),%edx
  8012d2:	85 d2                	test   %edx,%edx
  8012d4:	74 32                	je     801308 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	50                   	push   %eax
  8012dd:	ff d2                	call   *%edx
  8012df:	83 c4 10             	add    $0x10,%esp
}
  8012e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012e7:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012ec:	8b 40 48             	mov    0x48(%eax),%eax
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	53                   	push   %ebx
  8012f3:	50                   	push   %eax
  8012f4:	68 50 23 80 00       	push   $0x802350
  8012f9:	e8 27 ef ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801306:	eb da                	jmp    8012e2 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801308:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80130d:	eb d3                	jmp    8012e2 <ftruncate+0x56>

0080130f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80130f:	f3 0f 1e fb          	endbr32 
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	53                   	push   %ebx
  801317:	83 ec 1c             	sub    $0x1c,%esp
  80131a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	ff 75 08             	pushl  0x8(%ebp)
  801324:	e8 57 fb ff ff       	call   800e80 <fd_lookup>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	78 4b                	js     80137b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801336:	50                   	push   %eax
  801337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133a:	ff 30                	pushl  (%eax)
  80133c:	e8 93 fb ff ff       	call   800ed4 <dev_lookup>
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 33                	js     80137b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80134f:	74 2f                	je     801380 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801351:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801354:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80135b:	00 00 00 
	stat->st_isdir = 0;
  80135e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801365:	00 00 00 
	stat->st_dev = dev;
  801368:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	53                   	push   %ebx
  801372:	ff 75 f0             	pushl  -0x10(%ebp)
  801375:	ff 50 14             	call   *0x14(%eax)
  801378:	83 c4 10             	add    $0x10,%esp
}
  80137b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    
		return -E_NOT_SUPP;
  801380:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801385:	eb f4                	jmp    80137b <fstat+0x6c>

00801387 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801387:	f3 0f 1e fb          	endbr32 
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	56                   	push   %esi
  80138f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	6a 00                	push   $0x0
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 3a 02 00 00       	call   8015d7 <open>
  80139d:	89 c3                	mov    %eax,%ebx
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	78 1b                	js     8013c1 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	50                   	push   %eax
  8013ad:	e8 5d ff ff ff       	call   80130f <fstat>
  8013b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8013b4:	89 1c 24             	mov    %ebx,(%esp)
  8013b7:	e8 fd fb ff ff       	call   800fb9 <close>
	return r;
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	89 f3                	mov    %esi,%ebx
}
  8013c1:	89 d8                	mov    %ebx,%eax
  8013c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	56                   	push   %esi
  8013ce:	53                   	push   %ebx
  8013cf:	89 c6                	mov    %eax,%esi
  8013d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013da:	74 27                	je     801403 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013dc:	6a 07                	push   $0x7
  8013de:	68 00 50 80 00       	push   $0x805000
  8013e3:	56                   	push   %esi
  8013e4:	ff 35 00 40 80 00    	pushl  0x804000
  8013ea:	e8 fd 07 00 00       	call   801bec <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013ef:	83 c4 0c             	add    $0xc,%esp
  8013f2:	6a 00                	push   $0x0
  8013f4:	53                   	push   %ebx
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 83 07 00 00       	call   801b7f <ipc_recv>
}
  8013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	6a 01                	push   $0x1
  801408:	e8 37 08 00 00       	call   801c44 <ipc_find_env>
  80140d:	a3 00 40 80 00       	mov    %eax,0x804000
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	eb c5                	jmp    8013dc <fsipc+0x12>

00801417 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801417:	f3 0f 1e fb          	endbr32 
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8b 40 0c             	mov    0xc(%eax),%eax
  801427:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801434:	ba 00 00 00 00       	mov    $0x0,%edx
  801439:	b8 02 00 00 00       	mov    $0x2,%eax
  80143e:	e8 87 ff ff ff       	call   8013ca <fsipc>
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <devfile_flush>:
{
  801445:	f3 0f 1e fb          	endbr32 
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8b 40 0c             	mov    0xc(%eax),%eax
  801455:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80145a:	ba 00 00 00 00       	mov    $0x0,%edx
  80145f:	b8 06 00 00 00       	mov    $0x6,%eax
  801464:	e8 61 ff ff ff       	call   8013ca <fsipc>
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <devfile_stat>:
{
  80146b:	f3 0f 1e fb          	endbr32 
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	53                   	push   %ebx
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8b 40 0c             	mov    0xc(%eax),%eax
  80147f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801484:	ba 00 00 00 00       	mov    $0x0,%edx
  801489:	b8 05 00 00 00       	mov    $0x5,%eax
  80148e:	e8 37 ff ff ff       	call   8013ca <fsipc>
  801493:	85 c0                	test   %eax,%eax
  801495:	78 2c                	js     8014c3 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	68 00 50 80 00       	push   $0x805000
  80149f:	53                   	push   %ebx
  8014a0:	e8 ea f2 ff ff       	call   80078f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014a5:	a1 80 50 80 00       	mov    0x805080,%eax
  8014aa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b0:	a1 84 50 80 00       	mov    0x805084,%eax
  8014b5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <devfile_write>:
{
  8014c8:	f3 0f 1e fb          	endbr32 
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014e1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014e7:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014ed:	77 30                	ja     80151f <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	53                   	push   %ebx
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	68 08 50 80 00       	push   $0x805008
  8014fb:	e8 47 f4 ff ff       	call   800947 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
  801505:	b8 04 00 00 00       	mov    $0x4,%eax
  80150a:	e8 bb fe ff ff       	call   8013ca <fsipc>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 04                	js     80151a <devfile_write+0x52>
	assert(r <= n);
  801516:	39 d8                	cmp    %ebx,%eax
  801518:	77 1e                	ja     801538 <devfile_write+0x70>
}
  80151a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80151f:	68 bc 23 80 00       	push   $0x8023bc
  801524:	68 e9 23 80 00       	push   $0x8023e9
  801529:	68 94 00 00 00       	push   $0x94
  80152e:	68 fe 23 80 00       	push   $0x8023fe
  801533:	e8 06 ec ff ff       	call   80013e <_panic>
	assert(r <= n);
  801538:	68 09 24 80 00       	push   $0x802409
  80153d:	68 e9 23 80 00       	push   $0x8023e9
  801542:	68 98 00 00 00       	push   $0x98
  801547:	68 fe 23 80 00       	push   $0x8023fe
  80154c:	e8 ed eb ff ff       	call   80013e <_panic>

00801551 <devfile_read>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
  80155a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 40 0c             	mov    0xc(%eax),%eax
  801563:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801568:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	b8 03 00 00 00       	mov    $0x3,%eax
  801578:	e8 4d fe ff ff       	call   8013ca <fsipc>
  80157d:	89 c3                	mov    %eax,%ebx
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 1f                	js     8015a2 <devfile_read+0x51>
	assert(r <= n);
  801583:	39 f0                	cmp    %esi,%eax
  801585:	77 24                	ja     8015ab <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801587:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80158c:	7f 33                	jg     8015c1 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	50                   	push   %eax
  801592:	68 00 50 80 00       	push   $0x805000
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	e8 a8 f3 ff ff       	call   800947 <memmove>
	return r;
  80159f:	83 c4 10             	add    $0x10,%esp
}
  8015a2:	89 d8                	mov    %ebx,%eax
  8015a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a7:	5b                   	pop    %ebx
  8015a8:	5e                   	pop    %esi
  8015a9:	5d                   	pop    %ebp
  8015aa:	c3                   	ret    
	assert(r <= n);
  8015ab:	68 09 24 80 00       	push   $0x802409
  8015b0:	68 e9 23 80 00       	push   $0x8023e9
  8015b5:	6a 7c                	push   $0x7c
  8015b7:	68 fe 23 80 00       	push   $0x8023fe
  8015bc:	e8 7d eb ff ff       	call   80013e <_panic>
	assert(r <= PGSIZE);
  8015c1:	68 10 24 80 00       	push   $0x802410
  8015c6:	68 e9 23 80 00       	push   $0x8023e9
  8015cb:	6a 7d                	push   $0x7d
  8015cd:	68 fe 23 80 00       	push   $0x8023fe
  8015d2:	e8 67 eb ff ff       	call   80013e <_panic>

008015d7 <open>:
{
  8015d7:	f3 0f 1e fb          	endbr32 
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 1c             	sub    $0x1c,%esp
  8015e3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015e6:	56                   	push   %esi
  8015e7:	e8 60 f1 ff ff       	call   80074c <strlen>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015f4:	7f 6c                	jg     801662 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	e8 28 f8 ff ff       	call   800e2a <fd_alloc>
  801602:	89 c3                	mov    %eax,%ebx
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 3c                	js     801647 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	56                   	push   %esi
  80160f:	68 00 50 80 00       	push   $0x805000
  801614:	e8 76 f1 ff ff       	call   80078f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	b8 01 00 00 00       	mov    $0x1,%eax
  801629:	e8 9c fd ff ff       	call   8013ca <fsipc>
  80162e:	89 c3                	mov    %eax,%ebx
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	85 c0                	test   %eax,%eax
  801635:	78 19                	js     801650 <open+0x79>
	return fd2num(fd);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	ff 75 f4             	pushl  -0xc(%ebp)
  80163d:	e8 b5 f7 ff ff       	call   800df7 <fd2num>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	83 c4 10             	add    $0x10,%esp
}
  801647:	89 d8                	mov    %ebx,%eax
  801649:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    
		fd_close(fd, 0);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	6a 00                	push   $0x0
  801655:	ff 75 f4             	pushl  -0xc(%ebp)
  801658:	e8 d1 f8 ff ff       	call   800f2e <fd_close>
		return r;
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	eb e5                	jmp    801647 <open+0x70>
		return -E_BAD_PATH;
  801662:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801667:	eb de                	jmp    801647 <open+0x70>

00801669 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801669:	f3 0f 1e fb          	endbr32 
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801673:	ba 00 00 00 00       	mov    $0x0,%edx
  801678:	b8 08 00 00 00       	mov    $0x8,%eax
  80167d:	e8 48 fd ff ff       	call   8013ca <fsipc>
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801684:	f3 0f 1e fb          	endbr32 
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	56                   	push   %esi
  80168c:	53                   	push   %ebx
  80168d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 70 f7 ff ff       	call   800e0b <fd2data>
  80169b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80169d:	83 c4 08             	add    $0x8,%esp
  8016a0:	68 1c 24 80 00       	push   $0x80241c
  8016a5:	53                   	push   %ebx
  8016a6:	e8 e4 f0 ff ff       	call   80078f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016ab:	8b 46 04             	mov    0x4(%esi),%eax
  8016ae:	2b 06                	sub    (%esi),%eax
  8016b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bd:	00 00 00 
	stat->st_dev = &devpipe;
  8016c0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016c7:	30 80 00 
	return 0;
}
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016d6:	f3 0f 1e fb          	endbr32 
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016e4:	53                   	push   %ebx
  8016e5:	6a 00                	push   $0x0
  8016e7:	e8 7d f5 ff ff       	call   800c69 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016ec:	89 1c 24             	mov    %ebx,(%esp)
  8016ef:	e8 17 f7 ff ff       	call   800e0b <fd2data>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	50                   	push   %eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	e8 6a f5 ff ff       	call   800c69 <sys_page_unmap>
}
  8016ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <_pipeisclosed>:
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	57                   	push   %edi
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	83 ec 1c             	sub    $0x1c,%esp
  80170d:	89 c7                	mov    %eax,%edi
  80170f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801711:	a1 04 40 80 00       	mov    0x804004,%eax
  801716:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	57                   	push   %edi
  80171d:	e8 5f 05 00 00       	call   801c81 <pageref>
  801722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801725:	89 34 24             	mov    %esi,(%esp)
  801728:	e8 54 05 00 00       	call   801c81 <pageref>
		nn = thisenv->env_runs;
  80172d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801733:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	39 cb                	cmp    %ecx,%ebx
  80173b:	74 1b                	je     801758 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80173d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801740:	75 cf                	jne    801711 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801742:	8b 42 58             	mov    0x58(%edx),%eax
  801745:	6a 01                	push   $0x1
  801747:	50                   	push   %eax
  801748:	53                   	push   %ebx
  801749:	68 23 24 80 00       	push   $0x802423
  80174e:	e8 d2 ea ff ff       	call   800225 <cprintf>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	eb b9                	jmp    801711 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801758:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80175b:	0f 94 c0             	sete   %al
  80175e:	0f b6 c0             	movzbl %al,%eax
}
  801761:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801764:	5b                   	pop    %ebx
  801765:	5e                   	pop    %esi
  801766:	5f                   	pop    %edi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <devpipe_write>:
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	83 ec 28             	sub    $0x28,%esp
  801776:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801779:	56                   	push   %esi
  80177a:	e8 8c f6 ff ff       	call   800e0b <fd2data>
  80177f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	bf 00 00 00 00       	mov    $0x0,%edi
  801789:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80178c:	74 4f                	je     8017dd <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80178e:	8b 43 04             	mov    0x4(%ebx),%eax
  801791:	8b 0b                	mov    (%ebx),%ecx
  801793:	8d 51 20             	lea    0x20(%ecx),%edx
  801796:	39 d0                	cmp    %edx,%eax
  801798:	72 14                	jb     8017ae <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80179a:	89 da                	mov    %ebx,%edx
  80179c:	89 f0                	mov    %esi,%eax
  80179e:	e8 61 ff ff ff       	call   801704 <_pipeisclosed>
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	75 3b                	jne    8017e2 <devpipe_write+0x79>
			sys_yield();
  8017a7:	e8 40 f4 ff ff       	call   800bec <sys_yield>
  8017ac:	eb e0                	jmp    80178e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017b5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017b8:	89 c2                	mov    %eax,%edx
  8017ba:	c1 fa 1f             	sar    $0x1f,%edx
  8017bd:	89 d1                	mov    %edx,%ecx
  8017bf:	c1 e9 1b             	shr    $0x1b,%ecx
  8017c2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017c5:	83 e2 1f             	and    $0x1f,%edx
  8017c8:	29 ca                	sub    %ecx,%edx
  8017ca:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017ce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017d2:	83 c0 01             	add    $0x1,%eax
  8017d5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017d8:	83 c7 01             	add    $0x1,%edi
  8017db:	eb ac                	jmp    801789 <devpipe_write+0x20>
	return i;
  8017dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e0:	eb 05                	jmp    8017e7 <devpipe_write+0x7e>
				return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5f                   	pop    %edi
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <devpipe_read>:
{
  8017ef:	f3 0f 1e fb          	endbr32 
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 18             	sub    $0x18,%esp
  8017fc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017ff:	57                   	push   %edi
  801800:	e8 06 f6 ff ff       	call   800e0b <fd2data>
  801805:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	be 00 00 00 00       	mov    $0x0,%esi
  80180f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801812:	75 14                	jne    801828 <devpipe_read+0x39>
	return i;
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	eb 02                	jmp    80181b <devpipe_read+0x2c>
				return i;
  801819:	89 f0                	mov    %esi,%eax
}
  80181b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5e                   	pop    %esi
  801820:	5f                   	pop    %edi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    
			sys_yield();
  801823:	e8 c4 f3 ff ff       	call   800bec <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801828:	8b 03                	mov    (%ebx),%eax
  80182a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80182d:	75 18                	jne    801847 <devpipe_read+0x58>
			if (i > 0)
  80182f:	85 f6                	test   %esi,%esi
  801831:	75 e6                	jne    801819 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801833:	89 da                	mov    %ebx,%edx
  801835:	89 f8                	mov    %edi,%eax
  801837:	e8 c8 fe ff ff       	call   801704 <_pipeisclosed>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 e3                	je     801823 <devpipe_read+0x34>
				return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb d4                	jmp    80181b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801847:	99                   	cltd   
  801848:	c1 ea 1b             	shr    $0x1b,%edx
  80184b:	01 d0                	add    %edx,%eax
  80184d:	83 e0 1f             	and    $0x1f,%eax
  801850:	29 d0                	sub    %edx,%eax
  801852:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80185d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801860:	83 c6 01             	add    $0x1,%esi
  801863:	eb aa                	jmp    80180f <devpipe_read+0x20>

00801865 <pipe>:
{
  801865:	f3 0f 1e fb          	endbr32 
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801874:	50                   	push   %eax
  801875:	e8 b0 f5 ff ff       	call   800e2a <fd_alloc>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	0f 88 23 01 00 00    	js     8019aa <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 07 04 00 00       	push   $0x407
  80188f:	ff 75 f4             	pushl  -0xc(%ebp)
  801892:	6a 00                	push   $0x0
  801894:	e8 7e f3 ff ff       	call   800c17 <sys_page_alloc>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	0f 88 04 01 00 00    	js     8019aa <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	e8 78 f5 ff ff       	call   800e2a <fd_alloc>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	0f 88 db 00 00 00    	js     80199a <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 07 04 00 00       	push   $0x407
  8018c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ca:	6a 00                	push   $0x0
  8018cc:	e8 46 f3 ff ff       	call   800c17 <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	0f 88 bc 00 00 00    	js     80199a <pipe+0x135>
	va = fd2data(fd0);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e4:	e8 22 f5 ff ff       	call   800e0b <fd2data>
  8018e9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018eb:	83 c4 0c             	add    $0xc,%esp
  8018ee:	68 07 04 00 00       	push   $0x407
  8018f3:	50                   	push   %eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 1c f3 ff ff       	call   800c17 <sys_page_alloc>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	0f 88 82 00 00 00    	js     80198a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 f0             	pushl  -0x10(%ebp)
  80190e:	e8 f8 f4 ff ff       	call   800e0b <fd2data>
  801913:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80191a:	50                   	push   %eax
  80191b:	6a 00                	push   $0x0
  80191d:	56                   	push   %esi
  80191e:	6a 00                	push   $0x0
  801920:	e8 1a f3 ff ff       	call   800c3f <sys_page_map>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 20             	add    $0x20,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 4e                	js     80197c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80192e:	a1 20 30 80 00       	mov    0x803020,%eax
  801933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801936:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801945:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	ff 75 f4             	pushl  -0xc(%ebp)
  801957:	e8 9b f4 ff ff       	call   800df7 <fd2num>
  80195c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801961:	83 c4 04             	add    $0x4,%esp
  801964:	ff 75 f0             	pushl  -0x10(%ebp)
  801967:	e8 8b f4 ff ff       	call   800df7 <fd2num>
  80196c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80196f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	bb 00 00 00 00       	mov    $0x0,%ebx
  80197a:	eb 2e                	jmp    8019aa <pipe+0x145>
	sys_page_unmap(0, va);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	56                   	push   %esi
  801980:	6a 00                	push   $0x0
  801982:	e8 e2 f2 ff ff       	call   800c69 <sys_page_unmap>
  801987:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	ff 75 f0             	pushl  -0x10(%ebp)
  801990:	6a 00                	push   $0x0
  801992:	e8 d2 f2 ff ff       	call   800c69 <sys_page_unmap>
  801997:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a0:	6a 00                	push   $0x0
  8019a2:	e8 c2 f2 ff ff       	call   800c69 <sys_page_unmap>
  8019a7:	83 c4 10             	add    $0x10,%esp
}
  8019aa:	89 d8                	mov    %ebx,%eax
  8019ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5d                   	pop    %ebp
  8019b2:	c3                   	ret    

008019b3 <pipeisclosed>:
{
  8019b3:	f3 0f 1e fb          	endbr32 
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c0:	50                   	push   %eax
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	e8 b7 f4 ff ff       	call   800e80 <fd_lookup>
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 18                	js     8019e8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d6:	e8 30 f4 ff ff       	call   800e0b <fd2data>
  8019db:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	e8 1f fd ff ff       	call   801704 <_pipeisclosed>
  8019e5:	83 c4 10             	add    $0x10,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019ea:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	c3                   	ret    

008019f4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019f4:	f3 0f 1e fb          	endbr32 
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019fe:	68 3b 24 80 00       	push   $0x80243b
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	e8 84 ed ff ff       	call   80078f <strcpy>
	return 0;
}
  801a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <devcons_write>:
{
  801a12:	f3 0f 1e fb          	endbr32 
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a22:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a27:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a2d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a30:	73 31                	jae    801a63 <devcons_write+0x51>
		m = n - tot;
  801a32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a35:	29 f3                	sub    %esi,%ebx
  801a37:	83 fb 7f             	cmp    $0x7f,%ebx
  801a3a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a3f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	53                   	push   %ebx
  801a46:	89 f0                	mov    %esi,%eax
  801a48:	03 45 0c             	add    0xc(%ebp),%eax
  801a4b:	50                   	push   %eax
  801a4c:	57                   	push   %edi
  801a4d:	e8 f5 ee ff ff       	call   800947 <memmove>
		sys_cputs(buf, m);
  801a52:	83 c4 08             	add    $0x8,%esp
  801a55:	53                   	push   %ebx
  801a56:	57                   	push   %edi
  801a57:	e8 f0 f0 ff ff       	call   800b4c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a5c:	01 de                	add    %ebx,%esi
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	eb ca                	jmp    801a2d <devcons_write+0x1b>
}
  801a63:	89 f0                	mov    %esi,%eax
  801a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5f                   	pop    %edi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    

00801a6d <devcons_read>:
{
  801a6d:	f3 0f 1e fb          	endbr32 
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 08             	sub    $0x8,%esp
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a80:	74 21                	je     801aa3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801a82:	e8 ef f0 ff ff       	call   800b76 <sys_cgetc>
  801a87:	85 c0                	test   %eax,%eax
  801a89:	75 07                	jne    801a92 <devcons_read+0x25>
		sys_yield();
  801a8b:	e8 5c f1 ff ff       	call   800bec <sys_yield>
  801a90:	eb f0                	jmp    801a82 <devcons_read+0x15>
	if (c < 0)
  801a92:	78 0f                	js     801aa3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801a94:	83 f8 04             	cmp    $0x4,%eax
  801a97:	74 0c                	je     801aa5 <devcons_read+0x38>
	*(char*)vbuf = c;
  801a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9c:	88 02                	mov    %al,(%edx)
	return 1;
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    
		return 0;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	eb f7                	jmp    801aa3 <devcons_read+0x36>

00801aac <cputchar>:
{
  801aac:	f3 0f 1e fb          	endbr32 
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801abc:	6a 01                	push   $0x1
  801abe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ac1:	50                   	push   %eax
  801ac2:	e8 85 f0 ff ff       	call   800b4c <sys_cputs>
}
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <getchar>:
{
  801acc:	f3 0f 1e fb          	endbr32 
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ad6:	6a 01                	push   $0x1
  801ad8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801adb:	50                   	push   %eax
  801adc:	6a 00                	push   $0x0
  801ade:	e8 20 f6 ff ff       	call   801103 <read>
	if (r < 0)
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 06                	js     801af0 <getchar+0x24>
	if (r < 1)
  801aea:	74 06                	je     801af2 <getchar+0x26>
	return c;
  801aec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    
		return -E_EOF;
  801af2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801af7:	eb f7                	jmp    801af0 <getchar+0x24>

00801af9 <iscons>:
{
  801af9:	f3 0f 1e fb          	endbr32 
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b06:	50                   	push   %eax
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	e8 71 f3 ff ff       	call   800e80 <fd_lookup>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 11                	js     801b27 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b19:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b1f:	39 10                	cmp    %edx,(%eax)
  801b21:	0f 94 c0             	sete   %al
  801b24:	0f b6 c0             	movzbl %al,%eax
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <opencons>:
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b36:	50                   	push   %eax
  801b37:	e8 ee f2 ff ff       	call   800e2a <fd_alloc>
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 3a                	js     801b7d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	68 07 04 00 00       	push   $0x407
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	6a 00                	push   $0x0
  801b50:	e8 c2 f0 ff ff       	call   800c17 <sys_page_alloc>
  801b55:	83 c4 10             	add    $0x10,%esp
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	78 21                	js     801b7d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b65:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b71:	83 ec 0c             	sub    $0xc,%esp
  801b74:	50                   	push   %eax
  801b75:	e8 7d f2 ff ff       	call   800df7 <fd2num>
  801b7a:	83 c4 10             	add    $0x10,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b7f:	f3 0f 1e fb          	endbr32 
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	8b 75 08             	mov    0x8(%ebp),%esi
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b91:	85 c0                	test   %eax,%eax
  801b93:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b98:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	50                   	push   %eax
  801b9f:	e8 8a f1 ff ff       	call   800d2e <sys_ipc_recv>
	if (r < 0) {
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	78 2b                	js     801bd6 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801bab:	85 f6                	test   %esi,%esi
  801bad:	74 0a                	je     801bb9 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801baf:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb4:	8b 40 74             	mov    0x74(%eax),%eax
  801bb7:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801bb9:	85 db                	test   %ebx,%ebx
  801bbb:	74 0a                	je     801bc7 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801bbd:	a1 04 40 80 00       	mov    0x804004,%eax
  801bc2:	8b 40 78             	mov    0x78(%eax),%eax
  801bc5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801bc7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bcc:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    
		if (from_env_store) {
  801bd6:	85 f6                	test   %esi,%esi
  801bd8:	74 06                	je     801be0 <ipc_recv+0x61>
			*from_env_store = 0;
  801bda:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801be0:	85 db                	test   %ebx,%ebx
  801be2:	74 eb                	je     801bcf <ipc_recv+0x50>
			*perm_store = 0;
  801be4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bea:	eb e3                	jmp    801bcf <ipc_recv+0x50>

00801bec <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	57                   	push   %edi
  801bf4:	56                   	push   %esi
  801bf5:	53                   	push   %ebx
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801c02:	85 db                	test   %ebx,%ebx
  801c04:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c09:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801c0c:	ff 75 14             	pushl  0x14(%ebp)
  801c0f:	53                   	push   %ebx
  801c10:	56                   	push   %esi
  801c11:	57                   	push   %edi
  801c12:	e8 ee f0 ff ff       	call   800d05 <sys_ipc_try_send>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c1d:	75 07                	jne    801c26 <ipc_send+0x3a>
		sys_yield();
  801c1f:	e8 c8 ef ff ff       	call   800bec <sys_yield>
  801c24:	eb e6                	jmp    801c0c <ipc_send+0x20>
	}

	if (ret < 0) {
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 08                	js     801c32 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801c32:	50                   	push   %eax
  801c33:	68 47 24 80 00       	push   $0x802447
  801c38:	6a 48                	push   $0x48
  801c3a:	68 64 24 80 00       	push   $0x802464
  801c3f:	e8 fa e4 ff ff       	call   80013e <_panic>

00801c44 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c44:	f3 0f 1e fb          	endbr32 
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c53:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c56:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c5c:	8b 52 50             	mov    0x50(%edx),%edx
  801c5f:	39 ca                	cmp    %ecx,%edx
  801c61:	74 11                	je     801c74 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801c63:	83 c0 01             	add    $0x1,%eax
  801c66:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c6b:	75 e6                	jne    801c53 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c72:	eb 0b                	jmp    801c7f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801c74:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c77:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c7c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c81:	f3 0f 1e fb          	endbr32 
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c8b:	89 c2                	mov    %eax,%edx
  801c8d:	c1 ea 16             	shr    $0x16,%edx
  801c90:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c9c:	f6 c1 01             	test   $0x1,%cl
  801c9f:	74 1c                	je     801cbd <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801ca1:	c1 e8 0c             	shr    $0xc,%eax
  801ca4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cab:	a8 01                	test   $0x1,%al
  801cad:	74 0e                	je     801cbd <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801caf:	c1 e8 0c             	shr    $0xc,%eax
  801cb2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801cb9:	ef 
  801cba:	0f b7 d2             	movzwl %dx,%edx
}
  801cbd:	89 d0                	mov    %edx,%eax
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
  801cc1:	66 90                	xchg   %ax,%ax
  801cc3:	66 90                	xchg   %ax,%ax
  801cc5:	66 90                	xchg   %ax,%ax
  801cc7:	66 90                	xchg   %ax,%ax
  801cc9:	66 90                	xchg   %ax,%ax
  801ccb:	66 90                	xchg   %ax,%ax
  801ccd:	66 90                	xchg   %ax,%ax
  801ccf:	90                   	nop

00801cd0 <__udivdi3>:
  801cd0:	f3 0f 1e fb          	endbr32 
  801cd4:	55                   	push   %ebp
  801cd5:	57                   	push   %edi
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 1c             	sub    $0x1c,%esp
  801cdb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cdf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ce3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ceb:	85 d2                	test   %edx,%edx
  801ced:	75 19                	jne    801d08 <__udivdi3+0x38>
  801cef:	39 f3                	cmp    %esi,%ebx
  801cf1:	76 4d                	jbe    801d40 <__udivdi3+0x70>
  801cf3:	31 ff                	xor    %edi,%edi
  801cf5:	89 e8                	mov    %ebp,%eax
  801cf7:	89 f2                	mov    %esi,%edx
  801cf9:	f7 f3                	div    %ebx
  801cfb:	89 fa                	mov    %edi,%edx
  801cfd:	83 c4 1c             	add    $0x1c,%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5f                   	pop    %edi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    
  801d05:	8d 76 00             	lea    0x0(%esi),%esi
  801d08:	39 f2                	cmp    %esi,%edx
  801d0a:	76 14                	jbe    801d20 <__udivdi3+0x50>
  801d0c:	31 ff                	xor    %edi,%edi
  801d0e:	31 c0                	xor    %eax,%eax
  801d10:	89 fa                	mov    %edi,%edx
  801d12:	83 c4 1c             	add    $0x1c,%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5f                   	pop    %edi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
  801d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d20:	0f bd fa             	bsr    %edx,%edi
  801d23:	83 f7 1f             	xor    $0x1f,%edi
  801d26:	75 48                	jne    801d70 <__udivdi3+0xa0>
  801d28:	39 f2                	cmp    %esi,%edx
  801d2a:	72 06                	jb     801d32 <__udivdi3+0x62>
  801d2c:	31 c0                	xor    %eax,%eax
  801d2e:	39 eb                	cmp    %ebp,%ebx
  801d30:	77 de                	ja     801d10 <__udivdi3+0x40>
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	eb d7                	jmp    801d10 <__udivdi3+0x40>
  801d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d40:	89 d9                	mov    %ebx,%ecx
  801d42:	85 db                	test   %ebx,%ebx
  801d44:	75 0b                	jne    801d51 <__udivdi3+0x81>
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	31 d2                	xor    %edx,%edx
  801d4d:	f7 f3                	div    %ebx
  801d4f:	89 c1                	mov    %eax,%ecx
  801d51:	31 d2                	xor    %edx,%edx
  801d53:	89 f0                	mov    %esi,%eax
  801d55:	f7 f1                	div    %ecx
  801d57:	89 c6                	mov    %eax,%esi
  801d59:	89 e8                	mov    %ebp,%eax
  801d5b:	89 f7                	mov    %esi,%edi
  801d5d:	f7 f1                	div    %ecx
  801d5f:	89 fa                	mov    %edi,%edx
  801d61:	83 c4 1c             	add    $0x1c,%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5f                   	pop    %edi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
  801d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d70:	89 f9                	mov    %edi,%ecx
  801d72:	b8 20 00 00 00       	mov    $0x20,%eax
  801d77:	29 f8                	sub    %edi,%eax
  801d79:	d3 e2                	shl    %cl,%edx
  801d7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7f:	89 c1                	mov    %eax,%ecx
  801d81:	89 da                	mov    %ebx,%edx
  801d83:	d3 ea                	shr    %cl,%edx
  801d85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d89:	09 d1                	or     %edx,%ecx
  801d8b:	89 f2                	mov    %esi,%edx
  801d8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d91:	89 f9                	mov    %edi,%ecx
  801d93:	d3 e3                	shl    %cl,%ebx
  801d95:	89 c1                	mov    %eax,%ecx
  801d97:	d3 ea                	shr    %cl,%edx
  801d99:	89 f9                	mov    %edi,%ecx
  801d9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d9f:	89 eb                	mov    %ebp,%ebx
  801da1:	d3 e6                	shl    %cl,%esi
  801da3:	89 c1                	mov    %eax,%ecx
  801da5:	d3 eb                	shr    %cl,%ebx
  801da7:	09 de                	or     %ebx,%esi
  801da9:	89 f0                	mov    %esi,%eax
  801dab:	f7 74 24 08          	divl   0x8(%esp)
  801daf:	89 d6                	mov    %edx,%esi
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	f7 64 24 0c          	mull   0xc(%esp)
  801db7:	39 d6                	cmp    %edx,%esi
  801db9:	72 15                	jb     801dd0 <__udivdi3+0x100>
  801dbb:	89 f9                	mov    %edi,%ecx
  801dbd:	d3 e5                	shl    %cl,%ebp
  801dbf:	39 c5                	cmp    %eax,%ebp
  801dc1:	73 04                	jae    801dc7 <__udivdi3+0xf7>
  801dc3:	39 d6                	cmp    %edx,%esi
  801dc5:	74 09                	je     801dd0 <__udivdi3+0x100>
  801dc7:	89 d8                	mov    %ebx,%eax
  801dc9:	31 ff                	xor    %edi,%edi
  801dcb:	e9 40 ff ff ff       	jmp    801d10 <__udivdi3+0x40>
  801dd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dd3:	31 ff                	xor    %edi,%edi
  801dd5:	e9 36 ff ff ff       	jmp    801d10 <__udivdi3+0x40>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	66 90                	xchg   %ax,%ax
  801dde:	66 90                	xchg   %ax,%ax

00801de0 <__umoddi3>:
  801de0:	f3 0f 1e fb          	endbr32 
  801de4:	55                   	push   %ebp
  801de5:	57                   	push   %edi
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 1c             	sub    $0x1c,%esp
  801deb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801def:	8b 74 24 30          	mov    0x30(%esp),%esi
  801df3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801df7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	75 19                	jne    801e18 <__umoddi3+0x38>
  801dff:	39 df                	cmp    %ebx,%edi
  801e01:	76 5d                	jbe    801e60 <__umoddi3+0x80>
  801e03:	89 f0                	mov    %esi,%eax
  801e05:	89 da                	mov    %ebx,%edx
  801e07:	f7 f7                	div    %edi
  801e09:	89 d0                	mov    %edx,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	83 c4 1c             	add    $0x1c,%esp
  801e10:	5b                   	pop    %ebx
  801e11:	5e                   	pop    %esi
  801e12:	5f                   	pop    %edi
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    
  801e15:	8d 76 00             	lea    0x0(%esi),%esi
  801e18:	89 f2                	mov    %esi,%edx
  801e1a:	39 d8                	cmp    %ebx,%eax
  801e1c:	76 12                	jbe    801e30 <__umoddi3+0x50>
  801e1e:	89 f0                	mov    %esi,%eax
  801e20:	89 da                	mov    %ebx,%edx
  801e22:	83 c4 1c             	add    $0x1c,%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    
  801e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e30:	0f bd e8             	bsr    %eax,%ebp
  801e33:	83 f5 1f             	xor    $0x1f,%ebp
  801e36:	75 50                	jne    801e88 <__umoddi3+0xa8>
  801e38:	39 d8                	cmp    %ebx,%eax
  801e3a:	0f 82 e0 00 00 00    	jb     801f20 <__umoddi3+0x140>
  801e40:	89 d9                	mov    %ebx,%ecx
  801e42:	39 f7                	cmp    %esi,%edi
  801e44:	0f 86 d6 00 00 00    	jbe    801f20 <__umoddi3+0x140>
  801e4a:	89 d0                	mov    %edx,%eax
  801e4c:	89 ca                	mov    %ecx,%edx
  801e4e:	83 c4 1c             	add    $0x1c,%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    
  801e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e5d:	8d 76 00             	lea    0x0(%esi),%esi
  801e60:	89 fd                	mov    %edi,%ebp
  801e62:	85 ff                	test   %edi,%edi
  801e64:	75 0b                	jne    801e71 <__umoddi3+0x91>
  801e66:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6b:	31 d2                	xor    %edx,%edx
  801e6d:	f7 f7                	div    %edi
  801e6f:	89 c5                	mov    %eax,%ebp
  801e71:	89 d8                	mov    %ebx,%eax
  801e73:	31 d2                	xor    %edx,%edx
  801e75:	f7 f5                	div    %ebp
  801e77:	89 f0                	mov    %esi,%eax
  801e79:	f7 f5                	div    %ebp
  801e7b:	89 d0                	mov    %edx,%eax
  801e7d:	31 d2                	xor    %edx,%edx
  801e7f:	eb 8c                	jmp    801e0d <__umoddi3+0x2d>
  801e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e88:	89 e9                	mov    %ebp,%ecx
  801e8a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e8f:	29 ea                	sub    %ebp,%edx
  801e91:	d3 e0                	shl    %cl,%eax
  801e93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e97:	89 d1                	mov    %edx,%ecx
  801e99:	89 f8                	mov    %edi,%eax
  801e9b:	d3 e8                	shr    %cl,%eax
  801e9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ea1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ea5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ea9:	09 c1                	or     %eax,%ecx
  801eab:	89 d8                	mov    %ebx,%eax
  801ead:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb1:	89 e9                	mov    %ebp,%ecx
  801eb3:	d3 e7                	shl    %cl,%edi
  801eb5:	89 d1                	mov    %edx,%ecx
  801eb7:	d3 e8                	shr    %cl,%eax
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ebf:	d3 e3                	shl    %cl,%ebx
  801ec1:	89 c7                	mov    %eax,%edi
  801ec3:	89 d1                	mov    %edx,%ecx
  801ec5:	89 f0                	mov    %esi,%eax
  801ec7:	d3 e8                	shr    %cl,%eax
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	89 fa                	mov    %edi,%edx
  801ecd:	d3 e6                	shl    %cl,%esi
  801ecf:	09 d8                	or     %ebx,%eax
  801ed1:	f7 74 24 08          	divl   0x8(%esp)
  801ed5:	89 d1                	mov    %edx,%ecx
  801ed7:	89 f3                	mov    %esi,%ebx
  801ed9:	f7 64 24 0c          	mull   0xc(%esp)
  801edd:	89 c6                	mov    %eax,%esi
  801edf:	89 d7                	mov    %edx,%edi
  801ee1:	39 d1                	cmp    %edx,%ecx
  801ee3:	72 06                	jb     801eeb <__umoddi3+0x10b>
  801ee5:	75 10                	jne    801ef7 <__umoddi3+0x117>
  801ee7:	39 c3                	cmp    %eax,%ebx
  801ee9:	73 0c                	jae    801ef7 <__umoddi3+0x117>
  801eeb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801eef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801ef3:	89 d7                	mov    %edx,%edi
  801ef5:	89 c6                	mov    %eax,%esi
  801ef7:	89 ca                	mov    %ecx,%edx
  801ef9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801efe:	29 f3                	sub    %esi,%ebx
  801f00:	19 fa                	sbb    %edi,%edx
  801f02:	89 d0                	mov    %edx,%eax
  801f04:	d3 e0                	shl    %cl,%eax
  801f06:	89 e9                	mov    %ebp,%ecx
  801f08:	d3 eb                	shr    %cl,%ebx
  801f0a:	d3 ea                	shr    %cl,%edx
  801f0c:	09 d8                	or     %ebx,%eax
  801f0e:	83 c4 1c             	add    $0x1c,%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5f                   	pop    %edi
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    
  801f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f1d:	8d 76 00             	lea    0x0(%esi),%esi
  801f20:	29 fe                	sub    %edi,%esi
  801f22:	19 c3                	sbb    %eax,%ebx
  801f24:	89 f2                	mov    %esi,%edx
  801f26:	89 d9                	mov    %ebx,%ecx
  801f28:	e9 1d ff ff ff       	jmp    801e4a <__umoddi3+0x6a>
