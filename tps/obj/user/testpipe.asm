
obj/user/testpipe.debug:     formato del fichero elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003f:	c7 05 04 30 80 00 60 	movl   $0x802660,0x803004
  800046:	26 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 43 1e 00 00       	call   801e95 <pipe>
  800052:	89 c6                	mov    %eax,%esi
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 1b 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005f:	e8 77 12 00 00       	call   8012db <fork>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 88 1e 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006e:	0f 85 56 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800074:	a1 04 40 80 00       	mov    0x804004,%eax
  800079:	8b 40 48             	mov    0x48(%eax),%eax
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	ff 75 90             	pushl  -0x70(%ebp)
  800082:	50                   	push   %eax
  800083:	68 85 26 80 00       	push   $0x802685
  800088:	e8 9c 03 00 00       	call   800429 <cprintf>
		close(p[1]);
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	ff 75 90             	pushl  -0x70(%ebp)
  800093:	e8 51 15 00 00       	call   8015e9 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800098:	a1 04 40 80 00       	mov    0x804004,%eax
  80009d:	8b 40 48             	mov    0x48(%eax),%eax
  8000a0:	83 c4 0c             	add    $0xc,%esp
  8000a3:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a6:	50                   	push   %eax
  8000a7:	68 a2 26 80 00       	push   $0x8026a2
  8000ac:	e8 78 03 00 00       	call   800429 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	6a 63                	push   $0x63
  8000b6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b9:	50                   	push   %eax
  8000ba:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bd:	e8 fc 16 00 00       	call   8017be <readn>
  8000c2:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 88 cf 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cf:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	ff 35 00 30 80 00    	pushl  0x803000
  8000dd:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 6c 09 00 00       	call   800a52 <strcmp>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	0f 85 bf 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 c8 26 80 00       	push   $0x8026c8
  8000f9:	e8 2b 03 00 00       	call   800429 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  800101:	e8 1e 02 00 00       	call   800324 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	53                   	push   %ebx
  80010a:	e8 0b 1f 00 00       	call   80201a <wait>

	binaryname = "pipewriteeof";
  80010f:	c7 05 04 30 80 00 1e 	movl   $0x80271e,0x803004
  800116:	27 80 00 
	if ((i = pipe(p)) < 0)
  800119:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 71 1d 00 00       	call   801e95 <pipe>
  800124:	89 c6                	mov    %eax,%esi
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	0f 88 32 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  800131:	e8 a5 11 00 00       	call   8012db <fork>
  800136:	89 c3                	mov    %eax,%ebx
  800138:	85 c0                	test   %eax,%eax
  80013a:	0f 88 35 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 98 14 00 00       	call   8015e9 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 8d 14 00 00       	call   8015e9 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 b6 1e 00 00       	call   80201a <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 4c 27 80 00 	movl   $0x80274c,(%esp)
  80016b:	e8 b9 02 00 00       	call   800429 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 6c 26 80 00       	push   $0x80266c
  800180:	6a 0e                	push   $0xe
  800182:	68 75 26 80 00       	push   $0x802675
  800187:	e8 b6 01 00 00       	call   800342 <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 87 2b 80 00       	push   $0x802b87
  800192:	6a 11                	push   $0x11
  800194:	68 75 26 80 00       	push   $0x802675
  800199:	e8 a4 01 00 00       	call   800342 <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 bf 26 80 00       	push   $0x8026bf
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 75 26 80 00       	push   $0x802675
  8001ab:	e8 92 01 00 00       	call   800342 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 e4 26 80 00       	push   $0x8026e4
  8001bd:	e8 67 02 00 00       	call   800429 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 37 ff ff ff       	jmp    800101 <umain+0xce>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 85 26 80 00       	push   $0x802685
  8001de:	e8 46 02 00 00       	call   800429 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 fb 13 00 00       	call   8015e9 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 f7 26 80 00       	push   $0x8026f7
  800202:	e8 22 02 00 00       	call   800429 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 3b 07 00 00       	call   800950 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 e2 15 00 00       	call   801809 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 19 07 00 00       	call   800950 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 a0 13 00 00       	call   8015e9 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b5 fe ff ff       	jmp    800106 <umain+0xd3>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 14 27 80 00       	push   $0x802714
  800257:	6a 25                	push   $0x25
  800259:	68 75 26 80 00       	push   $0x802675
  80025e:	e8 df 00 00 00       	call   800342 <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 6c 26 80 00       	push   $0x80266c
  800269:	6a 2c                	push   $0x2c
  80026b:	68 75 26 80 00       	push   $0x802675
  800270:	e8 cd 00 00 00       	call   800342 <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 87 2b 80 00       	push   $0x802b87
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 75 26 80 00       	push   $0x802675
  800282:	e8 bb 00 00 00       	call   800342 <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 57 13 00 00       	call   8015e9 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 2b 27 80 00       	push   $0x80272b
  80029d:	e8 87 01 00 00       	call   800429 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 2d 27 80 00       	push   $0x80272d
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 55 15 00 00       	call   801809 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 2f 27 80 00       	push   $0x80272f
  8002c4:	e8 60 01 00 00       	call   800429 <cprintf>
		exit();
  8002c9:	e8 56 00 00 00       	call   800324 <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8002e5:	e8 de 0a 00 00       	call   800dc8 <sys_getenvid>
	if (id >= 0)
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	78 12                	js     800300 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8002ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002fb:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	85 db                	test   %ebx,%ebx
  800302:	7e 07                	jle    80030b <libmain+0x35>
		binaryname = argv[0];
  800304:	8b 06                	mov    (%esi),%eax
  800306:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	e8 1e fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800315:	e8 0a 00 00 00       	call   800324 <exit>
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800320:	5b                   	pop    %ebx
  800321:	5e                   	pop    %esi
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032e:	e8 e7 12 00 00       	call   80161a <close_all>
	sys_env_destroy(0);
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	6a 00                	push   $0x0
  800338:	e8 65 0a 00 00       	call   800da2 <sys_env_destroy>
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034e:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800354:	e8 6f 0a 00 00       	call   800dc8 <sys_getenvid>
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	56                   	push   %esi
  800363:	50                   	push   %eax
  800364:	68 b0 27 80 00       	push   $0x8027b0
  800369:	e8 bb 00 00 00       	call   800429 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036e:	83 c4 18             	add    $0x18,%esp
  800371:	53                   	push   %ebx
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	e8 5a 00 00 00       	call   8003d4 <vcprintf>
	cprintf("\n");
  80037a:	c7 04 24 1e 2e 80 00 	movl   $0x802e1e,(%esp)
  800381:	e8 a3 00 00 00       	call   800429 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800389:	cc                   	int3   
  80038a:	eb fd                	jmp    800389 <_panic+0x47>

0080038c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80038c:	f3 0f 1e fb          	endbr32 
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	53                   	push   %ebx
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039a:	8b 13                	mov    (%ebx),%edx
  80039c:	8d 42 01             	lea    0x1(%edx),%eax
  80039f:	89 03                	mov    %eax,(%ebx)
  8003a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ad:	74 09                	je     8003b8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003af:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 ff 00 00 00       	push   $0xff
  8003c0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c3:	50                   	push   %eax
  8003c4:	e8 87 09 00 00       	call   800d50 <sys_cputs>
		b->idx = 0;
  8003c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb db                	jmp    8003af <putch+0x23>

008003d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d4:	f3 0f 1e fb          	endbr32 
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e8:	00 00 00 
	b.cnt = 0;
  8003eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	68 8c 03 80 00       	push   $0x80038c
  800407:	e8 80 01 00 00       	call   80058c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040c:	83 c4 08             	add    $0x8,%esp
  80040f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800415:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	e8 2f 09 00 00       	call   800d50 <sys_cputs>

	return b.cnt;
}
  800421:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800429:	f3 0f 1e fb          	endbr32 
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800433:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800436:	50                   	push   %eax
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 95 ff ff ff       	call   8003d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	57                   	push   %edi
  800445:	56                   	push   %esi
  800446:	53                   	push   %ebx
  800447:	83 ec 1c             	sub    $0x1c,%esp
  80044a:	89 c7                	mov    %eax,%edi
  80044c:	89 d6                	mov    %edx,%esi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	89 d1                	mov    %edx,%ecx
  800456:	89 c2                	mov    %eax,%edx
  800458:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045e:	8b 45 10             	mov    0x10(%ebp),%eax
  800461:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800473:	72 3e                	jb     8004b3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	ff 75 18             	pushl  0x18(%ebp)
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	53                   	push   %ebx
  80047f:	50                   	push   %eax
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	ff 75 e4             	pushl  -0x1c(%ebp)
  800486:	ff 75 e0             	pushl  -0x20(%ebp)
  800489:	ff 75 dc             	pushl  -0x24(%ebp)
  80048c:	ff 75 d8             	pushl  -0x28(%ebp)
  80048f:	e8 5c 1f 00 00       	call   8023f0 <__udivdi3>
  800494:	83 c4 18             	add    $0x18,%esp
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	89 f2                	mov    %esi,%edx
  80049b:	89 f8                	mov    %edi,%eax
  80049d:	e8 9f ff ff ff       	call   800441 <printnum>
  8004a2:	83 c4 20             	add    $0x20,%esp
  8004a5:	eb 13                	jmp    8004ba <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	56                   	push   %esi
  8004ab:	ff 75 18             	pushl  0x18(%ebp)
  8004ae:	ff d7                	call   *%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7f ed                	jg     8004a7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	56                   	push   %esi
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cd:	e8 2e 20 00 00       	call   802500 <__umoddi3>
  8004d2:	83 c4 14             	add    $0x14,%esp
  8004d5:	0f be 80 d3 27 80 00 	movsbl 0x8027d3(%eax),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff d7                	call   *%edi
}
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e5:	5b                   	pop    %ebx
  8004e6:	5e                   	pop    %esi
  8004e7:	5f                   	pop    %edi
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8004ea:	83 fa 01             	cmp    $0x1,%edx
  8004ed:	7f 13                	jg     800502 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8004ef:	85 d2                	test   %edx,%edx
  8004f1:	74 1c                	je     80050f <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8004f3:	8b 10                	mov    (%eax),%edx
  8004f5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004f8:	89 08                	mov    %ecx,(%eax)
  8004fa:	8b 02                	mov    (%edx),%eax
  8004fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800501:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800502:	8b 10                	mov    (%eax),%edx
  800504:	8d 4a 08             	lea    0x8(%edx),%ecx
  800507:	89 08                	mov    %ecx,(%eax)
  800509:	8b 02                	mov    (%edx),%eax
  80050b:	8b 52 04             	mov    0x4(%edx),%edx
  80050e:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80050f:	8b 10                	mov    (%eax),%edx
  800511:	8d 4a 04             	lea    0x4(%edx),%ecx
  800514:	89 08                	mov    %ecx,(%eax)
  800516:	8b 02                	mov    (%edx),%eax
  800518:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80051d:	c3                   	ret    

0080051e <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80051e:	83 fa 01             	cmp    $0x1,%edx
  800521:	7f 0f                	jg     800532 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800523:	85 d2                	test   %edx,%edx
  800525:	74 18                	je     80053f <getint+0x21>
		return va_arg(*ap, long);
  800527:	8b 10                	mov    (%eax),%edx
  800529:	8d 4a 04             	lea    0x4(%edx),%ecx
  80052c:	89 08                	mov    %ecx,(%eax)
  80052e:	8b 02                	mov    (%edx),%eax
  800530:	99                   	cltd   
  800531:	c3                   	ret    
		return va_arg(*ap, long long);
  800532:	8b 10                	mov    (%eax),%edx
  800534:	8d 4a 08             	lea    0x8(%edx),%ecx
  800537:	89 08                	mov    %ecx,(%eax)
  800539:	8b 02                	mov    (%edx),%eax
  80053b:	8b 52 04             	mov    0x4(%edx),%edx
  80053e:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80053f:	8b 10                	mov    (%eax),%edx
  800541:	8d 4a 04             	lea    0x4(%edx),%ecx
  800544:	89 08                	mov    %ecx,(%eax)
  800546:	8b 02                	mov    (%edx),%eax
  800548:	99                   	cltd   
}
  800549:	c3                   	ret    

0080054a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80054a:	f3 0f 1e fb          	endbr32 
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800554:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800558:	8b 10                	mov    (%eax),%edx
  80055a:	3b 50 04             	cmp    0x4(%eax),%edx
  80055d:	73 0a                	jae    800569 <sprintputch+0x1f>
		*b->buf++ = ch;
  80055f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800562:	89 08                	mov    %ecx,(%eax)
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	88 02                	mov    %al,(%edx)
}
  800569:	5d                   	pop    %ebp
  80056a:	c3                   	ret    

0080056b <printfmt>:
{
  80056b:	f3 0f 1e fb          	endbr32 
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800575:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800578:	50                   	push   %eax
  800579:	ff 75 10             	pushl  0x10(%ebp)
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	ff 75 08             	pushl  0x8(%ebp)
  800582:	e8 05 00 00 00       	call   80058c <vprintfmt>
}
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <vprintfmt>:
{
  80058c:	f3 0f 1e fb          	endbr32 
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	57                   	push   %edi
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 2c             	sub    $0x2c,%esp
  800599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80059c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80059f:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005a2:	e9 86 02 00 00       	jmp    80082d <vprintfmt+0x2a1>
		padc = ' ';
  8005a7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005ab:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	8d 47 01             	lea    0x1(%edi),%eax
  8005c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cb:	0f b6 17             	movzbl (%edi),%edx
  8005ce:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005d1:	3c 55                	cmp    $0x55,%al
  8005d3:	0f 87 df 02 00 00    	ja     8008b8 <vprintfmt+0x32c>
  8005d9:	0f b6 c0             	movzbl %al,%eax
  8005dc:	3e ff 24 85 20 29 80 	notrack jmp *0x802920(,%eax,4)
  8005e3:	00 
  8005e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005e7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005eb:	eb d8                	jmp    8005c5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005f4:	eb cf                	jmp    8005c5 <vprintfmt+0x39>
  8005f6:	0f b6 d2             	movzbl %dl,%edx
  8005f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800601:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800604:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800607:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80060b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80060e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800611:	83 f9 09             	cmp    $0x9,%ecx
  800614:	77 52                	ja     800668 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800616:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800619:	eb e9                	jmp    800604 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	89 55 14             	mov    %edx,0x14(%ebp)
  800624:	8b 00                	mov    (%eax),%eax
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800629:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80062c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800630:	79 93                	jns    8005c5 <vprintfmt+0x39>
				width = precision, precision = -1;
  800632:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800635:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800638:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80063f:	eb 84                	jmp    8005c5 <vprintfmt+0x39>
  800641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800644:	85 c0                	test   %eax,%eax
  800646:	ba 00 00 00 00       	mov    $0x0,%edx
  80064b:	0f 49 d0             	cmovns %eax,%edx
  80064e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800651:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800654:	e9 6c ff ff ff       	jmp    8005c5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800659:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80065c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800663:	e9 5d ff ff ff       	jmp    8005c5 <vprintfmt+0x39>
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80066e:	eb bc                	jmp    80062c <vprintfmt+0xa0>
			lflag++;
  800670:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800676:	e9 4a ff ff ff       	jmp    8005c5 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	89 55 14             	mov    %edx,0x14(%ebp)
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	56                   	push   %esi
  800688:	ff 30                	pushl  (%eax)
  80068a:	ff d3                	call   *%ebx
			break;
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	e9 96 01 00 00       	jmp    80082a <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 50 04             	lea    0x4(%eax),%edx
  80069a:	89 55 14             	mov    %edx,0x14(%ebp)
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	99                   	cltd   
  8006a0:	31 d0                	xor    %edx,%eax
  8006a2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006a4:	83 f8 0f             	cmp    $0xf,%eax
  8006a7:	7f 20                	jg     8006c9 <vprintfmt+0x13d>
  8006a9:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  8006b0:	85 d2                	test   %edx,%edx
  8006b2:	74 15                	je     8006c9 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8006b4:	52                   	push   %edx
  8006b5:	68 7b 2d 80 00       	push   $0x802d7b
  8006ba:	56                   	push   %esi
  8006bb:	53                   	push   %ebx
  8006bc:	e8 aa fe ff ff       	call   80056b <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	e9 61 01 00 00       	jmp    80082a <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8006c9:	50                   	push   %eax
  8006ca:	68 eb 27 80 00       	push   $0x8027eb
  8006cf:	56                   	push   %esi
  8006d0:	53                   	push   %ebx
  8006d1:	e8 95 fe ff ff       	call   80056b <printfmt>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	e9 4c 01 00 00       	jmp    80082a <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e7:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006e9:	85 c9                	test   %ecx,%ecx
  8006eb:	b8 e4 27 80 00       	mov    $0x8027e4,%eax
  8006f0:	0f 45 c1             	cmovne %ecx,%eax
  8006f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fa:	7e 06                	jle    800702 <vprintfmt+0x176>
  8006fc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800700:	75 0d                	jne    80070f <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800702:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800705:	89 c7                	mov    %eax,%edi
  800707:	03 45 e0             	add    -0x20(%ebp),%eax
  80070a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80070d:	eb 57                	jmp    800766 <vprintfmt+0x1da>
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 d8             	pushl  -0x28(%ebp)
  800715:	ff 75 cc             	pushl  -0x34(%ebp)
  800718:	e8 4f 02 00 00       	call   80096c <strnlen>
  80071d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800720:	29 c2                	sub    %eax,%edx
  800722:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800725:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800728:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80072c:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80072f:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800731:	85 db                	test   %ebx,%ebx
  800733:	7e 10                	jle    800745 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	56                   	push   %esi
  800739:	57                   	push   %edi
  80073a:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80073d:	83 eb 01             	sub    $0x1,%ebx
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	eb ec                	jmp    800731 <vprintfmt+0x1a5>
  800745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800748:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80074b:	85 d2                	test   %edx,%edx
  80074d:	b8 00 00 00 00       	mov    $0x0,%eax
  800752:	0f 49 c2             	cmovns %edx,%eax
  800755:	29 c2                	sub    %eax,%edx
  800757:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80075a:	eb a6                	jmp    800702 <vprintfmt+0x176>
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	56                   	push   %esi
  800760:	52                   	push   %edx
  800761:	ff d3                	call   *%ebx
  800763:	83 c4 10             	add    $0x10,%esp
  800766:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800769:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	83 c7 01             	add    $0x1,%edi
  80076e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800772:	0f be d0             	movsbl %al,%edx
  800775:	85 d2                	test   %edx,%edx
  800777:	74 42                	je     8007bb <vprintfmt+0x22f>
  800779:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80077d:	78 06                	js     800785 <vprintfmt+0x1f9>
  80077f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800783:	78 1e                	js     8007a3 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800785:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800789:	74 d1                	je     80075c <vprintfmt+0x1d0>
  80078b:	0f be c0             	movsbl %al,%eax
  80078e:	83 e8 20             	sub    $0x20,%eax
  800791:	83 f8 5e             	cmp    $0x5e,%eax
  800794:	76 c6                	jbe    80075c <vprintfmt+0x1d0>
					putch('?', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	56                   	push   %esi
  80079a:	6a 3f                	push   $0x3f
  80079c:	ff d3                	call   *%ebx
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	eb c3                	jmp    800766 <vprintfmt+0x1da>
  8007a3:	89 cf                	mov    %ecx,%edi
  8007a5:	eb 0e                	jmp    8007b5 <vprintfmt+0x229>
				putch(' ', putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	56                   	push   %esi
  8007ab:	6a 20                	push   $0x20
  8007ad:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8007af:	83 ef 01             	sub    $0x1,%edi
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	85 ff                	test   %edi,%edi
  8007b7:	7f ee                	jg     8007a7 <vprintfmt+0x21b>
  8007b9:	eb 6f                	jmp    80082a <vprintfmt+0x29e>
  8007bb:	89 cf                	mov    %ecx,%edi
  8007bd:	eb f6                	jmp    8007b5 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8007bf:	89 ca                	mov    %ecx,%edx
  8007c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c4:	e8 55 fd ff ff       	call   80051e <getint>
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007cf:	85 d2                	test   %edx,%edx
  8007d1:	78 0b                	js     8007de <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8007d3:	89 d1                	mov    %edx,%ecx
  8007d5:	89 c2                	mov    %eax,%edx
			base = 10;
  8007d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dc:	eb 32                	jmp    800810 <vprintfmt+0x284>
				putch('-', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	56                   	push   %esi
  8007e2:	6a 2d                	push   $0x2d
  8007e4:	ff d3                	call   *%ebx
				num = -(long long) num;
  8007e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ec:	f7 da                	neg    %edx
  8007ee:	83 d1 00             	adc    $0x0,%ecx
  8007f1:	f7 d9                	neg    %ecx
  8007f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fb:	eb 13                	jmp    800810 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8007fd:	89 ca                	mov    %ecx,%edx
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	e8 e3 fc ff ff       	call   8004ea <getuint>
  800807:	89 d1                	mov    %edx,%ecx
  800809:	89 c2                	mov    %eax,%edx
			base = 10;
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800817:	57                   	push   %edi
  800818:	ff 75 e0             	pushl  -0x20(%ebp)
  80081b:	50                   	push   %eax
  80081c:	51                   	push   %ecx
  80081d:	52                   	push   %edx
  80081e:	89 f2                	mov    %esi,%edx
  800820:	89 d8                	mov    %ebx,%eax
  800822:	e8 1a fc ff ff       	call   800441 <printnum>
			break;
  800827:	83 c4 20             	add    $0x20,%esp
{
  80082a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	83 c7 01             	add    $0x1,%edi
  800830:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800834:	83 f8 25             	cmp    $0x25,%eax
  800837:	0f 84 6a fd ff ff    	je     8005a7 <vprintfmt+0x1b>
			if (ch == '\0')
  80083d:	85 c0                	test   %eax,%eax
  80083f:	0f 84 93 00 00 00    	je     8008d8 <vprintfmt+0x34c>
			putch(ch, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	56                   	push   %esi
  800849:	50                   	push   %eax
  80084a:	ff d3                	call   *%ebx
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	eb dc                	jmp    80082d <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800851:	89 ca                	mov    %ecx,%edx
  800853:	8d 45 14             	lea    0x14(%ebp),%eax
  800856:	e8 8f fc ff ff       	call   8004ea <getuint>
  80085b:	89 d1                	mov    %edx,%ecx
  80085d:	89 c2                	mov    %eax,%edx
			base = 8;
  80085f:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800864:	eb aa                	jmp    800810 <vprintfmt+0x284>
			putch('0', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	56                   	push   %esi
  80086a:	6a 30                	push   $0x30
  80086c:	ff d3                	call   *%ebx
			putch('x', putdat);
  80086e:	83 c4 08             	add    $0x8,%esp
  800871:	56                   	push   %esi
  800872:	6a 78                	push   $0x78
  800874:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800886:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800889:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80088e:	eb 80                	jmp    800810 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800890:	89 ca                	mov    %ecx,%edx
  800892:	8d 45 14             	lea    0x14(%ebp),%eax
  800895:	e8 50 fc ff ff       	call   8004ea <getuint>
  80089a:	89 d1                	mov    %edx,%ecx
  80089c:	89 c2                	mov    %eax,%edx
			base = 16;
  80089e:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a3:	e9 68 ff ff ff       	jmp    800810 <vprintfmt+0x284>
			putch(ch, putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	56                   	push   %esi
  8008ac:	6a 25                	push   $0x25
  8008ae:	ff d3                	call   *%ebx
			break;
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	e9 72 ff ff ff       	jmp    80082a <vprintfmt+0x29e>
			putch('%', putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	56                   	push   %esi
  8008bc:	6a 25                	push   $0x25
  8008be:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 f8                	mov    %edi,%eax
  8008c5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c9:	74 05                	je     8008d0 <vprintfmt+0x344>
  8008cb:	83 e8 01             	sub    $0x1,%eax
  8008ce:	eb f5                	jmp    8008c5 <vprintfmt+0x339>
  8008d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d3:	e9 52 ff ff ff       	jmp    80082a <vprintfmt+0x29e>
}
  8008d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5f                   	pop    %edi
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 18             	sub    $0x18,%esp
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800901:	85 c0                	test   %eax,%eax
  800903:	74 26                	je     80092b <vsnprintf+0x4b>
  800905:	85 d2                	test   %edx,%edx
  800907:	7e 22                	jle    80092b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800909:	ff 75 14             	pushl  0x14(%ebp)
  80090c:	ff 75 10             	pushl  0x10(%ebp)
  80090f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800912:	50                   	push   %eax
  800913:	68 4a 05 80 00       	push   $0x80054a
  800918:	e8 6f fc ff ff       	call   80058c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800920:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800926:	83 c4 10             	add    $0x10,%esp
}
  800929:	c9                   	leave  
  80092a:	c3                   	ret    
		return -E_INVAL;
  80092b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800930:	eb f7                	jmp    800929 <vsnprintf+0x49>

00800932 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093f:	50                   	push   %eax
  800940:	ff 75 10             	pushl  0x10(%ebp)
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	ff 75 08             	pushl  0x8(%ebp)
  800949:	e8 92 ff ff ff       	call   8008e0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095a:	b8 00 00 00 00       	mov    $0x0,%eax
  80095f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800963:	74 05                	je     80096a <strlen+0x1a>
		n++;
  800965:	83 c0 01             	add    $0x1,%eax
  800968:	eb f5                	jmp    80095f <strlen+0xf>
	return n;
}
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096c:	f3 0f 1e fb          	endbr32 
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	39 d0                	cmp    %edx,%eax
  800980:	74 0d                	je     80098f <strnlen+0x23>
  800982:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800986:	74 05                	je     80098d <strnlen+0x21>
		n++;
  800988:	83 c0 01             	add    $0x1,%eax
  80098b:	eb f1                	jmp    80097e <strnlen+0x12>
  80098d:	89 c2                	mov    %eax,%edx
	return n;
}
  80098f:	89 d0                	mov    %edx,%eax
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800993:	f3 0f 1e fb          	endbr32 
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009aa:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f2                	jne    8009a6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8009b4:	89 c8                	mov    %ecx,%eax
  8009b6:	5b                   	pop    %ebx
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b9:	f3 0f 1e fb          	endbr32 
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	53                   	push   %ebx
  8009c1:	83 ec 10             	sub    $0x10,%esp
  8009c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c7:	53                   	push   %ebx
  8009c8:	e8 83 ff ff ff       	call   800950 <strlen>
  8009cd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	01 d8                	add    %ebx,%eax
  8009d5:	50                   	push   %eax
  8009d6:	e8 b8 ff ff ff       	call   800993 <strcpy>
	return dst;
}
  8009db:	89 d8                	mov    %ebx,%eax
  8009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e2:	f3 0f 1e fb          	endbr32 
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f1:	89 f3                	mov    %esi,%ebx
  8009f3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f6:	89 f0                	mov    %esi,%eax
  8009f8:	39 d8                	cmp    %ebx,%eax
  8009fa:	74 11                	je     800a0d <strncpy+0x2b>
		*dst++ = *src;
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	0f b6 0a             	movzbl (%edx),%ecx
  800a02:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a05:	80 f9 01             	cmp    $0x1,%cl
  800a08:	83 da ff             	sbb    $0xffffffff,%edx
  800a0b:	eb eb                	jmp    8009f8 <strncpy+0x16>
	}
	return ret;
}
  800a0d:	89 f0                	mov    %esi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a13:	f3 0f 1e fb          	endbr32 
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a22:	8b 55 10             	mov    0x10(%ebp),%edx
  800a25:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a27:	85 d2                	test   %edx,%edx
  800a29:	74 21                	je     800a4c <strlcpy+0x39>
  800a2b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a31:	39 c2                	cmp    %eax,%edx
  800a33:	74 14                	je     800a49 <strlcpy+0x36>
  800a35:	0f b6 19             	movzbl (%ecx),%ebx
  800a38:	84 db                	test   %bl,%bl
  800a3a:	74 0b                	je     800a47 <strlcpy+0x34>
			*dst++ = *src++;
  800a3c:	83 c1 01             	add    $0x1,%ecx
  800a3f:	83 c2 01             	add    $0x1,%edx
  800a42:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a45:	eb ea                	jmp    800a31 <strlcpy+0x1e>
  800a47:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4c:	29 f0                	sub    %esi,%eax
}
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a52:	f3 0f 1e fb          	endbr32 
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5f:	0f b6 01             	movzbl (%ecx),%eax
  800a62:	84 c0                	test   %al,%al
  800a64:	74 0c                	je     800a72 <strcmp+0x20>
  800a66:	3a 02                	cmp    (%edx),%al
  800a68:	75 08                	jne    800a72 <strcmp+0x20>
		p++, q++;
  800a6a:	83 c1 01             	add    $0x1,%ecx
  800a6d:	83 c2 01             	add    $0x1,%edx
  800a70:	eb ed                	jmp    800a5f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a72:	0f b6 c0             	movzbl %al,%eax
  800a75:	0f b6 12             	movzbl (%edx),%edx
  800a78:	29 d0                	sub    %edx,%eax
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7c:	f3 0f 1e fb          	endbr32 
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	53                   	push   %ebx
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8a:	89 c3                	mov    %eax,%ebx
  800a8c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8f:	eb 06                	jmp    800a97 <strncmp+0x1b>
		n--, p++, q++;
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a97:	39 d8                	cmp    %ebx,%eax
  800a99:	74 16                	je     800ab1 <strncmp+0x35>
  800a9b:	0f b6 08             	movzbl (%eax),%ecx
  800a9e:	84 c9                	test   %cl,%cl
  800aa0:	74 04                	je     800aa6 <strncmp+0x2a>
  800aa2:	3a 0a                	cmp    (%edx),%cl
  800aa4:	74 eb                	je     800a91 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa6:	0f b6 00             	movzbl (%eax),%eax
  800aa9:	0f b6 12             	movzbl (%edx),%edx
  800aac:	29 d0                	sub    %edx,%eax
}
  800aae:	5b                   	pop    %ebx
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    
		return 0;
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	eb f6                	jmp    800aae <strncmp+0x32>

00800ab8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac6:	0f b6 10             	movzbl (%eax),%edx
  800ac9:	84 d2                	test   %dl,%dl
  800acb:	74 09                	je     800ad6 <strchr+0x1e>
		if (*s == c)
  800acd:	38 ca                	cmp    %cl,%dl
  800acf:	74 0a                	je     800adb <strchr+0x23>
	for (; *s; s++)
  800ad1:	83 c0 01             	add    $0x1,%eax
  800ad4:	eb f0                	jmp    800ac6 <strchr+0xe>
			return (char *) s;
	return 0;
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800add:	f3 0f 1e fb          	endbr32 
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aeb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aee:	38 ca                	cmp    %cl,%dl
  800af0:	74 09                	je     800afb <strfind+0x1e>
  800af2:	84 d2                	test   %dl,%dl
  800af4:	74 05                	je     800afb <strfind+0x1e>
	for (; *s; s++)
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	eb f0                	jmp    800aeb <strfind+0xe>
			break;
	return (char *) s;
}
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afd:	f3 0f 1e fb          	endbr32 
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	57                   	push   %edi
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800b0d:	85 c9                	test   %ecx,%ecx
  800b0f:	74 33                	je     800b44 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b11:	89 d0                	mov    %edx,%eax
  800b13:	09 c8                	or     %ecx,%eax
  800b15:	a8 03                	test   $0x3,%al
  800b17:	75 23                	jne    800b3c <memset+0x3f>
		c &= 0xFF;
  800b19:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1d:	89 d8                	mov    %ebx,%eax
  800b1f:	c1 e0 08             	shl    $0x8,%eax
  800b22:	89 df                	mov    %ebx,%edi
  800b24:	c1 e7 18             	shl    $0x18,%edi
  800b27:	89 de                	mov    %ebx,%esi
  800b29:	c1 e6 10             	shl    $0x10,%esi
  800b2c:	09 f7                	or     %esi,%edi
  800b2e:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800b30:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b33:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800b35:	89 d7                	mov    %edx,%edi
  800b37:	fc                   	cld    
  800b38:	f3 ab                	rep stos %eax,%es:(%edi)
  800b3a:	eb 08                	jmp    800b44 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3c:	89 d7                	mov    %edx,%edi
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	fc                   	cld    
  800b42:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800b44:	89 d0                	mov    %edx,%eax
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5d:	39 c6                	cmp    %eax,%esi
  800b5f:	73 32                	jae    800b93 <memmove+0x48>
  800b61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	76 2b                	jbe    800b93 <memmove+0x48>
		s += n;
		d += n;
  800b68:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6b:	89 fe                	mov    %edi,%esi
  800b6d:	09 ce                	or     %ecx,%esi
  800b6f:	09 d6                	or     %edx,%esi
  800b71:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b77:	75 0e                	jne    800b87 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b79:	83 ef 04             	sub    $0x4,%edi
  800b7c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b82:	fd                   	std    
  800b83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b85:	eb 09                	jmp    800b90 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b87:	83 ef 01             	sub    $0x1,%edi
  800b8a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8d:	fd                   	std    
  800b8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b90:	fc                   	cld    
  800b91:	eb 1a                	jmp    800bad <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	09 ca                	or     %ecx,%edx
  800b97:	09 f2                	or     %esi,%edx
  800b99:	f6 c2 03             	test   $0x3,%dl
  800b9c:	75 0a                	jne    800ba8 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba1:	89 c7                	mov    %eax,%edi
  800ba3:	fc                   	cld    
  800ba4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba6:	eb 05                	jmp    800bad <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	fc                   	cld    
  800bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb1:	f3 0f 1e fb          	endbr32 
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	ff 75 08             	pushl  0x8(%ebp)
  800bc4:	e8 82 ff ff ff       	call   800b4b <memmove>
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bda:	89 c6                	mov    %eax,%esi
  800bdc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdf:	39 f0                	cmp    %esi,%eax
  800be1:	74 1c                	je     800bff <memcmp+0x34>
		if (*s1 != *s2)
  800be3:	0f b6 08             	movzbl (%eax),%ecx
  800be6:	0f b6 1a             	movzbl (%edx),%ebx
  800be9:	38 d9                	cmp    %bl,%cl
  800beb:	75 08                	jne    800bf5 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bed:	83 c0 01             	add    $0x1,%eax
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	eb ea                	jmp    800bdf <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bf5:	0f b6 c1             	movzbl %cl,%eax
  800bf8:	0f b6 db             	movzbl %bl,%ebx
  800bfb:	29 d8                	sub    %ebx,%eax
  800bfd:	eb 05                	jmp    800c04 <memcmp+0x39>
	}

	return 0;
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c08:	f3 0f 1e fb          	endbr32 
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c15:	89 c2                	mov    %eax,%edx
  800c17:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c1a:	39 d0                	cmp    %edx,%eax
  800c1c:	73 09                	jae    800c27 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1e:	38 08                	cmp    %cl,(%eax)
  800c20:	74 05                	je     800c27 <memfind+0x1f>
	for (; s < ends; s++)
  800c22:	83 c0 01             	add    $0x1,%eax
  800c25:	eb f3                	jmp    800c1a <memfind+0x12>
			break;
	return (void *) s;
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c29:	f3 0f 1e fb          	endbr32 
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
  800c33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c39:	eb 03                	jmp    800c3e <strtol+0x15>
		s++;
  800c3b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c3e:	0f b6 01             	movzbl (%ecx),%eax
  800c41:	3c 20                	cmp    $0x20,%al
  800c43:	74 f6                	je     800c3b <strtol+0x12>
  800c45:	3c 09                	cmp    $0x9,%al
  800c47:	74 f2                	je     800c3b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c49:	3c 2b                	cmp    $0x2b,%al
  800c4b:	74 2a                	je     800c77 <strtol+0x4e>
	int neg = 0;
  800c4d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c52:	3c 2d                	cmp    $0x2d,%al
  800c54:	74 2b                	je     800c81 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c56:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c5c:	75 0f                	jne    800c6d <strtol+0x44>
  800c5e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c61:	74 28                	je     800c8b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6a:	0f 44 d8             	cmove  %eax,%ebx
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c72:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c75:	eb 46                	jmp    800cbd <strtol+0x94>
		s++;
  800c77:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c7a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7f:	eb d5                	jmp    800c56 <strtol+0x2d>
		s++, neg = 1;
  800c81:	83 c1 01             	add    $0x1,%ecx
  800c84:	bf 01 00 00 00       	mov    $0x1,%edi
  800c89:	eb cb                	jmp    800c56 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c8f:	74 0e                	je     800c9f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c91:	85 db                	test   %ebx,%ebx
  800c93:	75 d8                	jne    800c6d <strtol+0x44>
		s++, base = 8;
  800c95:	83 c1 01             	add    $0x1,%ecx
  800c98:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9d:	eb ce                	jmp    800c6d <strtol+0x44>
		s += 2, base = 16;
  800c9f:	83 c1 02             	add    $0x2,%ecx
  800ca2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca7:	eb c4                	jmp    800c6d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca9:	0f be d2             	movsbl %dl,%edx
  800cac:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800caf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cb2:	7d 3a                	jge    800cee <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cb4:	83 c1 01             	add    $0x1,%ecx
  800cb7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cbb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cbd:	0f b6 11             	movzbl (%ecx),%edx
  800cc0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc3:	89 f3                	mov    %esi,%ebx
  800cc5:	80 fb 09             	cmp    $0x9,%bl
  800cc8:	76 df                	jbe    800ca9 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800cca:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ccd:	89 f3                	mov    %esi,%ebx
  800ccf:	80 fb 19             	cmp    $0x19,%bl
  800cd2:	77 08                	ja     800cdc <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd4:	0f be d2             	movsbl %dl,%edx
  800cd7:	83 ea 57             	sub    $0x57,%edx
  800cda:	eb d3                	jmp    800caf <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800cdc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cdf:	89 f3                	mov    %esi,%ebx
  800ce1:	80 fb 19             	cmp    $0x19,%bl
  800ce4:	77 08                	ja     800cee <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ce6:	0f be d2             	movsbl %dl,%edx
  800ce9:	83 ea 37             	sub    $0x37,%edx
  800cec:	eb c1                	jmp    800caf <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 05                	je     800cf9 <strtol+0xd0>
		*endptr = (char *) s;
  800cf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf9:	89 c2                	mov    %eax,%edx
  800cfb:	f7 da                	neg    %edx
  800cfd:	85 ff                	test   %edi,%edi
  800cff:	0f 45 c2             	cmovne %edx,%eax
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 1c             	sub    $0x1c,%esp
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d13:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d16:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d1e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d21:	8b 75 14             	mov    0x14(%ebp),%esi
  800d24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2a:	74 04                	je     800d30 <syscall+0x29>
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	ff 75 e0             	pushl  -0x20(%ebp)
  800d3f:	68 df 2a 80 00       	push   $0x802adf
  800d44:	6a 23                	push   $0x23
  800d46:	68 fc 2a 80 00       	push   $0x802afc
  800d4b:	e8 f2 f5 ff ff       	call   800342 <_panic>

00800d50 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800d50:	f3 0f 1e fb          	endbr32 
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800d5a:	6a 00                	push   $0x0
  800d5c:	6a 00                	push   $0x0
  800d5e:	6a 00                	push   $0x0
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d66:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	e8 92 ff ff ff       	call   800d07 <syscall>
}
  800d75:	83 c4 10             	add    $0x10,%esp
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7a:	f3 0f 1e fb          	endbr32 
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800d84:	6a 00                	push   $0x0
  800d86:	6a 00                	push   $0x0
  800d88:	6a 00                	push   $0x0
  800d8a:	6a 00                	push   $0x0
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9b:	e8 67 ff ff ff       	call   800d07 <syscall>
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da2:	f3 0f 1e fb          	endbr32 
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800dac:	6a 00                	push   $0x0
  800dae:	6a 00                	push   $0x0
  800db0:	6a 00                	push   $0x0
  800db2:	6a 00                	push   $0x0
  800db4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db7:	ba 01 00 00 00       	mov    $0x1,%edx
  800dbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc1:	e8 41 ff ff ff       	call   800d07 <syscall>
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc8:	f3 0f 1e fb          	endbr32 
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800dd2:	6a 00                	push   $0x0
  800dd4:	6a 00                	push   $0x0
  800dd6:	6a 00                	push   $0x0
  800dd8:	6a 00                	push   $0x0
  800dda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  800de4:	b8 02 00 00 00       	mov    $0x2,%eax
  800de9:	e8 19 ff ff ff       	call   800d07 <syscall>
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <sys_yield>:

void
sys_yield(void)
{
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800dfa:	6a 00                	push   $0x0
  800dfc:	6a 00                	push   $0x0
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 00                	push   $0x0
  800e02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e11:	e8 f1 fe ff ff       	call   800d07 <syscall>
}
  800e16:	83 c4 10             	add    $0x10,%esp
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800e25:	6a 00                	push   $0x0
  800e27:	6a 00                	push   $0x0
  800e29:	ff 75 10             	pushl  0x10(%ebp)
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e32:	ba 01 00 00 00       	mov    $0x1,%edx
  800e37:	b8 04 00 00 00       	mov    $0x4,%eax
  800e3c:	e8 c6 fe ff ff       	call   800d07 <syscall>
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e43:	f3 0f 1e fb          	endbr32 
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800e4d:	ff 75 18             	pushl  0x18(%ebp)
  800e50:	ff 75 14             	pushl  0x14(%ebp)
  800e53:	ff 75 10             	pushl  0x10(%ebp)
  800e56:	ff 75 0c             	pushl  0xc(%ebp)
  800e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5c:	ba 01 00 00 00       	mov    $0x1,%edx
  800e61:	b8 05 00 00 00       	mov    $0x5,%eax
  800e66:	e8 9c fe ff ff       	call   800d07 <syscall>
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6d:	f3 0f 1e fb          	endbr32 
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800e77:	6a 00                	push   $0x0
  800e79:	6a 00                	push   $0x0
  800e7b:	6a 00                	push   $0x0
  800e7d:	ff 75 0c             	pushl  0xc(%ebp)
  800e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e83:	ba 01 00 00 00       	mov    $0x1,%edx
  800e88:	b8 06 00 00 00       	mov    $0x6,%eax
  800e8d:	e8 75 fe ff ff       	call   800d07 <syscall>
}
  800e92:	c9                   	leave  
  800e93:	c3                   	ret    

00800e94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e94:	f3 0f 1e fb          	endbr32 
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800e9e:	6a 00                	push   $0x0
  800ea0:	6a 00                	push   $0x0
  800ea2:	6a 00                	push   $0x0
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eaa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eaf:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb4:	e8 4e fe ff ff       	call   800d07 <syscall>
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ebb:	f3 0f 1e fb          	endbr32 
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ec5:	6a 00                	push   $0x0
  800ec7:	6a 00                	push   $0x0
  800ec9:	6a 00                	push   $0x0
  800ecb:	ff 75 0c             	pushl  0xc(%ebp)
  800ece:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  800ed6:	b8 09 00 00 00       	mov    $0x9,%eax
  800edb:	e8 27 fe ff ff       	call   800d07 <syscall>
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee2:	f3 0f 1e fb          	endbr32 
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800eec:	6a 00                	push   $0x0
  800eee:	6a 00                	push   $0x0
  800ef0:	6a 00                	push   $0x0
  800ef2:	ff 75 0c             	pushl  0xc(%ebp)
  800ef5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef8:	ba 01 00 00 00       	mov    $0x1,%edx
  800efd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f02:	e8 00 fe ff ff       	call   800d07 <syscall>
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f09:	f3 0f 1e fb          	endbr32 
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800f13:	6a 00                	push   $0x0
  800f15:	ff 75 14             	pushl  0x14(%ebp)
  800f18:	ff 75 10             	pushl  0x10(%ebp)
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2b:	e8 d7 fd ff ff       	call   800d07 <syscall>
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800f3c:	6a 00                	push   $0x0
  800f3e:	6a 00                	push   $0x0
  800f40:	6a 00                	push   $0x0
  800f42:	6a 00                	push   $0x0
  800f44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f47:	ba 01 00 00 00       	mov    $0x1,%edx
  800f4c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f51:	e8 b1 fd ff ff       	call   800d07 <syscall>
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 04             	sub    $0x4,%esp
  800f5f:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  800f61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  800f68:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  800f6b:	f6 c6 04             	test   $0x4,%dh
  800f6e:	75 51                	jne    800fc1 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  800f70:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800f76:	0f 84 84 00 00 00    	je     801000 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	68 05 08 00 00       	push   $0x805
  800f84:	53                   	push   %ebx
  800f85:	50                   	push   %eax
  800f86:	53                   	push   %ebx
  800f87:	6a 00                	push   $0x0
  800f89:	e8 b5 fe ff ff       	call   800e43 <sys_page_map>
		if (r)
  800f8e:	83 c4 20             	add    $0x20,%esp
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 59                	jne    800fee <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	68 05 08 00 00       	push   $0x805
  800f9d:	53                   	push   %ebx
  800f9e:	6a 00                	push   $0x0
  800fa0:	53                   	push   %ebx
  800fa1:	6a 00                	push   $0x0
  800fa3:	e8 9b fe ff ff       	call   800e43 <sys_page_map>
		if (r)
  800fa8:	83 c4 20             	add    $0x20,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	74 67                	je     801016 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800faf:	50                   	push   %eax
  800fb0:	68 0a 2b 80 00       	push   $0x802b0a
  800fb5:	6a 5f                	push   $0x5f
  800fb7:	68 25 2b 80 00       	push   $0x802b25
  800fbc:	e8 81 f3 ff ff       	call   800342 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  800fc1:	83 ec 0c             	sub    $0xc,%esp
  800fc4:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fca:	52                   	push   %edx
  800fcb:	53                   	push   %ebx
  800fcc:	50                   	push   %eax
  800fcd:	53                   	push   %ebx
  800fce:	6a 00                	push   $0x0
  800fd0:	e8 6e fe ff ff       	call   800e43 <sys_page_map>
		if (r)
  800fd5:	83 c4 20             	add    $0x20,%esp
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	74 3a                	je     801016 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  800fdc:	50                   	push   %eax
  800fdd:	68 0a 2b 80 00       	push   $0x802b0a
  800fe2:	6a 57                	push   $0x57
  800fe4:	68 25 2b 80 00       	push   $0x802b25
  800fe9:	e8 54 f3 ff ff       	call   800342 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  800fee:	50                   	push   %eax
  800fef:	68 0a 2b 80 00       	push   $0x802b0a
  800ff4:	6a 5b                	push   $0x5b
  800ff6:	68 25 2b 80 00       	push   $0x802b25
  800ffb:	e8 42 f3 ff ff       	call   800342 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	6a 05                	push   $0x5
  801005:	53                   	push   %ebx
  801006:	50                   	push   %eax
  801007:	53                   	push   %ebx
  801008:	6a 00                	push   $0x0
  80100a:	e8 34 fe ff ff       	call   800e43 <sys_page_map>
		if (r)
  80100f:	83 c4 20             	add    $0x20,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	75 0a                	jne    801020 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  801016:	b8 00 00 00 00       	mov    $0x0,%eax
  80101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  801020:	50                   	push   %eax
  801021:	68 0a 2b 80 00       	push   $0x802b0a
  801026:	6a 63                	push   $0x63
  801028:	68 25 2b 80 00       	push   $0x802b25
  80102d:	e8 10 f3 ff ff       	call   800342 <_panic>

00801032 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 0c             	sub    $0xc,%esp
  80103b:	89 c7                	mov    %eax,%edi
  80103d:	89 d6                	mov    %edx,%esi
  80103f:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  801041:	f6 c1 02             	test   $0x2,%cl
  801044:	75 2f                	jne    801075 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	51                   	push   %ecx
  80104a:	52                   	push   %edx
  80104b:	50                   	push   %eax
  80104c:	52                   	push   %edx
  80104d:	6a 00                	push   $0x0
  80104f:	e8 ef fd ff ff       	call   800e43 <sys_page_map>
  801054:	83 c4 20             	add    $0x20,%esp
  801057:	85 c0                	test   %eax,%eax
  801059:	78 08                	js     801063 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  80105b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    
			panic("sys_page_map: %e", r);
  801063:	50                   	push   %eax
  801064:	68 14 2b 80 00       	push   $0x802b14
  801069:	6a 6f                	push   $0x6f
  80106b:	68 25 2b 80 00       	push   $0x802b25
  801070:	e8 cd f2 ff ff       	call   800342 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  801075:	83 ec 04             	sub    $0x4,%esp
  801078:	51                   	push   %ecx
  801079:	52                   	push   %edx
  80107a:	50                   	push   %eax
  80107b:	e8 9b fd ff ff       	call   800e1b <sys_page_alloc>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	78 54                	js     8010db <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  801087:	83 ec 0c             	sub    $0xc,%esp
  80108a:	53                   	push   %ebx
  80108b:	68 00 00 40 00       	push   $0x400000
  801090:	6a 00                	push   $0x0
  801092:	56                   	push   %esi
  801093:	57                   	push   %edi
  801094:	e8 aa fd ff ff       	call   800e43 <sys_page_map>
  801099:	83 c4 20             	add    $0x20,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 4d                	js     8010ed <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	68 00 10 00 00       	push   $0x1000
  8010a8:	56                   	push   %esi
  8010a9:	68 00 00 40 00       	push   $0x400000
  8010ae:	e8 98 fa ff ff       	call   800b4b <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8010b3:	83 c4 08             	add    $0x8,%esp
  8010b6:	68 00 00 40 00       	push   $0x400000
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 ab fd ff ff       	call   800e6d <sys_page_unmap>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	79 92                	jns    80105b <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  8010c9:	50                   	push   %eax
  8010ca:	68 43 2b 80 00       	push   $0x802b43
  8010cf:	6a 78                	push   $0x78
  8010d1:	68 25 2b 80 00       	push   $0x802b25
  8010d6:	e8 67 f2 ff ff       	call   800342 <_panic>
		panic("sys_page_alloc: %e", r);
  8010db:	50                   	push   %eax
  8010dc:	68 30 2b 80 00       	push   $0x802b30
  8010e1:	6a 73                	push   $0x73
  8010e3:	68 25 2b 80 00       	push   $0x802b25
  8010e8:	e8 55 f2 ff ff       	call   800342 <_panic>
		panic("sys_page_map: %e", r);
  8010ed:	50                   	push   %eax
  8010ee:	68 14 2b 80 00       	push   $0x802b14
  8010f3:	6a 75                	push   $0x75
  8010f5:	68 25 2b 80 00       	push   $0x802b25
  8010fa:	e8 43 f2 ff ff       	call   800342 <_panic>

008010ff <pgfault>:
{
  8010ff:	f3 0f 1e fb          	endbr32 
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	53                   	push   %ebx
  801107:	83 ec 04             	sub    $0x4,%esp
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80110d:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80110f:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  801112:	89 da                	mov    %ebx,%edx
  801114:	c1 ea 0c             	shr    $0xc,%edx
  801117:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  80111e:	a8 01                	test   $0x1,%al
  801120:	74 7e                	je     8011a0 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  801122:	a8 02                	test   $0x2,%al
  801124:	0f 84 8a 00 00 00    	je     8011b4 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  80112a:	f6 c6 08             	test   $0x8,%dh
  80112d:	0f 84 95 00 00 00    	je     8011c8 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  801133:	83 ec 04             	sub    $0x4,%esp
  801136:	6a 07                	push   $0x7
  801138:	68 00 f0 7f 00       	push   $0x7ff000
  80113d:	6a 00                	push   $0x0
  80113f:	e8 d7 fc ff ff       	call   800e1b <sys_page_alloc>
	if (r)
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	0f 85 8d 00 00 00    	jne    8011dc <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80114f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801155:	83 ec 04             	sub    $0x4,%esp
  801158:	68 00 10 00 00       	push   $0x1000
  80115d:	53                   	push   %ebx
  80115e:	68 00 f0 7f 00       	push   $0x7ff000
  801163:	e8 49 fa ff ff       	call   800bb1 <memcpy>
	r = sys_page_map(
  801168:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80116f:	53                   	push   %ebx
  801170:	6a 00                	push   $0x0
  801172:	68 00 f0 7f 00       	push   $0x7ff000
  801177:	6a 00                	push   $0x0
  801179:	e8 c5 fc ff ff       	call   800e43 <sys_page_map>
	if (r)
  80117e:	83 c4 20             	add    $0x20,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	75 69                	jne    8011ee <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  801185:	83 ec 08             	sub    $0x8,%esp
  801188:	68 00 f0 7f 00       	push   $0x7ff000
  80118d:	6a 00                	push   $0x0
  80118f:	e8 d9 fc ff ff       	call   800e6d <sys_page_unmap>
	if (r)
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	75 65                	jne    801200 <pgfault+0x101>
}
  80119b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  8011a0:	83 ec 04             	sub    $0x4,%esp
  8011a3:	68 c4 2b 80 00       	push   $0x802bc4
  8011a8:	6a 20                	push   $0x20
  8011aa:	68 25 2b 80 00       	push   $0x802b25
  8011af:	e8 8e f1 ff ff       	call   800342 <_panic>
		panic("[pgfault] pgfault por lectura");
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	68 56 2b 80 00       	push   $0x802b56
  8011bc:	6a 23                	push   $0x23
  8011be:	68 25 2b 80 00       	push   $0x802b25
  8011c3:	e8 7a f1 ff ff       	call   800342 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 f0 2b 80 00       	push   $0x802bf0
  8011d0:	6a 27                	push   $0x27
  8011d2:	68 25 2b 80 00       	push   $0x802b25
  8011d7:	e8 66 f1 ff ff       	call   800342 <_panic>
		panic("pgfault: %e", r);
  8011dc:	50                   	push   %eax
  8011dd:	68 74 2b 80 00       	push   $0x802b74
  8011e2:	6a 32                	push   $0x32
  8011e4:	68 25 2b 80 00       	push   $0x802b25
  8011e9:	e8 54 f1 ff ff       	call   800342 <_panic>
		panic("pgfault: %e", r);
  8011ee:	50                   	push   %eax
  8011ef:	68 74 2b 80 00       	push   $0x802b74
  8011f4:	6a 39                	push   $0x39
  8011f6:	68 25 2b 80 00       	push   $0x802b25
  8011fb:	e8 42 f1 ff ff       	call   800342 <_panic>
		panic("pgfault: %e", r);
  801200:	50                   	push   %eax
  801201:	68 74 2b 80 00       	push   $0x802b74
  801206:	6a 3d                	push   $0x3d
  801208:	68 25 2b 80 00       	push   $0x802b25
  80120d:	e8 30 f1 ff ff       	call   800342 <_panic>

00801212 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  801212:	f3 0f 1e fb          	endbr32 
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	57                   	push   %edi
  80121a:	56                   	push   %esi
  80121b:	53                   	push   %ebx
  80121c:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80121f:	b8 07 00 00 00       	mov    $0x7,%eax
  801224:	cd 30                	int    $0x30
  801226:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 22                	js     80124e <fork_v0+0x3c>
  80122c:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801233:	75 52                	jne    801287 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801235:	e8 8e fb ff ff       	call   800dc8 <sys_getenvid>
  80123a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80123f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801242:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801247:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80124c:	eb 6e                	jmp    8012bc <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80124e:	50                   	push   %eax
  80124f:	68 18 2c 80 00       	push   $0x802c18
  801254:	68 8a 00 00 00       	push   $0x8a
  801259:	68 25 2b 80 00       	push   $0x802b25
  80125e:	e8 df f0 ff ff       	call   800342 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801263:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  80126a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801270:	89 da                	mov    %ebx,%edx
  801272:	89 f0                	mov    %esi,%eax
  801274:	e8 b9 fd ff ff       	call   801032 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801279:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80127f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801285:	74 23                	je     8012aa <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e8 16             	shr    $0x16,%eax
  80128c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801293:	a8 01                	test   $0x1,%al
  801295:	74 e2                	je     801279 <fork_v0+0x67>
  801297:	89 d8                	mov    %ebx,%eax
  801299:	c1 e8 0c             	shr    $0xc,%eax
  80129c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a3:	f6 c2 01             	test   $0x1,%dl
  8012a6:	74 d1                	je     801279 <fork_v0+0x67>
  8012a8:	eb b9                	jmp    801263 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	6a 02                	push   $0x2
  8012af:	57                   	push   %edi
  8012b0:	e8 df fb ff ff       	call   800e94 <sys_env_set_status>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 0a                	js     8012c6 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  8012bc:	89 f8                	mov    %edi,%eax
  8012be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c1:	5b                   	pop    %ebx
  8012c2:	5e                   	pop    %esi
  8012c3:	5f                   	pop    %edi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8012c6:	50                   	push   %eax
  8012c7:	68 3c 2c 80 00       	push   $0x802c3c
  8012cc:	68 98 00 00 00       	push   $0x98
  8012d1:	68 25 2b 80 00       	push   $0x802b25
  8012d6:	e8 67 f0 ff ff       	call   800342 <_panic>

008012db <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012db:	f3 0f 1e fb          	endbr32 
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	57                   	push   %edi
  8012e3:	56                   	push   %esi
  8012e4:	53                   	push   %ebx
  8012e5:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8012e8:	68 ff 10 80 00       	push   $0x8010ff
  8012ed:	e8 10 0f 00 00       	call   802202 <set_pgfault_handler>
  8012f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8012f7:	cd 30                	int    $0x30
  8012f9:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 37                	js     801339 <fork+0x5e>
  801302:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801304:	74 48                	je     80134e <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	6a 07                	push   $0x7
  80130b:	68 00 f0 bf ee       	push   $0xeebff000
  801310:	50                   	push   %eax
  801311:	e8 05 fb ff ff       	call   800e1b <sys_page_alloc>
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 4d                	js     80136a <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	68 7f 22 80 00       	push   $0x80227f
  801325:	56                   	push   %esi
  801326:	e8 b7 fb ff ff       	call   800ee2 <sys_env_set_pgfault_upcall>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 4d                	js     80137f <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801332:	bb 00 00 00 00       	mov    $0x0,%ebx
  801337:	eb 70                	jmp    8013a9 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801339:	50                   	push   %eax
  80133a:	68 80 2b 80 00       	push   $0x802b80
  80133f:	68 b7 00 00 00       	push   $0xb7
  801344:	68 25 2b 80 00       	push   $0x802b25
  801349:	e8 f4 ef ff ff       	call   800342 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80134e:	e8 75 fa ff ff       	call   800dc8 <sys_getenvid>
  801353:	25 ff 03 00 00       	and    $0x3ff,%eax
  801358:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80135b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801360:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801365:	e9 80 00 00 00       	jmp    8013ea <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  80136a:	50                   	push   %eax
  80136b:	68 90 2b 80 00       	push   $0x802b90
  801370:	68 c0 00 00 00       	push   $0xc0
  801375:	68 25 2b 80 00       	push   $0x802b25
  80137a:	e8 c3 ef ff ff       	call   800342 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80137f:	50                   	push   %eax
  801380:	68 60 2c 80 00       	push   $0x802c60
  801385:	68 c3 00 00 00       	push   $0xc3
  80138a:	68 25 2b 80 00       	push   $0x802b25
  80138f:	e8 ae ef ff ff       	call   800342 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801394:	89 f8                	mov    %edi,%eax
  801396:	e8 bd fb ff ff       	call   800f58 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80139b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013a1:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8013a7:	74 2f                	je     8013d8 <fork+0xfd>
  8013a9:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  8013ab:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  8013b1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8013b6:	76 e3                	jbe    80139b <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	c1 e8 16             	shr    $0x16,%eax
  8013bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c4:	a8 01                	test   $0x1,%al
  8013c6:	74 d3                	je     80139b <fork+0xc0>
  8013c8:	c1 ea 0c             	shr    $0xc,%edx
  8013cb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013d2:	a8 01                	test   $0x1,%al
  8013d4:	74 c5                	je     80139b <fork+0xc0>
  8013d6:	eb bc                	jmp    801394 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	6a 02                	push   $0x2
  8013dd:	56                   	push   %esi
  8013de:	e8 b1 fa ff ff       	call   800e94 <sys_env_set_status>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 0a                	js     8013f4 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8013ea:	89 f0                	mov    %esi,%eax
  8013ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5f                   	pop    %edi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8013f4:	50                   	push   %eax
  8013f5:	68 8c 2c 80 00       	push   $0x802c8c
  8013fa:	68 ce 00 00 00       	push   $0xce
  8013ff:	68 25 2b 80 00       	push   $0x802b25
  801404:	e8 39 ef ff ff       	call   800342 <_panic>

00801409 <sfork>:

// Challenge!
int
sfork(void)
{
  801409:	f3 0f 1e fb          	endbr32 
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801413:	68 ae 2b 80 00       	push   $0x802bae
  801418:	68 d7 00 00 00       	push   $0xd7
  80141d:	68 25 2b 80 00       	push   $0x802b25
  801422:	e8 1b ef ff ff       	call   800342 <_panic>

00801427 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801427:	f3 0f 1e fb          	endbr32 
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	05 00 00 00 30       	add    $0x30000000,%eax
  801436:	c1 e8 0c             	shr    $0xc,%eax
}
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    

0080143b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80143b:	f3 0f 1e fb          	endbr32 
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801445:	ff 75 08             	pushl  0x8(%ebp)
  801448:	e8 da ff ff ff       	call   801427 <fd2num>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	c1 e0 0c             	shl    $0xc,%eax
  801453:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80145a:	f3 0f 1e fb          	endbr32 
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801466:	89 c2                	mov    %eax,%edx
  801468:	c1 ea 16             	shr    $0x16,%edx
  80146b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801472:	f6 c2 01             	test   $0x1,%dl
  801475:	74 2d                	je     8014a4 <fd_alloc+0x4a>
  801477:	89 c2                	mov    %eax,%edx
  801479:	c1 ea 0c             	shr    $0xc,%edx
  80147c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801483:	f6 c2 01             	test   $0x1,%dl
  801486:	74 1c                	je     8014a4 <fd_alloc+0x4a>
  801488:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80148d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801492:	75 d2                	jne    801466 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80149d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014a2:	eb 0a                	jmp    8014ae <fd_alloc+0x54>
			*fd_store = fd;
  8014a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014b0:	f3 0f 1e fb          	endbr32 
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014ba:	83 f8 1f             	cmp    $0x1f,%eax
  8014bd:	77 30                	ja     8014ef <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014bf:	c1 e0 0c             	shl    $0xc,%eax
  8014c2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014c7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014cd:	f6 c2 01             	test   $0x1,%dl
  8014d0:	74 24                	je     8014f6 <fd_lookup+0x46>
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	c1 ea 0c             	shr    $0xc,%edx
  8014d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014de:	f6 c2 01             	test   $0x1,%dl
  8014e1:	74 1a                	je     8014fd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 02                	mov    %eax,(%edx)
	return 0;
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    
		return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb f7                	jmp    8014ed <fd_lookup+0x3d>
		return -E_INVAL;
  8014f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fb:	eb f0                	jmp    8014ed <fd_lookup+0x3d>
  8014fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801502:	eb e9                	jmp    8014ed <fd_lookup+0x3d>

00801504 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801504:	f3 0f 1e fb          	endbr32 
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801511:	ba 2c 2d 80 00       	mov    $0x802d2c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801516:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80151b:	39 08                	cmp    %ecx,(%eax)
  80151d:	74 33                	je     801552 <dev_lookup+0x4e>
  80151f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801522:	8b 02                	mov    (%edx),%eax
  801524:	85 c0                	test   %eax,%eax
  801526:	75 f3                	jne    80151b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801528:	a1 04 40 80 00       	mov    0x804004,%eax
  80152d:	8b 40 48             	mov    0x48(%eax),%eax
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	51                   	push   %ecx
  801534:	50                   	push   %eax
  801535:	68 b0 2c 80 00       	push   $0x802cb0
  80153a:	e8 ea ee ff ff       	call   800429 <cprintf>
	*dev = 0;
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    
			*dev = devtab[i];
  801552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801555:	89 01                	mov    %eax,(%ecx)
			return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
  80155c:	eb f2                	jmp    801550 <dev_lookup+0x4c>

0080155e <fd_close>:
{
  80155e:	f3 0f 1e fb          	endbr32 
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	57                   	push   %edi
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	83 ec 28             	sub    $0x28,%esp
  80156b:	8b 75 08             	mov    0x8(%ebp),%esi
  80156e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801571:	56                   	push   %esi
  801572:	e8 b0 fe ff ff       	call   801427 <fd2num>
  801577:	83 c4 08             	add    $0x8,%esp
  80157a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	e8 2c ff ff ff       	call   8014b0 <fd_lookup>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 05                	js     801592 <fd_close+0x34>
	    || fd != fd2)
  80158d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801590:	74 16                	je     8015a8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801592:	89 f8                	mov    %edi,%eax
  801594:	84 c0                	test   %al,%al
  801596:	b8 00 00 00 00       	mov    $0x0,%eax
  80159b:	0f 44 d8             	cmove  %eax,%ebx
}
  80159e:	89 d8                	mov    %ebx,%eax
  8015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5f                   	pop    %edi
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	ff 36                	pushl  (%esi)
  8015b1:	e8 4e ff ff ff       	call   801504 <dev_lookup>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 1a                	js     8015d9 <fd_close+0x7b>
		if (dev->dev_close)
  8015bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	74 0b                	je     8015d9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	56                   	push   %esi
  8015d2:	ff d0                	call   *%eax
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	56                   	push   %esi
  8015dd:	6a 00                	push   $0x0
  8015df:	e8 89 f8 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	eb b5                	jmp    80159e <fd_close+0x40>

008015e9 <close>:

int
close(int fdnum)
{
  8015e9:	f3 0f 1e fb          	endbr32 
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	e8 b1 fe ff ff       	call   8014b0 <fd_lookup>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	79 02                	jns    801608 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    
		return fd_close(fd, 1);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	6a 01                	push   $0x1
  80160d:	ff 75 f4             	pushl  -0xc(%ebp)
  801610:	e8 49 ff ff ff       	call   80155e <fd_close>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	eb ec                	jmp    801606 <close+0x1d>

0080161a <close_all>:

void
close_all(void)
{
  80161a:	f3 0f 1e fb          	endbr32 
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	53                   	push   %ebx
  801622:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	53                   	push   %ebx
  80162e:	e8 b6 ff ff ff       	call   8015e9 <close>
	for (i = 0; i < MAXFD; i++)
  801633:	83 c3 01             	add    $0x1,%ebx
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	83 fb 20             	cmp    $0x20,%ebx
  80163c:	75 ec                	jne    80162a <close_all+0x10>
}
  80163e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801643:	f3 0f 1e fb          	endbr32 
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	57                   	push   %edi
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 54 fe ff ff       	call   8014b0 <fd_lookup>
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	0f 88 81 00 00 00    	js     8016ea <dup+0xa7>
		return r;
	close(newfdnum);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	e8 75 ff ff ff       	call   8015e9 <close>

	newfd = INDEX2FD(newfdnum);
  801674:	8b 75 0c             	mov    0xc(%ebp),%esi
  801677:	c1 e6 0c             	shl    $0xc,%esi
  80167a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801680:	83 c4 04             	add    $0x4,%esp
  801683:	ff 75 e4             	pushl  -0x1c(%ebp)
  801686:	e8 b0 fd ff ff       	call   80143b <fd2data>
  80168b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80168d:	89 34 24             	mov    %esi,(%esp)
  801690:	e8 a6 fd ff ff       	call   80143b <fd2data>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	c1 e8 16             	shr    $0x16,%eax
  80169f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a6:	a8 01                	test   $0x1,%al
  8016a8:	74 11                	je     8016bb <dup+0x78>
  8016aa:	89 d8                	mov    %ebx,%eax
  8016ac:	c1 e8 0c             	shr    $0xc,%eax
  8016af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	75 39                	jne    8016f4 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	c1 e8 0c             	shr    $0xc,%eax
  8016c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ca:	83 ec 0c             	sub    $0xc,%esp
  8016cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d2:	50                   	push   %eax
  8016d3:	56                   	push   %esi
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	6a 00                	push   $0x0
  8016d9:	e8 65 f7 ff ff       	call   800e43 <sys_page_map>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	83 c4 20             	add    $0x20,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 31                	js     801718 <dup+0xd5>
		goto err;

	return newfdnum;
  8016e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016ea:	89 d8                	mov    %ebx,%eax
  8016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5f                   	pop    %edi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801703:	50                   	push   %eax
  801704:	57                   	push   %edi
  801705:	6a 00                	push   $0x0
  801707:	53                   	push   %ebx
  801708:	6a 00                	push   $0x0
  80170a:	e8 34 f7 ff ff       	call   800e43 <sys_page_map>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 20             	add    $0x20,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	79 a3                	jns    8016bb <dup+0x78>
	sys_page_unmap(0, newfd);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	56                   	push   %esi
  80171c:	6a 00                	push   $0x0
  80171e:	e8 4a f7 ff ff       	call   800e6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801723:	83 c4 08             	add    $0x8,%esp
  801726:	57                   	push   %edi
  801727:	6a 00                	push   $0x0
  801729:	e8 3f f7 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	eb b7                	jmp    8016ea <dup+0xa7>

00801733 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801733:	f3 0f 1e fb          	endbr32 
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 1c             	sub    $0x1c,%esp
  80173e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801744:	50                   	push   %eax
  801745:	53                   	push   %ebx
  801746:	e8 65 fd ff ff       	call   8014b0 <fd_lookup>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 3f                	js     801791 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	ff 30                	pushl  (%eax)
  80175e:	e8 a1 fd ff ff       	call   801504 <dev_lookup>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	78 27                	js     801791 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80176a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176d:	8b 42 08             	mov    0x8(%edx),%eax
  801770:	83 e0 03             	and    $0x3,%eax
  801773:	83 f8 01             	cmp    $0x1,%eax
  801776:	74 1e                	je     801796 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	8b 40 08             	mov    0x8(%eax),%eax
  80177e:	85 c0                	test   %eax,%eax
  801780:	74 35                	je     8017b7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 10             	pushl  0x10(%ebp)
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	52                   	push   %edx
  80178c:	ff d0                	call   *%eax
  80178e:	83 c4 10             	add    $0x10,%esp
}
  801791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801794:	c9                   	leave  
  801795:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801796:	a1 04 40 80 00       	mov    0x804004,%eax
  80179b:	8b 40 48             	mov    0x48(%eax),%eax
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	53                   	push   %ebx
  8017a2:	50                   	push   %eax
  8017a3:	68 f1 2c 80 00       	push   $0x802cf1
  8017a8:	e8 7c ec ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b5:	eb da                	jmp    801791 <read+0x5e>
		return -E_NOT_SUPP;
  8017b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bc:	eb d3                	jmp    801791 <read+0x5e>

008017be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017be:	f3 0f 1e fb          	endbr32 
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	57                   	push   %edi
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017ce:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d6:	eb 02                	jmp    8017da <readn+0x1c>
  8017d8:	01 c3                	add    %eax,%ebx
  8017da:	39 f3                	cmp    %esi,%ebx
  8017dc:	73 21                	jae    8017ff <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	89 f0                	mov    %esi,%eax
  8017e3:	29 d8                	sub    %ebx,%eax
  8017e5:	50                   	push   %eax
  8017e6:	89 d8                	mov    %ebx,%eax
  8017e8:	03 45 0c             	add    0xc(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	57                   	push   %edi
  8017ed:	e8 41 ff ff ff       	call   801733 <read>
		if (m < 0)
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 04                	js     8017fd <readn+0x3f>
			return m;
		if (m == 0)
  8017f9:	75 dd                	jne    8017d8 <readn+0x1a>
  8017fb:	eb 02                	jmp    8017ff <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017fd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017ff:	89 d8                	mov    %ebx,%eax
  801801:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    

00801809 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801809:	f3 0f 1e fb          	endbr32 
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	53                   	push   %ebx
  801811:	83 ec 1c             	sub    $0x1c,%esp
  801814:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801817:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181a:	50                   	push   %eax
  80181b:	53                   	push   %ebx
  80181c:	e8 8f fc ff ff       	call   8014b0 <fd_lookup>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	85 c0                	test   %eax,%eax
  801826:	78 3a                	js     801862 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801828:	83 ec 08             	sub    $0x8,%esp
  80182b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182e:	50                   	push   %eax
  80182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801832:	ff 30                	pushl  (%eax)
  801834:	e8 cb fc ff ff       	call   801504 <dev_lookup>
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 22                	js     801862 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801843:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801847:	74 1e                	je     801867 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184c:	8b 52 0c             	mov    0xc(%edx),%edx
  80184f:	85 d2                	test   %edx,%edx
  801851:	74 35                	je     801888 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	ff d2                	call   *%edx
  80185f:	83 c4 10             	add    $0x10,%esp
}
  801862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801865:	c9                   	leave  
  801866:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801867:	a1 04 40 80 00       	mov    0x804004,%eax
  80186c:	8b 40 48             	mov    0x48(%eax),%eax
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	53                   	push   %ebx
  801873:	50                   	push   %eax
  801874:	68 0d 2d 80 00       	push   $0x802d0d
  801879:	e8 ab eb ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801886:	eb da                	jmp    801862 <write+0x59>
		return -E_NOT_SUPP;
  801888:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188d:	eb d3                	jmp    801862 <write+0x59>

0080188f <seek>:

int
seek(int fdnum, off_t offset)
{
  80188f:	f3 0f 1e fb          	endbr32 
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801899:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189c:	50                   	push   %eax
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	e8 0b fc ff ff       	call   8014b0 <fd_lookup>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	78 0e                	js     8018ba <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018bc:	f3 0f 1e fb          	endbr32 
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 1c             	sub    $0x1c,%esp
  8018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	53                   	push   %ebx
  8018cf:	e8 dc fb ff ff       	call   8014b0 <fd_lookup>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 37                	js     801912 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e1:	50                   	push   %eax
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	ff 30                	pushl  (%eax)
  8018e7:	e8 18 fc ff ff       	call   801504 <dev_lookup>
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 1f                	js     801912 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fa:	74 1b                	je     801917 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ff:	8b 52 18             	mov    0x18(%edx),%edx
  801902:	85 d2                	test   %edx,%edx
  801904:	74 32                	je     801938 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	50                   	push   %eax
  80190d:	ff d2                	call   *%edx
  80190f:	83 c4 10             	add    $0x10,%esp
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    
			thisenv->env_id, fdnum);
  801917:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80191c:	8b 40 48             	mov    0x48(%eax),%eax
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	53                   	push   %ebx
  801923:	50                   	push   %eax
  801924:	68 d0 2c 80 00       	push   $0x802cd0
  801929:	e8 fb ea ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801936:	eb da                	jmp    801912 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801938:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193d:	eb d3                	jmp    801912 <ftruncate+0x56>

0080193f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80193f:	f3 0f 1e fb          	endbr32 
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	53                   	push   %ebx
  801947:	83 ec 1c             	sub    $0x1c,%esp
  80194a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	e8 57 fb ff ff       	call   8014b0 <fd_lookup>
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 4b                	js     8019ab <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801966:	50                   	push   %eax
  801967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196a:	ff 30                	pushl  (%eax)
  80196c:	e8 93 fb ff ff       	call   801504 <dev_lookup>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 33                	js     8019ab <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80197f:	74 2f                	je     8019b0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801981:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801984:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80198b:	00 00 00 
	stat->st_isdir = 0;
  80198e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801995:	00 00 00 
	stat->st_dev = dev;
  801998:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	53                   	push   %ebx
  8019a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a5:	ff 50 14             	call   *0x14(%eax)
  8019a8:	83 c4 10             	add    $0x10,%esp
}
  8019ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    
		return -E_NOT_SUPP;
  8019b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b5:	eb f4                	jmp    8019ab <fstat+0x6c>

008019b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019b7:	f3 0f 1e fb          	endbr32 
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 3a 02 00 00       	call   801c07 <open>
  8019cd:	89 c3                	mov    %eax,%ebx
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	78 1b                	js     8019f1 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	e8 5d ff ff ff       	call   80193f <fstat>
  8019e2:	89 c6                	mov    %eax,%esi
	close(fd);
  8019e4:	89 1c 24             	mov    %ebx,(%esp)
  8019e7:	e8 fd fb ff ff       	call   8015e9 <close>
	return r;
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	89 f3                	mov    %esi,%ebx
}
  8019f1:	89 d8                	mov    %ebx,%eax
  8019f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    

008019fa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
  8019ff:	89 c6                	mov    %eax,%esi
  801a01:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a03:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a0a:	74 27                	je     801a33 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a0c:	6a 07                	push   $0x7
  801a0e:	68 00 50 80 00       	push   $0x805000
  801a13:	56                   	push   %esi
  801a14:	ff 35 00 40 80 00    	pushl  0x804000
  801a1a:	e8 f3 08 00 00       	call   802312 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a1f:	83 c4 0c             	add    $0xc,%esp
  801a22:	6a 00                	push   $0x0
  801a24:	53                   	push   %ebx
  801a25:	6a 00                	push   $0x0
  801a27:	e8 79 08 00 00       	call   8022a5 <ipc_recv>
}
  801a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	6a 01                	push   $0x1
  801a38:	e8 2d 09 00 00       	call   80236a <ipc_find_env>
  801a3d:	a3 00 40 80 00       	mov    %eax,0x804000
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	eb c5                	jmp    801a0c <fsipc+0x12>

00801a47 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a47:	f3 0f 1e fb          	endbr32 
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	8b 40 0c             	mov    0xc(%eax),%eax
  801a57:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6e:	e8 87 ff ff ff       	call   8019fa <fsipc>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <devfile_flush>:
{
  801a75:	f3 0f 1e fb          	endbr32 
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8b 40 0c             	mov    0xc(%eax),%eax
  801a85:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	b8 06 00 00 00       	mov    $0x6,%eax
  801a94:	e8 61 ff ff ff       	call   8019fa <fsipc>
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <devfile_stat>:
{
  801a9b:	f3 0f 1e fb          	endbr32 
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	53                   	push   %ebx
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	8b 40 0c             	mov    0xc(%eax),%eax
  801aaf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	b8 05 00 00 00       	mov    $0x5,%eax
  801abe:	e8 37 ff ff ff       	call   8019fa <fsipc>
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 2c                	js     801af3 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	68 00 50 80 00       	push   $0x805000
  801acf:	53                   	push   %ebx
  801ad0:	e8 be ee ff ff       	call   800993 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ad5:	a1 80 50 80 00       	mov    0x805080,%eax
  801ada:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ae0:	a1 84 50 80 00       	mov    0x805084,%eax
  801ae5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <devfile_write>:
{
  801af8:	f3 0f 1e fb          	endbr32 
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801b11:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801b17:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b1d:	77 30                	ja     801b4f <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	53                   	push   %ebx
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	68 08 50 80 00       	push   $0x805008
  801b2b:	e8 1b f0 ff ff       	call   800b4b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b30:	ba 00 00 00 00       	mov    $0x0,%edx
  801b35:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3a:	e8 bb fe ff ff       	call   8019fa <fsipc>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 04                	js     801b4a <devfile_write+0x52>
	assert(r <= n);
  801b46:	39 d8                	cmp    %ebx,%eax
  801b48:	77 1e                	ja     801b68 <devfile_write+0x70>
}
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801b4f:	68 3c 2d 80 00       	push   $0x802d3c
  801b54:	68 69 2d 80 00       	push   $0x802d69
  801b59:	68 94 00 00 00       	push   $0x94
  801b5e:	68 7e 2d 80 00       	push   $0x802d7e
  801b63:	e8 da e7 ff ff       	call   800342 <_panic>
	assert(r <= n);
  801b68:	68 89 2d 80 00       	push   $0x802d89
  801b6d:	68 69 2d 80 00       	push   $0x802d69
  801b72:	68 98 00 00 00       	push   $0x98
  801b77:	68 7e 2d 80 00       	push   $0x802d7e
  801b7c:	e8 c1 e7 ff ff       	call   800342 <_panic>

00801b81 <devfile_read>:
{
  801b81:	f3 0f 1e fb          	endbr32 
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	56                   	push   %esi
  801b89:	53                   	push   %ebx
  801b8a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	8b 40 0c             	mov    0xc(%eax),%eax
  801b93:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b98:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba8:	e8 4d fe ff ff       	call   8019fa <fsipc>
  801bad:	89 c3                	mov    %eax,%ebx
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 1f                	js     801bd2 <devfile_read+0x51>
	assert(r <= n);
  801bb3:	39 f0                	cmp    %esi,%eax
  801bb5:	77 24                	ja     801bdb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801bb7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bbc:	7f 33                	jg     801bf1 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	50                   	push   %eax
  801bc2:	68 00 50 80 00       	push   $0x805000
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 7c ef ff ff       	call   800b4b <memmove>
	return r;
  801bcf:	83 c4 10             	add    $0x10,%esp
}
  801bd2:	89 d8                	mov    %ebx,%eax
  801bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    
	assert(r <= n);
  801bdb:	68 89 2d 80 00       	push   $0x802d89
  801be0:	68 69 2d 80 00       	push   $0x802d69
  801be5:	6a 7c                	push   $0x7c
  801be7:	68 7e 2d 80 00       	push   $0x802d7e
  801bec:	e8 51 e7 ff ff       	call   800342 <_panic>
	assert(r <= PGSIZE);
  801bf1:	68 90 2d 80 00       	push   $0x802d90
  801bf6:	68 69 2d 80 00       	push   $0x802d69
  801bfb:	6a 7d                	push   $0x7d
  801bfd:	68 7e 2d 80 00       	push   $0x802d7e
  801c02:	e8 3b e7 ff ff       	call   800342 <_panic>

00801c07 <open>:
{
  801c07:	f3 0f 1e fb          	endbr32 
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 1c             	sub    $0x1c,%esp
  801c13:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c16:	56                   	push   %esi
  801c17:	e8 34 ed ff ff       	call   800950 <strlen>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c24:	7f 6c                	jg     801c92 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2c:	50                   	push   %eax
  801c2d:	e8 28 f8 ff ff       	call   80145a <fd_alloc>
  801c32:	89 c3                	mov    %eax,%ebx
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	85 c0                	test   %eax,%eax
  801c39:	78 3c                	js     801c77 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801c3b:	83 ec 08             	sub    $0x8,%esp
  801c3e:	56                   	push   %esi
  801c3f:	68 00 50 80 00       	push   $0x805000
  801c44:	e8 4a ed ff ff       	call   800993 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c54:	b8 01 00 00 00       	mov    $0x1,%eax
  801c59:	e8 9c fd ff ff       	call   8019fa <fsipc>
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 19                	js     801c80 <open+0x79>
	return fd2num(fd);
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6d:	e8 b5 f7 ff ff       	call   801427 <fd2num>
  801c72:	89 c3                	mov    %eax,%ebx
  801c74:	83 c4 10             	add    $0x10,%esp
}
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
		fd_close(fd, 0);
  801c80:	83 ec 08             	sub    $0x8,%esp
  801c83:	6a 00                	push   $0x0
  801c85:	ff 75 f4             	pushl  -0xc(%ebp)
  801c88:	e8 d1 f8 ff ff       	call   80155e <fd_close>
		return r;
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	eb e5                	jmp    801c77 <open+0x70>
		return -E_BAD_PATH;
  801c92:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c97:	eb de                	jmp    801c77 <open+0x70>

00801c99 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c99:	f3 0f 1e fb          	endbr32 
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	b8 08 00 00 00       	mov    $0x8,%eax
  801cad:	e8 48 fd ff ff       	call   8019fa <fsipc>
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	56                   	push   %esi
  801cbc:	53                   	push   %ebx
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	e8 70 f7 ff ff       	call   80143b <fd2data>
  801ccb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ccd:	83 c4 08             	add    $0x8,%esp
  801cd0:	68 9c 2d 80 00       	push   $0x802d9c
  801cd5:	53                   	push   %ebx
  801cd6:	e8 b8 ec ff ff       	call   800993 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdb:	8b 46 04             	mov    0x4(%esi),%eax
  801cde:	2b 06                	sub    (%esi),%eax
  801ce0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ced:	00 00 00 
	stat->st_dev = &devpipe;
  801cf0:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801cf7:	30 80 00 
	return 0;
}
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d14:	53                   	push   %ebx
  801d15:	6a 00                	push   $0x0
  801d17:	e8 51 f1 ff ff       	call   800e6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d1c:	89 1c 24             	mov    %ebx,(%esp)
  801d1f:	e8 17 f7 ff ff       	call   80143b <fd2data>
  801d24:	83 c4 08             	add    $0x8,%esp
  801d27:	50                   	push   %eax
  801d28:	6a 00                	push   $0x0
  801d2a:	e8 3e f1 ff ff       	call   800e6d <sys_page_unmap>
}
  801d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <_pipeisclosed>:
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	57                   	push   %edi
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	83 ec 1c             	sub    $0x1c,%esp
  801d3d:	89 c7                	mov    %eax,%edi
  801d3f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d41:	a1 04 40 80 00       	mov    0x804004,%eax
  801d46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	57                   	push   %edi
  801d4d:	e8 55 06 00 00       	call   8023a7 <pageref>
  801d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d55:	89 34 24             	mov    %esi,(%esp)
  801d58:	e8 4a 06 00 00       	call   8023a7 <pageref>
		nn = thisenv->env_runs;
  801d5d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d63:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	39 cb                	cmp    %ecx,%ebx
  801d6b:	74 1b                	je     801d88 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d70:	75 cf                	jne    801d41 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d72:	8b 42 58             	mov    0x58(%edx),%eax
  801d75:	6a 01                	push   $0x1
  801d77:	50                   	push   %eax
  801d78:	53                   	push   %ebx
  801d79:	68 a3 2d 80 00       	push   $0x802da3
  801d7e:	e8 a6 e6 ff ff       	call   800429 <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	eb b9                	jmp    801d41 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d88:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8b:	0f 94 c0             	sete   %al
  801d8e:	0f b6 c0             	movzbl %al,%eax
}
  801d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5e                   	pop    %esi
  801d96:	5f                   	pop    %edi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <devpipe_write>:
{
  801d99:	f3 0f 1e fb          	endbr32 
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	57                   	push   %edi
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 28             	sub    $0x28,%esp
  801da6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da9:	56                   	push   %esi
  801daa:	e8 8c f6 ff ff       	call   80143b <fd2data>
  801daf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	bf 00 00 00 00       	mov    $0x0,%edi
  801db9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dbc:	74 4f                	je     801e0d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dbe:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc1:	8b 0b                	mov    (%ebx),%ecx
  801dc3:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc6:	39 d0                	cmp    %edx,%eax
  801dc8:	72 14                	jb     801dde <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801dca:	89 da                	mov    %ebx,%edx
  801dcc:	89 f0                	mov    %esi,%eax
  801dce:	e8 61 ff ff ff       	call   801d34 <_pipeisclosed>
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	75 3b                	jne    801e12 <devpipe_write+0x79>
			sys_yield();
  801dd7:	e8 14 f0 ff ff       	call   800df0 <sys_yield>
  801ddc:	eb e0                	jmp    801dbe <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	c1 fa 1f             	sar    $0x1f,%edx
  801ded:	89 d1                	mov    %edx,%ecx
  801def:	c1 e9 1b             	shr    $0x1b,%ecx
  801df2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df5:	83 e2 1f             	and    $0x1f,%edx
  801df8:	29 ca                	sub    %ecx,%edx
  801dfa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dfe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e02:	83 c0 01             	add    $0x1,%eax
  801e05:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e08:	83 c7 01             	add    $0x1,%edi
  801e0b:	eb ac                	jmp    801db9 <devpipe_write+0x20>
	return i;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	eb 05                	jmp    801e17 <devpipe_write+0x7e>
				return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devpipe_read>:
{
  801e1f:	f3 0f 1e fb          	endbr32 
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 18             	sub    $0x18,%esp
  801e2c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e2f:	57                   	push   %edi
  801e30:	e8 06 f6 ff ff       	call   80143b <fd2data>
  801e35:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	be 00 00 00 00       	mov    $0x0,%esi
  801e3f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e42:	75 14                	jne    801e58 <devpipe_read+0x39>
	return i;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	eb 02                	jmp    801e4b <devpipe_read+0x2c>
				return i;
  801e49:	89 f0                	mov    %esi,%eax
}
  801e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    
			sys_yield();
  801e53:	e8 98 ef ff ff       	call   800df0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e58:	8b 03                	mov    (%ebx),%eax
  801e5a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e5d:	75 18                	jne    801e77 <devpipe_read+0x58>
			if (i > 0)
  801e5f:	85 f6                	test   %esi,%esi
  801e61:	75 e6                	jne    801e49 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e63:	89 da                	mov    %ebx,%edx
  801e65:	89 f8                	mov    %edi,%eax
  801e67:	e8 c8 fe ff ff       	call   801d34 <_pipeisclosed>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	74 e3                	je     801e53 <devpipe_read+0x34>
				return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	eb d4                	jmp    801e4b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e77:	99                   	cltd   
  801e78:	c1 ea 1b             	shr    $0x1b,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	83 e0 1f             	and    $0x1f,%eax
  801e80:	29 d0                	sub    %edx,%eax
  801e82:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e8d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e90:	83 c6 01             	add    $0x1,%esi
  801e93:	eb aa                	jmp    801e3f <devpipe_read+0x20>

00801e95 <pipe>:
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	e8 b0 f5 ff ff       	call   80145a <fd_alloc>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 88 23 01 00 00    	js     801fda <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	68 07 04 00 00       	push   $0x407
  801ebf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 52 ef ff ff       	call   800e1b <sys_page_alloc>
  801ec9:	89 c3                	mov    %eax,%ebx
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	0f 88 04 01 00 00    	js     801fda <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edc:	50                   	push   %eax
  801edd:	e8 78 f5 ff ff       	call   80145a <fd_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	0f 88 db 00 00 00    	js     801fca <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 07 04 00 00       	push   $0x407
  801ef7:	ff 75 f0             	pushl  -0x10(%ebp)
  801efa:	6a 00                	push   $0x0
  801efc:	e8 1a ef ff ff       	call   800e1b <sys_page_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	85 c0                	test   %eax,%eax
  801f08:	0f 88 bc 00 00 00    	js     801fca <pipe+0x135>
	va = fd2data(fd0);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 f4             	pushl  -0xc(%ebp)
  801f14:	e8 22 f5 ff ff       	call   80143b <fd2data>
  801f19:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1b:	83 c4 0c             	add    $0xc,%esp
  801f1e:	68 07 04 00 00       	push   $0x407
  801f23:	50                   	push   %eax
  801f24:	6a 00                	push   $0x0
  801f26:	e8 f0 ee ff ff       	call   800e1b <sys_page_alloc>
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	85 c0                	test   %eax,%eax
  801f32:	0f 88 82 00 00 00    	js     801fba <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3e:	e8 f8 f4 ff ff       	call   80143b <fd2data>
  801f43:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f4a:	50                   	push   %eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	56                   	push   %esi
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 ee ee ff ff       	call   800e43 <sys_page_map>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 20             	add    $0x20,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 4e                	js     801fac <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5e:	a1 24 30 80 00       	mov    0x803024,%eax
  801f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f66:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f75:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	ff 75 f4             	pushl  -0xc(%ebp)
  801f87:	e8 9b f4 ff ff       	call   801427 <fd2num>
  801f8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f91:	83 c4 04             	add    $0x4,%esp
  801f94:	ff 75 f0             	pushl  -0x10(%ebp)
  801f97:	e8 8b f4 ff ff       	call   801427 <fd2num>
  801f9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801faa:	eb 2e                	jmp    801fda <pipe+0x145>
	sys_page_unmap(0, va);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	56                   	push   %esi
  801fb0:	6a 00                	push   $0x0
  801fb2:	e8 b6 ee ff ff       	call   800e6d <sys_page_unmap>
  801fb7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fba:	83 ec 08             	sub    $0x8,%esp
  801fbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc0:	6a 00                	push   $0x0
  801fc2:	e8 a6 ee ff ff       	call   800e6d <sys_page_unmap>
  801fc7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fca:	83 ec 08             	sub    $0x8,%esp
  801fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd0:	6a 00                	push   $0x0
  801fd2:	e8 96 ee ff ff       	call   800e6d <sys_page_unmap>
  801fd7:	83 c4 10             	add    $0x10,%esp
}
  801fda:	89 d8                	mov    %ebx,%eax
  801fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5d                   	pop    %ebp
  801fe2:	c3                   	ret    

00801fe3 <pipeisclosed>:
{
  801fe3:	f3 0f 1e fb          	endbr32 
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff0:	50                   	push   %eax
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	e8 b7 f4 ff ff       	call   8014b0 <fd_lookup>
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 18                	js     802018 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 30 f4 ff ff       	call   80143b <fd2data>
  80200b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	e8 1f fd ff ff       	call   801d34 <_pipeisclosed>
  802015:	83 c4 10             	add    $0x10,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80201a:	f3 0f 1e fb          	endbr32 
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	56                   	push   %esi
  802022:	53                   	push   %ebx
  802023:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802026:	85 f6                	test   %esi,%esi
  802028:	74 13                	je     80203d <wait+0x23>
	e = &envs[ENVX(envid)];
  80202a:	89 f3                	mov    %esi,%ebx
  80202c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802032:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802035:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80203b:	eb 1b                	jmp    802058 <wait+0x3e>
	assert(envid != 0);
  80203d:	68 bb 2d 80 00       	push   $0x802dbb
  802042:	68 69 2d 80 00       	push   $0x802d69
  802047:	6a 09                	push   $0x9
  802049:	68 c6 2d 80 00       	push   $0x802dc6
  80204e:	e8 ef e2 ff ff       	call   800342 <_panic>
		sys_yield();
  802053:	e8 98 ed ff ff       	call   800df0 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802058:	8b 43 48             	mov    0x48(%ebx),%eax
  80205b:	39 f0                	cmp    %esi,%eax
  80205d:	75 07                	jne    802066 <wait+0x4c>
  80205f:	8b 43 54             	mov    0x54(%ebx),%eax
  802062:	85 c0                	test   %eax,%eax
  802064:	75 ed                	jne    802053 <wait+0x39>
}
  802066:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    

0080206d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80206d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	c3                   	ret    

00802077 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802077:	f3 0f 1e fb          	endbr32 
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802081:	68 d1 2d 80 00       	push   $0x802dd1
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	e8 05 e9 ff ff       	call   800993 <strcpy>
	return 0;
}
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <devcons_write>:
{
  802095:	f3 0f 1e fb          	endbr32 
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	57                   	push   %edi
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020a5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020aa:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b3:	73 31                	jae    8020e6 <devcons_write+0x51>
		m = n - tot;
  8020b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020b8:	29 f3                	sub    %esi,%ebx
  8020ba:	83 fb 7f             	cmp    $0x7f,%ebx
  8020bd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020c2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	53                   	push   %ebx
  8020c9:	89 f0                	mov    %esi,%eax
  8020cb:	03 45 0c             	add    0xc(%ebp),%eax
  8020ce:	50                   	push   %eax
  8020cf:	57                   	push   %edi
  8020d0:	e8 76 ea ff ff       	call   800b4b <memmove>
		sys_cputs(buf, m);
  8020d5:	83 c4 08             	add    $0x8,%esp
  8020d8:	53                   	push   %ebx
  8020d9:	57                   	push   %edi
  8020da:	e8 71 ec ff ff       	call   800d50 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020df:	01 de                	add    %ebx,%esi
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	eb ca                	jmp    8020b0 <devcons_write+0x1b>
}
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    

008020f0 <devcons_read>:
{
  8020f0:	f3 0f 1e fb          	endbr32 
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 08             	sub    $0x8,%esp
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802103:	74 21                	je     802126 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802105:	e8 70 ec ff ff       	call   800d7a <sys_cgetc>
  80210a:	85 c0                	test   %eax,%eax
  80210c:	75 07                	jne    802115 <devcons_read+0x25>
		sys_yield();
  80210e:	e8 dd ec ff ff       	call   800df0 <sys_yield>
  802113:	eb f0                	jmp    802105 <devcons_read+0x15>
	if (c < 0)
  802115:	78 0f                	js     802126 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802117:	83 f8 04             	cmp    $0x4,%eax
  80211a:	74 0c                	je     802128 <devcons_read+0x38>
	*(char*)vbuf = c;
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	88 02                	mov    %al,(%edx)
	return 1;
  802121:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    
		return 0;
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
  80212d:	eb f7                	jmp    802126 <devcons_read+0x36>

0080212f <cputchar>:
{
  80212f:	f3 0f 1e fb          	endbr32 
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80213f:	6a 01                	push   $0x1
  802141:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802144:	50                   	push   %eax
  802145:	e8 06 ec ff ff       	call   800d50 <sys_cputs>
}
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <getchar>:
{
  80214f:	f3 0f 1e fb          	endbr32 
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802159:	6a 01                	push   $0x1
  80215b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80215e:	50                   	push   %eax
  80215f:	6a 00                	push   $0x0
  802161:	e8 cd f5 ff ff       	call   801733 <read>
	if (r < 0)
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 06                	js     802173 <getchar+0x24>
	if (r < 1)
  80216d:	74 06                	je     802175 <getchar+0x26>
	return c;
  80216f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    
		return -E_EOF;
  802175:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80217a:	eb f7                	jmp    802173 <getchar+0x24>

0080217c <iscons>:
{
  80217c:	f3 0f 1e fb          	endbr32 
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802186:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802189:	50                   	push   %eax
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 1e f3 ff ff       	call   8014b0 <fd_lookup>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	85 c0                	test   %eax,%eax
  802197:	78 11                	js     8021aa <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021a2:	39 10                	cmp    %edx,(%eax)
  8021a4:	0f 94 c0             	sete   %al
  8021a7:	0f b6 c0             	movzbl %al,%eax
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <opencons>:
{
  8021ac:	f3 0f 1e fb          	endbr32 
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b9:	50                   	push   %eax
  8021ba:	e8 9b f2 ff ff       	call   80145a <fd_alloc>
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	78 3a                	js     802200 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 07 04 00 00       	push   $0x407
  8021ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d1:	6a 00                	push   $0x0
  8021d3:	e8 43 ec ff ff       	call   800e1b <sys_page_alloc>
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 21                	js     802200 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021e8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	50                   	push   %eax
  8021f8:	e8 2a f2 ff ff       	call   801427 <fd2num>
  8021fd:	83 c4 10             	add    $0x10,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802202:	f3 0f 1e fb          	endbr32 
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80220c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802213:	74 0a                	je     80221f <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  80221f:	a1 04 40 80 00       	mov    0x804004,%eax
  802224:	8b 40 48             	mov    0x48(%eax),%eax
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	6a 07                	push   $0x7
  80222c:	68 00 f0 bf ee       	push   $0xeebff000
  802231:	50                   	push   %eax
  802232:	e8 e4 eb ff ff       	call   800e1b <sys_page_alloc>
		if (r!= 0)
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	85 c0                	test   %eax,%eax
  80223c:	75 2f                	jne    80226d <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80223e:	a1 04 40 80 00       	mov    0x804004,%eax
  802243:	8b 40 48             	mov    0x48(%eax),%eax
  802246:	83 ec 08             	sub    $0x8,%esp
  802249:	68 7f 22 80 00       	push   $0x80227f
  80224e:	50                   	push   %eax
  80224f:	e8 8e ec ff ff       	call   800ee2 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	85 c0                	test   %eax,%eax
  802259:	74 ba                	je     802215 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  80225b:	50                   	push   %eax
  80225c:	68 dd 2d 80 00       	push   $0x802ddd
  802261:	6a 26                	push   $0x26
  802263:	68 f5 2d 80 00       	push   $0x802df5
  802268:	e8 d5 e0 ff ff       	call   800342 <_panic>
			panic("set_pgfault_handler: %e", r);
  80226d:	50                   	push   %eax
  80226e:	68 dd 2d 80 00       	push   $0x802ddd
  802273:	6a 22                	push   $0x22
  802275:	68 f5 2d 80 00       	push   $0x802df5
  80227a:	e8 c3 e0 ff ff       	call   800342 <_panic>

0080227f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80227f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802280:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802285:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802287:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  80228a:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  80228e:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802291:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802295:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  802299:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80229b:	83 c4 08             	add    $0x8,%esp
	popal
  80229e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  80229f:	83 c4 04             	add    $0x4,%esp
	popfl
  8022a2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8022a3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022a4:	c3                   	ret    

008022a5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a5:	f3 0f 1e fb          	endbr32 
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022be:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	50                   	push   %eax
  8022c5:	e8 68 ec ff ff       	call   800f32 <sys_ipc_recv>
	if (r < 0) {
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 2b                	js     8022fc <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8022d1:	85 f6                	test   %esi,%esi
  8022d3:	74 0a                	je     8022df <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8022d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8022da:	8b 40 74             	mov    0x74(%eax),%eax
  8022dd:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8022df:	85 db                	test   %ebx,%ebx
  8022e1:	74 0a                	je     8022ed <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8022e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8022e8:	8b 40 78             	mov    0x78(%eax),%eax
  8022eb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8022f2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f8:	5b                   	pop    %ebx
  8022f9:	5e                   	pop    %esi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    
		if (from_env_store) {
  8022fc:	85 f6                	test   %esi,%esi
  8022fe:	74 06                	je     802306 <ipc_recv+0x61>
			*from_env_store = 0;
  802300:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  802306:	85 db                	test   %ebx,%ebx
  802308:	74 eb                	je     8022f5 <ipc_recv+0x50>
			*perm_store = 0;
  80230a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802310:	eb e3                	jmp    8022f5 <ipc_recv+0x50>

00802312 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802312:	f3 0f 1e fb          	endbr32 
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	57                   	push   %edi
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802322:	8b 75 0c             	mov    0xc(%ebp),%esi
  802325:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  802328:	85 db                	test   %ebx,%ebx
  80232a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80232f:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802332:	ff 75 14             	pushl  0x14(%ebp)
  802335:	53                   	push   %ebx
  802336:	56                   	push   %esi
  802337:	57                   	push   %edi
  802338:	e8 cc eb ff ff       	call   800f09 <sys_ipc_try_send>
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802343:	75 07                	jne    80234c <ipc_send+0x3a>
		sys_yield();
  802345:	e8 a6 ea ff ff       	call   800df0 <sys_yield>
  80234a:	eb e6                	jmp    802332 <ipc_send+0x20>
	}

	if (ret < 0) {
  80234c:	85 c0                	test   %eax,%eax
  80234e:	78 08                	js     802358 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5f                   	pop    %edi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802358:	50                   	push   %eax
  802359:	68 03 2e 80 00       	push   $0x802e03
  80235e:	6a 48                	push   $0x48
  802360:	68 20 2e 80 00       	push   $0x802e20
  802365:	e8 d8 df ff ff       	call   800342 <_panic>

0080236a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80236a:	f3 0f 1e fb          	endbr32 
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802379:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80237c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802382:	8b 52 50             	mov    0x50(%edx),%edx
  802385:	39 ca                	cmp    %ecx,%edx
  802387:	74 11                	je     80239a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802389:	83 c0 01             	add    $0x1,%eax
  80238c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802391:	75 e6                	jne    802379 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	eb 0b                	jmp    8023a5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80239a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80239d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023a2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023a7:	f3 0f 1e fb          	endbr32 
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023b1:	89 c2                	mov    %eax,%edx
  8023b3:	c1 ea 16             	shr    $0x16,%edx
  8023b6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8023bd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8023c2:	f6 c1 01             	test   $0x1,%cl
  8023c5:	74 1c                	je     8023e3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8023c7:	c1 e8 0c             	shr    $0xc,%eax
  8023ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8023d1:	a8 01                	test   $0x1,%al
  8023d3:	74 0e                	je     8023e3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023d5:	c1 e8 0c             	shr    $0xc,%eax
  8023d8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8023df:	ef 
  8023e0:	0f b7 d2             	movzwl %dx,%edx
}
  8023e3:	89 d0                	mov    %edx,%eax
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    
  8023e7:	66 90                	xchg   %ax,%ax
  8023e9:	66 90                	xchg   %ax,%ax
  8023eb:	66 90                	xchg   %ax,%ax
  8023ed:	66 90                	xchg   %ax,%ax
  8023ef:	90                   	nop

008023f0 <__udivdi3>:
  8023f0:	f3 0f 1e fb          	endbr32 
  8023f4:	55                   	push   %ebp
  8023f5:	57                   	push   %edi
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	83 ec 1c             	sub    $0x1c,%esp
  8023fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802403:	8b 74 24 34          	mov    0x34(%esp),%esi
  802407:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80240b:	85 d2                	test   %edx,%edx
  80240d:	75 19                	jne    802428 <__udivdi3+0x38>
  80240f:	39 f3                	cmp    %esi,%ebx
  802411:	76 4d                	jbe    802460 <__udivdi3+0x70>
  802413:	31 ff                	xor    %edi,%edi
  802415:	89 e8                	mov    %ebp,%eax
  802417:	89 f2                	mov    %esi,%edx
  802419:	f7 f3                	div    %ebx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	83 c4 1c             	add    $0x1c,%esp
  802420:	5b                   	pop    %ebx
  802421:	5e                   	pop    %esi
  802422:	5f                   	pop    %edi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	76 14                	jbe    802440 <__udivdi3+0x50>
  80242c:	31 ff                	xor    %edi,%edi
  80242e:	31 c0                	xor    %eax,%eax
  802430:	89 fa                	mov    %edi,%edx
  802432:	83 c4 1c             	add    $0x1c,%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    
  80243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802440:	0f bd fa             	bsr    %edx,%edi
  802443:	83 f7 1f             	xor    $0x1f,%edi
  802446:	75 48                	jne    802490 <__udivdi3+0xa0>
  802448:	39 f2                	cmp    %esi,%edx
  80244a:	72 06                	jb     802452 <__udivdi3+0x62>
  80244c:	31 c0                	xor    %eax,%eax
  80244e:	39 eb                	cmp    %ebp,%ebx
  802450:	77 de                	ja     802430 <__udivdi3+0x40>
  802452:	b8 01 00 00 00       	mov    $0x1,%eax
  802457:	eb d7                	jmp    802430 <__udivdi3+0x40>
  802459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802460:	89 d9                	mov    %ebx,%ecx
  802462:	85 db                	test   %ebx,%ebx
  802464:	75 0b                	jne    802471 <__udivdi3+0x81>
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f3                	div    %ebx
  80246f:	89 c1                	mov    %eax,%ecx
  802471:	31 d2                	xor    %edx,%edx
  802473:	89 f0                	mov    %esi,%eax
  802475:	f7 f1                	div    %ecx
  802477:	89 c6                	mov    %eax,%esi
  802479:	89 e8                	mov    %ebp,%eax
  80247b:	89 f7                	mov    %esi,%edi
  80247d:	f7 f1                	div    %ecx
  80247f:	89 fa                	mov    %edi,%edx
  802481:	83 c4 1c             	add    $0x1c,%esp
  802484:	5b                   	pop    %ebx
  802485:	5e                   	pop    %esi
  802486:	5f                   	pop    %edi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    
  802489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802490:	89 f9                	mov    %edi,%ecx
  802492:	b8 20 00 00 00       	mov    $0x20,%eax
  802497:	29 f8                	sub    %edi,%eax
  802499:	d3 e2                	shl    %cl,%edx
  80249b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80249f:	89 c1                	mov    %eax,%ecx
  8024a1:	89 da                	mov    %ebx,%edx
  8024a3:	d3 ea                	shr    %cl,%edx
  8024a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024a9:	09 d1                	or     %edx,%ecx
  8024ab:	89 f2                	mov    %esi,%edx
  8024ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024b1:	89 f9                	mov    %edi,%ecx
  8024b3:	d3 e3                	shl    %cl,%ebx
  8024b5:	89 c1                	mov    %eax,%ecx
  8024b7:	d3 ea                	shr    %cl,%edx
  8024b9:	89 f9                	mov    %edi,%ecx
  8024bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024bf:	89 eb                	mov    %ebp,%ebx
  8024c1:	d3 e6                	shl    %cl,%esi
  8024c3:	89 c1                	mov    %eax,%ecx
  8024c5:	d3 eb                	shr    %cl,%ebx
  8024c7:	09 de                	or     %ebx,%esi
  8024c9:	89 f0                	mov    %esi,%eax
  8024cb:	f7 74 24 08          	divl   0x8(%esp)
  8024cf:	89 d6                	mov    %edx,%esi
  8024d1:	89 c3                	mov    %eax,%ebx
  8024d3:	f7 64 24 0c          	mull   0xc(%esp)
  8024d7:	39 d6                	cmp    %edx,%esi
  8024d9:	72 15                	jb     8024f0 <__udivdi3+0x100>
  8024db:	89 f9                	mov    %edi,%ecx
  8024dd:	d3 e5                	shl    %cl,%ebp
  8024df:	39 c5                	cmp    %eax,%ebp
  8024e1:	73 04                	jae    8024e7 <__udivdi3+0xf7>
  8024e3:	39 d6                	cmp    %edx,%esi
  8024e5:	74 09                	je     8024f0 <__udivdi3+0x100>
  8024e7:	89 d8                	mov    %ebx,%eax
  8024e9:	31 ff                	xor    %edi,%edi
  8024eb:	e9 40 ff ff ff       	jmp    802430 <__udivdi3+0x40>
  8024f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024f3:	31 ff                	xor    %edi,%edi
  8024f5:	e9 36 ff ff ff       	jmp    802430 <__udivdi3+0x40>
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	f3 0f 1e fb          	endbr32 
  802504:	55                   	push   %ebp
  802505:	57                   	push   %edi
  802506:	56                   	push   %esi
  802507:	53                   	push   %ebx
  802508:	83 ec 1c             	sub    $0x1c,%esp
  80250b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80250f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802513:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802517:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80251b:	85 c0                	test   %eax,%eax
  80251d:	75 19                	jne    802538 <__umoddi3+0x38>
  80251f:	39 df                	cmp    %ebx,%edi
  802521:	76 5d                	jbe    802580 <__umoddi3+0x80>
  802523:	89 f0                	mov    %esi,%eax
  802525:	89 da                	mov    %ebx,%edx
  802527:	f7 f7                	div    %edi
  802529:	89 d0                	mov    %edx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	89 f2                	mov    %esi,%edx
  80253a:	39 d8                	cmp    %ebx,%eax
  80253c:	76 12                	jbe    802550 <__umoddi3+0x50>
  80253e:	89 f0                	mov    %esi,%eax
  802540:	89 da                	mov    %ebx,%edx
  802542:	83 c4 1c             	add    $0x1c,%esp
  802545:	5b                   	pop    %ebx
  802546:	5e                   	pop    %esi
  802547:	5f                   	pop    %edi
  802548:	5d                   	pop    %ebp
  802549:	c3                   	ret    
  80254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802550:	0f bd e8             	bsr    %eax,%ebp
  802553:	83 f5 1f             	xor    $0x1f,%ebp
  802556:	75 50                	jne    8025a8 <__umoddi3+0xa8>
  802558:	39 d8                	cmp    %ebx,%eax
  80255a:	0f 82 e0 00 00 00    	jb     802640 <__umoddi3+0x140>
  802560:	89 d9                	mov    %ebx,%ecx
  802562:	39 f7                	cmp    %esi,%edi
  802564:	0f 86 d6 00 00 00    	jbe    802640 <__umoddi3+0x140>
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	89 ca                	mov    %ecx,%edx
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 fd                	mov    %edi,%ebp
  802582:	85 ff                	test   %edi,%edi
  802584:	75 0b                	jne    802591 <__umoddi3+0x91>
  802586:	b8 01 00 00 00       	mov    $0x1,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	f7 f7                	div    %edi
  80258f:	89 c5                	mov    %eax,%ebp
  802591:	89 d8                	mov    %ebx,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f5                	div    %ebp
  802597:	89 f0                	mov    %esi,%eax
  802599:	f7 f5                	div    %ebp
  80259b:	89 d0                	mov    %edx,%eax
  80259d:	31 d2                	xor    %edx,%edx
  80259f:	eb 8c                	jmp    80252d <__umoddi3+0x2d>
  8025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8025af:	29 ea                	sub    %ebp,%edx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b7:	89 d1                	mov    %edx,%ecx
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	d3 e8                	shr    %cl,%eax
  8025bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025c9:	09 c1                	or     %eax,%ecx
  8025cb:	89 d8                	mov    %ebx,%eax
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 e9                	mov    %ebp,%ecx
  8025d3:	d3 e7                	shl    %cl,%edi
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	d3 e8                	shr    %cl,%eax
  8025d9:	89 e9                	mov    %ebp,%ecx
  8025db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025df:	d3 e3                	shl    %cl,%ebx
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	89 d1                	mov    %edx,%ecx
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	d3 e6                	shl    %cl,%esi
  8025ef:	09 d8                	or     %ebx,%eax
  8025f1:	f7 74 24 08          	divl   0x8(%esp)
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	89 f3                	mov    %esi,%ebx
  8025f9:	f7 64 24 0c          	mull   0xc(%esp)
  8025fd:	89 c6                	mov    %eax,%esi
  8025ff:	89 d7                	mov    %edx,%edi
  802601:	39 d1                	cmp    %edx,%ecx
  802603:	72 06                	jb     80260b <__umoddi3+0x10b>
  802605:	75 10                	jne    802617 <__umoddi3+0x117>
  802607:	39 c3                	cmp    %eax,%ebx
  802609:	73 0c                	jae    802617 <__umoddi3+0x117>
  80260b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80260f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802613:	89 d7                	mov    %edx,%edi
  802615:	89 c6                	mov    %eax,%esi
  802617:	89 ca                	mov    %ecx,%edx
  802619:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261e:	29 f3                	sub    %esi,%ebx
  802620:	19 fa                	sbb    %edi,%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	d3 e0                	shl    %cl,%eax
  802626:	89 e9                	mov    %ebp,%ecx
  802628:	d3 eb                	shr    %cl,%ebx
  80262a:	d3 ea                	shr    %cl,%edx
  80262c:	09 d8                	or     %ebx,%eax
  80262e:	83 c4 1c             	add    $0x1c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263d:	8d 76 00             	lea    0x0(%esi),%esi
  802640:	29 fe                	sub    %edi,%esi
  802642:	19 c3                	sbb    %eax,%ebx
  802644:	89 f2                	mov    %esi,%edx
  802646:	89 d9                	mov    %ebx,%ecx
  802648:	e9 1d ff ff ff       	jmp    80256a <__umoddi3+0x6a>
