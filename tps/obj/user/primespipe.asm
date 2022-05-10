
obj/user/primespipe.debug:     formato del fichero elf32-i386


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
  80002c:	e8 08 02 00 00       	call   800239 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800043:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800046:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800049:	eb 5e                	jmp    8000a9 <primeproc+0x76>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	85 c0                	test   %eax,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	0f 4e d0             	cmovle %eax,%edx
  800058:	52                   	push   %edx
  800059:	50                   	push   %eax
  80005a:	68 60 25 80 00       	push   $0x802560
  80005f:	6a 15                	push   $0x15
  800061:	68 8f 25 80 00       	push   $0x80258f
  800066:	e8 3a 02 00 00       	call   8002a5 <_panic>
		panic("pipe: %e", i);
  80006b:	50                   	push   %eax
  80006c:	68 a5 25 80 00       	push   $0x8025a5
  800071:	6a 1b                	push   $0x1b
  800073:	68 8f 25 80 00       	push   $0x80258f
  800078:	e8 28 02 00 00       	call   8002a5 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  80007d:	50                   	push   %eax
  80007e:	68 e7 29 80 00       	push   $0x8029e7
  800083:	6a 1d                	push   $0x1d
  800085:	68 8f 25 80 00       	push   $0x80258f
  80008a:	e8 16 02 00 00       	call   8002a5 <_panic>
	if (id == 0) {
		close(fd);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	53                   	push   %ebx
  800093:	e8 b4 14 00 00       	call   80154c <close>
		close(pfd[1]);
  800098:	83 c4 04             	add    $0x4,%esp
  80009b:	ff 75 dc             	pushl  -0x24(%ebp)
  80009e:	e8 a9 14 00 00       	call   80154c <close>
		fd = pfd[0];
  8000a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a6:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 6c 16 00 00       	call   801721 <readn>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 f8 04             	cmp    $0x4,%eax
  8000bb:	75 8e                	jne    80004b <primeproc+0x18>
	cprintf("%d\n", p);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	68 a1 25 80 00       	push   $0x8025a1
  8000c8:	e8 bf 02 00 00       	call   80038c <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000cd:	89 3c 24             	mov    %edi,(%esp)
  8000d0:	e8 23 1d 00 00       	call   801df8 <pipe>
  8000d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	78 8c                	js     80006b <primeproc+0x38>
	if ((id = fork()) < 0)
  8000df:	e8 5a 11 00 00       	call   80123e <fork>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	78 95                	js     80007d <primeproc+0x4a>
	if (id == 0) {
  8000e8:	74 a5                	je     80008f <primeproc+0x5c>
	}

	close(pfd[0]);
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f0:	e8 57 14 00 00       	call   80154c <close>
	wfd = pfd[1];
  8000f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f8:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	6a 04                	push   $0x4
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	e8 17 16 00 00       	call   801721 <readn>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	83 f8 04             	cmp    $0x4,%eax
  800110:	75 42                	jne    800154 <primeproc+0x121>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800115:	99                   	cltd   
  800116:	f7 7d e0             	idivl  -0x20(%ebp)
  800119:	85 d2                	test   %edx,%edx
  80011b:	74 e1                	je     8000fe <primeproc+0xcb>
			if ((r=write(wfd, &i, 4)) != 4)
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	6a 04                	push   $0x4
  800122:	56                   	push   %esi
  800123:	57                   	push   %edi
  800124:	e8 43 16 00 00       	call   80176c <write>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	83 f8 04             	cmp    $0x4,%eax
  80012f:	74 cd                	je     8000fe <primeproc+0xcb>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	85 c0                	test   %eax,%eax
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	0f 4e d0             	cmovle %eax,%edx
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	ff 75 e0             	pushl  -0x20(%ebp)
  800143:	68 ca 25 80 00       	push   $0x8025ca
  800148:	6a 2e                	push   $0x2e
  80014a:	68 8f 25 80 00       	push   $0x80258f
  80014f:	e8 51 01 00 00       	call   8002a5 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	0f 4e d0             	cmovle %eax,%edx
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	53                   	push   %ebx
  800164:	ff 75 e0             	pushl  -0x20(%ebp)
  800167:	68 ae 25 80 00       	push   $0x8025ae
  80016c:	6a 2b                	push   $0x2b
  80016e:	68 8f 25 80 00       	push   $0x80258f
  800173:	e8 2d 01 00 00       	call   8002a5 <_panic>

00800178 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	53                   	push   %ebx
  800180:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800183:	c7 05 00 30 80 00 e4 	movl   $0x8025e4,0x803000
  80018a:	25 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 62 1c 00 00       	call   801df8 <pipe>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	78 21                	js     8001c1 <umain+0x49>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001a0:	e8 99 10 00 00       	call   80123e <fork>
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	78 2a                	js     8001d3 <umain+0x5b>
		panic("fork: %e", id);

	if (id == 0) {
  8001a9:	75 3a                	jne    8001e5 <umain+0x6d>
		close(p[1]);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b1:	e8 96 13 00 00       	call   80154c <close>
		primeproc(p[0]);
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 72 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c1:	50                   	push   %eax
  8001c2:	68 a5 25 80 00       	push   $0x8025a5
  8001c7:	6a 3a                	push   $0x3a
  8001c9:	68 8f 25 80 00       	push   $0x80258f
  8001ce:	e8 d2 00 00 00       	call   8002a5 <_panic>
		panic("fork: %e", id);
  8001d3:	50                   	push   %eax
  8001d4:	68 e7 29 80 00       	push   $0x8029e7
  8001d9:	6a 3e                	push   $0x3e
  8001db:	68 8f 25 80 00       	push   $0x80258f
  8001e0:	e8 c0 00 00 00       	call   8002a5 <_panic>
	}

	close(p[0]);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001eb:	e8 5c 13 00 00       	call   80154c <close>

	// feed all the integers through
	for (i=2;; i++)
  8001f0:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f7:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001fa:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	6a 04                	push   $0x4
  800202:	53                   	push   %ebx
  800203:	ff 75 f0             	pushl  -0x10(%ebp)
  800206:	e8 61 15 00 00       	call   80176c <write>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	83 f8 04             	cmp    $0x4,%eax
  800211:	75 06                	jne    800219 <umain+0xa1>
	for (i=2;; i++)
  800213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800217:	eb e4                	jmp    8001fd <umain+0x85>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	85 c0                	test   %eax,%eax
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	0f 4e d0             	cmovle %eax,%edx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 ef 25 80 00       	push   $0x8025ef
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 8f 25 80 00       	push   $0x80258f
  800234:	e8 6c 00 00 00       	call   8002a5 <_panic>

00800239 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800245:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800248:	e8 de 0a 00 00       	call   800d2b <sys_getenvid>
	if (id >= 0)
  80024d:	85 c0                	test   %eax,%eax
  80024f:	78 12                	js     800263 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800251:	25 ff 03 00 00       	and    $0x3ff,%eax
  800256:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800259:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800263:	85 db                	test   %ebx,%ebx
  800265:	7e 07                	jle    80026e <libmain+0x35>
		binaryname = argv[0];
  800267:	8b 06                	mov    (%esi),%eax
  800269:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80026e:	83 ec 08             	sub    $0x8,%esp
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	e8 00 ff ff ff       	call   800178 <umain>

	// exit gracefully
	exit();
  800278:	e8 0a 00 00 00       	call   800287 <exit>
}
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800283:	5b                   	pop    %ebx
  800284:	5e                   	pop    %esi
  800285:	5d                   	pop    %ebp
  800286:	c3                   	ret    

00800287 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800291:	e8 e7 12 00 00       	call   80157d <close_all>
	sys_env_destroy(0);
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	6a 00                	push   $0x0
  80029b:	e8 65 0a 00 00       	call   800d05 <sys_env_destroy>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a5:	f3 0f 1e fb          	endbr32 
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002b7:	e8 6f 0a 00 00       	call   800d2b <sys_getenvid>
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	56                   	push   %esi
  8002c6:	50                   	push   %eax
  8002c7:	68 14 26 80 00       	push   $0x802614
  8002cc:	e8 bb 00 00 00       	call   80038c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d1:	83 c4 18             	add    $0x18,%esp
  8002d4:	53                   	push   %ebx
  8002d5:	ff 75 10             	pushl  0x10(%ebp)
  8002d8:	e8 5a 00 00 00       	call   800337 <vcprintf>
	cprintf("\n");
  8002dd:	c7 04 24 63 2c 80 00 	movl   $0x802c63,(%esp)
  8002e4:	e8 a3 00 00 00       	call   80038c <cprintf>
  8002e9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ec:	cc                   	int3   
  8002ed:	eb fd                	jmp    8002ec <_panic+0x47>

008002ef <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 04             	sub    $0x4,%esp
  8002fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002fd:	8b 13                	mov    (%ebx),%edx
  8002ff:	8d 42 01             	lea    0x1(%edx),%eax
  800302:	89 03                	mov    %eax,(%ebx)
  800304:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800307:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80030b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800310:	74 09                	je     80031b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800312:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	68 ff 00 00 00       	push   $0xff
  800323:	8d 43 08             	lea    0x8(%ebx),%eax
  800326:	50                   	push   %eax
  800327:	e8 87 09 00 00       	call   800cb3 <sys_cputs>
		b->idx = 0;
  80032c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	eb db                	jmp    800312 <putch+0x23>

00800337 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800337:	f3 0f 1e fb          	endbr32 
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800344:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80034b:	00 00 00 
	b.cnt = 0;
  80034e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800355:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800364:	50                   	push   %eax
  800365:	68 ef 02 80 00       	push   $0x8002ef
  80036a:	e8 80 01 00 00       	call   8004ef <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036f:	83 c4 08             	add    $0x8,%esp
  800372:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800378:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	e8 2f 09 00 00       	call   800cb3 <sys_cputs>

	return b.cnt;
}
  800384:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80038c:	f3 0f 1e fb          	endbr32 
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800396:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800399:	50                   	push   %eax
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 95 ff ff ff       	call   800337 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 1c             	sub    $0x1c,%esp
  8003ad:	89 c7                	mov    %eax,%edi
  8003af:	89 d6                	mov    %edx,%esi
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b7:	89 d1                	mov    %edx,%ecx
  8003b9:	89 c2                	mov    %eax,%edx
  8003bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003be:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003d6:	72 3e                	jb     800416 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	ff 75 18             	pushl  0x18(%ebp)
  8003de:	83 eb 01             	sub    $0x1,%ebx
  8003e1:	53                   	push   %ebx
  8003e2:	50                   	push   %eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f2:	e8 09 1f 00 00       	call   802300 <__udivdi3>
  8003f7:	83 c4 18             	add    $0x18,%esp
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	89 f2                	mov    %esi,%edx
  8003fe:	89 f8                	mov    %edi,%eax
  800400:	e8 9f ff ff ff       	call   8003a4 <printnum>
  800405:	83 c4 20             	add    $0x20,%esp
  800408:	eb 13                	jmp    80041d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	56                   	push   %esi
  80040e:	ff 75 18             	pushl  0x18(%ebp)
  800411:	ff d7                	call   *%edi
  800413:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800416:	83 eb 01             	sub    $0x1,%ebx
  800419:	85 db                	test   %ebx,%ebx
  80041b:	7f ed                	jg     80040a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	56                   	push   %esi
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 e4             	pushl  -0x1c(%ebp)
  800427:	ff 75 e0             	pushl  -0x20(%ebp)
  80042a:	ff 75 dc             	pushl  -0x24(%ebp)
  80042d:	ff 75 d8             	pushl  -0x28(%ebp)
  800430:	e8 db 1f 00 00       	call   802410 <__umoddi3>
  800435:	83 c4 14             	add    $0x14,%esp
  800438:	0f be 80 37 26 80 00 	movsbl 0x802637(%eax),%eax
  80043f:	50                   	push   %eax
  800440:	ff d7                	call   *%edi
}
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800448:	5b                   	pop    %ebx
  800449:	5e                   	pop    %esi
  80044a:	5f                   	pop    %edi
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80044d:	83 fa 01             	cmp    $0x1,%edx
  800450:	7f 13                	jg     800465 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800452:	85 d2                	test   %edx,%edx
  800454:	74 1c                	je     800472 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800456:	8b 10                	mov    (%eax),%edx
  800458:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045b:	89 08                	mov    %ecx,(%eax)
  80045d:	8b 02                	mov    (%edx),%eax
  80045f:	ba 00 00 00 00       	mov    $0x0,%edx
  800464:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800465:	8b 10                	mov    (%eax),%edx
  800467:	8d 4a 08             	lea    0x8(%edx),%ecx
  80046a:	89 08                	mov    %ecx,(%eax)
  80046c:	8b 02                	mov    (%edx),%eax
  80046e:	8b 52 04             	mov    0x4(%edx),%edx
  800471:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800472:	8b 10                	mov    (%eax),%edx
  800474:	8d 4a 04             	lea    0x4(%edx),%ecx
  800477:	89 08                	mov    %ecx,(%eax)
  800479:	8b 02                	mov    (%edx),%eax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800480:	c3                   	ret    

00800481 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800481:	83 fa 01             	cmp    $0x1,%edx
  800484:	7f 0f                	jg     800495 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <getint+0x21>
		return va_arg(*ap, long);
  80048a:	8b 10                	mov    (%eax),%edx
  80048c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80048f:	89 08                	mov    %ecx,(%eax)
  800491:	8b 02                	mov    (%edx),%eax
  800493:	99                   	cltd   
  800494:	c3                   	ret    
		return va_arg(*ap, long long);
  800495:	8b 10                	mov    (%eax),%edx
  800497:	8d 4a 08             	lea    0x8(%edx),%ecx
  80049a:	89 08                	mov    %ecx,(%eax)
  80049c:	8b 02                	mov    (%edx),%eax
  80049e:	8b 52 04             	mov    0x4(%edx),%edx
  8004a1:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8004a2:	8b 10                	mov    (%eax),%edx
  8004a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004a7:	89 08                	mov    %ecx,(%eax)
  8004a9:	8b 02                	mov    (%edx),%eax
  8004ab:	99                   	cltd   
}
  8004ac:	c3                   	ret    

008004ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ad:	f3 0f 1e fb          	endbr32 
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004b7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004bb:	8b 10                	mov    (%eax),%edx
  8004bd:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c0:	73 0a                	jae    8004cc <sprintputch+0x1f>
		*b->buf++ = ch;
  8004c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004c5:	89 08                	mov    %ecx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	88 02                	mov    %al,(%edx)
}
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    

008004ce <printfmt>:
{
  8004ce:	f3 0f 1e fb          	endbr32 
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004d8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004db:	50                   	push   %eax
  8004dc:	ff 75 10             	pushl  0x10(%ebp)
  8004df:	ff 75 0c             	pushl  0xc(%ebp)
  8004e2:	ff 75 08             	pushl  0x8(%ebp)
  8004e5:	e8 05 00 00 00       	call   8004ef <vprintfmt>
}
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <vprintfmt>:
{
  8004ef:	f3 0f 1e fb          	endbr32 
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	57                   	push   %edi
  8004f7:	56                   	push   %esi
  8004f8:	53                   	push   %ebx
  8004f9:	83 ec 2c             	sub    $0x2c,%esp
  8004fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800502:	8b 7d 10             	mov    0x10(%ebp),%edi
  800505:	e9 86 02 00 00       	jmp    800790 <vprintfmt+0x2a1>
		padc = ' ';
  80050a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80050e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800515:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80051c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800523:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800528:	8d 47 01             	lea    0x1(%edi),%eax
  80052b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80052e:	0f b6 17             	movzbl (%edi),%edx
  800531:	8d 42 dd             	lea    -0x23(%edx),%eax
  800534:	3c 55                	cmp    $0x55,%al
  800536:	0f 87 df 02 00 00    	ja     80081b <vprintfmt+0x32c>
  80053c:	0f b6 c0             	movzbl %al,%eax
  80053f:	3e ff 24 85 80 27 80 	notrack jmp *0x802780(,%eax,4)
  800546:	00 
  800547:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80054a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80054e:	eb d8                	jmp    800528 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800553:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800557:	eb cf                	jmp    800528 <vprintfmt+0x39>
  800559:	0f b6 d2             	movzbl %dl,%edx
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800567:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80056a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80056e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800571:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800574:	83 f9 09             	cmp    $0x9,%ecx
  800577:	77 52                	ja     8005cb <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800579:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80057c:	eb e9                	jmp    800567 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8d 50 04             	lea    0x4(%eax),%edx
  800584:	89 55 14             	mov    %edx,0x14(%ebp)
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80058f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800593:	79 93                	jns    800528 <vprintfmt+0x39>
				width = precision, precision = -1;
  800595:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005a2:	eb 84                	jmp    800528 <vprintfmt+0x39>
  8005a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	0f 49 d0             	cmovns %eax,%edx
  8005b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b7:	e9 6c ff ff ff       	jmp    800528 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005bf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005c6:	e9 5d ff ff ff       	jmp    800528 <vprintfmt+0x39>
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d1:	eb bc                	jmp    80058f <vprintfmt+0xa0>
			lflag++;
  8005d3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005d9:	e9 4a ff ff ff       	jmp    800528 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 50 04             	lea    0x4(%eax),%edx
  8005e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	56                   	push   %esi
  8005eb:	ff 30                	pushl  (%eax)
  8005ed:	ff d3                	call   *%ebx
			break;
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	e9 96 01 00 00       	jmp    80078d <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 00                	mov    (%eax),%eax
  800602:	99                   	cltd   
  800603:	31 d0                	xor    %edx,%eax
  800605:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800607:	83 f8 0f             	cmp    $0xf,%eax
  80060a:	7f 20                	jg     80062c <vprintfmt+0x13d>
  80060c:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800613:	85 d2                	test   %edx,%edx
  800615:	74 15                	je     80062c <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800617:	52                   	push   %edx
  800618:	68 db 2b 80 00       	push   $0x802bdb
  80061d:	56                   	push   %esi
  80061e:	53                   	push   %ebx
  80061f:	e8 aa fe ff ff       	call   8004ce <printfmt>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	e9 61 01 00 00       	jmp    80078d <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80062c:	50                   	push   %eax
  80062d:	68 4f 26 80 00       	push   $0x80264f
  800632:	56                   	push   %esi
  800633:	53                   	push   %ebx
  800634:	e8 95 fe ff ff       	call   8004ce <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	e9 4c 01 00 00       	jmp    80078d <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 50 04             	lea    0x4(%eax),%edx
  800647:	89 55 14             	mov    %edx,0x14(%ebp)
  80064a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80064c:	85 c9                	test   %ecx,%ecx
  80064e:	b8 48 26 80 00       	mov    $0x802648,%eax
  800653:	0f 45 c1             	cmovne %ecx,%eax
  800656:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800659:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065d:	7e 06                	jle    800665 <vprintfmt+0x176>
  80065f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800663:	75 0d                	jne    800672 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800665:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800668:	89 c7                	mov    %eax,%edi
  80066a:	03 45 e0             	add    -0x20(%ebp),%eax
  80066d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800670:	eb 57                	jmp    8006c9 <vprintfmt+0x1da>
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 d8             	pushl  -0x28(%ebp)
  800678:	ff 75 cc             	pushl  -0x34(%ebp)
  80067b:	e8 4f 02 00 00       	call   8008cf <strnlen>
  800680:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800683:	29 c2                	sub    %eax,%edx
  800685:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800688:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80068b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80068f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800692:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800694:	85 db                	test   %ebx,%ebx
  800696:	7e 10                	jle    8006a8 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	56                   	push   %esi
  80069c:	57                   	push   %edi
  80069d:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a0:	83 eb 01             	sub    $0x1,%ebx
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	eb ec                	jmp    800694 <vprintfmt+0x1a5>
  8006a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8006ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ae:	85 d2                	test   %edx,%edx
  8006b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b5:	0f 49 c2             	cmovns %edx,%eax
  8006b8:	29 c2                	sub    %eax,%edx
  8006ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006bd:	eb a6                	jmp    800665 <vprintfmt+0x176>
					putch(ch, putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	56                   	push   %esi
  8006c3:	52                   	push   %edx
  8006c4:	ff d3                	call   *%ebx
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006cc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ce:	83 c7 01             	add    $0x1,%edi
  8006d1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d5:	0f be d0             	movsbl %al,%edx
  8006d8:	85 d2                	test   %edx,%edx
  8006da:	74 42                	je     80071e <vprintfmt+0x22f>
  8006dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e0:	78 06                	js     8006e8 <vprintfmt+0x1f9>
  8006e2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006e6:	78 1e                	js     800706 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006ec:	74 d1                	je     8006bf <vprintfmt+0x1d0>
  8006ee:	0f be c0             	movsbl %al,%eax
  8006f1:	83 e8 20             	sub    $0x20,%eax
  8006f4:	83 f8 5e             	cmp    $0x5e,%eax
  8006f7:	76 c6                	jbe    8006bf <vprintfmt+0x1d0>
					putch('?', putdat);
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	56                   	push   %esi
  8006fd:	6a 3f                	push   $0x3f
  8006ff:	ff d3                	call   *%ebx
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	eb c3                	jmp    8006c9 <vprintfmt+0x1da>
  800706:	89 cf                	mov    %ecx,%edi
  800708:	eb 0e                	jmp    800718 <vprintfmt+0x229>
				putch(' ', putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	56                   	push   %esi
  80070e:	6a 20                	push   $0x20
  800710:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800712:	83 ef 01             	sub    $0x1,%edi
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	85 ff                	test   %edi,%edi
  80071a:	7f ee                	jg     80070a <vprintfmt+0x21b>
  80071c:	eb 6f                	jmp    80078d <vprintfmt+0x29e>
  80071e:	89 cf                	mov    %ecx,%edi
  800720:	eb f6                	jmp    800718 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800722:	89 ca                	mov    %ecx,%edx
  800724:	8d 45 14             	lea    0x14(%ebp),%eax
  800727:	e8 55 fd ff ff       	call   800481 <getint>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800732:	85 d2                	test   %edx,%edx
  800734:	78 0b                	js     800741 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800736:	89 d1                	mov    %edx,%ecx
  800738:	89 c2                	mov    %eax,%edx
			base = 10;
  80073a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073f:	eb 32                	jmp    800773 <vprintfmt+0x284>
				putch('-', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	56                   	push   %esi
  800745:	6a 2d                	push   $0x2d
  800747:	ff d3                	call   *%ebx
				num = -(long long) num;
  800749:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80074c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80074f:	f7 da                	neg    %edx
  800751:	83 d1 00             	adc    $0x0,%ecx
  800754:	f7 d9                	neg    %ecx
  800756:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800759:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075e:	eb 13                	jmp    800773 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800760:	89 ca                	mov    %ecx,%edx
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	e8 e3 fc ff ff       	call   80044d <getuint>
  80076a:	89 d1                	mov    %edx,%ecx
  80076c:	89 c2                	mov    %eax,%edx
			base = 10;
  80076e:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80077a:	57                   	push   %edi
  80077b:	ff 75 e0             	pushl  -0x20(%ebp)
  80077e:	50                   	push   %eax
  80077f:	51                   	push   %ecx
  800780:	52                   	push   %edx
  800781:	89 f2                	mov    %esi,%edx
  800783:	89 d8                	mov    %ebx,%eax
  800785:	e8 1a fc ff ff       	call   8003a4 <printnum>
			break;
  80078a:	83 c4 20             	add    $0x20,%esp
{
  80078d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800790:	83 c7 01             	add    $0x1,%edi
  800793:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800797:	83 f8 25             	cmp    $0x25,%eax
  80079a:	0f 84 6a fd ff ff    	je     80050a <vprintfmt+0x1b>
			if (ch == '\0')
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	0f 84 93 00 00 00    	je     80083b <vprintfmt+0x34c>
			putch(ch, putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	56                   	push   %esi
  8007ac:	50                   	push   %eax
  8007ad:	ff d3                	call   *%ebx
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb dc                	jmp    800790 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8007b4:	89 ca                	mov    %ecx,%edx
  8007b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b9:	e8 8f fc ff ff       	call   80044d <getuint>
  8007be:	89 d1                	mov    %edx,%ecx
  8007c0:	89 c2                	mov    %eax,%edx
			base = 8;
  8007c2:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007c7:	eb aa                	jmp    800773 <vprintfmt+0x284>
			putch('0', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	56                   	push   %esi
  8007cd:	6a 30                	push   $0x30
  8007cf:	ff d3                	call   *%ebx
			putch('x', putdat);
  8007d1:	83 c4 08             	add    $0x8,%esp
  8007d4:	56                   	push   %esi
  8007d5:	6a 78                	push   $0x78
  8007d7:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 50 04             	lea    0x4(%eax),%edx
  8007df:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8007e2:	8b 10                	mov    (%eax),%edx
  8007e4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007e9:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007f1:	eb 80                	jmp    800773 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8007f3:	89 ca                	mov    %ecx,%edx
  8007f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f8:	e8 50 fc ff ff       	call   80044d <getuint>
  8007fd:	89 d1                	mov    %edx,%ecx
  8007ff:	89 c2                	mov    %eax,%edx
			base = 16;
  800801:	b8 10 00 00 00       	mov    $0x10,%eax
  800806:	e9 68 ff ff ff       	jmp    800773 <vprintfmt+0x284>
			putch(ch, putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	56                   	push   %esi
  80080f:	6a 25                	push   $0x25
  800811:	ff d3                	call   *%ebx
			break;
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	e9 72 ff ff ff       	jmp    80078d <vprintfmt+0x29e>
			putch('%', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	56                   	push   %esi
  80081f:	6a 25                	push   $0x25
  800821:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 f8                	mov    %edi,%eax
  800828:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082c:	74 05                	je     800833 <vprintfmt+0x344>
  80082e:	83 e8 01             	sub    $0x1,%eax
  800831:	eb f5                	jmp    800828 <vprintfmt+0x339>
  800833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800836:	e9 52 ff ff ff       	jmp    80078d <vprintfmt+0x29e>
}
  80083b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083e:	5b                   	pop    %ebx
  80083f:	5e                   	pop    %esi
  800840:	5f                   	pop    %edi
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800843:	f3 0f 1e fb          	endbr32 
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 18             	sub    $0x18,%esp
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800853:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800856:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800864:	85 c0                	test   %eax,%eax
  800866:	74 26                	je     80088e <vsnprintf+0x4b>
  800868:	85 d2                	test   %edx,%edx
  80086a:	7e 22                	jle    80088e <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086c:	ff 75 14             	pushl  0x14(%ebp)
  80086f:	ff 75 10             	pushl  0x10(%ebp)
  800872:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800875:	50                   	push   %eax
  800876:	68 ad 04 80 00       	push   $0x8004ad
  80087b:	e8 6f fc ff ff       	call   8004ef <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800883:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    
		return -E_INVAL;
  80088e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800893:	eb f7                	jmp    80088c <vsnprintf+0x49>

00800895 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a2:	50                   	push   %eax
  8008a3:	ff 75 10             	pushl  0x10(%ebp)
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 92 ff ff ff       	call   800843 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b3:	f3 0f 1e fb          	endbr32 
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c6:	74 05                	je     8008cd <strlen+0x1a>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
  8008cb:	eb f5                	jmp    8008c2 <strlen+0xf>
	return n;
}
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008cf:	f3 0f 1e fb          	endbr32 
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e1:	39 d0                	cmp    %edx,%eax
  8008e3:	74 0d                	je     8008f2 <strnlen+0x23>
  8008e5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e9:	74 05                	je     8008f0 <strnlen+0x21>
		n++;
  8008eb:	83 c0 01             	add    $0x1,%eax
  8008ee:	eb f1                	jmp    8008e1 <strnlen+0x12>
  8008f0:	89 c2                	mov    %eax,%edx
	return n;
}
  8008f2:	89 d0                	mov    %edx,%eax
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f6:	f3 0f 1e fb          	endbr32 
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800901:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80090d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	84 d2                	test   %dl,%dl
  800915:	75 f2                	jne    800909 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800917:	89 c8                	mov    %ecx,%eax
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091c:	f3 0f 1e fb          	endbr32 
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	83 ec 10             	sub    $0x10,%esp
  800927:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092a:	53                   	push   %ebx
  80092b:	e8 83 ff ff ff       	call   8008b3 <strlen>
  800930:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	01 d8                	add    %ebx,%eax
  800938:	50                   	push   %eax
  800939:	e8 b8 ff ff ff       	call   8008f6 <strcpy>
	return dst;
}
  80093e:	89 d8                	mov    %ebx,%eax
  800940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800945:	f3 0f 1e fb          	endbr32 
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	8b 75 08             	mov    0x8(%ebp),%esi
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	89 f3                	mov    %esi,%ebx
  800956:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800959:	89 f0                	mov    %esi,%eax
  80095b:	39 d8                	cmp    %ebx,%eax
  80095d:	74 11                	je     800970 <strncpy+0x2b>
		*dst++ = *src;
  80095f:	83 c0 01             	add    $0x1,%eax
  800962:	0f b6 0a             	movzbl (%edx),%ecx
  800965:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800968:	80 f9 01             	cmp    $0x1,%cl
  80096b:	83 da ff             	sbb    $0xffffffff,%edx
  80096e:	eb eb                	jmp    80095b <strncpy+0x16>
	}
	return ret;
}
  800970:	89 f0                	mov    %esi,%eax
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800985:	8b 55 10             	mov    0x10(%ebp),%edx
  800988:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098a:	85 d2                	test   %edx,%edx
  80098c:	74 21                	je     8009af <strlcpy+0x39>
  80098e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800992:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800994:	39 c2                	cmp    %eax,%edx
  800996:	74 14                	je     8009ac <strlcpy+0x36>
  800998:	0f b6 19             	movzbl (%ecx),%ebx
  80099b:	84 db                	test   %bl,%bl
  80099d:	74 0b                	je     8009aa <strlcpy+0x34>
			*dst++ = *src++;
  80099f:	83 c1 01             	add    $0x1,%ecx
  8009a2:	83 c2 01             	add    $0x1,%edx
  8009a5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a8:	eb ea                	jmp    800994 <strlcpy+0x1e>
  8009aa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009af:	29 f0                	sub    %esi,%eax
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	5e                   	pop    %esi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b5:	f3 0f 1e fb          	endbr32 
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c2:	0f b6 01             	movzbl (%ecx),%eax
  8009c5:	84 c0                	test   %al,%al
  8009c7:	74 0c                	je     8009d5 <strcmp+0x20>
  8009c9:	3a 02                	cmp    (%edx),%al
  8009cb:	75 08                	jne    8009d5 <strcmp+0x20>
		p++, q++;
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	eb ed                	jmp    8009c2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d5:	0f b6 c0             	movzbl %al,%eax
  8009d8:	0f b6 12             	movzbl (%edx),%edx
  8009db:	29 d0                	sub    %edx,%eax
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009df:	f3 0f 1e fb          	endbr32 
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	53                   	push   %ebx
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ed:	89 c3                	mov    %eax,%ebx
  8009ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f2:	eb 06                	jmp    8009fa <strncmp+0x1b>
		n--, p++, q++;
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009fa:	39 d8                	cmp    %ebx,%eax
  8009fc:	74 16                	je     800a14 <strncmp+0x35>
  8009fe:	0f b6 08             	movzbl (%eax),%ecx
  800a01:	84 c9                	test   %cl,%cl
  800a03:	74 04                	je     800a09 <strncmp+0x2a>
  800a05:	3a 0a                	cmp    (%edx),%cl
  800a07:	74 eb                	je     8009f4 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a09:	0f b6 00             	movzbl (%eax),%eax
  800a0c:	0f b6 12             	movzbl (%edx),%edx
  800a0f:	29 d0                	sub    %edx,%eax
}
  800a11:	5b                   	pop    %ebx
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    
		return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
  800a19:	eb f6                	jmp    800a11 <strncmp+0x32>

00800a1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1b:	f3 0f 1e fb          	endbr32 
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a29:	0f b6 10             	movzbl (%eax),%edx
  800a2c:	84 d2                	test   %dl,%dl
  800a2e:	74 09                	je     800a39 <strchr+0x1e>
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 0a                	je     800a3e <strchr+0x23>
	for (; *s; s++)
  800a34:	83 c0 01             	add    $0x1,%eax
  800a37:	eb f0                	jmp    800a29 <strchr+0xe>
			return (char *) s;
	return 0;
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a40:	f3 0f 1e fb          	endbr32 
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a51:	38 ca                	cmp    %cl,%dl
  800a53:	74 09                	je     800a5e <strfind+0x1e>
  800a55:	84 d2                	test   %dl,%dl
  800a57:	74 05                	je     800a5e <strfind+0x1e>
	for (; *s; s++)
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	eb f0                	jmp    800a4e <strfind+0xe>
			break;
	return (char *) s;
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a60:	f3 0f 1e fb          	endbr32 
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800a70:	85 c9                	test   %ecx,%ecx
  800a72:	74 33                	je     800aa7 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a74:	89 d0                	mov    %edx,%eax
  800a76:	09 c8                	or     %ecx,%eax
  800a78:	a8 03                	test   $0x3,%al
  800a7a:	75 23                	jne    800a9f <memset+0x3f>
		c &= 0xFF;
  800a7c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a80:	89 d8                	mov    %ebx,%eax
  800a82:	c1 e0 08             	shl    $0x8,%eax
  800a85:	89 df                	mov    %ebx,%edi
  800a87:	c1 e7 18             	shl    $0x18,%edi
  800a8a:	89 de                	mov    %ebx,%esi
  800a8c:	c1 e6 10             	shl    $0x10,%esi
  800a8f:	09 f7                	or     %esi,%edi
  800a91:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a93:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a96:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800a98:	89 d7                	mov    %edx,%edi
  800a9a:	fc                   	cld    
  800a9b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9d:	eb 08                	jmp    800aa7 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9f:	89 d7                	mov    %edx,%edi
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	fc                   	cld    
  800aa5:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800aa7:	89 d0                	mov    %edx,%eax
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aae:	f3 0f 1e fb          	endbr32 
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac0:	39 c6                	cmp    %eax,%esi
  800ac2:	73 32                	jae    800af6 <memmove+0x48>
  800ac4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac7:	39 c2                	cmp    %eax,%edx
  800ac9:	76 2b                	jbe    800af6 <memmove+0x48>
		s += n;
		d += n;
  800acb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ace:	89 fe                	mov    %edi,%esi
  800ad0:	09 ce                	or     %ecx,%esi
  800ad2:	09 d6                	or     %edx,%esi
  800ad4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ada:	75 0e                	jne    800aea <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800adc:	83 ef 04             	sub    $0x4,%edi
  800adf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae8:	eb 09                	jmp    800af3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aea:	83 ef 01             	sub    $0x1,%edi
  800aed:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af0:	fd                   	std    
  800af1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af3:	fc                   	cld    
  800af4:	eb 1a                	jmp    800b10 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	09 ca                	or     %ecx,%edx
  800afa:	09 f2                	or     %esi,%edx
  800afc:	f6 c2 03             	test   $0x3,%dl
  800aff:	75 0a                	jne    800b0b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b04:	89 c7                	mov    %eax,%edi
  800b06:	fc                   	cld    
  800b07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b09:	eb 05                	jmp    800b10 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	fc                   	cld    
  800b0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b14:	f3 0f 1e fb          	endbr32 
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1e:	ff 75 10             	pushl  0x10(%ebp)
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 82 ff ff ff       	call   800aae <memmove>
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2e:	f3 0f 1e fb          	endbr32 
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	56                   	push   %esi
  800b36:	53                   	push   %ebx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3d:	89 c6                	mov    %eax,%esi
  800b3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b42:	39 f0                	cmp    %esi,%eax
  800b44:	74 1c                	je     800b62 <memcmp+0x34>
		if (*s1 != *s2)
  800b46:	0f b6 08             	movzbl (%eax),%ecx
  800b49:	0f b6 1a             	movzbl (%edx),%ebx
  800b4c:	38 d9                	cmp    %bl,%cl
  800b4e:	75 08                	jne    800b58 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b50:	83 c0 01             	add    $0x1,%eax
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	eb ea                	jmp    800b42 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b58:	0f b6 c1             	movzbl %cl,%eax
  800b5b:	0f b6 db             	movzbl %bl,%ebx
  800b5e:	29 d8                	sub    %ebx,%eax
  800b60:	eb 05                	jmp    800b67 <memcmp+0x39>
	}

	return 0;
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6b:	f3 0f 1e fb          	endbr32 
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b78:	89 c2                	mov    %eax,%edx
  800b7a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7d:	39 d0                	cmp    %edx,%eax
  800b7f:	73 09                	jae    800b8a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b81:	38 08                	cmp    %cl,(%eax)
  800b83:	74 05                	je     800b8a <memfind+0x1f>
	for (; s < ends; s++)
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	eb f3                	jmp    800b7d <memfind+0x12>
			break;
	return (void *) s;
}
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8c:	f3 0f 1e fb          	endbr32 
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9c:	eb 03                	jmp    800ba1 <strtol+0x15>
		s++;
  800b9e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba1:	0f b6 01             	movzbl (%ecx),%eax
  800ba4:	3c 20                	cmp    $0x20,%al
  800ba6:	74 f6                	je     800b9e <strtol+0x12>
  800ba8:	3c 09                	cmp    $0x9,%al
  800baa:	74 f2                	je     800b9e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bac:	3c 2b                	cmp    $0x2b,%al
  800bae:	74 2a                	je     800bda <strtol+0x4e>
	int neg = 0;
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb5:	3c 2d                	cmp    $0x2d,%al
  800bb7:	74 2b                	je     800be4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbf:	75 0f                	jne    800bd0 <strtol+0x44>
  800bc1:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc4:	74 28                	je     800bee <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcd:	0f 44 d8             	cmove  %eax,%ebx
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd8:	eb 46                	jmp    800c20 <strtol+0x94>
		s++;
  800bda:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  800be2:	eb d5                	jmp    800bb9 <strtol+0x2d>
		s++, neg = 1;
  800be4:	83 c1 01             	add    $0x1,%ecx
  800be7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bec:	eb cb                	jmp    800bb9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf2:	74 0e                	je     800c02 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf4:	85 db                	test   %ebx,%ebx
  800bf6:	75 d8                	jne    800bd0 <strtol+0x44>
		s++, base = 8;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c00:	eb ce                	jmp    800bd0 <strtol+0x44>
		s += 2, base = 16;
  800c02:	83 c1 02             	add    $0x2,%ecx
  800c05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0a:	eb c4                	jmp    800bd0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c0c:	0f be d2             	movsbl %dl,%edx
  800c0f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c12:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c15:	7d 3a                	jge    800c51 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c17:	83 c1 01             	add    $0x1,%ecx
  800c1a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c20:	0f b6 11             	movzbl (%ecx),%edx
  800c23:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 09             	cmp    $0x9,%bl
  800c2b:	76 df                	jbe    800c0c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c2d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c30:	89 f3                	mov    %esi,%ebx
  800c32:	80 fb 19             	cmp    $0x19,%bl
  800c35:	77 08                	ja     800c3f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c37:	0f be d2             	movsbl %dl,%edx
  800c3a:	83 ea 57             	sub    $0x57,%edx
  800c3d:	eb d3                	jmp    800c12 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c42:	89 f3                	mov    %esi,%ebx
  800c44:	80 fb 19             	cmp    $0x19,%bl
  800c47:	77 08                	ja     800c51 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c49:	0f be d2             	movsbl %dl,%edx
  800c4c:	83 ea 37             	sub    $0x37,%edx
  800c4f:	eb c1                	jmp    800c12 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c55:	74 05                	je     800c5c <strtol+0xd0>
		*endptr = (char *) s;
  800c57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5c:	89 c2                	mov    %eax,%edx
  800c5e:	f7 da                	neg    %edx
  800c60:	85 ff                	test   %edi,%edi
  800c62:	0f 45 c2             	cmovne %edx,%eax
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 1c             	sub    $0x1c,%esp
  800c73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c79:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c81:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c84:	8b 75 14             	mov    0x14(%ebp),%esi
  800c87:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8d:	74 04                	je     800c93 <syscall+0x29>
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	ff 75 e0             	pushl  -0x20(%ebp)
  800ca2:	68 3f 29 80 00       	push   $0x80293f
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 5c 29 80 00       	push   $0x80295c
  800cae:	e8 f2 f5 ff ff       	call   8002a5 <_panic>

00800cb3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800cb3:	f3 0f 1e fb          	endbr32 
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800cbd:	6a 00                	push   $0x0
  800cbf:	6a 00                	push   $0x0
  800cc1:	6a 00                	push   $0x0
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd3:	e8 92 ff ff ff       	call   800c6a <syscall>
}
  800cd8:	83 c4 10             	add    $0x10,%esp
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <sys_cgetc>:

int
sys_cgetc(void)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ce7:	6a 00                	push   $0x0
  800ce9:	6a 00                	push   $0x0
  800ceb:	6a 00                	push   $0x0
  800ced:	6a 00                	push   $0x0
  800cef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  800cfe:	e8 67 ff ff ff       	call   800c6a <syscall>
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d05:	f3 0f 1e fb          	endbr32 
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800d0f:	6a 00                	push   $0x0
  800d11:	6a 00                	push   $0x0
  800d13:	6a 00                	push   $0x0
  800d15:	6a 00                	push   $0x0
  800d17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1a:	ba 01 00 00 00       	mov    $0x1,%edx
  800d1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d24:	e8 41 ff ff ff       	call   800c6a <syscall>
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800d35:	6a 00                	push   $0x0
  800d37:	6a 00                	push   $0x0
  800d39:	6a 00                	push   $0x0
  800d3b:	6a 00                	push   $0x0
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
  800d47:	b8 02 00 00 00       	mov    $0x2,%eax
  800d4c:	e8 19 ff ff ff       	call   800c6a <syscall>
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <sys_yield>:

void
sys_yield(void)
{
  800d53:	f3 0f 1e fb          	endbr32 
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800d5d:	6a 00                	push   $0x0
  800d5f:	6a 00                	push   $0x0
  800d61:	6a 00                	push   $0x0
  800d63:	6a 00                	push   $0x0
  800d65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d74:	e8 f1 fe ff ff       	call   800c6a <syscall>
}
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800d88:	6a 00                	push   $0x0
  800d8a:	6a 00                	push   $0x0
  800d8c:	ff 75 10             	pushl  0x10(%ebp)
  800d8f:	ff 75 0c             	pushl  0xc(%ebp)
  800d92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d95:	ba 01 00 00 00       	mov    $0x1,%edx
  800d9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9f:	e8 c6 fe ff ff       	call   800c6a <syscall>
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da6:	f3 0f 1e fb          	endbr32 
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800db0:	ff 75 18             	pushl  0x18(%ebp)
  800db3:	ff 75 14             	pushl  0x14(%ebp)
  800db6:	ff 75 10             	pushl  0x10(%ebp)
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbf:	ba 01 00 00 00       	mov    $0x1,%edx
  800dc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc9:	e8 9c fe ff ff       	call   800c6a <syscall>
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd0:	f3 0f 1e fb          	endbr32 
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800dda:	6a 00                	push   $0x0
  800ddc:	6a 00                	push   $0x0
  800dde:	6a 00                	push   $0x0
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de6:	ba 01 00 00 00       	mov    $0x1,%edx
  800deb:	b8 06 00 00 00       	mov    $0x6,%eax
  800df0:	e8 75 fe ff ff       	call   800c6a <syscall>
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df7:	f3 0f 1e fb          	endbr32 
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800e01:	6a 00                	push   $0x0
  800e03:	6a 00                	push   $0x0
  800e05:	6a 00                	push   $0x0
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0d:	ba 01 00 00 00       	mov    $0x1,%edx
  800e12:	b8 08 00 00 00       	mov    $0x8,%eax
  800e17:	e8 4e fe ff ff       	call   800c6a <syscall>
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e1e:	f3 0f 1e fb          	endbr32 
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800e28:	6a 00                	push   $0x0
  800e2a:	6a 00                	push   $0x0
  800e2c:	6a 00                	push   $0x0
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e34:	ba 01 00 00 00       	mov    $0x1,%edx
  800e39:	b8 09 00 00 00       	mov    $0x9,%eax
  800e3e:	e8 27 fe ff ff       	call   800c6a <syscall>
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e45:	f3 0f 1e fb          	endbr32 
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800e4f:	6a 00                	push   $0x0
  800e51:	6a 00                	push   $0x0
  800e53:	6a 00                	push   $0x0
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5b:	ba 01 00 00 00       	mov    $0x1,%edx
  800e60:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e65:	e8 00 fe ff ff       	call   800c6a <syscall>
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e6c:	f3 0f 1e fb          	endbr32 
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e76:	6a 00                	push   $0x0
  800e78:	ff 75 14             	pushl  0x14(%ebp)
  800e7b:	ff 75 10             	pushl  0x10(%ebp)
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e84:	ba 00 00 00 00       	mov    $0x0,%edx
  800e89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8e:	e8 d7 fd ff ff       	call   800c6a <syscall>
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e95:	f3 0f 1e fb          	endbr32 
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800e9f:	6a 00                	push   $0x0
  800ea1:	6a 00                	push   $0x0
  800ea3:	6a 00                	push   $0x0
  800ea5:	6a 00                	push   $0x0
  800ea7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eaa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eaf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb4:	e8 b1 fd ff ff       	call   800c6a <syscall>
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800ec4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800ecb:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800ece:	f6 c6 04             	test   $0x4,%dh
  800ed1:	75 51                	jne    800f24 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800ed3:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800ed9:	0f 84 84 00 00 00    	je     800f63 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	68 05 08 00 00       	push   $0x805
  800ee7:	53                   	push   %ebx
  800ee8:	50                   	push   %eax
  800ee9:	53                   	push   %ebx
  800eea:	6a 00                	push   $0x0
  800eec:	e8 b5 fe ff ff       	call   800da6 <sys_page_map>
		if (r)
  800ef1:	83 c4 20             	add    $0x20,%esp
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 59                	jne    800f51 <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	68 05 08 00 00       	push   $0x805
  800f00:	53                   	push   %ebx
  800f01:	6a 00                	push   $0x0
  800f03:	53                   	push   %ebx
  800f04:	6a 00                	push   $0x0
  800f06:	e8 9b fe ff ff       	call   800da6 <sys_page_map>
		if (r)
  800f0b:	83 c4 20             	add    $0x20,%esp
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	74 67                	je     800f79 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800f12:	50                   	push   %eax
  800f13:	68 6a 29 80 00       	push   $0x80296a
  800f18:	6a 5f                	push   $0x5f
  800f1a:	68 85 29 80 00       	push   $0x802985
  800f1f:	e8 81 f3 ff ff       	call   8002a5 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800f2d:	52                   	push   %edx
  800f2e:	53                   	push   %ebx
  800f2f:	50                   	push   %eax
  800f30:	53                   	push   %ebx
  800f31:	6a 00                	push   $0x0
  800f33:	e8 6e fe ff ff       	call   800da6 <sys_page_map>
		if (r)
  800f38:	83 c4 20             	add    $0x20,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	74 3a                	je     800f79 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800f3f:	50                   	push   %eax
  800f40:	68 6a 29 80 00       	push   $0x80296a
  800f45:	6a 57                	push   $0x57
  800f47:	68 85 29 80 00       	push   $0x802985
  800f4c:	e8 54 f3 ff ff       	call   8002a5 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800f51:	50                   	push   %eax
  800f52:	68 6a 29 80 00       	push   $0x80296a
  800f57:	6a 5b                	push   $0x5b
  800f59:	68 85 29 80 00       	push   $0x802985
  800f5e:	e8 42 f3 ff ff       	call   8002a5 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	6a 05                	push   $0x5
  800f68:	53                   	push   %ebx
  800f69:	50                   	push   %eax
  800f6a:	53                   	push   %ebx
  800f6b:	6a 00                	push   $0x0
  800f6d:	e8 34 fe ff ff       	call   800da6 <sys_page_map>
		if (r)
  800f72:	83 c4 20             	add    $0x20,%esp
  800f75:	85 c0                	test   %eax,%eax
  800f77:	75 0a                	jne    800f83 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  800f83:	50                   	push   %eax
  800f84:	68 6a 29 80 00       	push   $0x80296a
  800f89:	6a 63                	push   $0x63
  800f8b:	68 85 29 80 00       	push   $0x802985
  800f90:	e8 10 f3 ff ff       	call   8002a5 <_panic>

00800f95 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	89 c7                	mov    %eax,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  800fa4:	f6 c1 02             	test   $0x2,%cl
  800fa7:	75 2f                	jne    800fd8 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	51                   	push   %ecx
  800fad:	52                   	push   %edx
  800fae:	50                   	push   %eax
  800faf:	52                   	push   %edx
  800fb0:	6a 00                	push   $0x0
  800fb2:	e8 ef fd ff ff       	call   800da6 <sys_page_map>
  800fb7:	83 c4 20             	add    $0x20,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 08                	js     800fc6 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  800fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    
			panic("sys_page_map: %e", r);
  800fc6:	50                   	push   %eax
  800fc7:	68 74 29 80 00       	push   $0x802974
  800fcc:	6a 6f                	push   $0x6f
  800fce:	68 85 29 80 00       	push   $0x802985
  800fd3:	e8 cd f2 ff ff       	call   8002a5 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  800fd8:	83 ec 04             	sub    $0x4,%esp
  800fdb:	51                   	push   %ecx
  800fdc:	52                   	push   %edx
  800fdd:	50                   	push   %eax
  800fde:	e8 9b fd ff ff       	call   800d7e <sys_page_alloc>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 54                	js     80103e <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	53                   	push   %ebx
  800fee:	68 00 00 40 00       	push   $0x400000
  800ff3:	6a 00                	push   $0x0
  800ff5:	56                   	push   %esi
  800ff6:	57                   	push   %edi
  800ff7:	e8 aa fd ff ff       	call   800da6 <sys_page_map>
  800ffc:	83 c4 20             	add    $0x20,%esp
  800fff:	85 c0                	test   %eax,%eax
  801001:	78 4d                	js     801050 <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 00 10 00 00       	push   $0x1000
  80100b:	56                   	push   %esi
  80100c:	68 00 00 40 00       	push   $0x400000
  801011:	e8 98 fa ff ff       	call   800aae <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801016:	83 c4 08             	add    $0x8,%esp
  801019:	68 00 00 40 00       	push   $0x400000
  80101e:	6a 00                	push   $0x0
  801020:	e8 ab fd ff ff       	call   800dd0 <sys_page_unmap>
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	85 c0                	test   %eax,%eax
  80102a:	79 92                	jns    800fbe <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  80102c:	50                   	push   %eax
  80102d:	68 a3 29 80 00       	push   $0x8029a3
  801032:	6a 78                	push   $0x78
  801034:	68 85 29 80 00       	push   $0x802985
  801039:	e8 67 f2 ff ff       	call   8002a5 <_panic>
		panic("sys_page_alloc: %e", r);
  80103e:	50                   	push   %eax
  80103f:	68 90 29 80 00       	push   $0x802990
  801044:	6a 73                	push   $0x73
  801046:	68 85 29 80 00       	push   $0x802985
  80104b:	e8 55 f2 ff ff       	call   8002a5 <_panic>
		panic("sys_page_map: %e", r);
  801050:	50                   	push   %eax
  801051:	68 74 29 80 00       	push   $0x802974
  801056:	6a 75                	push   $0x75
  801058:	68 85 29 80 00       	push   $0x802985
  80105d:	e8 43 f2 ff ff       	call   8002a5 <_panic>

00801062 <pgfault>:
{
  801062:	f3 0f 1e fb          	endbr32 
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	53                   	push   %ebx
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801070:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  801072:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  801075:	89 da                	mov    %ebx,%edx
  801077:	c1 ea 0c             	shr    $0xc,%edx
  80107a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  801081:	a8 01                	test   $0x1,%al
  801083:	74 7e                	je     801103 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  801085:	a8 02                	test   $0x2,%al
  801087:	0f 84 8a 00 00 00    	je     801117 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  80108d:	f6 c6 08             	test   $0x8,%dh
  801090:	0f 84 95 00 00 00    	je     80112b <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	6a 07                	push   $0x7
  80109b:	68 00 f0 7f 00       	push   $0x7ff000
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 d7 fc ff ff       	call   800d7e <sys_page_alloc>
	if (r)
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	0f 85 8d 00 00 00    	jne    80113f <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8010b2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8010b8:	83 ec 04             	sub    $0x4,%esp
  8010bb:	68 00 10 00 00       	push   $0x1000
  8010c0:	53                   	push   %ebx
  8010c1:	68 00 f0 7f 00       	push   $0x7ff000
  8010c6:	e8 49 fa ff ff       	call   800b14 <memcpy>
	r = sys_page_map(
  8010cb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010d2:	53                   	push   %ebx
  8010d3:	6a 00                	push   $0x0
  8010d5:	68 00 f0 7f 00       	push   $0x7ff000
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 c5 fc ff ff       	call   800da6 <sys_page_map>
	if (r)
  8010e1:	83 c4 20             	add    $0x20,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	75 69                	jne    801151 <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	68 00 f0 7f 00       	push   $0x7ff000
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 d9 fc ff ff       	call   800dd0 <sys_page_unmap>
	if (r)
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 65                	jne    801163 <pgfault+0x101>
}
  8010fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801101:	c9                   	leave  
  801102:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	68 24 2a 80 00       	push   $0x802a24
  80110b:	6a 20                	push   $0x20
  80110d:	68 85 29 80 00       	push   $0x802985
  801112:	e8 8e f1 ff ff       	call   8002a5 <_panic>
		panic("[pgfault] pgfault por lectura");
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	68 b6 29 80 00       	push   $0x8029b6
  80111f:	6a 23                	push   $0x23
  801121:	68 85 29 80 00       	push   $0x802985
  801126:	e8 7a f1 ff ff       	call   8002a5 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	68 50 2a 80 00       	push   $0x802a50
  801133:	6a 27                	push   $0x27
  801135:	68 85 29 80 00       	push   $0x802985
  80113a:	e8 66 f1 ff ff       	call   8002a5 <_panic>
		panic("pgfault: %e", r);
  80113f:	50                   	push   %eax
  801140:	68 d4 29 80 00       	push   $0x8029d4
  801145:	6a 32                	push   $0x32
  801147:	68 85 29 80 00       	push   $0x802985
  80114c:	e8 54 f1 ff ff       	call   8002a5 <_panic>
		panic("pgfault: %e", r);
  801151:	50                   	push   %eax
  801152:	68 d4 29 80 00       	push   $0x8029d4
  801157:	6a 39                	push   $0x39
  801159:	68 85 29 80 00       	push   $0x802985
  80115e:	e8 42 f1 ff ff       	call   8002a5 <_panic>
		panic("pgfault: %e", r);
  801163:	50                   	push   %eax
  801164:	68 d4 29 80 00       	push   $0x8029d4
  801169:	6a 3d                	push   $0x3d
  80116b:	68 85 29 80 00       	push   $0x802985
  801170:	e8 30 f1 ff ff       	call   8002a5 <_panic>

00801175 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  801175:	f3 0f 1e fb          	endbr32 
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801182:	b8 07 00 00 00       	mov    $0x7,%eax
  801187:	cd 30                	int    $0x30
  801189:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  80118b:	85 c0                	test   %eax,%eax
  80118d:	78 22                	js     8011b1 <fork_v0+0x3c>
  80118f:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801191:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801196:	75 52                	jne    8011ea <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801198:	e8 8e fb ff ff       	call   800d2b <sys_getenvid>
  80119d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011aa:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011af:	eb 6e                	jmp    80121f <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  8011b1:	50                   	push   %eax
  8011b2:	68 78 2a 80 00       	push   $0x802a78
  8011b7:	68 8a 00 00 00       	push   $0x8a
  8011bc:	68 85 29 80 00       	push   $0x802985
  8011c1:	e8 df f0 ff ff       	call   8002a5 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  8011c6:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  8011cd:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011d3:	89 da                	mov    %ebx,%edx
  8011d5:	89 f0                	mov    %esi,%eax
  8011d7:	e8 b9 fd ff ff       	call   800f95 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8011dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011e2:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011e8:	74 23                	je     80120d <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8011ea:	89 d8                	mov    %ebx,%eax
  8011ec:	c1 e8 16             	shr    $0x16,%eax
  8011ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f6:	a8 01                	test   $0x1,%al
  8011f8:	74 e2                	je     8011dc <fork_v0+0x67>
  8011fa:	89 d8                	mov    %ebx,%eax
  8011fc:	c1 e8 0c             	shr    $0xc,%eax
  8011ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801206:	f6 c2 01             	test   $0x1,%dl
  801209:	74 d1                	je     8011dc <fork_v0+0x67>
  80120b:	eb b9                	jmp    8011c6 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	6a 02                	push   $0x2
  801212:	57                   	push   %edi
  801213:	e8 df fb ff ff       	call   800df7 <sys_env_set_status>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 0a                	js     801229 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  80121f:	89 f8                	mov    %edi,%eax
  801221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  801229:	50                   	push   %eax
  80122a:	68 9c 2a 80 00       	push   $0x802a9c
  80122f:	68 98 00 00 00       	push   $0x98
  801234:	68 85 29 80 00       	push   $0x802985
  801239:	e8 67 f0 ff ff       	call   8002a5 <_panic>

0080123e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80123e:	f3 0f 1e fb          	endbr32 
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	57                   	push   %edi
  801246:	56                   	push   %esi
  801247:	53                   	push   %ebx
  801248:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  80124b:	68 62 10 80 00       	push   $0x801062
  801250:	e8 bd 0e 00 00       	call   802112 <set_pgfault_handler>
  801255:	b8 07 00 00 00       	mov    $0x7,%eax
  80125a:	cd 30                	int    $0x30
  80125c:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 37                	js     80129c <fork+0x5e>
  801265:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801267:	74 48                	je     8012b1 <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	6a 07                	push   $0x7
  80126e:	68 00 f0 bf ee       	push   $0xeebff000
  801273:	50                   	push   %eax
  801274:	e8 05 fb ff ff       	call   800d7e <sys_page_alloc>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 4d                	js     8012cd <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	68 8f 21 80 00       	push   $0x80218f
  801288:	56                   	push   %esi
  801289:	e8 b7 fb ff ff       	call   800e45 <sys_env_set_pgfault_upcall>
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	85 c0                	test   %eax,%eax
  801293:	78 4d                	js     8012e2 <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801295:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129a:	eb 70                	jmp    80130c <fork+0xce>
		panic("sys_exofork: %e", envid);
  80129c:	50                   	push   %eax
  80129d:	68 e0 29 80 00       	push   $0x8029e0
  8012a2:	68 b7 00 00 00       	push   $0xb7
  8012a7:	68 85 29 80 00       	push   $0x802985
  8012ac:	e8 f4 ef ff ff       	call   8002a5 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012b1:	e8 75 fa ff ff       	call   800d2b <sys_getenvid>
  8012b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012bb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8012c8:	e9 80 00 00 00       	jmp    80134d <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  8012cd:	50                   	push   %eax
  8012ce:	68 f0 29 80 00       	push   $0x8029f0
  8012d3:	68 c0 00 00 00       	push   $0xc0
  8012d8:	68 85 29 80 00       	push   $0x802985
  8012dd:	e8 c3 ef ff ff       	call   8002a5 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  8012e2:	50                   	push   %eax
  8012e3:	68 c0 2a 80 00       	push   $0x802ac0
  8012e8:	68 c3 00 00 00       	push   $0xc3
  8012ed:	68 85 29 80 00       	push   $0x802985
  8012f2:	e8 ae ef ff ff       	call   8002a5 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  8012f7:	89 f8                	mov    %edi,%eax
  8012f9:	e8 bd fb ff ff       	call   800ebb <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  8012fe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801304:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80130a:	74 2f                	je     80133b <fork+0xfd>
  80130c:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  80130e:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801314:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  801319:	76 e3                	jbe    8012fe <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80131b:	89 d8                	mov    %ebx,%eax
  80131d:	c1 e8 16             	shr    $0x16,%eax
  801320:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801327:	a8 01                	test   $0x1,%al
  801329:	74 d3                	je     8012fe <fork+0xc0>
  80132b:	c1 ea 0c             	shr    $0xc,%edx
  80132e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801335:	a8 01                	test   $0x1,%al
  801337:	74 c5                	je     8012fe <fork+0xc0>
  801339:	eb bc                	jmp    8012f7 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	6a 02                	push   $0x2
  801340:	56                   	push   %esi
  801341:	e8 b1 fa ff ff       	call   800df7 <sys_env_set_status>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 0a                	js     801357 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  80134d:	89 f0                	mov    %esi,%eax
  80134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801357:	50                   	push   %eax
  801358:	68 ec 2a 80 00       	push   $0x802aec
  80135d:	68 ce 00 00 00       	push   $0xce
  801362:	68 85 29 80 00       	push   $0x802985
  801367:	e8 39 ef ff ff       	call   8002a5 <_panic>

0080136c <sfork>:

// Challenge!
int
sfork(void)
{
  80136c:	f3 0f 1e fb          	endbr32 
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801376:	68 0e 2a 80 00       	push   $0x802a0e
  80137b:	68 d7 00 00 00       	push   $0xd7
  801380:	68 85 29 80 00       	push   $0x802985
  801385:	e8 1b ef ff ff       	call   8002a5 <_panic>

0080138a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80138a:	f3 0f 1e fb          	endbr32 
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	05 00 00 00 30       	add    $0x30000000,%eax
  801399:	c1 e8 0c             	shr    $0xc,%eax
}
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80139e:	f3 0f 1e fb          	endbr32 
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8013a8:	ff 75 08             	pushl  0x8(%ebp)
  8013ab:	e8 da ff ff ff       	call   80138a <fd2num>
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	c1 e0 0c             	shl    $0xc,%eax
  8013b6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013bd:	f3 0f 1e fb          	endbr32 
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	c1 ea 16             	shr    $0x16,%edx
  8013ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d5:	f6 c2 01             	test   $0x1,%dl
  8013d8:	74 2d                	je     801407 <fd_alloc+0x4a>
  8013da:	89 c2                	mov    %eax,%edx
  8013dc:	c1 ea 0c             	shr    $0xc,%edx
  8013df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e6:	f6 c2 01             	test   $0x1,%dl
  8013e9:	74 1c                	je     801407 <fd_alloc+0x4a>
  8013eb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013f0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f5:	75 d2                	jne    8013c9 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801400:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801405:	eb 0a                	jmp    801411 <fd_alloc+0x54>
			*fd_store = fd;
  801407:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801411:	5d                   	pop    %ebp
  801412:	c3                   	ret    

00801413 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801413:	f3 0f 1e fb          	endbr32 
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80141d:	83 f8 1f             	cmp    $0x1f,%eax
  801420:	77 30                	ja     801452 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801422:	c1 e0 0c             	shl    $0xc,%eax
  801425:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80142a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801430:	f6 c2 01             	test   $0x1,%dl
  801433:	74 24                	je     801459 <fd_lookup+0x46>
  801435:	89 c2                	mov    %eax,%edx
  801437:	c1 ea 0c             	shr    $0xc,%edx
  80143a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801441:	f6 c2 01             	test   $0x1,%dl
  801444:	74 1a                	je     801460 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801446:	8b 55 0c             	mov    0xc(%ebp),%edx
  801449:	89 02                	mov    %eax,(%edx)
	return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    
		return -E_INVAL;
  801452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801457:	eb f7                	jmp    801450 <fd_lookup+0x3d>
		return -E_INVAL;
  801459:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145e:	eb f0                	jmp    801450 <fd_lookup+0x3d>
  801460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801465:	eb e9                	jmp    801450 <fd_lookup+0x3d>

00801467 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801467:	f3 0f 1e fb          	endbr32 
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 08             	sub    $0x8,%esp
  801471:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801474:	ba 8c 2b 80 00       	mov    $0x802b8c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801479:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80147e:	39 08                	cmp    %ecx,(%eax)
  801480:	74 33                	je     8014b5 <dev_lookup+0x4e>
  801482:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801485:	8b 02                	mov    (%edx),%eax
  801487:	85 c0                	test   %eax,%eax
  801489:	75 f3                	jne    80147e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148b:	a1 04 40 80 00       	mov    0x804004,%eax
  801490:	8b 40 48             	mov    0x48(%eax),%eax
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	51                   	push   %ecx
  801497:	50                   	push   %eax
  801498:	68 10 2b 80 00       	push   $0x802b10
  80149d:	e8 ea ee ff ff       	call   80038c <cprintf>
	*dev = 0;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
			*dev = devtab[i];
  8014b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	eb f2                	jmp    8014b3 <dev_lookup+0x4c>

008014c1 <fd_close>:
{
  8014c1:	f3 0f 1e fb          	endbr32 
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 28             	sub    $0x28,%esp
  8014ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d4:	56                   	push   %esi
  8014d5:	e8 b0 fe ff ff       	call   80138a <fd2num>
  8014da:	83 c4 08             	add    $0x8,%esp
  8014dd:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	e8 2c ff ff ff       	call   801413 <fd_lookup>
  8014e7:	89 c3                	mov    %eax,%ebx
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 05                	js     8014f5 <fd_close+0x34>
	    || fd != fd2)
  8014f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f3:	74 16                	je     80150b <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014f5:	89 f8                	mov    %edi,%eax
  8014f7:	84 c0                	test   %al,%al
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fe:	0f 44 d8             	cmove  %eax,%ebx
}
  801501:	89 d8                	mov    %ebx,%eax
  801503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5f                   	pop    %edi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	ff 36                	pushl  (%esi)
  801514:	e8 4e ff ff ff       	call   801467 <dev_lookup>
  801519:	89 c3                	mov    %eax,%ebx
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 1a                	js     80153c <fd_close+0x7b>
		if (dev->dev_close)
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801528:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80152d:	85 c0                	test   %eax,%eax
  80152f:	74 0b                	je     80153c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	56                   	push   %esi
  801535:	ff d0                	call   *%eax
  801537:	89 c3                	mov    %eax,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	56                   	push   %esi
  801540:	6a 00                	push   $0x0
  801542:	e8 89 f8 ff ff       	call   800dd0 <sys_page_unmap>
	return r;
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	eb b5                	jmp    801501 <fd_close+0x40>

0080154c <close>:

int
close(int fdnum)
{
  80154c:	f3 0f 1e fb          	endbr32 
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801556:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	ff 75 08             	pushl  0x8(%ebp)
  80155d:	e8 b1 fe ff ff       	call   801413 <fd_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	79 02                	jns    80156b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    
		return fd_close(fd, 1);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	6a 01                	push   $0x1
  801570:	ff 75 f4             	pushl  -0xc(%ebp)
  801573:	e8 49 ff ff ff       	call   8014c1 <fd_close>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	eb ec                	jmp    801569 <close+0x1d>

0080157d <close_all>:

void
close_all(void)
{
  80157d:	f3 0f 1e fb          	endbr32 
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	53                   	push   %ebx
  801585:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801588:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	53                   	push   %ebx
  801591:	e8 b6 ff ff ff       	call   80154c <close>
	for (i = 0; i < MAXFD; i++)
  801596:	83 c3 01             	add    $0x1,%ebx
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	83 fb 20             	cmp    $0x20,%ebx
  80159f:	75 ec                	jne    80158d <close_all+0x10>
}
  8015a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	e8 54 fe ff ff       	call   801413 <fd_lookup>
  8015bf:	89 c3                	mov    %eax,%ebx
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	0f 88 81 00 00 00    	js     80164d <dup+0xa7>
		return r;
	close(newfdnum);
  8015cc:	83 ec 0c             	sub    $0xc,%esp
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	e8 75 ff ff ff       	call   80154c <close>

	newfd = INDEX2FD(newfdnum);
  8015d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015da:	c1 e6 0c             	shl    $0xc,%esi
  8015dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015e3:	83 c4 04             	add    $0x4,%esp
  8015e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015e9:	e8 b0 fd ff ff       	call   80139e <fd2data>
  8015ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015f0:	89 34 24             	mov    %esi,(%esp)
  8015f3:	e8 a6 fd ff ff       	call   80139e <fd2data>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015fd:	89 d8                	mov    %ebx,%eax
  8015ff:	c1 e8 16             	shr    $0x16,%eax
  801602:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801609:	a8 01                	test   $0x1,%al
  80160b:	74 11                	je     80161e <dup+0x78>
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	c1 e8 0c             	shr    $0xc,%eax
  801612:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801619:	f6 c2 01             	test   $0x1,%dl
  80161c:	75 39                	jne    801657 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80161e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801621:	89 d0                	mov    %edx,%eax
  801623:	c1 e8 0c             	shr    $0xc,%eax
  801626:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	25 07 0e 00 00       	and    $0xe07,%eax
  801635:	50                   	push   %eax
  801636:	56                   	push   %esi
  801637:	6a 00                	push   $0x0
  801639:	52                   	push   %edx
  80163a:	6a 00                	push   $0x0
  80163c:	e8 65 f7 ff ff       	call   800da6 <sys_page_map>
  801641:	89 c3                	mov    %eax,%ebx
  801643:	83 c4 20             	add    $0x20,%esp
  801646:	85 c0                	test   %eax,%eax
  801648:	78 31                	js     80167b <dup+0xd5>
		goto err;

	return newfdnum;
  80164a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80164d:	89 d8                	mov    %ebx,%eax
  80164f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801657:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	25 07 0e 00 00       	and    $0xe07,%eax
  801666:	50                   	push   %eax
  801667:	57                   	push   %edi
  801668:	6a 00                	push   $0x0
  80166a:	53                   	push   %ebx
  80166b:	6a 00                	push   $0x0
  80166d:	e8 34 f7 ff ff       	call   800da6 <sys_page_map>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	83 c4 20             	add    $0x20,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	79 a3                	jns    80161e <dup+0x78>
	sys_page_unmap(0, newfd);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	56                   	push   %esi
  80167f:	6a 00                	push   $0x0
  801681:	e8 4a f7 ff ff       	call   800dd0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801686:	83 c4 08             	add    $0x8,%esp
  801689:	57                   	push   %edi
  80168a:	6a 00                	push   $0x0
  80168c:	e8 3f f7 ff ff       	call   800dd0 <sys_page_unmap>
	return r;
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	eb b7                	jmp    80164d <dup+0xa7>

00801696 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801696:	f3 0f 1e fb          	endbr32 
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 1c             	sub    $0x1c,%esp
  8016a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	53                   	push   %ebx
  8016a9:	e8 65 fd ff ff       	call   801413 <fd_lookup>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 3f                	js     8016f4 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bf:	ff 30                	pushl  (%eax)
  8016c1:	e8 a1 fd ff ff       	call   801467 <dev_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 27                	js     8016f4 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d0:	8b 42 08             	mov    0x8(%edx),%eax
  8016d3:	83 e0 03             	and    $0x3,%eax
  8016d6:	83 f8 01             	cmp    $0x1,%eax
  8016d9:	74 1e                	je     8016f9 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016de:	8b 40 08             	mov    0x8(%eax),%eax
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	74 35                	je     80171a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	ff 75 10             	pushl  0x10(%ebp)
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	52                   	push   %edx
  8016ef:	ff d0                	call   *%eax
  8016f1:	83 c4 10             	add    $0x10,%esp
}
  8016f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8016fe:	8b 40 48             	mov    0x48(%eax),%eax
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	53                   	push   %ebx
  801705:	50                   	push   %eax
  801706:	68 51 2b 80 00       	push   $0x802b51
  80170b:	e8 7c ec ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801718:	eb da                	jmp    8016f4 <read+0x5e>
		return -E_NOT_SUPP;
  80171a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171f:	eb d3                	jmp    8016f4 <read+0x5e>

00801721 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801721:	f3 0f 1e fb          	endbr32 
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	57                   	push   %edi
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801731:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801734:	bb 00 00 00 00       	mov    $0x0,%ebx
  801739:	eb 02                	jmp    80173d <readn+0x1c>
  80173b:	01 c3                	add    %eax,%ebx
  80173d:	39 f3                	cmp    %esi,%ebx
  80173f:	73 21                	jae    801762 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	89 f0                	mov    %esi,%eax
  801746:	29 d8                	sub    %ebx,%eax
  801748:	50                   	push   %eax
  801749:	89 d8                	mov    %ebx,%eax
  80174b:	03 45 0c             	add    0xc(%ebp),%eax
  80174e:	50                   	push   %eax
  80174f:	57                   	push   %edi
  801750:	e8 41 ff ff ff       	call   801696 <read>
		if (m < 0)
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 04                	js     801760 <readn+0x3f>
			return m;
		if (m == 0)
  80175c:	75 dd                	jne    80173b <readn+0x1a>
  80175e:	eb 02                	jmp    801762 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801760:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801762:	89 d8                	mov    %ebx,%eax
  801764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80176c:	f3 0f 1e fb          	endbr32 
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	53                   	push   %ebx
  801774:	83 ec 1c             	sub    $0x1c,%esp
  801777:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	53                   	push   %ebx
  80177f:	e8 8f fc ff ff       	call   801413 <fd_lookup>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	85 c0                	test   %eax,%eax
  801789:	78 3a                	js     8017c5 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	ff 30                	pushl  (%eax)
  801797:	e8 cb fc ff ff       	call   801467 <dev_lookup>
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	78 22                	js     8017c5 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017aa:	74 1e                	je     8017ca <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017af:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b2:	85 d2                	test   %edx,%edx
  8017b4:	74 35                	je     8017eb <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	ff 75 10             	pushl  0x10(%ebp)
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	ff d2                	call   *%edx
  8017c2:	83 c4 10             	add    $0x10,%esp
}
  8017c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8017cf:	8b 40 48             	mov    0x48(%eax),%eax
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	53                   	push   %ebx
  8017d6:	50                   	push   %eax
  8017d7:	68 6d 2b 80 00       	push   $0x802b6d
  8017dc:	e8 ab eb ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e9:	eb da                	jmp    8017c5 <write+0x59>
		return -E_NOT_SUPP;
  8017eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f0:	eb d3                	jmp    8017c5 <write+0x59>

008017f2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017f2:	f3 0f 1e fb          	endbr32 
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	e8 0b fc ff ff       	call   801413 <fd_lookup>
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	78 0e                	js     80181d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801815:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80181f:	f3 0f 1e fb          	endbr32 
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	53                   	push   %ebx
  801827:	83 ec 1c             	sub    $0x1c,%esp
  80182a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801830:	50                   	push   %eax
  801831:	53                   	push   %ebx
  801832:	e8 dc fb ff ff       	call   801413 <fd_lookup>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 37                	js     801875 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801844:	50                   	push   %eax
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801848:	ff 30                	pushl  (%eax)
  80184a:	e8 18 fc ff ff       	call   801467 <dev_lookup>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 1f                	js     801875 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80185d:	74 1b                	je     80187a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80185f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801862:	8b 52 18             	mov    0x18(%edx),%edx
  801865:	85 d2                	test   %edx,%edx
  801867:	74 32                	je     80189b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	50                   	push   %eax
  801870:	ff d2                	call   *%edx
  801872:	83 c4 10             	add    $0x10,%esp
}
  801875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801878:	c9                   	leave  
  801879:	c3                   	ret    
			thisenv->env_id, fdnum);
  80187a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80187f:	8b 40 48             	mov    0x48(%eax),%eax
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	53                   	push   %ebx
  801886:	50                   	push   %eax
  801887:	68 30 2b 80 00       	push   $0x802b30
  80188c:	e8 fb ea ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801899:	eb da                	jmp    801875 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80189b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a0:	eb d3                	jmp    801875 <ftruncate+0x56>

008018a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a2:	f3 0f 1e fb          	endbr32 
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 1c             	sub    $0x1c,%esp
  8018ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b3:	50                   	push   %eax
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 57 fb ff ff       	call   801413 <fd_lookup>
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 4b                	js     80190e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c9:	50                   	push   %eax
  8018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cd:	ff 30                	pushl  (%eax)
  8018cf:	e8 93 fb ff ff       	call   801467 <dev_lookup>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 33                	js     80190e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018de:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e2:	74 2f                	je     801913 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018e7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ee:	00 00 00 
	stat->st_isdir = 0;
  8018f1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018f8:	00 00 00 
	stat->st_dev = dev;
  8018fb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	53                   	push   %ebx
  801905:	ff 75 f0             	pushl  -0x10(%ebp)
  801908:	ff 50 14             	call   *0x14(%eax)
  80190b:	83 c4 10             	add    $0x10,%esp
}
  80190e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801911:	c9                   	leave  
  801912:	c3                   	ret    
		return -E_NOT_SUPP;
  801913:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801918:	eb f4                	jmp    80190e <fstat+0x6c>

0080191a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191a:	f3 0f 1e fb          	endbr32 
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	56                   	push   %esi
  801922:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	6a 00                	push   $0x0
  801928:	ff 75 08             	pushl  0x8(%ebp)
  80192b:	e8 3a 02 00 00       	call   801b6a <open>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	78 1b                	js     801954 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	50                   	push   %eax
  801940:	e8 5d ff ff ff       	call   8018a2 <fstat>
  801945:	89 c6                	mov    %eax,%esi
	close(fd);
  801947:	89 1c 24             	mov    %ebx,(%esp)
  80194a:	e8 fd fb ff ff       	call   80154c <close>
	return r;
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	89 f3                	mov    %esi,%ebx
}
  801954:	89 d8                	mov    %ebx,%eax
  801956:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	89 c6                	mov    %eax,%esi
  801964:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801966:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80196d:	74 27                	je     801996 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80196f:	6a 07                	push   $0x7
  801971:	68 00 50 80 00       	push   $0x805000
  801976:	56                   	push   %esi
  801977:	ff 35 00 40 80 00    	pushl  0x804000
  80197d:	e8 a0 08 00 00       	call   802222 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801982:	83 c4 0c             	add    $0xc,%esp
  801985:	6a 00                	push   $0x0
  801987:	53                   	push   %ebx
  801988:	6a 00                	push   $0x0
  80198a:	e8 26 08 00 00       	call   8021b5 <ipc_recv>
}
  80198f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	6a 01                	push   $0x1
  80199b:	e8 da 08 00 00       	call   80227a <ipc_find_env>
  8019a0:	a3 00 40 80 00       	mov    %eax,0x804000
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	eb c5                	jmp    80196f <fsipc+0x12>

008019aa <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019aa:	f3 0f 1e fb          	endbr32 
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ba:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cc:	b8 02 00 00 00       	mov    $0x2,%eax
  8019d1:	e8 87 ff ff ff       	call   80195d <fsipc>
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <devfile_flush>:
{
  8019d8:	f3 0f 1e fb          	endbr32 
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8019f7:	e8 61 ff ff ff       	call   80195d <fsipc>
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <devfile_stat>:
{
  8019fe:	f3 0f 1e fb          	endbr32 
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	53                   	push   %ebx
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a12:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a17:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1c:	b8 05 00 00 00       	mov    $0x5,%eax
  801a21:	e8 37 ff ff ff       	call   80195d <fsipc>
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 2c                	js     801a56 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	68 00 50 80 00       	push   $0x805000
  801a32:	53                   	push   %ebx
  801a33:	e8 be ee ff ff       	call   8008f6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a38:	a1 80 50 80 00       	mov    0x805080,%eax
  801a3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a43:	a1 84 50 80 00       	mov    0x805084,%eax
  801a48:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <devfile_write>:
{
  801a5b:	f3 0f 1e fb          	endbr32 
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	53                   	push   %ebx
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a74:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a7a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a80:	77 30                	ja     801ab2 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	53                   	push   %ebx
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	68 08 50 80 00       	push   $0x805008
  801a8e:	e8 1b f0 ff ff       	call   800aae <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a93:	ba 00 00 00 00       	mov    $0x0,%edx
  801a98:	b8 04 00 00 00       	mov    $0x4,%eax
  801a9d:	e8 bb fe ff ff       	call   80195d <fsipc>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 04                	js     801aad <devfile_write+0x52>
	assert(r <= n);
  801aa9:	39 d8                	cmp    %ebx,%eax
  801aab:	77 1e                	ja     801acb <devfile_write+0x70>
}
  801aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801ab2:	68 9c 2b 80 00       	push   $0x802b9c
  801ab7:	68 c9 2b 80 00       	push   $0x802bc9
  801abc:	68 94 00 00 00       	push   $0x94
  801ac1:	68 de 2b 80 00       	push   $0x802bde
  801ac6:	e8 da e7 ff ff       	call   8002a5 <_panic>
	assert(r <= n);
  801acb:	68 e9 2b 80 00       	push   $0x802be9
  801ad0:	68 c9 2b 80 00       	push   $0x802bc9
  801ad5:	68 98 00 00 00       	push   $0x98
  801ada:	68 de 2b 80 00       	push   $0x802bde
  801adf:	e8 c1 e7 ff ff       	call   8002a5 <_panic>

00801ae4 <devfile_read>:
{
  801ae4:	f3 0f 1e fb          	endbr32 
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	56                   	push   %esi
  801aec:	53                   	push   %ebx
  801aed:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	8b 40 0c             	mov    0xc(%eax),%eax
  801af6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801afb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b01:	ba 00 00 00 00       	mov    $0x0,%edx
  801b06:	b8 03 00 00 00       	mov    $0x3,%eax
  801b0b:	e8 4d fe ff ff       	call   80195d <fsipc>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 1f                	js     801b35 <devfile_read+0x51>
	assert(r <= n);
  801b16:	39 f0                	cmp    %esi,%eax
  801b18:	77 24                	ja     801b3e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b1f:	7f 33                	jg     801b54 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	50                   	push   %eax
  801b25:	68 00 50 80 00       	push   $0x805000
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	e8 7c ef ff ff       	call   800aae <memmove>
	return r;
  801b32:	83 c4 10             	add    $0x10,%esp
}
  801b35:	89 d8                	mov    %ebx,%eax
  801b37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    
	assert(r <= n);
  801b3e:	68 e9 2b 80 00       	push   $0x802be9
  801b43:	68 c9 2b 80 00       	push   $0x802bc9
  801b48:	6a 7c                	push   $0x7c
  801b4a:	68 de 2b 80 00       	push   $0x802bde
  801b4f:	e8 51 e7 ff ff       	call   8002a5 <_panic>
	assert(r <= PGSIZE);
  801b54:	68 f0 2b 80 00       	push   $0x802bf0
  801b59:	68 c9 2b 80 00       	push   $0x802bc9
  801b5e:	6a 7d                	push   $0x7d
  801b60:	68 de 2b 80 00       	push   $0x802bde
  801b65:	e8 3b e7 ff ff       	call   8002a5 <_panic>

00801b6a <open>:
{
  801b6a:	f3 0f 1e fb          	endbr32 
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 1c             	sub    $0x1c,%esp
  801b76:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b79:	56                   	push   %esi
  801b7a:	e8 34 ed ff ff       	call   8008b3 <strlen>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b87:	7f 6c                	jg     801bf5 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b89:	83 ec 0c             	sub    $0xc,%esp
  801b8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8f:	50                   	push   %eax
  801b90:	e8 28 f8 ff ff       	call   8013bd <fd_alloc>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 3c                	js     801bda <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	56                   	push   %esi
  801ba2:	68 00 50 80 00       	push   $0x805000
  801ba7:	e8 4a ed ff ff       	call   8008f6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbc:	e8 9c fd ff ff       	call   80195d <fsipc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 19                	js     801be3 <open+0x79>
	return fd2num(fd);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd0:	e8 b5 f7 ff ff       	call   80138a <fd2num>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
}
  801bda:	89 d8                	mov    %ebx,%eax
  801bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
		fd_close(fd, 0);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 f4             	pushl  -0xc(%ebp)
  801beb:	e8 d1 f8 ff ff       	call   8014c1 <fd_close>
		return r;
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	eb e5                	jmp    801bda <open+0x70>
		return -E_BAD_PATH;
  801bf5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bfa:	eb de                	jmp    801bda <open+0x70>

00801bfc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bfc:	f3 0f 1e fb          	endbr32 
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c06:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c10:	e8 48 fd ff ff       	call   80195d <fsipc>
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c17:	f3 0f 1e fb          	endbr32 
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c23:	83 ec 0c             	sub    $0xc,%esp
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	e8 70 f7 ff ff       	call   80139e <fd2data>
  801c2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c30:	83 c4 08             	add    $0x8,%esp
  801c33:	68 fc 2b 80 00       	push   $0x802bfc
  801c38:	53                   	push   %ebx
  801c39:	e8 b8 ec ff ff       	call   8008f6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c3e:	8b 46 04             	mov    0x4(%esi),%eax
  801c41:	2b 06                	sub    (%esi),%eax
  801c43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c49:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c50:	00 00 00 
	stat->st_dev = &devpipe;
  801c53:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c5a:	30 80 00 
	return 0;
}
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c69:	f3 0f 1e fb          	endbr32 
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c77:	53                   	push   %ebx
  801c78:	6a 00                	push   $0x0
  801c7a:	e8 51 f1 ff ff       	call   800dd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c7f:	89 1c 24             	mov    %ebx,(%esp)
  801c82:	e8 17 f7 ff ff       	call   80139e <fd2data>
  801c87:	83 c4 08             	add    $0x8,%esp
  801c8a:	50                   	push   %eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 3e f1 ff ff       	call   800dd0 <sys_page_unmap>
}
  801c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <_pipeisclosed>:
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	57                   	push   %edi
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 1c             	sub    $0x1c,%esp
  801ca0:	89 c7                	mov    %eax,%edi
  801ca2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ca4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	57                   	push   %edi
  801cb0:	e8 02 06 00 00       	call   8022b7 <pageref>
  801cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cb8:	89 34 24             	mov    %esi,(%esp)
  801cbb:	e8 f7 05 00 00       	call   8022b7 <pageref>
		nn = thisenv->env_runs;
  801cc0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cc6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cc9:	83 c4 10             	add    $0x10,%esp
  801ccc:	39 cb                	cmp    %ecx,%ebx
  801cce:	74 1b                	je     801ceb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cd3:	75 cf                	jne    801ca4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cd5:	8b 42 58             	mov    0x58(%edx),%eax
  801cd8:	6a 01                	push   $0x1
  801cda:	50                   	push   %eax
  801cdb:	53                   	push   %ebx
  801cdc:	68 03 2c 80 00       	push   $0x802c03
  801ce1:	e8 a6 e6 ff ff       	call   80038c <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	eb b9                	jmp    801ca4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ceb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cee:	0f 94 c0             	sete   %al
  801cf1:	0f b6 c0             	movzbl %al,%eax
}
  801cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    

00801cfc <devpipe_write>:
{
  801cfc:	f3 0f 1e fb          	endbr32 
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	57                   	push   %edi
  801d04:	56                   	push   %esi
  801d05:	53                   	push   %ebx
  801d06:	83 ec 28             	sub    $0x28,%esp
  801d09:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d0c:	56                   	push   %esi
  801d0d:	e8 8c f6 ff ff       	call   80139e <fd2data>
  801d12:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d1f:	74 4f                	je     801d70 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d21:	8b 43 04             	mov    0x4(%ebx),%eax
  801d24:	8b 0b                	mov    (%ebx),%ecx
  801d26:	8d 51 20             	lea    0x20(%ecx),%edx
  801d29:	39 d0                	cmp    %edx,%eax
  801d2b:	72 14                	jb     801d41 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d2d:	89 da                	mov    %ebx,%edx
  801d2f:	89 f0                	mov    %esi,%eax
  801d31:	e8 61 ff ff ff       	call   801c97 <_pipeisclosed>
  801d36:	85 c0                	test   %eax,%eax
  801d38:	75 3b                	jne    801d75 <devpipe_write+0x79>
			sys_yield();
  801d3a:	e8 14 f0 ff ff       	call   800d53 <sys_yield>
  801d3f:	eb e0                	jmp    801d21 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d44:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d48:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d4b:	89 c2                	mov    %eax,%edx
  801d4d:	c1 fa 1f             	sar    $0x1f,%edx
  801d50:	89 d1                	mov    %edx,%ecx
  801d52:	c1 e9 1b             	shr    $0x1b,%ecx
  801d55:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d58:	83 e2 1f             	and    $0x1f,%edx
  801d5b:	29 ca                	sub    %ecx,%edx
  801d5d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d61:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d65:	83 c0 01             	add    $0x1,%eax
  801d68:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d6b:	83 c7 01             	add    $0x1,%edi
  801d6e:	eb ac                	jmp    801d1c <devpipe_write+0x20>
	return i;
  801d70:	8b 45 10             	mov    0x10(%ebp),%eax
  801d73:	eb 05                	jmp    801d7a <devpipe_write+0x7e>
				return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5f                   	pop    %edi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <devpipe_read>:
{
  801d82:	f3 0f 1e fb          	endbr32 
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	57                   	push   %edi
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	83 ec 18             	sub    $0x18,%esp
  801d8f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d92:	57                   	push   %edi
  801d93:	e8 06 f6 ff ff       	call   80139e <fd2data>
  801d98:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	be 00 00 00 00       	mov    $0x0,%esi
  801da2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da5:	75 14                	jne    801dbb <devpipe_read+0x39>
	return i;
  801da7:	8b 45 10             	mov    0x10(%ebp),%eax
  801daa:	eb 02                	jmp    801dae <devpipe_read+0x2c>
				return i;
  801dac:	89 f0                	mov    %esi,%eax
}
  801dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5f                   	pop    %edi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
			sys_yield();
  801db6:	e8 98 ef ff ff       	call   800d53 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dbb:	8b 03                	mov    (%ebx),%eax
  801dbd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dc0:	75 18                	jne    801dda <devpipe_read+0x58>
			if (i > 0)
  801dc2:	85 f6                	test   %esi,%esi
  801dc4:	75 e6                	jne    801dac <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801dc6:	89 da                	mov    %ebx,%edx
  801dc8:	89 f8                	mov    %edi,%eax
  801dca:	e8 c8 fe ff ff       	call   801c97 <_pipeisclosed>
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	74 e3                	je     801db6 <devpipe_read+0x34>
				return 0;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	eb d4                	jmp    801dae <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dda:	99                   	cltd   
  801ddb:	c1 ea 1b             	shr    $0x1b,%edx
  801dde:	01 d0                	add    %edx,%eax
  801de0:	83 e0 1f             	and    $0x1f,%eax
  801de3:	29 d0                	sub    %edx,%eax
  801de5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ded:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801df0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801df3:	83 c6 01             	add    $0x1,%esi
  801df6:	eb aa                	jmp    801da2 <devpipe_read+0x20>

00801df8 <pipe>:
{
  801df8:	f3 0f 1e fb          	endbr32 
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	56                   	push   %esi
  801e00:	53                   	push   %ebx
  801e01:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e07:	50                   	push   %eax
  801e08:	e8 b0 f5 ff ff       	call   8013bd <fd_alloc>
  801e0d:	89 c3                	mov    %eax,%ebx
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	85 c0                	test   %eax,%eax
  801e14:	0f 88 23 01 00 00    	js     801f3d <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 07 04 00 00       	push   $0x407
  801e22:	ff 75 f4             	pushl  -0xc(%ebp)
  801e25:	6a 00                	push   $0x0
  801e27:	e8 52 ef ff ff       	call   800d7e <sys_page_alloc>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	0f 88 04 01 00 00    	js     801f3d <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	e8 78 f5 ff ff       	call   8013bd <fd_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	0f 88 db 00 00 00    	js     801f2d <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	68 07 04 00 00       	push   $0x407
  801e5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5d:	6a 00                	push   $0x0
  801e5f:	e8 1a ef ff ff       	call   800d7e <sys_page_alloc>
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	0f 88 bc 00 00 00    	js     801f2d <pipe+0x135>
	va = fd2data(fd0);
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	ff 75 f4             	pushl  -0xc(%ebp)
  801e77:	e8 22 f5 ff ff       	call   80139e <fd2data>
  801e7c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7e:	83 c4 0c             	add    $0xc,%esp
  801e81:	68 07 04 00 00       	push   $0x407
  801e86:	50                   	push   %eax
  801e87:	6a 00                	push   $0x0
  801e89:	e8 f0 ee ff ff       	call   800d7e <sys_page_alloc>
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	85 c0                	test   %eax,%eax
  801e95:	0f 88 82 00 00 00    	js     801f1d <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea1:	e8 f8 f4 ff ff       	call   80139e <fd2data>
  801ea6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ead:	50                   	push   %eax
  801eae:	6a 00                	push   $0x0
  801eb0:	56                   	push   %esi
  801eb1:	6a 00                	push   $0x0
  801eb3:	e8 ee ee ff ff       	call   800da6 <sys_page_map>
  801eb8:	89 c3                	mov    %eax,%ebx
  801eba:	83 c4 20             	add    $0x20,%esp
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 4e                	js     801f0f <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ec1:	a1 20 30 80 00       	mov    0x803020,%eax
  801ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ece:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ed5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eea:	e8 9b f4 ff ff       	call   80138a <fd2num>
  801eef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ef4:	83 c4 04             	add    $0x4,%esp
  801ef7:	ff 75 f0             	pushl  -0x10(%ebp)
  801efa:	e8 8b f4 ff ff       	call   80138a <fd2num>
  801eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f02:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0d:	eb 2e                	jmp    801f3d <pipe+0x145>
	sys_page_unmap(0, va);
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	56                   	push   %esi
  801f13:	6a 00                	push   $0x0
  801f15:	e8 b6 ee ff ff       	call   800dd0 <sys_page_unmap>
  801f1a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	ff 75 f0             	pushl  -0x10(%ebp)
  801f23:	6a 00                	push   $0x0
  801f25:	e8 a6 ee ff ff       	call   800dd0 <sys_page_unmap>
  801f2a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f2d:	83 ec 08             	sub    $0x8,%esp
  801f30:	ff 75 f4             	pushl  -0xc(%ebp)
  801f33:	6a 00                	push   $0x0
  801f35:	e8 96 ee ff ff       	call   800dd0 <sys_page_unmap>
  801f3a:	83 c4 10             	add    $0x10,%esp
}
  801f3d:	89 d8                	mov    %ebx,%eax
  801f3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f42:	5b                   	pop    %ebx
  801f43:	5e                   	pop    %esi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    

00801f46 <pipeisclosed>:
{
  801f46:	f3 0f 1e fb          	endbr32 
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f53:	50                   	push   %eax
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	e8 b7 f4 ff ff       	call   801413 <fd_lookup>
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 18                	js     801f7b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	ff 75 f4             	pushl  -0xc(%ebp)
  801f69:	e8 30 f4 ff ff       	call   80139e <fd2data>
  801f6e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	e8 1f fd ff ff       	call   801c97 <_pipeisclosed>
  801f78:	83 c4 10             	add    $0x10,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f7d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	c3                   	ret    

00801f87 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f87:	f3 0f 1e fb          	endbr32 
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f91:	68 16 2c 80 00       	push   $0x802c16
  801f96:	ff 75 0c             	pushl  0xc(%ebp)
  801f99:	e8 58 e9 ff ff       	call   8008f6 <strcpy>
	return 0;
}
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <devcons_write>:
{
  801fa5:	f3 0f 1e fb          	endbr32 
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	57                   	push   %edi
  801fad:	56                   	push   %esi
  801fae:	53                   	push   %ebx
  801faf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fb5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fba:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc3:	73 31                	jae    801ff6 <devcons_write+0x51>
		m = n - tot;
  801fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fc8:	29 f3                	sub    %esi,%ebx
  801fca:	83 fb 7f             	cmp    $0x7f,%ebx
  801fcd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fd2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	53                   	push   %ebx
  801fd9:	89 f0                	mov    %esi,%eax
  801fdb:	03 45 0c             	add    0xc(%ebp),%eax
  801fde:	50                   	push   %eax
  801fdf:	57                   	push   %edi
  801fe0:	e8 c9 ea ff ff       	call   800aae <memmove>
		sys_cputs(buf, m);
  801fe5:	83 c4 08             	add    $0x8,%esp
  801fe8:	53                   	push   %ebx
  801fe9:	57                   	push   %edi
  801fea:	e8 c4 ec ff ff       	call   800cb3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fef:	01 de                	add    %ebx,%esi
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	eb ca                	jmp    801fc0 <devcons_write+0x1b>
}
  801ff6:	89 f0                	mov    %esi,%eax
  801ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <devcons_read>:
{
  802000:	f3 0f 1e fb          	endbr32 
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80200f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802013:	74 21                	je     802036 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802015:	e8 c3 ec ff ff       	call   800cdd <sys_cgetc>
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 07                	jne    802025 <devcons_read+0x25>
		sys_yield();
  80201e:	e8 30 ed ff ff       	call   800d53 <sys_yield>
  802023:	eb f0                	jmp    802015 <devcons_read+0x15>
	if (c < 0)
  802025:	78 0f                	js     802036 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802027:	83 f8 04             	cmp    $0x4,%eax
  80202a:	74 0c                	je     802038 <devcons_read+0x38>
	*(char*)vbuf = c;
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	88 02                	mov    %al,(%edx)
	return 1;
  802031:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    
		return 0;
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
  80203d:	eb f7                	jmp    802036 <devcons_read+0x36>

0080203f <cputchar>:
{
  80203f:	f3 0f 1e fb          	endbr32 
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80204f:	6a 01                	push   $0x1
  802051:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802054:	50                   	push   %eax
  802055:	e8 59 ec ff ff       	call   800cb3 <sys_cputs>
}
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <getchar>:
{
  80205f:	f3 0f 1e fb          	endbr32 
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802069:	6a 01                	push   $0x1
  80206b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80206e:	50                   	push   %eax
  80206f:	6a 00                	push   $0x0
  802071:	e8 20 f6 ff ff       	call   801696 <read>
	if (r < 0)
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 06                	js     802083 <getchar+0x24>
	if (r < 1)
  80207d:	74 06                	je     802085 <getchar+0x26>
	return c;
  80207f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    
		return -E_EOF;
  802085:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80208a:	eb f7                	jmp    802083 <getchar+0x24>

0080208c <iscons>:
{
  80208c:	f3 0f 1e fb          	endbr32 
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802099:	50                   	push   %eax
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	e8 71 f3 ff ff       	call   801413 <fd_lookup>
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 11                	js     8020ba <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020b2:	39 10                	cmp    %edx,(%eax)
  8020b4:	0f 94 c0             	sete   %al
  8020b7:	0f b6 c0             	movzbl %al,%eax
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <opencons>:
{
  8020bc:	f3 0f 1e fb          	endbr32 
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c9:	50                   	push   %eax
  8020ca:	e8 ee f2 ff ff       	call   8013bd <fd_alloc>
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	78 3a                	js     802110 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	68 07 04 00 00       	push   $0x407
  8020de:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e1:	6a 00                	push   $0x0
  8020e3:	e8 96 ec ff ff       	call   800d7e <sys_page_alloc>
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 21                	js     802110 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020f8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	50                   	push   %eax
  802108:	e8 7d f2 ff ff       	call   80138a <fd2num>
  80210d:	83 c4 10             	add    $0x10,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802112:	f3 0f 1e fb          	endbr32 
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80211c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802123:	74 0a                	je     80212f <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  80212f:	a1 04 40 80 00       	mov    0x804004,%eax
  802134:	8b 40 48             	mov    0x48(%eax),%eax
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	6a 07                	push   $0x7
  80213c:	68 00 f0 bf ee       	push   $0xeebff000
  802141:	50                   	push   %eax
  802142:	e8 37 ec ff ff       	call   800d7e <sys_page_alloc>
		if (r!= 0)
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	85 c0                	test   %eax,%eax
  80214c:	75 2f                	jne    80217d <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80214e:	a1 04 40 80 00       	mov    0x804004,%eax
  802153:	8b 40 48             	mov    0x48(%eax),%eax
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	68 8f 21 80 00       	push   $0x80218f
  80215e:	50                   	push   %eax
  80215f:	e8 e1 ec ff ff       	call   800e45 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	74 ba                	je     802125 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  80216b:	50                   	push   %eax
  80216c:	68 22 2c 80 00       	push   $0x802c22
  802171:	6a 26                	push   $0x26
  802173:	68 3a 2c 80 00       	push   $0x802c3a
  802178:	e8 28 e1 ff ff       	call   8002a5 <_panic>
			panic("set_pgfault_handler: %e", r);
  80217d:	50                   	push   %eax
  80217e:	68 22 2c 80 00       	push   $0x802c22
  802183:	6a 22                	push   $0x22
  802185:	68 3a 2c 80 00       	push   $0x802c3a
  80218a:	e8 16 e1 ff ff       	call   8002a5 <_panic>

0080218f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80218f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802190:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802195:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802197:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  80219a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80219e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  8021a1:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  8021a5:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  8021a9:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8021ab:	83 c4 08             	add    $0x8,%esp
	popal
  8021ae:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  8021af:	83 c4 04             	add    $0x4,%esp
	popfl
  8021b2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8021b3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8021b4:	c3                   	ret    

008021b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b5:	f3 0f 1e fb          	endbr32 
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	56                   	push   %esi
  8021bd:	53                   	push   %ebx
  8021be:	8b 75 08             	mov    0x8(%ebp),%esi
  8021c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ce:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	50                   	push   %eax
  8021d5:	e8 bb ec ff ff       	call   800e95 <sys_ipc_recv>
	if (r < 0) {
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 2b                	js     80220c <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8021e1:	85 f6                	test   %esi,%esi
  8021e3:	74 0a                	je     8021ef <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8021e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ea:	8b 40 74             	mov    0x74(%eax),%eax
  8021ed:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8021ef:	85 db                	test   %ebx,%ebx
  8021f1:	74 0a                	je     8021fd <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8021f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8021f8:	8b 40 78             	mov    0x78(%eax),%eax
  8021fb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021fd:	a1 04 40 80 00       	mov    0x804004,%eax
  802202:	8b 40 70             	mov    0x70(%eax),%eax
}
  802205:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802208:	5b                   	pop    %ebx
  802209:	5e                   	pop    %esi
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    
		if (from_env_store) {
  80220c:	85 f6                	test   %esi,%esi
  80220e:	74 06                	je     802216 <ipc_recv+0x61>
			*from_env_store = 0;
  802210:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  802216:	85 db                	test   %ebx,%ebx
  802218:	74 eb                	je     802205 <ipc_recv+0x50>
			*perm_store = 0;
  80221a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802220:	eb e3                	jmp    802205 <ipc_recv+0x50>

00802222 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802222:	f3 0f 1e fb          	endbr32 
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802232:	8b 75 0c             	mov    0xc(%ebp),%esi
  802235:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  802238:	85 db                	test   %ebx,%ebx
  80223a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80223f:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802242:	ff 75 14             	pushl  0x14(%ebp)
  802245:	53                   	push   %ebx
  802246:	56                   	push   %esi
  802247:	57                   	push   %edi
  802248:	e8 1f ec ff ff       	call   800e6c <sys_ipc_try_send>
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802253:	75 07                	jne    80225c <ipc_send+0x3a>
		sys_yield();
  802255:	e8 f9 ea ff ff       	call   800d53 <sys_yield>
  80225a:	eb e6                	jmp    802242 <ipc_send+0x20>
	}

	if (ret < 0) {
  80225c:	85 c0                	test   %eax,%eax
  80225e:	78 08                	js     802268 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802268:	50                   	push   %eax
  802269:	68 48 2c 80 00       	push   $0x802c48
  80226e:	6a 48                	push   $0x48
  802270:	68 65 2c 80 00       	push   $0x802c65
  802275:	e8 2b e0 ff ff       	call   8002a5 <_panic>

0080227a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80227a:	f3 0f 1e fb          	endbr32 
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802289:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80228c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802292:	8b 52 50             	mov    0x50(%edx),%edx
  802295:	39 ca                	cmp    %ecx,%edx
  802297:	74 11                	je     8022aa <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802299:	83 c0 01             	add    $0x1,%eax
  80229c:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022a1:	75 e6                	jne    802289 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	eb 0b                	jmp    8022b5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022b2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    

008022b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b7:	f3 0f 1e fb          	endbr32 
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022c1:	89 c2                	mov    %eax,%edx
  8022c3:	c1 ea 16             	shr    $0x16,%edx
  8022c6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022cd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022d2:	f6 c1 01             	test   $0x1,%cl
  8022d5:	74 1c                	je     8022f3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022d7:	c1 e8 0c             	shr    $0xc,%eax
  8022da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022e1:	a8 01                	test   $0x1,%al
  8022e3:	74 0e                	je     8022f3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022e5:	c1 e8 0c             	shr    $0xc,%eax
  8022e8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022ef:	ef 
  8022f0:	0f b7 d2             	movzwl %dx,%edx
}
  8022f3:	89 d0                	mov    %edx,%eax
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    
  8022f7:	66 90                	xchg   %ax,%ax
  8022f9:	66 90                	xchg   %ax,%ax
  8022fb:	66 90                	xchg   %ax,%ax
  8022fd:	66 90                	xchg   %ax,%ax
  8022ff:	90                   	nop

00802300 <__udivdi3>:
  802300:	f3 0f 1e fb          	endbr32 
  802304:	55                   	push   %ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 1c             	sub    $0x1c,%esp
  80230b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802313:	8b 74 24 34          	mov    0x34(%esp),%esi
  802317:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80231b:	85 d2                	test   %edx,%edx
  80231d:	75 19                	jne    802338 <__udivdi3+0x38>
  80231f:	39 f3                	cmp    %esi,%ebx
  802321:	76 4d                	jbe    802370 <__udivdi3+0x70>
  802323:	31 ff                	xor    %edi,%edi
  802325:	89 e8                	mov    %ebp,%eax
  802327:	89 f2                	mov    %esi,%edx
  802329:	f7 f3                	div    %ebx
  80232b:	89 fa                	mov    %edi,%edx
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	76 14                	jbe    802350 <__udivdi3+0x50>
  80233c:	31 ff                	xor    %edi,%edi
  80233e:	31 c0                	xor    %eax,%eax
  802340:	89 fa                	mov    %edi,%edx
  802342:	83 c4 1c             	add    $0x1c,%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
  80234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802350:	0f bd fa             	bsr    %edx,%edi
  802353:	83 f7 1f             	xor    $0x1f,%edi
  802356:	75 48                	jne    8023a0 <__udivdi3+0xa0>
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	72 06                	jb     802362 <__udivdi3+0x62>
  80235c:	31 c0                	xor    %eax,%eax
  80235e:	39 eb                	cmp    %ebp,%ebx
  802360:	77 de                	ja     802340 <__udivdi3+0x40>
  802362:	b8 01 00 00 00       	mov    $0x1,%eax
  802367:	eb d7                	jmp    802340 <__udivdi3+0x40>
  802369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802370:	89 d9                	mov    %ebx,%ecx
  802372:	85 db                	test   %ebx,%ebx
  802374:	75 0b                	jne    802381 <__udivdi3+0x81>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f3                	div    %ebx
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	31 d2                	xor    %edx,%edx
  802383:	89 f0                	mov    %esi,%eax
  802385:	f7 f1                	div    %ecx
  802387:	89 c6                	mov    %eax,%esi
  802389:	89 e8                	mov    %ebp,%eax
  80238b:	89 f7                	mov    %esi,%edi
  80238d:	f7 f1                	div    %ecx
  80238f:	89 fa                	mov    %edi,%edx
  802391:	83 c4 1c             	add    $0x1c,%esp
  802394:	5b                   	pop    %ebx
  802395:	5e                   	pop    %esi
  802396:	5f                   	pop    %edi
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    
  802399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a0:	89 f9                	mov    %edi,%ecx
  8023a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023a7:	29 f8                	sub    %edi,%eax
  8023a9:	d3 e2                	shl    %cl,%edx
  8023ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 da                	mov    %ebx,%edx
  8023b3:	d3 ea                	shr    %cl,%edx
  8023b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b9:	09 d1                	or     %edx,%ecx
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 f9                	mov    %edi,%ecx
  8023c3:	d3 e3                	shl    %cl,%ebx
  8023c5:	89 c1                	mov    %eax,%ecx
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	89 f9                	mov    %edi,%ecx
  8023cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023cf:	89 eb                	mov    %ebp,%ebx
  8023d1:	d3 e6                	shl    %cl,%esi
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	d3 eb                	shr    %cl,%ebx
  8023d7:	09 de                	or     %ebx,%esi
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	f7 74 24 08          	divl   0x8(%esp)
  8023df:	89 d6                	mov    %edx,%esi
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	f7 64 24 0c          	mull   0xc(%esp)
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	72 15                	jb     802400 <__udivdi3+0x100>
  8023eb:	89 f9                	mov    %edi,%ecx
  8023ed:	d3 e5                	shl    %cl,%ebp
  8023ef:	39 c5                	cmp    %eax,%ebp
  8023f1:	73 04                	jae    8023f7 <__udivdi3+0xf7>
  8023f3:	39 d6                	cmp    %edx,%esi
  8023f5:	74 09                	je     802400 <__udivdi3+0x100>
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	31 ff                	xor    %edi,%edi
  8023fb:	e9 40 ff ff ff       	jmp    802340 <__udivdi3+0x40>
  802400:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802403:	31 ff                	xor    %edi,%edi
  802405:	e9 36 ff ff ff       	jmp    802340 <__udivdi3+0x40>
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	f3 0f 1e fb          	endbr32 
  802414:	55                   	push   %ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	83 ec 1c             	sub    $0x1c,%esp
  80241b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802423:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 19                	jne    802448 <__umoddi3+0x38>
  80242f:	39 df                	cmp    %ebx,%edi
  802431:	76 5d                	jbe    802490 <__umoddi3+0x80>
  802433:	89 f0                	mov    %esi,%eax
  802435:	89 da                	mov    %ebx,%edx
  802437:	f7 f7                	div    %edi
  802439:	89 d0                	mov    %edx,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	89 f2                	mov    %esi,%edx
  80244a:	39 d8                	cmp    %ebx,%eax
  80244c:	76 12                	jbe    802460 <__umoddi3+0x50>
  80244e:	89 f0                	mov    %esi,%eax
  802450:	89 da                	mov    %ebx,%edx
  802452:	83 c4 1c             	add    $0x1c,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    
  80245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802460:	0f bd e8             	bsr    %eax,%ebp
  802463:	83 f5 1f             	xor    $0x1f,%ebp
  802466:	75 50                	jne    8024b8 <__umoddi3+0xa8>
  802468:	39 d8                	cmp    %ebx,%eax
  80246a:	0f 82 e0 00 00 00    	jb     802550 <__umoddi3+0x140>
  802470:	89 d9                	mov    %ebx,%ecx
  802472:	39 f7                	cmp    %esi,%edi
  802474:	0f 86 d6 00 00 00    	jbe    802550 <__umoddi3+0x140>
  80247a:	89 d0                	mov    %edx,%eax
  80247c:	89 ca                	mov    %ecx,%edx
  80247e:	83 c4 1c             	add    $0x1c,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5f                   	pop    %edi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    
  802486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	89 fd                	mov    %edi,%ebp
  802492:	85 ff                	test   %edi,%edi
  802494:	75 0b                	jne    8024a1 <__umoddi3+0x91>
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f7                	div    %edi
  80249f:	89 c5                	mov    %eax,%ebp
  8024a1:	89 d8                	mov    %ebx,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f5                	div    %ebp
  8024a7:	89 f0                	mov    %esi,%eax
  8024a9:	f7 f5                	div    %ebp
  8024ab:	89 d0                	mov    %edx,%eax
  8024ad:	31 d2                	xor    %edx,%edx
  8024af:	eb 8c                	jmp    80243d <__umoddi3+0x2d>
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0x10b>
  802515:	75 10                	jne    802527 <__umoddi3+0x117>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x117>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	29 fe                	sub    %edi,%esi
  802552:	19 c3                	sbb    %eax,%ebx
  802554:	89 f2                	mov    %esi,%edx
  802556:	89 d9                	mov    %ebx,%ecx
  802558:	e9 1d ff ff ff       	jmp    80247a <__umoddi3+0x6a>
