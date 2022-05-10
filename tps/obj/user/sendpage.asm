
obj/user/sendpage.debug:     formato del fichero elf32-i386


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
  80002c:	e8 83 01 00 00       	call   8001b4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  80003d:	e8 2d 11 00 00       	call   80116f <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 ab 00 00 00    	je     8000f8 <umain+0xc5>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 04 40 80 00       	mov    0x804004,%eax
  800052:	8b 40 48             	mov    0x48(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 a0 00       	push   $0xa00000
  80005f:	50                   	push   %eax
  800060:	e8 4a 0c 00 00       	call   800caf <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800065:	83 c4 04             	add    $0x4,%esp
  800068:	ff 35 04 30 80 00    	pushl  0x803004
  80006e:	e8 71 07 00 00       	call   8007e4 <strlen>
  800073:	83 c4 0c             	add    $0xc,%esp
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	50                   	push   %eax
  80007a:	ff 35 04 30 80 00    	pushl  0x803004
  800080:	68 00 00 a0 00       	push   $0xa00000
  800085:	e8 bb 09 00 00       	call   800a45 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80008a:	6a 07                	push   $0x7
  80008c:	68 00 00 a0 00       	push   $0xa00000
  800091:	6a 00                	push   $0x0
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 8d 12 00 00       	call   801328 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 0d 12 00 00       	call   8012bb <ipc_recv>
	cprintf("%x got message from %x: %s\n",
		thisenv->env_id, who, TEMP_ADDR);
  8000ae:	a1 04 40 80 00       	mov    0x804004,%eax
	cprintf("%x got message from %x: %s\n",
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	68 00 00 a0 00       	push   $0xa00000
  8000bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8000be:	50                   	push   %eax
  8000bf:	68 e0 24 80 00       	push   $0x8024e0
  8000c4:	e8 f4 01 00 00       	call   8002bd <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000c9:	83 c4 14             	add    $0x14,%esp
  8000cc:	ff 35 00 30 80 00    	pushl  0x803000
  8000d2:	e8 0d 07 00 00       	call   8007e4 <strlen>
  8000d7:	83 c4 0c             	add    $0xc,%esp
  8000da:	50                   	push   %eax
  8000db:	ff 35 00 30 80 00    	pushl  0x803000
  8000e1:	68 00 00 a0 00       	push   $0xa00000
  8000e6:	e8 25 08 00 00       	call   800910 <strncmp>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	0f 84 a9 00 00 00    	je     80019f <umain+0x16c>
		cprintf("parent received correct message\n");
	return;
}
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	6a 00                	push   $0x0
  8000fd:	68 00 00 b0 00       	push   $0xb00000
  800102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800105:	50                   	push   %eax
  800106:	e8 b0 11 00 00       	call   8012bb <ipc_recv>
			thisenv->env_id, who, TEMP_ADDR_CHILD);
  80010b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("%x got message from %x: %s\n",
  800110:	8b 40 48             	mov    0x48(%eax),%eax
  800113:	68 00 00 b0 00       	push   $0xb00000
  800118:	ff 75 f4             	pushl  -0xc(%ebp)
  80011b:	50                   	push   %eax
  80011c:	68 e0 24 80 00       	push   $0x8024e0
  800121:	e8 97 01 00 00       	call   8002bd <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800126:	83 c4 14             	add    $0x14,%esp
  800129:	ff 35 04 30 80 00    	pushl  0x803004
  80012f:	e8 b0 06 00 00       	call   8007e4 <strlen>
  800134:	83 c4 0c             	add    $0xc,%esp
  800137:	50                   	push   %eax
  800138:	ff 35 04 30 80 00    	pushl  0x803004
  80013e:	68 00 00 b0 00       	push   $0xb00000
  800143:	e8 c8 07 00 00       	call   800910 <strncmp>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 3e                	je     80018d <umain+0x15a>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	ff 35 00 30 80 00    	pushl  0x803000
  800158:	e8 87 06 00 00       	call   8007e4 <strlen>
  80015d:	83 c4 0c             	add    $0xc,%esp
  800160:	83 c0 01             	add    $0x1,%eax
  800163:	50                   	push   %eax
  800164:	ff 35 00 30 80 00    	pushl  0x803000
  80016a:	68 00 00 b0 00       	push   $0xb00000
  80016f:	e8 d1 08 00 00       	call   800a45 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800174:	6a 07                	push   $0x7
  800176:	68 00 00 b0 00       	push   $0xb00000
  80017b:	6a 00                	push   $0x0
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	e8 a3 11 00 00       	call   801328 <ipc_send>
		return;
  800185:	83 c4 20             	add    $0x20,%esp
  800188:	e9 69 ff ff ff       	jmp    8000f6 <umain+0xc3>
			cprintf("child received correct message\n");
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	68 fc 24 80 00       	push   $0x8024fc
  800195:	e8 23 01 00 00       	call   8002bd <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb b0                	jmp    80014f <umain+0x11c>
		cprintf("parent received correct message\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 1c 25 80 00       	push   $0x80251c
  8001a7:	e8 11 01 00 00       	call   8002bd <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	e9 42 ff ff ff       	jmp    8000f6 <umain+0xc3>

008001b4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b4:	f3 0f 1e fb          	endbr32 
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001c3:	e8 94 0a 00 00       	call   800c5c <sys_getenvid>
	if (id >= 0)
  8001c8:	85 c0                	test   %eax,%eax
  8001ca:	78 12                	js     8001de <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8001cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001d9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001de:	85 db                	test   %ebx,%ebx
  8001e0:	7e 07                	jle    8001e9 <libmain+0x35>
		binaryname = argv[0];
  8001e2:	8b 06                	mov    (%esi),%eax
  8001e4:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	e8 40 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001f3:	e8 0a 00 00 00       	call   800202 <exit>
}
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001fe:	5b                   	pop    %ebx
  8001ff:	5e                   	pop    %esi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    

00800202 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800202:	f3 0f 1e fb          	endbr32 
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80020c:	e8 9f 13 00 00       	call   8015b0 <close_all>
	sys_env_destroy(0);
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	6a 00                	push   $0x0
  800216:	e8 1b 0a 00 00       	call   800c36 <sys_env_destroy>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800220:	f3 0f 1e fb          	endbr32 
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	53                   	push   %ebx
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022e:	8b 13                	mov    (%ebx),%edx
  800230:	8d 42 01             	lea    0x1(%edx),%eax
  800233:	89 03                	mov    %eax,(%ebx)
  800235:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800238:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80023c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800241:	74 09                	je     80024c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800243:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	68 ff 00 00 00       	push   $0xff
  800254:	8d 43 08             	lea    0x8(%ebx),%eax
  800257:	50                   	push   %eax
  800258:	e8 87 09 00 00       	call   800be4 <sys_cputs>
		b->idx = 0;
  80025d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	eb db                	jmp    800243 <putch+0x23>

00800268 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800268:	f3 0f 1e fb          	endbr32 
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800275:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027c:	00 00 00 
	b.cnt = 0;
  80027f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800286:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800289:	ff 75 0c             	pushl  0xc(%ebp)
  80028c:	ff 75 08             	pushl  0x8(%ebp)
  80028f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800295:	50                   	push   %eax
  800296:	68 20 02 80 00       	push   $0x800220
  80029b:	e8 80 01 00 00       	call   800420 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a0:	83 c4 08             	add    $0x8,%esp
  8002a3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002af:	50                   	push   %eax
  8002b0:	e8 2f 09 00 00       	call   800be4 <sys_cputs>

	return b.cnt;
}
  8002b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bd:	f3 0f 1e fb          	endbr32 
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ca:	50                   	push   %eax
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 95 ff ff ff       	call   800268 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 1c             	sub    $0x1c,%esp
  8002de:	89 c7                	mov    %eax,%edi
  8002e0:	89 d6                	mov    %edx,%esi
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e8:	89 d1                	mov    %edx,%ecx
  8002ea:	89 c2                	mov    %eax,%edx
  8002ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800302:	39 c2                	cmp    %eax,%edx
  800304:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800307:	72 3e                	jb     800347 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	ff 75 18             	pushl  0x18(%ebp)
  80030f:	83 eb 01             	sub    $0x1,%ebx
  800312:	53                   	push   %ebx
  800313:	50                   	push   %eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031a:	ff 75 e0             	pushl  -0x20(%ebp)
  80031d:	ff 75 dc             	pushl  -0x24(%ebp)
  800320:	ff 75 d8             	pushl  -0x28(%ebp)
  800323:	e8 58 1f 00 00       	call   802280 <__udivdi3>
  800328:	83 c4 18             	add    $0x18,%esp
  80032b:	52                   	push   %edx
  80032c:	50                   	push   %eax
  80032d:	89 f2                	mov    %esi,%edx
  80032f:	89 f8                	mov    %edi,%eax
  800331:	e8 9f ff ff ff       	call   8002d5 <printnum>
  800336:	83 c4 20             	add    $0x20,%esp
  800339:	eb 13                	jmp    80034e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	56                   	push   %esi
  80033f:	ff 75 18             	pushl  0x18(%ebp)
  800342:	ff d7                	call   *%edi
  800344:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800347:	83 eb 01             	sub    $0x1,%ebx
  80034a:	85 db                	test   %ebx,%ebx
  80034c:	7f ed                	jg     80033b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	56                   	push   %esi
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	ff 75 e4             	pushl  -0x1c(%ebp)
  800358:	ff 75 e0             	pushl  -0x20(%ebp)
  80035b:	ff 75 dc             	pushl  -0x24(%ebp)
  80035e:	ff 75 d8             	pushl  -0x28(%ebp)
  800361:	e8 2a 20 00 00       	call   802390 <__umoddi3>
  800366:	83 c4 14             	add    $0x14,%esp
  800369:	0f be 80 94 25 80 00 	movsbl 0x802594(%eax),%eax
  800370:	50                   	push   %eax
  800371:	ff d7                	call   *%edi
}
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800379:	5b                   	pop    %ebx
  80037a:	5e                   	pop    %esi
  80037b:	5f                   	pop    %edi
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80037e:	83 fa 01             	cmp    $0x1,%edx
  800381:	7f 13                	jg     800396 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800383:	85 d2                	test   %edx,%edx
  800385:	74 1c                	je     8003a3 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	ba 00 00 00 00       	mov    $0x0,%edx
  800395:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800396:	8b 10                	mov    (%eax),%edx
  800398:	8d 4a 08             	lea    0x8(%edx),%ecx
  80039b:	89 08                	mov    %ecx,(%eax)
  80039d:	8b 02                	mov    (%edx),%eax
  80039f:	8b 52 04             	mov    0x4(%edx),%edx
  8003a2:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8003a3:	8b 10                	mov    (%eax),%edx
  8003a5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a8:	89 08                	mov    %ecx,(%eax)
  8003aa:	8b 02                	mov    (%edx),%eax
  8003ac:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b1:	c3                   	ret    

008003b2 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8003b2:	83 fa 01             	cmp    $0x1,%edx
  8003b5:	7f 0f                	jg     8003c6 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 18                	je     8003d3 <getint+0x21>
		return va_arg(*ap, long);
  8003bb:	8b 10                	mov    (%eax),%edx
  8003bd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c0:	89 08                	mov    %ecx,(%eax)
  8003c2:	8b 02                	mov    (%edx),%eax
  8003c4:	99                   	cltd   
  8003c5:	c3                   	ret    
		return va_arg(*ap, long long);
  8003c6:	8b 10                	mov    (%eax),%edx
  8003c8:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cb:	89 08                	mov    %ecx,(%eax)
  8003cd:	8b 02                	mov    (%edx),%eax
  8003cf:	8b 52 04             	mov    0x4(%edx),%edx
  8003d2:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8003d3:	8b 10                	mov    (%eax),%edx
  8003d5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003d8:	89 08                	mov    %ecx,(%eax)
  8003da:	8b 02                	mov    (%edx),%eax
  8003dc:	99                   	cltd   
}
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	f3 0f 1e fb          	endbr32 
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f1:	73 0a                	jae    8003fd <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	88 02                	mov    %al,(%edx)
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <printfmt>:
{
  8003ff:	f3 0f 1e fb          	endbr32 
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800409:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 05 00 00 00       	call   800420 <vprintfmt>
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <vprintfmt>:
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	57                   	push   %edi
  800428:	56                   	push   %esi
  800429:	53                   	push   %ebx
  80042a:	83 ec 2c             	sub    $0x2c,%esp
  80042d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800430:	8b 75 0c             	mov    0xc(%ebp),%esi
  800433:	8b 7d 10             	mov    0x10(%ebp),%edi
  800436:	e9 86 02 00 00       	jmp    8006c1 <vprintfmt+0x2a1>
		padc = ' ';
  80043b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800454:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8d 47 01             	lea    0x1(%edi),%eax
  80045c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045f:	0f b6 17             	movzbl (%edi),%edx
  800462:	8d 42 dd             	lea    -0x23(%edx),%eax
  800465:	3c 55                	cmp    $0x55,%al
  800467:	0f 87 df 02 00 00    	ja     80074c <vprintfmt+0x32c>
  80046d:	0f b6 c0             	movzbl %al,%eax
  800470:	3e ff 24 85 e0 26 80 	notrack jmp *0x8026e0(,%eax,4)
  800477:	00 
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047f:	eb d8                	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800484:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800488:	eb cf                	jmp    800459 <vprintfmt+0x39>
  80048a:	0f b6 d2             	movzbl %dl,%edx
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800498:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a5:	83 f9 09             	cmp    $0x9,%ecx
  8004a8:	77 52                	ja     8004fc <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8004aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ad:	eb e9                	jmp    800498 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8d 50 04             	lea    0x4(%eax),%edx
  8004b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c4:	79 93                	jns    800459 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d3:	eb 84                	jmp    800459 <vprintfmt+0x39>
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	85 c0                	test   %eax,%eax
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
  8004df:	0f 49 d0             	cmovns %eax,%edx
  8004e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004e8:	e9 6c ff ff ff       	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004f7:	e9 5d ff ff ff       	jmp    800459 <vprintfmt+0x39>
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800502:	eb bc                	jmp    8004c0 <vprintfmt+0xa0>
			lflag++;
  800504:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050a:	e9 4a ff ff ff       	jmp    800459 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 50 04             	lea    0x4(%eax),%edx
  800515:	89 55 14             	mov    %edx,0x14(%ebp)
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	56                   	push   %esi
  80051c:	ff 30                	pushl  (%eax)
  80051e:	ff d3                	call   *%ebx
			break;
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	e9 96 01 00 00       	jmp    8006be <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8d 50 04             	lea    0x4(%eax),%edx
  80052e:	89 55 14             	mov    %edx,0x14(%ebp)
  800531:	8b 00                	mov    (%eax),%eax
  800533:	99                   	cltd   
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 0f             	cmp    $0xf,%eax
  80053b:	7f 20                	jg     80055d <vprintfmt+0x13d>
  80053d:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 15                	je     80055d <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 63 2b 80 00       	push   $0x802b63
  80054e:	56                   	push   %esi
  80054f:	53                   	push   %ebx
  800550:	e8 aa fe ff ff       	call   8003ff <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	e9 61 01 00 00       	jmp    8006be <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80055d:	50                   	push   %eax
  80055e:	68 ac 25 80 00       	push   $0x8025ac
  800563:	56                   	push   %esi
  800564:	53                   	push   %ebx
  800565:	e8 95 fe ff ff       	call   8003ff <printfmt>
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	e9 4c 01 00 00       	jmp    8006be <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 50 04             	lea    0x4(%eax),%edx
  800578:	89 55 14             	mov    %edx,0x14(%ebp)
  80057b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80057d:	85 c9                	test   %ecx,%ecx
  80057f:	b8 a5 25 80 00       	mov    $0x8025a5,%eax
  800584:	0f 45 c1             	cmovne %ecx,%eax
  800587:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80058a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058e:	7e 06                	jle    800596 <vprintfmt+0x176>
  800590:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800594:	75 0d                	jne    8005a3 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800599:	89 c7                	mov    %eax,%edi
  80059b:	03 45 e0             	add    -0x20(%ebp),%eax
  80059e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a1:	eb 57                	jmp    8005fa <vprintfmt+0x1da>
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a9:	ff 75 cc             	pushl  -0x34(%ebp)
  8005ac:	e8 4f 02 00 00       	call   800800 <strnlen>
  8005b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b4:	29 c2                	sub    %eax,%edx
  8005b6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005b9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005bc:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8005c3:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c5:	85 db                	test   %ebx,%ebx
  8005c7:	7e 10                	jle    8005d9 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	56                   	push   %esi
  8005cd:	57                   	push   %edi
  8005ce:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	83 eb 01             	sub    $0x1,%ebx
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	eb ec                	jmp    8005c5 <vprintfmt+0x1a5>
  8005d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005df:	85 d2                	test   %edx,%edx
  8005e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e6:	0f 49 c2             	cmovns %edx,%eax
  8005e9:	29 c2                	sub    %eax,%edx
  8005eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005ee:	eb a6                	jmp    800596 <vprintfmt+0x176>
					putch(ch, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	56                   	push   %esi
  8005f4:	52                   	push   %edx
  8005f5:	ff d3                	call   *%ebx
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005fd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	83 c7 01             	add    $0x1,%edi
  800602:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800606:	0f be d0             	movsbl %al,%edx
  800609:	85 d2                	test   %edx,%edx
  80060b:	74 42                	je     80064f <vprintfmt+0x22f>
  80060d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800611:	78 06                	js     800619 <vprintfmt+0x1f9>
  800613:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800617:	78 1e                	js     800637 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800619:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80061d:	74 d1                	je     8005f0 <vprintfmt+0x1d0>
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 e8 20             	sub    $0x20,%eax
  800625:	83 f8 5e             	cmp    $0x5e,%eax
  800628:	76 c6                	jbe    8005f0 <vprintfmt+0x1d0>
					putch('?', putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	56                   	push   %esi
  80062e:	6a 3f                	push   $0x3f
  800630:	ff d3                	call   *%ebx
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb c3                	jmp    8005fa <vprintfmt+0x1da>
  800637:	89 cf                	mov    %ecx,%edi
  800639:	eb 0e                	jmp    800649 <vprintfmt+0x229>
				putch(' ', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	56                   	push   %esi
  80063f:	6a 20                	push   $0x20
  800641:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800643:	83 ef 01             	sub    $0x1,%edi
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	85 ff                	test   %edi,%edi
  80064b:	7f ee                	jg     80063b <vprintfmt+0x21b>
  80064d:	eb 6f                	jmp    8006be <vprintfmt+0x29e>
  80064f:	89 cf                	mov    %ecx,%edi
  800651:	eb f6                	jmp    800649 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800653:	89 ca                	mov    %ecx,%edx
  800655:	8d 45 14             	lea    0x14(%ebp),%eax
  800658:	e8 55 fd ff ff       	call   8003b2 <getint>
  80065d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800660:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800663:	85 d2                	test   %edx,%edx
  800665:	78 0b                	js     800672 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800667:	89 d1                	mov    %edx,%ecx
  800669:	89 c2                	mov    %eax,%edx
			base = 10;
  80066b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800670:	eb 32                	jmp    8006a4 <vprintfmt+0x284>
				putch('-', putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	56                   	push   %esi
  800676:	6a 2d                	push   $0x2d
  800678:	ff d3                	call   *%ebx
				num = -(long long) num;
  80067a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80067d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800680:	f7 da                	neg    %edx
  800682:	83 d1 00             	adc    $0x0,%ecx
  800685:	f7 d9                	neg    %ecx
  800687:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	eb 13                	jmp    8006a4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800691:	89 ca                	mov    %ecx,%edx
  800693:	8d 45 14             	lea    0x14(%ebp),%eax
  800696:	e8 e3 fc ff ff       	call   80037e <getuint>
  80069b:	89 d1                	mov    %edx,%ecx
  80069d:	89 c2                	mov    %eax,%edx
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006ab:	57                   	push   %edi
  8006ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	51                   	push   %ecx
  8006b1:	52                   	push   %edx
  8006b2:	89 f2                	mov    %esi,%edx
  8006b4:	89 d8                	mov    %ebx,%eax
  8006b6:	e8 1a fc ff ff       	call   8002d5 <printnum>
			break;
  8006bb:	83 c4 20             	add    $0x20,%esp
{
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c1:	83 c7 01             	add    $0x1,%edi
  8006c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c8:	83 f8 25             	cmp    $0x25,%eax
  8006cb:	0f 84 6a fd ff ff    	je     80043b <vprintfmt+0x1b>
			if (ch == '\0')
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 84 93 00 00 00    	je     80076c <vprintfmt+0x34c>
			putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	56                   	push   %esi
  8006dd:	50                   	push   %eax
  8006de:	ff d3                	call   *%ebx
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb dc                	jmp    8006c1 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8006e5:	89 ca                	mov    %ecx,%edx
  8006e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ea:	e8 8f fc ff ff       	call   80037e <getuint>
  8006ef:	89 d1                	mov    %edx,%ecx
  8006f1:	89 c2                	mov    %eax,%edx
			base = 8;
  8006f3:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006f8:	eb aa                	jmp    8006a4 <vprintfmt+0x284>
			putch('0', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	56                   	push   %esi
  8006fe:	6a 30                	push   $0x30
  800700:	ff d3                	call   *%ebx
			putch('x', putdat);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	56                   	push   %esi
  800706:	6a 78                	push   $0x78
  800708:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800713:	8b 10                	mov    (%eax),%edx
  800715:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80071a:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80071d:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800722:	eb 80                	jmp    8006a4 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800724:	89 ca                	mov    %ecx,%edx
  800726:	8d 45 14             	lea    0x14(%ebp),%eax
  800729:	e8 50 fc ff ff       	call   80037e <getuint>
  80072e:	89 d1                	mov    %edx,%ecx
  800730:	89 c2                	mov    %eax,%edx
			base = 16;
  800732:	b8 10 00 00 00       	mov    $0x10,%eax
  800737:	e9 68 ff ff ff       	jmp    8006a4 <vprintfmt+0x284>
			putch(ch, putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	56                   	push   %esi
  800740:	6a 25                	push   $0x25
  800742:	ff d3                	call   *%ebx
			break;
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	e9 72 ff ff ff       	jmp    8006be <vprintfmt+0x29e>
			putch('%', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	56                   	push   %esi
  800750:	6a 25                	push   $0x25
  800752:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	89 f8                	mov    %edi,%eax
  800759:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075d:	74 05                	je     800764 <vprintfmt+0x344>
  80075f:	83 e8 01             	sub    $0x1,%eax
  800762:	eb f5                	jmp    800759 <vprintfmt+0x339>
  800764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800767:	e9 52 ff ff ff       	jmp    8006be <vprintfmt+0x29e>
}
  80076c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076f:	5b                   	pop    %ebx
  800770:	5e                   	pop    %esi
  800771:	5f                   	pop    %edi
  800772:	5d                   	pop    %ebp
  800773:	c3                   	ret    

00800774 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800774:	f3 0f 1e fb          	endbr32 
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800784:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800787:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80078e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800795:	85 c0                	test   %eax,%eax
  800797:	74 26                	je     8007bf <vsnprintf+0x4b>
  800799:	85 d2                	test   %edx,%edx
  80079b:	7e 22                	jle    8007bf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80079d:	ff 75 14             	pushl  0x14(%ebp)
  8007a0:	ff 75 10             	pushl  0x10(%ebp)
  8007a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a6:	50                   	push   %eax
  8007a7:	68 de 03 80 00       	push   $0x8003de
  8007ac:	e8 6f fc ff ff       	call   800420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
}
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    
		return -E_INVAL;
  8007bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c4:	eb f7                	jmp    8007bd <vsnprintf+0x49>

008007c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c6:	f3 0f 1e fb          	endbr32 
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 10             	pushl  0x10(%ebp)
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	ff 75 08             	pushl  0x8(%ebp)
  8007dd:	e8 92 ff ff ff       	call   800774 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e4:	f3 0f 1e fb          	endbr32 
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f7:	74 05                	je     8007fe <strlen+0x1a>
		n++;
  8007f9:	83 c0 01             	add    $0x1,%eax
  8007fc:	eb f5                	jmp    8007f3 <strlen+0xf>
	return n;
}
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800800:	f3 0f 1e fb          	endbr32 
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
  800812:	39 d0                	cmp    %edx,%eax
  800814:	74 0d                	je     800823 <strnlen+0x23>
  800816:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081a:	74 05                	je     800821 <strnlen+0x21>
		n++;
  80081c:	83 c0 01             	add    $0x1,%eax
  80081f:	eb f1                	jmp    800812 <strnlen+0x12>
  800821:	89 c2                	mov    %eax,%edx
	return n;
}
  800823:	89 d0                	mov    %edx,%eax
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800827:	f3 0f 1e fb          	endbr32 
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80083e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800841:	83 c0 01             	add    $0x1,%eax
  800844:	84 d2                	test   %dl,%dl
  800846:	75 f2                	jne    80083a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800848:	89 c8                	mov    %ecx,%eax
  80084a:	5b                   	pop    %ebx
  80084b:	5d                   	pop    %ebp
  80084c:	c3                   	ret    

0080084d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	53                   	push   %ebx
  800855:	83 ec 10             	sub    $0x10,%esp
  800858:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085b:	53                   	push   %ebx
  80085c:	e8 83 ff ff ff       	call   8007e4 <strlen>
  800861:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	01 d8                	add    %ebx,%eax
  800869:	50                   	push   %eax
  80086a:	e8 b8 ff ff ff       	call   800827 <strcpy>
	return dst;
}
  80086f:	89 d8                	mov    %ebx,%eax
  800871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800876:	f3 0f 1e fb          	endbr32 
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	8b 75 08             	mov    0x8(%ebp),%esi
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
  800885:	89 f3                	mov    %esi,%ebx
  800887:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088a:	89 f0                	mov    %esi,%eax
  80088c:	39 d8                	cmp    %ebx,%eax
  80088e:	74 11                	je     8008a1 <strncpy+0x2b>
		*dst++ = *src;
  800890:	83 c0 01             	add    $0x1,%eax
  800893:	0f b6 0a             	movzbl (%edx),%ecx
  800896:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800899:	80 f9 01             	cmp    $0x1,%cl
  80089c:	83 da ff             	sbb    $0xffffffff,%edx
  80089f:	eb eb                	jmp    80088c <strncpy+0x16>
	}
	return ret;
}
  8008a1:	89 f0                	mov    %esi,%eax
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a7:	f3 0f 1e fb          	endbr32 
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	56                   	push   %esi
  8008af:	53                   	push   %ebx
  8008b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8008b9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	74 21                	je     8008e0 <strlcpy+0x39>
  8008bf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	74 14                	je     8008dd <strlcpy+0x36>
  8008c9:	0f b6 19             	movzbl (%ecx),%ebx
  8008cc:	84 db                	test   %bl,%bl
  8008ce:	74 0b                	je     8008db <strlcpy+0x34>
			*dst++ = *src++;
  8008d0:	83 c1 01             	add    $0x1,%ecx
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d9:	eb ea                	jmp    8008c5 <strlcpy+0x1e>
  8008db:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e0:	29 f0                	sub    %esi,%eax
}
  8008e2:	5b                   	pop    %ebx
  8008e3:	5e                   	pop    %esi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e6:	f3 0f 1e fb          	endbr32 
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f3:	0f b6 01             	movzbl (%ecx),%eax
  8008f6:	84 c0                	test   %al,%al
  8008f8:	74 0c                	je     800906 <strcmp+0x20>
  8008fa:	3a 02                	cmp    (%edx),%al
  8008fc:	75 08                	jne    800906 <strcmp+0x20>
		p++, q++;
  8008fe:	83 c1 01             	add    $0x1,%ecx
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	eb ed                	jmp    8008f3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800906:	0f b6 c0             	movzbl %al,%eax
  800909:	0f b6 12             	movzbl (%edx),%edx
  80090c:	29 d0                	sub    %edx,%eax
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800910:	f3 0f 1e fb          	endbr32 
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	53                   	push   %ebx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091e:	89 c3                	mov    %eax,%ebx
  800920:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800923:	eb 06                	jmp    80092b <strncmp+0x1b>
		n--, p++, q++;
  800925:	83 c0 01             	add    $0x1,%eax
  800928:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092b:	39 d8                	cmp    %ebx,%eax
  80092d:	74 16                	je     800945 <strncmp+0x35>
  80092f:	0f b6 08             	movzbl (%eax),%ecx
  800932:	84 c9                	test   %cl,%cl
  800934:	74 04                	je     80093a <strncmp+0x2a>
  800936:	3a 0a                	cmp    (%edx),%cl
  800938:	74 eb                	je     800925 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093a:	0f b6 00             	movzbl (%eax),%eax
  80093d:	0f b6 12             	movzbl (%edx),%edx
  800940:	29 d0                	sub    %edx,%eax
}
  800942:	5b                   	pop    %ebx
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    
		return 0;
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	eb f6                	jmp    800942 <strncmp+0x32>

0080094c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094c:	f3 0f 1e fb          	endbr32 
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095a:	0f b6 10             	movzbl (%eax),%edx
  80095d:	84 d2                	test   %dl,%dl
  80095f:	74 09                	je     80096a <strchr+0x1e>
		if (*s == c)
  800961:	38 ca                	cmp    %cl,%dl
  800963:	74 0a                	je     80096f <strchr+0x23>
	for (; *s; s++)
  800965:	83 c0 01             	add    $0x1,%eax
  800968:	eb f0                	jmp    80095a <strchr+0xe>
			return (char *) s;
	return 0;
  80096a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800971:	f3 0f 1e fb          	endbr32 
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800982:	38 ca                	cmp    %cl,%dl
  800984:	74 09                	je     80098f <strfind+0x1e>
  800986:	84 d2                	test   %dl,%dl
  800988:	74 05                	je     80098f <strfind+0x1e>
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	eb f0                	jmp    80097f <strfind+0xe>
			break;
	return (char *) s;
}
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800991:	f3 0f 1e fb          	endbr32 
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	57                   	push   %edi
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 55 08             	mov    0x8(%ebp),%edx
  80099e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009a1:	85 c9                	test   %ecx,%ecx
  8009a3:	74 33                	je     8009d8 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	09 c8                	or     %ecx,%eax
  8009a9:	a8 03                	test   $0x3,%al
  8009ab:	75 23                	jne    8009d0 <memset+0x3f>
		c &= 0xFF;
  8009ad:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b1:	89 d8                	mov    %ebx,%eax
  8009b3:	c1 e0 08             	shl    $0x8,%eax
  8009b6:	89 df                	mov    %ebx,%edi
  8009b8:	c1 e7 18             	shl    $0x18,%edi
  8009bb:	89 de                	mov    %ebx,%esi
  8009bd:	c1 e6 10             	shl    $0x10,%esi
  8009c0:	09 f7                	or     %esi,%edi
  8009c2:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009c4:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c7:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8009c9:	89 d7                	mov    %edx,%edi
  8009cb:	fc                   	cld    
  8009cc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ce:	eb 08                	jmp    8009d8 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d0:	89 d7                	mov    %edx,%edi
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	fc                   	cld    
  8009d6:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009d8:	89 d0                	mov    %edx,%eax
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5f                   	pop    %edi
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009df:	f3 0f 1e fb          	endbr32 
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	57                   	push   %edi
  8009e7:	56                   	push   %esi
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f1:	39 c6                	cmp    %eax,%esi
  8009f3:	73 32                	jae    800a27 <memmove+0x48>
  8009f5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f8:	39 c2                	cmp    %eax,%edx
  8009fa:	76 2b                	jbe    800a27 <memmove+0x48>
		s += n;
		d += n;
  8009fc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	89 fe                	mov    %edi,%esi
  800a01:	09 ce                	or     %ecx,%esi
  800a03:	09 d6                	or     %edx,%esi
  800a05:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0b:	75 0e                	jne    800a1b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0d:	83 ef 04             	sub    $0x4,%edi
  800a10:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a16:	fd                   	std    
  800a17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a19:	eb 09                	jmp    800a24 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1b:	83 ef 01             	sub    $0x1,%edi
  800a1e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a21:	fd                   	std    
  800a22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a24:	fc                   	cld    
  800a25:	eb 1a                	jmp    800a41 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a27:	89 c2                	mov    %eax,%edx
  800a29:	09 ca                	or     %ecx,%edx
  800a2b:	09 f2                	or     %esi,%edx
  800a2d:	f6 c2 03             	test   $0x3,%dl
  800a30:	75 0a                	jne    800a3c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a35:	89 c7                	mov    %eax,%edi
  800a37:	fc                   	cld    
  800a38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3a:	eb 05                	jmp    800a41 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3c:	89 c7                	mov    %eax,%edi
  800a3e:	fc                   	cld    
  800a3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a41:	5e                   	pop    %esi
  800a42:	5f                   	pop    %edi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a45:	f3 0f 1e fb          	endbr32 
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a4f:	ff 75 10             	pushl  0x10(%ebp)
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	ff 75 08             	pushl  0x8(%ebp)
  800a58:	e8 82 ff ff ff       	call   8009df <memmove>
}
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5f:	f3 0f 1e fb          	endbr32 
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	56                   	push   %esi
  800a67:	53                   	push   %ebx
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	89 c6                	mov    %eax,%esi
  800a70:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a73:	39 f0                	cmp    %esi,%eax
  800a75:	74 1c                	je     800a93 <memcmp+0x34>
		if (*s1 != *s2)
  800a77:	0f b6 08             	movzbl (%eax),%ecx
  800a7a:	0f b6 1a             	movzbl (%edx),%ebx
  800a7d:	38 d9                	cmp    %bl,%cl
  800a7f:	75 08                	jne    800a89 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	83 c2 01             	add    $0x1,%edx
  800a87:	eb ea                	jmp    800a73 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a89:	0f b6 c1             	movzbl %cl,%eax
  800a8c:	0f b6 db             	movzbl %bl,%ebx
  800a8f:	29 d8                	sub    %ebx,%eax
  800a91:	eb 05                	jmp    800a98 <memcmp+0x39>
	}

	return 0;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9c:	f3 0f 1e fb          	endbr32 
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa9:	89 c2                	mov    %eax,%edx
  800aab:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aae:	39 d0                	cmp    %edx,%eax
  800ab0:	73 09                	jae    800abb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab2:	38 08                	cmp    %cl,(%eax)
  800ab4:	74 05                	je     800abb <memfind+0x1f>
	for (; s < ends; s++)
  800ab6:	83 c0 01             	add    $0x1,%eax
  800ab9:	eb f3                	jmp    800aae <memfind+0x12>
			break;
	return (void *) s;
}
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abd:	f3 0f 1e fb          	endbr32 
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	57                   	push   %edi
  800ac5:	56                   	push   %esi
  800ac6:	53                   	push   %ebx
  800ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acd:	eb 03                	jmp    800ad2 <strtol+0x15>
		s++;
  800acf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad2:	0f b6 01             	movzbl (%ecx),%eax
  800ad5:	3c 20                	cmp    $0x20,%al
  800ad7:	74 f6                	je     800acf <strtol+0x12>
  800ad9:	3c 09                	cmp    $0x9,%al
  800adb:	74 f2                	je     800acf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800add:	3c 2b                	cmp    $0x2b,%al
  800adf:	74 2a                	je     800b0b <strtol+0x4e>
	int neg = 0;
  800ae1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae6:	3c 2d                	cmp    $0x2d,%al
  800ae8:	74 2b                	je     800b15 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af0:	75 0f                	jne    800b01 <strtol+0x44>
  800af2:	80 39 30             	cmpb   $0x30,(%ecx)
  800af5:	74 28                	je     800b1f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af7:	85 db                	test   %ebx,%ebx
  800af9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afe:	0f 44 d8             	cmove  %eax,%ebx
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b09:	eb 46                	jmp    800b51 <strtol+0x94>
		s++;
  800b0b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b13:	eb d5                	jmp    800aea <strtol+0x2d>
		s++, neg = 1;
  800b15:	83 c1 01             	add    $0x1,%ecx
  800b18:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1d:	eb cb                	jmp    800aea <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b23:	74 0e                	je     800b33 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b25:	85 db                	test   %ebx,%ebx
  800b27:	75 d8                	jne    800b01 <strtol+0x44>
		s++, base = 8;
  800b29:	83 c1 01             	add    $0x1,%ecx
  800b2c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b31:	eb ce                	jmp    800b01 <strtol+0x44>
		s += 2, base = 16;
  800b33:	83 c1 02             	add    $0x2,%ecx
  800b36:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3b:	eb c4                	jmp    800b01 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b43:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b46:	7d 3a                	jge    800b82 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b48:	83 c1 01             	add    $0x1,%ecx
  800b4b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b51:	0f b6 11             	movzbl (%ecx),%edx
  800b54:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 09             	cmp    $0x9,%bl
  800b5c:	76 df                	jbe    800b3d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b5e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b61:	89 f3                	mov    %esi,%ebx
  800b63:	80 fb 19             	cmp    $0x19,%bl
  800b66:	77 08                	ja     800b70 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b68:	0f be d2             	movsbl %dl,%edx
  800b6b:	83 ea 57             	sub    $0x57,%edx
  800b6e:	eb d3                	jmp    800b43 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b70:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b73:	89 f3                	mov    %esi,%ebx
  800b75:	80 fb 19             	cmp    $0x19,%bl
  800b78:	77 08                	ja     800b82 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b7a:	0f be d2             	movsbl %dl,%edx
  800b7d:	83 ea 37             	sub    $0x37,%edx
  800b80:	eb c1                	jmp    800b43 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b86:	74 05                	je     800b8d <strtol+0xd0>
		*endptr = (char *) s;
  800b88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8d:	89 c2                	mov    %eax,%edx
  800b8f:	f7 da                	neg    %edx
  800b91:	85 ff                	test   %edi,%edi
  800b93:	0f 45 c2             	cmovne %edx,%eax
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5f                   	pop    %edi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	83 ec 1c             	sub    $0x1c,%esp
  800ba4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ba7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800baa:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bb2:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bb5:	8b 75 14             	mov    0x14(%ebp),%esi
  800bb8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbe:	74 04                	je     800bc4 <syscall+0x29>
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	7f 08                	jg     800bcc <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bcc:	83 ec 0c             	sub    $0xc,%esp
  800bcf:	50                   	push   %eax
  800bd0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bd3:	68 9f 28 80 00       	push   $0x80289f
  800bd8:	6a 23                	push   $0x23
  800bda:	68 bc 28 80 00       	push   $0x8028bc
  800bdf:	e8 61 15 00 00       	call   802145 <_panic>

00800be4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800be4:	f3 0f 1e fb          	endbr32 
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800bee:	6a 00                	push   $0x0
  800bf0:	6a 00                	push   $0x0
  800bf2:	6a 00                	push   $0x0
  800bf4:	ff 75 0c             	pushl  0xc(%ebp)
  800bf7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	e8 92 ff ff ff       	call   800b9b <syscall>
}
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0e:	f3 0f 1e fb          	endbr32 
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c18:	6a 00                	push   $0x0
  800c1a:	6a 00                	push   $0x0
  800c1c:	6a 00                	push   $0x0
  800c1e:	6a 00                	push   $0x0
  800c20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c2f:	e8 67 ff ff ff       	call   800b9b <syscall>
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c36:	f3 0f 1e fb          	endbr32 
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c40:	6a 00                	push   $0x0
  800c42:	6a 00                	push   $0x0
  800c44:	6a 00                	push   $0x0
  800c46:	6a 00                	push   $0x0
  800c48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c50:	b8 03 00 00 00       	mov    $0x3,%eax
  800c55:	e8 41 ff ff ff       	call   800b9b <syscall>
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c66:	6a 00                	push   $0x0
  800c68:	6a 00                	push   $0x0
  800c6a:	6a 00                	push   $0x0
  800c6c:	6a 00                	push   $0x0
  800c6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c73:	ba 00 00 00 00       	mov    $0x0,%edx
  800c78:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7d:	e8 19 ff ff ff       	call   800b9b <syscall>
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <sys_yield>:

void
sys_yield(void)
{
  800c84:	f3 0f 1e fb          	endbr32 
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c8e:	6a 00                	push   $0x0
  800c90:	6a 00                	push   $0x0
  800c92:	6a 00                	push   $0x0
  800c94:	6a 00                	push   $0x0
  800c96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca5:	e8 f1 fe ff ff       	call   800b9b <syscall>
}
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800caf:	f3 0f 1e fb          	endbr32 
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cb9:	6a 00                	push   $0x0
  800cbb:	6a 00                	push   $0x0
  800cbd:	ff 75 10             	pushl  0x10(%ebp)
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc6:	ba 01 00 00 00       	mov    $0x1,%edx
  800ccb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd0:	e8 c6 fe ff ff       	call   800b9b <syscall>
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd7:	f3 0f 1e fb          	endbr32 
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800ce1:	ff 75 18             	pushl  0x18(%ebp)
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	ff 75 0c             	pushl  0xc(%ebp)
  800ced:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf0:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf5:	b8 05 00 00 00       	mov    $0x5,%eax
  800cfa:	e8 9c fe ff ff       	call   800b9b <syscall>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d0b:	6a 00                	push   $0x0
  800d0d:	6a 00                	push   $0x0
  800d0f:	6a 00                	push   $0x0
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d17:	ba 01 00 00 00       	mov    $0x1,%edx
  800d1c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d21:	e8 75 fe ff ff       	call   800b9b <syscall>
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d28:	f3 0f 1e fb          	endbr32 
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d32:	6a 00                	push   $0x0
  800d34:	6a 00                	push   $0x0
  800d36:	6a 00                	push   $0x0
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d3e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	e8 4e fe ff ff       	call   800b9b <syscall>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d4f:	f3 0f 1e fb          	endbr32 
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d59:	6a 00                	push   $0x0
  800d5b:	6a 00                	push   $0x0
  800d5d:	6a 00                	push   $0x0
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d65:	ba 01 00 00 00       	mov    $0x1,%edx
  800d6a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6f:	e8 27 fe ff ff       	call   800b9b <syscall>
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d76:	f3 0f 1e fb          	endbr32 
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d80:	6a 00                	push   $0x0
  800d82:	6a 00                	push   $0x0
  800d84:	6a 00                	push   $0x0
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d8c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	e8 00 fe ff ff       	call   800b9b <syscall>
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9d:	f3 0f 1e fb          	endbr32 
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800da7:	6a 00                	push   $0x0
  800da9:	ff 75 14             	pushl  0x14(%ebp)
  800dac:	ff 75 10             	pushl  0x10(%ebp)
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db5:	ba 00 00 00 00       	mov    $0x0,%edx
  800dba:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbf:	e8 d7 fd ff ff       	call   800b9b <syscall>
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800dd0:	6a 00                	push   $0x0
  800dd2:	6a 00                	push   $0x0
  800dd4:	6a 00                	push   $0x0
  800dd6:	6a 00                	push   $0x0
  800dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddb:	ba 01 00 00 00       	mov    $0x1,%edx
  800de0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de5:	e8 b1 fd ff ff       	call   800b9b <syscall>
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	53                   	push   %ebx
  800df0:	83 ec 04             	sub    $0x4,%esp
  800df3:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800df5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800dfc:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800dff:	f6 c6 04             	test   $0x4,%dh
  800e02:	75 51                	jne    800e55 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800e04:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800e0a:	0f 84 84 00 00 00    	je     800e94 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	68 05 08 00 00       	push   $0x805
  800e18:	53                   	push   %ebx
  800e19:	50                   	push   %eax
  800e1a:	53                   	push   %ebx
  800e1b:	6a 00                	push   $0x0
  800e1d:	e8 b5 fe ff ff       	call   800cd7 <sys_page_map>
		if (r)
  800e22:	83 c4 20             	add    $0x20,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	75 59                	jne    800e82 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 05 08 00 00       	push   $0x805
  800e31:	53                   	push   %ebx
  800e32:	6a 00                	push   $0x0
  800e34:	53                   	push   %ebx
  800e35:	6a 00                	push   $0x0
  800e37:	e8 9b fe ff ff       	call   800cd7 <sys_page_map>
		if (r)
  800e3c:	83 c4 20             	add    $0x20,%esp
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	74 67                	je     800eaa <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800e43:	50                   	push   %eax
  800e44:	68 ca 28 80 00       	push   $0x8028ca
  800e49:	6a 5f                	push   $0x5f
  800e4b:	68 e5 28 80 00       	push   $0x8028e5
  800e50:	e8 f0 12 00 00       	call   802145 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800e5e:	52                   	push   %edx
  800e5f:	53                   	push   %ebx
  800e60:	50                   	push   %eax
  800e61:	53                   	push   %ebx
  800e62:	6a 00                	push   $0x0
  800e64:	e8 6e fe ff ff       	call   800cd7 <sys_page_map>
		if (r)
  800e69:	83 c4 20             	add    $0x20,%esp
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	74 3a                	je     800eaa <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800e70:	50                   	push   %eax
  800e71:	68 ca 28 80 00       	push   $0x8028ca
  800e76:	6a 57                	push   $0x57
  800e78:	68 e5 28 80 00       	push   $0x8028e5
  800e7d:	e8 c3 12 00 00       	call   802145 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800e82:	50                   	push   %eax
  800e83:	68 ca 28 80 00       	push   $0x8028ca
  800e88:	6a 5b                	push   $0x5b
  800e8a:	68 e5 28 80 00       	push   $0x8028e5
  800e8f:	e8 b1 12 00 00       	call   802145 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	6a 05                	push   $0x5
  800e99:	53                   	push   %ebx
  800e9a:	50                   	push   %eax
  800e9b:	53                   	push   %ebx
  800e9c:	6a 00                	push   $0x0
  800e9e:	e8 34 fe ff ff       	call   800cd7 <sys_page_map>
		if (r)
  800ea3:	83 c4 20             	add    $0x20,%esp
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	75 0a                	jne    800eb4 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800eb4:	50                   	push   %eax
  800eb5:	68 ca 28 80 00       	push   $0x8028ca
  800eba:	6a 63                	push   $0x63
  800ebc:	68 e5 28 80 00       	push   $0x8028e5
  800ec1:	e8 7f 12 00 00       	call   802145 <_panic>

00800ec6 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	89 c7                	mov    %eax,%edi
  800ed1:	89 d6                	mov    %edx,%esi
  800ed3:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800ed5:	f6 c1 02             	test   $0x2,%cl
  800ed8:	75 2f                	jne    800f09 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	51                   	push   %ecx
  800ede:	52                   	push   %edx
  800edf:	50                   	push   %eax
  800ee0:	52                   	push   %edx
  800ee1:	6a 00                	push   $0x0
  800ee3:	e8 ef fd ff ff       	call   800cd7 <sys_page_map>
  800ee8:	83 c4 20             	add    $0x20,%esp
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	78 08                	js     800ef7 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800ef7:	50                   	push   %eax
  800ef8:	68 d4 28 80 00       	push   $0x8028d4
  800efd:	6a 6f                	push   $0x6f
  800eff:	68 e5 28 80 00       	push   $0x8028e5
  800f04:	e8 3c 12 00 00       	call   802145 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800f09:	83 ec 04             	sub    $0x4,%esp
  800f0c:	51                   	push   %ecx
  800f0d:	52                   	push   %edx
  800f0e:	50                   	push   %eax
  800f0f:	e8 9b fd ff ff       	call   800caf <sys_page_alloc>
  800f14:	83 c4 10             	add    $0x10,%esp
  800f17:	85 c0                	test   %eax,%eax
  800f19:	78 54                	js     800f6f <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	53                   	push   %ebx
  800f1f:	68 00 00 40 00       	push   $0x400000
  800f24:	6a 00                	push   $0x0
  800f26:	56                   	push   %esi
  800f27:	57                   	push   %edi
  800f28:	e8 aa fd ff ff       	call   800cd7 <sys_page_map>
  800f2d:	83 c4 20             	add    $0x20,%esp
  800f30:	85 c0                	test   %eax,%eax
  800f32:	78 4d                	js     800f81 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  800f34:	83 ec 04             	sub    $0x4,%esp
  800f37:	68 00 10 00 00       	push   $0x1000
  800f3c:	56                   	push   %esi
  800f3d:	68 00 00 40 00       	push   $0x400000
  800f42:	e8 98 fa ff ff       	call   8009df <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800f47:	83 c4 08             	add    $0x8,%esp
  800f4a:	68 00 00 40 00       	push   $0x400000
  800f4f:	6a 00                	push   $0x0
  800f51:	e8 ab fd ff ff       	call   800d01 <sys_page_unmap>
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	79 92                	jns    800eef <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  800f5d:	50                   	push   %eax
  800f5e:	68 03 29 80 00       	push   $0x802903
  800f63:	6a 78                	push   $0x78
  800f65:	68 e5 28 80 00       	push   $0x8028e5
  800f6a:	e8 d6 11 00 00       	call   802145 <_panic>
		panic("sys_page_alloc: %e", r);
  800f6f:	50                   	push   %eax
  800f70:	68 f0 28 80 00       	push   $0x8028f0
  800f75:	6a 73                	push   $0x73
  800f77:	68 e5 28 80 00       	push   $0x8028e5
  800f7c:	e8 c4 11 00 00       	call   802145 <_panic>
		panic("sys_page_map: %e", r);
  800f81:	50                   	push   %eax
  800f82:	68 d4 28 80 00       	push   $0x8028d4
  800f87:	6a 75                	push   $0x75
  800f89:	68 e5 28 80 00       	push   $0x8028e5
  800f8e:	e8 b2 11 00 00       	call   802145 <_panic>

00800f93 <pgfault>:
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 04             	sub    $0x4,%esp
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fa1:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  800fa3:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  800fa6:	89 da                	mov    %ebx,%edx
  800fa8:	c1 ea 0c             	shr    $0xc,%edx
  800fab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  800fb2:	a8 01                	test   $0x1,%al
  800fb4:	74 7e                	je     801034 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  800fb6:	a8 02                	test   $0x2,%al
  800fb8:	0f 84 8a 00 00 00    	je     801048 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  800fbe:	f6 c6 08             	test   $0x8,%dh
  800fc1:	0f 84 95 00 00 00    	je     80105c <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  800fc7:	83 ec 04             	sub    $0x4,%esp
  800fca:	6a 07                	push   $0x7
  800fcc:	68 00 f0 7f 00       	push   $0x7ff000
  800fd1:	6a 00                	push   $0x0
  800fd3:	e8 d7 fc ff ff       	call   800caf <sys_page_alloc>
	if (r)
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	0f 85 8d 00 00 00    	jne    801070 <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800fe3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	68 00 10 00 00       	push   $0x1000
  800ff1:	53                   	push   %ebx
  800ff2:	68 00 f0 7f 00       	push   $0x7ff000
  800ff7:	e8 49 fa ff ff       	call   800a45 <memcpy>
	r = sys_page_map(
  800ffc:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801003:	53                   	push   %ebx
  801004:	6a 00                	push   $0x0
  801006:	68 00 f0 7f 00       	push   $0x7ff000
  80100b:	6a 00                	push   $0x0
  80100d:	e8 c5 fc ff ff       	call   800cd7 <sys_page_map>
	if (r)
  801012:	83 c4 20             	add    $0x20,%esp
  801015:	85 c0                	test   %eax,%eax
  801017:	75 69                	jne    801082 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	68 00 f0 7f 00       	push   $0x7ff000
  801021:	6a 00                	push   $0x0
  801023:	e8 d9 fc ff ff       	call   800d01 <sys_page_unmap>
	if (r)
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 65                	jne    801094 <pgfault+0x101>
}
  80102f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801032:	c9                   	leave  
  801033:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  801034:	83 ec 04             	sub    $0x4,%esp
  801037:	68 84 29 80 00       	push   $0x802984
  80103c:	6a 20                	push   $0x20
  80103e:	68 e5 28 80 00       	push   $0x8028e5
  801043:	e8 fd 10 00 00       	call   802145 <_panic>
		panic("[pgfault] pgfault por lectura");
  801048:	83 ec 04             	sub    $0x4,%esp
  80104b:	68 16 29 80 00       	push   $0x802916
  801050:	6a 23                	push   $0x23
  801052:	68 e5 28 80 00       	push   $0x8028e5
  801057:	e8 e9 10 00 00       	call   802145 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  80105c:	83 ec 04             	sub    $0x4,%esp
  80105f:	68 b0 29 80 00       	push   $0x8029b0
  801064:	6a 27                	push   $0x27
  801066:	68 e5 28 80 00       	push   $0x8028e5
  80106b:	e8 d5 10 00 00       	call   802145 <_panic>
		panic("pgfault: %e", r);
  801070:	50                   	push   %eax
  801071:	68 34 29 80 00       	push   $0x802934
  801076:	6a 32                	push   $0x32
  801078:	68 e5 28 80 00       	push   $0x8028e5
  80107d:	e8 c3 10 00 00       	call   802145 <_panic>
		panic("pgfault: %e", r);
  801082:	50                   	push   %eax
  801083:	68 34 29 80 00       	push   $0x802934
  801088:	6a 39                	push   $0x39
  80108a:	68 e5 28 80 00       	push   $0x8028e5
  80108f:	e8 b1 10 00 00       	call   802145 <_panic>
		panic("pgfault: %e", r);
  801094:	50                   	push   %eax
  801095:	68 34 29 80 00       	push   $0x802934
  80109a:	6a 3d                	push   $0x3d
  80109c:	68 e5 28 80 00       	push   $0x8028e5
  8010a1:	e8 9f 10 00 00       	call   802145 <_panic>

008010a6 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  8010a6:	f3 0f 1e fb          	endbr32 
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	57                   	push   %edi
  8010ae:	56                   	push   %esi
  8010af:	53                   	push   %ebx
  8010b0:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8010b8:	cd 30                	int    $0x30
  8010ba:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 22                	js     8010e2 <fork_v0+0x3c>
  8010c0:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8010c2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010c7:	75 52                	jne    80111b <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010c9:	e8 8e fb ff ff       	call   800c5c <sys_getenvid>
  8010ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010d3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010db:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010e0:	eb 6e                	jmp    801150 <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  8010e2:	50                   	push   %eax
  8010e3:	68 d8 29 80 00       	push   $0x8029d8
  8010e8:	68 8a 00 00 00       	push   $0x8a
  8010ed:	68 e5 28 80 00       	push   $0x8028e5
  8010f2:	e8 4e 10 00 00       	call   802145 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  8010f7:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  8010fe:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801104:	89 da                	mov    %ebx,%edx
  801106:	89 f0                	mov    %esi,%eax
  801108:	e8 b9 fd ff ff       	call   800ec6 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80110d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801113:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801119:	74 23                	je     80113e <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	c1 e8 16             	shr    $0x16,%eax
  801120:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801127:	a8 01                	test   $0x1,%al
  801129:	74 e2                	je     80110d <fork_v0+0x67>
  80112b:	89 d8                	mov    %ebx,%eax
  80112d:	c1 e8 0c             	shr    $0xc,%eax
  801130:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801137:	f6 c2 01             	test   $0x1,%dl
  80113a:	74 d1                	je     80110d <fork_v0+0x67>
  80113c:	eb b9                	jmp    8010f7 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80113e:	83 ec 08             	sub    $0x8,%esp
  801141:	6a 02                	push   $0x2
  801143:	57                   	push   %edi
  801144:	e8 df fb ff ff       	call   800d28 <sys_env_set_status>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 0a                	js     80115a <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  801150:	89 f8                	mov    %edi,%eax
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  80115a:	50                   	push   %eax
  80115b:	68 fc 29 80 00       	push   $0x8029fc
  801160:	68 98 00 00 00       	push   $0x98
  801165:	68 e5 28 80 00       	push   $0x8028e5
  80116a:	e8 d6 0f 00 00       	call   802145 <_panic>

0080116f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80116f:	f3 0f 1e fb          	endbr32 
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  80117c:	68 93 0f 80 00       	push   $0x800f93
  801181:	e8 09 10 00 00       	call   80218f <set_pgfault_handler>
  801186:	b8 07 00 00 00       	mov    $0x7,%eax
  80118b:	cd 30                	int    $0x30
  80118d:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	78 37                	js     8011cd <fork+0x5e>
  801196:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801198:	74 48                	je     8011e2 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	6a 07                	push   $0x7
  80119f:	68 00 f0 bf ee       	push   $0xeebff000
  8011a4:	50                   	push   %eax
  8011a5:	e8 05 fb ff ff       	call   800caf <sys_page_alloc>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 4d                	js     8011fe <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	68 0c 22 80 00       	push   $0x80220c
  8011b9:	56                   	push   %esi
  8011ba:	e8 b7 fb ff ff       	call   800d76 <sys_env_set_pgfault_upcall>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	78 4d                	js     801213 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8011c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cb:	eb 70                	jmp    80123d <fork+0xce>
		panic("sys_exofork: %e", envid);
  8011cd:	50                   	push   %eax
  8011ce:	68 40 29 80 00       	push   $0x802940
  8011d3:	68 b7 00 00 00       	push   $0xb7
  8011d8:	68 e5 28 80 00       	push   $0x8028e5
  8011dd:	e8 63 0f 00 00       	call   802145 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011e2:	e8 75 fa ff ff       	call   800c5c <sys_getenvid>
  8011e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011f4:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011f9:	e9 80 00 00 00       	jmp    80127e <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  8011fe:	50                   	push   %eax
  8011ff:	68 50 29 80 00       	push   $0x802950
  801204:	68 c0 00 00 00       	push   $0xc0
  801209:	68 e5 28 80 00       	push   $0x8028e5
  80120e:	e8 32 0f 00 00       	call   802145 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801213:	50                   	push   %eax
  801214:	68 20 2a 80 00       	push   $0x802a20
  801219:	68 c3 00 00 00       	push   $0xc3
  80121e:	68 e5 28 80 00       	push   $0x8028e5
  801223:	e8 1d 0f 00 00       	call   802145 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801228:	89 f8                	mov    %edi,%eax
  80122a:	e8 bd fb ff ff       	call   800dec <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80122f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801235:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80123b:	74 2f                	je     80126c <fork+0xfd>
  80123d:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  80123f:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801245:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80124a:	76 e3                	jbe    80122f <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80124c:	89 d8                	mov    %ebx,%eax
  80124e:	c1 e8 16             	shr    $0x16,%eax
  801251:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801258:	a8 01                	test   $0x1,%al
  80125a:	74 d3                	je     80122f <fork+0xc0>
  80125c:	c1 ea 0c             	shr    $0xc,%edx
  80125f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801266:	a8 01                	test   $0x1,%al
  801268:	74 c5                	je     80122f <fork+0xc0>
  80126a:	eb bc                	jmp    801228 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	6a 02                	push   $0x2
  801271:	56                   	push   %esi
  801272:	e8 b1 fa ff ff       	call   800d28 <sys_env_set_status>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 0a                	js     801288 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  80127e:	89 f0                	mov    %esi,%eax
  801280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801283:	5b                   	pop    %ebx
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801288:	50                   	push   %eax
  801289:	68 4c 2a 80 00       	push   $0x802a4c
  80128e:	68 ce 00 00 00       	push   $0xce
  801293:	68 e5 28 80 00       	push   $0x8028e5
  801298:	e8 a8 0e 00 00       	call   802145 <_panic>

0080129d <sfork>:

// Challenge!
int
sfork(void)
{
  80129d:	f3 0f 1e fb          	endbr32 
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012a7:	68 6e 29 80 00       	push   $0x80296e
  8012ac:	68 d7 00 00 00       	push   $0xd7
  8012b1:	68 e5 28 80 00       	push   $0x8028e5
  8012b6:	e8 8a 0e 00 00       	call   802145 <_panic>

008012bb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012bb:	f3 0f 1e fb          	endbr32 
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	56                   	push   %esi
  8012c3:	53                   	push   %ebx
  8012c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012d4:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	50                   	push   %eax
  8012db:	e8 e6 fa ff ff       	call   800dc6 <sys_ipc_recv>
	if (r < 0) {
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 2b                	js     801312 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8012e7:	85 f6                	test   %esi,%esi
  8012e9:	74 0a                	je     8012f5 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8012eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012f0:	8b 40 74             	mov    0x74(%eax),%eax
  8012f3:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 0a                	je     801303 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8012f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fe:	8b 40 78             	mov    0x78(%eax),%eax
  801301:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801303:	a1 04 40 80 00       	mov    0x804004,%eax
  801308:	8b 40 70             	mov    0x70(%eax),%eax
}
  80130b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130e:	5b                   	pop    %ebx
  80130f:	5e                   	pop    %esi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
		if (from_env_store) {
  801312:	85 f6                	test   %esi,%esi
  801314:	74 06                	je     80131c <ipc_recv+0x61>
			*from_env_store = 0;
  801316:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  80131c:	85 db                	test   %ebx,%ebx
  80131e:	74 eb                	je     80130b <ipc_recv+0x50>
			*perm_store = 0;
  801320:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801326:	eb e3                	jmp    80130b <ipc_recv+0x50>

00801328 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 0c             	sub    $0xc,%esp
  801335:	8b 7d 08             	mov    0x8(%ebp),%edi
  801338:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  80133e:	85 db                	test   %ebx,%ebx
  801340:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801345:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801348:	ff 75 14             	pushl  0x14(%ebp)
  80134b:	53                   	push   %ebx
  80134c:	56                   	push   %esi
  80134d:	57                   	push   %edi
  80134e:	e8 4a fa ff ff       	call   800d9d <sys_ipc_try_send>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801359:	75 07                	jne    801362 <ipc_send+0x3a>
		sys_yield();
  80135b:	e8 24 f9 ff ff       	call   800c84 <sys_yield>
  801360:	eb e6                	jmp    801348 <ipc_send+0x20>
	}

	if (ret < 0) {
  801362:	85 c0                	test   %eax,%eax
  801364:	78 08                	js     80136e <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5f                   	pop    %edi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  80136e:	50                   	push   %eax
  80136f:	68 6e 2a 80 00       	push   $0x802a6e
  801374:	6a 48                	push   $0x48
  801376:	68 8b 2a 80 00       	push   $0x802a8b
  80137b:	e8 c5 0d 00 00       	call   802145 <_panic>

00801380 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801380:	f3 0f 1e fb          	endbr32 
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80138f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801392:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801398:	8b 52 50             	mov    0x50(%edx),%edx
  80139b:	39 ca                	cmp    %ecx,%edx
  80139d:	74 11                	je     8013b0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80139f:	83 c0 01             	add    $0x1,%eax
  8013a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013a7:	75 e6                	jne    80138f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ae:	eb 0b                	jmp    8013bb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013bd:	f3 0f 1e fb          	endbr32 
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	05 00 00 00 30       	add    $0x30000000,%eax
  8013cc:	c1 e8 0c             	shr    $0xc,%eax
}
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    

008013d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013d1:	f3 0f 1e fb          	endbr32 
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8013db:	ff 75 08             	pushl  0x8(%ebp)
  8013de:	e8 da ff ff ff       	call   8013bd <fd2num>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	c1 e0 0c             	shl    $0xc,%eax
  8013e9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	c1 ea 16             	shr    $0x16,%edx
  801401:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801408:	f6 c2 01             	test   $0x1,%dl
  80140b:	74 2d                	je     80143a <fd_alloc+0x4a>
  80140d:	89 c2                	mov    %eax,%edx
  80140f:	c1 ea 0c             	shr    $0xc,%edx
  801412:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801419:	f6 c2 01             	test   $0x1,%dl
  80141c:	74 1c                	je     80143a <fd_alloc+0x4a>
  80141e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801423:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801428:	75 d2                	jne    8013fc <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801433:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801438:	eb 0a                	jmp    801444 <fd_alloc+0x54>
			*fd_store = fd;
  80143a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801446:	f3 0f 1e fb          	endbr32 
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801450:	83 f8 1f             	cmp    $0x1f,%eax
  801453:	77 30                	ja     801485 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801455:	c1 e0 0c             	shl    $0xc,%eax
  801458:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80145d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801463:	f6 c2 01             	test   $0x1,%dl
  801466:	74 24                	je     80148c <fd_lookup+0x46>
  801468:	89 c2                	mov    %eax,%edx
  80146a:	c1 ea 0c             	shr    $0xc,%edx
  80146d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801474:	f6 c2 01             	test   $0x1,%dl
  801477:	74 1a                	je     801493 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	89 02                	mov    %eax,(%edx)
	return 0;
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    
		return -E_INVAL;
  801485:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148a:	eb f7                	jmp    801483 <fd_lookup+0x3d>
		return -E_INVAL;
  80148c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801491:	eb f0                	jmp    801483 <fd_lookup+0x3d>
  801493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801498:	eb e9                	jmp    801483 <fd_lookup+0x3d>

0080149a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80149a:	f3 0f 1e fb          	endbr32 
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a7:	ba 14 2b 80 00       	mov    $0x802b14,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014ac:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014b1:	39 08                	cmp    %ecx,(%eax)
  8014b3:	74 33                	je     8014e8 <dev_lookup+0x4e>
  8014b5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014b8:	8b 02                	mov    (%edx),%eax
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	75 f3                	jne    8014b1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014be:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c3:	8b 40 48             	mov    0x48(%eax),%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	51                   	push   %ecx
  8014ca:	50                   	push   %eax
  8014cb:	68 98 2a 80 00       	push   $0x802a98
  8014d0:	e8 e8 ed ff ff       	call   8002bd <cprintf>
	*dev = 0;
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    
			*dev = devtab[i];
  8014e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014eb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	eb f2                	jmp    8014e6 <dev_lookup+0x4c>

008014f4 <fd_close>:
{
  8014f4:	f3 0f 1e fb          	endbr32 
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	57                   	push   %edi
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 28             	sub    $0x28,%esp
  801501:	8b 75 08             	mov    0x8(%ebp),%esi
  801504:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801507:	56                   	push   %esi
  801508:	e8 b0 fe ff ff       	call   8013bd <fd2num>
  80150d:	83 c4 08             	add    $0x8,%esp
  801510:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	e8 2c ff ff ff       	call   801446 <fd_lookup>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 05                	js     801528 <fd_close+0x34>
	    || fd != fd2)
  801523:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801526:	74 16                	je     80153e <fd_close+0x4a>
		return (must_exist ? r : 0);
  801528:	89 f8                	mov    %edi,%eax
  80152a:	84 c0                	test   %al,%al
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
  801531:	0f 44 d8             	cmove  %eax,%ebx
}
  801534:	89 d8                	mov    %ebx,%eax
  801536:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801539:	5b                   	pop    %ebx
  80153a:	5e                   	pop    %esi
  80153b:	5f                   	pop    %edi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	ff 36                	pushl  (%esi)
  801547:	e8 4e ff ff ff       	call   80149a <dev_lookup>
  80154c:	89 c3                	mov    %eax,%ebx
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 1a                	js     80156f <fd_close+0x7b>
		if (dev->dev_close)
  801555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801558:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80155b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801560:	85 c0                	test   %eax,%eax
  801562:	74 0b                	je     80156f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	56                   	push   %esi
  801568:	ff d0                	call   *%eax
  80156a:	89 c3                	mov    %eax,%ebx
  80156c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	56                   	push   %esi
  801573:	6a 00                	push   $0x0
  801575:	e8 87 f7 ff ff       	call   800d01 <sys_page_unmap>
	return r;
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	eb b5                	jmp    801534 <fd_close+0x40>

0080157f <close>:

int
close(int fdnum)
{
  80157f:	f3 0f 1e fb          	endbr32 
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801589:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 b1 fe ff ff       	call   801446 <fd_lookup>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	79 02                	jns    80159e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    
		return fd_close(fd, 1);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	6a 01                	push   $0x1
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	e8 49 ff ff ff       	call   8014f4 <fd_close>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	eb ec                	jmp    80159c <close+0x1d>

008015b0 <close_all>:

void
close_all(void)
{
  8015b0:	f3 0f 1e fb          	endbr32 
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	53                   	push   %ebx
  8015c4:	e8 b6 ff ff ff       	call   80157f <close>
	for (i = 0; i < MAXFD; i++)
  8015c9:	83 c3 01             	add    $0x1,%ebx
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	83 fb 20             	cmp    $0x20,%ebx
  8015d2:	75 ec                	jne    8015c0 <close_all+0x10>
}
  8015d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015d9:	f3 0f 1e fb          	endbr32 
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	57                   	push   %edi
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015e9:	50                   	push   %eax
  8015ea:	ff 75 08             	pushl  0x8(%ebp)
  8015ed:	e8 54 fe ff ff       	call   801446 <fd_lookup>
  8015f2:	89 c3                	mov    %eax,%ebx
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	0f 88 81 00 00 00    	js     801680 <dup+0xa7>
		return r;
	close(newfdnum);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	ff 75 0c             	pushl  0xc(%ebp)
  801605:	e8 75 ff ff ff       	call   80157f <close>

	newfd = INDEX2FD(newfdnum);
  80160a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160d:	c1 e6 0c             	shl    $0xc,%esi
  801610:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801616:	83 c4 04             	add    $0x4,%esp
  801619:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161c:	e8 b0 fd ff ff       	call   8013d1 <fd2data>
  801621:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801623:	89 34 24             	mov    %esi,(%esp)
  801626:	e8 a6 fd ff ff       	call   8013d1 <fd2data>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801630:	89 d8                	mov    %ebx,%eax
  801632:	c1 e8 16             	shr    $0x16,%eax
  801635:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163c:	a8 01                	test   $0x1,%al
  80163e:	74 11                	je     801651 <dup+0x78>
  801640:	89 d8                	mov    %ebx,%eax
  801642:	c1 e8 0c             	shr    $0xc,%eax
  801645:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164c:	f6 c2 01             	test   $0x1,%dl
  80164f:	75 39                	jne    80168a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801654:	89 d0                	mov    %edx,%eax
  801656:	c1 e8 0c             	shr    $0xc,%eax
  801659:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	25 07 0e 00 00       	and    $0xe07,%eax
  801668:	50                   	push   %eax
  801669:	56                   	push   %esi
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	6a 00                	push   $0x0
  80166f:	e8 63 f6 ff ff       	call   800cd7 <sys_page_map>
  801674:	89 c3                	mov    %eax,%ebx
  801676:	83 c4 20             	add    $0x20,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 31                	js     8016ae <dup+0xd5>
		goto err;

	return newfdnum;
  80167d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801680:	89 d8                	mov    %ebx,%eax
  801682:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5f                   	pop    %edi
  801688:	5d                   	pop    %ebp
  801689:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80168a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	25 07 0e 00 00       	and    $0xe07,%eax
  801699:	50                   	push   %eax
  80169a:	57                   	push   %edi
  80169b:	6a 00                	push   $0x0
  80169d:	53                   	push   %ebx
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 32 f6 ff ff       	call   800cd7 <sys_page_map>
  8016a5:	89 c3                	mov    %eax,%ebx
  8016a7:	83 c4 20             	add    $0x20,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	79 a3                	jns    801651 <dup+0x78>
	sys_page_unmap(0, newfd);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	56                   	push   %esi
  8016b2:	6a 00                	push   $0x0
  8016b4:	e8 48 f6 ff ff       	call   800d01 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	57                   	push   %edi
  8016bd:	6a 00                	push   $0x0
  8016bf:	e8 3d f6 ff ff       	call   800d01 <sys_page_unmap>
	return r;
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	eb b7                	jmp    801680 <dup+0xa7>

008016c9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016c9:	f3 0f 1e fb          	endbr32 
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 1c             	sub    $0x1c,%esp
  8016d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016da:	50                   	push   %eax
  8016db:	53                   	push   %ebx
  8016dc:	e8 65 fd ff ff       	call   801446 <fd_lookup>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 3f                	js     801727 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ee:	50                   	push   %eax
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	ff 30                	pushl  (%eax)
  8016f4:	e8 a1 fd ff ff       	call   80149a <dev_lookup>
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 27                	js     801727 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801700:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801703:	8b 42 08             	mov    0x8(%edx),%eax
  801706:	83 e0 03             	and    $0x3,%eax
  801709:	83 f8 01             	cmp    $0x1,%eax
  80170c:	74 1e                	je     80172c <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	8b 40 08             	mov    0x8(%eax),%eax
  801714:	85 c0                	test   %eax,%eax
  801716:	74 35                	je     80174d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	ff 75 10             	pushl  0x10(%ebp)
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	52                   	push   %edx
  801722:	ff d0                	call   *%eax
  801724:	83 c4 10             	add    $0x10,%esp
}
  801727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80172c:	a1 04 40 80 00       	mov    0x804004,%eax
  801731:	8b 40 48             	mov    0x48(%eax),%eax
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	53                   	push   %ebx
  801738:	50                   	push   %eax
  801739:	68 d9 2a 80 00       	push   $0x802ad9
  80173e:	e8 7a eb ff ff       	call   8002bd <cprintf>
		return -E_INVAL;
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174b:	eb da                	jmp    801727 <read+0x5e>
		return -E_NOT_SUPP;
  80174d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801752:	eb d3                	jmp    801727 <read+0x5e>

00801754 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 0c             	sub    $0xc,%esp
  801761:	8b 7d 08             	mov    0x8(%ebp),%edi
  801764:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801767:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176c:	eb 02                	jmp    801770 <readn+0x1c>
  80176e:	01 c3                	add    %eax,%ebx
  801770:	39 f3                	cmp    %esi,%ebx
  801772:	73 21                	jae    801795 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	89 f0                	mov    %esi,%eax
  801779:	29 d8                	sub    %ebx,%eax
  80177b:	50                   	push   %eax
  80177c:	89 d8                	mov    %ebx,%eax
  80177e:	03 45 0c             	add    0xc(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	57                   	push   %edi
  801783:	e8 41 ff ff ff       	call   8016c9 <read>
		if (m < 0)
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 04                	js     801793 <readn+0x3f>
			return m;
		if (m == 0)
  80178f:	75 dd                	jne    80176e <readn+0x1a>
  801791:	eb 02                	jmp    801795 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801793:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801795:	89 d8                	mov    %ebx,%eax
  801797:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    

0080179f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80179f:	f3 0f 1e fb          	endbr32 
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 1c             	sub    $0x1c,%esp
  8017aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b0:	50                   	push   %eax
  8017b1:	53                   	push   %ebx
  8017b2:	e8 8f fc ff ff       	call   801446 <fd_lookup>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 3a                	js     8017f8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017be:	83 ec 08             	sub    $0x8,%esp
  8017c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c4:	50                   	push   %eax
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	ff 30                	pushl  (%eax)
  8017ca:	e8 cb fc ff ff       	call   80149a <dev_lookup>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 22                	js     8017f8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017dd:	74 1e                	je     8017fd <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8017e5:	85 d2                	test   %edx,%edx
  8017e7:	74 35                	je     80181e <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	50                   	push   %eax
  8017f3:	ff d2                	call   *%edx
  8017f5:	83 c4 10             	add    $0x10,%esp
}
  8017f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fd:	a1 04 40 80 00       	mov    0x804004,%eax
  801802:	8b 40 48             	mov    0x48(%eax),%eax
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	53                   	push   %ebx
  801809:	50                   	push   %eax
  80180a:	68 f5 2a 80 00       	push   $0x802af5
  80180f:	e8 a9 ea ff ff       	call   8002bd <cprintf>
		return -E_INVAL;
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181c:	eb da                	jmp    8017f8 <write+0x59>
		return -E_NOT_SUPP;
  80181e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801823:	eb d3                	jmp    8017f8 <write+0x59>

00801825 <seek>:

int
seek(int fdnum, off_t offset)
{
  801825:	f3 0f 1e fb          	endbr32 
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801832:	50                   	push   %eax
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	e8 0b fc ff ff       	call   801446 <fd_lookup>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 0e                	js     801850 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801860:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801863:	50                   	push   %eax
  801864:	53                   	push   %ebx
  801865:	e8 dc fb ff ff       	call   801446 <fd_lookup>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 37                	js     8018a8 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801877:	50                   	push   %eax
  801878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187b:	ff 30                	pushl  (%eax)
  80187d:	e8 18 fc ff ff       	call   80149a <dev_lookup>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 c0                	test   %eax,%eax
  801887:	78 1f                	js     8018a8 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801890:	74 1b                	je     8018ad <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	8b 52 18             	mov    0x18(%edx),%edx
  801898:	85 d2                	test   %edx,%edx
  80189a:	74 32                	je     8018ce <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	50                   	push   %eax
  8018a3:	ff d2                	call   *%edx
  8018a5:	83 c4 10             	add    $0x10,%esp
}
  8018a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018ad:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b2:	8b 40 48             	mov    0x48(%eax),%eax
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	53                   	push   %ebx
  8018b9:	50                   	push   %eax
  8018ba:	68 b8 2a 80 00       	push   $0x802ab8
  8018bf:	e8 f9 e9 ff ff       	call   8002bd <cprintf>
		return -E_INVAL;
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cc:	eb da                	jmp    8018a8 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d3:	eb d3                	jmp    8018a8 <ftruncate+0x56>

008018d5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d5:	f3 0f 1e fb          	endbr32 
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 1c             	sub    $0x1c,%esp
  8018e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	e8 57 fb ff ff       	call   801446 <fd_lookup>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 4b                	js     801941 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fc:	50                   	push   %eax
  8018fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801900:	ff 30                	pushl  (%eax)
  801902:	e8 93 fb ff ff       	call   80149a <dev_lookup>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 33                	js     801941 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801915:	74 2f                	je     801946 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801917:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80191a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801921:	00 00 00 
	stat->st_isdir = 0;
  801924:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192b:	00 00 00 
	stat->st_dev = dev;
  80192e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	53                   	push   %ebx
  801938:	ff 75 f0             	pushl  -0x10(%ebp)
  80193b:	ff 50 14             	call   *0x14(%eax)
  80193e:	83 c4 10             	add    $0x10,%esp
}
  801941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801944:	c9                   	leave  
  801945:	c3                   	ret    
		return -E_NOT_SUPP;
  801946:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194b:	eb f4                	jmp    801941 <fstat+0x6c>

0080194d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80194d:	f3 0f 1e fb          	endbr32 
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	6a 00                	push   $0x0
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	e8 3a 02 00 00       	call   801b9d <open>
  801963:	89 c3                	mov    %eax,%ebx
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 1b                	js     801987 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80196c:	83 ec 08             	sub    $0x8,%esp
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	50                   	push   %eax
  801973:	e8 5d ff ff ff       	call   8018d5 <fstat>
  801978:	89 c6                	mov    %eax,%esi
	close(fd);
  80197a:	89 1c 24             	mov    %ebx,(%esp)
  80197d:	e8 fd fb ff ff       	call   80157f <close>
	return r;
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	89 f3                	mov    %esi,%ebx
}
  801987:	89 d8                	mov    %ebx,%eax
  801989:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198c:	5b                   	pop    %ebx
  80198d:	5e                   	pop    %esi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	56                   	push   %esi
  801994:	53                   	push   %ebx
  801995:	89 c6                	mov    %eax,%esi
  801997:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801999:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019a0:	74 27                	je     8019c9 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019a2:	6a 07                	push   $0x7
  8019a4:	68 00 50 80 00       	push   $0x805000
  8019a9:	56                   	push   %esi
  8019aa:	ff 35 00 40 80 00    	pushl  0x804000
  8019b0:	e8 73 f9 ff ff       	call   801328 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019b5:	83 c4 0c             	add    $0xc,%esp
  8019b8:	6a 00                	push   $0x0
  8019ba:	53                   	push   %ebx
  8019bb:	6a 00                	push   $0x0
  8019bd:	e8 f9 f8 ff ff       	call   8012bb <ipc_recv>
}
  8019c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	6a 01                	push   $0x1
  8019ce:	e8 ad f9 ff ff       	call   801380 <ipc_find_env>
  8019d3:	a3 00 40 80 00       	mov    %eax,0x804000
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	eb c5                	jmp    8019a2 <fsipc+0x12>

008019dd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019dd:	f3 0f 1e fb          	endbr32 
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801a04:	e8 87 ff ff ff       	call   801990 <fsipc>
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <devfile_flush>:
{
  801a0b:	f3 0f 1e fb          	endbr32 
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a20:	ba 00 00 00 00       	mov    $0x0,%edx
  801a25:	b8 06 00 00 00       	mov    $0x6,%eax
  801a2a:	e8 61 ff ff ff       	call   801990 <fsipc>
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <devfile_stat>:
{
  801a31:	f3 0f 1e fb          	endbr32 
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	53                   	push   %ebx
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8b 40 0c             	mov    0xc(%eax),%eax
  801a45:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a54:	e8 37 ff ff ff       	call   801990 <fsipc>
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	78 2c                	js     801a89 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	68 00 50 80 00       	push   $0x805000
  801a65:	53                   	push   %ebx
  801a66:	e8 bc ed ff ff       	call   800827 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a6b:	a1 80 50 80 00       	mov    0x805080,%eax
  801a70:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a76:	a1 84 50 80 00       	mov    0x805084,%eax
  801a7b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <devfile_write>:
{
  801a8e:	f3 0f 1e fb          	endbr32 
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	53                   	push   %ebx
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801aa7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801aad:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801ab3:	77 30                	ja     801ae5 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	53                   	push   %ebx
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	68 08 50 80 00       	push   $0x805008
  801ac1:	e8 19 ef ff ff       	call   8009df <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ac6:	ba 00 00 00 00       	mov    $0x0,%edx
  801acb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad0:	e8 bb fe ff ff       	call   801990 <fsipc>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 04                	js     801ae0 <devfile_write+0x52>
	assert(r <= n);
  801adc:	39 d8                	cmp    %ebx,%eax
  801ade:	77 1e                	ja     801afe <devfile_write+0x70>
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801ae5:	68 24 2b 80 00       	push   $0x802b24
  801aea:	68 51 2b 80 00       	push   $0x802b51
  801aef:	68 94 00 00 00       	push   $0x94
  801af4:	68 66 2b 80 00       	push   $0x802b66
  801af9:	e8 47 06 00 00       	call   802145 <_panic>
	assert(r <= n);
  801afe:	68 71 2b 80 00       	push   $0x802b71
  801b03:	68 51 2b 80 00       	push   $0x802b51
  801b08:	68 98 00 00 00       	push   $0x98
  801b0d:	68 66 2b 80 00       	push   $0x802b66
  801b12:	e8 2e 06 00 00       	call   802145 <_panic>

00801b17 <devfile_read>:
{
  801b17:	f3 0f 1e fb          	endbr32 
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8b 40 0c             	mov    0xc(%eax),%eax
  801b29:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b2e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b34:	ba 00 00 00 00       	mov    $0x0,%edx
  801b39:	b8 03 00 00 00       	mov    $0x3,%eax
  801b3e:	e8 4d fe ff ff       	call   801990 <fsipc>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 1f                	js     801b68 <devfile_read+0x51>
	assert(r <= n);
  801b49:	39 f0                	cmp    %esi,%eax
  801b4b:	77 24                	ja     801b71 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b4d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b52:	7f 33                	jg     801b87 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	50                   	push   %eax
  801b58:	68 00 50 80 00       	push   $0x805000
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	e8 7a ee ff ff       	call   8009df <memmove>
	return r;
  801b65:	83 c4 10             	add    $0x10,%esp
}
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    
	assert(r <= n);
  801b71:	68 71 2b 80 00       	push   $0x802b71
  801b76:	68 51 2b 80 00       	push   $0x802b51
  801b7b:	6a 7c                	push   $0x7c
  801b7d:	68 66 2b 80 00       	push   $0x802b66
  801b82:	e8 be 05 00 00       	call   802145 <_panic>
	assert(r <= PGSIZE);
  801b87:	68 78 2b 80 00       	push   $0x802b78
  801b8c:	68 51 2b 80 00       	push   $0x802b51
  801b91:	6a 7d                	push   $0x7d
  801b93:	68 66 2b 80 00       	push   $0x802b66
  801b98:	e8 a8 05 00 00       	call   802145 <_panic>

00801b9d <open>:
{
  801b9d:	f3 0f 1e fb          	endbr32 
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 1c             	sub    $0x1c,%esp
  801ba9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bac:	56                   	push   %esi
  801bad:	e8 32 ec ff ff       	call   8007e4 <strlen>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bba:	7f 6c                	jg     801c28 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801bbc:	83 ec 0c             	sub    $0xc,%esp
  801bbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc2:	50                   	push   %eax
  801bc3:	e8 28 f8 ff ff       	call   8013f0 <fd_alloc>
  801bc8:	89 c3                	mov    %eax,%ebx
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 3c                	js     801c0d <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	56                   	push   %esi
  801bd5:	68 00 50 80 00       	push   $0x805000
  801bda:	e8 48 ec ff ff       	call   800827 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	e8 9c fd ff ff       	call   801990 <fsipc>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 19                	js     801c16 <open+0x79>
	return fd2num(fd);
  801bfd:	83 ec 0c             	sub    $0xc,%esp
  801c00:	ff 75 f4             	pushl  -0xc(%ebp)
  801c03:	e8 b5 f7 ff ff       	call   8013bd <fd2num>
  801c08:	89 c3                	mov    %eax,%ebx
  801c0a:	83 c4 10             	add    $0x10,%esp
}
  801c0d:	89 d8                	mov    %ebx,%eax
  801c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    
		fd_close(fd, 0);
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1e:	e8 d1 f8 ff ff       	call   8014f4 <fd_close>
		return r;
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	eb e5                	jmp    801c0d <open+0x70>
		return -E_BAD_PATH;
  801c28:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c2d:	eb de                	jmp    801c0d <open+0x70>

00801c2f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c2f:	f3 0f 1e fb          	endbr32 
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c39:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c43:	e8 48 fd ff ff       	call   801990 <fsipc>
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c4a:	f3 0f 1e fb          	endbr32 
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	e8 70 f7 ff ff       	call   8013d1 <fd2data>
  801c61:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c63:	83 c4 08             	add    $0x8,%esp
  801c66:	68 84 2b 80 00       	push   $0x802b84
  801c6b:	53                   	push   %ebx
  801c6c:	e8 b6 eb ff ff       	call   800827 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c71:	8b 46 04             	mov    0x4(%esi),%eax
  801c74:	2b 06                	sub    (%esi),%eax
  801c76:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c83:	00 00 00 
	stat->st_dev = &devpipe;
  801c86:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801c8d:	30 80 00 
	return 0;
}
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    

00801c9c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9c:	f3 0f 1e fb          	endbr32 
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801caa:	53                   	push   %ebx
  801cab:	6a 00                	push   $0x0
  801cad:	e8 4f f0 ff ff       	call   800d01 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb2:	89 1c 24             	mov    %ebx,(%esp)
  801cb5:	e8 17 f7 ff ff       	call   8013d1 <fd2data>
  801cba:	83 c4 08             	add    $0x8,%esp
  801cbd:	50                   	push   %eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	e8 3c f0 ff ff       	call   800d01 <sys_page_unmap>
}
  801cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <_pipeisclosed>:
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 1c             	sub    $0x1c,%esp
  801cd3:	89 c7                	mov    %eax,%edi
  801cd5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd7:	a1 04 40 80 00       	mov    0x804004,%eax
  801cdc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	57                   	push   %edi
  801ce3:	e8 4a 05 00 00       	call   802232 <pageref>
  801ce8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ceb:	89 34 24             	mov    %esi,(%esp)
  801cee:	e8 3f 05 00 00       	call   802232 <pageref>
		nn = thisenv->env_runs;
  801cf3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cf9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	39 cb                	cmp    %ecx,%ebx
  801d01:	74 1b                	je     801d1e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d03:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d06:	75 cf                	jne    801cd7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d08:	8b 42 58             	mov    0x58(%edx),%eax
  801d0b:	6a 01                	push   $0x1
  801d0d:	50                   	push   %eax
  801d0e:	53                   	push   %ebx
  801d0f:	68 8b 2b 80 00       	push   $0x802b8b
  801d14:	e8 a4 e5 ff ff       	call   8002bd <cprintf>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	eb b9                	jmp    801cd7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d1e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d21:	0f 94 c0             	sete   %al
  801d24:	0f b6 c0             	movzbl %al,%eax
}
  801d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2a:	5b                   	pop    %ebx
  801d2b:	5e                   	pop    %esi
  801d2c:	5f                   	pop    %edi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <devpipe_write>:
{
  801d2f:	f3 0f 1e fb          	endbr32 
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 28             	sub    $0x28,%esp
  801d3c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d3f:	56                   	push   %esi
  801d40:	e8 8c f6 ff ff       	call   8013d1 <fd2data>
  801d45:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d52:	74 4f                	je     801da3 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d54:	8b 43 04             	mov    0x4(%ebx),%eax
  801d57:	8b 0b                	mov    (%ebx),%ecx
  801d59:	8d 51 20             	lea    0x20(%ecx),%edx
  801d5c:	39 d0                	cmp    %edx,%eax
  801d5e:	72 14                	jb     801d74 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d60:	89 da                	mov    %ebx,%edx
  801d62:	89 f0                	mov    %esi,%eax
  801d64:	e8 61 ff ff ff       	call   801cca <_pipeisclosed>
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	75 3b                	jne    801da8 <devpipe_write+0x79>
			sys_yield();
  801d6d:	e8 12 ef ff ff       	call   800c84 <sys_yield>
  801d72:	eb e0                	jmp    801d54 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d77:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d7b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d7e:	89 c2                	mov    %eax,%edx
  801d80:	c1 fa 1f             	sar    $0x1f,%edx
  801d83:	89 d1                	mov    %edx,%ecx
  801d85:	c1 e9 1b             	shr    $0x1b,%ecx
  801d88:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d8b:	83 e2 1f             	and    $0x1f,%edx
  801d8e:	29 ca                	sub    %ecx,%edx
  801d90:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d94:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d98:	83 c0 01             	add    $0x1,%eax
  801d9b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d9e:	83 c7 01             	add    $0x1,%edi
  801da1:	eb ac                	jmp    801d4f <devpipe_write+0x20>
	return i;
  801da3:	8b 45 10             	mov    0x10(%ebp),%eax
  801da6:	eb 05                	jmp    801dad <devpipe_write+0x7e>
				return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    

00801db5 <devpipe_read>:
{
  801db5:	f3 0f 1e fb          	endbr32 
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	57                   	push   %edi
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 18             	sub    $0x18,%esp
  801dc2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dc5:	57                   	push   %edi
  801dc6:	e8 06 f6 ff ff       	call   8013d1 <fd2data>
  801dcb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	be 00 00 00 00       	mov    $0x0,%esi
  801dd5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dd8:	75 14                	jne    801dee <devpipe_read+0x39>
	return i;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	eb 02                	jmp    801de1 <devpipe_read+0x2c>
				return i;
  801ddf:	89 f0                	mov    %esi,%eax
}
  801de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
			sys_yield();
  801de9:	e8 96 ee ff ff       	call   800c84 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dee:	8b 03                	mov    (%ebx),%eax
  801df0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801df3:	75 18                	jne    801e0d <devpipe_read+0x58>
			if (i > 0)
  801df5:	85 f6                	test   %esi,%esi
  801df7:	75 e6                	jne    801ddf <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801df9:	89 da                	mov    %ebx,%edx
  801dfb:	89 f8                	mov    %edi,%eax
  801dfd:	e8 c8 fe ff ff       	call   801cca <_pipeisclosed>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	74 e3                	je     801de9 <devpipe_read+0x34>
				return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	eb d4                	jmp    801de1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e0d:	99                   	cltd   
  801e0e:	c1 ea 1b             	shr    $0x1b,%edx
  801e11:	01 d0                	add    %edx,%eax
  801e13:	83 e0 1f             	and    $0x1f,%eax
  801e16:	29 d0                	sub    %edx,%eax
  801e18:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e20:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e23:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e26:	83 c6 01             	add    $0x1,%esi
  801e29:	eb aa                	jmp    801dd5 <devpipe_read+0x20>

00801e2b <pipe>:
{
  801e2b:	f3 0f 1e fb          	endbr32 
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3a:	50                   	push   %eax
  801e3b:	e8 b0 f5 ff ff       	call   8013f0 <fd_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	0f 88 23 01 00 00    	js     801f70 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	68 07 04 00 00       	push   $0x407
  801e55:	ff 75 f4             	pushl  -0xc(%ebp)
  801e58:	6a 00                	push   $0x0
  801e5a:	e8 50 ee ff ff       	call   800caf <sys_page_alloc>
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	0f 88 04 01 00 00    	js     801f70 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e72:	50                   	push   %eax
  801e73:	e8 78 f5 ff ff       	call   8013f0 <fd_alloc>
  801e78:	89 c3                	mov    %eax,%ebx
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	0f 88 db 00 00 00    	js     801f60 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	68 07 04 00 00       	push   $0x407
  801e8d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e90:	6a 00                	push   $0x0
  801e92:	e8 18 ee ff ff       	call   800caf <sys_page_alloc>
  801e97:	89 c3                	mov    %eax,%ebx
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	0f 88 bc 00 00 00    	js     801f60 <pipe+0x135>
	va = fd2data(fd0);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaa:	e8 22 f5 ff ff       	call   8013d1 <fd2data>
  801eaf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb1:	83 c4 0c             	add    $0xc,%esp
  801eb4:	68 07 04 00 00       	push   $0x407
  801eb9:	50                   	push   %eax
  801eba:	6a 00                	push   $0x0
  801ebc:	e8 ee ed ff ff       	call   800caf <sys_page_alloc>
  801ec1:	89 c3                	mov    %eax,%ebx
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	0f 88 82 00 00 00    	js     801f50 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ece:	83 ec 0c             	sub    $0xc,%esp
  801ed1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed4:	e8 f8 f4 ff ff       	call   8013d1 <fd2data>
  801ed9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ee0:	50                   	push   %eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	56                   	push   %esi
  801ee4:	6a 00                	push   $0x0
  801ee6:	e8 ec ed ff ff       	call   800cd7 <sys_page_map>
  801eeb:	89 c3                	mov    %eax,%ebx
  801eed:	83 c4 20             	add    $0x20,%esp
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	78 4e                	js     801f42 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ef4:	a1 28 30 80 00       	mov    0x803028,%eax
  801ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f10:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f17:	83 ec 0c             	sub    $0xc,%esp
  801f1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1d:	e8 9b f4 ff ff       	call   8013bd <fd2num>
  801f22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f25:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f27:	83 c4 04             	add    $0x4,%esp
  801f2a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2d:	e8 8b f4 ff ff       	call   8013bd <fd2num>
  801f32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f35:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f40:	eb 2e                	jmp    801f70 <pipe+0x145>
	sys_page_unmap(0, va);
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	56                   	push   %esi
  801f46:	6a 00                	push   $0x0
  801f48:	e8 b4 ed ff ff       	call   800d01 <sys_page_unmap>
  801f4d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	ff 75 f0             	pushl  -0x10(%ebp)
  801f56:	6a 00                	push   $0x0
  801f58:	e8 a4 ed ff ff       	call   800d01 <sys_page_unmap>
  801f5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f60:	83 ec 08             	sub    $0x8,%esp
  801f63:	ff 75 f4             	pushl  -0xc(%ebp)
  801f66:	6a 00                	push   $0x0
  801f68:	e8 94 ed ff ff       	call   800d01 <sys_page_unmap>
  801f6d:	83 c4 10             	add    $0x10,%esp
}
  801f70:	89 d8                	mov    %ebx,%eax
  801f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <pipeisclosed>:
{
  801f79:	f3 0f 1e fb          	endbr32 
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f86:	50                   	push   %eax
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 b7 f4 ff ff       	call   801446 <fd_lookup>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 18                	js     801fae <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9c:	e8 30 f4 ff ff       	call   8013d1 <fd2data>
  801fa1:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	e8 1f fd ff ff       	call   801cca <_pipeisclosed>
  801fab:	83 c4 10             	add    $0x10,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fb0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	c3                   	ret    

00801fba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fba:	f3 0f 1e fb          	endbr32 
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc4:	68 a3 2b 80 00       	push   $0x802ba3
  801fc9:	ff 75 0c             	pushl  0xc(%ebp)
  801fcc:	e8 56 e8 ff ff       	call   800827 <strcpy>
	return 0;
}
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <devcons_write>:
{
  801fd8:	f3 0f 1e fb          	endbr32 
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ff3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff6:	73 31                	jae    802029 <devcons_write+0x51>
		m = n - tot;
  801ff8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ffb:	29 f3                	sub    %esi,%ebx
  801ffd:	83 fb 7f             	cmp    $0x7f,%ebx
  802000:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802005:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	53                   	push   %ebx
  80200c:	89 f0                	mov    %esi,%eax
  80200e:	03 45 0c             	add    0xc(%ebp),%eax
  802011:	50                   	push   %eax
  802012:	57                   	push   %edi
  802013:	e8 c7 e9 ff ff       	call   8009df <memmove>
		sys_cputs(buf, m);
  802018:	83 c4 08             	add    $0x8,%esp
  80201b:	53                   	push   %ebx
  80201c:	57                   	push   %edi
  80201d:	e8 c2 eb ff ff       	call   800be4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802022:	01 de                	add    %ebx,%esi
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	eb ca                	jmp    801ff3 <devcons_write+0x1b>
}
  802029:	89 f0                	mov    %esi,%eax
  80202b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    

00802033 <devcons_read>:
{
  802033:	f3 0f 1e fb          	endbr32 
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 08             	sub    $0x8,%esp
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802046:	74 21                	je     802069 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802048:	e8 c1 eb ff ff       	call   800c0e <sys_cgetc>
  80204d:	85 c0                	test   %eax,%eax
  80204f:	75 07                	jne    802058 <devcons_read+0x25>
		sys_yield();
  802051:	e8 2e ec ff ff       	call   800c84 <sys_yield>
  802056:	eb f0                	jmp    802048 <devcons_read+0x15>
	if (c < 0)
  802058:	78 0f                	js     802069 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80205a:	83 f8 04             	cmp    $0x4,%eax
  80205d:	74 0c                	je     80206b <devcons_read+0x38>
	*(char*)vbuf = c;
  80205f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802062:	88 02                	mov    %al,(%edx)
	return 1;
  802064:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    
		return 0;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	eb f7                	jmp    802069 <devcons_read+0x36>

00802072 <cputchar>:
{
  802072:	f3 0f 1e fb          	endbr32 
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802082:	6a 01                	push   $0x1
  802084:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802087:	50                   	push   %eax
  802088:	e8 57 eb ff ff       	call   800be4 <sys_cputs>
}
  80208d:	83 c4 10             	add    $0x10,%esp
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <getchar>:
{
  802092:	f3 0f 1e fb          	endbr32 
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80209c:	6a 01                	push   $0x1
  80209e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	e8 20 f6 ff ff       	call   8016c9 <read>
	if (r < 0)
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	78 06                	js     8020b6 <getchar+0x24>
	if (r < 1)
  8020b0:	74 06                	je     8020b8 <getchar+0x26>
	return c;
  8020b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    
		return -E_EOF;
  8020b8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020bd:	eb f7                	jmp    8020b6 <getchar+0x24>

008020bf <iscons>:
{
  8020bf:	f3 0f 1e fb          	endbr32 
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 71 f3 ff ff       	call   801446 <fd_lookup>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 11                	js     8020ed <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 15 44 30 80 00    	mov    0x803044,%edx
  8020e5:	39 10                	cmp    %edx,(%eax)
  8020e7:	0f 94 c0             	sete   %al
  8020ea:	0f b6 c0             	movzbl %al,%eax
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <opencons>:
{
  8020ef:	f3 0f 1e fb          	endbr32 
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fc:	50                   	push   %eax
  8020fd:	e8 ee f2 ff ff       	call   8013f0 <fd_alloc>
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	85 c0                	test   %eax,%eax
  802107:	78 3a                	js     802143 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 07 04 00 00       	push   $0x407
  802111:	ff 75 f4             	pushl  -0xc(%ebp)
  802114:	6a 00                	push   $0x0
  802116:	e8 94 eb ff ff       	call   800caf <sys_page_alloc>
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 21                	js     802143 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 15 44 30 80 00    	mov    0x803044,%edx
  80212b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	50                   	push   %eax
  80213b:	e8 7d f2 ff ff       	call   8013bd <fd2num>
  802140:	83 c4 10             	add    $0x10,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802145:	f3 0f 1e fb          	endbr32 
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80214e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802151:	8b 35 08 30 80 00    	mov    0x803008,%esi
  802157:	e8 00 eb ff ff       	call   800c5c <sys_getenvid>
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	56                   	push   %esi
  802166:	50                   	push   %eax
  802167:	68 b0 2b 80 00       	push   $0x802bb0
  80216c:	e8 4c e1 ff ff       	call   8002bd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802171:	83 c4 18             	add    $0x18,%esp
  802174:	53                   	push   %ebx
  802175:	ff 75 10             	pushl  0x10(%ebp)
  802178:	e8 eb e0 ff ff       	call   800268 <vcprintf>
	cprintf("\n");
  80217d:	c7 04 24 89 2a 80 00 	movl   $0x802a89,(%esp)
  802184:	e8 34 e1 ff ff       	call   8002bd <cprintf>
  802189:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80218c:	cc                   	int3   
  80218d:	eb fd                	jmp    80218c <_panic+0x47>

0080218f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80218f:	f3 0f 1e fb          	endbr32 
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802199:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8021a0:	74 0a                	je     8021ac <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  8021ac:	a1 04 40 80 00       	mov    0x804004,%eax
  8021b1:	8b 40 48             	mov    0x48(%eax),%eax
  8021b4:	83 ec 04             	sub    $0x4,%esp
  8021b7:	6a 07                	push   $0x7
  8021b9:	68 00 f0 bf ee       	push   $0xeebff000
  8021be:	50                   	push   %eax
  8021bf:	e8 eb ea ff ff       	call   800caf <sys_page_alloc>
		if (r!= 0)
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	75 2f                	jne    8021fa <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8021cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8021d0:	8b 40 48             	mov    0x48(%eax),%eax
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	68 0c 22 80 00       	push   $0x80220c
  8021db:	50                   	push   %eax
  8021dc:	e8 95 eb ff ff       	call   800d76 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 ba                	je     8021a2 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  8021e8:	50                   	push   %eax
  8021e9:	68 d3 2b 80 00       	push   $0x802bd3
  8021ee:	6a 26                	push   $0x26
  8021f0:	68 eb 2b 80 00       	push   $0x802beb
  8021f5:	e8 4b ff ff ff       	call   802145 <_panic>
			panic("set_pgfault_handler: %e", r);
  8021fa:	50                   	push   %eax
  8021fb:	68 d3 2b 80 00       	push   $0x802bd3
  802200:	6a 22                	push   $0x22
  802202:	68 eb 2b 80 00       	push   $0x802beb
  802207:	e8 39 ff ff ff       	call   802145 <_panic>

0080220c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80220c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80220d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802212:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802214:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  802217:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80221b:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  80221e:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802222:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802226:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802228:	83 c4 08             	add    $0x8,%esp
	popal
  80222b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80222c:	83 c4 04             	add    $0x4,%esp
	popfl
  80222f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802230:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802231:	c3                   	ret    

00802232 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802232:	f3 0f 1e fb          	endbr32 
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80223c:	89 c2                	mov    %eax,%edx
  80223e:	c1 ea 16             	shr    $0x16,%edx
  802241:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802248:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80224d:	f6 c1 01             	test   $0x1,%cl
  802250:	74 1c                	je     80226e <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802252:	c1 e8 0c             	shr    $0xc,%eax
  802255:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80225c:	a8 01                	test   $0x1,%al
  80225e:	74 0e                	je     80226e <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802260:	c1 e8 0c             	shr    $0xc,%eax
  802263:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80226a:	ef 
  80226b:	0f b7 d2             	movzwl %dx,%edx
}
  80226e:	89 d0                	mov    %edx,%eax
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
  802272:	66 90                	xchg   %ax,%ax
  802274:	66 90                	xchg   %ax,%ax
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__udivdi3>:
  802280:	f3 0f 1e fb          	endbr32 
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80228f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802293:	8b 74 24 34          	mov    0x34(%esp),%esi
  802297:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80229b:	85 d2                	test   %edx,%edx
  80229d:	75 19                	jne    8022b8 <__udivdi3+0x38>
  80229f:	39 f3                	cmp    %esi,%ebx
  8022a1:	76 4d                	jbe    8022f0 <__udivdi3+0x70>
  8022a3:	31 ff                	xor    %edi,%edi
  8022a5:	89 e8                	mov    %ebp,%eax
  8022a7:	89 f2                	mov    %esi,%edx
  8022a9:	f7 f3                	div    %ebx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	39 f2                	cmp    %esi,%edx
  8022ba:	76 14                	jbe    8022d0 <__udivdi3+0x50>
  8022bc:	31 ff                	xor    %edi,%edi
  8022be:	31 c0                	xor    %eax,%eax
  8022c0:	89 fa                	mov    %edi,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d0:	0f bd fa             	bsr    %edx,%edi
  8022d3:	83 f7 1f             	xor    $0x1f,%edi
  8022d6:	75 48                	jne    802320 <__udivdi3+0xa0>
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	72 06                	jb     8022e2 <__udivdi3+0x62>
  8022dc:	31 c0                	xor    %eax,%eax
  8022de:	39 eb                	cmp    %ebp,%ebx
  8022e0:	77 de                	ja     8022c0 <__udivdi3+0x40>
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e7:	eb d7                	jmp    8022c0 <__udivdi3+0x40>
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	89 d9                	mov    %ebx,%ecx
  8022f2:	85 db                	test   %ebx,%ebx
  8022f4:	75 0b                	jne    802301 <__udivdi3+0x81>
  8022f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f3                	div    %ebx
  8022ff:	89 c1                	mov    %eax,%ecx
  802301:	31 d2                	xor    %edx,%edx
  802303:	89 f0                	mov    %esi,%eax
  802305:	f7 f1                	div    %ecx
  802307:	89 c6                	mov    %eax,%esi
  802309:	89 e8                	mov    %ebp,%eax
  80230b:	89 f7                	mov    %esi,%edi
  80230d:	f7 f1                	div    %ecx
  80230f:	89 fa                	mov    %edi,%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	89 f9                	mov    %edi,%ecx
  802322:	b8 20 00 00 00       	mov    $0x20,%eax
  802327:	29 f8                	sub    %edi,%eax
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	89 da                	mov    %ebx,%edx
  802333:	d3 ea                	shr    %cl,%edx
  802335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802339:	09 d1                	or     %edx,%ecx
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 f9                	mov    %edi,%ecx
  802343:	d3 e3                	shl    %cl,%ebx
  802345:	89 c1                	mov    %eax,%ecx
  802347:	d3 ea                	shr    %cl,%edx
  802349:	89 f9                	mov    %edi,%ecx
  80234b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80234f:	89 eb                	mov    %ebp,%ebx
  802351:	d3 e6                	shl    %cl,%esi
  802353:	89 c1                	mov    %eax,%ecx
  802355:	d3 eb                	shr    %cl,%ebx
  802357:	09 de                	or     %ebx,%esi
  802359:	89 f0                	mov    %esi,%eax
  80235b:	f7 74 24 08          	divl   0x8(%esp)
  80235f:	89 d6                	mov    %edx,%esi
  802361:	89 c3                	mov    %eax,%ebx
  802363:	f7 64 24 0c          	mull   0xc(%esp)
  802367:	39 d6                	cmp    %edx,%esi
  802369:	72 15                	jb     802380 <__udivdi3+0x100>
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e5                	shl    %cl,%ebp
  80236f:	39 c5                	cmp    %eax,%ebp
  802371:	73 04                	jae    802377 <__udivdi3+0xf7>
  802373:	39 d6                	cmp    %edx,%esi
  802375:	74 09                	je     802380 <__udivdi3+0x100>
  802377:	89 d8                	mov    %ebx,%eax
  802379:	31 ff                	xor    %edi,%edi
  80237b:	e9 40 ff ff ff       	jmp    8022c0 <__udivdi3+0x40>
  802380:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802383:	31 ff                	xor    %edi,%edi
  802385:	e9 36 ff ff ff       	jmp    8022c0 <__udivdi3+0x40>
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <__umoddi3>:
  802390:	f3 0f 1e fb          	endbr32 
  802394:	55                   	push   %ebp
  802395:	57                   	push   %edi
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	83 ec 1c             	sub    $0x1c,%esp
  80239b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80239f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	75 19                	jne    8023c8 <__umoddi3+0x38>
  8023af:	39 df                	cmp    %ebx,%edi
  8023b1:	76 5d                	jbe    802410 <__umoddi3+0x80>
  8023b3:	89 f0                	mov    %esi,%eax
  8023b5:	89 da                	mov    %ebx,%edx
  8023b7:	f7 f7                	div    %edi
  8023b9:	89 d0                	mov    %edx,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	83 c4 1c             	add    $0x1c,%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	89 f2                	mov    %esi,%edx
  8023ca:	39 d8                	cmp    %ebx,%eax
  8023cc:	76 12                	jbe    8023e0 <__umoddi3+0x50>
  8023ce:	89 f0                	mov    %esi,%eax
  8023d0:	89 da                	mov    %ebx,%edx
  8023d2:	83 c4 1c             	add    $0x1c,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023e0:	0f bd e8             	bsr    %eax,%ebp
  8023e3:	83 f5 1f             	xor    $0x1f,%ebp
  8023e6:	75 50                	jne    802438 <__umoddi3+0xa8>
  8023e8:	39 d8                	cmp    %ebx,%eax
  8023ea:	0f 82 e0 00 00 00    	jb     8024d0 <__umoddi3+0x140>
  8023f0:	89 d9                	mov    %ebx,%ecx
  8023f2:	39 f7                	cmp    %esi,%edi
  8023f4:	0f 86 d6 00 00 00    	jbe    8024d0 <__umoddi3+0x140>
  8023fa:	89 d0                	mov    %edx,%eax
  8023fc:	89 ca                	mov    %ecx,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 fd                	mov    %edi,%ebp
  802412:	85 ff                	test   %edi,%edi
  802414:	75 0b                	jne    802421 <__umoddi3+0x91>
  802416:	b8 01 00 00 00       	mov    $0x1,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f7                	div    %edi
  80241f:	89 c5                	mov    %eax,%ebp
  802421:	89 d8                	mov    %ebx,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f5                	div    %ebp
  802427:	89 f0                	mov    %esi,%eax
  802429:	f7 f5                	div    %ebp
  80242b:	89 d0                	mov    %edx,%eax
  80242d:	31 d2                	xor    %edx,%edx
  80242f:	eb 8c                	jmp    8023bd <__umoddi3+0x2d>
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 e9                	mov    %ebp,%ecx
  80243a:	ba 20 00 00 00       	mov    $0x20,%edx
  80243f:	29 ea                	sub    %ebp,%edx
  802441:	d3 e0                	shl    %cl,%eax
  802443:	89 44 24 08          	mov    %eax,0x8(%esp)
  802447:	89 d1                	mov    %edx,%ecx
  802449:	89 f8                	mov    %edi,%eax
  80244b:	d3 e8                	shr    %cl,%eax
  80244d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802451:	89 54 24 04          	mov    %edx,0x4(%esp)
  802455:	8b 54 24 04          	mov    0x4(%esp),%edx
  802459:	09 c1                	or     %eax,%ecx
  80245b:	89 d8                	mov    %ebx,%eax
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 e9                	mov    %ebp,%ecx
  802463:	d3 e7                	shl    %cl,%edi
  802465:	89 d1                	mov    %edx,%ecx
  802467:	d3 e8                	shr    %cl,%eax
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80246f:	d3 e3                	shl    %cl,%ebx
  802471:	89 c7                	mov    %eax,%edi
  802473:	89 d1                	mov    %edx,%ecx
  802475:	89 f0                	mov    %esi,%eax
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 fa                	mov    %edi,%edx
  80247d:	d3 e6                	shl    %cl,%esi
  80247f:	09 d8                	or     %ebx,%eax
  802481:	f7 74 24 08          	divl   0x8(%esp)
  802485:	89 d1                	mov    %edx,%ecx
  802487:	89 f3                	mov    %esi,%ebx
  802489:	f7 64 24 0c          	mull   0xc(%esp)
  80248d:	89 c6                	mov    %eax,%esi
  80248f:	89 d7                	mov    %edx,%edi
  802491:	39 d1                	cmp    %edx,%ecx
  802493:	72 06                	jb     80249b <__umoddi3+0x10b>
  802495:	75 10                	jne    8024a7 <__umoddi3+0x117>
  802497:	39 c3                	cmp    %eax,%ebx
  802499:	73 0c                	jae    8024a7 <__umoddi3+0x117>
  80249b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80249f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024a3:	89 d7                	mov    %edx,%edi
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	89 ca                	mov    %ecx,%edx
  8024a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ae:	29 f3                	sub    %esi,%ebx
  8024b0:	19 fa                	sbb    %edi,%edx
  8024b2:	89 d0                	mov    %edx,%eax
  8024b4:	d3 e0                	shl    %cl,%eax
  8024b6:	89 e9                	mov    %ebp,%ecx
  8024b8:	d3 eb                	shr    %cl,%ebx
  8024ba:	d3 ea                	shr    %cl,%edx
  8024bc:	09 d8                	or     %ebx,%eax
  8024be:	83 c4 1c             	add    $0x1c,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5f                   	pop    %edi
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    
  8024c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024cd:	8d 76 00             	lea    0x0(%esi),%esi
  8024d0:	29 fe                	sub    %edi,%esi
  8024d2:	19 c3                	sbb    %eax,%ebx
  8024d4:	89 f2                	mov    %esi,%edx
  8024d6:	89 d9                	mov    %ebx,%ecx
  8024d8:	e9 1d ff ff ff       	jmp    8023fa <__umoddi3+0x6a>
