
obj/user/testshell.debug:     formato del fichero elf32-i386


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
  80002c:	e8 83 04 00 00       	call   8004b4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <breakpoint>:
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800035:	f3 0f 1e fb          	endbr32 
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	57                   	push   %edi
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	81 ec 84 00 00 00    	sub    $0x84,%esp
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80004b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  80004e:	53                   	push   %ebx
  80004f:	56                   	push   %esi
  800050:	e8 18 1a 00 00       	call   801a6d <seek>
	seek(kfd, off);
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	53                   	push   %ebx
  800059:	57                   	push   %edi
  80005a:	e8 0e 1a 00 00       	call   801a6d <seek>

	cprintf("shell produced incorrect output.\n");
  80005f:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  800066:	e8 9c 05 00 00       	call   800607 <cprintf>
	cprintf("expected:\n===\n");
  80006b:	c7 04 24 ab 2c 80 00 	movl   $0x802cab,(%esp)
  800072:	e8 90 05 00 00       	call   800607 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007d:	83 ec 04             	sub    $0x4,%esp
  800080:	6a 63                	push   $0x63
  800082:	53                   	push   %ebx
  800083:	57                   	push   %edi
  800084:	e8 88 18 00 00       	call   801911 <read>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	85 c0                	test   %eax,%eax
  80008e:	7e 0f                	jle    80009f <wrong+0x6a>
		sys_cputs(buf, n);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	50                   	push   %eax
  800094:	53                   	push   %ebx
  800095:	e8 94 0e 00 00       	call   800f2e <sys_cputs>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	eb de                	jmp    80007d <wrong+0x48>
	cprintf("===\ngot:\n===\n");
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	68 ba 2c 80 00       	push   $0x802cba
  8000a7:	e8 5b 05 00 00       	call   800607 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b2:	eb 0d                	jmp    8000c1 <wrong+0x8c>
		sys_cputs(buf, n);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	50                   	push   %eax
  8000b8:	53                   	push   %ebx
  8000b9:	e8 70 0e 00 00       	call   800f2e <sys_cputs>
  8000be:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 63                	push   $0x63
  8000c6:	53                   	push   %ebx
  8000c7:	56                   	push   %esi
  8000c8:	e8 44 18 00 00       	call   801911 <read>
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	7f e0                	jg     8000b4 <wrong+0x7f>
	cprintf("===\n");
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 b5 2c 80 00       	push   $0x802cb5
  8000dc:	e8 26 05 00 00       	call   800607 <cprintf>
	exit();
  8000e1:	e8 1c 04 00 00       	call   800502 <exit>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <umain>:
{
  8000f1:	f3 0f 1e fb          	endbr32 
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	57                   	push   %edi
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000fe:	6a 00                	push   $0x0
  800100:	e8 c2 16 00 00       	call   8017c7 <close>
	close(1);
  800105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010c:	e8 b6 16 00 00       	call   8017c7 <close>
	opencons();
  800111:	e8 48 03 00 00       	call   80045e <opencons>
	opencons();
  800116:	e8 43 03 00 00       	call   80045e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011b:	83 c4 08             	add    $0x8,%esp
  80011e:	6a 00                	push   $0x0
  800120:	68 c8 2c 80 00       	push   $0x802cc8
  800125:	e8 bb 1c 00 00       	call   801de5 <open>
  80012a:	89 c3                	mov    %eax,%ebx
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	85 c0                	test   %eax,%eax
  800131:	0f 88 e7 00 00 00    	js     80021e <umain+0x12d>
	if ((wfd = pipe(pfds)) < 0)
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 ca 24 00 00       	call   80260d <pipe>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	85 c0                	test   %eax,%eax
  800148:	0f 88 e2 00 00 00    	js     800230 <umain+0x13f>
	wfd = pfds[1];
  80014e:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 64 2c 80 00       	push   $0x802c64
  800159:	e8 a9 04 00 00       	call   800607 <cprintf>
	if ((r = fork()) < 0)
  80015e:	e8 56 13 00 00       	call   8014b9 <fork>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	85 c0                	test   %eax,%eax
  800168:	0f 88 d4 00 00 00    	js     800242 <umain+0x151>
	if (r == 0) {
  80016e:	75 6f                	jne    8001df <umain+0xee>
		dup(rfd, 0);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	6a 00                	push   $0x0
  800175:	53                   	push   %ebx
  800176:	e8 a6 16 00 00       	call   801821 <dup>
		dup(wfd, 1);
  80017b:	83 c4 08             	add    $0x8,%esp
  80017e:	6a 01                	push   $0x1
  800180:	56                   	push   %esi
  800181:	e8 9b 16 00 00       	call   801821 <dup>
		close(rfd);
  800186:	89 1c 24             	mov    %ebx,(%esp)
  800189:	e8 39 16 00 00       	call   8017c7 <close>
		close(wfd);
  80018e:	89 34 24             	mov    %esi,(%esp)
  800191:	e8 31 16 00 00       	call   8017c7 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800196:	6a 00                	push   $0x0
  800198:	68 05 2d 80 00       	push   $0x802d05
  80019d:	68 d2 2c 80 00       	push   $0x802cd2
  8001a2:	68 08 2d 80 00       	push   $0x802d08
  8001a7:	e8 ce 21 00 00       	call   80237a <spawnl>
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	83 c4 20             	add    $0x20,%esp
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	0f 88 9b 00 00 00    	js     800254 <umain+0x163>
		close(0);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 04 16 00 00       	call   8017c7 <close>
		close(1);
  8001c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001ca:	e8 f8 15 00 00       	call   8017c7 <close>
		wait(r);
  8001cf:	89 3c 24             	mov    %edi,(%esp)
  8001d2:	e8 bb 25 00 00       	call   802792 <wait>
		exit();
  8001d7:	e8 26 03 00 00       	call   800502 <exit>
  8001dc:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	53                   	push   %ebx
  8001e3:	e8 df 15 00 00       	call   8017c7 <close>
	close(wfd);
  8001e8:	89 34 24             	mov    %esi,(%esp)
  8001eb:	e8 d7 15 00 00       	call   8017c7 <close>
	rfd = pfds[0];
  8001f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f6:	83 c4 08             	add    $0x8,%esp
  8001f9:	6a 00                	push   $0x0
  8001fb:	68 16 2d 80 00       	push   $0x802d16
  800200:	e8 e0 1b 00 00       	call   801de5 <open>
  800205:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	85 c0                	test   %eax,%eax
  80020d:	78 57                	js     800266 <umain+0x175>
  80020f:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  800214:	bf 00 00 00 00       	mov    $0x0,%edi
  800219:	e9 9a 00 00 00       	jmp    8002b8 <umain+0x1c7>
		panic("open testshell.sh: %e", rfd);
  80021e:	50                   	push   %eax
  80021f:	68 d5 2c 80 00       	push   $0x802cd5
  800224:	6a 13                	push   $0x13
  800226:	68 eb 2c 80 00       	push   $0x802ceb
  80022b:	e8 f0 02 00 00       	call   800520 <_panic>
		panic("pipe: %e", wfd);
  800230:	50                   	push   %eax
  800231:	68 fc 2c 80 00       	push   $0x802cfc
  800236:	6a 15                	push   $0x15
  800238:	68 eb 2c 80 00       	push   $0x802ceb
  80023d:	e8 de 02 00 00       	call   800520 <_panic>
		panic("fork: %e", r);
  800242:	50                   	push   %eax
  800243:	68 47 31 80 00       	push   $0x803147
  800248:	6a 1a                	push   $0x1a
  80024a:	68 eb 2c 80 00       	push   $0x802ceb
  80024f:	e8 cc 02 00 00       	call   800520 <_panic>
			panic("spawn: %e", r);
  800254:	50                   	push   %eax
  800255:	68 0c 2d 80 00       	push   $0x802d0c
  80025a:	6a 21                	push   $0x21
  80025c:	68 eb 2c 80 00       	push   $0x802ceb
  800261:	e8 ba 02 00 00       	call   800520 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800266:	50                   	push   %eax
  800267:	68 88 2c 80 00       	push   $0x802c88
  80026c:	6a 2c                	push   $0x2c
  80026e:	68 eb 2c 80 00       	push   $0x802ceb
  800273:	e8 a8 02 00 00       	call   800520 <_panic>
			panic("reading testshell.out: %e", n1);
  800278:	53                   	push   %ebx
  800279:	68 24 2d 80 00       	push   $0x802d24
  80027e:	6a 33                	push   $0x33
  800280:	68 eb 2c 80 00       	push   $0x802ceb
  800285:	e8 96 02 00 00       	call   800520 <_panic>
			panic("reading testshell.key: %e", n2);
  80028a:	50                   	push   %eax
  80028b:	68 3e 2d 80 00       	push   $0x802d3e
  800290:	6a 35                	push   $0x35
  800292:	68 eb 2c 80 00       	push   $0x802ceb
  800297:	e8 84 02 00 00       	call   800520 <_panic>
			wrong(rfd, kfd, nloff);
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	57                   	push   %edi
  8002a0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a6:	e8 8a fd ff ff       	call   800035 <wrong>
  8002ab:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002ae:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b2:	0f 44 fe             	cmove  %esi,%edi
  8002b5:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	6a 01                	push   $0x1
  8002bd:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002c0:	50                   	push   %eax
  8002c1:	ff 75 d0             	pushl  -0x30(%ebp)
  8002c4:	e8 48 16 00 00       	call   801911 <read>
  8002c9:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002cb:	83 c4 0c             	add    $0xc,%esp
  8002ce:	6a 01                	push   $0x1
  8002d0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d7:	e8 35 16 00 00       	call   801911 <read>
		if (n1 < 0)
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	85 db                	test   %ebx,%ebx
  8002e1:	78 95                	js     800278 <umain+0x187>
		if (n2 < 0)
  8002e3:	85 c0                	test   %eax,%eax
  8002e5:	78 a3                	js     80028a <umain+0x199>
		if (n1 == 0 && n2 == 0)
  8002e7:	89 da                	mov    %ebx,%edx
  8002e9:	09 c2                	or     %eax,%edx
  8002eb:	74 15                	je     800302 <umain+0x211>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002ed:	83 fb 01             	cmp    $0x1,%ebx
  8002f0:	75 aa                	jne    80029c <umain+0x1ab>
  8002f2:	83 f8 01             	cmp    $0x1,%eax
  8002f5:	75 a5                	jne    80029c <umain+0x1ab>
  8002f7:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002fb:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002fe:	75 9c                	jne    80029c <umain+0x1ab>
  800300:	eb ac                	jmp    8002ae <umain+0x1bd>
	cprintf("shell ran correctly\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 58 2d 80 00       	push   $0x802d58
  80030a:	e8 f8 02 00 00       	call   800607 <cprintf>
	breakpoint();
  80030f:	e8 1f fd ff ff       	call   800033 <breakpoint>
}
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031a:	5b                   	pop    %ebx
  80031b:	5e                   	pop    %esi
  80031c:	5f                   	pop    %edi
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80031f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
  800328:	c3                   	ret    

00800329 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800329:	f3 0f 1e fb          	endbr32 
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800333:	68 6d 2d 80 00       	push   $0x802d6d
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	e8 31 08 00 00       	call   800b71 <strcpy>
	return 0;
}
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	c9                   	leave  
  800346:	c3                   	ret    

00800347 <devcons_write>:
{
  800347:	f3 0f 1e fb          	endbr32 
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
  800351:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800357:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80035c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800362:	3b 75 10             	cmp    0x10(%ebp),%esi
  800365:	73 31                	jae    800398 <devcons_write+0x51>
		m = n - tot;
  800367:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80036a:	29 f3                	sub    %esi,%ebx
  80036c:	83 fb 7f             	cmp    $0x7f,%ebx
  80036f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800374:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	53                   	push   %ebx
  80037b:	89 f0                	mov    %esi,%eax
  80037d:	03 45 0c             	add    0xc(%ebp),%eax
  800380:	50                   	push   %eax
  800381:	57                   	push   %edi
  800382:	e8 a2 09 00 00       	call   800d29 <memmove>
		sys_cputs(buf, m);
  800387:	83 c4 08             	add    $0x8,%esp
  80038a:	53                   	push   %ebx
  80038b:	57                   	push   %edi
  80038c:	e8 9d 0b 00 00       	call   800f2e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800391:	01 de                	add    %ebx,%esi
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	eb ca                	jmp    800362 <devcons_write+0x1b>
}
  800398:	89 f0                	mov    %esi,%eax
  80039a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039d:	5b                   	pop    %ebx
  80039e:	5e                   	pop    %esi
  80039f:	5f                   	pop    %edi
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    

008003a2 <devcons_read>:
{
  8003a2:	f3 0f 1e fb          	endbr32 
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8003b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003b5:	74 21                	je     8003d8 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8003b7:	e8 9c 0b 00 00       	call   800f58 <sys_cgetc>
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	75 07                	jne    8003c7 <devcons_read+0x25>
		sys_yield();
  8003c0:	e8 09 0c 00 00       	call   800fce <sys_yield>
  8003c5:	eb f0                	jmp    8003b7 <devcons_read+0x15>
	if (c < 0)
  8003c7:	78 0f                	js     8003d8 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8003c9:	83 f8 04             	cmp    $0x4,%eax
  8003cc:	74 0c                	je     8003da <devcons_read+0x38>
	*(char*)vbuf = c;
  8003ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d1:	88 02                	mov    %al,(%edx)
	return 1;
  8003d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    
		return 0;
  8003da:	b8 00 00 00 00       	mov    $0x0,%eax
  8003df:	eb f7                	jmp    8003d8 <devcons_read+0x36>

008003e1 <cputchar>:
{
  8003e1:	f3 0f 1e fb          	endbr32 
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003f1:	6a 01                	push   $0x1
  8003f3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f6:	50                   	push   %eax
  8003f7:	e8 32 0b 00 00       	call   800f2e <sys_cputs>
}
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <getchar>:
{
  800401:	f3 0f 1e fb          	endbr32 
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80040b:	6a 01                	push   $0x1
  80040d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800410:	50                   	push   %eax
  800411:	6a 00                	push   $0x0
  800413:	e8 f9 14 00 00       	call   801911 <read>
	if (r < 0)
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	85 c0                	test   %eax,%eax
  80041d:	78 06                	js     800425 <getchar+0x24>
	if (r < 1)
  80041f:	74 06                	je     800427 <getchar+0x26>
	return c;
  800421:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800425:	c9                   	leave  
  800426:	c3                   	ret    
		return -E_EOF;
  800427:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80042c:	eb f7                	jmp    800425 <getchar+0x24>

0080042e <iscons>:
{
  80042e:	f3 0f 1e fb          	endbr32 
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800438:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043b:	50                   	push   %eax
  80043c:	ff 75 08             	pushl  0x8(%ebp)
  80043f:	e8 4a 12 00 00       	call   80168e <fd_lookup>
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	85 c0                	test   %eax,%eax
  800449:	78 11                	js     80045c <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80044b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800454:	39 10                	cmp    %edx,(%eax)
  800456:	0f 94 c0             	sete   %al
  800459:	0f b6 c0             	movzbl %al,%eax
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <opencons>:
{
  80045e:	f3 0f 1e fb          	endbr32 
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 c7 11 00 00       	call   801638 <fd_alloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	85 c0                	test   %eax,%eax
  800476:	78 3a                	js     8004b2 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 07 04 00 00       	push   $0x407
  800480:	ff 75 f4             	pushl  -0xc(%ebp)
  800483:	6a 00                	push   $0x0
  800485:	e8 6f 0b 00 00       	call   800ff9 <sys_page_alloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	85 c0                	test   %eax,%eax
  80048f:	78 21                	js     8004b2 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800494:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80049a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80049c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	50                   	push   %eax
  8004aa:	e8 56 11 00 00       	call   801605 <fd2num>
  8004af:	83 c4 10             	add    $0x10,%esp
}
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004b4:	f3 0f 1e fb          	endbr32 
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	56                   	push   %esi
  8004bc:	53                   	push   %ebx
  8004bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004c0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8004c3:	e8 de 0a 00 00       	call   800fa6 <sys_getenvid>
	if (id >= 0)
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	78 12                	js     8004de <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8004cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004d9:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004de:	85 db                	test   %ebx,%ebx
  8004e0:	7e 07                	jle    8004e9 <libmain+0x35>
		binaryname = argv[0];
  8004e2:	8b 06                	mov    (%esi),%eax
  8004e4:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	56                   	push   %esi
  8004ed:	53                   	push   %ebx
  8004ee:	e8 fe fb ff ff       	call   8000f1 <umain>

	// exit gracefully
	exit();
  8004f3:	e8 0a 00 00 00       	call   800502 <exit>
}
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004fe:	5b                   	pop    %ebx
  8004ff:	5e                   	pop    %esi
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800502:	f3 0f 1e fb          	endbr32 
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80050c:	e8 e7 12 00 00       	call   8017f8 <close_all>
	sys_env_destroy(0);
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	6a 00                	push   $0x0
  800516:	e8 65 0a 00 00       	call   800f80 <sys_env_destroy>
}
  80051b:	83 c4 10             	add    $0x10,%esp
  80051e:	c9                   	leave  
  80051f:	c3                   	ret    

00800520 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800520:	f3 0f 1e fb          	endbr32 
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800529:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80052c:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800532:	e8 6f 0a 00 00       	call   800fa6 <sys_getenvid>
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	ff 75 0c             	pushl  0xc(%ebp)
  80053d:	ff 75 08             	pushl  0x8(%ebp)
  800540:	56                   	push   %esi
  800541:	50                   	push   %eax
  800542:	68 84 2d 80 00       	push   $0x802d84
  800547:	e8 bb 00 00 00       	call   800607 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80054c:	83 c4 18             	add    $0x18,%esp
  80054f:	53                   	push   %ebx
  800550:	ff 75 10             	pushl  0x10(%ebp)
  800553:	e8 5a 00 00 00       	call   8005b2 <vcprintf>
	cprintf("\n");
  800558:	c7 04 24 84 34 80 00 	movl   $0x803484,(%esp)
  80055f:	e8 a3 00 00 00       	call   800607 <cprintf>
  800564:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800567:	cc                   	int3   
  800568:	eb fd                	jmp    800567 <_panic+0x47>

0080056a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80056a:	f3 0f 1e fb          	endbr32 
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	53                   	push   %ebx
  800572:	83 ec 04             	sub    $0x4,%esp
  800575:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800578:	8b 13                	mov    (%ebx),%edx
  80057a:	8d 42 01             	lea    0x1(%edx),%eax
  80057d:	89 03                	mov    %eax,(%ebx)
  80057f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800582:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800586:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058b:	74 09                	je     800596 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80058d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800594:	c9                   	leave  
  800595:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	68 ff 00 00 00       	push   $0xff
  80059e:	8d 43 08             	lea    0x8(%ebx),%eax
  8005a1:	50                   	push   %eax
  8005a2:	e8 87 09 00 00       	call   800f2e <sys_cputs>
		b->idx = 0;
  8005a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	eb db                	jmp    80058d <putch+0x23>

008005b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b2:	f3 0f 1e fb          	endbr32 
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c6:	00 00 00 
	b.cnt = 0;
  8005c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 08             	pushl  0x8(%ebp)
  8005d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005df:	50                   	push   %eax
  8005e0:	68 6a 05 80 00       	push   $0x80056a
  8005e5:	e8 80 01 00 00       	call   80076a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ea:	83 c4 08             	add    $0x8,%esp
  8005ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005f9:	50                   	push   %eax
  8005fa:	e8 2f 09 00 00       	call   800f2e <sys_cputs>

	return b.cnt;
}
  8005ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800607:	f3 0f 1e fb          	endbr32 
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800611:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800614:	50                   	push   %eax
  800615:	ff 75 08             	pushl  0x8(%ebp)
  800618:	e8 95 ff ff ff       	call   8005b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	57                   	push   %edi
  800623:	56                   	push   %esi
  800624:	53                   	push   %ebx
  800625:	83 ec 1c             	sub    $0x1c,%esp
  800628:	89 c7                	mov    %eax,%edi
  80062a:	89 d6                	mov    %edx,%esi
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800632:	89 d1                	mov    %edx,%ecx
  800634:	89 c2                	mov    %eax,%edx
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063c:	8b 45 10             	mov    0x10(%ebp),%eax
  80063f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800642:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800645:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80064c:	39 c2                	cmp    %eax,%edx
  80064e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800651:	72 3e                	jb     800691 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	ff 75 18             	pushl  0x18(%ebp)
  800659:	83 eb 01             	sub    $0x1,%ebx
  80065c:	53                   	push   %ebx
  80065d:	50                   	push   %eax
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 e4             	pushl  -0x1c(%ebp)
  800664:	ff 75 e0             	pushl  -0x20(%ebp)
  800667:	ff 75 dc             	pushl  -0x24(%ebp)
  80066a:	ff 75 d8             	pushl  -0x28(%ebp)
  80066d:	e8 5e 23 00 00       	call   8029d0 <__udivdi3>
  800672:	83 c4 18             	add    $0x18,%esp
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	89 f2                	mov    %esi,%edx
  800679:	89 f8                	mov    %edi,%eax
  80067b:	e8 9f ff ff ff       	call   80061f <printnum>
  800680:	83 c4 20             	add    $0x20,%esp
  800683:	eb 13                	jmp    800698 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	56                   	push   %esi
  800689:	ff 75 18             	pushl  0x18(%ebp)
  80068c:	ff d7                	call   *%edi
  80068e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800691:	83 eb 01             	sub    $0x1,%ebx
  800694:	85 db                	test   %ebx,%ebx
  800696:	7f ed                	jg     800685 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	56                   	push   %esi
  80069c:	83 ec 04             	sub    $0x4,%esp
  80069f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8006a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ab:	e8 30 24 00 00       	call   802ae0 <__umoddi3>
  8006b0:	83 c4 14             	add    $0x14,%esp
  8006b3:	0f be 80 a7 2d 80 00 	movsbl 0x802da7(%eax),%eax
  8006ba:	50                   	push   %eax
  8006bb:	ff d7                	call   *%edi
}
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c3:	5b                   	pop    %ebx
  8006c4:	5e                   	pop    %esi
  8006c5:	5f                   	pop    %edi
  8006c6:	5d                   	pop    %ebp
  8006c7:	c3                   	ret    

008006c8 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006c8:	83 fa 01             	cmp    $0x1,%edx
  8006cb:	7f 13                	jg     8006e0 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8006cd:	85 d2                	test   %edx,%edx
  8006cf:	74 1c                	je     8006ed <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006d6:	89 08                	mov    %ecx,(%eax)
  8006d8:	8b 02                	mov    (%edx),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
  8006df:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8006e5:	89 08                	mov    %ecx,(%eax)
  8006e7:	8b 02                	mov    (%edx),%eax
  8006e9:	8b 52 04             	mov    0x4(%edx),%edx
  8006ec:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8006ed:	8b 10                	mov    (%eax),%edx
  8006ef:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006f2:	89 08                	mov    %ecx,(%eax)
  8006f4:	8b 02                	mov    (%edx),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	c3                   	ret    

008006fc <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006fc:	83 fa 01             	cmp    $0x1,%edx
  8006ff:	7f 0f                	jg     800710 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800701:	85 d2                	test   %edx,%edx
  800703:	74 18                	je     80071d <getint+0x21>
		return va_arg(*ap, long);
  800705:	8b 10                	mov    (%eax),%edx
  800707:	8d 4a 04             	lea    0x4(%edx),%ecx
  80070a:	89 08                	mov    %ecx,(%eax)
  80070c:	8b 02                	mov    (%edx),%eax
  80070e:	99                   	cltd   
  80070f:	c3                   	ret    
		return va_arg(*ap, long long);
  800710:	8b 10                	mov    (%eax),%edx
  800712:	8d 4a 08             	lea    0x8(%edx),%ecx
  800715:	89 08                	mov    %ecx,(%eax)
  800717:	8b 02                	mov    (%edx),%eax
  800719:	8b 52 04             	mov    0x4(%edx),%edx
  80071c:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80071d:	8b 10                	mov    (%eax),%edx
  80071f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800722:	89 08                	mov    %ecx,(%eax)
  800724:	8b 02                	mov    (%edx),%eax
  800726:	99                   	cltd   
}
  800727:	c3                   	ret    

00800728 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800728:	f3 0f 1e fb          	endbr32 
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800732:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800736:	8b 10                	mov    (%eax),%edx
  800738:	3b 50 04             	cmp    0x4(%eax),%edx
  80073b:	73 0a                	jae    800747 <sprintputch+0x1f>
		*b->buf++ = ch;
  80073d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800740:	89 08                	mov    %ecx,(%eax)
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	88 02                	mov    %al,(%edx)
}
  800747:	5d                   	pop    %ebp
  800748:	c3                   	ret    

00800749 <printfmt>:
{
  800749:	f3 0f 1e fb          	endbr32 
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800753:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800756:	50                   	push   %eax
  800757:	ff 75 10             	pushl  0x10(%ebp)
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	ff 75 08             	pushl  0x8(%ebp)
  800760:	e8 05 00 00 00       	call   80076a <vprintfmt>
}
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <vprintfmt>:
{
  80076a:	f3 0f 1e fb          	endbr32 
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	57                   	push   %edi
  800772:	56                   	push   %esi
  800773:	53                   	push   %ebx
  800774:	83 ec 2c             	sub    $0x2c,%esp
  800777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80077a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80077d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800780:	e9 86 02 00 00       	jmp    800a0b <vprintfmt+0x2a1>
		padc = ' ';
  800785:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800789:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800790:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800797:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80079e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007a3:	8d 47 01             	lea    0x1(%edi),%eax
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a9:	0f b6 17             	movzbl (%edi),%edx
  8007ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8007af:	3c 55                	cmp    $0x55,%al
  8007b1:	0f 87 df 02 00 00    	ja     800a96 <vprintfmt+0x32c>
  8007b7:	0f b6 c0             	movzbl %al,%eax
  8007ba:	3e ff 24 85 e0 2e 80 	notrack jmp *0x802ee0(,%eax,4)
  8007c1:	00 
  8007c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8007c5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8007c9:	eb d8                	jmp    8007a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007ce:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8007d2:	eb cf                	jmp    8007a3 <vprintfmt+0x39>
  8007d4:	0f b6 d2             	movzbl %dl,%edx
  8007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8007e2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007e5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8007e9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8007ec:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8007ef:	83 f9 09             	cmp    $0x9,%ecx
  8007f2:	77 52                	ja     800846 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8007f4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8007f7:	eb e9                	jmp    8007e2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	89 55 14             	mov    %edx,0x14(%ebp)
  800802:	8b 00                	mov    (%eax),%eax
  800804:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800807:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80080a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80080e:	79 93                	jns    8007a3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800810:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800813:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800816:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80081d:	eb 84                	jmp    8007a3 <vprintfmt+0x39>
  80081f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800822:	85 c0                	test   %eax,%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	0f 49 d0             	cmovns %eax,%edx
  80082c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80082f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800832:	e9 6c ff ff ff       	jmp    8007a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800837:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80083a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800841:	e9 5d ff ff ff       	jmp    8007a3 <vprintfmt+0x39>
  800846:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800849:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80084c:	eb bc                	jmp    80080a <vprintfmt+0xa0>
			lflag++;
  80084e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800851:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800854:	e9 4a ff ff ff       	jmp    8007a3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 50 04             	lea    0x4(%eax),%edx
  80085f:	89 55 14             	mov    %edx,0x14(%ebp)
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	56                   	push   %esi
  800866:	ff 30                	pushl  (%eax)
  800868:	ff d3                	call   *%ebx
			break;
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	e9 96 01 00 00       	jmp    800a08 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	89 55 14             	mov    %edx,0x14(%ebp)
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	99                   	cltd   
  80087e:	31 d0                	xor    %edx,%eax
  800880:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800882:	83 f8 0f             	cmp    $0xf,%eax
  800885:	7f 20                	jg     8008a7 <vprintfmt+0x13d>
  800887:	8b 14 85 40 30 80 00 	mov    0x803040(,%eax,4),%edx
  80088e:	85 d2                	test   %edx,%edx
  800890:	74 15                	je     8008a7 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800892:	52                   	push   %edx
  800893:	68 3b 33 80 00       	push   $0x80333b
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	e8 aa fe ff ff       	call   800749 <printfmt>
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	e9 61 01 00 00       	jmp    800a08 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8008a7:	50                   	push   %eax
  8008a8:	68 bf 2d 80 00       	push   $0x802dbf
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	e8 95 fe ff ff       	call   800749 <printfmt>
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	e9 4c 01 00 00       	jmp    800a08 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 50 04             	lea    0x4(%eax),%edx
  8008c2:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8008c7:	85 c9                	test   %ecx,%ecx
  8008c9:	b8 b8 2d 80 00       	mov    $0x802db8,%eax
  8008ce:	0f 45 c1             	cmovne %ecx,%eax
  8008d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8008d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008d8:	7e 06                	jle    8008e0 <vprintfmt+0x176>
  8008da:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8008de:	75 0d                	jne    8008ed <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008e3:	89 c7                	mov    %eax,%edi
  8008e5:	03 45 e0             	add    -0x20(%ebp),%eax
  8008e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008eb:	eb 57                	jmp    800944 <vprintfmt+0x1da>
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8008f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8008f6:	e8 4f 02 00 00       	call   800b4a <strnlen>
  8008fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fe:	29 c2                	sub    %eax,%edx
  800900:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800903:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800906:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80090a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80090d:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80090f:	85 db                	test   %ebx,%ebx
  800911:	7e 10                	jle    800923 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	56                   	push   %esi
  800917:	57                   	push   %edi
  800918:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80091b:	83 eb 01             	sub    $0x1,%ebx
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	eb ec                	jmp    80090f <vprintfmt+0x1a5>
  800923:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800926:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800929:	85 d2                	test   %edx,%edx
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
  800930:	0f 49 c2             	cmovns %edx,%eax
  800933:	29 c2                	sub    %eax,%edx
  800935:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800938:	eb a6                	jmp    8008e0 <vprintfmt+0x176>
					putch(ch, putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	56                   	push   %esi
  80093e:	52                   	push   %edx
  80093f:	ff d3                	call   *%ebx
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800947:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800949:	83 c7 01             	add    $0x1,%edi
  80094c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800950:	0f be d0             	movsbl %al,%edx
  800953:	85 d2                	test   %edx,%edx
  800955:	74 42                	je     800999 <vprintfmt+0x22f>
  800957:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80095b:	78 06                	js     800963 <vprintfmt+0x1f9>
  80095d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800961:	78 1e                	js     800981 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800963:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800967:	74 d1                	je     80093a <vprintfmt+0x1d0>
  800969:	0f be c0             	movsbl %al,%eax
  80096c:	83 e8 20             	sub    $0x20,%eax
  80096f:	83 f8 5e             	cmp    $0x5e,%eax
  800972:	76 c6                	jbe    80093a <vprintfmt+0x1d0>
					putch('?', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	56                   	push   %esi
  800978:	6a 3f                	push   $0x3f
  80097a:	ff d3                	call   *%ebx
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	eb c3                	jmp    800944 <vprintfmt+0x1da>
  800981:	89 cf                	mov    %ecx,%edi
  800983:	eb 0e                	jmp    800993 <vprintfmt+0x229>
				putch(' ', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	56                   	push   %esi
  800989:	6a 20                	push   $0x20
  80098b:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  80098d:	83 ef 01             	sub    $0x1,%edi
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	85 ff                	test   %edi,%edi
  800995:	7f ee                	jg     800985 <vprintfmt+0x21b>
  800997:	eb 6f                	jmp    800a08 <vprintfmt+0x29e>
  800999:	89 cf                	mov    %ecx,%edi
  80099b:	eb f6                	jmp    800993 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  80099d:	89 ca                	mov    %ecx,%edx
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	e8 55 fd ff ff       	call   8006fc <getint>
  8009a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8009ad:	85 d2                	test   %edx,%edx
  8009af:	78 0b                	js     8009bc <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8009b1:	89 d1                	mov    %edx,%ecx
  8009b3:	89 c2                	mov    %eax,%edx
			base = 10;
  8009b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ba:	eb 32                	jmp    8009ee <vprintfmt+0x284>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	56                   	push   %esi
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	ff d3                	call   *%ebx
				num = -(long long) num;
  8009c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8009ca:	f7 da                	neg    %edx
  8009cc:	83 d1 00             	adc    $0x0,%ecx
  8009cf:	f7 d9                	neg    %ecx
  8009d1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8009db:	89 ca                	mov    %ecx,%edx
  8009dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e0:	e8 e3 fc ff ff       	call   8006c8 <getuint>
  8009e5:	89 d1                	mov    %edx,%ecx
  8009e7:	89 c2                	mov    %eax,%edx
			base = 10;
  8009e9:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009ee:	83 ec 0c             	sub    $0xc,%esp
  8009f1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8009f5:	57                   	push   %edi
  8009f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009f9:	50                   	push   %eax
  8009fa:	51                   	push   %ecx
  8009fb:	52                   	push   %edx
  8009fc:	89 f2                	mov    %esi,%edx
  8009fe:	89 d8                	mov    %ebx,%eax
  800a00:	e8 1a fc ff ff       	call   80061f <printnum>
			break;
  800a05:	83 c4 20             	add    $0x20,%esp
{
  800a08:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0b:	83 c7 01             	add    $0x1,%edi
  800a0e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a12:	83 f8 25             	cmp    $0x25,%eax
  800a15:	0f 84 6a fd ff ff    	je     800785 <vprintfmt+0x1b>
			if (ch == '\0')
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	0f 84 93 00 00 00    	je     800ab6 <vprintfmt+0x34c>
			putch(ch, putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	56                   	push   %esi
  800a27:	50                   	push   %eax
  800a28:	ff d3                	call   *%ebx
  800a2a:	83 c4 10             	add    $0x10,%esp
  800a2d:	eb dc                	jmp    800a0b <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800a2f:	89 ca                	mov    %ecx,%edx
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	e8 8f fc ff ff       	call   8006c8 <getuint>
  800a39:	89 d1                	mov    %edx,%ecx
  800a3b:	89 c2                	mov    %eax,%edx
			base = 8;
  800a3d:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800a42:	eb aa                	jmp    8009ee <vprintfmt+0x284>
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	56                   	push   %esi
  800a48:	6a 30                	push   $0x30
  800a4a:	ff d3                	call   *%ebx
			putch('x', putdat);
  800a4c:	83 c4 08             	add    $0x8,%esp
  800a4f:	56                   	push   %esi
  800a50:	6a 78                	push   $0x78
  800a52:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	8d 50 04             	lea    0x4(%eax),%edx
  800a5a:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800a5d:	8b 10                	mov    (%eax),%edx
  800a5f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a64:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800a67:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800a6c:	eb 80                	jmp    8009ee <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800a6e:	89 ca                	mov    %ecx,%edx
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	e8 50 fc ff ff       	call   8006c8 <getuint>
  800a78:	89 d1                	mov    %edx,%ecx
  800a7a:	89 c2                	mov    %eax,%edx
			base = 16;
  800a7c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a81:	e9 68 ff ff ff       	jmp    8009ee <vprintfmt+0x284>
			putch(ch, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	56                   	push   %esi
  800a8a:	6a 25                	push   $0x25
  800a8c:	ff d3                	call   *%ebx
			break;
  800a8e:	83 c4 10             	add    $0x10,%esp
  800a91:	e9 72 ff ff ff       	jmp    800a08 <vprintfmt+0x29e>
			putch('%', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	56                   	push   %esi
  800a9a:	6a 25                	push   $0x25
  800a9c:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 f8                	mov    %edi,%eax
  800aa3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800aa7:	74 05                	je     800aae <vprintfmt+0x344>
  800aa9:	83 e8 01             	sub    $0x1,%eax
  800aac:	eb f5                	jmp    800aa3 <vprintfmt+0x339>
  800aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab1:	e9 52 ff ff ff       	jmp    800a08 <vprintfmt+0x29e>
}
  800ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5f                   	pop    %edi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800abe:	f3 0f 1e fb          	endbr32 
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 18             	sub    $0x18,%esp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	74 26                	je     800b09 <vsnprintf+0x4b>
  800ae3:	85 d2                	test   %edx,%edx
  800ae5:	7e 22                	jle    800b09 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae7:	ff 75 14             	pushl  0x14(%ebp)
  800aea:	ff 75 10             	pushl  0x10(%ebp)
  800aed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	68 28 07 80 00       	push   $0x800728
  800af6:	e8 6f fc ff ff       	call   80076a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800afe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b04:	83 c4 10             	add    $0x10,%esp
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    
		return -E_INVAL;
  800b09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b0e:	eb f7                	jmp    800b07 <vsnprintf+0x49>

00800b10 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b10:	f3 0f 1e fb          	endbr32 
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b1a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b1d:	50                   	push   %eax
  800b1e:	ff 75 10             	pushl  0x10(%ebp)
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 92 ff ff ff       	call   800abe <vsnprintf>
	va_end(ap);

	return rc;
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b2e:	f3 0f 1e fb          	endbr32 
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b41:	74 05                	je     800b48 <strlen+0x1a>
		n++;
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	eb f5                	jmp    800b3d <strlen+0xf>
	return n;
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b4a:	f3 0f 1e fb          	endbr32 
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b54:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	39 d0                	cmp    %edx,%eax
  800b5e:	74 0d                	je     800b6d <strnlen+0x23>
  800b60:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b64:	74 05                	je     800b6b <strnlen+0x21>
		n++;
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	eb f1                	jmp    800b5c <strnlen+0x12>
  800b6b:	89 c2                	mov    %eax,%edx
	return n;
}
  800b6d:	89 d0                	mov    %edx,%eax
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b71:	f3 0f 1e fb          	endbr32 
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	53                   	push   %ebx
  800b79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b84:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b88:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	84 d2                	test   %dl,%dl
  800b90:	75 f2                	jne    800b84 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800b92:	89 c8                	mov    %ecx,%eax
  800b94:	5b                   	pop    %ebx
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b97:	f3 0f 1e fb          	endbr32 
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	53                   	push   %ebx
  800b9f:	83 ec 10             	sub    $0x10,%esp
  800ba2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ba5:	53                   	push   %ebx
  800ba6:	e8 83 ff ff ff       	call   800b2e <strlen>
  800bab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	01 d8                	add    %ebx,%eax
  800bb3:	50                   	push   %eax
  800bb4:	e8 b8 ff ff ff       	call   800b71 <strcpy>
	return dst;
}
  800bb9:	89 d8                	mov    %ebx,%eax
  800bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bc0:	f3 0f 1e fb          	endbr32 
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 75 08             	mov    0x8(%ebp),%esi
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcf:	89 f3                	mov    %esi,%ebx
  800bd1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd4:	89 f0                	mov    %esi,%eax
  800bd6:	39 d8                	cmp    %ebx,%eax
  800bd8:	74 11                	je     800beb <strncpy+0x2b>
		*dst++ = *src;
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	0f b6 0a             	movzbl (%edx),%ecx
  800be0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be3:	80 f9 01             	cmp    $0x1,%cl
  800be6:	83 da ff             	sbb    $0xffffffff,%edx
  800be9:	eb eb                	jmp    800bd6 <strncpy+0x16>
	}
	return ret;
}
  800beb:	89 f0                	mov    %esi,%eax
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf1:	f3 0f 1e fb          	endbr32 
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	8b 75 08             	mov    0x8(%ebp),%esi
  800bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c00:	8b 55 10             	mov    0x10(%ebp),%edx
  800c03:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c05:	85 d2                	test   %edx,%edx
  800c07:	74 21                	je     800c2a <strlcpy+0x39>
  800c09:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c0d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c0f:	39 c2                	cmp    %eax,%edx
  800c11:	74 14                	je     800c27 <strlcpy+0x36>
  800c13:	0f b6 19             	movzbl (%ecx),%ebx
  800c16:	84 db                	test   %bl,%bl
  800c18:	74 0b                	je     800c25 <strlcpy+0x34>
			*dst++ = *src++;
  800c1a:	83 c1 01             	add    $0x1,%ecx
  800c1d:	83 c2 01             	add    $0x1,%edx
  800c20:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c23:	eb ea                	jmp    800c0f <strlcpy+0x1e>
  800c25:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c2a:	29 f0                	sub    %esi,%eax
}
  800c2c:	5b                   	pop    %ebx
  800c2d:	5e                   	pop    %esi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c30:	f3 0f 1e fb          	endbr32 
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c3d:	0f b6 01             	movzbl (%ecx),%eax
  800c40:	84 c0                	test   %al,%al
  800c42:	74 0c                	je     800c50 <strcmp+0x20>
  800c44:	3a 02                	cmp    (%edx),%al
  800c46:	75 08                	jne    800c50 <strcmp+0x20>
		p++, q++;
  800c48:	83 c1 01             	add    $0x1,%ecx
  800c4b:	83 c2 01             	add    $0x1,%edx
  800c4e:	eb ed                	jmp    800c3d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c50:	0f b6 c0             	movzbl %al,%eax
  800c53:	0f b6 12             	movzbl (%edx),%edx
  800c56:	29 d0                	sub    %edx,%eax
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c5a:	f3 0f 1e fb          	endbr32 
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	53                   	push   %ebx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c68:	89 c3                	mov    %eax,%ebx
  800c6a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c6d:	eb 06                	jmp    800c75 <strncmp+0x1b>
		n--, p++, q++;
  800c6f:	83 c0 01             	add    $0x1,%eax
  800c72:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c75:	39 d8                	cmp    %ebx,%eax
  800c77:	74 16                	je     800c8f <strncmp+0x35>
  800c79:	0f b6 08             	movzbl (%eax),%ecx
  800c7c:	84 c9                	test   %cl,%cl
  800c7e:	74 04                	je     800c84 <strncmp+0x2a>
  800c80:	3a 0a                	cmp    (%edx),%cl
  800c82:	74 eb                	je     800c6f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c84:	0f b6 00             	movzbl (%eax),%eax
  800c87:	0f b6 12             	movzbl (%edx),%edx
  800c8a:	29 d0                	sub    %edx,%eax
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    
		return 0;
  800c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c94:	eb f6                	jmp    800c8c <strncmp+0x32>

00800c96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c96:	f3 0f 1e fb          	endbr32 
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	0f b6 10             	movzbl (%eax),%edx
  800ca7:	84 d2                	test   %dl,%dl
  800ca9:	74 09                	je     800cb4 <strchr+0x1e>
		if (*s == c)
  800cab:	38 ca                	cmp    %cl,%dl
  800cad:	74 0a                	je     800cb9 <strchr+0x23>
	for (; *s; s++)
  800caf:	83 c0 01             	add    $0x1,%eax
  800cb2:	eb f0                	jmp    800ca4 <strchr+0xe>
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	f3 0f 1e fb          	endbr32 
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ccc:	38 ca                	cmp    %cl,%dl
  800cce:	74 09                	je     800cd9 <strfind+0x1e>
  800cd0:	84 d2                	test   %dl,%dl
  800cd2:	74 05                	je     800cd9 <strfind+0x1e>
	for (; *s; s++)
  800cd4:	83 c0 01             	add    $0x1,%eax
  800cd7:	eb f0                	jmp    800cc9 <strfind+0xe>
			break;
	return (char *) s;
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800ceb:	85 c9                	test   %ecx,%ecx
  800ced:	74 33                	je     800d22 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cef:	89 d0                	mov    %edx,%eax
  800cf1:	09 c8                	or     %ecx,%eax
  800cf3:	a8 03                	test   $0x3,%al
  800cf5:	75 23                	jne    800d1a <memset+0x3f>
		c &= 0xFF;
  800cf7:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cfb:	89 d8                	mov    %ebx,%eax
  800cfd:	c1 e0 08             	shl    $0x8,%eax
  800d00:	89 df                	mov    %ebx,%edi
  800d02:	c1 e7 18             	shl    $0x18,%edi
  800d05:	89 de                	mov    %ebx,%esi
  800d07:	c1 e6 10             	shl    $0x10,%esi
  800d0a:	09 f7                	or     %esi,%edi
  800d0c:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800d0e:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d11:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	fc                   	cld    
  800d16:	f3 ab                	rep stos %eax,%es:(%edi)
  800d18:	eb 08                	jmp    800d22 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	fc                   	cld    
  800d20:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800d22:	89 d0                	mov    %edx,%eax
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d29:	f3 0f 1e fb          	endbr32 
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d38:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d3b:	39 c6                	cmp    %eax,%esi
  800d3d:	73 32                	jae    800d71 <memmove+0x48>
  800d3f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	76 2b                	jbe    800d71 <memmove+0x48>
		s += n;
		d += n;
  800d46:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d49:	89 fe                	mov    %edi,%esi
  800d4b:	09 ce                	or     %ecx,%esi
  800d4d:	09 d6                	or     %edx,%esi
  800d4f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d55:	75 0e                	jne    800d65 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d57:	83 ef 04             	sub    $0x4,%edi
  800d5a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d5d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d60:	fd                   	std    
  800d61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d63:	eb 09                	jmp    800d6e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d65:	83 ef 01             	sub    $0x1,%edi
  800d68:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d6b:	fd                   	std    
  800d6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d6e:	fc                   	cld    
  800d6f:	eb 1a                	jmp    800d8b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d71:	89 c2                	mov    %eax,%edx
  800d73:	09 ca                	or     %ecx,%edx
  800d75:	09 f2                	or     %esi,%edx
  800d77:	f6 c2 03             	test   $0x3,%dl
  800d7a:	75 0a                	jne    800d86 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d7f:	89 c7                	mov    %eax,%edi
  800d81:	fc                   	cld    
  800d82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d84:	eb 05                	jmp    800d8b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800d86:	89 c7                	mov    %eax,%edi
  800d88:	fc                   	cld    
  800d89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d8f:	f3 0f 1e fb          	endbr32 
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d99:	ff 75 10             	pushl  0x10(%ebp)
  800d9c:	ff 75 0c             	pushl  0xc(%ebp)
  800d9f:	ff 75 08             	pushl  0x8(%ebp)
  800da2:	e8 82 ff ff ff       	call   800d29 <memmove>
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800da9:	f3 0f 1e fb          	endbr32 
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	89 c6                	mov    %eax,%esi
  800dba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbd:	39 f0                	cmp    %esi,%eax
  800dbf:	74 1c                	je     800ddd <memcmp+0x34>
		if (*s1 != *s2)
  800dc1:	0f b6 08             	movzbl (%eax),%ecx
  800dc4:	0f b6 1a             	movzbl (%edx),%ebx
  800dc7:	38 d9                	cmp    %bl,%cl
  800dc9:	75 08                	jne    800dd3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dcb:	83 c0 01             	add    $0x1,%eax
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	eb ea                	jmp    800dbd <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800dd3:	0f b6 c1             	movzbl %cl,%eax
  800dd6:	0f b6 db             	movzbl %bl,%ebx
  800dd9:	29 d8                	sub    %ebx,%eax
  800ddb:	eb 05                	jmp    800de2 <memcmp+0x39>
	}

	return 0;
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800df3:	89 c2                	mov    %eax,%edx
  800df5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df8:	39 d0                	cmp    %edx,%eax
  800dfa:	73 09                	jae    800e05 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dfc:	38 08                	cmp    %cl,(%eax)
  800dfe:	74 05                	je     800e05 <memfind+0x1f>
	for (; s < ends; s++)
  800e00:	83 c0 01             	add    $0x1,%eax
  800e03:	eb f3                	jmp    800df8 <memfind+0x12>
			break;
	return (void *) s;
}
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e17:	eb 03                	jmp    800e1c <strtol+0x15>
		s++;
  800e19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e1c:	0f b6 01             	movzbl (%ecx),%eax
  800e1f:	3c 20                	cmp    $0x20,%al
  800e21:	74 f6                	je     800e19 <strtol+0x12>
  800e23:	3c 09                	cmp    $0x9,%al
  800e25:	74 f2                	je     800e19 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800e27:	3c 2b                	cmp    $0x2b,%al
  800e29:	74 2a                	je     800e55 <strtol+0x4e>
	int neg = 0;
  800e2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e30:	3c 2d                	cmp    $0x2d,%al
  800e32:	74 2b                	je     800e5f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e3a:	75 0f                	jne    800e4b <strtol+0x44>
  800e3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800e3f:	74 28                	je     800e69 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e48:	0f 44 d8             	cmove  %eax,%ebx
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e53:	eb 46                	jmp    800e9b <strtol+0x94>
		s++;
  800e55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e58:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5d:	eb d5                	jmp    800e34 <strtol+0x2d>
		s++, neg = 1;
  800e5f:	83 c1 01             	add    $0x1,%ecx
  800e62:	bf 01 00 00 00       	mov    $0x1,%edi
  800e67:	eb cb                	jmp    800e34 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e6d:	74 0e                	je     800e7d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	75 d8                	jne    800e4b <strtol+0x44>
		s++, base = 8;
  800e73:	83 c1 01             	add    $0x1,%ecx
  800e76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e7b:	eb ce                	jmp    800e4b <strtol+0x44>
		s += 2, base = 16;
  800e7d:	83 c1 02             	add    $0x2,%ecx
  800e80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e85:	eb c4                	jmp    800e4b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e87:	0f be d2             	movsbl %dl,%edx
  800e8a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e90:	7d 3a                	jge    800ecc <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e92:	83 c1 01             	add    $0x1,%ecx
  800e95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9b:	0f b6 11             	movzbl (%ecx),%edx
  800e9e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea1:	89 f3                	mov    %esi,%ebx
  800ea3:	80 fb 09             	cmp    $0x9,%bl
  800ea6:	76 df                	jbe    800e87 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ea8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800eab:	89 f3                	mov    %esi,%ebx
  800ead:	80 fb 19             	cmp    $0x19,%bl
  800eb0:	77 08                	ja     800eba <strtol+0xb3>
			dig = *s - 'a' + 10;
  800eb2:	0f be d2             	movsbl %dl,%edx
  800eb5:	83 ea 57             	sub    $0x57,%edx
  800eb8:	eb d3                	jmp    800e8d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800eba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ebd:	89 f3                	mov    %esi,%ebx
  800ebf:	80 fb 19             	cmp    $0x19,%bl
  800ec2:	77 08                	ja     800ecc <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ec4:	0f be d2             	movsbl %dl,%edx
  800ec7:	83 ea 37             	sub    $0x37,%edx
  800eca:	eb c1                	jmp    800e8d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed0:	74 05                	je     800ed7 <strtol+0xd0>
		*endptr = (char *) s;
  800ed2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ed7:	89 c2                	mov    %eax,%edx
  800ed9:	f7 da                	neg    %edx
  800edb:	85 ff                	test   %edi,%edi
  800edd:	0f 45 c2             	cmovne %edx,%eax
}
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
  800eeb:	83 ec 1c             	sub    $0x1c,%esp
  800eee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ef1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ef4:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800efc:	8b 7d 10             	mov    0x10(%ebp),%edi
  800eff:	8b 75 14             	mov    0x14(%ebp),%esi
  800f02:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f08:	74 04                	je     800f0e <syscall+0x29>
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	ff 75 e0             	pushl  -0x20(%ebp)
  800f1d:	68 9f 30 80 00       	push   $0x80309f
  800f22:	6a 23                	push   $0x23
  800f24:	68 bc 30 80 00       	push   $0x8030bc
  800f29:	e8 f2 f5 ff ff       	call   800520 <_panic>

00800f2e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800f2e:	f3 0f 1e fb          	endbr32 
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800f38:	6a 00                	push   $0x0
  800f3a:	6a 00                	push   $0x0
  800f3c:	6a 00                	push   $0x0
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f44:	ba 00 00 00 00       	mov    $0x0,%edx
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4e:	e8 92 ff ff ff       	call   800ee5 <syscall>
}
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f58:	f3 0f 1e fb          	endbr32 
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800f62:	6a 00                	push   $0x0
  800f64:	6a 00                	push   $0x0
  800f66:	6a 00                	push   $0x0
  800f68:	6a 00                	push   $0x0
  800f6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f74:	b8 01 00 00 00       	mov    $0x1,%eax
  800f79:	e8 67 ff ff ff       	call   800ee5 <syscall>
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800f8a:	6a 00                	push   $0x0
  800f8c:	6a 00                	push   $0x0
  800f8e:	6a 00                	push   $0x0
  800f90:	6a 00                	push   $0x0
  800f92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f95:	ba 01 00 00 00       	mov    $0x1,%edx
  800f9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9f:	e8 41 ff ff ff       	call   800ee5 <syscall>
}
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fa6:	f3 0f 1e fb          	endbr32 
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800fb0:	6a 00                	push   $0x0
  800fb2:	6a 00                	push   $0x0
  800fb4:	6a 00                	push   $0x0
  800fb6:	6a 00                	push   $0x0
  800fb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800fc7:	e8 19 ff ff ff       	call   800ee5 <syscall>
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <sys_yield>:

void
sys_yield(void)
{
  800fce:	f3 0f 1e fb          	endbr32 
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800fd8:	6a 00                	push   $0x0
  800fda:	6a 00                	push   $0x0
  800fdc:	6a 00                	push   $0x0
  800fde:	6a 00                	push   $0x0
  800fe0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fea:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fef:	e8 f1 fe ff ff       	call   800ee5 <syscall>
}
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ff9:	f3 0f 1e fb          	endbr32 
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801003:	6a 00                	push   $0x0
  801005:	6a 00                	push   $0x0
  801007:	ff 75 10             	pushl  0x10(%ebp)
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801010:	ba 01 00 00 00       	mov    $0x1,%edx
  801015:	b8 04 00 00 00       	mov    $0x4,%eax
  80101a:	e8 c6 fe ff ff       	call   800ee5 <syscall>
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801021:	f3 0f 1e fb          	endbr32 
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80102b:	ff 75 18             	pushl  0x18(%ebp)
  80102e:	ff 75 14             	pushl  0x14(%ebp)
  801031:	ff 75 10             	pushl  0x10(%ebp)
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103a:	ba 01 00 00 00       	mov    $0x1,%edx
  80103f:	b8 05 00 00 00       	mov    $0x5,%eax
  801044:	e8 9c fe ff ff       	call   800ee5 <syscall>
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80104b:	f3 0f 1e fb          	endbr32 
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801055:	6a 00                	push   $0x0
  801057:	6a 00                	push   $0x0
  801059:	6a 00                	push   $0x0
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801061:	ba 01 00 00 00       	mov    $0x1,%edx
  801066:	b8 06 00 00 00       	mov    $0x6,%eax
  80106b:	e8 75 fe ff ff       	call   800ee5 <syscall>
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80107c:	6a 00                	push   $0x0
  80107e:	6a 00                	push   $0x0
  801080:	6a 00                	push   $0x0
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801088:	ba 01 00 00 00       	mov    $0x1,%edx
  80108d:	b8 08 00 00 00       	mov    $0x8,%eax
  801092:	e8 4e fe ff ff       	call   800ee5 <syscall>
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801099:	f3 0f 1e fb          	endbr32 
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 00                	push   $0x0
  8010a9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010af:	ba 01 00 00 00       	mov    $0x1,%edx
  8010b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b9:	e8 27 fe ff ff       	call   800ee5 <syscall>
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010c0:	f3 0f 1e fb          	endbr32 
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d6:	ba 01 00 00 00       	mov    $0x1,%edx
  8010db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e0:	e8 00 fe ff ff       	call   800ee5 <syscall>
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010e7:	f3 0f 1e fb          	endbr32 
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8010f1:	6a 00                	push   $0x0
  8010f3:	ff 75 14             	pushl  0x14(%ebp)
  8010f6:	ff 75 10             	pushl  0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801104:	b8 0c 00 00 00       	mov    $0xc,%eax
  801109:	e8 d7 fd ff ff       	call   800ee5 <syscall>
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801125:	ba 01 00 00 00       	mov    $0x1,%edx
  80112a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80112f:	e8 b1 fd ff ff       	call   800ee5 <syscall>
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	53                   	push   %ebx
  80113a:	83 ec 04             	sub    $0x4,%esp
  80113d:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  80113f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  801146:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  801149:	f6 c6 04             	test   $0x4,%dh
  80114c:	75 51                	jne    80119f <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  80114e:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801154:	0f 84 84 00 00 00    	je     8011de <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	68 05 08 00 00       	push   $0x805
  801162:	53                   	push   %ebx
  801163:	50                   	push   %eax
  801164:	53                   	push   %ebx
  801165:	6a 00                	push   $0x0
  801167:	e8 b5 fe ff ff       	call   801021 <sys_page_map>
		if (r)
  80116c:	83 c4 20             	add    $0x20,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 59                	jne    8011cc <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	68 05 08 00 00       	push   $0x805
  80117b:	53                   	push   %ebx
  80117c:	6a 00                	push   $0x0
  80117e:	53                   	push   %ebx
  80117f:	6a 00                	push   $0x0
  801181:	e8 9b fe ff ff       	call   801021 <sys_page_map>
		if (r)
  801186:	83 c4 20             	add    $0x20,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	74 67                	je     8011f4 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  80118d:	50                   	push   %eax
  80118e:	68 ca 30 80 00       	push   $0x8030ca
  801193:	6a 5f                	push   $0x5f
  801195:	68 e5 30 80 00       	push   $0x8030e5
  80119a:	e8 81 f3 ff ff       	call   800520 <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011a8:	52                   	push   %edx
  8011a9:	53                   	push   %ebx
  8011aa:	50                   	push   %eax
  8011ab:	53                   	push   %ebx
  8011ac:	6a 00                	push   $0x0
  8011ae:	e8 6e fe ff ff       	call   801021 <sys_page_map>
		if (r)
  8011b3:	83 c4 20             	add    $0x20,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 3a                	je     8011f4 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  8011ba:	50                   	push   %eax
  8011bb:	68 ca 30 80 00       	push   $0x8030ca
  8011c0:	6a 57                	push   $0x57
  8011c2:	68 e5 30 80 00       	push   $0x8030e5
  8011c7:	e8 54 f3 ff ff       	call   800520 <_panic>
			panic("[duppage] sys_page_map: %e", r);
  8011cc:	50                   	push   %eax
  8011cd:	68 ca 30 80 00       	push   $0x8030ca
  8011d2:	6a 5b                	push   $0x5b
  8011d4:	68 e5 30 80 00       	push   $0x8030e5
  8011d9:	e8 42 f3 ff ff       	call   800520 <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	6a 05                	push   $0x5
  8011e3:	53                   	push   %ebx
  8011e4:	50                   	push   %eax
  8011e5:	53                   	push   %ebx
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 34 fe ff ff       	call   801021 <sys_page_map>
		if (r)
  8011ed:	83 c4 20             	add    $0x20,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	75 0a                	jne    8011fe <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  8011fe:	50                   	push   %eax
  8011ff:	68 ca 30 80 00       	push   $0x8030ca
  801204:	6a 63                	push   $0x63
  801206:	68 e5 30 80 00       	push   $0x8030e5
  80120b:	e8 10 f3 ff ff       	call   800520 <_panic>

00801210 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	89 c7                	mov    %eax,%edi
  80121b:	89 d6                	mov    %edx,%esi
  80121d:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  80121f:	f6 c1 02             	test   $0x2,%cl
  801222:	75 2f                	jne    801253 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  801224:	83 ec 0c             	sub    $0xc,%esp
  801227:	51                   	push   %ecx
  801228:	52                   	push   %edx
  801229:	50                   	push   %eax
  80122a:	52                   	push   %edx
  80122b:	6a 00                	push   $0x0
  80122d:	e8 ef fd ff ff       	call   801021 <sys_page_map>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 08                	js     801241 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  801239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123c:	5b                   	pop    %ebx
  80123d:	5e                   	pop    %esi
  80123e:	5f                   	pop    %edi
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    
			panic("sys_page_map: %e", r);
  801241:	50                   	push   %eax
  801242:	68 d4 30 80 00       	push   $0x8030d4
  801247:	6a 6f                	push   $0x6f
  801249:	68 e5 30 80 00       	push   $0x8030e5
  80124e:	e8 cd f2 ff ff       	call   800520 <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	51                   	push   %ecx
  801257:	52                   	push   %edx
  801258:	50                   	push   %eax
  801259:	e8 9b fd ff ff       	call   800ff9 <sys_page_alloc>
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 54                	js     8012b9 <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  801265:	83 ec 0c             	sub    $0xc,%esp
  801268:	53                   	push   %ebx
  801269:	68 00 00 40 00       	push   $0x400000
  80126e:	6a 00                	push   $0x0
  801270:	56                   	push   %esi
  801271:	57                   	push   %edi
  801272:	e8 aa fd ff ff       	call   801021 <sys_page_map>
  801277:	83 c4 20             	add    $0x20,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 4d                	js     8012cb <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	68 00 10 00 00       	push   $0x1000
  801286:	56                   	push   %esi
  801287:	68 00 00 40 00       	push   $0x400000
  80128c:	e8 98 fa ff ff       	call   800d29 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801291:	83 c4 08             	add    $0x8,%esp
  801294:	68 00 00 40 00       	push   $0x400000
  801299:	6a 00                	push   $0x0
  80129b:	e8 ab fd ff ff       	call   80104b <sys_page_unmap>
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	79 92                	jns    801239 <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  8012a7:	50                   	push   %eax
  8012a8:	68 03 31 80 00       	push   $0x803103
  8012ad:	6a 78                	push   $0x78
  8012af:	68 e5 30 80 00       	push   $0x8030e5
  8012b4:	e8 67 f2 ff ff       	call   800520 <_panic>
		panic("sys_page_alloc: %e", r);
  8012b9:	50                   	push   %eax
  8012ba:	68 f0 30 80 00       	push   $0x8030f0
  8012bf:	6a 73                	push   $0x73
  8012c1:	68 e5 30 80 00       	push   $0x8030e5
  8012c6:	e8 55 f2 ff ff       	call   800520 <_panic>
		panic("sys_page_map: %e", r);
  8012cb:	50                   	push   %eax
  8012cc:	68 d4 30 80 00       	push   $0x8030d4
  8012d1:	6a 75                	push   $0x75
  8012d3:	68 e5 30 80 00       	push   $0x8030e5
  8012d8:	e8 43 f2 ff ff       	call   800520 <_panic>

008012dd <pgfault>:
{
  8012dd:	f3 0f 1e fb          	endbr32 
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	53                   	push   %ebx
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8012eb:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8012ed:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  8012f0:	89 da                	mov    %ebx,%edx
  8012f2:	c1 ea 0c             	shr    $0xc,%edx
  8012f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  8012fc:	a8 01                	test   $0x1,%al
  8012fe:	74 7e                	je     80137e <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  801300:	a8 02                	test   $0x2,%al
  801302:	0f 84 8a 00 00 00    	je     801392 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  801308:	f6 c6 08             	test   $0x8,%dh
  80130b:	0f 84 95 00 00 00    	je     8013a6 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	6a 07                	push   $0x7
  801316:	68 00 f0 7f 00       	push   $0x7ff000
  80131b:	6a 00                	push   $0x0
  80131d:	e8 d7 fc ff ff       	call   800ff9 <sys_page_alloc>
	if (r)
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	0f 85 8d 00 00 00    	jne    8013ba <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80132d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	68 00 10 00 00       	push   $0x1000
  80133b:	53                   	push   %ebx
  80133c:	68 00 f0 7f 00       	push   $0x7ff000
  801341:	e8 49 fa ff ff       	call   800d8f <memcpy>
	r = sys_page_map(
  801346:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80134d:	53                   	push   %ebx
  80134e:	6a 00                	push   $0x0
  801350:	68 00 f0 7f 00       	push   $0x7ff000
  801355:	6a 00                	push   $0x0
  801357:	e8 c5 fc ff ff       	call   801021 <sys_page_map>
	if (r)
  80135c:	83 c4 20             	add    $0x20,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	75 69                	jne    8013cc <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	68 00 f0 7f 00       	push   $0x7ff000
  80136b:	6a 00                	push   $0x0
  80136d:	e8 d9 fc ff ff       	call   80104b <sys_page_unmap>
	if (r)
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	75 65                	jne    8013de <pgfault+0x101>
}
  801379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	68 84 31 80 00       	push   $0x803184
  801386:	6a 20                	push   $0x20
  801388:	68 e5 30 80 00       	push   $0x8030e5
  80138d:	e8 8e f1 ff ff       	call   800520 <_panic>
		panic("[pgfault] pgfault por lectura");
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	68 16 31 80 00       	push   $0x803116
  80139a:	6a 23                	push   $0x23
  80139c:	68 e5 30 80 00       	push   $0x8030e5
  8013a1:	e8 7a f1 ff ff       	call   800520 <_panic>
		panic("[pgfault] pgfault COW no configurado");
  8013a6:	83 ec 04             	sub    $0x4,%esp
  8013a9:	68 b0 31 80 00       	push   $0x8031b0
  8013ae:	6a 27                	push   $0x27
  8013b0:	68 e5 30 80 00       	push   $0x8030e5
  8013b5:	e8 66 f1 ff ff       	call   800520 <_panic>
		panic("pgfault: %e", r);
  8013ba:	50                   	push   %eax
  8013bb:	68 34 31 80 00       	push   $0x803134
  8013c0:	6a 32                	push   $0x32
  8013c2:	68 e5 30 80 00       	push   $0x8030e5
  8013c7:	e8 54 f1 ff ff       	call   800520 <_panic>
		panic("pgfault: %e", r);
  8013cc:	50                   	push   %eax
  8013cd:	68 34 31 80 00       	push   $0x803134
  8013d2:	6a 39                	push   $0x39
  8013d4:	68 e5 30 80 00       	push   $0x8030e5
  8013d9:	e8 42 f1 ff ff       	call   800520 <_panic>
		panic("pgfault: %e", r);
  8013de:	50                   	push   %eax
  8013df:	68 34 31 80 00       	push   $0x803134
  8013e4:	6a 3d                	push   $0x3d
  8013e6:	68 e5 30 80 00       	push   $0x8030e5
  8013eb:	e8 30 f1 ff ff       	call   800520 <_panic>

008013f0 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013fd:	b8 07 00 00 00       	mov    $0x7,%eax
  801402:	cd 30                	int    $0x30
  801404:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801406:	85 c0                	test   %eax,%eax
  801408:	78 22                	js     80142c <fork_v0+0x3c>
  80140a:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  80140c:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801411:	75 52                	jne    801465 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801413:	e8 8e fb ff ff       	call   800fa6 <sys_getenvid>
  801418:	25 ff 03 00 00       	and    $0x3ff,%eax
  80141d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801420:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801425:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80142a:	eb 6e                	jmp    80149a <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  80142c:	50                   	push   %eax
  80142d:	68 d8 31 80 00       	push   $0x8031d8
  801432:	68 8a 00 00 00       	push   $0x8a
  801437:	68 e5 30 80 00       	push   $0x8030e5
  80143c:	e8 df f0 ff ff       	call   800520 <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801441:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801448:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80144e:	89 da                	mov    %ebx,%edx
  801450:	89 f0                	mov    %esi,%eax
  801452:	e8 b9 fd ff ff       	call   801210 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80145d:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801463:	74 23                	je     801488 <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801465:	89 d8                	mov    %ebx,%eax
  801467:	c1 e8 16             	shr    $0x16,%eax
  80146a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801471:	a8 01                	test   $0x1,%al
  801473:	74 e2                	je     801457 <fork_v0+0x67>
  801475:	89 d8                	mov    %ebx,%eax
  801477:	c1 e8 0c             	shr    $0xc,%eax
  80147a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801481:	f6 c2 01             	test   $0x1,%dl
  801484:	74 d1                	je     801457 <fork_v0+0x67>
  801486:	eb b9                	jmp    801441 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	6a 02                	push   $0x2
  80148d:	57                   	push   %edi
  80148e:	e8 df fb ff ff       	call   801072 <sys_env_set_status>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	78 0a                	js     8014a4 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  80149a:	89 f8                	mov    %edi,%eax
  80149c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  8014a4:	50                   	push   %eax
  8014a5:	68 fc 31 80 00       	push   $0x8031fc
  8014aa:	68 98 00 00 00       	push   $0x98
  8014af:	68 e5 30 80 00       	push   $0x8030e5
  8014b4:	e8 67 f0 ff ff       	call   800520 <_panic>

008014b9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014b9:	f3 0f 1e fb          	endbr32 
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	57                   	push   %edi
  8014c1:	56                   	push   %esi
  8014c2:	53                   	push   %ebx
  8014c3:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  8014c6:	68 dd 12 80 00       	push   $0x8012dd
  8014cb:	e8 15 13 00 00       	call   8027e5 <set_pgfault_handler>
  8014d0:	b8 07 00 00 00       	mov    $0x7,%eax
  8014d5:	cd 30                	int    $0x30
  8014d7:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 37                	js     801517 <fork+0x5e>
  8014e0:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8014e2:	74 48                	je     80152c <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	6a 07                	push   $0x7
  8014e9:	68 00 f0 bf ee       	push   $0xeebff000
  8014ee:	50                   	push   %eax
  8014ef:	e8 05 fb ff ff       	call   800ff9 <sys_page_alloc>
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 4d                	js     801548 <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	68 62 28 80 00       	push   $0x802862
  801503:	56                   	push   %esi
  801504:	e8 b7 fb ff ff       	call   8010c0 <sys_env_set_pgfault_upcall>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 4d                	js     80155d <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801510:	bb 00 00 00 00       	mov    $0x0,%ebx
  801515:	eb 70                	jmp    801587 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801517:	50                   	push   %eax
  801518:	68 40 31 80 00       	push   $0x803140
  80151d:	68 b7 00 00 00       	push   $0xb7
  801522:	68 e5 30 80 00       	push   $0x8030e5
  801527:	e8 f4 ef ff ff       	call   800520 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80152c:	e8 75 fa ff ff       	call   800fa6 <sys_getenvid>
  801531:	25 ff 03 00 00       	and    $0x3ff,%eax
  801536:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801539:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80153e:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801543:	e9 80 00 00 00       	jmp    8015c8 <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801548:	50                   	push   %eax
  801549:	68 50 31 80 00       	push   $0x803150
  80154e:	68 c0 00 00 00       	push   $0xc0
  801553:	68 e5 30 80 00       	push   $0x8030e5
  801558:	e8 c3 ef ff ff       	call   800520 <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  80155d:	50                   	push   %eax
  80155e:	68 20 32 80 00       	push   $0x803220
  801563:	68 c3 00 00 00       	push   $0xc3
  801568:	68 e5 30 80 00       	push   $0x8030e5
  80156d:	e8 ae ef ff ff       	call   800520 <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801572:	89 f8                	mov    %edi,%eax
  801574:	e8 bd fb ff ff       	call   801136 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801579:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80157f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801585:	74 2f                	je     8015b6 <fork+0xfd>
  801587:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  801589:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  80158f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  801594:	76 e3                	jbe    801579 <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801596:	89 d8                	mov    %ebx,%eax
  801598:	c1 e8 16             	shr    $0x16,%eax
  80159b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a2:	a8 01                	test   $0x1,%al
  8015a4:	74 d3                	je     801579 <fork+0xc0>
  8015a6:	c1 ea 0c             	shr    $0xc,%edx
  8015a9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015b0:	a8 01                	test   $0x1,%al
  8015b2:	74 c5                	je     801579 <fork+0xc0>
  8015b4:	eb bc                	jmp    801572 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015b6:	83 ec 08             	sub    $0x8,%esp
  8015b9:	6a 02                	push   $0x2
  8015bb:	56                   	push   %esi
  8015bc:	e8 b1 fa ff ff       	call   801072 <sys_env_set_status>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 0a                	js     8015d2 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  8015c8:	89 f0                	mov    %esi,%eax
  8015ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5f                   	pop    %edi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  8015d2:	50                   	push   %eax
  8015d3:	68 4c 32 80 00       	push   $0x80324c
  8015d8:	68 ce 00 00 00       	push   $0xce
  8015dd:	68 e5 30 80 00       	push   $0x8030e5
  8015e2:	e8 39 ef ff ff       	call   800520 <_panic>

008015e7 <sfork>:

// Challenge!
int
sfork(void)
{
  8015e7:	f3 0f 1e fb          	endbr32 
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8015f1:	68 6e 31 80 00       	push   $0x80316e
  8015f6:	68 d7 00 00 00       	push   $0xd7
  8015fb:	68 e5 30 80 00       	push   $0x8030e5
  801600:	e8 1b ef ff ff       	call   800520 <_panic>

00801605 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801605:	f3 0f 1e fb          	endbr32 
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	05 00 00 00 30       	add    $0x30000000,%eax
  801614:	c1 e8 0c             	shr    $0xc,%eax
}
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801619:	f3 0f 1e fb          	endbr32 
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	e8 da ff ff ff       	call   801605 <fd2num>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	c1 e0 0c             	shl    $0xc,%eax
  801631:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801644:	89 c2                	mov    %eax,%edx
  801646:	c1 ea 16             	shr    $0x16,%edx
  801649:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801650:	f6 c2 01             	test   $0x1,%dl
  801653:	74 2d                	je     801682 <fd_alloc+0x4a>
  801655:	89 c2                	mov    %eax,%edx
  801657:	c1 ea 0c             	shr    $0xc,%edx
  80165a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801661:	f6 c2 01             	test   $0x1,%dl
  801664:	74 1c                	je     801682 <fd_alloc+0x4a>
  801666:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80166b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801670:	75 d2                	jne    801644 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80167b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801680:	eb 0a                	jmp    80168c <fd_alloc+0x54>
			*fd_store = fd;
  801682:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801685:	89 01                	mov    %eax,(%ecx)
			return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80168e:	f3 0f 1e fb          	endbr32 
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801698:	83 f8 1f             	cmp    $0x1f,%eax
  80169b:	77 30                	ja     8016cd <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80169d:	c1 e0 0c             	shl    $0xc,%eax
  8016a0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016a5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016ab:	f6 c2 01             	test   $0x1,%dl
  8016ae:	74 24                	je     8016d4 <fd_lookup+0x46>
  8016b0:	89 c2                	mov    %eax,%edx
  8016b2:	c1 ea 0c             	shr    $0xc,%edx
  8016b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016bc:	f6 c2 01             	test   $0x1,%dl
  8016bf:	74 1a                	je     8016db <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    
		return -E_INVAL;
  8016cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d2:	eb f7                	jmp    8016cb <fd_lookup+0x3d>
		return -E_INVAL;
  8016d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d9:	eb f0                	jmp    8016cb <fd_lookup+0x3d>
  8016db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e0:	eb e9                	jmp    8016cb <fd_lookup+0x3d>

008016e2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016e2:	f3 0f 1e fb          	endbr32 
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ef:	ba ec 32 80 00       	mov    $0x8032ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8016f4:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016f9:	39 08                	cmp    %ecx,(%eax)
  8016fb:	74 33                	je     801730 <dev_lookup+0x4e>
  8016fd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801700:	8b 02                	mov    (%edx),%eax
  801702:	85 c0                	test   %eax,%eax
  801704:	75 f3                	jne    8016f9 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801706:	a1 04 50 80 00       	mov    0x805004,%eax
  80170b:	8b 40 48             	mov    0x48(%eax),%eax
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	51                   	push   %ecx
  801712:	50                   	push   %eax
  801713:	68 70 32 80 00       	push   $0x803270
  801718:	e8 ea ee ff ff       	call   800607 <cprintf>
	*dev = 0;
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    
			*dev = devtab[i];
  801730:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801733:	89 01                	mov    %eax,(%ecx)
			return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	eb f2                	jmp    80172e <dev_lookup+0x4c>

0080173c <fd_close>:
{
  80173c:	f3 0f 1e fb          	endbr32 
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	57                   	push   %edi
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
  801746:	83 ec 28             	sub    $0x28,%esp
  801749:	8b 75 08             	mov    0x8(%ebp),%esi
  80174c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80174f:	56                   	push   %esi
  801750:	e8 b0 fe ff ff       	call   801605 <fd2num>
  801755:	83 c4 08             	add    $0x8,%esp
  801758:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80175b:	52                   	push   %edx
  80175c:	50                   	push   %eax
  80175d:	e8 2c ff ff ff       	call   80168e <fd_lookup>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	85 c0                	test   %eax,%eax
  801769:	78 05                	js     801770 <fd_close+0x34>
	    || fd != fd2)
  80176b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80176e:	74 16                	je     801786 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801770:	89 f8                	mov    %edi,%eax
  801772:	84 c0                	test   %al,%al
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	0f 44 d8             	cmove  %eax,%ebx
}
  80177c:	89 d8                	mov    %ebx,%eax
  80177e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801781:	5b                   	pop    %ebx
  801782:	5e                   	pop    %esi
  801783:	5f                   	pop    %edi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801786:	83 ec 08             	sub    $0x8,%esp
  801789:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80178c:	50                   	push   %eax
  80178d:	ff 36                	pushl  (%esi)
  80178f:	e8 4e ff ff ff       	call   8016e2 <dev_lookup>
  801794:	89 c3                	mov    %eax,%ebx
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 1a                	js     8017b7 <fd_close+0x7b>
		if (dev->dev_close)
  80179d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	74 0b                	je     8017b7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	56                   	push   %esi
  8017b0:	ff d0                	call   *%eax
  8017b2:	89 c3                	mov    %eax,%ebx
  8017b4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b7:	83 ec 08             	sub    $0x8,%esp
  8017ba:	56                   	push   %esi
  8017bb:	6a 00                	push   $0x0
  8017bd:	e8 89 f8 ff ff       	call   80104b <sys_page_unmap>
	return r;
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb b5                	jmp    80177c <fd_close+0x40>

008017c7 <close>:

int
close(int fdnum)
{
  8017c7:	f3 0f 1e fb          	endbr32 
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 b1 fe ff ff       	call   80168e <fd_lookup>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	79 02                	jns    8017e6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    
		return fd_close(fd, 1);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	6a 01                	push   $0x1
  8017eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ee:	e8 49 ff ff ff       	call   80173c <fd_close>
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	eb ec                	jmp    8017e4 <close+0x1d>

008017f8 <close_all>:

void
close_all(void)
{
  8017f8:	f3 0f 1e fb          	endbr32 
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801803:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801808:	83 ec 0c             	sub    $0xc,%esp
  80180b:	53                   	push   %ebx
  80180c:	e8 b6 ff ff ff       	call   8017c7 <close>
	for (i = 0; i < MAXFD; i++)
  801811:	83 c3 01             	add    $0x1,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	83 fb 20             	cmp    $0x20,%ebx
  80181a:	75 ec                	jne    801808 <close_all+0x10>
}
  80181c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801821:	f3 0f 1e fb          	endbr32 
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	57                   	push   %edi
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80182e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801831:	50                   	push   %eax
  801832:	ff 75 08             	pushl  0x8(%ebp)
  801835:	e8 54 fe ff ff       	call   80168e <fd_lookup>
  80183a:	89 c3                	mov    %eax,%ebx
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	85 c0                	test   %eax,%eax
  801841:	0f 88 81 00 00 00    	js     8018c8 <dup+0xa7>
		return r;
	close(newfdnum);
  801847:	83 ec 0c             	sub    $0xc,%esp
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	e8 75 ff ff ff       	call   8017c7 <close>

	newfd = INDEX2FD(newfdnum);
  801852:	8b 75 0c             	mov    0xc(%ebp),%esi
  801855:	c1 e6 0c             	shl    $0xc,%esi
  801858:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80185e:	83 c4 04             	add    $0x4,%esp
  801861:	ff 75 e4             	pushl  -0x1c(%ebp)
  801864:	e8 b0 fd ff ff       	call   801619 <fd2data>
  801869:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80186b:	89 34 24             	mov    %esi,(%esp)
  80186e:	e8 a6 fd ff ff       	call   801619 <fd2data>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	c1 e8 16             	shr    $0x16,%eax
  80187d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801884:	a8 01                	test   $0x1,%al
  801886:	74 11                	je     801899 <dup+0x78>
  801888:	89 d8                	mov    %ebx,%eax
  80188a:	c1 e8 0c             	shr    $0xc,%eax
  80188d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801894:	f6 c2 01             	test   $0x1,%dl
  801897:	75 39                	jne    8018d2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80189c:	89 d0                	mov    %edx,%eax
  80189e:	c1 e8 0c             	shr    $0xc,%eax
  8018a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8018b0:	50                   	push   %eax
  8018b1:	56                   	push   %esi
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 65 f7 ff ff       	call   801021 <sys_page_map>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 20             	add    $0x20,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 31                	js     8018f6 <dup+0xd5>
		goto err;

	return newfdnum;
  8018c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018c8:	89 d8                	mov    %ebx,%eax
  8018ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018cd:	5b                   	pop    %ebx
  8018ce:	5e                   	pop    %esi
  8018cf:	5f                   	pop    %edi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8018e1:	50                   	push   %eax
  8018e2:	57                   	push   %edi
  8018e3:	6a 00                	push   $0x0
  8018e5:	53                   	push   %ebx
  8018e6:	6a 00                	push   $0x0
  8018e8:	e8 34 f7 ff ff       	call   801021 <sys_page_map>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	83 c4 20             	add    $0x20,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	79 a3                	jns    801899 <dup+0x78>
	sys_page_unmap(0, newfd);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	56                   	push   %esi
  8018fa:	6a 00                	push   $0x0
  8018fc:	e8 4a f7 ff ff       	call   80104b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801901:	83 c4 08             	add    $0x8,%esp
  801904:	57                   	push   %edi
  801905:	6a 00                	push   $0x0
  801907:	e8 3f f7 ff ff       	call   80104b <sys_page_unmap>
	return r;
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	eb b7                	jmp    8018c8 <dup+0xa7>

00801911 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801911:	f3 0f 1e fb          	endbr32 
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	53                   	push   %ebx
  801919:	83 ec 1c             	sub    $0x1c,%esp
  80191c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80191f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	53                   	push   %ebx
  801924:	e8 65 fd ff ff       	call   80168e <fd_lookup>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 3f                	js     80196f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	ff 30                	pushl  (%eax)
  80193c:	e8 a1 fd ff ff       	call   8016e2 <dev_lookup>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 27                	js     80196f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801948:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194b:	8b 42 08             	mov    0x8(%edx),%eax
  80194e:	83 e0 03             	and    $0x3,%eax
  801951:	83 f8 01             	cmp    $0x1,%eax
  801954:	74 1e                	je     801974 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	8b 40 08             	mov    0x8(%eax),%eax
  80195c:	85 c0                	test   %eax,%eax
  80195e:	74 35                	je     801995 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	ff 75 10             	pushl  0x10(%ebp)
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	52                   	push   %edx
  80196a:	ff d0                	call   *%eax
  80196c:	83 c4 10             	add    $0x10,%esp
}
  80196f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801972:	c9                   	leave  
  801973:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801974:	a1 04 50 80 00       	mov    0x805004,%eax
  801979:	8b 40 48             	mov    0x48(%eax),%eax
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	53                   	push   %ebx
  801980:	50                   	push   %eax
  801981:	68 b1 32 80 00       	push   $0x8032b1
  801986:	e8 7c ec ff ff       	call   800607 <cprintf>
		return -E_INVAL;
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801993:	eb da                	jmp    80196f <read+0x5e>
		return -E_NOT_SUPP;
  801995:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199a:	eb d3                	jmp    80196f <read+0x5e>

0080199c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199c:	f3 0f 1e fb          	endbr32 
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	57                   	push   %edi
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 0c             	sub    $0xc,%esp
  8019a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b4:	eb 02                	jmp    8019b8 <readn+0x1c>
  8019b6:	01 c3                	add    %eax,%ebx
  8019b8:	39 f3                	cmp    %esi,%ebx
  8019ba:	73 21                	jae    8019dd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	89 f0                	mov    %esi,%eax
  8019c1:	29 d8                	sub    %ebx,%eax
  8019c3:	50                   	push   %eax
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	03 45 0c             	add    0xc(%ebp),%eax
  8019c9:	50                   	push   %eax
  8019ca:	57                   	push   %edi
  8019cb:	e8 41 ff ff ff       	call   801911 <read>
		if (m < 0)
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 04                	js     8019db <readn+0x3f>
			return m;
		if (m == 0)
  8019d7:	75 dd                	jne    8019b6 <readn+0x1a>
  8019d9:	eb 02                	jmp    8019dd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019db:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019dd:	89 d8                	mov    %ebx,%eax
  8019df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5e                   	pop    %esi
  8019e4:	5f                   	pop    %edi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e7:	f3 0f 1e fb          	endbr32 
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 1c             	sub    $0x1c,%esp
  8019f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	53                   	push   %ebx
  8019fa:	e8 8f fc ff ff       	call   80168e <fd_lookup>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 3a                	js     801a40 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	50                   	push   %eax
  801a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a10:	ff 30                	pushl  (%eax)
  801a12:	e8 cb fc ff ff       	call   8016e2 <dev_lookup>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 22                	js     801a40 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a25:	74 1e                	je     801a45 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2d:	85 d2                	test   %edx,%edx
  801a2f:	74 35                	je     801a66 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	ff 75 10             	pushl  0x10(%ebp)
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	50                   	push   %eax
  801a3b:	ff d2                	call   *%edx
  801a3d:	83 c4 10             	add    $0x10,%esp
}
  801a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a45:	a1 04 50 80 00       	mov    0x805004,%eax
  801a4a:	8b 40 48             	mov    0x48(%eax),%eax
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	53                   	push   %ebx
  801a51:	50                   	push   %eax
  801a52:	68 cd 32 80 00       	push   $0x8032cd
  801a57:	e8 ab eb ff ff       	call   800607 <cprintf>
		return -E_INVAL;
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a64:	eb da                	jmp    801a40 <write+0x59>
		return -E_NOT_SUPP;
  801a66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6b:	eb d3                	jmp    801a40 <write+0x59>

00801a6d <seek>:

int
seek(int fdnum, off_t offset)
{
  801a6d:	f3 0f 1e fb          	endbr32 
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7a:	50                   	push   %eax
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 0b fc ff ff       	call   80168e <fd_lookup>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 0e                	js     801a98 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a90:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a9a:	f3 0f 1e fb          	endbr32 
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 1c             	sub    $0x1c,%esp
  801aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aab:	50                   	push   %eax
  801aac:	53                   	push   %ebx
  801aad:	e8 dc fb ff ff       	call   80168e <fd_lookup>
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 37                	js     801af0 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abf:	50                   	push   %eax
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	ff 30                	pushl  (%eax)
  801ac5:	e8 18 fc ff ff       	call   8016e2 <dev_lookup>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 1f                	js     801af0 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad8:	74 1b                	je     801af5 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801add:	8b 52 18             	mov    0x18(%edx),%edx
  801ae0:	85 d2                	test   %edx,%edx
  801ae2:	74 32                	je     801b16 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	ff d2                	call   *%edx
  801aed:	83 c4 10             	add    $0x10,%esp
}
  801af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    
			thisenv->env_id, fdnum);
  801af5:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801afa:	8b 40 48             	mov    0x48(%eax),%eax
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	53                   	push   %ebx
  801b01:	50                   	push   %eax
  801b02:	68 90 32 80 00       	push   $0x803290
  801b07:	e8 fb ea ff ff       	call   800607 <cprintf>
		return -E_INVAL;
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b14:	eb da                	jmp    801af0 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801b16:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b1b:	eb d3                	jmp    801af0 <ftruncate+0x56>

00801b1d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b1d:	f3 0f 1e fb          	endbr32 
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
  801b25:	83 ec 1c             	sub    $0x1c,%esp
  801b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2e:	50                   	push   %eax
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	e8 57 fb ff ff       	call   80168e <fd_lookup>
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 4b                	js     801b89 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b44:	50                   	push   %eax
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	ff 30                	pushl  (%eax)
  801b4a:	e8 93 fb ff ff       	call   8016e2 <dev_lookup>
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 33                	js     801b89 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b59:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b5d:	74 2f                	je     801b8e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b5f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b62:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b69:	00 00 00 
	stat->st_isdir = 0;
  801b6c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b73:	00 00 00 
	stat->st_dev = dev;
  801b76:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b7c:	83 ec 08             	sub    $0x8,%esp
  801b7f:	53                   	push   %ebx
  801b80:	ff 75 f0             	pushl  -0x10(%ebp)
  801b83:	ff 50 14             	call   *0x14(%eax)
  801b86:	83 c4 10             	add    $0x10,%esp
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    
		return -E_NOT_SUPP;
  801b8e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b93:	eb f4                	jmp    801b89 <fstat+0x6c>

00801b95 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b95:	f3 0f 1e fb          	endbr32 
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	e8 3a 02 00 00       	call   801de5 <open>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 1b                	js     801bcf <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801bb4:	83 ec 08             	sub    $0x8,%esp
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	e8 5d ff ff ff       	call   801b1d <fstat>
  801bc0:	89 c6                	mov    %eax,%esi
	close(fd);
  801bc2:	89 1c 24             	mov    %ebx,(%esp)
  801bc5:	e8 fd fb ff ff       	call   8017c7 <close>
	return r;
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 f3                	mov    %esi,%ebx
}
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	89 c6                	mov    %eax,%esi
  801bdf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801be1:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801be8:	74 27                	je     801c11 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bea:	6a 07                	push   $0x7
  801bec:	68 00 60 80 00       	push   $0x806000
  801bf1:	56                   	push   %esi
  801bf2:	ff 35 00 50 80 00    	pushl  0x805000
  801bf8:	e8 f8 0c 00 00       	call   8028f5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bfd:	83 c4 0c             	add    $0xc,%esp
  801c00:	6a 00                	push   $0x0
  801c02:	53                   	push   %ebx
  801c03:	6a 00                	push   $0x0
  801c05:	e8 7e 0c 00 00       	call   802888 <ipc_recv>
}
  801c0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	6a 01                	push   $0x1
  801c16:	e8 32 0d 00 00       	call   80294d <ipc_find_env>
  801c1b:	a3 00 50 80 00       	mov    %eax,0x805000
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	eb c5                	jmp    801bea <fsipc+0x12>

00801c25 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c25:	f3 0f 1e fb          	endbr32 
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	8b 40 0c             	mov    0xc(%eax),%eax
  801c35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c42:	ba 00 00 00 00       	mov    $0x0,%edx
  801c47:	b8 02 00 00 00       	mov    $0x2,%eax
  801c4c:	e8 87 ff ff ff       	call   801bd8 <fsipc>
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <devfile_flush>:
{
  801c53:	f3 0f 1e fb          	endbr32 
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	8b 40 0c             	mov    0xc(%eax),%eax
  801c63:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c68:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6d:	b8 06 00 00 00       	mov    $0x6,%eax
  801c72:	e8 61 ff ff ff       	call   801bd8 <fsipc>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_stat>:
{
  801c79:	f3 0f 1e fb          	endbr32 
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9c:	e8 37 ff ff ff       	call   801bd8 <fsipc>
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 2c                	js     801cd1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	68 00 60 80 00       	push   $0x806000
  801cad:	53                   	push   %ebx
  801cae:	e8 be ee ff ff       	call   800b71 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cb3:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cbe:	a1 84 60 80 00       	mov    0x806084,%eax
  801cc3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cc9:	83 c4 10             	add    $0x10,%esp
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <devfile_write>:
{
  801cd6:	f3 0f 1e fb          	endbr32 
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cea:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cef:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801cf5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801cfb:	77 30                	ja     801d2d <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	53                   	push   %ebx
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	68 08 60 80 00       	push   $0x806008
  801d09:	e8 1b f0 ff ff       	call   800d29 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d13:	b8 04 00 00 00       	mov    $0x4,%eax
  801d18:	e8 bb fe ff ff       	call   801bd8 <fsipc>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 04                	js     801d28 <devfile_write+0x52>
	assert(r <= n);
  801d24:	39 d8                	cmp    %ebx,%eax
  801d26:	77 1e                	ja     801d46 <devfile_write+0x70>
}
  801d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801d2d:	68 fc 32 80 00       	push   $0x8032fc
  801d32:	68 29 33 80 00       	push   $0x803329
  801d37:	68 94 00 00 00       	push   $0x94
  801d3c:	68 3e 33 80 00       	push   $0x80333e
  801d41:	e8 da e7 ff ff       	call   800520 <_panic>
	assert(r <= n);
  801d46:	68 49 33 80 00       	push   $0x803349
  801d4b:	68 29 33 80 00       	push   $0x803329
  801d50:	68 98 00 00 00       	push   $0x98
  801d55:	68 3e 33 80 00       	push   $0x80333e
  801d5a:	e8 c1 e7 ff ff       	call   800520 <_panic>

00801d5f <devfile_read>:
{
  801d5f:	f3 0f 1e fb          	endbr32 
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d71:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d76:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d81:	b8 03 00 00 00       	mov    $0x3,%eax
  801d86:	e8 4d fe ff ff       	call   801bd8 <fsipc>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 1f                	js     801db0 <devfile_read+0x51>
	assert(r <= n);
  801d91:	39 f0                	cmp    %esi,%eax
  801d93:	77 24                	ja     801db9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801d95:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d9a:	7f 33                	jg     801dcf <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	50                   	push   %eax
  801da0:	68 00 60 80 00       	push   $0x806000
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	e8 7c ef ff ff       	call   800d29 <memmove>
	return r;
  801dad:	83 c4 10             	add    $0x10,%esp
}
  801db0:	89 d8                	mov    %ebx,%eax
  801db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    
	assert(r <= n);
  801db9:	68 49 33 80 00       	push   $0x803349
  801dbe:	68 29 33 80 00       	push   $0x803329
  801dc3:	6a 7c                	push   $0x7c
  801dc5:	68 3e 33 80 00       	push   $0x80333e
  801dca:	e8 51 e7 ff ff       	call   800520 <_panic>
	assert(r <= PGSIZE);
  801dcf:	68 50 33 80 00       	push   $0x803350
  801dd4:	68 29 33 80 00       	push   $0x803329
  801dd9:	6a 7d                	push   $0x7d
  801ddb:	68 3e 33 80 00       	push   $0x80333e
  801de0:	e8 3b e7 ff ff       	call   800520 <_panic>

00801de5 <open>:
{
  801de5:	f3 0f 1e fb          	endbr32 
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	56                   	push   %esi
  801ded:	53                   	push   %ebx
  801dee:	83 ec 1c             	sub    $0x1c,%esp
  801df1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801df4:	56                   	push   %esi
  801df5:	e8 34 ed ff ff       	call   800b2e <strlen>
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e02:	7f 6c                	jg     801e70 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	e8 28 f8 ff ff       	call   801638 <fd_alloc>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 3c                	js     801e55 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801e19:	83 ec 08             	sub    $0x8,%esp
  801e1c:	56                   	push   %esi
  801e1d:	68 00 60 80 00       	push   $0x806000
  801e22:	e8 4a ed ff ff       	call   800b71 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e32:	b8 01 00 00 00       	mov    $0x1,%eax
  801e37:	e8 9c fd ff ff       	call   801bd8 <fsipc>
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	85 c0                	test   %eax,%eax
  801e43:	78 19                	js     801e5e <open+0x79>
	return fd2num(fd);
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4b:	e8 b5 f7 ff ff       	call   801605 <fd2num>
  801e50:	89 c3                	mov    %eax,%ebx
  801e52:	83 c4 10             	add    $0x10,%esp
}
  801e55:	89 d8                	mov    %ebx,%eax
  801e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5e                   	pop    %esi
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    
		fd_close(fd, 0);
  801e5e:	83 ec 08             	sub    $0x8,%esp
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 f4             	pushl  -0xc(%ebp)
  801e66:	e8 d1 f8 ff ff       	call   80173c <fd_close>
		return r;
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	eb e5                	jmp    801e55 <open+0x70>
		return -E_BAD_PATH;
  801e70:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e75:	eb de                	jmp    801e55 <open+0x70>

00801e77 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	b8 08 00 00 00       	mov    $0x8,%eax
  801e8b:	e8 48 fd ff ff       	call   801bd8 <fsipc>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <copy_shared_pages>:
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	return 0;
}
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
  801e97:	c3                   	ret    

00801e98 <init_stack>:
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	57                   	push   %edi
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 2c             	sub    $0x2c,%esp
  801ea1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801ea4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801ea7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (argc = 0; argv[argc] != 0; argc++)
  801eaa:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801eaf:	be 00 00 00 00       	mov    $0x0,%esi
  801eb4:	89 d7                	mov    %edx,%edi
  801eb6:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801ebd:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	74 15                	je     801ed9 <init_stack+0x41>
		string_size += strlen(argv[argc]) + 1;
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	50                   	push   %eax
  801ec8:	e8 61 ec ff ff       	call   800b2e <strlen>
  801ecd:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801ed1:	83 c3 01             	add    $0x1,%ebx
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	eb dd                	jmp    801eb6 <init_stack+0x1e>
  801ed9:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  801edc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801edf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ee4:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ee6:	89 fa                	mov    %edi,%edx
  801ee8:	83 e2 fc             	and    $0xfffffffc,%edx
  801eeb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ef2:	29 c2                	sub    %eax,%edx
  801ef4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  801ef7:	8d 42 f8             	lea    -0x8(%edx),%eax
  801efa:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801eff:	0f 86 06 01 00 00    	jbe    80200b <init_stack+0x173>
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	6a 07                	push   $0x7
  801f0a:	68 00 00 40 00       	push   $0x400000
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 e3 f0 ff ff       	call   800ff9 <sys_page_alloc>
  801f16:	89 c6                	mov    %eax,%esi
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	0f 88 de 00 00 00    	js     802001 <init_stack+0x169>
	for (i = 0; i < argc; i++) {
  801f23:	be 00 00 00 00       	mov    $0x0,%esi
  801f28:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801f2b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801f2e:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  801f31:	7e 2f                	jle    801f62 <init_stack+0xca>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f33:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f39:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801f3c:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f45:	57                   	push   %edi
  801f46:	e8 26 ec ff ff       	call   800b71 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f4b:	83 c4 04             	add    $0x4,%esp
  801f4e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f51:	e8 d8 eb ff ff       	call   800b2e <strlen>
  801f56:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801f5a:	83 c6 01             	add    $0x1,%esi
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	eb cc                	jmp    801f2e <init_stack+0x96>
	argv_store[argc] = 0;
  801f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f65:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801f68:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801f6f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f75:	75 5f                	jne    801fd6 <init_stack+0x13e>
	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f7a:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801f80:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801f83:	89 d0                	mov    %edx,%eax
  801f85:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f88:	89 4a f8             	mov    %ecx,-0x8(%edx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f8b:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801f90:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801f93:	89 01                	mov    %eax,(%ecx)
	if ((r = sys_page_map(0,
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	6a 07                	push   $0x7
  801f9a:	68 00 d0 bf ee       	push   $0xeebfd000
  801f9f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801fa2:	68 00 00 40 00       	push   $0x400000
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 73 f0 ff ff       	call   801021 <sys_page_map>
  801fae:	89 c6                	mov    %eax,%esi
  801fb0:	83 c4 20             	add    $0x20,%esp
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 38                	js     801fef <init_stack+0x157>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	68 00 00 40 00       	push   $0x400000
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 85 f0 ff ff       	call   80104b <sys_page_unmap>
  801fc6:	89 c6                	mov    %eax,%esi
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 20                	js     801fef <init_stack+0x157>
	return 0;
  801fcf:	be 00 00 00 00       	mov    $0x0,%esi
  801fd4:	eb 2b                	jmp    802001 <init_stack+0x169>
	assert(string_store == (char *) UTEMP + PGSIZE);
  801fd6:	68 5c 33 80 00       	push   $0x80335c
  801fdb:	68 29 33 80 00       	push   $0x803329
  801fe0:	68 fc 00 00 00       	push   $0xfc
  801fe5:	68 84 33 80 00       	push   $0x803384
  801fea:	e8 31 e5 ff ff       	call   800520 <_panic>
	sys_page_unmap(0, UTEMP);
  801fef:	83 ec 08             	sub    $0x8,%esp
  801ff2:	68 00 00 40 00       	push   $0x400000
  801ff7:	6a 00                	push   $0x0
  801ff9:	e8 4d f0 ff ff       	call   80104b <sys_page_unmap>
	return r;
  801ffe:	83 c4 10             	add    $0x10,%esp
}
  802001:	89 f0                	mov    %esi,%eax
  802003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5f                   	pop    %edi
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    
		return -E_NO_MEM;
  80200b:	be fc ff ff ff       	mov    $0xfffffffc,%esi
  802010:	eb ef                	jmp    802001 <init_stack+0x169>

00802012 <map_segment>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80201e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  802021:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  802024:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((i = PGOFF(va))) {
  802027:	89 d0                	mov    %edx,%eax
  802029:	25 ff 0f 00 00       	and    $0xfff,%eax
  80202e:	74 0f                	je     80203f <map_segment+0x2d>
		va -= i;
  802030:	29 c2                	sub    %eax,%edx
  802032:	89 55 e0             	mov    %edx,-0x20(%ebp)
		memsz += i;
  802035:	01 c1                	add    %eax,%ecx
  802037:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  80203a:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  80203c:	29 45 10             	sub    %eax,0x10(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80203f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802044:	e9 99 00 00 00       	jmp    8020e2 <map_segment+0xd0>
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  802049:	83 ec 04             	sub    $0x4,%esp
  80204c:	6a 07                	push   $0x7
  80204e:	68 00 00 40 00       	push   $0x400000
  802053:	6a 00                	push   $0x0
  802055:	e8 9f ef ff ff       	call   800ff9 <sys_page_alloc>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	85 c0                	test   %eax,%eax
  80205f:	0f 88 c1 00 00 00    	js     802126 <map_segment+0x114>
			if ((r = seek(fd, fileoffset + i)) < 0)
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	89 f0                	mov    %esi,%eax
  80206a:	03 45 10             	add    0x10(%ebp),%eax
  80206d:	50                   	push   %eax
  80206e:	ff 75 08             	pushl  0x8(%ebp)
  802071:	e8 f7 f9 ff ff       	call   801a6d <seek>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 88 a5 00 00 00    	js     802126 <map_segment+0x114>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	89 f8                	mov    %edi,%eax
  802086:	29 f0                	sub    %esi,%eax
  802088:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80208d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802092:	0f 47 c2             	cmova  %edx,%eax
  802095:	50                   	push   %eax
  802096:	68 00 00 40 00       	push   $0x400000
  80209b:	ff 75 08             	pushl  0x8(%ebp)
  80209e:	e8 f9 f8 ff ff       	call   80199c <readn>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 7c                	js     802126 <map_segment+0x114>
			if ((r = sys_page_map(
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	ff 75 14             	pushl  0x14(%ebp)
  8020b0:	03 75 e0             	add    -0x20(%ebp),%esi
  8020b3:	56                   	push   %esi
  8020b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8020b7:	68 00 00 40 00       	push   $0x400000
  8020bc:	6a 00                	push   $0x0
  8020be:	e8 5e ef ff ff       	call   801021 <sys_page_map>
  8020c3:	83 c4 20             	add    $0x20,%esp
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 42                	js     80210c <map_segment+0xfa>
			sys_page_unmap(0, UTEMP);
  8020ca:	83 ec 08             	sub    $0x8,%esp
  8020cd:	68 00 00 40 00       	push   $0x400000
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 72 ef ff ff       	call   80104b <sys_page_unmap>
  8020d9:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8020dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020e2:	89 de                	mov    %ebx,%esi
  8020e4:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  8020e7:	76 38                	jbe    802121 <map_segment+0x10f>
		if (i >= filesz) {
  8020e9:	39 df                	cmp    %ebx,%edi
  8020eb:	0f 87 58 ff ff ff    	ja     802049 <map_segment+0x37>
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	ff 75 14             	pushl  0x14(%ebp)
  8020f7:	03 75 e0             	add    -0x20(%ebp),%esi
  8020fa:	56                   	push   %esi
  8020fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8020fe:	e8 f6 ee ff ff       	call   800ff9 <sys_page_alloc>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	79 d2                	jns    8020dc <map_segment+0xca>
  80210a:	eb 1a                	jmp    802126 <map_segment+0x114>
				panic("spawn: sys_page_map data: %e", r);
  80210c:	50                   	push   %eax
  80210d:	68 90 33 80 00       	push   $0x803390
  802112:	68 3a 01 00 00       	push   $0x13a
  802117:	68 84 33 80 00       	push   $0x803384
  80211c:	e8 ff e3 ff ff       	call   800520 <_panic>
	return 0;
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802129:	5b                   	pop    %ebx
  80212a:	5e                   	pop    %esi
  80212b:	5f                   	pop    %edi
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <spawn>:
{
  80212e:	f3 0f 1e fb          	endbr32 
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	57                   	push   %edi
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	81 ec 74 02 00 00    	sub    $0x274,%esp
	if ((r = open(prog, O_RDONLY)) < 0)
  80213e:	6a 00                	push   $0x0
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	e8 9d fc ff ff       	call   801de5 <open>
  802148:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	0f 88 0b 02 00 00    	js     802364 <spawn+0x236>
  802159:	89 c7                	mov    %eax,%edi
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 00 02 00 00       	push   $0x200
  802163:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802169:	50                   	push   %eax
  80216a:	57                   	push   %edi
  80216b:	e8 2c f8 ff ff       	call   80199c <readn>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	3d 00 02 00 00       	cmp    $0x200,%eax
  802178:	0f 85 85 00 00 00    	jne    802203 <spawn+0xd5>
  80217e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802185:	45 4c 46 
  802188:	75 79                	jne    802203 <spawn+0xd5>
  80218a:	b8 07 00 00 00       	mov    $0x7,%eax
  80218f:	cd 30                	int    $0x30
  802191:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802197:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	if ((r = sys_exofork()) < 0)
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	0f 88 b1 01 00 00    	js     802358 <spawn+0x22a>
	child_tf = envs[ENVX(child)].env_tf;
  8021a7:	89 c6                	mov    %eax,%esi
  8021a9:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8021af:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8021b2:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8021b8:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8021be:	b9 11 00 00 00       	mov    $0x11,%ecx
  8021c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8021c5:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8021cb:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  8021d1:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	89 d8                	mov    %ebx,%eax
  8021dc:	e8 b7 fc ff ff       	call   801e98 <init_stack>
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	0f 88 89 01 00 00    	js     802372 <spawn+0x244>
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  8021e9:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8021ef:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021f6:	be 00 00 00 00       	mov    $0x0,%esi
  8021fb:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802201:	eb 3e                	jmp    802241 <spawn+0x113>
		close(fd);
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80220c:	e8 b6 f5 ff ff       	call   8017c7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802211:	83 c4 0c             	add    $0xc,%esp
  802214:	68 7f 45 4c 46       	push   $0x464c457f
  802219:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80221f:	68 ad 33 80 00       	push   $0x8033ad
  802224:	e8 de e3 ff ff       	call   800607 <cprintf>
		return -E_NOT_EXEC;
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802233:	ff ff ff 
  802236:	e9 29 01 00 00       	jmp    802364 <spawn+0x236>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80223b:	83 c6 01             	add    $0x1,%esi
  80223e:	83 c3 20             	add    $0x20,%ebx
  802241:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802248:	39 f0                	cmp    %esi,%eax
  80224a:	7e 62                	jle    8022ae <spawn+0x180>
		if (ph->p_type != ELF_PROG_LOAD)
  80224c:	83 3b 01             	cmpl   $0x1,(%ebx)
  80224f:	75 ea                	jne    80223b <spawn+0x10d>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802251:	8b 43 18             	mov    0x18(%ebx),%eax
  802254:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802257:	83 f8 01             	cmp    $0x1,%eax
  80225a:	19 c0                	sbb    %eax,%eax
  80225c:	83 e0 fe             	and    $0xfffffffe,%eax
  80225f:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  802262:	8b 4b 14             	mov    0x14(%ebx),%ecx
  802265:	8b 53 08             	mov    0x8(%ebx),%edx
  802268:	50                   	push   %eax
  802269:	ff 73 04             	pushl  0x4(%ebx)
  80226c:	ff 73 10             	pushl  0x10(%ebx)
  80226f:	57                   	push   %edi
  802270:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802276:	e8 97 fd ff ff       	call   802012 <map_segment>
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	85 c0                	test   %eax,%eax
  802280:	79 b9                	jns    80223b <spawn+0x10d>
  802282:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80228d:	e8 ee ec ff ff       	call   800f80 <sys_env_destroy>
	close(fd);
  802292:	83 c4 04             	add    $0x4,%esp
  802295:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80229b:	e8 27 f5 ff ff       	call   8017c7 <close>
	return r;
  8022a0:	83 c4 10             	add    $0x10,%esp
		if ((r = map_segment(child,
  8022a3:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
	return r;
  8022a9:	e9 b6 00 00 00       	jmp    802364 <spawn+0x236>
	close(fd);
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022b7:	e8 0b f5 ff ff       	call   8017c7 <close>
	if ((r = copy_shared_pages(child)) < 0)
  8022bc:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8022c2:	e8 cb fb ff ff       	call   801e92 <copy_shared_pages>
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	78 4b                	js     802319 <spawn+0x1eb>
	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  8022ce:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8022d5:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022d8:	83 ec 08             	sub    $0x8,%esp
  8022db:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022e1:	50                   	push   %eax
  8022e2:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8022e8:	e8 ac ed ff ff       	call   801099 <sys_env_set_trapframe>
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	78 3a                	js     80232e <spawn+0x200>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022f4:	83 ec 08             	sub    $0x8,%esp
  8022f7:	6a 02                	push   $0x2
  8022f9:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8022ff:	e8 6e ed ff ff       	call   801072 <sys_env_set_status>
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	85 c0                	test   %eax,%eax
  802309:	78 38                	js     802343 <spawn+0x215>
	return child;
  80230b:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802311:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802317:	eb 4b                	jmp    802364 <spawn+0x236>
		panic("copy_shared_pages: %e", r);
  802319:	50                   	push   %eax
  80231a:	68 c7 33 80 00       	push   $0x8033c7
  80231f:	68 8c 00 00 00       	push   $0x8c
  802324:	68 84 33 80 00       	push   $0x803384
  802329:	e8 f2 e1 ff ff       	call   800520 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  80232e:	50                   	push   %eax
  80232f:	68 dd 33 80 00       	push   $0x8033dd
  802334:	68 90 00 00 00       	push   $0x90
  802339:	68 84 33 80 00       	push   $0x803384
  80233e:	e8 dd e1 ff ff       	call   800520 <_panic>
		panic("sys_env_set_status: %e", r);
  802343:	50                   	push   %eax
  802344:	68 f7 33 80 00       	push   $0x8033f7
  802349:	68 93 00 00 00       	push   $0x93
  80234e:	68 84 33 80 00       	push   $0x803384
  802353:	e8 c8 e1 ff ff       	call   800520 <_panic>
		return r;
  802358:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80235e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802364:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80236a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5f                   	pop    %edi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    
		return r;
  802372:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802378:	eb ea                	jmp    802364 <spawn+0x236>

0080237a <spawnl>:
{
  80237a:	f3 0f 1e fb          	endbr32 
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802387:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  80238f:	8d 4a 04             	lea    0x4(%edx),%ecx
  802392:	83 3a 00             	cmpl   $0x0,(%edx)
  802395:	74 07                	je     80239e <spawnl+0x24>
		argc++;
  802397:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  80239a:	89 ca                	mov    %ecx,%edx
  80239c:	eb f1                	jmp    80238f <spawnl+0x15>
	const char *argv[argc + 2];
  80239e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	83 e1 f0             	and    $0xfffffff0,%ecx
  8023aa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8023b0:	89 e6                	mov    %esp,%esi
  8023b2:	29 d6                	sub    %edx,%esi
  8023b4:	89 f2                	mov    %esi,%edx
  8023b6:	39 d4                	cmp    %edx,%esp
  8023b8:	74 10                	je     8023ca <spawnl+0x50>
  8023ba:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8023c0:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8023c7:	00 
  8023c8:	eb ec                	jmp    8023b6 <spawnl+0x3c>
  8023ca:	89 ca                	mov    %ecx,%edx
  8023cc:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8023d2:	29 d4                	sub    %edx,%esp
  8023d4:	85 d2                	test   %edx,%edx
  8023d6:	74 05                	je     8023dd <spawnl+0x63>
  8023d8:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8023dd:	8d 74 24 03          	lea    0x3(%esp),%esi
  8023e1:	89 f2                	mov    %esi,%edx
  8023e3:	c1 ea 02             	shr    $0x2,%edx
  8023e6:	83 e6 fc             	and    $0xfffffffc,%esi
  8023e9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8023eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ee:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  8023f5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8023fc:	00 
	va_start(vl, arg0);
  8023fd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802400:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	eb 0b                	jmp    802414 <spawnl+0x9a>
		argv[i + 1] = va_arg(vl, const char *);
  802409:	83 c0 01             	add    $0x1,%eax
  80240c:	8b 39                	mov    (%ecx),%edi
  80240e:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802411:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  802414:	39 d0                	cmp    %edx,%eax
  802416:	75 f1                	jne    802409 <spawnl+0x8f>
	return spawn(prog, argv);
  802418:	83 ec 08             	sub    $0x8,%esp
  80241b:	56                   	push   %esi
  80241c:	ff 75 08             	pushl  0x8(%ebp)
  80241f:	e8 0a fd ff ff       	call   80212e <spawn>
}
  802424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    

0080242c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80242c:	f3 0f 1e fb          	endbr32 
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	56                   	push   %esi
  802434:	53                   	push   %ebx
  802435:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802438:	83 ec 0c             	sub    $0xc,%esp
  80243b:	ff 75 08             	pushl  0x8(%ebp)
  80243e:	e8 d6 f1 ff ff       	call   801619 <fd2data>
  802443:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802445:	83 c4 08             	add    $0x8,%esp
  802448:	68 0e 34 80 00       	push   $0x80340e
  80244d:	53                   	push   %ebx
  80244e:	e8 1e e7 ff ff       	call   800b71 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802453:	8b 46 04             	mov    0x4(%esi),%eax
  802456:	2b 06                	sub    (%esi),%eax
  802458:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80245e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802465:	00 00 00 
	stat->st_dev = &devpipe;
  802468:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80246f:	40 80 00 
	return 0;
}
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80247a:	5b                   	pop    %ebx
  80247b:	5e                   	pop    %esi
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    

0080247e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247e:	f3 0f 1e fb          	endbr32 
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	53                   	push   %ebx
  802486:	83 ec 0c             	sub    $0xc,%esp
  802489:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80248c:	53                   	push   %ebx
  80248d:	6a 00                	push   $0x0
  80248f:	e8 b7 eb ff ff       	call   80104b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802494:	89 1c 24             	mov    %ebx,(%esp)
  802497:	e8 7d f1 ff ff       	call   801619 <fd2data>
  80249c:	83 c4 08             	add    $0x8,%esp
  80249f:	50                   	push   %eax
  8024a0:	6a 00                	push   $0x0
  8024a2:	e8 a4 eb ff ff       	call   80104b <sys_page_unmap>
}
  8024a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <_pipeisclosed>:
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	57                   	push   %edi
  8024b0:	56                   	push   %esi
  8024b1:	53                   	push   %ebx
  8024b2:	83 ec 1c             	sub    $0x1c,%esp
  8024b5:	89 c7                	mov    %eax,%edi
  8024b7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024b9:	a1 04 50 80 00       	mov    0x805004,%eax
  8024be:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	57                   	push   %edi
  8024c5:	e8 c0 04 00 00       	call   80298a <pageref>
  8024ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024cd:	89 34 24             	mov    %esi,(%esp)
  8024d0:	e8 b5 04 00 00       	call   80298a <pageref>
		nn = thisenv->env_runs;
  8024d5:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8024db:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024de:	83 c4 10             	add    $0x10,%esp
  8024e1:	39 cb                	cmp    %ecx,%ebx
  8024e3:	74 1b                	je     802500 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024e8:	75 cf                	jne    8024b9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024ea:	8b 42 58             	mov    0x58(%edx),%eax
  8024ed:	6a 01                	push   $0x1
  8024ef:	50                   	push   %eax
  8024f0:	53                   	push   %ebx
  8024f1:	68 15 34 80 00       	push   $0x803415
  8024f6:	e8 0c e1 ff ff       	call   800607 <cprintf>
  8024fb:	83 c4 10             	add    $0x10,%esp
  8024fe:	eb b9                	jmp    8024b9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802500:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802503:	0f 94 c0             	sete   %al
  802506:	0f b6 c0             	movzbl %al,%eax
}
  802509:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    

00802511 <devpipe_write>:
{
  802511:	f3 0f 1e fb          	endbr32 
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	57                   	push   %edi
  802519:	56                   	push   %esi
  80251a:	53                   	push   %ebx
  80251b:	83 ec 28             	sub    $0x28,%esp
  80251e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802521:	56                   	push   %esi
  802522:	e8 f2 f0 ff ff       	call   801619 <fd2data>
  802527:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802529:	83 c4 10             	add    $0x10,%esp
  80252c:	bf 00 00 00 00       	mov    $0x0,%edi
  802531:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802534:	74 4f                	je     802585 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802536:	8b 43 04             	mov    0x4(%ebx),%eax
  802539:	8b 0b                	mov    (%ebx),%ecx
  80253b:	8d 51 20             	lea    0x20(%ecx),%edx
  80253e:	39 d0                	cmp    %edx,%eax
  802540:	72 14                	jb     802556 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802542:	89 da                	mov    %ebx,%edx
  802544:	89 f0                	mov    %esi,%eax
  802546:	e8 61 ff ff ff       	call   8024ac <_pipeisclosed>
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 3b                	jne    80258a <devpipe_write+0x79>
			sys_yield();
  80254f:	e8 7a ea ff ff       	call   800fce <sys_yield>
  802554:	eb e0                	jmp    802536 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802559:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80255d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802560:	89 c2                	mov    %eax,%edx
  802562:	c1 fa 1f             	sar    $0x1f,%edx
  802565:	89 d1                	mov    %edx,%ecx
  802567:	c1 e9 1b             	shr    $0x1b,%ecx
  80256a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80256d:	83 e2 1f             	and    $0x1f,%edx
  802570:	29 ca                	sub    %ecx,%edx
  802572:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802576:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80257a:	83 c0 01             	add    $0x1,%eax
  80257d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802580:	83 c7 01             	add    $0x1,%edi
  802583:	eb ac                	jmp    802531 <devpipe_write+0x20>
	return i;
  802585:	8b 45 10             	mov    0x10(%ebp),%eax
  802588:	eb 05                	jmp    80258f <devpipe_write+0x7e>
				return 0;
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802592:	5b                   	pop    %ebx
  802593:	5e                   	pop    %esi
  802594:	5f                   	pop    %edi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <devpipe_read>:
{
  802597:	f3 0f 1e fb          	endbr32 
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	57                   	push   %edi
  80259f:	56                   	push   %esi
  8025a0:	53                   	push   %ebx
  8025a1:	83 ec 18             	sub    $0x18,%esp
  8025a4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025a7:	57                   	push   %edi
  8025a8:	e8 6c f0 ff ff       	call   801619 <fd2data>
  8025ad:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025af:	83 c4 10             	add    $0x10,%esp
  8025b2:	be 00 00 00 00       	mov    $0x0,%esi
  8025b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ba:	75 14                	jne    8025d0 <devpipe_read+0x39>
	return i;
  8025bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bf:	eb 02                	jmp    8025c3 <devpipe_read+0x2c>
				return i;
  8025c1:	89 f0                	mov    %esi,%eax
}
  8025c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5f                   	pop    %edi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    
			sys_yield();
  8025cb:	e8 fe e9 ff ff       	call   800fce <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025d0:	8b 03                	mov    (%ebx),%eax
  8025d2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025d5:	75 18                	jne    8025ef <devpipe_read+0x58>
			if (i > 0)
  8025d7:	85 f6                	test   %esi,%esi
  8025d9:	75 e6                	jne    8025c1 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8025db:	89 da                	mov    %ebx,%edx
  8025dd:	89 f8                	mov    %edi,%eax
  8025df:	e8 c8 fe ff ff       	call   8024ac <_pipeisclosed>
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 e3                	je     8025cb <devpipe_read+0x34>
				return 0;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ed:	eb d4                	jmp    8025c3 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025ef:	99                   	cltd   
  8025f0:	c1 ea 1b             	shr    $0x1b,%edx
  8025f3:	01 d0                	add    %edx,%eax
  8025f5:	83 e0 1f             	and    $0x1f,%eax
  8025f8:	29 d0                	sub    %edx,%eax
  8025fa:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802602:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802605:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802608:	83 c6 01             	add    $0x1,%esi
  80260b:	eb aa                	jmp    8025b7 <devpipe_read+0x20>

0080260d <pipe>:
{
  80260d:	f3 0f 1e fb          	endbr32 
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	56                   	push   %esi
  802615:	53                   	push   %ebx
  802616:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80261c:	50                   	push   %eax
  80261d:	e8 16 f0 ff ff       	call   801638 <fd_alloc>
  802622:	89 c3                	mov    %eax,%ebx
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 88 23 01 00 00    	js     802752 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 07 04 00 00       	push   $0x407
  802637:	ff 75 f4             	pushl  -0xc(%ebp)
  80263a:	6a 00                	push   $0x0
  80263c:	e8 b8 e9 ff ff       	call   800ff9 <sys_page_alloc>
  802641:	89 c3                	mov    %eax,%ebx
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	85 c0                	test   %eax,%eax
  802648:	0f 88 04 01 00 00    	js     802752 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802654:	50                   	push   %eax
  802655:	e8 de ef ff ff       	call   801638 <fd_alloc>
  80265a:	89 c3                	mov    %eax,%ebx
  80265c:	83 c4 10             	add    $0x10,%esp
  80265f:	85 c0                	test   %eax,%eax
  802661:	0f 88 db 00 00 00    	js     802742 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 07 04 00 00       	push   $0x407
  80266f:	ff 75 f0             	pushl  -0x10(%ebp)
  802672:	6a 00                	push   $0x0
  802674:	e8 80 e9 ff ff       	call   800ff9 <sys_page_alloc>
  802679:	89 c3                	mov    %eax,%ebx
  80267b:	83 c4 10             	add    $0x10,%esp
  80267e:	85 c0                	test   %eax,%eax
  802680:	0f 88 bc 00 00 00    	js     802742 <pipe+0x135>
	va = fd2data(fd0);
  802686:	83 ec 0c             	sub    $0xc,%esp
  802689:	ff 75 f4             	pushl  -0xc(%ebp)
  80268c:	e8 88 ef ff ff       	call   801619 <fd2data>
  802691:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802693:	83 c4 0c             	add    $0xc,%esp
  802696:	68 07 04 00 00       	push   $0x407
  80269b:	50                   	push   %eax
  80269c:	6a 00                	push   $0x0
  80269e:	e8 56 e9 ff ff       	call   800ff9 <sys_page_alloc>
  8026a3:	89 c3                	mov    %eax,%ebx
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	0f 88 82 00 00 00    	js     802732 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b6:	e8 5e ef ff ff       	call   801619 <fd2data>
  8026bb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026c2:	50                   	push   %eax
  8026c3:	6a 00                	push   $0x0
  8026c5:	56                   	push   %esi
  8026c6:	6a 00                	push   $0x0
  8026c8:	e8 54 e9 ff ff       	call   801021 <sys_page_map>
  8026cd:	89 c3                	mov    %eax,%ebx
  8026cf:	83 c4 20             	add    $0x20,%esp
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	78 4e                	js     802724 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8026d6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ed:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026f9:	83 ec 0c             	sub    $0xc,%esp
  8026fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ff:	e8 01 ef ff ff       	call   801605 <fd2num>
  802704:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802707:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802709:	83 c4 04             	add    $0x4,%esp
  80270c:	ff 75 f0             	pushl  -0x10(%ebp)
  80270f:	e8 f1 ee ff ff       	call   801605 <fd2num>
  802714:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802717:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80271a:	83 c4 10             	add    $0x10,%esp
  80271d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802722:	eb 2e                	jmp    802752 <pipe+0x145>
	sys_page_unmap(0, va);
  802724:	83 ec 08             	sub    $0x8,%esp
  802727:	56                   	push   %esi
  802728:	6a 00                	push   $0x0
  80272a:	e8 1c e9 ff ff       	call   80104b <sys_page_unmap>
  80272f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802732:	83 ec 08             	sub    $0x8,%esp
  802735:	ff 75 f0             	pushl  -0x10(%ebp)
  802738:	6a 00                	push   $0x0
  80273a:	e8 0c e9 ff ff       	call   80104b <sys_page_unmap>
  80273f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802742:	83 ec 08             	sub    $0x8,%esp
  802745:	ff 75 f4             	pushl  -0xc(%ebp)
  802748:	6a 00                	push   $0x0
  80274a:	e8 fc e8 ff ff       	call   80104b <sys_page_unmap>
  80274f:	83 c4 10             	add    $0x10,%esp
}
  802752:	89 d8                	mov    %ebx,%eax
  802754:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802757:	5b                   	pop    %ebx
  802758:	5e                   	pop    %esi
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    

0080275b <pipeisclosed>:
{
  80275b:	f3 0f 1e fb          	endbr32 
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802768:	50                   	push   %eax
  802769:	ff 75 08             	pushl  0x8(%ebp)
  80276c:	e8 1d ef ff ff       	call   80168e <fd_lookup>
  802771:	83 c4 10             	add    $0x10,%esp
  802774:	85 c0                	test   %eax,%eax
  802776:	78 18                	js     802790 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802778:	83 ec 0c             	sub    $0xc,%esp
  80277b:	ff 75 f4             	pushl  -0xc(%ebp)
  80277e:	e8 96 ee ff ff       	call   801619 <fd2data>
  802783:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	e8 1f fd ff ff       	call   8024ac <_pipeisclosed>
  80278d:	83 c4 10             	add    $0x10,%esp
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802792:	f3 0f 1e fb          	endbr32 
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	56                   	push   %esi
  80279a:	53                   	push   %ebx
  80279b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80279e:	85 f6                	test   %esi,%esi
  8027a0:	74 13                	je     8027b5 <wait+0x23>
	e = &envs[ENVX(envid)];
  8027a2:	89 f3                	mov    %esi,%ebx
  8027a4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027aa:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8027ad:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8027b3:	eb 1b                	jmp    8027d0 <wait+0x3e>
	assert(envid != 0);
  8027b5:	68 2d 34 80 00       	push   $0x80342d
  8027ba:	68 29 33 80 00       	push   $0x803329
  8027bf:	6a 09                	push   $0x9
  8027c1:	68 38 34 80 00       	push   $0x803438
  8027c6:	e8 55 dd ff ff       	call   800520 <_panic>
		sys_yield();
  8027cb:	e8 fe e7 ff ff       	call   800fce <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027d0:	8b 43 48             	mov    0x48(%ebx),%eax
  8027d3:	39 f0                	cmp    %esi,%eax
  8027d5:	75 07                	jne    8027de <wait+0x4c>
  8027d7:	8b 43 54             	mov    0x54(%ebx),%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	75 ed                	jne    8027cb <wait+0x39>
}
  8027de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027e1:	5b                   	pop    %ebx
  8027e2:	5e                   	pop    %esi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    

008027e5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e5:	f3 0f 1e fb          	endbr32 
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027ef:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8027f6:	74 0a                	je     802802 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802800:	c9                   	leave  
  802801:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  802802:	a1 04 50 80 00       	mov    0x805004,%eax
  802807:	8b 40 48             	mov    0x48(%eax),%eax
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	6a 07                	push   $0x7
  80280f:	68 00 f0 bf ee       	push   $0xeebff000
  802814:	50                   	push   %eax
  802815:	e8 df e7 ff ff       	call   800ff9 <sys_page_alloc>
		if (r!= 0)
  80281a:	83 c4 10             	add    $0x10,%esp
  80281d:	85 c0                	test   %eax,%eax
  80281f:	75 2f                	jne    802850 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802821:	a1 04 50 80 00       	mov    0x805004,%eax
  802826:	8b 40 48             	mov    0x48(%eax),%eax
  802829:	83 ec 08             	sub    $0x8,%esp
  80282c:	68 62 28 80 00       	push   $0x802862
  802831:	50                   	push   %eax
  802832:	e8 89 e8 ff ff       	call   8010c0 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  802837:	83 c4 10             	add    $0x10,%esp
  80283a:	85 c0                	test   %eax,%eax
  80283c:	74 ba                	je     8027f8 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  80283e:	50                   	push   %eax
  80283f:	68 43 34 80 00       	push   $0x803443
  802844:	6a 26                	push   $0x26
  802846:	68 5b 34 80 00       	push   $0x80345b
  80284b:	e8 d0 dc ff ff       	call   800520 <_panic>
			panic("set_pgfault_handler: %e", r);
  802850:	50                   	push   %eax
  802851:	68 43 34 80 00       	push   $0x803443
  802856:	6a 22                	push   $0x22
  802858:	68 5b 34 80 00       	push   $0x80345b
  80285d:	e8 be dc ff ff       	call   800520 <_panic>

00802862 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802862:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802863:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802868:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80286a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  80286d:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  802871:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  802874:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  802878:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  80287c:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80287e:	83 c4 08             	add    $0x8,%esp
	popal
  802881:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  802882:	83 c4 04             	add    $0x4,%esp
	popfl
  802885:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  802886:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802887:	c3                   	ret    

00802888 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802888:	f3 0f 1e fb          	endbr32 
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	56                   	push   %esi
  802890:	53                   	push   %ebx
  802891:	8b 75 08             	mov    0x8(%ebp),%esi
  802894:	8b 45 0c             	mov    0xc(%ebp),%eax
  802897:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  80289a:	85 c0                	test   %eax,%eax
  80289c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028a1:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8028a4:	83 ec 0c             	sub    $0xc,%esp
  8028a7:	50                   	push   %eax
  8028a8:	e8 63 e8 ff ff       	call   801110 <sys_ipc_recv>
	if (r < 0) {
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	78 2b                	js     8028df <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8028b4:	85 f6                	test   %esi,%esi
  8028b6:	74 0a                	je     8028c2 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8028b8:	a1 04 50 80 00       	mov    0x805004,%eax
  8028bd:	8b 40 74             	mov    0x74(%eax),%eax
  8028c0:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8028c2:	85 db                	test   %ebx,%ebx
  8028c4:	74 0a                	je     8028d0 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8028c6:	a1 04 50 80 00       	mov    0x805004,%eax
  8028cb:	8b 40 78             	mov    0x78(%eax),%eax
  8028ce:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8028d0:	a1 04 50 80 00       	mov    0x805004,%eax
  8028d5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028db:	5b                   	pop    %ebx
  8028dc:	5e                   	pop    %esi
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    
		if (from_env_store) {
  8028df:	85 f6                	test   %esi,%esi
  8028e1:	74 06                	je     8028e9 <ipc_recv+0x61>
			*from_env_store = 0;
  8028e3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8028e9:	85 db                	test   %ebx,%ebx
  8028eb:	74 eb                	je     8028d8 <ipc_recv+0x50>
			*perm_store = 0;
  8028ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028f3:	eb e3                	jmp    8028d8 <ipc_recv+0x50>

008028f5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028f5:	f3 0f 1e fb          	endbr32 
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	57                   	push   %edi
  8028fd:	56                   	push   %esi
  8028fe:	53                   	push   %ebx
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	8b 7d 08             	mov    0x8(%ebp),%edi
  802905:	8b 75 0c             	mov    0xc(%ebp),%esi
  802908:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  80290b:	85 db                	test   %ebx,%ebx
  80290d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802912:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802915:	ff 75 14             	pushl  0x14(%ebp)
  802918:	53                   	push   %ebx
  802919:	56                   	push   %esi
  80291a:	57                   	push   %edi
  80291b:	e8 c7 e7 ff ff       	call   8010e7 <sys_ipc_try_send>
  802920:	83 c4 10             	add    $0x10,%esp
  802923:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802926:	75 07                	jne    80292f <ipc_send+0x3a>
		sys_yield();
  802928:	e8 a1 e6 ff ff       	call   800fce <sys_yield>
  80292d:	eb e6                	jmp    802915 <ipc_send+0x20>
	}

	if (ret < 0) {
  80292f:	85 c0                	test   %eax,%eax
  802931:	78 08                	js     80293b <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802933:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802936:	5b                   	pop    %ebx
  802937:	5e                   	pop    %esi
  802938:	5f                   	pop    %edi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  80293b:	50                   	push   %eax
  80293c:	68 69 34 80 00       	push   $0x803469
  802941:	6a 48                	push   $0x48
  802943:	68 86 34 80 00       	push   $0x803486
  802948:	e8 d3 db ff ff       	call   800520 <_panic>

0080294d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80294d:	f3 0f 1e fb          	endbr32 
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80295c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80295f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802965:	8b 52 50             	mov    0x50(%edx),%edx
  802968:	39 ca                	cmp    %ecx,%edx
  80296a:	74 11                	je     80297d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80296c:	83 c0 01             	add    $0x1,%eax
  80296f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802974:	75 e6                	jne    80295c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	eb 0b                	jmp    802988 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80297d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802980:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802985:	8b 40 48             	mov    0x48(%eax),%eax
}
  802988:	5d                   	pop    %ebp
  802989:	c3                   	ret    

0080298a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80298a:	f3 0f 1e fb          	endbr32 
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802994:	89 c2                	mov    %eax,%edx
  802996:	c1 ea 16             	shr    $0x16,%edx
  802999:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8029a0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8029a5:	f6 c1 01             	test   $0x1,%cl
  8029a8:	74 1c                	je     8029c6 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8029aa:	c1 e8 0c             	shr    $0xc,%eax
  8029ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029b4:	a8 01                	test   $0x1,%al
  8029b6:	74 0e                	je     8029c6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029b8:	c1 e8 0c             	shr    $0xc,%eax
  8029bb:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8029c2:	ef 
  8029c3:	0f b7 d2             	movzwl %dx,%edx
}
  8029c6:	89 d0                	mov    %edx,%eax
  8029c8:	5d                   	pop    %ebp
  8029c9:	c3                   	ret    
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__udivdi3>:
  8029d0:	f3 0f 1e fb          	endbr32 
  8029d4:	55                   	push   %ebp
  8029d5:	57                   	push   %edi
  8029d6:	56                   	push   %esi
  8029d7:	53                   	push   %ebx
  8029d8:	83 ec 1c             	sub    $0x1c,%esp
  8029db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029eb:	85 d2                	test   %edx,%edx
  8029ed:	75 19                	jne    802a08 <__udivdi3+0x38>
  8029ef:	39 f3                	cmp    %esi,%ebx
  8029f1:	76 4d                	jbe    802a40 <__udivdi3+0x70>
  8029f3:	31 ff                	xor    %edi,%edi
  8029f5:	89 e8                	mov    %ebp,%eax
  8029f7:	89 f2                	mov    %esi,%edx
  8029f9:	f7 f3                	div    %ebx
  8029fb:	89 fa                	mov    %edi,%edx
  8029fd:	83 c4 1c             	add    $0x1c,%esp
  802a00:	5b                   	pop    %ebx
  802a01:	5e                   	pop    %esi
  802a02:	5f                   	pop    %edi
  802a03:	5d                   	pop    %ebp
  802a04:	c3                   	ret    
  802a05:	8d 76 00             	lea    0x0(%esi),%esi
  802a08:	39 f2                	cmp    %esi,%edx
  802a0a:	76 14                	jbe    802a20 <__udivdi3+0x50>
  802a0c:	31 ff                	xor    %edi,%edi
  802a0e:	31 c0                	xor    %eax,%eax
  802a10:	89 fa                	mov    %edi,%edx
  802a12:	83 c4 1c             	add    $0x1c,%esp
  802a15:	5b                   	pop    %ebx
  802a16:	5e                   	pop    %esi
  802a17:	5f                   	pop    %edi
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    
  802a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a20:	0f bd fa             	bsr    %edx,%edi
  802a23:	83 f7 1f             	xor    $0x1f,%edi
  802a26:	75 48                	jne    802a70 <__udivdi3+0xa0>
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	72 06                	jb     802a32 <__udivdi3+0x62>
  802a2c:	31 c0                	xor    %eax,%eax
  802a2e:	39 eb                	cmp    %ebp,%ebx
  802a30:	77 de                	ja     802a10 <__udivdi3+0x40>
  802a32:	b8 01 00 00 00       	mov    $0x1,%eax
  802a37:	eb d7                	jmp    802a10 <__udivdi3+0x40>
  802a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a40:	89 d9                	mov    %ebx,%ecx
  802a42:	85 db                	test   %ebx,%ebx
  802a44:	75 0b                	jne    802a51 <__udivdi3+0x81>
  802a46:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f3                	div    %ebx
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	31 d2                	xor    %edx,%edx
  802a53:	89 f0                	mov    %esi,%eax
  802a55:	f7 f1                	div    %ecx
  802a57:	89 c6                	mov    %eax,%esi
  802a59:	89 e8                	mov    %ebp,%eax
  802a5b:	89 f7                	mov    %esi,%edi
  802a5d:	f7 f1                	div    %ecx
  802a5f:	89 fa                	mov    %edi,%edx
  802a61:	83 c4 1c             	add    $0x1c,%esp
  802a64:	5b                   	pop    %ebx
  802a65:	5e                   	pop    %esi
  802a66:	5f                   	pop    %edi
  802a67:	5d                   	pop    %ebp
  802a68:	c3                   	ret    
  802a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	b8 20 00 00 00       	mov    $0x20,%eax
  802a77:	29 f8                	sub    %edi,%eax
  802a79:	d3 e2                	shl    %cl,%edx
  802a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	89 da                	mov    %ebx,%edx
  802a83:	d3 ea                	shr    %cl,%edx
  802a85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a89:	09 d1                	or     %edx,%ecx
  802a8b:	89 f2                	mov    %esi,%edx
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 f9                	mov    %edi,%ecx
  802a93:	d3 e3                	shl    %cl,%ebx
  802a95:	89 c1                	mov    %eax,%ecx
  802a97:	d3 ea                	shr    %cl,%edx
  802a99:	89 f9                	mov    %edi,%ecx
  802a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a9f:	89 eb                	mov    %ebp,%ebx
  802aa1:	d3 e6                	shl    %cl,%esi
  802aa3:	89 c1                	mov    %eax,%ecx
  802aa5:	d3 eb                	shr    %cl,%ebx
  802aa7:	09 de                	or     %ebx,%esi
  802aa9:	89 f0                	mov    %esi,%eax
  802aab:	f7 74 24 08          	divl   0x8(%esp)
  802aaf:	89 d6                	mov    %edx,%esi
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	f7 64 24 0c          	mull   0xc(%esp)
  802ab7:	39 d6                	cmp    %edx,%esi
  802ab9:	72 15                	jb     802ad0 <__udivdi3+0x100>
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e5                	shl    %cl,%ebp
  802abf:	39 c5                	cmp    %eax,%ebp
  802ac1:	73 04                	jae    802ac7 <__udivdi3+0xf7>
  802ac3:	39 d6                	cmp    %edx,%esi
  802ac5:	74 09                	je     802ad0 <__udivdi3+0x100>
  802ac7:	89 d8                	mov    %ebx,%eax
  802ac9:	31 ff                	xor    %edi,%edi
  802acb:	e9 40 ff ff ff       	jmp    802a10 <__udivdi3+0x40>
  802ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ad3:	31 ff                	xor    %edi,%edi
  802ad5:	e9 36 ff ff ff       	jmp    802a10 <__udivdi3+0x40>
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	f3 0f 1e fb          	endbr32 
  802ae4:	55                   	push   %ebp
  802ae5:	57                   	push   %edi
  802ae6:	56                   	push   %esi
  802ae7:	53                   	push   %ebx
  802ae8:	83 ec 1c             	sub    $0x1c,%esp
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802af3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802afb:	85 c0                	test   %eax,%eax
  802afd:	75 19                	jne    802b18 <__umoddi3+0x38>
  802aff:	39 df                	cmp    %ebx,%edi
  802b01:	76 5d                	jbe    802b60 <__umoddi3+0x80>
  802b03:	89 f0                	mov    %esi,%eax
  802b05:	89 da                	mov    %ebx,%edx
  802b07:	f7 f7                	div    %edi
  802b09:	89 d0                	mov    %edx,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	83 c4 1c             	add    $0x1c,%esp
  802b10:	5b                   	pop    %ebx
  802b11:	5e                   	pop    %esi
  802b12:	5f                   	pop    %edi
  802b13:	5d                   	pop    %ebp
  802b14:	c3                   	ret    
  802b15:	8d 76 00             	lea    0x0(%esi),%esi
  802b18:	89 f2                	mov    %esi,%edx
  802b1a:	39 d8                	cmp    %ebx,%eax
  802b1c:	76 12                	jbe    802b30 <__umoddi3+0x50>
  802b1e:	89 f0                	mov    %esi,%eax
  802b20:	89 da                	mov    %ebx,%edx
  802b22:	83 c4 1c             	add    $0x1c,%esp
  802b25:	5b                   	pop    %ebx
  802b26:	5e                   	pop    %esi
  802b27:	5f                   	pop    %edi
  802b28:	5d                   	pop    %ebp
  802b29:	c3                   	ret    
  802b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b30:	0f bd e8             	bsr    %eax,%ebp
  802b33:	83 f5 1f             	xor    $0x1f,%ebp
  802b36:	75 50                	jne    802b88 <__umoddi3+0xa8>
  802b38:	39 d8                	cmp    %ebx,%eax
  802b3a:	0f 82 e0 00 00 00    	jb     802c20 <__umoddi3+0x140>
  802b40:	89 d9                	mov    %ebx,%ecx
  802b42:	39 f7                	cmp    %esi,%edi
  802b44:	0f 86 d6 00 00 00    	jbe    802c20 <__umoddi3+0x140>
  802b4a:	89 d0                	mov    %edx,%eax
  802b4c:	89 ca                	mov    %ecx,%edx
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 fd                	mov    %edi,%ebp
  802b62:	85 ff                	test   %edi,%edi
  802b64:	75 0b                	jne    802b71 <__umoddi3+0x91>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f7                	div    %edi
  802b6f:	89 c5                	mov    %eax,%ebp
  802b71:	89 d8                	mov    %ebx,%eax
  802b73:	31 d2                	xor    %edx,%edx
  802b75:	f7 f5                	div    %ebp
  802b77:	89 f0                	mov    %esi,%eax
  802b79:	f7 f5                	div    %ebp
  802b7b:	89 d0                	mov    %edx,%eax
  802b7d:	31 d2                	xor    %edx,%edx
  802b7f:	eb 8c                	jmp    802b0d <__umoddi3+0x2d>
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 e9                	mov    %ebp,%ecx
  802b8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b8f:	29 ea                	sub    %ebp,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b97:	89 d1                	mov    %edx,%ecx
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	d3 e8                	shr    %cl,%eax
  802b9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ba5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ba9:	09 c1                	or     %eax,%ecx
  802bab:	89 d8                	mov    %ebx,%eax
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bbf:	d3 e3                	shl    %cl,%ebx
  802bc1:	89 c7                	mov    %eax,%edi
  802bc3:	89 d1                	mov    %edx,%ecx
  802bc5:	89 f0                	mov    %esi,%eax
  802bc7:	d3 e8                	shr    %cl,%eax
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	89 fa                	mov    %edi,%edx
  802bcd:	d3 e6                	shl    %cl,%esi
  802bcf:	09 d8                	or     %ebx,%eax
  802bd1:	f7 74 24 08          	divl   0x8(%esp)
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	89 f3                	mov    %esi,%ebx
  802bd9:	f7 64 24 0c          	mull   0xc(%esp)
  802bdd:	89 c6                	mov    %eax,%esi
  802bdf:	89 d7                	mov    %edx,%edi
  802be1:	39 d1                	cmp    %edx,%ecx
  802be3:	72 06                	jb     802beb <__umoddi3+0x10b>
  802be5:	75 10                	jne    802bf7 <__umoddi3+0x117>
  802be7:	39 c3                	cmp    %eax,%ebx
  802be9:	73 0c                	jae    802bf7 <__umoddi3+0x117>
  802beb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bf3:	89 d7                	mov    %edx,%edi
  802bf5:	89 c6                	mov    %eax,%esi
  802bf7:	89 ca                	mov    %ecx,%edx
  802bf9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bfe:	29 f3                	sub    %esi,%ebx
  802c00:	19 fa                	sbb    %edi,%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	d3 e0                	shl    %cl,%eax
  802c06:	89 e9                	mov    %ebp,%ecx
  802c08:	d3 eb                	shr    %cl,%ebx
  802c0a:	d3 ea                	shr    %cl,%edx
  802c0c:	09 d8                	or     %ebx,%eax
  802c0e:	83 c4 1c             	add    $0x1c,%esp
  802c11:	5b                   	pop    %ebx
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	29 fe                	sub    %edi,%esi
  802c22:	19 c3                	sbb    %eax,%ebx
  802c24:	89 f2                	mov    %esi,%edx
  802c26:	89 d9                	mov    %ebx,%ecx
  802c28:	e9 1d ff ff ff       	jmp    802b4a <__umoddi3+0x6a>
